import xml.etree.ElementTree as ET
import os

xml_path = '/Users/nagasai/LifeProgreX/scratch/charter_extract/word/document.xml'
if os.path.exists(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()
    
    # Define the namespace for WordprocessingML
    ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
    
    # Iterate through all paragraph elements
    for p in root.findall('.//w:p', ns):
        texts = [t.text for t in p.findall('.//w:t', ns) if t.text]
        if texts:
            print(''.join(texts))
else:
    print(f"File not found: {xml_path}")
