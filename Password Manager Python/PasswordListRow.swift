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
    
    @State var localBackgroundColor: NSColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0)
    @State var localTextColor: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    @State var unlocked: Bool = false
    @State var showMenu: Bool = false
    @State var showAlert: Bool = false
    @State var editPassword: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                .fill(Color(localBackgroundColor))
            
            HStack {
                VStack(alignment: .leading) {
                    Text(item.website)
                }.frame(width: geometry.size.width/6, height: nil, alignment: .leading)
                Divider()
                VStack(alignment: .leading) {
                    Text(item.keyName)
                }.frame(width: geometry.size.width/10, height: nil, alignment: .leading)
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
                }.frame(width: geometry.size.width/3, height: nil, alignment: .leading)
                
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
                }.buttonStyle(.plain).popover(isPresented: $showMenu, attachmentAnchor: .point(.leading), arrowEdge: .leading) {
                    VStack(alignment: .leading) {
                        Button(action: { editPassword.toggle() }) {
                            Text("Edit Password")
                        }.popover(isPresented: $editPassword, attachmentAnchor: .point(.leading), arrowEdge: .leading) {
                            EditPassword(passwordData: item)
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
                    }.padding().buttonStyle(.borderless)
                }
            }.padding(5).foregroundColor(Color(localTextColor)).onHover { item in
                if item {
                    localBackgroundColor = NSColor(red: 52/255, green: 109/255, blue: 251/255, alpha: 0.9)
                    localTextColor = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    localBackgroundColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0)
                    localTextColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
                }
            }
        }
    }
}
