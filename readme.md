# Home dashboard

last seen screen before entering in the real word


## installation

```bash
pip install -r requirements.txt
./update.sh
```
open `./www/index.html`

optional options for `./update.sh`:

- `-s` or `--no-index`: do not generate index file
- `-d` or `--daemon`: endless loop
- `--sleep=123`: sleep `123`s between steps of the endless loop
- `--index=/path/to/index.html`(default=`./www/index.html`): index file
- `--dir=/path/to/directory` or `--dir=/path/to/page.html` (default is `./www/pages`): xhtml pages to parse


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