//
//  VStackScroll.swift
//  Aspasia
//
//  Created by 이동근 on 2021/06/18.
//

import UIKit

class VStackScroll: UIScrollView {
    let contentView: VStackView = VStackView()
    
    // Sticky Header
    var headerView: UIView?
    var headerHeight: CGFloat = 0
    
    init() {
        super.init(frame: .zero)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        let height = contentView.heightAnchor.constraint(equalTo: heightAnchor)
        height.priority = .defaultHigh
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            height
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var origin: CGPoint = .zero
        
        if frame.width < UIScreen.main.bounds.width {
            origin = CGPoint(x: -safeAreaInsets.left, y: -safeAreaInsets.top)
        } else {
            origin = .zero
        }
        
        headerView?.frame.origin = origin
        headerView?.frame.size = CGSize(width: frame.width, height: frame.height > headerHeight ? headerHeight : frame.height)
    }
    
    func push(_ stack: UIView, spacing: CGFloat) {
        contentView.push(stack, spacing: spacing)
        
        contentView.layoutIfNeeded()
        contentSize = contentView.frame.size
    }
    
    func pushHeader(_ stack: UIView, height: CGFloat) {
        headerView = stack
        headerHeight = height
        
        contentView.addSubview(stack)
        contentView.minHeight = height
    }
}
