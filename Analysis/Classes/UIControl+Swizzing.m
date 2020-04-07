//
//  UIControl+Swizzing.m
//  Bhex
//
//  Created by magi on 2020/4/5.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "UIControl+Swizzing.h"
#import "MethodSwizzing.h"
#import "AnalysisMananger.h"

@implementation UIControl(Swizzing)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzingSelector = @selector(bh_sendAction:to:forEvent:);
        [MethodSwizzing swizzingForClass:[self class] originalSel:originalSelector swizzingSel:swizzingSelector];
    });
}


-(void)bh_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [self bh_sendAction:action to:target forEvent:event];
    
    NSMutableString *identifier = [NSMutableString string];
    NSMutableArray *identifierArray = [NSMutableArray array];
    if (![target isKindOfClass:[UIViewController class]]) {
       UIResponder *next = [target nextResponder];
        while (next != nil) {
            [identifierArray addObject:[next class]];
            if ([next isKindOfClass:[UIViewController class]]) {
                break;
            }
            next = [next nextResponder];
        }
    }
    
    NSArray* reversedArray  = [[identifierArray reverseObjectEnumerator] allObjects];
    
    [identifier appendFormat:@"%@", [reversedArray componentsJoinedByString:@"/"]];
    [identifier appendFormat:@"%@/%@/%ld",[target class], NSStringFromSelector(action),self.tag];
    
    NSLog(@"identifier bh_sendAction: %@", identifier);
    [AnalysisMananger saveState:identifier
                           type:[kControlAction copy]
                         remark:@"点击事件"];
}


@end
