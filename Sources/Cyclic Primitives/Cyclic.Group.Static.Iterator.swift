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

import Sequence_Primitives

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
    public struct Iterator: Sequence.Iterator.`Protocol`, IteratorProtocol, Sendable {
        @usableFromInline
        var current: Ordinal

        @usableFromInline
        let bound: Cardinal

        @usableFromInline
        var _buffer: InlineArray<1, Element>

        @inlinable
        init() {
            self.current = .zero
            self.bound = try! Cardinal(modulus)
            self._buffer = InlineArray(repeating: Element(__unchecked: .zero))
        }

        /// Returns the next element in the group, or `nil` when iteration is exhausted.
        ///
        /// Elements are produced in order from `0` to `modulus - 1`.
        @inlinable
        public mutating func next() -> Element? {
            guard current < bound else { return nil }
            let element = Element(__unchecked: current)
            current = current + Cardinal.one
            return element
        }

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
        public mutating func nextSpan(maximumCount: Cardinal) -> Swift.Span<Element> {
            guard maximumCount > .zero, current < bound else {
                return _buffer.span.extracting(first: 0)
            }
            _buffer[0] = Element(__unchecked: current)
            current = current + Cardinal.one
            return _buffer.span
        }
    }
}
