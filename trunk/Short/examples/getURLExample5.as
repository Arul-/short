/**
 * @exampleText The following ActionScript uses <code>POST</code> to send variables in the HTTP header. Make sure you test your documents in a browser window, because otherwise your variables are sent using <code>GET</code>: 
 */
$(myButton).onClick=function(){
	getURL("http://www.adobe.com", "_blank", "POST", 
		{firstName: "Gus", lastName: "Richardson", age: 92});
}
