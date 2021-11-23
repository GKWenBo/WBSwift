//
//  ViewController.swift
//  FoundationDemo
//
//  Created by wenbo on 2021/11/23.
//

/*
 1、AttributedString
 2、Date to String
 3、String to Date
 4、Formatting number
 */

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        attributedStringBasics(important: true)
//        attributedStringCharacters()
//        attributedStringRuns()
//        attributedStringRuns2()
//        codableBasics()
        
        
//        formattingDates()
//         formattingDatesWithStyles()
//        formattingDatesMoreExamples()
//        formattingIntervals()
//        parsingDates()
//        parsingDatesStrategies()
        
        
//        formattingNumbers()
//        formattingNumbersWithStyles()
        formattingLists()
    }

    // MARK: - ## AttributedString ##
    
    // MARK: - AttributedString Basic
    /*
    func attributedStringBasics(important: Bool) {
        var thanks = AttributedString("Thank you!")
        thanks.font = .body.bold()

        var website = AttributedString("Please visit our website.")
        website.font = .body.italic()
        website.link = URL(string: "http://www.example.com")

        var container = AttributeContainer()
        if important {
            container.foregroundColor = .red
            container.underlineColor = .primary
        } else {
            container.foregroundColor = .primary
        }

        thanks.mergeAttributes(container)
        website.mergeAttributes(container)

        print(thanks)
        print(website)
    }
     */
    
    // MARK: - AttributedString CharaCharacters
    func attributedStringCharacters() {
        var message = AttributedString(localized: "Thank you! _Please visit our [website](http://www.example.com)._")
        let characterView = message.characters
        for i in characterView.indices where characterView[i].isPunctuation {
            message[i..<characterView.index(after: i)].foregroundColor = .orange
        }

        print(message)
    }

    // MARK: - AttributedString Runs(PartI)
    func attributedStringRuns() {
        let message = AttributedString(localized: "Thank you! _Please visit our [website](http://www.example.com)._")
        let runCount = message.runs.count
        // runCount is 4
        print(runCount)

        let firstRun = message.runs.first!
        let firstString = String(message.characters[firstRun.range])
        // firstString is "Thank you!"
        print(firstString)
    }
    
    // MARK: - AttributedString Runs(PartII)
    func attributedStringRuns2() {
        let message = AttributedString(localized: "Thank you! _Please visit our [website](http://www.example.com)._")

        let linkRunCount = message.runs[\.link].count
        // linkRunCount is 3
        print(linkRunCount)
        print(message.runs[\.link])

        var insecureLinks: [URL] = []
        for (value, range) in message.runs[\.link] {
            if let v = value, v.scheme != "https" {
                insecureLinks.append(v)
            }
        }
        // insecureLinks is [http://www.example.com]
        print(insecureLinks)
    }
    
    // MARK: - AttributedString Mutation
    /*
    func attributedStringMutation() {
        var message = AttributedString(localized: "Thank you! _Please visit our [website](http://www.example.com)._")

        if let range = message.range(of: "visit") {
            message[range].font = .body.italic().bold()
            message.characters.replaceSubrange(range, with: "surf")
        }

        print(message)
    }
     */
    
    // MARK: - Localized Strings
    func prompt(for document: String) -> String {
        String(localized: "Would you like to save the document “\(document)”?")
    }

    func attributedPrompt(for document: String) -> AttributedString {
        AttributedString(localized: "Would you like to save the document “\(document)”?")
    }
    
    // MARK: - Codable AttributedString
    struct FoodItem: Codable {
        // Placeholder type to demonstrate concept
        var name: String
    }

    struct Receipt: Codable {
        var items: [FoodItem]
        var thankYouMessage: AttributedString
    }

    func codableBasics() {
        let message = AttributedString(localized: "Thank you! _Please visit our [website](http://www.example.com)._")
        let receipt = Receipt(items: [FoodItem(name: "Juice")], thankYouMessage: message)

        let encoded = try! JSONEncoder().encode(receipt)
        let decodedReceipt = try! JSONDecoder().decode(Receipt.self, from: encoded)

        print("\(decodedReceipt.thankYouMessage)")
    }
    
    // MARK: - ## Date ##
    // MARK: - Formatting Dates
    func formattingDates() {
        // Note: This will use your current date & time plus current locale. Example output is for en_US locale.
        let date = Date.now

        let formatted = date.formatted()
        // example: "6/7/2021, 9:42 AM"
        print(formatted)

        let onlyDate = date.formatted(date: .numeric, time: .omitted)
        // example: "6/7/2021"
        print(onlyDate)

        let onlyTime = date.formatted(date: .omitted, time: .shortened)
        // example: "9:42 AM"
        print(onlyTime)
    }
    
    // MARK: - Formatting Dates With Styles
    func formattingDatesWithStyles() {
        // Note: This will use your current date & time plus current locale. Example output is for en_US locale.
        let date = Date.now

        let formatted = date.formatted(.dateTime)
        // example: "6/7/2021, 9:42 AM"
        print(formatted)
    }
    
    // MARK: - Formatting Dates - More Examples
    func formattingDatesMoreExamples() {
        // Note: This will use your current date & time plus current locale. Example output is for en_US locale.
        let date = Date.now

        let formatted = date.formatted(.dateTime.year().day().month())
        // example: "Jun 7, 2021"
        print(formatted)

        let formattedWide = date.formatted(.dateTime.year().day().month(.wide))
        // example: "June 7, 2021"
        print(formattedWide)

        let formattedWeekday = date.formatted(.dateTime.weekday(.wide))
        // example: "Monday"
        print(formattedWeekday)

        let logFormat = date.formatted(.iso8601)
        // example: "20210607T164200Z"
        print(logFormat)

        let fileNameFormat = date.formatted(.iso8601.year().month().day().dateSeparator(.dash))
        // example: "2021-06-07"
        print(fileNameFormat)
    }
    
    // MARK: - Formatting Intervals
    func formattingIntervals() {
        // Note: This will use your current date & time plus current locale. Example output is for en_US locale.
        let now = Date.now
        // Note on time calculations: This represents the absolute point in time 5000 seconds from now. For calculations that are in terms of hours, days, etc., please use Calendar API.
        let later = now + TimeInterval(5000)

        let range = (now..<later).formatted()
        // example: "6/7/21, 9:42 – 11:05 AM"
        print(range)

        let noDate = (now..<later).formatted(date: .omitted, time: .complete)
        // example: "9:42:00 AM PDT – 11:05:20 AM PDT"
        print(noDate)

        let timeDuration = (now..<later).formatted(.timeDuration)
        // example: "1:23:20"
        print(timeDuration)

        let components = (now..<later).formatted(.components(style: .wide))
        // example: "1 hour, 23 minutes, 20 seconds"
        print(components)

        let relative = later.formatted(.relative(presentation: .named, unitsStyle: .wide))
        // example: "in 1 hour"
        print(relative)
    }
    
    // MARK: - Parsing Dates
    func parsingDates() {
        let date = Date.now

        let format = Date.FormatStyle().year().day().month()
        let formatted = date.formatted(format)
        // example: "Jun 7, 2021"
        print(formatted)

        if let date = try? Date(formatted, strategy: format) {
            // example: 2021-06-07 07:00:00 +0000
            print(date)
        }
    }
    
    // MARK: - Parsing Dates - Strategies
    func parsingDatesStrategies() {
        let strategy = Date.ParseStrategy(
            format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
            timeZone: TimeZone.current)

        if let date = try? Date("2021-06-07", strategy: strategy) {
            // date is 2021-06-07 07:00:00 +0000
            print(date)
        }
    }
    
    // MARK: - ## Number ##
    // MARK: - Formatting Numbers
    func formattingNumbers() {
        // Note: This will use your current locale. Example output is for en_US locale.
        let value = 12345

        let formatted = value.formatted()
        // formatted is "12,345"
        print(formatted)
    }
    
    // MARK: - Formatting Numbers With Styles
    func formattingNumbersWithStyles() {
        // Note: This will use your current locale. Example output is for en_US locale.
        let percent = 25
        let percentFormatted = percent.formatted(.percent)
        // percentFormatted is "25%"
        print(percentFormatted)

        let scientific = 42e9
        let scientificFormatted = scientific.formatted(.number.notation(.scientific))
        // scientificFormatted is "4.2E10"
        print(scientificFormatted)

        let price = 29
        let priceFormatted = price.formatted(.currency(code: "usd"))
        // priceFormatted is "$29.00"
        print(priceFormatted)
    }
    
    // MARK: - Formatting Lists
    func formattingLists() {
        // Note: This will use your current locale. Example output is for en_US locale.
        let list = [25, 50, 75].formatted(.list(memberStyle: .percent, type: .or))
        // list is "25%, 50%, or 75%"
        print(list)
    }
}

