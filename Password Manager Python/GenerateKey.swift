//
//  GenerateKey.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 14.07.21.
//

import SwiftUI

enum AlertState {
    case allowed, disabled
}

struct GenerateKey: View {
    @State var generatedKey: String = ""
    @State var hashedKey: String = ""
    @State var showAlert: Bool = false
    
    @State var state: AlertState = .allowed
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @FetchRequest(entity: Keys.entity(), sortDescriptors: [])
    var key: FetchedResults<Keys>
    
    var body: some View {
        VStack {
            Button(action: {
                if UserData().keyName < 5 {
                    state = .allowed
                } else {
                    state = .disabled
                }
                showAlert.toggle()
            }) {
                Label("Generate Key", systemImage: "dice")
            }.alert(isPresented: $showAlert) {
                switch state {
                case .allowed:
                    return Alert(title: Text("Important"), message: Text("In order to use this tool in a secure manner please write down this key on a piece of paper and do not share it with anyone!\n\nFor security reasons, only 5 keys can be generated. Accordingly, you should carefully generate a new key and keep them safe."), primaryButton: .cancel(), secondaryButton: .default(Text("Generate"), action: {
                        UserData().keyName += 1
                        (generatedKey, hashedKey) = keyGen()
                        
                        let newKey = Keys(context: viewContext)
                        newKey.name = UserData().names[UserData().keyName]
                        newKey.hashedKey = hashedKey
                        
                        do {
                            try viewContext.save()
                            presentationMode.wrappedValue.dismiss()
                            print("Saved successfully")
                            print(hashedKey)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }))
                case .disabled:
                    return Alert(title: Text("Not allowed"), message: Text("You have already generated 5 keys! If you want to generate a new one, please reset all keys and passwords in the settings."), dismissButton: .cancel())
                }
            }
            
            /*.alert(isPresented: $showAlert) {
                    
            }*/
            
            VStack {
                Text("Generated Key:").fontWeight(.bold)
                Text("\(generatedKey)")
            }.padding()
            
            VStack {
                Text("Key Name:").fontWeight(.bold)
                Text("\(UserData().names[UserData().keyName])")
            }.padding(.bottom)
            
            Button(action: {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(generatedKey, forType: .string)
            }) {
                Label("Copy to clipboard", systemImage: "doc.on.doc")
            }
        }.padding()
    }
}

struct GenerateKey_Previews: PreviewProvider {
    static var previews: some View {
        GenerateKey()
    }
}
