extends NpcsCombatState
class_name NpcBehitState
var tween:Tween
@export var back_distance:float
@export var stiff_time:float = .2
@export var froze_time:float = 0

func enter():
	super.enter()
	EventBus._play_SE("knife-stab")
	npc.life-=1
	var npc_global_position_x:float=npc.global_position.x
	tween=npc.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(npc,"global_position",Vector2(npc_global_position_x-back_distance*get_relative_position_x_2_player(),npc.global_position.y),stiff_time)
	if npc.life==0:
		tween.chain().tween_interval(.5)
		await tween.finished
		tween.kill()
		return death_state
	tween.chain().tween_interval(froze_time)
	await tween.finished
	tween.kill()
	return chase_state
	
func exit(state:NpcsBaseState):
	tween.kill()
