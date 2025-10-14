shader_type canvas_item;

uniform float wave_frequency:hint_range(0.0, 1.0, 0.1) = 1;
uniform float wave_speed:hint_range(0.0, 1.0, 0.1) = 1;
uniform float wave_amplitude:hint_range(0.0, 1.0, 0.1) = 1;
uniform sampler2D SCREEN:hint_screen_texture,filter_linear;

void vertex() {
	vec2 tp = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	VERTEX = VERTEX + vec2(0,cos(tp.y*wave_frequency+TIME*wave_speed))*2.0*wave_amplitude;
}

void fragment() {
	vec4 water_color = texture(SCREEN,SCREEN_UV + vec2(sin(UV.y*10.0+TIME)/240.0 + 0.0005,0));
	COLOR = mix(COLOR,water_color,0.3);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
