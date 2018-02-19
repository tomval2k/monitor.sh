#!/bin/sh

#module attributes
name=uptime
version=0.1

#get data (only getting 1 value so pretty simple)
timestamp=$(date +%s)
result=$(while read line; do var=${line% *}; printf $var; done < /proc/uptime)


#echo $result
printf '{ "meta": {"name": "%s","version": "%s"},"data": [ { "timestamp": "%d", "name": "%s", "value": "%.2f"}]}\n' $name $version $timestamp $name $result
