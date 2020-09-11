//
//  ViewController.swift
//  youtube
//
//  Created by jungwooram on 2020-06-09.
//  Copyright © 2020 jungwooram. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    //MARK:
    let FeedCellId = "FeedCellId"
    let TrendingCellId = "TrendingCellId"
    let SubscriptionCellId = "SubscriptionCellId"
    let titles = ["Home", "Trending", "Subscriptions", "Account"]
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()

    lazy var settingLauncher: SettingLauncher = {
        let launcher = SettingLauncher()
        launcher.homeController = self
        return launcher
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad() 
        
        configureNavBar()
        
        configureMenuBar()
       
        configureCollectionView()
            
        //setupCard()

    }
    
    private func configureCollectionView() {
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCellId)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: TrendingCellId)
        collectionView.register(SubscriptionCell.self, forCellWithReuseIdentifier: SubscriptionCellId)

        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.isPagingEnabled = true
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
    }

    private func configureMenuBar() {
        
        let redView = UIView()
        redView.backgroundColor = .red
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)

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
        
    }
    
    private func setTitle(for index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[index])"
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
    
    func scrollToMenuIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .init(), animated: true)
        setTitle(for: index)
    }
    
    @objc func handleSearch() {

    }

    @objc func handleOptions() {
        settingLauncher.showSettings()
    }
    
    //MARK: - UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier: String
        
        switch indexPath.item {
            case 0: identifier = FeedCellId
            case 1: identifier = TrendingCellId
            case 2: identifier = SubscriptionCellId
            default: identifier = FeedCellId
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.move().x / view.frame.width)
        menuBar.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .init())
        setTitle(for: index)
    }
    
}





