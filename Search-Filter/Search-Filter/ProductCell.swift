//
//  ProductCell.swift
//  Search-Filter
//
//  Created by antonio yaphiar on 4/20/18.
//  Copyright © 2018 Antonio. All rights reserved.
//

import Foundation
import UIKit
class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
