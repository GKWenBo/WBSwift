//
//  Adaptive.h
//  NewFeatureXcode
//
//  Created by wenbo on 2021/11/19.
//

/*
 availability.h
 AvailabilityVersion.h
 NSObjCRuntime.h
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// [AFNetworking](https://github.com/AFNetworking/AFNetworking)适配方案
#if ((__IPHONE_OS_VERSION_MAX_ALLOWED && __IPHONE_OS_VERSION_MAX_ALLOWED < 100000) || (__MAC_OS_VERSION_MAX_ALLOWED && __MAC_OS_VERSION_MAX_ALLOWED < 101200) ||(__WATCH_OS_MAX_VERSION_ALLOWED && __WATCH_OS_MAX_VERSION_ALLOWED < 30000) ||(__TV_OS_MAX_VERSION_ALLOWED && __TV_OS_MAX_VERSION_ALLOWED < 100000))
    #define AF_CAN_INCLUDE_SESSION_TASK_METRICS 0
#else
    #define AF_CAN_INCLUDE_SESSION_TASK_METRICS 1
#endif

NS_ASSUME_NONNULL_BEGIN

// [QMUI_iOS](https://github.com/Tencent/QMUI_iOS)适配方案
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000
/// 当前编译使用的 Base SDK 版本为 iOS 14.0 及以上
#define IOS14_SDK_ALLOWED YES
#endif

// 类引入时版本
API_AVAILABLE(ios(2.0)) @interface AdaptiveOC : NSObject

/// 定义属性适应版本
#ifdef __IPHONE_15_0
@property (nonatomic, strong) UINavigationBarAppearance *km_transitionBarAppearance API_AVAILABLE(ios(15.0));
#endif

// API启用，iOS7.0引入，11.0废弃
@property(nonatomic,assign) BOOL automaticallyAdjustsScrollViewInsets API_DEPRECATED("Use UIScrollView's contentInsetAdjustmentBehavior instead", ios(7.0,11.0),tvos(7.0,11.0)); // Defaults to YES

@end

NS_ASSUME_NONNULL_END
