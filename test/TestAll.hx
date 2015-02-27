import gtfs.*;
import utest.Runner;
import utest.ui.Report;

class TestAll {

    public static function main()
    {
        var sample = gtfs.Reader.read(sys.io.File.read("data/sample-feed.zip", true));
        trace("AGENCIES:\n\t" + Lambda.array(sample.agencies).join("\n\t"));
        trace("STATIONS:\n\t" + Lambda.array(sample.stations).join("\n\t"));
        trace("STOPS:\n\t"    + Lambda.array(sample.stops).join("\n\t"));

        var r = new Runner();

        r.addCase(new TestServiceValidity());
        r.addCase(new TestCsvReader());

        Report.create(r);
        r.run();
    }

}

