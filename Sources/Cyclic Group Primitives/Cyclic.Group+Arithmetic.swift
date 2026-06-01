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
public import Cyclic_Namespace_Primitives
public import Index_Primitives
internal import Ordinal_Primitives

// MARK: - Dynamic Cyclic Group Operations

extension Cyclic.Group {
    /// Advances an element by one position, wrapping at modulus.
    ///
    /// - Parameters:
    ///   - element: The current element.
    ///   - modulus: The group modulus.
    /// - Returns: The successor element.
    /// - Complexity: O(1)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modulus = try Cyclic.Group.Modulus(Cardinal(5))
    /// let element = Cyclic.Group.Element(__unchecked: Ordinal(4))
    /// let next = Cyclic.Group.successor(element, modulus: modulus)  // 0 (wraps)
    /// ```
    @inlinable
    public static func successor(_ element: Element, modulus: Modulus) -> Element {
        let sum = element.residue + Cardinal.one
        let reduced = sum % modulus.value
        return Element(__unchecked: reduced)
    }

    /// Retreats an element by one position, wrapping at modulus.
    ///
    /// - Parameters:
    ///   - element: The current element.
    ///   - modulus: The group modulus.
    /// - Returns: The predecessor element.
    /// - Complexity: O(1)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modulus = try Cyclic.Group.Modulus(Cardinal(5))
    /// let element = Cyclic.Group.Element.zero
    /// let prev = Cyclic.Group.predecessor(element, modulus: modulus)  // 4 (wraps)
    /// ```
    @inlinable
    public static func predecessor(_ element: Element, modulus: Modulus) -> Element {
        // (element - 1 + modulus) % modulus
        let sum = element.residue + modulus.value.subtract.saturating(Cardinal.one)
        let reduced = sum % modulus.value
        return Element(__unchecked: reduced)
    }

    /// Adds two elements in the cyclic group.
    ///
    /// - Parameters:
    ///   - lhs: First element.
    ///   - rhs: Second element.
    ///   - modulus: The group modulus.
    /// - Returns: The sum modulo the modulus.
    /// - Complexity: O(1)
    @inlinable
    public static func add(_ lhs: Element, _ rhs: Element, modulus: Modulus) -> Element {
        let sum = lhs.residue + Cardinal(rhs.residue)
        let reduced = sum % modulus.value
        return Element(__unchecked: reduced)
    }

    /// Subtracts two elements in the cyclic group.
    ///
    /// - Parameters:
    ///   - lhs: Element to subtract from.
    ///   - rhs: Element to subtract.
    ///   - modulus: The group modulus.
    /// - Returns: The difference modulo the modulus.
    /// - Complexity: O(1)
    @inlinable
    public static func subtract(_ lhs: Element, _ rhs: Element, modulus: Modulus) -> Element {
        // (lhs - rhs + modulus) % modulus
        let inverse = modulus.value.subtract.saturating(Cardinal(rhs.residue))
        let sum = lhs.residue + inverse
        let reduced = sum % modulus.value
        return Element(__unchecked: reduced)
    }

    /// Computes the additive inverse of an element.
    ///
    /// - Parameters:
    ///   - element: The element.
    ///   - modulus: The group modulus.
    /// - Returns: The inverse element such that `element + inverse = zero`.
    /// - Complexity: O(1)
    @inlinable
    public static func inverse(_ element: Element, modulus: Modulus) -> Element {
        if element.residue == .zero { return element }
        let inv = modulus.value.subtract.saturating(Cardinal(element.residue))
        return Element(__unchecked: Ordinal(inv))
    }

    /// Advances an element by an offset, wrapping at modulus.
    ///
    /// - Parameters:
    ///   - element: The current element.
    ///   - offset: The offset to advance by (can be negative).
    ///   - modulus: The group modulus.
    /// - Returns: The resulting element.
    /// - Complexity: O(1)
    @inlinable
    public static func advanced<Tag: ~Copyable & ~Escapable>(
        _ element: Element,
        by offset: Index<Tag>.Offset,
        modulus: Modulus
    ) -> Element {
        guard offset.vector >= .zero else {
            let backward = Ordinal(offset.magnitude.cardinal) % modulus.value
            let inverse = modulus.value.subtract.saturating(Cardinal(backward))
            let sum = element.residue + inverse
            return Element(__unchecked: sum % modulus.value)
        }
        // reason: offset.vector >= .zero (just guarded), so Ordinal(vector) cannot throw.
        // swift-format-ignore: NeverUseForceTry
        // swiftlint:disable:next force_try
        let forward = try! Ordinal(offset.vector) % modulus.value
        let sum = element.residue + Cardinal(forward)
        return Element(__unchecked: sum % modulus.value)
    }
}
