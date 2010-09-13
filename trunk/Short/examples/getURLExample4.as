/**
 * @exampleText You can also use <code>GET</code> or <code>POST</code> for sending variables. The following example uses <code>GET</code> to append variables to a URL:
 */
$(myButton).onClick=function(){
	getURL("http://www.adobe.com", "_blank", "GET", 
		{firstName: "Gus", lastName: "Richardson", age: 92});
}