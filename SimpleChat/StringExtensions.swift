//
//  StringExtensions.swift
//  SimpleChat
//
//  Created by Jeremy Zhou on 3/11/18.
//  Copyright © 2018 Jeremy Zhou. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func attrString(_ color: UIColor = UIColor.darkText, font:UIFont = .systemFont(ofSize: 14) ) -> NSAttributedString {
        let attr : [NSAttributedStringKey: Any]  = [
            .foregroundColor : color,
            .font: font
        ]
        
        return NSAttributedString(string: self, attributes: attr)
    }
}
