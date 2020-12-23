//
//  YWNumSpencCharaKeyboardView.m
//  Pods-YWKeyboardKit_Example
//
//  Created by yaowei on 2020/12/23.
//

#import "YWNumSpencCharaKeyboardView.h"
#import <YWKeyboardKit/YWKeyboardButton.h>

@interface YWNumSpencCharaKeyboardView ()<YWKeyboardButtonDelegate>
{
    CGFloat _itemWidth;
    NSInteger _cellType;
    CGFloat _space;
}
@property (nonatomic, strong, nullable) NSBundle        *thisBundle;

@property (nonatomic, strong          ) NSMutableArray  *charList;

@property (nonatomic, strong          ) NSMutableArray  *numPinList;

@property (nonatomic, strong          ) UIColor         *deleteColor;


@property (nonatomic, weak            ) UIView *numPinView;

@property (nonatomic, weak            ) UIView *charView;

@property (nonatomic, weak            ) UIView *currentView;

@property (nonatomic, strong, nullable) NSTimer *timer;

@property (nonatomic, strong, nullable) NSMutableArray *letterList;

@end

@implementation YWNumSpencCharaKeyboardView

/// 按下的回调
/// @param button 当前操作对象
- (void)handleTouchDownForState:(YWKeyboardButton *)button{
    if (button.tag == 801) {
        button.selected = !button.selected;
        if (button.selected) {
            button.keyColor = [UIColor whiteColor];
            button.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_up1_acc"];
        }else{
            button.keyColor = self.deleteColor;
            button.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_up_acc"];
        }
        for (YWKeyboardButton *btn in _letterList) {
            btn.selected = !btn.selected;
        }
        [button setNeedsDisplay];
    }
}
/**执行YWKeyboardButton内部的TouchUpInside，YES-继续执行内部的实现，NO-不需要执行*/
- (BOOL)interceptorTouchUpInside:(UIButton *)button{
    if (button.tag == 801) {
        return NO;
    }
    if (button.tag == 901) {
        _currentView.hidden = YES;
        if (_currentView == self.numPinView) {
            [self createCharKeyboardView];
        }else{
            [self createNumCharKeyboardView];
        }
        _currentView.hidden = NO;
        [self.timer invalidate];
        self.timer = nil;
        return NO;
    }
    
    return YES;
}

/// 是否需要点击放大效果
/// @param button 当前操作对象
- (BOOL)needDrawAmplification:(UIButton *)button{
    if (button.tag == 801) {
        return NO;
    }
    if (button.tag == 901) {
        return NO;
    }
    if (button.tag == 902) {
        return NO;
    }
    if (button.tag == 999) {
        return NO;
    }
    return _downEffect;
}

