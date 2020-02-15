extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var player_vars = get_node("/root/root")
	connect("status_character", get_parent().get_parent().get_child(2).get_child(0), "color_status")

func color_status(charNum, status):
	if status == 0:
		get_child(charNum).get_child(1).color = Color.gray
	elif status == 1:
		get_child(charNum).get_child(1).color = Color.red
	elif status ==2:
		get_child(charNum).get_child(1).color = Color(0,0,0,0)
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass