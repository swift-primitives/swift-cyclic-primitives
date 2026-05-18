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

public import Cyclic_Namespace_Primitives

extension Cyclic.Group {
    /// The cyclic group ℤ/nℤ with compile-time modulus.
    ///
    /// A specialization of cyclic groups where the modulus is known at compile time.
    /// This enables zero-sized types and eliminates runtime modulus storage.
    ///
    /// ## Iteration
    ///
    /// The group itself is a `Sequence` over all its elements:
    ///
    /// ```swift
    /// for element in Cyclic.Group.Static<5>() {
    ///     print(element.position)  // 0, 1, 2, 3, 4
    /// }
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// var idx: Cyclic.Group.Static<5>.Element = .zero
    /// idx = idx + .one  // 1
    /// idx = idx + .one  // 2
    /// // ...
    /// idx = idx + .one  // 0 (wraps at 5)
    ///
    /// Cyclic.Group.Static<5>.modulus  // 5
    /// ```
    public struct Static<let modulus: Int>: Sendable {
        /// Creates a cyclic group instance.
        ///
        /// The group is a zero-sized type; instances exist only to enable
        /// iteration over all group elements.
        @inlinable
        public init() {}
    }
}
