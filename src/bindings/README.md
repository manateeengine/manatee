# Manatee Bindings

## Introduction

Manatee is built with the goal of "have as few dependencies as possible", however this goal only
encompasses other Zig dependencies, system libraries and APIs are still fair game, and 100%
necessary. This portion of Manatee's codebase contains idiomatic Zig bindings of various system
APIs, libraries, and frameworks across multiple platforms.

## A Quick Disclaimer

These bindings are not designed to be complete Zig implementations of these APIs, but rather a
bare-minimum subset required for Manatee functionality. Additionally, these bindings are maintained
by-hand (for now), but I'll eventually figure out a way to generate them based off of API specs in
the future. Given these limitations, I can't currently recommend using these outside of Manatee. At
some point in the future, I'll probably move these to their own repos (and actually create complete
generated bindings), but that'll be very far after Manatee's v0 release.

## Supported Bindings

As of right now, Manatee has bindings for the following:

### Universal

* Vulkan

### MacOS

* Objective-C Runtime
* Foundation
* CoreGraphics
* Quartz (CoreAnimation)
* AppKit

### Windows

* WinBase
* WinDef (A few opaque types but not much else)
* WinUser

### SteamOS / Arch Linux

No bindings for SteamOS are available at this time, but that should change shortly!

## Planned Bindings

Although there's no timeline, I plan on adding the following bindings to Manatee:

* Blender (Specifically importing of .blend files)
* D3D12
* Jolt Physics (No way in hell I'm writing my own physics engine, FUCK that)
* Metal
* OpenGL
* Steam

There're probably a lot more that I'm forgetting about, but eh.

## The Anatomy of a Binding

### Folder Structure

I try to format my bindings in the exact same way every time (at least from here on out lol). Each
binding will always be based off of the following structure:

```text
bindings/
├── <binding_name>/
│   ├── <section_1_name>/
│   │   └── <subsection_name>.zig
│   ├── <section_1_name>.zig
│   └── <section_2_name>.zig
└── <binding_name>.zig
```

The top-level `bindings/<binding_name>.zig` file exists to reexport nested code and to provide a
doc comment with links and helpful context about the binding. The real meat of the binding can be
found in the `bindings/<binding_name>` folder. I haven't found a super scientific way to separate
these bindings into files, but I generally tend to separate them into the same sections that're
defined in the docs, and if there aren't any sections defined in the docs, I'll separate them by
the name of their header. It's not a perfect system, but it makes sense to me. Additionally, each
binding contains a `c.zig` file for defining any necessary opaque types, external functions, and
external structs.

### File Structure

Each file in the binding will be sorted into the following sections, with each section internally
being sorted alphabetically:

1. Opaque Types
2. Constants
3. Enums
4. Structs / Mixins
5. Functions
6. Other

### Code Transformations

When creating these bindings, I generally like to keep things as close to their original API as
possible, however I do a little bit of transformation, including:

1. Ensuring variable naming conventions match the conventions used in Zig's STD. This means
   1. Types, structs, and enums are written in `PascalCase`
   2. Functions are written in camelCase (unless they're generics, which use `PascalCase`)
   3. Everything else is `snake_case`
2. Reducing redundancy. Let's take the Vulkan bindings for example: everything has a `Vk` prefix,
   and we really don't need that given our usage will be something along the lines of
   `vulkan.Device` - it'd be redundant to say `vulkan.VkDevice` instead. Another VUlkan example:
   any function parameters that require pointers will be prefixed with `p` (i.e. `pDevice`), but
   we don't need that level of redundancy, as Zig will fail to compile if we pass a non-pointer to
   a pointer parameter.
3. TODO: Write docs on idiomatic transformations (`init`, `deinit`, `create`, `destroy`, etc)
4. TODO: Write docs on compensation for bindings requiring class inheritance

The notable exception to this is functions marked as `extern`. These functions should always have
identical names to their original API functions so they can be correctly linked at runtime, and
should be private, or wrapped with a correctly-named function if public.
