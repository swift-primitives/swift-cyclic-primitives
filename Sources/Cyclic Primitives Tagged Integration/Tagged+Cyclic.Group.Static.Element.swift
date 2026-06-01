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

public import Cyclic_Group_Static_Element_Primitives
internal import Ordinal_Primitives
public import Tagged_Primitives

// MARK: - Tagged<Tag, Cyclic.Group.Static<N>.Element> Construction

extension Tagged where Tag: ~Copyable & ~Escapable {
    /// Creates a tagged cyclic group element from an element.
    @inlinable
    public init<let N: Int>(_ element: Cyclic.Group.Static<N>.Element)
    where Underlying == Cyclic.Group.Static<N>.Element {
        self.init(_unchecked: element)
    }

    /// Creates a tagged cyclic group element from an ordinal position.
    @inlinable
    public init<let N: Int>(_ position: Ordinal) throws(Cyclic.Group.Static<N>.Element.Error)
    where Underlying == Cyclic.Group.Static<N>.Element {
        self.init(_unchecked: try Cyclic.Group.Static<N>.Element(position))
    }

    /// Creates a tagged cyclic group element with wrapping.
    @inlinable
    public init<let N: Int>(wrapping position: Ordinal)
    where Underlying == Cyclic.Group.Static<N>.Element {
        self.init(_unchecked: Cyclic.Group.Static<N>.Element(wrapping: position))
    }
}

// MARK: - Tagged<Tag, Cyclic.Group.Static<N>.Element> Arithmetic

extension Tagged where Tag: ~Copyable & ~Escapable {
    /// Group addition (modular).
    @inlinable
    public static func + <let N: Int>(lhs: Self, rhs: Self) -> Self
    where Underlying == Cyclic.Group.Static<N>.Element {
        Self(_unchecked: lhs.underlying + rhs.underlying)
    }

    /// Group subtraction (modular).
    @inlinable
    public static func - <let N: Int>(lhs: Self, rhs: Self) -> Self
    where Underlying == Cyclic.Group.Static<N>.Element {
        Self(_unchecked: lhs.underlying - rhs.underlying)
    }

    /// Compound addition.
    @inlinable
    public static func += <let N: Int>(lhs: inout Self, rhs: Self)
    where Underlying == Cyclic.Group.Static<N>.Element {
        lhs = lhs + rhs
    }

    /// Compound subtraction.
    @inlinable
    public static func -= <let N: Int>(lhs: inout Self, rhs: Self)
    where Underlying == Cyclic.Group.Static<N>.Element {
        lhs = lhs - rhs
    }
}

// MARK: - Tagged<Tag, Cyclic.Group.Static<N>.Element> Inverse

extension Tagged where Tag: ~Copyable & ~Escapable {
    /// The additive inverse of this element.
    @inlinable
    public func inverse<let N: Int>() -> Self where Underlying == Cyclic.Group.Static<N>.Element {
        Self(_unchecked: underlying.inverse)
    }
}
