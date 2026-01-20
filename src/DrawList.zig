const std = @import("std");

const c = @import("c");

const imgui = @import("imgui.zig");
const Vec2 = imgui.Vec2;
const Col = imgui.Col;

inner: c.ImDrawList,

/// wrapper for c.ImDrawList_AddShapeEx
pub const Shape = struct {
    /// `null` means filled shape.
    thickness: ?f32,
    inner: union(enum) {
        line: struct { p1: Vec2, p2: Vec2 },
        rect: struct { min: Vec2, max: Vec2, ex: RectEx },
        triangle: struct { p1: Vec2, p2: Vec2, p3: Vec2 },
        quad: struct { p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2 },
        circle: struct { center: Vec2, radius: f32, ex: CircleEx },
        ellipse: struct { center: Vec2, radius: Vec2, ex: EllipseEx },
        ngon: struct { center: Vec2, radius: f32, num_segments: c_int },
    },

    pub fn line(p1: Vec2, p2: Vec2, thickness: f32) @This() {
        return @This(){ .thickness = thickness, .inner = .line{ .p1 = p1, .p2 = p2 } };
    }

    pub const RectEx = struct { rounding: f32 = 0, flags: c.ImDrawFlags = 0 };
    pub fn rect(min: Vec2, max: Vec2, thickness: ?f32, ex: RectEx) @This() {
        return @This(){ .thickness = thickness, .inner = .rect{ .min = min, .max = max, .ex = ex } };
    }

    pub fn triangle(p1: Vec2, p2: Vec2, p3: Vec2, thickness: ?f32) @This() {
        return @This(){ .thickness = thickness, .inner = .triangle{ .p1 = p1, .p2 = p2, .p3 = p3 } };
    }

    pub fn quad(p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2, thickness: ?f32) @This() {
        return @This(){ .thickness = thickness, .inner = .quad{ .p1 = p1, .p2 = p2, .p3 = p3, .p4 = p4 } };
    }

    pub const CircleEx = struct { num_segments: c_int = 0 };
    pub fn circle(center: Vec2, radius: f32, thickness: ?f32, ex: CircleEx) @This() {
        return @This(){ .thickness = thickness, .inner = .circle{ .center = center, .radius = radius, .ex = ex } };
    }

    pub const EllipseEx = struct { rot: f32 = 0, num_segments: c_int = 0 };
    pub fn ellipse(center: Vec2, radius: Vec2, thickness: ?f32, ex: EllipseEx) @This() {
        return @This(){ .thickness = thickness, .inner = .ellipse{ .center = center, .radius = radius, .ex = ex } };
    }

    pub fn ngon(center: Vec2, radius: f32, num_segments: c_int, thickness: ?f32) @This() {
        return @This(){ .thickness = thickness, .inner = .ngon{ .center = center, .radius = radius, .num_segments = num_segments } };
    }
};

// Primitives
// - Filled shapes must always use clockwise winding order. The anti-aliasing fringe depends on it. Counter-clockwise shapes will have "inward" anti-aliasing.
// - For rectangular primitives, "p_min" and "p_max" represent the upper-left and lower-right corners.
// - For circle primitives, use "num_segments == 0" to automatically calculate tessellation (preferred).
//   In older versions (until Dear ImGui 1.77) the AddCircle functions defaulted to num_segments == 12.
//   In future versions we will use textures to provide cheaper and higher-quality circles.
//   Use AddNgon() and AddNgonFilled() functions if you need to guarantee a specific number of sides
pub fn add(drawlist: *@This(), shape: Shape, colour: Col) void {
    const thickness = shape.thickness orelse return addFilled(drawlist, shape, colour);

    const col = colour.into();
    const self = drawlist.into();

    switch (shape.inner) {
        .line => |s| c.ImDrawList_AddLineEx(self, s.p1.into(), s.p2.into(), col, thickness),
        .rect => |s| c.ImDrawList_AddRectEx(self, s.min.into(), s.max.into(), col, s.ex.rounding, s.ex.flags, thickness),
        .triangle => |s| c.ImDrawList_AddTriangleEx(self, s.p1.into(), s.p2.into(), s.p3.into(), col, thickness),
        .quad => |s| c.ImDrawList_AddQuadEx(self, s.p1.into(), s.p2.into(), s.p3.into(), s.p4.into(), col, thickness),
        .circle => |s| c.ImDrawList_AddCircleEx(self, s.center.into(), s.radius, col, s.ex.num_segments, thickness),
        .ellipse => |s| c.ImDrawList_AddEllipseEx(self, s.center.into(), s.radius.into(), col, s.ex.rot, s.ex.num_segments, thickness),
        .ngon => |s| c.ImDrawList_AddNgonEx(self, s.center.into(), s.radius, col, s.num_segments, thickness),
    }
}

pub fn addFilled(drawlist: *@This(), shape: Shape, colour: Col) void {
    std.debug.assert(shape.thickness == null);

    const col = colour.into();
    const self = drawlist.into();

    switch (shape.inner) {
        .line => unreachable,
        .rect => |s| c.ImDrawList_AddRectFilledEx(self, s.min.into(), s.max.into(), col, s.ex.rounding, s.ex.flags),
        .triangle => |s| c.ImDrawList_AddTriangleFilled(self, s.p1.into(), s.p2.into(), s.p3.into(), col),
        .quad => |s| c.ImDrawList_AddQuadFilled(self, s.p1.into(), s.p2.into(), s.p3.into(), s.p4.into(), col),
        .circle => |s| c.ImDrawList_AddCircleFilled(self, s.center.into(), s.radius, col, s.ex.num_segments),
        .ellipse => |s| c.ImDrawList_AddEllipseFilledEx(self, s.center.into(), s.radius.into(), col, s.ex.rot, s.ex.num_segments),
        .ngon => |s| c.ImDrawList_AddNgonFilled(self, s.center.into(), s.radius, col, s.num_segments),
    }
}

pub fn getForeground() *@This() {
    return @ptrCast(c.ImGui_GetForegroundDrawList());
}

pub fn getBackground() *@This() {
    return @ptrCast(c.ImGui_GetBackgroundDrawList());
}

pub fn into(self: *@This()) *c.ImDrawList {
    return &self.inner;
}

test {
    std.testing.refAllDecls(@This());
}
