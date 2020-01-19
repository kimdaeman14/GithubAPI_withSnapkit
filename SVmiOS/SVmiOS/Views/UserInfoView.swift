//
//  UserInfoView.swift
//  SVmiOS
//
//  Created by Jaycee on 2020/01/19.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import UIKit
import SnapKit
import Then

class UserInfoView: UIView {
    
    let baseView = UIView().then {
        $0.layer.borderWidth = 2.0
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    let userProfileImage = UIImageView()
    
    var userName = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .black
    }
    
    var name = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .black
    }
    
    var userLocation = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .black
    }
    
    var userCompany = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .black
    }
    
    var userFollowers = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .black
    }
    
    var userFollowing = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .black
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func bind(model: UserInfo){
        self.userProfileImage.kf.setImage(with: URL(string: model.userProfileImage ?? ""))
        self.userName.text = model.userName
        self.name.text = model.name
        self.userLocation.text = model.userLocation
        self.userCompany.text = model.userCompany
        self.userFollowers.text = "follwers : \(model.userFollowers ?? 0)"
        self.userFollowing.text = "follwing : \(model.userFollowing ?? 0)"
     }
}

extension UserInfoView {
    func setupUI(){
        
        self.addSubview(self.baseView)
        self.baseView.addSubview(userProfileImage)
        self.baseView.addSubview(userName)
        self.baseView.addSubview(name)
        self.baseView.addSubview(userLocation)
        self.baseView.addSubview(userCompany)
        self.baseView.addSubview(userFollowers)
        self.baseView.addSubview(userFollowing)
        
//        userProfileImage.backgroundColor = .orange
//        userName.backgroundColor = .yellow
//        name.backgroundColor = .red
//        userLocation.backgroundColor = .blue
//        userCompany.backgroundColor = .green
//        userFollowers.backgroundColor = .magenta
//        userFollowing.backgroundColor = .cyan
        
        baseView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(140)
            make.top.equalTo(5)
            make.left.equalTo(10)
        }
        
        userProfileImage.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(self.baseView.snp.height)
        }
        
        userName.snp.makeConstraints { make in
            make.left.equalTo(self.userProfileImage.snp.right).offset(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(self.name.snp.top).offset(-5)
            make.height.equalTo(20)
        }
        
        name.snp.makeConstraints { make in
            make.left.equalTo(self.userProfileImage.snp.right).offset(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(self.userLocation.snp.top).offset(-5)
            make.height.equalTo(20)
        }
        
        userLocation.snp.makeConstraints { make in
            make.left.equalTo(self.userProfileImage.snp.right).offset(10)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        userCompany.snp.makeConstraints { make in
            make.left.equalTo(self.userProfileImage.snp.right).offset(10)
            make.right.equalTo(-10)
            make.top.equalTo(self.userLocation.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
        userFollowers.snp.makeConstraints { make in
            make.left.equalTo(self.userProfileImage.snp.right).offset(10)
            make.right.equalTo(self.userFollowing.snp.left)
            make.width.equalTo(self.userFollowing.snp.width)
            make.top.equalTo(self.userCompany.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
        userFollowing.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.top.equalTo(self.userCompany.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
    }
    
}
