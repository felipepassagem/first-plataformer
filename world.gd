extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	var plataform_positions = [ [Vector2(300, 380), .5],  [Vector2(550, 220), .85], [Vector2(650, 300), 1], [Vector2(310, 160), .6]]
	
	for x in range(len(plataform_positions)):
		var plat = preload("res://Plataforma.tscn").instantiate()
		print("x: ", plataform_positions[x][0])
		plat.position = plataform_positions[x][0]
		plat.scale.x = plataform_positions[x][1]
		add_child(plat)
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass
