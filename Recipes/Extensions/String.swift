//
//  String.swift
//  Recipes
//
//  Created by Antoine Antoniol on 27/01/2020.
//  Copyright © 2020 Antoine Antoniol. All rights reserved.
//

import Foundation


extension String {
    ///Convert a string url to data
    var data: Data? {
        guard let url = URL(string: self) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
}
