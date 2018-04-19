//
//  FilterVC.swift
//  Search-Filter
//
//  Created by antonio yaphiar on 4/20/18.
//  Copyright © 2018 Antonio. All rights reserved.
//

import Foundation
import WARangeSlider

class FilterVC: UIViewController {
    
    @IBOutlet weak var rangeView: UIView!
    @IBOutlet weak var minimumPriceLabel: UILabel!
    @IBOutlet weak var maximumPriceLabel: UILabel!
    @IBOutlet weak var wholeSaleSwitch: UISwitch!
    @IBOutlet var goldMerchantView: UIView!
    @IBOutlet var officialStoreView: UIView!
    
    var maxPriceValue = Double()
    var minPriceValue = Double()
    var wholeSale = Bool()
    var filtershop = Int()
    var goldMerch = Bool()
    
    let formatter = NumberFormatter()
    
    let maxPrice:Int = 10000000
    
    var productVC = ProductVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set Data
        wholeSale = productVC.wholesale
        if(productVC.wholesale == true){
            wholeSaleSwitch.setOn(true, animated: true)
        }else {
            wholeSaleSwitch.setOn(false, animated: true)
        }
        
        filtershop = productVC.fshop
        goldMerch = productVC.official
        
        formatter.locale = Locale(identifier: "id")
        formatter.numberStyle = .decimal
        
        minPriceValue = Double(productVC.minPrice)
        maxPriceValue = Double(productVC.maxPrice)
        
        //set Range View
        let rangeSlider = RangeSlider(frame: CGRect(x:0, y:0, width:self.view.frame.size.width-16, height:20))
        rangeSlider.trackHighlightTintColor = UIColor(red:0.31, green:0.64, blue:0.31, alpha:1.0)
        rangeSlider.thumbTintColor = UIColor.white
        rangeSlider.thumbBorderColor = UIColor(red:0.31, green:0.64, blue:0.31, alpha:1.0)
        
        rangeSlider.upperValue = Double(maxPriceValue)/Double(maxPrice)
        rangeSlider.lowerValue = Double(minPriceValue)/Double(maxPrice)
        
        self.rangeView.addSubview(rangeSlider)
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged(_:)),
                              for: .valueChanged)
        
        
        self.setPriceTextField()
        
        //set view
        goldMerchantView.layer.borderWidth = 1
        goldMerchantView.layer.borderColor = UIColor.lightGray.cgColor
        goldMerchantView.layer.cornerRadius = 15
        
        officialStoreView.layer.borderWidth = 1
        officialStoreView.layer.borderColor = UIColor.lightGray.cgColor
        officialStoreView.layer.cornerRadius = 15
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(filtershop == 2){
            officialStoreView.isHidden = false
        }else {
            officialStoreView.isHidden = true
        }
        
        if(goldMerch == true){
            goldMerchantView.isHidden = false
        }else {
            goldMerchantView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        
        maxPriceValue = round(Double(maxPrice)*Double(rangeSlider.upperValue))
        minPriceValue = round(Double(maxPrice)*Double(rangeSlider.lowerValue))
        
        self.setPriceTextField()
    }
    
    func setPriceTextField() {
        if let formattedMaxPrice = formatter.string(from: maxPriceValue as NSNumber) {
            self.maximumPriceLabel.text = "Rp \(formattedMaxPrice)"
        }
        
        if let formattedMinPrice = formatter.string(from: minPriceValue as NSNumber) {
            self.minimumPriceLabel.text = "Rp \(formattedMinPrice)"
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reset"), object: nil)
        })
    }
    
    @IBAction func wholeSaleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            wholeSale = true
        } else {
            wholeSale = false
        }
    }
    
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        
        productVC.minPrice = Int(minPriceValue)
        productVC.maxPrice = Int(maxPriceValue)
        productVC.wholesale = wholeSale
        productVC.rows = 10
        productVC.start = 0
        productVC.official = goldMerch
        productVC.fshop = filtershop
        
        self.navigationController?.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        })
        
    }
    
    @IBAction func goldMerchantTapped(_ sender: UIButton) {
        goldMerchantView.isHidden = true
        goldMerch = false
    }
    
    @IBAction func officialStoreTapped(_ sender: UIButton) {
        officialStoreView.isHidden = true
        filtershop = 1
    }
    
    @IBAction func shopTypeButtonTapped(_ sender: UIButton) {
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopType") as! ShopTypeController
        //vc.filterController = self
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


