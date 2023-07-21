//
//  SBAIRequestManager.m
//  ElectricRoom
//
//  Created by 刘永吉 on 2022/5/25.
//

#import "SBAIRequestManager.h"
#import "SBAIApi.h"
#import "SBAITool.h"
#import "SBAITool+MD5.h"
#import "SBFileTool.h"

#import "SBAIPracticeLoginModel.h"

#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <AFNetworking/AFURLResponseSerialization.h>
#import <AFNetworking/AFURLRequestSerialization.h>

@interface SBAIRequestManager ()

@property (strong, nonatomic) AFHTTPSessionManager *netManager;
@end

@implementation SBAIRequestManager


///单利模式
+ (SBAIRequestManager *)shareAFNetworking{
    static SBAIRequestManager *networking = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networking = [[SBAIRequestManager alloc] init];
        networking.netManager = [networking getManager];
        [networking handleHeader];
    });
    
    return networking;
}

- (AFHTTPSessionManager *)getManager{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:HttpRequestApi]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"    ",@"text/html",@"text/json",@"text/plain",@"application/json",@"charset=utf-8",@"application/octet-stream",nil];
    
    manager.requestSerializer.timeoutInterval = DEFAULT_TIMEOUT_INTERVAL;
    manager.operationQueue.maxConcurrentOperationCount = 10;
    return manager;
}

#pragma mark ---------- 请求头设置
- (void)handleHeader{
    AFHTTPRequestSerializer *header = _netManager.requestSerializer;
    
    NSString *loginString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SB_AI_LOGIN"];
    SBAIPracticeLoginModel *loginModel = [SBAIPracticeLoginModel mj_objectWithKeyValues:[loginString mj_JSONObject]];

    [header setValue:loginModel.token.length ? loginModel.token : @"" forHTTPHeaderField:@"token"];
    
    
    NSString *GlmUser = @"AI2023042610080000001";
    NSString *GlmPassword = @"d16d539c250844018757eb98020b3d93";
    NSString *input = [NSString stringWithFormat:@"%@:%@",GlmUser,GlmPassword];
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [data base64EncodedStringWithOptions:0];
    
    [header setValue:[NSString stringWithFormat:@"Basic %@",result] forHTTPHeaderField:@"Authorization"];
    
}

#pragma mark ---------- 刷新请求头
- (void)reloadHeaderData{
    AFHTTPRequestSerializer *header = RequestManager.netManager.requestSerializer;
    
    NSString *loginString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SB_AI_LOGIN"];
    SBAIPracticeLoginModel *loginModel = [SBAIPracticeLoginModel mj_objectWithKeyValues:[loginString mj_JSONObject]];

    [header setValue:loginModel.token.length ? loginModel.token : @"" forHTTPHeaderField:@"token"];
}

#pragma mark ---------- 取消所有请求
- (void)cancelAllRequest{
    @synchronized(self) {
        [self.netManager.dataTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
                [task cancel];
            }
        }];
    };
}

#pragma mark ---------- 取消某个请求
- (void)cancelRequestWithURL:(NSString *)url{
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [self.netManager.dataTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[NSURLSessionDataTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                *stop = YES;
            }
        }];
    };
}

- (NSURLSessionDataTask *)GetWithUrl:(NSString *)Url
                            response:(SBAIRequestResponseBlock)response
{
    return [self GetWithUrl:Url
                 parameters:nil
            timeoutInterval:0.f
                   progress:nil
                   response:response];
}

- (NSURLSessionDataTask *)GetWithUrl:(NSString *)Url
                            progress:(ERDownloadProgressBlock)progress
                            response:(SBAIRequestResponseBlock)response
{
    return [self GetWithUrl:Url
                 parameters:nil
            timeoutInterval:0.f
                   progress:progress
                   response:response];
}

- (NSURLSessionDataTask *)GetWithUrl:(NSString *)Url
                     timeoutInterval:(CGFloat)timeoutInterval
                            response:(SBAIRequestResponseBlock)response
{
    return [self GetWithUrl:Url
                 parameters:nil
            timeoutInterval:timeoutInterval
                   progress:nil
                   response:response];
}

- (NSURLSessionDataTask *)GetWithUrl:(NSString *)Url
                          parameters:(NSDictionary *)parameters
                     timeoutInterval:(CGFloat)timeoutInterval
                            response:(SBAIRequestResponseBlock)response
{
    return [self GetWithUrl:Url
                 parameters:parameters
            timeoutInterval:timeoutInterval
                   progress:nil
                   response:response];
}

