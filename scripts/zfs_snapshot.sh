#!/usr/bin/env bash
set -euf -o pipefail
PREFIX=$1
zfs snapshot $PREFIX-$(date +%Y-%m-%d-%H%M%S)
