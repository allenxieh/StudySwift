//: [Previous](@previous)
/*:
 # @dynamicCallable
 - - -
 Apply this attribute to a class, structure, enumeration, or protocol to treat instances of the type as callable functions. The type must implement either a `dynamicallyCall(withArguments:)` method, a `dynamicallyCall(withKeywordArguments:)` method, or both.
 */
@dynamicCallable
struct TelephoneExchange {
    func dynamicallyCall(withArguments phoneNumber: [Int]) {
        if phoneNumber == [4, 1, 1] {
            print("Get Swift help on forums.swift.org")
        } else {
            print("Unrecognized number")
        }
    }
}

let dial = TelephoneExchange()

// Use a dynamic method call.
dial(4, 1, 1)
// Prints "Get Swift help on forums.swift.org"

dial(8, 6, 7, 5, 3, 0, 9)
// Prints "Unrecognized number"

// Call the underlying method directly.
dial.dynamicallyCall(withArguments: [4, 1, 1])

@dynamicCallable
struct Repeater {
    func dynamicallyCall(withKeywordArguments pairs: KeyValuePairs<String, Int>) -> String {
        return pairs
            .map { label, count in
                repeatElement(label, count: count).joined(separator: " ")
            }
            .joined(separator: "\n")
    }
}

let repeatLabels = Repeater()
print(repeatLabels(a: 1, b: 2, c: 3, b: 2, a: 1))
//等价于 print(repeatLabels.dynamicallyCall(withKeywordArguments: ["a": 1, "b": 2, "c": 3, "b": 2, "a": 1]))
// a
// b b
// c c c
// b b
// a
/*:
 - - -
 # callAsFunction
 _ _ _
 swift 5.2 引入的语法糖
 - - -
 */
struct Adder {
    
    func callAsFunction(_ a: Int, _ b: Int) -> Int{
        return a + b
    }
    
    func callAsFunction(_ a: Float, _ b: Float) -> Float{
        return a + b
    }
    
    func callAsFunction(str1: String, str2: String, a: Int, b: Int) -> String{
        return "\(str1)+\(str2)=\(a+b)"
    }
    
}

func runTest() -> Void{
    
    let add = Adder()
    print("add: \(add(1, 2))")
    //print add: 3
    print("add: \(add(1.5, 1.5))")
    //print add: 3.0
    print("add: \(add(str1: "1", str2: "2", a: 1, b: 2))")
    //print add: 1+2=3
}

runTest()
/*:
 猫神博客[使用 protocol 和 callAsFunction 改进 Delegate](https://onevcat.com/2020/03/improve-delegate/)
 */
//: [Next](@next)

