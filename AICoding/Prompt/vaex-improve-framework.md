# round 1
请先熟悉一下这个vaex的背景和功能，通过skill来熟悉应该很快。

在myvaex-Stage2中，我也想做一个修改。
目前: vaex的stage2的scale0是对齐stage1的LR latent的,我现在不想这样子对齐了，我突发奇想不想在stage2中依赖LR latent了。
当然啦，对齐还是要对齐的，只不过对齐的方法不一样了，现在对齐的方法是：直接将scale0的latent通过decoder 解码成图像，然后和LR（256*256）的分辨率 进行loss。

也就是说还是有两部分的loss，一部分是所有scale叠加在一起最终图像和HR的loss，一部分是scale0的loss。不过呢这两部分的loss如何配比，是否要schedule，我暂时就不规定了，你可以斟酌斟酌。

请你帮我完成一下这个任务，thank you！

注意你要站在我的角度来仔细思考问题，把自己当成主人公，来帮我想办法，而不只是完成任务,因为我任务说的很简略，可能也会有我没有考虑到的地方。

顺带一提，我之所以想做这么一个改变，是因为我觉得stage1的LR latent的空间和stage2的latent空间分布其实应该不一样的，强行对其可能会损害stage2的性能，因为stage2 decoder在多尺度中是共享的，如果让适配stage1Decoder的LR latent在stage2的训练中硬着让stage2的scale0对齐stage1的LR latent反而不太好。（说的比较玄学，我也不知道我感觉的对不对）

做个过程中注意：
1.更新skills
2.更新训练脚本
3.在readme中给我写一下我将要运行的命令行参数

# round 2
我现在想修改myvaex-Stage1的训练，让我的stage1使用LR（256*256）的分辨率，并且latent压缩成 4 * 4，（可以主动修改，但是默认是 4 * 4）。主动修改的变量需要在训练脚本中暴露出来。
在修改的过程中肯定会遇到网络结构的改变，需要你思考一下修改是否合理。

然后，