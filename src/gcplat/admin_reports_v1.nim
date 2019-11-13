
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Admin Reports
## version: reports_v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Fetches reports for the administrators of G Suite customers about the usage, collaboration, security, and risk for their users.
## 
## /admin-sdk/reports/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_579380 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579380](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579380): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "admin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReportsActivitiesList_579650 = ref object of OpenApiRestCall_579380
proc url_ReportsActivitiesList_579652(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/activity/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReportsActivitiesList_579651(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of activities for a specific customer's account and application such as the Admin console application or the Google Drive application. For more information, see the guides for administrator and Google Drive activity reports. For more information about the activity report's parameters, see the activity parameters reference guides.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : Application name for which the events are to be retrieved.
  ##   userKey: JString (required)
  ##          : Represents the profile ID or the user email for which the data should be filtered. Can be all for all information, or userKey for a user's unique G Suite profile ID or their primary email address.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_579791 = path.getOrDefault("applicationName")
  valid_579791 = validateParameter(valid_579791, JString, required = true,
                                 default = newJString("access_transparency"))
  if valid_579791 != nil:
    section.add "applicationName", valid_579791
  var valid_579792 = path.getOrDefault("userKey")
  valid_579792 = validateParameter(valid_579792, JString, required = true,
                                 default = nil)
  if valid_579792 != nil:
    section.add "userKey", valid_579792
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endTime: JString
  ##          : Sets the end of the range of time shown in the report. The date is in the RFC 3339 format, for example 2010-10-28T10:26:35.000Z. The default value is the approximate time of the API request. An API report has three basic time concepts:  
  ## - Date of the API's request for a report: When the API created and retrieved the report. 
  ## - Report's start time: The beginning of the timespan shown in the report. The startTime must be before the endTime (if specified) and the current time when the request is made, or the API returns an error. 
  ## - Report's end time: The end of the timespan shown in the report. For example, the timespan of events summarized in a report can start in April and end in May. The report itself can be requested in August.  If the endTime is not specified, the report returns all activities from the startTime until the current time or the most recent 180 days if the startTime is more than 180 days in the past.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   eventName: JString
  ##            : The name of the event being queried by the API. Each eventName is related to a specific G Suite service or feature which the API organizes into types of events. An example is the Google Calendar events in the Admin console application's reports. The Calendar Settings type structure has all of the Calendar eventName activities reported by the API. When an administrator changes a Calendar setting, the API reports this activity in the Calendar Settings type and eventName parameters. For more information about eventName query strings and parameters, see the list of event names for various applications above in applicationName.
  ##   startTime: JString
  ##            : Sets the beginning of the range of time shown in the report. The date is in the RFC 3339 format, for example 2010-10-28T10:26:35.000Z. The report returns all activities from startTime until endTime. The startTime must be before the endTime (if specified) and the current time when the request is made, or the API returns an error.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   actorIpAddress: JString
  ##                 : The Internet Protocol (IP) Address of host where the event was performed. This is an additional way to filter a report's summary using the IP address of the user whose activity is being reported. This IP address may or may not reflect the user's physical location. For example, the IP address can be the user's proxy server's address or a virtual private network (VPN) address. This parameter supports both IPv4 and IPv6 address versions.
  ##   pageToken: JString
  ##            : The token to specify next page. A report with multiple pages has a nextPageToken property in the response. In your follow-on request getting the next page of the report, enter the nextPageToken value in the pageToken query string.
  ##   orgUnitID: JString
  ##            : ID of the organizational unit to report on. Activity records will be shown only for users who belong to the specified organizational unit. Data before Dec 17, 2018 doesn't appear in the filtered results.
  ##   filters: JString
  ##          : The filters query string is a comma-separated list. The list is composed of event parameters that are manipulated by relational operators. Event parameters are in the form [parameter1 name][relational operator][parameter1 value],[parameter2 name][relational operator][parameter2 value],... 
  ## These event parameters are associated with a specific eventName. An empty report is returned if the filtered request's parameter does not belong to the eventName. For more information about eventName parameters, see the list of event names for various applications above in applicationName.
  ## 
  ## In the following Admin Activity example, the <> operator is URL-encoded in the request's query string (%3C%3E):
  ## GET...&eventName=CHANGE_CALENDAR_SETTING &filters=NEW_VALUE%3C%3EREAD_ONLY_ACCESS
  ## 
  ## In the following Drive example, the list can be a view or edit event's doc_id parameter with a value that is manipulated by an 'equal to' (==) or 'not equal to' (<>) relational operator. In the first example, the report returns each edited document's doc_id. In the second example, the report returns each viewed document's doc_id that equals the value 12345 and does not return any viewed document's which have a doc_id value of 98765. The <> operator is URL-encoded in the request's query string (%3C%3E):
  ## 
  ## GET...&eventName=edit&filters=doc_id GET...&eventName=view&filters=doc_id==12345,doc_id%3C%3E98765
  ## 
  ## The relational operators include:  
  ## - == - 'equal to'. 
  ## - <> - 'not equal to'. It is URL-encoded (%3C%3E). 
  ## - < - 'less than'. It is URL-encoded (%3C). 
  ## - <= - 'less than or equal to'. It is URL-encoded (%3C=). 
  ## - > - 'greater than'. It is URL-encoded (%3E). 
  ## - >= - 'greater than or equal to'. It is URL-encoded (%3E=).  
  ## Note: The API doesn't accept multiple values of a parameter. If a particular parameter is supplied more than once in the API request, the API only accepts the last value of that request parameter.
  ## In addition, if an invalid request parameter is supplied in the API request, the API ignores that request parameter and returns the response corresponding to the remaining valid request parameters. If no parameters are requested, all parameters are returned.
  ##   customerId: JString
  ##             : The unique ID of the customer to retrieve data for.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Determines how many activity records are shown on each response page. For example, if the request sets maxResults=1 and the report has two activities, the report has two pages. The response's nextPageToken property has the token to the second page. The maxResults query string is optional in the request. The default value is 1000.
  section = newJObject()
  var valid_579793 = query.getOrDefault("key")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "key", valid_579793
  var valid_579794 = query.getOrDefault("endTime")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "endTime", valid_579794
  var valid_579795 = query.getOrDefault("prettyPrint")
  valid_579795 = validateParameter(valid_579795, JBool, required = false,
                                 default = newJBool(true))
  if valid_579795 != nil:
    section.add "prettyPrint", valid_579795
  var valid_579796 = query.getOrDefault("oauth_token")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "oauth_token", valid_579796
  var valid_579797 = query.getOrDefault("eventName")
  valid_579797 = validateParameter(valid_579797, JString, required = false,
                                 default = nil)
  if valid_579797 != nil:
    section.add "eventName", valid_579797
  var valid_579798 = query.getOrDefault("startTime")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "startTime", valid_579798
  var valid_579799 = query.getOrDefault("alt")
  valid_579799 = validateParameter(valid_579799, JString, required = false,
                                 default = newJString("json"))
  if valid_579799 != nil:
    section.add "alt", valid_579799
  var valid_579800 = query.getOrDefault("userIp")
  valid_579800 = validateParameter(valid_579800, JString, required = false,
                                 default = nil)
  if valid_579800 != nil:
    section.add "userIp", valid_579800
  var valid_579801 = query.getOrDefault("quotaUser")
  valid_579801 = validateParameter(valid_579801, JString, required = false,
                                 default = nil)
  if valid_579801 != nil:
    section.add "quotaUser", valid_579801
  var valid_579802 = query.getOrDefault("actorIpAddress")
  valid_579802 = validateParameter(valid_579802, JString, required = false,
                                 default = nil)
  if valid_579802 != nil:
    section.add "actorIpAddress", valid_579802
  var valid_579803 = query.getOrDefault("pageToken")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = nil)
  if valid_579803 != nil:
    section.add "pageToken", valid_579803
  var valid_579804 = query.getOrDefault("orgUnitID")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = newJString(""))
  if valid_579804 != nil:
    section.add "orgUnitID", valid_579804
  var valid_579805 = query.getOrDefault("filters")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "filters", valid_579805
  var valid_579806 = query.getOrDefault("customerId")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "customerId", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579809 = query.getOrDefault("maxResults")
  valid_579809 = validateParameter(valid_579809, JInt, required = false,
                                 default = newJInt(1000))
  if valid_579809 != nil:
    section.add "maxResults", valid_579809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579832: Call_ReportsActivitiesList_579650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of activities for a specific customer's account and application such as the Admin console application or the Google Drive application. For more information, see the guides for administrator and Google Drive activity reports. For more information about the activity report's parameters, see the activity parameters reference guides.
  ## 
  let valid = call_579832.validator(path, query, header, formData, body)
  let scheme = call_579832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579832.url(scheme.get, call_579832.host, call_579832.base,
                         call_579832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579832, url, valid)

