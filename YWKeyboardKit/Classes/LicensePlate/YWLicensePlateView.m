//
//  YWLicensePlateView.m
//  NMChangJieCloud
//
//  Created by yaowei on 2018/12/14.
//

#import "YWLicensePlateView.h"
#import <YWKeyboardKit/YWKeyboardButton.h>






@interface YWLicensePlateView ()<YWKeyboardButtonDelegate>

@property (nonatomic, weak,  readwrite) id<UITextInput> textInput;

@property (nonatomic, strong          ) NSMutableArray *proviceCodeList;

@property (nonatomic, strong          ) NSMutableArray *numPinList;

@property (nonatomic, weak            ) UIView *proviceCodeView;

@property (nonatomic, weak            ) UIView *numPinView;

@property (nonatomic, strong          ) UIColor *deleteColor;

@property (nonatomic, strong, nullable) NSBundle *thisBundle;

@property (nonatomic, strong, nullable) NSTimer *timer;


@end


@implementation YWLicensePlateView

+ (instancetype)getEnglishOrProvinceLicensePlate:(id<UITextInput>)textInput{
    return [[YWLicensePlateView alloc] initWithFrame:CGRectZero inputViewStyle:UIInputViewStyleKeyboard textInput:textInput fitstType:YES];
}
+ (instancetype)getProvinceOrEnglishLicensePlate:(id<UITextInput>)textInput{
    return [[YWLicensePlateView alloc] initWithFrame:CGRectZero inputViewStyle:UIInputViewStyleKeyboard textInput:textInput fitstType:NO];
}
- (instancetype)initWithFrame:(CGRect)frame
               inputViewStyle:(UIInputViewStyle)inputViewStyle
                    textInput:(id<UITextInput>)textInput
                    fitstType:(BOOL)number{
    
    self = [super initWithFrame:frame inputViewStyle:inputViewStyle];
    if (self) {
        _textInput = textInput;
        [self createViewNumPinView];
        [self createViewProviceCodeView];
        if (number) {
            [self showNumPinView];
        }else{
            [self showProviceCodeView];            
        }
    }
    return self;
}
- (void)showEnglishNumView{
    [self showNumPinView];
    [self.timer invalidate];
    self.timer = nil;
}
- (void)showProvinceView{
    [self showProviceCodeView];
    [self.timer invalidate];
    self.timer = nil;
}
//MARK: -------- YWKeyboardButtonDelegate -----------
- (BOOL)interceptorTouchUpInside:(YWKeyboardButton *)button{
    if (button.tag == 900) {//ABC
        [self showNumPinView];
        [self.timer invalidate];
        self.timer = nil;
        return NO;
    }
    if (button.tag == 901){//中
        [self showProviceCodeView];
        [self.timer invalidate];
        self.timer = nil;
        return NO;
    }
    return YES;
}
- (BOOL)needDrawAmplification:(YWKeyboardButton *)button{
    if (button.tag == 900) {//ABC
        return NO;
    }
    if (button.tag == 901){//中
        return NO;
    }
    if (button.tag == 902) {//delegate
        return NO;
    }
    return YES;
}





//MARK: -------- UI ----------------

- (void)createViewProviceCodeView{
    
    NSInteger lineItem = 9;
    CGFloat leftX = 5;
    CGFloat space = 6;
    NSInteger i = 0;
    CGFloat top = 5;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - (lineItem - 1) * space - leftX * 2)/lineItem;
    CGFloat height = 1.34375 * width;
    
    CGFloat viewHeight = 5 * (top * 2 + height);
    CGFloat both_x = YW_KEYBOARD_TABBARBOTTOM;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, viewHeight + both_x);
    
    [self addSubview:({
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, viewHeight)];
        _proviceCodeView = v;
        v;
    })];
    
    //针对小屏幕，处理字体
    CGSize size4 = CGSizeMake(320,568);
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    UIFont *font = [UIFont systemFontOfSize:14];
    if (size4.width == mainSize.width && size4.height == mainSize.height) {//4.0
        font = [UIFont systemFontOfSize:12];
    }
    CGFloat fixedHeight = height + top + top;
    
    for (NSString *kText in self.proviceCodeList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardButton *btn = [YWKeyboardButton buttonWithType:UIButtonTypeCustom];
        CGFloat currentX = index * (width + space) + leftX;
//        if (i >= 37) {
//            currentX = index * (width + space) + leftX + width;
//        }
        if (i == 36){//abc
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, width, height);
            btn.tag = 900;
            btn.keyColor = self.deleteColor;
            btn.delegate = self;
            btn.titleLabel.font = font;
        }else if (i == 43){//delete
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, width+width+space, height);
            btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
            btn.keyColor = self.deleteColor;
            btn.tag = 902;
            btn.delegate = self;
            [self addLongGesAction:btn];
        }else{
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, width, height);
        }
        btn.input = kText;
        btn.textInput = _textInput;
        [_proviceCodeView addSubview:btn];
        i ++;
    }
}

