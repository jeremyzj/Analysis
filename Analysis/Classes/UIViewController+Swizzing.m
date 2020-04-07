//
//  UIViewController+Swizzing.m
//  Bhex
//
//  Created by magi on 2020/4/5.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "UIViewController+Swizzing.h"
#import "MethodSwizzing.h"
#import "AnalysisMananger.h"

@implementation UIViewController(Swizzing)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalAppearSelector = @selector(viewWillAppear:);
        SEL swizzingAppearSelector = @selector(bh_viewWillAppear:);
        [MethodSwizzing swizzingForClass:[self class] originalSel:originalAppearSelector swizzingSel:swizzingAppearSelector];
        
        SEL originalDisappearSelector = @selector(viewWillDisappear:);
        SEL swizzingDisappearSelector = @selector(bh_viewWillDisappear:);
        [MethodSwizzing swizzingForClass:[self class] originalSel:originalDisappearSelector swizzingSel:swizzingDisappearSelector];
        
        SEL originalDidLoadSelector = @selector(viewDidLoad);
        SEL swizzingDidLoadSelector = @selector(bh_viewDidLoad);
        [MethodSwizzing swizzingForClass:[self class] originalSel:originalDidLoadSelector swizzingSel:swizzingDidLoadSelector];
        
    });
}

- (void)bh_viewWillAppear: (BOOL)animated {
    [self bh_viewWillAppear:animated];
    NSString * identifier = [NSString stringWithFormat:@"%@", [self class]];
    [AnalysisMananger saveState:[NSString stringWithFormat:@"%@WillAppear", identifier]
                           type:[kPageAction copy]
                         remark:@"页面将要打开"];
}

- (void)bh_viewWillDisappear: (BOOL)animated {
    [self bh_viewWillAppear:animated];
    
    NSString * identifier = [NSString stringWithFormat:@"%@", [self class]];
    [AnalysisMananger saveState:[NSString stringWithFormat:@"%@WillDisappear", identifier]
                           type:[kPageAction copy]
                         remark:@"页面将要关闭"];
}

- (void)bh_viewDidLoad {
    [self bh_viewDidLoad];
    NSString * identifier = [NSString stringWithFormat:@"%@", [self class]];
    [AnalysisMananger saveState:[NSString stringWithFormat:@"%@DidLoad", identifier]
                           type:[kPageAction copy]
                         remark:@"页面初始化"];
}

@end
