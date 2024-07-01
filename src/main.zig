const std = @import("std");
const math = std.math;
const ray = @import("raylib");
const Vector2 = ray.Vector2;
const Black = ray.colors.Black;
const screen = struct {
    pub const width: i32 = 800;
    pub const height: i32 = 450;
    pub const fps: i32 = 60;
};
player: Player,
const Game = @This();
pub fn main() !void {
    ray.initWindow(screen.width, screen.height, "asteroids");
    var game = Game.init(.{
        .player = .{
            .pos = .{
                (screen.width / 2) - (Player.WIDTH / 2),
                (screen.height / 2) - (Player.HEIGHT / 2),
            },
            .rotation = 45,
        },
    });
    defer game.deinit();
    while (!ray.windowShouldClose()) {
        ray.beginDrawing();
        defer ray.endDrawing();
        ray.clearBackground(ray.colors.White);
        ray.drawTriangle(game.player.p1(), game.player.p2(), game.player.p3(), Black);
    }
}
const InitOptions = struct {
    player: Player,
};
fn init(options: InitOptions) Game {
    ray.setTargetFps(screen.fps);
    ray.setWindowState(.{
        .msaa_4x_hint = true,
    });
    return Game{
        .player = options.player,
    };
}
fn deinit(self: *Game) void {
    _ = self;
    ray.closeWindow();
}
const Player = Triangle(20);
fn Triangle(comptime BASE_SIZE: f32) type {
    return struct {
        const x = 0;
        const y = 1;
        const Self = @This();
        pub const HEIGHT: f32 = (BASE_SIZE / 2) / math.tan(math.degreesToRadians(20));
        pub const WIDTH: f32 = BASE_SIZE;
        pos: Vector2,
        rotation: f32,

        pub fn p1(self: Self) Vector2 {
            return .{
                self.pos[x] - (math.sin(math.degreesToRadians(self.rotation)) * HEIGHT),
                self.pos[y] - (math.cos(math.degreesToRadians(self.rotation)) * HEIGHT),
            };
        }
        pub fn p2(self: Self) Vector2 {
            return .{
                self.pos[x] - (math.cos(math.degreesToRadians(self.rotation)) * (WIDTH / 2)),
                self.pos[y] + (math.sin(math.degreesToRadians(self.rotation)) * (WIDTH / 2)),
            };
        }
        pub fn p3(self: Self) Vector2 {
            return .{
                self.pos[x] + (math.cos(math.degreesToRadians(self.rotation)) * (WIDTH / 2)),
                self.pos[y] - (math.sin(math.degreesToRadians(self.rotation)) * (WIDTH / 2)),
            };
        }
    };
}
