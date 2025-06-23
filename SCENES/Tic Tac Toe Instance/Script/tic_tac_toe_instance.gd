class_name Tic_Tac_Toe_Game_Board extends Control


@export var game_board : Array = [
	"___",
	"___",
	"___"
]
@export var coords := [0, 0]
@export var result : String = "_"
@export var master_board : Super_Tic_Tac_Toe_Game_Board = null

func _ready():
	pass


func enable_play():
	$Open_Game_Button.disabled = false


func play_with_delay_animation(name: String, delay: float = 0.0):
	await GlobalModule.wait(delay)
	$Animator.play(name)


func hide_game():
	$Game_Block.pivot_offset = Vector2(1, 1) * 75
	$Animator.play("Fade_away")


func show_game():
	$Game_Block.pivot_offset = Vector2(coords[0], coords[1]) * 75
	$Animator.play_backwards("Fade_away")


func close_game(def : bool = false):
	$Animator.play_backwards("Open_Game")
	if def: $Open_Game_Button.disabled = true
	master_board.current_opened_game = null


func open_game():
	$Animator.play("Open_Game")
	
	for sub_slot in $Game_Block/GridContainer.get_children(): 
		if sub_slot.text in ["O", "X"]: sub_slot.disabled = true
		else: sub_slot.disabled = false
	
	master_board.current_opened_game = self
	master_board.hide_games([self])


func _on_open_game_button_pressed(): open_game()


func _on_animator_animation_finished(anim_name):
	if anim_name == "Spawn": $Game_Block.pivot_offset = Vector2(coords[0], coords[1]) * 75


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


func update_display_based_on_conditions():
	$Game_Block/Dark_Wall.visible = true
	$Open_Game_Button.text = result
	$Open_Game_Button.disabled = true
	
	master_board.game_board[coords[1]][coords[0]] = result


func _on_play_slot_pressed(slot_pressed_id):
	var slot_id_node : Button = $Game_Block/GridContainer.get_children()[slot_pressed_id - 1]
	slot_id_node.disabled = true
	
	for sub_slot in $Game_Block/GridContainer.get_children(): sub_slot.disabled = true
	
	var line = int((slot_pressed_id - 1)/3)
	var col = int((slot_pressed_id - 1)%3)
	
	if master_board.turn_to == "X": slot_id_node.self_modulate = Color("#249185")
	slot_id_node.text = master_board.turn_to
	
	game_board[line][col] = master_board.turn_to
	
	if master_board.turn_to == "X": master_board.turn_to = "O"
	elif master_board.turn_to == "O": master_board.turn_to = "X"
	
	if check_win_condition(): update_display_based_on_conditions()
	
	await GlobalModule.wait(0.2)
	master_board.cancel_board_selection()
	master_board.selection_type = 0
	if master_board.is_board_available(slot_pressed_id - 1): master_board.set_mask_AAB(true)
	
	await GlobalModule.wait(0.8)
	if master_board.is_board_available(slot_pressed_id - 1): 
		master_board.selection_type = 1
		master_board.manual_open_game(slot_pressed_id - 1)
		await GlobalModule.wait(0.5)
		master_board.set_mask_AAB(false)
