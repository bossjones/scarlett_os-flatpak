#!/bin/bash
desktop-file-edit --set-key Name --set-value 'ScarlettOS' --set-key Exec --set-value 'who' --set-key Icon --set-value org.scarlett.ScarlettOS ScarlettOS.desktop

install -D ScarlettOS.desktop /app/share/applications/org.scarlett.ScarlettOS.desktop