import gtfs.*;
import utest.Runner;
import utest.ui.Report;

class TestAll {

    public static function main()
    {
        var r = new Runner();

        r.addCase(new TestServiceValidity());
        r.addCase(new TestCsvReader());

        Report.create(r);
        // r.run();

        var x = new gtfs.Reader();
        x.readArchive(sys.io.File.read("data/sample-feed.zip", true));
    }

}

