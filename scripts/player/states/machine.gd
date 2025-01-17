extends StateMachine

func _ready():
	states_map = {
		"idle": $Idle,
		"walk": $Walk,
		"air": $Air,
		"hold": $Hold,
		"hurt": $Hurt,
		"locked": $Locked,
		"dash": $Dash
	}
	
func _change_state(state_name, msg := {} ):
	if not _active:
		return
	if state_name in ["hold", "hurt", "locked", "dash"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name, msg)
