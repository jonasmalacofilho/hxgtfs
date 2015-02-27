package gtfs;

class Helpers {
    public static function coalesce<A>(v1:Null<A>, v2:Null<A>):Null<A>
    {
        return v1 != null ? v1 : v2;
    }
}

