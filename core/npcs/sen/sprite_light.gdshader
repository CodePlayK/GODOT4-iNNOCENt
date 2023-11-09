shader_type canvas_item;
uniform vec4 color:source_color;
uniform bool enable;
uniform bool mix_modulate = true;
uniform float mix_modulate_strength = 1.0;
varying flat vec4 modulate;
void vertex() {
	modulate = COLOR;
}

void fragment() {
	if (enable){
	// Place fragment code here.
	vec4 old_color=texture(TEXTURE,UV);
	vec4 new_color=color;
	//new_color.a=old_color.a*new_color.a;
	if (mix_modulate){
	COLOR=COLOR*mix_modulate_strength;
	}else{
	COLOR=COLOR;
	}
	}
}
