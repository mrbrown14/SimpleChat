//
//  ImageExtensions.swift
//  SimpleChat
//
//  Created by Jeremy Zhou on 3/11/18.
//  Copyright © 2018 Jeremy Zhou. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func imageMaskedWith(_ color: UIColor) -> UIImage {
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -(imageRect.size.height))
        
        context?.clip(to: imageRect, mask: cgImage!)
        context?.setFillColor(color.cgColor)
        context?.fill(imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}
