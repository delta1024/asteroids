const std = @import("std");

const decToRad = std.math.degreesToRadians;
const opts = @import("opts");
const ray = @import("raylib");
const colors = ray.colors;
const Vector2 = ray.Vector2;
const player_width = opts.player_width;
const player_heght = (player_width / 2) / @tan(decToRad(20));
const player_speed: f32 = 6;
pub fn main() !void {
    var player = Player{
        .pos = .{ (opts.default_width / 2), (opts.default_height / 2) },
    };
    ray.initWindow(opts.default_width, opts.default_height, opts.title);
    defer ray.closeWindow();
    ray.setTargetFps(60);

    while (!ray.windowShouldClose()) {
        player.update();
        ray.beginDrawing();
        defer ray.endDrawing();
        ray.clearBackground(colors.RayWhite);
        player.draw();
    }
}
const Player = struct {
    pos: Vector2,
    speed: Vector2 = .{ 0, 0 },
    rotation: f32 = 0.0,
    acceleration: f32 = 0.0,
    fn update(player: *Player) void {
        if (ray.isKeyDown(.Left)) {
            player.rotation -= 5;
        }
        if (ray.isKeyDown(.Right)) {
            player.rotation += 5;
        }
        if (ray.isKeyDown(.Up)) {
            if (player.acceleration < 1)
                player.acceleration += 0.04;
        } else {
            if (player.acceleration > 0)
                player.acceleration -= 0.02
            else if (player.acceleration < 0)
                player.acceleration = 0;
        }
        if (ray.isKeyDown(.Down)) {
            if (player.acceleration > 0)
                player.acceleration -= 0.04
            else if (player.acceleration < 0)
                player.acceleration = 0;
        }

        player.speed = Vector2{
            @sin(decToRad(player.rotation)),
            @cos(decToRad(player.rotation)),
        } * Vector2{ player_speed, player_speed };

        player.pos += (Vector2{ 1, -1 } * (player.speed * Vector2{ player.acceleration, player.acceleration }));
    }
    fn draw(player: *Player) void {
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
};
