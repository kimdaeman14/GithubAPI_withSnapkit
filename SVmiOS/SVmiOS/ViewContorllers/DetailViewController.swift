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
    
    var didSetupConstraints = false
    
    var selectedUserName:String?
    
    let tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    var headerView = UserInfoView()
    
    var userRepos: [UserRepository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initTableView()
        self.initData()
    }
}


extension DetailViewController {
    
    func initData(){
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
        
        API.reposList(1, selectedUserName ?? "").responseData { response in
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
                    }
                }catch{
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
        
    }
    
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




