extends NpcsCombatState
@export var dodge_distance:float
@export var dodge_time:float
@export var cooldown:float
@onready var timer: Timer = $Timer
var tween:Tween


func pre_enter() -> bool:
	return npc.dodgeable

func enter():
	super.enter()
	npc.dodgeable = false
	tween = npc.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(npc,"global_position",Vector2(npc.global_position.x-npc.face_left_normalozed*dodge_distance,npc.global_position.y),dodge_time)
	await tween.finished
	timer.start(cooldown-dodge_time)
	return chase_state

func exit(state:NpcsBaseState):
	tween.kill()

func _on_timer_timeout() -> void:
	npc.dodgeable = true
	pass # Replace with function body.
