//
//  YFTapLabel.m
//  LabelDemo
//
//  Created by 孙云飞 on 2018/11/19.
//  Copyright © 2018 孙云飞. All rights reserved.
//

#import "YFTapLabel.h"
#import <CoreText/CoreText.h>
@interface YFTapLabel()
@property(nonatomic,strong)NSArray *taps;
@end
@implementation YFTapLabel

- (void)setText:(NSString *)text attrParams:(NSDictionary *)param tapArrays:(NSArray<YFTapModel *> *)tapArrays{
    
    self.taps = tapArrays;
    __block NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attrStr addAttributes:param range:NSMakeRange(0, text.length)];
    [tapArrays enumerateObjectsUsingBlock:^(YFTapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [attrStr addAttributes:obj.attrParam range:obj.range];
        
    }];
    
    self.attributedText = attrStr;
    self.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [self touchPoint:p];
}

- (void)touchPoint:(CGPoint)p{
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedText.length), path, NULL);
    
    CFRange range = CTFrameGetVisibleStringRange(frame);
    
    if (self.attributedText.length > range.length) {
        
        UIFont *font = nil;
        
        if ([self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil]) {
            
            font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        }else if (self.font){
            font = self.font;
        }else{
            
            font = [UIFont systemFontOfSize:12];
        }
        
        CGPathRelease(path);
        path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + font.lineHeight));
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    CFIndex count = CFArrayGetCount(lines);
    
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, count) : count;
    
    if (!numberOfLines) {
        
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(path);
        return;
    }
    
    CGPoint origins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), origins);
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.width), 1.f, -1.f);
    
    CGFloat verticalOffset = 0;
    
    for(CFIndex i = 0;i < numberOfLines;i ++){
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGFloat ascent = 0.0f;
        CGFloat descent = 0.0f;
        CGFloat leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat height = ascent + fabs(descent * 2) + leading;
        CGRect flippedRect = CGRectMake(p.x, p.y, width, height);
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        rect = CGRectInset(rect, 0, 0);
        rect = CGRectOffset(rect, 0, verticalOffset);
        
        NSParagraphStyle *style = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        CGFloat lineSpace;
        
        if (style) {
            
            lineSpace= style.lineSpacing;
        }else
            lineSpace = 0;
        
        CGFloat lineOutSpace = (self.bounds.size.height - lineSpace * (count - 1) - rect.size.height * count) / 2;
        
        rect.origin.y = lineOutSpace + rect.size.height * i + lineSpace * i;
        
        if (CGRectContainsPoint(rect, p)) {
            
            CGPoint relativePoint = CGPointMake(p.x, p.y);
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            CGFloat offset;
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                
                index = index - 1;
            }
            
            NSInteger line_count = self.taps.count;
            for(int j = 0;j < line_count;j ++){
                
                YFTapModel *model = self.taps[j];
                NSRange tmp = model.range;
                if (NSLocationInRange(index, tmp)) {
                    
                    if (self.tapBlock) {
                        
                        self.tapBlock(model.tapStr);
                    }
                }
            }
        }
        
    }
    
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(path);
    
}

@end

@implementation YFTapModel

@end
