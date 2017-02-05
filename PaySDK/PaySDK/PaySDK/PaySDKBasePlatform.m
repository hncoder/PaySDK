//
//  PaySDKBasePlatform.m
//  PaySDK
//
//  Created by hncoder on 2017/2/5.
//  Copyright © 2017年 hncoder. All rights reserved.
//

#import "PaySDKBasePlatform.h"

@interface PaySDKBasePlatform()

@property (nonatomic, strong, readwrite) PaySDKReq *payReq;
@property (nonatomic, strong, readwrite) PaySDKCompletion completion;
@property (nonatomic, assign) PayStatus payStatus;

@end

@implementation PaySDKBasePlatform

- (BOOL)onPayReq:(PaySDKReq *)payReq completion:(PaySDKCompletion)completion
{
    self.payReq = payReq;
    self.completion = completion;
    
    // Request to get prepay information
    [self requestToGetPrepayInformation];
    
    return YES;
}

- (void)requestToGetPrepayInformation
{
    [self.payReq.getInfoUtil onGetPrepayInfoWithPayReq:self.payReq complection:^(NSUInteger orderStatus, NSDictionary *prepay, NSError *error) {
        
        assert([NSThread isMainThread]);
        if (!prepay)
        {
//            error = [NSError errorWithDomain:@"" code:errCode userInfo:nil];
            [self completionWithError:error];
        }
        else
        {
            [self sendPrepayResp:prepay];
        }
    }];
}

- (void)sendPrepayResp:(NSDictionary *)resp
{
    // Implementation in subclass method
    assert(0);
}

- (void)completionWithError:(NSError *)error
{
    PaySDKResp *payResp = [[PaySDKResp alloc] init];
    payResp.errCode = error.code;
    payResp.errStr = [self errStrWithErrCode:error.code];
    payResp.payReq = self.payReq;
    payResp.payStatus = self.payStatus;
    
    if (self.completion)
    {
        self.completion(payResp);
        self.completion = nil;
    }
}

- (void)completionWithCheckingError:(NSError *)error
{
    if (error.code == PayErrCodeSuccess)
    {
        // Check order status from server
        [self.payReq.getInfoUtil onGetPayStatusWithPayReq:self.payReq complection:^(NSUInteger orderStatus, NSError *error) {
            // If error, set GMPayOrderStatusPaid default.
            self.payStatus = error ? PayStatusPaid : orderStatus;
            [self completionWithError:[NSError errorWithDomain:@"" code:PayErrCodeSuccess userInfo:nil]];
        }];
    }
    else
    {
        [self completionWithError:error];
    }
}

- (NSString *)errStrWithErrCode:(PayErrCode)errCode
{
    NSString *errStr = nil;
    if ([self.payReq.getInfoUtil respondsToSelector:@selector(errStrWithErrCode:)])
    {
        errStr = [self.payReq.getInfoUtil errStrWithErrCode:errCode];
    }
    else
    {
        switch (errCode)
        {
            case PayErrCodeSuccess:
                errStr = @"";
                break;
                
            case PayErrCodeFail:
                errStr = @"支付异常，请稍后在我的活动";
                break;
                
            case PayErrCodeCancel:
                errStr = @"您已经取消了支付";
                break;
                
            case PayErrCodeAuthFail:
                errStr = @"授权失败，请稍后再试";
                break;
                
            case PayErrCodeNotSupport:
                errStr = @"支付不支持";
                break;
                
            case PayErrCodeOrderPaid:
                errStr = @"已支付成功";
                break;
                
            case PayErrCodeOrderCancelled:
                errStr = @"支付已被取消";
                break;
                
            case PayErrCodeOrderOvertime:
                errStr = @"未支付超时";
                break;
                
            default:
                break;
        }
    }
    
    return errStr;
}

- (BOOL)handlePayPlatformResqURL:(NSURL *)url
{
    return NO;
}

+ (BOOL)isSupported
{
    return NO;
}

@end
