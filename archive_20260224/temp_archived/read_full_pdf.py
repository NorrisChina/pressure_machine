import sys
sys.path.insert(0, '.venv32/Lib/site-packages')

import PyPDF2

def extract_pdf(pdf_path):
    """Extract all text from PDF with better error handling"""
    with open(pdf_path, 'rb') as file:
        reader = PyPDF2.PdfReader(file)
        total_pages = len(reader.pages)
        
        print(f"=== DoPE DLL Documentation Summary ===")
        print(f"Total Pages: {total_pages}\n")
        
        # Extract key sections
        for page_num in range(min(20, total_pages)):  # First 20 pages
            try:
                page = reader.pages[page_num]
                text = page.extract_text()
                
                # Only print pages with substantial content
                if text.strip() and len(text) > 100:
                    print(f"\n{'='*60}")
                    print(f"--- Page {page_num + 1} ---")
                    print('='*60)
                    
                    # Clean up text
                    lines = text.split('\n')
                    for line in lines:
                        # Skip empty lines and page headers
                        line = line.strip()
                        if line and not line.startswith('Page') and not line.startswith('Version'):
                            try:
                                print(line)
                            except UnicodeEncodeError:
                                # Replace problematic characters
                                print(line.encode('ascii', 'replace').decode('ascii'))
            except Exception as e:
                print(f"Error on page {page_num + 1}: {e}")
                continue

if __name__ == '__main__':
    extract_pdf('Seriell-DLL-DOPE.pdf')
