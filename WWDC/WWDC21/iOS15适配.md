## iOS15适配

### API适配技巧

- @available可用于修饰类，协议，方法，属性，表明这些类型适用的平台和操作系统

  ```objective-c
  /// OC
  if (@available(iOS 15.0, *)) {
  
  } else {
    /// fallback statements 
  }
  
  /// Swift
  if #available(iOS 15.0, *) {
    
  } else {
    /// fallback statements 
  }
  ```

  缺点：高版本API无法在低版本Xcode上编译通过，如果不考虑不同版本适配问题，推荐这种适配方式

- 通过判断系统版本决定使用API

  ```swift
  if Float(UIDevice.current.systemVersion)! > 15.0 {
      /// call api
  } else {
      /// call low api
  }
  ```

- 通过是否能响应某个方法适配API

  ```objective-c
  if ([self respondsToSelector:@selector(aSelector)]) {
          /// call method
   }
  ```

  缺点：高版本API无法在低版本Xcode上编译通过

- 条件编译+系统版本判断

  ```objective-c
  #ifdef __IPHONE_15_0
  @property (nonatomic, strong) UINavigationBarAppearance *km_transitionBarAppearance API_AVAILABLE(ios(15.0));
  #endif
  
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
  ```

  通过条件编译适配方式，能兼容不同版本Xcode编译，可以结合@available使用

