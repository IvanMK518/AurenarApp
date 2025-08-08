# README

<p align="center">
 <img width="244" height="344" alt="Aurenar Logo Bright" src="https://github.com/user-attachments/assets/dcc4dfba-73f2-4649-ad2f-7cc867eb3b09" />
</p>

## Overview
This is the Aurenar Wireless V-Link's companion app. This app acts as both a controller and receiver of the microcontroller's behaviors.

## Features

# Documentation For Future Developers
## Please read this document for environment setup in VSCode:
[Dev Env Setup and config Rev02.docx](https://github.com/user-attachments/files/21690740/Dev.Env.Setup.and.config.Rev02.docx)

- **Please also do the following:**
 - in the very same `CMakeLists.txt` under `set(MX_Application_Src)` add `${CMAKE_SOURCE_DIR}/Core/Src/ble.c` and `${CMAKE_SOURCE_DIR}/Core/Src/cobs.c`.
 - Then run a Clean Rebuild or Build + Flash
   


## Core Functions: 
### **AccountView**: This is currently a static placeholder for future user's control panel. When please update when authentication is implemented.
### **bluetoothService**: This function handles all bluetooth capabilities in the app.
- **Core BLE Management**
  - `bluetoothService.init()` - Initializes CBCentralManager and sets up BLE delegates ([bluetoothService.swift#L67](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L67))
  - `scan()` - Scans for AdaFruit Bluefruit LE devices with V-Link service UUID ([bluetoothService.swift#L74](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L74))
  - `send()` - Low-level data transmission to BLE device ([bluetoothService.swift#L86](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L86))

- **Command Interface**
  - `sendCmd()` - COBS-encoded command transmission ([bluetoothService.swift#L96](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L96))
  - `startStim()` - Send stimulation start command ([bluetoothService.swift#L339](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L339))
  - `pauseStim()` - Send stimulation pause command ([bluetoothService.swift#L344](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L344))
  - `resumeStim()` - Send stimulation resume command ([bluetoothService.swift#L349](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L349))

- **Signal Monitoring**
  - `readSignalStrength()` - Request RSSI from connected device ([bluetoothService.swift#L102](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L102))
  - `signalStrengthConversion()` - Convert RSSI to percentage (range: -85dBm to -50dBm) ([bluetoothService.swift#L112](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L112))
  - `startRSSIMonitoring()` - Automatic 2-second interval RSSI polling ([bluetoothService.swift#L126](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L126))

- **Data Processing**
  - `processFrame()` - Parse incoming BLE commands and telemetry ([bluetoothService.swift#L238](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L238))
  - `decoded()` - COBS frame decoder for received data ([bluetoothService.swift#L230](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L230))
  - Handles 1Hz telemetry packets (battery voltage + ear impedance)
  - Processes device state commands (start/pause/stop/error states)

- **Connection Management**
  - Auto-reconnection to previously paired devices using CBUUID
  - Connection state tracking: `.connected`, `.disconnected`, `.scanning`, `.pairing`, `.error`
  - Automatic service/characteristic discovery for Bluefruit UART service
  - TX/RX characteristic handling with notification setup

- **Published Properties**
  - `@Published var peripheralStatus` - Current BLE connection state
  - `@Published var batteryLvl` - Device battery level (0-100%)
  - `@Published var impedanceLvl` - Ear impedance percentage
  - `@Published var devState` - Current device operational state
  - `@Published var signalStrength` - Raw RSSI value in dBm
  - `@Published var signalStrengthPercent` - Signal strength as percentage

- **Protocol Support**
  - **Service UUID**: `6E400001-B5A3-F393-E0A9-E50E24DCCA9E` (Nordic UART Service)
  - **TX UUID**: `6E400002-B5A3-F393-E0A9-E50E24DCCA9E` (Phone -> Device)
  - **RX UUID**: `6E400003-B5A3-F393-E0A9-E50E24DCCA9E` (Device -> Phone)
  - GlassGem Cobs Library: ([COBS](https://github.com/armadsen/GlassGem))

### **CalendarView**: This function displays a calendar with therapy tracking properties.
- **Therapy Completion Tracking**
  - Visual checkmark indicators for daily therapy sessions (1-2 sessions per day)
  - Color-coded completion status: Gray (none), Yellow (1 session), Blue (2+ sessions)
  - Integration with `TherapyCounter` environment object for session data
  - `therapyCounter.getCompletion(for: day)` - Retrieves completion count for specific date

- **Date Extensions & Utilities**
  - `Date.firstLetterOfWeekdays` - Generates weekday headers (S, M, T, W, T, F, S) ([CalendarView.swift#L71](https://github.com/IvanMK518/Firmware-AUR120/blob/main/CalendarView.swift#L71))
  - `Date.monthNames` - Localized month name array ([CalendarView.swift#L82](https://github.com/IvanMK518/Firmware-AUR120/blob/main/CalendarView.swift#L82))
  - `Date.startOfMonth` - First day of current month ([CalendarView.swift#L93](https://github.com/IvanMK518/Firmware-AUR120/blob/main/CalendarView.swift#L93))
  - `Date.endOfMonth` - Last day of current month ([CalendarView.swift#L97](https://github.com/IvanMK518/Firmware-AUR120/blob/main/CalendarView.swift#L97))
  - `Date.calendarDisplayDays` - Generates array of dates for calendar grid display ([CalendarView.swift#L117](https://github.com/IvanMK518/Firmware-AUR120/blob/main/CalendarView.swift#L117))

- **State Management**
  - `@State private var date` - Currently selected date for calendar navigation
  - `@State private var days` - Array of dates to display in calendar grid
  - `@EnvironmentObject var therapyCounter` - Shared therapy session tracking data
  - Reactive updates when date selection changes (`onChange(of: date)`)

- **Calendar Logic**
  - Displays previous/next month days to fill grid
  - Week starts on Sunday (standard US calendar format)
  - Handles month boundaries and leap years automatically
  - Filters display range from Sunday before month start to month end

### **HomeView**: This function handles transition between paired state and unpaired state.
  - if `bt.connected` is called as positive from `bluetoothService` then this view displays `TimerView`, else it remains on the pairing screen `PairingView`.

### **TherapyCounter**: This function counts finished therapy sessions logged by acknowledgement sent from the microcontroller.
- **Session Tracking**
  - `countCompletion()` - Increments daily therapy session count (max 2 per day) ([TherapyCounter.swift#L22](https://github.com/IvanMK518/Firmware-AUR120/blob/main/TherapyCounter.swift#L22))
  - `getCompletion(for: Date)` - Retrieves completion count for specific date ([TherapyCounter.swift#L33](https://github.com/IvanMK518/Firmware-AUR120/blob/main/TherapyCounter.swift#L33))
  - Date-based session limiting: maximum 2 therapy sessions per calendar day
  - Triggered by microcontroller ACK signals via BLE communication which are processed in `processFrame()` ([bluetoothService.swift#L238](https://github.com/IvanMK518/Firmware-AUR120/blob/main/bluetoothService.swift#L238)).

- **Data Persistence**
  - `saveCompletions()` - Auto-saves session data to UserDefaults on count changes ([TherapyCounter.swift#L17](https://github.com/IvanMK518/Firmware-AUR120/blob/main/TherapyCounter.swift#L17))
  - `loadCompletion()` - Restores session history from UserDefaults on app launch ([TherapyCounter.swift#L38](https://github.com/IvanMK518/Firmware-AUR120/blob/main/TherapyCounter.swift#L38))
  - Storage key: "therapyComplete" in UserDefaults
  - Dictionary format: `[String: Int]` where key is "yyyy-MM-dd" date string

- **Date Management**
  - `dateKey(for: Date)` - Converts Date objects to standardized string keys ([TherapyCounter.swift#L29](https://github.com/IvanMK518/Firmware-AUR120/blob/main/TherapyCounter.swift#L29))
  - Format: "yyyy-MM-dd"

- **State Management**
  - `@Published var count` - Dictionary of completion counts per date
  - Observable object for SwiftUI view updates
  - Automatic persistence on data changes via `didSet` observer

### **TimerView**: Handles stimulation timer updates, device state management, and user controls for therapy sessions.
- **Timer Management**
  - `startTimer()` - Initializes 1-second interval countdown timer for 20-minute sessions ([TimerView.swift#L173](https://github.com/IvanMK518/Firmware-AUR120/blob/main/TimerView.swift#L173))
  - `stopTimer()` - Invalidates and cleans up active timer ([TimerView.swift#L186](https://github.com/IvanMK518/Firmware-AUR120/blob/main/TimerView.swift#L186))
  - `formattedTime` - Converts remaining seconds to MM:SS display format ([TimerView.swift#L40](https://github.com/IvanMK518/Firmware-AUR120/blob/main/TimerView.swift#L40))
  - Auto-stops therapy when countdown reaches zero

- **Device State Handling**
  - **TimerState enum**: `.paused`, `.running`, `.stopped`, `.impFail`, `.impCheck`, `.batLow`, `.therapyCP`, `.impSuccess` ([TimerView.swift#L16](https://github.com/IvanMK518/Firmware-AUR120/blob/main/TimerView.swift#L16))
  - State-reactive timer control: starts on `.running`/`.impSuccess`, stops on `.paused`/`.stopped`
  - Integration with `bluetoothService` for real-time device state updates
  - Automatic therapy completion counting on `.therapyCP` state

- **User Interface Controls**
  - Dynamic play/pause button based on current device state ([TimerView.swift#L98](https://github.com/IvanMK518/Firmware-AUR120/blob/main/TimerView.swift#L98))
  - Visual progress indicators: battery level, signal strength, impedance monitoring
  - State-dependent animations: `WaveAnimation` during therapy, `impCheckAnimation` during setup
  - Circular progress ring showing therapy completion percentage

- **Error & Status Overlays**
  - `overlay()` - Displays full-screen status messages with auto-dismiss timers ([TimerView.swift#L154](https://github.com/IvanMK518/Firmware-AUR120/blob/main/TimerView.swift#L154))
  - **Error States**: Poor ear contact (10s), battery low (5s), impedance check failure (5s)
  - **Success State**: Therapy complete confirmation (5s)
  - Customizable icon, color, message, and duration per state

- **Live Activity Integration**
  - ActivityKit integration for iOS Dynamic Island/Lock Screen widgets
  - `TimeTrackingAttributes` for persistent therapy session tracking
  - Started when therapy begins, tracks session duration in background

- **Real-time Monitoring**
  - **Battery Level**: `bt.batteryLvl` with green bolt icon indicator
  - **Signal Strength**: `bt.signalStrengthPercent` (-85dBm to -50dBm range) with link icon
  - **Impedance Level**: `bt.impedanceLvl` with ECG waveform visualization
  - Color-coded status indicators for each metric

- **Therapy Session Flow**


## Special Thanks


| **Author:**    | Ivan Martinez-Kay                                              |
|----------------|----------------------------------------------------------------|
| **Email:**     | [iemarti@emory.edu](mailto:iemarti@emory.edu)         |
| **Contact:**   | [About Me](https://ivan-mk-s-website.vercel.app/)             |
