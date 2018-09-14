#!/usr/bin/env python3
# coding=utf-8

import sys
import os
import requests
import re
from lxml import etree
from lxml.builder import E


url_pattern = 'https://www.meteofrance.com/previsions-meteo-france/{city}/{zip_code}'
xpath_expression = '//*[@data-connector="weather"]'


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
        datetimes = part.xpath('.//time/@datetime')
        temperatures = part.xpath('.//li[contains(@class,"day-summary-temperature")]/text()[normalize-space()]')
        feel_temperatures = part.xpath('.//li[contains(@class,"day-summary-tress-start")]/text()[normalize-space()]')
        uvs = part.xpath('.//li[contains(@class,"day-summary-uv")]/text()[normalize-space()]')
        winds = part.xpath('.//li[contains(@class,"day-summary-wind")]//text()[normalize-space()][last()]')
        rains = part.xpath('.//div[contains(@class,"day-probabilities")]//strong/text()[normalize-space()]')
        pictures = part.xpath('.//li[contains(@class,"day-summary-image")]//text()[normalize-space()]')
        
        datetime = attr_datetime = ''
        temperature = attr_temperature = ''
        feel_temperature = attr_feel_temperature = ''
        uv = attr_uv = ''
        wind = attr_wind = ''
        rain = attr_rain = ''
        picture = attr_picture = ''

        if (len(datetimes)):
            datetime = datetimes[0].strip()
            attr_datetime = re.sub(r'\D+', '', datetime)
        
        if (len(temperatures)):
            temperature = temperatures[0].strip()
            attr_temperature = re.sub(r'[^0-9-]+', '', temperature)
        
        if (len(feel_temperatures)):
            feel_temperature = feel_temperatures[0].strip()
            attr_feel_temperature = re.sub(r'[^0-9-]+', '', feel_temperature)

        if (len(uvs)):
            uv = uvs[0].strip()
            attr_uv = re.sub(r'\D+', '', uv)

        if (len(winds)):
            wind = winds[0].strip()
            attr_wind = re.sub(r'\D+', '', wind)

        if (len(rains)):
            rain = rains[0].strip()
            attr_rain = re.sub(r'\D+', '', rain)

        if (len(pictures)):
            picture = pictures[0].strip()

        #print('        datetime: ' + datetime)
        #print('     temperature: ' + temperature)
        #print('feel_temperature: ' + feel_temperature)
        #print('              uv: ' + uv)
        #print('            wind: ' + wind)
        #print('            rain: ' + rain)
        #print('         picture: ' + picture)

        # legend:
        # - Ensoleillé ou Nuit claire
        # - Ciel voilé
        # - Éclaircies
        # - Très nuageux
        # - Brume ou bancs de brouillard
        # - Brouillard
        # - Brouillard givrant
        # - Bruine / Pluie faible
        # - Pluie verglaçante
        # - Pluies éparses / Rares averses
        # - Pluie / Averses
        # - Pluie forte
        # - Pluie orageuses
        # - Quelques flocons
        # - Pluie et neige
        # - Neige / Averses de neige
        # - Neige forte
        # - Risque de grêle
        # - Risque d'orages
        # - Orages

        li = E.li(
            E.time(datetime, {'datetime': datetime}),
            E.span(temperature, {'class': 'temperature'}),
            E.span(feel_temperature, {'class': 'feel_temperature'}),
            #E.span(uv, {'class': 'uv'}),
            #E.span(wind, {'class': 'wind'}),
            #E.span(rain, {'class': 'rain'}),
            { 'data-datetime': attr_datetime
            , 'data-temperature': attr_temperature
            , 'data-feel_temperature': attr_feel_temperature
            , 'data-uv': attr_uv
            , 'data-wind': attr_wind
            , 'data-rain': attr_rain
            , 'data-picture': re.sub(r'\W*/\W*', ' ', picture.replace(' ', '-').replace("'", '-'))
            }
        )
        ul.append(li)

    e.append(ul)
    

xml_bytes = etree.tostring(tree, xml_declaration=False, method='xml', pretty_print=pretty_print)
xml_text = xml_bytes.decode('utf-8')

with open(output_path, 'w') as xml_file:
    print(xml_text, file=xml_file)
