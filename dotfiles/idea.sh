#!/usr/bin/env bash

TOOLS="$HOME/tools"
TARGET="$TOOLS/idea"
TARGET_GZ="$TOOLS/idea.tar.gz"
URL="https://download-cdn.jetbrains.com/idea/ideaIC-2025.1.1.1.tar.gz"

if [ ! -d "$TARGET" ]
then
	mkdir -p "$TOOLS"

	if [ ! -f "$TARGET_GZ" ]
	then
		wget "$URL" -O "$TARGET_GZ"
	fi

	mkdir -p "$TARGET"
	tar xf "$TARGET_GZ" -C "$TARGET" # --strip-components=1
	for inner in "$TARGET/*"; do
		mv $inner/* $TARGET
	done
fi