- [AFNetworking](https://github.com/AFNetworking/AFNetworking)适配方案

  ```objective-c
  #if ((__IPHONE_OS_VERSION_MAX_ALLOWED && __IPHONE_OS_VERSION_MAX_ALLOWED < 100000) || (__MAC_OS_VERSION_MAX_ALLOWED && __MAC_OS_VERSION_MAX_ALLOWED < 101200) ||(__WATCH_OS_MAX_VERSION_ALLOWED && __WATCH_OS_MAX_VERSION_ALLOWED < 30000) ||(__TV_OS_MAX_VERSION_ALLOWED && __TV_OS_MAX_VERSION_ALLOWED < 100000))
      #define AF_CAN_INCLUDE_SESSION_TASK_METRICS 0
  #else
      #define AF_CAN_INCLUDE_SESSION_TASK_METRICS 1
  #endif
  ```

  - [QMUI_iOS](https://github.com/Tencent/QMUI_iOS)适配方案

    ```objective-c
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000
    /// 当前编译使用的 Base SDK 版本为 iOS 14.0 及以上
    #define IOS14_SDK_ALLOWED YES
    #endif
    ```

### 一、UIKit新特性

#### 表格头部间距

```swift
/*
 /// Padding above each section header. The default value is `UITableViewAutomaticDimension`.
 @available(iOS 15.0, *)
 open var sectionHeaderTopPadding: CGFloat
 */
if #available(iOS 15.0, *) {
    let tableView = UITableView()
    tableView.sectionHeaderTopPadding = 0
}

/// 在APP启动全局设置
if #available(iOS 15.0, *) {
    UITableView.appearance().sectionHeaderTopPadding = 0
}
```

#### UITableView编辑状态图标点击颜色改变

```objective-c
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.editing) {
        if (@available(iOS 15.0, *)) {
            [self addEditButtons];
        }
    }
}

- (void)addEditButtons
{
    for (UIView *view in self.subviews) {
        if ([NSStringFromClass([view class]) rangeOfString:@"EditControl"].location != NSNotFound) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:[UIImageView class]]) {
                    [subview removeFromSuperview];
                }
            }
        } else if ([NSStringFromClass([view class]) rangeOfString:@"ReorderControl"].location != NSNotFound) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:[UIImageView class]]) {
                    ((UIImageView *)subview).image = [SWImageCache imageNamed:@"citymanagement_move_icon"];
                    subview.frame = CGRectMake(0, 0, 26, 18);
                    subview.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
                }
            }
        }
    }
}
```

#### 导航栏、标签栏样式适配

```swift
let tabBar = UITabBar()

let appearance = UITabBarAppearance()
appearance.backgroundEffect = nil
appearance.backgroundColor = .orange

/*
 /// Describes the appearance attributes for the tabBar to use when an observable scroll view is scrolled to the bottom. If not set, standardAppearance will be used instead.
 @available(iOS 15.0, *)
 @NSCopying open var scrollEdgeAppearance: UITabBarAppearance?
 */
if #available(iOS 15.0, *) {
    tabBar.scrollEdgeAppearance = appearance
}

let scrollView = UIScrollView()
let controller = UIViewController()
controller.setContentScrollView(scrollView)
```

#### Creating a button With Button.Configuration

```swift
/*
 .plain()
 .tinted()
 .gray()
 .filled()
 .borderless()
 .bordered()
 .borderedTinted()
 .borderedProminent()
 */
var config = UIButton.Configuration.tinted()
config.title = "Add to Cart"
config.image = UIImage(systemName: "cart.badge.plus")
config.imagePlacement = .trailing
config.buttonSize = .large
config.cornerStyle = .capsule

let addToCartButton = UIButton(configuration: config)
```

#### Using hierarchical color symbol

```swift
/// Using a hierarchical color symbol
let configuration = UIImage.SymbolConfiguration(hierarchicalColor: .systemOrange)

let image = UIImage(systemName: "sun.max.circle.fill", withConfiguration: configuration)
```

#### Image display preparation

```swift
if let image = UIImage(contentsOfFile: pathToImage) {
    /// Prepare the thumbnail asynchronously
    Task {
        let preparedImage = await image.byPreparingForDisplay()
        imageView.image = preparedImage
    }
}
```

#### Image thumbnailing

```swift
if let bigImage = UIImage(contentsOfFile: pathToBigImage) {
    Task {
        let smallImage = await bigImage.byPreparingThumbnail(ofSize: smallSize)
        imageView.image = smallImage
    }
}
```

### 二、Foundation新特性

#### AttributedString

### 三、Xcode新特性

#### 界面

> Xcode 13 重新设计了 Project Navigator，各种不同的文件类型使用了符号化的图标。默认情况下，文件扩展名是隐藏的。

#### 适配新的building system

升级到Xcode13后，编译工程报“Building for iOS Simulator, but the linked and embedded framework '***' was built for iOS + tvOS Simulator”

需修改Xcode配置TARGETS->Build Settings->Validate Workspace改为YES

Validate Workspace作用是：

```
If enabled, perform validation checks on the workspace configuration as part of the build process.

如果开启了（设置为Yes），那么在构建版本的过程中将对工作区配置进行验证检查。
```

#### Xcode Cloud

> Xcode Cloud 是对于团队协作是一项重要的补充特性，它允许持续集成和交付，跨越多种设备类型进行并行测试，还能自动推送 App 到 TestFlight，使得测试人员获取最新版本的项目构建更加便捷。

#### 源码编辑器

- 自动导入
- 解包语句自动补全
- 更深路径的自动补全
- Switch case自动补全
- 数组遍历语句自动补全
- 列断点
- Vim 模式

#### 版本控制改进

#### 用 DocC 创建自定义文档

#### Optimize Object LifeTimes

优化内存管理配置

### 四、Swift新特性

[Swift Compiler Driver](https://github.com/apple/swift-driver)

[swift-system](https://github.com/apple/swift-system)

[swift-collections](https://github.com/apple/swift-collections)

> **Swift Collections**是 Swift 编程语言的数据结构实现的开源包。
>
> [在 swift.org 上](https://swift.org/blog/swift-collections)的[公告中](https://swift.org/blog/swift-collections)阅读有关该软件包及其背后意图的更多信息。

[swift-algorithms](https://github.com/apple/swift-algorithms)

> **Swift Algorithms**是序列和集合算法及其相关类型的开源包。
>
> [在 swift.org 上](https://swift.org/blog/swift-algorithms/)的[公告中](https://swift.org/blog/swift-algorithms/)阅读有关该软件包及其背后意图的更多信息。

#### 异步并发