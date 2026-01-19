# imgui wrapper

This is a light zig wrapper around imgui using [dear bindings](https://github.com/dearimgui/dear_bindings). This is made only for dx11 and win32.

## Use

To update the bindings create a python .venv with dear bindings requirements.txt installed and run

```sh
zig build update
```

To use in your own project.

```sh
zig fetch --save git+https://github.com/P34R1/imgui
```

```zig
// build.zig
const dep_imgui = b.dependency("imgui", .{
    .header = @as([]const u8, "// extra code for translated c"),
    .target = target,
    .optimize = optimize,
});

// c module (because addTranslateC creates different types for each translation)
const c = dep_imgui.module("c");
// imgui module
const imgui = dep_imgui.module("imgui");
```
