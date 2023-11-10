extends Node
##Player状态机的base状态
class_name BaseState
@onready var jump_state: BaseState
@onready var walk_state: BaseState
@onready var run_state: BaseState
@onready var dash_state: BaseState
@onready var climb_state: BaseState
@onready var fall_state: BaseState
@onready var lift_state: BaseState
@onready var idle_state: BaseState
@onready var double_jump_state: BaseState
@onready var landing_state: BaseState
@onready var ground_state: BaseState
@onready var air_state: BaseState
@onready var interactive_state: BaseState
@onready var dense_state: BaseState
@onready var combat_state: BaseState
@onready var behit_state: BaseState
@onready var behitDenseSafed_state: BaseState
@onready var behitDamaged_state: BaseState
@onready var light_state: BaseState
@onready var talk_state: BaseState
@onready var fastrun_state: BaseState
@onready var attack0_state: BaseState
@onready var attack1_state: BaseState
@onready var attack2_state: BaseState
@onready var attack3_state: BaseState
@onready var toptrans_state: BaseState

##当前状态是否要转换sprite
@export var change_sprite:bool=true
##当前状态是否要颜色覆盖sprite
@export var change_sprite_color:bool=false
##要覆盖sprite的颜色
@export var sprite_color:Color
##当前state是否为普通state,即能够在hit或者dense等临时状态后切回
@export var is_normal_state:bool=true
##将要赋予的角色
var player: Player
var move:int
var state_manager:PlayerStateManager
var aniplayer:AnimationPlayer

##初始化事件
func init(all_states) -> void:
	var property_list:Array[Dictionary] = self.get_script().get_script_property_list()
	for state in all_states:
		for p in property_list:
			if p.name==(state.name+"_state"):
				set(p.name,state)
				
##进入该状态的方法，每次进入都会执行，在pre_physics_process之前进行
func pre_enter() -> bool:
	return true
	
##在init之后执行的方法,只会在初始化时执行一次,适用于state的静态标记变量	
func init_var():
	pass
##在pre_enter之后在enter之前的方法,每次进入都会重新赋值,适用于state切换时的动态标记变量
func load_var():
	pass
	
##进入该状态的方法，每次进入都会执行，在pre_physics_process之前进行
func enter() -> BaseState:
	return null
	
#退出该状态的方法，每次进入都会执行，在physics_process之后进行
func exit(state:BaseState):
	pass

func is_animation_play()-> bool:
	return change_sprite

#有输入事件的方法,不确定与物理帧方法的顺序。慎用
func input(event: InputEvent) -> BaseState:
	return null

#游戏实际帧数的处理方法，godot默认物理帧FPS为60
#当游戏运行帧数大于物理帧FPS时：可通过传递delta获得与物理帧数同样效果
#而运行帧数小于物理帧数时，即使传递delta也可能导致问题
#运行顺序不确定
func process(delta: float) -> BaseState:
	return null
	
##物理帧方法，当变量涉及+=或者-+等随时间累计情况时，需要*delta
func physics_process(delta: float) -> BaseState:
	return
	
##物理帧中先执行的方法
func pre_physics_process(delta: float)->BaseState:
	return null
	
##物理帧中后执行的方法	
func after_physics_process(delta: float)->BaseState:
	return null

##玩家面朝方向
func player_faced(moves):
	if moves < 0:
		player.base.scale.x = -abs(player.base.scale.x)
		player.weapon.scale.x=-abs(player.weapon.scale.x)
		PlayerState.face_left=true
	elif moves > 0:
		player.weapon.scale.x=abs(player.weapon.scale.x)
		player.base.scale.x = abs(player.base.scale.x)
		PlayerState.face_left=false

##重力		
func apply_gravity(delta):
	player.velocity.y+=player.gravity*delta
	player.velocity.y=min(player.velocity.y,player.max_velocity_y)

##摩擦力	
func apply_friction(delta):
	player.velocity.x=move_toward(player.velocity.x,0,player.friction*delta)
func apply_acceleration_run(v,delta):
	player.velocity.x=move_toward(player.velocity.x,player.max_speed_run*v,player.acceleration_run*delta)
func apply_acceleration_walk(v,delta):
	player.velocity.x=move_toward(player.velocity.x,player.max_speed_walk*v,player.acceleration_run*delta)
func apply_acceleration_custom(v,scale_to_walk,delta):
	player.velocity.x=move_toward(player.velocity.x,player.max_speed_walk*v*scale_to_walk,player.acceleration_run*delta)
func apply_acceleration_fastrun(v,delta):
	player.velocity.x=move_toward(player.velocity.x,player.max_speed_fast_run*v,player.acceleration_run*delta)
func apply_acceleration_dash(v,delta):
	player.velocity.x=move_toward(player.velocity.x,player.max_speed_dash*v,player.acceleration_dash*delta)
func apply_climb_acceleration_y(delta):
	player.velocity.y=move_toward(player.velocity.y,-player.max_speed_run,player.climb_speed*delta)
func apply_climb_acceleration_x(delta):
	player.velocity.x=move_toward(player.velocity.x,-player.max_speed_run,player.climb_speed*delta)
func min_jump_force(velocity:Vector2,delta)->Vector2:
	if velocity.y<-player.min_jump_fource and velocity.y<0 and Input.is_action_just_released("jump"):
		velocity.y=-player.jump_speed/player.click_jump_force_limit
	return velocity
func is_on_ladder()->bool:
	if not player.ladder_checker.is_colliding():return false
	var clollider=player.ladder_checker.get_collider()
	return true
func get_movement_input_x() -> int:
	var a= Input.get_axis("move_left","move_right")
	if a==0:
		return 0
	elif a>0:
		return 1
	else:
		return -1
func is_player_change_moving_direction()->bool:
	if Input.is_action_pressed("move_left") and player.velocity.x>0:
		return true
	if Input.is_action_pressed("move_right") and player.velocity.x<0:
		return true
	return false
func get_palyer_move_direction_x()->int:
		if  player.velocity.x>0:
			return 1
		elif player.velocity.x==0:
			return 0
		else :
			return -1
func get_player_faced_direction():
	if player.base.flip_h == false:
		return -1
	else:
		return 1
func is_player_blocked()->bool:
	if player.block_checker_right.is_colliding() or player.block_checker_right.is_colliding():
		return true
	return false
	
func play_animation():
	player.base.play(self.get_name())
	#player.reflection.play(self.get_name())

func change_animation_color(flag:bool=false):
	player.base.material.set_shader_parameter("color",sprite_color)
	player.base.material.set_shader_parameter("colored",flag)
	if flag:
		player.base.pause()
	else:
		player.base.play()
