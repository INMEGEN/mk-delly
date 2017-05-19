#!/bin/bash

##Define the type of SV beign detected
TOOL=$(pwd | tr "/" "\n" | tail -n2 | head -n1)

##Create body of mkfile
##Create an array with the prereqs
prereq_list="tmp/prereq.list"

ls data/*.bcf | tr "\n" " " > $prereq_list

echo "< ../config.mk

all:VQ:
        bin/targets | xargs mk

results/$TOOL.merge.bcf:Q: $(cat $prereq_list)
	mkdir -p \$(dirname \$target)
	delly-parallel merge -t $TOOL -m \$MIN_LONG -n \$MAX_LONG \\
	-o \$target.build -b 500 -r \$OVERLAP $(cat $prereq_list) \\
	&& mv \$target.build \$target
" > mkfile