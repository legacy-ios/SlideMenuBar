//
//  Extensions.swift
//  youtube
//
//  Created by jungwooram on 2020-06-09.
//  Copyright © 2020 jungwooram. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIImageView {
    
    struct ImageCache {
        static let cache = NSCache<AnyObject, AnyObject>()
    }
    
    func loadImage(urlString: String) {
        
        image = nil
        
        if let imageFromCache = ImageCache.cache.object(forKey: urlString as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            
            if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        ImageCache.cache.setObject(image, forKey: url.absoluteString as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}
