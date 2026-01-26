const std = @import("std");

const c = @import("c");
pub const init = c.cImGui_ImplWin32_Init;
pub const shutdown = c.cImGui_ImplWin32_Shutdown;
pub const newFrame = c.cImGui_ImplWin32_NewFrame;
pub const wndProcHandler = c.cImGui_ImplWin32_WndProcHandler;

test {
    std.testing.refAllDecls(@This());
}
