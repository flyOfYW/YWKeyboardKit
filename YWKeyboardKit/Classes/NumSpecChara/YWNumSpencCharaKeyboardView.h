//
//  YWNumSpencCharaKeyboardView.h
//  Pods-YWKeyboardKit_Example
//
//  Created by yaowei on 2020/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWNumSpencCharaKeyboardView : UIInputView
@property (nonatomic, weak, readonly) id<UITextInput> textInput;
/**是否需要按下效果*/
@property (nonatomic, assign        ) BOOL downEffect;

/// 获取UIInputViewview【字母+特殊字符】
/// @param textInput 输入框
+ (instancetype)getDefalutNumCharKeyboardView:(id<UITextInput>)textInput;
/// 获取UIInputViewview【特殊字符+字母】
/// @param textInput 输入框
+ (instancetype)getCharNumKeyboardView:(id<UITextInput>)textInput;

@end

NS_ASSUME_NONNULL_END
