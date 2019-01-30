//
//  Model.swift
//  ToDoList
//
//  Created by Nick_Romanenko on 1/21/19.
//  Copyright © 2019 Nick_Romanenko. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

var ToDoItems: [[String: Any]] {
    get {
        if let array = UserDefaults.standard.array(forKey: "ToDoDataKey") as? [[String: Any]] {
            return array
        } else {
            return []
        }
    }
    
    set {
        //сохраняем данные массива словарей в UserDefaults
        UserDefaults.standard.set(newValue, forKey: "ToDoDataKey")
        UserDefaults.standard.synchronize()
    }
}

//добавляем новый элемент в массив данных
func addItem(nameItem: String, isCompleted: Bool = false) {
    ToDoItems.append(["Name": nameItem, "isCompleted": isCompleted])
    setBadge()
}

//удаляем элемент из массива данных
func removeItem(at index: Int) {
    ToDoItems.remove(at: index)
    setBadge()
}

//меняем "статус" строки данных в списке (ставим галочку об окончании задания или убираем ее)
func changeState(at item: Int) -> Bool{
    ToDoItems[item]["isCompleted"] = !(ToDoItems[item]["isCompleted"] as! Bool)
    setBadge()
    return (ToDoItems[item]["isCompleted"]) as! Bool
}

//когда будут менять местами элементы в таблице(интерфейсе) - этот метод будет менять их и в самом массиве
func moveItem(fromIndex: Int, toIndex: Int) {
    let from = ToDoItems[fromIndex]
    ToDoItems.remove(at: fromIndex)
    ToDoItems.insert(from, at: toIndex)
}

//единожды запрашиваем у пользователя запрос на разрешение получать уведомления
func requestForNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (isEnabled, error) in
        if isEnabled {
            print("согласие получено")
        } else {
            print("пришел отказ")
        }
    }
}

//узнаем количество дел, которые нужно выполнить для "бейджа" на иконке
func setBadge() {
    var totalBadgeNumber = 0
    for item in ToDoItems {
        if item["isCompleted"] as? Bool == false {
            totalBadgeNumber += 1
        }
    }
    UIApplication.shared.applicationIconBadgeNumber = totalBadgeNumber
}
