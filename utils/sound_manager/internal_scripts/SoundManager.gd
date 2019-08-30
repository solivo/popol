extends SoundManager

####################################################################
#	SOUND MANAGER MODULE FOR GODOT 3.1
#			Version 1.6
#			© Xecestel
####################################################################
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
#####################################
#variables#
export (String, DIR) var BGM_DIR_PATH = "res://Assets/Audio/BGM";
export (String, DIR) var SFX_DIR_PATH = "res://Assets/Audio/Sound Effects";
export (String, DIR) var MFX_DIR_PATH = "res://Assets/Audio/Music Effects";
export (String, DIR) var BGS_DIR_PATH = "res://Assets/Audio/BGS";
onready var BGM_Audiostream = get_node("BGM");
onready var BGS_Audiostream = get_node("BGS");
onready var SE_Audiostreams = $SoundEffects.get_children();
onready var ME_Audiostream = get_node("ME");
onready var soundmgr_dir_rel_path = self.get_script().get_path().get_base_dir();

var bgm_playing				: String;
var bgs_playing				: String;
var se_playing				: Array		= [ "SE0" ];
var me_playing				: String;
###########

#####################
#	BGM HANDLING	#
#####################

#Plays a given bgm
func play_bgm(bgm : String, reset_to_defaults : bool = true) -> void:
	if (bgm == "" || bgm == null):
		print_debug("No BGM selected.");
		return;
	if (self.is_bgm_playing(bgm)):
		return;
	
	var bgm_file_name = bgm if (bgm.get_extension() != "") else Audio_Files_Dictionary.get(bgm);
	if (bgm_file_name == null):
		print_debug("Error: file not found " + bgm);
		return;
		
	var bgm_file_path = BGM_DIR_PATH + "/" + bgm_file_name;
	
	var Stream = load(bgm_file_path);
	if (Stream == null):
		print_debug("Failed to load file from path: " + bgm_file_path);
		return;
	
	self.stop_bgm();
	self.pause_bgm(false);
	
	if (reset_to_defaults):
		self.set_bgm_pitch_scale(1.0);
		self.set_bgm_volume_db(0.0);
		
	BGM_Audiostream.set_stream(Stream);
	BGM_Audiostream.play();
	bgm_playing = bgm;
#end

func stop_bgm(bgm : String = "") -> void:
	if (bgm != ""):
		if (self.is_bgm_playing(bgm)):
			BGM_Audiostream.stop();
			return;
			
	BGM_Audiostream.stop();
#end

func is_bgm_playing(bgm : String = "") -> bool:
	if (bgm == null || bgm == ""):
		return BGM_Audiostream.is_playing();
	return (bgm_playing == bgm && BGM_Audiostream.is_playing());
#end

func set_bgm_volume_db(volume_db : float) -> void:
	BGM_Audiostream.set_volume_db(volume_db);
#end

func get_bgm_volume_db() -> float:
	return BGM_Audiostream.get_volume_db();
#end

func set_bgm_pitch_scale(pitch : float) -> void:
	BGM_Audiostream.set_pitch_scale(pitch);
#end

func get_bgm_pitch_scale() -> float:
	return BGM_Audiostream.get_pitch_scale();
#end

func pause_bgm(paused : bool) -> void:
	BGM_Audiostream.set_stream_paused(paused);
#end

func is_bgm_paused() -> bool:
	return BGM_Audiostream.get_paused();
#end


#####################
#	BGS HANDLING	#
#####################

#Plays a given bgm
func play_bgs(bgs : String, reset_to_defaults : bool = true) -> void:
	SE_Audiostreams = $SoundEffects.get_children();
	if (bgs == "" || bgs == null):
		print_debug("No BGS selected.");
		return;
	if (self.is_bgs_playing(bgs)):
		return;
			
	var bgs_file_name = bgs if (bgs.get_extension() != "") else Audio_Files_Dictionary.get(bgs);
	if (bgs_file_name == null):
		print_debug("Error: file not found " + bgs);
		return;
		
	var bgs_file_path = BGS_DIR_PATH + "/" + bgs_file_name;
	
	var Stream = load(bgs_file_path);
	if (Stream == null):
		print_debug("Failed to load file from path: " + bgs_file_path);
		return;
	
	self.stop_bgs();
	self.pause_bgs(false);
	
	if (reset_to_defaults):
		self.set_bgs_pitch_scale(1.0);
		self.set_bgs_volume_db(0.0);
		
	BGS_Audiostream.set_stream(Stream);
	BGS_Audiostream.play();
	bgs_playing = bgs;
#end

func stop_bgs(bgs : String = "") -> void:
	if (bgs != ""):
		if (self.is_bgs_playing(bgs)):
			BGS_Audiostream.stop();
			return;
			
	BGS_Audiostream.stop();
#end

