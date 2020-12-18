//
//  YWProvinceLicensePlatePrefixView.m
//  NMChangJieCloud
//
//  Created by yaowei on 2018/12/14.
//

#import "YWProvinceLicensePlatePrefixView.h"
#import "YWKeyboardButton.h"

@interface YWProvinceLicensePlatePrefixView ()<YWKeyboardButtonDelegate>

@property (nonatomic, weak,  readwrite) id<UITextInput> textInput;

@property (nonatomic, strong          ) NSMutableArray *proviceCodeList;
 
@property (nonatomic, weak            ) UIView *proviceCodeView;

@property (nonatomic, strong          ) UIColor *deleteColor;

@property (nonatomic, strong, nullable) NSBundle *thisBundle;


@end


@implementation YWProvinceLicensePlatePrefixView




+ (instancetype)getDefalutProvinceKeyBoardView:(id<UITextInput>)textInput{
    return [[YWProvinceLicensePlatePrefixView alloc] initWithFrame:CGRectZero inputViewStyle:UIInputViewStyleDefault textInput:textInput];
}
- (instancetype)initWithFrame:(CGRect)frame
               inputViewStyle:(UIInputViewStyle)inputViewStyle
                    textInput:(id<UITextInput>)textInput{
    self = [super initWithFrame:frame inputViewStyle:inputViewStyle];
    if (self) {
        _textInput = textInput;
        [self createViewProviceCodeView];
    }
    return self;
}









- (void)createViewProviceCodeView{
    
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
        _proviceCodeView = v;
        v;
    })];
    
    
    for (NSString *kText in self.proviceCodeList) {
        NSInteger index = i % lineItem;
        NSInteger page  = i / lineItem;
        YWKeyboardButton *btn = [YWKeyboardButton buttonWithType:UIButtonTypeCustom];
        CGFloat currentX = index * (width + space) + leftX;
        btn.frame = CGRectMake(currentX, top + (height + top + top) * page, width, height);
        if (i == 38){
            btn.iconImage = [self getImageOnBundleWithImage:@"yw_keyboard_over"];
            btn.tag = 902;
            btn.frame = CGRectMake(currentX, top + (height + top + top) * page, width * 2 + space, height);
            btn.keyColor = self.deleteColor;
            btn.delegate = self;
        }
        btn.input = kText;
        btn.textInput = _textInput;
        [_proviceCodeView addSubview:btn];
        i ++;
    }
}
//MARK: -------- YWKeyboardButtonDelegate -----------
- (BOOL)needDrawAmplification:(YWKeyboardButton *)button{
    if (button.tag == 902) {
        return NO;
    }
    return YES;
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
        _proviceCodeList = [NSMutableArray arrayWithArray:
                            @[@"京",@"津",@"渝",@"沪",@"冀",@"晋",@"辽",@"吉",@"黑",@"苏",
                              @"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"琼",
                              @"川",@"贵",@"云",@"陕",@"甘",@"青",@"蒙",@"桂",@"宁",@"新",
                              @"藏",@"使",@"领",@"警",@"学",@"港",@"澳",@"挂", @""
                            ]];
    }
    return _proviceCodeList;
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
