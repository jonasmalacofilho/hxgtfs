package gtfs;

typedef GtfsErrorPos = {
    fileName : String,
    lineNumber : Int
}

enum GtfsFormatError {
    EMissingFile(fileName:String);
    ENullFieldNotAllowed(fieldName:String, pos:GtfsErrorPos);
    EEmptyFieldNotAllowed(fieldName:String, pos:GtfsErrorPos);
    ENotInt(fieldName:String, field:String, pos:GtfsErrorPos);
    ENotFloat(fieldName:String, field:String, pos:GtfsErrorPos);
    EUnexpectedFieldContents(fieldName:String, field:String, pos:GtfsErrorPos);
}

enum GtfsConsistencyError {
    EFieldValueNotUnique(fieldName:String, value:Dynamic, ?pos:GtfsErrorPos);
}

