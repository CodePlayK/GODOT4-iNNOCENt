##工具类,[Rooms]切换到[TitleRoom]
##
##[color=yellow]注意:[/color]必须挂载于[Rooms]节点下!
class_name Room2Title extends Component
##全屏颜色
@onready var trans_color_rect: ColorRect = $"../CanvasLayer/TransColorRect"
##当前[Rooms]中的[TitleRoom]
@onready var title_room: TitleRoom = $"../title_room"
##玩家相机
@onready var player_camera: Camera2D = %PlayerCamera

func init_var():
	FATHER_CLASS_NAME="Rooms"
	clazz_name="ScreenColor"
	
##就绪
func ready() -> void:
	EventBus.title_transition_completed.connect(_title_transition_completed)
	EventBus.to_title_screen.connect(_to_title_screen)
	
##收到[signal EventBus.title_transition_completed]过渡结束后的方法
func _title_transition_completed():
	var tween=trans_color_rect.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(trans_color_rect,"color",title_room.room_color,.2)
	tween.chain().tween_callback(room_camrea)
	tween.chain().tween_property(trans_color_rect,"color",title_room.room_color_trans,.3)
	tween.tween_interval(.5)
	tween.tween_callback(transaction_end)
	
##收到[signal EventBus.to_title_screen]切换到[TitleRoom]后的方法,在此处暂停游戏
func _to_title_screen():
	if !CutsceneState.title_able:return
	CutsceneState.title_able=false
	var tween=trans_color_rect.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(trans_color_rect,"color",title_room.room_color,.2)
	tween.chain().tween_callback(title_camrea)
	tween.chain().tween_property(trans_color_rect,"color",title_room.room_color_trans,.2)
	tween.chain().tween_callback(get_tree().set_pause.bind(true))
	
##切换到[TitleRoom]相机
func title_camrea():
	EventBus._enable_title_screen_camera(true)
	player_camera.position_smoothing_enabled=true
	player_camera.limit_smoothed=true
	
##切换到[Rooms](Player)相机
func room_camrea():
	player_camera.make_current()
	player_camera.reset_smoothing()
	player_camera.position_smoothing_enabled=true
	player_camera.limit_smoothed=true
	await get_tree().process_frame
	player_camera.reset_smoothing()
	
##切换回[Rooms]完毕后执行
func transaction_end():
	CutsceneState.title_able=true
