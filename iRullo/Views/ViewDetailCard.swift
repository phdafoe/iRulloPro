//
//  ViewDetailCard.swift
//  iRullo
//
//  Created by Andres Felipe Ocampo Eljaiek on 21/10/23.
//

import SwiftUI

struct ViewDetailCard: View {
    
    @ObservedObject var boardList: BoardList
    
    @State var tapNewName: String = ""
    @State var tapNewDescription: String = ""
    @State private var startDateNewTask = Date()
    @State private var finishDateNewTask = Date()
    
    var confirmAction: (String?, String?) -> ()
    @SwiftUI.Environment(\.presentationMode) var presenterMode
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("New Task")) {
                        TextField("Tap to add name", text: $tapNewName)
                        TextEditor(text: $tapNewDescription)
                    }
                    
                    Section(header: Text("Parameters")) {
                        DatePicker(selection: $startDateNewTask,
                                   in: Date.now...,
                                   displayedComponents: .date) {
                            HStack{
                                Image(systemName: "clock")
                                Text("Start task").font(.caption)
                            }
                        }
                        DatePicker(selection: $finishDateNewTask,
                                   in: Date.now...,
                                   displayedComponents: .date) {
                            HStack{
                                Image(systemName: "clock.fill")
                                Text("Finish task").font(.caption)
                            }
                        }
                    }
                }
                .listStyle(.automatic)
                
                Spacer()
                
                HStack(spacing: 16){
                    Button("Save"){
                        print("saved")
                        confirmAction(tapNewName, tapNewDescription)
                        self.presenterMode.wrappedValue.dismiss()
                    }
                    Button("Cancel", role: .cancel){
                        print("canceled")
                        self.presenterMode.wrappedValue.dismiss()
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Spacer()
            }
            .background(Constants.Backgroud.boardListBackgroundColor)
            .navigationTitle(boardList.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

