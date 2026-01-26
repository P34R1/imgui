const std = @import("std");

const c = @import("c");
pub const Io = c.ImGuiIO;
pub const newFrame = c.ImGui_NewFrame;
pub const render = c.ImGui_Render;
pub const getDrawData = c.ImGui_GetDrawData;
pub const getIO = c.ImGui_GetIO;
pub const styleColorsDark = c.ImGui_StyleColorsDark;
pub const createContext = c.ImGui_CreateContext;
pub const destroyContext = c.ImGui_DestroyContext;
pub const end = c.ImGui_End;

pub const DrawList = @import("DrawList.zig");
pub const impl_dx11 = @import("impl_dx11.zig");
pub const impl_win32 = @import("impl_win32.zig");

/// - Begin() = push window to the stack and start appending to it. End() = pop window from the stack.
/// - Passing 'bool* p_open != NULL' shows a window-closing widget in the upper-right corner of the window,
///   which clicking will set the boolean to false when clicked.
/// - You may append multiple times to the same window during the same frame by calling Begin()/End() pairs multiple times.
///   Some information such as 'flags' or 'p_open' will only be considered by the first call to Begin().
/// - Begin() return false to indicate the window is collapsed or fully clipped, so you may early out and omit submitting
///   anything to the window. Always call a matching End() for each Begin() call, regardless of its return value!
///   [Important: due to legacy reason, Begin/End and BeginChild/EndChild are inconsistent with all other functions
///    such as BeginMenu/EndMenu, BeginPopup/EndPopup, etc. where the EndXXX call should only be called if the corresponding
///    BeginXXX function returned true. Begin and BeginChild are the only odd ones out. Will be fixed in a future update.]
/// - Note that the bottom of window stack always contains a window called "Debug".
pub fn begin(name: [*:0]const u8, p_open: ?*bool, flags: c.ImGuiWindowFlags) bool {
    return c.ImGui_Begin(name, p_open, flags);
}

pub fn text(comptime fmt: []const u8, args: anytype) void {
    var buf: [8192]u8 = undefined;
    const txt = std.fmt.bufPrint(&buf, fmt, args) catch unreachable;
    c.ImGui_TextUnformattedEx(txt.ptr, txt.ptr + txt.len);
}

pub const Col = packed struct {
    r: u8 = 0,
    g: u8 = 0,
    b: u8 = 0,
    a: u8 = 255,

    pub fn rgb(r: u8, g: u8, b: u8) @This() {
        return .{ .r = r, .g = g, .b = b };
    }

    pub fn rgba(r: u8, g: u8, b: u8, a: u8) @This() {
        return .{ .r = r, .g = g, .b = b, .a = a };
    }

    pub fn into(self: @This()) c.ImU32 {
        return @bitCast(self);
    }
};

pub const Vec2 = struct {
    x: f32,
    y: f32,

    pub fn new(x: f32, y: f32) @This() {
        return .{ .x = x, .y = y };
    }

    pub fn into(self: @This()) c.ImVec2 {
        return .{ .x = self.x, .y = self.y };
    }
};

test {
    std.testing.refAllDecls(@This());
}
