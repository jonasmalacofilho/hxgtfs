package gtfs;

import gtfs.Error;
import gtfs.FileReader;
import gtfs.Types;
import haxe.io.Input;
using gtfs.Helpers;

class Reader {
    var zip:List<haxe.zip.Entry>;
    var file:FileReader;
    var ctx:Gtfs;

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
            if (ctx.agencies.exists(agency.id))
                throw EFieldValueNotUnique("agency_id", file.makeErrPos());
            ctx.agencies.set(agency.id, agency);
        }

        if (Lambda.count(ctx.agencies) > 1 && (ctx.agencies.exists(null) || ctx.agencies.exists("")))
            throw null;  // FIXME
    }

    function readStops()
    {
        for (r in openFile("stops.txt")) {
            var base:BaseStop = {
                id : r.notEmpty("stop_id"),
                code : r.emptyAsNull("stop_code"),
                name : r.notEmpty("stop_name"),  // annoying for testing?
                desc : r.emptyAsNull("stop_desc"),
                pos : {
                    lat : r.float("stop_lat"),
                    lon : r.float("stop_lon")
                },
                url : r.emptyAsNull("stop_url"),
                timezone : r.emptyAsNull("stop_timezone"),
                wheelchairBoarding : r.nullableInt("wheelchair_boarding").coalesce(0)
            };
            if (ctx.stations.exists(base.id) || ctx.stops.exists(base.id))
                throw EFieldValueNotUnique("stop_id", file.makeErrPos());

            switch (r.field("location_type")) {
            case "0", "", null:
                var stop:Stop = cast base;
                stop.stationId = r.emptyAsNull("parent_station");
                stop.zoneId = r.emptyAsNull("zone_id");
                ctx.stops.set(stop.id, stop);
            case "1":
                var station:Station = cast base;
                if (station.wheelchairBoarding == ANoInfo)
                    station.wheelchairBoarding = AInherit;
                ctx.stations.set(station.id, station);
            case _:
                throw null;  // FIXME
            }
        }
    }

    function readAll()
    {
        readAgencies();
        readStops();
    }

    function new(input:Input)
    {
        zip = haxe.zip.Reader.readZip(input);
        ctx = {
            agencies : new Map(),
            stations : new Map(),
            stops : new Map(),
            route : null,
            calendar : null,
            trips : null,
            stopTimes : null,
        };
    }

    public static function read(input:Input)
    {
        var x = new Reader(input);
        x.readAll();
        return x.ctx;
    }
}

