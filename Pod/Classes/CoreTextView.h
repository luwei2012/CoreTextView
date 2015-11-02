//
//  CoreTextView.h
//  CoreTextView
//
//  Created by luwei on 15/10/29.
//  Copyright © 2015年 luwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

typedef enum _CoreTextBaseLine{
    CoreTextBaseLineCenter  = 0x0000001,
    CoreTextBaseLineTop     = 0x0000010,
    CoreTextBaseLineLeft    = 0x0000100,
    CoreTextBaseLineBottom  = 0x0001000,
    CoreTextBaseLineRight   = 0x0010000,
    CoreTextBaseLineCenterX = 0x0100000,
    CoreTextBaseLineCenterY = 0x1000000,
}CoreTextBaseLine;

@interface CoreTextView : UIView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSInteger numberOfLines;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) CGFloat wordSpace;
@property (nonatomic, assign) CoreTextBaseLine baseLine;
@property (nonatomic, strong) NSString *text;

-(CGFloat)getTextWidth;

@end
