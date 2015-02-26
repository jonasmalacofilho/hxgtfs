package gtfs;

import format.csv.Reader;

class CsvRecordWraperImpl {
    var columns:Map<String,Int>;
    var record:Array<String>;

    public function get(column:String):Null<String>
    {
        return columns.exists(column) ? record[columns.get(column)] : null;
    }

    public function new(columns, record)
    {
        this.columns = columns;
        this.record = record;
    }
}

abstract CsvRecordWraper(CsvRecordWraperImpl) from CsvRecordWraperImpl {
    @:arrayAccess public inline function get(column:String)
    {
        return this.get(column);
    }
    public inline function new(t)
    {
        this = t;
    }
}

class CsvReaderWraper {
    var columns:Map<String,Int>;
    var reader:Reader;

    public function hasNext()
    {
        return reader.hasNext();
    }

    public function next():CsvRecordWraper
    {
        return new CsvRecordWraperImpl(columns, reader.next());
    }

    public function readAll():Array<CsvRecordWraper>
    {
        return reader.readAll().map(CsvRecordWraperImpl.new.bind(columns));
    }

    public function new(columns, reader)
    {
        this.columns = columns;
        this.reader = reader;
    }
}

class CsvTools {
    public static function openAsTable(reader:Reader):CsvReaderWraper
    {
        var header = reader.next();
        var columns = new Map();
        for (i in 0...header.length)
            columns.set(header[i], i);
        return new CsvReaderWraper(columns, reader);
    }
    public static function notNull(field:Null<String>):String
    {
        if (field == null)
            throw "Null field not allowed";
        return field;
    }
    public static function notEmpty(field:Null<String>):String
    {
        if (field == null || field == "")
            throw "Empty field not allowed";
        return field;
    }
    public static function int(field:Null<String>):Int
    {
        return field != null ? Std.parseInt(field) : 0;
    }
    public static function float(field:Null<String>):Float
    {
        return field != null ? Std.parseFloat(field) : 0.;
    }
    public static function emptyAsNull(field:Null<String>):String
    {
        return field == "" ? null : field;
    }
}

