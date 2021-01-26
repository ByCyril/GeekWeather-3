//
//  ErrorView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/24/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI

struct WeatherFetcherError {
    var title: String
    var description: String
}

struct ErrorView: View {
    
    var error: WeatherFetcherError
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "xmark.octagon.fill").resizable().frame(width: 25, height: 25, alignment: .center).padding().foregroundColor(.white)
                    Text(error.title)
                        .font(Font.custom("AvenirNext-Medium", size: 25))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }.padding(.bottom)
                Text(error.description)
                    .font(Font.custom("AvenirNext-Medium", size: 17))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Spacer()
                Text("Developed and Designed by Cyril © 2017 - 2021")
                    .font(Font.custom("AvenirNext-Medium", size: 13))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(weatherModel: Mocks.mock())
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    }
}
