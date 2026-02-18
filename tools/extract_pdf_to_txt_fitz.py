"""Extract PDF text to txt using PyMuPDF (fitz).

Why:
- PyPDF2 sometimes drops text in tables/columns.
- This extractor is a second pass that often captures the missing function prototypes.

Usage:
  C:/Users/cho77175/Desktop/code/.venv/Scripts/python.exe tools/extract_pdf_to_txt_fitz.py DoPE.pdf temp/DoPE_pdf_EXTRACTED_FITZ.txt
  C:/Users/cho77175/Desktop/code/.venv/Scripts/python.exe tools/extract_pdf_to_txt_fitz.py DoPE.pdf temp/out.txt --start 1 --end 30

Pages are 1-based in CLI.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import fitz  # PyMuPDF


def extract(pdf_path: Path, out_path: Path, start: int, end: int) -> None:
    doc = fitz.open(pdf_path)

    total_pages = doc.page_count
    start0 = max(0, start - 1)
    end0 = min(total_pages - 1, end - 1)
    if start0 > end0:
        raise SystemExit(f"Invalid page range: start={start}, end={end}, total={total_pages}")

    out_path.parent.mkdir(parents=True, exist_ok=True)
    with out_path.open("w", encoding="utf-8", newline="\n") as f:
        for idx in range(start0, end0 + 1):
            page = doc.load_page(idx)
            text = page.get_text("text")
            f.write(text)
            f.write("\n\n")
            if (idx - start0 + 1) % 10 == 0:
                print(f"extracted {idx + 1}/{end0 + 1}")

    print(f"done: wrote {out_path} ({out_path.stat().st_size} bytes)")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("pdf", type=Path)
    ap.add_argument("out", type=Path)
    ap.add_argument("--start", type=int, default=1, help="1-based start page")
    ap.add_argument("--end", type=int, default=10_000, help="1-based end page")
    args = ap.parse_args()

    extract(args.pdf, args.out, args.start, args.end)


if __name__ == "__main__":
    main()
