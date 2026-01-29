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

// MARK: - Cyclic.Group.Element → Ordinal

extension Ordinal {
    /// Creates an ordinal position from a cyclic group element.
    ///
    /// This is a total operation — simply returns the element's position.
    ///
    /// - Parameter element: A cyclic group element.
    @inlinable
    public init<let N: Int>(_ element: Cyclic.Group<N>.Element) {
        self = element.position
    }
}
