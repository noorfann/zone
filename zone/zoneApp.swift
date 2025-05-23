//
//  zoneApp.swift
//  zone
//
//  Created by Zulfikar Noorfan on 20/05/25.
//

import SwiftData
import SwiftUI

@main
struct zoneApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GoalModel.self,
            TodoModel.self,
            TimeLogModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView(modelContext: sharedModelContainer.mainContext)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
