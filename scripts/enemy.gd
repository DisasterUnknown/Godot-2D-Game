extends CharacterBody2D

@onready var slimeAudioWalk = $AudioStreamSlime_jump

var speed = 85 
var player_chase = false
var player = null

var health = 60
var player_inAtk_range = false
var can_take_dmg = true
var dying = false
var knockback = false


# Runs all the audio related to the slime ccording to the parramenters
func audio_play(movement, track):
	if track == "walk":
		if movement == 1:
			if (!slimeAudioWalk.playing):
				slimeAudioWalk.play()
		else:
			slimeAudioWalk.stop()
	if track == "death":
		$AudioStreamSlime_death.play()


# Runs every physics frame
func _physics_process(delta):
	deal_with_dmg()
	
	if !dying:
		if knockback:
			var knockValue = (position - player.position).normalized() * (speed * 3)
			var knockback_move = move_and_collide(knockValue * delta)
			await get_tree().create_timer(0.2).timeout
			knockback = false
		elif player_chase:
			position += (player.position - position).normalized() * speed * delta
			move_and_collide(Vector2(0,0))

			$AnimatedSprite2D.play("walk")
			audio_play(1, "walk")
		else:
			$AnimatedSprite2D.play("idle")
			audio_play(0, "walk")


# Creates an enemy method
func enemy():
	pass


# When a player enters the detection area
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


# When a player leaves the detection area
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false


# When the player is in the atk range
func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inAtk_range = true


# When the player exits the atk range
func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inAtk_range = false		


# If the player is attacking
func deal_with_dmg():
	if player_inAtk_range and Global.player_current_atk and can_take_dmg:
		health = health - 20
		can_take_dmg = false
		$gainDmg_cooldown.start()
		dmgAnimation()
		print("Slime Health: ", health)
		if health <= 0:
			dying = true
			$AnimatedSprite2D.play("death")
			audio_play(1, "death")
			await get_tree().create_timer(0.6).timeout         # Waits for a few seconds
			self.queue_free()


# Get dmg color animation
func dmgAnimation():
	if health > 0:
		await get_tree().create_timer(0.2).timeout
		$AnimatedSprite2D.modulate = Color.RED
		knockback = true
		await get_tree().create_timer(0.2).timeout
		$AnimatedSprite2D.modulate = Color.WHITE


# Dmg gaining cooldown timer
func _on_gain_dmg_cooldown_timeout():
	can_take_dmg = true
