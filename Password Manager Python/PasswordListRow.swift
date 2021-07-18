//
//  PasswordListRow.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 14.07.21.
//

import SwiftUI

struct PasswordListRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: FetchedResults<Passwords>.Element
    var geometry: GeometryProxy
    
    @State var unlocked: Bool = false
    @State var showMenu: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.website)
                }.frame(width: geometry.size.width/5, height: nil, alignment: .leading)
                Divider()
                VStack(alignment: .leading) {
                    Text(item.keyName)
                }.frame(width: geometry.size.width/5, height: nil, alignment: .leading)
                Divider()
                VStack(alignment: .leading) {
                    Text(item.username)
                }.frame(width: geometry.size.width/5, height: nil, alignment: .leading)
                Divider()
                VStack(alignment: .leading) {
                    let passwordLength = item.password.count
                    let hiddenPwd = String(repeating: "*", count: passwordLength)
                    if unlocked {
                        Text("\(item.password)")
                    } else {
                        Text(hiddenPwd)
                    }
                }.frame(width: geometry.size.width/5, height: nil, alignment: .leading)
                
                Spacer()
                Button(action: {
                    unlocked.toggle()
                }) {
                    if unlocked {
                        Image(systemName: "eye")
                    } else {
                        Image(systemName: "eye.slash")
                    }
                }.buttonStyle(.plain)
                Button(action: { showMenu.toggle() }) {
                    Image(systemName: "ellipsis.circle")
                }.buttonStyle(.plain)
                    .popover(isPresented: $showMenu, attachmentAnchor: .point(.leading), arrowEdge: .leading) {
                        /*Menu("Menu") {
                            Button(action: {}) {
                                Text("Edit Password")
                            }
                        }.menuStyle(.automatic)*/
                        VStack {
                            Button(action: {}) {
                                Text("Edit Password")
                            }
                            
                            Button(action: {
                                let pasteboard = NSPasteboard.general
                                pasteboard.clearContents()
                                pasteboard.setString(item.username, forType: .string)
                            }) {
                                Text("Copy Username")
                            }
                            
                            Button(action: {
                                let pasteboard = NSPasteboard.general
                                pasteboard.clearContents()
                                pasteboard.setString(item.password, forType: .string)
                            }) {
                                Text("Copy Password")
                            }
                            
                            Button(action: {
                                showAlert.toggle()
                            }) {
                                Text("Delete Password").foregroundColor(.red)
                            }.alert(isPresented: $showAlert) {
                                Alert(title: Text("Attention"), message: Text("This will delete the password permanently."), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
                                    viewContext.delete(item)
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }))
                            }
                        }.padding()
                }
            }
    }
}
