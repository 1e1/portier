#!/usr/bin/env python3
import sys
import os
import requests
import json
from lxml import etree


pretty_print = True
path = os.path.dirname(os.path.abspath(__file__)) + '/../index.html'
url_pattern = 'https://www.meteofrance.com/mf3-rpc-portlet/rest/pluie/{id}'
xpath_expression = '//*[@data-connector="weather-rain"]'


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
    id = e.get('data-param')
    url = url_pattern.replace('{id}', id)
    
    print(url)
    r = requests.get(url, headers={})
    response = r.text

    data = json.loads(response)

    for index, dataCadran in enumerate(data['dataCadran']):
        color = dataCadran['color']
        #print(index +1, dataCadran)
        rain = e.xpath(f"//rain[position()={index +1}]", namespaces=ns)
        rain[0].set("style", f"background-color:#{color}")

    
xml_bytes = etree.tostring(tree, xml_declaration=False, method='xml', encoding='UTF-8', pretty_print=pretty_print)
xml_text = xml_bytes.decode('utf-8')

with open(path, 'w') as xml_file:
    print(xml_text, file=xml_file)
