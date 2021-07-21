//
//  SimpleSubject.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/21.
//

import UIKit

/// 간단하게 제목과 내용으로 표현하는 view
class SimpleSubject: UIView {
    let titleLabel = UILabel()
    let subjectLabel = UILabel()
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 0)))
        
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        subjectLabel.font = .systemFont(ofSize: 16)
        subjectLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subjectLabel)
        NSLayoutConstraint.activate([
            subjectLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            subjectLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            subjectLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bottomAnchor.constraint(equalTo: subjectLabel.bottomAnchor)
        ])
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
