import Foundation
import UIKit

@_functionBuilder
public struct ExpressionBuilder {

    public static func buildBlock(_ arguments: ValidExpressionArgument...) -> Expression {

        var expressionElements = [Expression.Element]()

        for arg in arguments {
            expressionElements = expressionElements + arg.expressionElements
        }

        return Expression(with: expressionElements)
    }
}

public protocol ValidExpressionArgument {
    var expressionElements: [Expression.Element] { get }
}

extension Int: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.number(Double(self)))]
    }
}

extension UInt: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.number(Double(self)))]
    }
}

extension Double: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.number(Double(self)))]
    }
}

extension String: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.string(self))]
    }
}

extension Bool: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.boolean(self))]
    }
}

extension Array: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        if let self = self as? [Double] {
            return [.argument(.array(self))]
        } else if let self = self as? [String] {
            return [.argument(.stringArray(self))]
        }
        return []
    }
}

extension Expression.Element: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [self]
    }
}

extension Expression: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(.expression(self))]
    }
}

extension Expression.Argument: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.argument(self)]
    }
}

extension Expression.Operator: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        return [.op(self)]
    }
}

extension Dictionary: ValidExpressionArgument where Key: ValidExpressionArgument,
                                                    Value: ValidExpressionArgument {
    public var expressionElements: [Expression.Element] {
        var elements = [Expression.Element]()
        for (key, value) in self {
            elements = elements + key.expressionElements + value.expressionElements
        }
        return elements
    }
}
