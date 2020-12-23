//
//  YWKeyboardButton.m
//  TextKeyBoard
//
//  Created by Mr.Yao on 2020/2/27.
//  Copyright © 2020 Mr.Yao. All rights reserved.
//

#import "YWKeyboardButton.h"
#import "YWTipUpView.h"


@interface YWKeyboardButton ()
{
    struct {
        unsigned inTouchUpInside : 1;
        unsigned amplification : 1;
        unsigned touchDownForState : 1;
    } _delegateHas;
    
}
@property (nonatomic, strong            ) YWTipUpView *buttonView;
@property (nonatomic, readwrite         ) YWKeyboardButtonPosition position;

@end

@implementation YWKeyboardButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
//手指按下按钮的事件
- (void)handleTouchDown{
    [[UIDevice currentDevice] playInputClick];
    if (_delegateHas.touchDownForState) {
        [_delegate handleTouchDownForState:self];
    }
    if ([self isDrawAmplification]) {//放大效果
        [self showInputView];
    }
}
- (void)handleTouchUpInside{
    BOOL isContinue = YES;
    if (_delegateHas.inTouchUpInside) {
        isContinue = [_delegate interceptorTouchUpInside:self];
    }
    if (!isContinue) return;
//    [self insertText:self.input];
    [self insertText:[self getCurrentInputText]];
    if ([self isDrawAmplification]) {
        [self hideInputView];
    }
}
- (void)showInputView{
    [self hideInputView];
    self.buttonView = [[YWTipUpView alloc] initWithKeyboardButton:self];
    [self.window addSubview:self.buttonView];
}

- (void)hideInputView{
    [self.buttonView removeFromSuperview];
    self.buttonView = nil;
    [self setNeedsDisplay];
}

- (void)insertText:(NSString *)text{
    BOOL shouldInsertText = YES;
    
    if ([self.textInput isKindOfClass:[UITextView class]]) {
        // Call UITextViewDelegate methods if necessary
        UITextView *textView = (UITextView *)self.textInput;
        NSRange selectedRange = textView.selectedRange;
        
        if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            shouldInsertText = [textView.delegate textView:textView
                                   shouldChangeTextInRange:selectedRange
                                           replacementText:text];
        }
    } else if ([self.textInput isKindOfClass:[UITextField class]]) {
        // Call UITextFieldDelgate methods if necessary
        UITextField *textField = (UITextField *)self.textInput;
        NSRange selectedRange = [self textInputSelectedRange];
        
        if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            shouldInsertText = [textField.delegate textField:textField
                               shouldChangeCharactersInRange:selectedRange
                                           replacementString:text];
        }
    }
    
    if (shouldInsertText == YES) {
        [self.textInput insertText:text];
        if (text.length <= 0) {//delete 键
            [self.textInput deleteBackward];
        }
    }
}

- (NSRange)textInputSelectedRange{
    
    UITextPosition *beginning = self.textInput.beginningOfDocument;
    
    UITextRange *selectedRange = self.textInput.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    const NSInteger location = [self.textInput offsetFromPosition:beginning
                                                       toPosition:selectionStart];
    const NSInteger length = [self.textInput offsetFromPosition:selectionStart
                                                     toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)updateButtonPosition{
    
    CGFloat leftPadding = CGRectGetMinX(self.frame);
    CGFloat rightPadding = CGRectGetMaxX(self.superview.frame) - CGRectGetMaxX(self.frame);
    CGFloat minimumClearance = CGRectGetWidth(self.frame) / 2 + 8;
    
    if (leftPadding >= minimumClearance && rightPadding >= minimumClearance) {
        self.position = YWKeyboardButtonPositionInner;
    } else if (leftPadding > rightPadding) {
        self.position = YWKeyboardButtonPositionLeft;
    } else {
        self.position = YWKeyboardButtonPositionRight;
    }
}

- (void)commonInit{
    self.exclusiveTouch = YES;
    _drawAmplification = YES;
    if (@available(iOS 13.0, *)) {
        _keyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:80.0/255.f green:80.0/255.f blue:80.0/255.f alpha:1];
            }else{
                return [UIColor whiteColor];
            }
        }];
        _keyTextColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor whiteColor];
            }else{
                return [UIColor blackColor];
            }
        }];
        _keyShadowColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:45.0 / 255.f green:45.0 / 255.f blue:45.0 / 255.f alpha:1];
            }else{
                return [UIColor colorWithRed:136 / 255.f green:138 / 255.f blue:142 / 255.f alpha:1];
            }
        }];
        
        
    } else {
        _keyColor = [UIColor whiteColor];
        _keyTextColor = [UIColor blackColor];
        _keyShadowColor = [UIColor colorWithRed:136 / 255.f green:138 / 255.f blue:142 / 255.f alpha:1];
    }
        
    _downGrayEffectColor = [UIColor colorWithRed:213/255.f green:214/255.f blue:216/255.f alpha:1];
    [self setTitleColor:_keyTextColor forState:UIControlStateNormal];
    [self setTitleColor:_keyTextColor forState:UIControlStateDisabled];
    [self setTitleColor:_keyTextColor forState:UIControlStateSelected];

    //    UIControlEventTouchUpInside 先回触发 handleTouchDown ，才到 handleTouchUpInside
    [self addTarget:self action:@selector(handleTouchDown)
   forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(handleTouchUpInside)
   forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self hideInputView];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self hideInputView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateButtonPosition];
}
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = self.keyColor;
    
    UIColor *shadow = self.keyShadowColor;
    CGSize shadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat shadowBlurRadius = 0;
    
    UIBezierPath *roundedRectanglePath =
    [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 1) cornerRadius:4.f];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [color setFill];
    [roundedRectanglePath fill];
    CGContextRestoreGState(context);
}

