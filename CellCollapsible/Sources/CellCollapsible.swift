//
//  CellCollapsible.swift
//  CellCollapsible
//
//  Created by HongTao Guo on 2018/5/31.
//  Copyright © 2018 HongTao Guo. All rights reserved.
//

import Foundation
import UIKit


struct CollapsibleSection<S, C> {
    var section: S
    var contents: [C]
    var collasped: Bool
}

protocol CellCollapsible: class {

    associatedtype S
    associatedtype C

    var sections: [CollapsibleSection<S, C>] {get set}
    var headerIndices: [Int] { get set }
    var collapseSectionRowCounts: Int { get set }

    func prepareData()
    func isCellCollapsed(at indexPath: IndexPath) -> Bool
    func isCollapsed(at indexPath: IndexPath) -> Bool
    func collaspe(_ collaspe: Bool, at indexPath: IndexPath, in tableView: UITableView)
    func collaspeSection(at indexPath: IndexPath) -> S?
    func content(at indexPath: IndexPath) -> C?
}

extension CellCollapsible {

    func prepareData() {
        var index = 0
        var indices: [Int] = []
        var count = sections.count

        for section in sections {
            indices.append(index)
            let contentsCount = section.contents.count
            index += contentsCount + 1
            count += contentsCount
        }
        headerIndices = indices
        collapseSectionRowCounts = count
    }

    func collaspeSection(at indexPath: IndexPath) -> S? {
        let section = getSectionIndex(indexPath.row)
        guard isCellCollapsed(at: indexPath) else { return nil }
        return sections[section].section
    }

    func content(at indexPath: IndexPath) -> C? {
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        guard row > 0 else { return nil }
        return sections[section].contents[row - 1]
    }

    func collaspe(_ collasped: Bool, at indexPath: IndexPath, in tableView: UITableView) {
        let section = getSectionIndex(indexPath.row)
        self.sections[section].collasped = collasped
        reloadSections(in: section, tableSection: indexPath.section, in: tableView)
    }

    func isCollapsed(at indexPath: IndexPath) -> Bool {
        let section = getSectionIndex(indexPath.row)
        return sections[section].collasped
    }

    func isCellCollapsed(at indexPath: IndexPath) -> Bool {
        let row = getRowIndex(indexPath.row)
        return row == 0
    }

    func reloadSections(in subSection: Int, tableSection: Int, in tableView: UITableView) {
        let indices = headerIndices
        let start = indices[subSection]
        let end = start + sections[subSection].contents.count
        let indexpaths = (start...end).map{ IndexPath(row: $0, section: tableSection) }
        tableView.reloadRows(at: indexpaths, with: .automatic)
    }

    func cellHeight(for indexPath: IndexPath) -> CGFloat {
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        if row == 0 { return UITableViewAutomaticDimension }

        return sections[section].collasped ? 0 : UITableViewAutomaticDimension
    }

    //
    // MARK: - Helper Functions
    //

    func getSectionIndex(_ row: Int) -> Int {
        let indices = headerIndices// getHeaderIndices()

        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        return -1
    }

    func getRowIndex(_ row: Int) -> Int {
        var index = row
        let indices = headerIndices// getHeaderIndices()
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        return index
    }

}
