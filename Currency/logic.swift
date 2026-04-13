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

final class CurrencyViewModel: ObservableObject {
    @Published var amount = ""
    @Published var fromCurrency = "USD"
    @Published var toCurrency = "EUR"
    @Published var convertedAmount: Double = 0.0
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    var rates: [String: Double] = [:]
    

    func fetchExchangeRates(base: String = "USD") async {
        let sourceCurrency = base.isEmpty ? "USD" : base.uppercased()
        guard let url = URL(string: "https://open.er-api.com/v6/latest/\(sourceCurrency)") else {
            errorMessage = "Invalid URL for currency rates. "
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let apiResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
            rates = apiResponse.rates
            fromCurrency = apiResponse.base_code
            convertCurrentAmount()
        } catch {
            errorMessage = errorMessage(from: error)
            convertedAmount = 0.0
            rates = [:]
        }

        isLoading = false
    }

    func convertCurrentAmount() {
        let amountValue = Double(amount) ?? 0.0
        guard amountValue >= 0 else {
            convertedAmount = 0.0
            return
        }

        let sourceCurrency = fromCurrency.isEmpty ? "USD" : fromCurrency.uppercased()
        let targetCurrency = toCurrency.isEmpty ? sourceCurrency : toCurrency.uppercased()

        if sourceCurrency == targetCurrency {
            convertedAmount = amountValue
            return
        }

        guard let rate = rates[targetCurrency] else {
            convertedAmount = 0.0
            return
        }

        convertedAmount = amountValue * rate
    }

    private func errorMessage(from error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return "No internet connection."
            case .timedOut:
                return "Request timed out."
            default:
                return urlError.localizedDescription
            }
        }

        return error.localizedDescription
    }
}
