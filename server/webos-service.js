"use strict";
// Sustituto de "webos-service" para ejecutar index.js fuera de una TV LG.
// Cada metodo registrado queda disponible por HTTP: GET/POST /<metodo>?clave=valor
// y devuelve el mismo JSON que daba el bus de webOS.
var http = require("http");
var url = require("url");

function Service(name) {
  this.name = name;
  this.methods = {};
  Service.last = this;
}
Service.prototype.register = function (method, fn) {
  this.methods[method] = fn;
};

Service.listen = function (port, host, ready) {
  var svc = Service.last;
  var server = http.createServer(function (req, res) {
    var cors = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "Content-Type",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS"
    };
    if (req.method === "OPTIONS") { res.writeHead(204, cors); return res.end(); }

    var u = url.parse(req.url, true);
    var method = u.pathname.replace(/^\/+/, "");
    var fn = svc && svc.methods[method];
    if (!fn) {
      res.writeHead(404, Object.assign({ "Content-Type": "application/json" }, cors));
      return res.end(JSON.stringify({ returnValue: false, errorText: "metodo desconocido: " + method }));
    }

    var chunks = [];
    req.on("data", function (c) { chunks.push(c); });
    req.on("end", function () {
      var payload = {};
      Object.keys(u.query).forEach(function (k) { payload[k] = u.query[k]; });
      if (chunks.length) {
        try {
          var body = JSON.parse(Buffer.concat(chunks).toString("utf8"));
          Object.keys(body).forEach(function (k) { payload[k] = body[k]; });
        } catch (e) { /* cuerpo no JSON: se ignora */ }
      }
      var done = false;
      fn({
        payload: payload,
        isSubscription: false,
        respond: function (data) {
          if (done) return;
          done = true;
          res.writeHead(200, Object.assign({ "Content-Type": "application/json; charset=utf-8" }, cors));
          res.end(JSON.stringify(data));
        }
      });
    });
  });
  server.listen(port, host, ready);
  return server;
};

module.exports = Service;
