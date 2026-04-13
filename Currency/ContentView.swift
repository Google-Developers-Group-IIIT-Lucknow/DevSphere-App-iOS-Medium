//
//  ContentView.swift
//  Currency
//
//  Created by Prabhnoor Kaur on 12/04/26.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CurrencyViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Live Currency Converter")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color(hex: "1C1E21"))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 60)
                .padding(.bottom, 32)

            TextField("Enter Amount", text: $viewModel.amount)
                .keyboardType(.decimalPad)
                .padding(.horizontal, 16)
                .frame(height: 55)
                .background(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                .padding(.bottom, 24)
                .onChange(of: viewModel.amount) { _ in
                    viewModel.convertCurrentAmount()
                }

            HStack(spacing: 0) {
                TextField("From", text: $viewModel.fromCurrency)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                    .onChange(of: viewModel.fromCurrency) { newValue in
                        Task {
                            await viewModel.fetchExchangeRates(base: newValue)
                        }
                    }

                Text(" TO ")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "1C1E21"))
                    .padding(.horizontal, 8)

                TextField("To", text: $viewModel.toCurrency)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                    .onChange(of: viewModel.toCurrency) { _ in
                        viewModel.convertCurrentAmount()
                    }
            }
            .padding(.bottom, 32)

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 16)
            }

            if let errorText = viewModel.errorMessage {
                Text(errorText)
                    .foregroundColor(Color(hex: "D93025"))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
            }

            Text("Converted Amount: \(viewModel.convertedAmount, format: .number.precision(.fractionLength(2)))")
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
        .task {
            await viewModel.fetchExchangeRates(base: viewModel.fromCurrency)
        }
    }
}

#Preview {
    ContentView()
}