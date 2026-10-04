#!/usr/bin/env python3
"""Generate iOS6Sim.xcodeproj/project.pbxproj for the macOS SwiftUI app."""
import os

SRC = os.path.dirname(os.path.abspath(__file__))

SWIFT_FILES = [
    "iOS6Sim/iOS6SimApp.swift",
    "iOS6Sim/Simulator/SimulatorState.swift",
    "iOS6Sim/Simulator/Wallpapers.swift",
    "iOS6Sim/Simulator/AppIcon.swift",
    "iOS6Sim/Simulator/StatusBar.swift",
    "iOS6Sim/Simulator/LockScreen.swift",
    "iOS6Sim/Simulator/HomeScreen.swift",
    "iOS6Sim/Simulator/DeviceFrame.swift",
    "iOS6Sim/Simulator/iOS6UI.swift",
    "iOS6Sim/Apps/NotesApp.swift",
    "iOS6Sim/Apps/CalculatorApp.swift",
    "iOS6Sim/Apps/ClockApp.swift",
    "iOS6Sim/Apps/WeatherApp.swift",
    "iOS6Sim/Apps/SettingsApp.swift",
    "iOS6Sim/Apps/PhotosApp.swift",
    "iOS6Sim/Apps/RemindersApp.swift",
    "iOS6Sim/Apps/StockApps1.swift",
    "iOS6Sim/Apps/StockApps2.swift",
    "iOS6Sim/Apps/StockApps3.swift",
    "iOS6Sim/Apps/StockApps4.swift",
    "iOS6Sim/Apps/Jailbreak.swift",
    "iOS6Sim/Apps/MessageStore.swift",
    "iOS6Sim/Apps/MessagesApp.swift",
]

def uid(n):
    return "%024X" % n

# Fixed IDs
PID_PROJECT = uid(1)
PID_TARGET = uid(2)
PID_PROJ_CONFIG_LIST = uid(3)
PID_TARGET_CONFIG_LIST = uid(4)
PID_DEBUG_PROJ = uid(5)
PID_RELEASE_PROJ = uid(6)
PID_DEBUG_TARGET = uid(7)
PID_RELEASE_TARGET = uid(8)
PID_MAIN_GROUP = uid(9)
PID_PRODUCTS_GROUP = uid(10)
PID_APP_GROUP = uid(11)
PID_SIM_GROUP = uid(12)
PID_APPS_GROUP = uid(13)
PID_SOURCES = uid(14)
PID_FRAMEWORKS = uid(15)
PID_RESOURCES = uid(16)
PID_APP_REF = uid(17)
PID_PLIST_REF = uid(18)

file_ids = {}
build_ids = {}
next_id = 100
for f in SWIFT_FILES:
    file_ids[f] = uid(next_id); next_id += 1
    build_ids[f] = uid(next_id); next_id += 1

L = []

def w(s=""):
    L.append(s)

# --- Header ---
w("// !$*UTF8*$!")
w("{")
w("\tarchiveVersion = 1;")
w("\tclasses = {")
w("\t};")
w("\tobjectVersion = 77;")
w("\tobjects = {")

# --- PBXFileReference ---
w("/* Begin PBXFileReference section */")
w(f"\t\t{PID_APP_REF} /* iOS 6.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = \"iOS 6.app\"; sourceTree = BUILT_PRODUCTS_DIR; }};")
w(f"\t\t{PID_PLIST_REF} /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = \"<group>\"; }};")
for f in SWIFT_FILES:
    name = os.path.basename(f)
    w(f"\t\t{file_ids[f]} /* {name} */ = {{isa = PBXFileReference; explicitFileType = sourcecode.swift; path = \"{name}\"; sourceTree = \"<group>\"; }};")
w("/* End PBXFileReference section */")
w("")

