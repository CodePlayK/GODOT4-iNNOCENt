extends NpcsCombatState
@export_category("巡逻配置")
##巡逻的范围,以左边为起点计算
@export var patrol_distance:float=150
##巡逻范围的随机系数
@export var patrol_distance_rand:Vector2=Vector2(.8,1.2)
##跑完一次巡逻距离的时间,以即单趟
@export var patrol_time:float=3
##巡逻时间的随机系数
@export var patrol_time_rand:Vector2=Vector2(.8,1.2)
##巡逻单趟后原地停止的时间
@export var wait_time:float=3
##巡逻单趟后原地停止时间的随机系数
@export var wait_time_rand:Vector2=Vector2(.8,1.2)
var patrol_distance_t:float
var patrol_time_t:float
var wait_time_t:float
var base_position:float
var tween:Tween
var speed_map_2_animation
var face_direction: FaceDirection


func init_var():
	speed_map_2_animation = npc.speed_map_2_animation
	face_direction = npc.face_direction
	
func enter():
	super.enter()
	var face_flag=false
	speed_map_2_animation.set_enabel(true)
	base_position=npc.get_position().x
	rand()
	if !npc.patrol_right or !npc.patrol_left:
		Debug.dprinterr("[%s]未配置巡逻边界点" %npc.name)
	##TODO 没有设定巡逻边界的逻辑
	if npc.get_position().x+patrol_distance_t>npc.patrol_right.global_position.x:
		patrol_distance_t=-abs(patrol_distance_t)
		face_flag=true
	tween=npc.create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.chain().tween_interval(.5)
	tween.chain().tween_property(npc,"global_position",Vector2(base_position+patrol_distance_t,npc.get_position().y),patrol_time_t)
	tween.parallel().tween_callback(npc.aniplayer.play.bind(animation_name_real))
	tween.parallel().tween_callback(face_direction.set_faced.bind(face_flag))
	tween.chain().tween_interval(wait_time_t)
	tween.parallel().tween_callback(npc.aniplayer.play.bind(idle_state.name))
	tween.chain().tween_property(npc,"global_position",Vector2(base_position,npc.get_position().y),patrol_time_t)
	tween.parallel().tween_callback(face_direction.set_faced.bind(!face_flag))
	tween.parallel().tween_callback(npc.aniplayer.play.bind(animation_name_real))
	tween.chain().tween_interval(wait_time_t)
	tween.parallel().tween_callback(npc.aniplayer.play.bind(idle_state.name))
	tween.chain().tween_callback(rand)

func rand():
	patrol_distance_t=patrol_distance*randf_range(patrol_distance_rand.x,patrol_distance_rand.y)
	patrol_time_t=patrol_time*randf_range(patrol_time_rand.x,patrol_time_rand.y)
	wait_time_t=wait_time*randf_range(wait_time_rand.x,wait_time_rand.y)

func physics_process(delta: float):
	if npc.player_detection.has_overlapping_bodies():
		if get_npc_faced_direction()==1 and npc.global_position.x + 40 >= npc.patrol_right.global_position.x:
			return attack0_state
		elif get_npc_faced_direction()==-1 and npc.global_position.x - 40 <= npc.patrol_right.global_position.x:
			return attack0_state
		return chase_state
	return await npc.patrol_weight_machine.process()
func exit(state:NpcsBaseState):
	npc.patrol_weight_machine.exit()
	speed_map_2_animation.set_enabel(false)
	if tween:
		tween.kill()

