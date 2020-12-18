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
@class YWKeyboardButton;

typedef NS_ENUM(NSUInteger, YWKeyboardButtonPosition) {
    YWKeyboardButtonPositionLeft,
    YWKeyboardButtonPositionInner,
    YWKeyboardButtonPositionRight
};

@protocol YWKeyboardButtonDelegate <NSObject>
@optional

/**执行YWKeyboardButton内部的TouchUpInside，YES-继续执行内部的实现，NO-不需要执行*/
- (BOOL)interceptorTouchUpInside:(YWKeyboardButton *)button;

/// 是否需要点击放大效果
/// @param button 当前操作对象
- (BOOL)needDrawAmplification:(YWKeyboardButton *)button;

/// 是否需要按下变灰效果
/// @param button 当前操作对象
- (BOOL)needDownGrayEffect:(YWKeyboardButton *)button;

@end

@interface YWKeyboardButton : UIButton
@property (nonatomic, strong) NSString *input;
@property (nonatomic, strong) UIColor *keyColor;
@property (nonatomic, strong) UIColor *keyTextColor;
@property (nonatomic, strong) UIColor *keyShadowColor;
@property (nonatomic, strong) UIColor *keyHighlightedColor;
/**默认YES*/
@property (nonatomic, assign) BOOL drawShadow;
/**默认YES*/
@property (nonatomic, assign) BOOL drawAmplification;
/**按下变灰效果，默认NO*/
@property (nonatomic, assign) BOOL downGray;


/**输入框*/
@property (nonatomic, weak) id<UITextInput> textInput;

@property (nonatomic, readonly) YWKeyboardButtonPosition position;

@property (nonatomic, weak) id <YWKeyboardButtonDelegate>delegate;



@property (nonatomic, copy, nullable) UIImage *bgIconImage;

@property (nonatomic, copy, nullable) UIImage *iconImage;

@end

NS_ASSUME_NONNULL_END
