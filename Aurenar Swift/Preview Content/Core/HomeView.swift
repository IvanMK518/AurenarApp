//
//  HomeView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 6/11/25.
//

/*
 Home screen component. Renders UI from various other views.
*/

import Foundation
import SwiftUI

struct HomeView: View {
    @StateObject private var bt = bluetoothService()
    @State private var isRunning = false
    @State private var isPairing = false
    @State private var time = 0
    @State private var showAlert = false

    
    var body: some View {
        ZStack {
            if bt.peripheralStatus == .connected {
                pairingSuccessView(bt: bt, )
            } else {
                pairingView(bt: bt)
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