proc call*(call_579903: Call_ReportsActivitiesList_579650; userKey: string;
          key: string = ""; endTime: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; eventName: string = "";
          applicationName: string = "access_transparency"; startTime: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          actorIpAddress: string = ""; pageToken: string = ""; orgUnitID: string = "";
          filters: string = ""; customerId: string = ""; fields: string = "";
          maxResults: int = 1000): Recallable =
  ## reportsActivitiesList
  ## Retrieves a list of activities for a specific customer's account and application such as the Admin console application or the Google Drive application. For more information, see the guides for administrator and Google Drive activity reports. For more information about the activity report's parameters, see the activity parameters reference guides.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endTime: string
  ##          : Sets the end of the range of time shown in the report. The date is in the RFC 3339 format, for example 2010-10-28T10:26:35.000Z. The default value is the approximate time of the API request. An API report has three basic time concepts:  
  ## - Date of the API's request for a report: When the API created and retrieved the report. 
  ## - Report's start time: The beginning of the timespan shown in the report. The startTime must be before the endTime (if specified) and the current time when the request is made, or the API returns an error. 
  ## - Report's end time: The end of the timespan shown in the report. For example, the timespan of events summarized in a report can start in April and end in May. The report itself can be requested in August.  If the endTime is not specified, the report returns all activities from the startTime until the current time or the most recent 180 days if the startTime is more than 180 days in the past.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   eventName: string
  ##            : The name of the event being queried by the API. Each eventName is related to a specific G Suite service or feature which the API organizes into types of events. An example is the Google Calendar events in the Admin console application's reports. The Calendar Settings type structure has all of the Calendar eventName activities reported by the API. When an administrator changes a Calendar setting, the API reports this activity in the Calendar Settings type and eventName parameters. For more information about eventName query strings and parameters, see the list of event names for various applications above in applicationName.
  ##   applicationName: string (required)
  ##                  : Application name for which the events are to be retrieved.
  ##   startTime: string
  ##            : Sets the beginning of the range of time shown in the report. The date is in the RFC 3339 format, for example 2010-10-28T10:26:35.000Z. The report returns all activities from startTime until endTime. The startTime must be before the endTime (if specified) and the current time when the request is made, or the API returns an error.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   actorIpAddress: string
  ##                 : The Internet Protocol (IP) Address of host where the event was performed. This is an additional way to filter a report's summary using the IP address of the user whose activity is being reported. This IP address may or may not reflect the user's physical location. For example, the IP address can be the user's proxy server's address or a virtual private network (VPN) address. This parameter supports both IPv4 and IPv6 address versions.
  ##   pageToken: string
  ##            : The token to specify next page. A report with multiple pages has a nextPageToken property in the response. In your follow-on request getting the next page of the report, enter the nextPageToken value in the pageToken query string.
  ##   orgUnitID: string
  ##            : ID of the organizational unit to report on. Activity records will be shown only for users who belong to the specified organizational unit. Data before Dec 17, 2018 doesn't appear in the filtered results.
  ##   filters: string
  ##          : The filters query string is a comma-separated list. The list is composed of event parameters that are manipulated by relational operators. Event parameters are in the form [parameter1 name][relational operator][parameter1 value],[parameter2 name][relational operator][parameter2 value],... 
  ## These event parameters are associated with a specific eventName. An empty report is returned if the filtered request's parameter does not belong to the eventName. For more information about eventName parameters, see the list of event names for various applications above in applicationName.
  ## 
  ## In the following Admin Activity example, the <> operator is URL-encoded in the request's query string (%3C%3E):
  ## GET...&eventName=CHANGE_CALENDAR_SETTING &filters=NEW_VALUE%3C%3EREAD_ONLY_ACCESS
  ## 
  ## In the following Drive example, the list can be a view or edit event's doc_id parameter with a value that is manipulated by an 'equal to' (==) or 'not equal to' (<>) relational operator. In the first example, the report returns each edited document's doc_id. In the second example, the report returns each viewed document's doc_id that equals the value 12345 and does not return any viewed document's which have a doc_id value of 98765. The <> operator is URL-encoded in the request's query string (%3C%3E):
  ## 
  ## GET...&eventName=edit&filters=doc_id GET...&eventName=view&filters=doc_id==12345,doc_id%3C%3E98765
  ## 
  ## The relational operators include:  
  ## - == - 'equal to'. 
  ## - <> - 'not equal to'. It is URL-encoded (%3C%3E). 
  ## - < - 'less than'. It is URL-encoded (%3C). 
  ## - <= - 'less than or equal to'. It is URL-encoded (%3C=). 
  ## - > - 'greater than'. It is URL-encoded (%3E). 
  ## - >= - 'greater than or equal to'. It is URL-encoded (%3E=).  
  ## Note: The API doesn't accept multiple values of a parameter. If a particular parameter is supplied more than once in the API request, the API only accepts the last value of that request parameter.
  ## In addition, if an invalid request parameter is supplied in the API request, the API ignores that request parameter and returns the response corresponding to the remaining valid request parameters. If no parameters are requested, all parameters are returned.
  ##   customerId: string
  ##             : The unique ID of the customer to retrieve data for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Determines how many activity records are shown on each response page. For example, if the request sets maxResults=1 and the report has two activities, the report has two pages. The response's nextPageToken property has the token to the second page. The maxResults query string is optional in the request. The default value is 1000.
  ##   userKey: string (required)
  ##          : Represents the profile ID or the user email for which the data should be filtered. Can be all for all information, or userKey for a user's unique G Suite profile ID or their primary email address.
  var path_579904 = newJObject()
  var query_579906 = newJObject()
  add(query_579906, "key", newJString(key))
  add(query_579906, "endTime", newJString(endTime))
  add(query_579906, "prettyPrint", newJBool(prettyPrint))
  add(query_579906, "oauth_token", newJString(oauthToken))
  add(query_579906, "eventName", newJString(eventName))
  add(path_579904, "applicationName", newJString(applicationName))
  add(query_579906, "startTime", newJString(startTime))
  add(query_579906, "alt", newJString(alt))
  add(query_579906, "userIp", newJString(userIp))
  add(query_579906, "quotaUser", newJString(quotaUser))
  add(query_579906, "actorIpAddress", newJString(actorIpAddress))
  add(query_579906, "pageToken", newJString(pageToken))
  add(query_579906, "orgUnitID", newJString(orgUnitID))
  add(query_579906, "filters", newJString(filters))
  add(query_579906, "customerId", newJString(customerId))
  add(query_579906, "fields", newJString(fields))
  add(query_579906, "maxResults", newJInt(maxResults))
  add(path_579904, "userKey", newJString(userKey))
  result = call_579903.call(path_579904, query_579906, nil, nil, nil)

