//
//  ViewController.swift
//  Calculator
//
//  Created by Robert Collins on 16/02/2015.
//  Copyright (c) 2015 Robert Collins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // This is initialized automatically to nil
    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingANumber = false
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        switch operation {
        case "×" :
            performOperation {$0 * $1}
            //            case "−" :
            //            case "×" :
            //            case "÷" :
            
        default :
            println("op was \(sender.description)")
            break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operandStack.removeLast() * operandStack.removeLast()
            enter()
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text =  digit
            userIsInTheMiddleOfTypingANumber = true
        }
        
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }
    
}

