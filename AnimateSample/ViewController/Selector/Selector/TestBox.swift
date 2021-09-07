//
//  TestBox.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/04.
//

import UIKit

/// override 해서 호출콜을 보기 위해 만든 테스트 박스
class TestBox: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("test box layout subviews")
    }
}
