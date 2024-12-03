extends CharacterBody2D

@onready var playerAudioWalk = $AudioStreamPlayer_walking

var slime

var enemy_inAtk_range = false
var atk_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false

const speed = 150
var attacking = false
var current_dir = "none"

# Runs when the code is ready to be sxercuted
func _ready():
	$AnimatedSprite2D.play("idle_front")

# This function runs evey frome itteration (ones evey game cycle)
func _physics_process(delta):
	UpdateHealthBar()
	enemy_atk()
	attack()
	
	if !attacking:
		player_movement(delta)
	
	if health <= 0:
		player_alive = false
		health = 0
		print("Player dead!!")
		self.queue_free()
	
	
# Player movement related code
func player_movement(delta):
	if Input.is_action_pressed("Right_Move"):
		current_dir = "right"
		play_anim(1)
		audio_play(1, "walk")
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("Left_Move"):
		current_dir = "left"
		play_anim(1)
		audio_play(1, "walk")
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("Up_Move"):
		current_dir = "up"
		play_anim(1)
		audio_play(1, "walk")
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("Down_Move"):
		current_dir = "down"
		play_anim(1)
		audio_play(1, "walk")
		velocity.x = 0
		velocity.y = speed
	else:
		play_anim(0)
		audio_play(0, "walk")
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide() 
	

# Runs all the audio related to the player ccording to the parramenters
func audio_play(movement, track):
	if track == "walk":
		if movement == 1:
			if (!playerAudioWalk.playing):
				playerAudioWalk.play()
		else:
			playerAudioWalk.stop()
	elif track == "atk":
		$AudioStreamPlayer_attack.play()


# Runs player animation related for walking
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if !attack_ip:
				anim.play("idle_side")
	elif dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if !attack_ip:
				anim.play("idle_side")
	elif dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if !attack_ip:
				anim.play("idle_back")
	elif dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if !attack_ip:
				anim.play("idle_front")
	
	
# Creates a player method
func player():
	pass


# what todo when the enemy enters the player body
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		slime = body.get_node_or_null("AnimatedSprite2D")
		enemy_inAtk_range = true


# what todo when the enemy exits the player body
func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inAtk_range = false


# When enemy is in attack range
func enemy_atk():
	if enemy_inAtk_range and atk_cooldown and slime.visible:
		health = health - 10
		dmgAnimation()
		atk_cooldown = false
		$gainDmg_cooldown.start()
		print("Player Health: ", health)


# Get dmg color animation
func dmgAnimation():
	for i in range(2):
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D.modulate = Color.WHITE


# Attack cooldown timer
func _on_atk_cooldown_timeout():
	atk_cooldown = true


# Player attack run animation and audio
func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		playerAudioWalk.stop()
		attacking = true
		Global.player_current_atk = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$dealAtk_timer.start()
			audio_play(0, "atk")
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$dealAtk_timer.start()
			audio_play(0, "atk")
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$dealAtk_timer.start()
			audio_play(0, "atk")
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$dealAtk_timer.start()
			audio_play(0, "atk")


# When the attack timer goes off
func _on_deal_atk_timer_timeout():
	$dealAtk_timer.stop()
	attacking = false
	Global.player_current_atk = false
	attack_ip = false


func UpdateHealthBar():
	var healthbar = $HealthBar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else :
		healthbar.visible = true


func _on_regin_time_timeout():
	if health < 100 and !attacking:
		health += 20
		if health > 100:
			health = 100
	
	if health <= 0:
		health = 0
