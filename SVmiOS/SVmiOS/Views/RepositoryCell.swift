//
//  RepositoryCell.swift
//  SVmiOS
//
//  Created by Jaycee on 2020/01/19.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Then

class RepositoryCell: UITableViewCell {
    
    static let reuseIdentifier = "RepositoryCell"
    
    let baseView = UIView().then {
        $0.layer.borderWidth = 2.0
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    var repoName = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .black
    }
    
    var repoDescription = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .black
        $0.numberOfLines = 3
    }
    
    var repoStargazersCount = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .black
    }
    
    var repoWatchersCount = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .black
    }
    
    var repoCreatedAt = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .black
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func bind(repo: UserRepository){
        self.repoName.text = "repository_name : \(repo.name ?? "")"
        self.repoDescription.text = "description :\n\(repo.description ?? "")"
        self.repoStargazersCount.text = "star : \(repo.stargazersCount ?? "")"
        self.repoWatchersCount.text = "watcher : \(repo.watchersCount ?? "")"
        self.repoCreatedAt.text = repo.createdAt
    }
    
}

extension RepositoryCell {
    func setupUI(){
        
        self.addSubview(self.baseView)
        self.baseView.addSubview(repoName)
        self.baseView.addSubview(repoDescription)
        self.baseView.addSubview(repoStargazersCount)
        self.baseView.addSubview(repoWatchersCount)
        self.baseView.addSubview(repoCreatedAt)
        
//        repoName.backgroundColor = .orange
//        repoDescription.backgroundColor = .yellow
//        repoStargazersCount.backgroundColor = .red
//        repoWatchersCount.backgroundColor = .blue
//        repoCreatedAt.backgroundColor = .green
        
        
        baseView.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
        }
        
        repoName.snp.makeConstraints { make in
            make.bottom.equalTo(self.repoDescription.snp.top).offset(-10)
            make.left.equalTo(10)
            make.width.equalTo(250)
        }
        
        repoDescription.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.width.equalTo(250)
            make.top.equalTo(self.repoWatchersCount.snp.top)
        }
        
        repoStargazersCount.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.bottom.equalTo(self.repoWatchersCount.snp.top).offset(-10)
        }
        
        repoWatchersCount.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview().offset(5)
        }
        
        repoCreatedAt.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.top.equalTo(self.repoWatchersCount.snp.bottom).offset(10)
            
        }
        
        
        
        
        
        
        
        
        
        
        
    }
}
