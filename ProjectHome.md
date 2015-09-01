### Why Short? ###
While we all like AS3 for consistency, better performance and OOP, many of us hate it for its verbose nature. If you share this view, then you will find **Short** helpful in your day-to-day development tasks, be it an agency interactive or a complex application. **Short** attempts to reduce the verboseness of the language.

### What it provides? ###
It provides few global objects and methods as shown below,
| **Name** | **Purpose** |
|:---------|:------------|
| `_`      | root of event handling simplification. once we set the target using `_.to=myMovieClip` syntax, we can use `_.onClick` instead of `myMovieClip.addEventListener(...)` to handle events.  it is a global instance of `com.luracast.Short` |
| `$(target)` | alternative syntax for getting the short version of the target. Use `$(myMovieClip).onClick=function(){}` syntax,  instead of `myMovieClip.addEventListener(...)` to handle events.  it is a global function to call `com.luracast.Short.getShort(target)` |
| `_.loadChild(...)` or `$(target).loadChild(...)` | convenience method to load an image/swf into our movie. |
| `_.loadingChild` or `$(target).loadingChild()` | convenience property to refer to the Loader. |
| `_.listeners` or `$(target).listeners` | list of active listeners on the current target. |
| `_.listAllEvents()` or `$(target).listAllEvents()` | lists the events supported by the current target object. |
| `_.listErrorEvents()` or `$(target).listErrorEvents()` | lists the error events supported by the current target. |
| `_.removeListeners()` or `$(target).removeListeners()` | helper method to remove all events added through the `onEventName` syntax |
| `_global` | a global object to add properties and methods that you want to access from every where |
| `getURL()` |a global method to load a document from a specific URL into a window or pass variables to another application at a defined URL. Shorthand for navigateToURL. |
| `com.luracast.Short` |A stand-in object to simplify event handling with `onEventName` syntax. It also adds convenience methods to the objects it stands-in for |


### How to use it? ###
Its a simple 3 step process
  1. download **Short.swc** from the downloads section
  1. add it to your library path
  1. start using it :)

Here is an example that shows most of the use cases
```
//the one and only import statement!
import flash.events.ProgressEvent;
//on the root timeline
_.to=this;
_.loadChild("http://www.helpexamples.com/flash/images/image1.jpg").onComplete=function():void
{
	with (this.content)
	{
		trace(this, 'width', width, 'height', height);
		//traces [short Loader] width 400 height 267
		y=100;
		width=100
		height=66;
	}
	this.onceEnterFrame=function():void
	{
		trace('enterframe once');
	}
	this.onClick=function():void
	{
		getURL("http://www.adobe.com/software/flash/flashpro/", "_blank");
		//manually remove event listener
		delete this.onClick;
	}
}
```

Short is not just for Sprites and MovieClips, it will work on any target that is capable of dispatching events

This example shows how we can use the `$(target)` syntax, nested functions to create a simple http client using `flash.net.Socket'
```
import flash.net.Socket;
import flash.events.Event;
	
function socketResponse(onResult:Function, onError:Function, 
						host:String, page:String = '', port:int = 80):void {
    var s:Object = $(new Socket(host, port));
    trace(s.listErrorEvents());
	//traces onIoError,onSecurityError
	trace(s.listAllEvents());
	//traces onClose,onConnect,onIoError,onSecurityError,onSocketData
    var result:String = '';
    s.onIoError = s.onSecurityError = function(e:Event):void {
        e.preventDefault();
        //delete this.onceConnect, s.onIoError, s.onSecurityError;
        this.removeListeners();
        onError(e);
    }
    s.onceConnect = function():void {
        this.writeUTFBytes("GET /" + page + "\n");
        this.onSocketData = function():void {
            result += this.readUTFBytes(this.bytesAvailable)
        }

        this.onceClose = function():void {
            //delete this.onSocketData, this.onceIoError, s.onSecurityError;
			this.removeListeners();
            onResult(result);
        }
    }
trace('listeners', s.listeners);
//traces listeners onIoError,onceConnect,onSecurityError
}
//Use the socket response function to trace the response from google.com
socketResponse(trace, trace, 'google.com');
//socketResponse(trace, trace, 'localhost);

```

For more information refer to the API-Documentation link provided in the side bar