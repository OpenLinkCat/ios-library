/* Copyright 2010-2019 Urban Airship and Contributors */

import UIKit

public class AirshipDebugKit : NSObject {
    @objc public static var deviceInfoViewController : UIViewController? = instantiateStoryboard("DeviceInfo")
    @objc public static var automationViewController : UIViewController? = instantiateStoryboard("Automation")
    @objc public static var customEventsViewController : UIViewController? = instantiateStoryboard("CustomEvents")
    
    /**
     * Loads one of the debug storyboards.
     * @param name Name of the storyboard you want loaded, e.g. "DeviceInfo".
     * @return Initial view controller for the instantiated storyboard.
     */
    class func instantiateStoryboard(_ name : String) -> UIViewController? {
        // find the bundle containing the storyboard
        var storyboardBundle : Bundle = Bundle(for: self)
        if (storyboardBundle.path(forResource: name, ofType: "storyboardc") == nil) {
            // if it is not the main bundle, then it should be in the resource bundle
            let resourceBundlePath = storyboardBundle.path(forResource: "AirshipDebugResources", ofType: "bundle")
            if (resourceBundlePath == nil) {
                print("ERROR: storyboard for \(name) not found")
                return nil
            }
            storyboardBundle = Bundle.init(path: resourceBundlePath!)!
            if (storyboardBundle.path(forResource: name, ofType: "storyboardc") == nil) {
                print("ERROR: storyboard for \(name) not found")
                return nil
            }
        }
        
        // get the requested storyboard from the bundle
        let storyboard = UIStoryboard(name: name, bundle: storyboardBundle)

        return storyboard.instantiateViewController(withIdentifier: "InitialController")
    }

}

// MARK: Extensions for Localization

/**
 * Translate the string using the DebugKit strings file
 */
internal extension String {
    func localized(bundle: Bundle = Bundle(for: AirshipDebugKit.self), tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, comment: "")
    }
}

/**
 * Adds IBInspectable to UILabel for use in storyboards.
 *
 * Designer can enter a localization key in the storyboard attributes
 * inspector for the UILabel. This key will be used to localize the
 * UILabel's text when the storyboard is loaded.
 */
internal extension UILabel {
    @IBInspectable var keyForLocalization: String? {
        // Don't need to ever get the key.
        get { return nil }
        // When the key is set by the storyboard, localize it
        // and set the localized text as the text of the UILabel
        set(key) {
            text = key?.localized()
        }
    }
}

/**
 * Adds IBInspectable to UINavigationItem for use in storyboards.
 *
 * Designer can enter a localization key in the storyboard attributes
 * inspector for the UINavigationItem. This key will be used to localize the
 * UINavigationItem's title when the storyboard is loaded.
 */
internal extension UINavigationItem {
    @IBInspectable var keyForLocalization: String? {
        // Don't need to ever get the key.
        get { return nil }
        set(key) {
            // When the key is set by the storyboard, localize it
            // and set the localized text as the title of the UINavigationItem
            title = key?.localized()
        }
    }
}

/**
 * Adds IBInspectable to UITextField for use in storyboards.
 *
 * Designer can enter a localization key in the storyboard attributes
 * inspector for the UITextField. This key will be used to localize the
 * UITextField's placeholder when the storyboard is loaded.
 */
internal extension UITextField {
    @IBInspectable var keyForLocalization: String? {
        // Don't need to ever get the key.
        get { return nil }
        set(key) {
            // When the key is set by the storyboard, localize it
            // and set the localized text as the placeholder of the UITextField
            placeholder = key?.localized()
        }
    }
}