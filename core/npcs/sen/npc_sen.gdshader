shader_type canvas_item;
uniform vec4 color:source_color;
uniform bool enable;
uniform bool colored;
uniform bool mix_modulate = true;
varying flat vec4 modulate;
uniform float mix_modulate_strength = 1.0;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec4 new_color = COLOR;
	if (enable){
	// Place fragment code here.
	vec4 old_color=texture(TEXTURE,UV);

	if (colored){
		new_color = color;
		new_color.a=old_color.a*new_color.a;	
		COLOR=new_color;
	};
		
	if (mix_modulate&&!colored){
		COLOR=new_color*modulate*mix_modulate_strength;
		COLOR.a=old_color.a;
	};
}
}
