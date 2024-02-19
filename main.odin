package main

import rl "vendor:raylib"

import "core:fmt"
import "core:math"

WIDTH :: 960
HEIGHT :: 720

vec_rel_to_abs :: proc(origin: rl.Vector2, vec: rl.Vector2) -> rl.Vector2{
    return rl.Vector2{origin.x + vec.x, origin.y + vec.y}
}

deg_to_rad :: proc(angle_deg: f32) -> f32{
    return angle_deg * math.PI / 180.0
}

rotate_vec_rel :: proc(vec: rl.Vector2, angle: f32) -> rl.Vector2{
    angle := deg_to_rad(angle)
    return rl.Vector2{vec.x * math.cos(angle) - math.sin(angle) * vec.y, math.sin(angle) * vec.x + math.cos(angle) * vec.y}
}

rotate_vec_abs :: proc(origin: rl.Vector2, vec: rl.Vector2, angle: f32) -> rl.Vector2{
    angle := deg_to_rad(angle)
    vec_rel := rl.Vector2{vec.x - origin.x, vec.y - origin.y}
    vec_rot := rl.Vector2{vec_rel.x * math.cos(angle) - vec_rel.y * math.sin(angle), vec_rel.x * math.sin(angle) + vec.y * math.cos(angle)}
    return rl.Vector2{vec_rot.x + origin.x, vec_rot.y + origin.y}
}

draw_vector :: proc(origin: rl.Vector2, relative_vector: rl.Vector2, angle: f32, color: rl.Color, line_thickness: f32 = 4.0){
    vec := relative_vector
    vec_abs_rot := vec_rel_to_abs(origin, rotate_vec_rel(vec, angle))

    //maybe that could be customizable
    p1 := rl.Vector2{15.0, 0.0}
    p2 := rl.Vector2{0.0, 30.0}
    p3 := rl.Vector2{-15.0, 0.0}

    rl.DrawLineEx(origin, vec_abs_rot, line_thickness, color)
    rl.DrawTriangle(vec_rel_to_abs(vec_abs_rot, rotate_vec_rel(p1, angle)), vec_rel_to_abs(vec_abs_rot, rotate_vec_rel(p3, angle)), vec_rel_to_abs(vec_abs_rot, rotate_vec_rel(p2, angle)), color)
}

vec_norm :: proc(vec: rl.Vector2) -> rl.Vector2{
    len := math.sqrt(vec.x * vec.x + vec.y * vec.y)
    return rl.Vector2{vec.x / len, vec.y / len}
}

main :: proc(){
    rl.InitWindow(WIDTH, HEIGHT, "particles")
    defer rl.CloseWindow()
    rl.SetTargetFPS(60)

    vec := rl.Vector2{0.0, 100.0}
    circ_pos := rl.Vector2{WIDTH / 2, HEIGHT / 2}

    particle_amount :: 10
    angle_delta := 360.0 / f32(particle_amount)

    circle_speed: f32 = 5.0

    //void DrawTriangleLines(Vector2 v1, Vector2 v2, Vector2 v3, Color color);   

    for !rl.WindowShouldClose(){
        rl.BeginDrawing()
        defer rl.EndDrawing()

        //UPDATING
        if rl.IsKeyDown(.Q){
            circ_pos += vec_norm(rotate_vec_rel(vec, angle)) * circle_speed
        }

        //RENDERING
        rl.ClearBackground(rl.BLACK)
        for i in 0..<particle_amount{
            draw_vector(circ_pos, vec, f32(i) * angle_delta, rl.Color{66, 245, 147, 255})
        }
        rl.DrawCircle(i32(circ_pos.x), i32(circ_pos.y), 25, rl.WHITE)
    }
}