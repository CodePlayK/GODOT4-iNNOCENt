extends Npcs
@onready var player_detection: Area2D = $PlayerDetection
@onready var weapon: Area2D = $Weapon

func _ready() -> void:
	super._ready()
	obj_name=npc_name

func enable_all_interact(flag):
	if on_combat:return
	enable_self(flag)
	enable_player_detection(flag)

func enable_player_detection(flag):
	player_detection.set_deferred("monitoring",flag)
	player_detection.set_deferred("monitorable",flag)
	
func enable_self(flag):
	self.monitoring=flag
	self.monitorable=flag
	
func enable_weapon(flag):
	weapon.set_deferred("monitoring",flag)
	weapon.set_deferred("monitorable",flag)
