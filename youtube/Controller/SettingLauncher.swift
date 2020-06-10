//
//  SettingLauncher.swift
//  youtube
//
//  Created by jungwooram on 2020-06-10.
//  Copyright © 2020 jungwooram. All rights reserved.
//

import UIKit

class SettingLauncher {
    
    let blackView = UIView()
    
    func showSettings() {
        // show menu
        if let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first {
            print(window)
        }



    }
}
