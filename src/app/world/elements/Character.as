package app.world.elements
{
	import com.piterwilson.utils.*;
	import app.data.*;
	import app.world.data.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;

	public class Character extends Sprite
	{
		// Storage
		public var outfit:MovieClip;
		public var animatePose:Boolean;

		private var _itemDataMap:Object;

		// Properties
		public function set scale(pVal:Number) : void { outfit.scaleX = outfit.scaleY = pVal; }

		// Constructor
		// pData = { x:Number, y:Number, [various "__Data"s], ?params:URLVariables }
		public function Character(pData:Object) {
			super();
			animatePose = false;

			this.x = pData.x;
			this.y = pData.y;

			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, function () { startDrag(); });
			this.addEventListener(MouseEvent.MOUSE_UP, function () { stopDrag(); });

			/****************************
			* Store Data
			*****************************/
			_itemDataMap = {};
			_itemDataMap[ITEM.BOX_SMALL] = pData.box_small;
			_itemDataMap[ITEM.BOX_LARGE] = pData.box_large;
			_itemDataMap[ITEM.PLANK_SMALL] = pData.hair;
			_itemDataMap[ITEM.PLANK_LARGE] = pData.ears;
			_itemDataMap[ITEM.BALL] = pData.eyes;
			_itemDataMap[ITEM.TRAMPOLINE] = pData.mouth;
			_itemDataMap[ITEM.ANVIL] = pData.neck;
			_itemDataMap[ITEM.CANNONBALL] = pData.tail;
			_itemDataMap[ITEM.BALLOON] = pData.contacts;
			
			/*if(pData.params) _parseParams(pData.params);*/

			updatePose();
		}

		public function updatePose() {
			outfit = addChild(new MovieClip());
			/*var tScale = 3;
			if(outfit != null) { tScale = outfit.scaleX; removeChild(outfit); }
			outfit = addChild(new Pose(getItemData(ITEM.POSE)));
			outfit.scaleX = outfit.scaleY = tScale;

			outfit.apply({
				items:[
					getItemData(ITEM.BOX_SMALL),
					getItemData(ITEM.BOX_LARGE),
					getItemData(ITEM.HAIR),
					getItemData(ITEM.PLANK_SMALL),
					getItemData(ITEM.PLANK_LARGE),
					getItemData(ITEM.BALL),
					getItemData(ITEM.TRAMPOLINE),
					getItemData(ITEM.ANVIL),
					getItemData(ITEM.CANNONBALL),
					getItemData(ITEM.BALLOON),
				]
			});
			if(animatePose) outfit.play(); else outfit.stopAtLastFrame();*/
		}

		private function _parseParams(pParams:URLVariables) : void {
			trace(pParams.toString());

			_setParamToType(pParams, ITEM.SKIN, "s", false);
			_setParamToType(pParams, ITEM.HAIR, "d");
			_setParamToType(pParams, ITEM.HAT, "h");
			_setParamToType(pParams, ITEM.EARS, "e");
			_setParamToType(pParams, ITEM.EYES, "y");
			_setParamToType(pParams, ITEM.MOUTH, "m");
			_setParamToType(pParams, ITEM.NECK, "n");
			_setParamToType(pParams, ITEM.TAIL, "t");
			_setParamToType(pParams, ITEM.CONTACTS, "c");
			_setParamToType(pParams, ITEM.POSE, "p", false);
		}
		private function _setParamToType(pParams:URLVariables, pType:String, pParam:String, pAllowNull:Boolean=true) {
			var tData:ItemData = null;
			if(pParams[pParam] != null) {
				if(pParams[pParam] == '') {
					tData = null;
				} else {
					tData = GameAssets.getItemFromTypeID(pType, pParams[pParam]);
				}
			}
			_itemDataMap[pType] = pAllowNull ? tData : ( tData == null ? _itemDataMap[pType] : tData );
		}

		public function getParams() : URLVariables {
			var tParms = new URLVariables();

			var tData:ItemData;
			tParms.s = (tData = getItemData(ITEM.SKIN)) ? tData.id : '';
			tParms.d = (tData = getItemData(ITEM.HAIR)) ? tData.id : '';
			tParms.h = (tData = getItemData(ITEM.HAT)) ? tData.id : '';
			tParms.e = (tData = getItemData(ITEM.EARS)) ? tData.id : '';
			tParms.y = (tData = getItemData(ITEM.EYES)) ? tData.id : '';
			tParms.m = (tData = getItemData(ITEM.MOUTH)) ? tData.id : '';
			tParms.n = (tData = getItemData(ITEM.NECK)) ? tData.id : '';
			tParms.t = (tData = getItemData(ITEM.TAIL)) ? tData.id : '';
			tParms.c = (tData = getItemData(ITEM.CONTACTS)) ? tData.id : '';
			tParms.p = (tData = getItemData(ITEM.POSE)) ? tData.id : '';

			return tParms;
		}

		/****************************
		* Color
		*****************************/
		public function getColors(pType:String) : Array {
			return _itemDataMap[pType].colors;
		}

		public function colorItem(pType:String, arg2:int, pColor:String) : Array {
			_itemDataMap[pType].colors[arg2] = GameAssets.convertColorToNumber(pColor);
			updatePose();
		}

		/****************************
		* Update Data
		*****************************/
		public function getItemData(pType:String) : ItemData {
			return _itemDataMap[pType];
		}

		public function setItemData(pItem:ItemData) : void {
			var tType = pItem.type == ITEM.SKIN_COLOR ? ITEM.SKIN : pItem.type;
			_itemDataMap[tType] = pItem;
			updatePose();
		}

		public function removeItem(pType:String) : void {
			_itemDataMap[pType] = null;
			updatePose();
		}
	}
}
