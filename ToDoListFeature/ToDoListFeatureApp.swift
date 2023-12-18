//
//  ToDoListFeatureApp.swift
//  ToDoListFeature
//
//  Created by ONIN on 12/13/23.
//

import SwiftUI

@main
struct ToDoListFeatureApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(CoreDataViewModel())
        }
    }
}
