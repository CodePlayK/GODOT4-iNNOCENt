extends Area2D
@onready var hit_box_shape: CollisionShape2D = $CollisionShape2D
@onready var state_manager: PlayerStateManager = $"../state_manager"

func _on_area_entered(area: Area2D) -> void:
	PlayerState.player_be_hitting=true
	state_manager.on_hit(area)

func disable_hit():
	hit_box_shape.disabled = true
	
func enable_hit():
	hit_box_shape.disabled = false
