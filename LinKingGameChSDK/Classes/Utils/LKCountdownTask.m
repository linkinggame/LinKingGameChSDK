

#import "LKCountdownTask.h"

@implementation LKCountdownTask
- (void)main {
    
    self.taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    while (_leftTimeInterval > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_leftTimeInterval -= 1;
            if (self->_countingDownBlcok) self->_countingDownBlcok(self->_leftTimeInterval);
        });
        [NSThread sleepForTimeInterval:1];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_finishedBlcok) {
            self->_finishedBlcok(0);
        }
    });
    if (self.taskIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.taskIdentifier];
        self.taskIdentifier = UIBackgroundTaskInvalid;
    }
}
@end
