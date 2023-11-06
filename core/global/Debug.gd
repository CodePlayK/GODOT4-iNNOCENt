extends Node
@onready var debug_printer:RichTextLabel = $MC/HBoxContainer/DebugPrinter
@onready var mc = $MC
@export var offset_top1:int=145
@export var offset_top2:int=260
var time:String
func _ready():
	mc.offset_top=offset_top2
	await RenderingServer.frame_post_draw
	debug_printer.get_v_scroll_bar().hide()

func dprint(txt):
	time = str(Time.get_ticks_msec())
	print("["+time+"] "+str(txt))
	debug_printer.append_text("\n["+time+"] "+str(txt))
	
func dprinterr(txt):
	time = str(Time.get_ticks_msec())
	printerr("["+time+"] "+str(txt))
	debug_printer.append_text("\n["+time+"] [color=ff241ae5]"+str(txt)+"[/color]")
		
func dprintinfo(txt):
	time = str(Time.get_ticks_msec())
	print("["+time+"] "+str(txt))
	debug_printer.append_text("\n["+time+"] [color=1ee6d2]"+str(txt)+"[/color]")

func _on_printer_mouse_entered():
	debug_printer.grab_focus()
	mc.offset_top=offset_top1
	debug_printer.get_v_scroll_bar().show()
	
func _on_printer_mouse_exited():
	debug_printer.release_focus()
	mc.offset_top=offset_top2
	await RenderingServer.frame_post_draw
	debug_printer.scroll_to_line(debug_printer.get_line_count())
	debug_printer.get_v_scroll_bar().hide()

func _on_button_pressed():
	debug_printer.get_v_scroll_bar().hide()
