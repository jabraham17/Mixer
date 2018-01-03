#!/bin/sh

#mark all feature tags as warnings, seperate so that it can be turned off

#if the flag is set then run it
if [ "$1" == "-o" ]; then
    TAGS="FEAT:"
    find "${SRCROOT}/Mixer" \( -name "*.h" -or -name "*.m" -or -name "*.swift" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($TAGS).*\$" | perl -p -e "s/($TAGS)/ warning: \$1/"
fi

#always run these
TAGS="TODO:|FIXME:|MARK:"
ERRORTAG="ERROR:"
find "${SRCROOT}/Mixer" \( -name "*.h" -or -name "*.m" -or -name "*.swift" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($TAGS).*\$|($ERRORTAG).*\$" | perl -p -e "s/($TAGS)/ warning: \$1/" | perl -p -e "s/($ERRORTAG)/ error: \$1/"
