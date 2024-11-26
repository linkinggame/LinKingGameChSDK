

#import "LKSFPointManager.h"
#import "LKPointApi.h"

@interface LKSFPointManager ()

@end


static LKSFPointManager *_instance = nil;
@implementation LKSFPointManager

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKSFPointManager alloc] init];
    });
    return _instance;
}
- (void)activatePointWithComplete:(void (^)(NSError * _Nullable))complete{
    [LKPointApi pointEventName:@"Activation" withTp:@"Activation" withValues:nil complete:^(NSError * _Nonnull error) {
        if (complete) {
           complete(error);
        }
    }];
}
- (void)adstandardPointEventName:(NSString *)eventName withParameters:(NSDictionary *)params complete:(void(^)(NSError *error))complete{
    [LKPointApi adPointEventName:eventName withValues:params complete:^(NSError * _Nonnull error) {
        if (complete) {
            complete(error);
        }
    }];
}
/// 标准事件 -
- (void)standardPointEventName:(NSString *)eventName withParameters:(NSDictionary *)params complete:(void(^)(NSError *error))complete{
    [LKPointApi pointEventName:eventName withTp:eventName withValues:params complete:complete];
}

/// 自定义事件 -
- (void)customePointEventName:(NSString *)eventName withParameters:(NSDictionary *)params complete:(void(^)(NSError *error))complete{
    
    [LKPointApi pointEventName:eventName withTp:@"event" withValues:params complete:complete];
    
}


/// 等级
/// @param level 等级
- (void)logAchieveLevelEvent:(int)level serverId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName complete:(void(^_Nullable)(NSError * _Nullable error))complete{
    
    NSDictionary *params = @{
        @"server_id":serverId,
         @"role_id":roleId,
        @"role_name":roleName,
        @"level":[NSString stringWithFormat:@"%ld",(long)level]
    };
    
    [LKPointApi pointEventName:@"level" withTp:@"RoleInfo" withValues:params complete:complete];
    
}

/// 关卡
- (void)logAchieveStageEvent:(int)stage serverId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName complete:(void(^_Nullable)(NSError * _Nullable error))complete{
    NSDictionary *params = @{
        @"server_id":serverId,
         @"role_id":roleId,
        @"role_name":roleName,
        @"stage":[NSString stringWithFormat:@"%ld",(long)stage]
    };
    
    [LKPointApi pointEventName:@"stage" withTp:@"RoleInfo" withValues:params complete:complete];
}

/// 新手引导
- (void)logAchieveCompleteTutorialId:(NSString *)contentId EventServerId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName complete:(void(^_Nullable)(NSError * _Nullable error))complete{
    NSDictionary *params = @{
        @"server_id":serverId,
         @"role_id":roleId,
        @"role_name":roleName,
        @"guide_step":contentId
    };
    
    [LKPointApi pointEventName:@"guide_step" withTp:@"RoleInfo" withValues:params complete:complete];
}
/// 进入游戏
- (void)logEnterGameServerId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName enterGame:(BOOL)enterGame complete:(void(^_Nullable)(NSError * _Nullable error))complete{
    
    NSString *enterGameStr = nil;
    if (enterGame == YES) {
        enterGameStr = @"true";
    }else{
        enterGameStr = @"false";
    }
    
    NSDictionary *params = @{
        @"server_id":serverId,
         @"role_id":roleId,
        @"role_name":roleName,
        @"enter_game":enterGameStr
    };
    
    [LKPointApi pointEventName:@"enter_game" withTp:@"RoleInfo" withValues:params complete:complete];
}


/// 创建角色
- (void)logRoleCreate:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName{
    
    NSDictionary *params = @{
        @"server_id":serverId,
         @"role_id":roleId,
        @"role_name":roleName,
    };
    
    [LKPointApi pointEventName:@"RoleCreate" withTp:@"RoleCreate" withValues:params complete:nil];
}


///  角色登录
- (void)logRoleLogin:(NSString *)serverId roleId:(NSString *)roleId{
    NSDictionary *params = @{
        @"server_id":serverId,
         @"role_id":roleId,
    };
    
    [LKPointApi pointEventName:@"RoleLogin" withTp:@"RoleLogin" withValues:params complete:nil];
}

@end
