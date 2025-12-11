//
//  LocationPermissionBanner.swift
//  RuckIt
//
//  Created by Shawn Sheehan on 12/11/25.
//
import SwiftUI

struct LocationPermissionBanner: View {
    var body: some View {
        HStack {
            Image(systemName: "location.slash.fill")
                .foregroundStyle(.red)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Location Access Denied")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("Enable in Settings to track activities")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Settings")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

