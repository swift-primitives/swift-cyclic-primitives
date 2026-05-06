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

@Suite("Cyclic.Group (Dynamic) Tests")
struct CyclicGroupDynamicTests {

    // MARK: - Modulus Construction

    @Test
    func `Valid modulus construction`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        #expect(modulus.value == Cardinal(5))
    }

    @Test
    func `Zero modulus throws`() {
        #expect(throws: Cyclic.Group.Modulus.Error.zeroModulus) {
            _ = try Cyclic.Group.Modulus(.zero)
        }
    }

    // MARK: - Element Construction

    @Test
    func `Element construction with normalization`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))

        let e0 = Cyclic.Group.Element(Ordinal(0), modulus: modulus)
        #expect(e0.residue == Ordinal(0))

        let e3 = Cyclic.Group.Element(Ordinal(3), modulus: modulus)
        #expect(e3.residue == Ordinal(3))

        // Normalization: 7 mod 5 = 2
        let e7 = Cyclic.Group.Element(Ordinal(7), modulus: modulus)
        #expect(e7.residue == Ordinal(2))
    }

    // MARK: - Successor

    @Test
    func `Successor without wrap`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let element = Cyclic.Group.Element(__unchecked: Ordinal(2))
        let next = Cyclic.Group.successor(element, modulus: modulus)
        #expect(next.residue == Ordinal(3))
    }

    @Test
    func `Successor with wrap`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let element = Cyclic.Group.Element(__unchecked: Ordinal(4))
        let next = Cyclic.Group.successor(element, modulus: modulus)
        #expect(next.residue == Ordinal(0))
    }

    // MARK: - Predecessor

    @Test
    func `Predecessor without wrap`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let element = Cyclic.Group.Element(__unchecked: Ordinal(3))
        let prev = Cyclic.Group.predecessor(element, modulus: modulus)
        #expect(prev.residue == Ordinal(2))
    }

    @Test
    func `Predecessor with wrap`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let element = Cyclic.Group.Element.zero
        let prev = Cyclic.Group.predecessor(element, modulus: modulus)
        #expect(prev.residue == Ordinal(4))
    }

    // MARK: - Add

    @Test
    func `Add without wrap`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(10))
        let a = Cyclic.Group.Element(__unchecked: Ordinal(3))
        let b = Cyclic.Group.Element(__unchecked: Ordinal(4))
        let sum = Cyclic.Group.add(a, b, modulus: modulus)
        #expect(sum.residue == Ordinal(7))
    }

    @Test
    func `Add with wrap`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let a = Cyclic.Group.Element(__unchecked: Ordinal(4))
        let b = Cyclic.Group.Element(__unchecked: Ordinal(3))
        let sum = Cyclic.Group.add(a, b, modulus: modulus)
        #expect(sum.residue == Ordinal(2))  // (4 + 3) mod 5 = 2
    }

    // MARK: - Subtract

    @Test
    func `Subtract without wrap`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(10))
        let a = Cyclic.Group.Element(__unchecked: Ordinal(7))
        let b = Cyclic.Group.Element(__unchecked: Ordinal(3))
        let diff = Cyclic.Group.subtract(a, b, modulus: modulus)
        #expect(diff.residue == Ordinal(4))
    }

    @Test
    func `Subtract with wrap`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let a = Cyclic.Group.Element(__unchecked: Ordinal(1))
        let b = Cyclic.Group.Element(__unchecked: Ordinal(3))
        let diff = Cyclic.Group.subtract(a, b, modulus: modulus)
        #expect(diff.residue == Ordinal(3))  // (1 - 3 + 5) mod 5 = 3
    }

    // MARK: - Inverse

    @Test
    func `Inverse property: element + inverse = zero`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(7))
        let element = Cyclic.Group.Element(__unchecked: Ordinal(4))
        let inv = Cyclic.Group.inverse(element, modulus: modulus)
        let sum = Cyclic.Group.add(element, inv, modulus: modulus)
        #expect(sum.residue == Ordinal(0))
    }

    @Test
    func `Inverse of zero is zero`() throws {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let inv = Cyclic.Group.inverse(.zero, modulus: modulus)
        #expect(inv.residue == Ordinal(0))
    }

    // MARK: - Ring Buffer Simulation

    @Test
    func `Ring buffer index advancement`() throws {
        let capacity = try Cyclic.Group.Modulus(Cardinal(4))
        var tail = Cyclic.Group.Element.zero

        tail = Cyclic.Group.successor(tail, modulus: capacity)
        #expect(tail.residue == Ordinal(1))

        tail = Cyclic.Group.successor(tail, modulus: capacity)
        #expect(tail.residue == Ordinal(2))

        tail = Cyclic.Group.successor(tail, modulus: capacity)
        #expect(tail.residue == Ordinal(3))

        tail = Cyclic.Group.successor(tail, modulus: capacity)
        #expect(tail.residue == Ordinal(0))  // wraps
    }
}
