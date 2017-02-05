//
//  PaySDK.h
//  PaySDK
//
//  Created by hncoder on 2017/2/5.
//  Copyright © 2017年 hncoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaySDKObject.h"

@interface PaySDK : NSObject

/**
 Method to pay.
 
 @param payReq The pay request information
 @param completion Completion block of the pay request
 @return `Yes` if successful; `No` if fail, maybe the pay request info has error params, or the pay platform type is not supported.
 */
+ (BOOL)onPayReq:(PaySDKReq *)payReq completion:(PaySDKCompletion)completion;

/**
 Handle the callback url from the third-party pay platform.
 
 @param url URL to handle
 @return `YES` if the url matches a pay platform; `NO` if no pay platform can handle it.
 */
+ (BOOL)handlePayPlatformResqURL:(NSURL *)url;

/**
 Check whether or not the pay platform is supported.
 
 @param payPlatformType Type of pay platform
 @return `YES` if supported, `NO` if not supported(e.g., the third-party pay platform is not installed on device).
 */
+ (BOOL)isSupportedWithPayPlatform:(PayPlatformType)payPlatformType;

@end
