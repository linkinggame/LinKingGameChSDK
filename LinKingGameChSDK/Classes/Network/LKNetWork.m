

#import "LKNetWork.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "LKNetWork.h"
#import "LKUUID.h"
#import "LKNetUtils.h"
#import "LKGlobalConf.h"
#import "LKPointApi.h"
#import "NSObject+LKUserDefined.h"
#import <AFNetworking/AFNetworking.h>
#import "LKLog.h"
#import "LKUser.h"
typedef void (^LKSuccessBlock)(id obj);
typedef void (^LKFailureBlock)(NSError *error);
static LKNetWork *manager = nil;
static AFHTTPSessionManager *af_manager = nil;
@implementation LKNetWork


+(AFHTTPSessionManager *)sharedHttpSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_manager = [AFHTTPSessionManager manager];
        af_manager.operationQueue.maxConcurrentOperationCount = 4;
    });
    
    return af_manager;
}

+ (NSDictionary *)dealParameters:(NSDictionary *)parames{

    NSMutableDictionary *resultParames = [NSMutableDictionary dictionaryWithDictionary:parames];
    // 数据签名
    NSString *signVal = [LKNetUtils getSignData:parames];
    [resultParames setValue:signVal forKey:@"sign"];

    return resultParames;
}

+ (NSString *)getLanguage{
    NSString * preferredLanguage = @"zh-Hans";
    if (!preferredLanguage || !preferredLanguage.length) {
        preferredLanguage = [NSLocale preferredLanguages].firstObject;
    }
    if ([preferredLanguage rangeOfString:@"zh-Hans"].location != NSNotFound) {
        preferredLanguage = @"zh-Hans";
    } else if ([preferredLanguage rangeOfString:@"zh-Hant"].location != NSNotFound) {
        preferredLanguage = @"zh-Hant";
    } else if ([preferredLanguage rangeOfString:@"ar"].location != NSNotFound) {
        preferredLanguage = @"ar";
    } else {
        preferredLanguage = @"en";
    }
    return preferredLanguage;
}
+ (void)getWithURLString:(NSString *)urlString success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{

    AFHTTPSessionManager *sessionManage =  [LKNetWork sharedHttpSessionManager];

    LKLogInfo(@"urlString:%@",urlString);
    [sessionManage GET:urlString parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];

            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            LKLogInfo(@"josnStr:%@",responseStr);

            if (data != nil) {
                id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                           
                       if ([object isKindOfClass:[NSDictionary class]]) {
                           
                           NSDictionary *responseDict = (NSDictionary *)object;
                           success(responseDict);
                       }else if ([object isKindOfClass:[NSArray class]]){
                              NSArray *responseDict = (NSArray *)object;

                           success(responseDict);
                       }else{
                        
                           LKLogInfo(@"<~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*>");
                           LKLogInfo(@"==== request config fail start ==");
                           LKLogInfo(@"urlString:%@",urlString);
                           LKLogInfo(@"==== request config fail end ==");
                           LKLogInfo(@"<~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*>");
                           NSError *errorCustome =  [self responserErrorMsg:@"网络解析失败,请检查网络" code:1002];
                           failure(errorCustome);
                       }
            }else{
           
                LKLogInfo(@"<~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*>");
                LKLogInfo(@"--- request config fail start ---");
                LKLogInfo(@"urlString:%@",urlString);
                LKLogInfo(@"--- request config fail end ---");
                LKLogInfo(@"<~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*>");
                NSError *errorCustome =  [self responserErrorMsg:@"网络解析失败,请检查网络" code:1001];
                failure(errorCustome);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    

}

+ (void)getFromPhpithURLString:(NSString *)urlString success:(void(^)(id responseObject))success failure:(void(^)(NSError  * _Nullable error))failure{
    AFHTTPSessionManager *sessionManage =  [LKNetWork sharedHttpSessionManager];
    sessionManage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    LKLogInfo(@"urlString:%@",urlString);
    [sessionManage GET:urlString parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            LKLogInfo(@"josnStr:%@",responseObject);
            if (responseObject != nil) {
                success(responseObject);
            }else{
           
                LKLogInfo(@"<~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*>");
                LKLogInfo(@"--- request config fail start ---");
                LKLogInfo(@"urlString:%@",urlString);
                LKLogInfo(@"--- request config fail end ---");
                LKLogInfo(@"<~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*>");
                NSError *errorCustome =  [self responserErrorMsg:@"網絡解析失敗,請檢查網絡" code:1001];
                failure(errorCustome);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
}

+ (void)postNormalWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters HTTPHeaderField:(NSDictionary *)headerField success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    NSData *data =[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:nil];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    request.timeoutInterval = 60;
    [request setValue:@"application/json;text/plain;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    if (headerField != nil) {
        for (NSString *key in headerField.allKeys) {
            [request setValue:headerField[key] forHTTPHeaderField:key];
        }
    }
    [request setHTTPBody:data];
    [[session dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {

    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {

    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (error) {
            failure(error);
        }else{
            LKLogInfo(@"responseObject:%@",responseObject);
            if (error) {
                failure(error);
            } else {
              success(responseObject);
            }
        }

    }] resume];
}
//===
+ (void)postWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{

    LKLogInfo(@"urlString:%@",urlString);
   
    NSDictionary *resultDict = parameters;
    LKLogInfo(@"parameters:%@",parameters);
    //[self dealParameters:parameters];

    NSData *data =[NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:nil];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    NSMutableURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:nil];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    request.timeoutInterval = 60;
    [request setValue:@"application/json;text/plain;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[self getLanguage] forHTTPHeaderField:@"LK_LANGUAGE"];
    [request setHTTPBody:data];

    [[session dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {

    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {

    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (error) {
            failure(error);
        }else{
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];

            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            LKLogInfo(@"josnStr:%@",responseStr);
            
            if (data != nil) {
                id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *responseDict = (NSDictionary *)object;
                        if (error) {
                            failure(error);
                        } else {
                          success(responseDict);
                        }
                    }
            } else {
                failure([self responserErrorMsg:@"数据结构错误" code:-107]);
            }

        }

    }] resume];

}
+ (void)postWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters HTTPHeaderField:(NSDictionary *)headerField success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    LKLogInfo(@"urlString:%@",urlString);
   
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:[self dealParameters:parameters]];
    LKUser *user = [LKUser getUser];
    if (user != nil) {
        if (user.token.exceptNull != nil) {
            [resultDict setObject:user.token forKey:@"lk_token"];
        }
        if (user.userId.exceptNull != nil) {
            [resultDict setObject:user.userId forKey:@"uid"];
        }
        
        [resultDict setObject:[self getLanguage] forKey:@"LK_LANGUAGE"];
    }
    
    LKLogInfo(@"parameters:%@",parameters);
    NSData *data =[NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:nil];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSMutableURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:parameters error:nil];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    request.timeoutInterval = 60;
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[self getLanguage] forHTTPHeaderField:@"LK_LANGUAGE"];
    if (headerField != nil) {
        for (NSString *key in headerField.allKeys) {
            [request setValue:headerField[key] forHTTPHeaderField:key];
        }
    }
    [request setHTTPBody:data];

    [[session dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {

    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {

    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (error) {
            failure(error);
        }else{
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];

            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            LKLogInfo(@"josnStr:%@",responseStr);

            if (data != nil) {
                id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *responseDict = (NSDictionary *)object;
                        if (error) {
                            failure(error);
                        } else {
                          success(responseDict);
                        }
                    }
            } else {
                failure([self responserErrorMsg:@"数据结构错误" code:-107]);
            }
        }

    }] resume];
}

