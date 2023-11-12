extends Node
@onready var obj: Player = $".."
@onready var aniplayer: AnimationPlayer = $"../state_manager/Aniplayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#obj.ready.connect(on_obj_ready)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_obj_ready() -> void:
	obj.base.frame_changed.connect(on_base_frame_changed)

	pass
func on_base_frame_changed() -> void:
	if obj.front_base.animation != obj.base.animation:
		obj.front_base.animation = obj.base.animation
	obj.front_base.frame = obj.base.frame
	pass
