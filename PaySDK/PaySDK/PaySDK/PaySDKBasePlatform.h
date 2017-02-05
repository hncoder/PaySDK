//
//  PaySDKBasePlatform.h
//  PaySDK
//
//  Created by hncoder on 2017/2/5.
//  Copyright © 2017年 hncoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaySDKObject.h"

@interface PaySDKBasePlatform : NSObject<PayPlatformProtocol>

- (void)sendPrepayResp:(NSDictionary *)resp;
- (void)completionWithCheckingError:(NSError *)error;
- (NSString *)errStrWithErrCode:(PayErrCode)errCode;

@end
