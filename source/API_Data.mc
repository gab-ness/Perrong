//TODO:
/*
SETTINGS
- select stops
- save selections

API
On start:
- request data based on selections
- receive data
- format data
- store data

View:
- load data
- display data

Reload:
- request data
- receive data
- format data
- store data
    */
import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;

class API_Data{
    function initialize() {
        makeRequest();
    }
    function makeRequest(){
        var url = "https://api.entur.io/journey-planner/v3/graphql";
        //placeholder
        var params = {"query" => "query ($id: String!){ stopPlace(id: $id) {name id estimatedCalls {expectedDepartureTime destinationDisplay {frontText }serviceJourney {line {publicCode transportMode}}}}}", "variables" => {"id" => "NSR:StopPlace:6208"}};
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {"ET-Client-Name" => "nesskom-applikasjon", "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        var responseCallback = method(:onResponse);
        Communications.makeWebRequest(url, params, options, responseCallback);
    }

    function onResponse(responseCode as Number, data as Dictionary?) as Void{
        //data
        //responsecodes
        var output = data;
        // if(data != null){
        //     output = data[0];
        // }
        if(responseCode == 200){
            System.println("Request Successful");
            System.println("data: " + output);
            WatchUi.requestUpdate();
        }else{
            System.println("Response: " + responseCode);
        }
    }

    //format data
    //store data
    //load data
}