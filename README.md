# 📱 DevSphere iOS App (Medium)

> Build a **Currency Converter App** using Swift & SwiftUI by integrating a real-time exchange rate API.

---

## 🚀 Getting Started

### 1️⃣ Fork the Repository
Click on the **Fork** button on the top right of this repository.

### 2️⃣ Clone the Repository

```bash
git clone https://github.com/Google-Developers-Group-IIIT-Lucknow/DevSphere-App-iOS-Medium.git
```

### 3️⃣ Open in Xcode

- Open **Xcode**
- Click on **Open a Project**
- Select the cloned folder

---

## 🧑‍💻 Your Task

Navigate to `logic.swift` and implement the following:

---

### 1. Fetch Exchange Rates (API Integration)

**API Endpoint:**
```
https://open.er-api.com/v6/latest/{BASE_CURRENCY}
```

**Example:**
```
https://open.er-api.com/v6/latest/USD
```

**What to implement:**
- Make an API call using `URLSession`
- Decode the response into `ExchangeRateResponse`
- Store the rates in the `rates` dictionary
- Handle loading state using `isLoading`
- Handle errors using `errorMessage`

---

### 2. Convert Currency

**What to implement:**
- Take the input amount
- Convert from `fromCurrency` to `toCurrency`
- Use the exchange rates fetched from the API

**Formula:**
```
Converted Amount = Amount × (To Currency Rate / From Currency Rate)
```

---

## 📦 API Info

| Property | Value |
|----------|-------|
| Base URL | `https://open.er-api.com` |
| Auth | No API key required |
| Endpoint | `/v6/latest/{BASE_CURRENCY}` |

---

## ✅ Requirements

- [ ] Fetch real-time exchange rates from the API
- [ ] Implement correct conversion logic
- [ ] Handle invalid inputs properly
- [ ] Show loading and error states
- [ ] Keep code clean and readable

---

## ⭐ Important Notes

> ❌ Do **NOT** hardcode exchange rates  
> ✅ Always use live API data  
> 🔄 Ensure conversion updates correctly when inputs change

---

## 📁 Project Structure

```
Currency_Converter/
├── logic.swift          ← Your implementation goes here
├── ContentView.swift
├── Config.swift
└── ...
```

---

## 🤝 Contributing

1. Fork the repository
2. Create your branch: `git checkout -b your-branch-name`
3. Commit your changes: `git commit -m "implement currency converter logic"`
4. Push to the branch: `git push --set-upstream origin your-branch-name`
5. Open a Pull Request

---

*Made with ❤️ for DevSphere by Google Developer Groups IIIT Lucknow*
