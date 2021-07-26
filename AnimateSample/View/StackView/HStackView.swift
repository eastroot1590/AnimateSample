//
//  HStackView.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/26.
//

import UIKit

class HStackView: UIView {
    var alignment: UIView.ContentMode = .center
    
    var stack: [Stackable] = []
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: frame.origin, size: CGSize(width: 0, height: frame.height)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var width: CGFloat = 0
        
        for node in stack {
            if node.view.frame.width > 0 {
                alignmentLayout(node.view, node.spacing, 0, minX: width)
            } else {
                fillLayout(node.view, node.spacing, 0, minX: width)
            }
            
            width += node.spacing + node.view.frame.width
        }
        
        frame.size = CGSize(width: width, height: frame.height)
    }
    
    /// VStackView에 view를 추가한다.
    /// - parameter stack : 추가할 view
    /// - parameter spacing : 앞서 추가한 view와의 공백
    /// - parameter offset : 수직축에 대한 offset
    func push(_ child: UIView, spacing: CGFloat = 0, offset: CGFloat = 0) {
        // layout
        if child.frame.width > 0 {
            alignmentLayout(child, spacing, offset, minX: frame.height)
        } else {
            fillLayout(child, spacing, offset, minX: frame.height)
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
            node.view.transform = CGAffineTransform(translationX: -20, y: 0)
            node.view.alpha = 0
            
            UIView.animate(withDuration: 0.1, delay: 0.05 * Double(playing), animations: {
                node.view.alpha = 1
                node.view.transform = .identity
            })
            
            playing += 1
        }
    }
    
    private func alignmentLayout(_ child: UIView, _ spacing: CGFloat, _ offset: CGFloat, minX: CGFloat) {
        // default center
        var origin = CGPoint(x: minX + spacing, y: frame.height / 2 - child.frame.height / 2)
        
        switch alignment {
        case .top:
            origin.y = offset
            
        case .bottom:
            origin.y = frame.height - child.frame.height + offset
            
        default:
            break
        }
        
        child.frame.origin = origin
        
    }
    
    private func fillLayout(_ child: UIView, _ spacing: CGFloat, _ offset: CGFloat, minX: CGFloat) {
        child.frame = CGRect(x: minX + spacing, y: offset, width: child.frame.width, height: frame.height)
    }
}
