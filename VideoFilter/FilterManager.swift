//
//  FilterManager.swift
//  LineMaker
//
//  Created by Mac-mini on 26.01.17.
//  Copyright © 2017 AndreyPolyashev. All rights reserved.
//

import UIKit

class FilterManager {
    fileprivate var filters: [FilterType] = []
    
    init(filters: [FilterType]) {
        self.filters = filters
    }
}

//MARK: Internal API
extension FilterManager {
    func imageWithFilter(_ filter: FilterType, cameraImage: CIImage) -> UIImage? {
        
        guard let filter = filter.filter() else {
            return nil
        }
        
        filter.setValuesForKeys([kCIInputImageKey: cameraImage,
                                 kCIInputBrightnessKey: NSNumber(value: 0.0),
                                 kCIInputContrastKey: NSNumber(value: 1.0),
                                 kCIInputSaturationKey: NSNumber(value: 0.0)])
        
        
        filter.setValue(cameraImage, forKey: kCIInputImageKey)
        
        if let image = filter.value(forKey: kCIOutputImageKey) as? CIImage {
            return UIImage(ciImage: image)
        }
        
        
        return nil

    }
}
