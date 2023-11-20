##玩家控制对象
class_name Player extends CharacterBody2D
@export_category("配置")
@export var dead_switch: bool=true
##重力
@export_group("运动")
@export var gravity: int=800
##最大y速度
@export var max_velocity_y: int=800
##run加速度
@export var acceleration_run: int=400
@export var acceleration_dash: int=700
@export var max_speed_dash: int=700
##摩擦力
@export var friction: int=800
##最大run速度
@export var max_speed_run: int=200
##最大fastrun速度
@export var max_speed_fast_run: int=300
##最大walk速度
@export var max_speed_walk: int=100
##jump速度
@export var jump_speed: int=220
@export var climb_speed: int=120
@export var climb_speed_x: int=80
@export var click_jump_force_limit:=5
##最低跳跃速度
@export var min_jump_fource:=70
var on_ready=false
var start_position
var stamina:int
#region @onready
@onready var dialogue_position: Marker2D = $Marker/DialoguePosition
@onready var base: AnimatedSprite2D = $Animation/base
@onready var base_fx: AnimatedSprite2D = $Animation/baseFX
@onready var states: = $state_manager
@onready var ladder_checker: RayCast2D = $Rays/ladderChecker
@onready var ground_checker: RayCast2D = $Rays/groundChecker
@onready var block_checker_left: RayCast2D = $Rays/blockCheckerLeft
@onready var block_checker_right: RayCast2D = $Rays/blockCheckerRight
@onready var ui: Node2D = $UI
@onready var player_camera = $PlayerCamera
@onready var hit_box: HitBox = $Area/HitBox
@onready var hurt_box: HurtBox = $Area/HurtBox
@onready var sound_effect: SoundEffect = $Component/SoundEffect
@onready var anime: Anime = $Animation/Anime
@onready var fx: Node2D = $Animation/FX

#endregion


func _ready() -> void:
	EventBus.get_player_position.connect(_on_get_player_position)
	EventBus.change_player_position.connect(_on_change_player_position)
	EventBus.change_player_visiable.connect(_on_change_player_visiable)
	EventBus.player_face_left.connect(_on_player_face_left)
	start_position=get_position()
	states.init(self)
	on_ready=true
	PlayerState.on_player_ready(self)

func _unhandled_input(event: InputEvent) -> void:
	if !on_ready or event is InputEventMouseMotion:
		return 
	states.input(event)

func _physics_process(delta: float) -> void:
	if !on_ready:
		return 
	is_player_interact_being_locked()
	is_player_on_fighting()
	states.physics_process(delta)

func _process(delta: float) -> void:
	if !on_ready:
		return 
	states.process(delta)

func _on_world_player_is_dead():
	player_is_dead()

func player_is_dead():
	if dead_switch:
		Global.playerDeadTimes+=1
		set_position(start_position)
	
func _on_change_player_visiable()->void:
	self.hide()

func _on_change_player_position(player_position) -> void:
	self.global_position=player_position
	if !player_camera.is_node_ready():
		await player_camera.ready
	player_camera.reset_smoothing()
	
func _on_get_player_position():
	return global_position
	
func _on_player_face_left(state) -> void:
	if state:
		base.scale.x = -abs(base.scale.x)
		hit_box.set_scale(Vector2(-1,1))
		PlayerState.face_left=true
	else:
		hit_box.set_scale(Vector2(1,1))
		base.scale.x = abs(base.scale.x)
		PlayerState.face_left=false

func get_dialogue_position():
	return dialogue_position.global_position

func _on_update_timer_timeout():
	PlayerState.player_global_position=global_position
	if ground_checker.is_colliding():
		PlayerState.current_height = ground_checker.get_collision_point().y - global_position.y

func is_player_interact_being_locked():
	if PlayerState.player_lock_interact_obj.is_empty():
		if PlayerState.player_interact_being_locked:
			PlayerState.enable_all_ineractable()
			PlayerState.player_interact_being_locked=false
	else:
		if !PlayerState.player_interact_being_locked:	
			PlayerState.disable_all_ineractable()
			PlayerState.player_interact_being_locked=true

func is_player_on_fighting():
	if PlayerState.player_on_fighting.is_empty():
		if PlayerState.is_player_on_fighting:
			PlayerState.is_player_on_fighting=false
	else:
		if !PlayerState.is_player_on_fighting:	
			PlayerState.is_player_on_fighting=true


func _on_tree_exiting() -> void:
	PlayerState.player_state_history.clear()
