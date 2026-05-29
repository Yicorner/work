## partial mask
背景：srvar::forward 返回一个BLV，然后做交叉熵loss
idea1：直接在train_step里面加一个loss = diffloss(z, target, mask)
即可，其中mask全1，表示都需要预测。
idea2:以后可能还可以加个mask，训练核心是transformer的能力，如果有mask会不会更好（现在相当于全部是需要预测的），搞几个不需要预测的，然后让它学需要预测的。不需要预测的怎么搞？那肯定是真实值啦。参考计算loss的真实值。



