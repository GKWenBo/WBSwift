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

#### 异步并发async/await

callback的劣势

##### 回调地狱

```swift
func processNews1(
  url: URL, 
  completionHandler: (_ article: Article) -> Void) {
  downloadArticle(url) { article in
    saveToDatabase(article) { article in
      completionHandler(article)
    }
  })
})
```

##### 捉襟见肘的错误处理

```swift
func processNews2(
  url: URL, 
  completionHandler: (_ article: Article?, _ error: Error?) -> Void) {
  downloadArticle(url) { article, error in
    guard let article = article else {
      completionHandler(nil, error)
      return
    }
    
    saveToDatabase(article) { article, error in
      guard let article = article else {
        completionHandler(nil, error)
        return
      }
      
      completionHandler(article)
    }
  })
})
```

这次，我们假设 callback 都接受两个参数，分别是正常情况下的 `Article` 以及表达错误的 `Error`。为了在进入下一个异步环节之前确保结果正常，我们就得在每一个 callback 里用 `guard let` 先确认下结果。显然，如果你是 Swift `guard` 机制的设计者，你也不会满意这样的用法。

除了 `guard` 之外，Swift 中另外一个和错误处理有关的设施是异常，并且，Swift 还特别为了处理异步方法中的错误定义了 `Result` 类型。但它们在我们例子中的表现，却并不理想：

```swift
func processNews3(
  url: URL,
  completionHandler: (Result<Article, Error>) -> Void) {
  do {
    downloadArticle(url) { result in
      do {
        let article = try result.get()
        saveToDatabase(article) { result
          do {
            let article = try result.get()
            completionHandler(.success(article))
          }
          catch {
            completionHandler(.failure(error))
          }
        }
      }
      catch {
        completionHandler(.failure(error))
      }
    }
  }
  catch {
    completionHandler(.failure(error))
  }
}
```

当然，我们也可以用 `switch...case...` 来处理每个 callback 中的 `result`：

```swift
saveToDatabase(article) { result
  switch result {
    case .success(let article):
      completionHandler(.success(article))
    case .failure(let error):
      completionHandler(.failure(error))
  }
}
```

##### 有条件地执行异步代码

```swift
func loadNews(
  url: URL,
  completionHandler: (Result<Article, Error>) -> Void) {
  let swizzle: (_ article: Article) -> Void = {
    // Switch placeholder to article
  }
  
  if cache[url] != nil {
    swizzle(cache[url]!)
  }
  else {
    processNews3(url: url) { result in
      do {
        let article = result.get()
        swizzle(article)
      }
      catch {
        print(error)
      }
    }
  }
}
```

##### 硬伤之外的小毛病

除了上面这些比较严重的硬伤之外，使用回调函数的时候还容易在结构复杂之后犯一些难以察觉的错误。例如之前 `processNews2` 的实现，就可能在调用 `completionHandler` 之后，忘了使用 `return` 语句：

```swift
func processNews4a(
  url: URL, 
  completionHandler: (_ article: Article?, _ error: Error?) -> Void) {
  downloadArticle(url) { article, error in
    guard let article = article else {
      completionHandler(nil, error)
      /// Forget `return`
    }
    
    saveToDatabase(article) { article, error in
      guard let article = article else {
        completionHandler(nil, error)
        /// Forget `return`
      }
      
      completionHandler(article)
    }
  })
})
```

或者，直接 `return` 忘了调用 `completionHandler`：

```swift
func processNews4b(
  url: URL, 
  completionHandler: (_ article: Article?, _ error: Error?) -> Void) {
  downloadArticle(url) { article, error in
    guard let article = article else {
      /// Forget `completionHandler(nil, error)`
      return
    }
    
    saveToDatabase(article) { article, error in
      guard let article = article else {
        /// Forget `completionHandler(nil, error)`
        return
      }
      
      completionHandler(article)
    }
  })
})
```

##### 那些函数可以定义成异步的

第一个问题是**究竟哪些有函数性质的元素可以被标记为 `async` 呢？**。毫无疑问，全局函数是可以的，刚才我们已经试过了。第二类可以标记为 `async` 的，是自定义类型的 `init` 或者普通方法，例如，我们把刚才的代码改成这样：

```swift
struct Dinner {
  init() async {
    print("Plan the menu.")
  }

  func chopVegetable() async {
    print("Chopping vegetables")
  }
}
```

##### 定义可以抛出异常的异步函数

对于一个异步函数来说，相比同步函数，它有更大的概率会发生错误。那么，我们的第二问题就是：该如何定义既异步执行，又可能抛出异常的函数呢？虽然 `async` 和 `throws` 并无优先级的区别，Swift 要求我们 **`async` 必须写在 `throws` 前面**，例如这样：

