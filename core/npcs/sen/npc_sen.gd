extends Npcs
class_name NpcSen
@onready var weapon: Area2D = $Weapon
@onready var player_detection: Area2D = $PlayerDetection

func _ready() -> void:
	super._ready()
			
func enable_all_interact(flag):
	if on_combat or on_fighting:return
	enable_self(flag)
	enable_player_detection(flag)

func enable_player_detection(flag):
	Debug.dprintinfo("[%s][%s][%s][%s]全局统治锁定检测player-[%s]" %[current_state,self.name,str(on_combat),str(on_fighting),str(flag)])
	player_detection.set_deferred("monitoring",flag)
	player_detection.set_deferred("monitorable",flag)
	
func enable_self(flag):
	set_deferred("monitoring",flag)
	set_deferred("monitorable",flag)
	
func enable_weapon(flag):
	weapon.set_deferred("monitoring",flag)
	weapon.set_deferred("monitorable",flag)
