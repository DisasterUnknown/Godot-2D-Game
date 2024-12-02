extends PointLight2D

var _timer = randi_range(0, 999)
const lampSize = 0.1
const lampTime = 0.005
#0.1
#0.005

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_timer += 1
	var new_scale = sin(_timer * lampTime) * lampSize
	scale = Vector2(1 + new_scale, 1 + new_scale)
