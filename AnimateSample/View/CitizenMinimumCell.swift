//
//  CitizenMinimumCell.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

/// 주민 정보를 표현하는 CollectionViewCell
class CitizenMinimumCell: UICollectionViewCell {
    let thumbnailImage = UIImageView()
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        thumbnailImage.contentMode = .scaleAspectFit
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(thumbnailImage)
        NSLayoutConstraint.activate([
            thumbnailImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            thumbnailImage.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImage.widthAnchor.constraint(equalTo: widthAnchor),
            thumbnailImage.heightAnchor.constraint(equalTo: widthAnchor)
        ])
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(data: CitizenMinimumData) {
        thumbnailImage.image = UIImage(named: data.profileImage)
        nameLabel.text = data.name
    }
}

extension CitizenMinimumCell: Expandable {
    var primeView: UIView {
        self.thumbnailImage
    }
    
//    func primeView() -> UIView {
//        return thumbnailImage
//    }
}
