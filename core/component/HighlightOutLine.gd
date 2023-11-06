extends Node
@onready var obj = $".."
@onready var outline = $"../Outline"
#物体高亮边缘
#要求高亮sprite名称为「Outline」，放于一层子类
func _ready():
	outline.hide()
	obj.mouse_entered.connect(_highlight_on)
	obj.mouse_exited.connect(_highlight_off)
	pass 

func _highlight_on():
	outline.show()
	pass
func _highlight_off():
	outline.hide()
	pass
