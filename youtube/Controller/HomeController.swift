//
//  ViewController.swift
//  youtube
//
//  Created by jungwooram on 2020-06-09.
//  Copyright © 2020 jungwooram. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var videos = [Video]()

    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()

    lazy var settingLauncher: SettingLauncher = {
        let launcher = SettingLauncher()
        launcher.homeController = self
        return launcher
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        configureNavBar()
        
        configureMenuBar()
        
        fetchVideos()
                
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        cell.video = videos[indexPath.item]
        return cell
    }
    
    private func fetchVideos() {
        if let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json") {
            let request = URLRequest(url: url)
            let urlSession = URLSession(configuration: .default)
            let tast = urlSession.dataTask(with: request) { (data, res, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        
                        for dic in json as! [[String: AnyObject]] {
                            
                            let video = Video()
                            video.title = dic["title"] as? String
                            video.numberOfViews = dic["number_of_views"] as? NSNumber
                            video.thumbNailImage = dic["thumbnail_image_name"] as? String
                            
                            let chaannel = Channel()
                            chaannel.name = dic["channel"]?["name"] as? String
                            chaannel.profileImage = dic["channel"]?["profile_image_name"] as? String
                            
                            video.channel = chaannel
                            
                            self.videos.append(video)
                            
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                        
                    } catch let jsonError {
                        print(jsonError)
                    }
                    
                    
                }
            }
            tast.resume()
        }
        
        
    }
    
    func showViewControllerForSetting(with setting: Setting) {
        let dummyContoller = UIViewController()
        dummyContoller.navigationItem.title = setting.name.rawValue
        dummyContoller.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = atts
        navigationController?.pushViewController(dummyContoller, animated: true)
    }
    
    private func configureMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]|", views: menuBar)
    }
    
    private func configureNavBar() {
        
        let searchImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.white)
        let searchBarbutton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let ellipsisImage = UIImage(systemName: "ellipsis")?.withTintColor(.white)
        let ellipsisBarbutton = UIBarButtonItem(image: ellipsisImage, style: .plain, target: self, action: #selector(handleOptions))
        navigationItem.rightBarButtonItems = [ellipsisBarbutton, searchBarbutton]
        navigationController?.navigationBar.tintColor = .white
        
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        navigationController?.navigationBar.isTranslucent = false
        
        //navigation bar delete shadow
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        navigationController?.hidesBarsOnSwipe = true
        
    }
    
    @objc func handleSearch() {
        
    }

    @objc func handleOptions() {
        //show menu
        settingLauncher.showSettings()
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16 + 68)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}




