from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
IGNORE_DIRS = {".venv", ".venv32", "__pycache__", ".git"}


def iter_py_files() -> list[Path]:
    paths: list[Path] = []
    for p in ROOT.rglob("*.py"):
        if any(part in IGNORE_DIRS for part in p.parts):
            continue
        paths.append(p)
    return paths


def main() -> None:
    names: set[str] = set()
    for path in iter_py_files():
        try:
            text = path.read_text(encoding="utf-8", errors="ignore")
        except Exception:
            continue
        for m in re.finditer(r"\bDoPE[A-Za-z0-9_]+\b", text):
            names.add(m.group(0))

    names_sorted = sorted(names)
    print(f"Found {len(names_sorted)} DoPE* symbols")
    for n in names_sorted:
        print(n)


if __name__ == "__main__":
    main()
