package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.external.ExternalInterface;
	
	import com.adobe.nativeExtensions.Vibration;
	
	public class Main extends Sprite {

		private var startScreenSprite:Sprite;
		private var mainScreenSprite:Sprite;
		
		private var vibration:Vibration;
		
		public function Main() 
		{
			Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT; 
			trace("Working");
			DisplayStartScreen();
		}
		
		public function DisplayStartScreen():void

		{
			//instantiate the bitmap in the library by its identifier
			startScreenSprite = new Sprite();//create an image container

			addChild(startScreenSprite);//add it to the display list

			var libraryImage:Bitmap = new Bitmap(new StartScreen(0,0));
			libraryImage.x -= 10;
			libraryImage.y -= 10;
			//place the image in the image container

			startScreenSprite.addChild(libraryImage);
			
			startScreenSprite.addEventListener(TouchEvent.TOUCH_BEGIN, OnTouchTap);

		}
		
		public function DisplayMainScreen():void 
		{
			//instantiate the bitmap in the library by its identifier
			mainScreenSprite = new Sprite();//create an image container

			addChild(mainScreenSprite);//add it to the display list

			var libraryImage:Bitmap = new Bitmap(new MainScreen(0,0));
			//place the image in the image container

			mainScreenSprite.addChild(libraryImage);
			
			mainScreenSprite.addEventListener(TouchEvent.TOUCH_BEGIN, OnOpenPersonalBarcode);
		}
		
		private function OnTouchTap(evt:TouchEvent):void 
		{
			trace("OnTouch");
			
			startScreenSprite.removeChildAt(0);
			
			DisplayMainScreen();
		}
		
		private function OnOpenPersonalBarcode(evt:TouchEvent):void 
		{
			trace(Vibration.isSupported);
			
			//vibrate
			if (Vibration.isSupported) 
			{
				vibration = new Vibration();
				vibration.vibrate(2000);
			}
		}

	}
	
}
