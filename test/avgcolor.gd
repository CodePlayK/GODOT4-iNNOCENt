extends Node2D
@onready var title_room = $".."

@onready var sprite_2d_2 = $"../Sprite2D2"

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.get_screen_color.connect(_get_screen_color)
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func capture_screen():
	# Wait until the frame has finished before getting the texture.
	await RenderingServer.frame_post_draw
	# Retrieve the captured image.
	var viewport = title_room.get_viewport()
	var img = viewport.get_texture().get_image()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _get_screen_color():
	capture_screen()
	var tex = ImageTexture.new()
	#tex.create_from_image(img)
	sprite_2d_2.texture=tex
