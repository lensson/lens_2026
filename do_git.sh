#!/bin/bash
cd /home/zhenac/my/lens_2026
{
  echo "=== git add ==="
  git add -A
  echo "=== git status ==="
  git status
  echo "=== git commit ==="
  git commit -m "migration AI phase 1 @Copilot"
  echo "=== git push ==="
  git push
  echo "=== git log ==="
  git log --oneline -3
} > /home/zhenac/my/lens_2026/git_out.txt 2>&1


