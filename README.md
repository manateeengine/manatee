# Manatee

The Manatee Game Engine

## Source Code Structure

Manatee's source code will eventually be significantly larger than most Zig projects that currently
exist, especially considering one of the goals for the engine is "keep everything in one repo".
With these constraints in mind, Manatee is structured a little bit differently than most Zig
projects, and observes the following directory structure:

```text
.
├── .github - GitHub Configuration for CI and PR Templates
├── .vscode - Editor Configuration for Visual Studio Code
├── src/
│   ├── modules/
│   │   ├── build - The Manatee Build module
│   │   ├── editor - The Manatee Editor module
│   │   └── engine - The Manatee Engine module
│   ├── main.zig - The main entrypoint for the Manatee editor
│   ├── main_lib.zig - The main entrypoint for Manatee's C lib
│   └── main_module.zig - The main entrypoint for the Manatee engine Zig module
├── build.zig - Zig Build File
├── build.zig.zon - Zig Package Manager Config
├── LICENSE - Manatee's License
└── README.md - Manatee's Readme
```

Note the three distinct `main` files, these are used by Manatee's build module and are located at
the root level to provide first-class support for ZLS. Everything else is contained in its own
independent folder inside `src/modules`, with each model having its own `main.zig` to serve as its
respective entrypoint.

## Getting Started

TODO: Get the engine to a complete enough state to where I can write actual getting started
instructions so that my documentation can be so much better than anything UE5 has ever put out
(fuck you Tim Sweeney, you know what you did).
