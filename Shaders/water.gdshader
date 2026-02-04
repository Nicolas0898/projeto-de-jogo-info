shader_type canvas_item;

uniform float wave_frequency:hint_range(0.0, 1.0, 0.1) = 1;
uniform float wave_speed:hint_range(0.0, 1.0, 0.1) = 1;
uniform float wave_amplitude:hint_range(0.0, 10.0, 0.1) = 1;
uniform sampler2D SCREEN:hint_screen_texture,filter_linear;
global uniform vec2 camera_pos;
varying vec2 global_pos;

void vertex() {
	global_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	VERTEX = VERTEX + vec2(0,cos(global_pos.x*wave_frequency+TIME*wave_speed))*2.0*wave_amplitude;
	VERTEX -= vec2(0,sin(global_pos.x*wave_frequency+TIME*1.4*wave_speed))*1.0*wave_amplitude;
}

void fragment() {
	vec4 water_color = texture(SCREEN,SCREEN_UV + vec2(sin(global_pos.y/2.0+TIME)/2400.0 + 0.0005,sin(global_pos.y/2.0+TIME)/240.0));
	float factor = abs(camera_pos.y - global_pos.y)/180.0;
	COLOR = mix(COLOR,water_color,0.3);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
