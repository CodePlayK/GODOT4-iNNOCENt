extends NpcsCombatState
@onready var player_detection: Area2D = $"../../../../PlayerDetection"
@export var chase_speed:float=300
var chase_speed_r:float
@export var chase_distance:int=30
@export var lost_distance:int=500
@onready var timer: Timer = $Timer

func enter():
	super.enter()
	chase_speed_r=chase_speed*randf_range(.8,1.2)
	
func physics_process(delta: float):
	if abs(PlayerState.player_global_position.x-npc.global_position.x)>lost_distance:return patrol_state
	if PlayerState.player_global_position.x<npc.global_position.x:
		EventBus._obj_set_face_left(npc.name,true)
		if abs(PlayerState.player_global_position.x-npc.global_position.x)>chase_distance:
			npc.global_position.x-=chase_speed_r*delta
			timer.stop()
		else:
			if timer.is_stopped():
				timer.start()
	else :
		EventBus._obj_set_face_left(npc.name,false)
		if abs(PlayerState.player_global_position.x-npc.global_position.x)>chase_distance:
			npc.global_position.x+=chase_speed_r*delta
			timer.stop()
		else:
			if timer.is_stopped():
				timer.start()
	
func _on_timer_timeout() -> void:
	state_manager.state2state(attack_state)

func exit(NpcsBaseState):
	timer.stop()
