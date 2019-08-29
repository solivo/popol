extends AudioStreamPlayer
####################################################################
#SOUND EFFECT SCRIPT FOR THE SOUND MANAGER MODULE FOR GODOT 3.1
#			© Xecestel
####################################################################
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
#####################################

#signals#
signal finished_playing(sound_name);
#########

#variables#
onready var SoundManager = self.get_tree().get_root().get_node("/root/SoundManager");
var sound_name;
###########

func _ready():
	self.connect("finished", self, "_on_self_finished");
	self.connect("finished_playing", SoundManager, "_on_SE_finished" );
	self.set_volume_db(0.0);
	self.set_pitch_scale(1.0);
#end

func set_sound_name(sound_name : String) -> void:
	self.sound_name = sound_name;
#end	

func _on_self_finished() -> void:
	emit_signal("finished_playing", self.sound_name);
#end
