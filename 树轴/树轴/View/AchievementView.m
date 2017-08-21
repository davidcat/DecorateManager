//
//  AchievementView.m
//  树轴
//
//  Created by Harry on 2017/3/12.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import "AchievementView.h"

#define kCenterX    (self.frame.size.width * 0.5)
#define kCenterY    (self.frame.size.height * 0.5)

#define kDottedLineWidth 100 // 中间虚线宽度
#define kDottedLineColor [UIColor grayColor] // 中间虚线的颜色
#define kNoramlHeight 40 // 长线条的高度
#define kVerLineWith  1 // 竖线的宽度
#define kVerLineColor [UIColor grayColor] // 竖线的颜色
#define kCircleWidth  5 // 小圆直径
#define kCircleColor  [UIColor grayColor] // 小圆的颜色
#define kCirCleLineWidth 1 // 小圆描边宽度
#define kBottomDottedColor [UIColor purpleColor]


#define kNumFont   [UIFont systemFontOfSize:22]  // num的字体大小
#define kNumColor   [UIColor grayColor]    // num的颜色
#define kNumTopString  @"考核"
#define kNumTopFont   [UIFont systemFontOfSize:30]  // num上边的字体大小
#define kNumTopColor   [UIColor grayColor]    // num上边的颜色


NSString *const AchievementViewLeftTextSymbol = @"AchievementViewLeftText";
NSString *const AchievementViewRightTextSymbol = @"AchievementViewRightText";
NSString *const AchievementViewTextColorSymbol = @"AchievementViewTextColor";
NSString *const AchievementViewLeftFontSymbol = @"AchievementViewLeftFont";
NSString *const AchievementViewRightFontSymbol = @"AchievementViewRightFont";
NSString *const AchievementViewNumFontSymbol = @"AchievementViewNumFont";
NSString *const AchievementViewNumColorSymbol = @"AchievementViewNumColor";

@interface AchievementView ()

@end

@implementation AchievementView


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    // 异常
    NSAssert(self.dataArr != nil, @"数组不能为空");
    NSAssert(self.dataArr.count >= 3, @"最少三个才能达到对称关系");
    // 画虚线
    [self drawDottetd];
    
    // 偶数处理
    if (self.dataArr.count % 2 == 0) {
        [self.dataArr removeLastObject];
    }
    
    NSInteger centerLocation = (self.dataArr.count - 1) / 2;
    CGPoint upPoint = CGPointZero;
    CGPoint upPointLocation = CGPointMake(kCenterX, kCenterY);
    CGPoint downPoint = CGPointZero;
    CGPoint downPointLocation = CGPointMake(kCenterX, kCenterY);

    for (NSInteger i = centerLocation - 1, j = centerLocation + 1; i >= 0 || j < self.dataArr.count; i--,j++) {
        upPoint = [self drawLineWithPoint:upPointLocation withDirection:DirectionUp withItemDic:self.dataArr[i]];
        upPointLocation = upPoint;
        [self drawTextWithPoint:upPoint direction:DirectionUp itemDic:self.dataArr[i]];
    
        downPoint = [self drawLineWithPoint:downPointLocation withDirection:DirectionDown withItemDic:self.dataArr[i]];
        downPointLocation = downPoint;
        [self drawTextWithPoint:downPoint direction:DirectionDown itemDic:self.dataArr[j]];
    }
    
    [self drawTextWithPoint:CGPointMake(kCenterX, kCenterY) direction:DirectionCenter itemDic:self.dataArr[centerLocation]];

    NSString *center = [self.dataArr[centerLocation][AchievementViewRightTextSymbol] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *top = [[self.dataArr firstObject][AchievementViewRightTextSymbol] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *down = [[self.dataArr lastObject][AchievementViewRightTextSymbol] stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString *str = [self.numValue mutableCopy];
    
    NSString *numV = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    CGFloat numValue = numV.floatValue;
    
    CGFloat centerValue = [center floatValue];
    CGFloat topValue = [top floatValue];
    CGFloat downValue = [down floatValue];

    CGFloat deltaY =  downPoint.y - upPointLocation.y;
    
    CGFloat finalY = downPoint.y - deltaY * (numValue - downValue) / (topValue - downValue);

    CGFloat circleWidth = kCircleWidth * 0.5 + 1;

    if (numValue > centerValue) {
        circleWidth = - circleWidth;
    } else if (numValue == centerValue) {
        circleWidth = 0;
    }

    [self drawBottomDottetdViewWithPoint:CGPointMake(kCenterX, finalY - circleWidth)];
}


- (void)setNumValue:(NSString *)numValue
{
    _numValue = numValue;
    [self setNeedsDisplay];
}


#pragma mark - <画向左的线条>

- (void)drawBottomDottetdViewWithPoint:(CGPoint)point
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, kBottomDottedColor.CGColor);
    
    CGContextSetLineWidth(context, 1);
    
    CGContextMoveToPoint(context, point.x, point.y);
    
    CGContextAddLineToPoint(context, point.x - kDottedLineWidth*0.5, point.y);
    
    CGFloat arr[] = {3,1};
    
    CGContextSetLineDash(context, 0, arr, 2);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    
    UIFont *numFont = kNumFont;
    UIColor *numColor = kNumColor;


    CGFloat leftM = 10;
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, numColor.CGColor);
    
    CGRect leftRect = [self.numValue boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:numFont, NSForegroundColorAttributeName:numColor} context:nil];
    
    [self.numValue drawInRect:CGRectMake(point.x - kDottedLineWidth*0.5 - leftM - leftRect.size.width, point.y-leftRect.size.height*0.5, leftRect.size.width, leftRect.size.height) withAttributes:@{NSFontAttributeName:numFont, NSForegroundColorAttributeName:numColor}];
    
    
    CGRect topRect = [kNumTopString boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kNumTopFont, NSForegroundColorAttributeName:kNumTopColor} context:nil];

    [kNumTopString drawInRect:CGRectMake(point.x - kDottedLineWidth*0.5 - leftM - leftRect.size.width, point.y-leftRect.size.height*0.5 - 5 - topRect.size.height, topRect.size.width, topRect.size.height) withAttributes:@{NSFontAttributeName:kNumTopFont, NSForegroundColorAttributeName:kNumTopColor}];
    
    CGContextClosePath(context);
}



