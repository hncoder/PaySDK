//
//  PaySDKWXPlatform.m
//  PaySDK
//
//  Created by hncoder on 2017/2/5.
//  Copyright © 2017年 hncoder. All rights reserved.
//

#import "PaySDKWXPlatform.h"
#import "WXApi.h"

@interface PaySDKWXPlatform()<WXApiDelegate>

@end

@implementation PaySDKWXPlatform

- (void)sendPrepayResp:(NSDictionary *)resp
{
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [resp objectForKey:@"partnerid"];
    req.prepayId            = [resp objectForKey:@"prepayid"];
    req.nonceStr            = [resp objectForKey:@"noncestr"];
    req.timeStamp           = [[resp objectForKey:@"timestamp"] unsignedIntValue];
    req.package             = [resp objectForKey:@"package"];
    req.sign                = [resp objectForKey:@"sign"];
    
    if (![WXApi sendReq:req])
    {
        NSError *error = [NSError errorWithDomain:@"" code:PayErrCodeFail userInfo:nil];
        [self completionWithCheckingError:error];
    }
}

- (BOOL)handlePayPlatformResqURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

+ (BOOL)isSupported
{
    return [WXApi isWXAppInstalled];
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp
{
    PayErrCode errCode = PayErrCodeSuccess;
    
    switch (resp.errCode)
    {
        case WXSuccess:
            errCode = PayErrCodeSuccess;
            break;
            
        case WXErrCodeUserCancel:
            errCode = PayErrCodeCancel;
            break;
            
        case WXErrCodeAuthDeny:
            errCode = PayErrCodeAuthFail;
            break;
            
        default:
            errCode = PayErrCodeFail;
            break;
    }
    
    
    NSError *error = [NSError errorWithDomain:@"" code:errCode userInfo:nil];
    [self completionWithCheckingError:error];
}

@end
