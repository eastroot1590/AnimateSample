//
//  VStackScroll.swift
//  Aspasia
//
//  Created by 이동근 on 2021/06/18.
//

import UIKit

class VStackScroll: UIScrollView {
    var alignment: UIView.ContentMode {
        get {
            self.contentView.alignment
        }
        set {
            self.contentView.alignment = newValue
        }
    }
    
    var contentView: VStackView!
    
    var bannerView: UIView?
    var bannerHeight: CGFloat = 0
    
    var ribbonView: UIView?
    var ribbonHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        showsHorizontalScrollIndicator = false
        
        contentView = VStackView(frame: frame)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let offset = min(contentOffset.y, 0)
        let bannerHeightMax = bannerHeight - offset
        
        bannerView?.frame.origin = CGPoint(x: 0, y: offset)
        
        if frame.height > bannerHeightMax {
            bannerView?.frame.size = CGSize(width: frame.width, height: bannerHeightMax)
        } else {
            bannerView?.frame.size = frame.size
        }
        
        let ribbonOffset = max(contentOffset.y + adjustedContentInset.top, bannerHeight) - bannerHeight
        let rHeight = min(ribbonHeight + ribbonOffset, ribbonHeight + adjustedContentInset.top)
        ribbonView?.frame.origin = CGPoint(x: 0, y: max(contentOffset.y, bannerHeight))
        ribbonView?.frame.size = CGSize(width: frame.width, height: rHeight)
        
        let shadowOffset = min(ribbonOffset / adjustedContentInset.top, 1)
        ribbonView?.layer.shadowOffset = CGSize(width: 0, height: shadowOffset * 50)
        
        resizeScrollBound()
    }
    
    /// VStackScroll에 view를 추가한다.
    /// - parameter stack : 추가할 view
    /// - parameter spacing : 앞서 추가한 view와의 공백
    /// - parameter offset : 수직축에 대한 offset
    func push(_ stack: UIView, spacing: CGFloat = 0, offset: CGFloat = 0) {
        contentView.push(stack, spacing: spacing, offset: offset)
    }
    
    func setBanner(_ banner: UIView, height: CGFloat) {
        bannerView = banner
        bannerHeight = height
        
        addSubview(banner)
        
        // layout
        banner.frame.origin = .zero
        banner.frame.size = CGSize(width: frame.width, height: height)
        
        contentView.frame.origin = CGPoint(x: 0, y: bannerHeight + ribbonHeight)
    }
    
    func setRibbon(_ ribbon: UIView, height: CGFloat) {
        ribbonView = ribbon
        ribbonHeight = height
        
        addSubview(ribbon)
        
        // layout
        ribbon.frame.origin = CGPoint(x: 0, y: bannerHeight)
        ribbon.frame.size = CGSize(width: frame.width, height: ribbonHeight)
        // shadow
        ribbon.layer.shadowColor = UIColor.black.cgColor
        ribbon.layer.shadowOpacity = 0.5
        ribbon.layer.shadowRadius = 10
        ribbon.layer.shadowPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: -20, y: ribbon.frame.height / 2), size: CGSize(width: ribbon.frame.width + 40, height: ribbon.frame.height / 2))).cgPath
        
        contentView.frame.origin = CGPoint(x: 0, y: bannerHeight + ribbonHeight)
    }
    
    private func resizeScrollBound() {
        contentSize = CGSize(width: contentView.frame.width, height: bannerHeight + ribbonHeight + contentView.frame.height)
    }
}
