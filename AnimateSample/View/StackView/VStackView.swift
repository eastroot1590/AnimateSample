//
//  VStackView.swift
//  Aspasia
//
//  Created by 이동근 on 2021/06/18.
//

import UIKit

class VStackView: UIView {
    var alignment: UIView.ContentMode = .center
    
    var stack: [Stackable] = []
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    private var contentSize: CGSize = .zero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var height: CGFloat = 0
        
        for node in stack {
            if node.view.frame.width > 0 {
                alignmentLayout(node.view, node.spacing, 0, minY: height)
            } else {
                fillLayout(node.view, node.spacing, 0, minY: height)
            }
            
            height += node.spacing + node.view.frame.height
        }
        
        contentSize = CGSize(width: frame.width, height: height)
        
        invalidateIntrinsicContentSize()
    }
    
    /// VStackView에 view를 추가한다.
    /// - parameter stack : 추가할 view
    /// - parameter spacing : 앞서 추가한 view와의 공백
    /// - parameter offset : 수직축에 대한 offset
    func push(_ child: UIView, spacing: CGFloat = 0, offset: CGFloat = 0) {
        child.sizeToFit()
        
        // layout
        if child.frame.width > 0 {
            alignmentLayout(child, spacing, offset, minY: frame.height)
        } else {
            fillLayout(child, spacing, offset, minY: frame.height)
        }
        
        // add
        addSubview(child)
        
        // append stack
        let node = Stackable(view: child, spacing: spacing)
        stack.append(node)
    }
    
    func playCascade() {
        var playing: Int = 0
        
        for node in stack {
            node.view.transform = CGAffineTransform(translationX: 0, y: -20)
            node.view.alpha = 0
            
            UIView.animate(withDuration: 0.1, delay: 0.05 * Double(playing), animations: {
                node.view.alpha = 1
                node.view.transform = .identity
            })
            
            playing += 1
        }
    }
    
    private func alignmentLayout(_ child: UIView, _ spacing: CGFloat, _ offset: CGFloat, minY: CGFloat) {
        // default center
        var origin = CGPoint(x: frame.width / 2 - child.frame.width / 2, y: minY + spacing)
        
        switch alignment {
        case .left:
            origin.x = 0 + offset
            
        case .right:
            origin.x = frame.width - child.frame.width + offset
            
        default:
            break
        }
        
        child.frame.origin = origin
        
    }
    
    private func fillLayout(_ child: UIView, _ spacing: CGFloat, _ offset: CGFloat, minY: CGFloat) {
        child.frame = CGRect(x: offset, y: minY + spacing, width: frame.width, height: child.frame.height)
    }
}
