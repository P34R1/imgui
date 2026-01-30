const std = @import("std");

const c = @import("c");

const Shape = @import("DrawList/Shape.zig");
const imgui = @import("imgui.zig");
const Vec2 = imgui.Vec2;
const Col = imgui.Col;

inner: c.ImDrawList,

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
        .text => |s| c.ImDrawList_AddTextEx(self, s.pos.into(), col, s.text.ptr, s.text.ptr + s.text.len),
    }
}

fn addFilled(drawlist: *@This(), shape: Shape, colour: Col) void {
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
        .text => unreachable,
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
