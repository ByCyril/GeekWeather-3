//
//  iPadNavigationView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/5/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI

struct LocationPicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return SavedLocationViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

struct iPadNavigationView: View {
    var isPresented = false


    var body: some View {
        HStack {
            Text("Test")
        }
    }
}

struct iPadNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        iPadNavigationView()
    }
}
