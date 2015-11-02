//
//  CoreTextView.m
//  coreText
//
//  Created by luwei on 15/10/29.
//  Copyright © 2015年 luwei. All rights reserved.
//

#import "CoreTextView.h"


//全局字体行间距
#define DEFAULT_FONT_SIZE           25
#define DEFAULT_LINE_SPACE          15
#define DEFAULT_WORD_SPACE          2

@interface CoreTextView (){
    NSInteger textRealLine;
    CGFloat textWidth;
    CGFloat textHeight;//单行显示的时候有用 用来计算文字矩形区域
    CGFloat lineAscent;
    CGFloat lineDescent;
    CGFloat lineLeading;
    CFIndex textIndex;
    BOOL isWordSpaceSetZero;
}
@property (nonatomic, strong) NSMutableAttributedString *attributedText;
@property (nonatomic, assign) BOOL needUpdateAttributedText;
@end

@implementation CoreTextView

-(CGFloat)getTextWidth{
    if (_needUpdateAttributedText) {
        [self updateAttributedText];
    }
    return textWidth;
}

-(void)setNeedUpdateAttributedText:(BOOL)needUpdateAttributedText{
    _needUpdateAttributedText = needUpdateAttributedText;
    if (needUpdateAttributedText == YES) {
        [self setNeedsDisplay];
    }
}

-(void)awakeFromNib{
    self.needUpdateAttributedText = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.needUpdateAttributedText = YES;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.needUpdateAttributedText) {
        [self updateAttributedText];
    }
    //获取画布句柄
    CGContextRef context = UIGraphicsGetCurrentContext();
    //颠倒窗口 坐标计算使用的mac下的坐标系 跟ios的坐标系正好颠倒
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    //生成富文本的信息 具体不懂  反正这是core text绘制的必须流程和对象
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    //这一步生成合适的绘制区域
    CGPathRef path = [self createPathWithLines];
    // Create a frame for this column and draw it.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0),
                                                path,
                                                (CFDictionaryRef)@{(id)kCTFrameProgressionAttributeName: @(kCTFrameProgressionRightToLeft)});
    CTFrameDraw(frame, context);
    //释放内存
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

//计算富文本绘制真实产生的行数 以及文本显示的rect的宽高
-(void)caculateRealLine{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    CGMutablePathRef path = CGPathCreateMutable();//创建一个path句柄
    CGPathAddRect(path, NULL, self.bounds);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0),
                                                path,
                                                (CFDictionaryRef)@{(id)kCTFrameProgressionAttributeName: @(kCTFrameProgressionRightToLeft)});
    
    CFArrayRef lines    = CTFrameGetLines(frame); //lines指向的指针是frame的属性 不能释放 否则释放frame时会过渡释放
    textRealLine        = CFArrayGetCount(lines); //we should always set textRealLine before we user self.numberOfLines
    textHeight          = 0;
    textWidth           = 0;
    for (int i = 0; i < self.numberOfLines; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat height = CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        if (textHeight < height) {
            textHeight = height;
        }
        /**根据苹果官方说法https://developer.apple.com/library/mac/documentation/TextFonts/Conceptual/CocoaTextArchitecture/TypoFeatures/TextSystemFeatures.html#//apple_ref/doc/uid/TP40009459-CH6-BBCFAEGE
         *大部分文字的显示区域应该是处于lineAscent 但是根据我debug得到的数据lineDescent正好是一个汉字的宽度 lineAscent跟lineDescent有关 具体关系不清楚
         *所以我有理由相信竖向显示汉字的区域处于lineDescent，但是行高的计算还是需要加上lineAscent 尽管貌似lineAscent区域没有绘制，或者lineAscent区域只绘制英文？
         *再有lineLeading,根据http://geeklu.com/2013/03/core-text/ 这篇博客说lineLeading就是行间距，但是只是在竖向显示时，这个lineLeading一直是0，所以我们需要额外加上行间距
         **/
        textWidth = textWidth + lineDescent + lineAscent + lineLeading + self.lineSpace;
    }
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

- (BOOL)isChinese:(NSString *)s index:(int)index {
    NSString *subString = [s substringWithRange:NSMakeRange(index, 1)];
    const char *cString = [subString UTF8String];
    return strlen(cString) == 3;
}

////这一步生成合适的绘制区域 默认规则是居中
- (CGPathRef)createPathWithLines
{
    // 居中显示 计算中间的矩形
    CGFloat startX = self.bounds.origin.x;//default x, y
    CGFloat startY = self.bounds.origin.y;
    if (self.baseLine & CoreTextBaseLineCenter) {
        //居中显示
        startX = (self.bounds.size.width - textWidth - self.lineSpace - lineAscent * 0.5) * 0.5 + self.bounds.origin.x;//不要问我为什么lineAscent*0.5 都是调试出来的......
        startY = (self.bounds.size.height - textHeight) * 0.5 + self.bounds.origin.y;
    }else{
        //需要注意！！！！！！！！这里计算的区域Y坐标是mac坐标系下的坐标 也就是说本来Top的时候应该是self.bounds.origin.y，这个在逻辑上也说得通，可是实际效果是Bottom得效果。
        if (self.baseLine & CoreTextBaseLineTop) {
            //确定Y坐标
            startY = (self.bounds.size.height - textHeight) + self.bounds.origin.y;
        }
        if (self.baseLine & CoreTextBaseLineBottom) {
            startY = self.bounds.origin.y;
        }
        if (self.baseLine & CoreTextBaseLineLeft) {
            //确定X坐标
            startX = self.bounds.origin.x - lineAscent * 0.5 - self.lineSpace;//不要问我为什么lineAscent*0.5 都是调试出来的......
        }
        if (self.baseLine & CoreTextBaseLineRight) {
            startX = (self.bounds.size.width - textWidth) + self.bounds.origin.x;
        }
        if (self.baseLine & CoreTextBaseLineCenterX) {
            //确定X坐标
            startX = (self.bounds.size.width - textWidth - self.lineSpace - lineAscent) * 0.5 + self.bounds.origin.x;
        }
        if (self.baseLine & CoreTextBaseLineCenterY) {
            //确定Y坐标
            startY = (self.bounds.size.height - textHeight) * 0.5 + self.bounds.origin.y;
        }
    }
    CGRect contentRect = CGRectMake(startX, startY, textWidth, textHeight);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, contentRect);
    return path;
}


