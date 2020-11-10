//
//  Time.swift
//  student
//
//  Created by 寺西帝乃 on 2020/11/08.
//

import Foundation


func nowTimeString() -> String {
    let dt = Date()
    let dateFormatter = DateFormatter()// DateFormatter を使用して書式とロケールを指定する
    dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
    
    return dateFormatter.string(from: dt)
}

func StudyTime(startTime: String) -> Int{
    let dt = Date()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
    
    let fromTime = dateFormatter.date(from: startTime)
    
    let timeInternal = Calendar.current.dateComponents([.minute], from: fromTime!, to: dt).minute
    
    return timeInternal!
    
}
