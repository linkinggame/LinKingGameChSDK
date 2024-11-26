

#import "LKPointManager.h"
#import "LKPointApi.h"
#import "LKSFPointManager.h"
#import "LKAFManager.h"
@interface LKPointManager ()

@end


static LKPointManager *_instance = nil;

@implementation LKPointManager

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LKPointManager alloc] init];
    });
    return _instance;
}



//=======================================================


/// 进入游戏
/// @param serverId 区服id
/// @param roleId 角色id
/// @param roleName 角色名
/// @param enterGame 进入游戏（false单区,true多区）
- (void)logEnterGame:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName enterGame:(BOOL)enterGame{
    [[LKSFPointManager shared] logEnterGameServerId:serverId roleId:roleId roleName:roleName enterGame:enterGame complete:nil];
    
    
    [[LKAFManager shared] afLogTrackEvent:@"enterGame" withValues:@{
        @"serverId":serverId,
        @"roleId":roleId,
        @"roleName":roleName,
        @"enterGame":[NSNumber numberWithBool:enterGame]
    }];
}

/// 新手引导
/// @param contentId 内容id
/// @param content 内容
/// @param serverId 区服ID
/// @param roleId 角色id
/// @param roleName 角色名
- (void)logTutorial:(NSString *)contentId content:(NSString *)content EventServerId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName{
    [[LKSFPointManager shared] logAchieveCompleteTutorialId:contentId EventServerId:serverId roleId:roleId roleName:roleName complete:nil];
    
    [[LKAFManager shared] afLogTutorialCompletionWithSuccess:YES userId:contentId desc:content];
}

/// 关卡
/// @param stage 关卡
/// @param serverId 区服id
/// @param roleId 角色id
/// @param roleName 角色名
- (void)logStage:(int)stage serverId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName{
    [[LKSFPointManager shared] logAchieveStageEvent:stage serverId:serverId roleId:roleId roleName:roleName complete:nil];
    
    [[LKAFManager shared] afLogTrackEvent:@"stage" withValues:@{
        @"stage":[NSNumber numberWithInt:stage],
        @"serverId":serverId,
        @"roleId":roleId,
        @"roleName":roleName
    }];
}

/// 等级
/// @param level 等级
/// @param serverId 区服Id
/// @param roleId 角色id
/// @param roleName 角色名
- (void)logLevel:(int)level serverId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName{
    [[LKSFPointManager shared] logAchieveLevelEvent:level serverId:serverId roleId:roleId roleName:roleName complete:nil];
    
    [[LKAFManager shared] afLogLevel:level score:level];
    
}
/// 创建角色
- (void)logRoleCreate:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName{
    [[LKSFPointManager shared] logRoleCreate:serverId roleId:roleId roleName:roleName];
}


/// 角色登录打点
/// @param serverId 区服Id
/// @param roleId 角色id
- (void)logRoleLogin:(NSString *)serverId roleId:(NSString *)roleId{
    [[LKSFPointManager shared] logRoleLogin:serverId roleId:roleId];
}

/// 无参自定义事件
/// @param event 事件名
- (void)logEvent:(NSString *)event{
    // LK
    [[LKSFPointManager shared] customePointEventName:event withParameters:nil complete:nil];
    // AF
    [[LKAFManager shared] afLogTrackEvent:event withValues:@{}];
}

/// 有参自定义事件
/// @param event 事件名
/// @param values 参数
- (void)logEvent:(NSString *)event withValues:(NSDictionary *_Nullable)values{
    // LK
    [[LKSFPointManager shared] customePointEventName:event withParameters:values complete:nil];
    // AF 自定义打点
    [[LKAFManager shared] afLogTrackEvent:event withValues:values];

}


- (void)adLogEventName:(NSString *)eventName withParameters:(NSDictionary *_Nullable)params complete:(void(^_Nullable)(NSError *_Nullableerror))complete{
    
    [[LKSFPointManager shared] adstandardPointEventName:eventName withParameters:params complete:complete];
    // AF 自定义打点
    [[LKAFManager shared] afLogTrackEvent:eventName withValues:params];

}


//=================================================






/// 激活打点
/// @param complete <#complete description#>
- (void)activatePointWithComplete:(void(^)(NSError *error))complete{
    [[LKSFPointManager shared] activatePointWithComplete:^(NSError * _Nullable error) {
        complete(error);
    }];
}

// 标准打点
- (void)standardLogEventName:(NSString *)eventName withParameters:(NSDictionary *)params complete:(void(^)(NSError *error))complete{
    [[LKSFPointManager shared] standardPointEventName:eventName withParameters:params complete:^(NSError * _Nullable error) {
        if (complete) {
            complete(error);
        }
    }];
    
}
- (void)standardLogEventName:(NSString *)eventName complete:(void(^)(NSError *error))complete{
    [[LKSFPointManager shared] standardPointEventName:eventName withParameters:nil complete:^(NSError * _Nullable error) {
       if (complete) {
           complete(error);
       }
        
    }];
    
}

