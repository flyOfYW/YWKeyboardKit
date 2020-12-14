//
//  YWTipUpView.h
//  TextKeyBoard
//
//  Created by Mr.Yao on 2020/2/27.
//  Copyright © 2020 Mr.Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class YWKeyboardButton;

@interface YWTipUpView : UIView

@property (nonatomic, readonly) NSInteger selectedInputIndex;

- (instancetype)initWithKeyboardButton:(YWKeyboardButton *)button;

@end

NS_ASSUME_NONNULL_END
