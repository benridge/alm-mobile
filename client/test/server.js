var express = require('express');
var path = require('path');

var app = express();

app.get('/', function(req, res) {
    res.sendfile(path.resolve(__dirname) + '/testpage.html');
});

module.exports = app;
