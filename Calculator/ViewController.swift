//
//  ViewController.swift
//  Calculator
//
//  Created by Robert Collins on 16/02/2015.
//  Copyright (c) 2015 Robert Collins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("digit = \(digit)")
    }
}

