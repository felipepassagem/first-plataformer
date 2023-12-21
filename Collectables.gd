extends Node2D


var Cherry = preload("res://Collectables/Cherry.tscn")


func _on_timer_timeout():
	
	var cherryTemp = Cherry.instantiate()
	var rng = RandomNumberGenerator.new()
	var randInt = rng.randi_range(10, 400)
	#cherryTemp.position = Vector2(randInt,296)
	#add_child(cherryTemp)
