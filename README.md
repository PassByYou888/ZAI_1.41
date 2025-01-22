# ZAI_1.41
Z-AI V1.41 Beta1

# 计算引擎部署说明
[百度网盘中的依赖库下载](https://pan.baidu.com/s/1C1rPukLMIQ0MC4CPs8l0AQ?pwd=8888) 提取码:8888


- 把网盘依赖库拉下来
- 将Binary是解压放在Demo/Binary目录中
- 选择对应的计算引擎放在Demo/Binary覆盖
- 注意这里要覆盖两次,第一次解压Binary,第二次是解压其中一个计算引擎,这两次操作都是把文件放在Demo/Binary目录覆盖
- 先Binary压缩包,再计算引擎压缩包,注意顺序不要错


# DLL依赖库部署
- 在Demo/Binary找到vcruntime这类依赖库,安装它
- 如果是OneAPI,X86,X64这类计算引擎直接使用即可
- 如果使用cuda计算引擎,在Demo/Binary找到Install_CUDA_Library.bat,运行它


by.qq600585


2025-1-22

