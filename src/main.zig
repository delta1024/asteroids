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

        const p1 = Vector2{
            player.pos[0] + @sin(decToRad(player.rotation)) * player_heght,
            player.pos[1] - @cos(decToRad(player.rotation)) * player_heght,
        };
        if (player.pos[0] < 0 and p1[0] < 0) {
            // player.rotation *= -1;
            player.pos[0] += (opts.default_width + player_heght);
        } else if (player.pos[0] > opts.default_width and p1[0] > opts.default_width) {
            // player.rotation *= -1;
            player.pos[0] -= (opts.default_width + player_heght);
        }

        if (player.pos[1] < 0 and p1[1] < 0) {
            // player.rotation *= -1;
            player.pos[1] += (opts.default_height + player_heght);
        } else if (player.pos[1] > opts.default_height and p1[1] > opts.default_height) {
            // player.rotation *= -1;
            player.pos[1] -= (opts.default_height + player_heght);
        }
    }
    fn draw(player: *Player) void {
        const upper_vector = Vector2{ 1, -1 } * (Vector2{
            @sin(decToRad(player.rotation)),
            @cos(decToRad(player.rotation)),
        } * Vector2{ player_heght, player_heght });

        const side_vector = Vector2{
            @cos(decToRad(player.rotation)),
            @sin(decToRad(player.rotation)),
        } * Vector2{ player_width / 2, player_width / 2 };

        ray.drawTriangle(
            player.pos + upper_vector,
            player.pos - side_vector,
            player.pos + side_vector,
            colors.Black,
        );
    }
};
const Bullet = struct {
    pos: Vector2 = .{ 0, 0 },
    speed: Vector2 = .{ 0, 0 },
    rotation: f32 = 0,
    radius: f32 = 3,
    time_active: usize = 0,
    active: bool = false,
    pub fn init(player: *Player) Bullet {
        return Bullet{
            .pos = Vector2{ 1, -1 } * (Vector2{
                @sin(decToRad(player.rotation)),
                @cos(decToRad(player.rotation)),
            } * player_heght),
            .rotation = player.rotation,
            .speed = Vector2{ 1.5, -1.5 } * (Vector2{
                @sin(decToRad(player.rotation)),
                @cos(decToRad(player.rotation)),
            } * Vector2{ player_speed, player_speed }),
            .active = true,
        };
    }
    pub fn update(bullet: *Bullet) void {
        bullet.time_active += 1;
        bullet.pos += bullet.speed;
        if (bullet.pos[0] < 0 or
            bullet.pos[0] > opts.default_width or
            bullet.pos[1] < 0 or
            bullet[1] > opts.default_height or
            bullet.time_active > 60)
            bullet.active = false;
    }
    pub fn draw(bullet: *Bullet) void {
        ray.drawCircleV(bullet.pos, bullet.radius, colors.Black);
    }
};
