extends Node2D

@onready var balloon: Control = $Balloon
@onready var margin: MarginContainer = $Balloon/VB/background/Margin
@onready var hint_sprite = $Balloon/VB/background/Margin/HB/VB/HB/MC/Hint
@onready var character_label: RichTextLabel = $Balloon/VB/background/Margin/HB/VB/CharacterLabel
@onready var dialogue_label:=$Balloon/VB/background/Margin/HB/VB/HB/DialogueLabel
@onready var responses_menu: VBoxContainer = %Responses
@onready var response_template: RichTextLabel = %ResponseTemplate
@onready var background =$Balloon/VB/background
@onready var response_margin =  %responseMargin
@onready var background_color = $Balloon/VB/background/BackgroundColor
@onready var pointer_right = $Balloon/VB/MC/HB/MC2/PointerRight
@onready var pointer_left = $Balloon/VB/MC/HB/MC/PointerLeft
@onready var response_style_box =preload("res://core/common/dialogue_ballon/dialogue/response style box focus.tres")
@onready var screen_checker_r = %ScreenCheckerR
@onready var screen_checker_l = %ScreenCheckerL
@onready var vb = $Balloon/VB
@onready var dialogue_start_timer: Timer = $DialogueStartTimer
@onready var dialogue_ended_timer: Timer = $DialogueEndedTimer
@onready var timer = $DialogueEndTimer
@onready var typeout_timer = $TypeoutTimer
var balloon_visiable:bool=false
var temp_position_l:Vector2
var temp_position_r:Vector2


#最大长度
var max_x=0
var temp_margin=6
var left_side_flag=false
var base_position=Vector2.ZERO
## The dialogue resource
var resource: DialogueResource
## Temporary game states
var temporary_game_states: Array = []
## See if we are waiting for the player
var is_waiting_for_input: bool = false
var current_obj_name:String
var current_obj_position_name:String
var nextable:bool=true

var last_talk_obj

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
#		锁定player能力
		lock_player_ability()
#		通知目标对象更新对话坐标
		#EventBus._get_obj_position(current_obj_position_name)
#		获取目标最新对话坐标
		#base_position=DialogueState.dic_dialogue_position[current_obj_position_name]
		base_position=last_talk_obj.dialogue_position.global_position
#		清除上一次选项框与label内容
		for item in responses_menu.get_children():
			item.text=""
		dialogue_label.text=""
		character_label.text=""
		#hide_balloon()
		max_x=0
		is_waiting_for_input = false
		if not next_dialogue_line:
			hide_balloon()
			unlock_player_ability()
			return
		# Remove any previous responses
		for child in responses_menu.get_children():
			child.queue_free()
#		自动配置对话框颜色
		if next_dialogue_line.character in DialogueState.dic_sprite_talk_color:
			background_color.color=DialogueState.dic_sprite_talk_color[next_dialogue_line.character]
		else:
			background_color.color=DialogueState.dic_sprite_talk_color["NA"]
		pointer_right.material.set_shader_parameter("color",background_color.color)
		pointer_left.material.set_shader_parameter("color",background_color.color)
		response_style_box.bg_color=background_color.color
		dialogue_line = next_dialogue_line
		character_label.visible = not dialogue_line.character.is_empty()
		character_label.text = dialogue_line.character+":"
		dialogue_label.modulate.a = 0
		#dialogue_label.size.x = dialogue_label.get_parent().size.x - 1
		dialogue_label.dialogue_line = dialogue_line
		if null==dialogue_line.next_id or ""==dialogue_line.next_id:
			hint_sprite.hide()
		else:
			hint_sprite.show()
		#await dialogue_label.reset_height()
		# Show any responses we have
		responses_menu.modulate.a = 0
		margin.size = Vector2.ZERO
		response_margin.size = Vector2.ZERO
#		配置多选项
		if dialogue_line.responses.size() > 0:
			for response in dialogue_line.responses:
				# Duplicate the template so we can grab the fonts, sizing, etc
				var item: RichTextLabel = response_template.duplicate(0)
				item.name = "Response%d" % responses_menu.get_child_count()
				if not response.is_allowed:
					item.name = String(item.name) + "Disallowed"
					item.modulate.a = 0.4
				item.text = response.text
				item.size.x=item.get_content_width()+5
				item.show()
				responses_menu.add_child(item)
			configure_menu()
#		预计算左右位置
		temp_position_l= get_left_side_position()
		temp_position_r= get_right_side_position()
#		判断当前对话框边界是否超出屏幕，超出则反向
		if left_side_flag:
			self.global_position=temp_position_l
			await RenderingServer.frame_post_draw
			if !screen_checker_l.is_on_screen():
				left_side_flag=false
				self.global_position=temp_position_r
		else:
			self.global_position=temp_position_r
			await RenderingServer.frame_post_draw
			if !screen_checker_r.is_on_screen():
				left_side_flag=true
				self.global_position=temp_position_l
		dialogue_label.modulate.a = 1
		max_x=0
		if not dialogue_line.text.is_empty():
			show_balloon()
			nextable=false
			dialogue_label.type_out()
			await dialogue_label.finished_typing
			nextable=true
		# Wait for input
		if dialogue_line.responses.size() > 0:
			responses_menu.modulate.a = 1
		elif dialogue_line.time != null:
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line

func _ready() -> void:
	hide_balloon()
	margin.size = Vector2.ZERO
	response_margin.size = Vector2.ZERO
	DialogueManager.mutated.connect(_on_mutation)
	EventBus.next_dialogue.connect(_on_next_dialogue)
	EventBus.talk.connect(start)
	EventBus.end_talk.connect(_end_talk)

func _end_talk():
	typeout_timer.stop()
	typeout_timer.start()
	DialogueManager.dialogue_ended.emit()
	if !nextable:
		nextable=true
	unlock_player_ability()
	hide_balloon()

