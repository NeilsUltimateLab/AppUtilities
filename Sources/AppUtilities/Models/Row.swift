//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

public struct Row<Value, Cell: ReusableView>: Hashable where Value: Hashable {
    public var value: Value
    public var cellType: Cell.Type
    
    public init(_ value: Value) {
        self.value = value
        self.cellType = Cell.self
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(cellType.identifier)
    }
    
    public static func ==(lhs: Row, rhs: Row) -> Bool {
        lhs.value == rhs.value && lhs.cellType.identifier == rhs.cellType.identifier
    }
}

public extension Row where Cell: UITableViewCell {
    func registerCell(in tableView: UITableView) {
        tableView.register(Cell.self)
    }
    
    func registerNib(in tableView: UITableView) {
        tableView.registerNib(Cell.self)
    }
    
    func dequeueReusableCell(from tableView: UITableView, at indexPath: IndexPath) -> Cell? {
        let cell = tableView.dequeueReusableCell(Cell.self, for: indexPath)
        return cell
    }
}

public extension Row where Cell: UICollectionViewCell {
    func registerCell(in collectionView: UICollectionView) {
        collectionView.register(Cell.self)
    }
    
    func registerNib(in collectionView: UICollectionView) {
        collectionView.registerNib(Cell.self)
    }
    
    func dequeueReusableCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> Cell? {
        collectionView.dequeueReusableCell(Cell.self, for: indexPath)
    }
}
