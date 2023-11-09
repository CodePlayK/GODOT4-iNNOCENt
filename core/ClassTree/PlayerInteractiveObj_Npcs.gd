##可以与玩家接触交互的对象
class_name Npcs extends PlayerInteractiveObj
const clazz_name = "Npcs"
##npc的状态机管理器
@onready var states: Node = $NpcStateManager
##主sprite
@onready var base: AnimatedSprite2D = $base
@onready var ui: Node2D = $UI
@onready var hit_fx: Node2D = $HitFX

@export_category("配置")
##初始化时进入的首个节点(并不会运行)
@export var starting_state:String
##初始化时进入的第二个节点(真正运行的第一个状态)
@export var starting_state1:String
var on_ready=false
##巡逻范围右边界
@export var patrol_right:Marker2D
##巡逻范围左边界
@export var patrol_left:Marker2D
@export var life:int
var current_state
var on_combat:bool=false
var on_fighting:bool=false:
	set(f):
		on_fighting = f
		if self.name.is_empty():return
		if f:
			if !PlayerState.player_on_fighting.has(self.name):
				PlayerState.player_on_fighting[self.name] = self
				ui.stiff_bar.show()
		else :
			ui.stiff_bar.hide()
			PlayerState.player_on_fighting.erase(self.name)
@export var npc_name:String
var face_left:bool

func _enter_tree() -> void:
	obj_name=npc_name

func _init() -> void:
	set_meta("clazz_name",clazz_name)
	
func _ready() -> void:
	super._ready()
	self.tree_exiting.connect(_tree_exiting)
	states.init(self)
	on_ready=true

func _unhandled_input(event: InputEvent) -> void:
	if !on_ready or CutsceneState.cutscene_playing:
		return 
	states.input(event)

func _physics_process(delta: float) -> void:
	if !on_ready or CutsceneState.cutscene_playing:
		return 
	states.physics_process(delta)

func _process(delta: float) -> void:
	if !on_ready or CutsceneState.cutscene_playing:
		return 
	states.process(delta)

func _tree_exiting():
	PlayerState.player_lock_interact_obj.erase(self.name)
	reset_npc()
	
func reset_npc():
	pass
