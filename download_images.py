import urllib.request
import re
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

urls = {
    'satya': 'https://www.linkedin.com/in/satya-nagunoori-pr',
    'nagasai': 'https://www.linkedin.com/in/nagasaidonthi',
    'bhanusai': 'https://www.linkedin.com/in/bhanu-gomasani-b53448246'
}

for name, url in urls.items():
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'})
        html = urllib.request.urlopen(req, context=ctx).read().decode('utf-8')
        match = re.search(r'property="og:image" content="(.*?)"', html)
        if match:
            img_url = match.group(1).replace('&amp;', '&')
            print(f"Found {name}: {img_url}")
            urllib.request.urlretrieve(img_url, f'Assets/{name}.jpg')
            print(f"Saved {name}.jpg")
        else:
            print(f"No image found for {name}")
    except Exception as e:
        print(f"Error for {name}: {e}")
