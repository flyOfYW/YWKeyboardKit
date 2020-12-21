//
//  YWNumPadKeyboardView.m
//  HGWisdomRoad
//
//  Created by yaowei on 2018/09/19.
//

#import "YWNumPadKeyboardView.h"
#import <YWKeyboardKit/YWKeyboardButton.h>

@interface YWNumPadKeyboardView ()<YWKeyboardButtonDelegate,YWKeyboardButtonDataSource>
{
    CGFloat _itemWidth;
    NSInteger _cellType;
    CGFloat _space;
}
@property (nonatomic, strong, nullable) NSBundle        *thisBundle;

@property (nonatomic, strong          ) NSMutableArray  *numDecimalList;
@property (nonatomic, strong          ) NSMutableArray  *numList;
@property (nonatomic, strong          ) UIColor         *deleteColor;
@property (nonatomic, strong, nullable) NSTimer *timer;

@end


@implementation YWNumPadKeyboardView

/**带有小数点分割线样式键盘*/
+ (instancetype)getDecimalKeyboardDividerView:(id<UITextInput>)textInput{
    YWNumPadKeyboardView *keyboardView = [[YWNumPadKeyboardView alloc] initWithFrame:CGRectZero
                                                                      inputViewStyle:UIInputViewStyleKeyboard
                                                                           textInput:textInput
                                                                            cellType:0];
    return keyboardView;
}
/**带有小数点圆角样式键盘*/
+ (instancetype)getDecimalKeyboardShadowView:(id<UITextInput>)textInput{
    YWNumPadKeyboardView *keyboardView = [[YWNumPadKeyboardView alloc] initWithFrame:CGRectZero
                                                                      inputViewStyle:UIInputViewStyleKeyboard
                                                                           textInput:textInput
                                                                            cellType:1];
    return keyboardView;
}
/**不带有小数点分割线样式键盘*/
+ (instancetype)getNumKeyboardDividerView:(id<UITextInput>)textInput{
    YWNumPadKeyboardView *keyboardView = [[YWNumPadKeyboardView alloc] initWithFrame:CGRectZero
                                                                      inputViewStyle:UIInputViewStyleKeyboard
                                                                           textInput:textInput
                                                                            cellType:2];
    return keyboardView;
}
/**不带有小数点圆角样式键盘*/
+ (instancetype)getNumKeyboardShadowView:(id<UITextInput>)textInput{
    YWNumPadKeyboardView *keyboardView = [[YWNumPadKeyboardView alloc] initWithFrame:CGRectZero
                                                                      inputViewStyle:UIInputViewStyleKeyboard
                                                                           textInput:textInput
                                                                            cellType:3];
    return keyboardView;

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
        _downGrayEffect = YES;
        _floatDigit = 2;
        [self sizeToFit];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self createNumPadKeyboardView];
    }
    return self;
}

