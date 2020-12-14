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
    tf2.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf2];
    
    
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
