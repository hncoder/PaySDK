//
//  PaySDKObject.h
//  PaySDK
//
//  Created by hncoder on 2017/2/5.
//  Copyright © 2017年 hncoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// Pay platform type defines, it just supports WeChat now.
typedef NS_ENUM(NSUInteger, PayPlatformType)
{
    PayPlatformTypeWXPay = 1, // Wechat pay.
    PayPlatformTypeAliPay // Ali pay.(supported at a later time)
};

// Pay response error code defines.
typedef NS_ENUM(NSUInteger, PayErrCode)
{
    PayErrCodeSuccess = 0, // Succeed.
    PayErrCodeCancel,  // Cancelled may be by user.
    PayErrCodeFail,    // Common Fail.
    PayErrCodeAuthFail, // Auth Fail.
    PayErrCodeNotSupport, // Not support(not installed).
    PayErrCodeOrderPaid, // The order is paid.
    PayErrCodeOrderCancelled, // The order is cancelled.
    PayErrCodeOrderOvertime, // the order is unpaid overtime.
    
};

// Pay order status
typedef NS_ENUM(NSUInteger, PayStatus)
{
    PayStatusUnknown = 0, // 未知
    PayStatusNotPrepay = 1, // 订单已创建，预支付信息为创建
    PayStatusNotPaid = 2, // 预支付信息已生成，待支付
    PayStatusPaid = 5, // 已支付
    // 其它订单状态，这里不需要定义了
};

@protocol PayGetInfoUtil;
/**
 Request class of pay.
 */
@interface PaySDKReq : NSObject
@property (nonatomic, assign) uint64_t orderId; // Order id
// The platform to do pay
@property (nonatomic, assign)   PayPlatformType payPlatformType;
// The controller in which the pay is requested
@property (nonatomic, weak)     UIViewController *payInController;
// Store extra information if needed for the specific pay
@property (nonatomic, strong)   id extra;
// The util to get prepay info
@property (nonatomic, strong) id<PayGetInfoUtil> getInfoUtil;


@end


/**
 Response class of pay.
 */
@interface PaySDKResp : NSObject

@property (nonatomic, assign)   PayErrCode errCode;   // Error code
@property (nonatomic, copy)     NSString *errStr;       // Error string
@property (nonatomic, assign)   PayStatus payStatus;   // Order status
@property (nonatomic, strong)   PaySDKReq *payReq;       // Pay request information

@end


/**
 Completion block to call when prepay information fetched.
 
 @param payStatus Pay status
 @param prepay Prepay information
 @param error `Nil` if no error
 */
typedef void(^PayGetPrepayInfoCompletion)(PayStatus payStatus, NSDictionary *prepay, NSError *error);
/**
 Completion block to call when order status fetched
 
 @param payStatus Order id
 @param error `Nil` if no error
 */
typedef void(^PayGetPayStatusCompletion)(PayStatus payStatus, NSError *error);
/**
 Get prepay information util protocol.
 */
@protocol PayGetInfoUtil <NSObject>

- (BOOL)onGetPrepayInfoWithPayReq:(PaySDKReq *)payReq complection:(PayGetPrepayInfoCompletion)completion;
- (BOOL)onGetPayStatusWithPayReq:(PaySDKReq *)payReq complection:(PayGetPayStatusCompletion)completion;

@optional
- (NSString *)errStrWithErrCode:(PayErrCode)errCode;

@end


/**
 Completion block to call when the pay operation finished.
 
 @param payResp The response of pay.
 */
typedef void(^PaySDKCompletion)(PaySDKResp *payResp);
/**
 Pay platform protocol.
 */
@protocol PayPlatformProtocol <NSObject>

- (BOOL)onPayReq:(PaySDKReq *)payReq completion:(PaySDKCompletion)completion;
- (BOOL)handlePayPlatformResqURL:(NSURL *)url;
+ (BOOL)isSupported;

@end

