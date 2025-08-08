# README

<p align="center">
 <img width="244" height="344" alt="Aurenar Logo Bright" src="https://github.com/user-attachments/assets/dcc4dfba-73f2-4649-ad2f-7cc867eb3b09" />
</p>

## Overview
This is the Aurenar Wireless V-Link's companion app. This app acts as both a controller and receiver of the microcontroller's behaviors.

## Features

# Documentation For Future Developers
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



## Special Thanks


| **Author:**    | Ivan Martinez-Kay                                              |
|----------------|----------------------------------------------------------------|
| **Email:**     | [iemarti@emory.edu](mailto:iemarti@emory.edu)         |
| **Contact:**   | [About Me](https://ivan-mk-s-website.vercel.app/)             |
