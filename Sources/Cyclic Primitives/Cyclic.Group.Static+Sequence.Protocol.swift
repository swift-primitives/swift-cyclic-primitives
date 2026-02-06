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

// MARK: - Sequence.Protocol Conformance

extension Cyclic.Group.Static: Sequence.`Protocol` {
    /// Creates an iterator over all elements of this cyclic group.
    ///
    /// Elements are produced in order from 0 to `modulus - 1`.
    @inlinable
    public func makeIterator() -> Iterator {
        Iterator()
    }
}

// MARK: - Swift.Sequence Conformance

/// Enables `for-in` loops and stdlib algorithm compatibility.
///
/// Since `Cyclic.Group.Static` and its `Element` are both `Copyable`, dual conformance
/// to both `Sequence.Protocol` and `Swift.Sequence` is supported with no
/// additional implementation required.
extension Cyclic.Group.Static: Swift.Sequence {
    /// The number of elements in this group (exact count known at compile time).
    @inlinable
    public var underestimatedCount: Int { Self.modulus }
}

// MARK: - Group Properties

extension Cyclic.Group.Static {
    /// The number of elements in this cyclic group.
    ///
    /// This is a compile-time constant derived from the generic parameter.
    @inlinable
    public static var count: Cardinal { Cardinal(UInt(modulus)) }
}
