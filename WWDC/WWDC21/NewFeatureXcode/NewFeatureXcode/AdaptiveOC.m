//
//  Adaptive.m
//  NewFeatureXcode
//
//  Created by wenbo on 2021/11/19.
//

#import "AdaptiveOC.h"
#import <objc/runtime.h>

@implementation AdaptiveOC

#ifdef __IPHONE_15_0
- (void)setKm_transitionBarAppearance:(UINavigationBarAppearance *)km_transitionBarAppearance API_AVAILABLE(ios(15.0)) {
    objc_setAssociatedObject(self, @selector(km_transitionBarAppearance), km_transitionBarAppearance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationBarAppearance *)km_transitionBarAppearance API_AVAILABLE(ios(15.0)) {
    UINavigationBarAppearance *appearance = objc_getAssociatedObject(self, @selector(km_transitionBarAppearance));
    if (!appearance) {
        appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        objc_setAssociatedObject(self, @selector(km_transitionBarAppearance), appearance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return appearance;
}
#endif

@end
