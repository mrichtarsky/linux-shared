#!/usr/bin/env bash
set -euo pipefail

RUSTUP_HOME=/p/tools/rust
CARGO_HOME=/p/tools/rust/.cargo

curl https://sh.rustup.rs -sSf | sh -s -- -y

source /p/tools/rust/.cargo/env

RUSTUP_HOME=/p/tools/rust
CARGO_HOME=/p/tools/rust/.cargo

rustup default stable
