extends Button


func _on_toggled(toggled_on):
	get_parent().Button_Animator.play("Play_Button_Press")
