#!/bin/bash

wdir=/admin/projects/wapt

#Web application enumeration scripts
echo  "Input site to be tested (www.example.com)..."

read -p "Site: " sitename

echo  "You've selected $sitename as your target..."

echo "Please enter a name for your project..."

read -p "Project: " projname

projfolder=$wdir/$projname
echo Creating project folder $projfolder...

if  [ ! -e $projfolder ]; then
	mkdir -p $projfolder
elif [ ! -d $projfolder ]; then
	echo $projfolder already exists but is not a directory 1>&2
fi

echo Beginning Scans...

echo "Scanning HTTP Verbs..."
hverbs="$projname"_http_verbs.txt
nmap --script http-methods -p 80,443 $sitename -oN $projfolder/$hverbs  >/dev/null

echo "Scanning SSL Cipers..."
ssl="$projname"_ssl_cipers.txt
nmap --script ssl-enum-ciphers -p 443 $sitename -oN $projfolder/$ssl >/dev/null

echo "Scanning Services (may take some time)..."
services="$projname"_services.txt
nmap  -Pn -sT -sV -F $sitename -oN $projfolder/$services >/dev/null

#echo "Headers..."
#headers="$projname"_headers.txt
#hsecscan -i -u https://$sitename >$headers 
