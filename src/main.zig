const std = @import("std");
const math = std.math;
const ray = @import("raylib");
const Vector2 = ray.Vector2;
const Black = ray.colors.Black;
const BASE_WIDTH: i32 = 200;
fn Triangle(comptime height: f32, comptime width: f32) type {
    return struct {
        pub const HEIGHT = height;
        pub const WIDTH = width;
        const DEG: f32 = 45;
        const x = 0;
        const y = 1;
        const Self = @This();
        pos: Vector2,
        pub fn p1(self: Self) Vector2 {
            return .{
                self.pos[x] - (math.sin(DEG) * HEIGHT),
                self.pos[y] - (math.cos(DEG) * HEIGHT),
            };
        }
        pub fn p2(self: Self) Vector2 {
            return .{
                self.pos[x] - (math.cos(DEG) * (WIDTH / 2)),
                self.pos[y] + (math.sin(DEG) * (WIDTH / 2)),
            };
        }
        pub fn p3(self: Self) Vector2 {
            return .{
                self.pos[x] + (math.cos(DEG) * (WIDTH / 2)),
                self.pos[y] - (math.sin(DEG) * (WIDTH / 2)),
            };
        }
    };
}
pub fn main() !void {
    const screen = struct {
        pub const width: i32 = 800;
        pub const height: i32 = 450;
        pub const fps: i32 = 60;
    };
    const player = Triangle(200, 100){
        .pos = .{
            (screen.width / 2),
            (screen.height / 2),
        },
    };
    ray.initWindow(screen.width, screen.height, "asteroids");
    defer ray.closeWindow();
    ray.setTargetFps(screen.fps);
    while (!ray.windowShouldClose()) {
        ray.beginDrawing();
        defer ray.endDrawing();

        ray.clearBackground(ray.colors.White);
        ray.drawTriangle(player.p1(), player.p2(), player.p3(), Black);
    }
}
