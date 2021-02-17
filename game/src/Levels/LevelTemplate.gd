extends Node2D

onready var trump_animation = $trump_animation
onready var dialogue_pop = $popups/dialogue_popup


func _ready():
	self.step_1_trump_hello()

func step_1_trump_hello():
	trump_animation.play("trump_salut")
	dialogue_pop.name = 'Your Boss'
	dialogue_pop.dialogue = 'Hi, I am your [b][shake][color=red]Boss[/color][/shake][/b]. Do it!'
	dialogue_pop.open()
	