func _on_next_dialogue() -> void:
	if not is_waiting_for_input and !nextable: return
	next(dialogue_line.next_id)
## Start some dialogue
func start(obj,dialogue_resource: Resource, title: String, dialogue_position:Vector2=Vector2.ZERO,flag:bool=false,obj_name:String="NA",extra_game_states: Array = []) -> void:
	if last_talk_obj==obj and !dialogue_start_timer.is_stopped() and !CutsceneState.cutscener_playing:
		Debug.dprinterr("[%s]当前obj对话速度过快!" %obj.obj_name)
		return
	last_talk_obj=obj
	if !nextable:
		await dialogue_label.finished_typing
		nextable=true
	if !typeout_timer.is_stopped():
		await timer.timeout
	temporary_game_states = extra_game_states
	current_obj_name=obj.obj_name
	current_obj_position_name=obj.name
	if dialogue_position !=Vector2.ZERO:
		self.global_position=dialogue_position
	base_position=dialogue_position
	left_side_flag=flag
	is_waiting_for_input = false
	resource = dialogue_resource
	dialogue_start_timer.start()
	self.dialogue_line = await DialogueManager.get_next_dialogue_line(resource, title, temporary_game_states)
	pass

## Go to the next line
func next(next_id: String) -> void:
	if !nextable:return
	add_obj_interact_time()
	self.dialogue_line = await DialogueManager.get_next_dialogue_line(resource, next_id, temporary_game_states)

# Set up keyboard movement and signals for the response menu
func configure_menu() -> void:
	balloon.focus_mode = Control.FOCUS_NONE
	var items = get_responses()
	for i in items.size():
		var item: Control = items[i]
		item.focus_mode = Control.FOCUS_ALL
		item.focus_neighbor_left = item.get_path()
		item.focus_neighbor_right = item.get_path()

		if i == 0:
			item.focus_neighbor_top = item.get_path()
			item.focus_previous = item.get_path()
		else:
			item.focus_neighbor_top = items[i - 1].get_path()
			item.focus_previous = items[i - 1].get_path()

		if i == items.size() - 1:
			item.focus_neighbor_bottom = item.get_path()
			item.focus_next = item.get_path()
		else:
			item.focus_neighbor_bottom = items[i + 1].get_path()
			item.focus_next = items[i + 1].get_path()
		if !item.mouse_entered.is_connected(_on_response_mouse_entered):
			item.mouse_entered.connect(_on_response_mouse_entered.bind(item))
		if !item.gui_input.is_connected(_on_response_gui_input):
			item.gui_input.connect(_on_response_gui_input.bind(item))
	items[0].grab_focus()
# Get a list of enabled items
func get_responses() -> Array:
	var items: Array = []
	for child in responses_menu.get_children():
		if "Disallowed" in child.name: continue
		items.append(child)
	return items

### Signals
func _on_mutation() -> void:
	is_waiting_for_input = false
	hide_balloon()

func _on_response_mouse_entered(item: Control) -> void:
	if "Disallowed" in item.name: return
	item.grab_focus()

func _on_response_gui_input(event: InputEvent, item: Control) -> void:
	if "Disallowed" in item.name: return
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				next(dialogue_line.responses[item.get_index()].next_id)
	elif event.is_action_pressed("ui_accept") and item in get_responses():
		next(dialogue_line.responses[item.get_index()].next_id)

func _on_balloon_gui_input(event: InputEvent) -> void:
	if not is_waiting_for_input: return
	if null!=dialogue_line and dialogue_line.responses.size() > 0: return
	# When there are no response options the balloon itself is the clickable thing
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		next(dialogue_line.next_id)
	elif (event.is_action_pressed("ui_accept") or event.is_action_pressed("interactive")) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)

func get_left_side_position() -> Vector2:
	if dialogue_line.responses.size() > 0:
		for item in responses_menu.get_children():
			max_x=max(max_x,item.get_content_width())
	else:
		max_x=0
		if max_x>dialogue_label.get_content_width()+6:
			temp_margin=3
		else :
			temp_margin=3
	temp_position_l=Vector2(base_position.x-(max(max_x,dialogue_label.get_content_width(),character_label.get_content_width()))*self.scale.x-temp_margin,base_position.y)
	return temp_position_l

func get_right_side_position() -> Vector2:
	temp_position_r=Vector2(base_position.x,base_position.y)
	return temp_position_r
	
func hide_balloon():
	response_margin.modulate.a=0
	background.modulate.a=0
	pointer_left.self_modulate.a=.1
	pointer_right.self_modulate.a=.1
	balloon_visiable=false
func show_balloon():
	if !nextable:
		await dialogue_label.finished_typing
		nextable=true
	response_margin.modulate.a=.95
	background.modulate.a=.95
	if left_side_flag:
		pointer_left.self_modulate.a=.01
		pointer_right.self_modulate.a=.95
	else:
		pointer_right.self_modulate.a=.01
		pointer_left.self_modulate.a=.95
	vb.visible = true
	balloon_visiable=true
	
func lock_player_ability():
	PlayerState.ability_lock=true

func unlock_player_ability():
	timer.stop()
	timer.start(0.1)

func _on_timer_timeout():
	PlayerState.ability_lock=false
	pass 

func add_obj_interact_time():
	EventBus._add_interact_time(current_obj_name)


func _on_typeout_timer_timeout():
	hide_balloon()
	pass 


func _on_tree_exiting():
	PlayerState.ability_lock=false
	pass 


func _on_dialogue_ended_timer_timeout() -> void:
	if null!=last_talk_obj and !last_talk_obj.on_talk:
		PlayerState.ability_lock=false
		hide_balloon()
	pass 
