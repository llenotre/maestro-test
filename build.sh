#!/bin/sh

set -e

if [ -z "$TARGET" ]; then
	export TARGET=i686-unknown-linux-musl
fi

# Build
cargo build --release -Zbuild-std --target "$TARGET"

# Create disk and filesystem
dd if=/dev/zero of=disk bs=1M count=1024
mkfs.ext2 disk

# Fill filesystem
debugfs -wf - disk <<EOF
mkdir /dev
mkdir /sbin
write target/$TARGET/release/init /sbin/init
write target/$TARGET/release/maestro-test /sbin/maestro-test
EOF
