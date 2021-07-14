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
            Button(action: { key = keyGen() }) {
                Label("Generate Key", systemImage: "dice")
            }
            
            Text("Generated Key:")
            Text("\(key)")
            
            Button(action: {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(key, forType: .string)
                self.showAlert.toggle()
            }) {
                Label("Copy to clipboard", systemImage: "doc.on.doc")
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("Important"), message: Text("In order to use this tool in a secure manner please write down this key on a piece of paper and do not share it with anyone!"), dismissButton: .destructive(Text("Close")))
            }
        }
    }
}

struct GenerateKey_Previews: PreviewProvider {
    static var previews: some View {
        GenerateKey()
    }
}
