//
//  String+Extention.swift
//  SVmiOS
//
//  Created by Jaycee on 2020/01/20.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import Foundation

extension String {
    var dateFormatted:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date ?? Date())
    }
}
