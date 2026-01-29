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

public import Identity_Primitives

// MARK: - Tagged<Tag, Cyclic.Group<N>.Element> Properties and Constants

extension Tagged where Tag: ~Copyable {
    /// The zero element (identity).
    @inlinable
    public static func zero<let N: Int>() -> Self
    where RawValue == Cyclic.Group<N>.Element {
        Self(__unchecked: (), .zero)
    }

    /// The generator element (1 mod N).
    @inlinable
    public static func one<let N: Int>() -> Self
    where RawValue == Cyclic.Group<N>.Element {
        Self(__unchecked: (), .one)
    }
}

// MARK: - Tagged<Tag, Cyclic.Group<N>.Element> Construction

extension Tagged where Tag: ~Copyable {
    /// Creates a tagged cyclic group element from an element.
    @inlinable
    public init<let N: Int>(_ element: Cyclic.Group<N>.Element)
    where RawValue == Cyclic.Group<N>.Element {
        self.init(__unchecked: (), element)
    }

    /// Creates a tagged cyclic group element from an ordinal position.
    @inlinable
    public init<let N: Int>(_ position: Ordinal) throws(Cyclic.Group<N>.Element.Error)
    where RawValue == Cyclic.Group<N>.Element {
        self.init(__unchecked: (), try Cyclic.Group<N>.Element(position))
    }

    /// Creates a tagged cyclic group element with wrapping.
    @inlinable
    public init<let N: Int>(wrapping position: Ordinal)
    where RawValue == Cyclic.Group<N>.Element {
        self.init(__unchecked: (), Cyclic.Group<N>.Element(wrapping: position))
    }
}

// MARK: - Tagged<Tag, Cyclic.Group<N>.Element> Arithmetic

extension Tagged where Tag: ~Copyable {
    /// Group addition (modular).
    @inlinable
    public static func + <let N: Int>(lhs: Self, rhs: Self) -> Self
    where RawValue == Cyclic.Group<N>.Element {
        Self(__unchecked: (), lhs.rawValue + rhs.rawValue)
    }

    /// Group subtraction (modular).
    @inlinable
    public static func - <let N: Int>(lhs: Self, rhs: Self) -> Self
    where RawValue == Cyclic.Group<N>.Element {
        Self(__unchecked: (), lhs.rawValue - rhs.rawValue)
    }

    /// Compound addition.
    @inlinable
    public static func += <let N: Int>(lhs: inout Self, rhs: Self)
    where RawValue == Cyclic.Group<N>.Element {
        lhs = lhs + rhs
    }

    /// Compound subtraction.
    @inlinable
    public static func -= <let N: Int>(lhs: inout Self, rhs: Self)
    where RawValue == Cyclic.Group<N>.Element {
        lhs = lhs - rhs
    }
}

// MARK: - Tagged<Tag, Cyclic.Group<N>.Element> Inverse

extension Tagged where Tag: ~Copyable {
    /// The additive inverse of this element.
    @inlinable
    public func inverse<let N: Int>() -> Self where RawValue == Cyclic.Group<N>.Element {
        Self(__unchecked: (), rawValue.inverse)
    }
}
