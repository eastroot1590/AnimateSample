//
//  SimpleSubject.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/21.
//

import UIKit

/// 간단하게 제목과 내용으로 표현하는 view
class SimpleSubject: UIView {
    var padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var titleWidth: CGFloat = 100
    
    let titleLabel = UILabel()
    let subjectLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.preferredMaxLayoutWidth = 100
        titleLabel.textAlignment = .right
        addSubview(titleLabel)
        
        subjectLabel.font = .systemFont(ofSize: 16)
        subjectLabel.numberOfLines = 0
        addSubview(subjectLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.frame = CGRect(origin: CGPoint(x: padding.left, y: padding.top), size: CGSize(width: titleWidth, height: titleLabel.frame.height))
        subjectLabel.frame = CGRect(origin: CGPoint(x: padding.left + titleWidth + 20, y: padding.top), size: CGSize(width: frame.width - padding.right - 20 - titleWidth - padding.left, height: subjectLabel.frame.height))
        
        frame.size = CGSize(width: frame.width, height: max(titleLabel.frame.height, subjectLabel.frame.height) + padding.top + padding.bottom)
    }
    
    func fatch(title: String, subject: String) {
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        subjectLabel.text = subject
        subjectLabel.sizeToFit()
    }
}
