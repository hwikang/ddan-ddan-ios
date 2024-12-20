//
//  Adjusted.swift
//  DDanDDan
//
//  Created by 이지희 on 12/7/24.
//

import UIKit

extension CGFloat {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 360
        let ratioH: CGFloat = UIScreen.main.bounds.height / 800
        return ratio <= ratioH ? self * ratio : self * ratioH
    }
    
    var adjustedWidth: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 360
        return CGFloat(self) * ratio
    }
    
    var adjustedHeight: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 800
        return CGFloat(self) * ratio
    }
}

extension Int {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 360
        let ratioH: CGFloat = UIScreen.main.bounds.height / 800
        return ratio <= ratioH ? CGFloat(self) * ratio : CGFloat(self) * ratioH
    }
    
    var adjustedWidth: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 360
        return CGFloat(self) * ratio
    }
    
    var adjustedHeight: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 800
        return CGFloat(self) * ratio
    }
}

extension Double {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 360
        let ratioH: CGFloat = UIScreen.main.bounds.height / 800
        return ratio <= ratioH ? CGFloat(self) * ratio : CGFloat(self) * ratioH
    }
    
    var adjustedWidth: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 360
        return CGFloat(self) * ratio
    }
    
    var adjustedHeight: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 800
        return CGFloat(self) * ratio
    }
}
