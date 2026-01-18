const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

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

    const header = b.option([]const u8, "header", "Addition to the header making up the exported c module.") orelse "";
    const dcimgui = b.addTranslateC(.{ .target = target, .optimize = optimize, .root_source_file = b.addWriteFiles().add("headers.hpp", b.fmt(
        \\#define WIN32_LEAN_AND_MEAN
        \\#include <d3d11.h>
        \\{s}
        \\#define IMGUI_BACKEND_HAS_WINDOWS_H
        \\#include <dcimgui.h>
        \\#include <backends/dx11.h>
        \\#include <backends/win32.h>
    , .{header})) });

    dcimgui.addIncludePath(imgui.path(""));
    dcimgui.addIncludePath(b.path("generated"));
    const dcimgui_mod = dcimgui.addModule("c");

    const mod = b.addModule("imgui", .{
        .root_source_file = b.path("src/imgui.zig"),
        .imports = &.{.{ .name = "c", .module = dcimgui_mod }},
        .link_libcpp = true,
        .target = target,
        .optimize = optimize,
    });

    b.getInstallStep().dependOn(&dcimgui.step);

    mod.addIncludePath(imgui.path(""));
    mod.addIncludePath(imgui.path("backends"));
    mod.addIncludePath(b.path("generated"));
    mod.addCSourceFiles(.{ .root = b.path("generated"), .files = &.{
        "dcimgui.cpp",
        "backends/dx11.cpp",
        "backends/win32.cpp",
    } });

    mod.linkSystemLibrary("d3dcompiler_47", .{});
    mod.linkSystemLibrary("gdi32", .{});
    mod.linkSystemLibrary("dwmapi", .{});
    mod.addCSourceFiles(.{ .root = imgui.path(""), .files = &.{
        "imgui.cpp",
        "imgui_demo.cpp",
        "imgui_draw.cpp",
        "imgui_widgets.cpp",
        "imgui_tables.cpp",
        "backends/imgui_impl_dx11.cpp",
        "backends/imgui_impl_win32.cpp",
    } });

    const lib = b.addLibrary(.{
        .name = "imgui",
        .root_module = mod,
    });

    b.installArtifact(lib);
}

const backends = .{ "dx11", "win32" };

fn path(lazy_path: std.Build.LazyPath) []u8 {
    const p = lazy_path.getPath4(lazy_path.dependency.dependency.builder, null) catch unreachable;
    return lazy_path.dependency.dependency.builder.fmt("{f}", .{p});
}
