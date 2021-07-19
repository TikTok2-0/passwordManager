//
//  EditPassword.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 19.07.21.
//

import SwiftUI

struct EditPassword: View {
    @State var website: String = ""
    @State var username: String = ""
    @State var localPassword: String = ""
    @State var key: String = ""
    @State var keyName: String = ""
    
    @ObservedObject var passwordData: FetchedResults<Passwords>.Element
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @FetchRequest(entity: Passwords.entity(), sortDescriptors: [])
    var password: FetchedResults<Passwords>
    
    var body: some View {
        VStack {
            Text("Add Password")
                .font(.title3)
                .fontWeight(.bold)
            
            Section {
                TextField("Name", text: $website)
                TextField("Username", text: $username)
                TextField("Password", text: $localPassword)
            }
            Section {
                TextField("Key Name", text: $keyName)
                TextField("Key for Encryption", text: $key)
            }
            Section {
                HStack {
                    Spacer()
                    Button(action: {
                        self.passwordData.objectWillChange.send()
                        self.passwordData.website = self.website
                        self.passwordData.username = self.username
                        self.passwordData.password = self.localPassword

                        try? self.viewContext.save()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Label("Save", systemImage: "key.icloud")
                    }
                }
            }
        }
        .padding()
        .frame(width: 250, height: nil, alignment: .center)
        .onAppear {
            self.website = passwordData.website
            self.username = passwordData.username
            self.localPassword = passwordData.password
            self.keyName = passwordData.keyName
        }
    }
}

/*
struct EditPassword_Previews: PreviewProvider {
    static var previews: some View {
        EditPassword()
    }
}
*/