// 自定义打点
- (void)customeLogEventName:(NSString *)eventName withParameters:(NSDictionary *)params complete:(void(^)(NSError *error))complete{
    [[LKSFPointManager shared] customePointEventName:eventName withParameters:params complete:complete];
    
    // AF 自定义打点
    [[LKAFManager shared] afLogTrackEvent:eventName withValues:params];
    
}
- (void)customeLogEventName:(NSString *)eventName complete:(void(^)(NSError *error))complete{
    [[LKSFPointManager shared] customePointEventName:eventName withParameters:nil complete:complete];
    // AF 自定义打点
    [[LKAFManager shared] afLogTrackEvent:eventName withValues:@{}];
}


// 广告打点
//- (void)adLogEventName:(NSString *)eventName withParameters:(NSDictionary *)params complete:(void(^)(NSError *error))complete{
//     [[LKSFPointManager shared] adstandardPointEventName:eventName withParameters:params complete:complete];
//}

/// 等级
/// @param level 等级
- (void)logAchieveLevelEvent:(int )level serverId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName complete:(void(^_Nullable)(NSError * _Nullable error))complete{

    [[LKSFPointManager shared] logAchieveLevelEvent:level serverId:serverId roleId:roleId roleName:roleName complete:complete];
    
    [[LKAFManager shared] afLogLevel:level score:level];

}

/// 关卡
- (void)logAchieveStageEvent:(int)stage serverId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName complete:(void(^_Nullable)(NSError * _Nullable error))complete{
    
    [[LKSFPointManager shared] logAchieveStageEvent:stage serverId:serverId roleId:roleId roleName:roleName complete:complete];
    

}

/// 新手引导
- (void)logAchieveCompleteTutorialId:(NSString *)contentId content:(NSString *)content EventServerId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName complete:(void(^_Nullable)(NSError * _Nullable error))complete;{
    
    [[LKSFPointManager shared] logAchieveCompleteTutorialId:contentId EventServerId:serverId roleId:roleId roleName:roleName complete:complete];
    
    [[LKAFManager shared] afLogTutorialCompletionWithSuccess:YES userId:contentId desc:content];
}

/// 进入游戏
- (void)logEnterGameServerId:(NSString *)serverId roleId:(NSString *)roleId roleName:(NSString *)roleName enterGame:(BOOL)enterGame complete:(void(^_Nullable)(NSError * _Nullable error))complete{
    [[LKSFPointManager shared] logEnterGameServerId:serverId roleId:roleId roleName:roleName enterGame:enterGame complete:complete];
}



/// 用于追踪付款信息配置状态
/// @param success 是否成功
- (void)logAddPaymentInfoSuccess:(BOOL)success{
    [[LKAFManager shared] afLogAddPaymentInfoSuccess:success];
}
/// 用于追踪付款信息配置状态
/// @param price 价格
/// @param type 商品类型
/// @param currency 货币类型
/// @param goodsId 商品id
/// @param content 商品描述
/// @param quantity 商品数量
- (void)logAddGoodsCartWithPrice:(NSNumber *)price goodsType:(NSString *)type currency:(NSString *)currency goodsId:(NSString *)goodsId content:(NSString *)content quantity:(int)quantity{
    [[LKAFManager shared] afLogAddGoodsCartWithPrice:price goodsType:type currency:currency goodsId:goodsId content:content quantity:quantity];
    
}

/// 完成购买
/// @param price     购买产生的收入
/// @param orderId 购买生成的订单ID
/// @param receiptId 买家生成的收据ID
- (void)logCompletedPurchase:(NSNumber *)price orderId:(NSString *)orderId receiptId:(NSString *)receiptId{
    
    [[LKAFManager shared] afLogCompletedPurchase:price orderId:orderId receiptId:receiptId];
}

/// 用于追踪特定商品的“添加到愿望清单”事件
/// @param price 价格
/// @param type 类型
/// @param goodsId 物品id
/// @param content 详细描述
/// @param currency 货币类型
/// @param quantity 数量
- (void)logAddWishlistWithPrice:(NSNumber *)price goodsType:(NSString *)type goodsId:(NSString *)goodsId content:(NSString *)content currency:(NSString *)currency quantity:(int)quantity{
    
    [[LKAFManager shared] afLogAddWishlistWithPrice:price goodsType:type goodsId:goodsId content:content currency:currency quantity:quantity];
}

/// 用于追踪用户注册方式
/// @param style 注册方式
- (void)logCompleteRegistrationStyle:(NSString *)style{
    [[LKAFManager shared] afLogCompleteRegistrationStyle:style];
}


/// 用于追踪结账事件
/// @param price 价格
/// @param contentType 商品类型
/// @param contentId 商品id
/// @param quantity 商品数量
/// @param payment 支付方式（信息）
/// @param currency 货币类型
- (void)logInitiatedCheckoutWithPrice:(NSNumber *)price contentType:(NSString *)contentType contentId:(NSString *)contentId content:(NSString *)content  quantity:(int)quantity payment:(NSString *)payment currency:(NSString *)currency{
    
    [[LKAFManager shared] afLogInitiatedCheckoutWithPrice:price contentType:contentType contentId:contentId content:content quantity:quantity payment:payment currency:currency];
}

