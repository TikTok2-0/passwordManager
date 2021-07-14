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
    let myPythonScript = PythonObject(contentsOfFile: "example")
    var helloworld: String {
        return myPythonScript.swiftOutput().description
    }
    let hash = "123".sha256()
    
    @State var currentView: String = "gen"
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                //Text("\(geometry.size.width) x \(geometry.size.height)")
                Picker(selection: $currentView, label: Text("")) {
                    Text("Generate Key")
                    Text("Manage Passwords").tag("list")
                    Text("Generate Password").tag("gen")
                }.pickerStyle(.segmented).padding().padding(.horizontal, geometry.size.width*0.25)
                Divider()
                if currentView == "list" {
                    PasswordList()
                } else if currentView == "gen" {
                    GeneratePassword()
                }
            }
        }.frame(width: 1200, height: 640, alignment: .leading)
    }
}

extension PythonObject {
    static func loadPythonScript(named filename: String) -> PythonObject {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "py")?
                .deletingLastPathComponent() else {
                    fatalError("Could not get URL for file")
                }
        let sys = Python.import("sys")
        let path = PythonObject(url.path)
        if !(sys.path.contains(path)) {
            sys.path.append(path)
        }
        return Python.import(filename)
    }
    
    init(contentsOfFile filename: String) {
        self.init(Self.loadPythonScript(named: filename))
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
    
    init() {
        self.upperChars = UserDefaults.standard.object(forKey: "upperChars") as? Bool ?? true
        self.specialChars = UserDefaults.standard.object(forKey: "specialChars") as? Bool ?? true
        self.figureChars = UserDefaults.standard.object(forKey: "upperChars") as? Bool ?? true
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
