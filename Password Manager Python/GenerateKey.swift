//
//  GenerateKey.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 14.07.21.
//

import SwiftUI

struct GenerateKey: View {
    @State var key: String = ""
    @State var username: String = "hkrieger"
    @State var password: String = "password123"
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.showAlert.toggle()
            }) {
                Label("Generate Key", systemImage: "dice")
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("Important"), message: Text("In order to use this tool in a secure manner please write down this key on a piece of paper and do not share it with anyone!\n\nFor security reasons, only 5 keys can be generated. Accordingly, you should carefully generate a new key and keep them safe."), primaryButton: .cancel(), secondaryButton: .default(Text("Generate"), action: { key = keyGen() }))
            }
            
            VStack {
                Text("Generated Key:").fontWeight(.bold)
                Text("\(key)")
            }.padding()
            
            VStack {
                Text("Key Name:").fontWeight(.bold)
                Text("\(UserData().keyName)")
            }.padding(.bottom)
            
            Button(action: {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(key, forType: .string)
            }) {
                Label("Copy to clipboard", systemImage: "doc.on.doc")
            }
        }
    }
}

struct GenerateKey_Previews: PreviewProvider {
    static var previews: some View {
        GenerateKey()
    }
}
