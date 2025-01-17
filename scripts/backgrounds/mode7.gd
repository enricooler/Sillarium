extends CanvasLayer

onready var f = $Floor
onready var mat = f.get_material()

var wrap = 0
var speed = 0.125

func _process(_delta):
	wrap = wrapf(wrap + speed, 0, 2)
	mat.set_shader_param("POSITION", wrap)
