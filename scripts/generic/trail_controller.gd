extends Sprite

onready var visibility = $VisibilityNotifier2D
var fadeSpeed = 0.1
var modulation := Color.white

func _ready():
	visibility.connect("screen_exited", self, "_kill")
	_setColor(modulation)
	
func _setColor(color : Color):
	var material = self.get_material()
	material.set_shader_param("flash_color", color)
	
func _process(_delta):
	modulate.a -= fadeSpeed
	modulate.b += fadeSpeed * 4
	
	if (modulate.a <= 0):
		_kill()
		
func _kill():
	queue_free()
