//: [Previous](@previous)

import UIKit

/// Using a hierarchical color symbol
let configuration = UIImage.SymbolConfiguration(hierarchicalColor: .systemOrange)

let image = UIImage(systemName: "sun.max.circle.fill", withConfiguration: configuration)


let pathToImage = "pathToImage"
var imageView = UIImageView()
if let image = UIImage(contentsOfFile: pathToImage) {
    /// Prepare the thumbnail asynchronously
    Task {
        let preparedImage = await image.byPreparingForDisplay()
        imageView.image = preparedImage
    }
}

let pathToBigImage = "pathToBigImage"
let smallSize = CGSize(width: 20, height: 20)
if let bigImage = UIImage(contentsOfFile: pathToBigImage) {
    Task {
        let smallImage = await bigImage.byPreparingThumbnail(ofSize: smallSize)
        imageView.image = smallImage
    }
}

//: [Next](@next)
