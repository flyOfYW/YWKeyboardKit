//
//  YWKeyboardButton.h
//  TextKeyBoard
//
//  Created by Mr.Yao on 2020/2/27.
//  Copyright © 2020 Mr.Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

//刘海屏底部的高度
#define YW_KEYBOARD_TABBARBOTTOM ({\
CGFloat isBangsScreen = 0; \
if (@available(iOS 11.0, *)) { \
UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
isBangsScreen = window.safeAreaInsets.bottom; \
} \
isBangsScreen; \
})



NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YWKeyboardButtonPosition) {
    YWKeyboardButtonPositionLeft,
    YWKeyboardButtonPositionInner,
    YWKeyboardButtonPositionRight
};

@protocol YWKeyboardButtonDelegate <NSObject>
@optional
/**执行YWKeyboardButton内部的TouchUpInside，YES-继续执行内部的实现，NO-不需要执行（YES:输入字符，NO-不需要输入字符）*/
- (BOOL)interceptorTouchUpInside:(UIButton *)button;

/// 是否需要点击放大效果
/// @param button 当前操作对象
- (BOOL)needDrawAmplification:(UIButton *)button;

/// 是否需要按下变灰效果
/// @param button 当前操作对象
- (BOOL)needDownGrayEffect:(UIButton *)button;

/// 按下的回调
/// @param button 当前操作对象
- (void)handleTouchDownForState:(UIButton *)button;

@end

@protocol YWKeyboardButtonDataSource <NSObject>
@optional
/**是否录入有效数字,0-可以随意输入，1-保留一位小数点的有效数字，n-保留n位小数点的有效数字*/
- (NSInteger)isEffectiveDigitForInput:(UIButton *)button;


@end





@interface YWKeyboardButton : UIButton

@property (nonatomic, strong) NSString *input;
/**normal  selected 不一致*/
@property (nonatomic, strong) NSString *inputSelected;
/**键盘颜色*/
@property (nonatomic, strong) UIColor *keyColor;
/**键盘上的文字颜色*/
@property (nonatomic, strong) UIColor *keyTextColor;
/**底部边距线颜色*/
@property (nonatomic, strong) UIColor *keyShadowColor;
/**按下效果颜色*/
@property (nonatomic, strong) UIColor *downGrayEffectColor;
/**默认YES*/
@property (nonatomic, assign) BOOL drawAmplification;
/**输入框*/
@property (nonatomic, weak) id<UITextInput> textInput;

@property (nonatomic, readonly) YWKeyboardButtonPosition position;

@property (nonatomic, weak) id <YWKeyboardButtonDelegate>delegate;

@property (nonatomic, copy, nullable) UIImage *bgIconImage;

@property (nonatomic, copy, nullable) UIImage *iconImage;

/// 获取当前的文字，由于加入了大小字母
- (NSString *)getCurrentInputText;
@end


@interface YWKeyboardDownButton : UIButton

@property (nonatomic, strong) NSString *input;
/**键盘颜色*/
@property (nonatomic, strong) UIColor *keyColor;
/**键盘上的文字颜色*/
@property (nonatomic, strong) UIColor *keyTextColor;
/**底部边距线颜色*/
@property (nonatomic, strong) UIColor *keyShadowColor;
/**按下效果颜色*/
@property (nonatomic, strong) UIColor *downGrayEffectColor;
/**默认YES*/
@property (nonatomic, assign) BOOL drawShadow;
/**按下变灰效果，默认NO*/
@property (nonatomic, assign) BOOL downGray;
/**特定不需要点击效果*/
@property (nonatomic, assign) BOOL specificNoDown;

/**输入框*/
@property (nonatomic, weak) id<UITextInput> textInput;

@property (nonatomic, weak) id <YWKeyboardButtonDelegate>delegate;

@property (nonatomic, weak) id <YWKeyboardButtonDataSource>dataSource;

@property (nonatomic, copy, nullable) UIImage *bgIconImage;

@property (nonatomic, copy, nullable) UIImage *iconImage;


@end


NS_ASSUME_NONNULL_END
