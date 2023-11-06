extends Node
class_name CutsceneManager
@onready var last_state:CutsceneBaseState
@onready var current_state:CutsceneBaseState = $CutsceneBaseState
@onready var cutscene_base_state = $CutsceneBaseState

var all_states: Array
var on_ready:bool=false

func _ready():
	init()

func change_state(new_state: CutsceneBaseState) -> void:        
	if current_state and current_state!=new_state:
		if !current_state==cutscene_base_state:
			current_state.exit()
		last_state=current_state
		print_a_to_b(current_state.name,new_state.name)
		current_state = new_state
		current_state=current_state
		current_state.enter()

func init() -> void:
	for cutscene in cutscene_base_state.get_children():
		all_states.append(cutscene)
	conect_eventbus()
	_on_change_cutscene(CutsceneState.current_cutscene)
	on_ready=true
	EventBus.emit_signal("cutscene_loaded")
func physics_process(delta: float) -> void:
	if !on_ready:return
	current_state.physics_process(delta)
func input(event: InputEvent) -> void:
	if !on_ready:return
	current_state.input(event)

func process(delta: float) -> void:
	if !on_ready:return
	current_state.process(delta)

func get_childen_node(node:Node):
	for child in node.get_children():
		all_states.append(child)
		if child:
			get_childen_node(child)
			
func print_a_to_b(a,b):
	var format_string = "过场状态机切换: [%s] --> [%s]"
	var actual_string = format_string % [a, b]
	Debug.dprintinfo(actual_string)
	return actual_string
	
func conect_eventbus():
	EventBus.change_cutscene.connect(_on_change_cutscene)
	EventBus.cutscene_play.connect(_on_cutscene_play)
	
func _on_change_cutscene(cutscene_name):
	for state in all_states:
		if cutscene_name in state.name:
			change_state(state)
			return null
	
func _on_cutscene_play():
	CutsceneState.cutscene_playing=true
	current_state.play_cutscene()

