"use strict";
// Apunta la app de la TV al servidor: node configurar.js IP [puerto]
var fs = require("fs");
var path = require("path");
var ip = process.argv[2];
var port = process.argv[3] || "8910";
if (!ip) { console.error("Uso: node configurar.js IP [puerto]"); process.exit(1); }
var file = path.join(__dirname, "tizen", "config", "api.js");
var txt = fs.readFileSync(file, "utf8");
var out = txt.replace(/devServiceUrl:"[^"]*"/, 'devServiceUrl:"http://' + ip + ":" + port + '"');
if (out === txt && txt.indexOf("http://" + ip + ":" + port) === -1) {
  console.error("No encontre devServiceUrl en " + file); process.exit(1);
}
fs.writeFileSync(file, out);
console.log("App configurada para usar http://" + ip + ":" + port);
