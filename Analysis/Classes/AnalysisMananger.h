//
//  AnalysisMananger.h
//  Bhex
//
//  Created by magi on 2020/4/6.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static const NSString *kPageAction = @"PageAction";   // 页面
static const NSString *kControlAction = @"ControlAction";
static const NSString *kTableAction = @"TableCellAction";
static const NSString *kCollectionAction = @"CollectCellAction";
static const NSString *kAppStateAction = @"AppStateAction";

@class AnalysisModel;

@interface AnalysisMananger : NSObject

+ (void)loadMananger;

+ (void)saveAction: (AnalysisModel *)data;

+ (void)saveState: (NSString *)state type:(NSString *)type remark: (NSString  *)remark;

@end

NS_ASSUME_NONNULL_END