+ (instancetype)getDefalutNumCharKeyboardView:(id<UITextInput>)textInput{
    return [[YWNumSpencCharaKeyboardView alloc] initWithFrame:CGRectZero inputViewStyle:UIInputViewStyleKeyboard textInput:textInput cellType:0];
}
+ (instancetype)getCharNumKeyboardView:(id<UITextInput>)textInput{
    return [[YWNumSpencCharaKeyboardView alloc] initWithFrame:CGRectZero inputViewStyle:UIInputViewStyleKeyboard textInput:textInput cellType:1];
}
- (instancetype)initWithFrame:(CGRect)frame
               inputViewStyle:(UIInputViewStyle)inputViewStyle
                    textInput:(id<UITextInput>)textInput
                     cellType:(NSInteger)cellType{
    self = [super initWithFrame:frame inputViewStyle:inputViewStyle];
    if (self) {
        _cellType = cellType;
        _textInput = textInput;
        _space = 0.5;
        _downEffect = YES;
        [self sizeToFit];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if (cellType == 0) {
            [self createNumCharKeyboardView];
        }else{
            [self createCharKeyboardView];
            _currentView = _charView;
        }
    }
    return self;
}
- (void)createNumCharKeyboardView{
    if (_numPinView) {
        _currentView = _numPinView;
        return;
    }
    _letterList = [NSMutableArray new];
    NSInteger lineItem = 10;
    CGFloat leftX = 5;
    CGFloat space = 6;
    NSInteger i = 0;
    CGFloat top = 5;
    CGFloat width = _itemWidth;
    CGFloat height = 1.34375 * width;
        
    [self addSubview:({
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height)];
        _numPinView = v;
        v;
    })];
    CGFloat lastCurrentX = leftX;
    CGFloat fixedHeight = height + top + top;
    for (NSString *kText in self.numPinList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardButton *btn = [YWKeyboardButton buttonWithType:UIButtonTypeCustom];
        if (i < 30) {
            CGFloat currentX = index == 0 ? leftX : lastCurrentX;
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, width, height);
            lastCurrentX = currentX + width + space;
        }else if (i < 31){//字符切换
            CGFloat currentLeft = 1 * (width + space) + (width/2 + 6);//z的左距离
            CGFloat currentW = currentLeft - 5 - 10;
            CGFloat currentX = leftX;
            btn.frame = CGRectMake(currentX, top + fixedHeight * 3, currentW, height);
            lastCurrentX = currentX + currentW + space + space;
        }else if(i > 37){
            CGFloat currentZLeft = 1 * (width + space) + (width/2 + 6);//z的左距离
            CGFloat currentW = currentZLeft - 5 - 10;
            btn.frame = CGRectMake(lastCurrentX + space, top + fixedHeight * page, currentW, height);
        }else{
            CGFloat currentX = index == 0 ? leftX : lastCurrentX;
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, width, height);
            lastCurrentX = currentX + width + space;
        }
        if (i == 20) {//大小切换切换
            btn.tag = 801;
            btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_up_acc"];
        }else if (i == 30) {//字符切换切换
            btn.tag = 901;
            btn.keyColor = self.deleteColor;
            [btn.titleLabel adjustsFontSizeToFitWidth];
            btn.input = kText;
        }else if (i == 38){
            btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
            btn.tag = 902;
            btn.keyColor = self.deleteColor;
            [self addLongGesAction:btn];
        }else{
            btn.input = [kText lowercaseString];
            btn.inputSelected = kText;
        }
        if (i > 9 && i < 20) {
            [_letterList addObject:btn];
        }else if (i > 20 && i < 30) {
            [_letterList addObject:btn];
        }else if (i > 30 && i < 38) {
            [_letterList addObject:btn];
        }
        btn.delegate = self;
        btn.textInput = _textInput;
        [_numPinView addSubview:btn];
        i ++;
    }
    _currentView = _numPinView;
}
- (void)createCharKeyboardView{
    if (_charView) {
        _currentView = _charView;
        return;
    }
    
    NSInteger lineItem = 10;
    CGFloat leftX = 5;
    CGFloat space = 6;
    NSInteger i = 0;
    CGFloat top = 5;
    CGFloat width = _itemWidth;
    CGFloat height = 1.34375 * width;
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    CGFloat totalWidth = mainSize.width;
    
    [self addSubview:({
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0,totalWidth, self.frame.size.height)];
        _charView = v;
        v;
    })];
    
    CGFloat lastCurrentX = leftX;
    CGFloat currentLeft = 1 * (width + space) + (width/2 + 6);//z的左距离
    CGFloat opationWith = currentLeft - 5 - 10;
    //针对小屏幕，处理字体
    CGSize size4 = CGSizeMake(320,568);
    UIFont *font = [UIFont systemFontOfSize:14];
    if (size4.width == mainSize.width && size4.height == mainSize.height) {//4.0
        font = [UIFont systemFontOfSize:12];
    }
    
    CGFloat fixedHeight = height + top + top;
    
    for (NSString *kText in self.charList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardButton *btn = [YWKeyboardButton buttonWithType:UIButtonTypeCustom];
        if(i < 30){
            CGFloat currentX = index == 0 ? leftX : lastCurrentX;
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, width, height);
            lastCurrentX = currentX + width + space;
            btn.input = kText;
        }else if (i == 30) {//abc
            CGFloat currentW = opationWith;
            CGFloat currentX = leftX;
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, currentW, height);
            lastCurrentX = currentX + currentW + space;
            
            btn.tag = 901;
            btn.keyColor = self.deleteColor;
            btn.titleLabel.font = font;
            btn.input = kText;
            
        }else if (i == 33){//空格
            btn.tag = 999;
            CGFloat currentW = totalWidth - lastCurrentX - 2 *(space + width) - space - opationWith - leftX;
            CGFloat currentX = lastCurrentX;
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, currentW, height);
            lastCurrentX = currentX + currentW + space;
            btn.input = kText;
            [btn setTitle:@"空格" forState:UIControlStateNormal];
            [btn setTitle:@"空格" forState:UIControlStateDisabled];
            [btn setTitle:@"空格" forState:UIControlStateSelected];
        }else if(i == 36){//delete
            CGFloat currentW = opationWith;
            btn.frame = CGRectMake(lastCurrentX, top + fixedHeight * page, currentW, height);
            
            btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
            btn.tag = 902;
            btn.keyColor = self.deleteColor;
            [self addLongGesAction:btn];
        }else{
            CGFloat currentX = index == 0 ? leftX : lastCurrentX;
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, width, height);
            lastCurrentX = currentX + width + space;
            btn.input = kText;
        }
        btn.delegate = self;
        btn.textInput = _textInput;
        [_charView addSubview:btn];
        i ++;
    }
    _currentView = _charView;
}
- (CGSize)sizeThatFits:(CGSize)size{
    CGSize sizeThatFit = [super sizeThatFits:size];
    
    NSInteger lineItem = 10;
    CGFloat leftX = 5;
    CGFloat space = 6;
    CGFloat top = 5;
    _itemWidth = ([UIScreen mainScreen].bounds.size.width - (lineItem - 1) * space - leftX * 2)/lineItem;
    CGFloat height = 1.34375 * _itemWidth;
    
    CGFloat viewHeight = 4 * (top * 2 + height);
    CGFloat both_x = YW_KEYBOARD_TABBARBOTTOM;
    sizeThatFit.height = viewHeight + both_x;
    
    return sizeThatFit;;
}

