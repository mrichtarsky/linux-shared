#!/usr/bin/env bash
set -euxo pipefail

export RUSTUP_HOME=/p/tools/rust
export CARGO_HOME=/p/tools/rust/.cargo

curl https://sh.rustup.rs -sSf | sh -s -- -y
