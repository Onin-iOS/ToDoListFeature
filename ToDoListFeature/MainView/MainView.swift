//
//  MainView.swift
//  ToDoListFeature
//
//  Created by ONIN on 12/11/23.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @EnvironmentObject var viewModel: CoreDataViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    ToDoKanbanView(isTargeted: viewModel.isTodoTargeted)
                        .dropDestination(for: String.self) { droppedTask, location in
                            viewModel.addTask(todayTask: droppedTask.joined())
                            
                            viewModel.removeInProgressTask(task: droppedTask.joined())
                            viewModel.removeDoneTask(task: droppedTask.joined())
                            
                            return true
                        } isTargeted: { isTargeted in
                            viewModel.isTodoTargeted = isTargeted
                        }
                    
                    InProgressKanbanView(isTargeted: viewModel.isInProgressTargeted)
                        .dropDestination(for: String.self) { droppedTask, location in
                            viewModel.addInProgressTask(todayTask: droppedTask.joined())
                            
                            viewModel.removeToDoTask(task: droppedTask.joined())
                            viewModel.removeDoneTask(task: droppedTask.joined())
                            
                            return true
                        } isTargeted: { isTargeted in
                            viewModel.isInProgressTargeted = isTargeted
                        }
                    
                    DoneKanbanView(isTargeted: viewModel.isDoneTargeted)
                        .dropDestination(for: String.self) { droppedTask, location in
                            viewModel.addDoneTask(todayTask: droppedTask.joined())
                            
                            viewModel.removeToDoTask(task: droppedTask.joined())
                            viewModel.removeInProgressTask(task: droppedTask.joined())
                            
                            return true
                        } isTargeted: { isTargeted in
                            viewModel.isDoneTargeted = isTargeted
                        }
                    
                }
                .padding()
                
            }
            .sheet(isPresented: $viewModel.addTaskShows, content: {
                withAnimation {
                    AddTaskView()
                        .presentationDetents([.height(250)])
                        .presentationCornerRadius(20)
                        .presentationDragIndicator(.visible)
                }
            })
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    MainView()
        .environmentObject(CoreDataViewModel())
}


