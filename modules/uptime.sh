#!/bin/sh

#module attributes
name=uptime
version=0.2.0

#get data (only getting 1 value so pretty simple)
timestamp=$(date +%s)
result=$(while read line; do var=${line% *}; printf $var; done < /proc/uptime)


#echo $result
printf '{ "mod-%s": { "meta": {"name": "%s","version": "%s"},"data": {"%s": { "timestamp": "%d", "value": "%.2f"}} }}\n' $name $name $version $name $timestamp $result
