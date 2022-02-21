var exec = require('cordova/exec');

function SharePlugin() {};

SharePlugin.prototype = {
	share : function(content, success, fail){
		exec(success, fail, "SharePlugin", "share", [content]);
	}
};

module.exports = new SharePlugin();