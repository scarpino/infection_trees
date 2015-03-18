#!/bin/bash

# @author = Ruben S. Andrist
# @email = andrist@gmail.com
# @date = 2014-07-16

for filename in $@; do

    # transform sam's input csv into
    # dot format of the graph
    cat $@ | sed -e"s/\"//g" | awk -F"," '
        BEGIN {
            OFS=""
            print "digraph G {"
        }
        {
            # ignore header line
            if (NR < 2) next

            # print everything else
            print "\t",$2," -> ",$1,";"
        }
        END {
            print "}"
        }
    ' > ${filename/\.csv/.dot}

    # use dot to render the graph
    dot -Tpdf "${filename/\.csv/.dot}" -o "${filename/\.csv/.pdf}"
done

# vim: set ff=unix ai tw=80 ts=4 sts=4 sw=4 et:
