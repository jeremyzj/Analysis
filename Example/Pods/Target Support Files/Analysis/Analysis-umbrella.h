#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AnalysisMananger.h"
#import "AnalysisModel.h"
#import "MethodSwizzing.h"
#import "UICollectionView+Swizzing.h"
#import "UIControl+Swizzing.h"
#import "UITableView+Swizzing.h"
#import "UIViewController+Swizzing.h"

FOUNDATION_EXPORT double AnalysisVersionNumber;
FOUNDATION_EXPORT const unsigned char AnalysisVersionString[];

