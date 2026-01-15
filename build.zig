const std = @import("std");

pub fn build(b: *std.Build) void {
    const imgui = b.dependency("imgui", .{});
    const dear_bindings = b.dependency("dear_bindings", .{});

    const python = ".venv/Scripts/python";
    const dear_bindings_py = path(dear_bindings.path("dear_bindings.py"));
    const imgui_h = path(imgui.path("imgui.h"));

    const gen_dcimgui_h = b.addSystemCommand(&.{ python, dear_bindings_py, "--emit-combined-json-metadata", "-o", "generated/dcimgui", imgui_h });
    const update_step = b.step("update", "Update C ABI bindings.");
    update_step.dependOn(&gen_dcimgui_h.step);

    inline for (backends) |backend| {
        const backend_h = path(imgui.path("backends/imgui_impl_" ++ backend ++ ".h"));
        const gen_backend_h = b.addSystemCommand(&.{ python, dear_bindings_py, "--backend", "--emit-combined-json-metadata", "-o", "generated/backends/" ++ backend, backend_h });
        update_step.dependOn(&gen_backend_h.step);
    }
}

const backends = .{ "dx11", "win32" };

fn path(lazy_path: std.Build.LazyPath) []u8 {
    const p = lazy_path.getPath4(lazy_path.dependency.dependency.builder, null) catch unreachable;
    return lazy_path.dependency.dependency.builder.fmt("{f}", .{p});
}
