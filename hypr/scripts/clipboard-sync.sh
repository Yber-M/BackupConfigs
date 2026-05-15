#!/bin/bash

pkill -f "wl-paste.*cliphist" 2>/dev/null
pkill -f "wl-paste.*primary" 2>/dev/null

wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

wl-paste --primary --watch sh -c 'wl-paste --primary | wl-copy' &
