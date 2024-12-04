extends Node2D

@onready var EnemyScene = preload("res://screans/enemy.tscn")

# Respown the enemy
func respawn_enemy(spawnPosition, delay):
	await get_tree().create_timer(delay).timeout
	var ene = EnemyScene.instantiate()
	ene.position = spawnPosition
	add_child(ene)
	
	# Make the enemy initially invisible
	ene.modulate.a = 0  # transparency = 0 
	
	# Tween to smoothly make it visible
	var tween = create_tween()
	tween.tween_property(ene, "modulate:a", 1, 1.0)
