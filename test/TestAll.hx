import gtfs.*;
import utest.Runner;
import utest.ui.Report;

class TestAll {

    public static function main()
    {
        var r = new Runner();

        r.addCase(new TestServiceValidity());

        Report.create(r);
        r.run();
    }

}