- (void)setBgIconImage:(UIImage *)bgIconImage{
    _bgIconImage = bgIconImage;
    [self setBackgroundImage:[bgIconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[bgIconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                    forState:UIControlStateDisabled];
    [self setBackgroundImage:[bgIconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                    forState:UIControlStateSelected];
}
- (void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    [self setImage:[iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
          forState:UIControlStateNormal];
    [self setImage:[iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
          forState:UIControlStateDisabled];
    [self setImage:[iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
          forState:UIControlStateSelected];
}

- (void)setInput:(NSString *)input{
    _input = input;
    [self setTitle:input forState:UIControlStateNormal];
    [self setTitle:input forState:UIControlStateDisabled];
    [self setTitle:input forState:UIControlStateSelected];
}
- (void)setInputSelected:(NSString *)inputSelected{
    _inputSelected = inputSelected;
    [self setTitle:inputSelected forState:UIControlStateSelected];
}
- (void)setDelegate:(id<YWKeyboardButtonDelegate>)delegate{
    _delegate = delegate;
    _delegateHas.inTouchUpInside = delegate && [delegate respondsToSelector:@selector(interceptorTouchUpInside:)];
    _delegateHas.amplification = delegate && [delegate respondsToSelector:@selector(needDrawAmplification:)];
    _delegateHas.touchDownForState = delegate && [delegate respondsToSelector:@selector(handleTouchDownForState:)];
}
- (NSString *)getCurrentInputText{
    if (!_inputSelected) {
        return _input;
    }
    if (self.selected) {
        return _inputSelected;
    }
    return _input;
}
- (BOOL)isDrawAmplification{
    if (_delegateHas.amplification) {
        _drawAmplification = [_delegate needDrawAmplification:self];
    }
    //defalut is yes
    return _drawAmplification;
}
@end

//MARK: ----- YWKeyboardDownButton ---------

@interface YWKeyboardDownButton ()
{
    struct {
        unsigned inTouchUpInside : 1;
        unsigned downGary : 1;
    } _delegateHas;
    struct {
        unsigned effectiveDigit : 1;
    } _dataSourceHas;
}
@end

@implementation YWKeyboardDownButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
//手指按下按钮的事件
- (void)handleTouchDown{
    [[UIDevice currentDevice] playInputClick];
    if ([self isNeedDownGrayEffect]) {
        [self setNeedsDisplay];
    }
}
- (void)handleTouchUpInside{
    BOOL isContinue = YES;
    if (_delegateHas.inTouchUpInside) {
        isContinue = [_delegate interceptorTouchUpInside:self];
    }
    if (!isContinue) return;
        
    [self insertText:self.input];

}
- (void)insertText:(NSString *)text{
    BOOL shouldInsertText = YES;
    
    if ([self.textInput isKindOfClass:[UITextView class]]) {
        // Call UITextViewDelegate methods if necessary
        UITextView *textView = (UITextView *)self.textInput;
        NSRange selectedRange = textView.selectedRange;
        
        if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            shouldInsertText = [textView.delegate textView:textView
                                   shouldChangeTextInRange:selectedRange
                                           replacementText:text];
        }
    } else if ([self.textInput isKindOfClass:[UITextField class]]) {
        // Call UITextFieldDelgate methods if necessary
        UITextField *textField = (UITextField *)self.textInput;
        NSRange selectedRange = [self textInputSelectedRange];
        
        if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            shouldInsertText = [textField.delegate textField:textField
                               shouldChangeCharactersInRange:selectedRange
                                           replacementString:text];
        }
        NSInteger effectiveDigit = [self isEffectiveDigit];
        if (effectiveDigit != 0) {
            shouldInsertText = [self canInput:textField
                                      inRange:selectedRange
                            replacementString:text
                                    canDigits:effectiveDigit];
            if ([textField.text isEqual:@"0"] && !shouldInsertText) {
                [self.textInput deleteBackward];
                shouldInsertText = YES;
            }
        }
    }
    if (shouldInsertText == YES) {
        [self.textInput insertText:text];
        if (text.length <= 0) {//delete 键
            [self.textInput deleteBackward];
        }
    }
}

- (NSRange)textInputSelectedRange{
    
    UITextPosition *beginning = self.textInput.beginningOfDocument;
    
    UITextRange *selectedRange = self.textInput.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    const NSInteger location = [self.textInput offsetFromPosition:beginning
                                                       toPosition:selectionStart];
    const NSInteger length = [self.textInput offsetFromPosition:selectionStart
                                                     toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

/// 判断是数字有效否可以继续输入数字
/// @param textField 输入框
/// @param range 选择范围
/// @param string 单个数字
- (BOOL)canInput:(UITextField *)textField
         inRange:(NSRange)range
replacementString:(NSString *)string
       canDigits:(NSInteger)digits{
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length > 0) {
        // 保留规则: 小数点后2位
//        NSString *stringRegex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
        NSString *stringRegex = [NSString stringWithFormat:@"^\\-?([1-9]\\d*|0)(\\.\\d{0,%zi})?$",digits];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL flag = [predicate evaluateWithObject:toString];
        if (!flag) {
            return NO;
        }
    }
    return YES;
}

- (void)commonInit{
    self.exclusiveTouch = YES;
    _drawShadow = YES;
    if (@available(iOS 13.0, *)) {
        _keyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:80.0/255.f green:80.0/255.f blue:80.0/255.f alpha:1];
            }else{
                return [UIColor whiteColor];
            }
        }];
        _keyTextColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor whiteColor];
            }else{
                return [UIColor blackColor];
            }
        }];
        _keyShadowColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:45.0 / 255.f green:45.0 / 255.f blue:45.0 / 255.f alpha:1];
            }else{
                return [UIColor colorWithRed:136 / 255.f green:138 / 255.f blue:142 / 255.f alpha:1];
            }
        }];
        
        
    } else {
        _keyColor = [UIColor whiteColor];
        _keyTextColor = [UIColor blackColor];
        _keyShadowColor = [UIColor colorWithRed:136 / 255.f green:138 / 255.f blue:142 / 255.f alpha:1];
    }
        
    _downGrayEffectColor = [UIColor colorWithRed:213/255.f green:214/255.f blue:216/255.f alpha:1];
    [self setTitleColor:_keyTextColor forState:UIControlStateNormal];
    [self setTitleColor:_keyTextColor forState:UIControlStateDisabled];
    [self setTitleColor:_keyTextColor forState:UIControlStateSelected];

    //    UIControlEventTouchUpInside 先回触发 handleTouchDown ，才到 handleTouchUpInside
    [self addTarget:self action:@selector(handleTouchDown)
   forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(handleTouchUpInside)
   forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    if (_specificNoDown) {
        [super drawRect:rect];
        return;
    }
    if (_drawShadow) {//绘制按钮的样式
        //进一步判断是否需要绘制点击效果
        [self judgeGrayEffectOfDrawShadow];
    }else{
        [self judgeGrayEffectOfNoDrawShadow:rect];
    }
}
- (void)judgeGrayEffectOfDrawShadow{
    if ([self isNeedDownGrayEffect]) {//需要绘制点击效果
        if (self.isHighlighted) {//当前处于按下状态
            [self drawDownGrayEffectOfDrawShadow];
            return;
        }
        //松手指，松开状态：还原原来的效果
        [self drawBorderStyle];
        return;
    }
    //不需要点击效果
    [self drawBorderStyle];
}
- (void)judgeGrayEffectOfNoDrawShadow:(CGRect)rect{
    if ([self isNeedDownGrayEffect]) {//需要绘制点击效果
        if (self.isHighlighted) {//当前处于按下状态
            [self drawDownGrayEffectOfNoDrawShadow];
            return;
        }
        //松手指，松开状态：还原原来的效果
        [self drawDefalutOfNoDrawShadow];
        return;
    }
    //不需要点击效果
    [super drawRect:rect];
}