- (NSURLSessionDataTask *)GetWithUrl:(NSString *)Url
                          parameters:(NSDictionary *)parameters
                     timeoutInterval:(CGFloat)timeoutInterval
                            progress:(ERDownloadProgressBlock)progress
                            response:(SBAIRequestResponseBlock)response
{
    
    NSLog(@"请求接口%@", Url);
    NSLog(@"请求参数%@", [parameters mj_JSONString]);
    AFHTTPSessionManager *manager = _netManager;
    
    CGFloat time = DEFAULT_TIMEOUT_INTERVAL;
    if (timeoutInterval > 0) time = timeoutInterval;
    manager.requestSerializer.timeoutInterval = time;
    
    NSURLSessionDataTask *sessionDataTask = [manager GET:Url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) progress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"返回接口%@", Url);
        NSLog(@"返回参数%@", [responseObject mj_JSONString]);
        
        SBAIResponseModel *model = [SBAIResponseModel new];
        if ([responseObject isKindOfClass:[NSNull class]] || ![responseObject isKindOfClass:[NSDictionary class]]) {
            model.msg = @"返回参数格式出错";
            if (response) response(NO, model);
            return;
        }
        
        SBAIResponseModel *resModel = [SBAIResponseModel mj_objectWithKeyValues:responseObject];
        
        NSString *code = resModel.code;
        
        model.code = code;
        model.msg = [SBAIRequestManager getNetWorkResponseMsg:resModel];
        model.data = resModel.data;
        
        if (response) response(YES, model);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SBAIResponseModel *model = [SBAIResponseModel new];
        model.msg = error.localizedDescription;
        model.error = error;
        if (response) response(NO, model);
    }];
    
    return sessionDataTask;
    
}

- (NSURLSessionDataTask *)PostWithUrl:(NSString *)Url
                           parameters:(NSDictionary *)parameters
                             response:(SBAIRequestResponseBlock)response
{
    return [self PostWithUrl:Url
             timeoutInterval:0.f
                  parameters:parameters
                    progress:nil
                    response:(SBAIRequestResponseBlock)response];
}

- (NSURLSessionDataTask *)PostWithUrl:(NSString *)Url
                      timeoutInterval:(CGFloat)timeoutInterval
                           parameters:(NSDictionary *)parameters
                             response:(SBAIRequestResponseBlock)response
{
    return [self PostWithUrl:Url
             timeoutInterval:timeoutInterval
                  parameters:parameters
                    progress:nil
                    response:response];
}

- (NSURLSessionDataTask *)PostWithUrl:(NSString *)Url
                      timeoutInterval:(CGFloat)timeoutInterval
                           parameters:(NSDictionary *)parameters
                           handleCode:(BOOL)handleCode
                             response:(SBAIRequestResponseBlock)response
{
    return [self PostWithUrl:Url
             timeoutInterval:timeoutInterval
                  parameters:parameters
                  handleCode:handleCode
                    progress:nil
                    response:response];
}

- (NSURLSessionDataTask *)PostWithUrl:(NSString *)Url
                      timeoutInterval:(CGFloat)timeoutInterval
                           parameters:(NSDictionary *)parameters
                             progress:(ERDownloadProgressBlock)progress
                             response:(SBAIRequestResponseBlock)response
{
    return [self PostWithUrl:Url
             timeoutInterval:timeoutInterval
                  parameters:parameters
                  handleCode:YES
                    progress:progress
                    response:response];
}

- (NSURLSessionDataTask *)PostWithUrl:(NSString *)Url
                      timeoutInterval:(CGFloat)timeoutInterval
                           parameters:(NSDictionary *)parameters
                           handleCode:(BOOL)handleCode
                             progress:(ERDownloadProgressBlock)progress
                             response:(SBAIRequestResponseBlock)response
{
    
    NSLog(@"请求接口%@", Url);
    NSLog(@"请求参数%@", [parameters mj_JSONString]);
    
    AFHTTPSessionManager *manager = _netManager;
    
    CGFloat time = DEFAULT_TIMEOUT_INTERVAL;
    if (timeoutInterval > 0) time = timeoutInterval;
    
    [manager.requestSerializer setTimeoutInterval:time];
    
    NSURLSessionDataTask *sessionDataTask = [manager POST:Url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"返回接口%@", Url);
        NSLog(@"返回参数%@", [responseObject mj_JSONString]);
        
        SBAIResponseModel *model = [SBAIResponseModel new];
        if ([responseObject isKindOfClass:[NSNull class]] || ![responseObject isKindOfClass:[NSDictionary class]]) {
            model.msg = @"返回参数格式出错";
            if (response) response(NO, model);
            return;
        }
        
        SBAIResponseModel *resModel = [SBAIResponseModel mj_objectWithKeyValues:responseObject];
        
        NSString *code = resModel.code;
        
        model.code = code;
        model.msg = [SBAIRequestManager getNetWorkResponseMsg:resModel];
        model.data = resModel.data;
        
        if (![code isEqualToString:@"200"]) {
            NSLog(@"返回参数%@", [responseObject mj_JSONString]);
            if (response) response(NO, model);
            return;
        }
        
        if (response) response(YES, model);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SBAIResponseModel *model = [SBAIResponseModel new];
        model.msg = error.localizedDescription;
        model.error = error;
        if (response) response(NO, model);
    }];
    
    
    return sessionDataTask;
}

