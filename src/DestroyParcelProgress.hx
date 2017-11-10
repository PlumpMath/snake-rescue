package ;

import luxe.ParcelProgress;
import luxe.resource.Resource;
import luxe.Parcel;
import luxe.Visual;
import luxe.Color;
import luxe.options.ParcelProgressOptions;
import luxe.Text;
import luxe.Vector;

typedef DestroyParcelProgressOptions = {
    > ParcelProgressOptions,
    
    ?secondHalf: Bool
}

class DestroyParcelProgress extends ParcelProgress {
	var block : Visual;
    var background_ : Visual;
    var secondHalf : Bool = false;

	public function new(_options:DestroyParcelProgressOptions) {
		_options.no_visuals = true;
		_options.fade_in = false;

		if(_options.bar == null) {
			_options.bar = new Color().rgb(0x88C070);
		}

		if(_options.background == null) {
			_options.background = new Color().rgb(0x306850);
		}

		super(_options);
        
        if (_options.secondHalf) secondHalf = _options.secondHalf;
        
        background_ = new Visual({
            name: "background",
            color: _options.background,
            pos: new Vector(0, 0),
            size: new Vector(256, 256),
            batcher: Main.backgroundBatcher,
            depth: 0
        });
        
		block = new Visual({
            name: "progress",
            color: _options.bar,
            pos: new Vector(0, if(secondHalf) 128 else 0),
            size: new Vector(256, 256),
            batcher: Main.backgroundBatcher,
            depth: 1
        });

        options.parcel.on(ParcelEvent.progress, onprogress);
        options.parcel.on(ParcelEvent.complete, oncomplete);
	}
    
    var oldamount : Int = 32;
    
	override public function onprogress(_state:ParcelChange) {
		var amount = Math.floor(_state.index / _state.total * 16);
        if (secondHalf) amount += 16;
        if (amount < oldamount) {
            oldamount = amount;
            block.pos.y = 256/32 * amount;
            Luxe.camera.shake(1);
        }
	}

	override public function oncomplete(p:Parcel) {
		block.destroy();
        background_.destroy();

		super.oncomplete(p);
	}
}