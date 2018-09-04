#!/usr/bin/env python3
import sys
import os
import requests
from lxml import etree
from lxml.builder import E


url_pattern = 'https://www.google.com/search?q=traffic+{city}'
xpath_expression = '//*[@data-connector="traffic-google"]'


pretty_print = True
path_default = os.path.dirname(os.path.abspath(__file__)) + '/../www/index.html'
path = sys.argv[1] if 2==len(sys.argv) else path_default

tree = etree.parse(path)

#  a hack allowing to access the
#  default namespace (if defined) via the 'p:' prefix    
#  E.g. given a default namespaces such as 'xmlns="http://maven.apache.org/POM/4.0.0"'
#  an XPath of '//p:module' will return all the 'module' nodes
ns = tree.getroot().nsmap
if ns.keys() and None in ns:
    ns['p'] = ns.pop(None)
#   end of hack    

for e in tree.xpath(xpath_expression, namespaces=ns):
    city = e.get('data-city')
    url = url_pattern.replace('{city}', city)
    
    print(url)
    r = requests.get(url, headers={'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0'})
    response = r.text

    rtree = etree.HTML(response)
    imgs = rtree.xpath('//img[starts-with(@src,"/maps")][1]')
    
    if (len(imgs)):
        for child in e:
            e.remove(child)
    
        img = imgs[0]
        src = img.get('src')

        # python3.7: img = E.img(src=f'https://www.google.com/{src}')
        img_src = 'https://www.google.com/{src}'.replace('{src}', src)
        img = E.img(src=img_src)

        e.append(img)


xml_bytes = etree.tostring(tree, xml_declaration=False, method='xml', encoding='UTF-8', pretty_print=pretty_print)
xml_text = xml_bytes.decode('utf-8')

with open(path, 'w') as xml_file:
    print(xml_text, file=xml_file)
