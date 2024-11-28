extends CharacterBody2D

@onready var slimeAudioWalk = $AudioStreamSlime_jump

var speed = 85 
var player_chase = false
var player = null

var health = 100
var player_inAtk_range = false
var can_take_dmg = true
var dying = false

func audio_play(movement):
	if movement == 1:
		if (!slimeAudioWalk.playing):
			slimeAudioWalk.play()
	else:
		slimeAudioWalk.stop()


func _physics_process(delta):
	deal_with_dmg()
	
	if !dying:
		if player_chase:
			position += (player.position - position).normalized() * speed * delta
			move_and_collide(Vector2(0,0))

			$AnimatedSprite2D.play("walk")
			audio_play(1)
		else:
			$AnimatedSprite2D.play("idle")
			audio_play(0)


func enemy():
	pass


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inAtk_range = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inAtk_range = false		


func deal_with_dmg():
	if player_inAtk_range and Global.player_current_atk and can_take_dmg:
		health = health - 20
		can_take_dmg = false
		$gainDmg_cooldown.start()
		print("Slime Health: ", health)
		if health <= 0:
			dying = true
			$AnimatedSprite2D.play("death")
			$death_ani_cooldown.start()


func _on_gain_dmg_cooldown_timeout():
	can_take_dmg = true


func _on_death_ani_cooldown_timeout():
	self.queue_free()
