//
//  UITableView+Swizzing.m
//  Bhex
//
//  Created by magi on 2020/4/5.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "UITableView+Swizzing.h"
#import "MethodSwizzing.h"
#import "AnalysisMananger.h"

@implementation UITableView(Swizzing)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalAppearSelector = @selector(setDelegate:);
        SEL swizzingAppearSelector = @selector(bh_setDelegate:);
        [MethodSwizzing swizzingForClass:[self class] originalSel:originalAppearSelector swizzingSel:swizzingAppearSelector];
    });
}

- (void)bh_setDelegate: (id<UITableViewDelegate>)delegate {
    [self bh_setDelegate:delegate];
    
    SEL sel = @selector(tableView:didSelectRowAtIndexPath:);
    
    SEL sel_ =  NSSelectorFromString([NSString stringWithFormat:@"%@/%@/%ld", NSStringFromClass([delegate class]), NSStringFromClass([self class]),self.tag]);
    
    
    //因为 tableView:didSelectRowAtIndexPath:方法是optional的，所以没有实现的时候直接return
    if (![self isContainSel:sel inClass:[delegate class]]) {
        
        return;
    }
    
    
    BOOL addsuccess = class_addMethod([delegate class],
                                      sel_,
                                      method_getImplementation(class_getInstanceMethod([self class], @selector(bh_tableView:didSelectRowAtIndexPath:))),
                                      nil);
    
    //如果添加成功了就直接交换实现， 如果没有添加成功，说明之前已经添加过并交换过实现了
    if (addsuccess) {
        Method selMethod = class_getInstanceMethod([delegate class], sel);
        Method sel_Method = class_getInstanceMethod([delegate class], sel_);
        method_exchangeImplementations(selMethod, sel_Method);
    }
}

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

// 由于我们交换了方法， 所以在tableview的 didselected 被调用的时候， 实质调用的是以下方法：
-(void)bh_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@/%@/%ld", NSStringFromClass([self class]),  NSStringFromClass([tableView class]), tableView.tag]);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id,id) = (void *)imp;
        func(self, sel,tableView,indexPath);
    }
    
    NSMutableString *identifier = [NSMutableString string];
    NSMutableArray *identifierArray = [NSMutableArray array];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIResponder *next = [cell nextResponder];
    while (next != nil) {
        [identifierArray addObject:[next class]];
        if ([next isKindOfClass:[UIViewController class]]) {
            break;
        }
        next = [next nextResponder];
    }
    
    
    NSArray* reversedArray  = [[identifierArray reverseObjectEnumerator] allObjects];
    [identifier appendFormat:@"%@", [reversedArray componentsJoinedByString:@"/"]];
    
    [identifier appendFormat:@"%@/%@/%ld/%ld", [self class],[tableView class], indexPath.section, indexPath.row];
    NSLog(@"identifier tableview: %@", identifier); 
    
    [AnalysisMananger saveState:identifier
                           type:[kTableAction copy]
                         remark:@"列表cell点击"];
}


@end