```swift
struct Dinner {
  func chopVegetable() async {
    print("Chopping vegetables")
  }

  func marinateMeat() async throws {
    print("Marinate meat")
  }
}
```

但是，提前说一句，对于 `async throws` 的函数，调用的时候，**`try/try?/try!` 必须在 `await` 的前面**：

```swift
await dinner.chopVegetable()
try await dinner.marinateMeat()
print("Dinner is served.")
```

##### 异步 init 方法在继承关系中的用法

第三个问题，和派生类有关。如果派生类的 `init` 方法是异步的，它还会自动调用基类的同步 `init` 方法么？

答案是：会。但条件有二：

- 条件一，在异步 `init` 方法里，我们没有自己调用基类的 `init` 方法；
- 条件二，基类存在默认的，同步的 designated initializer；

```swift
class Tableware {
  var color: String
  var shape: String

  init(color: String = "white", shape: String = "round") {
    self.color = color
    self.shape = shape
    print("Prepare tableware: Color:\(color), Shape:\(shape)")
  }
}

class Dish: Tableware {
  init() async {
    print("Disinfection the dish before use.")
  }
}
```

##### `async` 对函数重载的影响

我们给 `Dinner` 添加了两个预热烤箱的方法，一个是基于回调函数的，一个是异步的。由于它们都有默认参数，对于 `preheatOven()` 这样的表达式，Swift 应该调用哪个呢？

聪明的你可能会说，有 `await` 就调用异步的，否则就调用同步的呗。对于这个解释，你至多只能得 50 分：

- 一方面，在后面的内容中我们就会看到，调用异步函数不一定要在每一个异步函数前面使用 `await`，因此它不足以作为函数调用判断的依据；
- 另一方面，在有 `async` 之前，Swift 对重载函数的选择标准是优先选择参数少的。因此，在上面的例子中，异步的函数看起来才是正确的选择。但默认选择异步的版本会带来源代码兼容性问题，毕竟在有 `async` 之前，编译器默认选择的都是同步的函数；

为此，Swift 采取了更加精致的策略，编译器会判断调用函数时的上下文环境。在同步环境中选择同步的版本，异步的环境中选择异步的版本。因此，在我们的异步 `main` 函数中，默认就会调用异步的版本。

```swift
struct Dinner {
  func preheatOven(_ completionHandler: (() -> Void)? = nil) {
    print("Preheat oven with completion handler.")
  }

  func preheatOven() async {
    print("Preheat oven asynchronously.")
  }
}
```

##### 和 `async` 相关的类型转换

关于异步函数的第五个问题：两个函数类型，如果它们的区别只是 `async`，这两个类型的变量之间可以互相赋值么？其实，这个问题的答案，和 `throws` 有些类似：同步可以向异步转换，反之则不行。

```swift
struct FunctionTypes {
  var syncNonThrowing: () -> Void
  var syncThrowing: () throws -> Void
  var asyncNonThrowing: () async -> Void
  var asyncThrowing: () async throws -> Void
  
  mutating func demonstrateConversions() {
    // Okay to add 'async' and/or 'throws'    
    asyncNonThrowing = syncNonThrowing
    asyncThrowing = syncThrowing
    syncThrowing = syncNonThrowing
    asyncThrowing = asyncNonThrowing
    
    // Error to remove 'async' or 'throws'
    syncNonThrowing = asyncNonThrowing // error
    syncThrowing = asyncThrowing       // error
    syncNonThrowing = syncThrowing     // error
    asyncNonThrowing = syncThrowing    // error
  }
}
```

##### 协议中的 `async` 约束

和 `async` 函数有关的最后一个问题，是 Swift 协议中的 `async` 约束。简单用一句话总结就是：如果约束中带有 `async`，那么这个约束可以由同步或异步函数实现。否则，就只能由同步方式实现。例如：

```swift
protocol Cook {
  func chopVegetable() async
  func marinateMeat() async
  func preheatOven() async
  func serve() // Can only be satisfied by a synchronous function
}
```

##### async 关键字对 Closure 用法的影响

```swift
func cook(_ process: () async -> Void) async {
  await process()
}
```

然后，调用的时候，我们就可以这样：

```swift
await dinner.cook { () async -> Void in
  await dinner.chopVegetable()
  try? await dinner.marinateMeat()
  await dinner.preheatOven()
}
```

或者这样：

```swift
await dinner.cook {
  await dinner.chopVegetable()
  try? await dinner.marinateMeat()
  await dinner.preheatOven()
}
```

当我们要显式定义一个 `async` closure 的时候，可以像这样：

```swift
{ () async -> Void in 
  // asynchronous closure
}
```

实际上，`cook` 的调用还有第三种方法，像这样：

```swift
func myCook() async {
  print("My own cooking approach.")
}

await dinner.cook(myCook)
```

#### @globalActor

#### @MainActor

#### Task Local Value