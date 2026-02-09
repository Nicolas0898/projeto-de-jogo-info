shader_type canvas_item;
uniform float wave_frequency:hint_range(0.0, 1.0, 0.1) = 1;
uniform float wave_speed:hint_range(0.0, 1.0, 0.1) = 1;
uniform float wave_amplitude:hint_range(0.0, 10.0, 0.1) = 1;

void vertex() {
	vec2 global_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	VERTEX = VERTEX + vec2(0,cos(global_pos.x*wave_frequency+TIME*wave_speed))*2.0*wave_amplitude;
	VERTEX -= vec2(0,sin(global_pos.x*wave_frequency+TIME*1.4*wave_speed))*1.0*wave_amplitude;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
