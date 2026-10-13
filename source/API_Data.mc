import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;
using Toybox.Timer;

var currentMinutes as Number?;

class API_Data{
    function initialize() {
        makeRequest();
    }
    function makeRequest(){
        var url = "https://api.entur.io/journey-planner/v3/graphql";
        //placeholder
        //added: realtime , aimedDepartureTime cancellation , quay {id publicCode situations{ situationNumber summary { language value}
        var params = {"query" => "query ($id: String!){ stopPlace(id: $id) {name id estimatedCalls {realtime aimedDepartureTime expectedDepartureTime cancellation destinationDisplay {frontText } quay {id publicCode situations{ situationNumber summary { language value}}} serviceJourney {line {publicCode transportMode}}}}}", "variables" => {"id" => "NSR:StopPlace:6208"}};
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
                //test vars
                var realT = line["realtime"] as Boolean;
                var plannedDepT = line["aimedDepartureTime"];
                var cancelledTrip = line["cancellation"];
                var quayId = line["quay"].values();
                System.println("Real Time: " + realT + " Original Dep Time: " + plannedDepT + " Cancelled (bool): " + cancelledTrip + " Quay IDs: " + quayId);
                //test end
                var destDisplay = line["destinationDisplay"] as Dictionary;
                var destination = destDisplay["frontText"] as String;
                var departureTime = line["expectedDepartureTime"];
                var departureDate = line["expectedDepartureTime"];
                formatData(destination, stopName, departureTime, departureDate);
            }
            //move pointer & timer logic to fire outside of api retrieval!
            timeTracker();
            journey.departurePointer();
        }else{
            System.println("Response failed, received code: " + responseCode);
        }
    }

    function timeTracker() as Void{
        WatchUi.requestUpdate();
        if(refreshTimer == null){
            refreshTimer = new Timer.Timer();
            //time < 30s, update every 5s?
            refreshTimer.start(timers.method(:onRefresh), 20000, true);
        }
    }

    function formatData(endStop as String, stopName as String, rawTime as String, rawDate as String) as Void{
        var hours = rawTime.substring(11, 13);
        var minutes = rawTime.substring(14, 16);
        var seconds = rawTime.substring(17, 19);
        var date = options.styleDate(rawDate);
        var scheduledTime = hours + ":" + minutes;
        var stopDict = {
            "destination" => endStop,
            "stop" => stopName,
            "time" => scheduledTime,
            "hours" => hours,
            "minutes" => minutes,
            "seconds" => seconds,
            "date" => date
        };
        journey.setInfoTable(stopDict);
    }
}