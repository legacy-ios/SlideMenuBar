//
//  SettingLauncher.swift
//  youtube
//
//  Created by jungwooram on 2020-06-10.
//  Copyright © 2020 jungwooram. All rights reserved.
//

import UIKit

class Setting {
    let name: String
    let imageName: String
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
class SettingLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    var homeController: HomeController?
    
    let settings: [Setting] = {
        return [Setting(name: "Settings", imageName: "gear"),
         Setting(name: "Terms & privacy policy", imageName: "hand.raised"),
         Setting(name: "Send Feedback", imageName: "exclamationmark.bubble.fill"),
         Setting(name: "Help", imageName: "questionmark.circle"),
         Setting(name: "Switch Account", imageName: "person.circle.fill"),
         Setting(name: "Cancel", imageName: "xmark")]
    }()
    
    lazy var blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let selector = #selector(handleTapGesture)
        let tap = UITapGestureRecognizer(target: self, action: selector)
        view.addGestureRecognizer(tap)
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    func showSettings() {
        // show menu
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                        
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = 350//CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
            }, completion: nil)
        }
         
    }
    
    @objc func handleTapGesture() {
        handleDismiss(nil)
    }
    
    private func handleDismiss(_ indexPath: IndexPath?) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { _ in
            guard let indexPath = indexPath else { return }
            let setting = self.settings[indexPath.item]
            if indexPath.item != self.settings.count-1 {
                self.homeController?.showViewControllerForSetting(with: setting)
            }
        }
    }
    
    //MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        cell.setting = settings[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleDismiss(indexPath)
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }

}
