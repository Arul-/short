/**
 * @exampleText The following example creates new instance of Sprite targeting a sprite
 * lists the events supported by sprite and then listens to addedToStage event once
 */
import com.luracast.Short;
import flash.display.Sprite;

var s:Short = new Short(new Sprite);
trace(s.listAllEvents());
//traces the following (broken into multiple lines for clarrity)
//onAdded,onAddedToStage,onClear,onClick,onContextMenu,onCopy,onCut,onDoubleClick,
//onEnterFrame,onExitFrame,onFocusIn,onFocusOut,onFrameConstructed,onGesturePan,
//onGesturePressAndTap,onGestureRotate,onGestureSwipe,onGestureTwoFingerTap,
//onGestureZoom,onImeStartComposition,onKeyDown,onKeyFocusChange,onKeyUp,
//onMiddleClick,onMiddleMouseDown,onMiddleMouseUp,onMouseDown,
//onMouseFocusChange,onMouseMove,onMouseOut,onMouseOver,onMouseUp,
//onMouseWheel,onNativeDragComplete,onNativeDragDrop,onNativeDragEnter,
//onNativeDragExit,onNativeDragOver,onNativeDragStart,onNativeDragUpdate,
//onPaste,onRemoved,onRemovedFromStage,onRender,onRightClick,onRightMouseDown,
//onRightMouseUp,onRollOut,onRollOver,onSelectAll,onTabChildrenChange,onTabEnabledChange,
//onTabIndexChange,onTextInput,onTouchBegin,onTouchEnd,onTouchMove,onTouchOut,onTouchOver,
//onTouchRollOut,onTouchRollOver,onTouchTap
s.onceAddedToStage=function():void
{
	trace('addedToStage');
}
addChild(s.to);