- (NSURLSessionDataTask *)PostImageWithUrl:(NSString *)Url
                           timeoutInterval:(CGFloat)timeoutInterval
                                 imageData:(NSData *)imageData
                                parameters:(NSDictionary *)parameters
                                  response:(SBAIRequestResponseBlock)response {
    
    NSLog(@"请求接口%@", Url);
    NSLog(@"请求参数%@", [parameters mj_JSONString]);
    
    AFHTTPSessionManager *manager = _netManager;
    
    CGFloat time = DEFAULT_TIMEOUT_INTERVAL_FILE;
    if (timeoutInterval > 0) time = timeoutInterval;
    manager.requestSerializer.timeoutInterval = time;
    
    NSURLSessionDataTask *sessionDataTask = [manager POST:Url parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:[NSString stringWithFormat:@"%@.jpg",[self getUniqueStrByUUID]]
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"返回接口%@", Url);
        NSLog(@"返回参数%@", [responseObject mj_JSONString]);
        
        SBAIResponseModel *model = [SBAIResponseModel new];
        if ([responseObject isKindOfClass:[NSNull class]] || ![responseObject isKindOfClass:[NSDictionary class]]) {
            model.msg = @"返回参数格式出错";
            if (response) response(NO, model);
            return;
        }
        
        SBAIResponseModel *resModel = [SBAIResponseModel mj_objectWithKeyValues:responseObject];
        
        model.code = resModel.code;
        model.msg = [SBAIRequestManager getNetWorkResponseMsg:resModel];
        model.data = resModel.data;
        
        if (![resModel.code isEqualToString:@"200"]) {
            if (response) response(NO, model);
            return;
        }
        
        if (response) response(YES, model);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SBAIResponseModel *model = [SBAIResponseModel new];
        model.msg = error.localizedDescription;
        model.error = error;
        if (response) response(NO, model);
    }];
    
    
    return sessionDataTask;
}

- (NSURLSessionDataTask *)PostFileWithUrl:(NSString *)Url
                          timeoutInterval:(CGFloat)timeoutInterval
                                 fileData:(NSData *)fileData
                               parameters:(NSDictionary *)parameters
                                 response:(SBAIRequestResponseBlock)response {
    return [self PostFileWithUrl:Url
                 timeoutInterval:timeoutInterval
                        fileData:fileData
                         keyName:@"File"
                        fileName:@"iat.pcm"
                      parameters:parameters
                        response:response];
}

- (NSURLSessionDataTask *)PostFileWithUrl:(NSString *)Url
                          timeoutInterval:(CGFloat)timeoutInterval
                                 fileData:(NSData *)fileData
                                 fileName:(NSString *) fileName
                               parameters:(NSDictionary *)parameters
                                 response:(SBAIRequestResponseBlock)response {
    
    return [self PostFileWithUrl:Url
                 timeoutInterval:timeoutInterval
                        fileData:fileData
                         keyName:@"files"
                        fileName:fileName
                      parameters:parameters
                        response:response];
}

