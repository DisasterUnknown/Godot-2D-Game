extends CharacterBody2D

@onready var slimeAudioWalk = $AudioStreamSlime_jump
@onready var displayOrigin = $RewordDisplay
@onready var worldNode = get_node("/root/world")
@onready var spawnPosition = position

var SpawnTop_right
var SpawnBottom_left

var speed = 85 
var spawnCountDown = Status.slimeSpawnTIME
var player_chase = false
var goback = false
var player = null

var dmgTaken
var health = Status.slimeHP
var player_inAtk_range = false
var can_take_dmg = true
var dying = false
var knockback = false

@onready var slimeItem = $slimeCollectable

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


func _ready():
	SpawnTop_right = Vector2(spawnPosition.x + 20, spawnPosition.y + 20)
	SpawnBottom_left = Vector2(spawnPosition.x - 20, spawnPosition.y - 20)


# Runs every physics frame
func _physics_process(delta):
	dmgTaken = Status.playerATK
	
	UpdateHealthBar()
	deal_with_dmg()
	
	if (self.position.x >= SpawnBottom_left.x) and (self.position.x <= SpawnTop_right.x) and (self.position.y >= SpawnBottom_left.y) and (self.position.y <= SpawnTop_right.y):
		goback = false
	
	if goback:
		position += (spawnPosition - position).normalized() * speed/2 * delta
		move_and_collide(Vector2(0,0))
		
		$AnimatedSprite2D.play("walk")
		audio_play(1, "walk")
	elif knockback and !dying:
		var knockValue = (position - player.position).normalized() * (speed * 3)
		var knockback_move = move_and_collide(knockValue * delta)
		await get_tree().create_timer(0.2).timeout
		knockback = false
	elif player_chase and !dying:
		position += (player.position - position).normalized() * speed * delta
		move_and_collide(Vector2(0,0))

		$AnimatedSprite2D.play("walk")
		audio_play(1, "walk")
	elif !dying:
		$AnimatedSprite2D.play("idle")
		audio_play(0, "walk")


# Creates an enemy method
func enemy():
	pass


# When a player enters the detection area
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	goback = false


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
		health = health - dmgTaken
		can_take_dmg = false
		$gainDmg_cooldown.start()
		dmgAnimation()
		print("Slime Health: ", health)
		if health <= 0:
			dying = true
			Status.displayReword(displayOrigin.global_position)
			Status.debugFunc()
			
			$AnimatedSprite2D.play("death")
			dmgAnimation()
			audio_play(1, "death")
			await get_tree().create_timer(0.6).timeout         # Waits for a few seconds
			dropItem()


# Droping an silme item when the slime is dead
func dropItem():
	$AnimatedSprite2D.visible = false
	$enemy_hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true
	$AudioStreamSlime_jump.stop()
	$HealthBar.visible = false
	
	slimeItem.visible = true
	collectSlimeDrop()
	worldNode.respawn_enemy(spawnPosition, spawnCountDown)


# Slime dead drops
func collectSlimeDrop():
	await get_tree().create_timer(1.5).timeout
	slimeItem.visible = false
	self.queue_free()


# Get dmg color animation
func dmgAnimation():
	knockback = true
	#await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.modulate = Color.WHITE


# Dmg gaining cooldown timer
func _on_gain_dmg_cooldown_timeout():
	can_take_dmg = true


# Updating the health bar according to health
func UpdateHealthBar():
	var healthbar = $HealthBar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else :
		healthbar.visible = true


# Health regen timer
func _on_health_regen_timeout():
	if !player_chase:
		goback = !goback
	if health < 100 and !player_chase:
		health += 100
		if health > 100:
			health = 100
	
	if health <= 0:
		health = 0
