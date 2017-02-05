//
//  PaySDK.m
//  PaySDK
//
//  Created by hncoder on 2017/2/5.
//  Copyright © 2017年 hncoder. All rights reserved.
//

#import "PaySDK.h"
#import "PaySDKWXPlatform.h"
#import "PaySDKAliPlatform.h"

@interface PayPlatformFactory : NSObject

+ (id<PayPlatformProtocol>)payPlatformWithType:(PayPlatformType)payPlatformType;

@end

@implementation PayPlatformFactory

+ (id<PayPlatformProtocol>)payPlatformWithType:(PayPlatformType)payPlatformType
{
    id<PayPlatformProtocol> payPlatform = nil;
    
    switch (payPlatformType)
    {
        case PayPlatformTypeWXPay:
            payPlatform = [[PaySDKWXPlatform alloc] init];
            break;
        case PayPlatformTypeAliPay:
            payPlatform = [[PaySDKAliPlatform alloc] init];
            break;
        default:
            break;
    }
    
    return payPlatform;
}

+ (BOOL)isSupportedWithPayPlatform:(PayPlatformType)payPlatformType
{
    BOOL isSupported = NO;
    switch (payPlatformType)
    {
        case PayPlatformTypeWXPay:
            isSupported = [PaySDKWXPlatform isSupported];
            break;
        case PayPlatformTypeAliPay:
            isSupported = [PaySDKAliPlatform isSupported];
            break;
        default:
            break;
    }
    
    return isSupported;
}

@end

@interface PaySDK()

@property (nonatomic, strong) id<PayPlatformProtocol> payPlatform;

@end

@implementation PaySDK


+ (instancetype)sharedInstance
{
    static PaySDK *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

+ (BOOL)onPayReq:(PaySDKReq *)payReq completion:(PaySDKCompletion)completion
{
    assert([NSThread isMainThread]);
    if (![[self class] isSupportedWithPayPlatform:payReq.payPlatformType])
    {
        return NO;
    }
    
    [PaySDK sharedInstance].payPlatform = [PayPlatformFactory payPlatformWithType:payReq.payPlatformType];
    return [[PaySDK sharedInstance].payPlatform onPayReq:payReq completion:completion];
}

+ (BOOL)handlePayPlatformResqURL:(NSURL *)url
{
    assert([NSThread isMainThread]);
    return [[PaySDK sharedInstance].payPlatform handlePayPlatformResqURL:url];
}

+ (BOOL)isSupportedWithPayPlatform:(PayPlatformType)payPlatformType
{
    return [PayPlatformFactory isSupportedWithPayPlatform:payPlatformType];
}

@end
