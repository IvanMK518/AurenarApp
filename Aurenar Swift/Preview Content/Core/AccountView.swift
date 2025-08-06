//
//  AccountView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 6/11/25.
//

/*
 This component is for user account access
*/

import SwiftUI

struct AccountView: View {
    
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Account")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(TherapyCounter())
    }
}

