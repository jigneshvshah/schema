describe 'asset master', ->
	#Include logger
	log4js = require('log4js')
	logger = log4js.getLogger()
  
	#Odd things happen if you set this in multiple places.
	logger.setLevel('INFO')

	fs = require('fs')
	geometrySchema = "./v1/asset/geometry.schema"
	testUtils = require "./test_utils"

	it 'Check geometry schema', ->
		logger.info("Check geometry schema")
		json = {
			"type": "LineString",
			"coordinates": [
				[102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]
				],
			"bbox" : [124.0, 100.0, 14.0, -47.0]
		}
		testUtils.validate(json, geometrySchema, true)

		#1. switch to one universal geometry object
		#2. Add more tests to test invalid types, coordinates, bbox's
