//
//  CoreDataViewModel.swift
//  ToDoListFeature
//
//  Created by ONIN on 12/12/23.
//

import SwiftUI
import CoreData


class CoreDataViewModel: ObservableObject {
    
    // MARK: - View States
    @Published var addTaskShows = false
    @Published var isTodoTargeted = false
    @Published var isInProgressTargeted = false
    @Published var isDoneTargeted = false
    
    // MARK: - CoreData
    let container: NSPersistentContainer
    @Published var toDoTask: [ToDo] = []
    @Published var inProgressTask: [InProgress] = []
    @Published var doneTask: [Done] = []
    
    init() {
        container = NSPersistentContainer(name: "ListModel")
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("DEBUG: Error loading CoreData. \(error.localizedDescription)")
            }
        }
        
        fetchToDoTasks()
        fetchInProgressTasks()
        fetchDoneTasks()
    }
    
    // MARK: - Fetch Tasks
    func fetchToDoTasks() {
        let request = NSFetchRequest<ToDo>(entityName: "ToDo")
        
        do {
            toDoTask = try container.viewContext.fetch(request)
        } catch {
            print("DEBUG: Error fetching. \(error.localizedDescription)")
        }
    }
    
    func fetchInProgressTasks() {
        let request = NSFetchRequest<InProgress>(entityName: "InProgress")
        
        do {
            inProgressTask = try container.viewContext.fetch(request)
        } catch {
            print("DEBUG: Error fetching. \(error.localizedDescription)")
        }
    }
    
    func fetchDoneTasks() {
        let request = NSFetchRequest<Done>(entityName: "Done")
        
        do {
            doneTask = try container.viewContext.fetch(request)
        } catch {
            print("DEBUG: Error fetching. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Add Tasks
    func addTask(todayTask: String) {
        // Check if the task already exists in ToDo tasks
        let existingTask = toDoTask.first { $0.task == todayTask }
        
        guard existingTask == nil else {
            // If the task already exists, print a debug message and return
            print("DEBUG: Task already exists in ToDo tasks")
            return
        }
        
        // If the task is not a duplicate, proceed to add it
        let newTask = ToDo(context: container.viewContext)
        newTask.id = UUID()
        newTask.task = todayTask
        
        print("DEBUG: ToDo task added")
        saveTask()
    }
    
    func addInProgressTask(todayTask: String) {
        let existingTask = inProgressTask.first { $0.task == todayTask }
        
        guard existingTask == nil else {
            print("DEBUG: Task already exists in InProgress tasks")
            return
        }
        
        let newTask = InProgress(context: container.viewContext)
        newTask.id = UUID()
        newTask.task = todayTask
        
        print("DEBUG: InProgress task added")
        saveInProgressTask()
    }
    
    func addDoneTask(todayTask: String) {
        let existingTask = doneTask.first { $0.task == todayTask }
        
        guard existingTask == nil else {
            print("DEBUG: Task already exists in Done tasks")
            return
        }
        
        let newTask = Done(context: container.viewContext)
        newTask.id = UUID()
        newTask.task = todayTask
        
        print("DEBUG: Donetask added")
        saveDoneTask()
    }
    
    
    // MARK: - Save Tasks
    func saveTask() {
        do {
            try container.viewContext.save()
            fetchToDoTasks()
            
            print("DEBUG: Task ToDo saved")
        } catch {
            print("DEBUG: Error saving. \(error.localizedDescription)")
        }
    }
    
    func saveInProgressTask() {
        do {
            try container.viewContext.save()
            fetchInProgressTasks()
            
            print("DEBUG: Task inProgress saved")
        } catch {
            print("DEBUG: Error saving. \(error.localizedDescription)")
        }
    }
    
    func saveDoneTask() {
        do {
            try container.viewContext.save()
            fetchDoneTasks()
            
            print("DEBUG: Task Done saved")
        } catch {
            print("DEBUG: Error saving. \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Delete Tasks
    func deleteToDoTask(task: ToDo) {
        container.viewContext.delete(task)
        saveTask()
        
        print("DEBUG: ToDo task deleted")
    }
    
    func deleteInProgressTask(task: InProgress) {
        container.viewContext.delete(task)
        saveInProgressTask()
        
        print("DEBUG: InProgress task deleted")
    }
    
    func deleteDoneTask(task: Done) {
        container.viewContext.delete(task)
        saveDoneTask()
        
        print("DEBUG: Done task deleted")
    }
    
    // MARK: - Remove Task
    func removeToDoTask(task: String) {
        // Creating a fetch request for ToDo entities
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        // Setting up a predicate to filter tasks based on the provided task string
        fetchRequest.predicate = NSPredicate(format: "task == %@", task)
        
        do {
            // Fetching existing ToDo tasks based on the fetch request
            let existingTasks = try container.viewContext.fetch(fetchRequest)
            
            // Checking if a task matching the criteria was found
            guard let removedTask = existingTasks.first else {
                // If no matching task was found, print a debug message and return
                print("DEBUG: ToDo task not found for removal")
                return
            }
            
            // Deleting the existing ToDo entity from the Core Data context
            container.viewContext.delete(removedTask)
            
            // Printing a debug message indicating that a ToDo task has been removed
            print("DEBUG: ToDo task removed")
            
            // Saving changes to Core Data
            saveTask()
            
            // Fetching ToDo tasks after removal
            fetchToDoTasks()
            
        } catch {
            // Handling errors that may occur during the fetch and delete operations
            print("DEBUG: Error fetching and removing ToDo task: \(error)")
        }
    }
    
    func removeInProgressTask(task: String) {
        let fetchRequest: NSFetchRequest<InProgress> = InProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "task == %@", task)
        
        do {
            let existingTasks = try container.viewContext.fetch(fetchRequest)
            
            guard let removedTask = existingTasks.first else {
                print("DEBUG: InProgress task not found for removal")
                return
            }
            
            container.viewContext.delete(removedTask)
            print("DEBUG: InProgress task removed")
            
            saveInProgressTask()
            fetchInProgressTasks()
            
        } catch {
            print("Error fetching and removing InProgress task: \(error)")
        }
    }
    
    func removeDoneTask(task: String) {
        let fetchRequest: NSFetchRequest<Done> = Done.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "task == %@", task)
        
        do {
            let existingTasks = try container.viewContext.fetch(fetchRequest)
            
            guard let removedTask = existingTasks.first else {
                print("DEBUG: Done task not found for removal")
                return
            }
            
            container.viewContext.delete(removedTask)
            print("DEBUG: Done task removed")
            
            saveDoneTask()
            fetchDoneTasks()
            
        } catch {
            print("Error fetching and removing Done task: \(error)")
        }
    }
    
}

