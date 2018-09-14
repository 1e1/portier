#!/usr/bin/env python3
# coding=utf-8

import sys
import os
import pytz
from datetime import datetime
from lxml import etree
from lxml.builder import E


xpath_expression = '//*[@data-connector="time"]'


pretty_print = True
path_default = os.path.dirname(os.path.abspath(__file__)) + '/../www/index.html'
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
    dataFormat = e.get('data-format', '%H:%M')
    dataTimezone = e.get('data-timezone', 'Etc/UTC')

    utcnow = datetime.utcnow()
    
    old_timezone = pytz.timezone('Etc/UTC')
    new_timezone = pytz.timezone(dataTimezone)

    localnow = old_timezone.localize(utcnow).astimezone(new_timezone)

    isoTime = utcnow.isoformat()
    customTime = localnow.strftime(dataFormat)

    print(isoTime)

    for child in e:
        e.remove(child)

    time = E.time(
        customTime,
        { 'datetime': isoTime }
    )
    e.append(time)


xml_bytes = etree.tostring(tree, xml_declaration=False, method='xml', pretty_print=pretty_print)
xml_text = xml_bytes.decode('utf-8')

with open(output_path, 'w') as xml_file:
    print(xml_text, file=xml_file)
