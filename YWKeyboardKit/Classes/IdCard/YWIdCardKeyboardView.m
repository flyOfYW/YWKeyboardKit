//
//  YWIdCardKeyboardView.m
//  JXNewAirRecharge
//
//  Created by yaowei on 2019/10/11.
//

#import "YWIdCardKeyboardView.h"
#import <YWKeyboardKit/YWKeyboardButton.h>

@interface YWIdCardKeyboardView ()<YWKeyboardButtonDelegate>
{
    CGFloat _itemWidth;
    CGFloat _dividerSpace;
}
@property (nonatomic, weak,  readwrite) id<UITextInput> textInput;
@property (nonatomic, strong          ) NSMutableArray  *numList;
@property (nonatomic, strong, nullable) NSBundle        *thisBundle;
@property (nonatomic, strong          ) UIColor         *deleteColor;
@property (nonatomic, assign          ) NSInteger        cellType;
@property (nonatomic, strong, nullable) NSTimer *timer;
@end

@implementation YWIdCardKeyboardView

+ (instancetype)getIdCardKeyboardDividerView:(id<UITextInput>)textInput{
    YWIdCardKeyboardView *kView = [[self alloc] initWithFrame:CGRectZero inputViewStyle:UIInputViewStyleKeyboard textInput:textInput cellType:0];
    return kView;
}
+ (instancetype)getIdCardKeyboardShadowView:(id<UITextInput>)textInput{
    YWIdCardKeyboardView *kView = [[self alloc] initWithFrame:CGRectZero inputViewStyle:UIInputViewStyleKeyboard textInput:textInput cellType:1];
    return kView;
}
- (instancetype)initWithFrame:(CGRect)frame
               inputViewStyle:(UIInputViewStyle)inputViewStyle
                    textInput:(id<UITextInput>)textInput
                     cellType:(NSInteger)cellType{
    self = [super initWithFrame:frame inputViewStyle:inputViewStyle];
    if (self) {
        _cellType = cellType;
        _dividerSpace = 0.5;
        [self sizeToFit];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _textInput = textInput;
        _downGrayEffect = YES;
        //赋值触发UI搭建
        self.cellType = cellType;
    }
    return self;
}
//MARK: --- YWKeyboardButtonDelegate ---
- (BOOL)needDownGrayEffect:(YWKeyboardButton *)button{
    if (_cellType == 0) {
        return _downGrayEffect;
    }
    if (_cellType == 1) {
        return _downGrayEffect;
    }
    return NO;
}
//MARK: --- 单元格圆角样式的view ---
- (void)createShadowView{
    NSInteger lineItem = 3;
    CGFloat space = 10;
    NSInteger i = 0;
    CGFloat top = 10;
    CGFloat width = _itemWidth;
    CGFloat height = 0.34 * width;
    CGFloat leftX = 10;

    for (NSString *kText in self.numList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardDownButton *btn = [YWKeyboardDownButton buttonWithType:UIButtonTypeCustom];
        CGFloat currentX = index * (width + space) + leftX;
        btn.frame = CGRectMake(currentX, top + (height + top) * page, width, height);
        if ([kText isEqual:@""]) {
            btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
            btn.keyColor = self.deleteColor;
            [self idcard_addLongGesAction:btn];
        }
        btn.delegate = self;
        btn.input = kText;
        btn.textInput = _textInput;
        [self addSubview:btn];
        i ++;
    }
}

//MARK: --- 分割线样式的view ---
- (void)createDividerView{
    
    NSInteger lineItem = 3;
    CGFloat space = _dividerSpace;
    NSInteger i = 0;
    CGFloat top = 0;
    CGFloat width = _itemWidth;
    CGFloat height = 0.34 * width;

    for (NSString *kText in self.numList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardDownButton *btn = [YWKeyboardDownButton buttonWithType:UIButtonTypeCustom];
        CGFloat currentX = index * (width + space);
        btn.frame = CGRectMake(currentX, top + (height + space) * page, width, height);
        btn.drawShadow = NO;
        if ([kText isEqual:@""]) {
            btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
            btn.keyColor = self.deleteColor;
            [self idcard_addLongGesAction:btn];
        }
        btn.delegate = self;
        btn.input = kText;
        btn.textInput = _textInput;
        [self addSubview:btn];
        i ++;
    }
}
//MARK: --- 长按 delete ----
- (void)idcard_addLongGesAction:(YWKeyboardDownButton *) btn{
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(idcard_deleteWithLognGes:)];
    [btn addGestureRecognizer:ges];
}

- (void)idcard_deleteWithLognGes:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.timer invalidate];
        self.timer = nil;
        self.timer = [NSTimer timerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(idcard_deleteAction)
                                           userInfo:nil
                                            repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }else if (sender.state == UIGestureRecognizerStateEnded){
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)idcard_deleteAction{
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
    if (_cellType == 0) {
        _itemWidth = ([UIScreen mainScreen].bounds.size.width - _dividerSpace * 2)/3;
        CGFloat height = 0.34 * _itemWidth;
        sizeThatFit.height = height * 4 + lbh + _dividerSpace * 3;
    }else if(_cellType == 1){
        _itemWidth = ([UIScreen mainScreen].bounds.size.width - 40)/3;
        CGFloat height = 0.34 * _itemWidth;
        sizeThatFit.height = height * 4 + (lbh > 0 ? lbh : 10) + 40;
    }
    return sizeThatFit;
}

//MARK: --- getter && setter
- (void)setCellType:(NSInteger)cellType{
    _cellType = cellType;
    switch (cellType) {
        case 0:
            [self createDividerView];
            break;
        case 1:
            [self createShadowView];
            break;
            
        default:
            break;
    }
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

- (NSMutableArray *)numList{
    if (!_numList) {
        _numList = [NSMutableArray arrayWithArray:@[
            @"1",@"2",@"3",
            @"4",@"5",@"6",
            @"7",@"8",@"9",
            @"X",@"0",@""
        ]];
    }
    return _numList;
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
