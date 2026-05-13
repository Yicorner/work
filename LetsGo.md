# Get my thoughts in order

## how we inference
without flex_atten, use_ref, use_diff



## idxBl_to_var_input
input : gt_ms_idx_Bl : ([B, 1], [B, 4], ... , [B, 256])

next_scales = []
H, W = v_patch_nums[-1]
SN = len(v_patch_nums)

f_hat = [B, C, H, W] all zero
pn_next : v_patch_nums[0]

for si in range(SN - 1)
    self.embedding(gt_ms_idx_Bl[si]) [B, l, self.Cvae]
    .transpose_(1, 2).view(B, C, pn_next, pn_next) [B, self.Cvae, ., .]
    h_BChw = F.interpolate(above, (H, W))
    f_hat.add(phi(h_BChw))
    pn_next = self.v_patch_nums[si+1]
    next_scales.append(F.interpolate(f_hat, size=(pn_next, pn_next))) // 1～n个patch生成第n+1个patch

return next_scales //torch.Size([4, 679, 32])

## img_to_idxBl


## SRVAR::inference
low_f : 1 -> transformer -> 1
1 -> 4
4 -> transformer -> 4
4 -> 9
...
256 -> transformer -> 256

etc...