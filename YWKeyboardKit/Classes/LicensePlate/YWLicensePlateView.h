//
//  YWLicensePlateView.h
//  NMChangJieCloud
//
//  Created by yaowei on 2018/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWLicensePlateView : UIInputView

@property (nonatomic, weak, readonly) id<UITextInput> textInput;

/// 英文中文[车牌省份编码]切换键盘
/// @param textInput 输入框
+ (instancetype)getEnglishOrProvinceLicensePlate:(id<UITextInput>)textInput;

/// 中文[车牌省份编码]或英文字母换键盘
/// @param textInput 输入框
+ (instancetype)getProvinceOrEnglishLicensePlate:(id<UITextInput>)textInput;


/// 手动切换至英文键盘
- (void)showEnglishNumView;

/// 手动切换至省份键盘
- (void)showProvinceView;
@end

NS_ASSUME_NONNULL_END
