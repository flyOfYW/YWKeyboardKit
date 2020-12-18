//
//  YWViewController.m
//  YWKeyboardKit
//
//  Created by yw on 12/14/2020.
//  Copyright (c) 2020 yw. All rights reserved.
//

#import "YWViewController.h"
#import <YWKeyboardKit/YWLicensePlateView.h>
#import <YWKeyboardKit/YWProvinceLicensePlatePrefixView.h>
#import <YWKeyboardKit/YWInputToolbar.h>

#import <YWKeyboardKit/YWIdCardKeyboardView.h>


@interface YWViewController ()
<UITextFieldDelegate>
@end

@implementation YWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 80   , 34)];
    tf.adjustsFontSizeToFitWidth = YES;
    tf.placeholder = @"前缀车牌";
    tf.tag = 300;
    tf.delegate = self;
    tf.inputView = [YWProvinceLicensePlatePrefixView getDefalutProvinceKeyBoardView:tf];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf];
    
    UITextField *tf1 = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 140   , 34)];
    tf1.adjustsFontSizeToFitWidth = YES;
    tf1.placeholder = @"字母优先可切换车牌";
    tf1.inputView = [YWLicensePlateView getEnglishOrProvinceLicensePlate:tf1];
    tf1.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf1];
    
    UITextField *tf2 = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, 200   , 34)];
    tf2.adjustsFontSizeToFitWidth = YES;
    tf2.placeholder = @"一行输入车牌";
    tf2.inputView = [YWLicensePlateView getProvinceOrEnglishLicensePlate:tf2];
    YWInputToolbar *toolbar = [YWInputToolbar getInputToolbar:tf2];
    toolbar.title = @"ETC专用车牌键盘";
    tf2.inputAccessoryView = toolbar;
    tf2.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf2];
    
    UITextField *tf3 = [[UITextField alloc] initWithFrame:CGRectMake(20, 180, 160   , 34)];
    tf3.adjustsFontSizeToFitWidth = YES;
    tf3.placeholder = @"身份证键盘";
    tf3.inputView = [YWIdCardKeyboardView getIdCardKeyboardDividerView:tf3];
    YWInputToolbar *toolbar1 = [YWInputToolbar getInputToolbar:tf3];
    toolbar1.title = @"身份证专用键盘";
    tf3.inputAccessoryView = toolbar1;
    tf3.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf3];
    
    UITextField *tf4 = [[UITextField alloc] initWithFrame:CGRectMake(190, 180, 160   , 34)];
    tf4.adjustsFontSizeToFitWidth = YES;
    tf4.placeholder = @"身份证键盘";
    __block  YWIdCardKeyboardView *idCardKeyboardShadowView = [YWIdCardKeyboardView getIdCardKeyboardShadowView:tf4];
    tf4.inputView = idCardKeyboardShadowView;
    YWInputToolbar *toolbar2 = [YWInputToolbar getInputToolbar:tf4];
    toolbar2.leftImageNormal = [UIImage imageNamed:@"icon_eye"];
    toolbar2.leftImageSelected = [UIImage imageNamed:@"icon_eyeclose"];
    toolbar2.title = @" 身份证专用键盘";
    if (@available(iOS 13.0, *)) {
        toolbar2.logo = [[UIImage systemImageNamed:@"applelogo"] imageWithTintColor:[UIColor systemBlueColor]];
    }
    toolbar2.leftCall = ^(id  _Nullable obj) {
        idCardKeyboardShadowView.downGrayEffect = !idCardKeyboardShadowView.downGrayEffect;
    };
    tf4.inputAccessoryView = toolbar2;
    tf4.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf4];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 300) {
        textField.text = string;
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
