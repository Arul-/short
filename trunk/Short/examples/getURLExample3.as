/**
 * @exampleText In the following ActionScript, JavaScript is used to open an alert window when the SWF file is embedded in a browser window (please note that when calling JavaScript with getURL(), the url parameter is limited to 508 characters):
 */
$(myButton).onClick=function(){
	getURL("javascript:alert('you clicked me')");
}