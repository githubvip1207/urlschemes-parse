
# URLSchemes解析工具

该程序主要使用命令usp.sh，可以完成解析指定ipa文件的URLSchemes。

## 使用方法：
	Usage: bash usp.sh -f <filename>
	Param:
		filename: ipa包路径，必须是相对的
	Example:
		bash usp.sh -f ./meitu.ipa
		bash usp.sh -f ./ipa/meitu.ipa

## 环境要求：
	python 2.7
	plutil mac电脑默认安装
	建议在mac机器上使用

## 注意：
	程序运行时，会在脚本目录下创建temp目录，该目录用于缓存ipa的源码，
	你可以任意删除它。当然程序本身也具备清洗能力，所以你不用担心这个文件会占用你的磁盘空间。

	该工具指定的ipa文件你可以使用PP助手等软件生成，你也可以在itunes中得到。

## 安装建议：
	建议将程序所处的目录放在~/bin下，然后配置~/bin/urlschemes-parse到环境变量中，
	如果有需要也推荐你根据自己的需求修改usp.sh为其他你喜欢的命令名。
