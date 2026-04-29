import re
import os

xml_path = '/Users/nagasai/LifeProgreX/scratch/charter_extract/word/document.xml'
if os.path.exists(xml_path):
    with open(xml_path, 'r') as f:
        xml_content = f.read()
        # Simple extraction of text between <w:t> tags
        texts = re.findall(r'<w:t[^>]*>(.*?)</w:t>', xml_content)
        print('\n'.join(texts))
else:
    print(f"File not found: {xml_path}")