//MARK: --- YWKeyboardButtonDelegate ---
- (BOOL)needDownGrayEffect:(YWKeyboardButton *)button{
    return _downGrayEffect;
}
//MARK: --- YWKeyboardButtonDataSource ---
- (NSInteger)isEffectiveDigitForInput:(UIButton *)button{
    if (_effectiveDigit) {
        return _floatDigit;
    }
    return 0;
}
//MARK: --- UI ---
- (void)createNumPadKeyboardView{
    if (_cellType == 0) {
        [self createDecimalKeyboardDividerView];
        return;
    }
    if (_cellType == 1) {
        [self createDecimalKeyboardShadowView];
        return;
    }
    if (_cellType == 2) {
        [self createNumKeyboardDividerView];
        return;
    }
    if (_cellType == 3) {
        [self createNumKeyboardShadowView];
        return;
    }
}
//MARK: --- 单元格圆角样式的view ---
- (void)createDecimalKeyboardShadowView{
    NSInteger lineItem = 3;
    CGFloat space = _space;
    NSInteger i = 0;
    CGFloat top = 10;
    CGFloat width = _itemWidth;
    CGFloat height = 0.34 * width;
    CGFloat leftX = 10;

    for (NSString *kText in self.numDecimalList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardDownButton *btn = [self createBtnWith:kText];
        CGFloat currentX = index * (width + space) + leftX;
        btn.frame = CGRectMake(currentX, top + (height + top) * page, width, height);
        btn.drawShadow = YES;
        [self addSubview:btn];
        i ++;
    }
}
- (void)createNumKeyboardShadowView{
    NSInteger lineItem = 3;
    CGFloat space = _space;
    NSInteger i = 0;
    CGFloat top = 10;
    CGFloat width = _itemWidth;
    CGFloat height = 0.34 * width;
    CGFloat leftX = 10;

    for (NSString *kText in self.numList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardDownButton *btn = [self createBtnWith:kText];
        CGFloat currentX = index * (width + space) + leftX;
        if([kText isEqual:@"-"]){
            btn = nil;
            i ++;
            continue;;
        }else if([kText isEqual:@""]){//删除键
            btn.keyColor = [UIColor clearColor];
            btn.drawShadow = NO;
            btn.specificNoDown = YES;
        }
        btn.drawShadow = YES;
        btn.frame = CGRectMake(currentX, top + (height + top) * page, width, height);
        [self addSubview:btn];
        i ++;
    }
}
//MARK: --- 分割线样式的view ---
- (void)createDecimalKeyboardDividerView{
    NSInteger lineItem = 3;
    CGFloat space = _space;
    NSInteger i = 0;
    CGFloat top = 0;
    CGFloat width = _itemWidth;
    CGFloat height = 0.34 * width;

    for (NSString *kText in self.numDecimalList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardDownButton *btn = [self createBtnWith:kText];
        CGFloat currentX = index * (width + space);
        btn.frame = CGRectMake(currentX, top + (height + space) * page, width, height);
        [self addSubview:btn];
        i ++;
    }
}
- (void)createNumKeyboardDividerView{
    NSInteger lineItem = 3;
    CGFloat space = _space;
    NSInteger i = 0;
    CGFloat top = 0;
    CGFloat width = _itemWidth;
    CGFloat height = 0.34 * width;

    for (NSString *kText in self.numList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardDownButton *btn = [self createBtnWith:kText];
        CGFloat currentX = index * (width + space);
        if([kText isEqual:@"-"]){
            btn = nil;
            i ++;
            continue;;
        }else if([kText isEqual:@""]){
            btn.keyColor = [UIColor clearColor];
            btn.specificNoDown = YES;
        }
        btn.frame = CGRectMake(currentX, top + (height + space) * page, width, height);
        [self addSubview:btn];
        i ++;
    }
}
- (YWKeyboardDownButton *)createBtnWith:(NSString *)kText{
    YWKeyboardDownButton *btn = [YWKeyboardDownButton buttonWithType:UIButtonTypeCustom];
    btn.drawShadow = NO;
    if ([kText isEqual:@""]) {
        btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
        btn.keyColor = self.deleteColor;
        [self numPad_addLongGesAction:btn];
    }else if([kText isEqual:@"."]){
        btn.keyColor = self.deleteColor;
    }
    btn.delegate = self;
    btn.dataSource = self;
    btn.input = kText;
    btn.textInput = _textInput;
    return btn;
}
//MARK: --- 长按 delete ----
- (void)numPad_addLongGesAction:(YWKeyboardDownButton *) btn{
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(numPad_deleteWithLognGes:)];
    [btn addGestureRecognizer:ges];
}

- (void)numPad_deleteWithLognGes:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.timer invalidate];
        self.timer = nil;
        self.timer = [NSTimer timerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(numPad_deleteAction)
                                           userInfo:nil
                                            repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }else if (sender.state == UIGestureRecognizerStateEnded){
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)numPad_deleteAction{
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

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize sizeThatFit = [super sizeThatFits:size];
    CGFloat lbh = YW_KEYBOARD_TABBARBOTTOM;
    if (_cellType == 0 || _cellType == 2) {
        _space = 0.5;
        _itemWidth = ([UIScreen mainScreen].bounds.size.width - _space * 2)/3;
        CGFloat height = 0.34 * _itemWidth;
        sizeThatFit.height = height * 4 + lbh + _space * 3;
    }else if(_cellType == 1 || _cellType == 3){
        _space = 10;
        _itemWidth = ([UIScreen mainScreen].bounds.size.width - _space * 4)/3;
        CGFloat height = 0.34 * _itemWidth;
        sizeThatFit.height = height * 4 + (lbh > 0 ? lbh : 10) + _space * 4;
    }
    return sizeThatFit;
}

- (NSMutableArray *)numDecimalList{
    if (!_numDecimalList) {
        _numDecimalList = [NSMutableArray arrayWithArray:@[
            @"1",@"2",@"3",
            @"4",@"5",@"6",
            @"7",@"8",@"9",
            @".",@"0",@""
        ]];
    }
    return _numDecimalList;
}

- (NSMutableArray *)numList{
    if (!_numList) {
        _numList = [NSMutableArray arrayWithArray:@[
            @"1",@"2",@"3",
            @"4",@"5",@"6",
            @"7",@"8",@"9",
            @"-",@"0",@""
        ]];
    }
    return _numList;
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
@end
