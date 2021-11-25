//
//  ViewController.swift
//  UIKitDemo
//
//  Created by WENBO on 2021/11/18.
//

/*
 1、UITableView
 2、UIButton
 3、UINavigationBarAppearance
 4、UIImage
 */

import UIKit

class ViewController: UIViewController {
    
    var addToCartButton: UIButton!
    var button: UIButton?
    
    // MARK: - Indicating a configuration needs an update
    private var itemQuantityDescription: String? {
        didSet {
            guard let addToCartButton = addToCartButton else {
                return
            }
            addToCartButton.setNeedsUpdateConfiguration()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//                testTableView()
        
                testButton()
        //        createButton1()
        //        createButton2()
        //        createButton3()
        //         createButton4()
//        createButton5()
        
        //        testNavigationBar()
        
        //        testSFSymbol()
    }
    
    // MARK: - ## UITableView ##
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
    
    // MARK: - ## UIButton ##
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
        // 使用sfsymbol
        config.image = UIImage(systemName: "cart.badge.plus")
        // 图片位置
        config.imagePlacement = .trailing
        // 按钮大小
        config.buttonSize = .large
        // 圆角样式
        config.cornerStyle = .capsule
        
        let addToCartButton = UIButton(configuration: config)
        addToCartButton.center = self.view.center
        self.view.addSubview(addToCartButton)
    }
    
    // MARK: - Customing a button configuration
    func createButton1() {
        // Create the Add to Cart button
        var config = UIButton.Configuration.tinted()
        config.title = "Add to Cart"
        config.image = UIImage(systemName: "cart.badge.plus")
        config.imagePlacement = .trailing
        
        addToCartButton = UIButton(configuration: config,
                                   primaryAction: nil)
        addToCartButton.center = self.view.center
        self.view.addSubview(addToCartButton)
    }
    
    // MARK: - Customing a button with a configuration update handler
    func createButton2() {
        // Customize image and subtitle with a configurationUpdateHandler
        var config = UIButton.Configuration.tinted()
        config.title = "Add to Cart"
        config.image = UIImage(systemName: "cart.badge.plus")
        config.imagePlacement = .trailing
        
        addToCartButton = UIButton(configuration: config,
                                   primaryAction: nil)
        addToCartButton.center = self.view.center
        self.view.addSubview(addToCartButton)
        
        // 调用setNeedsUpdateConfiguration，触发configurationUpdateHandler
        addToCartButton.configurationUpdateHandler = {
            button in
            
            var config = button.configuration
            config?.image = button.isHighlighted
            ? UIImage(systemName: "cart.fill.badge.plus")
            : UIImage(systemName: "cart.badge.plus")
            config?.subtitle = self.itemQuantityDescription
            button.configuration = config
        }
        
        self.itemQuantityDescription = "subTitle"
    }
    
    // MARK: - A completely customized button
    func createButton3() {
        // Configure the button background
        
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.image = UIImage(systemName: "cart.fill")
        config.title = "Checkout"
        config.background.backgroundColor = .orange
        
        let checkoutButton = UIButton(configuration: config,
                                      primaryAction: nil)
        checkoutButton.configurationUpdateHandler = {
            [unowned self] button in
            
            var config = button.configuration
            // 显示加载菊花
            config?.showsActivityIndicator = true
            button.configuration = config
        }
        checkoutButton.center = self.view.center
        self.view.addSubview(checkoutButton)
    }
    
    // MARK: - Creating a toggle button
    func createButton4() {
        // Toggle button
        
        // UIAction setup
        let stockToggleAction = UIAction(title: "In Stock Only") { [unowned self] _ in
            self.toggleStock()
        }
        
        // The button
        let button = UIButton(primaryAction: stockToggleAction)
        button.changesSelectionAsPrimaryAction = true
        // Initial state
        button.isSelected = false
        button.center = self.view.center
        button.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        self.view.addSubview(button)
    }
    
    func toggleStock() {
        
    }
    
    // MARK: - Creating a pop-up button
    func createButton5() {
        // Pop-up button
        
        let colorClosure = { [unowned self] (action: UIAction) in
            self.updateColor(action.title)
        }
        
        let button = UIButton(primaryAction: nil)
        
        button.menu = UIMenu(children: [
            UIAction(title: "Bondi Blue", handler: colorClosure),
            UIAction(title: "Flower Power", state: .on, handler: colorClosure)
        ])
        
        button.showsMenuAsPrimaryAction = true
        
        button.changesSelectionAsPrimaryAction = true
        
        // Update to the currently set one
        updateColor(button.menu?.selectedElements.first?.title)
        
        // Update the selection
        (button.menu?.children[0] as? UIAction)?.state = .on
        
        button.center = self.view.center
        button.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        self.view.addSubview(button)
        self.button = button
    }
    
    func updateColor(_ title: String?) {
        guard let title = title else {
            return
        }
        button?.setTitle(title, for: .normal)
    }
    
    // MARK: - ## UIImage ##
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
    
    // MARK: ## UINavigationBarAppearance ##
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
    
    // MARK: - Using a hierarchical color symbol
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

