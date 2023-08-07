extends CanvasLayer

    
func appear():
    get_tree().call_group("buttons", "set_disabled" , false)
    _tween().tween_property(self, "offset:x", 0.0 , 0.5).from(500.0)
    

func disappear():
    get_tree().call_group("buttons", "set_disabled" , true)
    _tween().tween_property(self, "offset:x", 500.0 , 0.5).from(0.0)
    

func _tween():
    return create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
