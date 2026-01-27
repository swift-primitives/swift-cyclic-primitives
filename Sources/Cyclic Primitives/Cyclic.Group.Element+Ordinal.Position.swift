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

// MARK: - Cyclic.Group.Element → Ordinal.Position

extension Ordinal.Position {
    /// Creates an ordinal position from a cyclic group element.
    ///
    /// This is a total operation — cyclic elements are always non-negative
    /// and fit within `Ordinal.Position`'s range.
    ///
    /// - Parameter element: A cyclic group element.
    @inlinable
    public init<let N: Int>(_ element: Cyclic.Group<N>.Element) {
        self.init(UInt(element.rawValue))
    }
}

// MARK: - Ordinal.Position → Cyclic.Group.Element

extension Cyclic.Group.Element {
    /// Creates a cyclic group element from an ordinal position.
    ///
    /// - Parameter position: The ordinal position.
    /// - Throws: `Error.outOfBounds` if position >= order.
    /// - Throws: `Error.invalidOrder` if order <= 0.
    @inlinable
    public init(_ position: Ordinal.Position) throws(Error) {
        guard order > 0 else { throw .invalidOrder }
        let value = Int(position.rawValue)
        guard value < order else { throw .outOfBounds(value) }
        self.init(__unchecked: (), value)
    }

    /// Creates a cyclic group element from an ordinal position using modular reduction.
    ///
    /// Unlike `init(_:)`, this never fails — positions >= order are reduced modulo order.
    ///
    /// - Parameter position: The ordinal position.
    /// - Precondition: order > 0
    @inlinable
    public init(wrapping position: Ordinal.Position) {
        precondition(order > 0, "Cyclic group order must be positive")
        self.init(__unchecked: (), Int(position.rawValue) % order)
    }
}