func is_bgs_playing(bgs : String = "") -> bool:
	if (bgs == null || bgs == ""):
		return BGS_Audiostream.is_playing();
	return (bgs_playing == bgs && BGS_Audiostream.is_playing());
#end

func set_bgs_volume_db(volume_db : float) -> void:
	BGS_Audiostream.set_volume_db(volume_db);
#end

func get_bgs_volume_db() -> float:
	return BGS_Audiostream.get_volume_db();
#end
	
func set_bgs_pitch_scale(pitch : float) -> void:
	BGS_Audiostream.set_pitch_scale(pitch);
#end

func get_bgs_pitch_scale() -> float:
	return BGS_Audiostream.get_pitch_scale();
#end
	
func pause_bgs(paused : bool) -> void:
	BGS_Audiostream.set_stream_paused(paused);
#end

func is_bgs_paused() -> bool:
	return BGS_Audiostream.get_stream_paused();

#############################
#	SOUND EFFECTS HANDLING	#
#############################

#Plays selected Sound Effect
func play_se(sound_effect : String, reset_to_defaults : bool = true, override_current_sound : bool = true, sound_to_override : String = "") -> void:
	if (sound_effect == "" || sound_effect == null):
		print_debug("No sound effect selected.");
		return;
	if (override_current_sound):
		if (self.is_se_playing(sound_effect)):
			return;
		
	var sound_effect_file_name = sound_effect if (sound_effect.get_extension() != "") else Audio_Files_Dictionary.get(sound_effect);
	if (sound_effect_file_name == null):
		print_debug("Error: file not found " + sound_effect);
		return;
		
	var sound_effect_path = SFX_DIR_PATH + "/" + sound_effect_file_name;
	
	var Stream = load(sound_effect_path);
	if (Stream == null):
		print_debug("Failed to load file from path: " + sound_effect_path);
		return;
	
	var se_index = 0;
	
	if (override_current_sound):
		if (sound_to_override != "" && sound_to_override != null):
			se_index = se_playing.find(sound_to_override);
			
		if (se_index < 0):
			print_debug("Sound not found: " + sound_to_override);
			return;
			 
		if (reset_to_defaults):
			self.set_se_pitch_scale(1.0, sound_to_override);
			self.set_se_volume_db(0.0, sound_to_override);
	else:
		se_index = self.add_sound_effect(sound_effect);
		
	SE_Audiostreams[se_index].set_stream(Stream);
	SE_Audiostreams[se_index].play();
	SE_Audiostreams[se_index].set_sound_name(sound_effect);
	se_playing[se_index] = sound_effect;
#end

#Stops selected Sound Effect
func stop_se(sound_effect : String = "") -> void:
	var se_index = 0;
	if (sound_effect != "" && sound_effect != null):
		if (self.is_se_playing(sound_effect)):
			se_index = se_playing.find(sound_effect);
	SE_Audiostreams[se_index].stop();
#	self.erase_audiostream();
#end

#Returns true if the selected Sound Effect is already playing
func is_se_playing(sound_effect : String = "") -> bool:
	if (sound_effect != "" || sound_effect != null):
		var se_index = se_playing.find(sound_effect);
		if (se_index < 0):
			return false;
		elif (se_index >= 1):
			return true;
			
	return SE_Audiostreams[0].is_playing();
#end

func set_se_volume_db(volume_db : float, sound_effect : String = "") -> void:
	var se_index = 0;
	if (sound_effect != null && sound_effect != ""):
		se_index = se_playing.find(sound_effect);
		if (se_index < 0):
			print_debug("Sound not found: " + sound_effect);
			return;
	SE_Audiostreams[se_index].set_volume_db(volume_db);
#end

func get_se_volume_db(sound_effect : String = "") -> float:
	var se_index = 0;
	if (sound_effect != null && sound_effect != ""):
		se_index = se_playing.find(sound_effect);
		if (se_index < 0):
			print_debug("Sound not found: " + sound_effect);
			return -1.0;
	return SE_Audiostreams[se_index].get_volume_db();
#end
	
func set_se_pitch_scale(pitch : float, sound_effect : String = "") -> void:
	var se_index = 0;
	if (sound_effect != null && sound_effect != ""):
		se_index = se_playing.find(sound_effect);
		if (se_index < 0):
			print_debug("Sound not found: " + sound_effect);
			return;
	SE_Audiostreams[se_index].set_pitch_scale(pitch);
#end

func get_se_pitch_scale(sound_effect : String = "") -> float:
	var se_index = 0;
	if (sound_effect != null && sound_effect != ""):
		se_index = se_playing.find(sound_effect);
		if (se_index < 0):
			print_debug("Sound not found: " + sound_effect);
			return -1.0;
	return SE_Audiostreams[se_index].get_pitch_scale();
	
