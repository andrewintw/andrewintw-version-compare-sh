#! /bin/sh

get_ver_digit() {
	local ver="$1"
	local pos="$2"
	local digit=`echo $ver | cut -d '.' -f $pos`

	if [ "$digit" = "" ]; then
		digit=0
	fi

	digit=`expr $digit + 0`

	printf "%d" "$digit"
}

version_compare() {
	# <version core> ::= <major> "." <minor> "." <patch> "." <build>
	local v1="$1"
	local v2="$2"

	v1_major=`get_ver_digit $v1 1`
	v1_minor=`get_ver_digit $v1 2`
	v1_patch=`get_ver_digit $v1 3`
	v1_build=`get_ver_digit $v1 4`

	v2_major=`get_ver_digit $v2 1`
	v2_minor=`get_ver_digit $v2 2`
	v2_patch=`get_ver_digit $v2 3`
	v2_build=`get_ver_digit $v2 4`

	#echo "DEBUG> v1:[$v1_major].[$v1_minor].[$v1_patch].[$v1_build]"
	#echo "DEBUG> v2:[$v2_major].[$v2_minor].[$v2_patch].[$v2_build]"

	if [ "${v1_major}.${v1_minor}.${v1_patch}.${v1_build}" = "${v2_major}.${v2_minor}.${v2_patch}.${v2_build}" ]; then
		return 0
	fi

	diff_major="$(( $v2_major - $v1_major ))"
	diff_minor="$(( $v2_minor - $v1_minor ))"
	diff_patch="$(( $v2_patch - $v1_patch ))"
	diff_build="$(( $v2_build - $v1_build ))"

	if [ $diff_major -gt 0 ]; then
		return 2
	elif [ $diff_major -lt 0 ]; then
		return 1
	fi

	if [ $diff_minor -gt 0 ]; then
		return 2
	elif [ $diff_minor -lt 0 ]; then
		return 1
	fi
	
	if [ $diff_patch -gt 0 ]; then
		return 2
	elif [ $diff_patch -lt 0 ]; then
		return 1
	fi

	if [ $diff_build -gt 0 ]; then
		return 2
	elif [ $diff_build -lt 0 ]; then
		return 1
	fi
}

test_version_compare() {
	local v1="$1"
	local v2="$2"
	local exp="$3"
	local op=''

	version_compare "$v1" "$v2"
	case $? in
		0) op='=';;
		1) op='>';;
		2) op='<';;
	esac

	if [ "$op" = "$exp" ]; then
		echo "PASS> $v1 $op $v2"
	else
		echo "FAIL> $v1 is NOT $exp $v2"
	fi
}

#test_version_compare "$1" "$2" "$3"