@synthesize numberOfLines = _numberOfLines, font = _font,
textColor = _textColor, text = _text, lineSpace = _lineSpace,
baseLine = _baseLine, wordSpace = _wordSpace;

-(void)setWordSpace:(CGFloat)wordSpace{
    isWordSpaceSetZero = (wordSpace == 0);
    if (_wordSpace != wordSpace) {
        _wordSpace = wordSpace;
        self.needUpdateAttributedText = YES;
    }
}

-(CGFloat)wordSpace{
    if (_wordSpace == 0 && !isWordSpaceSetZero) {
        _wordSpace = DEFAULT_WORD_SPACE;
    }
    return _wordSpace;
}

-(void)setBaseLine:(CoreTextBaseLine)baseLine{
    if (_baseLine != baseLine) {
        _baseLine = baseLine;
        [self setNeedsDisplay];
    }
}

-(CoreTextBaseLine)baseLine{
    if (_baseLine == 0) {
        _baseLine = CoreTextBaseLineCenter;
    }
    return _baseLine;
}

-(void)setLineSpace:(CGFloat)lineSpace{
    if (_lineSpace != lineSpace) {
        _lineSpace = lineSpace;
        self.needUpdateAttributedText = YES;
    }
}

-(CGFloat)lineSpace{
    if (_lineSpace == 0) {
        return DEFAULT_LINE_SPACE;
    }else{
        return _lineSpace;
    }
}

-(void)setFont:(UIFont *)font{
    _font = font;
    if (self.font) {
        self.needUpdateAttributedText = YES;
    }
}

-(UIFont *)font{
    if (_font == nil) {
        _font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
    }
    return _font;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    if (self.textColor) {
        self.needUpdateAttributedText = YES;
    }
}

-(UIColor *)textColor{
    if (_textColor == nil) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}


-(void)setText:(NSString *)text{
    if (text && ![self.text isEqualToString:text]) {
        _text = text;
        self.needUpdateAttributedText = YES;
    }else{
        _text = text;
    }
}

-(NSString *)text{
    if (_text == nil) {
        _text = @"";
    }
    return _text;
}

-(void)setNumberOfLines:(NSInteger)numberOfLines{
    if (numberOfLines >= 0 && _numberOfLines != numberOfLines) {
        _numberOfLines = numberOfLines;
        self.needUpdateAttributedText = YES;
    }
}

-(NSInteger)numberOfLines{
    return _numberOfLines > 0 ? (_numberOfLines > textRealLine ? textRealLine : _numberOfLines) : textRealLine;
}


-(CGSize)singleWordSize{
    NSString *text = @"文";
    CGSize labelsize = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    return labelsize;
}


-(void)updateAttributedText{
    self.needUpdateAttributedText = NO;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.text attributes:nil];
    
    for (int i = 0; i < attrStr.length; i++) {
        if ([self isChinese:self.text index:i]) {
            [attrStr addAttribute:(id)kCTVerticalFormsAttributeName
                            value:@YES
                            range:NSMakeRange(i, 1)];
            [attrStr addAttribute:NSKernAttributeName value:@(self.wordSpace) range:NSMakeRange(i, 1)];
        }
    }
    
    //为所有文本设置字体
    if (self.font) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
        // Set the lineSpacing.
        CGFloat lineSpacing = CTFontGetLeading(fontRef) + self.lineSpace;
        // Create the paragraph style settings.
        CTParagraphStyleSetting setting;
        setting.spec = kCTParagraphStyleSpecifierLineSpacing;
        setting.valueSize = sizeof(CGFloat);
        setting.value = &lineSpacing;
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(&setting, 1);
        [attrStr addAttribute:(NSString *)kCTFontAttributeName
                        value:(__bridge id _Nonnull)(fontRef)
                        range:NSMakeRange(0, [attrStr length])];
        [attrStr addAttribute:(id)kCTParagraphStyleAttributeName
                        value:(__bridge id)paragraphStyle
                        range:NSMakeRange(0, [attrStr length])];
        CFRelease(fontRef);
        CFRelease(paragraphStyle);
    }
    
    if (self.textColor) {
        //设置颜色
        [attrStr addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(__bridge id _Nonnull)(self.textColor.CGColor)
                        range:NSMakeRange(0,attrStr.length)];
    }
    
    self.attributedText = attrStr;
    [self caculateRealLine];
    [self setNeedsDisplay];
}


@end
