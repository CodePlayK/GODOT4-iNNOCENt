extends Npcs
class_name NpcSen
func _ready() -> void:
	super._ready()
			
func enable_all_interact(flag):
	if on_combat or on_fighting:return
	enable_self(flag)
	enable_player_detection(flag)

func enable_player_detection(flag):
	player_detection.set_deferred("monitoring",flag)
	player_detection.set_deferred("monitorable",flag)
	
func enable_self(flag):
	set_deferred("monitoring",flag)
	set_deferred("monitorable",flag)
	
func enable_weapon(flag:bool):
	hit_box.set_enable(flag)
