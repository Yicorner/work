# round 1
背景：我刚刚在服务端按照var\README.md (155-165) 训练了var，但是效果很不好，训练日志如下：
var\local_output\stdout.txt (4360-4368)，我之所以说训练效果不好，是因为在对比重建图中（也就是var\local_output\cond_and_scale[0]_dont_depend_on_LR_VAE 文件夹里的对比图（从服务断拷贝到我现在本地）完全看不出有任何训练成功的样子，不是模糊，不是不精确，是根本就是一团无意义的噪声黑白（重建图中间那一列）。
ep0000_it016799_comparison.png和ep0000_it000000_comparison.png几乎没什么区别

请帮我看看问题出在哪里，如果现在的信息不够，可以多加一些调试信息，然后我帮你运行。



注意（额外信息）：

你刚刚给我的代码commit为6a102041624f5c68ef1e96bc56516bba900f634a，在此基础上，我又有新的几个提交（主要是代码运行不起来有bug）。
分别为：
c15a13747f40f8caa88dc4e21a075be056f756a8
76fac2ebb8a4045dcc4a6caf0602010b5e7f269b
46074b4885aa266477c0e08902555e40c45bcd24 fix first scale shape issue
2e61b5e9282af9b8455d8b0a178e6a54f0481d2c basic.py:fix KeyError: '((1, 4, 4), (1, 5, 5), ...)', and other small fix

其中46074b这次提交我觉得有大问题，它直接将sos 一模一样复制了16个为了匹配输入，我觉得这明显是不对的，但是我暂时没有想到应该怎么去改进它，请你给我方案（先不要自己主动修改，可以先给我几个方案让我选，总之我觉得现在这样肯定是不行的），我不知道它会不会是导致我这次训练有问题的唯一凶手，但起码是凶手之一。
2e61b5这次提交我不知道有没有问题，请你帮我预览一下，这个commit主要是为了fix KeyError: '((1, 4, 4), (1, 5, 5), ...)'


# round 2
好的，我觉得还是先添加一下诊断补丁吧，请帮我添加，还有一个点就是我觉得现在log的频率太低了，我希望能够log的频率高一些。
注意代码的可维护性和可读性。
[如有必要]改训练脚本和skill和readme，也请修改。

我还想问一个问题，在刚刚你的回复中，什么叫做只采样 scale0 的图？采样是指？

# round 3

注意看
var\local_output\stdout.txt @stdout.txt (4897-5019) 
我按照你的说法增加了diagnostics之后又跑了var，命令如下
var\README.md @README.md (185-201) 
我发现diagnostics中的重建图的二三列都是相当模糊，完全看不出一点样子（iter8710）和（iter0）都是一样的黑白噪声。但是第四列oracle rec和原图接近。

请帮我出谋划策一下我下一步应该怎么办。

【我感觉我可能需要把 scale0 起点改成 LR-conditioned query，而不是纯 SOS 扩展。例如从 low_f 通过轻量 projection/downsample 得到 [B, 16, D] 的 scale0 query，再加 pos_start。这比当前 sos.expand(B,16,D)+pos_start 更合理，只是个例子，我对深度学习理解肯定没你深刻，如果你有更好的办法，那就用你的，如果暂时不需要改，也请说明理由。】
我的理由如下，如今16个token都是一模一样（只有pos不一样），那么它们经过transform block 之后的输出几乎也是一摸一样的（因为qkv都一样），也就是说@SRVAR.py (768-796) 这里的输出几乎也是一摸一样的。
而target 4*4，明显是不一样的。我个人认为这明显是不合理的。

