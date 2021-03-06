# Home dashboard

last seen screen before entering in the real word

![landscape](./screenshots/landscape.png)
![portrait](./screenshots/portrait.png)


## installation

### raspbian


#### single mode
use existing template (see template names in `./www/pages/`)

```bash
# template = suresnes
curl -sSL https://raw.githubusercontent.com/1e1/portier/master/misc/_raspbian_fresh_install.sh | bash -s -- --template=suresnes
```


#### use all template
```bash
sh -c "$(curl -sSL https://raw.githubusercontent.com/1e1/portier/master/misc/_raspbian_fresh_install.sh)"
```


#### update a template

Then if you update a template into `/home/pi/portier/www/pages/`.
You have just to restart the service: `service portier restart` or let's do it on startup/reboot.



### manual

`apt-get install python3-pip`


### optional

- nginx-light: for remote access, otherwise you can go to `file:///path/to/index.html`
- chromium: for kiosk mode

```bash
pip install -r requirements.txt
./update.sh
```
open `./www/index.html`

optional options for `./update.sh`:

- `-s` or `--no-index`: do not generate index file
- `-d` or `--daemon`: endless loop
- `--sleep=123`: sleep *123* seconds between steps of the endless loop
- `--index=/path/to/index.html`(default=`./www/index.html`): index file
- `--dir=/path/to/directory` or `--dir=/path/to/page.html` (default is `./www/pages`): xhtml pages to parse
- `--shared-memory=/path/to/directory` (default is `/dev/shm`): workspace directory - a memory FS is efficient


## tips: use a RAM disk

```bash
mkdir /var/www/ramdisk
sudo nano /etc/fstab
```
add
```
tmpfs /var/www/ramdisk tmpfs nodev,nosuid,size=1M 0 0
```
```bash
sudo mount -a
df
```
check the new volume

source: [domoticz](https://www.domoticz.com/wiki/Setting_up_a_RAM_drive_on_Raspberry_Pi)


## connectors

### ratp
```html
<div data-connector="ratp" data-line="100100093:93" data-stop="59049">
    <div class="important">
        <label>destination 1</label>
        <div>message 1</div>
    </div>
    <div>
        <label>destination 2</label>
        <output>1</output>
    </div>
    <div>
        <label>destination 3</label>
        <output>22</output>
    </div>
    <div>
        <label>...</label>
        <output>...</output>
    </div>
</div>
```

get the values on ViaNavigo.fr
- `data-line`: line id
- `data-stop`: stop id

### rss
```html
<div data-connector="rss" data-url="http://www.lefigaro.fr/rss/figaro_flash-actu.xml">
    <ul>
        <li>title 1</li>
        <li>title 2</li>
        <li>title 3</li>
        <li>...</li>
    </ul>
</div>
```

- `data-url`: RSS url

### traffic-google
```html
<div data-connector="traffic-google" data-city="suresnes">
    <img src="https://www.google.com/maps/..."/>
</div>
```

- `data-city`: city name

### weather-rain
```html
<div data-connector="weather-rain" data-param="920730">
    <ul>
        <li style="background-color:#123def"> </li>
        <li style="background-color:#456abc"> </li>
        <li style="background-color:#789000"> </li>
        <li class="minutes">15</li>
        <li style="background-color:#123def"> </li>
        <li style="background-color:#456abc"> </li>
        <li style="background-color:#789000"> </li>
        <li class="minutes">30</li>
        <li style="background-color:#123def"> </li>
        <li style="background-color:#456abc"> </li>
        <li style="background-color:#789000"> </li>
        <li class="minutes">45</li>
        <li style="background-color:#123def"> </li>
        <li style="background-color:#456abc"> </li>
        <li style="background-color:#789000"> </li>
    </ul>
</div>
```

get the values on MeteoFrance.fr
- `data-param`: location id

### weather
```html
<div data-connector="weather" data-city="suresnes" data-zip_code="92150">
    <ul>
        <li>
            <time datetime="12h">12h</time>
            <span class="temperature">25°C</span>
        </li>
        <li>
            <time datetime="13h">13h</time>
            <span class="temperature">26°C</span>
        </li>
        <li>
            <time datetime="...">...</time>
            <span class="temperature">...</span>
        </li>
    </div>
</div>
```

get the values on MeteoFrance.fr
- `data-city`: city name
- `data-zip_code`: zip code

### time
```html
<div data-connector="time">
    <time datetime="2018-09-05T21:33:51">21:33</time></div>
</div>
```

- `data-format`: override the default format
