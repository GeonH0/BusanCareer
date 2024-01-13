//
//  SectionView.swift
//  BusanCareer
//
//  Created by 김건호 on 12/4/23.
//

import SwiftUI

struct SectionView: View {
    var section: Section
    
    var body: some View {
        VStack {
            Text("지역: \(section.sectionTitle)")
            Text("위도: \(section.latitude), 경도: \(section.longitude)")
            Text("\(section.items.count)")
            
        }
    }
}





