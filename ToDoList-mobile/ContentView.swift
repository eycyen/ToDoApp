//
//  ContentView.swift
//  ToDoList-mobile
//
//  Created by Ahmet Hasan Canbolat on 25.09.2025.
//

import SwiftUI

struct ItemModel: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    let itemName: String
    var isDone: Bool
}


struct ContentView: View {
    
    @State var toDoList: [ItemModel] = []
    
    var body: some View {
        //Body
        NavigationView {
            //List
            List {
                ForEach($toDoList) { item in
                    ItemRowView(item: item)
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
            .navigationTitle(
                    Text("To-do")
            )
            .navigationBarItems(
                leading: EditButton(),
                trailing: NavigationLink("Add",destination: AddPage(toDoList: $toDoList))

            )
            .listStyle(.grouped)
            
        }
        .onAppear {
            loadFromUserDefaults()
        }
        
        .onChange(of: toDoList) {
            saveToUserDefaults()
        }
    }
    
    
    
}

extension ContentView {
    
    // REMARK : Logic
    
    func delete(indexSet: IndexSet) {
        toDoList.remove(atOffsets: indexSet)
    }
    
    func move(indices : IndexSet, newOffset: Int) {
        toDoList.move(fromOffsets: indices, toOffset: newOffset)
    }
    
}

extension ContentView {
    
    // REMARK : Save and load
    
    func saveToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(toDoList) {
            UserDefaults.standard.set(encodedData,forKey: "toDoList")
        }
    
    }
    
    func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "toDoList"), let decodedList = try? JSONDecoder().decode([ItemModel].self, from: data) {
            toDoList = decodedList
        }
            
    }
}


struct AddPage: View {
    
    @Binding var toDoList: [ItemModel]
    
    @State var item: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {

            VStack(alignment:.center) {
                
                TextField("Type here...", text: $item)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25.0, style: .continuous
                        )
                        .opacity(0.3)
                    )
                    .padding()
                    
                
                
                Button(action: {
                    
                    toDoList.append(ItemModel(itemName: item,isDone: false))
                    
                    item = ""
                    
                    dismiss()
                    
                }, label: {
                    Text("Save")
                })
                    
                    
            }
        }
        
}

struct ItemRowView: View {
    @Binding var item: ItemModel

    var body: some View {
        HStack {
            Button(action: {
                item.isDone.toggle()
            }) {
                Image(systemName: item.isDone ? "checkmark.circle" : "circle")
            }

            Text(item.itemName.capitalized)
        }
    }
}

#Preview {
   ContentView()
}
