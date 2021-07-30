//
//  AddPassword.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 14.07.21.
//

import SwiftUI

struct AddPassword: View {
    @State var website: String = ""
    @State var username: String = ""
    @State var localPassword: String
    @State var key: String = ""
    @State var keyName: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @FetchRequest(entity: Passwords.entity(), sortDescriptors: [])
    var password: FetchedResults<Passwords>
    @FetchRequest(entity: Keys.entity(), sortDescriptors: [])
    var keys: FetchedResults<Keys>
    
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
                        //let keyArray: [UInt8] = Array(self.key.utf8)
                        print("\n\n TEST \n\n")
                        for item in keys {
                            //print("\(keyArray)")
                            //print("\n\(item.hashedKey ?? "Default"), \(hashKey(key: self.key))")
                            
                            if item.hashedKey == hashKey(key: self.key) {
                                let newPw = Passwords(context: viewContext)
                                newPw.website = self.website
                                (newPw.password, newPw.iv) = encryptPass(newPassword: self.localPassword, keyID: self.keyName, usedKey: self.key)
                                newPw.username = self.username
                                newPw.keyName = self.keyName
                            }
                        }
                        
                        do {
                            try viewContext.save()
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }) {
                        Label("Save", systemImage: "key.icloud")
                    }
                }
            }
        }
        .padding()
        .frame(width: 250, height: nil, alignment: .center)
    }
}

/*
struct AddPassword_Previews: PreviewProvider {
    static var previews: some View {
        AddPassword()
    }
}
*/
