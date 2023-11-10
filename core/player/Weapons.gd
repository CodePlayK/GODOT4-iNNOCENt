extends Area2D
var enable:bool = true
var shape_list:Array[CollisionShape2D]

func _ready() -> void:
	for node in get_children():
		if node is CollisionShape2D:
			shape_list.append(node)
	
func set_enable(flag:bool):
	enable = flag

func disable_rect():
	for shape in shape_list:
		shape.set_deferred("disabled" , true)
