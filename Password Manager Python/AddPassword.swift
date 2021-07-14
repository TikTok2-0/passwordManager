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
    @State var password: String = ""
    @State var key: String = ""
    
    var body: some View {
        VStack {
            Text("Add Password")
                .font(.title3)
                .fontWeight(.bold)
            
            Section {
                TextField("Website", text: $website)
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
            }
            Section {
                TextField("Key for Encryption", text: $key)
            }
            Section {
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Label("Save", systemImage: "key.icloud")
                    }
                }
            }
        }
        .padding()
        .frame(width: 250, height: nil, alignment: .center)
    }
}

struct AddPassword_Previews: PreviewProvider {
    static var previews: some View {
        AddPassword()
    }
}
