//
//  logic.swift
//  Currency
//
//  Created by Prabhnoor Kaur on 12/04/26.
//

import Foundation

struct ExchangeRateResponse: Codable {
    let result: String
    let base_code: String
    let rates: [String: Double]
}

@MainActor
final class CurrencyViewModel: ObservableObject {
    @Published var amount = ""
    @Published var fromCurrency = "USD"
    @Published var toCurrency = "EUR"
    @Published var convertedAmount: Double = 0.0
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    var rates: [String: Double] = [:]

    func fetchExchangeRates(base: String = "USD") async {
        let normalizedBase = base.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard let url = URL(string: "https://open.er-api.com/v6/latest/\(normalizedBase)") else {
            errorMessage = "Invalid base currency."
            rates = [:]
            convertedAmount = 0.0
            return
        }
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                errorMessage = "Unable to load exchange rates right now."
                rates = [:]
                convertedAmount = 0.0
                return
            }
            let decodedResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
            guard decodedResponse.result.lowercased() == "success" else {
                errorMessage = "Exchange rate service returned an invalid response."
                rates = [:]
                convertedAmount = 0.0
                return
            }
            var fetchedRates = decodedResponse.rates
            fetchedRates[decodedResponse.base_code.uppercased()] = 1.0
            rates = fetchedRates
            fromCurrency = fromCurrency.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            toCurrency = toCurrency.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            convertCurrentAmount()
        }catch {
            errorMessage = "Failed to decode exchange rates."
        }
    }
    func convertCurrentAmount() {
        let trimmedAmount = amount.trimmingCharacters(in: .whitespacesAndNewlines)
        let sourceCurrency = fromCurrency.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let destinationCurrency = toCurrency.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        guard !trimmedAmount.isEmpty,
              let inputAmount = Double(trimmedAmount),
              inputAmount.isFinite,
              inputAmount >= 0 else {
            convertedAmount = 0.0
            return
        }
        guard let fromRate = rates[sourceCurrency],
              let toRate = rates[destinationCurrency],
              fromRate > 0,
              toRate > 0 else {
            convertedAmount = 0.0
            return
        }
        convertedAmount = inputAmount * (toRate / fromRate)
    }
}
