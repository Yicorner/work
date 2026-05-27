# 现在有一个比较复杂的任务需要你去完成。
# 任务总体描述：myvaex与var的训练过程以及框架的改进。

# myvaex
新增stage3
## stage3作用：
将LR_folder 中的图像压缩到n*n latent（默认4 * 4），使其对齐于stage2 ALIGNMENT_LOSS_TYPE=scale0_image时的scale 0 latent。
## 需要注意的点：
1.n可调节，需要通过训练脚本暴露出来这个变量。
2.scale 0 latent的形态必须和n一样(需要加assert断言)。
3.这一阶段中只需要训练encoder即可，不需要训练decoder，普通的AE即可，要求精确性，不用kl。
4.损失函数我还没想好怎么设计，需要你帮我设计一个合理的损失函数，要求精确性。
5.需要stage2的ckpt作为赋值并frozen，也通过脚本来暴露。
6.为了防止过拟合，需要帮我写一个脚本来对test文件夹中的图像进行测试，就像eval_stage1_ckpt.py一样，来验证latent对齐的效果好不好。
7.改动的过程中要保持兼容性，不要把之前的东西都改掉了。


# var
新增arg选项来控制训练流程。
## 目前的训练流程： 
当前训练过程中，起点sos是这样计算的：sos = self._build_scale0_queries(sos, low_f_BLC, scale_schedule)
如果将sos是4*4(s0)，那么训练过程中transformer的流程是（ ->表示transformer ）
s0(from low_f) -> s0(pred)        与s0(gt) 做loss
s1(interpolate from s0_gt) -> s1(pred)        与s1(gt) 做loss
s2(interpolate from s1_gt) -> s2(pred)        与s2(gt) 做loss
依次类推
除此之外还有cond_BD = self.low_proj_for_sos((kv_compact, cu_seqlens_k, max_seqlen_k)).float().contiguous()作为crossattn
## 我现在打算的训练流程：
直接有 s0(pred)（from ckpt-stage3）      不与s0(gt) 做loss
s1(interpolate from s0_pred) -> s1(pred)      与s1(gt) 做loss
s2(interpolate from s1_gt) -> s2(pred)        与s2(gt) 做loss
s3(interpolate from s2_gt) -> s3(pred)        与s3(gt) 做loss
## 需要注意的点：
1.只有s1是interpolate from s0_pred，其他都是from gt
2.虽然s0(pred)不需要经过transfomer了，但是我觉得有必要让transfomer中的token都能看到它。
具体方法有
a.让它作为crossattn，原来的cond_BD就不再使用了，直接使用s0(pred)（from ckpt-stage3） 作为crossattn的kv。
b.在self-attn中把s0的token还是放入x_BLC的开头，只不过s0本身的transformer的输出不去使用它作为loss。
你帮我斟酌一下哪个方法好，我个人认为这两个效果是一样的，感觉可以都用上哩。
3.我发现现在的多尺度vae步骤会比较复杂。我总结一下是这样的：
img(HR) ->- encoder -> quant_conv -> latent(16 * 16)
latent(16 * 16) -> interpolate -> latents0(4 * 4)
latents0(4 * 4) -> mean_and_logvar_conv -> latents0_2(4 * 4) 
latents0_2(4 * 4) -> interpolate -> latents0_2(16 * 16)
latents0_2(16 * 16) -> quant_resi_conv -> latents0_3(16 * 16)
latents0_3(16 * 16) -> interpolate -> latents0_3(4 * 4)
latents0_3(4 * 4) -> quant_conv -> decoder -> 应该与img(LR)比较接近，因为 latents0_3(4 * 4)的含义就是4倍缩小的语义信息，应当是理所当然解码出4倍模糊的图像。
所以你在写代码的时候务必要非常清晰当前是哪个latent，到底是哪个latent做的自回归。对齐的又是哪个，这个我目前也没搞的特别明白

## 当然啦，改了训练流程，还有inference的流程需要修改。
这一块我相信刚刚的信息对你来说已经足够知道怎么改了，就不多少了

# 最后需要注意的点：
1.注意你要站在我的角度来仔细思考问题，把自己当成主人公，来帮我想深度思考方案的合理性与可改进的地方，而不只是完成任务，如果觉得不合理，也请指出。
2.更新skills
3.更新训练脚本
4.在readme中给我写一下我将要运行的命令行参数。
5.为了兼容性，很多地方可以加个参数控制，而不是直接修改。
6.为了训练速度，如果存在更高效的写法，也请修改，比如可以结果可以多次使用之类的，能够省点时间就省点时间。
7.添加必要的诊断信息，比如var的多级重建图（diagnostic文件夹可供你使用，诊断的图像都放这）。
