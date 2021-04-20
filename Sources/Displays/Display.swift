// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/03/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if os(macOS) || targetEnvironment(macCatalyst)
import CoreGraphics
import Foundation

public struct Display: Equatable {
    let id: CGDirectDisplayID
    let index: Int
    
    public func mirror(to display: Display) {
        var token: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&token)
        CGConfigureDisplayMirrorOfDisplay(token, id, display.id)
        CGCompleteDisplayConfiguration(token, .forSession)
    }
    
    public func unmirror() {
        var token: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&token)
        CGConfigureDisplayMirrorOfDisplay(token, id, kCGNullDirectDisplay)
        CGCompleteDisplayConfiguration(token, .forSession)
    }
    
    public var mode: CGDisplayMode {
        get { return CGDisplayCopyDisplayMode(id)! }
        set {
            var token: CGDisplayConfigRef?
            CGBeginDisplayConfiguration(&token)
            CGDisplaySetDisplayMode(id, newValue, nil)
            CGCompleteDisplayConfiguration(token, .forSession)
        }
    }
    
    public var modes: [CGDisplayMode] {
        if let cgModes = CGDisplayCopyAllDisplayModes(id, nil), let modes = cgModes as? Array<CGDisplayMode> {
            return modes
        }
        
        return []
    }
    
    public var isMain: Bool {
        return CGDisplayIsMain(id) != 0
    }
    
    public static var main: Display {
        return Display(id: CGMainDisplayID(), index: 0)
    }
    
    public static var active: [Display] {
        var displayCount: UInt32 = 0;
        if CGGetActiveDisplayList(0, nil, &displayCount) == CGError.success {
            let allocated = Int(displayCount)
            let displays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
            defer { displays.deallocate() }

            if CGGetActiveDisplayList(displayCount, displays, &displayCount) == CGError.success {
                var result: [Display] = []
                for i in 0 ..< Int(displayCount) {
                    result.append(Display(id: displays[i], index: i))
                }
                return result
            }
        }
        
        return []
    }
    
    fileprivate var ioName: String {
        let names = ioInfo()?[kDisplayProductName] as? [String: String]
        let name = (names?["en_US"]) ?? names?.values.first
        return name ?? "Display \(id)"
    }

}

fileprivate extension Display {
    func ioInfo() -> NSDictionary? {
        // NB: ioInfo fails for M1 macs; it seems that the IODisplayConnect does not exist on them.
        var service: io_iterator_t = 0
        IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &service)
        let vendorToMatch = CGDisplayVendorNumber(id)
        let productToMatch = CGDisplayModelNumber(id)
        let serialToMatch = CGDisplaySerialNumber(id)
        repeat {
            let serv = IOIteratorNext(service)
            if serv == 0 {
                break
            }
            if let dict = IODisplayCreateInfoDictionary(serv, IOOptionBits(kIODisplayOnlyPreferredName)) {
                let info = dict.takeRetainedValue() as NSDictionary
                if
                    let vendor = info[kDisplayVendorID] as? Int32, vendor == vendorToMatch,
                    let model = info[kDisplayProductID] as? Int32, model == productToMatch,
                    ((info[kDisplaySerialNumber] as? Int32) ?? 0) == serialToMatch
                {
                    return info
                }
            }
        } while true
        
        return nil
    }
}

#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension Display {
    public var name: String {
        if #available(macOS 10.15, *) {
            let screen = NSScreen.screens[index]
            return screen.localizedName
        }
        
        return ioName
    }
}

#else

extension Display {
    public var name: String {
        return ioName
    }
}

#endif
