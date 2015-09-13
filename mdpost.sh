#!/bin/bash

# set config:
# * _templates dir, 
TEMPLATES="_templates"

# * _articles dir,
ARTICLES="_articles"

# * article tag (to replace with article html)
CONTENTTAG="{mp:content}"

# check dependencies (markdown)
DEPENDENCIES="markdown"
for i in $DEPENDENCIES
do
	type $i &>/dev/null && continue || { echo "$i not found. Please install it"; exit; }
done

# read arguments (-t, -a)
TEMPLATE_ARG=
ARTICLE_ARG=
while getopts t:a: opt; do 
	case $opt in 
		t)
			TEMPLATE_ARG=$OPTARG
			;;
		a)
			ARTICLE_ARG=$OPTARG
			;;
	esac
done

if [[ $TEMPLATE_ARG = "" ]]
then
	echo "No template specified!"
	exit;
fi
if [[ $ARTICLE_ARG = "" ]]
then
	echo "No article specified!"
	exit;
fi

TEMPLATE_PATH="${TEMPLATES}/${TEMPLATE_ARG}/template.html"
ARTICLE_PATH="${ARTICLES}/${ARTICLE_ARG}"
ARTICLE_INPUT="${ARTICLE_PATH}/index.md"

# verify argument paths exist/valid
if [ ! -f $TEMPLATE_PATH ]
then
	echo "Invalid template or template path";
	exit;
else
	echo "Using template ${TEMPLATE_PATH}"
fi
if [ ! -f $ARTICLE_INPUT ]
then
	echo "Invalid article or article path";
	exit;
else 
	echo "Using article input ${ARTICLE_INPUT}"
fi

# load template to var
TEMPLATE_DATA=$(<${TEMPLATE_PATH})

# convert markdown to html
CONVERTED_ARTICLE_OUTPUT="<section>$(markdown $ARTICLE_INPUT)</section>"

# retrieve the title of the article (the first h1 element)
TITLE=`echo "${CONVERTED_ARTICLE_OUTPUT}" | sed -n "s/.*<h1>\([^<]*\)<\/h1>.*/\1/p"`
echo "Title seems to be *${TITLE}*"

# create a timestamp
DATE=`date --rfc-822`
PUBDATE="<time datetime=\"${DATE}\">${DATE}</time>"

# wrap the first h1 in a header element (and include a timestamp)
CA_TEMP=${CONVERTED_ARTICLE_OUTPUT}
CA_TEMP=${CA_TEMP/"<h1>"/"<header><h1>"}
CA_TEMP=${CA_TEMP/"</h1>"/"</h1>${PUBDATE}</header>"}

CONVERTED_ARTICLE_OUTPUT=${CA_TEMP}

# replace article tag with converted html
FULL_ARTICLE=${TEMPLATE_DATA/$CONTENTTAG/$CONVERTED_ARTICLE_OUTPUT}

# write to article argument index.html
echo "${FULL_ARTICLE}" > "${ARTICLE_PATH}/index.html"

echo "Article created at ${ARTICLE_PATH}/index.html"

#TODO
#echo "Added ${TITLE} to site index"

exit 0;
