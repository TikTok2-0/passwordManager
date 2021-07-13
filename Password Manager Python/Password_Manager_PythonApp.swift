//
//  Password_Manager_PythonApp.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 13.07.21.
//

import SwiftUI

@main
struct Password_Manager_PythonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
