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

extension Cyclic.Group.Static.Element {
    /// Error thrown when cyclic group element construction fails.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The group modulus must be greater than zero.
        case invalidModulus
        /// The provided value was outside the valid range `0..<modulus`.
        case outOfBounds(Int)
    }
}
