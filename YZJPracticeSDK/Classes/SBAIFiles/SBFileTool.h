//
//  SBFileTool.h
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 文件路径类型
typedef NS_ENUM(NSInteger, SBFileToolPathType) {
    ///应用中用户数据可以放在这里，iTunes备份和恢复的时候会包括此目录
    SBFileToolPathTypeDocuments             = 0,
    /// 存放临时文件，iTunes不会备份和恢复此目录，此目录下文件可能会在应用退出后删除
    SBFileToolPathTypeTmp                   = 1,
    /// 存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
    SBFileToolPathTypeCache                 = 2,
    
};

@interface SBFileTool : NSObject


/// 处理路径为绝对路径
/// @param path 路径名称
/// @param filePathType 路径类型存放地
+ (NSString *) absolutePath:(NSString *)path filePathType:(SBFileToolPathType)filePathType;


/// 创建文件夹存储路径
/// @param path 文件夹绝对路径
+ (NSString *) createPath:(NSString *)path;

/// 删除文件夹存储路径
/// @param path 文件夹绝对路径
+ (void) removePath:(NSString *)path;

/// 判断文件是否存在
/// @param path 文件绝对路径
+ (BOOL) isfileExistsAtPath:(NSString *)path;

/// 写入文件
/// @param path 文件的绝对路径
/// @param content 文件内容
+ (BOOL) writeFileAtPath:(NSString *)path content:(NSData *)content;


/// 读取文件
/// @param path 文件绝对路径
+ (NSData *) readFileAtPath:(NSString *)path;


/// 判断文件是否存在
/// @param filename: 文件名字
+ (NSString *)fileItemInCacheDirectory:(NSString *)filename;

/// 获取子文件夹数组
/// @param path: 文件夹名称
+(NSArray *)listItemsInDirectoryAtPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
