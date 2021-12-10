//
//  File.swift
//  
//
//  Created by Neil Jain on 8/1/21.
//

import UIKit

/// This is used to show the textual represetation of an item and compare while selecting.
public typealias SelectionProvider = Equatable & CustomStringConvertible

/// Provides an interface for presenting selection options of a list of content.
///
/// This takes the collection of ``SelectionProvider`` with optional collection of already selected items.
open class SelectionViewController<A: SelectionProvider>: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - DataSources
    
    /// Collection of items for the list to provide selection.
    public var items: [A] = []
    
    /// Collection of already / previously selected items.
    ///
    /// for non-nil values, the tableView will show selection indicators to them and will scroll to first element.
    public var selectedItems: [A]?
    
    /// Allows ``tableView`` to have multiple selection.
    public var allowsMultipleSelection: Bool {
        set {
            self.tableView.allowsMultipleSelection = newValue
        }
        get {
            return self.tableView.allowsMultipleSelection
        }
    }
    
    /// Allow to show `Cancel` button at the navigation bar.
    public var shouldDismiss: Bool = false
    
    public var selectAllButton: UIBarButtonItem?
    
    /// A callback for the selected items.
    public typealias SelectionHandler = (([A]) -> Void)
    
    // MARK: - Selection Handler
    private var onSelection: SelectionHandler?
    public var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Initialisers
    public init(items: [A], selectedItems: [A]? = nil, allowsMultipleSelection enabled: Bool, style: UITableView.Style = .plain, shouldDismiss: Bool = false, selectionHandler: SelectionHandler?) {
        self.items = items
        self.onSelection = selectionHandler
        self.selectedItems = selectedItems
        self.shouldDismiss = shouldDismiss
        super.init(nibName: nil, bundle: nil)
        
        self.allowsMultipleSelection = enabled
        self.view.backgroundColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life-cycle Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupBarItems()
        setupForAlreadySelectedData()
    }
    
    fileprivate func setupTable() {
        self.view.addSubview(self.tableView)
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.tableView.register(SelectionTableCell.self)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = self.tableView.style == .plain ? UIView() : nil
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    fileprivate func setupBarItems() {
        if shouldDismiss {
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissAction))
            self.navigationItem.leftBarButtonItem = cancelButton
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        guard allowsMultipleSelection else { return }
        
        self.selectAllButton = UIBarButtonItem(title: "Select All", style: UIBarButtonItem.Style.plain, target: self, action: #selector(selectAllAction))
        self.navigationItem.rightBarButtonItem = selectAllButton
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.leftBarButtonItem = doneItem
    }
    
    private func setupForAlreadySelectedData() {
        guard let alreadySelectedData = self.selectedItems else { return }
        let indexPaths = items.indices(from: alreadySelectedData).map({IndexPath(row: $0, section: 0)})
        for indexPath in indexPaths {
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
        updateSelectAllButton()
        if let lastIndexPath = indexPaths.last {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.tableView.scrollToRow(at: lastIndexPath, at: .top, animated: true)
            }
        }
    }
    
    // MARK: - Methods
    
    @objc func doneAction() {
        var selectedItems = [A]()
        if let indexPaths = self.tableView.indexPathsForSelectedRows {
            for item in indexPaths {
                selectedItems.append(items[item.row])
            }
        }
        onSelection?(selectedItems)
        if self.shouldDismiss {
            dismissAction()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectAllAction() {
        let indexPaths = (0..<items.count).map{IndexPath(row: $0, section: 0)}
        if isAllSelected {
            for indexPath in indexPaths {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        } else {
            for indexPath in indexPaths {
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
            }
        }
        updateSelectAllButton()
    }
    
    fileprivate var isAllSelected: Bool {
        let selectedItems = self.tableView.indexPathsForSelectedRows
        return selectedItems?.count == self.items.count
    }
    
    fileprivate func updateSelectAllButton() {
        selectAllButton?.title = isAllSelected ? "Deselect All" : "Select All"
    }
    
    // MARK: - UITableViewDataSource Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SelectionTableCell.self, for: indexPath)!
        let data = items[indexPath.row]
        cell.textLabel?.text = data.description
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.allowsMultipleSelection {
            self.doneAction()
        }
        updateSelectAllButton()
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateSelectAllButton()
    }
    
}

class SelectionTableCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
    
}


public extension Array where Element: Equatable {
    
    mutating func delete(_ item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
    
    func indices(from anotherArray: Array) -> [Int] {
        var indices = [Int]()
        for element in anotherArray {
            if let index = self.firstIndex(of: element) {
                indices.append(index)
            }
        }
        return indices
    }
    
}

