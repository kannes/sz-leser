#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

if [ ! -d "pages" ]; then
  echo "initialise first"
  exit
fi

if [ ! -f "sueddeutsche.de.sqlite" ]; then
  echo "initialise first"
  exit
fi

timestamp=$(date +%Y-%m-%d_%H:%M:%S)

wget -nv -O pages/activevisits_"${timestamp}".gz \
--header="Accept-Encoding: gzip" \
http://www.sueddeutsche.de/news/activevisits
# TODO ggf user-agent faken, falls sie blocken...

# Gesamtanzahl ist eine einfache Zahl, grep -> sqlite und fertig.
total=$(zgrep -H '<span class="mostread complete">' pages/activevisits_"${timestamp}".gz | \
sed 's#</span>##' | \
sed 's#pages/activevisits_#"#' | \
sed 's#.gz.*">#",#' | sed 's#_# #')
# da ist auch der timestamp drin, bisschen :ugly:?

sqlite3 sueddeutsche.de.sqlite "INSERT INTO total(timestamp, leser) VALUES (${total});" && \
echo "Eingefügt: ${total}"

# Die Anzahl je Story ist eine einfache Tabelle, per .import am einfachsten? =)
zgrep -HE '(Leser lesen gerade|rel="bookmark">)' pages/activevisits_"${timestamp}".gz | \
sed 's#pages/activevisits_##' | \
sed 's#.gz.*title="#\t#' | \
sed 's#_# #' | \
sed 's# Leser lesen gerade.*##' | \
sed 's#.*sueddeutsche.de##' | \
sed 's#".*##' | \
paste - - | \
sort > /tmp/perurl.tsv

sqlite3 -separator '	' sueddeutsche.de.sqlite '.import /tmp/perurl.tsv perurl' && \
echo "Importiert: ${timestamp}	"`wc -l /tmp/perurl.tsv`