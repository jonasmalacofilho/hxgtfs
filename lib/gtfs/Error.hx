package gtfs;

typedef GtfsErrorPos = {
    fileName : String,
    lineNumber : Int
}

enum GtfsFormatError {
    EMissingFile(fileName:String);
    ENullFieldNotAllowed(fieldName:String, pos:GtfsErrorPos);
    EEmptyFieldNotAllowed(fieldName:String, pos:GtfsErrorPos);
    EIdMustBeUnique(fieldName:String, pos:GtfsErrorPos);
}

enum GtfsConsistencyError {
}

