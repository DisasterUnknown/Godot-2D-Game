extends CharacterBody2D

@onready var slimeAudioWalk = $AudioStreamSlime_jump

var speed = 85 
var player_chase = false
var player = null

func audio_play(movement):
	if movement == 1:
		if (!slimeAudioWalk.playing):
			slimeAudioWalk.play()
	else:
		slimeAudioWalk.stop()


func _physics_process(delta):
	if player_chase:
		position += (player.position - position).normalized() * speed * delta
		move_and_collide(Vector2(0,0))

		$AnimatedSprite2D.play("walk")
		audio_play(1)
	else:
		$AnimatedSprite2D.play("idle")
		audio_play(0)


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
