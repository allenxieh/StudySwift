//: [Previous](@previous)
protocol Printable {
    func say() -> String
}

struct HelloPrint: Printable {
    func say() -> String {
        return "hello world"
    }
}

struct StarsPrint: Printable {
    var length: Int
    func say() -> String {
        return String(repeating: "*", count: length)
    }
}

struct RespectPrint: Printable {
    var name: String
    func say() -> String {
        return name+" respect"
    }
}

struct Line: Printable {
    var elements: [Printable]
    func say() -> String {
        return elements.map {
            $0.say()
        }.joined(separator: "")
    }
}

@resultBuilder
struct PrintBuilder {
    static func buildBlock(_ elements: Printable...) -> Printable {
        return Line(elements: elements)
    }
}

func start(@PrintBuilder content: () -> Printable) -> Printable {
    return content()
}

let begin = start {
    HelloPrint()
    StarsPrint(length: 3)
    RespectPrint(name: "张三, AKA 法外狂徒")
}

print(begin.say())
//: [Next](@next)
