//
//  YWInputToolbar.h
//  Pods-YWKeyboardKit_Example
//
//  Created by yaowei on 2020/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWInputToolbar : UIToolbar


@property (nonatomic, weak,   readonly) id<UITextInput> textInput;

@property (nullable, nonatomic, strong) UIColor *toolbarBarTintColor;

@property (nullable, nonatomic,  copy ) NSString *title;

@property (nullable, nonatomic,  copy ) NSString *done;


+ (instancetype)getInputToolbar:(id<UITextInput>)textInput;

@end

NS_ASSUME_NONNULL_END
