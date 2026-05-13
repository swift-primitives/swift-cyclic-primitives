// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Cyclic_Primitives_Test_Support
import Testing

@testable import Cyclic_Primitives

@Suite("Cyclic.Group.Static.Element Tests")
struct CyclicGroupStaticElementTests {

    // MARK: - Construction

    @Test
    func `Valid construction via throwing init`() throws {
        // Use throwing init explicitly with Ordinal
        let g0 = try Cyclic.Group.Static<5>.Element(Ordinal(0))
        #expect(g0.position == 0)

        let g4 = try Cyclic.Group.Static<5>.Element(Ordinal(4))
        #expect(g4.position == 4)
    }

    @Test
    func `Out of bounds construction throws`() {
        #expect(throws: Cyclic.Group.Static<5>.Element.Error.outOfBounds(5)) {
            _ = try Cyclic.Group.Static<5>.Element(Ordinal(5))
        }
        #expect(throws: Cyclic.Group.Static<5>.Element.Error.outOfBounds(100)) {
            _ = try Cyclic.Group.Static<5>.Element(Ordinal(100))
        }
    }

    @Test
    func `Invalid modulus throws`() {
        #expect(throws: Cyclic.Group.Static<0>.Element.Error.invalidModulus) {
            _ = try Cyclic.Group.Static<0>.Element(Ordinal(0))
        }
    }

    // MARK: - Identity and Generator

    @Test
    func `Zero is identity`() {
        let zero = Cyclic.Group.Static<5>.Element.zero
        #expect(zero.position == 0)
    }

    @Test
    func `One is generator`() {
        let one = Cyclic.Group.Static<5>.Element.one
        #expect(one.position == 1)
    }

    @Test
    func `One equals zero for modulus 1`() {
        let one = Cyclic.Group.Static<1>.Element.one
        let zero = Cyclic.Group.Static<1>.Element.zero
        #expect(one == zero)
        #expect(one.position == 0)
    }

    // MARK: - Group Operation (Addition)

    @Test
    func `Addition without wrap`() {
        let a: Cyclic.Group.Static<10>.Element = 3
        let b: Cyclic.Group.Static<10>.Element = 4
        let sum = a + b
        #expect(sum.position == 7)
    }

    @Test
    func `Addition with wrap`() {
        let a: Cyclic.Group.Static<5>.Element = 4
        let b: Cyclic.Group.Static<5>.Element = 3
        let sum = a + b
        #expect(sum.position == 2)  // (4 + 3) mod 5 = 2
    }

    @Test
    func `Identity property: a + zero = a`() {
        let a: Cyclic.Group.Static<7>.Element = 4
        let result = a + .zero
        #expect(result == a)
    }

    // MARK: - Inverse Operation (Subtraction)

    @Test
    func `Subtraction without wrap`() {
        let a: Cyclic.Group.Static<10>.Element = 7
        let b: Cyclic.Group.Static<10>.Element = 3
        let diff = a - b
        #expect(diff.position == 4)
    }

    @Test
    func `Subtraction with wrap`() {
        let a: Cyclic.Group.Static<5>.Element = 1
        let b: Cyclic.Group.Static<5>.Element = 3
        let diff = a - b
        #expect(diff.position == 3)  // (1 - 3 + 5) mod 5 = 3
    }

    @Test
    func `Subtraction wrap from zero`() {
        let a: Cyclic.Group.Static<5>.Element = 0
        let b: Cyclic.Group.Static<5>.Element = 1
        let diff = a - b
        #expect(diff.position == 4)  // 0 - 1 wraps to 4
    }

    // MARK: - Additive Inverse

    @Test
    func `Inverse property: a + inverse = zero`() {
        let a: Cyclic.Group.Static<7>.Element = 4
        let inv = a.inverse
        let result = a + inv
        #expect(result == .zero)
    }

    @Test
    func `Inverse of zero is zero`() {
        let zero = Cyclic.Group.Static<5>.Element.zero
        #expect(zero.inverse == .zero)
    }

    // MARK: - Compound Operations

    @Test
    func `Compound addition`() {
        var g: Cyclic.Group.Static<5>.Element = 3
        g += .one
        #expect(g.position == 4)
        g += .one
        #expect(g.position == 0)  // wraps
    }

    @Test
    func `Compound subtraction`() {
        var g: Cyclic.Group.Static<5>.Element = 1
        g -= .one
        #expect(g.position == 0)
        g -= .one
        #expect(g.position == 4)  // wraps
    }

    // MARK: - Ring Buffer Use Case

    @Test
    func `Ring buffer index advancement`() {
        var tail = Cyclic.Group.Static<4>.Element.zero

        tail += .one  // 1
        #expect(tail.position == 1)

        tail += .one  // 2
        #expect(tail.position == 2)

        tail += .one  // 3
        #expect(tail.position == 3)

        tail += .one  // 0 (wraps)
        #expect(tail.position == 0)
    }

    // MARK: - Comparable

    @Test
    func `Ordering`() {
        let a: Cyclic.Group.Static<5>.Element = 2
        let b: Cyclic.Group.Static<5>.Element = 4
        #expect(a < b)
        #expect(!(b < a))
        #expect(!(a < a))
    }

    // MARK: - Modulus

    @Test
    func `Modulus property`() {
        #expect(Cyclic.Group.Static<7>.modulus == 7)
        #expect(Cyclic.Group.Static<1>.modulus == 1)
        #expect(Cyclic.Group.Static<100>.modulus == 100)
    }
}
