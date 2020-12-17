//
//  YWInputToolbar.m
//  Pods-YWKeyboardKit_Example
//
//  Created by yaowei on 2020/12/17.
//

#import "YWInputToolbar.h"

@interface YWInputToolbar ()
@property (nonatomic, strong) UIButton *leftBarButton;
@property (nonatomic, strong) UIButton *titleBarButton;
@property (nonatomic, strong) UIButton *doneBarButton;
@property (nonatomic, weak, readwrite) id<UITextInput> textInput;

@end

@implementation YWInputToolbar

+ (void)initialize{
    [super initialize];
    YWInputToolbar *appearanceProxy = [self appearance];
    NSArray <NSNumber*> *positions = @[@(UIBarPositionAny),@(UIBarPositionBottom),@(UIBarPositionTop),@(UIBarPositionTopAttached)];
    
    for (NSNumber *position in positions){
        UIToolbarPosition toolbarPosition = [position unsignedIntegerValue];
        [appearanceProxy setBackgroundImage:nil forToolbarPosition:toolbarPosition barMetrics:UIBarMetricsDefault];
        [appearanceProxy setShadowImage:nil forToolbarPosition:toolbarPosition];
    }
}
+ (instancetype)getInputToolbar:(id<UITextInput>)textInput{
    YWInputToolbar *toolbar = [[YWInputToolbar alloc] initWithFrame:CGRectZero];
    toolbar.textInput = textInput;
    return toolbar;
}
- (void)initialize{
    [self sizeToFit];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.translucent = YES;
//    self.barStyle = UIBarStyleDefault;
    [self addSubview:self.leftBarButton];
    [self addSubview:self.titleBarButton];
    [self addSubview:self.doneBarButton];
}

- (void)barStyleAction{
    if ([_textInput respondsToSelector:@selector(keyboardAppearance)]){
        switch ([_textInput keyboardAppearance]){
            case UIKeyboardAppearanceDark:
            {
                self.barStyle = UIBarStyleBlack;
                [self setBarTintColor:nil];
            }
                break;
            default:
            {
                self.barStyle = UIBarStyleDefault;
                self.barTintColor = _toolbarBarTintColor;
            }
                break;
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self){
        [self initialize];
    }
    return self;
}

- (void)doneAction{
    if ([self.textInput isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)self.textInput;
        [textView resignFirstResponder];
    } else if ([self.textInput isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)self.textInput;
        [textField resignFirstResponder];
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [_titleBarButton setTitle:title forState:UIControlStateNormal];
    [self setNeedsLayout];
}
- (void)setDone:(NSString *)done{
    _done = done;
    [_doneBarButton setTitle:done forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (UIButton *)leftBarButton{
    if (_leftBarButton == nil) {
        _leftBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        if (@available(iOS 13.0, *)) {
            [_leftBarButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        } else
#endif
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 130000
            [_leftBarButton setTitleColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
#endif
        }
        [_leftBarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_leftBarButton setBackgroundColor:[UIColor clearColor]];
        [_leftBarButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _leftBarButton;
}
- (UIButton *)titleBarButton{
    if (_titleBarButton == nil) {
        _titleBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _titleBarButton.titleLabel.numberOfLines = 2;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        if (@available(iOS 13.0, *)) {
            [_titleBarButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        } else
#endif
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 130000
            [_titleBarButton setTitleColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
#endif
        }
        [_titleBarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_titleBarButton setBackgroundColor:[UIColor clearColor]];
        [_titleBarButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleBarButton;
}
- (UIButton *)doneBarButton{
    if (_doneBarButton == nil) {
        _doneBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
        if (@available(iOS 13.0, *)) {
            [_doneBarButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        } else
#endif
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 130000
            [_doneBarButton setTitleColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
#endif
        }
        [_doneBarButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_doneBarButton setBackgroundColor:[UIColor clearColor]];
        [_doneBarButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_doneBarButton setTitle:@"完成" forState:UIControlStateNormal];
        _doneBarButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_doneBarButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBarButton;
}


- (CGSize)sizeThatFits:(CGSize)size{
    CGSize sizeThatFit = [super sizeThatFits:size];
    sizeThatFit.height = 44;
    return sizeThatFit;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self barStyleAction];
    CGFloat margin = 16;
    
    CGSize leftSize = [self.leftBarButton sizeThatFits:CGSizeMake(80, 44)];

    CGSize doneSize = [self.doneBarButton sizeThatFits:CGSizeMake(80, 44)];

    CGFloat maxWidth = CGRectGetWidth(self.frame) - (margin + leftSize.width) - (margin + doneSize.width) - margin * 2;
    
    _leftBarButton.frame = CGRectMake(margin, 0, leftSize.width, 44);
    _titleBarButton.frame = CGRectMake(CGRectGetMaxX(_leftBarButton.frame) + margin, 0, maxWidth, 44);
    _doneBarButton.frame = CGRectMake(CGRectGetMaxX(_titleBarButton.frame) + margin, 0, doneSize.width, 44);

}

@end
