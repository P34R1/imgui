const std = @import("std");

const c = @import("c");

const imgui = @import("../imgui.zig");
const Vec2 = imgui.Vec2;

center: Vec2,
radius: Vec2,
ex: Ex,

pub const Ex = struct {
    rot: f32 = 0,
    num_segments: c_int = 0,
};

test {
    std.testing.refAllDecls(@This());
}
