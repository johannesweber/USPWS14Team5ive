// Playground - noun: a place where people can play

import UIKit

enum Example {
    case A
    case B
    case C
    case D
}


var example = Example.A


example = .B

switch example {
case .A:
    println("A")
case .B:
    println("B")                               // B
case .C:
    println("C")
case .D:
    println("D")
}

var b = Example.B


println(b.)




