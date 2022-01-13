//: [Previous](@previous)
/*:
 # @objc @objcMembers @nonobjc
 - - -
 1. 告诉编译器, 这个声明在 Objective-C 代码中是可用或不可用的. 包括类, 协议, 枚举, 属性等等
 2. swift特有特性无法暴露给 Objective-C
 3. 当想在 Objective-C 中为 objc 特性标记的实体暴露一个不同的名字时, @objc 可以接受一个参数
 */
import Foundation
@objcMembers
class ExampleClass: NSObject {
    var enabled: Bool {
        @objc(isEnabled) get {
            return false
        }
    }
}
//: [Next](@next)
