//
//  VStackView.swift
//  Aspasia
//
//  Created by 이동근 on 2021/06/18.
//

import UIKit

class VStackView: UIView {
    /// StackView에 추가할 수 있는 Node
    struct StackNode {
        var view: UIView
        var spacing: CGFloat
    }
    
    var alignment: UIView.ContentMode = .center
    
    var stack: [StackNode] = []
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: 0)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        frame.size = CGSize(width: frame.size.width, height: height)
    }
    
    /// VStackView에 view를 추가한다.
    /// - parameter stack : 추가할 view
    /// - parameter spacing : 앞서 추가한 view와의 공백
    /// - parameter offset : 수직축에 대한 offset
    func push(_ child: UIView, spacing: CGFloat = 0, offset: CGFloat = 0) {
        // layout
        if child.frame.width > 0 {
            alignmentLayout(child, spacing, offset, minY: frame.height)
        } else {
            fillLayout(child, spacing, offset, minY: frame.height)
        }
        
        // add
        addSubview(child)
        
        // append stack
//        frame.size = CGSize(width: frame.width, height: frame.height + spacing + child.frame.height)
        let stackNode = StackNode(view: child, spacing: spacing)
        stack.append(stackNode)
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
