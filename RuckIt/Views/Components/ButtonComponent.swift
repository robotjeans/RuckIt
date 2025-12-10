//
//  ButtonComponent.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/10/25.
//
import SwiftUI

struct PrimaryButton: View {
let title: String
var isFilled: Bool = true


var body: some View {
Text(title)
.font(.headline)
.foregroundColor(isFilled ? .white : Color("DarkOrange"))
.frame(maxWidth: .infinity)
.padding()
.background(isFilled ? Color("DarkOrange") : Color.white)
.overlay(
RoundedRectangle(cornerRadius: 12)
.stroke(Color("DarkOrange"), lineWidth: isFilled ? 0 : 2)
)
.cornerRadius(12)
.shadow(radius: 2)
}
}
