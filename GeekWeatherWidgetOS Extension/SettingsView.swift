//
//  SettingsView.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/26/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI

struct SectionTitleHeader: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(Font.custom("AvenirNext-Medium", size: 13))
            .minimumScaleFactor(0.2)
            .allowsTightening(true)
            .lineLimit(1)
            .foregroundColor(.secondary)
    }
}

struct SettingsView: View {
    
    @State var set24hourTime: Bool = false {
        didSet {
            sharedUserDefaults?.setValue(set24hourTime, forKey: "is24Hour")
        }
    }
    
    @State var selectedTemp: Int = 0
    @State var selectedMetric: Int = 0
    
    var body: some View {
        List {
            Section(header: SectionTitleHeader(text: "Temperature")) {
                
                Button(action: {
                    selectedTemp = 0
                    sharedUserDefaults?.setValue(0, forKey: "Temperature")
                }, label: {
                    HStack {
                        Text("Fahrenheit")
                            .font(Font.custom("AvenirNext-Medium", size: 15))
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if selectedTemp == 0 {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(Color.green)
                        }
                        
                    }
                })
                
                Button(action: {
                    selectedTemp = 1
                    sharedUserDefaults?.setValue(1, forKey: "Temperature")
                }, label: {
                    HStack {
                        Text("Celsius")
                            .font(Font.custom("AvenirNext-Medium", size: 15))
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white)
                        
                        Spacer()
                        if selectedTemp == 1 {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(Color.green)
                        }
                    }
                })
            }
            
            Section(header: SectionTitleHeader(text: "Metrics")) {
                Button(action: {
                    sharedUserDefaults?.setValue(0, forKey: "Units")
                }, label: {
                    HStack {
                        Text("m/s")
                            .font(Font.custom("AvenirNext-Medium", size: 15))
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white)
                        
                        Spacer()
                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color.green)
                    }
                })
                Button(action: {
                    sharedUserDefaults?.setValue(1, forKey: "Units")
                }, label: {
                    HStack {
                        Text("mph")
                            .font(Font.custom("AvenirNext-Medium", size: 15))
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white)
                        
                        Spacer()
                        //                    Image(systemName: "checkmark.circle.fill").foregroundColor(Color.green)
                    }
                })
                Button(action: {
                    sharedUserDefaults?.setValue(2, forKey: "Units")
                }, label: {
                    HStack {
                        Text("km/h")
                            .font(Font.custom("AvenirNext-Medium", size: 15))
                            .minimumScaleFactor(0.2)
                            .allowsTightening(true)
                            .lineLimit(1)
                            .foregroundColor(.white)
                        
                        Spacer()
                        //                    Image(systemName: "checkmark.circle.fill").foregroundColor(Color.green)
                    }
                })
            }
            
            Section(header: SectionTitleHeader(text: "Time Format")) {
                Toggle(isOn: $set24hourTime) {
                    Text("24-Hour TIme")
                        .font(Font.custom("AvenirNext-Medium", size: 15))
                        .minimumScaleFactor(0.2)
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(.white)
                }.padding()
            }
        }.onAppear(perform: {
            selectedTemp = sharedUserDefaults?.integer(forKey: "Temperature") ?? 0
            selectedMetric = sharedUserDefaults?.integer(forKey: "Units") ?? 0
        })
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
    }
}
