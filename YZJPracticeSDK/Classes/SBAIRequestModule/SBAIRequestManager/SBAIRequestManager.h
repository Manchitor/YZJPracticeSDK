//
//  SBAIRequestManager.h
//  ElectricRoom
//
//  Created by 刘永吉 on 2022/5/25.
//

#import <Foundation/Foundation.h>
#import "SBAIResponseModel.h"

#define RequestManager [SBAIRequestManager shareAFNetworking]

#define DEFAULT_TIMEOUT_INTERVAL  20.0   //超时时间

#define DEFAULT_MAX_TIMEOUT_INTERVAL  600.0   //超时时间

#define DEFAULT_TIMEOUT_INTERVAL_FILE  30.0   //超时时间


typedef void(^SBAIRequestResponseBlock)(BOOL isSuccess, SBAIResponseModel *responseObject);

typedef void(^ERDownloadProgressBlock)(NSProgress * downloadProgress);

@interface SBAIRequestManager : NSObject



+ (SBAIRequestManager *)shareAFNetworking;

/**
 *
 *    取消所有请求
 */
- (void)cancelAllRequest;
/**
 *
 *  取消某个请求。如果是要取消某个请求，最好是引用接口所返回来的HYBURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *@param url                URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
- (void)cancelRequestWithURL:(NSString *)url;

- (void)reloadHeaderData;

#pragma mark -- get相关

- (NSURLSessionDataTask *)GetWithUrl:(NSString *)Url
                            response:(SBAIRequestResponseBlock)response;

- (NSURLSessionDataTask *)GetWithUrl:(NSString *)Url
                            progress:(ERDownloadProgressBlock)progress
                            response:(SBAIRequestResponseBlock)response;

- (NSURLSessionDataTask *)GetWithUrl:(NSString *)Url
                     timeoutInterval:(CGFloat)timeoutInterval
                            response:(SBAIRequestResponseBlock)response;

- (NSURLSessionDataTask *)GetWithUrl:(NSString *)Url
                          parameters:(NSDictionary *)parameters
                     timeoutInterval:(CGFloat)timeoutInterval
                            response:(SBAIRequestResponseBlock)response;

- (NSURLSessionDataTask *)GetWithUrl:(NSString *)Url
                          parameters:(NSDictionary *)parameters
                     timeoutInterval:(CGFloat)timeoutInterval
                            progress:(ERDownloadProgressBlock)progress
                            response:(SBAIRequestResponseBlock)response;

#pragma mark -- post相关

- (NSURLSessionDataTask *)PostWithUrl:(NSString *)Url
                           parameters:(NSDictionary *)parameters
                              response:(SBAIRequestResponseBlock)response;

- (NSURLSessionDataTask *)PostWithUrl:(NSString *)Url
                      timeoutInterval:(CGFloat)timeoutInterval
                           parameters:(NSDictionary *)parameters
                              response:(SBAIRequestResponseBlock)response;

- (NSURLSessionDataTask *)PostWithUrl:(NSString *)Url
                      timeoutInterval:(CGFloat)timeoutInterval
                           parameters:(NSDictionary *)parameters
                           handleCode:(BOOL)handleCode
                             response:(SBAIRequestResponseBlock)response;

- (NSURLSessionDataTask *)PostWithUrl:(NSString *)Url
                      timeoutInterval:(CGFloat)timeoutInterval
                           parameters:(NSDictionary *)parameters
                             progress:(ERDownloadProgressBlock)progress
                             response:(SBAIRequestResponseBlock)response;

- (NSURLSessionDataTask *)PostWithUrl:(NSString *)Url
                      timeoutInterval:(CGFloat)timeoutInterval
                           parameters:(NSDictionary *)parameters
                           handleCode:(BOOL)handleCode
                             progress:(ERDownloadProgressBlock)progress
                             response:(SBAIRequestResponseBlock)response;


//上传图片
- (NSURLSessionDataTask *)PostImageWithUrl:(NSString *)Url
                      timeoutInterval:(CGFloat)timeoutInterval
                              imageData:(NSData *)imageData
                           parameters:(NSDictionary *)parameters
                             response:(SBAIRequestResponseBlock)response;
///上传文件
- (NSURLSessionDataTask *)PostFileWithUrl:(NSString *)Url
                          timeoutInterval:(CGFloat)timeoutInterval
                                 fileData:(NSData *)fileData
                               parameters:(NSDictionary *)parameters
                                 response:(SBAIRequestResponseBlock)response;

- (NSURLSessionDataTask *)PostFileWithUrl:(NSString *)Url
                          timeoutInterval:(CGFloat)timeoutInterval
                                 fileData:(NSData *)fileData
                                 fileName:(NSString *) fileName
                               parameters:(NSDictionary *)parameters
                                 response:(SBAIRequestResponseBlock)response;

/**
 文件上传（多图）
 */
- (NSURLSessionDataTask *) doUploadImagesWithURL:(NSString *) Url
                            parameters:(nullable id)parameters
                           timeoutInterval:(CGFloat)timeoutInterval
                                   fileDataArray:(NSArray *_Nullable) imageArray                 name:(NSString *_Nullable) name response:(SBAIRequestResponseBlock _Nullable )response;

- (NSURLSessionDataTask *_Nullable)DownloadWithUrl:(NSString *_Nullable)Url
                          parameters:(NSDictionary *_Nullable)parameters
                     timeoutInterval:(CGFloat)timeoutInterval
                                 progress:(ERDownloadProgressBlock _Nullable )progress
                                 response:(SBAIRequestResponseBlock _Nonnull )response;



///下载视频文件
- (NSURLSessionDownloadTask *_Nullable)DownloadVideoWithUrl:(NSString * _Nullable)Url
                          parameters:(NSDictionary * _Nullable)parameters
                     timeoutInterval:(CGFloat)timeoutInterval
                                      progress:(ERDownloadProgressBlock _Nullable )progress
                                      response:(SBAIRequestResponseBlock _Nullable )responsed;
///获取视频文件大小
- (NSURLSessionDataTask *)DownloadVideoSizeWithUrl:(NSString * _Nullable)Url
                                        parameters:(NSDictionary * _Nullable)parameters
                                   timeoutInterval:(CGFloat)timeoutInterval
                                          progress:(ERDownloadProgressBlock _Nullable )progress
                                          response:(SBAIRequestResponseBlock _Nullable )responsed;

///获取请求返回的Msg
+ (NSString *_Nonnull)getNetWorkResponseMsg:(SBAIResponseModel *_Nullable)responseModel;

@end

