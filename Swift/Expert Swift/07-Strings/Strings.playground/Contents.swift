import UIKit

let eAcute = "\u{E9}"
let combinedEacute = "\u{65}\u{301}"

eAcute.count
combinedEacute.count

eAcute == combinedEacute

let eAcute_objc: NSString = "\u{E9}"
let combinedEacute_objc: NSString = "\u{65}\u{301}"
eAcute_objc.length
combinedEacute_objc.length

eAcute_objc == combinedEacute_objc

let acute = "\u{301}"
let smallE = "\u{65}"

acute.count
smallE.count

let combineEacute2 = smallE + acute

combineEacute2.count

let lorem = "Lo͞r̉em̗"
Array(lorem)
Array(lorem.utf8)
Array(lorem.utf16)

let flags = "🏳️🏴🏴‍☠️🏁"
Array(flags.unicodeScalars)
Array(flags.utf8)
Array(flags.utf16)
