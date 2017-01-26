//
//  FilterTypes.swift
//  LineMaker
//
//  Created by Mac-mini on 26.01.17.
//  Copyright © 2017 AndreyPolyashev. All rights reserved.
//

import UIKit

enum FilterType {
    case blackWhite
    
    func filter() -> CIFilter? {
        switch self {
        case .blackWhite:
            return CIFilter(name: "CIColorControls")
        
        default:
            break
        }
    }
}
