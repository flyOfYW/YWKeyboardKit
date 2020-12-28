//
//  YWInputToolbar.h
//  Pods-YWKeyboardKit_Example
//
//  Created by yaowei on 2020/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWInputToolbar : UIView

@property (nonatomic, weak,   readonly) id<UITextInput> textInput;
/**颜色*/
@property (nullable, nonatomic, strong) UIColor *toolbarBarTintColor;
/**左边的图标*/
@property (nullable, nonatomic, strong) UIImage *leftImageNormal;
/**左边的标题*/
@property (nullable, nonatomic,  copy ) NSString *leftTitleNormal;
/**左边的图标*/
@property (nullable, nonatomic, strong) UIImage *leftImageSelected;
/**左边的标题*/
@property (nullable, nonatomic,  copy ) NSString *leftTitleSelected;
/**标题栏logo*/
@property (nullable, nonatomic, strong) UIImage *logo;
/**标题*/
@property (nullable, nonatomic,  copy ) NSString *title;
/**完成*/
@property (nullable, nonatomic,  copy ) NSString *done;

/**”左边“ 点击的回调*/
@property (nullable, nonatomic,  copy ) void(^leftCall)(_Nullable id obj);

/**”完成“ 点击的回调*/
@property (nullable, nonatomic,  copy ) void(^doneCall)(_Nullable id obj);

+ (instancetype)getInputToolbar:(id<UITextInput>)textInput;

@end

NS_ASSUME_NONNULL_END
