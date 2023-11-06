extends NpcsCombatState
var tween:Tween
@export var back_distance:float
@export var life:int

func enter():
	super.enter()
	life-=1
	var npc_global_position_x:float=npc.global_position.x
	tween=npc.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(npc,"global_position",Vector2(npc_global_position_x-back_distance*get_relative_position_x_2_player(),npc.global_position.y),.5)
	if life==0:
		tween.chain().tween_interval(.5)
		await tween.finished
		tween.kill()
		return death_state
	tween.chain().tween_interval(1)
	await tween.finished
	tween.kill()
	return chase_state
