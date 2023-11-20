extends StackingState

func enter():
	#Debug.dprintwarn("[staminaerror]耐力条不足")
	EventBus._play_SE("stamina_error",1,-10,self.name)
	pass
