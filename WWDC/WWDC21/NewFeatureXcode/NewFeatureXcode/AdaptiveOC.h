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
#import <availability.h>
#import <Foundation/NSObjCRuntime.h>

// MARK: - AFNetworking
// [AFNetworking](https://github.com/AFNetworking/AFNetworking)适配方案
#if ((__IPHONE_OS_VERSION_MAX_ALLOWED && __IPHONE_OS_VERSION_MAX_ALLOWED < 100000) || (__MAC_OS_VERSION_MAX_ALLOWED && __MAC_OS_VERSION_MAX_ALLOWED < 101200) ||(__WATCH_OS_MAX_VERSION_ALLOWED && __WATCH_OS_MAX_VERSION_ALLOWED < 30000) ||(__TV_OS_MAX_VERSION_ALLOWED && __TV_OS_MAX_VERSION_ALLOWED < 100000))
    #define AF_CAN_INCLUDE_SESSION_TASK_METRICS 0
#else
    #define AF_CAN_INCLUDE_SESSION_TASK_METRICS 1
#endif

/*
 #if AF_CAN_INCLUDE_SESSION_TASK_METRICS
 @property (nonatomic, strong) NSURLSessionTaskMetrics *sessionTaskMetrics AF_API_AVAILABLE(ios(10), macosx(10.12), watchos(3), tvos(10));
 #endif
 */

NS_ASSUME_NONNULL_BEGIN

// MARK: - QMUI_iOS
// [QMUI_iOS](https://github.com/Tencent/QMUI_iOS)适配方案
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000
/// 当前编译使用的 Base SDK 版本为 iOS 14.0 及以上
#define IOS14_SDK_ALLOWED YES
#endif
/*
 + (BOOL)isMac {
 #ifdef IOS14_SDK_ALLOWED
     if (@available(iOS 14.0, *)) {
         return [NSProcessInfo processInfo].isiOSAppOnMac || [NSProcessInfo processInfo].isMacCatalystApp;
     }
 #endif
     if (@available(iOS 13.0, *)) {
         return [NSProcessInfo processInfo].isMacCatalystApp;
     }
     return NO;
 }
 */

// MARK: - 类引入时版本
API_AVAILABLE(ios(2.0)) @interface AdaptiveOC : NSObject

// MARK: - 标记方法不可用
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init __attribute__((unavailable("你不要用 -init")));

// MARK: - API引入版本
#ifdef __IPHONE_15_0
@property (nonatomic, strong) UINavigationBarAppearance *km_transitionBarAppearance API_AVAILABLE(ios(15.0));
#endif

// MARK: - API启用，iOS7.0引入，11.0废弃
@property(nonatomic,assign) BOOL automaticallyAdjustsScrollViewInsets API_DEPRECATED("Use UIScrollView's contentInsetAdjustmentBehavior instead", ios(7.0,11.0), tvos(7.0,11.0)); // Defaults to YES

- (void)oldMethod API_DEPRECATED("方法弃用", ios(2.0,6.0));
- (void)oldMethod1 __attribute__((availability(ios,introduced=2_0,deprecated=7_0,obsoleted=13_0,message="用 -newMethod 这个方法替代 ")));

@end

NS_ASSUME_NONNULL_END
