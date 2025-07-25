//
//  ContentView.swift
//  Birthdays
//
//  Created by Scholar on 7/25/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var friends : [Friend]
    // = [Friend(name: "Aditi", birthday: .now), Friend(name: "Tracey", birthday:Date(timeIntervalSince1970: 20)) ]
    
    @Environment(\.modelContext) private var context
    
    @State private var newName = ""
    @State private var newBirthday = Date.now
    @State private var selectedFriend: Friend?
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(friends) {friend in
                        HStack {
                            Text(friend.name)
                            Spacer()
                            Text(friend.birthday, format: .dateTime.month(.wide).day().year())
                        }//hstack
                        .onTapGesture {
                            selectedFriend = friend
                        }//tapgesture
                }//friendin
                .onDelete(perform: deleteFriend)
            }//list
            .navigationTitle("Birthdays")
            .sheet(item: $selectedFriend) {friend in
                NavigationStack {EditFriendView(friend: friend)
                }//navstack
            }//sheet
            .safeAreaInset(edge: .bottom) {
                VStack(alignment:.center, spacing: 20) {
                    Text("New Birthday")
                        .font(.headline)
                    DatePicker(selection: $newBirthday, in: Date.distantPast...Date.now, displayedComponents: .date) {
                        TextField("Name", text: $newName)
                            .textFieldStyle(.roundedBorder)
                    }//date picker
                    Button("Save") {
                        let newFriend = Friend(name: newName, birthday: newBirthday)
                        //friends.append(newFriend)
                        context.insert(newFriend)
                        newName = ""
                        newBirthday = .now
                    }//button
                    .bold()
                }//vstack
                .padding()
                .background(.bar)
            }//safe inset
        }//navstack
    }//body
    func deleteFriend(at offsets: IndexSet) {
        for index in offsets{
            let friendToDelete = friends[index]
            context.delete(friendToDelete)
        }//for index in offsets
    }//delete friend
}//struct




#Preview {
    ContentView()
        .modelContainer(for: Friend.self, inMemory : true)
}//preview