- (void)drawBorderStyle{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = self.keyColor;
    
    UIColor *shadow = self.keyShadowColor;
    CGSize shadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat shadowBlurRadius = 0;
    
    UIBezierPath *roundedRectanglePath =
    [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,
                                                       0,
                                                       self.frame.size.width,
                                                       self.frame.size.height - 1)
                               cornerRadius:4.f];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [color setFill];
    [roundedRectanglePath fill];
    CGContextRestoreGState(context);
}
- (void)drawDownGrayEffectOfDrawShadow{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = self.downGrayEffectColor;
    
    UIColor *shadow = self.keyShadowColor;
    CGSize shadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat shadowBlurRadius = 0;
    
    UIBezierPath *roundedRectanglePath =
    [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,
                                                       0,
                                                       self.frame.size.width,
                                                       self.frame.size.height - 1)
                               cornerRadius:4.f];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [color setFill];
    [roundedRectanglePath fill];
    CGContextRestoreGState(context);
}
//MARK: --- 按下效果相关 ----

/// 默认【原始效果】
- (void)drawDefalutOfNoDrawShadow{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = self.keyColor;
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRect:
                                          CGRectMake(0,
                                                     0,
                                                     self.frame.size.width,
                                                     self.frame.size.height)];
    CGContextSaveGState(context);
    [color setFill];
    [roundedRectanglePath fill];
    CGContextRestoreGState(context);
}
/// 按下的效果设置
- (void)drawDownGrayEffectOfNoDrawShadow{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = self.downGrayEffectColor;
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRect:
                                          CGRectMake(0,
                                                     0,
                                                     self.frame.size.width,
                                                     self.frame.size.height)];
    CGContextSaveGState(context);
    [color setFill];
    [roundedRectanglePath fill];
    CGContextRestoreGState(context);
}




