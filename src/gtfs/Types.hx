package gtfs;

typedef Pos = {
    var lat:Float;
    var lon:Float;
}  // WGS84

typedef Agency = {
    var id:String;
    var name:String;
    var url:String;
    var timezone:String;
    var lang:Null<String>;
    var phone:Null<String>;
    var fareUrl:Null<String>;
}

typedef BaseStop = {
    var id:String;
    var code:Null<String>;  // for the user
    var name:String;
    var desc:Null<String>;  // description
    var pos:Pos;
    var zoneId:Null<String>;
    var url:Null<String>;
    var timezone:Null<String>;
    var wheelchairBoarding:AccessibilityInfo;
}

@:enum abstract AccessibilityInfo(Int) {
    var NoInfo = 0;
    var Some = 1;
    var None = 2;
    var Inherit = -99;  // [OFFSPEC] requires station
}

typedef Station = {
    > BaseStop,
    var stops:Array<Stop>;
}

typedef Stop = {
    > BaseStop,
    var station:Null<Station>;  // parent
}

@:enum abstract RouteType(Int) {
    var Tram = 0;
    var Subway = 1;
    var Rail = 2;
    var Bus = 3;
    var Ferry = 4;
    var CableCar = 5;
    var Aerial = 6;
    var Funicular = 7;
}  // WTF BRT??

abstract Color(Int) from Int to Int {
}

typedef Route = {
    var id:String;
    var agency:Null<Agency>;
    var shortName:String;
    var name:String;  // long name
    var desc:Null<String>;
    var type:RouteType;
    var url:Null<String>;
    var color:Null<Color>;
    var textColor:Null<Color>;
}

typedef Block = String;
typedef Shape = String;
typedef Direction = Int;

typedef Trip = {
    var route:Route;
    var service:Service;
    var id:String;
    var headsign:Null<String>;
    var shortName:Null<String>;
    var direction:Direction;
    var block:Null<Block>;
    var shape:Null<Shape>;
    var wheelchairAccessible:AccessibilityInfo;
    var bikesAllowed:AccessibilityInfo;
}

abstract GTFSTime(Float) from Float to Float {
}

@:enum abstract PickupType(Int) {
    var Regular = 0;
    var None = 1;
    var AgencyArranged = 2;
    var DriverCoordinated = 3;
}

typedef DropOffType = PickupType;

typedef StopTime = {
    var trip:Trip;
    var arrivalTime:GTFSTime;
    var departureTime:GTFSTime;
    var stop:Stop;
    var stopSeq:Int;
    var stopHeadsign:Null<String>;
    var pickupType:PickupType;
    var dropOffType:DropOffType;
    var distTraveled:Null<Float>;
}

@:enum abstract Weekday(Int) {
    var Sunday = 1;
    var Monday = 2;
    var Tuesday = 4;
    var Wednesday = 8;
    var Thursday = 16;
    var Friday = 32;
    var Saturday = 64;

    @:commutative @:op(A || B) public function or(b:Weekday):ValidityQuery
    {
        return new ValidityQuery({ mask : this | cast(b, Int), exact : false });
    }

    @:commutative @:op(A && B) public function and(b:Weekday):ValidityQuery
    {
        return new ValidityQuery({ mask : this | cast(b, Int), exact : true });
    }

    @:to public function toServiceValidity():ServiceValidity
    {
        return new ServiceValidity(this);
    }

    @:to public function toValidityQuery():ValidityQuery
    {
        return new ValidityQuery({ mask : this, exact : true });
    }

}

abstract ServiceValidity(Int) {

    public function new(mask)
    {
        this = mask;
    }

    @:to public function toValidityQuery():ValidityQuery
    {
        return new ValidityQuery({ mask : this, exact : true });
    }

    public function validFor(query:ValidityQuery):Bool
    {
        return query.exact ? this & query.mask == query.mask : this & query.mask != 0;
    }

}

@:forward abstract ValidityQuery({ mask : Int, exact : Bool }) {

    public function new(query)
    {
        this = query;
    }

    @:commutative @:op(a || b) public function or(b:ValidityQuery):ValidityQuery
    {
        return new ValidityQuery({ mask : this.mask | b.mask, exact : false });
    }

    @:commutative @:op(a && b) public function and(b:ValidityQuery):ValidityQuery
    {
        return new ValidityQuery({ mask : this.mask | b.mask, exact : true });
    }

    @:to public function toServiceValidity():ServiceValidity
    {
        return new ServiceValidity(this.mask);
    }

}

typedef GTFSDate = String;

typedef Service = {
    var id:String;
    var validity:ServiceValidity;
    var startDate:GTFSDate;
    var endDate:GTFSDate;
}

