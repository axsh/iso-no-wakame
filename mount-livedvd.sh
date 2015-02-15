#!/bin/bash

if [ 1 -ne $# ];then
  echo "Usage: $0 ISO_FILE"
  exit 1
fi
iso=$1
temp=`/bin/mktemp -d --tmpdir=/tmp/ tmp.XXXXXX`
/bin/mkdir -p ${temp}/{iso,sq,ext}
/bin/mount -o loop,ro ${iso} /${temp}/iso/
/bin/mount -o loop,ro /${temp}/iso/LiveOS/squashfs.img /${temp}/sq/
/bin/mount -o loop,ro /${temp}/sq/LiveOS/ext3fs.img /${temp}/ext/
