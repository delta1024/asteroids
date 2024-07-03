const std = @import("std");

const decToRad = std.math.degreesToRadians;
const opts = @import("opts");
const ray = @import("raylib");
const colors = ray.colors;
const Vector2 = ray.Vector2;
const player_width = opts.player_width;
const player_heght = (player_width / 2) / @tan(decToRad(20));

const Player = struct {
    pos: Vector2,
    rotation: f32 = 0.0,
};
pub fn main() !void {
    const player = Player{
        .pos = .{ (opts.default_width / 2), (opts.default_height / 2) },
    };
    ray.initWindow(opts.default_width, opts.default_height, opts.title);
    defer ray.closeWindow();

    while (!ray.windowShouldClose()) {
        ray.beginDrawing();
        defer ray.endDrawing();
        ray.clearBackground(colors.RayWhite);

        const p1 = Vector2{
            player.pos[0] + @sin(decToRad(player.rotation)) * player_heght,
            player.pos[1] - @cos(decToRad(player.rotation)) * player_heght,
        };
        const p2 = Vector2{
            player.pos[0] - @cos(decToRad(player.rotation)) * (player_width / 2),
            player.pos[1] - @sin(decToRad(player.rotation)) * (player_width / 2),
        };
        const p3 = Vector2{
            player.pos[0] + @cos(decToRad(player.rotation)) * (player_width / 2),
            player.pos[1] + @sin(decToRad(player.rotation)) * (player_width / 2),
        };
        ray.drawTriangle(p1, p2, p3, colors.Black);
    }
}
