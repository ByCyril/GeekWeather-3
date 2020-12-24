//
//  LocationHeaderView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/24/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import SwiftUI
import WidgetKit

struct LocationHeader: View {
    
    let location: String
    
    var body: some View {
        HStack {
            Text(location).font(Font.custom("HelveticaNeue-light", size: 17))
        }
    }
}

@available(iOS 14.0, *)
struct LocationHeader_Previews: PreviewProvider {
    static var previews: some View {
        LocationHeader(location: "San Jose, CA").previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
