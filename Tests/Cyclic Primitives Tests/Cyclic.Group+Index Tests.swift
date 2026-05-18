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

private enum Slot {}

extension Cyclic.Group {
    @Suite
    struct `Index Test` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

// MARK: - Unit

extension Cyclic.Group.`Index Test`.Unit {

    // MARK: Cyclic.Group.Element from typed Index

    @Test
    func `Element from typed Index`() {
        let index: Index<Slot> = .init(_unchecked: Ordinal(3))
        let element = Cyclic.Group.Element(__unchecked: index)
        #expect(element.residue == Ordinal(3))
    }

    // MARK: Cyclic.Group.Modulus from typed Count

    @Test
    func `Modulus from typed Count succeeds for positive count`() throws(Cyclic.Group.Modulus.Error) {
        let count: Index<Slot>.Count = .init(Cardinal(5))
        let modulus = try Cyclic.Group.Modulus(count)
        #expect(modulus.value == Cardinal(5))
    }

    // MARK: Cyclic.Group.advanced — positive offset

    @Test
    func `advanced by positive offset within modulus`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(10))
        let start = Cyclic.Group.Element(__unchecked: Ordinal(2))
        let offset: Index<Slot>.Offset = .init(3)
        let advanced = Cyclic.Group.advanced(start, by: offset, modulus: modulus)
        #expect(advanced.residue == Ordinal(5))
    }

    @Test
    func `advanced by positive offset wraps at modulus`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let start = Cyclic.Group.Element(__unchecked: Ordinal(4))
        let offset: Index<Slot>.Offset = .init(3)
        let advanced = Cyclic.Group.advanced(start, by: offset, modulus: modulus)
        #expect(advanced.residue == Ordinal(2))  // (4 + 3) mod 5 = 2
    }

    // MARK: Cyclic.Group.advanced — negative offset

    @Test
    func `advanced by negative offset within modulus`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(10))
        let start = Cyclic.Group.Element(__unchecked: Ordinal(7))
        let offset: Index<Slot>.Offset = .init(-3)
        let advanced = Cyclic.Group.advanced(start, by: offset, modulus: modulus)
        #expect(advanced.residue == Ordinal(4))
    }

    @Test
    func `advanced by negative offset wraps below zero`() throws(Cyclic.Group.Modulus.Error) {
        let modulus = try Cyclic.Group.Modulus(Cardinal(5))
        let start = Cyclic.Group.Element(__unchecked: Ordinal(1))
        let offset: Index<Slot>.Offset = .init(-3)
        let advanced = Cyclic.Group.advanced(start, by: offset, modulus: modulus)
        #expect(advanced.residue == Ordinal(3))  // (1 - 3 + 5) mod 5 = 3
    }
}

// MARK: - Edge Case

extension Cyclic.Group.`Index Test`.`Edge Case` {

    @Test
    func `Modulus from typed Count throws for zero count`() {
        #expect(throws: Cyclic.Group.Modulus.Error.zeroModulus) {
            let count: Index<Slot>.Count = .init(Cardinal.zero)
            _ = try Cyclic.Group.Modulus(count)
        }
    }
}
