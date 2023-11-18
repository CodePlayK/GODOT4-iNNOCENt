extends Node
@onready var stiff_bar=$StiffBar
@onready var npc: Npcs = $".."

func _ready():
	stiff_bar.max_value=npc.health

func _process(delta):
	stiff_bar.value=npc.health

