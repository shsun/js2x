# js2m converts a js file to a const NSString literal.
# It will minify js, escape doublequote and append backslash to the end of lines. 
# For the format of js file or what it will generate, check the following command
# ./js2m.sh Classes/Renderer/MRAID/mraid.js Classes/Renderer/MRAID/XAdMRAIDConstants.m 3

jsfile=$1 
mfile=$2
templatelines=$3

function js2musage()
{
	echo "usage: `basename $0` <js file with template string defined> <target .m file which will be overwrote> <lines of comment in js file>"
	echo "example: `basename $0` sample.js template.m 5"
}

if [ ! -f './tools/js/closure-compiler/compiler.jar' ]
then
    echo "Cannot find ./tools/js/closure-compiler/compiler.jar"
    exit 1
fi

if [ `which perl` ] && [ `which cut` ] && [ `which head` ] && [ `which tail` ] && [ `which sed` ]
then
	# do nth
	:
else
	echo "Failed to find one of required binaries: perl, cut, head, tail, sed."
	exit 1
fi

if [ $# != 3 ]
then
	echo "`basename $0` expectes three parameters."
	js2musage
	exit 1
fi

if [ ${jsfile##*.} != "js" ] || [ ! -f $jsfile ]
then
	echo "Did you provide a existed .js file as the first parameter?"
	js2musage
	exit 1
fi

if [ ${mfile##*.} != "m" ]
then
	echo "Did you provide a .m filename as the second parameter that will be convert target?"
	js2musage
	exit 1
fi

if ! [[ $templatelines =~ ^([0-9]+)$ ]]
then
	echo "Did you provide how many lines should be reserved in js file as the third parameter?"
	js2musage
	exit 1
fi


# cut extra lines
tempfoo=`basename $0`
TMPFILE=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1
head -$templatelines $jsfile | sed 's|//NSString|NSString|g'  > $TMPFILE && echo -n "=@\"" >> $TMPFILE && mv $TMPFILE $mfile

if [ $? != 0 ]
then
	echo "Failed to cut file.";
	exit 1
fi

# jsminify, escape double quote, append backslash to the end of line
tail +`expr 1 + $templatelines` $jsfile | java -jar ./tools/js/closure-compiler/compiler.jar --js $jsfile | sed 's|\"|\\\"|g' | perl -i -p -e 's/\n/\\n\\\n/' >> $mfile
#for debug, don't jsminify
#tail +`expr 1 + $templatelines` $jsfile | sed 's|\"|\\\"|g' | perl -i -p -e 's/\n/\\n\\\n/' >> $mfile

if [ $? != 0 ]
then
	echo "Failed to escape js file and insert into .m file." && exit 1
fi

# echo final line of doublequote and semicolon
echo "\";" >> $mfile
