extends Node2D
@onready var npcs: Node2D = $"../Npcs"
@onready var npc_sen: NpcSen = $"../Npcs/Npc_Sen"

@onready var portrol_right_marker: Marker = $"../Marker/PortrolRightMarker"
@onready var portrol_left_marker: Marker = $"../Marker/PortrolLeftMarker"
const npc_sen_pack = preload("res://core/npcs/sen/npc_sen.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	#if !npc_sen:return
	#npc_sen.global_position.x=randf_range(portrol_left_marker.global_position.x,portrol_right_marker.global_position.x)
	#await RenderingServer.frame_post_draw
	#var sen=npc_sen.duplicate(8)
	###当前复制对象时并不会实例化shader parameter,只能新复制一份materail
	#var material = npc_sen.base.material.duplicate()
	#npc_sen.base.material=material

	var sen = npc_sen.duplicate(8)
	sen.global_position.x=randf_range(portrol_left_marker.global_position.x,portrol_right_marker.global_position.x)
	#sen.patrol_right = npc_sen.patrol_right
	#sen.patrol_left = npc_sen.patrol_left
	var material = npc_sen.base.material.duplicate()
	npc_sen.base.material=material
	await RenderingServer.frame_post_draw
	npcs.add_child(sen)
	EventBus._running_obj(sen.name)
