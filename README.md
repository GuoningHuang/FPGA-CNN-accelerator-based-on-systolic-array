# AI-accerator-based-on-systolic-array
2023集创赛国二，紫光同创杯。基于脉动阵列写的一个简单的卷积层加速器。纯Verilog。支持yolov3-tiny的第一层卷积层计算。可根据FPGA端DSP资源灵活调整脉动阵列的结构以实现不同的计算效率。  
# 代码结构
sources目录下是ip核和代码，sim目录下是仿真文件，coe目录下是rom例化需要的coe文件。
# 加速器设计思路
![image](https://github.com/odin2985/AI-accerator-based-on-systolic/assets/75004653/10ae2238-bd6b-4936-9ee7-ad46464fcef3)  
这个AI加速器是我们作品中的一个模块，输入的HDMI数据会输入到AI加速器单元，计算完量化yolov3tiny模型的第一层，包含一次卷积+LeakReLU+max pooling操作，随后将结果经过PCIE传回PC主机，PC主机利用GPU和PCIE采集的FPGA计算结果，完成剩下的模型运算步骤，实现目标检测。
# 加速器具体设计
AI加速器主要包括，图像缓冲，权重缓冲，乘加操作计算单元，激活函数计算单元以及池化计算单元等部分。设计框图如图所示：
![image](https://github.com/odin2985/AI-accerator-based-on-systolic/assets/75004653/cc61ed47-8035-47d7-9df7-1be32338c7fb)  
图中的卷积模块由图像缓冲模块，权重缓冲模块和计算模块组成，图像缓冲模块负责缓冲三行特征图数据和输出9个的3×3卷积核计算的特征图的值，权重缓冲模块负责输入两个卷积核的值，PE模块负责计算一个3×3的卷积核卷积一次的值。当缓冲模块存入三行数据的同时，会读出数据送入计算模块进行计算，此时输入的两个卷积核算完三行图像的卷积操作后，更换下两个卷积核进行计算，同时对RAM的读地址归零，重新读取RAM中的三行数据计算卷积，以此往复，算完所有16个卷积核后，下三行数据到来，以此往复。
例化三个卷积模块，分为对图像的RGB三个分量进行卷积，即将每个卷积核的第三维拆分开给三个独立的卷积模块进行并行计算，随后将三个分量的卷积结果累加即得到卷积核的最后累加结果。随后将累加结果与bias相加，经过后续模块计算，即得到最终计算结果。
## 数据输入
HDMI传入的图像是1920×1080p，输入yolo的图像大小是480×256。1920×1080先缩放成480×270，然后去掉最后面14行数据就变成480×256.HDMI的图像数据是一行一行到，行的缩放就只需要间隔4个值采样，列的缩放就是每隔四行取一行。输入加速器的数据是一行一行输入。
在进行卷积操作时，我们需要将开窗得到的如3X3大小的局部图像数据与卷积核进行卷积运算，从而完成处理，这个过程我们使用了行缓冲结构（如图所示）。行缓冲结构由三个FIFO组成，有一个数据输入接口和三个数据输出接口，输入三行数后，在第四行数据进行输入时，输出的三个接口将会输出缓存前三行数据，一个时钟周期输出一列的三个数，依次类推，在第五行数据输入时，输出接口将会依次输出第2，3，4行的三个数。
![image](https://github.com/odin2985/AI-accerator-based-on-systolic/assets/75004653/0fd034f1-fecb-4c11-a093-a4d70bf0cd99)  
我们所加速的模型的卷积核大小为3*3，我们每次需要从特征图中同时取出九个数进行计算，因此我们使用了9个假双端口RAM进行数据缓冲，一个端口负责读数据，另一个端口负责写数据。写数据时，每次将行缓冲输出的3个数据分别写到9个RAM里，每3个RAM写入一个同样的数据（即这3个RAM存储同一行数据），在输出三次后，即可得到一张完整的特征图，此时开始从RAM中读取数据，只需将读取的地址错开，即可读出待卷积的9个数据。

![image](https://github.com/odin2985/AI-accerator-based-on-systolic/assets/75004653/e7713776-fe73-48d8-ae08-7205c61f7505)  
再对9个数据进行延时操作以匹配脉动阵列的计算过程，即可输出至计算单元中进行计算。
## 权重缓重模块
权重缓冲模块存储了对应待卷积层的权重，使用一个ROM实现，事先将权重数据写成dat文件烧录进ROM中即可。
由于我们的计算单元一次课有计算两个卷积核，每个卷积核的一维有9个数，因此，一共有18个数据需要输出，我们将18个数据拼接成一个二进制数据，读出后将其切片赋值给18个变量，即可输出卷积核数据。
当三行特征图的卷积操作算完后，需要更换卷积核并进行重新读取特征图进行计算，得到特征图算完的信号后，我们会更换下两个卷积核数据，以此往复，即可完成所有16个卷积核的一维累加计算。
## 乘加操作计算单元
在这个单元中我们使用了脉动阵列结构，Google的TPU中使用了这种结构，此结构相比于乘法树，使用了更少的FPGA资源，同时便于拓展，可以通过配置不同的列数来控制每次计算的卷积核个数，因此我们使用这种结构进行乘法累加计算。脉动阵列的每个PE计算单元如图所示，实现的计算为P = F*W+C。

我们搭建的脉动阵列计算单元如图所示，F1-F9为待卷积的特征图数据，数据缓冲模块中已经将9个特征图数据通过延时的方式输入，F1与W01计算完后，结果输入到下一个PE的中，与F2*W02的结果相加，依次让数据往下流动，即可实现一个卷积核的一次计算。我们将F同时输入到两个卷积核中，以此实现同时对两个卷积核的计算，可以并行的输出对两个卷积核的计算结果。
![image](https://github.com/odin2985/AI-accerator-based-on-systolic/assets/75004653/0fae9ed7-dfe7-46dc-a830-92289224820c)  
计算单元结构示意
## 池化计算单元
池化计算包括平均池化和最大池化的等，我们需要加速的神经网络中使用的是最大池化，步长是2，池化大小也是2，即每四个格子取最大值，计算方式如图所示，经过分析，我们发现此过程可以使用行缓存机制实现。
池化过程可以拆解为两个步骤，第一个步骤是每行的相邻两个数取最大值，池化前的数据输入是480*256，池化后即变成240*256。我们只需例化一个寄存器暂存两个值中的一个，待下一个数据到来时，比较大小，大的数输出即可。第二个步骤是每列的相邻两个数取最大值，这个过程我们使用行缓冲机制实现，行缓冲依次输出两行的值，取两个值中的最大值，并且让每两行相互比较，例如一开始输出1，2行，此时比较取最大值，接着行缓冲输出2，3行的时候，暂停比较，待3，4行来的时候再进行比较。这样，我们就完成了池化模块的设计。

