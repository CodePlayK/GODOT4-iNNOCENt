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

    // 如果距离小于圆的半径，表示在圆内，设置颜色为红色，否则为蓝色
    if (distance_to_center < circle_radius && distance_to_center>inner_circle_radius_scale*circle_radius) {
        //COLOR = vec4(1.0, 0.0, 0.0, 1.0); // 在圆内，红色
		COLOR.a =COLOR.a* 1.0/circle_radius*(distance_to_center-inner_circle_radius_scale*circle_radius)*strength;
    } else if(distance_to_center<inner_circle_radius_scale*circle_radius){
		COLOR.a=0.0;
        //COLOR = COLOR; // 在圆外，蓝色
    }
}