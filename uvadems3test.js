//var request = require('request');
var AWS = require('aws-sdk');
var fs = require('fs');

var credentials = new AWS.SharedIniFileCredentials({profile: 'uvadem'});
AWS.config.credentials = credentials;

fs.readFile('/Volumes/Storage/index.html','utf8',function(err,data){
	var params = {Bucket: 'ccps-demographics', Key: 'index.html', Body: data}
	console.log();
})
console.log("hey")