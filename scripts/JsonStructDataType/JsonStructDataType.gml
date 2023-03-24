///@func JsonStruct(data_or_key, string)
///@param {string, struct} data_or_key 
///@desc Utility class for building a struct with ordered keys.
function JsonStruct(data_or_key) constructor {
	if (is_struct(data_or_key)) {
		var keys = variable_struct_get_names(data_or_key);
		var nKeys = array_length(keys);
		_data = array_create(nKeys*2);
		var ii = 0;
		for (var i = 0; i < nKeys; ++i) {
			var k = keys[i];
			_data[ii] = k;
			_data[ii+1] = variable_struct_get(data_or_key, k);
			ii += 2;
		}
	} else {
		if (argument_count % 2 == 1) show_error("Expected an even number of arguments, got " + string(argument_count) + ".", true);
		_data = array_create(argument_count);
		for (var i = 0; i < argument_count; ++i) {
			_data[i] = argument[i];
		}
	}
	
	///@func get(key)
	///@param {string} key The key to look up.
	///@return {Any}
	///@desc Return the value stored at the given key.
	///
	///If the key is not found, return undefined.
	static get = function(key) {
		for (var i = array_length(_data)-2; i >= 0; i -= 2) {
			if (_data[i] == key) return _data[i+1];
		}
		return undefined;
	};
	
	///@func set(key, value)
	///@param {string} key The key to set.
	///@param {any} value The value to set under the key.
	///@return {Struct.JsonStruct}
	///@desc Set the value for the given key.
	///
	///Returns self to support chaining. Example: js.set("foo", 3).set("bar", 4);
	static set = function(key, value) {
		var imax = array_length(_data);
		var i;
		for (i = 0; i < imax; i += 2) {
			if (_data[@i] == key) {
				_data[@i+1] = value;
				return self;
			}
		}
		_data[@i+1] = value;
		_data[@i] = key;
		return self;
	}
	
	///@func keys()
	///@return {Array<string>}
	///@desc Return an array of all available keys.
	static keys = function() {
		var result = array_create(array_length(_data) div 2);
		var imax = array_length(_data);
		var ii = 0;
		for (var i = 0; i < imax; i += 2) {
			result[ii] = _data[i];
			++ii;
		}
		///Feather disable GM1045
		return result;
		///Feather enable GM1045
	}
	
	///@func size()
	///@return {real}
	///@desc Return the number of entries stored.
	static size = function() {
		return array_length(_data) div 2;
	}
}
