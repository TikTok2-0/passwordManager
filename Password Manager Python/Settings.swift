//
//  Settings.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 18.07.21.
//

import SwiftUI

struct Settings: View {
    @State var confirm: Bool = false
    @State var showIDs: Bool = false
    @State var deletePasswords: Bool = false
    
    @FetchRequest(entity: Keys.entity(), sortDescriptors: [])
    var key: FetchedResults<Keys>
    @FetchRequest(entity: Passwords.entity(), sortDescriptors: [])
    var password: FetchedResults<Passwords>
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            Button(action: { showIDs.toggle() }) {
                Label("Show used KeyIDs", systemImage: "eye")
            }.popover(isPresented: $showIDs, attachmentAnchor: .point(.trailing), arrowEdge: .trailing) {
                VStack {
                    if UserData().keyName != 0 {
                        ForEach(key, id: \.self) { key in
                            Text("\(key.name!)")
                        }
                    } else {
                        Text("No key has been generated yet")
                    }
                }.padding()
            }
            
            Button(action: { deletePasswords.toggle() }) {
                Label("Delete all passwords", systemImage: "trash").foregroundColor(.red)
            }.alert(isPresented: $deletePasswords) {
                Alert(title: Text("Attention"), message: Text("This will permanently delete all your passwords"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
                    for singlePass in password {
                        viewContext.delete(singlePass)
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }))
            }
            
            Button(action: { confirm.toggle() }) {
                Label("Reset", systemImage: "trash").foregroundColor(.red)
            }.alert(isPresented: $confirm) {
                Alert(title: Text("Attention"), message: Text("This will make all generated keys unusable and delete all saved passwords"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Reset"), action: {
                    for singleKey in key {
                        viewContext.delete(singleKey)
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    UserData().keyName = 0
                    for singlePass in password {
                        viewContext.delete(singlePass)
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }))
            }
            
            ForEach(key, id: \.self) { key in
                HStack {
                    Text("\(key.name!)")
                    Spacer()
                    Text("\(key.hashedKey!)")
                }
            }
        }.padding()
    }
}

func deleteAllData(_ entity:String) {
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
