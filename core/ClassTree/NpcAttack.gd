extends NpcsCombatState
@onready var player_detection: Area2D = $"../../../../PlayerDetection"
@export var attack_range:float=40
@onready var aniplayer: AnimationPlayer = $aniplayer
@onready var weapon: Area2D = $"../../../../Weapon"
var tween:Tween

func connect_signal():
	weapon.area_entered.connect(on_hit)
	return

func pre_enter() -> bool:
	change_sprite=false
	return true
	
func enter():
	super.enter()
	#PlayerState.add_player_lock_interact_obj(npc)
	tween=npc.create_tween()
	tween.set_loops()
	tween.chain().tween_callback(aniplayer.play.bind("attack1"))
	tween.chain().tween_interval(.25)
	tween.chain().tween_interval(1)
	tween.chain().tween_callback(state_change)
	
func state_change():
	if abs(PlayerState.player_global_position.x-npc.global_position.x)>attack_range:
		state_manager.state2state(chase_state) 

func exit(NpcsBaseState):
	tween.kill()
	#aniplayer.stop()
	npc.enable_weapon(false)
	
func on_hit(area):
	if state_manager.current_state==self:
		PlayerState.player_be_hitting=true
	
func physics_process(delta: float):
	if npc.attack_range.has_overlapping_areas() and PlayerState.dense_success_flag:
		return behit_state
