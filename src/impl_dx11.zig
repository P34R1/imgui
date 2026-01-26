const std = @import("std");

const c = @import("c");
pub const createDeviceObjects = c.cImGui_ImplDX11_CreateDeviceObjects;
pub const invalidateDeviceObjects = c.cImGui_ImplDX11_InvalidateDeviceObjects;
pub const init = c.cImGui_ImplDX11_Init;
pub const shutdown = c.cImGui_ImplDX11_Shutdown;
pub const newFrame = c.cImGui_ImplDX11_NewFrame;
pub const renderDrawData = c.cImGui_ImplDX11_RenderDrawData;

test {
    std.testing.refAllDecls(@This());
}
