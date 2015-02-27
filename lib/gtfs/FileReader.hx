package gtfs;

import gtfs.Error;
import haxe.io.*;
import haxe.zip.Entry;
import format.csv.Reader in CsvReader;

@:access(gtfs.FileReader)
class RecordReader {
    var file:FileReader;
    var rec:Array<String>;

    public function field(fieldName:String):Null<String>
    {
        return file.header.exists(fieldName) ? rec[file.header.get(fieldName)] : null;
    }

    public function notNull(fieldName:String):String
    {
        var f = field(fieldName);
        if (f == null)
            throw ENullFieldNotAllowed(fieldName, file.makeErrPos());
        return f;
    }

    public function notEmpty(fieldName:String):String
    {
        var f = field(fieldName);
        if (f == null || f == "")
            throw EEmptyFieldNotAllowed(fieldName, file.makeErrPos());
        return f;
    }

    public function emptyAsNull(fieldName:String):String
    {
        var f = field(fieldName);
        return f == "" ? null : f;
    }

    public function int(fieldName:String):Int
    {
        var f = field(fieldName);
        return f != null ? Std.parseInt(f) : 0;
    }

    public function float(fieldName:String):Float
    {
        var f = field(fieldName);
        return f != null ? Std.parseFloat(f) : 0.;
    }

    public function new(fileReader, record)
    {
        file = fileReader;
        rec = record;
    }
}

class FileReader {
    public var fileName(default, null):String;
    public var lineNumber(default, null):Int;
    var zipEntry:Entry;
    var rawInput:Input;
    var csvReader:CsvReader;
    var header:Map<String,Int>;

    function clear()
    {
        fileName = null;
        lineNumber = null;
        zipEntry = null;
        header = null;
        rawInput = null;
        csvReader = null;
    }

    function readHeader()
    {
        header = new Map();
        var i = 0;
        for (fn in csvReader.next())
            header.set(fn, i++);
        lineNumber++;
    }
    
    public function makeErrPos():GtfsErrorPos
    {
        return { fileName : fileName, lineNumber : lineNumber };
    }

    public function hasNext():Bool
    {
        return csvReader.hasNext();
    }

    public function next():RecordReader
    {
        return new RecordReader(this, csvReader.next());
    }

    public function readAll():Array<RecordReader>
    {
        return csvReader.readAll().map(RecordReader.new.bind(this));
    }


    public function new(zip:List<Entry>, fileName:String)
    {
        this.fileName = fileName;
        lineNumber = 0;
        zipEntry = Lambda.find(zip, function (e) return e.fileName == fileName);
        if (zipEntry == null)
            throw EMissingFile(fileName);
        rawInput = new BytesInput(haxe.zip.Reader.unzip(zipEntry));
        csvReader = new CsvReader().reset(null, rawInput);
        readHeader();
    }
}

