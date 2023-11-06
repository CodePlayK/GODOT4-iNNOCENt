extends Component
##标题画面
##
##目前实际效果相当于暂停菜单, 暂停游戏实际在[method Room2Title._to_title_screen]中调用,而启用游戏则在[method to_game]中
class_name TitleRoom
##动画播放器
@onready var aniplayer = $Aniplayer
##标题相机
@onready var title_screen_camera = %TitleScreenCamera
@onready var screen_color = $ScreenColor
##当前的平均色
var room_color:Color
##当前的平均色透明色
var room_color_trans:Color
##按键能够点击
var click_able:bool=true

func init_var():
	FATHER_CLASS_NAME="Rooms"
	clazz_name="TitleRoom"

func connect_signal():
	EventBus.enable_title_screen_camera.connect(_enable_title_screen_camera)
	EventBus.title_2_game.connect(_on_continue_pressed)
	
func ready():
	await screen_color._get_screen_color()
	room_color=screen_color.screen_color
	room_color_trans=screen_color.screen_color_trans
	pass 
##继续按钮按下
func _on_continue_pressed():
	if !click_able:return
	click_able=false
	to_game()
	pass 
##保存按钮按下
func _on_save_pressed():
	if !click_able:return
	EventBus._save_game()
	EventBus._player_save_game()
	to_game()
	pass 
##启用标题相机
func _enable_title_screen_camera(flag:bool=true):
	if flag:title_screen_camera.make_current()
	aniplayer.play("to_title")
	await aniplayer.animation_finished
	click_able=true
	pass 
##载入按钮按下
func _on_load_pressed():
	EventBus._load_game()
	EventBus._player_load_game()
	to_game()
	pass 
##返回游戏[Rooms],接触游戏暂停状态
func to_game():
	await screen_color._get_screen_color()
	room_color=screen_color.screen_color
	room_color_trans=screen_color.screen_color_trans
	aniplayer.play("start_game")
	await aniplayer.animation_finished
	get_tree().set_pause(false)
	EventBus._title_transition_completed()
##删除存档按钮按下
func _on_delete_pressed():
	EventBus._delete_save()
	pass 
