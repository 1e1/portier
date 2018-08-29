#!/usr/bin/env python3
import sys
import os
import requests
import json
from lxml import etree
from lxml.builder import E


pretty_print = True
path = os.path.dirname(os.path.abspath(__file__)) + '/../index.html'
url_pattern = 'https://api.vianavigo.com/lines/{line}/stops/{stop}/realTime'
xpath_expression = '//*[@data-connector="ratp"]'


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
    for child in e:
        e.remove(child)
    
    line = e.get('data-line')
    url = url_pattern.replace('{line}', line)
    stop = e.get('data-stop')
    url = url.replace('{stop}', stop)
    
    print(url)
    r = requests.get(url, headers={'X-Host-Override': 'vgo-api'})
    response = r.text

    data = json.loads(response)

    for schedule in data:
        #print(schedule)
        if 'err_code' == schedule:
            div = E.div(
                E.div('fin de service')
            )
            e.append(div)
        else:
            lineDirection = schedule['lineDirection']
            code = schedule['code']

            if 'message' == code:
                message = schedule['schedule']
                div = E.div(
                    E.label(lineDirection),
                    E.div(message),
                    {"class": "important"}
                )
                e.append(div)
            elif 'duration' == code:
                time = schedule['time']
                div = E.div(
                    E.label(lineDirection),
                    E.output(time)
                )
                e.append(div)


xml_bytes = etree.tostring(tree, xml_declaration=False, method='xml', encoding='UTF-8', pretty_print=pretty_print)
xml_text = xml_bytes.decode('utf-8')

with open(path, 'w') as xml_file:
    print(xml_text, file=xml_file)
