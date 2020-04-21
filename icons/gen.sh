#!/bin/bash

sips --resampleWidth 120 Icon_1024.png --out Icon_iPhone@2x.png
sips --resampleWidth 180 Icon_1024.png --out Icon_iPhone@3x.png
sips --resampleWidth 76 Icon_1024.png --out Icon_iPad.png
sips --resampleWidth 152 Icon_1024.png --out Icon_iPad@2x.png
sips --resampleWidth 167 Icon_1024.png --out Icon_iPadPro@2x.png
