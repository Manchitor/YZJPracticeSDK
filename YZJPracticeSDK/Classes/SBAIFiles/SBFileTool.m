//
//  SBFileTool.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/22.
//

#import "SBFileTool.h"

@implementation SBFileTool

/// 处理路径为绝对路径
/// @param path 路径名称
/// @param filePathType 路径类型存放地
+ (NSString *) absolutePath:(NSString *)path filePathType:(SBFileToolPathType)filePathType{
    
    [SBFileTool assertPath:path];
    
    if (filePathType == SBFileToolPathTypeDocuments) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths lastObject];
        return [documentDirectory stringByAppendingPathComponent:path];
    }else if (filePathType == SBFileToolPathTypeCache){
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths lastObject];
        return [cacheDirectory stringByAppendingPathComponent:path];
    }else{
        return [NSTemporaryDirectory() stringByAppendingPathComponent:path];
    }
}

+(NSString *)createPath:(NSString *)path{
    [self assertPath:path];

    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSLog(@"文件夹已经存在,不需要创建");
        return path;
    }else{
        NSError *error;
        if ([[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"创建文件夹成功，目录 = %@", path);
            return path;
        }else {
            NSLog(@"创建文件夹失败，原因是 = %@", path);
            return nil;
        }
    }
}

/// 删除文件夹存储路径
/// @param path 文件夹绝对路径
+ (void) removePath:(NSString *)path{
    [self assertPath:path];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSError *error;
        NSLog(@"文件夹已经存在,需要删除");
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }else{
        NSLog(@"文件夹不存在,不需要删除");
    }
}


/// 判断文件是否存在
/// @param path 文件绝对路径
+ (BOOL) isfileExistsAtPath:(NSString *)path{
    [self assertPath:path];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}


/// 写入文件
/// @param path 文件的绝对路径
/// @param content 文件内容
+(BOOL)writeFileAtPath:(NSString *)path content:(NSData *)content{
    if(content == nil)
    {
        [NSException raise:@"Invalid content" format:@"content can't be nil."];
    }
    
    return [((NSData *)content) writeToFile:path atomically:YES];
}

+(NSData *)readFileAtPath:(NSString *)path{
    return [NSData dataWithContentsOfFile:path options:NSDataReadingMapped error:nil];
}


+ (void)assertPath:(NSString *)path{
    NSAssert(path != nil, @"Invalid path. Path cannot be nil.");
    NSAssert(![path isEqualToString:@""], @"Invalid path. Path cannot be empty string.");
}

#pragma mark ----------判断文件是否存在
+ (NSString *)fileItemInCacheDirectory:(NSString *)filename
{
    
    NSString *absolutePath = [SBFileTool absolutePath:@"practice_video_file" filePathType:SBFileToolPathTypeCache];//绝对路径
    
    NSArray *paths = [SBFileTool listItemsInDirectoryAtPath:absolutePath];//获取时间目录
    
    for (NSString *path in paths) {
        BOOL isExists =  [SBFileTool isfileExistsAtPath:[path stringByAppendingPathComponent:filename]];
        if (isExists)
        {
            return [path stringByAppendingPathComponent:filename];
        }
    }
    return nil;
}

#pragma mark ----------获取缓存文件目录
+(NSArray *)listItemsInDirectoryAtPath:(NSString *)path
{
    NSArray *relativeSubpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSMutableArray *absoluteSubpaths = [[NSMutableArray alloc] init];
    
    for(NSString *relativeSubpath in relativeSubpaths)
    {
        NSString *absoluteSubpath = [path stringByAppendingPathComponent:relativeSubpath];
        [absoluteSubpaths addObject:absoluteSubpath];
    }
    
    return [NSArray arrayWithArray:absoluteSubpaths];
}
@end
