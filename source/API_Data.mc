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
using Toybox.Timer;

public var currentDeparture as Dictionary?;
public var infoTable as Array = [];
var currentMinutes as Number?;

//date & time updated each time new Vehicle indexed - fetched by View
var displayDate as String?;
var displayTime as String?;

var updateTimer as Timer.Timer?;
//declare shared TimeHandler
var handler = new TimeHandler();
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

    function onResponse(responseCode as Number, responseBody as Dictionary?) as Void{
        if(responseCode == 200){
            System.println("Request Successful");
            System.println("data: ");
            System.println(responseBody);
            //stop place
            var queryId = responseBody["data"] as Dictionary;
            var stopDetails = queryId["stopPlace"] as Dictionary;
            var stopName = stopDetails["name"] as String;
            var receivedLines = stopDetails["estimatedCalls"] as Array;
            for(var i = 0; i < receivedLines.size(); i++){
                var line = receivedLines[i] as Dictionary;
                var destDisplay = line["destinationDisplay"] as Dictionary;
                var destination = destDisplay["frontText"] as String;
                //merge lines below!
                var departureTime = line["expectedDepartureTime"];
                var departureDate = line["expectedDepartureTime"];
                formatData(destination, stopName, departureTime, departureDate);
            }
            //move pointer & timer logic to fire outside of api retrieval!
            departurePointer();
            timeTracker();
        }else{
            System.println("Response failed, received code: " + responseCode);
        }
    }

    function timeTracker(){
        WatchUi.requestUpdate();
        if(updateTimer == null){
            updateTimer = new Timer.Timer();
            //time < 30s, update every 5s?
            updateTimer.start(handler.method(:timerCallback), 20000, true);
        }
    }

    //handles displayed time info for next trip
    function departurePointer() as Void{
        currentDeparture = infoTable[counter] as Dictionary;
        var departureHours = (currentDeparture["hours"] as String).toNumber();
        var departureMinutes = (currentDeparture["minutes"] as String).toNumber();
        var departureSeconds = (currentDeparture["seconds"] as String).toNumber();
        var departureTime = departureHours * 60 + departureMinutes;
        handler.setTimeLeft(departureTime, departureSeconds);
        displayDate = currentDeparture["date"] as String;
        displayTime = currentDeparture["time"] as String;
    }

    function formatData(endStop as String, stopName as String, rawTime as String, rawDate as String) as Void{
        var hours = rawTime.substring(11, 13);
        var minutes = rawTime.substring(14, 16);
        var seconds = rawTime.substring(17, 19);
        var date = handler.styleDate(rawDate);
        var scheduledTime = hours + ":" + minutes;
        //retrieve data from onResponse
        var stopDict = {
            "destination" => endStop,
            "stop" => stopName,
            "time" => scheduledTime,
            "hours" => hours,
            "minutes" => minutes,
            "seconds" => seconds,
            "date" => date
        };
        infoTable.add(stopDict);
    }
}