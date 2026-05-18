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

public import Cardinal_Primitives
public import Cyclic_Group_Static_Primitives
public import Cyclic_Namespace_Primitives
public import Ordinal_Primitives

// MARK: - Identity and Generator

extension Cyclic.Group.Static.Element {
    /// The identity element (0) in ℤ/nℤ.
    ///
    /// For any element `a`: `a + .zero == a`
    @inlinable
    public static var zero: Self { Self(__unchecked: .zero) }

    /// The generator (1 mod modulus) in ℤ/nℤ.
    ///
    /// For modulus > 1, this is 1. For modulus == 1, this equals `.zero`.
    ///
    /// Repeatedly adding `.one` generates all elements of the group:
    /// ```swift
    /// var x: Cyclic.Group.Static<5>.Element = .zero
    /// x = x + .one  // 1
    /// x = x + .one  // 2
    /// x = x + .one  // 3
    /// x = x + .one  // 4
    /// x = x + .one  // 0 (wraps)
    /// ```
    @inlinable
    public static var one: Self {
        Self(__unchecked: modulus > 1 ? Ordinal(1) : .zero)
    }
}

// MARK: - Group Operations

extension Cyclic.Group.Static.Element {
    /// Group operation in ℤ/nℤ.
    ///
    /// The result automatically wraps within `[0, modulus)`:
    /// ```swift
    /// let a: Cyclic.Group.Static<5>.Element = try! .init(Ordinal(4))
    /// let b: Cyclic.Group.Static<5>.Element = try! .init(Ordinal(3))
    /// let sum = a + b  // 2 (wraps: (4 + 3) mod 5 = 2)
    /// ```
    ///
    /// Composition: `Ordinal + Cardinal` then `% Cardinal`
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        let sum = lhs.position + Cardinal(rhs.position)
        let reduced = sum % Self.order
        return Self(__unchecked: reduced)
    }

    /// Inverse operation in ℤ/nℤ.
    ///
    /// The result automatically wraps within `[0, modulus)`:
    /// ```swift
    /// let a: Cyclic.Group.Static<5>.Element = try! .init(Ordinal(1))
    /// let b: Cyclic.Group.Static<5>.Element = try! .init(Ordinal(3))
    /// let diff = a - b  // 3 (wraps: (1 - 3 + 5) mod 5 = 3)
    /// ```
    ///
    /// Composition: `a - b (mod N)` = `(a + (N - b)) mod N`
    /// Uses: `Cardinal - Cardinal` via `.subtract.exact` (safe because b < N invariant)
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        // N - b is always valid since rhs.position < order (invariant)
        let inverse = Self.order.subtract.saturating(Cardinal(rhs.position))
        let sum = lhs.position + inverse
        let reduced = sum % Self.order
        return Self(__unchecked: reduced)
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

extension Cyclic.Group.Static.Element {
    /// The additive inverse of this element.
    ///
    /// For element `a`, the inverse `-a` satisfies: `a + (-a) == .zero`
    ///
    /// ```swift
    /// let a: Cyclic.Group.Static<5>.Element = try! .init(Ordinal(3))
    /// let inv = a.inverse  // 2 (because 3 + 2 = 5 ≡ 0 mod 5)
    /// ```
    ///
    /// Composition: `N - a` via Cardinal subtraction, converted back to Ordinal
    @inlinable
    public var inverse: Self {
        if position == .zero { return self }
        // position < order (invariant), so subtraction is safe
        let inv = Self.order.subtract.saturating(Cardinal(position))
        return Self(__unchecked: Ordinal(inv))
    }
}
