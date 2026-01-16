const c = @import("c");

const imgui = @import("imgui.zig");
const Vec2 = imgui.Vec2;
const Col = imgui.Col;

inner: c.ImDrawList,

pub fn getForeground() *@This() {
    return @ptrCast(c.ImGui_GetForegroundDrawList());
}

pub fn getBackground() *@This() {
    return @ptrCast(c.ImGui_GetBackgroundDrawList());
}

pub const RectOptions = struct { rounding: f32 = 0, flags: c.ImDrawFlags = 0, thickness: f32 = 1 };
pub fn addRect(self: *@This(), min: Vec2, max: Vec2, col: Col, options: RectOptions) void {
    return c.ImDrawList_AddRectEx(@ptrCast(self), min.into(), max.into(), col.into(), options.rounding, options.flags, options.thickness);
}