- (NSURLSessionDataTask *)PostFileWithUrl:(NSString *)Url
                          timeoutInterval:(CGFloat)timeoutInterval
                                 fileData:(NSData *)fileData
                                  keyName:(NSString *)keyName
                                 fileName:(NSString *) fileName
                               parameters:(NSDictionary *)parameters
                                 response:(SBAIRequestResponseBlock)response
{
    NSLog(@"请求接口%@", Url);
    NSLog(@"请求参数%@", [parameters mj_JSONString]);
    
    AFHTTPSessionManager *manager = _netManager;
    
    CGFloat time = DEFAULT_TIMEOUT_INTERVAL_FILE;
    if (timeoutInterval > 0) time = timeoutInterval;
    manager.requestSerializer.timeoutInterval = time;
    
    NSURLSessionDataTask *sessionDataTask = [manager POST:Url parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:keyName fileName:fileName mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"返回接口%@", Url);
        NSLog(@"返回参数%@", [responseObject mj_JSONString]);
        
        SBAIResponseModel *model = [SBAIResponseModel new];
        if ([responseObject isKindOfClass:[NSNull class]] || ![responseObject isKindOfClass:[NSDictionary class]]) {
            model.msg = @"返回参数格式出错";
            if (response) response(NO, model);
            return;
        }
        SBAIResponseModel *resModel = [SBAIResponseModel mj_objectWithKeyValues:responseObject];
        
        model.code = resModel.code;
        model.msg = [SBAIRequestManager getNetWorkResponseMsg:resModel];
        model.data = resModel.data;
        
        if (![resModel.code isEqualToString:@"200"]) {
            
            if (response) response(NO, model);
            return;
        }
        
        if (response) response(YES, model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SBAIResponseModel *model = [SBAIResponseModel new];
        model.msg = error.localizedDescription;
        model.error = error;
        if (response) response(NO, model);
    }];
    
    return sessionDataTask;
}


/**
 文件上传（多图）
 */
- (NSURLSessionDataTask *) doUploadImagesWithURL:(NSString *) Url
                                      parameters:(nullable id)parameters
                                 timeoutInterval:(CGFloat)timeoutInterval
                                   fileDataArray:(NSArray *_Nullable) imageArray
                                            name:(NSString *_Nullable) name response:(SBAIRequestResponseBlock _Nullable )response;{
    NSLog(@"请求接口%@", Url);
    NSLog(@"请求参数%@", [parameters mj_JSONString]);
    
    AFHTTPSessionManager *manager = _netManager;
    
    CGFloat time = DEFAULT_TIMEOUT_INTERVAL_FILE;
    if (timeoutInterval > 0) time = timeoutInterval;
    manager.requestSerializer.timeoutInterval = time;
    
    NSURLSessionDataTask *sessionDataTask = [manager POST:Url parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSInteger imgCount = 0;
        for (int index = 0; index<imageArray.count; index++) {
            NSData *imageData =  UIImageJPEGRepresentation(imageArray[index], 1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmssSSS";
            
            NSString *fileName = [NSString stringWithFormat:@"%@%@.jpg",[formatter stringFromDate:[NSDate date]],@(imgCount)];
            
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
            
            imgCount++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"返回接口%@", Url);
        NSLog(@"返回参数%@", [responseObject mj_JSONString]);
        
        SBAIResponseModel *model = [SBAIResponseModel new];
        if ([responseObject isKindOfClass:[NSNull class]] || ![responseObject isKindOfClass:[NSDictionary class]]) {
            model.msg = @"返回参数格式出错";
            if (response) response(NO, model);
            return;
        }
        SBAIResponseModel *resModel = [SBAIResponseModel mj_objectWithKeyValues:responseObject];
        
        NSString *code = resModel.code;
        model.code = code;
        model.msg = [SBAIRequestManager getNetWorkResponseMsg:resModel];
        model.data = resModel.data;
        
        if (![code isEqualToString:@"200"]) {
            if (response) response(NO, model);
            return;
        }
        
        if (response) response(YES, model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SBAIResponseModel *model = [SBAIResponseModel new];
        model.msg = error.localizedDescription;
        model.error = error;
        if (response) response(NO, model);
    }];
    
    return sessionDataTask;
}

- (NSURLSessionDataTask *_Nullable)DownloadWithUrl:(NSString *_Nullable)Url
                                        parameters:(NSDictionary *_Nullable)parameters
                                   timeoutInterval:(CGFloat)timeoutInterval
                                          progress:(ERDownloadProgressBlock _Nullable )progress
                                          response:(SBAIRequestResponseBlock _Nonnull )response
{
    
    NSLog(@"请求接口%@", Url);
    NSLog(@"请求参数%@", [parameters mj_JSONString]);
    AFHTTPSessionManager *manager = _netManager;
    
    CGFloat time = DEFAULT_TIMEOUT_INTERVAL;
    if (timeoutInterval > 0) time = timeoutInterval;
    manager.requestSerializer.timeoutInterval = time;
    
    NSURLSessionDataTask *sessionDataTask = [manager GET:Url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) progress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"返回接口%@", Url);
        NSLog(@"返回参数%@", [responseObject mj_JSONString]);
        
        SBAIResponseModel *model = [SBAIResponseModel new];
        if ([responseObject isKindOfClass:[NSNull class]] || ![responseObject isKindOfClass:[NSDictionary class]]) {
            model.msg = @"返回参数格式出错";
            if (response) response(NO, model);
            return;
        }
        
        SBAIResponseModel *resModel = [SBAIResponseModel mj_objectWithKeyValues:responseObject];
        
        NSString *code = resModel.code;
        
        model.code = code;
        model.msg = [SBAIRequestManager getNetWorkResponseMsg:resModel];
        model.data = resModel.data;
        
        if (response) response(YES, model);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SBAIResponseModel *model = [SBAIResponseModel new];
        model.msg = error.localizedDescription;
        model.error = error;
        if (response) response(NO, model);
    }];
    
    return sessionDataTask;
    
}

