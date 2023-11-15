extends Weight
var distance

func _process(delta: float) -> void:
	if PlayerState.attacking:
		weight.value = 100
	else :
		weight.value = 0
