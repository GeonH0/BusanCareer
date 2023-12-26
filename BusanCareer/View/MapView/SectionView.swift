//
//  SectionView.swift
//  BusanCareer
//
//  Created by 김건호 on 12/4/23.
//

import SwiftUI

struct SectionView: View {
    var latitude: Double
    var longitude: Double
    
    
    

    var body: some View {
        // 여기에 창에 표시할 내용을 준비하십시오.
        Text("위도: \(latitude), 경도: \(longitude)")
    }
}



