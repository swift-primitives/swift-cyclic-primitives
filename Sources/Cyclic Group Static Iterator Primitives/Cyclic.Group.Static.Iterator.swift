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
internal import Ordinal_Primitives
public import Sequence_Primitives

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
    public struct Iterator: Sendable {
        @usableFromInline
        var current: Ordinal

        @usableFromInline
        let bound: Cardinal

        @usableFromInline
        var _buffer: InlineArray<1, Cyclic.Group.Static<modulus>.Element>

        @inlinable
        package init() {
            self.current = .zero
            // reason: modulus > 0 by Cyclic.Group.Static<modulus> documented contract; Cardinal(Int) only throws on negative input.
            // swift-format-ignore: NeverUseForceTry
            // swiftlint:disable:next force_try
            self.bound = try! Cardinal(modulus)
            self._buffer = InlineArray(repeating: Cyclic.Group.Static<modulus>.Element(__unchecked: .zero))
        }
    }
}

// MARK: - IteratorProtocol

extension Cyclic.Group.Static.Iterator: IteratorProtocol {
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

// MARK: - Sequence.Iterator.`Protocol`

extension Cyclic.Group.Static.Iterator: Sequence.Iterator.`Protocol` {
    /// Returns a borrowed span of up to `maximumCount` elements from the iterator.
    ///
    /// The returned span is borrowed from `self`'s internal storage; consume it
    /// before calling `next()` or `nextSpan(maximumCount:)` again. The next
    /// invocation invalidates the previously-returned span.
    ///
    /// The iterator advances by at most one element per call (the internal
    /// `InlineArray<1, Element>` buffer holds a single element). When
    /// iteration is exhausted or `maximumCount` is zero, an empty span is
    /// returned.
    @_lifetime(&self)
    @inlinable
    public mutating func nextSpan(maximumCount: Cardinal) -> Swift.Span<Cyclic.Group.Static<modulus>.Element> {
        guard maximumCount > .zero, current < bound else {
            return _buffer.span.extracting(first: 0)
        }
        _buffer[0] = Cyclic.Group.Static<modulus>.Element(__unchecked: current)
        current += Cardinal.one
        return _buffer.span
    }
}
