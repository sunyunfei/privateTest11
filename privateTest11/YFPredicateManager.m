//
//  YFPredicateManager.m
//  正则匹配Demo
//
//  Created by 孙云飞 on 2017/7/18.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "YFPredicateManager.h"

@implementation YFPredicateManager
+ (NSMutableArray *)obtainPredicateArray:(NSMutableArray *)originArray andPredicateIndex:(NSInteger)index{

    NSMutableArray *resultArray = [NSMutableArray array];
    //图片的正则:^(.+?)\.(png|jpg|gif|PNG|jpeg|bmp)$
    NSString *regex = [[NSString alloc]init];
    switch (index) {
        case 0:
        {
        
            regex = @"itemDir = YES";
        }
            break;
        case 1:
        {
        
           regex = @"itemName MATCHES '(?i)^(.+?)\\.(png|jpg|gif|PNG|jpeg|bmp|tiff)$'";
        }
            break;
        case 2:{
        
            regex = @"itemName MATCHES '(?i)^(.+?)\\.(mp3|m4a|wma|wav)$'";
        }
            break;
        case 3:{
        
            regex = @"itemName MATCHES '^(?i)(.+?)\\.(mp4|m4v|mkv|mov|mkv1|rmvb|rm|flv|mpg|mpeg|avi|wmv)$'";
        }
            break;
    }
    
    if (index != 0) {
        
        NSArray *result2 = [originArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"itemDir = YES"]];
        [resultArray addObjectsFromArray:result2];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:regex];
    NSArray *result1 = [originArray filteredArrayUsingPredicate:predicate];
    [resultArray addObjectsFromArray:result1];
    return resultArray;
}

+ (NSMutableArray *)obtainSpecialArray:(NSMutableArray *)originArray andConditions:(NSString *)str{

    NSMutableArray *resultArray = [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemName CONTAINS %@",str];
    NSArray *result1 = [originArray filteredArrayUsingPredicate:predicate];
    [resultArray addObjectsFromArray:result1];
    return resultArray;
}
@end
