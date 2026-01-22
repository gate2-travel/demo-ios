<div align="center">

# Gate2 Travel SDK for iOS

**Complete Flight & Hotel Booking Solution**

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
9. [Booking Flows](#9-booking-flows)
10. [Sample Code](#10-sample-code)
11. [Support](#11-support)

---

## 1. Overview

The Gate2 Travel SDK provides complete flight and hotel booking functionality for iPhone applications. Built with SwiftUI and Swift Concurrency, the SDK handles search, pricing, traveler/guest collection, and booking confirmation.

### Capabilities

| Feature | Flights | Hotels |
|---------|---------|--------|
| **Search** | Origin, destination, dates, passengers, class | Location, dates, rooms, guests, nationality |
| **Real-time Pricing** | Current pricing with fare rules | Room rates with cancellation policies |
| **Traveler/Guest Management** | Passenger info & documents | Guest details |
| **Booking Confirmation** | PNR generation | Confirmation number |
| **Custom Theming** | Brand customization with configurable colors | Brand customization with configurable colors |
| **Localization** | English, Russian, Azerbaijani | English, Russian, Azerbaijani |

### What You Handle

The SDK returns an `orderId` (Flights) or confirmation number (Hotels) via `onComplete`. Your app handles payment processing externally using this identifier.

---

## 2. Quick Start

### Step 1: Add Package

In Xcode: **File → Add Package Dependencies** → Enter:
```
https://github.com/gate2travel/Gate2TravelSDK-Distribution.git
```

Select `Gate2TravelSDK` (includes all modules).

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
import Gate2TravelFlights
import Gate2TravelHotels

// Flights
@MainActor
func startFlightBooking(from nav: UINavigationController) {
    let flow = FlightsFlow()
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

// Hotels
@MainActor
func startHotelBooking(from nav: UINavigationController) {
    let flow = HotelsFlow()
    flow.start(
        from: nav,
        onComplete: { confirmationNumber in
            print("Confirmation: \(confirmationNumber)")
        },
        onCancel: {
            nav.popViewController(animated: true)
        }
    )
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

// Target - Option 1: All features
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "Gate2TravelSDK", package: "Gate2TravelSDK-Distribution"),
    ]
)

// Target - Option 2: Individual features
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "Gate2TravelCore", package: "Gate2TravelSDK-Distribution"),
        .product(name: "Gate2TravelFlights", package: "Gate2TravelSDK-Distribution"),
        .product(name: "Gate2TravelHotels", package: "Gate2TravelSDK-Distribution"),
    ]
)
```

### Packages

| Package | Description |
|---------|-------------|
| `Gate2TravelSDK` | Main SDK entry point (includes all modules) |
| `Gate2TravelCore` | Networking, configuration, theming, UI components |
| `Gate2TravelFlights` | Flight search and booking |
| `Gate2TravelHotels` | Hotel search and booking |

---

## 5. Configuration

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `apiKey` | `String` | Yes | Your Gate2Travel API key |
| `theme` | `Theme` | Yes | Theme configuration (use `.default` or custom) |
| `logLevels` | `[G2TLogLevel]` | Yes | Array of log levels to enable |
| `localization` | `SDKLocalizationProvider` | Yes | Localization provider |

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
| `.error` | Failures and exceptions |
| `.warning` | Potential issues |
| `.info` | General information, state changes |
| `.verbose` | Detailed debugging |

Use an empty array `[]` to disable all logging.

---

## 6. Integration

### FlightsFlow

```swift
@MainActor
public final class FlightsFlow {
    public init(localization: FlightsLocalization = DefaultFlightsLocalization())

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

### HotelsFlow

```swift
@MainActor
public final class HotelsFlow {
    public init(localization: HotelsLocalization = DefaultHotelsLocalization())

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
| `onComplete` | Called with confirmation number when booking succeeds |
| `onCancel` | Called when user cancels |

### UIKit Integration

```swift
final class BookingViewController: UIViewController {
    private var flightsFlow: FlightsFlow?
    private var hotelsFlow: HotelsFlow?

    func startFlights() {
        guard let nav = navigationController else { return }
        let flow = FlightsFlow()
        flightsFlow = flow  // Retain the flow
        flow.start(
            from: nav,
            onComplete: { [weak self] orderId in
                self?.handleFlightComplete(orderId)
            },
            onCancel: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        )
    }

    func startHotels() {
        guard let nav = navigationController else { return }
        let flow = HotelsFlow()
        hotelsFlow = flow  // Retain the flow
        flow.start(
            from: nav,
            onComplete: { [weak self] confirmationNumber in
                self?.handleHotelComplete(confirmationNumber)
            },
            onCancel: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        )
    }
}
```

### SwiftUI Integration

The SDK provides ready-to-use SwiftUI views:

```swift
import Gate2TravelFlights
import Gate2TravelHotels

struct ContentView: View {
    @State private var showFlights = false
    @State private var showHotels = false

