# TODO

- [ ] Reverse engineer build logs from gnome-builder build output, and convert into Makefile commands / or bash / python, whatever.

- [ ] compile `flex`, `bison` `libasound2-dev` and `swig`, before compiling pocketsphinx. ( http://www.linuxfromscratch.org/lfs/view/development/chapter06/bison.html )

- [ ] make `easy-install.pth` and `setuptools.pth` writable  https://github.com/flatpak/flatpak-builder/issues/5

```
"ensure-writable": [
    "/lib/python3.6/site-packages/easy-install.pth",
    "/lib/python3.6/site-packages/setuptools.pth"
],
```

https://stackoverflow.com/questions/6301003/stopping-setup-py-from-installing-as-egg/27175492#27175492

- [ ] Recompile pulseaudio with https://github.com/flatpak/freedesktop-sdk-images/blob/1.6/org.freedesktop.Sdk.json.in#L1597 enabled

- [ ] Make sure we recompile version 1.48.04+dfsg-2 of espeak ( build log for examples https://launchpadlibrarian.net/231115665/buildlog_ubuntu-xenial-amd64.espeak_1.48.04+dfsg-2_BUILDING.txt.gz)

( maybe we need sonic ? )
```
-lstdc++ -lpulse -lpulse-simple -lportaudio -lpthread -lsonic
```
