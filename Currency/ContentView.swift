//
//  ContentView.swift
//  Currency
//
//  Created by Prabhnoor Kaur on 12/04/26.
//
import SwiftUI

struct ContentView: View {
    @State private var amount = ""
    @State private var fromCurrency = ""
    @State private var toCurrency = ""
    @State private var showProgress = false
    @State private var statusText = ""
    @State private var showStatus = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Text("Live Currency Converter")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color(hex: "1C1E21"))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 60)
                .padding(.bottom, 32)

            TextField("Enter Amount", text: $amount)
                .keyboardType(.decimalPad)
                .padding(.horizontal, 16)
                .frame(height: 55)
                .background(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                .padding(.bottom, 24)

            HStack(spacing: 0) {
                TextField("From", text: $fromCurrency)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)

                Text(" TO ")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "1C1E21"))
                    .padding(.horizontal, 8)

                TextField("To", text: $toCurrency)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
            }
            .padding(.bottom, 32)

            if showProgress {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 16)
            }

            if showStatus {
                Text(statusText)
                    .foregroundColor(Color(hex: "D93025"))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
            }

            Text("Converted Amount: 0.00")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(hex: "1E8E3E"))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(hex: "F0F2F5"))
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
