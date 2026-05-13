——任务：我希望你能够仔细的先预览一下这整个项目，并生成SKILL记录

——原项目结构介绍（注意：现在你看到的项目可能已经是改进后的，稍后我会说我改了哪些东西）：
这个项目是用来做医学影像超分的，目标为输入LR 图像，输出HR 图像。
原本项目是这样做的：先只用HR数据训练一个HR 多尺度离散 vae（也就是代码中的patch_nums)，然后在离散latent上做自回归(var)。训练过程大致就是模拟一个这样的流程：
## SRVAR::inference
low_f : 1 -> transformer -> 1
1 -> 4
4 -> transformer -> 4
4 -> 9
...
256 -> transformer -> 256 ：HR（这里只是简单的提一嘴，具体你还是得看代码来仔细熟悉一下我说的内容）。





——项目结构概况：
这一个大项目包含两个小项目：
对于这两个小项目，你只需要看两个文件夹的内容：
/myvaex 多尺度VAE阶段的训练任务，项目1
/var 自回归阶段的训练任务，项目2


——我改了什么？做了哪些创新？

1.关于多尺度离散VAE
/myvaex 在干什么请看 /myvaex/.cursor/skills 文件夹，你就可以了解他，我这里总结一下，
myvaex主要是将原来的多尺度离散vae改成了多尺度连续vae（为了细节），然后又考虑了alignment，添加了stage1，stage2。
这里定义几个术语：多尺度离散vae、stage1、stage2-alignment、stage2-without-alignment。
其中stage2-without-alignment就是只有多尺度连续vae，不需要stage1的对齐，也就不需要stage1的结果。

2.关于自回归部分VAR
当前的var应该只是对离散vae做了自回归

注意自回归本来就只适用于离散VAE，因为离散VAE有码表，天然将一个embedding对应为一个key，然后对key做回归即可。

现在我使用了连续vae，如何自回归呢？这个时候我找到了一篇论文，代码在/mar中,它就是连续vae做自回归的典范，你可以先熟悉一下它是怎么做的。


我希望你做什么？
1.首先将上述两个项目review一边，将要点写入/AIcoding/skills中，其中vaex的项目要点已经在文件夹myvaex/AICoding中了，所以你不需要重复写，只需要说：
vaex的项目要点在......里即可。
2.我
