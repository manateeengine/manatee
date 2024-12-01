# Manatee

The Manatee Game Engine

## Getting Started

If this is your first time using Manatee, I highly recommend you complete the following steps to
get started:

1. Install the latest version of VS Code. Manatee only has official support for VS Code at this
   time, however I plan on adding support for other editors once the engine is a little closer to
   a completed stage.
2. Install all of the recommended VS Code extensions found in `.vscode/extensions.json`
3. Install the latest nightly version of Zig and ZLS. I recommend installation via the VS Code Zig
   extension commands.
4. Install the Vulkan SDK. Support for DirectX 12, OpenGL, and Metal is planned for future releases
   as Manatee becomes more stable and feature complete, but as of right now Vulkan is the only
   supported graphics runtime

## A Note About Zig Versioning

As of right now, Manatee runs on the latest, nightly release of Zig. Once Zig hits version 1.0.0,
I'll likely change this requirement to the most current, stable release of Zig. Using nightly
ensures Manatee stays up to date with the most current Zig feature set and syntax, ensuring
stability around future releases.

With all of that in mind, Manatee should be considered a very early alpha tool, and probably
shouldn't be used for any serious game development.
