import gtfs.*;
import utest.Runner;
import utest.ui.Report;

class TestAll {

    @:access(gtfs.Reader)
    public static function main()
    {
        var r = new Runner();

        r.addCase(new TestServiceValidity());
        r.addCase(new TestCsvReader());

        Report.create(r);
        r.run();

        var x = new gtfs.Reader();
        x.openArchive(sys.io.File.read("data/sample-feed.zip", true));
        // trace(x.zip.map(function (e) return e.fileName));
        x.readAgencies();
    }

}

