//
//  YWIdCardKeyboardView.h
//  JXNewAirRecharge
//
//  Created by yaowei on 2019/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWIdCardKeyboardView : UIInputView
@property (nonatomic, weak, readonly) id<UITextInput> textInput;
/**是否需要按下变灰效果*/
@property (nonatomic, assign        ) BOOL downGrayEffect;

/**分割线形式的键盘*/
+ (instancetype)getIdCardKeyboardDividerView:(id<UITextInput>)textInput;
/**间隔形式的键盘*/
+ (instancetype)getIdCardKeyboardShadowView:(id<UITextInput>)textInput;


@end

NS_ASSUME_NONNULL_END
