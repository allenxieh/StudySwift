//: [Previous](@previous)
/*:
 # @resultBuilder
 - - -
 把这个特性应用给类、结构体、枚举来把对应类型作为结果建造器使用。结果建造器是一个逐步建造内嵌数据结构的类型。你可使用结果建造器来实现一个自然声明式的领域特定语言（DSL）以创建内嵌数据结构。\
 SwiftUI
 
     struct ContentView: View {
         var body: some View {
             Text("Hello World")
         }
     }
 
 - - -
 # The result-building methods are as follows:
 
    static func buildBlock(_ components: Component...) -> Component
 
 Combines an array of partial results into a single partial result. A result builder must implement this method.
 
    static func buildOptional(_ component: Component?) -> Component
 
 Builds a partial result from a partial result that can be nil. Implement this method to support if statements that don’t include an else clause.
 
    static func buildEither(first: Component) -> Component
 
 Builds a partial result whose value varies depending on some condition. Implement both this method and buildEither(second:) to support switch statements and if statements that include an else clause.
 
    static func buildEither(second: Component) -> Component
 
 Builds a partial result whose value varies depending on some condition. Implement both this method and buildEither(first:) to support switch statements and if statements that include an else clause.
 
    static func buildArray(_ components: [Component]) -> Component
 
 Builds a partial result from an array of partial results. Implement this method to support for loops.
 
    static func buildExpression(_ expression: Expression) -> Component
 
 Builds a partial result from an expression. You can implement this method to perform preprocessing—for example, converting expressions to an internal type—or to provide additional information for type inference at use sites.
 
    static func buildFinalResult(_ component: Component) -> FinalResult
 
 Builds a final result from a partial result. You can implement this method as part of a result builder that uses a different type for partial and final results, or to perform other postprocessing on a result before returning it.
 
    static func buildLimitedAvailability(_ component: Component) -> Component
 
 Builds a partial result that propagates or erases type information outside a compiler-control statement that performs an availability check. You can use this to erase type information that varies between the conditional branches.
 */
@resultBuilder
struct StringBuilder {
    // buildBlock中将多个值构建为一个结果
    static func buildBlock(_ strs: String...) -> String {
        // 以逗号拼接多个字符串
        strs.joined(separator: ",")
    }
}

@StringBuilder
func sayHello(to: String) -> String {
    "hello"
    "world"
    to
}

print(sayHello(to:"张三"))
//hello,world,张三
//: [Next](@next)