    var body: some View {
        VStack(spacing: 20) {
            Button("Book Flight") { showFlights = true }
            Button("Book Hotel") { showHotels = true }
        }
        .fullScreenCover(isPresented: $showFlights) {
            FlightsFlowView(
                onComplete: { orderId in
                    showFlights = false
                    // Process payment with orderId
                },
                onCancel: { showFlights = false }
            )
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showHotels) {
            HotelsFlowView(
                onComplete: { confirmationNumber in
                    showHotels = false
                    // Process payment
                },
                onCancel: { showHotels = false }
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
public struct Theme: Sendable {
    public let colors: ThemeColors
    public static let `default`: Theme

    public init(colors: ThemeColors = .default)
}
```

### ThemeColors Properties

| Category | Properties |
|----------|------------|
| **Primary** | `primary`, `primaryVariant`, `primarySubtle` |
| **Secondary** | `secondary`, `secondaryVariant` |
| **Semantic** | `success`, `successSubtle`, `warning`, `warningSubtle`, `error`, `errorSubtle` |
| **Background** | `background`, `backgroundSecondary`, `backgroundTertiary` |
| **Surface** | `surface`, `inputBackground` |
| **Text** | `textPrimary`, `textSecondary`, `textTertiary`, `textDisabled`, `textOnPrimary` |
| **Border** | `border`, `borderSubtle`, `borderFocus` |
| **Icon** | `iconPrimary`, `iconSecondary` |
| **Overlay** | `scrim` |

### Example

```swift
import SwiftUI

let customTheme = Theme(
    colors: ThemeColors(
        primary: .blue,
        primaryVariant: Color(red: 0.1, green: 0.3, blue: 0.8),
        primarySubtle: Color.blue.opacity(0.1),
        secondary: .gray,
        secondaryVariant: Color(white: 0.3),
        success: .green,
        successSubtle: Color.green.opacity(0.1),
        warning: .orange,
        warningSubtle: Color.orange.opacity(0.1),
        error: .red,
        errorSubtle: Color.red.opacity(0.1),
        background: .white,
        backgroundSecondary: Color(white: 0.97),
        backgroundTertiary: Color(white: 0.95),
        surface: .white,
        inputBackground: .white,
        textPrimary: .black,
        textSecondary: .gray,
        textTertiary: Color(white: 0.5),
        textDisabled: Color(white: 0.7),
        textOnPrimary: .white,
        border: Color(white: 0.9),
        borderSubtle: Color(white: 0.95),
        borderFocus: .blue,
        iconPrimary: Color(white: 0.2),
        iconSecondary: Color(white: 0.5),
        scrim: Color.black.opacity(0.5)
    )
)

await Gate2TravelSDK.configure(
    apiKey: "your-api-key",
    theme: customTheme,
    logLevels: [.error],
    localization: DefaultSDKLocalization()
)
```

The default theme automatically adapts to light/dark mode.

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

Implement `SDKLocalizationProvider` with custom localization providers:

```swift
struct MyLocalization: SDKLocalizationProvider {
    let common: CommonLocalization = MyCommonLocalization()
    let flights: FlightsLocalization = MyFlightsLocalization()
}

struct MyCommonLocalization: CommonLocalization {
    var ok: String { "OK" }
    var cancel: String { "Cancel" }
    var error: String { "Error" }
    var loading: String { "Loading..." }
    var retry: String { "Retry" }
    var search: String { "Search" }
    var done: String { "Done" }
    var back: String { "Back" }
    var next: String { "Next" }
    var confirm: String { "Confirm" }
    var errorNoConnection: String { "No internet connection" }
    var errorGeneric: String { "Something went wrong" }
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

### Feature-Specific Localization

You can also provide custom localization directly to each flow:

```swift
let flightsFlow = FlightsFlow(localization: MyFlightsLocalization())
let hotelsFlow = HotelsFlow(localization: MyHotelsLocalization())
```

---

## 9. Booking Flows

### Flights Flow

```
SEARCH → RESULTS → DETAIL → TRAVELERS → REVIEW → CONFIRMATION
                                                       │
                                                       ▼
                                             onComplete(orderId)
```

| Screen | Purpose |
|--------|---------|
| **Search** | Enter origin, destination, dates, passengers, cabin class |
| **Results** | View available flights with sorting options |
| **Detail** | Confirm price, view itinerary and baggage info |
| **Travelers** | Enter passenger information and documents |
| **Review** | Verify all details before booking |
| **Confirmation** | PNR and order confirmation |

### Hotels Flow

```
SEARCH → RESULTS → DETAIL → GUEST DETAILS → CONFIRMATION
                                                  │
                                                  ▼
                                    onComplete(confirmationNumber)
```

| Screen | Purpose |
|--------|---------|
| **Search** | Enter location, dates, rooms, guests, nationality |
| **Results** | View available hotels with sorting/filtering |
| **Detail** | Select room, view amenities, cancellation policy |
| **Guest Details** | Enter guest information and contact details |
| **Confirmation** | Booking confirmation number and details |

---

## 10. Sample Code

### Complete SwiftUI App

```swift
import SwiftUI
import Gate2TravelSDK
import Gate2TravelFlights
import Gate2TravelHotels

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
    @Published var lastBookingId: String?
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showFlights = false
    @State private var showHotels = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Travel App").font(.largeTitle)

            Button("Book Flight") { showFlights = true }
                .buttonStyle(.borderedProminent)

            Button("Book Hotel") { showHotels = true }
                .buttonStyle(.bordered)

            if let bookingId = appState.lastBookingId {
                Text("Last Booking: \(bookingId)").font(.caption)
            }
        }
        .fullScreenCover(isPresented: $showFlights) {
            FlightsFlowView(
                onComplete: { orderId in
                    appState.lastBookingId = orderId
                    showFlights = false
                },
                onCancel: { showFlights = false }
            )
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showHotels) {
            HotelsFlowView(
                onComplete: { confirmationNumber in
                    appState.lastBookingId = confirmationNumber
                    showHotels = false
                },
                onCancel: { showHotels = false }
            )
            .ignoresSafeArea()
        }
    }
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
