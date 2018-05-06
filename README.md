# scarlett_os-flatpak
Experimental repo to install scarlett via flatpak


```
/* "env": {
                    "GST_PLUGIN_SYSTEM_PATH": "/app/lib/gstreamer-1.0/",
                    "FREI0R_PATH": "/app/lib/frei0r-1/",
                    "GSTREAMER": "1.0",
                    "ENABLE_PYTHON3": "yes",
                    "ENABLE_GTK": "yes",
                    "PYTHON_VERSION": "3.5",
                    "CC": "gcc",
                    "V": "1"
                }, */
```


# Good example of installing cpython w/ flatpak and its deps

https://github.com/flathub/org.jamovi.jamovi/blob/master/python-deps.json

# Add to bash_profile

*https://ask.fedoraproject.org/en/question/53035/how-to-eliminate-export-dbus-launch-at-every-terminal-session-on-fedora/*
`export $(dbus-launch)`
