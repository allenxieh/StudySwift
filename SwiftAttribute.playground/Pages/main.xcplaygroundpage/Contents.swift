//: [Previous](@previous)
/*:
 # @main @UIApplicationMain
 - - -
 1. 这两个注解都可以作为程序顶级入口点([top-level entry point](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID352))
 2. 除此以外, main.swift也可作为顶级入口点
 3. 只能有一个入口, 否则编译报错
 4. 在 swift 5.3 之前使用 `main.swift` 和 `@UIApplicationMain` 作为入口, iOS 14 中引入的 `SwiftUI` 后, 生命周期都使用 `@main` 作为入口
 - - -
 ## main.swift
 
     UIApplicationMain(
         CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self)
     )
 
 ## @main
 1. 用于修饰实现了 `main()` 函数的类或结构体
 2. 用于修饰遵守了 `UIApplicationDelegate` 协议的类, 如果该类没有实现 `main()` 函数, 则默认生成以下代码
 
         static func main() -> Void {
             UIApplicationMain(
                 CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self)
             )
         }
 
 3. 启动 app 时, 通过 main 入口调用 `main()` 方法 swift 5.3 之前使用 @UIApplicationMain 作为入口
 */
/*:
 ![图片](main.png)
 ![图片](main1.png)
 ![图片](main2.png)
 */
/*:
 - - -
 ## `@UIApplicationMain`
 1. 用于修饰遵守了 `UIApplicationDelegate` 协议的类
 2. 仅作为入口标记, 不生成 `main()` 函数, 直接生成 Top-Level Code `UIApplicationMain(::::)`
 */
/*:
 ![图片](main3.png)
 ![图片](main4.png)
 */
/*:
 ## 总结: `@main` 适用性更广, 没有特殊需求时, `@main` 和 `@UIApplicationMain` 都可以直接用来修饰 `AppDelgate`; 如果有自定义 `AppDelegate` 或 `UIApplication` 需求时, 只能使用 `@main`
 */
//: [Next](@next)
