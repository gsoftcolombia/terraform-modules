# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] – 2026-02-28

### Changed
- Made `module.networking.key_pair` optional (breaking change)
  - Before upgrading, run: `terraform state mv aws_key_pair.this aws_key_pair.this[0]` to update tfstate

### Security
- (any security fixes).
