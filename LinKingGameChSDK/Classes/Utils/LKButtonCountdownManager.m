

#import "LKButtonCountdownManager.h"
#import "LKCountdownTask.h"

@interface LKButtonCountdownManager ()

@end
static LKButtonCountdownManager *_romSingletion = nil;
static    NSOperationQueue *_pool = nil;
@implementation LKButtonCountdownManager
+ (id)sharedSingletion
{
    
    if (_romSingletion == nil) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _romSingletion=[[LKButtonCountdownManager alloc] init];
            _pool = [[NSOperationQueue alloc] init];
            
        });
        
    }
    
    return _romSingletion;
    
}
+(instancetype)alloc
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _romSingletion = [super alloc];
    });
    
    return _romSingletion;
}


- (void)scheduledCountDownWithKey:(NSString *)aKey   timeInterval:(NSTimeInterval)timeInterval                      countingDown:(void (^)(NSTimeInterval))countingDown finished:(void (^)(NSTimeInterval))finished {
    if (timeInterval > 120) {
        NSCAssert(NO, @"受操作系统后台时间限制，倒计时时间规定不得大于 120 秒.");
    }
    
    if (_pool.operations.count >= 20)  return;
    LKCountdownTask *task = nil;
    if ([self coundownTaskExistWithKey:aKey task:&task]) {
        task.countingDownBlcok = countingDown;
        task.finishedBlcok     = finished;
        if (countingDown) {
            countingDown(task.leftTimeInterval);
        }
    } else {
            task= [[LKCountdownTask alloc] init];
            task.name              = aKey;
            task.leftTimeInterval  = timeInterval;

  
            task.countingDownBlcok = countingDown;
        
            task.finishedBlcok     = finished;
            [_pool addOperation:task];
        }


   }

- (BOOL)coundownTaskExistWithKey:(NSString *)akey task:(NSOperation *__autoreleasing  _Nullable *)task
{
    __block BOOL taskExist = NO;
    [_pool.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:akey]) {
            if (task) *task = obj;
            taskExist = YES;
            *stop     = YES;
        }
    }];
    return taskExist;
}

@end
