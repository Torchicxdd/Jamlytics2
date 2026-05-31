extends Node

const SAVE_PATH: String = "user://level_saves.tres"

func save_level_score(level_name: String, score: Dictionary) -> void:
	var save_data: LevelSaveData = load(SAVE_PATH) if ResourceLoader.exists(SAVE_PATH) else LevelSaveData.new()
	if not save_data.level_scores.has(level_name):
		save_data.level_scores[level_name] = []
	save_data.level_scores[level_name].append(score)
	ResourceSaver.save(save_data, SAVE_PATH)

func get_level_score(level_name: String) -> Array:
	if ResourceLoader.exists(SAVE_PATH):
		return (load(SAVE_PATH) as LevelSaveData).level_scores.get(level_name, [])
	return []
