//
//  File.swift
//  FuncyFresh
//
//  Created by Trevor Beasty on 5/23/19.
//  Copyright © 2019 Trevor Beasty. All rights reserved.
//

import Foundation

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B>(a: A, f: (A) -> B) -> B {
    
    return f(a)
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    
    return { a in
        g(f(a))
    }
}

precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
    
    return f >>> g
}

/////

func incr(_ x: Int) -> Int {
    return x + 1
}

func square(_ x: Int) -> Int {
    return x * x
}

func computeAndPrint(_ x: Int) -> (Int, [String]) {
    let computation = x * x + 1
    return (computation, ["Computed \(computation)"])
}

func greet(at date: Date) -> (String) -> String {
    return { name in
        let s = Int(date.timeIntervalSince1970) % 60
        return "Hello \(name)! It's \(s) seconds past the minute."
    }
}

let example: () -> Void = {
    
    let x = incr >>> computeAndPrint
    
}
