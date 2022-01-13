//: [Previous](@previous)
/*:
 # @propertyWrapper
 - - -
 Apply this attribute to a class, structure, or enumeration declaration to use that type as a property wrapper. When you apply this attribute to a type, you create a custom attribute with the same name as the type. Apply that new attribute to a property of a class, structure, or enumeration to wrap access to the property through an instance of the wrapper type; apply the attribute to a local stored variable declaration to wrap access to the variable the same way. Computed variables, global variables, and constants can’t use property wrappers.
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
