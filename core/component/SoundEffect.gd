extends Component
class_name SoundEffect

func play_se(se_config:SoundEffectConfig,obj):
		EventBus._play_SE(se_config.se_name,se_config.se_speed,se_config.se_pitch,str(owner.get_instance_id()+obj.get_instance_id()))

