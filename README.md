my_ios_exercises
===

This is my iOS exercises.
***

####1.HelloWorld
重新开始学习iOS。之前接触过，但是现在已经忘得差不多了。Xcode有不少变动。

####2.CalculatorWithNib
以前差不多就学到这个程序，主要是IB的操作。另外，这个计算器有一点BUG，请无视。初次使用Auto Layout。

####3.CalculatorWithoutNib
撇开IB，手工敲代码组织界面。用到了Auto Layout的FVL。FVL很智能很强大，但写起来会得针眼。总得来说Auto Layout的编辑或编程都不是太方便。

####4.OpenGLInScrollView
UIScrollView中嵌入使用由OpenGL做渲染工作的视图。GLES没有立即模式，不好快速写例子啊。

####5.OneAndAHalfPages
这是一个稍微复杂一点的，有一定交互趣味的界面DEMO。使用hitTest，使界面上半部分的触摸操作不会触发整个界面在垂直方向的滚动。

####6.AnimateZoomingText
具有动画化缩放效果的文字。

####7.RefreshableTableView
可下拉获取新数据的列表视图，并且支持滚动至底部时自动加载余下条目的功能。

####~~8.SimpleOpenGlSprite~~
~~由于OGL ES不支持立即模式，为了方便操作，对OGL ES进行了简单的封装，实现了基本的图片渲染、缩放、3D旋转等功能。~~

```
突然发现CALayer本身就支持3D变换操作，一般的界面3D效果根本用不上OpenGL。所以这个练习的计划先废止了。
```
####9.DiaoBaoLe
碉堡了，不解释。
