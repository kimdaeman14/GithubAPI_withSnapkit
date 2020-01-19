

import UIKit
import SnapKit
import Kingfisher
import SwiftyJSON

class ViewController: UIViewController {
    
    var didSetupConstraints = false
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initTableView()
        self.initData()
    }
    
}


extension ViewController {
    
    func initData(){
        API.allUsers(0).responseData { response in
            switch response.result{
            case .success(let data):
                do{
                    let json = try JSON(data: data)
                    _ = json.map { str, json in
                        self.users.append(User(profileImageURL: json["avatar_url"].string,
                                                   userID: json["id"].int,
                                                   userName: json["login"].string))
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
}

extension ViewController {
    
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
        self.tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
        cell.bind(model: self.users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.selectedUserName = users[indexPath.row].userName
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


