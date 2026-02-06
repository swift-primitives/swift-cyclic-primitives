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

extension Cyclic.Group.Static {
    /// An element of the cyclic group ℤ/nℤ.
    ///
    /// Unlike affine `Position` (a point in unbounded space), `Cyclic.Group.Static<n>.Element`
    /// is an element of a finite cyclic group where addition wraps modulo n.
    ///
    /// ## Algebraic Structure
    ///
    /// Elements of `Cyclic.Group.Static<n>` form a cyclic group under addition:
    /// - **Closure**: `(a + b) mod n` is always in `[0, n)`
    /// - **Associativity**: `(a + b) + c = a + (b + c)`
    /// - **Identity**: `.zero` satisfies `a + .zero = a`
    /// - **Inverse**: For every `a`, there exists `-a` such that `a + (-a) = .zero`
    ///
    /// ## Invariant
    ///
    /// `position` is always in the range `[0, modulus)`. Requires `modulus > 0`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Ring buffer index arithmetic
    /// var tail: Cyclic.Group.Static<10>.Element = try! .init(Ordinal(9))
    /// tail = tail + .one  // Wraps to 0
    ///
    /// // Backward navigation
    /// var idx: Cyclic.Group.Static<5>.Element = .zero
    /// idx = idx - .one  // Wraps to 4
    /// ```
    public struct Element: Hashable, Comparable, Sendable {
        /// The position within the cyclic group [0, modulus).
        public let position: Ordinal

        /// The group modulus as a Cardinal for arithmetic operations.
        @inlinable
        public static var modulusCardinal: Cardinal { Cardinal(UInt(modulus)) }

        /// Creates a cyclic group element from an ordinal position.
        ///
        /// - Parameter position: The ordinal position.
        /// - Throws: `Error.invalidModulus` if `modulus <= 0`.
        /// - Throws: `Error.outOfBounds` if `position >= modulus`.
        @inlinable
        public init(_ position: Ordinal) throws(Error) {
            guard modulus > 0 else { throw .invalidModulus }
            guard position < Self.modulusCardinal else {
                throw .outOfBounds(Int(position.rawValue))
            }
            self.position = position
        }

        /// Creates a cyclic group element without bounds checking.
        ///
        /// - Parameter position: Must be in `0..<modulus` where `modulus > 0`.
        /// - Warning: No validation is performed. Use only when the value
        ///   is known to be in bounds and modulus is valid.
        @inlinable
        public init(__unchecked position: Ordinal) {
            self.position = position
        }

        /// Creates a cyclic group element from an ordinal position using modular reduction.
        ///
        /// Unlike `init(_:)`, this never fails — positions >= modulus are reduced modulo modulus.
        ///
        /// - Parameter position: The ordinal position.
        /// - Precondition: modulus > 0
        @inlinable
        public init(wrapping position: Ordinal) {
            precondition(modulus > 0, "Cyclic group modulus must be positive")
            self.position = position % Self.modulusCardinal
        }

        // MARK: - Equatable

        @inlinable
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.position == rhs.position
        }

        // MARK: - Comparable

        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.position < rhs.position
        }

        @inlinable
        public static func <= (lhs: Self, rhs: Self) -> Bool {
            lhs.position <= rhs.position
        }

        @inlinable
        public static func > (lhs: Self, rhs: Self) -> Bool {
            lhs.position > rhs.position
        }

        @inlinable
        public static func >= (lhs: Self, rhs: Self) -> Bool {
            lhs.position >= rhs.position
        }

        // MARK: - Hashable

        @inlinable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(position)
        }
    }
}

// MARK: - Element.Error

extension Cyclic.Group.Static.Element {
    /// Error thrown when cyclic group element construction fails.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The group modulus must be greater than zero.
        case invalidModulus
        /// The provided value was outside the valid range `0..<modulus`.
        case outOfBounds(Int)
    }
}

// MARK: - CustomStringConvertible

extension Cyclic.Group.Static.Element: CustomStringConvertible {
    public var description: String {
        "Cyclic.Group.Static<\(modulus)>.Element(\(position))"
    }
}
