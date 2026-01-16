const c = @import("c");
pub const Init = c.cImGui_ImplWin32_Init;
pub const Shutdown = c.cImGui_ImplWin32_Shutdown;
pub const NewFrame = c.cImGui_ImplWin32_NewFrame;
pub const WndProcHandler = c.cImGui_ImplWin32_WndProcHandler;
