## Firefox Icon Fix

This changes the firefox icon to whatever image you want.
The [default image](firefox-icon-fix.png) is Senko from the anime 'The Helpful Fox Senko-san'.
If you want to change the image, just replace 'firefox-icon-fix.png' with the image you want. Your image **has to be** named 'firefox-icon-fix.png' too.

Since the script uses softlinks to reduce space, make sure you never delete or change this directory if it is on your disk and you have fixed the icons with the script.

> To make the script executable, type `chmod +x firefox-icon-fix.sh`

#### Usage

Fix icons:
```console
$ ./firefox-icon-fix.sh
```

Unfix icons (restore the real ones):
```console
$ ./firefox-icon-fix.sh unfix
```

Re-fix icons after firefox update (the icons are sadly getting resetted after every firefox update):
```console
$ ./firefox-icon-fix.sh --overwrite
```
