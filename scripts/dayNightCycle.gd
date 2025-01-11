extends CanvasModulate

@export var gradinet:GradientTexture2D

var time = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta/100
	var value = (sin(time - PI / 2) + 1.0) / 2.0
	self.color = gradinet.gradient.sample(value)
