#Utility script for converting the schemas with references to a single file for validating against.
#output goes into public

#Include some stuff.
util = require('util')
fs = require('fs')
JSV = require("JSV").JSV
env = JSV.createEnvironment("json-schema-draft-03")
path = require("path")
schemaMap = new Object
loadSchemasInFolder = (folder) ->
	files = fs.readdirSync(folder)
	util.puts "loading schemas in #{folder}"
	for file in files
		do (file) ->
			if path.extname(file) is ".schema"
				util.puts "loading schema for file #{file}"
				schemaData = fs.readFileSync("#{folder}/#{file}")
				name = path.basename(file, ".schema")
				schemaMap[name] = JSON.parse(schemaData)
				util.puts "Success"
				#env.createSchema( schemaData, true, path.basename(file, ".schema")  )


loadSupportSchemas = () ->
	loadSchemasInFolder("../v1/general")
	loadSchemasInFolder("../v1/calc")

replaceReferences = (schema) ->
	for key in Object.keys(schema)
		child = schema[key]
		if (child['$ref'] isnt undefined)
			url = child['$ref']
			util.puts("reference: #{url}")

			reference = schemaMap[url]

			util.puts( "replaced with #{JSON.stringify(reference, null, 2)}" )
			schema[key] = reference

	for key in Object.keys(schema)
		child = schema[key]
		if (typeof child is "object")
			util.puts("replacing in #{key}")
			replaceReferences(child)

replaceExtends = (schema) ->
	if (schema.extends isnt undefined)
		child = schema.extends
		delete schema.extends
		for key in Object.keys(child)
			util.puts "adding key #{key} value #{child[key]}"
			schema[key] = child[key]

	for key in Object.keys(schema)
		child = schema[key]
		if (typeof child is "object")
			util.puts "replacing extends in #{key}"
			replaceExtends(child)


loadSupportSchemas()


data = fs.readFileSync("../v1/calc/calc_project.schema")
schema = JSON.parse(data)
replaceReferences(schema)
replaceExtends(schema)
fs.writeFileSync("../public/v1/calc/calc_project.schema", JSON.stringify(schema, null, 2))

data = fs.readFileSync("../v1/calc/design.schema")
schema = JSON.parse(data)
replaceReferences(schema)
replaceExtends(schema)
fs.writeFileSync("../public/v1/calc/design.schema", JSON.stringify(schema, null, 2))

data = fs.readFileSync("../v1/calc/framing_plan.schema")
schema = JSON.parse(data)
replaceReferences(schema)
replaceExtends(schema)
fs.writeFileSync("../public/v1/calc/framing_plan.schema", JSON.stringify(schema, null, 2))