extends NpcsCombatState
@onready var player_detection: Area2D = $"../../../../PlayerDetection"
@export var attack_range:float=40
var tween:Tween

func connect_signal():
	return

func pre_enter() -> bool:
	return true
	
func enter():
	super.enter()
	#PlayerState.add_player_lock_interact_obj(npc)
	tween=npc.create_tween()
	tween.set_loops()
	tween.chain().tween_callback(aniplayer.play.bind("attack0"))
	tween.chain().tween_interval(.25)
	tween.chain().tween_interval(1)
	tween.chain().tween_callback(state_change)
	
func state_change():
	if abs(PlayerState.player_global_position.x-npc.global_position.x)>attack_range:
		state_manager.state2state(chase_state) 

func exit(NpcsBaseState):
	npc.enable_hitbox(false)
	aniplayer.stop()
	tween.kill()
	
func on_hit(area):
	if state_manager.current_state==self:
		PlayerState.player_be_hitting=true
	
func physics_process(delta: float):
	if npc.attack_range.has_overlapping_areas():
		if PlayerState.dense_success_flag:
			return behithard_state
