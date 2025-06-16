#!/usr/bin/env bash

sinks=$(wpctl status | sed -n '/Sinks:/,/Sources:/p' | string replace -a '├' '' | string replace -a '─' '' | string replace -a '│' '' | string replace -a '└' '' | string match -r '.*\[vol:.*' | string replace -r '\s*\[vol:.*$' '' | string replace -r '^\s*(\d+)\.' '$1\t' | string replace -r '.*?\\*.*?(\\d+).*?(\\w.*$)' '<b>$1 $2 *</b>' | string replace -r '\s+' ' ')
echo "$sinks"
