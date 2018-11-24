//
//  YFPredicateManager.h
//  正则匹配Demo
//
//  Created by 孙云飞 on 2017/7/18.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFPredicateManager : NSObject
+ (NSMutableArray *)obtainPredicateArray:(NSMutableArray *)originArray andPredicateIndex:(NSInteger)index;
+ (NSMutableArray *)obtainSpecialArray:(NSMutableArray *)originArray andConditions:(NSString *)str;
@end
