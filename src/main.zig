const std = @import("std");
const math = std.math;
const ray = @import("raylib");
const Vector2 = ray.Vector2;
const Black = ray.colors.Black;
const Color = ray.Color;
const BASE_SIZE: f32 = 20;
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
            .rotation = 0,
            .color = Black,
        },
    });
    defer game.deinit();
    while (!ray.windowShouldClose()) {
        ray.beginDrawing();
        defer ray.endDrawing();
        ray.clearBackground(ray.colors.White);
        game.player.draw();
    }
}
const InitOptions = struct {
    player: Player,
};
fn init(options: InitOptions) Game {
    ray.setTargetFps(screen.fps);
    return Game{
        .player = options.player,
    };
}
fn deinit(self: *Game) void {
    _ = self;
    ray.closeWindow();
}
const Player = struct {
    const x = 0;
    const y = 1;
    const Self = @This();
    pub const HEIGHT: f32 = (BASE_SIZE / 2) / math.tan(math.degreesToRadians(20));
    pub const WIDTH: f32 = BASE_SIZE;
    pos: Vector2,
    rotation: f32,
    color: Color,
    pub fn draw(self: *Player) void {
        const p1 = Vector2{
            self.pos[x] - (math.sin(math.degreesToRadians(self.rotation)) * HEIGHT),
            self.pos[y] - (math.cos(math.degreesToRadians(self.rotation)) * HEIGHT),
        };
        const p2 = Vector2{
            self.pos[x] - (math.cos(math.degreesToRadians(self.rotation)) * (WIDTH / 2)),
            self.pos[y] + (math.sin(math.degreesToRadians(self.rotation)) * (WIDTH / 2)),
        };
        const p3 = Vector2{
            self.pos[x] + (math.cos(math.degreesToRadians(self.rotation)) * (WIDTH / 2)),
            self.pos[y] - (math.sin(math.degreesToRadians(self.rotation)) * (WIDTH / 2)),
        };
        ray.drawTriangle(p1, p2, p3, self.color);
    }
};
