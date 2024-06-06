#!/usr/bin/env bash

#set screen timeout to 5 hours
adb shell settings put system screen_off_timeout  18000000

adb shell svc power stayon true

