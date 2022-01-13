//: [Previous](@previous)
/*:
 # @propertyWrapper
 - - -
 1. 告诉编译器, 这个声明在 Objective-C 代码中是可用或不可用的. 包括类, 协议, 枚举, 属性等等
 2. swift特有特性无法暴露给 Objective-C
 3. 当想在 Objective-C 中为 objc 特性标记的实体暴露一个不同的名字时, @objc 可以接受一个参数
 */
import UIKit
@propertyWrapper
struct RGBColorWrapper {
    private var r: CGFloat
    private var g: CGFloat
    private var b: CGFloat
    private var alpha: CGFloat
    
    var wrappedValue: UIColor { UIColor.init(red: r, green: g, blue: b, alpha: alpha) }
    
    init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1) {
        self.r = r / 255
        self.g = g / 255
        self.b = b / 255
        self.alpha = alpha
    }
}

struct Color {
    @RGBColorWrapper(255, 0, 0)
    static var redRed: UIColor
}
let color: UIColor = Color.redRed
//: [Next](@next)