/// 用于追踪购买事件（及相关收入）
/// @param price 价格
/// @param type 订单了类型
/// @param currency 货币类型 USD
/// @param orderId 订单Id
/// @param desc 描述
/// @param quantity 数量
- (void)logPurchaseWithPrice:(NSNumber *)price type:(NSString *)type currency:(NSString *)currency orderId:(NSString *)orderId desc:(NSString *)desc quantity:(int)quantity{
    
    [[LKAFManager shared] afLogPurchaseWithPrice:price type:type currency:currency orderId:orderId desc:desc quantity:quantity];
}

/// 用于追踪付费订阅购买
/// @param price 价格
- (void)logSubscribeWithPrice:(NSNumber *)price{
    
    [[LKAFManager shared] afLogSubscribeWithPrice:price];
    
}

/// 用于追踪产品的免费试用的开始
/// @param price 价格
/// @param currency 货币类型
- (void)logStartTrialWithPrice:(NSNumber *)price currency:(NSString *)currency{
    
    [[LKAFManager shared] afLogStartTrialWithPrice:price currency:currency];
}

/// 用于追踪应用/商品评级事件
/// @param rating 当前评级
/// @param contentType 评级类型
/// @param contentId 评级id
/// @param content 评级内容
/// @param maxRating 最大评级
- (void)logWithRating:(CGFloat)rating contentType:(NSString *)contentType contentId:(NSString *)contentId content:(NSString *)content maxRating:(CGFloat)maxRating{
    
    [[LKAFManager shared] afLogWithRating:rating contentType:contentType contentId:contentId content:content maxRating:maxRating];
}

/// 用于追踪搜索事件
/// @param contentType 搜索类别
/// @param searchWords 搜索关键字
/// @param success 是否搜索成功
- (void)logSearchWithContentType:(NSString *)contentType searchWords:(NSString *)searchWords success:(BOOL)success{
    
    [[LKAFManager shared] afLogSearchWithContentType:contentType searchWords:searchWords success:success];
}

/// 用于追踪积分花费事件
/// @param price 价格
/// @param contentType 事件类型
/// @param contentId 事件id
/// @param content 事件内容
- (void)logSpentCreditsWithPrice:(NSNumber *)price ContentType:(NSString *)contentType contentId:(NSString *)contentId content:(NSString *)content{
    
    [[LKAFManager shared] afLogSpentCreditsWithPrice:price ContentType:contentType contentId:contentId content:content];
}

/// 用于追踪成就解锁事件
/// @param desc 详细描述
- (void)logAchievementUnlockedWithDesc:(NSString *)desc{
    
    [[LKAFManager shared] afLogAchievementUnlockedWithDesc:desc];
}

/// 用于追踪内容视图事件
/// @param price 价格
/// @param contentType 内容类型
/// @param contentId 内容id
/// @param content 内容描述
/// @param currency 货币类型
- (void)logContentViewWithPrice:(NSNumber *)price contentType:(NSString *)contentType contentId:(NSString *)contentId content:(NSString *)content currency:(NSString *)currency{
    
    [[LKAFManager shared] afLogContentViewWithPrice:price contentType:contentType contentId:contentId content:content currency:currency];
    
}

/// 用于追踪列表视图事件
/// @param contentType 列表视图类别
/// @param contentList 列表集合
- (void)logListViewWithContentType:(NSString *)contentType contentList:(NSArray *)contentList{
    
    [[LKAFManager shared] afLogListViewWithContentType:contentType contentList:contentList];
}

///  用于追踪应用中展示广告的点击次数
- (void)logAdclickWithAdStyle:(NSString *)style{
    
    [[LKAFManager shared] afLogAdclickWithAdStyle:style];
}

/// 用于追踪应用中展示广告的展示次数
- (void)logAdView:(NSString *)style{
    
    [[LKAFManager shared] afLogAdView:style];
}

/// 用于追踪分享事件
/// @param desc 分享描述
- (void)logShareDesc:(NSString*)desc{
    
    [[LKAFManager shared] afLogShareDesc:desc];
}

/// 用于追踪邀请（社交）事件
- (void)logInvite{
    
    [[LKAFManager shared] afLogInvite];
}

///  用于追踪用户的重参与事件
- (void)logActive{
    
    [[LKAFManager shared] afLogActive];
    
}

/// 用于追踪用户登录事件
- (void)logLoginStyle:(NSString *)style{
    
    [[LKAFManager shared] afLogLoginStyle:style];
}

/// 从推送通知打开 用于追踪从推送通知打开应用的事件
- (void)logOpenedFromPushNotification{
    
    [[LKAFManager shared] afLogOpenedFromPushNotification];
    
}

/// 用于追踪更新事件
/// @param contentId 更新事件Id
- (void)logWithContentId:(NSString *)contentId{
    
    [[LKAFManager shared] afLogWithContentId:contentId];
}



/// 设置用户id
/// @param userId <#userId description#>
- (void)logTrackSetCustomerUserID:(NSString *)userId{
    
    [[LKAFManager shared] afLogTrackSetCustomerUserID:userId];
}


@end
