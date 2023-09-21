extends Label

var score = 0

func _on_mob_squashed():
	score += 1
	# score variable replaces placeholder '%s'
	text = "Score: %s" % score
