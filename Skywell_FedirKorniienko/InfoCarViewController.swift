//
//  InfoCarViewController.swift
//  Skywell_FedirKorniienko
//
//  Created by Fedir Korniienko on 04.06.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import UIKit

class InfoCarViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonLeftTutorialPage: UIButton!
    @IBOutlet weak var buttonRightTutorialPage: UIButton!
    
    @IBOutlet weak var labelCar: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelEngine: UILabel!
    @IBOutlet weak var labelTransmission: UILabel!
    @IBOutlet weak var labelCondition: UILabel!
    @IBOutlet weak var labelStaticCar: UILabel!
    @IBOutlet weak var labelStaticPrice: UILabel!
    
    var carData: CarData!
    var tutorialPages : [UIImageView] = []
    
    @IBAction func buttonRightTutorialPageAction(_ sender: UIButton) {
        var currentPageIndex: Int = Int(self.scrollView.contentOffset.x / self.view.frame.size.width)
        if self.scrollView.contentOffset.x.truncatingRemainder(dividingBy: self.view.frame.size.width) > 0 {
            currentPageIndex += 1
        }
        let xContentOffsetNextPage = CGFloat(currentPageIndex + 1) * self.view.frame.size.width
        
        if xContentOffsetNextPage < self.scrollView.contentSize.width {
            self.scrollView.setContentOffset(CGPoint(x: xContentOffsetNextPage,y: 0), animated: true)
        }
    }
    
    @IBAction func buttonLeftTutorialPageAction(_ sender: UIButton) {
        let currentPageIndex: Int = Int(self.scrollView.contentOffset.x / self.view.frame.size.width)
        let xContentOffsetNextPage = CGFloat(currentPageIndex - 1) * self.view.frame.size.width
        
        if  xContentOffsetNextPage >= 0 {
            self.scrollView.setContentOffset(CGPoint(x: xContentOffsetNextPage,y: 0), animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        
        self.scrollView.isPagingEnabled = true
        labelStaticPrice.text = NSLocalizedString("price", comment: "")
        labelStaticCar.text = NSLocalizedString("car", comment: "")
        labelEngine.text = NSLocalizedString("Engine: ", comment: "")
        labelTransmission.text = NSLocalizedString("Transmission: ", comment: "")
        labelCondition.text = NSLocalizedString("condition: ", comment: "")
       setupScrollView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            if self.scrollView.contentOffset.x > (self.scrollView.contentSize.width - self.view.frame.size.width * 1.5) {
                self.buttonRightTutorialPage.isHidden = true
            } else if self.scrollView.contentOffset.x < self.view.frame.size.width / 2 {
                self.buttonLeftTutorialPage.isHidden = true
            } else {
                self.buttonLeftTutorialPage.isHidden = false
                self.buttonRightTutorialPage.isHidden = false
            }
        }
    }
    
    func setupScrollView(){

        let tutorial = tutorialPages
        for page in 0..<tutorial.count {
            let xOrigin = CGFloat(page) * (self.view.frame.size.width)
            let tutorialPage  = UIImageView()
            tutorialPage.frame = CGRect(x: xOrigin,y: 0,width: self.view.frame.size.width,height: self.scrollView.frame.size.height-100)
            tutorialPage.image = tutorial[page].image
            
            self.scrollView.addSubview(tutorialPage)
        }
        
        self.scrollView.contentSize = CGSize(width: (self.view.frame.size.width) * CGFloat((tutorialPages.count)), height: self.scrollView.frame.size.height-100)
        if tutorial.count == 0 {
            return
        }
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.buttonLeftTutorialPage.isHidden = true
        if tutorialPages.count == 0{
        self.buttonRightTutorialPage.isHidden = true
        }
    }
    
    func initializeViews() {
        self.buttonLeftTutorialPage.imageView?.contentMode = .scaleAspectFit
        self.buttonRightTutorialPage.imageView?.contentMode = .scaleAspectFit
        self.labelCar.text = carData.carModel
        self.labelPrice.text = carData.price
        self.labelEngine.text = carData.engine
        self.labelTransmission.text = carData.transmission
        self.labelCondition.text = carData.condition
        guard let image = carData.image as? [UIImage] else {return}
        for image in image{
        tutorialPages.append(UIImageView(image: image))
        }
    }

    deinit {
        if tutorialPages.count > 0{
        self.scrollView.removeObserver(self, forKeyPath: "contentOffset")
        }
    }
}
