//
//  StorageUtils.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 8.11.2023.
//

import Foundation

private let defaults = UserDefaults.standard
private let levelKey = "lastLevel"

func saveUserProgress(level : Int){
    defaults.set(level, forKey: levelKey)
}

func getUsersLastCompletedLevel() -> Int {
    return defaults.integer(forKey: levelKey)
}
