package gtfs;

import format.csv.Reader in CsvReader;
import gtfs.Types;
import haxe.io.BytesInput;
import haxe.io.Input;
using gtfs.CsvTools;

class Reader {
    var zip:List<haxe.zip.Entry>;
    var ctx:Gtfs;


    function openFile(name:String):Input
    {
        var x = Lambda.find(zip, function (e) return e.fileName == name);
        // TODO check for null
        return new BytesInput(haxe.zip.Reader.unzip(x));
    }

    function openTable(name:String)
    {
        return new CsvReader().reset(openFile("agency.txt")).openAsTable();
    }

    public function openArchive(inp:Input)
    {
        zip = haxe.zip.Reader.readZip(inp);
    }

    public function readAgencies()
    {
        var agencies = [for (r in openTable("agency.txt")) {
            id : r["agency_id"].emptyAsNull(),
            name : r["agency_name"].notEmpty(),
            url : r["agency_url"].notEmpty(),
            timezone : r["agency_timezone"].notEmpty(),
            lang : r["agency_lang"].emptyAsNull(),
            phone : r["agency_phone"].emptyAsNull(),
            fareUrl : r["agency_fare_url"].emptyAsNull()
        }];
        ctx.agencies = ctx.agencies.concat(agencies);
        trace(ctx.agencies);
    }

    public function readArchive(inp:Input)
    {
        openArchive(inp);
        readAgencies();
        // TODO
    }

    public function new()
    {
        ctx = cast { agencies : [] };
    }

}

