//
//  String+.swift
//  Spelling
//
//  Created by Victor M on 28/03/2018.
//  Copyright © 2018 Victor M. All rights reserved.
//

import Foundation

extension String {
    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}
