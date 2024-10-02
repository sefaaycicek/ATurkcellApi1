//
//  ViewController.swift
//  ATurkcellApi1
//
//  Created by Sefa Aycicek on 2.10.2024.
//

import UIKit

class ViewController: BaseViewController {
    @IBOutlet weak var acc: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        
        viewModel.needShowProgress = { isLoading in
            if isLoading {
                self.acc.startAnimating()
            } else {
                self.acc.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
        
        viewModel.needReloadUITableData = {
            self.tableView.reloadData()
        }
    }
    
    @objc func refresh() {
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchData()
    }
}

extension ViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath: \(indexPath.row) - \(indexPath.section)")
        let model = viewModel.getItem(section: indexPath.section, index: indexPath.row)
        let identifier = (indexPath.row % 2) == 0 ? "portakal" : "portakalRed"
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PostTableViewCell {
            cell.configure(with: model)
            return cell
        }
        
        return UITableViewCell()
    }
    
  /*  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section Header \(section)"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Section Footer \(section)"
    }*/
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .yellow
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        return headerView
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        <#code#>
    }*/
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplayData(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteItem(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Sil"
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension ViewController : UITextFieldDelegate {
    
}

extension ViewController : UISearchBarDelegate {
    
}