//MARK: --- load YWKeyboardKit Bundle image ----
- (UIImage *)getImageOnBundleWithImage:(NSString *)imageName{
    return [self getImageOnBundle:imageName ofType:@"png"];
}
- (UIImage *)getImageOnBundle:(NSString *)imageName
                       ofType:(NSString *)type{
        
    return [UIImage imageNamed:imageName
                      inBundle:self.thisBundle compatibleWithTraitCollection:nil];
    
}
//MARK: --- 长按 delete ----
- (void)addLongGesAction:(YWKeyboardButton *) btn{
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteWithLognGes:)];
    [btn addGestureRecognizer:ges];
}

- (void)deleteWithLognGes:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.timer invalidate];
        self.timer = nil;
        self.timer = [NSTimer timerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(deleteAction)
                                           userInfo:nil
                                            repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }else if (sender.state == UIGestureRecognizerStateEnded){
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)deleteAction{
    [self.textInput deleteBackward];
}
- (NSMutableArray *)numPinList{
    if (!_numPinList) {
        _numPinList = [NSMutableArray arrayWithArray:@[
            @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",
            @"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",
           @"up",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",
          @"#+=",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@""
        ]];
    }
    return _numPinList;
}
- (NSMutableArray *)charList{
    if (!_charList) {
        _charList = [NSMutableArray arrayWithArray:@[
            @"&",@"\"",@";",@"^",@",",@"|",@"$",@"*",@":",@"'",
            @"?",@"{",@"[",@"~",@"#",@"}",@".",@"]",@"\\",@"!",
           @"(",@"%",@"-",@"_",@"+",@"/",@")",@"=",@"<",@"`",
           @"ABC",@">",@"@",@" ",@"·",@"￥",@""
        ]];
    }
    return _charList;
}
- (NSBundle *)thisBundle{
    if (!_thisBundle) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        
        NSURL *url = [bundle URLForResource:@"YWKeyboardKit"
                              withExtension:@"bundle"];
        
        _thisBundle = [NSBundle bundleWithURL:url];
    }
    return _thisBundle;
}
- (UIColor *)deleteColor{
    if (!_deleteColor) {
        if (@available(iOS 13.0, *)) {
            _deleteColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    return [UIColor colorWithRed:46.0/255.f green:46.0/255.f blue:46.0/255.f alpha:1];
                }else{
                    return [UIColor colorWithRed:180.0/255.f green:186.0/255.f blue:197.0/255.f alpha:1];
                }
            }];
        } else {
            _deleteColor = [UIColor colorWithRed:180.0/255.f green:186.0/255.f blue:197.0/255.f alpha:1];
        }
    }
    return _deleteColor;
}
- (void)dealloc{
    [_letterList removeAllObjects];
    _letterList = nil;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    YWKeyboardButton *btn2 = [_numPinView viewWithTag:801];
    YWKeyboardButton *btn = [_numPinView viewWithTag:902];
    YWKeyboardButton *btn1 = [_charView viewWithTag:902];
    if (btn) {
        btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
    }
    if (btn1) {
        btn1.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
    }
    if (btn2) {
        btn2.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_up_acc"];
    }
}
@end
