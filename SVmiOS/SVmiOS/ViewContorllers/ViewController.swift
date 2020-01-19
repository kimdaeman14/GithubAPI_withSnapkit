

import UIKit
import SnapKit
import Kingfisher
import SwiftyJSON

class ViewController: UIViewController {
    
    private var didSetupConstraints = false
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var users: [User] = []
    
    private var refreshControl = UIRefreshControl()
    
    private var fetchingMore = false
    
    private var lastID = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initTableView()
        self.initData()
    }
    
}


extension ViewController {
    
    private func initData(){
        API.allUsers(self.lastID).responseData { response in
            switch response.result{
            case .success(let data):
                do{
                    let json = try JSON(data: data)
                    _ = json.map { str, json in
                        self.users.append(User(profileImageURL: json["avatar_url"].string,
                                               userID: json["id"].int,
                                               userName: json["login"].string))
                        self.lastID = json["id"].int ?? 0
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
}

extension ViewController {
    
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
        self.tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        self.tableView.refreshControl = self.refreshControl
    }
    
    
    
    @objc private func refresh(){
        self.lastID = 0
        self.users = []
        self.initData()
        self.refreshControl.endRefreshing()
        
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

extension ViewController {
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
        }
    }
    
}




