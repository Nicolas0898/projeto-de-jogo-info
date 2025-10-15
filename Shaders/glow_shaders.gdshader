shader_type canvas_item;
uniform sampler2D glow_texture:filter_nearest;
uniform float intensity = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	vec4 pixel = texture(glow_texture,UV)*intensity;
	if(pixel.a!=0.0){
		COLOR = pixel;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
