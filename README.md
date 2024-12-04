# Manatee

The Manatee Game Engine

## Prerequisites

Development with Manatee has different prerequisites depending on the operating system you're
targeting, such as system SDKs and dynamic libraries. In order to ensure Manatee complies with all
license agreements, and not forcing users to agree to a license for a system they're not building
for simply by using Manatee, these prerequisites are not included in the repo and must be installed
manually.

### Global Prerequisites

- [Zig Nightly](https://ziglang.org/download/). See
  [A Note About Zig Versioning](#A%20NoteA%20AboutA%20ZigA%20Versioning) for my rationale as to why
  Manatee requires the nightly build of Zig.
- All OS-Specific prerequisites for your target operating system

### MacOS Prerequisites

- [XCode](https://developer.apple.com/xcode/). XCode contains the Objective-C runtime and all of
  the required MacOS frameworks for building games, such as AppKit and Metal.
  - Note, although it shares the name, XCode is not the same thing as the XCode command line
    tools. These tools include various utilities for development on MacOS, such as Git and the
    Apple LLVM. These tools should be included with an XCode install, and if you have these tools
    already installed but don't have XCode installed, you won't need to uninstall them to install
    XCode.
- An [Apple Developer Program](https://developer.apple.com/programs/) Membership (only required for
  publishing).
  - Apple terms of service, an Apple Developer Program membership is required to publish MacOS
    apps, so you'll need one before you publish anything with Manatee when targeting MacOS.

### Windows Prerequisites

- The [Windows SDK]()

### Optional But Recommended Tools

- [Visual Studio Code](https://code.visualstudio.com/). As of right now, Manatee only has official
  support for VS Code, however I plan on adding support for other editors once the engine is a
  little closer to a completed stage. Pull requests that add more builtin editor support are more
  than welcome!
  - Alongside VS Code, I highly recommend installing all of the extensions found in the file
    `.vscode/extensions.json`. This will make your life significantly easier, and if you install
    the Zig extension, there's the added bonus of being able to manage your Zig and ZLS
    installations directly from VS Code, making updating to the latest nightly build super easy.

### A Note About Zig Versioning

As of right now, Manatee runs on the latest, nightly release of Zig. Once Zig hits version 1.0.0,
I'll likely change this requirement to the most current, stable release of Zig. Using nightly
ensures Manatee stays up to date with the most current Zig feature set and syntax, ensuring
stability around future releases.

With all of that in mind, Manatee should be considered a very early alpha tool, and probably
shouldn't be used for any serious game development.

## Getting Started

TODO: Get the engine to a complete enough state to where I can write actual getting started
instructions so that my documentation can be so much better than anything UE5 has ever put out
(fuck you Tim Sweeney, you know what you did).