func pause_se(paused : bool, sound_effect : String = "") -> void:
	var se_index = 0
	if (sound_effect != null && sound_effect != ""):
		se_index = se_playing.find(sound_effect);
		if (se_index < 0):
			print_debug("Sound not found: " + sound_effect);
			return;
	SE_Audiostreams[se_index].set_stream_paused(paused);
#end

func is_se_paused(sound_effect : String = "") -> bool:
	var se_index = 0
	if (sound_effect != null && sound_effect != ""):
		se_index = se_playing.find(sound_effect);
		if (se_index < 0):
			print_debug("Sound not found: " + sound_effect);
			return false;
	return SE_Audiostreams[se_index].get_stream_paused();
#end

#############################
#	Music Effects Handling	#
#############################

func play_me(music_effect : String, reset_to_defaults : bool = true) -> void:
	if (music_effect == "" || music_effect == null):
		print_debug("No sound effect selected.");
		return;
	if (self.is_me_playing(music_effect)):
		return;
	
	var music_effect_file_name = music_effect if (music_effect.get_extension() != "") else Audio_Files_Dictionary.get(music_effect);
	if (music_effect_file_name == null):
		print_debug("Error: file not found " + music_effect);
		return;
	
	var music_effect_path = MFX_DIR_PATH + "/" + music_effect_file_name;
	
	var Stream = load(music_effect_path);
	if (Stream == null):
		print_debug("Failed to load file from path: " + music_effect_path);
		return;
	
	if (reset_to_defaults):
		self.set_me_pitch_scale(1.0);
		self.set_me_volume_db(0.0);
		
	ME_Audiostream.stream = Stream;
	ME_Audiostream.play();
	me_playing = music_effect;
#end

func stop_me(music_effect : String = "") -> void:
	if (music_effect != ""):
		if (self.is_me_playing(music_effect)):
			ME_Audiostream.stop();
			return;
			
	ME_Audiostream.stop();
#end

func is_me_playing(music_effect : String = "") -> bool:
	if (music_effect == "" || music_effect == null):
		return ME_Audiostream.is_playing();
	return (me_playing == music_effect && ME_Audiostream.is_playing());
#end

func set_me_volume_db(volume_db : float) -> void:
	ME_Audiostream.set_volume_db(volume_db);
#end

func get_me_volume_db() -> float:
	return ME_Audiostream.get_volume_db();
#end
	
func set_me_pitch_scale(pitch : float) -> void:
	ME_Audiostream.set_pitch_scale(pitch);
#end

func get_me_pitch_scale() -> float:
	return ME_Audiostream.get_pitch_scale();
#end

func pause_me(paused : bool) -> void:
	ME_Audiostream.set_stream_paused(paused);
#end

func is_me_paused() -> bool:
	return ME_Audiostream.get_stream_paused();
#end


#################################
#		GETTERS AND SETTERS		#
#################################

#Returns the name of the current playing (or last played) bgm
func get_playing_bgm() -> String:
	return bgm_playing;
#end

#Returns the name of the current playing (or last played) bgs
func get_playing_bgs() -> String:
	return bgs_playing;
#end

#Returns the name of the current playing sound effects
func get_playing_se_array() -> Array:
	return se_playing;
#end

#Returns the name of the current playing (or last played) me
func get_playing_me() -> String:
	return me_playing;
#end

#Returns the config dictionary
func get_configuration_dictionary() -> Dictionary:
	return Audio_Files_Dictionary;
#end

#Returns the file name of the given stream name
#Returns null if an error occures.
func get_config_value(stream_name : String) -> String:
	return Audio_Files_Dictionary.get(stream_name);
#end

#Allows you to change or add a stream file and name to the dictionary in runtime
func set_config_key(new_stream_name : String, new_stream_file : String) -> void:
	if (new_stream_file == "" || new_stream_name == ""):
		print_debug("Invalid arguments");
		return;
	
	Audio_Files_Dictionary[new_stream_name] = new_stream_file;
#end

func _on_SE_finished(sound_name):
	self.erase_sound_effect(sound_name);
#end


#############################
#	INTERNAL METHODS		#
#############################

func add_sound_effect(sound_name : String) -> int:
	var se_index;
	var new_audiostream = AudioStreamPlayer.new();
	var sound_effect_script = load(soundmgr_dir_rel_path + "/SoundEffects.gd");
	
	$SoundEffects.add_child(new_audiostream);
	new_audiostream.set_script(sound_effect_script);
	new_audiostream.set_bus($SoundEffects.get_child(0).get_bus());
	se_index = new_audiostream.get_index();
	se_playing.append(sound_name);
	SE_Audiostreams.append(new_audiostream);
	
	return se_index;
#end

func erase_sound_effect(sound_name : String) -> void:
	var se_index = se_playing.find(sound_name);
	
	if (se_index <= 0):
		return;
		
	se_playing.erase(sound_name);
	SE_Audiostreams.remove(se_index);
	$SoundEffects.get_children()[se_index].queue_free();
#end
