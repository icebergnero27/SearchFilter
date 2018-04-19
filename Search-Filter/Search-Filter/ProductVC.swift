//
//  ProductVC.swift
//  Search-Filter
//
//  Created by antonio yaphiar on 4/20/18.
//  Copyright © 2018 Antonio. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ProductVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var searchCollectionView: UICollectionView!
    var products = Array<Any>()
    var refreshControl = UIRefreshControl()
    
    var rows = Int()
    var start = Int()
    var minPrice = Int()
    var maxPrice = Int()
    var wholesale = Bool()
    var official = Bool()
    var fshop = Int()
    var key:String = "samsung"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetFilter), name: NSNotification.Name(rawValue: "reset"), object: nil)
        
        self.resetFilter()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func resetFilter(){
        start = 0
        rows = 10
        minPrice = 0
        maxPrice = 10000000
        wholesale = false
        official = false
        fshop = 1
        
        self.getData()
    }
    
    
    // MARK: - Collection
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:(self.view.frame.size.width/2-CGFloat(15)), height:CGFloat(280))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCell
        
        let data = self.products[indexPath.row] as! [String: Any]
        
        cell.productNameLabel.text = data["name"] as? String
        cell.productPriceLabel.text = data["price"] as? String
        
        cell.productImageView.download(link: data["image_uri"] as! String)
        
        return cell
    }
    
    @IBAction func fiterButtonTapped(_ sender: UIButton) {
        let nav = self.storyboard?.instantiateViewController(withIdentifier: "FilterNav") as! UINavigationController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Filter") as! FilterVC
        vc.productVC = self
        nav.setViewControllers([vc], animated: true)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func getData() {
        
        print(key,rows,minPrice,maxPrice,wholesale,official,fshop)
        
        Alamofire.request(
            URL(string: "https://ace.tokopedia.com/search/v2.5/product?q=\(key)&pmin=\(minPrice)&pmax=\(maxPrice)&wholesale=\(wholesale)&official=\(official)&fshop=\(fshop)&start=\(start)&rows=\(rows)")!,
            method: .get)
            .validate()
            .responseJSON { (response) -> Void in
                
                let jsonResult = response.result.value as? [String: Any]
                let status = jsonResult!["status"] as? [String: Any]
                if (status!["message"] as! String == "OK"){
                    self.products += jsonResult!["data"] as! Array
                    self.searchCollectionView.reloadData()
                }
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.bounds.maxY == scrollView.contentSize.height) {
            rows = 10
            start = self.products.count
            self.getData()
        }
    }

}

extension UIImageView {
    func download(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func download(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        download(url: url, contentMode: mode)
    }
}
