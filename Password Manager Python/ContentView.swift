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
    @State var searchList: Bool = false
    @State var searchInput: String = ""
    
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
                                Button(action: { searchList.toggle() }) {
                                    Image(systemName: "magnifyingglass")
                                        .imageScale(.large)
                                }.buttonStyle(.link).popover(isPresented: $searchList, attachmentAnchor: .point(.leading), arrowEdge: .leading) {
                                    VStack {
                                        Text("Search Passwords").font(.title3).fontWeight(.bold)
                                        FirstResponderNSSearchFieldRepresentable(text: $searchInput).frame(width: 150, height: 20, alignment: .center)
                                    }.padding()
                                }
                                Button(action: { activeSheet = .addPassword }) {
                                    Image(systemName: "plus")
                                        .imageScale(.large)
                                }.buttonStyle(.link)
                                .popover(item: $activeSheet, attachmentAnchor: .point(.leading), arrowEdge: .leading) { item in
                                    switch item {
                                    case .addPassword:
                                        AddPassword(localPassword: "")
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
                    PasswordList(searchText: self.searchInput)
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

struct FirstResponderNSSearchFieldRepresentable: NSViewControllerRepresentable {

    @Binding var text: String

      func makeNSViewController(
        context: NSViewControllerRepresentableContext<FirstResponderNSSearchFieldRepresentable>
      ) -> FirstResponderNSSearchFieldController {
          return FirstResponderNSSearchFieldController(text: $text)
      }

      func updateNSViewController(
        _ nsViewController: FirstResponderNSSearchFieldController,
        context: NSViewControllerRepresentableContext<FirstResponderNSSearchFieldRepresentable>
      ) {
      }
}

class FirstResponderNSSearchFieldController: NSViewController {

  @Binding var text: String
  var isFirstResponder : Bool = true

    init(text: Binding<String>, isFirstResponder : Bool = true) {
    self._text = text
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    let searchField = NSSearchField()
    searchField.delegate = self
    
    self.view = searchField
  }

  override func viewDidAppear() {
    self.view.window?.makeFirstResponder(self.view)
  }
}


extension FirstResponderNSSearchFieldController: NSSearchFieldDelegate {

  func controlTextDidChange(_ obj: Notification) {
    if let textField = obj.object as? NSTextField {
      self.text = textField.stringValue
    }
  }
}
