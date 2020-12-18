//
//  YWTipUpView.m
//  TextKeyBoard
//
//  Created by Mr.Yao on 2020/2/27.
//  Copyright © 2020 Mr.Yao. All rights reserved.
//

#import "YWTipUpView.h"
#import "YWKeyboardButton.h"
#import "TurtleBezierPath.h"

@interface YWTipUpView ()

@property (nonatomic, weak) YWKeyboardButton *button;
@property (nonatomic, strong) NSMutableArray *inputOptionRects;
@property (nonatomic, assign) NSInteger selectedInputIndex;

@end


@implementation YWTipUpView

- (instancetype)initWithKeyboardButton:(YWKeyboardButton *)button{
    CGRect frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if (self) {
        _button = button;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    if (_button.drawAmplification) {
        [self drawInputView:rect];
    }else{
        [super drawRect:rect];
    }
}
- (UIBezierPath *)inputViewPath{
    CGRect keyRect = [self convertRect:self.button.frame fromView:self.button.superview];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(7, 13, 7, 13);
    CGFloat upperWidth = CGRectGetWidth(_button.frame) + insets.left + insets.right;
    CGFloat lowerWidth = CGRectGetWidth(_button.frame);
    CGFloat majorRadius = 10.f;
    CGFloat minorRadius = 4.f;
    
    TurtleBezierPath *path = [TurtleBezierPath new];
    [path home];
    path.lineWidth = 0;
    path.lineCapStyle = kCGLineCapRound;
    
    switch (self.button.position) {
        case YWKeyboardButtonPositionInner:
        {
            [path rightArc:majorRadius turn:90]; // #1
            [path forward:upperWidth - 2 * majorRadius]; // #2 top
            [path rightArc:majorRadius turn:90]; // #3
            [path forward:CGRectGetHeight(keyRect) - 2 * majorRadius + insets.top + insets.bottom]; // #4 right big
            [path rightArc:majorRadius turn:48]; // #5
            [path forward:8.5f];
            [path leftArc:majorRadius turn:48]; // #6
            [path forward:CGRectGetHeight(keyRect) - 8.5f + 1];
            [path rightArc:minorRadius turn:90];
            [path forward:lowerWidth - 2 * minorRadius]; //  lowerWidth - 2 * minorRadius + 0.5f
            [path rightArc:minorRadius turn:90];
            [path forward:CGRectGetHeight(keyRect) - 2 * minorRadius];
            [path leftArc:majorRadius turn:48];
            [path forward:8.5f];
            [path rightArc:majorRadius turn:48];
            
            CGFloat offsetX = 0, offsetY = 0;
            CGRect pathBoundingBox = path.bounds;
            
            offsetX = CGRectGetMidX(keyRect) - CGRectGetMidX(path.bounds);
            offsetY = CGRectGetMaxY(keyRect) - CGRectGetHeight(pathBoundingBox) + 10;
            
            [path applyTransform:CGAffineTransformMakeTranslation(offsetX, offsetY)];
        }
            break;
            
        case YWKeyboardButtonPositionLeft:
        {
            [path rightArc:majorRadius turn:90]; // #1
            [path forward:upperWidth - 2 * majorRadius]; // #2 top
            [path rightArc:majorRadius turn:90]; // #3
            [path forward:CGRectGetHeight(keyRect) - 2 * majorRadius + insets.top + insets.bottom]; // #4 right big
            [path rightArc:majorRadius turn:45]; // #5
            [path forward:28]; // 6
            [path leftArc:majorRadius turn:45]; // #7
            [path forward:CGRectGetHeight(keyRect) - 26 + (insets.left + insets.right) / 4]; // #8
            [path rightArc:minorRadius turn:90]; // 9
            [path forward:path.currentPoint.x - minorRadius]; // 10
            [path rightArc:minorRadius turn:90]; // 11
            
            
            CGFloat offsetX = 0, offsetY = 0;
            CGRect pathBoundingBox = path.bounds;
            
            offsetX = CGRectGetMaxX(keyRect) - CGRectGetWidth(path.bounds);
            offsetY = CGRectGetMaxY(keyRect) - CGRectGetHeight(pathBoundingBox) - CGRectGetMinY(path.bounds);
            
            [path applyTransform:CGAffineTransformTranslate(CGAffineTransformMakeScale(-1, 1), -offsetX - CGRectGetWidth(path.bounds), offsetY)];
        }
            break;
            
        case YWKeyboardButtonPositionRight:
        {
            [path rightArc:majorRadius turn:90]; // #1
            [path forward:upperWidth - 2 * majorRadius]; // #2 top
            [path rightArc:majorRadius turn:90]; // #3
            [path forward:CGRectGetHeight(keyRect) - 2 * majorRadius + insets.top + insets.bottom]; // #4 right big
            [path rightArc:majorRadius turn:45]; // #5
            [path forward:28]; // 6
            [path leftArc:majorRadius turn:45]; // #7
            [path forward:CGRectGetHeight(keyRect) - 26 + (insets.left + insets.right) / 4]; // #8
            [path rightArc:minorRadius turn:90]; // 9
            [path forward:path.currentPoint.x - minorRadius]; // 10
            [path rightArc:minorRadius turn:90]; // 11
            
            CGFloat offsetX = 0, offsetY = 0;
            CGRect pathBoundingBox = path.bounds;
            
            offsetX = CGRectGetMinX(keyRect);
            offsetY = CGRectGetMaxY(keyRect) - CGRectGetHeight(pathBoundingBox) - CGRectGetMinY(path.bounds);
            
            [path applyTransform:CGAffineTransformMakeTranslation(offsetX, offsetY)];
        }
            break;
            
        default:
            break;
    }
    
    return path;
}

- (void)drawInputView:(CGRect)rect{
    {
        // Generate the overlay
        UIBezierPath *bezierPath = [self inputViewPath];
        NSString *inputString = self.button.input ? self.button.input : @"";
        
        // Position the overlay
        CGRect keyRect = [self convertRect:self.button.frame fromView:self.button.superview];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Overlay path & shadow
        {
            //// Shadow Declarations
            UIColor* shadow = [[UIColor blackColor] colorWithAlphaComponent: 0.5];
            CGSize shadowOffset = CGSizeMake(0, 0.5);
            CGFloat shadowBlurRadius = 2;
            
            //// Rounded Rectangle Drawing
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
            [self.button.keyColor setFill];
            [bezierPath fill];
            CGContextRestoreGState(context);
        }
        
        // Draw the key shadow sliver
        {
            //// Color Declarations
            UIColor *color = self.button.keyColor;
            
            //// Shadow Declarations
            UIColor *shadow = self.button.keyShadowColor;
            CGSize shadowOffset = CGSizeMake(0.1, 1.1);
            CGFloat shadowBlurRadius = 0;
            
            //// Rounded Rectangle Drawing
            UIBezierPath *roundedRectanglePath =
            [UIBezierPath bezierPathWithRoundedRect:CGRectMake(keyRect.origin.x, keyRect.origin.y, keyRect.size.width, keyRect.size.height - 1) cornerRadius:4];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
            [color setFill];
            [roundedRectanglePath fill];
            
            CGContextRestoreGState(context);
        }
        
        // Text drawing
        {
            UIColor *stringColor = self.button.keyTextColor;
            
            CGRect stringRect = bezierPath.bounds;
            
            NSMutableParagraphStyle *p = [NSMutableParagraphStyle new];
            p.alignment = NSTextAlignmentCenter;
            
            NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                    initWithString:inputString
                                                    attributes:
                                                    @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:44], NSForegroundColorAttributeName : stringColor, NSParagraphStyleAttributeName : p}];
            [attributedString drawInRect:stringRect];
        }
    }
}

@end
