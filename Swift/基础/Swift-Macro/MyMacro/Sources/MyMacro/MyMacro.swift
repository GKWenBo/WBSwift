// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "MyMacroMacros", type: "StringifyMacro")

@attached(member, names: arbitrary)
public macro CaseDetection() = #externalMacro(module: "MyMacroMacros", type: "CaseDetectionMacro")

@freestanding(expression)
public macro URL(_ value: String) -> URL = #externalMacro(module: "MyMacroMacros", type: "URLMacro")
