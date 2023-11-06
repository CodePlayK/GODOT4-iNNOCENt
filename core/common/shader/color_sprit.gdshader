shader_type canvas_item;
uniform vec4 color:source_color;
uniform bool enable;
varying flat vec4 modulate;
void vertex() {
	modulate = COLOR;
}

void fragment() {
	if (enable){
	// Place fragment code here.
	vec4 old_color=texture(TEXTURE,UV);
	vec4 new_color=color;
	new_color.a=old_color.a*new_color.a;
	COLOR=new_color*modulate;}
}
