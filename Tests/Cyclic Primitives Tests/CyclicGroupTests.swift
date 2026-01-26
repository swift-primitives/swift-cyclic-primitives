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

import Testing
@testable import Cyclic_Primitives
import Cyclic_Primitives_Test_Support

@Suite("Cyclic.Group.Element Tests")
struct CyclicGroupElementTests {

    // MARK: - Construction

    @Test("Valid construction via throwing init")
    func validConstruction() throws {
        // Use throwing init explicitly (not integer literal)
        let value0: Int = 0
        let g0 = try Cyclic.Group<5>.Element(value0)
        #expect(g0.rawValue == 0)

        let value4: Int = 4
        let g4 = try Cyclic.Group<5>.Element(value4)
        #expect(g4.rawValue == 4)
    }

    @Test("Out of bounds construction throws")
    func outOfBoundsThrows() {
        // Use variables to force throwing init
        let oob5: Int = 5
        let oobNeg: Int = -1
        #expect(throws: Cyclic.Group<5>.Element.Error.outOfBounds(5)) {
            _ = try Cyclic.Group<5>.Element(oob5)
        }
        #expect(throws: Cyclic.Group<5>.Element.Error.outOfBounds(-1)) {
            _ = try Cyclic.Group<5>.Element(oobNeg)
        }
    }

    @Test("Invalid order throws")
    func invalidOrderThrows() {
        let value: Int = 0
        #expect(throws: Cyclic.Group<0>.Element.Error.invalidOrder) {
            _ = try Cyclic.Group<0>.Element(value)
        }
    }

    // MARK: - Identity and Generator

    @Test("Zero is identity")
    func zeroIdentity() {
        let zero = Cyclic.Group<5>.Element.zero
        #expect(zero.rawValue == 0)
    }

    @Test("One is generator")
    func oneGenerator() {
        let one = Cyclic.Group<5>.Element.one
        #expect(one.rawValue == 1)
    }

    @Test("One equals zero for order 1")
    func oneEqualsZeroForOrderOne() {
        let one = Cyclic.Group<1>.Element.one
        let zero = Cyclic.Group<1>.Element.zero
        #expect(one == zero)
        #expect(one.rawValue == 0)
    }

    // MARK: - Group Operation (Addition)

    @Test("Addition without wrap")
    func additionNoWrap() {
        let a: Cyclic.Group<10>.Element = 3
        let b: Cyclic.Group<10>.Element = 4
        let sum = a + b
        #expect(sum.rawValue == 7)
    }

    @Test("Addition with wrap")
    func additionWithWrap() {
        let a: Cyclic.Group<5>.Element = 4
        let b: Cyclic.Group<5>.Element = 3
        let sum = a + b
        #expect(sum.rawValue == 2)  // (4 + 3) mod 5 = 2
    }

    @Test("Identity property: a + zero = a")
    func identityProperty() {
        let a: Cyclic.Group<7>.Element = 4
        let result = a + .zero
        #expect(result == a)
    }

    // MARK: - Inverse Operation (Subtraction)

    @Test("Subtraction without wrap")
    func subtractionNoWrap() {
        let a: Cyclic.Group<10>.Element = 7
        let b: Cyclic.Group<10>.Element = 3
        let diff = a - b
        #expect(diff.rawValue == 4)
    }

    @Test("Subtraction with wrap")
    func subtractionWithWrap() {
        let a: Cyclic.Group<5>.Element = 1
        let b: Cyclic.Group<5>.Element = 3
        let diff = a - b
        #expect(diff.rawValue == 3)  // (1 - 3 + 5) mod 5 = 3
    }

    @Test("Subtraction wrap from zero")
    func subtractionFromZero() {
        let a: Cyclic.Group<5>.Element = 0
        let b: Cyclic.Group<5>.Element = 1
        let diff = a - b
        #expect(diff.rawValue == 4)  // 0 - 1 wraps to 4
    }

    // MARK: - Additive Inverse

    @Test("Inverse property: a + inverse = zero")
    func inverseProperty() {
        let a: Cyclic.Group<7>.Element = 4
        let inv = a.inverse
        let result = a + inv
        #expect(result == .zero)
    }

    @Test("Inverse of zero is zero")
    func inverseOfZero() {
        let zero = Cyclic.Group<5>.Element.zero
        #expect(zero.inverse == .zero)
    }

    // MARK: - Compound Operations

    @Test("Compound addition")
    func compoundAddition() {
        var g: Cyclic.Group<5>.Element = 3
        g += .one
        #expect(g.rawValue == 4)
        g += .one
        #expect(g.rawValue == 0)  // wraps
    }

    @Test("Compound subtraction")
    func compoundSubtraction() {
        var g: Cyclic.Group<5>.Element = 1
        g -= .one
        #expect(g.rawValue == 0)
        g -= .one
        #expect(g.rawValue == 4)  // wraps
    }

    // MARK: - Ring Buffer Use Case

    @Test("Ring buffer index advancement")
    func ringBufferAdvancement() {
        var tail = Cyclic.Group<4>.Element.zero

        tail = tail + .one  // 1
        #expect(tail.rawValue == 1)

        tail = tail + .one  // 2
        #expect(tail.rawValue == 2)

        tail = tail + .one  // 3
        #expect(tail.rawValue == 3)

        tail = tail + .one  // 0 (wraps)
        #expect(tail.rawValue == 0)
    }

    // MARK: - Comparable

    @Test("Ordering")
    func ordering() {
        let a: Cyclic.Group<5>.Element = 2
        let b: Cyclic.Group<5>.Element = 4
        #expect(a < b)
        #expect(!(b < a))
        #expect(!(a < a))
    }

    // MARK: - Order

    @Test("Order property")
    func orderProperty() {
        #expect(Cyclic.Group<7>.order == 7)
        #expect(Cyclic.Group<1>.order == 1)
        #expect(Cyclic.Group<100>.order == 100)
    }
}
