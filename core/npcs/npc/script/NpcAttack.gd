extends NpcsAttackState

func pre_enter() -> bool:
	if !PlayerState.attacking:
		return true
	else:
		return false
