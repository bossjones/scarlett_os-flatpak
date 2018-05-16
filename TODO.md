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
