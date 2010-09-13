/**
 * @exampleText The following example ties <code>_</code>with the root time line/document class
 * and makes it available to every Timeline and scope in a SWF file,
 * and listens to <code>MouseEvent.CLICK</code> event
 */
//write this on the main timeline
_.to = this;
//write the following anywhere
_.onClick = function():void {
    trace('click');
}