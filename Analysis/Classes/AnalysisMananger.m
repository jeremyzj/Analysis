//
//  AnalysisMananger.m
//  Bhex
//
//  Created by magi on 2020/4/6.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "AnalysisMananger.h"
#import "AnalysisModel.h"

@interface AnalysisMananger()

@property (nonatomic, strong) dispatch_queue_t saveQueue;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, copy) NSString *fileName;

@end

@implementation AnalysisMananger

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (void)loadMananger {
    [[AnalysisMananger sharedInstance] loadManager];
}

+ (void)saveAction: (AnalysisModel* )data {
    [[AnalysisMananger sharedInstance] saveAction: data];
}


+ (void)saveState: (NSString *)state type:(NSString *)type remark: (NSString  *)remark {
    [[AnalysisMananger sharedInstance] saveState:state type:type remark:remark];
}


- (void)loadManager {
    self.saveQueue = dispatch_queue_create("com.analysis.queue", DISPATCH_QUEUE_SERIAL);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForegroundAction:) name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunchingAction:) name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundAction:) name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(appDidBecomeActiveAction:) name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveAction:) name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateAction:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_sync(self.saveQueue, ^{
        weakSelf.fileManager = [NSFileManager new];
        
        NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dictionary = [paths[0] stringByAppendingPathComponent:@"analysis"];
        
        if (![weakSelf.fileManager fileExistsAtPath:dictionary]) {
            [weakSelf.fileManager createDirectoryAtPath:dictionary withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        NSString *fileName = [NSString stringWithFormat:@"%@/%@.csv", dictionary, [self currentDateStr]];
        if (![weakSelf.fileManager fileExistsAtPath:fileName]) {
            [weakSelf.fileManager createFileAtPath:fileName contents:nil attributes:nil];
            NSString *column = @"timestamp,eventId,eventType,remarks";
            [column writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        weakSelf.fileName = fileName;
        
    });
    
}

- (NSString *)currentDateStr {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

- (void)appDidFinishLaunchingAction: (id)notifiy {
    NSLog(@"appDidFinishLaunchingAction: %@", notifiy);
    [self saveAppState:@"DidFinishLaunching" remark:@"打开APP"];
}

- (void)appDidBecomeActiveAction: (id)notifiy {
    NSLog(@"appDidBecomeActiveAction: %@", notifiy);
    [self saveAppState:@"DidBecomeActive" remark:@"激活APP"];
}

- (void)appWillResignActiveAction: (id)notifiy {
    NSLog(@"appWillResignActiveAction: %@", notifiy);
    [self saveAppState:@"WillResignActive" remark:@"APP将要回到后台"];
}

- (void)appDidEnterBackgroundAction: (id)notifiy {
    NSLog(@"appDidEnterBackgroundAction: %@", notifiy);
    [self saveAppState:@"DidEnterBackground" remark:@"APP已经回到后台"];
}

- (void)appWillEnterForegroundAction: (id)notifiy {
    NSLog(@"appWillEnterForegroundActionc: %@", notifiy);
    [self saveAppState:@"WillEnterForeground" remark:@"APP将要回到前台"];
}

- (void)appWillTerminateAction: (id)notifiy {
    NSLog(@"appWillTerminateAction: %@", notifiy);
    [self saveAppState:@"WillTerminate" remark:@"关闭APP"];
}

- (void)saveAppState: (NSString *)state remark: (NSString  *)remark {
    AnalysisModel *model = [[AnalysisModel alloc] init];
    model.actionId = state;
    model.actionType = [kAppStateAction copy];
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time= [date timeIntervalSince1970];
    model.actionTime = time;
    model.remarks = remark;
    [self saveAction:model];
}

- (void)saveState: (NSString *)state type:(NSString *)type remark: (NSString  *)remark {
    AnalysisModel *model = [[AnalysisModel alloc] init];
    model.actionId = state;
    model.actionType = type;
   
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time= [date timeIntervalSince1970];
    model.actionTime = time;
    model.remarks = remark;
    [AnalysisMananger saveAction:model];
}


- (void)saveAction: (AnalysisModel* )data {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.saveQueue, ^{
        NSString *analysis = [NSString stringWithFormat:@"\r\n%f,%@,%@,%@", data.actionTime, data.actionId, data.actionType, data.remarks];
        
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:weakSelf.fileName];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[analysis dataUsingEncoding:NSUTF8StringEncoding]];
    });
}


@end
