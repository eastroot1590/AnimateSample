//
//  HomeViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/09/07.
//

import UIKit

class HomeViewController: UIViewController {
    let rows: [TestViewControllerData] = [
        TestViewControllerData(title: "CollectionView 확장 애니메이션", viewController: CellSpreadViewController()),
        TestViewControllerData(title: "숫자 애니메이션", viewController: NumberViewController()),
        TestViewControllerData(title: "그래프 애니메이션", viewController: ChartViewController()),
        TestViewControllerData(title: "그리드 UX", viewController: GridUXViewController()),
        TestViewControllerData(title: "Selector", viewController: SelectorViewController()),
        TestViewControllerData(title: "다이나믹 테이블", viewController: DynamicTableViewController())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let table = UITableView(frame: view.frame, style: .grouped)
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: "TestCell")
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Animate Sample"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell") as! HomeTableViewCell
        
        cell.selectionStyle = .none
        cell.fatch(rows[indexPath.item].title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = rows[indexPath.item].viewController
        viewController.title = rows[indexPath.item].title
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
