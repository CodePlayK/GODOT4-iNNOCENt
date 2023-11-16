extends NpcsCombatState
@export var chase_speed:float=300
var chase_speed_r:float
@export var chase_distance:int=30
@export var lost_distance:int=500
@onready var timer: Timer = $Timer
var speed_map_2_animation
var face_direction: FaceDirection

func init_var():
	speed_map_2_animation = npc.speed_map_2_animation
	face_direction = npc.face_direction

func enter():
	super.enter()
	chase_speed_r=chase_speed*randf_range(.8,1.2)
	speed_map_2_animation.set_enabel(true)
	
func physics_process(delta: float):
	if abs(PlayerState.player_global_position.x-npc.global_position.x)>lost_distance:return patrol_state
	if PlayerState.player_global_position.x<npc.global_position.x:
		face_direction.set_faced(true)
		if abs(PlayerState.player_global_position.x-npc.global_position.x)>chase_distance:
			npc.global_position.x-=chase_speed_r*delta
			timer.stop()
		else:
			if timer.is_stopped():
				timer.start()
	else :
		face_direction.set_faced(false)
		if abs(PlayerState.player_global_position.x-npc.global_position.x)>chase_distance:
			npc.global_position.x+=chase_speed_r*delta
			timer.stop()
		else:
			if timer.is_stopped():
				timer.start()
	return await  npc.chase_weight_machine.process()
	
func _on_timer_timeout() -> void:
	return
	state_manager.state2state(attack0_state)

func exit(NpcsBaseState):
	timer.stop()
	npc.chase_weight_machine.exit()
	speed_map_2_animation.set_enabel(false)
