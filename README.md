<div align="center">

# Gate2 Travel SDK for iOS

**eSIM purchase and activation for your app**

[![SDK Version](https://img.shields.io/badge/SDK-1.9.0-blue.svg)](https://github.com/gate2-travel/demo-ios/releases)
[![iOS](https://img.shields.io/badge/iOS-15.0+-orange.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-6.2+-purple.svg)](https://swift.org)

</div>

---

## Table of Contents

1. [Overview](#1-overview)
2. [Quick Start](#2-quick-start)
3. [Requirements](#3-requirements)
4. [Installation](#4-installation)
5. [Configuration](#5-configuration)
6. [Integration](#6-integration)
7. [Appearance](#7-appearance)
8. [Localization](#8-localization)
9. [eSIM Flow](#9-esim-flow)
10. [Sample Code](#10-sample-code)
11. [Migration](#11-migration)
12. [Support](#12-support)

---

## 1. Overview

The Gate2 Travel SDK adds a complete eSIM store to your iPhone app. Built with SwiftUI and
Swift Concurrency, it handles destination search, data plans, order creation, activation,
and the user's purchased eSIMs. You keep control of payment.

### Capabilities

| Area | What the SDK does |
|------|-------------------|
| **Search** | Destination country or region, with promotional banners from your merchant settings |
| **Plans** | Data plans with validity, price, filters, and discounted prices |
| **Purchase** | Creates the order and hands you the order ID to take payment |
| **Activation** | QR code + direct install (iOS 17.4+) |
| **My eSIMs** | Purchased eSIMs with data usage, activation details, and top-up |
| **Localization** | English, Russian, Azerbaijani |

### What You Handle

- **Payment.** The SDK never collects card details. It calls `onProcessPayment(orderId)`;
  you take payment with your own provider and then show the activation screen.
- **The result.** `onComplete(orderId)` fires when the user finishes on the activation
  screen. The eSIM itself is installed in-app via QR code or direct install.

---

## 2. Quick Start

### Step 1: Add Package

In Xcode: **File → Add Package Dependencies** → Enter:
```
https://github.com/gate2-travel/demo-ios.git
```

Select the `Gate2TravelSDK` product.

### Step 2: Configure SDK

```swift
import Gate2TravelSDK

// At app launch
do {
    try Gate2Travel.configure(
        apiKey: "your-api-key",
        environment: .production,
        sessionId: "user-session-id",
        userId: "user-id"
    )
} catch {
    print("SDK configuration failed: \(error)")
}
```

### Step 3: Start the eSIM Flow

```swift
import Gate2TravelSDK

final class HomeViewController: UIViewController {
    private var esimFlow: ESimsFlow?

    func startESimPurchase() {
        guard let nav = navigationController else { return }
        let flow = ESimsFlow(
            navigationController: nav,
            onComplete: { orderId in print("eSIM Order: \(orderId)") },
            onFail: { error in print("eSIM error [\(error.code.rawValue)]: \(error.message)") }
        )
        esimFlow = flow
        flow.start(onProcessPayment: { orderId in
            // Process payment with your provider, then show the activation screen
            myPaymentProvider.pay(orderId: orderId) { success in
                Task { @MainActor in
                    if success { flow.showOrderResult(orderId: orderId) }
                }
            }
        })
    }
}
```

---

## 3. Requirements

| Requirement | Version |
|-------------|---------|
| iOS | 15.0+ |
| Xcode | 26.2+ (the toolchain releases are built and tested with) |
| Swift | 6.2+ |
| Device | iPhone |
| Orientation | Portrait |
| Network | Internet required |

The SDK uses `UINavigationController` for navigation (NavigationStack requires iOS 16+).

### Partner Site Payment Service

> ⚠️ **Partner Requirement**
>
> This step **must be completed by our partner** before integration can continue.

#### Overview
The Partner Site Payment Service is used to initiate a payment request in the bank's core system.
It validates the input and returns a response indicating whether the payment was successfully generated.

---

#### API Endpoint

**POST** `/api/v1/core-payment`

---

#### Request Headers

| Header | Description |
|------|------------|
| Content-Type | `application/json` |
| Authorization | `Bearer <access_token>` (if required) |

---

#### Request Body

##### Parameters

| Field | Type | Required | Description |
|------|------|----------|-------------|
| currency | string | Yes | ISO 4217 currency code (e.g., USD, EUR, AZN) |
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
  "message": "Operation successful"
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
        from: "1.9.0"
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

### Package Product

| Product | Contents |
|---------|----------|
| `Gate2TravelSDK` | The whole SDK: configuration, networking, and the eSIM feature. `import Gate2TravelSDK` is all you need. |

---

## 5. Configuration

Call `Gate2Travel.configure(...)` once, before creating any eSIM screen.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `apiKey` | `String` | Yes | — | Your Gate2Travel API key |
| `environment` | `G2TServerEnvironment` | Yes | — | `.production` for live apps, `.staging` for testing |
| `sessionId` | `String` | Yes | — | Current user session identifier |
| `userId` | `String` | Yes | — | Current user identifier. Required for My eSIMs and top-up. |
| `consoleLevels` | `[G2TLogLevel]` | No | `[]` | Log levels printed to the Xcode console |
| `onLog` | `G2TLogHandler?` | No | `nil` | Receives every SDK log message, at all levels, independent of `consoleLevels` |
| `localization` | `SDKLocalizationProvider` | No | `DefaultSDKLocalization()` | Not used by eSIM screens — pass custom eSIM strings to the flow instead (see [Localization](#8-localization)) |
| `language` | `(@Sendable () -> G2TLanguage)?` | No | `nil` | Returns the language to show. Read on every string lookup and request, so screens opened after a change use the new language. `nil` follows the system locale. |

`G2TLanguage` cases: `.english`, `.russian`, `.azerbaijani`.

### Example

```swift
import Gate2TravelSDK

@main
struct YourApp: App {
    init() {
        do {
            try Gate2Travel.configure(
                apiKey: ProcessInfo.processInfo.environment["GATE2_API_KEY"] ?? "",
                environment: .production,
                sessionId: "user-session-id",
                userId: "user-id",
                consoleLevels: [.error, .info],
                onLog: { level, message in
                    MyLogger.log("[\(level.label)] \(message)")
                },
                language: { .azerbaijani }
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
| `.error` | Network failures, decoding errors |
| `.info` | SDK lifecycle, screen navigation, flow events |
| `.verbose` | User action context: search criteria, selections, prices (no private data) |

`consoleLevels: []` (the default) turns off console output only. An `onLog` handler, if
you pass one, still receives every level.

---

## 6. Integration

> Creating an `ESimsFlow`, `ESimsFlowView`, or `ESimOrderDetailsView` before
> `Gate2Travel.configure(...)` has succeeded stops the app at runtime. Guard entry points
> with [`ESimsAvailability.isAvailable`](#esimsavailability).

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
| `onFail` | Called with an [`ESimFlowError`](#errors) on a non-recoverable failure |
| `onProcessPayment` | Called with the order ID when the SDK needs you to take payment. Process it, then call `showOrderResult(orderId:)`. |
| `localization` | Optional custom translations — see [Localization](#8-localization) |

> Create a new `ESimsFlow` per entry. The flow keeps itself alive while its screens are
> showing, and storing it in a property (as the samples do) is also fine. Calling `start`
> or `showMyESims` again on the same instance abandons the previous flow.
> `showOrderResult(orderId:)` continues the running flow, or opens the activation screen
> on its own when called on an instance that has not started one.

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
        Task { @MainActor in
            if success { flow.showOrderResult(orderId: orderId) }
        }
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

### Errors

`onFail` receives an `ESimFlowError`:

```swift
public struct ESimFlowError: Sendable {
    public let code: ESimErrorCode
    public let message: String
    public let isRetryable: Bool
    public let httpStatusCode: Int?
}
```

Codes reported in this release:

| `ESimErrorCode` | Raw value | When | `message` |
|-----------------|-----------|------|-----------|
| `.orderCreationFailed` | `ORDER_CREATION_FAILED` | Buying the plan failed | Localized, safe to show |
| `.orderConfirmationFailed` | `ORDER_CONFIRMATION_FAILED` | The activation screen could not load the order | Localized, safe to show |
| `.userIdRequired` | `USER_ID_REQUIRED` | `showMyESims` was called without a `userId` | English, for developers |

The other cases (`.networkError`, `.unauthorized`, `.forbidden`, `.notFound`,
`.serverError`, `.parseError`, `.unknown`) are reserved and not reported yet.
`httpStatusCode` is currently always `nil`.

Other recoverable problems, like a dropped connection while browsing, are shown in the
SDK screens with a retry button and never reach `onFail`. The activation screen is the
exception: when the order cannot load, it shows **Try again** and **Close** and also
reports `.orderConfirmationFailed` to `onFail`, once per failed attempt. Use `onFail` to
log it; closing the screen from `onFail` takes the retry away from the user. **Close**
fires `onComplete(orderId)`.

Use `@unknown default` when you `switch` over `ESimErrorCode`, so new cases never break
your build.

### UIKit Integration

```swift
final class TravelViewController: UIViewController {
    private var esimFlow: ESimsFlow?

    func startESim() {
        guard let nav = navigationController, ESimsAvailability.isAvailable else { return }
        let flow = ESimsFlow(
            navigationController: nav,
            onComplete: { [weak self] orderId in self?.handleComplete(orderId) },
            onFail: { [weak self] error in self?.showError(error.message) }
        )
        esimFlow = flow
        flow.start(onProcessPayment: { orderId in
            PaymentService.processPayment(orderId: orderId) { success in
                Task { @MainActor in
                    if success { flow.showOrderResult(orderId: orderId) }
                }
            }
        })
    }

    /// Opens eSIM history straight from your own orders tab.
    func showMyESims() {
        guard let nav = navigationController, ESimsAvailability.isAvailable else { return }
        let flow = ESimsFlow(
            navigationController: nav,
            onComplete: { [weak self] orderId in self?.handleComplete(orderId) },
            onFail: { [weak self] error in self?.showError(error.message) }
        )
        esimFlow = flow
        flow.showMyESims(onProcessPayment: { orderId in
            PaymentService.processPayment(orderId: orderId) { success in
                Task { @MainActor in
                    if success { flow.showOrderResult(orderId: orderId) }
                }
            }
        })
    }
}
```

### SwiftUI Integration

Two views are available:

```swift
/// The browse-and-buy flow (destination → plans → detail → onProcessPayment).
public struct ESimsFlowView: UIViewControllerRepresentable {
    public init(
        localization: ESimsLocalization = DefaultESimsLocalization(),
        onComplete: @escaping (String) -> Void,
        onProcessPayment: @escaping (String) -> Void,
        onFail: @escaping (ESimFlowError) -> Void
    )
}

/// The activation screen for a paid order.
public struct ESimOrderDetailsView: UIViewControllerRepresentable {
    public init(
        orderId: String,
        localization: ESimsLocalization = DefaultESimsLocalization(),
        onComplete: @escaping (String) -> Void,
        onFail: @escaping (ESimFlowError) -> Void
    )
}
```

`ESimsFlowView` has no `showOrderResult` hook. Once payment succeeds, show
`ESimOrderDetailsView` for that order ID. Present the flow as a `.sheet` (or add your
own close button), because its first screen has no dismiss control.

```swift
import Gate2TravelSDK

struct ContentView: View {
    @State private var showESim = false
    @State private var paidOrderId: String?

    var body: some View {
        Button("Buy eSIM") { showESim = true }
            .disabled(!ESimsAvailability.isAvailable)
            .sheet(isPresented: $showESim, onDismiss: { paidOrderId = nil }) {
                if let orderId = paidOrderId {
                    ESimOrderDetailsView(
                        orderId: orderId,
                        onComplete: { _ in showESim = false },
                        onFail: { error in print("eSIM error: \(error.message)") }
                    )
                } else {
                    ESimsFlowView(
                        onComplete: { _ in showESim = false },
                        onProcessPayment: { orderId in
                            PaymentService.processPayment(orderId: orderId) { success in
                                Task { @MainActor in
                                    if success { paidOrderId = orderId }
                                }
                            }
                        },
                        onFail: { error in print("eSIM error: \(error.message)") }
                    )
                }
            }
    }
}
```

My eSIMs has no SwiftUI view. To open it from SwiftUI, wrap a `UINavigationController`
in your own `UIViewControllerRepresentable` and call `ESimsFlow.showMyESims` on it.

---

## 7. Appearance

The SDK uses its built-in Gate2 theme, which adapts to light and dark mode
automatically. Custom colors cannot be configured in this release.

For the navigation bar, the SDK uses the system back button on the
`UINavigationController` you pass in, so your own navigation bar appearance settings
apply to it. Two exceptions: the Welcome (terms) screen draws a transparent bar with
its own white back chevron over its artwork, and the activation screen has no back
button — the user leaves it with **Done**, which fires `onComplete`.

---

## 8. Localization

The SDK ships English, Russian, and Azerbaijani translations for every eSIM screen.

### Choosing the Language

By default the SDK follows the system locale. To control it, pass `language:` to
`configure`. The closure is called each time the SDK resolves a string or sends a
request, so screens opened after an in-app language switch use the new language. A
screen that is already open, and content it already loaded from the server, keeps its
current language until it is opened again:

```swift
try Gate2Travel.configure(
    apiKey: "your-api-key",
    environment: .production,
    sessionId: "user-session-id",
    userId: "user-id",
    language: { AppSettings.shared.language.g2tLanguage }
)
```

### Custom Translations

To replace the bundled strings, implement `ESimsLocalization` and pass it to the
entry point you use. The `localization:` parameter of `configure` does not affect eSIM
screens.

```swift
struct MyESimsLocalization: ESimsLocalization {
    var welcomeTitle: String { "Stay connected abroad" }
    // ... implement every required member of ESimsLocalization
}

let flow = ESimsFlow(
    navigationController: nav,
    onComplete: { _ in },
    onFail: { _ in },
    localization: MyESimsLocalization()
)

// SwiftUI
ESimsFlowView(localization: MyESimsLocalization(), onComplete: { _ in }, onProcessPayment: { _ in }, onFail: { _ in })
ESimOrderDetailsView(orderId: orderId, localization: MyESimsLocalization(), onComplete: { _ in }, onFail: { _ in })
```

Members added in later releases come with English defaults, so a custom implementation
keeps compiling after an upgrade. Check the [Migration](#11-migration) notes for new
strings to translate.

---

## 9. eSIM Flow

The SDK never collects card details. It creates the order, hands you the order ID,
and waits for you to call `showOrderResult(orderId:)`.

```
start(onProcessPayment:)

  WELCOME → DESTINATION → PLANS → DETAIL
  (first run)    │                  │
                 │                  ▼
                 │        onProcessPayment(orderId)   ← you take payment here
                 │                  │
                 │                  ▼
                 │        showOrderResult(orderId:)
                 │                  │
                 │               RESULT
                 │                  │
                 │                  ▼
                 │        onComplete(orderId)
                 │
                 ├──▶ MY ESIMS → ESIM DETAIL   (when a userId is set and the user has an eSIM)
                 └──▶ FAQ


showMyESims(onProcessPayment:)

  MY ESIMS → ESIM DETAIL ──"Top up"──▶ PLANS → DETAIL → onProcessPayment(orderId)
```

| Screen | Purpose |
|--------|---------|
| **Welcome** | Terms and introduction. Shown once, before the first purchase. |
| **Destination** | Select a country or region. Shows your promotional banners and, when a `userId` is configured and the user already has an eSIM, their latest eSIM with a link to My eSIMs. |
| **Plans** | Browse data plans — data amount, validity, price, any discount — with filters and the device compatibility check |
| **Detail** | Data, validity, network, speed, coverage, and the buy action |
| **Result** | QR code for installation + direct install option (iOS 17.4+) |
| **My eSIMs** | Purchased eSIMs, with data usage and status |
| **eSIM Detail** | Activation details, install steps, and top-up |
| **FAQ** | Common questions about eSIMs |

#### Promotional Banners

The Destination screen shows the promotional banners set up in your merchant settings
with Gate2 Travel, in the user's current language. There is nothing to enable in code.
When no banner is set up, or it cannot load, the space is hidden.

#### Discounted Pricing

When a plan is discounted, the plan card shows the pre-discount price struck through
next to the price the user actually pays, plus a badge with the percentage off. The
plan detail header shows the payable price with the pre-discount price struck through
below it. The Buy Now button shows only the payable price.

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

    var body: some Scene {
        WindowGroup {
            if appState.isReady {
                ContentView().environmentObject(appState)
            } else {
                ProgressView("Loading...")
                    .task { appState.configureSDK() }
            }
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    @Published private(set) var isReady = false
    @Published var lastOrderId: String?

    func configureSDK() {
        do {
            try Gate2Travel.configure(
                apiKey: ProcessInfo.processInfo.environment["GATE2_API_KEY"] ?? "",
                environment: .production,
                sessionId: "user-session-id",
                userId: "user-id",
                consoleLevels: [.error]
            )
            isReady = true
        } catch {
            print("SDK configuration failed: \(error)")
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showESim = false
    @State private var paidOrderId: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Travel App").font(.largeTitle)

            if ESimsAvailability.isDeviceESimCapable {
                Button("Buy eSIM") { showESim = true }
                    .buttonStyle(.borderedProminent)
            }

            if let orderId = appState.lastOrderId {
                Text("Last eSIM order: \(orderId)").font(.caption)
            }
        }
        .sheet(isPresented: $showESim, onDismiss: { paidOrderId = nil }) {
            if let orderId = paidOrderId {
                ESimOrderDetailsView(
                    orderId: orderId,
                    onComplete: { orderId in
                        appState.lastOrderId = orderId
                        showESim = false
                    },
                    onFail: { error in print("eSIM error: \(error.message)") }
                )
            } else {
                ESimsFlowView(
                    onComplete: { orderId in
                        appState.lastOrderId = orderId
                        showESim = false
                    },
                    onProcessPayment: { orderId in
                        PaymentService.processPayment(orderId: orderId) { success in
                            Task { @MainActor in
                                if success { paidOrderId = orderId }
                            }
                        }
                    },
                    onFail: { error in print("eSIM error: \(error.message)") }
                )
            }
        }
    }
}
```

---

## 11. Migration

### Upgrading to 1.9.0

No code changes are needed.

#### Custom localization: one new string

If you implement `ESimsLocalization` yourself, one member was added for the
promotional banners. It has an English default, so **your code still compiles** — but
it will ship untranslated English until you override it:

| Member | English default |
|--------|-----------------|
| `accessibilityPromoBanner` | `Promotional banner` |

### New in 1.9.0

- Promotional banners on the eSIM main page, shown automatically from your merchant settings

### Upgrading to 1.8.0

Most apps need no changes. One item is source-breaking in a narrow case.

#### Blank `userId` now means "no user"

A `userId` that is empty or only whitespace is now treated as missing. The
Destination screen hides its My eSIMs shortcut, and `showMyESims` reports
`ESimErrorCode.userIdRequired`. Pass the real user identifier to
`Gate2Travel.configure(...)` if you want My eSIMs and top-up to appear.

#### `ESimErrorCode` has a new case

`userIdRequired` was added, reported when `showMyESims` is called without a
`userId`. If you `switch` over `ESimErrorCode` and cover every case with no
`default`, your switch is no longer exhaustive and will not compile:

```swift
// Before — lists every 1.7.0 case with no default; compiled on 1.7.0, fails on 1.8.0
switch error.code {
case .networkError, .unauthorized, .forbidden, .notFound, .serverError, .parseError: …
case .orderCreationFailed, .orderConfirmationFailed: …
case .unknown: …
}

// After — add @unknown default, and future cases will never break you again
switch error.code {
case .networkError, .unauthorized, .forbidden, .notFound, .serverError, .parseError: …
case .orderCreationFailed, .orderConfirmationFailed: …
case .unknown: …
@unknown default: reportUnexpected(error)
}
```

You are unaffected if you read `error.message`, read `error.code.rawValue`,
compare with `==`, or already use `default` / `@unknown default`.

#### Custom localization: three new strings

If you implement `ESimsLocalization` yourself, three members were added for
discounted pricing. They have English defaults, so **your code still compiles**
— but it will ship untranslated English until you override them:

| Member | English default |
|--------|-----------------|
| `plansDiscountBadge(_:)` | `20% discount` (receives `"20"` — the number only; add `%` in your copy) |
| `accessibilityDiscountOriginalPrice(_:)` | `Was 4.40 ₼` (receives the formatted pre-discount price) |
| `accessibilityDiscountPercent(_:)` | `20% off` (receives `"20"` — the number only) |

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

**Gate2 Travel SDK** • iOS 15.0+ • Swift 6.2+

© 2026 Gate2 Travel

</div>
