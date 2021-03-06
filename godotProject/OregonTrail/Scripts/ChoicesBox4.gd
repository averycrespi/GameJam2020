extends ColorRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected_option
var someoneInjured = 0
var popoutText
var chosen = 0
onready var popupPan = get_parent().get_parent().get_child(3)#getting popup panel



func change_scene(): #Unfinished
	if someoneInjured==1 && globalSingleton.character_status[2]>0 && globalSingleton.witch_potion>0: #if there is an injured character this scene, witch is alive and has potion
		#should jump to injured scene - need to change path
		globalSingleton.next_scene = 2
		get_tree().change_scene("res://OregonTrail/Scenes/injury.tscn")
	elif globalSingleton.character_status[0]==0: #if player is dead
		get_tree().change_scene("res://OregonTrail/Scenes/8.tscn")
	else: #Next Scene
		get_tree().change_scene("res://OregonTrail/Scenes/6.tscn")

func setPopout(text):#called when popup before next scene
	popupPan.popup_centered(Vector2(300,160))
	popupPan.set_position(Vector2(10,10))
	popupPan.get_child(0).add_text(text)

func choice0(): #Sneak
	if globalSingleton.character_status[4]>0: #if tinker is in party
		setPopout("Before you sneak through the DARK CAVE, the clever BARD plays a lullaby upon their lute. The TERRIBLE BEAST is lulled to sleep, allowing safe passage for all.")
	else:
		for i in range(6,-1,-1): #kill first healthy character
			print (i, globalSingleton.character_status[i])
			if globalSingleton.character_status[i]>0: #find first unlocked character
				change_status(i,0) #dead character
				popoutText = "You begin to sneak quietly through the DARK CAVE. However, the keen senses of the TERRIBLE BEAST detect " + globalSingleton.character_name[i] + ", and the monster pounces, killing them."
				break
		setPopout(popoutText)

func choice1(): #fight
	if globalSingleton.character_status[1]>1: #if tinker is in good health
		setPopout("The brave HUNTER fights the TERRIBLE BEAST! They are gravely injured, but they have slain the creature. You continue on your way.")
		globalSingleton.beast_status = 0
	else:
		for i in range(6,-1,-1): #kill first healthy character
			print (i, globalSingleton.character_status[i])
			if globalSingleton.character_status[i]>0: #find first unlocked character
				change_status(i,0) #dead character
				popoutText = "The brave " + globalSingleton.character_name[i] + " fights the TERRIBLE BEAST! They manage to best the monster, but tragically perish in the process."
				break
	setPopout(popoutText)


func choice2(): #intimidate it
	if globalSingleton.character_status[1]>0: #if hunter is alive
		setPopout("The brave HUNTER stands up tall and intimidates the TERRIBLE BEAST! The creature, taken aback by this show of aggression, retreats into the darkness.")
	else:
		for i in range(6,-1,-1): #kill first healthy character
			print (i, globalSingleton.character_status[i])
			if globalSingleton.character_status[i]>0: #find first unlocked character
				change_status(i,0) #dead character
				popoutText = "The foolhardy " + globalSingleton.character_name[i] + " attempts to intimidate the TERRIBLE BEAST! Unfortunately, the monster does not fall for their blustering, and strikes them down where they stand."
				break
	setPopout(popoutText)
	
func choice3(): #Flee through the cave
	popoutText = "You flee from the TERRIBLE BEAST, running wildly through the DARK CAVE! In the darkness, Player badly injures themselves."
	for i in range(6,-1,-1): #injure first health character from bottom up
		if globalSingleton.character_status[i]==2: #find first unlocked character
			change_status(i,1) #injured character
			popoutText = "You flee from the TERRIBLE BEAST, running wildly through the DARK CAVE! In the darkness, " + globalSingleton.character_name[i] + " badly injures themselves."
			globalSingleton.run_beast = 1
			break
	setPopout(popoutText)
		

func change_selected_color():
	$Pointer0.color = Color("3C2828")
	$Pointer1.color = Color("3C2828")
	$Pointer2.color = Color("3C2828")
	$Pointer3.color = Color("3C2828")
	
	match selected_option:
		0:
			$Pointer0.color = Color.yellow
		1:
			$Pointer1.color = Color.yellow
		2:
			$Pointer2.color = Color.yellow
		3:
			$Pointer3.color = Color.yellow

func _input(event):
	if event is InputEventKey:
		var just_pressed = event.pressed and not event.echo
		
		if event.scancode == KEY_RIGHT and just_pressed:
			selected_option = (selected_option + 1) % 4;
			change_selected_color()
		elif event.scancode == KEY_LEFT and just_pressed:
			if selected_option > 0:
				selected_option = selected_option - 1
			else:
				selected_option = 3
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
				3:
					if chosen == 0:
						choice3()
						chosen = 1
					elif chosen == 1:
						change_scene()

func change_status(characterNum, status):
	globalSingleton.character_status[characterNum] = status
	if status == 1:
		globalSingleton.injured_char = characterNum
		someoneInjured = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#reset menu choice
	selected_option = 0
	change_selected_color()


