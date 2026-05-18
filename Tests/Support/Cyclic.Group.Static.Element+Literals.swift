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

/// Test support: Adds `ExpressibleByIntegerLiteral` conformance to `Cyclic.Group.Static.Element`.
///
/// This conformance is available only for test targets. Production code should use
/// the throwing initializer `init(_:)` to construct elements.
///
/// - Warning: Traps on invalid values. Use only in tests.
extension Cyclic.Group.Static.Element: ExpressibleByIntegerLiteral {
    // reason: ExpressibleByIntegerLiteral protocol-required witness — Swift dictates the `value: Int` parameter shape via the protocol's default IntegerLiteralType; conformer cannot change it. See [RULE-EXEMPT-2] protocol-witness-citation-dict family.
    // swift-linter:disable:next int public parameter
    public init(integerLiteral value: Int) {
        do throws(Self.Error) {
            self = try Self(Ordinal(UInt(value)))
        } catch {
            preconditionFailure("Literal \(value) invalid for Cyclic.Group.Static<\(modulus)>.Element")
        }
    }
}
