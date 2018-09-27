//
//  RequestManage.m
//  QIJIAApartment
//
//  Created by zhangmingheng on 2017/8/9.
//  Copyright © 2017年 Shenzhen Feiben Technology Co., Ltd. All rights reserved.
//

#import "FloatView.h"
#import "RequestManager.h"
#import "RequestCacheManager.h"
#import "RequestActivityIndicatorView.h"
#import "UIActivityIndicatorView+AFNetworking.h"

@interface RequestManager()

@end
@implementation RequestManager

+(instancetype)shareInstance{
    static RequestManager *manage =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage =[[RequestManager alloc]init];
    });
    manage.isCache = NO;
    return manage;
}
#define mark post请求
-(NSURLSessionDataTask*_Nonnull)postWithURL:(NSString*_Nonnull) urlString parameters:(id _Nullable )parameters isLoading:(BOOL) isLoad loadTitle:(NSString*_Nullable) title addLoadToView:(UIView*_Nullable) view andWithSuccess:(httpRequestSuccsess _Nonnull )success andWithWarn:(httpRequestWarn _Nonnull )warn andWithFaile:(httpRequestFaile _Nonnull )faile isCache:(BOOL) isCache {
    //    urlString ：URL
    //    parameters：参数
    //    isLoad：是否加载
    //    title：加载文字
    //    view：在那加载
//        success：成功回调
//        faile：失败的回调
    //   isCache: 是否缓存 默认NO
    BLYLogInfo(@"\n\n请求前Url:\n%@ \nparameters:\n%@\n\n",urlString,parameters);
    
    [Helper removeAlertMessage]; // 移除气泡
    
    self.isCache = isCache;
    BLYLogInfo(@"\n\n是否缓存数据(1:是，0:否)：%d:\n\n",self.isCache);
    
    // 是否缓存，不缓存就直接请求数据
    if (self.isCache) {
    // 判断是否有缓存数据，如果有、先拿旧数据刷新UI，然后请求数据刷新UI并替换旧数据
        
        RequestCacheManager *cacheManager = [[RequestCacheManager alloc]initWithCacheURL:urlString withParameters:parameters];
        
        BLYLogInfo(@"\n\n文件夹是否存在(URL和参数拼接的)(1:是，0:否) :%d\n\n",cacheManager.isFileExist);
        if (cacheManager.isFileExist) {
            
            id cacheData = [cacheManager getCacheDataForArchiver];
           success(self,cacheData);
            BLYLogInfo(@"\n\n本地缓存数据%@:\n\n",cacheData);
            
        }
    }
    
    return [self setPostURL:urlString parameters:parameters isLoading:isLoad loadTitle:title addLoadToView:view andWithSuccess:success andWithWarn:warn andWithFaile:faile];
}
-(NSURLSessionDataTask*)setPostURL:(NSString*_Nonnull) urlString parameters:(id _Nullable )parameters isLoading:(BOOL) isLoad loadTitle:(NSString*_Nullable) title addLoadToView:(UIView*_Nullable) view andWithSuccess:(httpRequestSuccsess _Nonnull )success andWithWarn:(httpRequestWarn _Nonnull )warn andWithFaile:(httpRequestFaile _Nonnull )faile {
    
    // 请求管理者
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    //        httpManager.requestSerializer = [AFJSONRequestSerializer serializer]; // Json 请求格式
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 返回的数据格式
    //   httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    httpManager.requestSerializer.timeoutInterval = 20.0; // 请求时长
    // 请求
    NSURLSessionDataTask *task = [httpManager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功
        NSDictionary *dicJson =[NSJSONSerialization JSONObjectWithData:[NSData dataWithData:responseObject] options:NSJSONReadingMutableLeaves error:nil];
        
        BLYLogInfo(@"\n\n**********Start****************\n请求后Url:\n%@ \nparameters:\n%@ \n\nresponseObject:\n%@\n**********End***********\n\n",urlString,parameters,dicJson);
        self.model = dicJson;
        //  block 传值
        if ([Helper justDictionary:dicJson]&&![dicJson[@"code"] isKindOfClass:[NSNull class]]&&dicJson[@"code"]!=nil) {
            if ([dicJson[@"code"] integerValue] == 0) {
                
                // 成功回调
                success(self,dicJson[@"data"]);
                
                // 是否缓存数据 并且不是空值
                if (self.isCache&&dicJson[@"data"]!=nil&&![dicJson[@"data"] isKindOfClass:[NSNull class]]) {
                    
                     RequestCacheManager *cacheManager = [[RequestCacheManager alloc]initWithCacheURL:urlString withParameters:parameters];
                    //存储
                    BLYLogInfo(@"\n\n缓存数据是否成功(1:是，0:否)：%d\n\n",  [cacheManager saveCaDataForArchiver:dicJson[@"data"]]);
                }
            } else {
                warn(self,dicJson);
                [Helper alertMessage:dicJson[@"msg"] addToView:view];
            }
            
        }else [Helper alertMessage:@"返回数据错误" addToView:view];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败
        [Helper alertMessage:@"网络异常,请求失败" addToView:view];
        BLYLogInfo(@"\nError:\n%@\n",error);
        faile(self,error);
    }];
    if (isLoad) {
        //加载器
        [[RequestActivityIndicatorView showAIVAddedTo:view] setAnimatingWithStateOfTask:task];
    }
    return task;
}
// 图片上面(支持多张上传)
-(NSURLSessionDataTask*_Nonnull)upLoadPostWithUR:(NSString*_Nonnull) urlString parameters:(id _Nullable )parameters andWithSuccess:(httpRequestSuccsess _Nonnull )success andWithFaile:(httpRequestFaile _Nonnull )faile{
    // 请求管理者
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
//    httpManager.requestSerializer = [AFJSONRequestSerializer serializer]; // Json 请求格式
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 返回的数据格式
    NSURLSessionDataTask *task = [httpManager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        数组形式传参
        if ([parameters isKindOfClass:[NSArray class]]) {
            NSArray *imageArray = parameters;
            if (imageArray.count>0) {
                [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    /*! image的压缩方法 */
                    UIImage *resizedImage;
                    resizedImage = obj;
                    [self ba_uploadImageWithFormData:formData resizedImage:resizedImage imageType:@"png" imageScale:0.5 fileNames:nil index:idx];
                }];

            }
            return ;
        }
//               单张image形式传参
        if ([parameters isKindOfClass:[UIImage class]]){
            NSData *data = UIImageJPEGRepresentation(parameters, 0.3);//UIImagePNGRepresentation(image);
            //文件上传时不允许被覆盖或文件重名,所以在上传时使用当前系统时间作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmssSSSS";//设置时间格式
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            //参数1:上传的二进制；参数2:服务器上传标识字段，由后台指定；参数3:上传的文件名；参数4:上传格式
            [formData appendPartWithFileData:data
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        BLYLogInfo(@"单张图片上传成功: %@", dic);
        success(self,dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BLYLogInfo(@"单张图片上传失败: %@", error);
        faile(self,error);
    }];
    return task;
}
- (void)ba_uploadImageWithFormData:(id<AFMultipartFormData>  _Nonnull )formData
                      resizedImage:(UIImage *)resizedImage
                         imageType:(NSString *)imageType
                        imageScale:(CGFloat)imageScale
                         fileNames:(NSArray <NSString *> *)fileNames
                             index:(NSUInteger)index
{
//    resizedImage  每个上传的图片
    /*! 此处压缩方法是jpeg格式是原图大小的0.8倍，要调整大小的话，就在这里调整就行了还是原图等比压缩 */
    if (imageScale == 0)
    {
        imageScale = 0.8;
    }
    // 两种压缩图片的方法：压缩图片质量(Quality)，压缩图片尺寸(Size)。
    // 目前用到的是图片质量的压缩
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, imageScale ?: 1.f);
    
    /*! 拼接data */
    if (imageData != nil)
    {   // 图片数据不为空才传递 fileName
        //                [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
        
        // 默认图片的文件名, 若fileNames为nil就使用
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *imageFileName = [NSString stringWithFormat:@"%@%luld.%@",str, (unsigned long)index, imageType?:@"jpg"];
        
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileNames ? [NSString stringWithFormat:@"%@.%@",fileNames[index],imageType?:@"jpg"] : imageFileName
                                mimeType:[NSString stringWithFormat:@"image/%@",imageType ?: @"jpg"]];
        BLYLogInfo(@"上传图片 %lu 成功", (unsigned long)index);
    }
}
@end
