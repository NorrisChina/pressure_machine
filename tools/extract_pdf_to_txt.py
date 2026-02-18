from __future__ import annotations

import argparse
from pathlib import Path

import PyPDF2


def extract_pdf_to_txt(pdf_path: Path, out_path: Path, max_pages: int | None = None) -> None:
    reader = PyPDF2.PdfReader(str(pdf_path))
    total = len(reader.pages)
    n = total if max_pages is None else min(max_pages, total)

    out_path.parent.mkdir(parents=True, exist_ok=True)

    # Stream write to avoid holding everything in memory
    with out_path.open("w", encoding="utf-8", errors="replace") as f:
        f.write(f"PDF: {pdf_path.name}\n")
        f.write(f"TotalPages: {total}\n")
        f.write("=" * 80 + "\n")

        for i in range(n):
            try:
                text = reader.pages[i].extract_text() or ""
            except Exception as e:
                text = f"\n[[EXTRACT_ERROR page {i+1}: {e}]]\n"

            f.write(f"\n--- Page {i+1} ---\n")
            f.write(text)
            f.write("\n")

            if (i + 1) % 10 == 0:
                print(f"extracted {i+1}/{n} pages")

    print(f"done: wrote {out_path} ({out_path.stat().st_size} bytes)")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("pdf", type=str, help="Input PDF path")
    ap.add_argument("out", type=str, help="Output TXT path")
    ap.add_argument("--max-pages", type=int, default=None)
    args = ap.parse_args()

    extract_pdf_to_txt(Path(args.pdf), Path(args.out), args.max_pages)


if __name__ == "__main__":
    main()
