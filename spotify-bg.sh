#!/usr/bin/env bash

rm -rf out.png

./spotify-backup.py playlists.json --format=json --dump=liked
crystal build main.cr -o images
./images playlists.json > out.svg
inkscape out.svg -o out.png

rm -rf out.svg
rm -rf images
rm -rf playlists.json