var reportsActivitiesList* = Call_ReportsActivitiesList_579650(
    name: "reportsActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activity/users/{userKey}/applications/{applicationName}",
    validator: validate_ReportsActivitiesList_579651, base: "/admin/reports/v1",
    url: url_ReportsActivitiesList_579652, schemes: {Scheme.Https})
type
  Call_ReportsActivitiesWatch_579945 = ref object of OpenApiRestCall_579380
proc url_ReportsActivitiesWatch_579947(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/activity/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReportsActivitiesWatch_579946(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start receiving notifications for account activities. For more information, see Receiving Push Notifications.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : Application name for which the events are to be retrieved.
  ##   userKey: JString (required)
  ##          : Represents the profile ID or the user email for which the data should be filtered. Can be all for all information, or userKey for a user's unique G Suite profile ID or their primary email address.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_579948 = path.getOrDefault("applicationName")
  valid_579948 = validateParameter(valid_579948, JString, required = true,
                                 default = newJString("access_transparency"))
  if valid_579948 != nil:
    section.add "applicationName", valid_579948
  var valid_579949 = path.getOrDefault("userKey")
  valid_579949 = validateParameter(valid_579949, JString, required = true,
                                 default = nil)
  if valid_579949 != nil:
    section.add "userKey", valid_579949
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endTime: JString
  ##          : Sets the end of the range of time shown in the report. The date is in the RFC 3339 format, for example 2010-10-28T10:26:35.000Z. The default value is the approximate time of the API request. An API report has three basic time concepts:  
  ## - Date of the API's request for a report: When the API created and retrieved the report. 
  ## - Report's start time: The beginning of the timespan shown in the report. The startTime must be before the endTime (if specified) and the current time when the request is made, or the API returns an error. 
  ## - Report's end time: The end of the timespan shown in the report. For example, the timespan of events summarized in a report can start in April and end in May. The report itself can be requested in August.  If the endTime is not specified, the report returns all activities from the startTime until the current time or the most recent 180 days if the startTime is more than 180 days in the past.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   eventName: JString
  ##            : The name of the event being queried by the API. Each eventName is related to a specific G Suite service or feature which the API organizes into types of events. An example is the Google Calendar events in the Admin console application's reports. The Calendar Settings type structure has all of the Calendar eventName activities reported by the API. When an administrator changes a Calendar setting, the API reports this activity in the Calendar Settings type and eventName parameters. For more information about eventName query strings and parameters, see the list of event names for various applications above in applicationName.
  ##   startTime: JString
  ##            : Sets the beginning of the range of time shown in the report. The date is in the RFC 3339 format, for example 2010-10-28T10:26:35.000Z. The report returns all activities from startTime until endTime. The startTime must be before the endTime (if specified) and the current time when the request is made, or the API returns an error.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   actorIpAddress: JString
  ##                 : The Internet Protocol (IP) Address of host where the event was performed. This is an additional way to filter a report's summary using the IP address of the user whose activity is being reported. This IP address may or may not reflect the user's physical location. For example, the IP address can be the user's proxy server's address or a virtual private network (VPN) address. This parameter supports both IPv4 and IPv6 address versions.
  ##   pageToken: JString
  ##            : The token to specify next page. A report with multiple pages has a nextPageToken property in the response. In your follow-on request getting the next page of the report, enter the nextPageToken value in the pageToken query string.
  ##   orgUnitID: JString
  ##            : ID of the organizational unit to report on. Activity records will be shown only for users who belong to the specified organizational unit. Data before Dec 17, 2018 doesn't appear in the filtered results.
  ##   filters: JString
  ##          : The filters query string is a comma-separated list. The list is composed of event parameters that are manipulated by relational operators. Event parameters are in the form [parameter1 name][relational operator][parameter1 value],[parameter2 name][relational operator][parameter2 value],... 
  ## These event parameters are associated with a specific eventName. An empty report is returned if the filtered request's parameter does not belong to the eventName. For more information about eventName parameters, see the list of event names for various applications above in applicationName.
  ## 
  ## In the following Admin Activity example, the <> operator is URL-encoded in the request's query string (%3C%3E):
  ## GET...&eventName=CHANGE_CALENDAR_SETTING &filters=NEW_VALUE%3C%3EREAD_ONLY_ACCESS
  ## 
  ## In the following Drive example, the list can be a view or edit event's doc_id parameter with a value that is manipulated by an 'equal to' (==) or 'not equal to' (<>) relational operator. In the first example, the report returns each edited document's doc_id. In the second example, the report returns each viewed document's doc_id that equals the value 12345 and does not return any viewed document's which have a doc_id value of 98765. The <> operator is URL-encoded in the request's query string (%3C%3E):
  ## 
  ## GET...&eventName=edit&filters=doc_id GET...&eventName=view&filters=doc_id==12345,doc_id%3C%3E98765
  ## 
  ## The relational operators include:  
  ## - == - 'equal to'. 
  ## - <> - 'not equal to'. It is URL-encoded (%3C%3E). 
  ## - < - 'less than'. It is URL-encoded (%3C). 
  ## - <= - 'less than or equal to'. It is URL-encoded (%3C=). 
  ## - > - 'greater than'. It is URL-encoded (%3E). 
  ## - >= - 'greater than or equal to'. It is URL-encoded (%3E=).  
  ## Note: The API doesn't accept multiple values of a parameter. If a particular parameter is supplied more than once in the API request, the API only accepts the last value of that request parameter.
  ## In addition, if an invalid request parameter is supplied in the API request, the API ignores that request parameter and returns the response corresponding to the remaining valid request parameters. If no parameters are requested, all parameters are returned.
  ##   customerId: JString
  ##             : The unique ID of the customer to retrieve data for.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Determines how many activity records are shown on each response page. For example, if the request sets maxResults=1 and the report has two activities, the report has two pages. The response's nextPageToken property has the token to the second page. The maxResults query string is optional in the request. The default value is 1000.
  section = newJObject()
  var valid_579950 = query.getOrDefault("key")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "key", valid_579950
  var valid_579951 = query.getOrDefault("endTime")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "endTime", valid_579951
  var valid_579952 = query.getOrDefault("prettyPrint")
  valid_579952 = validateParameter(valid_579952, JBool, required = false,
                                 default = newJBool(true))
  if valid_579952 != nil:
    section.add "prettyPrint", valid_579952
  var valid_579953 = query.getOrDefault("oauth_token")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "oauth_token", valid_579953
  var valid_579954 = query.getOrDefault("eventName")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "eventName", valid_579954
  var valid_579955 = query.getOrDefault("startTime")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "startTime", valid_579955
  var valid_579956 = query.getOrDefault("alt")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = newJString("json"))
  if valid_579956 != nil:
    section.add "alt", valid_579956
  var valid_579957 = query.getOrDefault("userIp")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "userIp", valid_579957
  var valid_579958 = query.getOrDefault("quotaUser")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "quotaUser", valid_579958
  var valid_579959 = query.getOrDefault("actorIpAddress")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "actorIpAddress", valid_579959
  var valid_579960 = query.getOrDefault("pageToken")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "pageToken", valid_579960
  var valid_579961 = query.getOrDefault("orgUnitID")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = newJString(""))
  if valid_579961 != nil:
    section.add "orgUnitID", valid_579961
  var valid_579962 = query.getOrDefault("filters")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "filters", valid_579962
  var valid_579963 = query.getOrDefault("customerId")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "customerId", valid_579963
  var valid_579964 = query.getOrDefault("fields")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "fields", valid_579964
  var valid_579965 = query.getOrDefault("maxResults")
  valid_579965 = validateParameter(valid_579965, JInt, required = false,
                                 default = newJInt(1000))
  if valid_579965 != nil:
    section.add "maxResults", valid_579965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579967: Call_ReportsActivitiesWatch_579945; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start receiving notifications for account activities. For more information, see Receiving Push Notifications.
  ## 
  let valid = call_579967.validator(path, query, header, formData, body)
  let scheme = call_579967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579967.url(scheme.get, call_579967.host, call_579967.base,
                         call_579967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579967, url, valid)