- (void)setBgIconImage:(UIImage *)bgIconImage{
    _bgIconImage = bgIconImage;
    [self setBackgroundImage:[bgIconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[bgIconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                    forState:UIControlStateDisabled];
    [self setBackgroundImage:[bgIconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                    forState:UIControlStateSelected];
}
- (void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    [self setImage:[iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
          forState:UIControlStateNormal];
    [self setImage:[iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
          forState:UIControlStateDisabled];
    [self setImage:[iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
          forState:UIControlStateSelected];
}

- (void)setInput:(NSString *)input{
    _input = input;
    [self setTitle:input forState:UIControlStateNormal];
    [self setTitle:input forState:UIControlStateDisabled];
    [self setTitle:input forState:UIControlStateSelected];
}
- (void)setDelegate:(id<YWKeyboardButtonDelegate>)delegate{
    _delegate = delegate;
    _delegateHas.inTouchUpInside = delegate && [delegate respondsToSelector:
                                                @selector(interceptorTouchUpInside:)];
    _delegateHas.downGary = delegate && [delegate respondsToSelector:
                                         @selector(needDownGrayEffect:)];
}
- (void)setDataSource:(id<YWKeyboardButtonDataSource>)dataSource{
    _dataSource = dataSource;
    _dataSourceHas.effectiveDigit = dataSource && [dataSource respondsToSelector:
                                                   @selector(isEffectiveDigitForInput:)];
}
- (BOOL)isNeedDownGrayEffect{
    if (_delegateHas.downGary) {//优先级别needDownGrayEffect>_downGray
        _downGray = [_delegate needDownGrayEffect:self];
    }
    return _downGray;
}
- (NSInteger)isEffectiveDigit{
    if (_dataSourceHas.effectiveDigit) {
        return [_dataSource isEffectiveDigitForInput:self];
    }
    return 0;
}
@end
