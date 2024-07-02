const std = @import("std");
const opts = @import("opts");
const ray = @import("raylib");
const colors = ray.colors;

pub fn main() !void {
    ray.initWindow(opts.default_height, opts.default_width, opts.title);
    defer ray.closeWindow();

    while (!ray.windowShouldClose()) {
        ray.beginDrawing();
        defer ray.endDrawing();
        ray.clearBackground(colors.RayWhite);

        ray.drawText(
            opts.title,
            (opts.default_height / 2) - (opts.title.len / 2) * 12,
            (opts.default_width / 2) - 12,
            24,
            colors.Black,
        );
    }
}
