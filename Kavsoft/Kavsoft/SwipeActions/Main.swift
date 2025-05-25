//
//  Main.swift
//  Kavsoft
//
//  Created by Sarvar Boltaboyev on 23/05/25.
//

import SwiftUI

struct Main: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Messages")
        }
    }
}

#Preview {
    Main()
}
