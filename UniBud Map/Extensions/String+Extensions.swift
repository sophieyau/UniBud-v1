//
//  String+Extensions.swift
//  UniBud Map
//
//  Created by Sophie Yau on 23/01/2023.
//

import Foundation
extension String {
    var formatPhoneForCall: String {
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
