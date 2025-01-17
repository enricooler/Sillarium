extends TextureRect

var offsetLimit = texture.get_size()
export (int) var speed = 1;

func _ready():
	rect_size = rect_size + (offsetLimit * 2)
	
func _process(_delta):
	rect_position -= Vector2(speed, speed)
	
	if (abs(rect_position.x) >= offsetLimit.x):
		rect_position.x = 0;
		
	if (abs(rect_position.y) >= offsetLimit.y):
		rect_position.y = 0;
