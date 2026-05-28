我现在希望你根据以下命令来生成针对buaa服务器的指令
注意：
1.数据放在了/media/why/Raid524T/QBH/data/brats_256_t2_2021_pair_png_with_ref
2.不要使用train.sh了，直接给我写出最原始的命令，比如torchrun --nproc_per_node=1 --nnodes=1 --node_......
3.命令写入buaa_train_cmds.log
4.参数bed = local_output/stage2_gray_scale0_img_align_lr256_patch4to16_no_kl \
然后RECONSTRUCTION_DIR_NAME = reconstrction \
如果还有diagnostic，他的文件夹为diagnostics \
理想中的结构应该是
local_output/stage2_gray_scale0_img_align_lr256_patch4to16_no_kl
——reconstrction
——diagnostics
——ckpt-0.pth
——各种log.txt
——run_metadata.json(这个默认好像是在reconstrction文件夹下，可能需要改动代码？)




```bash
DATA_PATH=/home/featurize/data/brats_256_t2_2021_pair_png_with_ref \
STAGE=2 \
EXP_NAME=stage2_gray_scale0_img_align_lr256_patch4to16_no_kl \
EXP_NOTE="single-channel stage2 deterministic AE; scale0 decoded image aligned to LR pixels" \
RECONSTRUCTION_DIR_NAME=stage2_gray_scale0_img_align_lr256_patch4to16_no_kl \
IMG_CHANNELS=1 \
LR_FOLDER=LR \
HR_FOLDER=HR \
LR_IMG_SIZE=256 \
PATCH_NUMS="4 5 6 8 10 13 16" \
USE_LR_HR_ALIGNMENT=True \
ALIGNMENT_LOSS_TYPE=scale0_image \
ALIGNMENT_LOSS_WEIGHT=0.25 \
ALIGNMENT_LOSS_WARMUP_EP=0 \
STAGE2_USE_KL=False \
STAGE2_L1_WEIGHT=1.0 \
STAGE2_L2_WEIGHT=0.25 \
STAGE2_LPIPS_WEIGHT=0.25 \

DBG_NAN=True \
DISC_SPEC_NORM=False \
DISC_NORM=gn \
DISC_AUG_PROB=0.0 \
STAGE2_DISC_WEIGHT=-0.05 \
STAGE2_DISC_START_EP=1.0 \
STAGE2_DISC_WARMUP_EP=1.0 \

VAL_AND_SAVING_PER_EP=1 \
TRAIN_LOG_POINTS_PER_EPOCH=100 \
STAGE2_EP=3 \
bash train.sh
```