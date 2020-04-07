//
//  UICollectionView+Swizzing.m
//  Bhex
//
//  Created by magi on 2020/4/5.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "UICollectionView+Swizzing.h"
#import "MethodSwizzing.h"
#import "AnalysisMananger.h"
#import <objc/runtime.h>

@implementation UICollectionView(Swizzing)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalAppearSelector = @selector(setDelegate:);
        SEL swizzingAppearSelector = @selector(bh_setDelegate:);
        [MethodSwizzing swizzingForClass:[self class] originalSel:originalAppearSelector swizzingSel:swizzingAppearSelector];
    });
}


-(void)bh_setDelegate:(id<UICollectionViewDelegate>)delegate
{
    [self bh_setDelegate:delegate];
    
    SEL sel = @selector(collectionView:didSelectItemAtIndexPath:);
    
    SEL sel_ =  NSSelectorFromString(@"userDefined_collectionView_didselected");
    
    class_addMethod([delegate class],
                    sel_,
                    method_getImplementation(class_getInstanceMethod([self class], @selector(bh_collectionView:didSelectItemAtIndexPath:))),
                    nil);
    
    
    //判断是否有实现，没有的话添加一个实现
    if (![self isContainSel:sel inClass:[delegate class]]) {
        IMP imp = method_getImplementation(class_getInstanceMethod([delegate class], sel));
        class_addMethod([delegate class], sel, imp, nil);
    }
    
    
    // 将swizzle delegate method 和 origin delegate method 交换
    [MethodSwizzing swizzingForClass:[delegate class] originalSel:sel swizzingSel:sel_];
}


//判断页面是否实现了某个sel
- (BOOL)isContainSel:(SEL)sel inClass:(Class)class {
    unsigned int count;
    
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    return NO;
}



- (void)bh_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SEL sel = NSSelectorFromString(@"userDefined_collectionView_didselected");
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id,id) = (void *)imp;
        func(self, sel,collectionView,indexPath);
    }
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableString *identifier = [NSMutableString string];
    NSMutableArray *identifierArray = [NSMutableArray array];
    UIResponder *next = [cell nextResponder];
    while (next != nil) {
        [identifierArray addObject:[next class]];
        if ([next isKindOfClass:[UIViewController class]]) {
            break;
        }
        next = [next nextResponder];
    }
    
    
    NSArray* reversedArray  = [[identifierArray reverseObjectEnumerator] allObjects];
    
//    NSString * identifier = [NSString stringWithFormat:@"%@/%@/%ld", [target class], NSStringFromSelector(action),self.tag];
    [identifier appendFormat:@"%@", [reversedArray componentsJoinedByString:@"/"]];
 
    
    [identifier appendFormat:@"%@/%@/%ld/%ld", [self class],[collectionView class], (long)indexPath.section, (long)indexPath.row];
    NSLog(@"identifier tableview: %@", identifier);
    
    [AnalysisMananger saveState:identifier
                           type:[kControlAction copy]
                         remark:@"collection点击事件"];
    
}


@end