proc call*(call_579968: Call_ReportsActivitiesWatch_579945; userKey: string;
          key: string = ""; endTime: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; eventName: string = "";
          applicationName: string = "access_transparency"; startTime: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          actorIpAddress: string = ""; pageToken: string = ""; orgUnitID: string = "";
          filters: string = ""; customerId: string = ""; resource: JsonNode = nil;
          fields: string = ""; maxResults: int = 1000): Recallable =
  ## reportsActivitiesWatch
  ## Start receiving notifications for account activities. For more information, see Receiving Push Notifications.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endTime: string
  ##          : Sets the end of the range of time shown in the report. The date is in the RFC 3339 format, for example 2010-10-28T10:26:35.000Z. The default value is the approximate time of the API request. An API report has three basic time concepts:  
  ## - Date of the API's request for a report: When the API created and retrieved the report. 
  ## - Report's start time: The beginning of the timespan shown in the report. The startTime must be before the endTime (if specified) and the current time when the request is made, or the API returns an error. 
  ## - Report's end time: The end of the timespan shown in the report. For example, the timespan of events summarized in a report can start in April and end in May. The report itself can be requested in August.  If the endTime is not specified, the report returns all activities from the startTime until the current time or the most recent 180 days if the startTime is more than 180 days in the past.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   eventName: string
  ##            : The name of the event being queried by the API. Each eventName is related to a specific G Suite service or feature which the API organizes into types of events. An example is the Google Calendar events in the Admin console application's reports. The Calendar Settings type structure has all of the Calendar eventName activities reported by the API. When an administrator changes a Calendar setting, the API reports this activity in the Calendar Settings type and eventName parameters. For more information about eventName query strings and parameters, see the list of event names for various applications above in applicationName.
  ##   applicationName: string (required)
  ##                  : Application name for which the events are to be retrieved.
  ##   startTime: string
  ##            : Sets the beginning of the range of time shown in the report. The date is in the RFC 3339 format, for example 2010-10-28T10:26:35.000Z. The report returns all activities from startTime until endTime. The startTime must be before the endTime (if specified) and the current time when the request is made, or the API returns an error.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   actorIpAddress: string
  ##                 : The Internet Protocol (IP) Address of host where the event was performed. This is an additional way to filter a report's summary using the IP address of the user whose activity is being reported. This IP address may or may not reflect the user's physical location. For example, the IP address can be the user's proxy server's address or a virtual private network (VPN) address. This parameter supports both IPv4 and IPv6 address versions.
  ##   pageToken: string
  ##            : The token to specify next page. A report with multiple pages has a nextPageToken property in the response. In your follow-on request getting the next page of the report, enter the nextPageToken value in the pageToken query string.
  ##   orgUnitID: string
  ##            : ID of the organizational unit to report on. Activity records will be shown only for users who belong to the specified organizational unit. Data before Dec 17, 2018 doesn't appear in the filtered results.
  ##   filters: string
  ##          : The filters query string is a comma-separated list. The list is composed of event parameters that are manipulated by relational operators. Event parameters are in the form [parameter1 name][relational operator][parameter1 value],[parameter2 name][relational operator][parameter2 value],... 
  ## These event parameters are associated with a specific eventName. An empty report is returned if the filtered request's parameter does not belong to the eventName. For more information about eventName parameters, see the list of event names for various applications above in applicationName.
  ## 
  ## In the following Admin Activity example, the <> operator is URL-encoded in the request's query string (%3C%3E):
  ## GET...&eventName=CHANGE_CALENDAR_SETTING &filters=NEW_VALUE%3C%3EREAD_ONLY_ACCESS
  ## 
  ## In the following Drive example, the list can be a view or edit event's doc_id parameter with a value that is manipulated by an 'equal to' (==) or 'not equal to' (<>) relational operator. In the first example, the report returns each edited document's doc_id. In the second example, the report returns each viewed document's doc_id that equals the value 12345 and does not return any viewed document's which have a doc_id value of 98765. The <> operator is URL-encoded in the request's query string (%3C%3E):
  ## 
  ## GET...&eventName=edit&filters=doc_id GET...&eventName=view&filters=doc_id==12345,doc_id%3C%3E98765
  ## 
  ## The relational operators include:  
  ## - == - 'equal to'. 
  ## - <> - 'not equal to'. It is URL-encoded (%3C%3E). 
  ## - < - 'less than'. It is URL-encoded (%3C). 
  ## - <= - 'less than or equal to'. It is URL-encoded (%3C=). 
  ## - > - 'greater than'. It is URL-encoded (%3E). 
  ## - >= - 'greater than or equal to'. It is URL-encoded (%3E=).  
  ## Note: The API doesn't accept multiple values of a parameter. If a particular parameter is supplied more than once in the API request, the API only accepts the last value of that request parameter.
  ## In addition, if an invalid request parameter is supplied in the API request, the API ignores that request parameter and returns the response corresponding to the remaining valid request parameters. If no parameters are requested, all parameters are returned.
  ##   customerId: string
  ##             : The unique ID of the customer to retrieve data for.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Determines how many activity records are shown on each response page. For example, if the request sets maxResults=1 and the report has two activities, the report has two pages. The response's nextPageToken property has the token to the second page. The maxResults query string is optional in the request. The default value is 1000.
  ##   userKey: string (required)
  ##          : Represents the profile ID or the user email for which the data should be filtered. Can be all for all information, or userKey for a user's unique G Suite profile ID or their primary email address.
  var path_579969 = newJObject()
  var query_579970 = newJObject()
  var body_579971 = newJObject()
  add(query_579970, "key", newJString(key))
  add(query_579970, "endTime", newJString(endTime))
  add(query_579970, "prettyPrint", newJBool(prettyPrint))
  add(query_579970, "oauth_token", newJString(oauthToken))
  add(query_579970, "eventName", newJString(eventName))
  add(path_579969, "applicationName", newJString(applicationName))
  add(query_579970, "startTime", newJString(startTime))
  add(query_579970, "alt", newJString(alt))
  add(query_579970, "userIp", newJString(userIp))
  add(query_579970, "quotaUser", newJString(quotaUser))
  add(query_579970, "actorIpAddress", newJString(actorIpAddress))
  add(query_579970, "pageToken", newJString(pageToken))
  add(query_579970, "orgUnitID", newJString(orgUnitID))
  add(query_579970, "filters", newJString(filters))
  add(query_579970, "customerId", newJString(customerId))
  if resource != nil:
    body_579971 = resource
  add(query_579970, "fields", newJString(fields))
  add(query_579970, "maxResults", newJInt(maxResults))
  add(path_579969, "userKey", newJString(userKey))
  result = call_579968.call(path_579969, query_579970, nil, nil, body_579971)

