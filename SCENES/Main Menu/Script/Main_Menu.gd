extends Node2D


@onready var Button_Animator : AnimationPlayer = $Button_Animator

var texts = [
	"I had no idea what i was doing ngl...",
	"It is litterally 2 am, don't judge this game.",
	"I spent more time on the design than the code... help.",
	"The dev of this is mentally fine... now physically-",
	"I'll make some updates, obiously, morron.",
	"I know, i know, i am so smart.",
	"Find a title yourself btw, too lazy.",
	"If you find a bug, notify me on github so i can defenestrate myself.",
	"Cool UI right ? I know, i know, absolute masterpiece compared to triple A games.",
	"Click the button \"play\" to play",
	"I wonder how many updates i'll put into this (updates = all nighter)",
	"Say thank you and play.",
	"Yes, i wrote alot of text for just this section of the game",
	"I'll prolly add bots next time, so when i debug code i'll feel like i have friends !",
	"Tic Tac Toe for people who are SUFFERING from boredom !",
	"Recommended to drink water before playing, this will be very long (if you are smart).",
	"The game is acctualy more confusing than the concepts suggests it to be.",
	"BEHOLD, THE POWER OF AN ANGE- No... I mean, A GAME DEV.",
	"Done in 15 minutes, Designed in 15 hours, Design still sucks.",
	"Imagine playing a boring ahh game with bad graphics all that to fight boredom.",
	"I know i am good at game dev, but still, stop lazying arround and go to work",
	"Rebecca... no nothing, i just wanted to say your name",
	"Why am i writting alone ?",
	"This game is meant for people who are born the 5th of April... Not mentioning anoyone in particular",
	"2 hours of torture, and by torture i mean managing to find a good color chart.",
	"No, you are not smart, you just got lucky",
	"Professional game done by a professional... professionally ?",
	"It is 2 am, help.",
	"Imagine having no frien- wait...",
	"Better than any game you've ever played... It's not like your tastes are that amazing either..."
	
]

func _on_button_animator_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://SCENES/Main_Game_Scene/Main_Game_Scene.tscn")


func swap_text():
	$Sub_title.text = texts[randi_range(0, len(texts) - 1)]
	


func _ready():
	$Text_animator.play("Change_text")


func _on_text_animator_animation_finished(anim_name):
	await GlobalModule.wait(((2* len($Sub_title.text))/45) + 2)
	$Text_animator.play("Change_text")
