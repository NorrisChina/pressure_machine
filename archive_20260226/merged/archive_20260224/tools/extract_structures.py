from pathlib import Path
from PyPDF2 import PdfReader

ROOT = Path(__file__).resolve().parents[1]
PDF_PATH = ROOT / "Seriell-DLL-DOPE.pdf"
OUT_DIR = ROOT / "output"
OUT_DIR.mkdir(exist_ok=True)

KEYWORDS = [
    "DoPEData",
    "DoPESetup",
    "DoPE",
    "structure",
    "struct",
    "record",
    "Packed",
    "typedef",
    "DoPEOpenLink",
    "DoPESetNotification",
    "DoPESelSetup",
]


def extract_text(pdf_path: Path):
    if not pdf_path.exists():
        print(f"PDF not found: {pdf_path}")
        return ""
    reader = PdfReader(str(pdf_path))
    pages = []
    for i, p in enumerate(reader.pages, start=1):
        try:
            pages.append((i, p.extract_text() or ""))
        except Exception:
            pages.append((i, ""))
    return pages


def find_matches(pages):
    matches = []
    for page_num, text in pages:
        lower = text.lower()
        for kw in KEYWORDS:
            if kw.lower() in lower:
                # capture a snippet around each occurrence
                idx = lower.find(kw.lower())
                start = max(0, idx - 300)
                end = min(len(text), idx + 300)
                snippet = text[start:end]
                matches.append((page_num, kw, snippet))
    return matches


def main():
    pages = extract_text(PDF_PATH)
    out_all = OUT_DIR / "Seriell_DLL_DOPE_text.txt"
    with open(out_all, "w", encoding="utf-8") as f:
        for page_num, text in pages:
            f.write(f"\n\n--- Page {page_num} ---\n\n")
            f.write(text)

    matches = find_matches(pages)
    out_matches = OUT_DIR / "structures_extract.txt"
    with open(out_matches, "w", encoding="utf-8") as f:
        for page_num, kw, snippet in matches:
            f.write(f"--- Page {page_num} | Keyword: {kw} ---\n")
            f.write(snippet)
            f.write("\n\n")

    print("Extraction complete. Wrote:", out_all, out_matches)


if __name__ == '__main__':
    main()
