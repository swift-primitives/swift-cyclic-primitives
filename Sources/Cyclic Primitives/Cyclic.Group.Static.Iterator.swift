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

        @inlinable
        public mutating func next() -> Element? {
            guard current < bound else { return nil }
            let element = Element(__unchecked: current)
            current = current + Cardinal.one
            return element
        }

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
