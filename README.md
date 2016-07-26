>* 原文链接：[Closures Capture Semantics, Part 1: Catch them all!](http://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/#fnref:in-keyword)
>* 原文作者：Olivier Halligon

#Swift Closures 捕获语义
---
定义一个Pokemon
```swift
class Pokemon: CustomDebugStringConvertible {
    let name: String
    init(name: String){
        self.name = name
    }
    deinit { print("\(self) escaped") }
    var debugDescription: String { return "<Pokemon \(name)>" }
}
```
定义一个延迟执行的function
```swift
func delay(seconds:NSTimeInterval, closure: ()->()) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue()) { 
        print("<delay>")
        closure()
    }
}
```
---
###Default capture semantics
---
这是一个简单的例子
```swift
func demo1() {
  let pokemon = Pokemon(name: "Pikachu")
  print("before closure: \(pokemon)")
  delay(1) {
    print("inside closure: \(pokemon)")
  }
  print("bye")
}
```
执行结果如下：
```java
before closure: <Pokemon Mewtwo>
bye
delay
inside closure: <Pokemon Mewtwo>
<Pokemon Mewtwo> escaped
```
可以看到demo1已经执行完成，然而pokemon并没有释放，直到1秒以后closure完成才被释放。

这是因为closure捕获了变量`pokemon`，swift编译器发现closure在内部引用了`pokemon`变量，它自动地捕获（默认强引用），因此`pokemon`的生命周期与closure一样长。

是的，closures有一点像精灵球，只要你持有closure，`pokemon`参数就会同样一直存在，然而当closure被释放，`pokemon`也会被释放。

在这个例子中，closure它在执行完GCD以后就立即释放，因此`pokemon`的`deinit`方法同时也被调用。
###Captured variables are evaluated on execution
---
还有一点要注意的是，**被捕获的变量在closure执行过程中被赋值**。我们可以说它捕获的是这个变量的引用（或指针）

所以会有这样一个很有趣的栗子：
```swift
func demo2() {
    var pokemon = Pokemon(name: "Pikachu")
    print("before closuer: \(pokemon)")
    delay(1) { 
        print("inside closure: \(pokemon)")
    }
    pokemon = Pokemon(name: "Mew")
    print("after closure: \(pokemon)")
}
```
执行结果如下：
```java
before closuer: <Pokemon Pikachu>
<Pokemon Pikachu> escaped
after closure: <Pokemon Mew>
delay
inside closure: <Pokemon Mew>
<Pokemon Mew> escaped
```
注意我们在创建了closure以后改变了`closure`，直到closure在一秒以后执行（这时我们已经离开了demo2()方法的作用域了），我们打印了新的`pokemon`，并不是旧的那个！那是因为swift默认捕获了变量的引用。

因此这里我们初始化了Pikachu的`pokemon`，然后我们改变了它的值变成了Mew，因此Pikachu释放了---因为没有变量retain它。1秒以后closure执行并且打印了被closure捕获引用的变量`pokemon`的内容。

closure没有捕获"Pikachu"（这个pokemon我们在closure创建的时候就获取到了），但是`pokemon`有另外一个引用---在执行closure时被赋值成"Mew"

看起来很奇怪的是这个对于值类型也起作用，举个`Int`的栗子：
```swift
func demo3() {
  var value = 42
  print("before closure: \(value)")
  delay(1) {
    print("inside closure: \(value)")
  }
  value = 1337
  print("after closure: \(value)")
}
```
执行结果如下：
```java
before closure: 42
after closure: 1337
delay
inside closure: 1337
```
是的，closure打印了新的`Int`的值---即使`Int`是一个值类型！---因为它捕获了变量的引用，并不是变量值本身。

###You can modify captured values in closures
注意如果被捕获的对象是`var`（不是一个`let`），你同样可以在closure内部修改这个对象。
```swift
func demo4() {
  var value = 42
  print("before closure: \(value)")
  delay(1) {
    print("inside closure 1, before change: \(value)")
    value = 1337
    print("inside closure 1, after change: \(value)")
  }
  delay(2) {
    print("inside closure 2: \(value)")
  }
}
```
执行结果如下：
```java
before closure: 42
delay
inside closure 1, before change: 42
inside closure 1, after change: 1337
delay
inside closure 2: 1337
```
因此，`value`变量在block内部已经被改变（即使它已经被捕获，但它不是一个值拷贝的捕获，而是引用相同的一个变量）。当第一个block已经被释放并且`value`变量已经离开demo4()方法的作用域了，即使在之后执行，也能从第二个block得到新的值。
###Capturing a variable as a constant copy
---
如果你想在closure创建时捕获变量当时的值，而不是在closure执行时去赋值，你可以使用**capture list**。

在closure创建时你可以使用`[localVar = varToCapture]`去捕获变量的值。看起来就像如下代码：
```swift
func demo5() {
  var value = 42
  print("before closure: \(value)")
  delay(1) { [constValue = value] in
    print("inside closure: \(constValue)")
  }
  value = 1337
  print("after closure: \(value)")
}
```
执行结果如下：
```java
before closure: 42
after closure: 1337
delay
inside closure: 42
```
与`demo3()`代码对比，注意这时候closure打印出来的，是变量在被赋成新的1337值之前的值，即使block在这个新的值之后执行。

这就是`[constValue = value]`在closure中的作用：在closure创建时捕获变量`value`的*值*---并不是变量在重新赋值以后的引用。
###Back to Pokemons
---
以上所见同样意味着这个值如果是一个引用类型---就像我们的`Pokemon`class---closure并不会真正强引用了变量，而是不知为何捕获了一个`pokemon`原始实例的拷贝：
```swift
func demo6() {
  var pokemon = Pokemon(name: "Pikachu")
  print("before closure: \(pokemon)")
  delay(1) { [pokemonCopy = pokemon] in
    print("inside closure: \(pokemonCopy)")
  }
  pokemon = Pokemon(name: "Mewtwo")
  print("after closure: \(pokemon)")
}
```
这有点像我们创建了一个中间变量指向相同的pokemon，并且捕获这个变量：
```swift
func demo6_equivalent() {
  var pokemon = Pokemon(name: "Pikachu")
  print("before closure: \(pokemon)")
  // here we create an intermediate variable to hold the instance 
  // pointed by the variable at that point in the code:
  let pokemonCopy = pokemon
  delay(1) {
    print("inside closure: \(pokemonCopy)")
  }
  pokemon = Pokemon(name: "Mewtwo")
  print("after closure: \(pokemon)")
}
```
实际上，使用capture list与上面的代码行为完全的一致，特别是在closure里的中间变量`pokemonCopy`，将只会在closure body中起作用。

与`demo6()`对比---使用了`[pokemonCopy = pokemon] in`---以及`demo2()`---并没有直接使用`pokimon`。`demo6()`输出如下：
```java
before closure: <Pokemon Pikachu>
after closure: <Pokemon Mewtwo>
<Pokemon Mewtwo> escaped
delay
inside closure: <Pokemon Pikachu>
<Pokemon Pikachu> escaped
```
看看这里发生了什么：
* Pikachu被创建了。
* 然后它作为一个拷贝被closure捕获（这里捕获了变量`pokemon`的值）。
* 因此当之后我们将`pokemon`赋值为一个新的Pokemon`Mewtwo`，然后"Pikachu"并没有*立即*释放，因为它仍然被closure引用。
* 当我们离开了`demo6()`方法的作用域，`Mewtwo`被释放，因为`pokemon`参数自身---唯一强引用它的对象---已经离开作用域。
* 之后，当closure执行，它打印了"Pikachu"因为那是被capture list在创建closure时被捕获的参数。
* 然后closure被GCD释放，因此被引用的Pikachu pokemon也被释放了。

相反的，回到`demo2()`代码上：
* "Pikachu"被创建。
* 然后closure只捕获了变量`pokemon`的引用，并没是真正的""Pikachu"的值。
* 因此当`pokemon`被赋值为新的`Mewtwo`之后，"Pikachu"不在被任何一个对象强引用，然后立即释放。
* 但是变量`pokemon`（持有`Mewtwo`的pokemon）仍然被closure强引用。
* 因此在closure一秒以后执行，pokemon打印出"Mewtwo"。
* closure一旦执行完，被GCD释放，Mewtwo的pokemon也被释放
###Mixing it all
---
这里有一个很不正常的例子，包含了赋值以及创建closure时拷贝捕获---感谢capture list---以及捕获变量引用和closure执行中赋值：
```swift
func demo7() {
    var pokemon = Pokemon(name: "Mew")
    print("Initial pokemon is \(pokemon)")
    
    delay(1) { [capturedPokemon = pokemon] in
        print("closure 1 — pokemon captured at creation time: \(capturedPokemon)")
        print("closure 1 — variable evaluated at execution time: \(pokemon)")
        pokemon = Pokemon(name: "Pikachu")
        print("closure 1 - pokemon has been now set to \(pokemon)")
    }
    
    pokemon = Pokemon(name: "Mewtwo")
    print("pokemon changed to \(pokemon)")
    
    delay(2) { [capturedPokemon = pokemon] in
        print("closure 2 — pokemon captured at creation time: \(capturedPokemon)")
        print("closure 2 — variable evaluated at execution time: \(pokemon)")
        pokemon = Pokemon(name: "Charizard")
        print("closure 2 - value has been now set to \(pokemon)")
    }
}
```
执行结果如下：
```java
Initial pokemon is <Pokemon Mew>
pokemon changed to <Pokemon Mewtwo>
delay
closure 1 — pokemon captured at creation time: <Pokemon Mew>
closure 1 — variable evaluated at execution time: <Pokemon Mewtwo>
closure 1 - pokemon has been now set to <Pokemon Pikachu>
<Pokemon Mew> escaped
delay
closure 2 — pokemon captured at creation time: <Pokemon Mewtwo>
closure 2 — variable evaluated at execution time: <Pokemon Pikachu>
<Pokemon Pikachu> escaped
closure 2 - value has been now set to <Pokemon Charizard>
<Pokemon Mewtwo> escaped
<Pokemon Charizard> escaped
```
究竟发生了什么？有一点复杂，我详细解释每一个步骤：
1.  `pokemon`被初始化为`Mew`。
2.  closure1被创建，`pokemon`的值（那时候是`Mew`）被捕获为新的变量`capturedPokemon`---被保存在closure（并且变量`pokemon`的引用也被捕获，因此`capturedPokenmon`和`pokemon`都在closure中被使用）。
3.   `pokemon`改变为`Mewtwo`。
4.   closure2被创建，`pokemon`的值（那时候是`Mewtwo`）被捕获为新的变量`capturedPokemon`---被保存在closure（并且变量`pokemon`的引用也被捕获，因此`capturedPokenmon`和`pokemon`都在closure中被使用）。
5.  现在，`demo7()`方法完成。
6.  一秒以后，GCD执行了第一个closure。
* 它打印了被第一个closure捕获的`capturedPokemon`的值`Mew`。
* 它同样改变了被捕获引用的`pokemon`，那时候仍然是`Mewtwo`
* 然后它将变量`pokemon`赋值为`Pikachu`
* 当closure结束执行，被GCD释放，没有对象再引用`Mew`，因此它销毁了。但是`Mewtwo`仍然被第二个closure的`capturedPokemon`捕获并且`Pikachu`仍然被储存在变量`pokemon`中，同样被第二个closure捕获引用。
7. 又一秒过后，GCD执行了第二个closure
* 它打印了被第二个closure捕获的`capturedPokemon`的值`Mewtwo`。
* 它同样改变了被捕获引用的`pokemon`，那时候是`Pikachu`。
* 最后，它将变量`pokemon`赋值为`Charizard`，并且`Pikachu`不再被任何对象引用，然后被销毁。
* 当closure结束执行，被GCD释放，临时变量`capturedPokemon`立即了作用域，因此`Mewtwo`被释放，并且没有对象ratain变量`pokemon`的引用，因此`Charizard`对象也被释放。
###总结
---
key point:
* swift closure在使用外部变量时，捕获一个***引用***
* 这个引用会在closure执行时被改变
* 作为一个变量的引用捕获（并不是变量的值），**你可以在closure内部修改变量的值**（如果那个变量使用`var`而不是`let`声明）
* 你也可以告诉swift在创建closure时使用一个临时变量保存捕获变量的值，而不是捕获变量的引用。你可以在括号中使用**capture lists**表达式
