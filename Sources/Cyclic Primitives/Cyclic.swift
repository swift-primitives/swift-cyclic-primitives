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

/// Namespace for cyclic types.
public enum Cyclic {}

extension Cyclic {
    /// The cyclic group ℤ/nℤ of given order.
    ///
    /// Cyclic groups are finite groups where every element can be generated
    /// by repeatedly applying the group operation to a single generator.
    ///
    /// ## Mathematical Background
    ///
    /// A cyclic group of order n has:
    /// - Exactly n elements: {0, 1, 2, ..., n-1}
    /// - Identity element: 0
    /// - Generator: 1 (applying + repeatedly generates all elements)
    /// - Group operation: addition modulo n
    /// - Inverse operation: subtraction modulo n
    ///
    /// ## Use Cases
    ///
    /// - Ring buffer indices (wrap at capacity)
    /// - Circular navigation (wrap at end)
    /// - Modular arithmetic
    ///
    /// ## Iteration
    ///
    /// The group itself is a `Sequence` over all its elements:
    ///
    /// ```swift
    /// for element in Cyclic.Group<5>() {
    ///     print(element.rawValue)  // 0, 1, 2, 3, 4
    /// }
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// var idx: Cyclic.Group<5>.Element = 3
    /// idx = idx + .one  // 4
    /// idx = idx + .one  // 0 (wraps)
    ///
    /// Cyclic.Group<5>.order  // 5
    /// ```
    public struct Group<let order: Int>: Sendable {
        /// Creates a cyclic group instance.
        ///
        /// The group is a zero-sized type; instances exist only to enable
        /// iteration over all group elements.
        @inlinable
        public init() {}
    }
}
