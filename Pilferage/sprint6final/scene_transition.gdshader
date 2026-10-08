shader_type canvas_item;

const float pixel_size = 0.01;

uniform float circle_radius = 0.0;
uniform vec2 circle_center = vec2(0.5, 0.5);

void fragment() {
    vec2 pos = floor(UV / pixel_size) * pixel_size;
    float distance_from_center = distance(pos, circle_center);

    if (distance_from_center < circle_radius) {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    }
}
