//
//  CellCollapsibleDemoViewController.swift
//  CellCollapsible
//
//  Created by HongTao Guo on 2018/5/31.
//  Copyright © 2018 HongTao Guo. All rights reserved.
//

import UIKit

class CellCollapsibleDemoViewController: UIViewController, CellCollapsible {

    typealias S = String
    typealias C = String

    var sections: [CollapsibleSection<String, String>]
    var headerIndices: [Int] = []
    var collapseSectionRowCounts: Int = 0

    init(sections: [CollapsibleSection<String, String>]) {
        self.sections = sections
        super.init(nibName: nil, bundle: nil)
        prepareData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension CellCollapsibleDemoViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return collapseSectionRowCounts
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return cellHeight(for: indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "不能动"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isCollaspiableCell(at: indexPath) {
            cell.textLabel?.text = "index: " +  (collaspeSection(at: indexPath) ?? "")
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            cell.textLabel?.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        } else {
            cell.textLabel?.text = "\t" + (content(at: indexPath) ?? "")
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            cell.textLabel?.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        }
        
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section > 0 else { return }
        guard isCollaspiableCell(at: indexPath) else { return }
        let folded = isCollapsed(at: indexPath)
        collaspe(!folded, at: indexPath, in: tableView)
    }

}
