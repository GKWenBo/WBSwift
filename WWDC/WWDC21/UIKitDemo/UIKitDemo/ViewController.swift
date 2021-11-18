//
//  ViewController.swift
//  UIKitDemo
//
//  Created by WENBO on 2021/11/18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        testTableView()
        
//        testButton()
        
        testNavigationBar()
        
        testSFSymbol()
    }

    // MARK: - UITableView
    func testTableView() {
        let tableView = UITableView(frame: self.view.bounds)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0;
        } else {
            
        }
        self.view.addSubview(tableView)
        
        /// 在APP启动全局设置
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        } else {
            /// fall back
        }
    }
    
    // MARK: - Creating a button With Button
    func testButton() {
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
        var config = UIButton.Configuration.filled()
        config.title = "Add to Cart"
        config.image = UIImage(systemName: "cart.badge.plus")
        config.imagePlacement = .trailing
        config.buttonSize = .large
        config.cornerStyle = .capsule

        let addToCartButton = UIButton(configuration: config)
        addToCartButton.center = self.view.center
        self.view.addSubview(addToCartButton)
    }
    
    // MARK: - UIImage
    /*
     /// Asynchronously prepares this image for displaying on the specified screen.
     ///
     /// The completion handler will be invoked on a private queue. Be sure to return to the main queue before assigning the prepared image to an image view.
     ///
     /// @param completionHandler A block to invoke with the prepared image. If preparation failed (for example, beacuse the image data is corrupt), @c image will be nil.
     ///
     /// @note The prepared UIImage is not related to the original image. If the properties of the screen (such as its resolution or color gamut) change, or if the image is displayed on a different screen that the one it was prepared for, it may not render correctly.
     @available(iOS 15.0, *)
     open func byPreparingForDisplay() async -> UIImage?

     @available(iOS 15.0, *)
     open func preparingThumbnail(of size: CGSize) -> UIImage?

     @available(iOS 15.0, *)
     open func prepareThumbnail(of size: CGSize, completionHandler: @escaping (UIImage?) -> Void)

     @available(iOS 15.0, *)
     open func byPreparingThumbnail(ofSize size: CGSize) async -> UIImage?
     */
    func testImage() {
        let pathToImage = "pathToImage"
        let imageView = UIImageView()
        if let image = UIImage(contentsOfFile: pathToImage) {
            Task {
                let preparedImage = await image.byPreparingForDisplay()
                imageView.image = preparedImage
            }
        }

        let pathToBigImage = "pathToBigImage"
        let smallSize = CGSize(width: 20, height: 20)
        if let bigImage = UIImage(contentsOfFile: pathToBigImage) {
            Task {
                /// Prepare the thumbnail asynchronously
                let smallImage = await bigImage.byPreparingThumbnail(ofSize: smallSize)
                imageView.image = smallImage
            }
        }
    }

    // MARK: UINavigationBarAppearance
    func testNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = nil
        appearance.backgroundColor = .orange

        /*
         /// Describes the appearance attributes for the tabBar to use when an observable scroll view is scrolled to the bottom. If not set, standardAppearance will be used instead.
         @available(iOS 15.0, *)
         @NSCopying open var scrollEdgeAppearance: UITabBarAppearance?
         */
        if #available(iOS 15.0, *) {
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    func testSFSymbol() {
        /// Using a hierarchical color symbol
        let configuration = UIImage.SymbolConfiguration(hierarchicalColor: .systemOrange)

        // message.circle.fill
        // sun.max.circle.fill
        let image = UIImage(systemName: "message.circle.fill", withConfiguration: configuration)
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = self.view.center
        self.view.addSubview(imageView)
    }
    
}

