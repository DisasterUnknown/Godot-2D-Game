extends PointLight2D

var _timer = randi_range(0, 999)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_timer += 1
	var new_scale = sin(_timer * 0.009) * 0.1
	scale = Vector2(1 + new_scale, 1 + new_scale)
