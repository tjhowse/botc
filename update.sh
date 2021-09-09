#!/bin/bash
./get_unofficial_pdfs.py > urls.list
cd unofficial_pdfs
wget -c -i ../urls.list
