//
//  StatDisplay.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI

struct StatDisplay: View {
let label: String
let value: String


var body: some View {
VStack {
Text(label)
.font(.caption)
.foregroundColor(.gray)
Text(value)
.font(.headline)
.foregroundColor(Color("DarkOrange"))
}
}
}
