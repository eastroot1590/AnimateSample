//
//  SelectorViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/09/07.
//

import UIKit

class SelectorViewController: UIViewController {
    let selectedLabel: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        selectedLabel.text = "현재 선택된 번호는: "
        selectedLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectedLabel)
        NSLayoutConstraint.activate([
            selectedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            selectedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let selector = SelectorView(15, row: 3)
        selector.delegate = self
        selector.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selector)
        NSLayoutConstraint.activate([
            selector.topAnchor.constraint(equalTo: selectedLabel.bottomAnchor, constant: 10),
            selector.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selector.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selector.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SelectorViewController: SelectorViewDelegate {
    func selectorSelect(_ selector: SelectorView, option: UIView) {
        selectedLabel.text = "현재 선택된 번호는: \(option.tag)"
    }
}
