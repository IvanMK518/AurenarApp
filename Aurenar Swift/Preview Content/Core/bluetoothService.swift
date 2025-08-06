//
//  bluetoothService.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 6/20/25.
//

/*
 This component handles all BLE calls made to AdaFruit BLuefruit LE device on V-Link.
 Notes: - When phone is in range, CBCentralManager will autoconnect to previously paired device with CBUIID
*/


import Foundation
import CoreBluetooth
import GlassGem

enum connectionStatus {
    case connected
    case disconnected
    case scanning
    case pairing
    case error
}

let bluefruitService: CBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
private let txUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
private let rxUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")


class bluetoothService: NSObject, ObservableObject {
    
    enum BLE_CMD: UInt8 {
        case start = 0x01
        case pause = 0x02
        case ack = 0x80
        case stopped = 0x03
        case impFail = 0x04
        case batLow = 0x05
        case impCheck = 0x06
        case therapyCP = 0x07
        case resume = 0x08
        case impSuccess = 0x09
    }
    
    enum BLE_TELEMETRY: UInt8 {
        case telemetry1hz = 0x32
    }
    
    private var txCharacteristic : CBCharacteristic?

    private var centralManager : CBCentralManager!
    
    var adafruitPeripheral : CBPeripheral?
    
    @Published var peripheralStatus : connectionStatus = .disconnected
    
    @Published var batteryLvl: CGFloat = 0
    @Published var impedanceLvl: CGFloat = 0
    @Published var timeRemaining: Int = 0
    @Published var devState: TimerView.TimerState = .stopped
    
    var hasPaired = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scan() {
        guard centralManager.state == .poweredOn else {
            print("Central not powered on, stopping scan")
            return
        }
        
        guard peripheralStatus != .scanning else {
            return
        }

        peripheralStatus = .scanning
        centralManager.scanForPeripherals(withServices: [bluefruitService], options: nil)
    }

    func send (_ data: Data) {
        guard let bluefruit = adafruitPeripheral,
              let tx = txCharacteristic else {
            print("send: missing peripheral or txCharacteristic")
            return
        }
        let bytes = data.map { String(format: "%02X", $0) }.joined(separator: " ")
        print("Writing \(bytes) to \(tx.uuid.uuidString) with props \(tx.properties)")
        bluefruit.writeValue(data, for: tx, type: .withResponse)
    }
    
    func sendCmd(_ cmd: BLE_CMD) {
        let data = Data([cmd.rawValue])
        let encoded = data.encodedUsingCOBS()
        send(encoded)
    }

}
    
extension bluetoothService : CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn  {
            print("cb powered on")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name!)")
        adafruitPeripheral = peripheral
        centralManager.connect(peripheral)
        peripheralStatus = .pairing
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheralStatus = .connected
        print("Connected to \(peripheral.name!)")
        if peripheralStatus == .connected {
            hasPaired = true
        }
        peripheral.delegate = self
        peripheral.discoverServices([bluefruitService])
        centralManager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        peripheralStatus = .disconnected
        print("Device disconnected")
        adafruitPeripheral = nil
        txCharacteristic = nil
        
        if hasPaired {
            scan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        peripheralStatus = .error
        print(error?.localizedDescription ?? "no error")
    }
    
}

extension bluetoothService: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] where service.uuid == bluefruitService {
            peripheral.discoverCharacteristics([txUUID, rxUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        for characteristic in service.characteristics ?? [] {
            switch characteristic.uuid {
            case rxUUID:
                peripheral.setNotifyValue(true , for: characteristic)
            case txUUID:
                txCharacteristic = characteristic
            default:
                break
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let err = error {
            print("failed write: \(err)")
        } else {
            print("data sent")
        }
    }

    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if characteristic.uuid == rxUUID {
            guard let
                    data = characteristic.value
            else {
                print("no data received for \(characteristic.uuid.uuidString)")
                return
            }
            
            let decoded = data.decodedFromCOBS()
            guard !decoded.isEmpty else {
                return
            }
            
            guard let byte = decoded.first,
                    let cmd = byte.first
            else {
                print("Decode failure");
                return;
            }
            
            if cmd == BLE_TELEMETRY.telemetry1hz.rawValue {
                switch byte.count {
                case 5:
                    let battery = UInt16(byte[1]) | (UInt16(byte[2]) << 8)
                    let impedance = UInt16(byte[3]) | (UInt16(byte[4]) << 8)
                    
                    DispatchQueue.main.async {
                        self.batteryLvl = CGFloat(Double((battery / 4096) * 10))
                        let minImpedance: Double = 5000
                        let maxImpedance: Double = 57000
                        let impedanceValue = (Double(impedance))
                        let percentage = max(0.0, min(1.0, (impedanceValue - minImpedance) / (maxImpedance - minImpedance))) * 100.0
                        self.impedanceLvl = percentage
                        print("bat \(self.batteryLvl)")
                        print("imp \(self.impedanceLvl)")
                    }
                    
                    return
                    
                default:
                    print("ignoring false cmd")
                    return
                }
            }
                      
            guard byte.count == 1 else {
                    print("ignoring non-command frame len=\(byte.count), type=0x\(String(format:"%02X", cmd))")
                    return
            }
                       
                    
            
            switch cmd {
            case BLE_CMD.ack.rawValue:
                print("ACK received")
            case BLE_CMD.start.rawValue:
                DispatchQueue.main.async {
                    self.devState = .running
                }
                print("received \(cmd)")
                print("stim started by AUR120")
            case BLE_CMD.pause.rawValue:
                DispatchQueue.main.async {
                    self.devState = .paused
                }
                print("stim paused by AUR120")
            case BLE_CMD.stopped.rawValue:
                DispatchQueue.main.async {
                    self.devState = .stopped
                }
                print("stim stopped by AUR120")
            case BLE_CMD.impFail.rawValue:
                DispatchQueue.main.async {
                    self.devState = .impFail
                }
                print("impedance error by AUR120")
            case BLE_CMD.therapyCP.rawValue:
                DispatchQueue.main.async {
                    self.devState = .therapyCP
                }
                print("therapy complete by AUR120")
            case BLE_CMD.batLow.rawValue:
                DispatchQueue.main.async {
                    self.devState = .batLow
                }
                print("battery of device low")
            case BLE_CMD.impCheck.rawValue:
                DispatchQueue.main.async {
                    self.devState = .impCheck
                }
                print("impedance check failed by AUR120")
            case BLE_CMD.impSuccess.rawValue:
                DispatchQueue.main.async {
                    self.devState = .impSuccess
                }
                print("impedance check passed by AUR120")
            default:
                print("unknown cmd: \(decoded[0])")
            }
        }
    }
}

extension bluetoothService {
    func startStim() {
        print("start Stim called")
        sendCmd(.start)
    }
    
    func pauseStim() {
        print("pause Stim called")
        sendCmd(.pause)
    }
    
    func resumeStim() {
        print("resume Stim called")
        sendCmd(.resume)
    }
}