var reportsActivitiesWatch* = Call_ReportsActivitiesWatch_579945(
    name: "reportsActivitiesWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/activity/users/{userKey}/applications/{applicationName}/watch",
    validator: validate_ReportsActivitiesWatch_579946, base: "/admin/reports/v1",
    url: url_ReportsActivitiesWatch_579947, schemes: {Scheme.Https})
type
  Call_AdminChannelsStop_579972 = ref object of OpenApiRestCall_579380
proc url_AdminChannelsStop_579974(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_AdminChannelsStop_579973(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579975 = query.getOrDefault("key")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "key", valid_579975
  var valid_579976 = query.getOrDefault("prettyPrint")
  valid_579976 = validateParameter(valid_579976, JBool, required = false,
                                 default = newJBool(true))
  if valid_579976 != nil:
    section.add "prettyPrint", valid_579976
  var valid_579977 = query.getOrDefault("oauth_token")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "oauth_token", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("userIp")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "userIp", valid_579979
  var valid_579980 = query.getOrDefault("quotaUser")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "quotaUser", valid_579980
  var valid_579981 = query.getOrDefault("fields")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "fields", valid_579981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579983: Call_AdminChannelsStop_579972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_579983.validator(path, query, header, formData, body)
  let scheme = call_579983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579983.url(scheme.get, call_579983.host, call_579983.base,
                         call_579983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579983, url, valid)

proc call*(call_579984: Call_AdminChannelsStop_579972; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; resource: JsonNode = nil;
          fields: string = ""): Recallable =
  ## adminChannelsStop
  ## Stop watching resources through this channel
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579985 = newJObject()
  var body_579986 = newJObject()
  add(query_579985, "key", newJString(key))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "userIp", newJString(userIp))
  add(query_579985, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_579986 = resource
  add(query_579985, "fields", newJString(fields))
  result = call_579984.call(nil, query_579985, nil, nil, body_579986)

var adminChannelsStop* = Call_AdminChannelsStop_579972(name: "adminChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/admin/reports_v1/channels/stop",
    validator: validate_AdminChannelsStop_579973, base: "/admin/reports/v1",
    url: url_AdminChannelsStop_579974, schemes: {Scheme.Https})
type
  Call_ReportsCustomerUsageReportsGet_579987 = ref object of OpenApiRestCall_579380
proc url_ReportsCustomerUsageReportsGet_579989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "date" in path, "`date` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/usage/dates/"),
               (kind: VariableSegment, value: "date")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReportsCustomerUsageReportsGet_579988(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a report which is a collection of properties and statistics for a specific customer's account. For more information, see the Customers Usage Report guide. For more information about the customer report's parameters, see the Customers Usage parameters reference guides.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   date: JString (required)
  ##       : Represents the date the usage occurred. The timestamp is in the ISO 8601 format, yyyy-mm-dd. We recommend you use your account's time zone for this.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `date` field"
  var valid_579990 = path.getOrDefault("date")
  valid_579990 = validateParameter(valid_579990, JString, required = true,
                                 default = nil)
  if valid_579990 != nil:
    section.add "date", valid_579990
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token to specify next page. A report with multiple pages has a nextPageToken property in the response. For your follow-on requests getting all of the report's pages, enter the nextPageToken value in the pageToken query string.
  ##   customerId: JString
  ##             : The unique ID of the customer to retrieve data for.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   parameters: JString
  ##             : The parameters query string is a comma-separated list of event parameters that refine a report's results. The parameter is associated with a specific application. The application values for the Customers usage report include accounts, app_maker, apps_scripts, calendar, classroom, cros, docs, gmail, gplus, device_management, meet, and sites.
  ## A parameters query string is in the CSV form of app_name1:param_name1, app_name2:param_name2.
  ## Note: The API doesn't accept multiple values of a parameter. If a particular parameter is supplied more than once in the API request, the API only accepts the last value of that request parameter.
  ## In addition, if an invalid request parameter is supplied in the API request, the API ignores that request parameter and returns the response corresponding to the remaining valid request parameters.
  ## 
  ## An example of an invalid request parameter is one that does not belong to the application. If no parameters are requested, all parameters are returned.
  section = newJObject()
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  var valid_579993 = query.getOrDefault("oauth_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "oauth_token", valid_579993
  var valid_579994 = query.getOrDefault("alt")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("json"))
  if valid_579994 != nil:
    section.add "alt", valid_579994
  var valid_579995 = query.getOrDefault("userIp")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "userIp", valid_579995
  var valid_579996 = query.getOrDefault("quotaUser")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "quotaUser", valid_579996
  var valid_579997 = query.getOrDefault("pageToken")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "pageToken", valid_579997
  var valid_579998 = query.getOrDefault("customerId")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "customerId", valid_579998
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  var valid_580000 = query.getOrDefault("parameters")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "parameters", valid_580000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580001: Call_ReportsCustomerUsageReportsGet_579987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties and statistics for a specific customer's account. For more information, see the Customers Usage Report guide. For more information about the customer report's parameters, see the Customers Usage parameters reference guides.
  ## 
  let valid = call_580001.validator(path, query, header, formData, body)
  let scheme = call_580001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580001.url(scheme.get, call_580001.host, call_580001.base,
                         call_580001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580001, url, valid)

proc call*(call_580002: Call_ReportsCustomerUsageReportsGet_579987; date: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; customerId: string = ""; fields: string = "";
          parameters: string = ""): Recallable =
  ## reportsCustomerUsageReportsGet
  ## Retrieves a report which is a collection of properties and statistics for a specific customer's account. For more information, see the Customers Usage Report guide. For more information about the customer report's parameters, see the Customers Usage parameters reference guides.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to specify next page. A report with multiple pages has a nextPageToken property in the response. For your follow-on requests getting all of the report's pages, enter the nextPageToken value in the pageToken query string.
  ##   customerId: string
  ##             : The unique ID of the customer to retrieve data for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   date: string (required)
  ##       : Represents the date the usage occurred. The timestamp is in the ISO 8601 format, yyyy-mm-dd. We recommend you use your account's time zone for this.
  ##   parameters: string
  ##             : The parameters query string is a comma-separated list of event parameters that refine a report's results. The parameter is associated with a specific application. The application values for the Customers usage report include accounts, app_maker, apps_scripts, calendar, classroom, cros, docs, gmail, gplus, device_management, meet, and sites.
  ## A parameters query string is in the CSV form of app_name1:param_name1, app_name2:param_name2.
  ## Note: The API doesn't accept multiple values of a parameter. If a particular parameter is supplied more than once in the API request, the API only accepts the last value of that request parameter.
  ## In addition, if an invalid request parameter is supplied in the API request, the API ignores that request parameter and returns the response corresponding to the remaining valid request parameters.
  ## 
  ## An example of an invalid request parameter is one that does not belong to the application. If no parameters are requested, all parameters are returned.
  var path_580003 = newJObject()
  var query_580004 = newJObject()
  add(query_580004, "key", newJString(key))
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "userIp", newJString(userIp))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(query_580004, "pageToken", newJString(pageToken))
  add(query_580004, "customerId", newJString(customerId))
  add(query_580004, "fields", newJString(fields))
  add(path_580003, "date", newJString(date))
  add(query_580004, "parameters", newJString(parameters))
  result = call_580002.call(path_580003, query_580004, nil, nil, nil)

var reportsCustomerUsageReportsGet* = Call_ReportsCustomerUsageReportsGet_579987(
    name: "reportsCustomerUsageReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/usage/dates/{date}",
    validator: validate_ReportsCustomerUsageReportsGet_579988,
    base: "/admin/reports/v1", url: url_ReportsCustomerUsageReportsGet_579989,
    schemes: {Scheme.Https})
type
  Call_ReportsUserUsageReportGet_580005 = ref object of OpenApiRestCall_579380
proc url_ReportsUserUsageReportGet_580007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  assert "date" in path, "`date` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/usage/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/dates/"),
               (kind: VariableSegment, value: "date")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReportsUserUsageReportGet_580006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a report which is a collection of properties and statistics for a set of users with the account. For more information, see the User Usage Report guide. For more information about the user report's parameters, see the Users Usage parameters reference guides.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   date: JString (required)
  ##       : Represents the date the usage occurred. The timestamp is in the ISO 8601 format, yyyy-mm-dd. We recommend you use your account's time zone for this.
  ##   userKey: JString (required)
  ##          : Represents the profile ID or the user email for which the data should be filtered. Can be all for all information, or userKey for a user's unique G Suite profile ID or their primary email address.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `date` field"
  var valid_580008 = path.getOrDefault("date")
  valid_580008 = validateParameter(valid_580008, JString, required = true,
                                 default = nil)
  if valid_580008 != nil:
    section.add "date", valid_580008
  var valid_580009 = path.getOrDefault("userKey")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "userKey", valid_580009
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   parameters: JString
  ##             : The parameters query string is a comma-separated list of event parameters that refine a report's results. The parameter is associated with a specific application. The application values for the Customers usage report include accounts, app_maker, apps_scripts, calendar, classroom, cros, docs, gmail, gplus, device_management, meet, and sites.
  ## A parameters query string is in the CSV form of app_name1:param_name1, app_name2:param_name2.
  ## Note: The API doesn't accept multiple values of a parameter.
  ## If a particular parameter is supplied more than once in the API request, the API only accepts the last value of that request parameter. In addition, if an invalid request parameter is supplied in the API request, the API ignores that request parameter and returns the response corresponding to the remaining valid request parameters.
  ## 
  ## An example of an invalid request parameter is one that does not belong to the application. If no parameters are requested, all parameters are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token to specify next page. A report with multiple pages has a nextPageToken property in the response. In your follow-on request getting the next page of the report, enter the nextPageToken value in the pageToken query string.
  ##   orgUnitID: JString
  ##            : ID of the organizational unit to report on. User activity will be shown only for users who belong to the specified organizational unit. Data before Dec 17, 2018 doesn't appear in the filtered results.
  ##   filters: JString
  ##          : The filters query string is a comma-separated list of an application's event parameters where the parameter's value is manipulated by a relational operator. The filters query string includes the name of the application whose usage is returned in the report. The application values for the Users Usage Report include accounts, docs, and gmail.
  ## Filters are in the form [application name]:[parameter name][relational operator][parameter value],....
  ## 
  ## In this example, the <> 'not equal to' operator is URL-encoded in the request's query string (%3C%3E):
  ## GET https://www.googleapis.com/admin/reports/v1/usage/users/all/dates/2013-03-03 ?parameters=accounts:last_login_time &filters=accounts:last_login_time>2010-10-28T10:26:35.000Z
  ## 
  ## 
  ## The relational operators include:  
  ## - == - 'equal to'. 
  ## - <> - 'not equal to'. It is URL-encoded (%3C%3E). 
  ## - < - 'less than'. It is URL-encoded (%3C). 
  ## - <= - 'less than or equal to'. It is URL-encoded (%3C=). 
  ## - > - 'greater than'. It is URL-encoded (%3E). 
  ## - >= - 'greater than or equal to'. It is URL-encoded (%3E=).
  ##   customerId: JString
  ##             : The unique ID of the customer to retrieve data for.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Determines how many activity records are shown on each response page. For example, if the request sets maxResults=1 and the report has two activities, the report has two pages. The response's nextPageToken property has the token to the second page.
  ## The maxResults query string is optional.
  section = newJObject()
  var valid_580010 = query.getOrDefault("key")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "key", valid_580010
  var valid_580011 = query.getOrDefault("parameters")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "parameters", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("userIp")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "userIp", valid_580015
  var valid_580016 = query.getOrDefault("quotaUser")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "quotaUser", valid_580016
  var valid_580017 = query.getOrDefault("pageToken")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "pageToken", valid_580017
  var valid_580018 = query.getOrDefault("orgUnitID")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString(""))
  if valid_580018 != nil:
    section.add "orgUnitID", valid_580018
  var valid_580019 = query.getOrDefault("filters")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "filters", valid_580019
  var valid_580020 = query.getOrDefault("customerId")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "customerId", valid_580020
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
  var valid_580022 = query.getOrDefault("maxResults")
  valid_580022 = validateParameter(valid_580022, JInt, required = false,
                                 default = newJInt(1000))
  if valid_580022 != nil:
    section.add "maxResults", valid_580022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580023: Call_ReportsUserUsageReportGet_580005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties and statistics for a set of users with the account. For more information, see the User Usage Report guide. For more information about the user report's parameters, see the Users Usage parameters reference guides.
  ## 
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_ReportsUserUsageReportGet_580005; date: string;
          userKey: string; key: string = ""; parameters: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          orgUnitID: string = ""; filters: string = ""; customerId: string = "";
          fields: string = ""; maxResults: int = 1000): Recallable =
  ## reportsUserUsageReportGet
  ## Retrieves a report which is a collection of properties and statistics for a set of users with the account. For more information, see the User Usage Report guide. For more information about the user report's parameters, see the Users Usage parameters reference guides.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   parameters: string
  ##             : The parameters query string is a comma-separated list of event parameters that refine a report's results. The parameter is associated with a specific application. The application values for the Customers usage report include accounts, app_maker, apps_scripts, calendar, classroom, cros, docs, gmail, gplus, device_management, meet, and sites.
  ## A parameters query string is in the CSV form of app_name1:param_name1, app_name2:param_name2.
  ## Note: The API doesn't accept multiple values of a parameter.
  ## If a particular parameter is supplied more than once in the API request, the API only accepts the last value of that request parameter. In addition, if an invalid request parameter is supplied in the API request, the API ignores that request parameter and returns the response corresponding to the remaining valid request parameters.
  ## 
  ## An example of an invalid request parameter is one that does not belong to the application. If no parameters are requested, all parameters are returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to specify next page. A report with multiple pages has a nextPageToken property in the response. In your follow-on request getting the next page of the report, enter the nextPageToken value in the pageToken query string.
  ##   orgUnitID: string
  ##            : ID of the organizational unit to report on. User activity will be shown only for users who belong to the specified organizational unit. Data before Dec 17, 2018 doesn't appear in the filtered results.
  ##   filters: string
  ##          : The filters query string is a comma-separated list of an application's event parameters where the parameter's value is manipulated by a relational operator. The filters query string includes the name of the application whose usage is returned in the report. The application values for the Users Usage Report include accounts, docs, and gmail.
  ## Filters are in the form [application name]:[parameter name][relational operator][parameter value],....
  ## 
  ## In this example, the <> 'not equal to' operator is URL-encoded in the request's query string (%3C%3E):
  ## GET https://www.googleapis.com/admin/reports/v1/usage/users/all/dates/2013-03-03 ?parameters=accounts:last_login_time &filters=accounts:last_login_time>2010-10-28T10:26:35.000Z
  ## 
  ## 
  ## The relational operators include:  
  ## - == - 'equal to'. 
  ## - <> - 'not equal to'. It is URL-encoded (%3C%3E). 
  ## - < - 'less than'. It is URL-encoded (%3C). 
  ## - <= - 'less than or equal to'. It is URL-encoded (%3C=). 
  ## - > - 'greater than'. It is URL-encoded (%3E). 
  ## - >= - 'greater than or equal to'. It is URL-encoded (%3E=).
  ##   customerId: string
  ##             : The unique ID of the customer to retrieve data for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   date: string (required)
  ##       : Represents the date the usage occurred. The timestamp is in the ISO 8601 format, yyyy-mm-dd. We recommend you use your account's time zone for this.
  ##   maxResults: int
  ##             : Determines how many activity records are shown on each response page. For example, if the request sets maxResults=1 and the report has two activities, the report has two pages. The response's nextPageToken property has the token to the second page.
  ## The maxResults query string is optional.
  ##   userKey: string (required)
  ##          : Represents the profile ID or the user email for which the data should be filtered. Can be all for all information, or userKey for a user's unique G Suite profile ID or their primary email address.
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  add(query_580026, "key", newJString(key))
  add(query_580026, "parameters", newJString(parameters))
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "userIp", newJString(userIp))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(query_580026, "pageToken", newJString(pageToken))
  add(query_580026, "orgUnitID", newJString(orgUnitID))
  add(query_580026, "filters", newJString(filters))
  add(query_580026, "customerId", newJString(customerId))
  add(query_580026, "fields", newJString(fields))
  add(path_580025, "date", newJString(date))
  add(query_580026, "maxResults", newJInt(maxResults))
  add(path_580025, "userKey", newJString(userKey))
  result = call_580024.call(path_580025, query_580026, nil, nil, nil)

