#!/bin/bash
#########################################################################
# Author: (chenyu@1207.cn)
# Created Time: 2014-11-05 13:15:02
# File Name: urlschemes_parse.sh
# Description: 解析ipa包中的URLSchemes
#########################################################################

# 将当前脚本的目录定义为基础目录，并获取用户的目录
BASEPATH=$(dirname $0)
USERPATH=$(pwd)

# 定义临时文件、plist文件、源码文件的保存路径
TMP_PATH="${BASEPATH}/temp"
JSON_PATH="${TMP_PATH}/plist"
SOURCE_PATH="${TMP_PATH}/source"


########################## 提供的方法函数

# 验证上一条执行结果是否正确
function assertSuccess() {
	if [[ $1 -ne 0 ]]; then
		echo "error: ${2}"
		exit 1
	fi
}

# 判定目录是否存在，并且创建指定目录
function createDir() {
	if [[ -d $1 ]]; then
		echo "file already exists: ${1}"
	else
		mkdir -p $1
		assertSuccess $? "[error] failed to create the directory: ${1}"
		echo "create a directory success: ${1}"
	fi
}  

# 从json中获取指定的键值
# 使用方法：value=$(parseJson $s "url")
function parseJson() {
	echo $1 | sed 's/.*'$2':\([^,}]*\).*/\1/'
}

# 初始化当前的环境
function construct() {
	rm -rf "${TMP_PATH}"
	assertSuccess $? "[error] failed to delete files: ${TMP_PATH}"
	echo "delete the files success: ${TMP_PATH}"

	createDir "${JSON_PATH}"
	createDir "${SOURCE_PATH}"
}

# 使用方法
function usage() {
	echo '
  Usage: bash urlschemes_parse.sh -f <filename>
	Param:
		filename: ipa包路径，必须是相对的
  Example:
	bash urlschemes_parse.sh -f ./meitu.ipa
	bash urlschemes_parse.sh -f ./ipa/meitu.ipa
	'
}


########################## 获取用户输入的ipa路径

while [ $# != 0 ]; do
	case $1 in
		-f) shift; ipa=$1; shift;;	
		 *) shift;;
	esac
done

if [[ -z $ipa ]]; then
	echo "[error] ipa file not defined"
	usage
	exit 1
fi

ipaFile="${USERPATH}/${ipa}"
if [[ ! -f "${ipaFile}" ]]; then
	echo "[error] ipa file not found: ${ipaFile}"
	exit 1
fi



########################## 逻辑部分

echo "parse ipa path: ${ipaFile}"

# 初始化
construct

# 解压缩
unzip -oq "${ipaFile}" -d "${SOURCE_PATH}"
assertSuccess $? "[error] unpack the failure: ${ipaFile}"
echo "unpack the success: ${ipaFile}"

# 获取包名，因为有些ipa的Payload中可能存在多个.app文件，使用遍历的方式获取真实的.app文件
IFS=$'\n'
packages=$(ls "${SOURCE_PATH}/Payload" | grep "app$")
assertSuccess $? "[error] get package name failure: ${ipaFile}"
for package in ${packages}; do
	if [[ -f "${SOURCE_PATH}/Payload/${package}/Info.plist" ]]; then
		packageName="${package}"
	fi
done
echo "get package name success: ${packageName}"

# 转换plist文件
plutil -convert json -o "${JSON_PATH}/Info.plist" "${SOURCE_PATH}/Payload/${packageName}/Info.plist"
assertSuccess $? "[error] plist convert failure: ${ipaFile}"
echo "plist convert success: ${ipaFile}"

# 调用python，来解析json
python -c "
import json

try:
	infos = '''$(cat "${JSON_PATH}/Info.plist")'''
	infos = infos.replace('\r', '').replace('\n', '').replace('\t', '')
	infos = json.loads(infos)
except Exception, e:
	print '[error] JSON_PARSE: info.plist read failure'
	print e
	exit(1)
types = infos.get('CFBundleURLTypes', False)
if not types:
	print '[error] JSON_PARSE: CFBundleURLTypes not found'
	exit(1)
urlschemes = []
for type in types: 
	schemes = type.get('CFBundleURLSchemes', [])
	urlschemes.extend(schemes)
print '\nURL Schemes: \n\n      %s \n\n' % ', '.join(urlschemes)
#print ', '.join(urlschemes)
"


# vim: set noexpandtab ts=4 sts=4 sw=4 :
