### sources

- pluie
`curl -X GET http://www.meteofrance.com/mf3-rpc-portlet/rest/pluie/{idLieu}`
```
{
  "idLieu" : "123",
  "echeance" : "201808291150",
  "lastUpdate" : "11h35",
  "isAvailable" : true,
  "hasData" : true,
  "niveauPluieText" : [ "De11h50 à 12h50 : Pas de précipitations" ],
  "dataCadran" : [ {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  }, {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  }, {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  }, {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  }, {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  }, {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  }, {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  }, {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  }, {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  }, {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  }, {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  }, {
    "niveauPluieText" : "Pas de précipitations",
    "niveauPluie" : 1,
    "color" : "ffffff"
  } ]
}
```

- ratp
`curl -X GET 'https://api.vianavigo.com/lines/123/stops/123/realTime' -H 'X-Host-Override: vgo-api'`
```
[
  {
    "lineId": "123",
    "lineDirection": "Tour Eiffel",
    "code": "duration",
    "time": "1"
  },
  {
    "lineId": "123",
    "lineDirection": "Arc de Triomphe",
    "code": "duration",
    "time": "9"
  }
]
```


