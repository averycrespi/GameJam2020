extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _input(event):
	if event is InputEventKey:
		var just_pressed = event.pressed and not event.echo
		
		if event.scancode == KEY_SPACE and just_pressed:
			for i in range(1,7):
				globalSingleton.character_status[i]=0
			globalSingleton.character_status[0]=2
			get_tree().change_scene("res://OregonTrail/Scenes/0.tscn")
			

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
