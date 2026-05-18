shader_type canvas_item;
uniform vec4 top_colour : source_color;
uniform vec4 bottom_colour : source_color;
uniform float gradient_strength : hint_range(0.0, 1.0) = 1.0;
uniform float text_bottom : hint_range(2, 100.0) = 32.0;
uniform vec4 stroke_colour : source_color;
uniform float stroke_width : hint_range(0.0, 10.0) = 2.0;
uniform float sharpness : hint_range(1.0, 200.0) = 50.0;
uniform vec4 shadow_colour : source_color;
uniform vec2 shadow_offset = vec2(2.0, 2.0);
uniform float shadow_size : hint_range(0.0, 10.0) = 1.0;

varying float y_ratio;

void vertex() {
    y_ratio = (VERTEX.y) / text_bottom;
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec2 pixel = TEXTURE_PIXEL_SIZE;

    float sharp_alpha = smoothstep(0.5 - (1.0 / sharpness), 0.5 + (1.0 / sharpness), tex.a);

    float stroke = 0.0;
    for (float x = -stroke_width; x <= stroke_width; x += 1.0) {
        for (float y = -stroke_width; y <= stroke_width; y += 1.0) {
            if (length(vec2(x, y)) <= stroke_width) {
                float s = texture(TEXTURE, UV + vec2(x, y) * pixel).a;
                stroke = max(stroke, smoothstep(0.5 - (1.0 / sharpness), 0.5 + (1.0 / sharpness), s));
            }
        }
    }

    float shadow = 0.0;
    for (float x = -shadow_size; x <= shadow_size; x += 1.0) {
        for (float y = -shadow_size; y <= shadow_size; y += 1.0) {
            if (length(vec2(x, y)) <= shadow_size) {
                vec2 uv = UV + (vec2(x, y) - shadow_offset) * pixel;
                float s = texture(TEXTURE, uv).a;
                shadow = max(shadow, smoothstep(0.5 - (1.0 / sharpness), 0.5 + (1.0 / sharpness), s));
            }
        }
    }

    float t = clamp(y_ratio, 0.0, 1.0);
    vec3 gradient = mix(top_colour.rgb, bottom_colour.rgb, t);
    vec3 final_col = mix(top_colour.rgb, gradient, gradient_strength);

    vec3 final_rgb = mix(shadow_colour.rgb, stroke_colour.rgb, stroke);
    final_rgb = mix(final_rgb, final_col, sharp_alpha);
    float final_alpha = max(shadow * shadow_colour.a, max(stroke * stroke_colour.a, sharp_alpha));

    COLOR = vec4(final_rgb, final_alpha);
}