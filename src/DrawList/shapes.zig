const std = @import("std");

const c = @import("c");

const imgui = @import("../imgui.zig");
const Vec2 = imgui.Vec2;

test {
    std.testing.refAllDecls(@This());
}

pub const Line = struct {
    p1: Vec2,
    p2: Vec2,
};

pub const Triangle = struct {
    p1: Vec2,
    p2: Vec2,
    p3: Vec2,
};

pub const Rect = struct {
    min: Vec2,
    max: Vec2,
    ex: Ex,

    pub const Ex = struct {
        rounding: f32 = 0,
        flags: c.ImDrawFlags = 0,
    };
};

pub const Quad = struct {
    p1: Vec2,
    p2: Vec2,
    p3: Vec2,
    p4: Vec2,
};

pub const Circle = struct {
    center: Vec2,
    radius: f32,
    ex: Ex,

    pub const Ex = struct {
        num_segments: c_int = 0,
    };
};

pub const Ellipse = struct {
    center: Vec2,
    radius: Vec2,
    ex: Ex,

    pub const Ex = struct {
        rot: f32 = 0,
        num_segments: c_int = 0,
    };
};

pub const Ngon = struct {
    center: Vec2,
    radius: f32,
    num_segments: c_int,
};

pub const Text = struct {
    pos: Vec2,
    buf: [8192]u8,
    len: usize,
};
