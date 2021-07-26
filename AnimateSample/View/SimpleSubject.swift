//
//  SimpleSubject.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/21.
//

import UIKit

/// 간단하게 제목과 내용으로 표현하는 view
class SimpleSubject: UIView {
    let layoutInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 5)
    
    let titleLabel = UILabel()
    let subjectLabel = UILabel()
    
    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        
        let height = UIFont.boldSystemFont(ofSize: 16).lineHeight + layoutInset.top + layoutInset.bottom
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.frame.origin = CGPoint(x: layoutInset.left, y: layoutInset.top)
        addSubview(titleLabel)
        
        subjectLabel.font = .systemFont(ofSize: 16)
        subjectLabel.frame.origin = CGPoint(x: layoutInset.left + 50, y: layoutInset.top)
        addSubview(subjectLabel)
        
        frame.size = CGSize(width: 0, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fatch(title: String, subject: String) {
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        subjectLabel.text = subject
        subjectLabel.sizeToFit()
    }
}
