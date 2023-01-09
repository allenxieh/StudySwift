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

struct SpacingPrint: Printable {
    func say() -> String {
        return " "
    }
}

struct SkrPrint: Printable {
    func say() -> String {
        return "skr"
    }
}

struct EmptyPrint: Printable {
    func say() -> String {
        return ""
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

struct Paragraph: Printable {
    var elements: [Printable]
    func say() -> String {
        return elements.map {
            $0.say()
        }.joined(separator: "\n")
    }
}

@resultBuilder
struct LineBuilder {
    static func buildBlock(_ elements: Printable...) -> Printable {
        return Line(elements: elements)
    }
    static func buildArray(_ components: [Printable]) -> Printable {
        return Line(elements: components)
    }
}

@resultBuilder
struct ParagraphBuilder {
    static func buildOptional(_ component: Printable?) -> Printable {
        guard let component = component else { return EmptyPrint() }
        return component
    }
    static func buildBlock(_ elements: Printable...) -> Printable {
        var component = [Printable]()
        for element in elements {
            if element is EmptyPrint {
                
            } else {
                component.append(element)
            }
        }
        return Paragraph(elements: component)
    }
    static func buildEither(first component: Printable) -> Printable {
        return component
    }
    static func buildEither(second component: Printable) -> Printable {
        return component
    }
    static func buildArray(_ components: [Printable]) -> Printable {
        return Paragraph(elements: components)
    }
    static func buildFinalResult(_ component: Printable) -> Printable {
        var paragraph = component as! Paragraph
        paragraph.elements.append(SkrPrint())
        return paragraph
    }
}

func line(@LineBuilder content: () -> Printable) -> Printable {
    return content()
}

@available(macOS 99, *)
func futureLine(@LineBuilder content: () -> Printable) -> Printable {
    return content()
}

func paragraph(@ParagraphBuilder content: () -> Printable) -> Printable {
    return content()
}

let a = true

let begin = paragraph {
    HelloPrint()
    StarsPrint(length: 3)
    RespectPrint(name: "张三, AKA 法外狂徒")
    for _ in 0...3 {
        HelloPrint()
    }
}

print(begin.say())
//: [Next](@next)
