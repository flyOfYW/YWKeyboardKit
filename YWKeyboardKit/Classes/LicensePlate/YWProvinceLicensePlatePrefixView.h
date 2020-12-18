//
//  YWProvinceLicensePlatePrefixView.h
//  NMChangJieCloud
//
//  Created by yaowei on 2018/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWProvinceLicensePlatePrefixView : UIInputView

@property (nonatomic, weak,readonly) id<UITextInput> textInput;
/// 只有省份的键盘
/// @param textInput 输入框
+ (instancetype)getDefalutProvinceKeyBoardView:(id<UITextInput>)textInput;

@end

NS_ASSUME_NONNULL_END