//===

+ (void)postFormDataWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters HTTPHeaderField:(NSDictionary *)headerField success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    AFHTTPSessionManager *sessionManage =  [LKNetWork sharedHttpSessionManager];
    LKLogInfo(@"urlString:%@",urlString);
    NSDictionary *resultDict = [self dealParameters:parameters];
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:headerField];
    [headers setObject:[self getLanguage] forKey:@"LK_LANGUAGE"];

    
    [sessionManage POST:urlString parameters:resultDict headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];

            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            LKLogInfo(@"josnStr:%@",responseStr);

            if (data != nil) {
                id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                           
                       if ([object isKindOfClass:[NSDictionary class]]) {
                           
                           NSDictionary *responseDict = (NSDictionary *)object;
                           success(responseDict);
                       }else if ([object isKindOfClass:[NSArray class]]){
                              NSArray *responseDict = (NSArray *)object;

                           success(responseDict);
                       }else{
                           NSError *errorCustome =  [self responserErrorMsg:@"网络解析失败,请检查网络" code:1002];
                           failure(errorCustome);
                       }
            }else{
           
                NSError *errorCustome =  [self responserErrorMsg:@"网络解析失败,请检查网络" code:1001];
                failure(errorCustome);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    
    
}

+ (void)uploadWithURLString:(NSString *)urlString withImages:(NSArray<UIImage *>*)images parameters:(NSDictionary *)parameters HTTPHeaderField:(NSDictionary *)headerField complete:(void(^)(NSError *error, NSDictionary *responseObj))complete {
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc] init];
    
    NSMutableDictionary *reslutParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    // ====
    LKUser *user = [LKUser getUser];
    if (user != nil) {
        if (user.token.exceptNull != nil) {
            [reslutParameters setObject:user.token forKey:@"lk_token"];
        }
        if (user.userId.exceptNull != nil) {
            [reslutParameters setObject:user.userId forKey:@"uid"];
        }
        [reslutParameters setObject:[self getLanguage] forKey:@"LK_LANGUAGE"];
    }
   // ====
    
    //参数的集合的所有key的集合
    NSArray *keys= [reslutParameters allKeys];
    
    for (int i = 0; i <keys.count; i++) {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[reslutParameters objectForKey:key]];
    }
    //声明myRequestData，用来放入http body
     NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
     [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //循环加入上传图片
    for (int i = 0; i<images.count; i++) {
        //要上传的图片
         UIImage *image = images[i];
         NSData*data=UIImageJPEGRepresentation(image, 0.1);
         NSMutableString *imgbody = [[NSMutableString alloc] init];
        //此处循环添加图片文件
        //添加图片信息字段
        //声明pic字段，文件名为boris.png
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@.png",str];

        LKLogInfo(@"file name : %@",fileName);
        
        ////添加分界线，换行
        [imgbody appendFormat:@"%@\r\n",MPboundary];
        //[imgbody appendFormat:@"Content-Disposition: form-data; name="File%d"; filename="%@.jpg"\r\n", i, [keys objectAtIndex:i]];
        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"files", fileName];
        //声明上传文件的格式
        [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
     //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[self getLanguage] forHTTPHeaderField:@"LK_LANGUAGE"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    // 设置请求头额外参数
    if (headerField != nil) {
        for (NSString *key in headerField.allKeys) {
            [request setValue:headerField[key] forHTTPHeaderField:key];
        }
    }
     NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
     NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *responseObj =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             if (complete) {
//                 LKLogInfo(@"response:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                complete(error,responseObj);
            }
        });
    }] resume];
}

