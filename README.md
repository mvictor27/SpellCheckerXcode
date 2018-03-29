# SpellCheckerXcode

[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

Xcode extension that check spelling in swift files 

## Install

1. Clone this repository.
2. Open `SpellCheckerXcode.xcodeproj` in Xcode 9.2 or later
3. Configure signing with your own developer ID on all targets 
4. Quit Xcode.
5. Open a terminal, change to the directory where you cloned and run `xcodebuild -scheme SpellCheckerXcode install DSTROOT=~` to compile the extension.
6. Run `~/Applications/SpellCheckerXcode.app` and quit.
7. Go to System Preferences -> Extensions -> Xcode Source Editor and enable the extension.
8. Open Xcode and the extension should be found in Editor -> Spelling.

## Author

Victor M
