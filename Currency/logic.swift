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
    let conversion_rates: [String: Double]
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
        // TODO: Initialize and perform the API request for live exchange rates.
        // TODO: Decode the response into ExchangeRateResponse and update `rates`.
        // TODO: Update `isLoading`, `errorMessage`, and recalculate converted amount.
    }

    func convertCurrentAmount() {
        // TODO: Convert the current `amount` from `fromCurrency` to `toCurrency`
        // using the rates loaded from the API.
        convertedAmount = 0.0
    }
}
