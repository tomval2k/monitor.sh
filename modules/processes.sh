#!/bin/sh

#module attributes
name=processes
version=0.1

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

#echo '{ "meta": {"name": "'$name'","version": "'$version'"},"data": [ { "timestamp": "'$timestamp'", "name": "'$name'", "value": "'$result'"}]}'
printf '{ "meta": {"name": "%s","version": "%s"},"data": [ { "timestamp": "%d", "name": "%s", "value": "%d"}]}\n' $name $version $timestamp $name $result
