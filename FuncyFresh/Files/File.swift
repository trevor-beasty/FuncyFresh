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

func >>> <A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> (A) -> C {
    
    return { a in
        g(f(a))
    }
}

precedencegroup BackwardsComposition {
    associativity: left
}

infix operator <<<

func <<< <A, B, C>(_ f: @escaping (B) -> C, _ g: @escaping (A) -> B) -> (A) -> C {
    
    return g >>> f
}

precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
    
    return f >>> g
}

func curry<A, B, C>(f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
     return { a in
        return { b in
            f(a, b)
        }
    }
}

func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { b in
        return { a in
            f(a)(b)
        }
    }
}

func zurry<A>(_ f: () -> A) -> A {
    return f()
}

func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
    return { $0.map(f) }
}

func filter<A>(f: @escaping (A) -> Bool) -> ([A]) -> [A] {
    return { $0.filter(f) }
}

func first<A, B, C>(_ f: @escaping (A) -> C) -> ((A, B)) -> (C, B) {
    return { pair in
        return (f(pair.0), pair.1)
    }
}

func second<A, B, C>(_ f: @escaping (B) -> C) -> ((A, B)) -> (A, C) {
    return { pair in
        return (pair.0, f(pair.1))
    }
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
    
    let nested = ((1, true), "Swift")
    
    nested
        |> (first <<< second) { !$0 }
}
