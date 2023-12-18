//
//  AddTaskView.swift
//  ToDoListFeature
//
//  Created by ONIN on 12/11/23.
//

import SwiftUI

struct AddTaskView: View {
    
    @EnvironmentObject var viewModel: CoreDataViewModel
    @State private var task: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("textBG")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Add Task")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.yellow)
                    
                    VStack(spacing: 10) {
                        TextField("What's up?", text: $task)
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                        
                        Divider()
                        
                        HStack {
                            Button {
                                task = ""
                                viewModel.addTaskShows.toggle()
                            } label: {
                                Text("Cancel")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            Button {
                                guard !task.isEmpty else { return }
                                viewModel.addTask(todayTask: task)
                                task = ""
                                viewModel.addTaskShows.toggle()
                            } label: {
                                Text("Submit")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                    }
                    .padding(10)
                    .padding(.horizontal, 10)
                    .background(Color("grayBG"))
                    .cornerRadius(8)
                    .shadow(radius: 1, x: 1, y: 1)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 30)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    AddTaskView()
        .environmentObject(CoreDataViewModel())
}
