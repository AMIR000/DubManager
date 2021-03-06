package ru.kokorin.component
{
	import com.adobe.cairngorm.popup.IPopUpBehavior;
	import com.adobe.cairngorm.popup.PopUpBase;
	import com.adobe.cairngorm.popup.PopUpEvent;
	
	import flash.events.Event;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import mx.core.IUIComponent;
	
	public class KeepMaxSizeBehavior implements IPopUpBehavior
	{
		private static const PADDING:Number = 30;

		private var popup:IUIComponent;
		private var base:PopUpBase;
        private var updateTimeout:uint = 0;
		
		public function KeepMaxSizeBehavior(){
		}
		
		public function apply(base:PopUpBase):void{
			this.base = base;
			base.addEventListener(PopUpEvent.OPENED, onOpened);
		}
		
		private function onOpened(event:PopUpEvent):void{
			popup = event.popup as IUIComponent;
			if(popup && popup.stage){
				popup.stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
                updatePopup();
			}
			base.addEventListener(PopUpEvent.CLOSING, onClosing);
		}

		private function onStageResize(event:Event = null):void {
            if (updateTimeout) {
                clearTimeout(updateTimeout);
            }
            updateTimeout = setTimeout(updatePopup, 500);
		}

        private function updatePopup():void {
            updateTimeout = 0;

            popup.width = Math.min(popup.stage.stageWidth - 2*PADDING, popup.maxWidth);
            popup.height = Math.min(popup.stage.stageHeight - 2*PADDING, popup.maxHeight);

            popup.x = (popup.stage.stageWidth - popup.width) / 2;
            popup.y = (popup.stage.stageHeight - popup.height) / 2;
        }
		
		private function onClosing(event:Event):void{
			base.removeEventListener(PopUpEvent.CLOSING, onClosing);
			if (popup.stage){
				popup.stage.removeEventListener(Event.RESIZE, onStageResize);
			}
            if (updateTimeout) {
                clearTimeout(updateTimeout);
                updateTimeout = 0;
            }
        }
	}
}