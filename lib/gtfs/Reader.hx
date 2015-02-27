package gtfs;

import gtfs.Error;
import gtfs.FileReader;
import gtfs.Types;
import haxe.io.Input;

class Reader {
    var zip:List<haxe.zip.Entry>;
    var file:FileReader;
    var gtfs:Gtfs;

    function openFile(fileName:String):FileReader
    {
        return file = new FileReader(zip, fileName);
    }

    function readAgencies()
    {
        for (r in openFile("agency.txt")) {
            var agency = {
                id :       r.emptyAsNull("agency_id"),
                name :     r.notEmpty("agency_name"),
                url :      r.notEmpty("agency_url"),
                timezone : r.notEmpty("agency_timezone"),
                lang :     r.emptyAsNull("agency_lang"),
                phone :    r.emptyAsNull("agency_phone"),
                fareUrl :  r.emptyAsNull("agency_fare_url")
            };
            if (Lambda.exists(gtfs.agencies, function (a) return a.id == agency.id))
                throw EIdMustBeUnique("agency_id", file.makeErrPos());
            gtfs.agencies.push(agency);
        }
        // TODO check for missing id if gtfs.agencies.length > 1
    }

    function readAll()
    {
        readAgencies();
    }

    function new(input:Input)
    {
        zip = haxe.zip.Reader.readZip(input);
        gtfs = cast { agencies : [] };
    }

    public static function read(input:Input)
    {
        var x = new Reader(input);
        x.readAll();
        return x.gtfs;
    }
}

