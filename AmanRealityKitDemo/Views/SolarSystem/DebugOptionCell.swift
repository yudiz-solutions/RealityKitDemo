//
//  DebugOptionCell.swift
//  AmanRealityKitDemo
//
//  Created by Yudiz Solutions Limited on 23/03/23.
//

import UIKit

class DebugOptionCell: UICollectionViewCell {
    
    @IBOutlet private weak var lblOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.cornerRadius = 7.0
    }
    
    func setUI(option: String, shouldSelect: Bool) {
        lblOption.text = option
        lblOption.textColor = shouldSelect ? .white : .black
        contentView.backgroundColor = shouldSelect ? .orange : .white
    }
}
