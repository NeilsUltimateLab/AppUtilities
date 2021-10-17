//
//  File.swift
//  
//
//  Created by Neil Jain on 3/26/21.
//

import UIKit

/// A representation of `Cell` and its configuration `Value`.
///
/// `Cell` can be any ``ReusableView`` like `UITableViewCell`, `UICollectionViewCell`, `UITableViewHeaderFooterView`, `UICollectionReusableView` etc.
///
/// `Value` must conform to `Hashable` to use in `UICollectionViewDiffableDataSource` or `UITableViewDiffableDataSource`.
///
/// ## Usage:
/// - Declaration:
/// ```swift
/// enum ProfileRowType {
///     case image(Row<UIImage, ImageCell>)
///     case label(Row<String, LabelCell>)
///     case switch(Row<Bool, SwitchCell>)
///     case textField(Row<FieldValue, TextFieldCell>
/// }
///
///```
///
/// - Initialization:
///```swift
/// extension ProfileRowType {
///     static func rows() -> [ProfileRowType] {
///         [
///             .image(Row(UIImage(named: "profile-art")!)),
///             .label(Row("User name"))),
///             .switch(Row(true))),
///             .textField(Row(FieldValue(title: "Email", placeholder: "Enter email address", value: nil)))
///         ]
///     }
/// }
///```
///
/// - Usage:
///```swift
/// class ViewController: UIViewController {
///     private lazy var dataSource: UICollectionViewDiffableDataSource<Section, ProfileRowType> = {
///         UICollectionViewDiffableDataSource<Section, ProfileRowType>(collectionView: self.collectionView) { collectionView, indexPath, item in
///             switch item {
///             case .image(let row):
///                 let cell = row.dequeueReusableCell(from: collectionView, at: indexPath)
///                 cell.configure(with: row.value)
///                 return cell
///
///             case .label(let row):
///                 let cell = row.dequeueReusableCell(from: collectionView, at: indexPath)
///                 cell.configure(with: row.value)
///                 return cell
///
///             case .switch(let row):
///                 let cell = row.dequeueReusableCell(from: collectionView, at: indexPath)
///                 cell.configure(with: row.value)
///                 return cell
///
///             case .textField(let row):
///                 let cell = row.dequeueReusableCell(from: collectionView, at: indexPath)
///                 cell.configure(with: row.value)
///                 return cell
///             }
///         }
///     }()
/// }
/// 
/// ```
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