# --- PBXGroup ---
w("/* Begin PBXGroup section */")
w(f"\t\t{PID_MAIN_GROUP} = {{")
w("\t\t\tisa = PBXGroup;")
w("\t\t\tchildren = (")
w(f"\t\t\t\t{PID_APP_GROUP} /* iOS6Sim */,")
w(f"\t\t\t\t{PID_PRODUCTS_GROUP} /* Products */,")
w("\t\t\t);")
w("\t\t\tsourceTree = \"<group>\";")
w("\t\t};")
w(f"\t\t{PID_PRODUCTS_GROUP} /* Products */ = {{")
w("\t\t\tisa = PBXGroup;")
w("\t\t\tchildren = (")
w(f"\t\t\t\t{PID_APP_REF} /* iOS 6.app */,")
w("\t\t\t);")
w("\t\t\tname = Products;")
w("\t\t\tsourceTree = \"<group>\";")
w("\t\t};")
w(f"\t\t{PID_APP_GROUP} /* iOS6Sim */ = {{")
w("\t\t\tisa = PBXGroup;")
w("\t\t\tchildren = (")
w(f"\t\t\t\t{PID_PLIST_REF} /* Info.plist */,")
w(f"\t\t\t\t{file_ids['iOS6Sim/iOS6SimApp.swift']} /* iOS6SimApp.swift */,")
w(f"\t\t\t\t{PID_SIM_GROUP} /* Simulator */,")
w(f"\t\t\t\t{PID_APPS_GROUP} /* Apps */,")
w("\t\t\t);")
w("\t\t\tpath = iOS6Sim;")
w("\t\t\tsourceTree = \"<group>\";")
w("\t\t};")
w(f"\t\t{PID_SIM_GROUP} /* Simulator */ = {{")
w("\t\t\tisa = PBXGroup;")
w("\t\t\tchildren = (")
for f in SWIFT_FILES:
    if "/Simulator/" in f:
        w(f"\t\t\t\t{file_ids[f]} /* {os.path.basename(f)} */,")
w("\t\t\t);")
w("\t\t\tpath = Simulator;")
w("\t\t\tsourceTree = \"<group>\";")
w("\t\t};")
w(f"\t\t{PID_APPS_GROUP} /* Apps */ = {{")
w("\t\t\tisa = PBXGroup;")
w("\t\t\tchildren = (")
for f in SWIFT_FILES:
    if "/Apps/" in f:
        w(f"\t\t\t\t{file_ids[f]} /* {os.path.basename(f)} */,")
w("\t\t\t);")
w("\t\t\tpath = Apps;")
w("\t\t\tsourceTree = \"<group>\";")
w("\t\t};")
w("/* End PBXGroup section */")
w("")

# --- PBXNativeTarget ---
w("/* Begin PBXNativeTarget section */")
w(f"\t\t{PID_TARGET} /* iOS6Sim */ = {{")
w("\t\t\tisa = PBXNativeTarget;")
w("\t\t\tbuildConfigurationList = " + PID_TARGET_CONFIG_LIST + " /* Build configuration list for PBXNativeTarget \"iOS6Sim\" */;")
w("\t\t\tbuildPhases = (")
w(f"\t\t\t\t{PID_SOURCES} /* Sources */,")
w(f"\t\t\t\t{PID_FRAMEWORKS} /* Frameworks */,")
w(f"\t\t\t\t{PID_RESOURCES} /* Resources */,")
w("\t\t\t);")
w("\t\t\tbuildRules = (")
w("\t\t\t);")
w("\t\t\tdependencies = (")
w("\t\t\t);")
w("\t\t\tname = iOS6Sim;")
w("\t\t\tproductName = iOS6Sim;")
w(f"\t\t\tproductReference = {PID_APP_REF} /* iOS 6.app */;")
w("\t\t\tproductType = \"com.apple.product-type.application\";")
w("\t\t};")
w("/* End PBXNativeTarget section */")
w("")

# --- PBXProject ---
w("/* Begin PBXProject section */")
w(f"\t\t{PID_PROJECT} /* Project object */ = {{")
w("\t\t\tisa = PBXProject;")
w("\t\t\tbuildConfigurationList = " + PID_PROJ_CONFIG_LIST + " /* Build configuration list for PBXProject \"iOS6Sim\" */;")
w("\t\t\tcompatibilityVersion = \"Xcode 14.0\";")
w("\t\t\tdevelopmentRegion = en;")
w("\t\t\thasScannedForEncodings = 0;")
w("\t\t\tknownRegions = (")
w("\t\t\t\ten,")
w("\t\t\t);")
w("\t\t\tmainGroup = " + PID_MAIN_GROUP + ";")
w(f"\t\t\tproductRefGroup = {PID_PRODUCTS_GROUP} /* Products */;")
w("\t\t\tprojectDirPath = \"\";")
w("\t\t\tprojectRoot = \"\";")
w("\t\t\ttargets = (")
w(f"\t\t\t\t{PID_TARGET} /* iOS6Sim */,")
w("\t\t\t);")
w("\t\t};")
w("/* End PBXProject section */")
w("")

# --- Build phases ---
w("/* Begin PBXSourcesBuildPhase section */")
w(f"\t\t{PID_SOURCES} /* Sources */ = {{")
w("\t\t\tisa = PBXSourcesBuildPhase;")
w("\t\t\tbuildActionMask = 2147483647;")
w("\t\t\tfiles = (")
for f in SWIFT_FILES:
    w(f"\t\t\t\t{build_ids[f]} /* {os.path.basename(f)} in Sources */,")
