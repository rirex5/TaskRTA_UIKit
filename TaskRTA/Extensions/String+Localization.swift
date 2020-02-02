//
//  String+Localization.swift
//  TaskRTA
//
//  Created by Atsushi Otsubo on 2020/02/03.
//  Copyright © 2020 Rirex. All rights reserved.
//

import Foundation

extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
