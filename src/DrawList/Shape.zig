const std = @import("std");

const c = @import("c");

const imgui = @import("../imgui.zig");
const Vec2 = imgui.Vec2;
pub const Circle = @import("Circle.zig");
pub const Ellipse = @import("Ellipse.zig");
pub const Line = @import("Line.zig");
pub const Ngon = @import("Ngon.zig");
pub const Quad = @import("Quad.zig");
pub const Rect = @import("Rect.zig");
pub const Triangle = @import("Triangle.zig");

/// `null` means filled shape.
thickness: ?f32,
inner: union(enum) { line: Line, rect: Rect, triangle: Triangle, quad: Quad, circle: Circle, ellipse: Ellipse, ngon: Ngon },

pub fn line(p1: Vec2, p2: Vec2, thickness: f32) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .line = .{ .p1 = p1, .p2 = p2 } } };
}

pub fn rect(min: Vec2, max: Vec2, thickness: ?f32, ex: Rect.Ex) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .rect = .{ .min = min, .max = max, .ex = ex } } };
}

pub fn filledRect(min: Vec2, max: Vec2, ex: Rect.Ex) @This() {
    return rect(min, max, null, ex);
}

pub fn triangle(p1: Vec2, p2: Vec2, p3: Vec2, thickness: ?f32) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .triangle = .{ .p1 = p1, .p2 = p2, .p3 = p3 } } };
}

pub fn filledTriangle(p1: Vec2, p2: Vec2, p3: Vec2) @This() {
    return triangle(p1, p2, p3, null);
}

pub fn quad(p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2, thickness: ?f32) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .quad = .{ .p1 = p1, .p2 = p2, .p3 = p3, .p4 = p4 } } };
}

pub fn filledQuad(p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2) @This() {
    return quad(p1, p2, p3, p4, null);
}

pub fn circle(center: Vec2, radius: f32, thickness: ?f32, ex: Circle.Ex) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .circle = .{ .center = center, .radius = radius, .ex = ex } } };
}

pub fn filledCircle(center: Vec2, radius: f32, ex: Circle.Ex) @This() {
    return circle(center, radius, null, ex);
}

pub fn ellipse(center: Vec2, radius: Vec2, thickness: ?f32, ex: Ellipse.Ex) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .ellipse = .{ .center = center, .radius = radius, .ex = ex } } };
}

pub fn filledEllipse(center: Vec2, radius: Vec2, ex: Ellipse.Ex) @This() {
    return ellipse(center, radius, null, ex);
}

pub fn ngon(center: Vec2, radius: f32, num_segments: c_int, thickness: ?f32) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .ngon = .{ .center = center, .radius = radius, .num_segments = num_segments } } };
}

pub fn filledNgon(center: Vec2, radius: f32, num_segments: c_int) @This() {
    return ngon(center, radius, num_segments, null);
}

test {
    std.testing.refAllDecls(@This());
}
