//
//  PasswordListRow.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 14.07.21.
//

import SwiftUI

struct PasswordListRow: View {
    var item: [String]
    var geometry: GeometryProxy
    
    @State var unlocked: Bool = false
    
    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(item[0])
                }.frame(width: geometry.size.width/5, height: nil, alignment: .leading)
                Divider()
                VStack(alignment: .leading) {
                    Text(item[1])
                }.frame(width: geometry.size.width/5, height: nil, alignment: .leading)
                Divider()
                VStack(alignment: .leading) {
                    Text(item[2])
                }.frame(width: geometry.size.width/5, height: nil, alignment: .leading)
                Divider()
                VStack(alignment: .leading) {
                    if unlocked {
                        Text(item[3]).foregroundColor(.red)
                    } else {
                        Text(item[3])
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
                Button(action: {}) {
                    Image(systemName: "ellipsis.circle")
                }.buttonStyle(.plain)
            }
    }
}
