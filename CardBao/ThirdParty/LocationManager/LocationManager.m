//
//  LocationManager.m
//  CardBao
//
//  Created by zhangmingheng on 2018/10/29.
//  Copyright © 2018 andy_zhang. All rights reserved.
//

#import "LocationManager.h"
// 原生的定位框架
#import <CoreLocation/CoreLocation.h>
@interface LocationManager()<CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager* locationManager;
// 当前的viewController
@property (nonatomic, strong) UIViewController *parentViewController;
@property (nonatomic) void (^requestLocation)(LocationManager * _Nonnull manage, NSInteger code ,NSDictionary *_Nonnull result);

@end

@implementation LocationManager
+(instancetype)shareInstance {
    static LocationManager *manage =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage =[[LocationManager alloc]init];
        manage.locationManager = [CLLocationManager new];
        manage.locationManager.delegate = manage;
        manage.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    });
    return manage;
}
- (void)requestLocation:(UIViewController* _Nonnull) viewController resultBlock:(requestLocation _Nonnull) requestLocation {
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0){
        self.parentViewController = viewController;
        self.requestLocation      = requestLocation;
    
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//            NSLog(@"requestWhenInUseAuthorization");
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        //开始定位，不断调用其代理方法
        [self.locationManager startUpdatingLocation];
        //  判断是否有权限
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied&&[viewController isKindOfClass:[UIViewController class]]) {
            [self showAlertView];
            
        }
    } else {
        [Helper alertMessage:@"请升级iOS系统至8.0及以上" addToView:self.parentViewController.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [viewController.navigationController popViewControllerAnimated:YES];
        });
    }
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    // 2.停止定位
    [manager stopUpdatingLocation];
    
    // 获取·城市
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *place = placemarks[0];
        // NSLog(@"ddfff:%@",place.addressDictionary); // 详细地址
        self.requestLocation(self, 0, @{@"latitude":[NSString stringWithFormat:@"%f",coordinate.latitude],
                                        @"longitude":[NSString stringWithFormat:@"%f",coordinate.longitude],
                                        @"gpsCity":[NSString stringWithFormat:@"%@",place.locality],
                                        @"gpsProvince":[NSString stringWithFormat:@"%@",place.administrativeArea],
                                        });
    }];
    //    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
}
//提示没有定位权限
- (void)showAlertView{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"授权访问定位服务"
                                          message:@"请点击“允许”以允许访问,借款需要提供您的地理位置信息，若不允许，您将无法发送地理位置进行申请借款"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.parentViewController.navigationController popViewControllerAnimated:YES];
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] openURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    [alertController addAction:OKAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self.parentViewController.navigationController popViewControllerAnimated:YES];
    }]];
    [self.parentViewController presentViewController:alertController animated:YES completion:nil];
}
@end
