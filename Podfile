platform :ios, '9.1'
use_frameworks!
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'KFSwiftImageLoader'
pod 'GTToast'
pod 'SwiftAddressBook'
pod 'RZSquaresLoading'
pod 'SCLAlertView'
pod 'Fabric'
pod 'TwitterKit'
pod 'TwitterCore'
pod 'OAuthSwift'
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    # Configure Pod targets for Xcode 8 compatibility
    config.build_settings['SWIFT_VERSION'] = '2.3'
    config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
  end
end
