//
//  YWNumPadKeyboardView.h
//  HGWisdomRoad
//
//  Created by yaowei on 2018/09/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWNumPadKeyboardView : UIInputView

@property (nonatomic, weak, readonly) id<UITextInput> textInput;
/**是否需要按下变灰效果*/
@property (nonatomic, assign        ) BOOL downGrayEffect;
/**是否只能输入有效数字【如有小数位，则保留2位数】默认NO*/
@property (nonatomic, assign        ) BOOL effectiveDigit;
/**保留几位小数，默认保留2位数*/
@property (nonatomic, assign        ) NSInteger floatDigit;

/**带有小数点圆角样式键盘*/
+ (instancetype)getDecimalKeyboardShadowView:(id<UITextInput>)textInput;
/**带有小数点分割线样式键盘*/
+ (instancetype)getDecimalKeyboardDividerView:(id<UITextInput>)textInput;

/**不带有小数点圆角样式键盘*/
+ (instancetype)getNumKeyboardShadowView:(id<UITextInput>)textInput;
/**不带有小数点分割线样式键盘*/
+ (instancetype)getNumKeyboardDividerView:(id<UITextInput>)textInput;


@end

NS_ASSUME_NONNULL_END
