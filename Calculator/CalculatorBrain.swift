//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Neil Liu on 2016/7/6.
//  Copyright © 2016年 NeiL Liu. All rights reserved.
//

import Foundation


class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    // 閉包 簡化方式
    // { (op1: Double, op2: Double) -> Double in return op1 * op2}
    // { (op1, op2) in return op1 * op2} 已知BinaryOperation((Double, Double) -> Double) 所以可以將變數型態刪除
    // { ($0, $1) in return $0 * $1} 閉包也有默認參數名 可使用 $0, $1
    // { return $0 * $1} 已使用默認參數名且已知傳入值為Double 所以不需要 ($0, $1) in
    // { $0 * $1} 也已知傳回值為Double 所以也不需要 return
    
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0}),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0 * $1}),
        "÷" : Operation.BinaryOperation({ $0 / $1}),
        "+" : Operation.BinaryOperation({ $0 + $1}),
        "−" : Operation.BinaryOperation({ $0 - $1}),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double) // ((Double) -> (Double))是一個function
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation (symbol: String) {
        
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let foo):
                accumulator = foo(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }

    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
}