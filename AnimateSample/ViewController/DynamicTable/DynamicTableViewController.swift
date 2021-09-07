//
//  DynamicTableViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/09/07.
//

import UIKit

class DynamicTableViewController: UIViewController {
    let rows: [String] = [
        "그대 기억이",
        "지난 사랑이",
        "내안을 파고드는",
        "가시- 가 되어"
    ]
    
    var selectedIndex: IndexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SpikeTableCell.self, forCellReuseIdentifier: "SpikeCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension DynamicTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpikeCell") as! SpikeTableCell
        
        cell.selectionStyle = .none
        cell.titleLabel.text = rows[indexPath.item]
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        44
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let cell = tableView.cellForRow(at: indexPath) as? SpikeTableCell {
//            if selectedIndex == indexPath {
//                return 88
//            }
//            return cell.stack.intrinsicContentSize.height
//        }
//        return 44
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
//        tableView.layoutSubviews()
        selectedIndex = indexPath
        tableView.endUpdates()
    }
}
