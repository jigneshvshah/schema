// Generated by CoffeeScript 1.4.0

describe('project', function() {
  var JSV, env, fs, log4js, logger, path, testUtils;
  log4js = require('log4js');
  logger = log4js.getLogger();
  fs = require('fs');
  JSV = require("JSV").JSV;
  env = JSV.createEnvironment();
  path = require("path");
  testUtils = require("./test_utils");
  return it('load the external project schema', function() {
    var data, json, report, schema;
    logger.info("load the external project schema");
    data = fs.readFileSync("./v1/pm/pm_project.schema");
    schema = JSON.parse(data);
    json = {
      "name": "test name"
    };
    return report = env.validate(json, schema);
  });
});
