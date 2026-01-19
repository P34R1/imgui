const std = @import("std");

const c = @import("c");
pub const CreateDeviceObjects = c.cImGui_ImplDX11_CreateDeviceObjects;
pub const InvalidateDeviceObjects = c.cImGui_ImplDX11_InvalidateDeviceObjects;
pub const Init = c.cImGui_ImplDX11_Init;
pub const Shutdown = c.cImGui_ImplDX11_Shutdown;
pub const NewFrame = c.cImGui_ImplDX11_NewFrame;
pub const RenderDrawData = c.cImGui_ImplDX11_RenderDrawData;

test {
    std.testing.refAllDecls(@This());
}
