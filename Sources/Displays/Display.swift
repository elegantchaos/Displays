// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/03/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#if canImport(CoreGraphics)
import CoreGraphics
import Foundation

public struct Display: Equatable {
    let id: CGDirectDisplayID
    
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
    
    public static var main: Display {
        return Display(id: CGMainDisplayID())
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
                    result.append(Display(id: displays[i]))
                }
                return result
            }
        }
        
        return []
    }
    
}
#endif
