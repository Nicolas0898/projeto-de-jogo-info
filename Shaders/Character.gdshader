shader_type canvas_item;
uniform vec4 blink_color:source_color = vec4(1,1,1,1);
uniform float factor:hint_range(0.0, 1.0, 0.1) = 0;

float lerp(float a,float b,float t){
  return a + (b - a) * t;
}

vec4 lerpv4(vec4 a, vec4 b,float t){
	return a + (b - a) * t;
}

void vertex() {
	
}

void fragment() {
	vec4 pixel = texture(TEXTURE,UV);
	float alpha = pixel.a;
	
	COLOR = lerpv4(vec4(1,1,1,alpha) * blink_color,pixel,1.0-factor);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
