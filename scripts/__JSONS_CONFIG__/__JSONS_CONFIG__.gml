/**
Configure JSON Structs using these macros.
*/

//Specify the function to use for encoding real values here
//Available built-in values: string / jsons_real_encoder_string_format / jsons_real_encoder_detailed
//You can also specify the name of a function taking a single real argument and returning a string
#macro JSONS_REAL_ENCODER string

#macro JSONS_FORMATTED_COMMA ", "
#macro JSONS_FORMATTED_COLON ": "
#macro JSONS_FORMATTED_INDENT "\t"
#macro JSONS_FORMATTED_MAX_DEPTH 3
