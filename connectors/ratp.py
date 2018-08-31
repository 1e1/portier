#!/usr/bin/env python3
import sys
import os
import requests
import json
from lxml import etree
from lxml.builder import E
from operator import itemgetter


url_pattern = 'https://api.vianavigo.com/lines/{line}/stops/{stop}/realTime'
url_to_pattern = 'https://api.vianavigo.com/lines/{line}/stops/{stop}/to/{to}/realTime'
xpath_expression = '//*[@data-connector="ratp"]'
failures_max = 5


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
    line = e.get('data-line')
    stop = e.get('data-stop')
    to = e.get('data-to')
    failures = int(e.get('data-failures', '0'))

    url = url_pattern if None == to else url_to_pattern

    url = url.replace('{line}', line)
    url = url.replace('{stop}', stop)

    if None != to:
        url = url.replace('{to}', to)
    
    print(url)
    r = requests.get(url, headers={'X-Host-Override': 'vgo-api'})
    response = r.text

    data = json.loads(response)

    if type(data) is dict:
        error = data.get('err_code', 0)
        print(error)

        failures = 1 + failures
        if failures > failures_max:
            for child in e:
                e.remove(child)
            
        e.set('data-failures', str(failures))

    else:
        for d in data:
            way = d.get('sens', 0)
            d['sens'] = way
            
        data_order = sorted(data, key=itemgetter('sens'))
        
        for child in e:
            e.remove(child)

        for schedule in data_order:
            #print(schedule)
            lineDirection = schedule.get('lineDirection', 'Sans arrêt')
            code = schedule.get('code')
            way = schedule.get('sens')

            if 'message' == code:
                message = schedule.get('schedule')
                if 'Sans arrêt' != message:
                    div = E.div(
                        E.label(lineDirection),
                        E.div(message),
                        { 'class': 'important' }
                    )
                    e.append(div)
            elif 'duration' == code:
                time = schedule.get('time', '?')
                div = E.div(
                    E.label(lineDirection),
                    E.output(time)
                )
                e.append(div)

        if 'data-failures' in e.attrib:
            del e.attrib['data-failures']


xml_bytes = etree.tostring(tree, xml_declaration=False, method='xml', encoding='UTF-8', pretty_print=pretty_print)
xml_text = xml_bytes.decode('utf-8')

with open(path, 'w') as xml_file:
    print(xml_text, file=xml_file)
