#!/bin/bash
OUT="${2:-/home/zhenac/my/lens_2026/.copilot_out.txt}"
> "$OUT"
eval "$1" >> "$OUT" 2>&1
echo "EXIT:$?" >> "$OUT"
