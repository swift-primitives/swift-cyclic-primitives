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
    struct `Tagged Static Element Test` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

// MARK: - Unit

extension Cyclic.Group.`Tagged Static Element Test`.Unit {

    // MARK: Construction

    @Test
    func `init from Element`() {
        let element: Cyclic.Group.Static<5>.Element = 3
        let tagged: Tagged<Slot, Cyclic.Group.Static<5>.Element> = .init(element)
        #expect(tagged.underlying == element)
    }

    @Test
    func `init from Ordinal succeeds within bounds`() throws(Cyclic.Group.Static<5>.Element.Error) {
        let tagged: Tagged<Slot, Cyclic.Group.Static<5>.Element> = try .init(Ordinal(2))
        #expect(tagged.underlying.position == 2)
    }

    @Test
    func `init wrapping reduces position`() {
        let tagged: Tagged<Slot, Cyclic.Group.Static<5>.Element> = .init(wrapping: Ordinal(7))
        #expect(tagged.underlying.position == 2)  // 7 mod 5 = 2
    }

    // MARK: Arithmetic

    @Test
    func `addition wraps modulo N`() {
        let a: Tagged<Slot, Cyclic.Group.Static<5>.Element> = .init(Cyclic.Group.Static<5>.Element(__unchecked: Ordinal(4)))
        let b: Tagged<Slot, Cyclic.Group.Static<5>.Element> = .init(Cyclic.Group.Static<5>.Element(__unchecked: Ordinal(3)))
        let sum = a + b
        #expect(sum.underlying.position == 2)  // (4 + 3) mod 5 = 2
    }

    @Test
    func `subtraction wraps modulo N`() {
        let a: Tagged<Slot, Cyclic.Group.Static<5>.Element> = .init(Cyclic.Group.Static<5>.Element(__unchecked: Ordinal(1)))
        let b: Tagged<Slot, Cyclic.Group.Static<5>.Element> = .init(Cyclic.Group.Static<5>.Element(__unchecked: Ordinal(3)))
        let diff = a - b
        #expect(diff.underlying.position == 3)  // (1 - 3 + 5) mod 5 = 3
    }

    @Test
    func `compound addition wraps`() {
        var a: Tagged<Slot, Cyclic.Group.Static<5>.Element> = .init(Cyclic.Group.Static<5>.Element(__unchecked: Ordinal(3)))
        let b: Tagged<Slot, Cyclic.Group.Static<5>.Element> = .init(Cyclic.Group.Static<5>.Element(__unchecked: Ordinal(4)))
        a += b
        #expect(a.underlying.position == 2)  // (3 + 4) mod 5 = 2
    }

    @Test
    func `compound subtraction wraps`() {
        var a: Tagged<Slot, Cyclic.Group.Static<5>.Element> = .init(Cyclic.Group.Static<5>.Element(__unchecked: Ordinal(0)))
        let b: Tagged<Slot, Cyclic.Group.Static<5>.Element> = .init(Cyclic.Group.Static<5>.Element(__unchecked: Ordinal(1)))
        a -= b
        #expect(a.underlying.position == 4)  // 0 - 1 wraps to 4
    }

    // MARK: Inverse

    @Test
    func `inverse property a plus inverse equals zero`() {
        let a: Tagged<Slot, Cyclic.Group.Static<7>.Element> = .init(Cyclic.Group.Static<7>.Element(__unchecked: Ordinal(4)))
        let sum = a + a.inverse()
        #expect(sum.underlying.position == 0)
    }
}

// MARK: - Edge Case

extension Cyclic.Group.`Tagged Static Element Test`.`Edge Case` {

    @Test
    func `init from Ordinal throws out of bounds`() {
        #expect(throws: Cyclic.Group.Static<5>.Element.Error.outOfBounds(5)) {
            _ = try Tagged<Slot, Cyclic.Group.Static<5>.Element>(Ordinal(5))
        }
    }
}
