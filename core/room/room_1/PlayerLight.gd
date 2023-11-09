##玩家灯光
##
##只照亮玩家,可用于动态根据玩家位置切换亮度模拟灯光切换
class_name PlayerLight extends Component
@onready var player=%Player
var bright=7.3
var last_bright=7.3
@export var base_bright:float
var energy_tween

func ready() -> void:
	base_bright=self.energy
	EventBus.change_player_light.connect(_on_change_player_light)

func init_var():
	clazz_name="PlayerLight"
	FATHER_CLASS_NAME=""

func _on_change_player_light(bright:float):
	change_bright(bright)
	
func change_bright(bright:float):
	if last_bright!=bright:
		if bright==0:bright=base_bright
		energy_tween=self.create_tween()
		last_bright=bright
		energy_tween.tween_property(self,"energy",bright,.1)
		await energy_tween.finished
		energy_tween.kill()
	
