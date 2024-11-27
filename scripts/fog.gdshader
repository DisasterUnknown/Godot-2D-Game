shader_type canvas_item;

uniform sampler2D noise_texture: repeat_enable, filter_nearest;
uniform float density: hint_range(0.0, 1.0) = 1.00;
uniform vec2 speed = vec2(0.02, 0.01);

void fragment() {
	vec2 uv = UV + speed * TIME;
	float noise = texture(noise_texture, uv).r;
	float fog = noise * 1.2 - 1.6;
	COLOR.a += fog * density;
}

