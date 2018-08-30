#!/usr/bin/env python3
import sys
import os
import requests
import json
from lxml import etree
from lxml.builder import E


url_pattern = 'https://www.meteofrance.com/previsions-meteo-france/{city}/{zip_code}'
xpath_expression = '//*[@data-connector="weather"]'


pretty_print = True
path_default = os.path.dirname(os.path.abspath(__file__)) + '/../index.html'
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
    zip_code = e.get('data-zip_code')
    url = url.replace('{zip_code}', zip_code)
    
    print(url)
    r = requests.get(url, headers={})
    response = r.text

    rtree = etree.HTML(response)
    parts = rtree.xpath('//ul[contains(@class,"prevision-horaire")][1]/li', namespaces=ns)
    ul = E.ul()
    
    for child in e:
        e.remove(child)
    
    for part in parts:
        times = part.xpath('.//time[@datetime]')
        temperatures = part.xpath('.//li[contains(@class,"day-summary-temperature")]')
        #uvs = part.xpath('.//li[contains(@class,"day-summary-uv")]')[0]
        
        datetime = ''
        temperature = ''
        uv = ''

        if (len(times)):
            time = times[0]
            datetime = time.get('datetime')
        
        if (len(temperatures)):
            temperature = temperatures[0].text

        #if (len(uvs)):
        #    uv = uvs[0].text

        li = E.li(
            E.time(datetime, {'datetime': datetime}),
            E.span(temperature, {'class': 'temperature'})#,
            #E.span(uv, {'class': 'uv'})
        )
        ul.append(li)

    e.append(ul)
    


xml_bytes = etree.tostring(tree, xml_declaration=False, method='xml', encoding='UTF-8', pretty_print=pretty_print)
xml_text = xml_bytes.decode('utf-8')

with open(path, 'w') as xml_file:
    print(xml_text, file=xml_file)
