//
//  String+Extentions.swift
//  ToDoApp
//
//  Created by Valeriy Trusov on 10.05.2022.
//

import Foundation


extension String {
    
    var percentEncoded: String {
        
        let allowedCharacters = CharacterSet(charactersIn: "!@#$%^&*()-+=[]\\}{,./?><").inverted
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        return encodedString
    }
}
