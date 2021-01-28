//
//  AlertList.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/26/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI

struct AlertDetails: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var alert: Alert
    
    var body: some View {
        VStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Text("Back")
                    Spacer()
                }.padding()
            })
            
            Text(alert.event)
            Text(alert.start.convertTime())
            Text(alert.description)
        }.background(LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .topLeading, endPoint: .bottomTrailing)).foregroundColor(.white).cornerRadius(25).shadow(radius: 5).navigationBarBackButtonHidden(true)
    }
}

struct AlertItem: View {
    
    var alert: Alert
    
    var body: some View {
        HStack {
            VStack {
                Text(alert.event)
                    .font(Font.custom("AvenirNext-Bold", size: 21))
                    .minimumScaleFactor(0.5)
                    .allowsTightening(true)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
                
                HStack {
                    Text(alert.start.date(.truncFullDate))
                    Text("-")
                    Text(alert.end.date(.truncFullDate))
                }
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.white)
        }
    }
}

struct AlertList: View {
    var dismissAction: (() -> Void)
    var alerts: [Alert]
    
    @State var selectedItem: Int = -1
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Alerts")
                        .font(Font.custom("AvenirNext-Bold", size: 30))
                        .minimumScaleFactor(0.5)
                        .allowsTightening(true)
                        .lineLimit(1)
                        .foregroundColor(Color.white)
                    Spacer()
                    Button(action: {
                        self.dismissAction()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                            .padding(.trailing)
                    })
                }.padding(.top).padding(.leading)
                
                ForEach(0..<alerts.count) { i in
                    HStack {
                        VStack(alignment: .leading) {
                            
                            AlertItem(alert: alerts[i])
                            if selectedItem == i {
                                Spacer()
                                Text(alerts[i].description)
                                    .font(Font.custom("AvenirNext-Medium", size: 17))
                                    .foregroundColor(Color.white)
                                    .transition(.asymmetric(insertion: AnyTransition.opacity.combined(with: .slide), removal: AnyTransition.opacity.combined(with: .slide)))
                                
                            }
                            
                        }
                        
                    }.padding().onTapGesture {
                        withAnimation {
                            if self.selectedItem == i {
                                self.selectedItem = -1
                            } else {
                                self.selectedItem = i
                            }
                        }
                    }
                }
            }
        }.background(LinearGradient(gradient: Gradient(colors: [Color("System-GradientTopColor"),Color("System-GradientBottomColor")]), startPoint: .topLeading, endPoint: .bottomTrailing)).foregroundColor(.white).cornerRadius(25).shadow(radius: 5)
    }
}

struct AlertContainer: View {
    var alerts: [Alert]
    
    var dismissAction: (() -> Void)
    
    @State var offset: CGFloat = 1000
    
    var body: some View {
        AlertList(dismissAction: dismissAction, alerts: alerts).padding().offset(x: 0, y: self.offset).onAppear {
            withAnimation(.interactiveSpring()) {
                self.offset = 0
            }
        }
    }
}

struct AlertList_Previews: PreviewProvider {
    static var previews: some View {
        AlertContainer(alerts: Mocks.mock().alerts!, dismissAction: {
            
        })
    }
}
