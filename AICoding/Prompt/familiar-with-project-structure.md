**任务**我希望你能够仔细的先预览一下这整个项目，并生成SKILL记录（SKILL格式要规范，参考myvaex/AICoding/skills），同时做一个plan来修改var（这个任务比较复杂，需要你好好理解与思考，并权衡利弊选出最合适的方案）。

**注意**任务是在服务端跑，现在是在本地，所以你不需要跑代码，如果遇到找不到一些路径比如/home/featurize......，它们有可能也是服务端路径。

**原项目结构介绍**
（注意：现在你现在看到的项目已经是改进后的，稍后我会说我改了哪些东西）：
这个项目是用来做医学影像超分的，目标为输入LR 图像，输出HR 图像。
原本项目是这样做的：先只用HR数据训练一个HR 多尺度离散 vae（也就是代码中的patch_nums)，然后在离散latent上做自回归(var)。训练过程大致就是模拟一个这样的流程（这里只是简单的提一嘴，我说的很抽象，具体你还是得看代码来仔细熟悉一下我说的内容）：
SRVAR::inference
low_f : 1 -> transformer -> 1
1 -> 4
4 -> transformer -> 4
4 -> 9
...
256 -> transformer -> 256 ：HR（这里只是简单的提一嘴，我说的很抽象，具体你还是得看代码来仔细熟悉一下我说的内容）。





**项目结构概况：** 
这一个大项目包含两个小项目：
对于这两个小项目，你只需要看两个文件夹的内容：
/myvaex 多尺度VAE阶段的训练任务，项目1
/var 自回归阶段的训练任务，项目2


**我改了什么？做了哪些创新？**

1.关于多尺度离散VAE
/myvaex 在干什么请看 /myvaex/.cursor/skills 文件夹，你就可以了解他，我这里总结一下，
myvaex主要是将原来的多尺度离散vae改成了多尺度连续vae（为了细节真实性），然后又考虑了alignment，添加了stage1，stage2。
这里定义几个术语：多尺度离散vae、stage1、stage2-alignment、stage2-without-alignment。
其中stage2-without-alignment就是只有多尺度连续vae，不需要stage1的对齐，也就不需要stage1的结果。可以看看代码和SKILL仔细了解一下。

2.关于自回归部分VAR
当前的var应该只是对HR离散vae做了自回归，做完自回归之后，我们只需要训练好low_f : 1 -> transformer -> 1，就可以1->4->9->16......这样推理下去了，请自行看代码了解现在的var是怎么训练和推理的。




**我希望你做什么？** 
1.首先将上述两个项目review一边，将要点写入/AIcoding/skills中，其中vaex的项目要点已经在文件夹myvaex/AICoding中了，所以你不需要重复写，只需要软链接即可。var的项目信息写在var/AICoding/skills中，然后也软链接到大仓库work内部。
2.我想要将var中的离散vae改成连续vae。
注意自回归本来就只适用于离散VAE，因为离散VAE有码表，天然将一个embedding对应为一个key，然后对key做回归即可。
现在我使用了连续vae，如何自回归呢？这个时候我找到了一篇论文，代码在/mar中,它就是连续vae做自回归的典范，你可以先熟悉一下它是怎么做的。然后做一个plan（光是这个任务就已经很复杂了我认为,做好了plan也请给我详细讲讲，让我明白）。
3.完善项目其他部分，要求如下：
要求1：生成var/README.md和var/train.sh（参考myvaex/README.md 和 myvaex/train.sh)
要求2：训练脚本，需要指定stage2生成的ckpt路径。
要求3：其他参数你看着写，重要的参数都需要在train.sh套壳，例如
PATCH_NUMS_STR、
EXP_NAME、
EXP_NOTE、
EP、
VAL_AND_SAVING_PER_EP、
RECON_MAX_SAMPLES、
RECON_SAVE_INTERVAL、
RECON_DIR_NAME、
之类的，我暂时就想到这么到，不过加的不完整之后可以再改问题也不大。
要求4：var也需要和myvaex一样，每一次打印的时候都要生成一下对比图，参考myvaex的save_reconstruction_comparison，然后run_metadata.json文件也需要。
要求5：每次打印信息的时候需要输出PSNR，SSIM，如果有其他重要指标也请输出。



**我自己还没搞明白的疑问** 

疑问1：stage1的ckpt是否需要？Idk，需要你帮我看看。
如果需要，那么就是直接将low_f通过stage1的ckpt转化成latent，然后自回归生成后面的内容。
如果不需要也可以，那么就是在var中再次训练将low_f编码使其与stage2的scale1对齐，我觉得可以，因为stage2的scale1的结果和stage1的结果是对齐的，而且现成的代码好像本来就是这么写的，所以如果按照后者应该不需要改很多代码，按照前者的话需要改很多代码，我的理解对吗？你先仔细看看代码理解一下我说的，我相信以你的理解水平是可以的。
你帮我权衡利弊之下选择一个方案即可（哪个效果你觉的会好？）

疑问2：现在的数据集中有LR和LR_64*64,其中LR是256*256，是由LR_64*64三次插值得到的，所以它们蕴含的信息应该是LR_64*64 > LR。我该用哪个？我也不清楚，目前stage1用的是LR_64*64，因为64下采样16倍latent刚好是4，可以作为scale1，但是var现在版本用的是LR，有点没匹配，我不知道应该怎么改。
我看了一下var应该有两个地方可以用到LR，
一个是low_f : 1 -> transformer -> 1
1 -> 4
4 -> transformer -> 4
4 -> 9训练/推理的时候
另一个地方是crossattention的时候low_f会作为条件进来。

我现在在想的是stage1用的数据和var的用的LR数据用同样的数据吗（要么LR要么LR_64*64）？
还是说var训练过程中使用的LR可以和stage1可以不一样，因为毕竟只是通过一个三线性插值得到的，它们的信息应该是差不多的。我不懂。
应该需要增加一个参数来指定LR文件夹吧（maybe）


其他点可能我还没考虑到，需要你自己帮我看看并落实一下plan之后或许你能够发现新的问题，如果有疑问或者思考，请告诉我。

加油！虽然这个任务比较复杂，但是我相信你能够完成这个任务的！

