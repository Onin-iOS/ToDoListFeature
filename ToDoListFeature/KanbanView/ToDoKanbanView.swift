//
//  ToDoKanbanView.swift
//  ToDoListFeature
//
//  Created by ONIN on 12/12/23.
//

import SwiftUI

struct ToDoKanbanView: View {
    
    @EnvironmentObject var viewModel: CoreDataViewModel

    let isTargeted: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("To Do")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.yellow)
                
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.addTaskShows.toggle()
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isTargeted ? .yellow.opacity(0.15) : Color("grayBG"))
                
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.toDoTask) { entity in
                                HStack {
                                    Text(entity.task ?? "")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(.trailing, 20)
                                    
                                    Spacer()
                                    
                                    Button {
                                        viewModel.deleteToDoTask(task: entity)
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundStyle(.red)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(10)
                                .background(Color("textBG"))
                                .cornerRadius(8)
                                .shadow(radius: 1, x: 1, y: 1)
                                .padding(.horizontal, 10)
                                .draggable(entity.task ?? "")
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical)
                    }
            }
        }
    }
}

#Preview {
    ToDoKanbanView(isTargeted: false)
        .environmentObject(CoreDataViewModel())
}