var reportsUserUsageReportGet* = Call_ReportsUserUsageReportGet_580005(
    name: "reportsUserUsageReportGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/usage/users/{userKey}/dates/{date}",
    validator: validate_ReportsUserUsageReportGet_580006,
    base: "/admin/reports/v1", url: url_ReportsUserUsageReportGet_580007,
    schemes: {Scheme.Https})
type
  Call_ReportsEntityUsageReportsGet_580027 = ref object of OpenApiRestCall_579380
proc url_ReportsEntityUsageReportsGet_580029(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "entityType" in path, "`entityType` is a required path parameter"
  assert "entityKey" in path, "`entityKey` is a required path parameter"
  assert "date" in path, "`date` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/usage/"),
               (kind: VariableSegment, value: "entityType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "entityKey"),
               (kind: ConstantSegment, value: "/dates/"),
               (kind: VariableSegment, value: "date")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReportsEntityUsageReportsGet_580028(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a report which is a collection of properties and statistics for entities used by users within the account. For more information, see the Entities Usage Report guide. For more information about the entities report's parameters, see the Entities Usage parameters reference guides.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityKey: JString (required)
  ##            : Represents the key of the object to filter the data with.
  ##   entityType: JString (required)
  ##             : Represents the type of entity for the report.
  ##   date: JString (required)
  ##       : Represents the date the usage occurred. The timestamp is in the ISO 8601 format, yyyy-mm-dd. We recommend you use your account's time zone for this.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityKey` field"
  var valid_580030 = path.getOrDefault("entityKey")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = newJString("all"))
  if valid_580030 != nil:
    section.add "entityKey", valid_580030
  var valid_580031 = path.getOrDefault("entityType")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = newJString("gplus_communities"))
  if valid_580031 != nil:
    section.add "entityType", valid_580031
  var valid_580032 = path.getOrDefault("date")
  valid_580032 = validateParameter(valid_580032, JString, required = true,
                                 default = nil)
  if valid_580032 != nil:
    section.add "date", valid_580032
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token to specify next page. A report with multiple pages has a nextPageToken property in the response. In your follow-on request getting the next page of the report, enter the nextPageToken value in the pageToken query string.
  ##   filters: JString
  ##          : The filters query string is a comma-separated list of an application's event parameters where the parameter's value is manipulated by a relational operator. The filters query string includes the name of the application whose usage is returned in the report. The application values for the Entities usage report include accounts, docs, and gmail.
  ## Filters are in the form [application name]:[parameter name][relational operator][parameter value],....
  ## 
  ## In this example, the <> 'not equal to' operator is URL-encoded in the request's query string (%3C%3E):
  ## GET 
  ## https://www.googleapis.com/admin/reports/v1/usage/gplus_communities/all/dates/2017-12-01 ?parameters=gplus:community_name,gplus:num_total_members &filters=gplus:num_total_members>0
  ## 
  ## 
  ## The relational operators include:  
  ## - == - 'equal to'. 
  ## - <> - 'not equal to'. It is URL-encoded (%3C%3E). 
  ## - < - 'less than'. It is URL-encoded (%3C). 
  ## - <= - 'less than or equal to'. It is URL-encoded (%3C=). 
  ## - > - 'greater than'. It is URL-encoded (%3E). 
  ## - >= - 'greater than or equal to'. It is URL-encoded (%3E=).  Filters can only be applied to numeric parameters.
  ##   customerId: JString
  ##             : The unique ID of the customer to retrieve data for.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Determines how many activity records are shown on each response page. For example, if the request sets maxResults=1 and the report has two activities, the report has two pages. The response's nextPageToken property has the token to the second page.
  ##   parameters: JString
  ##             : The parameters query string is a comma-separated list of event parameters that refine a report's results. The parameter is associated with a specific application. The application values for the Entities usage report are only gplus.
  ## A parameter query string is in the CSV form of [app_name1:param_name1], [app_name2:param_name2]....
  ## Note: The API doesn't accept multiple values of a parameter. If a particular parameter is supplied more than once in the API request, the API only accepts the last value of that request parameter.
  ## In addition, if an invalid request parameter is supplied in the API request, the API ignores that request parameter and returns the response corresponding to the remaining valid request parameters.
  ## 
  ## An example of an invalid request parameter is one that does not belong to the application. If no parameters are requested, all parameters are returned.
  section = newJObject()
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
  var valid_580035 = query.getOrDefault("oauth_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "oauth_token", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("userIp")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "userIp", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("pageToken")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "pageToken", valid_580039
  var valid_580040 = query.getOrDefault("filters")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "filters", valid_580040
  var valid_580041 = query.getOrDefault("customerId")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "customerId", valid_580041
  var valid_580042 = query.getOrDefault("fields")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "fields", valid_580042
  var valid_580043 = query.getOrDefault("maxResults")
  valid_580043 = validateParameter(valid_580043, JInt, required = false,
                                 default = newJInt(1000))
  if valid_580043 != nil:
    section.add "maxResults", valid_580043
  var valid_580044 = query.getOrDefault("parameters")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "parameters", valid_580044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580045: Call_ReportsEntityUsageReportsGet_580027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties and statistics for entities used by users within the account. For more information, see the Entities Usage Report guide. For more information about the entities report's parameters, see the Entities Usage parameters reference guides.
  ## 
  let valid = call_580045.validator(path, query, header, formData, body)
  let scheme = call_580045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580045.url(scheme.get, call_580045.host, call_580045.base,
                         call_580045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580045, url, valid)

proc call*(call_580046: Call_ReportsEntityUsageReportsGet_580027; date: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          entityKey: string = "all"; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; filters: string = "";
          customerId: string = ""; entityType: string = "gplus_communities";
          fields: string = ""; maxResults: int = 1000; parameters: string = ""): Recallable =
  ## reportsEntityUsageReportsGet
  ## Retrieves a report which is a collection of properties and statistics for entities used by users within the account. For more information, see the Entities Usage Report guide. For more information about the entities report's parameters, see the Entities Usage parameters reference guides.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   entityKey: string (required)
  ##            : Represents the key of the object to filter the data with.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to specify next page. A report with multiple pages has a nextPageToken property in the response. In your follow-on request getting the next page of the report, enter the nextPageToken value in the pageToken query string.
  ##   filters: string
  ##          : The filters query string is a comma-separated list of an application's event parameters where the parameter's value is manipulated by a relational operator. The filters query string includes the name of the application whose usage is returned in the report. The application values for the Entities usage report include accounts, docs, and gmail.
  ## Filters are in the form [application name]:[parameter name][relational operator][parameter value],....
  ## 
  ## In this example, the <> 'not equal to' operator is URL-encoded in the request's query string (%3C%3E):
  ## GET 
  ## https://www.googleapis.com/admin/reports/v1/usage/gplus_communities/all/dates/2017-12-01 ?parameters=gplus:community_name,gplus:num_total_members &filters=gplus:num_total_members>0
  ## 
  ## 
  ## The relational operators include:  
  ## - == - 'equal to'. 
  ## - <> - 'not equal to'. It is URL-encoded (%3C%3E). 
  ## - < - 'less than'. It is URL-encoded (%3C). 
  ## - <= - 'less than or equal to'. It is URL-encoded (%3C=). 
  ## - > - 'greater than'. It is URL-encoded (%3E). 
  ## - >= - 'greater than or equal to'. It is URL-encoded (%3E=).  Filters can only be applied to numeric parameters.
  ##   customerId: string
  ##             : The unique ID of the customer to retrieve data for.
  ##   entityType: string (required)
  ##             : Represents the type of entity for the report.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   date: string (required)
  ##       : Represents the date the usage occurred. The timestamp is in the ISO 8601 format, yyyy-mm-dd. We recommend you use your account's time zone for this.
  ##   maxResults: int
  ##             : Determines how many activity records are shown on each response page. For example, if the request sets maxResults=1 and the report has two activities, the report has two pages. The response's nextPageToken property has the token to the second page.
  ##   parameters: string
  ##             : The parameters query string is a comma-separated list of event parameters that refine a report's results. The parameter is associated with a specific application. The application values for the Entities usage report are only gplus.
  ## A parameter query string is in the CSV form of [app_name1:param_name1], [app_name2:param_name2]....
  ## Note: The API doesn't accept multiple values of a parameter. If a particular parameter is supplied more than once in the API request, the API only accepts the last value of that request parameter.
  ## In addition, if an invalid request parameter is supplied in the API request, the API ignores that request parameter and returns the response corresponding to the remaining valid request parameters.
  ## 
  ## An example of an invalid request parameter is one that does not belong to the application. If no parameters are requested, all parameters are returned.
  var path_580047 = newJObject()
  var query_580048 = newJObject()
  add(query_580048, "key", newJString(key))
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(path_580047, "entityKey", newJString(entityKey))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "userIp", newJString(userIp))
  add(query_580048, "quotaUser", newJString(quotaUser))
  add(query_580048, "pageToken", newJString(pageToken))
  add(query_580048, "filters", newJString(filters))
  add(query_580048, "customerId", newJString(customerId))
  add(path_580047, "entityType", newJString(entityType))
  add(query_580048, "fields", newJString(fields))
  add(path_580047, "date", newJString(date))
  add(query_580048, "maxResults", newJInt(maxResults))
  add(query_580048, "parameters", newJString(parameters))
  result = call_580046.call(path_580047, query_580048, nil, nil, nil)

var reportsEntityUsageReportsGet* = Call_ReportsEntityUsageReportsGet_580027(
    name: "reportsEntityUsageReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/usage/{entityType}/{entityKey}/dates/{date}",
    validator: validate_ReportsEntityUsageReportsGet_580028,
    base: "/admin/reports/v1", url: url_ReportsEntityUsageReportsGet_580029,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
