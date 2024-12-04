extends Node

var mPlayerHP = 200
var mPlayerATK = 50
var mPlayerDEF = 25
var mPlayerSPEED = 175
var mPlayerLUCK = 50

var playerHP = 100
var playerATK = 25
var playerDEF = 0
var playerSPEED = 150
var playerLUCK = 10
var playerREGEN = 10

var base_probs = {"HP": 40, "ATK": 30, "DEF": 13, "SPEED": 10, "LUCK": 7}
var value_ranges = {"HP": [0.5, 2.0], "ATK": [0.5, 2.0], "DEF": [0.5, 2.0], "SPEED": [0.5, 2.0], "LUCK": [0.5, 1.0]}


var slimeHP
var slimeATK = 20
var slimeDEF
var slimeSPEED
var slimeSpawnTIME = 60.0


# Get the reword
func rewordDepth():
	var probability = base_probs.duplicate()
	for key in probability.keys():
		var multiplyer = 1.0 + (playerLUCK/100)
		probability[key] *= multiplyer
	return probability

func statValue(key):
	var range = value_ranges[key]
	var bias = floor(randf_range(10.0 / 50.0, playerLUCK / 50.0)*100) / 100.0
	return range[0] + (range[1] - range[0]) * bias

func getStatusReword():
	var probabilities = rewordDepth()
	var total = 0
	for value in probabilities.values():
		total += value
		
	var random_pick = randi() % int(total)
	var cumulative = 0
	
	for key in probabilities.keys():
		cumulative += probabilities[key]
		if random_pick < cumulative:
			return { "stat": key, "value": statValue(key) }


# Add the reword to the stats
func updateStats(stats, value):
	#HP,ATK,SPEED,DFE,LUCK
	if stats == "HP":
		if playerHP < mPlayerHP:
			playerHP += value
		else:
			playerHP = mPlayerHP
		
	elif stats == "ATK":
		if playerATK < mPlayerATK:
			playerATK += value
		else:
			playerATK = mPlayerATK
		
	elif stats == "DEF":
		if playerDEF < mPlayerDEF:
			playerDEF += value
		else:
			playerDEF = mPlayerDEF
		
	elif stats == "SPEED":
		if playerSPEED < mPlayerSPEED:
			playerSPEED += value
		else:
			playerSPEED = mPlayerSPEED
		
	elif stats == "LUCK":
		if playerLUCK < mPlayerLUCK:
			playerLUCK += value
		else:
			playerLUCK = mPlayerLUCK


# Display the stats reword
func displayReword(position: Vector2):
	var stat = getStatusReword()
	var value = stat.values()[0] + " + " + str(stat.values()[1])
	updateStats(stat.values()[0], stat.values()[1])
	
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



func debugFunc():
	print("\n\nHP: " + str(playerHP))
	print("ATK: " + str(playerATK))
	print("DEF: " + str(playerDEF))
	print("SPEED: " + str(playerSPEED))
	print("LUCK: " + str(playerLUCK))
	
	
	
	
