//
//  MethodSwizzing.h
//  Bhex
//
//  Created by magi on 2020/4/5.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MethodSwizzing : NSObject

+(void)swizzingForClass:(Class)cls originalSel:(SEL)originalSelector swizzingSel:(SEL)swizzingSelector;

@end

NS_ASSUME_NONNULL_END
