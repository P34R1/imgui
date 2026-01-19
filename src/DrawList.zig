const c = @import("c");

const imgui = @import("imgui.zig");
const Vec2 = imgui.Vec2;
const Col = imgui.Col;

inner: c.ImDrawList,

pub const Shape = union(enum) {
    _line: struct { p1: Vec2, p2: Vec2, ex: LineEx },
    _rect: struct { min: Vec2, max: Vec2, ex: RectEx },
    _triangle: struct { p1: Vec2, p2: Vec2, p3: Vec2, ex: TriangleEx },
    _quad: struct { p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2, ex: QuadEx },
    _circle: struct { center: Vec2, radius: f32, ex: CircleEx },
    _ellipse: struct { center: Vec2, radius: Vec2, ex: EllipseEx },
    _ngon: struct { center: Vec2, radius: f32, num_segments: c_int, ex: NgonEx },

    pub const LineEx = struct { thickness: f32 = 1 };
    pub fn line(p1: Vec2, p2: Vec2, ex: LineEx) @This() {
        return Shape{ ._line = .{ .p1 = p1, .p2 = p2, .ex = ex } };
    }

    pub const RectEx = struct { rounding: f32 = 0, flags: c.ImDrawFlags = 0, thickness: f32 = 1 };
    pub fn rect(min: Vec2, max: Vec2, ex: RectEx) @This() {
        return Shape{ ._rect = .{ .min = min, .max = max, .ex = ex } };
    }

    pub const TriangleEx = struct { thickness: f32 = 1 };
    pub fn triangle(p1: Vec2, p2: Vec2, p3: Vec2, ex: TriangleEx) @This() {
        return Shape{ ._triangle = .{ .p1 = p1, .p2 = p2, .p3 = p3, .ex = ex } };
    }

    pub const QuadEx = struct { thickness: f32 = 1 };
    pub fn quad(p1: Vec2, p2: Vec2, p3: Vec2, p4: Vec2, ex: QuadEx) @This() {
        return Shape{ ._quad = .{ .p1 = p1, .p2 = p2, .p3 = p3, .p4 = p4, .ex = ex } };
    }

    pub const CircleEx = struct { num_segments: c_int = 0, thickness: f32 = 1 };
    pub fn circle(center: Vec2, radius: f32, ex: CircleEx) @This() {
        return Shape{ ._circle = .{ .center = center, .radius = radius, .ex = ex } };
    }

    pub const EllipseEx = struct { rot: f32 = 0, num_segments: c_int = 0, thickness: f32 = 1 };
    pub fn ellipse(center: Vec2, radius: Vec2, ex: EllipseEx) @This() {
        return Shape{ ._ellipse = .{ .center = center, .radius = radius, .ex = ex } };
    }

    pub const NgonEx = struct { thickness: f32 = 1 };
    pub fn ngon(center: Vec2, radius: f32, num_segments: c_int, ex: NgonEx) @This() {
        return Shape{ ._ngon = .{ .center = center, .radius = radius, .num_segments = num_segments, .ex = ex } };
    }
};

// Primitives
// - Filled shapes must always use clockwise winding order. The anti-aliasing fringe depends on it. Counter-clockwise shapes will have "inward" anti-aliasing.
// - For rectangular primitives, "p_min" and "p_max" represent the upper-left and lower-right corners.
// - For circle primitives, use "num_segments == 0" to automatically calculate tessellation (preferred).
//   In older versions (until Dear ImGui 1.77) the AddCircle functions defaulted to num_segments == 12.
//   In future versions we will use textures to provide cheaper and higher-quality circles.
//   Use AddNgon() and AddNgonFilled() functions if you need to guarantee a specific number of sides
pub fn add(self: *@This(), shape: Shape, colour: Col, filled: bool) void {
    if (filled)
        return addFilled(self, shape, colour);

    const col = colour.into();
    switch (shape) {
        ._line => |s| c.ImDrawList_AddLineEx(self.into(), s.p1.into(), s.p2.into(), col, s.ex.thickness),
        ._rect => |s| c.ImDrawList_AddRectEx(self.into(), s.min.into(), s.max.into(), col, s.ex.rounding, s.ex.flags, s.ex.thickness),
        ._triangle => |s| c.ImDrawList_AddTriangleEx(self.into(), s.p1.into(), s.p2.into(), s.p3.into(), col, s.ex.thickness),
        ._quad => |s| c.ImDrawList_AddQuadEx(self.into(), s.p1.into(), s.p2.into(), s.p3.into(), s.p4.into(), col, s.ex.thickness),
        ._circle => |s| c.ImDrawList_AddCircleEx(self.into(), s.center.into(), s.radius, col, s.ex.num_segments, s.ex.thickness),
        ._ellipse => |s| c.ImDrawList_AddEllipseEx(self.into(), s.center.into(), s.radius.into(), col, s.ex.rot, s.ex.num_segments, s.ex.thickness),
        ._ngon => |s| c.ImDrawList_AddNgonEx(self.into(), s.center.into(), s.radius, col, s.num_segments, s.ex.thickness),
    }
}

pub fn addFilled(self: *@This(), shape: Shape, colour: Col) void {
    const col = colour.into();
    switch (shape) {
        ._line => unreachable,
        ._rect => |s| c.ImDrawList_AddRectFilledEx(self.into(), s.min.into(), s.max.into(), col, s.ex.rounding, s.ex.flags),
        ._triangle => |s| c.ImDrawList_AddTriangleFilled(self.into(), s.p1.into(), s.p2.into(), s.p3.into(), col),
        ._quad => |s| c.ImDrawList_AddQuadFilled(self.into(), s.p1.into(), s.p2.into(), s.p3.into(), s.p4.into(), col),
        ._circle => |s| c.ImDrawList_AddCircleFilled(self.into(), s.center.into(), s.radius, col, s.ex.num_segments),
        ._ellipse => |s| c.ImDrawList_AddEllipseFilledEx(self.into(), s.center.into(), s.radius.into(), col, s.ex.rot, s.ex.num_segments),
        ._ngon => |s| c.ImDrawList_AddNgonFilled(self.into(), s.center.into(), s.radius, col, s.num_segments),
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
