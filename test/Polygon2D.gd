extends Polygon2D
@export var parallax_move_data:ParallaxMoveData
@export var base_layer:String
@export var target_layer:String
var base_position_A:float
var base_position_B:float
# Called when the node enters the scene tree for the first time.
func _ready():
	base_position_A=self.polygon[0].x
	base_position_B=self.polygon[3].x
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.polygon[0].x=base_position_A+parallax_move_data.dic_layers_move_data[target_layer]-parallax_move_data.dic_layers_move_data[base_layer]
	self.polygon[3].x=base_position_B+parallax_move_data.dic_layers_move_data[target_layer]-parallax_move_data.dic_layers_move_data[base_layer]
	pass
