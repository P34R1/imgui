const std = @import("std");

const c = @import("c");

const imgui = @import("../imgui.zig");
const Vec2 = imgui.Vec2;

min: Vec2,
max: Vec2,
ex: Ex,

pub const Ex = struct {
    rounding: f32 = 0,
    flags: c.ImDrawFlags = 0,
};

test {
    std.testing.refAllDecls(@This());
}
