extends ColorRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected_option
var changed = 0
var deadChar
var injuredChar
var popoutText
var chosen = 0
var someoneInjured = 0
onready var popupPan = get_parent().get_parent().get_child(3)#getting popup panel

func change_scene(): #called when scene is changed (unfinished)
	if injuredChar!=null && globalSingleton.character_status[2]>0 && globalSingleton.witch_potion>0: #if there is an injured character this scene, witch is alive and has potion
		#should jump to injured scene - need to change path
		get_tree().change_scene("res://LegendOfZelda/Scenes/Overworld.tscn")
	elif globalSingleton.character_status[0]==0: #if player is dead
		pass #should jump to death scene
	else: #need to change path
		get_tree().change_scene("res://LegendOfZelda/Scenes/Overworld.tscn")

func setPopout(text):#called when popup before next scene
	popupPan.popup_centered(Vector2(300,160))
	popupPan.set_position(Vector2(10,10))
	popupPan.get_child(0).add_text(text)

func choice0(): #fight
	if globalSingleton.character_status[1]==2: #if hunter is healthy
		change_status(1,1) #hunter injured
		globalSingleton.beast_status = (0)
		setPopout("The brave HUNTER fights the TERRIBLE BEAST! They are gravely injured, but they have slain the creature. You continue on your way.")
	else:
		for i in range(1,7):
			if globalSingleton.character_status[i]==2: #find first unlocked character
				change_status(i,0) #dead character
				changed = 1
				deadChar = i
				break
		if changed==0:
			change_status(0,0)#player dead
			deadChar = 0
		popoutText = "The brave " + globalSingleton.character_name[deadChar] + " fights the TERRIBLE BEAST! They manage to best the monster, but tragically perish in the process."
		setPopout(popoutText)

func choice1(): #run
	for i in range(1,7):
			if globalSingleton.character_status[i]==2: #find first unlocked character
				change_status(i,1) #injured character
				changed = 1
				injuredChar = i
				break
	if changed==0:
			change_status(0,1)#player injured
			injuredChar = 0
	popoutText = "You flee from the TERRIBLE BEAST, crashing wildly through the foliage! In the chaos, " + globalSingleton.character_name[injuredChar] + " badly injures their leg."
	setPopout(popoutText)


func choice2(): #intimidate
	if globalSingleton.character_status[1]==2: #if hunter is healthy
		change_status(1,1) #hunter injured
		setPopout("The brave HUNTER stands up tall and intimidates the TERRIBLE BEAST! The creature, taken aback by this show of aggression, retreats into the woods.")
	else:
		for i in range(1,7):
			if globalSingleton.character_status[i]==2: #find first unlocked character
				change_status(i,0) #dead character
				changed = 1
				deadChar = i
				break
		if changed==0:
			change_status(0,0)#player dead
			deadChar = 0
		popoutText = "The foolhardy " + globalSingleton.character_name[deadChar] + " attempts to intimidate the TERRIBLE BEAST! Unfortunately, the monster does not fall for their blustering, and strikes them down where they stand."
		setPopout(popoutText)
		

func change_selected_color():
	$Pointer0.color = Color("3C2828")
	$Pointer1.color = Color("3C2828")
	$Pointer2.color = Color("3C2828")
	
	match selected_option:
		0:
			$Pointer0.color = Color.yellow
		1:
			$Pointer1.color = Color.yellow
		2:
			$Pointer2.color = Color.yellow

func _input(event):
	if event is InputEventKey:
		var just_pressed = event.pressed and not event.echo
		
		if event.scancode == KEY_RIGHT and just_pressed:
			selected_option = (selected_option + 1) % 3;
			change_selected_color()
		elif event.scancode == KEY_LEFT and just_pressed:
			if selected_option > 0:
				selected_option = selected_option - 1
			else:
				selected_option = 2
			change_selected_color()
		elif event.scancode == KEY_SPACE and just_pressed:
			match selected_option:
				0:
					if chosen == 0:
						choice0()
						chosen = 1
					elif chosen == 1:
						change_scene()
				1:
					if chosen == 0:
						choice1()
						chosen = 1
					elif chosen == 1:
						change_scene()
				2:
					if chosen == 0:
						choice2()
						chosen = 1
					elif chosen == 1:
						change_scene()

func change_status(characterNum, status):
	globalSingleton.character_status[characterNum] = status

# Called when the node enters the scene tree for the first time.
func _ready():
	#reset menu choice
	selected_option = 0
	change_selected_color()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass