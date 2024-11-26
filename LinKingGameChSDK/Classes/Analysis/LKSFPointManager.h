

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LKSFPointManagerDelegate <NSObject>


@end

@interface LKSFPointManager : NSObject

@property(nonatomic, copy)void(^activatePointCallBack)(NSError * _Nullable error);

@property(nonatomic, copy)void(^standardPointCallBack)(NSError * _Nullable error);

@property(nonatomic, copy)void(^customePointCallBack)(NSError * _Nullable error);

+ (instancetype)shared;
// 激活打点
- (void)activatePointWithComplete:(void(^_Nullable)(NSError * _Nullable error))complete;

/// 等级
/// @param level 等级
- (void)logAchieveLevelEvent:(int )level serverId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName complete:(void(^_Nullable)(NSError * _Nullable error))complete;

/// 关卡
- (void)logAchieveStageEvent:(int)stage serverId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName complete:(void(^_Nullable)(NSError * _Nullable error))complete;

/// 新手引导
- (void)logAchieveCompleteTutorialId:(NSString *)contentId EventServerId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName complete:(void(^_Nullable)(NSError * _Nullable error))complete;

/// 进入游戏
- (void)logEnterGameServerId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName enterGame:(BOOL)enterGame complete:(void(^_Nullable)(NSError * _Nullable error))complete;

/// 创建角色
- (void)logRoleCreate:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName;

///  角色登录
- (void)logRoleLogin:(NSString *)serverId roleId:(NSString *)roleId;

/// 广告打点
- (void)adstandardPointEventName:(NSString *)eventName withParameters:(NSDictionary *)params complete:(void(^)(NSError *error))complete;

/// 标准事件 -
- (void)standardPointEventName:(NSString * _Nullable)eventName withParameters:(NSDictionary *_Nullable)params complete:(void(^_Nullable)(NSError * _Nullable error))complete;

/// 自定义事件 -
- (void)customePointEventName:(NSString *_Nullable)eventName withParameters:(NSDictionary *_Nullable)params complete:(void(^_Nullable)(NSError *_Nullable error))complete;


@end

NS_ASSUME_NONNULL_END
