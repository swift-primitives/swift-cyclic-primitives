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

public import Cyclic_Primitives

/// Test support: Adds `ExpressibleByIntegerLiteral` conformance to `Cyclic.Group.Element`.
///
/// This conformance is available only for test targets. Production code should use
/// the throwing initializer `init(_:)` to construct elements.
///
/// - Warning: Traps on invalid values. Use only in tests.
extension Cyclic.Group.Element: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        do {
            self = try Self(value)
        } catch {
            preconditionFailure("Literal \(value) invalid for Cyclic.Group<\(order)>.Element")
        }
    }
}
