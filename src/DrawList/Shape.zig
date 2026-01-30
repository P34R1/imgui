const std = @import("std");

const c = @import("c");

const imgui = @import("../imgui.zig");
const Vec2 = imgui.Vec2;
const shapes = @import("shapes.zig");
pub const Circle = shapes.Circle;
pub const Triangle = shapes.Triangle;
pub const Ellipse = shapes.Ellipse;
pub const Line = shapes.Line;
pub const Ngon = shapes.Ngon;
pub const Quad = shapes.Quad;
pub const Rect = shapes.Rect;

/// `null` means filled shape.
thickness: ?f32,
inner: union(enum) { line: Line, rect: Rect, triangle: Triangle, quad: Quad, circle: Circle, ellipse: Ellipse, ngon: Ngon },

pub fn line(p1: Vec2, p2: Vec2, thickness: f32) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .line = .{ .p1 = p1, .p2 = p2 } } };
}

pub fn triangle(p1: Vec2, p2: Vec2, p3: Vec2, thickness: ?f32) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .triangle = .{ .p1 = p1, .p2 = p2, .p3 = p3 } } };
}

pub fn filledTriangle(p1: Vec2, p2: Vec2, p3: Vec2) @This() {
    return triangle(p1, p2, p3, null);
}

pub fn rect(min: Vec2, max: Vec2, ex: Rect.Ex, thickness: ?f32) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .rect = .{ .min = min, .max = max, .ex = ex } } };
}

pub fn filledRect(min: Vec2, max: Vec2, ex: Rect.Ex) @This() {
    return rect(min, max, ex, null);
}

pub fn quad(p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2, thickness: ?f32) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .quad = .{ .p1 = p1, .p2 = p2, .p3 = p3, .p4 = p4 } } };
}

pub fn filledQuad(p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2) @This() {
    return quad(p1, p2, p3, p4, null);
}

pub fn circle(center: Vec2, radius: f32, ex: Circle.Ex, thickness: ?f32) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .circle = .{ .center = center, .radius = radius, .ex = ex } } };
}

pub fn filledCircle(center: Vec2, radius: f32, ex: Circle.Ex) @This() {
    return circle(center, radius, ex, null);
}

pub fn ellipse(center: Vec2, radius: Vec2, ex: Ellipse.Ex, thickness: ?f32) @This() {
    return @This(){ .thickness = thickness, .inner = .{ .ellipse = .{ .center = center, .radius = radius, .ex = ex } } };
}

pub fn filledEllipse(center: Vec2, radius: Vec2, ex: Ellipse.Ex) @This() {
    return ellipse(center, radius, ex, null);
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
