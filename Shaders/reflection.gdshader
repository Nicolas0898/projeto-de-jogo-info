shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE :hint_screen_texture;
uniform float reflection_strenght:hint_range(0.0, 1.0, 0.1);

uniform float wave_amplitude:hint_range(0.0, 10.0, 0.1)= 1;
uniform float wave_speed:hint_range(0.0, 10.0, 0.1) = 1;
uniform float wave_frequency:hint_range(0.0, 10.0, 0.1) = 1;
uniform bool reflection_type = true;
uniform float ma;
global uniform vec2 camera_pos;

varying vec2 wp;
varying vec2 camera_middle;

void vertex() {
	vec2 tp = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	wp = tp;
	//VERTEX = VERTEX + vec2(0,cos(tp.y*wave_frequency+TIME*wave_speed))*2.0*wave_amplitude;
}

void fragment() {
	vec4 reflection;
	if(reflection_type){
		ivec2 size_reading = textureSize(TEXTURE,0);
		vec2 size = vec2(size_reading);//vec2(32,32);
		float mirror_axis = -((UV.y)*abs(abs(wp.y)-abs(ma))/1.4*SCREEN_PIXEL_SIZE.y);
		float dist = (wp.y-ma);
		//textureLod()
		
		//reflection = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x,
		//SCREEN_UV.y - sin(UV.x*20.0+TIME)/5.0/size.y + mirror_axis*10.0));
		
		float py = SCREEN_PIXEL_SIZE.y;
		reflection = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x,(1.0-(wp.y + camera_pos.y))-(SCREEN_UV.y)));
		COLOR = vec4(dist/100.0,0,0,1);
	}else{
		reflection = textureLod(SCREEN_TEXTURE,vec2(SCREEN_UV.x,(1.0)-SCREEN_UV.y + 0.3),0.0);
	}
	
	COLOR = mix(COLOR,reflection,reflection_strenght);
	//COLOR = vec4(edge.x/54.0,edge.y/64.0,0,1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
