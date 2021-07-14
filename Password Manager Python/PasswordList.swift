//
//  PasswordList.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 14.07.21.
//

import SwiftUI

struct PasswordList: View {
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<51, id: \.self) { item in
                Text("password \(item)")
            }
        }
    }
}

struct PasswordList_Previews: PreviewProvider {
    static var previews: some View {
        PasswordList()
    }
}
