import WidgetKit

@objc(Widgetkit)
class Widgetkit: NSObject {

    @objc(reloadAllTimelines)
    func reloadAllTimelines() -> Void {
        if #available(iOS 14.0, *) {
            #if arch(arm64) || arch(x86_64)
                WidgetCenter.shared.reloadAllTimelines()
            #endif
        }
    }

    @objc(reloadTimelines:)
    func reloadTimelines(ofKind: String) -> Void {
        if #available(iOS 14.0, *) {
            #if arch(arm64) || arch(x86_64)
                WidgetCenter.shared.reloadTimelines(ofKind: ofKind)
            #endif
        }
    }

    @objc(getItem:withAppGroup:withResolver:withRejecter:)
    func getItem(key: String, appGroup: String, resolve: RCTPromiseResolveBlock,reject: RCTPromiseRejectBlock) -> Void {
        var sharedDefaults: UserDefaults? = nil;

        if(appGroup != "") {
            sharedDefaults = UserDefaults.init(suiteName: appGroup)
        }

        if(sharedDefaults == nil) {
            resolve(nil)
            return
        }

        let value = sharedDefaults?.value(forKey: key)
        resolve(value);
    }

    @objc(setItem:withValue:withAppGroup:withResolver:withRejecter:)
    func setItem(key: String, value: String, appGroup: String, resolve: RCTPromiseResolveBlock,reject: RCTPromiseRejectBlock) -> Void {
        var sharedDefaults: UserDefaults? = nil;

        if(appGroup != "") {
            sharedDefaults = UserDefaults.init(suiteName: appGroup)
        }

        if(sharedDefaults == nil) {
            resolve(nil)
            return
        }

        sharedDefaults?.setValue(value, forKey: key)
        resolve(nil)
    }

    // Original code: https://github.com/Taylor123/react-native-widget-center/pull/1
    @objc(getCurrentConfigurations:reject:)
    func getCurrentConfigurations (_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        if #available(iOS 14.0, *) {
            #if arch(arm64) || arch(x86_64)
            WidgetCenter.shared.getCurrentConfigurations {result in
                switch result {
                case .success(let widgetInfo):
                    // Serialize widgets config into something the bridge understands
                    // https://reactnative.dev/docs/native-modules-ios#argument-types
                    var res:[[String: String]] = []
                    for widget in widgetInfo {
                        res.append(["kind": widget.kind, "family": widget.family.description])
                    }
                    resolve(res)
                case.failure(let error):
                    reject("404", "Couldn't get current widgets configuration", error)
                }
            }
            #endif
        }
    }


    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
