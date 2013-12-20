#!/bin/sh 
# -ex:
# bail on errors and show debugging stuff
read -r -d '' HELP <<-'EOF'

HELP TEXT HERE

Expects a tab separated list of call numbers and BibIds, like this:

ljs25	4645815
ljs26	4646348
ljs495	4650884
ljs451	4738506
ljs477	4745542
ljs23	4746981
ljs308	4748833
ljs252	4759444
ljs492	4762411
ljs493	4762524

Each BIBID will be used to snag the XML fo the manuscript in Penn In Hand,
using a URL like this:

* http://dla.library.upenn.edu/dla/medren/pageturn.xml?q=ljs&id=MEDREN_<BIBID>

The call numbers will be used to name the output files.

EOF

################################################################################
### TEMPFILES
# From:
#   http://stackoverflow.com/questions/430078/shell-script-templates
# create a default tmp file name
tmp=${TMPDIR:-/tmp}/prog.$$
# delete any existing temp files
trap "rm -f $tmp.?; exit 1" 0 1 2 3 13 15
# then do
#   ...real work that creates temp files $tmp.1, $tmp.2, ...

################################################################################
#### USAGE AND ERRORS
cmd=`basename $0`

usage() {
   echo "Usage: $cmd MS_LIST"
}

print_help() {
  echo "$HELP"
}

print_msg() {
  pm_code=$1
  pm_msg=$2
  printf "[%s] %15s     %s\n" $cmd $pm_code "$pm_msg"
}

error() {
   print_msg ERROR "$1" 1>&2
   usage
   exit 1
}

message() {
  print_msg INFO "$1" 1>&2
}

warning() {
  print_msg WARNING "$1" 1>&2
}

################################################################################
### OPTIONS
while getopts "h" opt; do
  case $opt in
    h)
      usage 
      print_help
      exit 1
      ;;
    \?)
      echo "ERROR Invalid option: -$OPTARG" >&2
      echo ""
      usage
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))


################################################################################
### THESCRIPT

OUTDIR=`dirname $0`/../data/xml
if [ ! -e $OUTDIR ]; then
  mkdir $OUTDIR
  message "Created $OUTDIR"
fi

LIST=${1?Please provide a list.}

if [ -f "$LIST" ]; then
  message "Using list: $LIST"
else
  error "Can't find list: $LIST"
fi

while read pair
do
  callno=`echo $pair | awk '{ print $1 }'`
  bibid=`echo $pair | awk '{ print $2 }'`
  outfile=$OUTDIR/${callno}.xml
  curl http://dla.library.upenn.edu/dla/medren/pageturn.xml?id=MEDREN_${bibid} --output $outfile
  message "Wrote $outfile"

done < $LIST

################################################################################
### EXIT
# http://stackoverflow.com/questions/430078/shell-script-templates
rm -f $tmp.?
trap 0
exit 0
