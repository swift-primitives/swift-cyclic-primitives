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
    /// An element of a dynamic cyclic group.
    ///
    /// Unlike `Cyclic.Group.Static<N>.Element` where the modulus is compile-time,
    /// this element stores only the residue. The modulus is supplied externally
    /// at operation time.
    ///
    /// ## Design Rationale
    ///
    /// For containers like ring buffers, the modulus (capacity) is owned by the
    /// container, not by each index. Storing the modulus per element would be
    /// wasteful. Instead, operations accept the modulus as a parameter.
    ///
    /// ## Invariant
    ///
    /// The residue should be in `[0, modulus)` for any operations to be valid.
    /// This invariant is maintained by construction and operations, but cannot
    /// be enforced without knowing the modulus.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modulus = try Cyclic.Group.Modulus(Cardinal(5))
    /// var element = Cyclic.Group.Element(Ordinal(3), modulus: modulus)
    /// element = Cyclic.Group.successor(element, modulus: modulus)  // 4
    /// element = Cyclic.Group.successor(element, modulus: modulus)  // 0 (wraps)
    /// ```
    public struct Element: Hashable, Comparable, Sendable {
        /// The residue value.
        ///
        /// Should be in `[0, modulus)` for valid operations.
        public let residue: Ordinal

        /// Creates an element from a residue with modular reduction.
        ///
        /// - Parameters:
        ///   - residue: The residue value.
        ///   - modulus: The group modulus for normalization.
        @inlinable
        public init(_ residue: Ordinal, modulus: Modulus) {
            self.residue = residue % modulus.value
        }

        /// Creates an element without validation.
        ///
        /// - Parameter residue: Must be in `[0, modulus)` for any modulus
        ///   that will be used in operations.
        /// - Warning: No validation is performed.
        @inlinable
        public init(__unchecked residue: Ordinal) {
            self.residue = residue
        }

        /// Creates an element from a typed index without validation.
        ///
        /// - Parameter index: Must be in `[0, modulus)` for any modulus
        ///   that will be used in operations.
        /// - Warning: No validation is performed.
        @inlinable
        public init<Tag: ~Copyable>(__unchecked index: Index<Tag>) {
            self.residue = index.ordinal
        }

        /// Creates the zero element (identity).
        @inlinable
        public static var zero: Self { Self(__unchecked: .zero) }

        /// Creates the generator element (1).
        ///
        /// Valid for any modulus > 1. For modulus == 1, use `.zero`.
        @inlinable
        public static var one: Self { Self(__unchecked: Ordinal(1)) }

        // MARK: - Equatable

        @inlinable
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.residue == rhs.residue
        }

        // MARK: - Comparable

        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.residue < rhs.residue
        }

        // MARK: - Hashable

        @inlinable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(residue)
        }
    }
}

// MARK: - CustomStringConvertible

extension Cyclic.Group.Element: CustomStringConvertible {
    public var description: String {
        "Cyclic.Group.Element(\(residue))"
    }
}
