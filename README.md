# JSON Struct

## Overview

This GMS 2 library allows encoding and decoding JSON as structs, arrays and other first-order data types.

## Requirements

- GameMaker Studio 2.3.7 or higher

If you use GameMaker Studio 2.3.0 to 2.3.6, please use [v1.1.0](https://github.com/dicksonlaw583/JsonStruct/releases/v1.1.0).

## Installation

Get the current asset package and associated documentation from [the releases page](https://github.com/dicksonlaw583/JsonStruct/releases). Simply extract everything to your project. Once you do that, you may optionally change the options in `__JSONS_CONFIG__` to suit your project's needs.

## Contributing to JSON Struct

- Clone this repository.
- Open the project in GameMaker Studio 2 LTS and make your additions/changes to `JsonStruct_Functions` for public functions, and `JsonStruct_Internal` for library-internal utilities. Also add the corresponding tests to the `JsonStruct_test` group.
- Open a pull request [here](https://github.com/dicksonlaw583/JsonStruct/issues).

## Additional Credits

Special thanks to [Aivan Fouren](https://github.com/AivanF) for contributing the core logic for `jsons_encode_formatted` and `jsons_save_formatted`.
