extends Component
@onready var health_bar: ProgressBar = $healthBar
var obj

func on_master_ready(master):
	obj = master.obj
	health_bar.max_value=obj.health

func _process(delta):
	if !obj:return
	health_bar.value=obj.health

