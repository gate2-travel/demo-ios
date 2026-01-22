<div align="center">

# Gate2 Travel SDK for iOS

**Complete Flight Booking Solution**

[![SDK Version](https://img.shields.io/badge/SDK-1.0.0-blue.svg)](https://github.com/gate2travel/Gate2TravelSDK-Distribution)
[![iOS](https://img.shields.io/badge/iOS-15.0+-orange.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9+-purple.svg)](https://swift.org)

</div>

---

## Table of Contents

1. [Overview](#1-overview)
2. [Quick Start](#2-quick-start)
3. [Requirements](#3-requirements)
4. [Installation](#4-installation)
5. [Configuration](#5-configuration)
6. [Integration](#6-integration)
7. [Theming](#7-theming)
8. [Localization](#8-localization)
9. [Booking Flow](#9-booking-flow)
10. [Sample Code](#10-sample-code)
11. [Support](#11-support)

---

## 1. Overview

The Gate2 Travel SDK provides complete flight booking functionality for iPhone applications. Built with SwiftUI and Swift Concurrency, the SDK handles search, pricing, traveler collection, and booking confirmation.

### Capabilities

| Feature | Description |
|---------|-------------|
| **Flight Search** | Search by origin, destination, dates, passengers, travel class |
| **Real-time Pricing** | Current pricing with fare rules before booking |
| **Traveler Management** | Collect and validate passenger information |
| **Booking Confirmation** | PNR generation and confirmation details |
| **Custom Theming** | Brand customization with configurable colors |
| **Localization** | English, Russian, Azerbaijani |

### What You Handle

The SDK returns an `orderId` via `onComplete`. Your app handles payment processing externally using this order ID.

---

## 2. Quick Start

### Step 1: Add Package

In Xcode: **File → Add Package Dependencies** → Enter:
```
https://github.com/gate2travel/Gate2TravelSDK-Distribution.git
```

Select `Gate2TravelCore` and `Gate2TravelFlights`.

### Step 2: Configure SDK

```swift
import Gate2TravelSDK

// At app launch
Task {
    await Gate2TravelSDK.configure(
        apiKey: "your-api-key",
        theme: .default,
        logLevels: [.error],
        localization: DefaultSDKLocalization()
    )
}
```

### Step 3: Start Booking Flow

```swift
import Gate2TravelCore
import Gate2TravelFlights

func startBooking(from nav: UINavigationController) {
    Task { @MainActor in
        let flow = await FlightsFlow()
        flow.start(
            from: nav,
            onComplete: { orderId in
                print("Order: \(orderId)")
                // Process payment with orderId
            },
            onCancel: {
                nav.popViewController(animated: true)
            }
        )
    }
}
```

---

## 3. Requirements

| Requirement | Version |
|-------------|---------|
| iOS | 15.0+ |
| Swift | 5.9+ |
| Xcode | 15.0+ |
| Device | iPhone |
| Orientation | Portrait |
| Network | Internet required |

The SDK uses `UINavigationController` for navigation (NavigationStack requires iOS 16+).

### Partner Site Payment Service

> ⚠️ **Partner Requirement**
>  
> This step **must be completed by our partner** before integration can continue.

#### Overview
The Partner Site Payment Service is used to initiate a payment request in the bank’s core system.  
It validates the input and returns a response indicating whether the payment was successfully generated.

---

#### API Endpoint

*POST* ⁠ /api/v1/core-payment ⁠

---

#### Request Headers

| Header | Description |
|------|------------|
| Content-Type | ⁠ application/json ⁠ |
| Authorization | ⁠ Bearer <access_token> ⁠ (if required) |

---

#### Request Body

##### Parameters

| Field | Type | Required | Description |
|------|------|----------|-------------|
| currency | string | Yes | ISO 4217 currency code (e.g., USD, EUR, INR) |
| amount | number | Yes | Payment amount (must be greater than 0) |
| orderId | string | Yes | Unique order or transaction identifier |

---

##### Example Request


```json 
{
  "currency": "USD",
  "amount": 100.50,
  "orderId": "ORD-20260113-001"
}
```
##### Example Response


```json
{
  "success": true,
  "amount": “Operation successful"
}
```
---

## 4. Installation

### Swift Package Manager

```swift
// Package.swift
dependencies: [
    .package(
        url: "https://github.com/gate2travel/Gate2TravelSDK-Distribution.git",
        from: "1.0.0"
    )
]

// Target
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "Gate2TravelCore", package: "Gate2TravelSDK-Distribution"),
        .product(name: "Gate2TravelFlights", package: "Gate2TravelSDK-Distribution"),
    ]
)
```

### Packages

| Package | Description |
|---------|-------------|
| `Gate2TravelCore` | Networking, configuration, theming, localization |
| `Gate2TravelFlights` | Flight booking feature |

---

## 5. Configuration

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `apiKey` | `String` | Yes | Your Gate2Travel API key |
| `theme` | `Theme` | No | Custom theme (default: `.default`) |
| `logLevels` | `[G2TLogLevel]` | No | Log levels (default: `[.error]`) |
| `localization` | `SDKLocalizationProvider` | No | Localization provider |

### Example

```swift
import Gate2TravelSDK

@main
struct YourApp: App {
    init() {
        Task {
            await Gate2TravelSDK.configure(
                apiKey: ProcessInfo.processInfo.environment["GATE2_API_KEY"] ?? "",
                theme: .default,
                logLevels: [.error, .warning],
                localization: DefaultSDKLocalization()
            )
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### Log Levels

| Level | Description |
|-------|-------------|
| `.error` | Only errors |
| `.warning` | Errors and warnings |
| `.info` | General information |
| `.verbose` | Detailed debugging |

---

## 6. Integration

### FlightsFlow

```swift
@MainActor
public final class FlightsFlow {
    public init() async

    public func start(
        from navigationController: UINavigationController,
        onComplete: @escaping (String) -> Void,
        onCancel: @escaping () -> Void
    )
}
```

| Parameter | Description |
|-----------|-------------|
| `navigationController` | UINavigationController to present the flow |
| `onComplete` | Called with order ID when booking succeeds |
| `onCancel` | Called when user cancels |

### UIKit

```swift
func presentBooking(from nav: UINavigationController) {
    Task { @MainActor in
        let flow = await FlightsFlow()
        flow.start(
            from: nav,
            onComplete: { orderId in
                // Navigate to payment
            },
            onCancel: {
                nav.popViewController(animated: true)
            }
        )
    }
}
```

### SwiftUI

```swift
struct FlightsFlowContainer: UIViewControllerRepresentable {
    let onComplete: (String) -> Void
    let onCancel: () -> Void

    func makeUIViewController(context: Context) -> UINavigationController {
        let nav = UINavigationController()
        Task { @MainActor in
            let flow = await FlightsFlow()
            flow.start(from: nav, onComplete: onComplete, onCancel: onCancel)
        }
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

// Usage
struct ContentView: View {
    @State private var showBooking = false

    var body: some View {
        Button("Book Flight") { showBooking = true }
        .fullScreenCover(isPresented: $showBooking) {
            FlightsFlowContainer(
                onComplete: { orderId in
                    showBooking = false
                    // Process payment
                },
                onCancel: { showBooking = false }
            )
            .ignoresSafeArea()
        }
    }
}
```

---

## 7. Theming

### Structure

```swift
public struct Theme {
    public let colors: ThemeColors
    public static let `default`: Theme
}

public struct ThemeColors {
    public let primary: Color        // Buttons, headers
    public let secondary: Color      // Accents
    public let background: Color     // Screen background
    public let surface: Color        // Cards
    public let error: Color          // Error states
    public let onPrimary: Color      // Text on primary
    public let onSecondary: Color    // Text on secondary
    public let onBackground: Color   // Text on background
    public let onSurface: Color      // Text on surface
}
```

### Example

```swift
let theme = Theme(
    colors: ThemeColors(
        primary: .blue,
        secondary: .green,
        background: .white,
        surface: Color(white: 0.97),
        error: .red,
        onPrimary: .white,
        onSecondary: .white,
        onBackground: .black,
        onSurface: .gray
    )
)

await Gate2TravelSDK.configure(
    apiKey: "your-api-key",
    theme: theme,
    logLevels: [.error],
    localization: DefaultSDKLocalization()
)
```

---

## 8. Localization

The SDK includes built-in support for English, Russian, and Azerbaijani through String Catalogs.

### Default Localization

```swift
await Gate2TravelSDK.configure(
    apiKey: "your-api-key",
    theme: .default,
    logLevels: [.error],
    localization: DefaultSDKLocalization()
)
```

### Custom Translations

Implement `SDKLocalizationProvider` with custom `CommonLocalization` and `FlightsLocalization`:

```swift
struct MyLocalization: SDKLocalizationProvider {
    let common: CommonLocalization = MyCommonLocalization()
    let flights: FlightsLocalization = MyFlightsLocalization()
}

struct MyFlightsLocalization: FlightsLocalization {
    var searchTitle: String { "Find Flights" }
    var searchFrom: String { "From" }
    var searchTo: String { "To" }
    // ... implement all required properties
}

await Gate2TravelSDK.configure(
    apiKey: "your-api-key",
    theme: .default,
    logLevels: [.error],
    localization: MyLocalization()
)
```

---

## 9. Booking Flow

The SDK implements a 5-screen flow:

```
SEARCH → DETAIL → TRAVELERS → REVIEW → CONFIRMATION
                                            │
                                            ▼
                                  onComplete(orderId)
```

### Screens

| Screen | Purpose |
|--------|---------|
| **Search** | Enter origin, destination, dates, passengers, class |
| **Detail** | Confirm price and availability |
| **Travelers** | Enter passenger information |
| **Review** | Verify all details before booking |
| **Confirmation** | PNR and order confirmation |

After confirmation, `onComplete(orderId)` is called. Use the order ID for payment processing.

---

## 10. Sample Code

### Complete SwiftUI App

```swift
import SwiftUI
import Gate2TravelSDK
import Gate2TravelCore
import Gate2TravelFlights

@main
struct TravelApp: App {
    @StateObject private var appState = AppState()

    init() {
        Task { @MainActor in
            await Gate2TravelSDK.configure(
                apiKey: ProcessInfo.processInfo.environment["GATE2_API_KEY"] ?? "",
                theme: .default,
                logLevels: [.error],
                localization: DefaultSDKLocalization()
            )
            appState.isReady = true
        }
    }

    var body: some Scene {
        WindowGroup {
            if appState.isReady {
                ContentView().environmentObject(appState)
            } else {
                ProgressView("Loading...")
            }
        }
    }
}

final class AppState: ObservableObject {
    @Published var isReady = false
    @Published var orderId: String?
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showBooking = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Travel App").font(.largeTitle)

            Button("Book Flight") { showBooking = true }
                .buttonStyle(.borderedProminent)

            if let orderId = appState.orderId {
                Text("Order: \(orderId)").font(.caption)
            }
        }
        .fullScreenCover(isPresented: $showBooking) {
            FlightsFlowContainer(
                onComplete: { orderId in
                    appState.orderId = orderId
                    showBooking = false
                },
                onCancel: { showBooking = false }
            )
            .ignoresSafeArea()
        }
    }
}

struct FlightsFlowContainer: UIViewControllerRepresentable {
    let onComplete: (String) -> Void
    let onCancel: () -> Void

    func makeUIViewController(context: Context) -> UINavigationController {
        let nav = UINavigationController()
        Task { @MainActor in
            let flow = await FlightsFlow()
            flow.start(from: nav, onComplete: onComplete, onCancel: onCancel)
        }
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
```

---

## 11. Support

| Resource | Link |
|----------|------|
| GitHub Issues | [github.com/gate2travel/Gate2TravelSDK-Distribution](https://github.com/gate2travel/Gate2TravelSDK-Distribution) |
| Email | sdk-support@gate2.travel |
| Developer Portal | [developers.gate2.travel](https://developers.gate2.travel) |

---

<div align="center">

**Gate2 Travel SDK** • iOS 15.0+ • Swift 5.9+

© 2025 Gate2 Travel

</div>
