//
//  ContentView.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 13.07.21.
//

import SwiftUI
import CoreData
import PythonKit
import CryptoSwift

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    @State var currentView: String = "list"
    let paddingFloat: CGFloat = 15
    @State var showSheet: Bool = false
    @State var activeSheet: ActiveSheet?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Picker(selection: $currentView, label: Text("")) {
                        Text("Generate Key").tag("key")
                        Text("Manage Passwords").tag("list")
                        Text("Generate Password").tag("gen")
                        Text("Settings").tag("settings")
                    }.pickerStyle(.segmented).padding().padding(.horizontal, geometry.size.width*0.25)
                        .frame(width: geometry.size.width-(paddingFloat*2), height: nil, alignment: .center)
                        .multilineTextAlignment(.center)
                        .overlay(
                            HStack {
                                Spacer()
                                Button(action: { activeSheet = .addPassword }) {
                                    Image(systemName: "plus")
                                        .imageScale(.large)
                                }.buttonStyle(.link)
                                .popover(item: $activeSheet, attachmentAnchor: .point(.leading), arrowEdge: .leading) { item in
                                    switch item {
                                    case .addPassword:
                                        AddPassword()
                                    case .generatePassword:
                                        GeneratePasswordPopover()
                                    case .generateKey:
                                        GenerateKey()
                                    }
                                }
                                .contextMenu {
                                    Button(action: { activeSheet = .addPassword }) {
                                        Text("Add Password")
                                    }
                                    Button(action: { activeSheet = .generateKey }) {
                                        Text("Generate Key")
                                    }
                                    Button(action: { activeSheet = .generatePassword }) {
                                        Text("Generate Password")
                                    }
                                }
                            }
                        )
                }
                Divider()
                if currentView == "key" {
                    GenerateKey()
                } else if currentView == "list" {
                    PasswordList()
                } else if currentView == "gen" {
                    GeneratePassword()
                } else if currentView == "settings" {
                    Settings()
                }
            }
        }.frame(width: 900, height: 480, alignment: .leading)
    }
}

enum ActiveSheet: Identifiable {
    case addPassword
    case generateKey
    case generatePassword
    
    var id: Int {
        hashValue
    }
}

class UserData: ObservableObject {
    @Published var upperChars: Bool {
        didSet {
            UserDefaults.standard.set(upperChars, forKey: "upperChars")
        }
    }
    @Published var specialChars: Bool {
        didSet {
            UserDefaults.standard.set(specialChars, forKey: "specialChars")
        }
    }
    @Published var figureChars: Bool {
        didSet {
            UserDefaults.standard.set(figureChars, forKey: "figureChars")
        }
    }
    
    @Published var keyName: Int {
        didSet {
            UserDefaults.standard.set(keyName, forKey: "keyName")
        }
    }
    var names = ["Alpha", "Alpha", "Beta", "Delta", "Kappa", "Omega"]
    
    init() {
        self.upperChars = UserDefaults.standard.object(forKey: "upperChars") as? Bool ?? true
        self.specialChars = UserDefaults.standard.object(forKey: "specialChars") as? Bool ?? true
        self.figureChars = UserDefaults.standard.object(forKey: "upperChars") as? Bool ?? true
        
        self.keyName = UserDefaults.standard.object(forKey: "keyName") as? Int ?? 0
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


    /*List {
        Section(header: Text("Passwords")) {
            NavigationLink(destination: PasswordList()) {
                Label("View Passwords", systemImage: "eye.fill")
            }
            NavigationLink(destination: Text("test")) {
                Label("Manage Password", systemImage: "list.bullet")
            }
            NavigationLink(destination: Text("test")) {
                Label("Generate Key", systemImage: "key.fill")
            }
            NavigationLink(destination: GeneratePassword()) {
                Label("Generate Password", systemImage: "dice.fill")
            }
        }
        Section(header: Text("Debugging")) {
            Text("Python Script: \(helloworld)")
            Text("Hash: \(hash)")
            Text("\(geometry.size.width) x \(geometry.size.height)")
        }
    }
    .listStyle(.sidebar)*/
//.frame(width: geometry.size.width, height: geometry.size.height)
//.frame(minWidth: 2560*0.15, idealWidth: 2560*0.7, maxWidth: 2560/2, minHeight: 1600*0.15, idealHeight: 1600*0.7, maxHeight: 2560/2, alignment: .center)
