extends PlayerAttackState

func pre_enter() -> bool:
	if !PlayerState.attaking:
		return true
	else:
		return false
