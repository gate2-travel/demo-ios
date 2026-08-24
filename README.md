<div align="center">

# Gate2 Travel SDK for iOS

**Complete Flight, Hotel & eSIM Solution**

[![SDK Version](https://img.shields.io/badge/SDK-1.0.0-blue.svg)](https://github.com/gate2-travel/demo-ios)
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
11. [Migration](#11-migration)
12. [Support](#12-support)

---

## 1. Overview

The Gate2 Travel SDK provides complete flight, hotel, and eSIM functionality for iPhone applications. Built with SwiftUI and Swift Concurrency, the SDK handles search, pricing, traveler/guest collection, and booking confirmation.

### Capabilities

| Feature | Flights | Hotels | eSIM |
|---------|---------|--------|------|
| **Search** | Origin, destination, dates, passengers, class | Location, dates, rooms, guests, nationality | Destination country |
| **Results** | Current pricing with fare rules | Room rates with cancellation policies | Data plans with validity |
| **User Info** | Passenger info & documents | Guest details | Email for delivery |
| **Confirmation** | PNR generation | Confirmation number | QR code + direct install |
| **Custom Theming** | Yes | Yes | Yes |
| **Localization** | English, Russian, Azerbaijani | English, Russian, Azerbaijani | English, Russian, Azerbaijani |

### What You Handle

The SDK returns an identifier via `onComplete`:
- **Flights**: `orderId` for payment processing
- **Hotels**: `confirmationNumber` for payment processing
- **eSIM**: `orderId` (eSIM delivered via QR code and email)

---

## 2. Quick Start

### Step 1: Add Package

In Xcode: **File → Add Package Dependencies** → Enter:
```
https://github.com/gate2-travel/demo-ios.git
```

Select `Gate2TravelSDK` (includes all modules).

### Step 2: Configure SDK

```swift
import Gate2TravelSDK

// At app launch
do {
    try Gate2Travel.configure(
        apiKey: "your-api-key",
        sessionId: "user-session-id",
        userId: "user-id"
    )
} catch {
    print("SDK configuration failed: \(error)")
}
```

### Step 3: Start Booking Flow

```swift
import Gate2TravelSDK

// Flights
@MainActor
func startFlightBooking(from nav: UINavigationController) {
    let flow = FlightsFlow()
    flow.start(
        from: nav,
        onComplete: { orderId in print("Order: \(orderId)") },
        onCancel: { nav.popViewController(animated: true) }
    )
}

// Hotels
@MainActor
func startHotelBooking(from nav: UINavigationController) {
    let flow = HotelsFlow()
    flow.start(
        from: nav,
        onComplete: { confirmationNumber in print("Confirmation: \(confirmationNumber)") },
        onCancel: { nav.popViewController(animated: true) }
    )
}

// eSIM
@MainActor
func startESimPurchase(from nav: UINavigationController) {
    let flow = ESimsFlow(
        navigationController: nav,
        onComplete: { orderId in print("eSIM Order: \(orderId)") },
        onFail: { error in print("eSIM error [\(error.code.rawValue)]: \(error.message)") }
    )
    flow.start(onProcessPayment: { orderId in
        // Process payment with your provider, then show the activation screen
        myPaymentProvider.pay(orderId: orderId) { success in
            if success { flow.showOrderResult(orderId: orderId) }
        }
    })
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
        url: "https://github.com/gate2-travel/demo-ios.git",
        from: "1.0.0"
    )
]

// Target
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "Gate2TravelSDK", package: "demo-ios"),
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
| `Gate2TravelESims` | eSIM purchase and installation |

---

## 5. Configuration

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `apiKey` | `String` | Yes | — | Your Gate2Travel API key |
| `sessionId` | `String` | Yes | — | Current user session identifier |
| `userId` | `String` | Yes | — | Current user identifier |
| `theme` | `Theme` | No | `.default` | Theme configuration (use `.default` or custom) |
| `logLevels` | `[G2TLogLevel]` | No | `[]` | Array of log levels to enable |
| `localization` | `SDKLocalizationProvider` | No | `DefaultSDKLocalization()` | Localization provider |
| `language` | `(() -> G2TLanguage)?` | No | `nil` | Closure returning the current language |

### Example

```swift
import Gate2TravelSDK

@main
struct YourApp: App {
    init() {
        do {
            try Gate2Travel.configure(
                apiKey: ProcessInfo.processInfo.environment["GATE2_API_KEY"] ?? "",
                sessionId: "user-session-id",
                userId: "user-id",
                logLevels: [.error, .warning]
            )
        } catch {
            print("SDK configuration failed: \(error)")
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

### ESimsFlow

```swift
@MainActor
public final class ESimsFlow {
    public init(
        navigationController: UINavigationController,
        onComplete: @escaping (String) -> Void,
        onFail: @escaping (ESimFlowError) -> Void,
        localization: ESimsLocalization = DefaultESimsLocalization()
    )

    /// Browse and buy: destination → plans → detail → your payment → activation.
    public func start(onProcessPayment: @escaping (String) -> Void)

    /// The user's purchased eSIMs, opened directly. Requires `userId` at configure time.
    public func showMyESims(onProcessPayment: @escaping (String) -> Void)

    /// Activation details for an order. Call after your payment provider confirms.
    public func showOrderResult(orderId: String)
}
```

The navigation controller and the `onComplete` / `onFail` callbacks are supplied
once, at init. Each entry point then takes only what is specific to it.

| Parameter | Description |
|-----------|-------------|
| `navigationController` | UINavigationController the SDK pushes its screens onto |
| `onComplete` | Called with the order ID when the user finishes on the activation screen |
| `onFail` | Called with an `ESimFlowError` on a non-recoverable failure |
| `onProcessPayment` | Called with the order ID when the SDK needs you to take payment. Process it, then call `showOrderResult(orderId:)`. |
| `localization` | Optional custom translations — see [Localization](#8-localization) |

> Create a new `ESimsFlow` per entry. The flow retains itself while running, so you
> do not need to hold a reference. Calling a second entry point on the same instance
> abandons the first.

#### Entry Points

The SDK is not limited to the full purchase flow — you can open it from wherever it
fits your app.

| Entry point | Opens at | Use it for |
|-------------|----------|------------|
| `start(onProcessPayment:)` | Destination selection | A "Buy an eSIM" button on your home or travel screen |
| `showMyESims(onProcessPayment:)` | My eSIMs list | An "eSIMs" row in your own orders, wallet, or profile tab |
| `showOrderResult(orderId:)` | Activation details | Returning from payment, or reopening an order from your order history |

#### My eSIMs

Opens the user's purchased eSIMs directly, skipping browse-and-buy. Each eSIM shows
its QR code, activation details, and remaining data.

```swift
let flow = ESimsFlow(
    navigationController: navigationController,
    onComplete: { orderId in print("Done: \(orderId)") },
    onFail: { error in showError(error.message) }
)

flow.showMyESims(onProcessPayment: { orderId in
    // Only fires if the user tops up an existing eSIM.
    myPaymentProvider.pay(orderId: orderId) { success in
        if success { flow.showOrderResult(orderId: orderId) }
    }
})
```

**Requires a `userId`.** Order history is per-user, so pass `userId` to
`Gate2Travel.configure(...)` before calling this. If it is missing or blank, nothing
is pushed and `onFail` reports `ESimErrorCode.userIdRequired` — it will not crash
your app, but the screen will not open either.

**Top-up.** Active eSIMs show a "Top up" button, which pushes the plans list and
creates a real add-on order — this is why `onProcessPayment` is required here, even
though the screen is mostly a listing. If the user has not yet accepted the terms,
the SDK shows them before the plans list.

### ESimsAvailability

Decide whether to show an eSIM entry point at all. Neither member presents a screen
or performs a network request.

```swift
public enum ESimsAvailability {
    /// The SDK is configured and the eSIM feature can be started.
    public static var isAvailable: Bool { get }

    /// This device's hardware supports eSIM provisioning.
    public static var isDeviceESimCapable: Bool { get }
}
```

```swift
if ESimsAvailability.isAvailable && ESimsAvailability.isDeviceESimCapable {
    showESimTile()
}
```

> `isDeviceESimCapable` is always `false` on the Simulator, which has no eUICC. Test
> device gating on hardware.

### UIKit Integration

```swift
final class BookingViewController: UIViewController {
    private var flightsFlow: FlightsFlow?
    private var hotelsFlow: HotelsFlow?
    private var esimFlow: ESimsFlow?

    func startFlights() {
        guard let nav = navigationController else { return }
        let flow = FlightsFlow()
        flightsFlow = flow
        flow.start(from: nav, onComplete: { [weak self] orderId in
            self?.handleComplete(orderId)
        }, onCancel: { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        })
    }

    func startHotels() {
        guard let nav = navigationController else { return }
        let flow = HotelsFlow()
        hotelsFlow = flow
        flow.start(from: nav, onComplete: { [weak self] confirmationNumber in
            self?.handleComplete(confirmationNumber)
        }, onCancel: { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        })
    }

    func startESim() {
        guard let nav = navigationController else { return }
        let flow = ESimsFlow(
            navigationController: nav,
            onComplete: { [weak self] orderId in self?.handleComplete(orderId) },
            onFail: { [weak self] error in self?.showError(error.message) }
        )
        esimFlow = flow
        flow.start(onProcessPayment: { orderId in
            PaymentService.processPayment(orderId: orderId) { success in
                if success { flow.showOrderResult(orderId: orderId) }
            }
        })
    }

    /// Opens eSIM history straight from your own orders tab.
    func showMyESims() {
        guard let nav = navigationController else { return }
        let flow = ESimsFlow(
            navigationController: nav,
            onComplete: { [weak self] orderId in self?.handleComplete(orderId) },
            onFail: { [weak self] error in self?.showError(error.message) }
        )
        esimFlow = flow
        flow.showMyESims(onProcessPayment: { orderId in
            PaymentService.processPayment(orderId: orderId) { success in
                if success { flow.showOrderResult(orderId: orderId) }
            }
        })
    }
}
```

### SwiftUI Integration

The SDK provides ready-to-use SwiftUI views:

```swift
import Gate2TravelSDK

struct ContentView: View {
    @State private var showFlights = false
    @State private var showHotels = false
    @State private var showESim = false

    var body: some View {
        VStack(spacing: 20) {
            Button("Book Flight") { showFlights = true }
            Button("Book Hotel") { showHotels = true }
            Button("Buy eSIM") { showESim = true }
        }
        .fullScreenCover(isPresented: $showFlights) {
            FlightsFlowView(
                onComplete: { orderId in showFlights = false },
                onCancel: { showFlights = false }
            ).ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showHotels) {
            HotelsFlowView(
                onComplete: { confirmationNumber in showHotels = false },
                onCancel: { showHotels = false }
            ).ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showESim) {
            ESimsFlowView(
                onComplete: { orderId in showESim = false },
                onProcessPayment: { orderId in
                    PaymentService.processPayment(orderId: orderId) { _ in }
                },
                onFail: { error in showESim = false }
            ).ignoresSafeArea()
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

do {
    try Gate2Travel.configure(
        apiKey: "your-api-key",
        sessionId: "user-session-id",
        userId: "user-id",
        theme: customTheme
    )
} catch {
    print("SDK configuration failed: \(error)")
}
```

The default theme automatically adapts to light/dark mode.

---

## 8. Localization

The SDK includes built-in support for English, Russian, and Azerbaijani through String Catalogs.

### Default Localization

```swift
do {
    try Gate2Travel.configure(
        apiKey: "your-api-key",
        sessionId: "user-session-id",
        userId: "user-id"
    )
} catch {
    print("SDK configuration failed: \(error)")
}
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

do {
    try Gate2Travel.configure(
        apiKey: "your-api-key",
        sessionId: "user-session-id",
        userId: "user-id",
        localization: MyLocalization()
    )
} catch {
    print("SDK configuration failed: \(error)")
}
```

### Feature-Specific Localization

You can also provide custom localization directly to each flow:

```swift
let flightsFlow = FlightsFlow(localization: MyFlightsLocalization())
let hotelsFlow = HotelsFlow(localization: MyHotelsLocalization())
let esimFlow = ESimsFlow(
    navigationController: nav,
    onComplete: { _ in },
    onFail: { _ in },
    localization: MyESimsLocalization()
)
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

### eSIM Flow

The SDK never collects card details. It creates the order, hands you the order ID,
and waits for you to call `showOrderResult(orderId:)`.

```
start(onProcessPayment:)

  WELCOME → DESTINATION → PLANS → DETAIL
  (first run)                       │
                                    ▼
                          onProcessPayment(orderId)   ← you take payment here
                                    │
                                    ▼
                        showOrderResult(orderId:)
                                    │
                                 RESULT
                                    │
                                    ▼
                          onComplete(orderId)


showMyESims(onProcessPayment:)

  MY ESIMS → ESIM DETAIL ──"Top up"──▶ PLANS → DETAIL → onProcessPayment(orderId)
```

| Screen | Purpose |
|--------|---------|
| **Welcome** | Terms and introduction. Shown once, before the first purchase. |
| **Destination** | Select country or region for eSIM coverage |
| **Plans** | Browse data plans — data amount, validity, price, and any discount |
| **Detail** | Coverage, features, device compatibility, and the buy action |
| **Result** | QR code for installation + direct install option (iOS 17.4+) |
| **My eSIMs** | Purchased eSIMs, with data usage and status |
| **eSIM Detail** | Activation details, install steps, and top-up |

#### Discounted Pricing

When the backend returns a discounted price for a plan, the plan card and the plan
detail header show the pre-discount price struck through next to the price the user
actually pays, plus a badge with the percentage off. The Buy Now button shows only
the payable price.

This is automatic — there is nothing to enable, and the order is created at the
discounted price.

---

## 10. Sample Code

### Complete SwiftUI App

```swift
import SwiftUI
import Gate2TravelSDK

@main
struct TravelApp: App {
    @StateObject private var appState = AppState()

    init() {
        do {
            try Gate2Travel.configure(
                apiKey: ProcessInfo.processInfo.environment["GATE2_API_KEY"] ?? "",
                sessionId: "user-session-id",
                userId: "user-id",
                logLevels: [.error]
            )
            appState.isReady = true
        } catch {
            print("SDK configuration failed: \(error)")
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
    @State private var showESim = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Travel App").font(.largeTitle)

            Button("Book Flight") { showFlights = true }
                .buttonStyle(.borderedProminent)

            Button("Book Hotel") { showHotels = true }
                .buttonStyle(.bordered)

            Button("Buy eSIM") { showESim = true }
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
            ).ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showHotels) {
            HotelsFlowView(
                onComplete: { confirmationNumber in
                    appState.lastBookingId = confirmationNumber
                    showHotels = false
                },
                onCancel: { showHotels = false }
            ).ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showESim) {
            ESimsFlowView(
                onComplete: { orderId in
                    appState.lastBookingId = orderId
                    showESim = false
                },
                onProcessPayment: { orderId, completion in
                    PaymentService.processPayment(orderId: orderId) { success in
                        completion(success)
                    }
                }
            ).ignoresSafeArea()
        }
    }
}
```

---

## 11. Migration

### Upgrading to 1.8.0

Most apps need no changes. Two items are source-breaking in narrow cases.

#### `ESimErrorCode` has a new case

`userIdRequired` was added, reported when `showMyESims` is called without a
`userId`. If you `switch` over `ESimErrorCode` and cover every case with no
`default`, your switch is no longer exhaustive and will not compile:

```swift
// Before — compiled against 1.7.0, fails on 1.8.0
switch error.code {
case .networkError: …
case .unknown: …
}

// After — add @unknown default, and future cases will never break you again
switch error.code {
case .networkError: …
case .unknown: …
@unknown default: reportUnexpected(error)
}
```

You are unaffected if you read `error.message`, read `error.code.rawValue`,
compare with `==`, or already use `default` / `@unknown default`.

#### `ConfirmOrderResponseDTO.amount` is now `Decimal?`

It was `Double?`. This only affects code using `@_spi(Gate2Internal) import
Gate2TravelCore` and reading `.amount` — the internal surface, not the supported
API. Monetary values are `Decimal` throughout the SDK so prices survive decoding
exactly; `Double` cannot represent most decimal amounts (`2040.88` becomes
`2040.8800000000000512`).

#### Custom localization: three new strings

If you implement `ESimsLocalization` yourself, three members were added for
discounted pricing. They have English defaults, so **your code still compiles**
— but it will ship untranslated English until you override them:

| Member | English default |
|--------|-----------------|
| `plansDiscountBadge(_:)` | `20% discount` |
| `accessibilityDiscountOriginalPrice(_:)` | `Was ₼4.40` |
| `accessibilityDiscountPercent(_:)` | `20% off` |

### New in 1.8.0

- `ESimsFlow.showMyESims(onProcessPayment:)` — open purchased eSIMs directly
- `ESimsAvailability` — check SDK and device eSIM support before showing an entry point
- Discounted pricing on plan cards and plan detail, applied automatically

---

## 12. Support

| Resource | Link |
|----------|------|
| GitHub Issues | [github.com/gate2-travel/demo-ios](https://github.com/gate2-travel/demo-ios) |
| Email | sdk-support@gate2.travel |
| Developer Portal | [developers.gate2.travel](https://developers.gate2.travel) |

---

<div align="center">

**Gate2 Travel SDK** • iOS 15.0+ • Swift 5.9+

© 2025 Gate2 Travel

</div>
