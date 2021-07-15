//
//  PasswordList.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 14.07.21.
//

import SwiftUI

struct PasswordList: View {
    let testTable = [
        ["twitter.com", "alpha", "LightningApps_", "password"],
        ["youtube.com", "omega", "Apple", "youtube123"],
        ["github.com", "kappa", "johndoe@gmail.com", "hlg>kaifu"]
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Website").fontWeight(.bold)
                    }.frame(width: geometry.size.width/5, height: nil, alignment: .leading)
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Key").fontWeight(.bold)
                    }.frame(width: geometry.size.width/5, height: nil, alignment: .leading)
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Username/E-Mail").fontWeight(.bold)
                    }.frame(width: geometry.size.width/5, height: nil, alignment: .leading)
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Password").fontWeight(.bold)
                    }.frame(width: geometry.size.width/5, height: nil, alignment: .leading)
                    
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "eye.slash")
                    }.buttonStyle(.plain).hidden().disabled(true)
                    Button(action: {}) {
                        Image(systemName: "ellipsis.circle")
                    }.buttonStyle(.plain).hidden().disabled(true)
                }.frame(width: nil, height: 20, alignment: .center)
                ScrollView {
                    ForEach(testTable, id: \.self) { row in
                        PasswordListRow(item: row, geometry: geometry)
                    }
                }
            }.padding()
        }
    }
}

struct PasswordList_Previews: PreviewProvider {
    static var previews: some View {
        PasswordList()
    }
}
