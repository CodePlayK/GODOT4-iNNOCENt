extends MarginContainer

@onready var stamina_bar: UIbar = $VBC/HBC/StaminaBar
@onready var fight_dely_time: Timer = $VBC/HBC/FightDelyTime

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stamina_bar.bar_max_value = PlayerState.max_stamina
	EventBus.player_stamina_recovered.connect(_on_player_stamina_recovered)
	EventBus.player_stamina_damaged.connect(_on_player_stamina_damaged)
	EventBus.player_on_fighting_changed.connect(_on_player_on_fighting_changed)
func _on_player_stamina_recovered():
	stamina_bar.bar_grow(PlayerState.stamina)
func _on_player_stamina_damaged():
	stamina_bar.bar_decrease(PlayerState.stamina)
func _on_player_on_fighting_changed(flag):
	if flag:
		stamina_bar.visible = flag
	else :
		if stamina_bar.visible and fight_dely_time.is_stopped():
			fight_dely_time.start(3)

func _on_fight_dely_time_timeout() -> void:
	if PlayerState.stamina == PlayerState.max_stamina:
		stamina_bar.hide()
