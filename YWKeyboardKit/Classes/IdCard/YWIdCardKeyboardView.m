//
//  YWIdCardKeyboardView.m
//  JXNewAirRecharge
//
//  Created by yaowei on 2019/10/11.
//

#import "YWIdCardKeyboardView.h"
#import "YWKeyboardButton.h"

@interface YWIdCardKeyboardView ()<YWKeyboardButtonDelegate>
{
    CGFloat _itemWidth;
}
@property (nonatomic, weak,  readwrite) id<UITextInput> textInput;
@property (nonatomic, strong          ) NSMutableArray  *numList;
@property (nonatomic, strong          ) UIColor         *deleteColor;
@property (nonatomic, strong, nullable) NSBundle        *thisBundle;
@property (nonatomic, strong          ) UIColor         *keyShadowColor;
@property (nonatomic, assign          ) NSInteger        cellType;
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
                    textInput:(id<UITextInput>)textInput cellType:(NSInteger)cellType{
    self = [super initWithFrame:frame inputViewStyle:inputViewStyle];
    if (self) {
        _cellType = cellType;
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
        if (!_downGrayEffect) {
            button.highlighted = NO;
        }
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
    CGFloat height = 0.33 * width;
    CGFloat leftX = 10;

    for (NSString *kText in self.numList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardButton *btn = [YWKeyboardButton buttonWithType:UIButtonTypeSystem];
        CGFloat currentX = index * (width + space) + leftX;
        btn.frame = CGRectMake(currentX, top + (height + top) * page, width, height);
        btn.drawAmplification = NO;
        if ([kText isEqual:@""]) {
            btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
            btn.keyColor = self.deleteColor;
        }else{
            btn.keyColor = self.deleteColor;
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
    CGFloat space = 1;
    NSInteger i = 0;
    CGFloat top = 0;
    CGFloat width = _itemWidth;
    CGFloat height = 0.34 * width;

    for (NSString *kText in self.numList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardButton *btn = [YWKeyboardButton buttonWithType:UIButtonTypeSystem];
        CGFloat currentX = index * (width + space);
        btn.frame = CGRectMake(currentX, top + (height + 1) * page, width, height);
        btn.drawShadow = NO;
        btn.drawAmplification = NO;
        if ([kText isEqual:@""]) {
            btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
            btn.keyColor = self.deleteColor;
        }else{
            btn.keyColor = self.deleteColor;
        }
        btn.delegate = self;
        btn.input = kText;
        btn.textInput = _textInput;
        btn.backgroundColor = self.keyShadowColor;
        [self addSubview:btn];
        i ++;
    }
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
    if (_cellType == 0) {
        _itemWidth = ([UIScreen mainScreen].bounds.size.width - 2)/3;
        CGFloat height = 0.34 * _itemWidth;
        sizeThatFit.height = height * 4 + YW_KEYBOARD_TABBARBOTTOM + 3;
    }else if(_cellType == 1){
        _itemWidth = ([UIScreen mainScreen].bounds.size.width - 40)/3;
        CGFloat height = 0.33 * _itemWidth;
        sizeThatFit.height = height * 4 + YW_KEYBOARD_TABBARBOTTOM + 40;
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

- (UIColor *)keyShadowColor{
    if (@available(iOS 13.0, *)) {
        _keyShadowColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:45.0 / 255.f green:45.0 / 255.f blue:45.0 / 255.f alpha:1];
            }else{
                return [UIColor whiteColor];
            }
        }];
        
    } else {
        _keyShadowColor = [UIColor whiteColor];
    }
    return _keyShadowColor;;
}

@end
