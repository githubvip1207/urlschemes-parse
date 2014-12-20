urlschemes-parse
================

# URLSchemes解析工具

该程序主要使用命令urlschemes_parse.sh，可以完成解析指定ipa文件的URLSchemes。

## 使用方法：
	Usage: bash urlschemes_parse.sh -f <filename>
	Param:
		filename: ipa包路径，必须是相对的
	Example:
		bash urlschemes_parse.sh -f ./meitu.ipa
		bash urlschemes_parse.sh -f ./ipa/meitu.ipa

## 环境要求：
	python 2.7
	plutil mac电脑默认安装

## 注意：
	程序运行时，会在脚本目录下创建temp目录，该目录用于缓存ipa的源码，
	你可以任意删除它。当然程序本身也具备清洗能力，所以你不用担心这个文件会占用你的磁盘空间。

## 安装建议：
	建议将程序所处的目录放在~/bin下，然后配置~/bin/urlschemes_parse到环境变量中，
	如果有需要也推荐你根据自己的需求修改urlschemes_parse.sh为其他你喜欢的命令名。
