//
//  AnalysisModel.h
//  Bhex
//
//  Created by magi on 2020/4/7.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnalysisModel : NSObject

@property (nonatomic, copy) NSString *actionType;
@property (nonatomic, copy) NSString *actionId;
@property (nonatomic, assign) NSTimeInterval actionTime;
@property (nonatomic, copy) NSString *remarks;

@end

NS_ASSUME_NONNULL_END
