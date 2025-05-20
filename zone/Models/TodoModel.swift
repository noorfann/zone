//
//  TodosModel.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import Foundation
import SwiftData

// MARK: - Todos Model
@Model
final class TodoModel {
    var id: String
    var goalID: String
    var title: String
    var isCompleted: Bool
    
    init(id: String = UUID().uuidString, goalID: String, title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.goalID = goalID
        self.isCompleted = isCompleted
    }
    
    func toggleCompleted() {
        isCompleted.toggle()
    }
}
