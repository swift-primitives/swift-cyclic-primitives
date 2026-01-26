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

extension Cyclic.Group {
    /// An iterator over all elements of a cyclic group.
    ///
    /// Produces elements in order from 0 to `order - 1`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// for element in Cyclic.Group<5>() {
    ///     print(element.rawValue)  // 0, 1, 2, 3, 4
    /// }
    /// ```
    public struct Iterator: IteratorProtocol, Sendable {
        @usableFromInline
        internal var current: Int

        @inlinable
        internal init() {
            self.current = 0
        }

        @inlinable
        public mutating func next() -> Element? {
            guard current < order else { return nil }
            defer { current += 1 }
            return Element(__unchecked: (), current)
        }
    }
}
