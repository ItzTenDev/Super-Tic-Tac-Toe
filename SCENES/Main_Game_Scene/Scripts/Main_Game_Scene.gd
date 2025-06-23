class_name Super_Tic_Tac_Toe_Game_Board extends Node2D


var turn_to : String = "X"
var selection_type : int = 0 # 1 = By Force, 0 = By Choice
@export var result : String = "_"
@export var game_board : Array = [
	"___",
	"___",
	"___"
]
var current_opened_game : Tic_Tac_Toe_Game_Board = null

var game_slot_node = preload("res://SCENES/Tic Tac Toe Instance/tic_tac_toe_instance.tscn")

func _ready():
	
	$Main_Game_Animator.play("Ready_Animation")


func true_ready():
	for i in range(9):
		var game_slot_instance = game_slot_node.instantiate()
		
		game_slot_instance.name = "Board_no_" + str(i)
		game_slot_instance.coords = [((i) % 3) ,int(i/3)]
		game_slot_instance.master_board = self
		game_slot_instance.game_board = [
			"___",
			"___",
			"___"
			]
		
		
		$Main_Board/Board_Grid_Control.add_child(game_slot_instance)
		
		var a_s = 0.2
		game_slot_instance.play_with_delay_animation("Spawn", (a_s * int(i/3)) + (a_s * ((i)%3)))
	
	for game_slot_child : Tic_Tac_Toe_Game_Board in $Main_Board/Board_Grid_Control.get_children():
		game_slot_child.enable_play()
		

func check_win_condition():
	# Check columns victories
	for col in range(3):
		var conc_total = ""
		for line in range(3):
			conc_total += game_board[line][col]
		
		if conc_total in ["OOO", "XXX"]: 
			result = "X" if conc_total == "XXX" else "O"
			return true
	
	# Check lines victories
	for line in range(3):
		if game_board[line] in ["OOO", "XXX"]: 
			result = "X" if game_board[line] == "XXX" else "O"
			return true
			
	# Check diagonals victories
	var d_slash = game_board[2][0] + game_board[1][1] + game_board[0][2]
	var d_bwslash = game_board[2][2] + game_board[1][1] + game_board[0][0]
	
	if (d_slash in ["OOO", "XXX"]) or (d_bwslash in ["OOO", "XXX"]):
		result = "X" if (d_slash == "XXX" or d_bwslash == "XXX") else "O"
		return true
	
	
	# Check for tie
	if "_" not in (game_board[1] + game_board[2] + game_board[0]): 
		result = "-"
		return true
	
	
	return false


func _physics_process(delta):
	print(game_board)
	if current_opened_game != null and Input.is_action_just_pressed("ui_cancel"):
		cancel_board_selection()
	
	$Label.text = "Turn to: " + turn_to


func manual_open_game(number: int):
	var board_target : Tic_Tac_Toe_Game_Board = $Main_Board/Board_Grid_Control.get_node("Board_no_" + str(number))
	
	if board_target: board_target.open_game()
	

func is_board_available(number: int):
	var board_target : Tic_Tac_Toe_Game_Board = $Main_Board/Board_Grid_Control.get_node("Board_no_" + str(number))
	
	return board_target.result == "_"


func hide_games(exceptions : Array):
	for game_slot_child : Tic_Tac_Toe_Game_Board in $Main_Board/Board_Grid_Control.get_children():
		if game_slot_child not in exceptions: game_slot_child.hide_game()
		
		
func show_games(exceptions : Array):
	for game_slot_child : Tic_Tac_Toe_Game_Board in $Main_Board/Board_Grid_Control.get_children():
		if game_slot_child not in exceptions: game_slot_child.show_game()


func _on_main_game_animator_animation_finished(anim_name):
	if anim_name == "Ready_Animation": true_ready()


func cancel_board_selection():
	if current_opened_game == null: return
	
	show_games([current_opened_game])
	current_opened_game.close_game()
	
	if check_win_condition():
		$Anti_Action_button.visible = true
		$Winning_title/Winning_label.text = "Tie" if result == "-" else "Victory of " + result
		await GlobalModule.wait(0.5)
		$Main_Game_Animator.play("Game result")
		await GlobalModule.wait(2.5)
		get_tree().change_scene_to_file("res://SCENES/Main Menu/main_menu.tscn")


func set_mask_AAB(visibility: bool = true):
	$Anti_Action_button.visible = visibility
	


func _on_back_button_pressed(): 
	if selection_type == 0: cancel_board_selection()
