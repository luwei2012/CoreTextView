# CoreTextView

[![CI Status](http://img.shields.io/travis/1071932819@qq.com/CoreTextView.svg?style=flat)](https://travis-ci.org/1071932819@qq.com/CoreTextView)
[![Version](https://img.shields.io/cocoapods/v/CoreTextView.svg?style=flat)](http://cocoapods.org/pods/CoreTextView)
[![License](https://img.shields.io/cocoapods/l/CoreTextView.svg?style=flat)](http://cocoapods.org/pods/CoreTextView)
[![Platform](https://img.shields.io/cocoapods/p/CoreTextView.svg?style=flat)](http://cocoapods.org/pods/CoreTextView)
vertical label 效果预览：

![vertical label 效果预览](https://github.com/luwei2012/CoreTextView/blob/master/releaseV1.1.png)

支持字体、行数、文字颜色、行间距和字符间距的设置。

支持居中，上下左右组合对齐，阅读方向为从右到左。

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

1.将CoreTextView的.h和.m文件加入你自己的工程。(你可以选择使用pod添加或者直接下载后添加 推荐使用pod 保持更新)

2.在你的布局文件中拖放一个UIView来代替UILabel，布局约束跟使用正常的UILabel控件一样。

3.将UIView的关联class设置为CoreTextView。

4.关联你的布局文件和Class文件，得到UIView的IBOutlet对象verticalLabel.

5.设置字体、行数、文字颜色和行间距等属性

## Requirements

platform :ios, '7.0'

## Installation

CoreTextView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CoreTextView"
```
# V1.0特性:

添加了文字对其的属性，支持居中，上下左右组合对齐，具体效果大家可以在demo里面通过设置
self.testLabel.baseLine = CoreTextBaseLineRight | CoreTextBaseLineBottom;查看。
居中显示的时候感觉中间的矩形区域计算不太准确，具体改进目测还需要研究下IOS的绘制特性，应该跟行间距有关。

# V1.1特性
修改了文本计算的方法，整个项目的核心就是这块，到目前为止我都还能保证这个算法是正确的，不过在我的项目里已经够用了
1.添加了字间距设置
2.修改了1.0版本布局对其不准确的bug

# To do
增加缩率符号的显示

## Author

1071932819@qq.com, luwei4685

## License

CoreTextView is available under the GNU license. See the LICENSE file for more info.
