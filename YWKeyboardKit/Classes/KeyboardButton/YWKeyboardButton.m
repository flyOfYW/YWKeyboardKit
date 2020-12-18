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
        unsigned downGary : 1;

    } _delegateHas;
    
}
@property (nonatomic, strong            ) YWTipUpView *buttonView;
@property (nonatomic, readwrite         ) YWKeyboardButtonPosition position;
@property (nonatomic, strong            ) UIColor *currentBackgorundColor;

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
    if ([self isDrawAmplification]) {
        [self showInputView];
    }
    if ([self isNeedDownGrayEffect]) {
        _currentBackgorundColor = self.backgroundColor;
        self.backgroundColor = [UIColor lightTextColor];
    }
}
- (void)handleTouchUpInside{
    BOOL isContinue = YES;
    if (_delegateHas.inTouchUpInside) {
        isContinue = [_delegate interceptorTouchUpInside:self];
    }
    if (!isContinue) return;
    [self insertText:self.input];
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
    if ([self isNeedDownGrayEffect]) {
        self.backgroundColor = _currentBackgorundColor;
        _currentBackgorundColor = nil;
    }
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
    _drawShadow = YES;
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
    
    _keyHighlightedColor = [UIColor colorWithRed:213/255.f green:214/255.f blue:216/255.f alpha:1];
    
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
    if (_drawShadow) {
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
    }else{
        [super drawRect:rect];
    }
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
    _delegateHas.inTouchUpInside = delegate && [delegate respondsToSelector:@selector(interceptorTouchUpInside:)];
    _delegateHas.amplification = delegate && [delegate respondsToSelector:@selector(needDrawAmplification:)];
    _delegateHas.downGary = delegate && [delegate respondsToSelector:@selector(needDownGrayEffect:)];
}
- (BOOL)isDrawAmplification{
    if (_delegateHas.amplification) {
        _drawAmplification = [_delegate needDrawAmplification:self];
    }
    //defalut is yes
    return _drawAmplification;
}
- (BOOL)isNeedDownGrayEffect{
    if (_delegateHas.downGary) {//优先级别needDownGrayEffect>_downGray
        _downGray = [_delegate needDownGrayEffect:self];
    }
    return _downGray;
}

@end
