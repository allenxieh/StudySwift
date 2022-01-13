/*:
 # @available
 - - -
 可用来标识计算属性、函数、类、协议、结构体、枚举等类型的生命周期\
平台:
 * iOS
 * iOSApplicationExtension
 * macOS
 * macOSApplicationExtension
 * watchOS
 * watchOSApplicationExtension
 * tvOS
 * tvOSApplicationExtension
 * swift
*/

@available(iOS 13.0, *) // 等价于@available(iOS, introduced: 13.0)
class A {
    
}
let a = A()

@available(iOS, introduced: 6.0, deprecated: 9.0, message: "deprecated message")
class B {
    
}
let b = B()

@available(iOS, introduced: 6.0, obsoleted: 9.0, message: "obsoleted message")
class C {
    
}
let c = C()

@available(*, deprecated, renamed: "testRenamed(a:)")
func test(a: Int) {
    
}

test(a: 1)

//: [Next](@next)
