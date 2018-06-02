//
//  ViewController.swift
//  FoldingCells
//
//  Created by HongTao Guo on 2018/5/31.
//  Copyright © 2018 HongTao Guo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func showDemo(_ sender: Any) {
        let s = (0...1000).map{CollapsibleSection<String, String>.init(section: "\($0)", contents: ["a", "b","c", "d", "e", "f", "g"], collasped: true)}
        let vc = CellCollapsibleDemoViewController(sections: s)
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

       //var sections: [FoldableSection<String, String>] = [FoldableSection<String, String>.init(section: "1", contents: ["a", "b","c", "d", "e", "f", "g"], fold: true), FoldableSection<String,String>.init(section: "2", contents: ["h", "i", "j", "k", "l", "m", "n"], fold: true), FoldableSection.init(section: "3", contents: ["o", "p", "q", "r", "s", "t"], fold: true), FoldableSection.init(section: "4", contents: ["u", "v", "w", "x", "y", "z"], fold: true)]

}