- (NSURLSessionDownloadTask *_Nullable)DownloadVideoWithUrl:(NSString * _Nullable)Url
                                                 parameters:(NSDictionary * _Nullable)parameters
                                            timeoutInterval:(CGFloat)timeoutInterval
                                                   progress:(ERDownloadProgressBlock _Nullable )progress
                                                   response:(SBAIRequestResponseBlock _Nullable )responsed
{
    
    NSLog(@"请求接口%@", Url);
    NSLog(@"请求参数%@", [parameters mj_JSONString]);
    AFHTTPSessionManager *manager = _netManager;
    
    CGFloat time = DEFAULT_TIMEOUT_INTERVAL;
    if (timeoutInterval > 0) time = timeoutInterval;
    manager.requestSerializer.timeoutInterval = time;
    
    NSURLSessionDownloadTask *sessionTask = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Url]] progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //1.当前时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy_MM_dd"];
        NSString *timeString = [formatter stringFromDate:[NSDate date]];
        
        //2.缓存目录 带时间 带文件ur的md5 .mp4
        NSString *filename = [NSString stringWithFormat:@"%@.mp4",[SBAITool SB_MD5:Url]];//url md5为参数
        
        NSString *path = [NSString stringWithFormat:@"practice_video_file/%@",timeString];
        
        [SBFileTool createPath:[SBFileTool absolutePath:path filePathType:SBFileToolPathTypeCache]];//创建目录
        
        NSString *namePath = [path stringByAppendingPathComponent:filename];//缓存路径
        
        
        NSString *absolutePath = [SBFileTool absolutePath:namePath filePathType:SBFileToolPathTypeCache];//绝对路径
        
        return [NSURL fileURLWithPath:absolutePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (responsed) {
                responsed(NO,nil);
            }
        }else{
            NSLog(@"filepath:%@",filePath.absoluteString);
            if (responsed) {
                responsed(YES,nil);
            }
        }
    }];
    
    [sessionTask resume];
    
    return sessionTask;
}

- (NSURLSessionDataTask *)DownloadVideoSizeWithUrl:(NSString * _Nullable)Url
                                        parameters:(NSDictionary * _Nullable)parameters
                                   timeoutInterval:(CGFloat)timeoutInterval
                                          progress:(ERDownloadProgressBlock _Nullable )progress
                                          response:(SBAIRequestResponseBlock _Nullable )responsed{
    NSLog(@"请求接口%@", Url);
    NSLog(@"请求参数%@", [parameters mj_JSONString]);
    AFHTTPSessionManager *manager = _netManager;
    
    CGFloat time = DEFAULT_TIMEOUT_INTERVAL;
    if (timeoutInterval > 0) time = timeoutInterval;
    manager.requestSerializer.timeoutInterval = time;
    NSURLSessionDataTask *task = [manager GET:Url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) progress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responsed) responsed(NO,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (responsed) responsed(NO,nil);
    }];
    return task;
}

- (NSString *)getUniqueStrByUUID{
    return [[NSUUID UUID] UUIDString];
}

///获取请求返回的Msg
+ (NSString *_Nonnull)getNetWorkResponseMsg:(SBAIResponseModel *_Nullable)responseModel{
    if (tf_isEmptyString(responseModel.code)) {
        return @"系统繁忙，请稍候重试";
    }
    if (tf_isEmptyString(responseModel.msg)) {
        return @"系统繁忙，请稍候重试";
    }
    if (responseModel.msg.length > 50) {//有可能是数据库sql异常、后台崩溃等错误
        return @"系统繁忙，请稍候重试";
    }
    return tf_isEmptyString(responseModel.msg) ? @"系统繁忙，请稍候重试" : responseModel.msg;
}

@end
