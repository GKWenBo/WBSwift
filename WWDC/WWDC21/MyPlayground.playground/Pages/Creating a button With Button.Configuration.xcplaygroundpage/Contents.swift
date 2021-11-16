import UIKit

/*
 .plain()
 .tinted()
 .gray()
 .filled()
 .borderless()
 .bordered()
 .borderedTinted()
 .borderedProminent()
 */
var config = UIButton.Configuration.tinted()
config.title = "Add to Cart"
config.image = UIImage(systemName: "cart.badge.plus")
config.imagePlacement = .trailing
config.buttonSize = .large
config.cornerStyle = .capsule

let addToCartButton = UIButton(configuration: config)
