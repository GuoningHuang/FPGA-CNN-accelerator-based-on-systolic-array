# AI-accerator-based-on-systolic-array
2023集创赛国二，紫光同创杯。基于脉动阵列写的一个简单的卷积层加速器，支持yolov3-tiny的第一层卷积层计算，可根据FPGA端DSP资源灵活调整脉动阵列的结构以实现不同的计算效率。
# 代码结构
sources目录下是ip核和代码，sim目录下是仿真文件，coe目录下是rom例化需要的coe文件。
# 加速器设计思路
![image](https://github.com/odin2985/AI-accerator-based-on-systolic/assets/75004653/10ae2238-bd6b-4936-9ee7-ad46464fcef3)
这个AI加速器是我们作品中的一个模块，输入的HDMI数据会输入到AI加速器单元，计算完量化yolov3tiny模型的第一层，包含一次卷积+LeakReLU+max pooling操作，随后将结果经过PCIE传回PC主机，PC主机利用GPU和PCIE采集的FPGA计算结果，完成剩下的模型运算步骤，实现目标检测。
