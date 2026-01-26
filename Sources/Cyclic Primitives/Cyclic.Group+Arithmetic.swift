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

// MARK: - Identity and Generator

extension Cyclic.Group.Element {
    /// The identity element (0) in ℤ/nℤ.
    ///
    /// For any element `a`: `a + .zero == a`
    @inlinable
    public static var zero: Self { Self(__unchecked: (), 0) }

    /// The generator (1 mod order) in ℤ/nℤ.
    ///
    /// For order > 1, this is 1. For order == 1, this equals `.zero`.
    ///
    /// Repeatedly adding `.one` generates all elements of the group:
    /// ```swift
    /// var x: Cyclic.Group<5>.Element = .zero
    /// x = x + .one  // 1
    /// x = x + .one  // 2
    /// x = x + .one  // 3
    /// x = x + .one  // 4
    /// x = x + .one  // 0 (wraps)
    /// ```
    @inlinable
    public static var one: Self { Self(__unchecked: (), 1 % order) }
}

// MARK: - Group Operations

extension Cyclic.Group.Element {
    /// Group operation in ℤ/nℤ.
    ///
    /// The result automatically wraps within `[0, order)`:
    /// ```swift
    /// let a: Cyclic.Group<5>.Element = try! .init(4)
    /// let b: Cyclic.Group<5>.Element = try! .init(3)
    /// let sum = a + b  // 2 (wraps: (4 + 3) mod 5 = 2)
    /// ```
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(__unchecked: (), (lhs.rawValue + rhs.rawValue) % order)
    }

    /// Inverse operation in ℤ/nℤ.
    ///
    /// The result automatically wraps within `[0, order)`:
    /// ```swift
    /// let a: Cyclic.Group<5>.Element = try! .init(1)
    /// let b: Cyclic.Group<5>.Element = try! .init(3)
    /// let diff = a - b  // 3 (wraps: (1 - 3 + 5) mod 5 = 3)
    /// ```
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(__unchecked: (), ((lhs.rawValue - rhs.rawValue) % order + order) % order)
    }

    /// Compound addition.
    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    /// Compound subtraction.
    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

// MARK: - Additive Inverse

extension Cyclic.Group.Element {
    /// The additive inverse of this element.
    ///
    /// For element `a`, the inverse `-a` satisfies: `a + (-a) == .zero`
    ///
    /// ```swift
    /// let a: Cyclic.Group<5>.Element = try! .init(3)
    /// let inv = a.inverse  // 2 (because 3 + 2 = 5 ≡ 0 mod 5)
    /// ```
    @inlinable
    public var inverse: Self {
        if rawValue == 0 {
            return self
        }
        return Self(__unchecked: (), order - rawValue)
    }
}
