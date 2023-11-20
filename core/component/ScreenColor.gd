##获取当前屏幕上的平均颜色
class_name ScreenColor extends Component
##实际计算的缩小倍数,有利于性能
@export var scale:float=5
var black_bar_height:int=0
##计算时,从屏幕顶部开始向下要忽略的屏幕比例
@export var top_ignore_height:float=.4
##计算时,从屏幕底部开始向上要忽略的屏幕比例
@export var bot_ignore_height:float=.0
##上下黑边相对于屏幕的高度大小比例,0则为没有黑边
@export var black_bar_scale_2_screen:float=.0
var screen_color:Color
var screen_color_trans:Color=Color.TRANSPARENT

func init_var():
	clazz_name="ScreenColor"
	FATHER_CLASS_NAME=""

func connect_signal():
	EventBus.get_screen_color.connect(_get_screen_color)

##计算屏幕颜色
func _get_screen_color():
	# Wait until the frame has finished before getting the texture.
	await RenderingServer.frame_post_draw
	# Retrieve the captured image.
	var viewport = get_viewport()
	var img=viewport.get_texture().get_image()
	var w=img.get_width()/scale
	var h=img.get_height()/scale
	black_bar_height=h*black_bar_scale_2_screen
	var t_h=h-(black_bar_height*2)
	var r:float=0
	var g:float=0
	var b:float=0
	var a:float=0
	var i:int=0
	img.resize(w,h)
	var color:Color
	for x in w:
		for y in h:
			if y>black_bar_height+(t_h*top_ignore_height) and y<h-black_bar_height-bot_ignore_height*t_h:
				color=img.get_pixelv(Vector2(x,y))
				r+=color.r
				g+=color.g
				b+=color.b
				a+=color.a
				i+=1
	screen_color= Color(r/i,g/i,b/i,a/i)
	screen_color_trans=Color(r/i,g/i,b/i,0)
