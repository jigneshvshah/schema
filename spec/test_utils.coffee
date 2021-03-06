log4js = require('log4js')
logger = log4js.getLogger()
fs = require('fs')
JSV = require("JSV").JSV
path = require("path")
env = JSV.createEnvironment("json-schema-draft-03")

loadSchemasInFolder = (folder) ->
  files = fs.readdirSync("."+folder)
  logger.debug "loading schemas in #{folder}"
  for file in files
    do (file) ->
      if path.extname(file) is ".schema"
        logger.debug "loading schema for file #{folder}/#{file}"
        schemaData = fs.readFileSync(".#{folder}/#{file}")
        logger.debug "https://raw.github.com/spidasoftware/schema/master#{folder}/#{file}"
        env.createSchema( schemaData, true, "https://raw.github.com/spidasoftware/schema/master#{folder}/#{file}" )

validate = (json, schemaFile, success=true, supportedSchemasArray=[]) ->
  for schema in supportedSchemasArray
    logger.debug "  Loading: "+schema
    loadSchemasInFolder(schema)
  logger.debug("json string to validate.")
  logger.debug(JSON.stringify(json, null, 2))
  data = fs.readFileSync(schemaFile)
  schema = JSON.parse(data)
  report = env.validate(json, schema)
  if success
    if report.errors.length>0
      expect(JSON.stringify(report.errors[0], null, 2)).toBe("")
    else
      expect(report.errors.length).toBe(0)
  else
    expect(report.errors.length).not.toBe(0)
    if report.errors.length==0
      expect("There were no errors, but we expected some.").toBe("")
    else
      expect(report.errors.length).toBeGreaterThan(0)

module.exports.validate = validate
module.exports.loadSchemasInFolder = loadSchemasInFolder
