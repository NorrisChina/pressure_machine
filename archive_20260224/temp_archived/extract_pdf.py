#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
提取 PDF 文本内容
"""
import sys
import PyPDF2

def extract_pdf_text(pdf_path):
    try:
        with open(pdf_path, 'rb') as file:
            reader = PyPDF2.PdfReader(file)
            print(f"PDF Pages: {len(reader.pages)}\n")
            print("=" * 60)
            
            for page_num in range(min(10, len(reader.pages))):
                print(f"\n--- Page {page_num + 1} ---\n")
                page = reader.pages[page_num]
                text = page.extract_text()
                print(text)
                print("\n" + "=" * 60)
                
    except Exception as e:
        print(f"Extraction failed: {e}")

if __name__ == "__main__":
    pdf_path = r"C:\Users\cho77175\Desktop\code\Seriell-DLL-DOPE.pdf"
    extract_pdf_text(pdf_path)
