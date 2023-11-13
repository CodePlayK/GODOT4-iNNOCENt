shader_type canvas_item;
uniform vec2 player_position;
uniform float circle_radius;
uniform float inner_circle_radius_scale;
uniform float strength;
varying flat vec4 modulate;
void vertex() {
	modulate = COLOR;
}

void fragment( )
{	
    vec2 current_pixel = SCREEN_UV/SCREEN_PIXEL_SIZE;
    // 计算当前像素到圆心的距离
    float distance_to_center = distance(current_pixel, player_position/SCREEN_PIXEL_SIZE);
    if (distance_to_center < circle_radius && distance_to_center>inner_circle_radius_scale*circle_radius) {
		COLOR.a =COLOR.a* 1.0/circle_radius*(distance_to_center-inner_circle_radius_scale*circle_radius)*strength;
    } else if(distance_to_center<inner_circle_radius_scale*circle_radius){
		COLOR.a=0.0;
    }
}