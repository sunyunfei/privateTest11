//
//  YFTapLabel.h
//  LabelDemo
//
//  Created by 孙云飞 on 2018/11/19.
//  Copyright © 2018 孙云飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFTapModel : NSObject
@property(nonatomic,copy)NSString *tapStr;
@property(nonatomic,assign)NSRange range;
@property(nonatomic,strong)NSDictionary *attrParam;
@end

@interface YFTapLabel : UILabel
@property(nonatomic,copy)void(^tapBlock)(NSString *str);//点击回調
- (void)setText:(NSString *)text attrParams:(NSDictionary *)param tapArrays:(NSArray<YFTapModel *> *)tapArrays;
@end

NS_ASSUME_NONNULL_END
