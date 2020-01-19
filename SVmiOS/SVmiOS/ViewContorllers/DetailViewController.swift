//
//  DetailViewController.swift
//  SVmiOS
//
//  Created by Jaycee on 2020/01/19.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import UIKit
import Then
import SwiftyJSON

class DetailViewController: UIViewController {
    
    private var didSetupConstraints = false
    
    public var selectedUserName:String?
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    private var headerView = UserInfoView()
    
    private var userRepos: [UserRepository] = []
    
    private var refreshControl = UIRefreshControl()

    private var fetchingMore = false

    private var lastPage = 1{
        didSet{
            print("lastPage : \(lastPage)")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initTableView()
        self.initData()
    }
}


extension DetailViewController {
    
    private func initData(){
        API.profileInfo(selectedUserName ?? "").responseData { response in
            switch response.result{
            case .success(let data):
                do{
                    let json = try JSON(data: data)
                        self.headerView.bind(model: UserInfo(userProfileImage: json["avatar_url"].string,
                                                             userName: json["login"].string,
                                                             name: json["name"].string,
                                                             userLocation: json["location"].string,
                                                             userCompany: json["company"].string,
                                                             userFollowers: json["followers"].int,
                                                             userFollowing: json["following"].int))
                        self.tableView.reloadData()

                }catch{
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        API.reposList(self.lastPage, selectedUserName ?? "").responseData { response in
            switch response.result{
            case .success(let data):
                do{
                    let json = try JSON(data: data)
                    _ = json.map { str, json in
                        self.userRepos.append(UserRepository(name: json["name"].string,
                                                             description: json["description"].string,
                                                             stargazersCount: json["stargazers_count"].int,
                                                             watchersCount: json["watchers_count"].int,
                                                             createdAt: json["created_at"].string?.dateFormatted))
                        self.tableView.reloadData()
                        self.fetchingMore = false
                    }
                }catch{
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
        
    }
    
    private func initUI(){
        //        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(self.tableView)
        self.tableView.addSubview(refreshControl)
               self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
               self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
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
    
    private func initTableView(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 110
        self.tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.reuseIdentifier)
        self.tableView.tableHeaderView = headerView
        self.tableView.refreshControl = self.refreshControl

        
    }
    
    @objc private func refresh(){
         self.lastPage = 1
         self.userRepos = []
         self.initData()
         self.refreshControl.endRefreshing()
         
     }
}



extension DetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.reuseIdentifier, for: indexPath) as! RepositoryCell
        cell.bind(repo: self.userRepos[indexPath.row])
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



extension DetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height * 2 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    private func beginBatchFetch() {
        fetchingMore = true
        tableView.reloadSections(IndexSet(integer: 0), with: .bottom)
        DispatchQueue.main.async {
            self.initData()
            self.lastPage += 1
        }
    }
    
}






