//
//  AchievementView.h
//  树轴
//
//  Created by Harry on 2017/3/12.
//  Copyright © 2017年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ItemDirection) {
    DirectionUp,
    DirectionCenter,
    DirectionDown,
};

extern NSString *const AchievementViewLeftTextSymbol;
extern NSString *const AchievementViewRightTextSymbol;
extern NSString *const AchievementViewTextColorSymbol;
extern NSString *const AchievementViewLeftFontSymbol;
extern NSString *const AchievementViewRightFontSymbol;
extern NSString *const AchievementViewNumFontSymbol;
extern NSString *const AchievementViewNumColorSymbol;

@interface AchievementView : UIView

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) NSString *numValue;

@end
