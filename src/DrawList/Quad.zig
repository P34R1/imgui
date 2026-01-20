const std = @import("std");

const c = @import("c");

const imgui = @import("../imgui.zig");
const Vec2 = imgui.Vec2;

p1: Vec2,
p2: Vec2,
p3: Vec2,
p4: Vec2,

test {
    std.testing.refAllDecls(@This());
}
