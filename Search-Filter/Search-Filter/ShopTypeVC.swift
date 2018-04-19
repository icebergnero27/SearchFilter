//
//  ShopTypeVC.swift
//  Search-Filter
//
//  Created by antonio yaphiar on 4/20/18.
//  Copyright © 2018 Antonio. All rights reserved.
//

import Foundation
import UIKit

class ShopTypeVC: UIViewController {
    
    var filterController = FilterVC()
    
    @IBOutlet var goldMerchRadio: UIButton!
    @IBOutlet var officialRadio: UIButton!
    
    var filtershop = Int()
    var goldMerch = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtershop = filterController.filtershop
        goldMerch = filterController.goldMerch
        
        setView()
    }
    
    
    func setView() {
        if(goldMerch == true){
            goldMerchRadio.setBackgroundImage(#imageLiteral(resourceName: "check"), for: UIControlState.normal)
        }else {
            goldMerchRadio.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for: UIControlState.normal)
        }
        
        if(filtershop == 2){
            officialRadio.setBackgroundImage(#imageLiteral(resourceName: "check"), for: UIControlState.normal)
        }else {
            officialRadio.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for: UIControlState.normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func officialRadioTapped(_ sender: UIButton) {
        if(filtershop == 2){
            filtershop = 1
        }else {
            filtershop = 2
        }
        
        setView()
    }
    
    @IBAction func goldRadioTapped(_ sender: UIButton) {
        if(goldMerch == true){
            goldMerch = false
        }else {
            goldMerch = true
        }
        
        setView()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIBarButtonItem) {
        goldMerch = false
        filtershop = 1
        
        setView()
    }
    
    @IBAction func applyTapped(_ sender: UIButton) {
        filterController.goldMerch = goldMerch
        filterController.filtershop = filtershop
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
