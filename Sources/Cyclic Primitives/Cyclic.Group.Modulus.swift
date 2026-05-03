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
    /// A positive modulus for dynamic cyclic group operations.
    ///
    /// Encapsulates the >0 invariant for runtime modulus values.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modulus = try Cyclic.Group.Modulus(Cardinal(5))
    /// let element = Cyclic.Group.Element(Ordinal(3), modulus: modulus)
    /// let next = Cyclic.Group.successor(element, modulus: modulus)
    /// ```
    public struct Modulus: Hashable, Sendable {
        /// The positive modulus value.
        public let value: Cardinal

        /// Creates a modulus from a cardinal value.
        ///
        /// - Parameter value: The modulus value (must be > 0).
        /// - Throws: `Error.zeroModulus` if value is zero.
        @inlinable
        public init(_ value: Cardinal) throws(Error) {
            guard value > .zero else { throw .zeroModulus }
            self.value = value
        }

        /// Creates a modulus without validation.
        ///
        /// - Parameter value: Must be > 0.
        /// - Warning: No validation is performed. Use only when the value
        ///   is known to be positive.
        @inlinable
        public init(__unchecked value: Cardinal) {
            self.value = value
        }

        /// Creates a modulus from a count.
        ///
        /// Convenience initializer for common buffer capacity use case.
        ///
        /// - Parameter count: The count value (must be > 0).
        /// - Throws: `Error.zeroModulus` if count is zero.
        @inlinable
        public init<Tag: ~Copyable>(_ count: Index<Tag>.Count) throws(Error) {
            guard count > .zero else { throw .zeroModulus }
            self.value = count.underlying
        }

        /// Creates a modulus from a count without validation.
        ///
        /// - Parameter count: Must be > 0.
        /// - Warning: No validation is performed.
        @inlinable
        public init<Tag: ~Copyable>(__unchecked count: Index<Tag>.Count) {
            self.value = count.underlying
        }
    }
}

// MARK: - Error

extension Cyclic.Group.Modulus {
    /// Error thrown when modulus construction fails.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The modulus must be greater than zero.
        case zeroModulus
    }
}

// MARK: - CustomStringConvertible

extension Cyclic.Group.Modulus: CustomStringConvertible {
    public var description: String {
        "Cyclic.Group.Modulus(\(value))"
    }
}
