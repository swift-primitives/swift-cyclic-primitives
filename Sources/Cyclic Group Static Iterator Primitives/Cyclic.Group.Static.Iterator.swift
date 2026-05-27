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
public import Cyclic_Group_Static_Element_Primitives
public import Cyclic_Group_Static_Primitives
public import Cyclic_Namespace_Primitives
public import Iterable
internal import Ordinal_Primitives

extension Cyclic.Group.Static {
    /// An iterator over all elements of a cyclic group.
    ///
    /// Produces elements in order from 0 to `modulus - 1`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// for element in Cyclic.Group.Static<5>() {
    ///     print(element.position)  // 0, 1, 2, 3, 4
    /// }
    /// ```
    public struct Iterator: Iterator_Primitive.Iterator.`Protocol`, IteratorProtocol, Sendable {
        @usableFromInline
        var current: Ordinal

        @usableFromInline
        let bound: Cardinal

        @inlinable
        package init() {
            self.current = .zero
            // reason: modulus > 0 by Cyclic.Group.Static<modulus> documented contract; Cardinal(Int) only throws on negative input.
            // swift-format-ignore: NeverUseForceTry
            // swiftlint:disable:next force_try
            self.bound = try! Cardinal(modulus)
        }
    }
}

// MARK: - next() — satisfies Iterator.`Protocol` + Swift.IteratorProtocol

extension Cyclic.Group.Static.Iterator {
    /// Returns the next element in the group, or `nil` when iteration is exhausted.
    ///
    /// Elements are produced in order from `0` to `modulus - 1`.
    @inlinable
    public mutating func next() -> Cyclic.Group.Static<modulus>.Element? {
        guard current < bound else { return nil }
        let element = Cyclic.Group.Static<modulus>.Element(__unchecked: current)
        current += Cardinal.one
        return element
    }
}
