# Audit History

### From: swift-institute/Research/audits/implementation-naming-2026-03-20/swift-cyclic-primitives.md (2026-03-20)

**Implementation + naming audit**

HIGH=2, MEDIUM=4, LOW=8, INFO=10
Finding IDs: CYC-001, CYC-002, CYC-003, CYC-004, CYC-005, CYC-006, CYC-007, CYC-008, IMPL-002, PATTERN-017

| ID | Severity | Requirement | File | Title |
|----|----------|-------------|------|-------|
| CYC-001 | LOW | [PATTERN-017] | Cyclic.Group.Modulus.swift:57 | `.rawValue` in Modulus init from Count (validated) |
| CYC-002 | LOW | [PATTERN-017] | Cyclic.Group.Modulus.swift:66 | `.rawValue` in Modulus __unchecked init from Count |
| CYC-003 | MEDIUM | [PATTERN-017] | Cyclic.Group+Arithmetic.swift:125 | `.rawValue.magnitude` in advanced(by:) |
| CYC-004 | LOW | [PATTERN-017] | Cyclic.Group.Static.swift:95 | `.rawValue` in error associated value construction |
| CYC-005 | INFO | [IMPL-002] | Cyclic.Group+Arithmetic.swift:70 | Cardinal(rhs.residue) explicit conversion in add |
| CYC-006 | INFO | [IMPL-002] | Cyclic.Group+Arithmetic.swift:86 | Cardinal(rhs.residue) explicit conversion in subtract |
| CYC-007 | INFO | [IMPL-002] | Cyclic.Group+Arithmetic.swift:102 | Cardinal(element.residue) explicit conversion in inverse |
| CYC-008 | INFO | [API-IMPL-005] | Cyclic.Group.Static.swift | Element + Error in same file as Static |
