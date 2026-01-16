const c = @import("c");
pub const IO = c.ImGuiIO;
pub const newFrame = c.ImGui_NewFrame;
pub const render = c.ImGui_Render;
pub const GetDrawData = c.ImGui_GetDrawData;
pub const GetIO = c.ImGui_GetIO;
pub const StyleColorsDark = c.ImGui_StyleColorsDark;

pub const ImplDX11 = struct {
    pub const CreateDeviceObjects = c.cImGui_ImplDX11_CreateDeviceObjects;
    pub const InvalidateDeviceObjects = c.cImGui_ImplDX11_InvalidateDeviceObjects;

    pub const Init = c.cImGui_ImplDX11_Init;
    pub const Shutdown = c.cImGui_ImplDX11_Shutdown;

    pub const NewFrame = c.cImGui_ImplDX11_NewFrame;
    pub const RenderDrawData = c.cImGui_ImplDX11_RenderDrawData;
};

pub const ImplWin32 = struct {
    pub const Init = c.cImGui_ImplWin32_Init;
    pub const Shutdown = c.cImGui_ImplWin32_Shutdown;

    pub const NewFrame = c.cImGui_ImplWin32_NewFrame;
    pub const WndProcHandler = c.cImGui_ImplWin32_WndProcHandler;
};

pub fn createContext(shared_font_atlas: ?*c.ImFontAtlas) ?*c.ImGuiContext {
    return c.ImGui_CreateContext(shared_font_atlas);
}

pub fn destroyContext(ctx: ?*c.ImGuiContext) void {
    return c.ImGui_DestroyContext(ctx);
}

/// Windows
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
pub fn begin(name: [*:0]const u8, p_open: ?*bool, flags: c_int) bool {
    return c.ImGui_Begin(name, p_open, flags);
}
pub fn end() void {
    c.ImGui_End();
}

pub const Text = @extern(*const fn (fmt: [*:0]const u8, ...) callconv(.c) void, .{ .name = "ImGui_Text" });

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

pub const DrawList = extern struct {
    inner: c.ImDrawList,

    pub fn getForeground() *@This() {
        return @ptrCast(c.ImGui_GetForegroundDrawList());
    }

    pub fn getBackground() *@This() {
        return @ptrCast(c.ImGui_GetBackgroundDrawList());
    }

    pub fn addRectEx(self: *@This(), min: Vec2, max: Vec2, col: Col, rounding: f32, flags: c.ImDrawFlags, thickness: f32) void {
        return c.ImDrawList_AddRectEx(@ptrCast(self), min.into(), max.into(), col.into(), rounding, flags, thickness);
    }
};
