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
    /// Namespace for cyclic group types.
    ///
    /// Contains both dynamic and compile-time modulus cyclic groups:
    /// - `Cyclic.Group` operations — runtime modulus (dynamic)
    /// - `Cyclic.Group.Static<N>` — compile-time modulus (specialization)
    ///
    /// ## Mathematical Background
    ///
    /// A cyclic group ℤ/nℤ of order n has:
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
    public enum Group {}
}
