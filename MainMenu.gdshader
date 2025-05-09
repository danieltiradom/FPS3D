shader_type canvas_item;

uniform float blur_size = 4.0;
uniform float brightness = 1.4;


void fragment() {
    vec2 tex_size = vec2(textureSize(TEXTURE, 0));
    vec2 pixel_size = vec2(blur_size) / tex_size;

    vec4 sum = vec4(0.0);
    sum += texture(TEXTURE, UV + vec2(0.0, -4.0 * pixel_size.y)) * 0.05;
    sum += texture(TEXTURE, UV + vec2(0.0, -2.0 * pixel_size.y)) * 0.09;
    sum += texture(TEXTURE, UV + vec2(0.0, -1.0 * pixel_size.y)) * 0.12;
    sum += texture(TEXTURE, UV) * 0.15;
    sum += texture(TEXTURE, UV + vec2(0.0, 1.0 * pixel_size.y)) * 0.12;
    sum += texture(TEXTURE, UV + vec2(0.0, 2.0 * pixel_size.y)) * 0.09;
    sum += texture(TEXTURE, UV + vec2(0.0, 4.0 * pixel_size.y)) * 0.05;

    COLOR = sum * brightness;
	
}
