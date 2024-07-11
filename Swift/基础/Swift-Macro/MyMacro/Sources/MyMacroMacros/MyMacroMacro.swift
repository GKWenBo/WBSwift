import SwiftCompilerPlugin
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")
public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "(\(argument), \(literal: argument.description))"
    }
}

public struct CaseDetectionMacro: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
            of node: AttributeSyntax,
            providingMembersOf declaration: Declaration,
            in context: Context
        ) throws -> [DeclSyntax] {
            var names: [String] = []
            for member in declaration.memberBlock.members { // 循环获取所有属性、方法
                let elements = member.decl.as(EnumCaseDeclSyntax.self)?.elements
                if let propertyName = elements?.first?.name.description {
                    names.append(propertyName) // 取出枚举名
                }
            }
            
            return names.map { // 拼接实现代码
                """
                var \("is" + capitalized($0)): Bool {
                    if case .\($0) = self { true }
                    else { false }
                }
                """
            }.map {
                DeclSyntax(stringLiteral: $0)
            }
        }
        
        /// 首字母大写
        private static func capitalized(_ str: String) -> String {
            var str = str
            let firstChar = String(str.prefix(1)).uppercased()
            str.replaceSubrange(...str.startIndex, with: firstChar)
            return str
        }
}

public struct URLMacro: ExpressionMacro {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, 
                                 in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        let content = node.argumentList.first?.expression.as(StringLiteralExprSyntax.self)?.segments.first?.description ?? ""
        guard let _ = URL(string: content) else {
            fatalError("can't create url!")
        }
        return "URL(string: \"\(raw: content)\")!"
    }
    
    
}

@main
struct MyMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        CaseDetectionMacro.self,
        URLMacro.self
    ]
}