#pragma mark - <画文字>

- (void)drawTextWithPoint:(CGPoint)point direction:(ItemDirection)direction itemDic:(NSDictionary *)dic
{
    NSString *leftString = @"";
    NSString *rightString = @"";
    UIFont *leftFont = [UIFont systemFontOfSize:12];
    UIFont *rightFont = [UIFont systemFontOfSize:16];
    UIColor *showColor = [UIColor blackColor];
    
    leftString = dic[AchievementViewLeftTextSymbol];
    rightString = dic[AchievementViewRightTextSymbol];
    leftFont = dic[AchievementViewLeftFontSymbol];
    rightFont = dic[AchievementViewRightFontSymbol];
    showColor = dic[AchievementViewTextColorSymbol];

    CGFloat margin = -kCircleWidth*0.5;
    if (direction == DirectionUp) {
        margin = -margin;
    } else if (direction == DirectionCenter) {
        margin = 0;
    } else {
       margin = -kCircleWidth*0.5;
    }
    
    CGFloat leftM = 10;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, showColor.CGColor);

    CGRect leftRect = [leftString boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:leftFont} context:nil];

    [leftString drawInRect:CGRectMake(point.x+kDottedLineWidth*0.5+leftM, point.y+margin-leftRect.size.height*0.5, leftRect.size.width, leftRect.size.height) withAttributes:@{NSFontAttributeName:leftFont,NSForegroundColorAttributeName:showColor}];
    
    CGRect rightRect = [rightString boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:rightFont} context:nil];


    [rightString drawInRect:CGRectMake(point.x+kDottedLineWidth*0.5+50+2*leftM, point.y+margin-rightRect.size.height*0.5, rightRect.size.width, rightRect.size.height) withAttributes:@{NSFontAttributeName:rightFont,NSForegroundColorAttributeName:showColor}];

    CGContextClosePath(context);
}



#pragma mark - <画虚线>

- (void)drawDottetd
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, kDottedLineColor.CGColor);
    
    CGContextSetLineWidth(context, 1);
    
    CGContextMoveToPoint(context, kCenterX, kCenterY);
    
    CGContextAddLineToPoint(context, kCenterX - kDottedLineWidth*0.5, kCenterY);
    
    CGContextMoveToPoint(context, kCenterX, kCenterY);
    
    CGContextAddLineToPoint(context, kCenterX + kDottedLineWidth*0.5, kCenterY);

    CGFloat arr[] = {3,1};

    CGContextSetLineDash(context, 0, arr, 2);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextClosePath(context);
}


#pragma mark - <画直线和画圆>

- (CGPoint)drawLineWithPoint:(CGPoint)point withDirection:(ItemDirection)direction withItemDic:(NSDictionary *)dic
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    CGContextSetLineWidth(context, kVerLineWith);
    
    CGContextSetAllowsAntialiasing(context, true);
    
    CGContextSetStrokeColorWithColor(context, kVerLineColor.CGColor);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, point.x, point.y);
    
    if (direction == DirectionUp) {
        CGContextAddLineToPoint(context, point.x, point.y-kNoramlHeight);
    } else {
        CGContextAddLineToPoint(context, point.x, point.y+kNoramlHeight);
    }
    CGContextStrokePath(context);
    
    CGRect bigRect = CGRectZero;
    if (direction == DirectionUp) {
        bigRect = CGRectMake(point.x-kCircleWidth*0.5,
                                point.y-kNoramlHeight,
                                kCircleWidth,
                                -kCircleWidth);
    } else {
        bigRect =  CGRectMake(point.x-kCircleWidth*0.5,
                                point.y+kNoramlHeight,
                                kCircleWidth,
                                kCircleWidth);
    }
    
    //设置空心圆的线条宽度
    CGContextSetLineWidth(context, kCirCleLineWidth);

    CGContextAddEllipseInRect(context, bigRect);
    
    
    UIColor *circleColor = kCircleColor;

    circleColor = dic[AchievementViewTextColorSymbol];
    
    [circleColor set];
    
    CGContextStrokePath(context);
    
    CGPoint endPoint = CGPointZero;
    
    if (direction == DirectionUp) {
        endPoint = CGPointMake(kCenterX, bigRect.origin.y-kCircleWidth-kCirCleLineWidth);
    } else {
        endPoint = CGPointMake(kCenterX, bigRect.origin.y+kCircleWidth+kCirCleLineWidth);
    }
    
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextSetLineWidth(context, kVerLineWith);
    
    CGContextSetAllowsAntialiasing(context, true);
    
    CGContextSetStrokeColorWithColor(context, kVerLineColor.CGColor);
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, endPoint.x, endPoint.y);
    
    if (direction == DirectionUp) {
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y-kNoramlHeight*0.5);
    } else {
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y+kNoramlHeight*0.5);
    }
    
    CGContextStrokePath(context);
    
    CGContextClosePath(context);
    
    return endPoint;
}


@end














