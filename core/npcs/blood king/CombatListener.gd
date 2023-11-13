extends Node
@onready var state_manager: NpcStateManager = $".."
@onready var base: NpcsBaseState = $"../base"
@onready var face_direction: FaceDirection = $"../../FaceDirection"

@export var dodge_distance:float
var distance_to_player
var on_player_left_side:int
var enabel:bool
var current_state:NpcsBaseState

func _physics_process(delta: float) -> void:
	current_state = state_manager.current_state
	get_position_to_player()
	to_dodge()


func to_dodge():
	if distance_to_player < dodge_distance:
		if !current_state in [base.dodge_state] or !current_state is NpcsAttackState:
			if PlayerState.attacking:
				face_direction.set_faced(!on_player_left_side)
				state_manager.state2state(base.dodge_state)
	pass
	
func get_position_to_player():
	var distance = state_manager.npc.global_position.x - PlayerState.player_global_position.x
	distance_to_player = abs(distance)
	if distance < 0:
		on_player_left_side = true
	else :
		on_player_left_side = false

