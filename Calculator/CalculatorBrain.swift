//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Robert Collins on 01/03/2015.
//  Copyright (c) 2015 Robert Collins. All rights reserved.
//

import Foundation

// Doesn't even inherit the functionality of NSObject
class CalculatorBrain {
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double) // Don't forget the parenthesis around the input Double, Double
        
        var description : String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let operation,_):
                    return operation
                case .BinaryOperation(let operation,_):
                    return operation
                }
            }
        }
    }
    
    private var opStack = [Op]() // this is syntactically the same as Array<Op>()
    private var knownOps = [String:Op]() // this is syntactically the same as Dictionary<String,Op>()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("−",{$1 - $0}))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("÷", {$1 / $0}))
        learnOp(Op.UnaryOperation("√", sqrt)) // this is the same as Op.UnaryOperation("√") {sqrt($0)}
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            // Arrays and dictionaries are not classes. They are structs. Classes can have inheritence. Classes are passed by reference. Structs are passed by value. They're copied. Arguments have an implicit 'let'
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(let opName, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let opName, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func reset() {
        opStack.removeAll(keepCapacity: false)
    }
    
    var description: String {
        get {
            let (desc,_) = description(opStack)
            return desc!
        }
    }
    
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if ops.isEmpty {
            return (" ",ops)
        } else {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch (op) {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .UnaryOperation(let operation, _):
                let (operandEvaluation,_) = description(remainingOps)
                return ("\(operation)(\(operandEvaluation!))",remainingOps)
            case .BinaryOperation(let operation, _):
                let op1Evaluation = description(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = description(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return ("(\(operand2)\(operation)\(operand1))", op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return ("?", ops)
    }
}

// make private things private. The public keyword is only used for Frameworks