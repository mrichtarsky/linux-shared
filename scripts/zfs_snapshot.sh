#!/usr/bin/env bash
set -euf -o pipefail
PREFIX=$1
PATH+=:/usr/sbin
zfs snapshot $PREFIX-$(date +%Y-%m-%d-%H%M%S)
