extends Node
@onready var door = $".."
@export var go_to_room_id:Global.rooms
@export var transition_type:Global.transition_type

# Called when the node enters the scene tree for the first time.
func _ready():
	door.body_entered.connect(_body_entered)
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _body_entered(body):
	EventBus._save_game()
	EventBus._transition_show(transition_type)
	await EventBus.transition_complete
	Debug.dprintinfo("开始转换场景")
	EventBus._change_room(go_to_room_id)
	pass
