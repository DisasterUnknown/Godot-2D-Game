extends Sprite2D

@onready var spawnPosition = position

var target_position = Vector2()
var velocity = Vector2()
var speed = randi_range(10, 20)
var movement_timer = 0
var change_target_interval = randf_range(1.0, 2.0)  # Seconds between target position changes
var direction_smoothness = 0.1  # Smaller values for smoother turns
var _timer = randi_range(0, 999)
const lampSize = 0.1
const lampTime = 0.005

# Noise generator for smooth, curved motion
var noise = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the initial target position
	set_new_target_position()

	# Configure FastNoiseLite for curved motion
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_CELLULAR  # Using Perlin noise for smooth curves
	noise.frequency = 0.5  # Adjust frequency for larger or smaller curves

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fly_lamp(delta)
	movement(delta)

func movement(delta):
	# Calculate the desired velocity toward the target position
	var desired_velocity = (target_position - position).normalized() * speed

	# Apply noise to create curves in the path
	var offset_x = noise.get_noise_2d(position.x * 0.05, Time.get_unix_time_from_system() * 0.05) * 20
	var offset_y = noise.get_noise_2d(position.y * 0.05, Time.get_unix_time_from_system() * 0.05) * 20
	var noise_offset = Vector2(offset_x, offset_y)
	
	# Combine the desired velocity with the noise offset
	velocity = velocity.lerp(desired_velocity + noise_offset.normalized() * 5, direction_smoothness)
	
	# Update position based on the smoothed velocity
	position += velocity * delta

	# Increment timer and check if it's time to change the target position
	movement_timer += delta
	if movement_timer >= change_target_interval:
		set_new_target_position()
		movement_timer = 0

func set_new_target_position():
	# Generate a new random target position within the range
	var random_offset_x = randi_range(-50, 50)
	var random_offset_y = randi_range(-50, 50)
	target_position = spawnPosition + Vector2(random_offset_x, random_offset_y)

func fly_lamp(delta):
	_timer += 1
	var new_scale = sin(_timer * lampTime) * lampSize
	scale = Vector2(1 + new_scale, 1 + new_scale)
