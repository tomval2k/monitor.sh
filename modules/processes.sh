#!/bin/sh

#module attributes
name=processes
version=0.2.0

#get data (only getting 1 value so pretty simple)
timestamp=$(date +%s)
getdata() {
  count=0;
  for i in /proc/[0-9]*;
    do count=$(( $count + 1 ));
  done;
}
getdata
result=$count

printf '{ "mod-%s": { "meta": {"name": "%s","version": "%s"},"data": {"%s": { "timestamp": "%d", "value": "%d"}} }}\n' $name $name $version $name $timestamp $result
