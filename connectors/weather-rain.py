#!/usr/bin/env python3
# coding=utf-8

import sys
import os
import requests
import json
from lxml import etree
from lxml.builder import E


url_pattern = 'https://www.meteofrance.com/mf3-rpc-portlet/rest/pluie/{id}'
xpath_expression = '//*[@data-connector="weather-rain"]'


pretty_print = True
path_default = os.path.dirname(os.path.abspath(__file__)) + '/../index.html'
input_path = sys.argv[1] if 1<len(sys.argv) else path_default
output_path = sys.argv[2] if 2<len(sys.argv) else input_path

tree = etree.parse(input_path)

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
    ul = E.ul()
    minutes = 0
    
    print(url)
    r = requests.get(url, headers={})
    response = r.text

    data = json.loads(response)
    dataCadran = data.get('dataCadran')
    size = len(dataCadran)

    for child in e:
        e.remove(child)

    for index, dataCadran in enumerate(dataCadran):
        color = dataCadran.get('color')
        
        style = 'background-color:#{color}'.replace('{color}', color)
        
        li = E.li(
            ' ',
            { 'style': style }
        )
        ul.append(li)

        minutes = minutes + 5
        
        if (0 == minutes % 15) and (index + 1 != size):
            sep = E.li(
                str(minutes),
                { 'class': 'minutes' }
            )
            ul.append(sep)

    e.append(ul)


xml_bytes = etree.tostring(tree, xml_declaration=False, method='xml', pretty_print=pretty_print)
xml_text = xml_bytes.decode('utf-8')

with open(output_path, 'w') as xml_file:
    print(xml_text, file=xml_file)
