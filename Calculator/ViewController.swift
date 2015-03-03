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
    
    @IBOutlet weak var history: UILabel!
    var brain = CalculatorBrain()
    
    @IBAction func appendDecimal(sender: UIButton) {
        let range = display.text!.rangeOfString(".")
        if range == nil {
            appendDigit(sender)
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                
            }
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
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
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

