//
//  YWInputToolbar.m
//  Pods-YWKeyboardKit_Example
//
//  Created by yaowei on 2020/12/17.
//

#import "YWInputToolbar.h"

@interface YWInputToolbar ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *leftBarButton;
@property (nonatomic, strong) UIButton *titleBarButton;
@property (nonatomic, strong) UIButton *doneBarButton;
@property (nonatomic, weak, readwrite) id<UITextInput> textInput;

@end

@implementation YWInputToolbar


+ (instancetype)getInputToolbar:(id<UITextInput>)textInput{
    YWInputToolbar *toolbar = [[YWInputToolbar alloc] initWithFrame:CGRectZero];
    toolbar.textInput = textInput;
    return toolbar;
}
- (void)initialize{
    [self sizeToFit];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.topView];
    [self addSubview:self.leftBarButton];
    [self addSubview:self.titleBarButton];
    [self addSubview:self.doneBarButton];
    [self barStyleAction];
}

- (void)barStyleAction{
    if (@available(iOS 13.0, *)) {
        self.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:87.0/255.f green:87.0/255.f blue:87.0/255.f alpha:1];
            }else{
                return [UIColor colorWithRed:246.0/255.f green:246.0/255.f blue:246/255.f alpha:1];
            }
        }];
        self.topView.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:118.0/255.f green:118.0/255.f blue:118.0/255.f alpha:1];
            }else{
                return [UIColor colorWithRed:230.0/255.f green:230.0/255.f blue:230.0/255.f alpha:1];
            }
        }];
    } else {
        self.backgroundColor = [UIColor colorWithRed:246.0/255.f green:246.0/255.f blue:246/255.f alpha:1];
        
        self.topView.backgroundColor = [UIColor colorWithRed:230.0/255.f green:230.0/255.f blue:230.0/255.f alpha:1];
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
- (void)leftAction{
    _leftBarButton.selected = !_leftBarButton.selected;
    if (_leftCall) {
        _leftCall(nil);
    }
}
- (void)doneAction{
    if ([self.textInput isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)self.textInput;
        [textView resignFirstResponder];
    } else if ([self.textInput isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)self.textInput;
        [textField resignFirstResponder];
    }
    if (_doneCall) {
        _doneCall(nil);
    }
}
- (void)setLeftImageNormal:(UIImage *)leftImageNormal{
    _leftImageNormal = leftImageNormal;
    [_leftBarButton setImage:[leftImageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}
- (void)setLeftTitleNormal:(NSString *)leftTitleNormal{
    _leftTitleNormal = leftTitleNormal;
    [_leftBarButton setTitle:leftTitleNormal forState:UIControlStateNormal];
}
- (void)setLeftImageSelected:(UIImage *)leftImageSelected{
    _leftImageSelected = leftImageSelected;
    [_leftBarButton setImage:[leftImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
}
- (void)setLeftTitleSelected:(NSString *)leftTitleSelected{
    _leftTitleSelected = leftTitleSelected;
    [_leftBarButton setTitle:_leftTitleSelected forState:UIControlStateSelected];
}
- (void)setTitle:(NSString *)title{
    _title = title;
    [_titleBarButton setTitle:title forState:UIControlStateNormal];
    [self setNeedsLayout];
}
- (void)setLogo:(UIImage *)logo{
    _logo = logo;
    [_titleBarButton setImage:[logo imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}
- (void)setDone:(NSString *)done{
    _done = done;
    [_doneBarButton setTitle:done forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (UIButton *)leftBarButton{
    if (_leftBarButton == nil) {
        _leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
        [_leftBarButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBarButton;
}
- (UIButton *)titleBarButton{
    if (_titleBarButton == nil) {
        _titleBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBarButton.titleLabel.numberOfLines = 2;
        _titleBarButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
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
- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
    }
    return _topView;
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize sizeThatFit = [super sizeThatFits:size];
    sizeThatFit.height = 44;
    return sizeThatFit;
}
- (void)layoutSubviews{
    [super layoutSubviews];
        
    CGFloat margin = 16;
    
    CGSize leftSize = [self.leftBarButton sizeThatFits:CGSizeMake(80, 44)];

    CGSize doneSize = [self.doneBarButton sizeThatFits:CGSizeMake(80, 44)];


    CGFloat maxWidth = CGRectGetWidth(self.frame) - (margin + leftSize.width) - (margin + doneSize.width) - margin * 2;
    
    _topView.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    
    _leftBarButton.frame = CGRectMake(margin, 0, leftSize.width, 44);
    _titleBarButton.frame = CGRectMake(CGRectGetMaxX(_leftBarButton.frame) + margin, 0, maxWidth, 44);
    _doneBarButton.frame = CGRectMake(CGRectGetMaxX(_titleBarButton.frame) + margin, 0, doneSize.width, 44);
}

@end
