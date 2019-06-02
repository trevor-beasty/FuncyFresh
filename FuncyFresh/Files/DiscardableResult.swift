//
//  DiscardableResult.swift
//  FuncyFresh
//
//  Created by Trevor Beasty on 6/2/19.
//  Copyright © 2019 Trevor Beasty. All rights reserved.
//

import Foundation

// MARK: - Class A Operators

precedencegroup ForwardInvocation {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >&>: ForwardInvocation

precedencegroup ForwardConfiguration {
    associativity: left
    higherThan: ForwardInvocation
}

infix operator <&>: ForwardConfiguration

precedencegroup MethodInvocation { }

infix operator <&: MethodInvocation

@discardableResult
func >&> <A: AnyObject>(a: A, f: (A) -> () -> ()) -> A {
    
    f(a)()
    return a
}

func <&> <A: AnyObject>(f: @escaping (A) -> () -> (), g: @escaping (A) -> () -> ()) -> (A) -> () -> () {

    return { a in
        f(a)()
        g(a)()
        return { }
    }
}

func <& <A: AnyObject, B>(f: @escaping (A) -> (B) -> (), b: B) -> (A) -> () -> () {
    
    return { a in
        f(a)(b)
        return { }
    }
}

func <& <A: AnyObject, B, C>(f: @escaping (A) -> (B,C) -> (), args: (B, C)) -> (A) -> () -> () {
    
    return { a in
        f(a)(args.0, args.1)
        return { }
    }
}

// MARK: - Class B Operators

precedencegroup Application {
    associativity: left
}

infix operator !>: Application

func !> <A: AnyObject>(a: A, f: (A) -> Void) -> A {
    f(a)
    return a
}

// MARK: - Arbitrary Class

class Thing {
    var a: Int = 0
    var b: Int = 0
    
    init() {
        a = 1
        b = 2
    }
    
}

// discardable result style functions

extension Thing {
    
    @discardableResult
    func foo_0(x: Int) -> Self {
        a += (b + x)
        return self
    }
    
    @discardableResult
    func bar_0(x: Int, y: Int) -> Self {
        a -= (y * y)
        b += (a * x)
        return self
    }
    
    @discardableResult
    func baz_0() -> Self {
        a *= b
        return self
    }
    
}

// normal functions

extension Thing {
    
    func foo_1(x: Int) {
        a += (b + x)
    }
    
    func bar_1(x: Int, y: Int) {
        a -= (y * y)
        b += (a * x)
    }
    
    func baz_1() {
        a *= b
    }
    
}

// MARK: - Equivalent Clients

// discardable result style

func makeThing_0() -> Thing {
    return Thing()
        .foo_0(x: 3)
        .bar_0(x: 7, y: 2)
        .baz_0()
}

// class A operators

func makeThing_1() -> Thing {
    return Thing() >&>
        (Thing.foo_1 <& 3)
        <&> (Thing.bar_1 <& (7,2) )
        <&> Thing.baz_1
}

// class B operators

func makeThing_2() -> Thing {
    return Thing()
        !> { $0.foo_1(x: 3) }
        !> { $0.bar_1(x: 7, y: 2) }
        !> { $0.baz_1() }
}