+ (NSError *)responserErrorMsg:(NSString *)msg{
    if (msg.exceptNull == nil) {
        msg = @"系统错误";
    }
    NSString *domain = @"com.linking.sdk.ErrorDomain";
        NSString *errorDesc = NSLocalizedString(msg, @"");
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorDesc };
        NSError *error = [NSError errorWithDomain:domain code:-101 userInfo:userInfo];
    return error;
}
+ (NSError *)responserErrorMsg:(NSString *)msg code:(int)code{
    if (msg.exceptNull == nil) {
        msg = @"系统错误";
    }
    NSString *domain = @"com.linking.sdk.ErrorDomain";
        NSString *errorDesc = NSLocalizedString(msg, @"");
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorDesc };
        NSError *error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
    return error;
}



//
//+ (void)uploadWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters HTTPHeaderField:(NSDictionary *)headerField success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
//       NSError *error=nil;
//
//         NSURLSession *session = [NSURLSession sharedSession];
//
//         NSDictionary *resultDict = [self dealParameters:parameters];
//         LKLogInfo(@"==parameters:%@==",resultDict);
//         NSData *data =[NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:&error];
//
//         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy  timeoutInterval:60.0];
//
//         [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//         [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//
//         if (headerField != nil) {
//             for (NSString *key in headerField.allKeys) {
//                 [request setValue:headerField[key] forHTTPHeaderField:key];
//             }
//         }
//
//         [request setHTTPMethod:@"POST"];
//         [request setHTTPBody:data];
//
//
//    [session uploadTaskWithRequest:nil fromData:nil completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//    }];
//}
//
//
//+ (void)uploadWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters{
//    NSString *urlString = @"";
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSData *imageData = [NSData dataWithContentsOfURL:url];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.yundama.com/api.php?method=upload"]
//                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                       timeoutInterval:10.0];
//    NSArray *parameters = @[];
//    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
//
//    NSError *error;
//    NSMutableString *body = [NSMutableString string];
//    for (NSDictionary *param in parameters) {
//        [body appendFormat:@"--%@\r\n", boundary];
//        if (param[@"files"]) {
//            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//            formatter.dateFormat=@"yyyyMMddHHmmss";
//            NSString *str=[formatter stringFromDate:[NSDate date]];
//            NSString *fileName=[NSString stringWithFormat:@"%@.gpeg",str];
//
//            LKLogInfo(@"file name : %@",fileName);
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], fileName];
//            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
//            if (error) {
//                LKLogInfo(@"%@", error);
//            }
//        } else {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
//            [body appendFormat:@"%@\n", param[@"value"]];
//        }
//    }
//
//    NSString *end = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];
//    NSMutableData *requestData = [NSMutableData data];
//    [requestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    [requestData appendData:imageData];
//    [requestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:requestData];
//    //设置HTTPHeader中Content-Type的值
//    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    //设置HTTPHeader
//    [request setValue:content forHTTPHeaderField:@"Content-Type"];
//    //设置Content-Length
//    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
//
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            LKLogInfo(@"error : %@",error);
//           // [self postYunDaMaFail];
//        } else {
//           // NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//
//        }
//    }] resume];
//}
#pragma mark - 上传图片
//- (void)postImageWithMethodName:(NSString *)methodName
//                       partName:(NSString *)partName
//                       imageData:(NSData *)imageData
//                        fileName:(NSString*)fileName
//                         success:(void (^)(id responseObject))success
//                         failure:(void (^)(NSError *error))failure
//{
//    NSString *URLString = [NSString stringWithFormat:@"%@%@",BaseUrl,methodName];
//    MYLog(@"URLString = %@",URLString);
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
//                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                               timeoutInterval:30];
//
//    request.HTTPMethod = @"POST";
//    //分界线的标识符
//    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
//
//    //分界线 --AaB03x
//    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
//    //结束符 AaB03x--
//    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
//
//    /*
//    上传格图片格式：
//    --AaB03x
//    Content-Disposition: form-data; name="file"; filename="currentImage.png"
//    Content-Type: image/png
//    */
//    //http body的字符串
//    NSMutableString *body=[[NSMutableString alloc]init];
//    //添加分界线，换行
//    [body appendFormat:@"%@\r\n",MPboundary];
//
//    //声明file字段
//    [body appendFormat:@"%@", [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.png\"\r\n",partName,fileName]];
//    //声明上传文件的格式
//    [body appendFormat:@"Content-Type: image/jpg\r\n\r\n"];
//
//    LKLogInfo(@"网络请求body:%@",body);
//    //声明结束符：--AaB03x--
//    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
//    //声明myRequestData，用来放入http body
//    NSMutableData *myRequestData=[NSMutableData data];
//    //将body字符串转化为UTF8格式的二进制
//    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    //将image的data加入
//    [myRequestData appendData:imageData];
//    //加入结束符--AaB03x--
//    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//
//    //设置HTTPHeader中Content-Type的值
//    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
//    //设置HTTPHeader
//    [request setValue:content forHTTPHeaderField:@"Content-Type"];
//    //设置Content-Length
//    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
//
//    [request setValue:@"" forHTTPHeaderField:@"LK_TOKEN"];
//
//    //设置http body
//    [request setHTTPBody:myRequestData];
//
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//    }];
//    [task resume];
//}


@end
