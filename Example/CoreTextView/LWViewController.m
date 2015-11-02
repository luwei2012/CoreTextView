//
//  LWViewController.m
//  CoreTextView
//
//  Created by 1071932819@qq.com on 11/02/2015.
//  Copyright (c) 2015 1071932819@qq.com. All rights reserved.
//

#import "LWViewController.h"

#define WORK_CATEGORY_FONT_SIZE     13
#define SC_LIGHTFONT @"SourceHanSansCN-Light"

@interface LWViewController ()
@property (weak, nonatomic) IBOutlet CoreTextView *testLabel;

@end

@implementation LWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.testLabel.text = @"说撒了肯定舒服啊手动覅家多岁的方式是的发生的阿斯顿发生地方拉屎的；阿斯兰的框架房老师的就开始剪短发看来是撒开了多久啊斯柯达萨都剌阿萨德焚枯食淡奥斯卡交电话费是肯定深刻的机会是肯定";
    self.testLabel.textColor             = [LWViewController colorWithHexString:@"#235689"];
    self.testLabel.font                  = [UIFont fontWithName:SC_LIGHTFONT size:WORK_CATEGORY_FONT_SIZE];
    self.testLabel.numberOfLines         = 4;
    //    self.testLabel.baseLine              = CoreTextBaseLineLeft | CoreTextBaseLineBottom;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  将16进制颜色字符串转换成uicolor
 *
 *  @param
 *
 *  @return
 */
#define DEFAULT_VOID_COLOR [UIColor clearColor]
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