w("\t\t\t);")
w("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
w("\t\t};")
w("/* End PBXSourcesBuildPhase section */")
w("")
w("/* Begin PBXFrameworksBuildPhase section */")
w(f"\t\t{PID_FRAMEWORKS} /* Frameworks */ = {{")
w("\t\t\tisa = PBXFrameworksBuildPhase;")
w("\t\t\tbuildActionMask = 2147483647;")
w("\t\t\tfiles = (")
w("\t\t\t);")
w("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
w("\t\t};")
w("/* End PBXFrameworksBuildPhase section */")
w("")
w("/* Begin PBXResourcesBuildPhase section */")
w(f"\t\t{PID_RESOURCES} /* Resources */ = {{")
w("\t\t\tisa = PBXResourcesBuildPhase;")
w("\t\t\tbuildActionMask = 2147483647;")
w("\t\t\tfiles = (")
w("\t\t\t);")
w("\t\t\trunOnlyForDeploymentPostprocessing = 0;")
w("\t\t};")
w("/* End PBXResourcesBuildPhase section */")
w("")

# --- PBXBuildFile ---
w("/* Begin PBXBuildFile section */")
for f in SWIFT_FILES:
    w(f"\t\t{build_ids[f]} /* {os.path.basename(f)} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ids[f]} /* {os.path.basename(f)} */; }};")
w("/* End PBXBuildFile section */")
w("")

# --- XCBuildConfiguration ---
def config(pid, name, is_target, debug):
    w(f"\t\t{pid} /* {name} */ = {{")
    w("\t\t\tisa = XCBuildConfiguration;")
    w("\t\t\tbuildSettings = {")
    if is_target:
        w("\t\t\t\tINFOPLIST_FILE = \"iOS6Sim/Info.plist\";")
        w("\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = \"com.emckeon97.iOS6Sim\";")
        w("\t\t\t\tPRODUCT_NAME = \"iOS 6\";")
        w("\t\t\t\tSDKROOT = iphoneos;")
        w("\t\t\t\tSWIFT_VERSION = 5.0;")
        w("\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;")
        w("\t\t\t\tTARGETED_DEVICE_FAMILY = 1;")
        w("\t\t\t\tCODE_SIGN_STYLE = Automatic;")
        w("\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;")
        w("\t\t\t\tASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;")
        if debug:
            w("\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = \"-Onone\";")
    else:
        w("\t\t\t\tSDKROOT = iphoneos;")
    w("\t\t\t};")
    w(f"\t\t\tname = {name};")
    w("\t\t};")

w("/* Begin XCBuildConfiguration section */")
config(PID_DEBUG_PROJ, "Debug", False, True)
config(PID_RELEASE_PROJ, "Release", False, False)
config(PID_DEBUG_TARGET, "Debug", True, True)
config(PID_RELEASE_TARGET, "Release", True, False)
w("/* End XCBuildConfiguration section */")
w("")

# --- XCConfigurationList ---
w("/* Begin XCConfigurationList section */")
w(f"\t\t{PID_PROJ_CONFIG_LIST} /* Build configuration list for PBXProject \"iOS6Sim\" */ = {{")
w("\t\t\tisa = XCConfigurationList;")
w("\t\t\tbuildConfigurations = (")
w(f"\t\t\t\t{PID_DEBUG_PROJ} /* Debug */,")
w(f"\t\t\t\t{PID_RELEASE_PROJ} /* Release */,")
w("\t\t\t);")
w("\t\t\tdefaultConfigurationIsVisible = 0;")
w("\t\t\tdefaultConfigurationName = Release;")
w("\t\t};")
w(f"\t\t{PID_TARGET_CONFIG_LIST} /* Build configuration list for PBXNativeTarget \"iOS6Sim\" */ = {{")
w("\t\t\tisa = XCConfigurationList;")
w("\t\t\tbuildConfigurations = (")
w(f"\t\t\t\t{PID_DEBUG_TARGET} /* Debug */,")
w(f"\t\t\t\t{PID_RELEASE_TARGET} /* Release */,")
w("\t\t\t);")
w("\t\t\tdefaultConfigurationIsVisible = 0;")
w("\t\t\tdefaultConfigurationName = Release;")
w("\t\t};")
w("/* End XCConfigurationList section */")
w("")
w("\t};")
w("\trootObject = " + PID_PROJECT + " /* Project object */;")
w("}")

out = os.path.join(SRC, "iOS6Sim.xcodeproj", "project.pbxproj")
with open(out, "w") as fh:
    fh.write("\n".join(L) + "\n")
print(f"wrote {out} ({os.path.getsize(out)} bytes)")
