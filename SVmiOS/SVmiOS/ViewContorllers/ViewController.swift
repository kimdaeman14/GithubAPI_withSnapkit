

import UIKit
import SnapKit
import Kingfisher

class ViewController: UIViewController {
    
    var didSetupConstraints = false
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    let dummyList: [User] = [
       User(profileImageURL: "https://www.womensarticle.com/wp-content/uploads/2018/05/jason-chen-22141-unsplash-1024x577.jpg", userID: "22", userName: "22"),
        User(profileImageURL: "https://www.dw.com/image/52036834_303.jpg", userID: "22", userName: "22"),

        User(profileImageURL: "https://www.dw.com/image/52036834_303.jpg", userID: "22", userName: "22"),

        User(profileImageURL: "https://www.womensarticle.com/wp-content/uploads/2018/05/jason-chen-22141-unsplash-1024x577.jpg", userID: "22", userName: "22")

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initTableView()
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
        return dummyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
        cell.bind(model: self.dummyList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}


