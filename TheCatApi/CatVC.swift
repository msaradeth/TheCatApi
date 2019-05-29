//
//  CatVC.swift
//  TheCatApi
//
//  Created by Mike Saradeth on 5/25/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class CatVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: CatViewModel!
    
    static func initWith(title: String, viewModel: CatViewModel) -> CatVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CatVC") as! CatVC
        vc.title = title
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        viewModel.loadData { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func setupVC() {
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "CatCell", bundle: nil), forCellReuseIdentifier:  CatCell.cellIdentifier)
//        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveFavorites))
//        self.navigationItem.rightBarButtonItem = saveBarButton
    }
    
//    @objc func saveFavorites() {
//        do {
//            try viewModel.saveFavorites()
//        }catch let error {
//            print(error.localizedDescription)
//        }
//    }

    deinit {
        print("deinit: CatVC")
    }
}

extension CatVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatCell.cellIdentifier, for: indexPath) as! CatCell
        cell.configure(index: indexPath.row, item: viewModel.items[indexPath.row], viewModelService: viewModel)
        return cell
    }
}
