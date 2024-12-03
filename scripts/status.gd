extends Node

var playerHP 
var playerATK
var playerDEF
var playerSPEED
var playerLUCK

var slimeHP
var slimeATK
var slimeDEF
var slimeSPEED


func displayReword(position: Vector2):
	var value = "HP + 5"
	
	var num = Label.new()
	num.global_position = position
	num.text = str(value)
	num.z_index = 5
	num.label_settings = LabelSettings.new()
	
	var color = "#FFF"
	num.label_settings.font_color = color
	num.label_settings.font_size = 8
	num.label_settings.outline_color = "#000"
	num.label_settings.outline_size = 1
	
	# Gocha add alignment
	
	call_deferred("add_child", num)
	
	await num.resized
	num.pivot_offset = Vector2(num.size/2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		num, "position:y", num.position.y - 30, 1.5
	).set_trans(Tween.TransitionType.TRANS_SINE).set_ease(Tween.EaseType.EASE_OUT)
	
	await tween.finished
	num.queue_free()
