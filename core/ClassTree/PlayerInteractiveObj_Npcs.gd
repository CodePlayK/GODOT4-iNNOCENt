##可以与玩家接触交互的对象
class_name Npcs extends PlayerInteractiveObj
const clazz_name = "Npcs"
##npc的状态机管理器
@onready var states: Node = $NpcStateManager
##主sprite
@onready var animation: Node2D = $Animation
@onready var vfx: Sprite2D = $Animation/vfx
@onready var base: Sprite2D = %base
@onready var ui: Node2D = $UI
@onready var hurt_fx: Node2D = $Animation/HurtFX
@onready var aniplayer: AnimationPlayer = $Animation/aniplayer
@onready var player_detection: Area2D = %Area/PlayerDetection
@onready var hit_box: HitBox = %Area/HitBox
@onready var face_direction: FaceDirection = $Component/FaceDirection
@onready var attack_range: Area2D = %Area/HitBox/AttackRange
@onready var sound_effect: SoundEffect = $Component/SoundEffect
@onready var light: Area2D = $Animation/Area/Light
@onready var dodge_weight_machine: Node = $WeightMachine/DodgeWeightMachine
@onready var time_2_last_attack_timer: Timer = $Timer/time2LastAttackTimer

@export_category("配置")
##初始化时进入的首个节点(并不会运行)
@export var starting_state:String
##运行时进入的状态
@export var starting1_state:String
@export var running_state:String
var on_ready=false
##巡逻范围右边界
@export var patrol_right:Marker2D
##巡逻范围左边界
@export var patrol_left:Marker2D
@export var life:int
var current_state
var being_hit:bool = false
var on_combat:bool=false
var dodgeable:bool = true
var attacking:bool = false	
var on_fighting:bool=false:
	set(f):
		on_fighting = f
		if self.name.is_empty():return
		if f:
			if !PlayerState.player_on_fighting.has(self.name):
				PlayerState.player_on_fighting[self.name] = self
				ui.health_bar.show()
		else :
			ui.health_bar.hide()
			PlayerState.player_on_fighting.erase(self.name)
@export var npc_name:String
var face_left:bool:
	set(f):
		face_left = f
		if f:
			face_left_normalozed = -1
		else :
			face_left_normalozed = 1
var face_left_normalozed:int

func _enter_tree() -> void:
	obj_name=npc_name

func _init() -> void:
	set_meta("clazz_name",clazz_name)
	
func _ready() -> void:
	super._ready()
	self.tree_exiting.connect(_tree_exiting)
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
