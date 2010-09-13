/**
 * @exampleText The following example uses <code>$(target)</code>with the root time line/document class
 * and listens to <code>MouseEvent.CLICK</code>
 */
//write this on the main timeline
$(this).onClick = function():void {
    trace('click')
}