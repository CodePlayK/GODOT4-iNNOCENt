extends NpcsCombatState
class_name NpcBehitState
var tween:Tween
@export var back_distance:float
@export var stiff_time:float = .2
@export var froze_time:float = 0
@export var protect_time:float = .2
@export var fx_name:String
@onready var protect_timer: Timer = $ProtectTimer
var enable:bool = true
		
func pre_enter() -> bool:
	return true
	
func enter():
	super.enter()
	npc.being_hit = false
	enable = false
	npc.health-=state_manager.current_damage
	npc.hurt_fx.play_fx(fx_name)
	var npc_global_position_x:float=npc.global_position.x
	tween=npc.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(npc,"global_position",Vector2(npc_global_position_x-back_distance*get_relative_position_x_2_player(),npc.global_position.y),stiff_time)
	if npc.health<=0:
		tween.chain().tween_interval(.5)
		await tween.finished
		tween.kill()
		return death_state
	tween.chain().tween_interval(froze_time)
	await tween.finished
	tween.kill()
	return chase_state
	
func exit(state:NpcsBaseState):
	enable = true
	state_manager.current_damage = 0
	tween.kill()

func _on_protect_timer_timeout() -> void:
	enable = true
