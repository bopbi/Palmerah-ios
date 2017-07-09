apple_resource(
    name = 'AppResources',
    dirs = [],
    files = glob(['Palmerah/*.png','Palmerah/*.xib','Palmerah/*.storyboard']),
)

apple_asset_catalog(
  name = 'AppAsset',
  dirs = ['Palmerah/Assets.xcassets'],
  app_icon = 'AppIcon',
)

apple_binary(
    name = 'AppBinary',
    srcs = glob([
        'Palmerah/*.swift',
      ]),
    deps = [':AppResources', ':AppAsset'],
    frameworks = [
        '$SDKROOT/System/Library/Frameworks/Foundation.framework',
        '$SDKROOT/System/Library/Frameworks/UIKit.framework',
    ],
)

apple_bundle(
    name = 'App',
    binary = ':AppBinary',
    tests = [':AppTest'],
    extension = 'app',
    info_plist = 'Palmerah/Info.plist',
    info_plist_substitutions = {
        'PRODUCT_BUNDLE_IDENTIFIER': 'com.arjunalabs.Palmerah',
        'CURRENT_PROJECT_VERSION': '1',
    },
)

apple_package(
  name = 'PalmerahAppPackage',
  bundle = ':App',
)

apple_test(
    name = 'AppTest',
    test_host_app = ':App',
    srcs = glob(['PalmerahTests/*.swift']),
    info_plist = 'PalmerahTests/Info.plist',
    frameworks = [
        '$SDKROOT/System/Library/Frameworks/Foundation.framework',
        '$PLATFORM_DIR/Developer/Library/Frameworks/XCTest.framework',
        '$SDKROOT/System/Library/Frameworks/UIKit.framework',
    ],
)