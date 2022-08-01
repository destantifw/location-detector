//
//  MainView.swift
//  location-detector
//
//  Created by destanti on 31/07/22.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var locationViewModel = LocationViewModel()
    
    var body: some View {
        VStack {
            if let locations = locationViewModel.locationList {
                List(locations, id: \.self) { string in
                    Text(string)
                }
            }
            Button("Start") {
                onStartTapped()
            }
            .alert(isPresented: $locationViewModel.isPermissionDenied) {() -> Alert in
                Alert(title: Text("Permission Denied"),
                      message: Text("You need to enable location permission to continue using this app."),
                      primaryButton: .default(Text("OK"),
                                              action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }), secondaryButton: .default(Text("Cancel"), action: {
                    exit(0)
                }))
                
            }
        }
    }
    
    func onStartTapped() {
        locationViewModel.requestLocation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
