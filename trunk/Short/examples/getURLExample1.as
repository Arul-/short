/**
 * @exampleText This example loads an image into a movie clip. When the image is clicked, a new URL is loaded in a new browser window.
 */
_.to = this;
_.loadChild("http://www.helpexamples.com/flash/images/image1.jpg")
	.onClick = function():void {
    	getURL("http://www.adobe.com/software/flash/flashpro/", "_blank");
	};