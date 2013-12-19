#!/usr/bin/env sh

this_dir=`dirname $0`
base_url="http://www.thedigitalwalters.org/Data/WaltersManuscripts/ManuscriptDescriptions"

tei_list="W102_tei.xml
W10_tei.xml
W111_tei.xml
W165_tei.xml
W167_tei.xml
W168_tei.xml
W174_tei.xml
W175_tei.xml
W182_tei.xml
W185_tei.xml
W188_tei.xml
W192_tei.xml
W198_tei.xml
W23_tei.xml
W26_tei.xml
W34_tei.xml
W41_tei.xml
W420_tei.xml
W437_tei.xml
W4_tei.xml
W538_tei.xml
W73_tei.xml
W764_tei.xml
W782_tei.xml
W78_tei.xml
W79_tei.xml
W918_tei.xml"

for x in $tei_list
do
	curl ${base_url}/${x} -o $this_dir/../tei/$x
done