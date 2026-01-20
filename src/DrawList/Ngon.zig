const std = @import("std");

const c = @import("c");

const imgui = @import("../imgui.zig");
const Vec2 = imgui.Vec2;

center: Vec2,
radius: f32,
num_segments: c_int,

test {
    std.testing.refAllDecls(@This());
}
