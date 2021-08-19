//
//  TestViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/27.
//

import UIKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "테스트"
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        let vStackScroll = VStackScroll(frame: view.frame)
        vStackScroll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(vStackScroll)
        
        for _ in 0 ..< 10 {
            let node = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 70)))
            node.backgroundColor = .systemYellow
            
            vStackScroll.push(node, spacing: 10)
        }
        
        let header = UIView()
        header.backgroundColor = .systemRed
        vStackScroll.setBanner(header, height: 300)
        
        let ribbon = UIView()
        ribbon.backgroundColor = .systemGreen
        vStackScroll.setRibbon(ribbon, height: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("test view will appear navigation bar show")
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        print("test view will layout subview")
    }
}
