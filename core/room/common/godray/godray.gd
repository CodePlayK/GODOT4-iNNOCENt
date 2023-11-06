extends Polygon2D
@export var bright:float=.9
@export_file var parallax_move_data
@export var base_layer:String="ParallaxLayer_3"
@export var target_layer:String="ParallaxLayer_0"
@onready var collision_shape_2d: CollisionShape2D = $LightArea/CollisionShape2D
@export var pont_top_left_offset:float=0
@export var pont_top_right_offset:float=0
@export var pont_bot_left_offset:float=0
@export var pont_bot_right_offset:float=0
@onready var godray = $"."
@onready var light_area: Area2D = $LightArea

var base_position_A:float
var base_position_B:float
var temp0:float
var temp1:float
# Called when the node enters the scene tree for the first time.
func _ready():
	light_area.bright=bright
	collision_shape_2d.shape=RectangleShape2D.new()
	godray.polygon[0].x+=pont_top_left_offset
	godray.polygon[1].x+=pont_bot_left_offset
	godray.polygon[2].x+=pont_top_right_offset
	godray.polygon[3].x+=pont_bot_right_offset
	base_position_A=godray.polygon[0].x
	base_position_B=godray.polygon[3].x	
	parallax_move_data=preload(Global.parallax_move_data_source_path)
	get_shape()
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if parallax_move_data.dic_layers_move_data.has(target_layer) and parallax_move_data.dic_layers_move_data.has(base_layer):
		godray.polygon[0].x=base_position_A+parallax_move_data.dic_layers_move_data[target_layer]-parallax_move_data.dic_layers_move_data[base_layer]
		godray.polygon[3].x=base_position_B+parallax_move_data.dic_layers_move_data[target_layer]-parallax_move_data.dic_layers_move_data[base_layer]
		get_shape()
	pass

func get_shape():
	var max_y=abs(max(godray.polygon[2].y,godray.polygon[1].y)-min(godray.polygon[0].y,godray.polygon[3].y))
	var max_x=max(godray.polygon[2].x,godray.polygon[3].x)-min(godray.polygon[0].x,godray.polygon[1].x)
	var center=Vector2(
		min(godray.polygon[0].x,godray.polygon[1].x)+max_x*.5,
		godray.polygon[0].y+max_y*.5
	)
	collision_shape_2d.position=center
	collision_shape_2d.shape.size.x=max_x
	collision_shape_2d.shape.size.y=max_y
