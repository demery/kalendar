#!/usr/bin/env sh

while read line
do
  grep "$line$" `dirname $0`/full_callno_list.txt
done < `dirname $0`/penn_kals.txt