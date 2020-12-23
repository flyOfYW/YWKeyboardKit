# YWKeyboardKit

[![CI Status](https://img.shields.io/travis/yw/YWKeyboardKit.svg?style=flat)](https://travis-ci.org/yw/YWKeyboardKit)
[![Version](https://img.shields.io/cocoapods/v/YWKeyboardKit.svg?style=flat)](https://cocoapods.org/pods/YWKeyboardKit)
[![License](https://img.shields.io/cocoapods/l/YWKeyboardKit.svg?style=flat)](https://cocoapods.org/pods/YWKeyboardKit)
[![Platform](https://img.shields.io/cocoapods/p/YWKeyboardKit.svg?style=flat)](https://cocoapods.org/pods/YWKeyboardKit)



简介
==============
-  车牌键盘
-  身份键盘
-  数字键盘【支持小数点以及是否有效数字、小数点位数设置】
-  安全键盘
-  26个字母和特殊字符键盘【密码键盘】

## Installation

YWKeyboardKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YWKeyboardKit'//包含所有的键盘
pod 'YWKeyboardKit/LicensePlate'//只引入车牌键盘
pod 'YWKeyboardKit/IdCard'//只引入身份键盘
pod 'YWKeyboardKit/NumPad'//只引入数字键盘
pod 'YWKeyboardKit/NumChar'//只引入字母和特殊符号键盘

```

## 效果图
<img src="https://github.com/flyOfYW/YWKeyboardKit/blob/master/image_re/id_card_1%402x.png" width="200" height="120"><img src="https://github.com/flyOfYW/YWKeyboardKit/blob/master/image_re/id_card_2%402x.png" width="200" height="120"><img src="https://github.com/flyOfYW/YWKeyboardKit/blob/master/image_re/plate_1%402x.png"   width="200" height="141"><img src="https://github.com/flyOfYW/YWKeyboardKit/blob/master/image_re/plate_2%402x.png"   width="200" height="148"><img src="https://github.com/flyOfYW/YWKeyboardKit/blob/master/image_re/plate_3%402x.png"   width="200" height="145"><img src="https://github.com/flyOfYW/YWKeyboardKit/blob/master/image_re/num_pad_1%402x.png"   width="200" height="131"><img src="https://github.com/flyOfYW/YWKeyboardKit/blob/master/image_re/num_pad_2%402x.png"   width="200" height="139"><img src="https://github.com/flyOfYW/YWKeyboardKit/blob/master/image_re/num_char1%402x.png"   width="200" height="139"><img src="https://github.com/flyOfYW/YWKeyboardKit/blob/master/image_re/num_char2%402x.png"   width="200" height="139">


## Example

```
//前缀车牌键盘
UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 80   , 34)];
tf.placeholder = @"前缀车牌";
tf.inputView = [YWProvinceLicensePlatePrefixView getDefalutProvinceKeyBoardView:tf];
[self.view addSubview:tf];

//省份汉子和字母数字可随意切换的键盘
UITextField *tf2 = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, 200   , 34)];
tf2.placeholder = @"一行输入车牌";
tf2.inputView = [YWLicensePlateView getProvinceOrEnglishLicensePlate:tf2];
[self.view addSubview:tf2];


//身份证输入键盘
UITextField *tf4 = [[UITextField alloc] initWithFrame:CGRectMake(190, 180, 160   , 34)];
tf4.placeholder = @"身份证键盘";
__block  YWIdCardKeyboardView *idCardKeyboardShadowView = [YWIdCardKeyboardView getIdCardKeyboardShadowView:tf4];
tf4.inputView = idCardKeyboardShadowView;
YWInputToolbar *toolbar2 = [YWInputToolbar getInputToolbar:tf4];
toolbar2.leftImageNormal = [UIImage imageNamed:@"icon_eye"];
toolbar2.leftImageSelected = [UIImage imageNamed:@"icon_eyeclose"];
toolbar2.title = @" 身份证专用键盘";
if (@available(iOS 13.0, *)) {
    toolbar2.logo = [[UIImage systemImageNamed:@"applelogo"] imageWithTintColor:[UIColor systemBlueColor]];
}
toolbar2.leftCall = ^(id  _Nullable obj) {
    idCardKeyboardShadowView.downGrayEffect = !idCardKeyboardShadowView.downGrayEffect;
};
tf4.inputAccessoryView = toolbar2;
[self.view addSubview:tf4];

```

### 版本更新记录
#### v0.1.6
- 【新增】: 26个字母和特殊符号组合键盘。
- 【新增】: 避免多个键同时被点击。
- 【修复】: 修复暗黑模式适配图标的bug。
#### v0.1.5
- 【新增】: 长按删除效果。
#### v0.1.4
- 【新增】: 数字键盘。
- 【新增】: 自主控制数字的有效性。
- 【新增】: 自主控制小数点的位数。
#### v0.1.3
- 【修复】: 修复在iOS 14.2 不追踪点击效果无效的bug。
#### v0.1.2
- 【新增】: 从项目中整理抽取身份证输入键盘。
- 【新增】: 键盘上的toolbar。
- 【新增】: 点击效果(支持外设)。
#### v0.1.1
- 【新增】: 键盘上的toolbar。
#### v0.1.0
- 【新增】: 从项目中整理抽取车牌键盘。


## Author

yw, 1498627884@qq.com

## License

YWKeyboardKit is available under the MIT license. See the LICENSE file for more info.
