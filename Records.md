# WorkingAndThinkingRecords

# 训练

## srvar::forward
背景：srvar::forward 返回一个BLV，然后做交叉熵loss
TODO：不改forward，直接在train_step里面加一个loss = diffloss(z, target, mask)
即可，其中mask全1，表示都需要预测。
TODO2:以后可能还可以加个mask，训练核心是transformer的能力，如果有mask会不会更好（现在相当于全部是需要预测的），搞几个不需要预测的，然后让它学需要预测的。不需要预测的怎么搞？那肯定是真实值啦。参考计算loss的真实值。

训练逻辑（这个我老是忘记，在这里写一下）：
1, 2, 3, 4
|  |  |  | transformer
a, b, c, d
a->2, b->3, c->4


2,3,4就是x_BLC_wo_prefix

## srvar::autoregressive_infer_cfg
inference的逻辑其实也和上面差不多
1, 2, 3, 4
|  |  |  | transformer
a, b, c, d
a->2, b->3, c->4

什么是transformer输入的BLV？其实BLV就是embedding，但是我有一个点倒是很奇怪，
BLV -> transformer ->BLV
BLV -> get_logits, 然后与idx做loss？没办法，看了一下好像确实tokenizer是先有idx再有embedding的。

BLV是怎么来的？

img      ->      gt_idx_Bl_super    ->   x_BLCv_wo_first_l_super->BLV
     img_to_idxBl            idxBl_to_var_input

我想看看
f = self.quant_conv(self.encoder(inp_img_no_grad))
这个就叫f

f_hat是量化之后的f

由于tokenizer是基于量化的，所以我这样会有点问题，还是得先实现一个不基于量化版本的var tokenizer

如何实现非量化版本的tokenizer？

已经实现：还增加了LR alignment。


