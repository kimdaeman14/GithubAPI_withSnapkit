//
//  DetailViewController.swift
//  SVmiOS
//
//  Created by Jaycee on 2020/01/19.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import UIKit
import Then

class DetailViewController: UIViewController {
    
    var didSetupConstraints = false
    
    let tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    let headerView = UserInfoView().then {
        $0.bind(model: UserInfo(userProfileImage: "https://www.womensarticle.com/wp-content/uploads/2018/05/jason-chen-22141-unsplash-1024x577.jpg",
                                userName: "water fire",
                                name: "jenny",
                                userLocation: "seoul",
                                userCompany: "svmios",
                                userFollowers: "123",
                                userFollowing: "456"))
    }
    
    let dummyList: [UserRepository] = [
        UserRepository(name: "hello world",
                       description: "uicolllecviewdddd",
                       stargazersCount: "1111111111",
                       watchersCount: "133113",
                       createdAt: "2014.03.03 07:40"),
        UserRepository(name: "alamofire",
                       description: "1uicolllecviewdddduicolllecviewdddduicolllecviewdddduicolllecviewdddduicolllecviewdddd",
                       stargazersCount: "13433",
                       watchersCount: "133",
                       createdAt: "2014.03.03 07:40"),
        UserRepository(name: "uicolllecviewdddd",
                       description: "1uicolllecviewdddduicolllecviewdddd",
                       stargazersCount: "13",
                       watchersCount: "13",
                       createdAt: "2014.03.03 07:40"),
        UserRepository(name: "uicolllecviewdddd",
                       description: "1uicolllecviewdddduicolllecviewdddd",
                       stargazersCount: "13",
                       watchersCount: "13",
                       createdAt: "2014.03.03 07:40"),
        UserRepository(name: "uicolllecviewdddd",
                       description: "1uicolllecviewdddduicolllecviewdddd",
                       stargazersCount: "13",
                       watchersCount: "13",
                       createdAt: "2014.03.03 07:40")
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initTableView()
    }
}


extension DetailViewController {
    
    func initUI(){
        //        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(self.tableView)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if(!didSetupConstraints){
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func initTableView(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 110
        self.tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.reuseIdentifier)
        self.tableView.tableHeaderView = headerView
        
    }
}



extension DetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.reuseIdentifier, for: indexPath) as! RepositoryCell
        cell.bind(repo: self.dummyList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = {
            let headerView = UIView()
            return headerView
        }()
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
}