- (void)createViewNumPinView{
    
    NSInteger lineItem = 10;
    CGFloat leftX = 5;
    CGFloat space = 6;
    NSInteger i = 0;
    CGFloat top = 5;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - (lineItem - 1) * space - leftX * 2)/lineItem;
    CGFloat height = 1.34375 * width;
    
    CGFloat viewHeight = 4 * (top * 2 + height);
    CGFloat both_x = YW_KEYBOARD_TABBARBOTTOM;
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, viewHeight + both_x);
    
    [self addSubview:({
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, viewHeight)];
        _numPinView = v;
        v;
    })];
    
    CGFloat fixedHeight = height + top + top;

    for (NSString *kText in self.numPinList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardButton *btn = [YWKeyboardButton buttonWithType:UIButtonTypeCustom];
        if (i < 20) {
            CGFloat currentX = index * (width + space) + leftX;
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, width, height);
        }else if (i < 29){
            CGFloat currentX = index * (width + space) + (width/2 + 6);
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, width, height);
        }else if (i < 30){//切换
            CGFloat currentLeft = 1 * (width + space) + (width/2 + 6);//z的左距离
            CGFloat currentW = currentLeft - 5 - 13;
            CGFloat currentX = 0 * (width + space) + leftX;
            btn.frame = CGRectMake(currentX, top + fixedHeight * 3, currentW, height);
            
            btn.tag = 901;
            btn.keyColor = self.deleteColor;
            btn.delegate = self;

        }else if(i > 36){
            CGFloat currentZLeft = 1 * (width + space) + (width/2 + 6);//z的左距离
            CGFloat currentW = currentZLeft - 5 - 13;
            CGFloat currentLeft = 8 * (width + space) + (width/2 + 6) + 9;
            btn.frame = CGRectMake(currentLeft, top + fixedHeight * page, currentW, height);
            btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
            btn.tag = 902;
            btn.keyColor = self.deleteColor;
            btn.delegate = self;
            [self addLongGesAction:btn];

        }else{
            CGFloat currentLeft = 1 * (width + space) + (width/2 + 6);
            CGFloat currentX = index * (width + space) + currentLeft;
            btn.frame = CGRectMake(currentX, top + fixedHeight * page, width, height);
        }
        btn.input = kText;
        btn.textInput = _textInput;
        [_numPinView addSubview:btn];
        i ++;
    }
}

- (void)showProviceCodeView{
    _numPinView.hidden = YES;
    _proviceCodeView.hidden = NO;
    CGRect rect = self.frame;
    rect.size.height = CGRectGetHeight(_proviceCodeView.frame)+YW_KEYBOARD_TABBARBOTTOM;
    NSArray <NSLayoutConstraint *>* constraints = self.constraints;
    BOOL isModity = NO;
    for (NSLayoutConstraint *constraint in constraints) {
        if(constraint.firstAttribute == NSLayoutAttributeHeight){
            constraint.constant = rect.size.height;
            isModity = YES;
            break;
        }
    }
    if(!isModity){
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, rect.size.height);
    }
}

- (void)showNumPinView{
    _proviceCodeView.hidden = YES;
    _numPinView.hidden = NO;
    CGRect rect = self.frame;
    rect.size.height = CGRectGetHeight(_numPinView.frame)+YW_KEYBOARD_TABBARBOTTOM;
    NSArray <NSLayoutConstraint *>* constraints = self.constraints;
    BOOL isModity = NO;
    for (NSLayoutConstraint *constraint in constraints) {
        if(constraint.firstAttribute == NSLayoutAttributeHeight){
            constraint.constant = rect.size.height;
            isModity = YES;
            break;
        }
    }
    if(!isModity){
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, rect.size.height);
    }
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
//MARK: --- load YWKeyboardKit Bundle image ----
- (UIImage *)getImageOnBundleWithImage:(NSString *)imageName{
    return [self getImageOnBundle:imageName ofType:@"png"];
}
- (UIImage *)getImageOnBundle:(NSString *)imageName
                       ofType:(NSString *)type{
    
    return [UIImage imageNamed:imageName
                      inBundle:self.thisBundle compatibleWithTraitCollection:nil];
    
}

//MARK: --- getter && setter
- (NSBundle *)thisBundle{
    if (!_thisBundle) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        
        NSURL *url = [bundle URLForResource:@"YWKeyboardKit"
                              withExtension:@"bundle"];
        
        _thisBundle = [NSBundle bundleWithURL:url];
    }
    return _thisBundle;
}
- (NSMutableArray *)proviceCodeList{
    if (!_proviceCodeList) {
//        _proviceCodeList = [NSMutableArray arrayWithArray:
//                            @[@"京",@"津",@"渝",@"沪",@"冀",@"晋",@"辽",@"吉",@"黑",@"苏",
//                              @"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"琼",
//                              @"川",@"贵",@"云",@"陕",@"甘",@"青",@"蒙",@"桂",@"宁",@"新",
//                              @"ABC", @"藏",@"使",@"领",@"警",@"学",@"港",@"澳",@"挂", @""
//                            ]];
        _proviceCodeList = [NSMutableArray arrayWithArray:
                            @[@"京",@"津",@"渝",@"沪",@"冀",@"晋",@"辽",@"吉",@"黑",
                              @"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",
                              @"粤",@"琼",@"川",@"贵",@"云",@"陕",@"甘",@"青",@"蒙",
                              @"桂",@"宁",@"新",@"藏",@"警",@"学",@"港",@"澳",@"使",
                              @"ABC",@"领",@"挂",@"试",@"应",@"急",@"临",@""
                            ]];
    }
    return _proviceCodeList;
}
- (NSMutableArray *)numPinList{
    if (!_numPinList) {
        _numPinList = [NSMutableArray arrayWithArray:@[
            @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",
            @"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",
            @"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",
            @"中",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@""
        ]];
    }
    return _numPinList;
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


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    YWKeyboardButton *btn = [_proviceCodeView viewWithTag:902];
    YWKeyboardButton *btn1 = [_numPinView viewWithTag:902];
    btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
    btn1.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
@end
