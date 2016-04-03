/* The file is supposed to be automatically generated from mraid.js to escaped string for NSString constant literal. */
//NSString * const XAD_MRAID_INJECTION_JS
(function() {
function MRAIDClass() {
	/* these variables are publicly available but not encouraged to use. It is mainly for single direction data sync. */
	this.listeners = {};
	this.viewable = true;	
	this.addEventListener = function (event, listener) {
		if (typeof this.listeners[event] === "undefined") {
			this.listeners[event] = [];
		}
		this.listeners[event].push(listener);
	};
	this.removeEventListener = function (event, listener) {
		if (this.listeners[event] instanceof Array) {
			var lis = this.listeners[event], i, len;
			if (lis !== null) {
				len = lis.length;
				for (i = 0; i < len; i++) {
					if (lis[i] === listener) {
						lis.splice(i, 1);
						break;
					}
				}
			}
		}
	};
	this.dispatchEvent = function (event) {
		if (this.listeners[event] instanceof Array) {
			var lis = this.listeners[event], i, len;
			len = lis.length;
			for (i = 0; i < len; i++) {
				try {
					if (lis[i]) {
						lis[i].apply(this, Array.prototype.slice.call(arguments,1));
					}
				} catch (e) {
					this._xad_log('Exception in dispatchEvent:' + e);
				}
			}
		}
	};
	this.getVersion = function () {
		return "2.0";
	};
}
/* Initialize global mraid variable, to be used by ad. */
window.mraid = new MRAIDClass();
})();
