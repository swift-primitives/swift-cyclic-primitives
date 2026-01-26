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
    /// An element of the cyclic group ℤ/nℤ.
    ///
    /// Unlike affine `Position` (a point in unbounded space), `Cyclic.Group<n>.Element`
    /// is an element of a finite cyclic group where addition wraps modulo n.
    ///
    /// ## Algebraic Structure
    ///
    /// Elements of `Cyclic.Group<n>` form a cyclic group under addition:
    /// - **Closure**: `(a + b) mod n` is always in `[0, n)`
    /// - **Associativity**: `(a + b) + c = a + (b + c)`
    /// - **Identity**: `.zero` satisfies `a + .zero = a`
    /// - **Inverse**: For every `a`, there exists `-a` such that `a + (-a) = .zero`
    ///
    /// ## Invariant
    ///
    /// `rawValue` is always in the range `[0, order)`. Requires `order > 0`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Ring buffer index arithmetic
    /// var tail: Cyclic.Group<10>.Element = try! .init(9)
    /// tail = tail + .one  // Wraps to 0
    ///
    /// // Backward navigation
    /// var idx: Cyclic.Group<5>.Element = .zero
    /// idx = idx - .one  // Wraps to 4
    /// ```
    public struct Element: Hashable, Comparable, Sendable {
        /// The underlying value (0 to order-1).
        public let rawValue: Int

        /// Creates a cyclic group element from an integer.
        ///
        /// - Parameter rawValue: The value.
        /// - Throws: `Error.invalidOrder` if `order <= 0`.
        /// - Throws: `Error.outOfBounds` if `rawValue < 0` or `rawValue >= order`.
        @inlinable
        public init(_ rawValue: Int) throws(Error) {
            guard order > 0 else { throw .invalidOrder }
            guard rawValue >= 0, rawValue < order else { throw .outOfBounds(rawValue) }
            self.rawValue = rawValue
        }

        /// Creates a cyclic group element without bounds checking.
        ///
        /// - Parameter rawValue: Must be in `0..<order` where `order > 0`.
        /// - Warning: No validation is performed. Use only when the value
        ///   is known to be in bounds and order is valid.
        @inlinable
        public init(__unchecked: Void, _ rawValue: Int) {
            self.rawValue = rawValue
        }

        // MARK: - Equatable

        @inlinable
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue == rhs.rawValue
        }

        // MARK: - Comparable

        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue < rhs.rawValue
        }

        @inlinable
        public static func <= (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue <= rhs.rawValue
        }

        @inlinable
        public static func > (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue > rhs.rawValue
        }

        @inlinable
        public static func >= (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue >= rhs.rawValue
        }

        // MARK: - Hashable

        @inlinable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(rawValue)
        }
    }
}

// MARK: - Element.Error

extension Cyclic.Group.Element {
    /// Error thrown when cyclic group element construction fails.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The group order must be greater than zero.
        case invalidOrder
        /// The provided value was outside the valid range `0..<order`.
        case outOfBounds(Int)
    }
}

// MARK: - CustomStringConvertible

extension Cyclic.Group.Element: CustomStringConvertible {
    public var description: String {
        "Cyclic.Group<\(order)>.Element(\(rawValue))"
    }
}
