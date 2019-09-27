
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
## https://developers.google.com/admin-sdk/reports/
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

  OpenApiRestCall_597424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597424): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "admin"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReportsActivitiesList_597692 = ref object of OpenApiRestCall_597424
proc url_ReportsActivitiesList_597694(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
  result.path = base & hydrated.get

proc validate_ReportsActivitiesList_597693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of activities for a specific customer and application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : Application name for which the events are to be retrieved.
  ##   userKey: JString (required)
  ##          : Represents the profile id or the user email for which the data should be filtered. When 'all' is specified as the userKey, it returns usageReports for all users.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_597820 = path.getOrDefault("applicationName")
  valid_597820 = validateParameter(valid_597820, JString, required = true,
                                 default = nil)
  if valid_597820 != nil:
    section.add "applicationName", valid_597820
  var valid_597821 = path.getOrDefault("userKey")
  valid_597821 = validateParameter(valid_597821, JString, required = true,
                                 default = nil)
  if valid_597821 != nil:
    section.add "userKey", valid_597821
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customerId: JString
  ##             : Represents the customer for which the data is to be fetched.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   endTime: JString
  ##          : Return events which occurred at or before this time.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Number of activity records to be shown in each page.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   filters: JString
  ##          : Event parameters in the form [parameter1 name][operator][parameter1 value],[parameter2 name][operator][parameter2 value],...
  ##   eventName: JString
  ##            : Name of the event being queried.
  ##   actorIpAddress: JString
  ##                 : IP Address of host where the event was performed. Supports both IPv4 and IPv6 addresses.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : Return events which occurred at or after this time.
  ##   orgUnitID: JString
  ##            : the organizational unit's(OU) ID to filter activities from users belonging to a specific OU or one of its sub-OU(s)
  section = newJObject()
  var valid_597822 = query.getOrDefault("fields")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = nil)
  if valid_597822 != nil:
    section.add "fields", valid_597822
  var valid_597823 = query.getOrDefault("pageToken")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "pageToken", valid_597823
  var valid_597824 = query.getOrDefault("quotaUser")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "quotaUser", valid_597824
  var valid_597838 = query.getOrDefault("alt")
  valid_597838 = validateParameter(valid_597838, JString, required = false,
                                 default = newJString("json"))
  if valid_597838 != nil:
    section.add "alt", valid_597838
  var valid_597839 = query.getOrDefault("customerId")
  valid_597839 = validateParameter(valid_597839, JString, required = false,
                                 default = nil)
  if valid_597839 != nil:
    section.add "customerId", valid_597839
  var valid_597840 = query.getOrDefault("oauth_token")
  valid_597840 = validateParameter(valid_597840, JString, required = false,
                                 default = nil)
  if valid_597840 != nil:
    section.add "oauth_token", valid_597840
  var valid_597841 = query.getOrDefault("endTime")
  valid_597841 = validateParameter(valid_597841, JString, required = false,
                                 default = nil)
  if valid_597841 != nil:
    section.add "endTime", valid_597841
  var valid_597842 = query.getOrDefault("userIp")
  valid_597842 = validateParameter(valid_597842, JString, required = false,
                                 default = nil)
  if valid_597842 != nil:
    section.add "userIp", valid_597842
  var valid_597843 = query.getOrDefault("maxResults")
  valid_597843 = validateParameter(valid_597843, JInt, required = false, default = nil)
  if valid_597843 != nil:
    section.add "maxResults", valid_597843
  var valid_597844 = query.getOrDefault("key")
  valid_597844 = validateParameter(valid_597844, JString, required = false,
                                 default = nil)
  if valid_597844 != nil:
    section.add "key", valid_597844
  var valid_597845 = query.getOrDefault("filters")
  valid_597845 = validateParameter(valid_597845, JString, required = false,
                                 default = nil)
  if valid_597845 != nil:
    section.add "filters", valid_597845
  var valid_597846 = query.getOrDefault("eventName")
  valid_597846 = validateParameter(valid_597846, JString, required = false,
                                 default = nil)
  if valid_597846 != nil:
    section.add "eventName", valid_597846
  var valid_597847 = query.getOrDefault("actorIpAddress")
  valid_597847 = validateParameter(valid_597847, JString, required = false,
                                 default = nil)
  if valid_597847 != nil:
    section.add "actorIpAddress", valid_597847
  var valid_597848 = query.getOrDefault("prettyPrint")
  valid_597848 = validateParameter(valid_597848, JBool, required = false,
                                 default = newJBool(true))
  if valid_597848 != nil:
    section.add "prettyPrint", valid_597848
  var valid_597849 = query.getOrDefault("startTime")
  valid_597849 = validateParameter(valid_597849, JString, required = false,
                                 default = nil)
  if valid_597849 != nil:
    section.add "startTime", valid_597849
  var valid_597850 = query.getOrDefault("orgUnitID")
  valid_597850 = validateParameter(valid_597850, JString, required = false,
                                 default = newJString(""))
  if valid_597850 != nil:
    section.add "orgUnitID", valid_597850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597873: Call_ReportsActivitiesList_597692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of activities for a specific customer and application.
  ## 
  let valid = call_597873.validator(path, query, header, formData, body)
  let scheme = call_597873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597873.url(scheme.get, call_597873.host, call_597873.base,
                         call_597873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597873, url, valid)

proc call*(call_597944: Call_ReportsActivitiesList_597692; applicationName: string;
          userKey: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; customerId: string = "";
          oauthToken: string = ""; endTime: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; filters: string = "";
          eventName: string = ""; actorIpAddress: string = ""; prettyPrint: bool = true;
          startTime: string = ""; orgUnitID: string = ""): Recallable =
  ## reportsActivitiesList
  ## Retrieves a list of activities for a specific customer and application.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   applicationName: string (required)
  ##                  : Application name for which the events are to be retrieved.
  ##   alt: string
  ##      : Data format for the response.
  ##   customerId: string
  ##             : Represents the customer for which the data is to be fetched.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   endTime: string
  ##          : Return events which occurred at or before this time.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userKey: string (required)
  ##          : Represents the profile id or the user email for which the data should be filtered. When 'all' is specified as the userKey, it returns usageReports for all users.
  ##   maxResults: int
  ##             : Number of activity records to be shown in each page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   filters: string
  ##          : Event parameters in the form [parameter1 name][operator][parameter1 value],[parameter2 name][operator][parameter2 value],...
  ##   eventName: string
  ##            : Name of the event being queried.
  ##   actorIpAddress: string
  ##                 : IP Address of host where the event was performed. Supports both IPv4 and IPv6 addresses.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : Return events which occurred at or after this time.
  ##   orgUnitID: string
  ##            : the organizational unit's(OU) ID to filter activities from users belonging to a specific OU or one of its sub-OU(s)
  var path_597945 = newJObject()
  var query_597947 = newJObject()
  add(query_597947, "fields", newJString(fields))
  add(query_597947, "pageToken", newJString(pageToken))
  add(query_597947, "quotaUser", newJString(quotaUser))
  add(path_597945, "applicationName", newJString(applicationName))
  add(query_597947, "alt", newJString(alt))
  add(query_597947, "customerId", newJString(customerId))
  add(query_597947, "oauth_token", newJString(oauthToken))
  add(query_597947, "endTime", newJString(endTime))
  add(query_597947, "userIp", newJString(userIp))
  add(path_597945, "userKey", newJString(userKey))
  add(query_597947, "maxResults", newJInt(maxResults))
  add(query_597947, "key", newJString(key))
  add(query_597947, "filters", newJString(filters))
  add(query_597947, "eventName", newJString(eventName))
  add(query_597947, "actorIpAddress", newJString(actorIpAddress))
  add(query_597947, "prettyPrint", newJBool(prettyPrint))
  add(query_597947, "startTime", newJString(startTime))
  add(query_597947, "orgUnitID", newJString(orgUnitID))
  result = call_597944.call(path_597945, query_597947, nil, nil, nil)

var reportsActivitiesList* = Call_ReportsActivitiesList_597692(
    name: "reportsActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activity/users/{userKey}/applications/{applicationName}",
    validator: validate_ReportsActivitiesList_597693, base: "/admin/reports/v1",
    url: url_ReportsActivitiesList_597694, schemes: {Scheme.Https})
type
  Call_ReportsActivitiesWatch_597986 = ref object of OpenApiRestCall_597424
proc url_ReportsActivitiesWatch_597988(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
  result.path = base & hydrated.get

proc validate_ReportsActivitiesWatch_597987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Push changes to activities
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : Application name for which the events are to be retrieved.
  ##   userKey: JString (required)
  ##          : Represents the profile id or the user email for which the data should be filtered. When 'all' is specified as the userKey, it returns usageReports for all users.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_597989 = path.getOrDefault("applicationName")
  valid_597989 = validateParameter(valid_597989, JString, required = true,
                                 default = nil)
  if valid_597989 != nil:
    section.add "applicationName", valid_597989
  var valid_597990 = path.getOrDefault("userKey")
  valid_597990 = validateParameter(valid_597990, JString, required = true,
                                 default = nil)
  if valid_597990 != nil:
    section.add "userKey", valid_597990
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customerId: JString
  ##             : Represents the customer for which the data is to be fetched.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   endTime: JString
  ##          : Return events which occurred at or before this time.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Number of activity records to be shown in each page.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   filters: JString
  ##          : Event parameters in the form [parameter1 name][operator][parameter1 value],[parameter2 name][operator][parameter2 value],...
  ##   eventName: JString
  ##            : Name of the event being queried.
  ##   actorIpAddress: JString
  ##                 : IP Address of host where the event was performed. Supports both IPv4 and IPv6 addresses.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : Return events which occurred at or after this time.
  ##   orgUnitID: JString
  ##            : the organizational unit's(OU) ID to filter activities from users belonging to a specific OU or one of its sub-OU(s)
  section = newJObject()
  var valid_597991 = query.getOrDefault("fields")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "fields", valid_597991
  var valid_597992 = query.getOrDefault("pageToken")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "pageToken", valid_597992
  var valid_597993 = query.getOrDefault("quotaUser")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "quotaUser", valid_597993
  var valid_597994 = query.getOrDefault("alt")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = newJString("json"))
  if valid_597994 != nil:
    section.add "alt", valid_597994
  var valid_597995 = query.getOrDefault("customerId")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "customerId", valid_597995
  var valid_597996 = query.getOrDefault("oauth_token")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "oauth_token", valid_597996
  var valid_597997 = query.getOrDefault("endTime")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "endTime", valid_597997
  var valid_597998 = query.getOrDefault("userIp")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "userIp", valid_597998
  var valid_597999 = query.getOrDefault("maxResults")
  valid_597999 = validateParameter(valid_597999, JInt, required = false, default = nil)
  if valid_597999 != nil:
    section.add "maxResults", valid_597999
  var valid_598000 = query.getOrDefault("key")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "key", valid_598000
  var valid_598001 = query.getOrDefault("filters")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "filters", valid_598001
  var valid_598002 = query.getOrDefault("eventName")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "eventName", valid_598002
  var valid_598003 = query.getOrDefault("actorIpAddress")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "actorIpAddress", valid_598003
  var valid_598004 = query.getOrDefault("prettyPrint")
  valid_598004 = validateParameter(valid_598004, JBool, required = false,
                                 default = newJBool(true))
  if valid_598004 != nil:
    section.add "prettyPrint", valid_598004
  var valid_598005 = query.getOrDefault("startTime")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "startTime", valid_598005
  var valid_598006 = query.getOrDefault("orgUnitID")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = newJString(""))
  if valid_598006 != nil:
    section.add "orgUnitID", valid_598006
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

proc call*(call_598008: Call_ReportsActivitiesWatch_597986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Push changes to activities
  ## 
  let valid = call_598008.validator(path, query, header, formData, body)
  let scheme = call_598008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598008.url(scheme.get, call_598008.host, call_598008.base,
                         call_598008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598008, url, valid)

proc call*(call_598009: Call_ReportsActivitiesWatch_597986;
          applicationName: string; userKey: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          customerId: string = ""; oauthToken: string = ""; endTime: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = ""; filters: string = "";
          resource: JsonNode = nil; eventName: string = ""; actorIpAddress: string = "";
          prettyPrint: bool = true; startTime: string = ""; orgUnitID: string = ""): Recallable =
  ## reportsActivitiesWatch
  ## Push changes to activities
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   applicationName: string (required)
  ##                  : Application name for which the events are to be retrieved.
  ##   alt: string
  ##      : Data format for the response.
  ##   customerId: string
  ##             : Represents the customer for which the data is to be fetched.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   endTime: string
  ##          : Return events which occurred at or before this time.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userKey: string (required)
  ##          : Represents the profile id or the user email for which the data should be filtered. When 'all' is specified as the userKey, it returns usageReports for all users.
  ##   maxResults: int
  ##             : Number of activity records to be shown in each page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   filters: string
  ##          : Event parameters in the form [parameter1 name][operator][parameter1 value],[parameter2 name][operator][parameter2 value],...
  ##   resource: JObject
  ##   eventName: string
  ##            : Name of the event being queried.
  ##   actorIpAddress: string
  ##                 : IP Address of host where the event was performed. Supports both IPv4 and IPv6 addresses.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : Return events which occurred at or after this time.
  ##   orgUnitID: string
  ##            : the organizational unit's(OU) ID to filter activities from users belonging to a specific OU or one of its sub-OU(s)
  var path_598010 = newJObject()
  var query_598011 = newJObject()
  var body_598012 = newJObject()
  add(query_598011, "fields", newJString(fields))
  add(query_598011, "pageToken", newJString(pageToken))
  add(query_598011, "quotaUser", newJString(quotaUser))
  add(path_598010, "applicationName", newJString(applicationName))
  add(query_598011, "alt", newJString(alt))
  add(query_598011, "customerId", newJString(customerId))
  add(query_598011, "oauth_token", newJString(oauthToken))
  add(query_598011, "endTime", newJString(endTime))
  add(query_598011, "userIp", newJString(userIp))
  add(path_598010, "userKey", newJString(userKey))
  add(query_598011, "maxResults", newJInt(maxResults))
  add(query_598011, "key", newJString(key))
  add(query_598011, "filters", newJString(filters))
  if resource != nil:
    body_598012 = resource
  add(query_598011, "eventName", newJString(eventName))
  add(query_598011, "actorIpAddress", newJString(actorIpAddress))
  add(query_598011, "prettyPrint", newJBool(prettyPrint))
  add(query_598011, "startTime", newJString(startTime))
  add(query_598011, "orgUnitID", newJString(orgUnitID))
  result = call_598009.call(path_598010, query_598011, nil, nil, body_598012)

var reportsActivitiesWatch* = Call_ReportsActivitiesWatch_597986(
    name: "reportsActivitiesWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/activity/users/{userKey}/applications/{applicationName}/watch",
    validator: validate_ReportsActivitiesWatch_597987, base: "/admin/reports/v1",
    url: url_ReportsActivitiesWatch_597988, schemes: {Scheme.Https})
type
  Call_AdminChannelsStop_598013 = ref object of OpenApiRestCall_597424
proc url_AdminChannelsStop_598015(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdminChannelsStop_598014(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598016 = query.getOrDefault("fields")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "fields", valid_598016
  var valid_598017 = query.getOrDefault("quotaUser")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "quotaUser", valid_598017
  var valid_598018 = query.getOrDefault("alt")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = newJString("json"))
  if valid_598018 != nil:
    section.add "alt", valid_598018
  var valid_598019 = query.getOrDefault("oauth_token")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "oauth_token", valid_598019
  var valid_598020 = query.getOrDefault("userIp")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "userIp", valid_598020
  var valid_598021 = query.getOrDefault("key")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "key", valid_598021
  var valid_598022 = query.getOrDefault("prettyPrint")
  valid_598022 = validateParameter(valid_598022, JBool, required = false,
                                 default = newJBool(true))
  if valid_598022 != nil:
    section.add "prettyPrint", valid_598022
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

proc call*(call_598024: Call_AdminChannelsStop_598013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_598024.validator(path, query, header, formData, body)
  let scheme = call_598024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598024.url(scheme.get, call_598024.host, call_598024.base,
                         call_598024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598024, url, valid)

proc call*(call_598025: Call_AdminChannelsStop_598013; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adminChannelsStop
  ## Stop watching resources through this channel
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598026 = newJObject()
  var body_598027 = newJObject()
  add(query_598026, "fields", newJString(fields))
  add(query_598026, "quotaUser", newJString(quotaUser))
  add(query_598026, "alt", newJString(alt))
  add(query_598026, "oauth_token", newJString(oauthToken))
  add(query_598026, "userIp", newJString(userIp))
  add(query_598026, "key", newJString(key))
  if resource != nil:
    body_598027 = resource
  add(query_598026, "prettyPrint", newJBool(prettyPrint))
  result = call_598025.call(nil, query_598026, nil, nil, body_598027)

var adminChannelsStop* = Call_AdminChannelsStop_598013(name: "adminChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/admin/reports_v1/channels/stop",
    validator: validate_AdminChannelsStop_598014, base: "/admin/reports/v1",
    url: url_AdminChannelsStop_598015, schemes: {Scheme.Https})
type
  Call_ReportsCustomerUsageReportsGet_598028 = ref object of OpenApiRestCall_597424
proc url_ReportsCustomerUsageReportsGet_598030(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "date" in path, "`date` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/usage/dates/"),
               (kind: VariableSegment, value: "date")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsCustomerUsageReportsGet_598029(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a report which is a collection of properties / statistics for a specific customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   date: JString (required)
  ##       : Represents the date in yyyy-mm-dd format for which the data is to be fetched.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `date` field"
  var valid_598031 = path.getOrDefault("date")
  valid_598031 = validateParameter(valid_598031, JString, required = true,
                                 default = nil)
  if valid_598031 != nil:
    section.add "date", valid_598031
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customerId: JString
  ##             : Represents the customer for which the data is to be fetched.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   parameters: JString
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
  section = newJObject()
  var valid_598032 = query.getOrDefault("fields")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "fields", valid_598032
  var valid_598033 = query.getOrDefault("pageToken")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "pageToken", valid_598033
  var valid_598034 = query.getOrDefault("quotaUser")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "quotaUser", valid_598034
  var valid_598035 = query.getOrDefault("alt")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = newJString("json"))
  if valid_598035 != nil:
    section.add "alt", valid_598035
  var valid_598036 = query.getOrDefault("customerId")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "customerId", valid_598036
  var valid_598037 = query.getOrDefault("oauth_token")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "oauth_token", valid_598037
  var valid_598038 = query.getOrDefault("userIp")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "userIp", valid_598038
  var valid_598039 = query.getOrDefault("key")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "key", valid_598039
  var valid_598040 = query.getOrDefault("prettyPrint")
  valid_598040 = validateParameter(valid_598040, JBool, required = false,
                                 default = newJBool(true))
  if valid_598040 != nil:
    section.add "prettyPrint", valid_598040
  var valid_598041 = query.getOrDefault("parameters")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "parameters", valid_598041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598042: Call_ReportsCustomerUsageReportsGet_598028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a specific customer.
  ## 
  let valid = call_598042.validator(path, query, header, formData, body)
  let scheme = call_598042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598042.url(scheme.get, call_598042.host, call_598042.base,
                         call_598042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598042, url, valid)

proc call*(call_598043: Call_ReportsCustomerUsageReportsGet_598028; date: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; customerId: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          parameters: string = ""): Recallable =
  ## reportsCustomerUsageReportsGet
  ## Retrieves a report which is a collection of properties / statistics for a specific customer.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customerId: string
  ##             : Represents the customer for which the data is to be fetched.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   date: string (required)
  ##       : Represents the date in yyyy-mm-dd format for which the data is to be fetched.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   parameters: string
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
  var path_598044 = newJObject()
  var query_598045 = newJObject()
  add(query_598045, "fields", newJString(fields))
  add(query_598045, "pageToken", newJString(pageToken))
  add(query_598045, "quotaUser", newJString(quotaUser))
  add(query_598045, "alt", newJString(alt))
  add(query_598045, "customerId", newJString(customerId))
  add(query_598045, "oauth_token", newJString(oauthToken))
  add(query_598045, "userIp", newJString(userIp))
  add(query_598045, "key", newJString(key))
  add(path_598044, "date", newJString(date))
  add(query_598045, "prettyPrint", newJBool(prettyPrint))
  add(query_598045, "parameters", newJString(parameters))
  result = call_598043.call(path_598044, query_598045, nil, nil, nil)

var reportsCustomerUsageReportsGet* = Call_ReportsCustomerUsageReportsGet_598028(
    name: "reportsCustomerUsageReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/usage/dates/{date}",
    validator: validate_ReportsCustomerUsageReportsGet_598029,
    base: "/admin/reports/v1", url: url_ReportsCustomerUsageReportsGet_598030,
    schemes: {Scheme.Https})
type
  Call_ReportsUserUsageReportGet_598046 = ref object of OpenApiRestCall_597424
proc url_ReportsUserUsageReportGet_598048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
  result.path = base & hydrated.get

proc validate_ReportsUserUsageReportGet_598047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a report which is a collection of properties / statistics for a set of users.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Represents the profile id or the user email for which the data should be filtered.
  ##   date: JString (required)
  ##       : Represents the date in yyyy-mm-dd format for which the data is to be fetched.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_598049 = path.getOrDefault("userKey")
  valid_598049 = validateParameter(valid_598049, JString, required = true,
                                 default = nil)
  if valid_598049 != nil:
    section.add "userKey", valid_598049
  var valid_598050 = path.getOrDefault("date")
  valid_598050 = validateParameter(valid_598050, JString, required = true,
                                 default = nil)
  if valid_598050 != nil:
    section.add "date", valid_598050
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customerId: JString
  ##             : Represents the customer for which the data is to be fetched.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Maximum allowed is 1000
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   filters: JString
  ##          : Represents the set of filters including parameter operator value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   orgUnitID: JString
  ##            : the organizational unit's ID to filter usage parameters from users belonging to a specific OU or one of its sub-OU(s).
  ##   parameters: JString
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
  section = newJObject()
  var valid_598051 = query.getOrDefault("fields")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "fields", valid_598051
  var valid_598052 = query.getOrDefault("pageToken")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "pageToken", valid_598052
  var valid_598053 = query.getOrDefault("quotaUser")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "quotaUser", valid_598053
  var valid_598054 = query.getOrDefault("alt")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = newJString("json"))
  if valid_598054 != nil:
    section.add "alt", valid_598054
  var valid_598055 = query.getOrDefault("customerId")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "customerId", valid_598055
  var valid_598056 = query.getOrDefault("oauth_token")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "oauth_token", valid_598056
  var valid_598057 = query.getOrDefault("userIp")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "userIp", valid_598057
  var valid_598058 = query.getOrDefault("maxResults")
  valid_598058 = validateParameter(valid_598058, JInt, required = false, default = nil)
  if valid_598058 != nil:
    section.add "maxResults", valid_598058
  var valid_598059 = query.getOrDefault("key")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "key", valid_598059
  var valid_598060 = query.getOrDefault("filters")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "filters", valid_598060
  var valid_598061 = query.getOrDefault("prettyPrint")
  valid_598061 = validateParameter(valid_598061, JBool, required = false,
                                 default = newJBool(true))
  if valid_598061 != nil:
    section.add "prettyPrint", valid_598061
  var valid_598062 = query.getOrDefault("orgUnitID")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = newJString(""))
  if valid_598062 != nil:
    section.add "orgUnitID", valid_598062
  var valid_598063 = query.getOrDefault("parameters")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "parameters", valid_598063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598064: Call_ReportsUserUsageReportGet_598046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a set of users.
  ## 
  let valid = call_598064.validator(path, query, header, formData, body)
  let scheme = call_598064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598064.url(scheme.get, call_598064.host, call_598064.base,
                         call_598064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598064, url, valid)

proc call*(call_598065: Call_ReportsUserUsageReportGet_598046; userKey: string;
          date: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; customerId: string = "";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; filters: string = ""; prettyPrint: bool = true;
          orgUnitID: string = ""; parameters: string = ""): Recallable =
  ## reportsUserUsageReportGet
  ## Retrieves a report which is a collection of properties / statistics for a set of users.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customerId: string
  ##             : Represents the customer for which the data is to be fetched.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userKey: string (required)
  ##          : Represents the profile id or the user email for which the data should be filtered.
  ##   maxResults: int
  ##             : Maximum number of results to return. Maximum allowed is 1000
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   filters: string
  ##          : Represents the set of filters including parameter operator value.
  ##   date: string (required)
  ##       : Represents the date in yyyy-mm-dd format for which the data is to be fetched.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   orgUnitID: string
  ##            : the organizational unit's ID to filter usage parameters from users belonging to a specific OU or one of its sub-OU(s).
  ##   parameters: string
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
  var path_598066 = newJObject()
  var query_598067 = newJObject()
  add(query_598067, "fields", newJString(fields))
  add(query_598067, "pageToken", newJString(pageToken))
  add(query_598067, "quotaUser", newJString(quotaUser))
  add(query_598067, "alt", newJString(alt))
  add(query_598067, "customerId", newJString(customerId))
  add(query_598067, "oauth_token", newJString(oauthToken))
  add(query_598067, "userIp", newJString(userIp))
  add(path_598066, "userKey", newJString(userKey))
  add(query_598067, "maxResults", newJInt(maxResults))
  add(query_598067, "key", newJString(key))
  add(query_598067, "filters", newJString(filters))
  add(path_598066, "date", newJString(date))
  add(query_598067, "prettyPrint", newJBool(prettyPrint))
  add(query_598067, "orgUnitID", newJString(orgUnitID))
  add(query_598067, "parameters", newJString(parameters))
  result = call_598065.call(path_598066, query_598067, nil, nil, nil)

var reportsUserUsageReportGet* = Call_ReportsUserUsageReportGet_598046(
    name: "reportsUserUsageReportGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/usage/users/{userKey}/dates/{date}",
    validator: validate_ReportsUserUsageReportGet_598047,
    base: "/admin/reports/v1", url: url_ReportsUserUsageReportGet_598048,
    schemes: {Scheme.Https})
type
  Call_ReportsEntityUsageReportsGet_598068 = ref object of OpenApiRestCall_597424
proc url_ReportsEntityUsageReportsGet_598070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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
  result.path = base & hydrated.get

proc validate_ReportsEntityUsageReportsGet_598069(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a report which is a collection of properties / statistics for a set of objects.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityType: JString (required)
  ##             : Type of object. Should be one of - gplus_communities.
  ##   entityKey: JString (required)
  ##            : Represents the key of object for which the data should be filtered.
  ##   date: JString (required)
  ##       : Represents the date in yyyy-mm-dd format for which the data is to be fetched.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `entityType` field"
  var valid_598071 = path.getOrDefault("entityType")
  valid_598071 = validateParameter(valid_598071, JString, required = true,
                                 default = nil)
  if valid_598071 != nil:
    section.add "entityType", valid_598071
  var valid_598072 = path.getOrDefault("entityKey")
  valid_598072 = validateParameter(valid_598072, JString, required = true,
                                 default = nil)
  if valid_598072 != nil:
    section.add "entityKey", valid_598072
  var valid_598073 = path.getOrDefault("date")
  valid_598073 = validateParameter(valid_598073, JString, required = true,
                                 default = nil)
  if valid_598073 != nil:
    section.add "date", valid_598073
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customerId: JString
  ##             : Represents the customer for which the data is to be fetched.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Maximum allowed is 1000
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   filters: JString
  ##          : Represents the set of filters including parameter operator value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   parameters: JString
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
  section = newJObject()
  var valid_598074 = query.getOrDefault("fields")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "fields", valid_598074
  var valid_598075 = query.getOrDefault("pageToken")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "pageToken", valid_598075
  var valid_598076 = query.getOrDefault("quotaUser")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "quotaUser", valid_598076
  var valid_598077 = query.getOrDefault("alt")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = newJString("json"))
  if valid_598077 != nil:
    section.add "alt", valid_598077
  var valid_598078 = query.getOrDefault("customerId")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "customerId", valid_598078
  var valid_598079 = query.getOrDefault("oauth_token")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "oauth_token", valid_598079
  var valid_598080 = query.getOrDefault("userIp")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "userIp", valid_598080
  var valid_598081 = query.getOrDefault("maxResults")
  valid_598081 = validateParameter(valid_598081, JInt, required = false, default = nil)
  if valid_598081 != nil:
    section.add "maxResults", valid_598081
  var valid_598082 = query.getOrDefault("key")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "key", valid_598082
  var valid_598083 = query.getOrDefault("filters")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "filters", valid_598083
  var valid_598084 = query.getOrDefault("prettyPrint")
  valid_598084 = validateParameter(valid_598084, JBool, required = false,
                                 default = newJBool(true))
  if valid_598084 != nil:
    section.add "prettyPrint", valid_598084
  var valid_598085 = query.getOrDefault("parameters")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "parameters", valid_598085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598086: Call_ReportsEntityUsageReportsGet_598068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a set of objects.
  ## 
  let valid = call_598086.validator(path, query, header, formData, body)
  let scheme = call_598086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598086.url(scheme.get, call_598086.host, call_598086.base,
                         call_598086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598086, url, valid)

proc call*(call_598087: Call_ReportsEntityUsageReportsGet_598068;
          entityType: string; entityKey: string; date: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          customerId: string = ""; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; filters: string = "";
          prettyPrint: bool = true; parameters: string = ""): Recallable =
  ## reportsEntityUsageReportsGet
  ## Retrieves a report which is a collection of properties / statistics for a set of objects.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customerId: string
  ##             : Represents the customer for which the data is to be fetched.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return. Maximum allowed is 1000
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   entityType: string (required)
  ##             : Type of object. Should be one of - gplus_communities.
  ##   entityKey: string (required)
  ##            : Represents the key of object for which the data should be filtered.
  ##   filters: string
  ##          : Represents the set of filters including parameter operator value.
  ##   date: string (required)
  ##       : Represents the date in yyyy-mm-dd format for which the data is to be fetched.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   parameters: string
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
  var path_598088 = newJObject()
  var query_598089 = newJObject()
  add(query_598089, "fields", newJString(fields))
  add(query_598089, "pageToken", newJString(pageToken))
  add(query_598089, "quotaUser", newJString(quotaUser))
  add(query_598089, "alt", newJString(alt))
  add(query_598089, "customerId", newJString(customerId))
  add(query_598089, "oauth_token", newJString(oauthToken))
  add(query_598089, "userIp", newJString(userIp))
  add(query_598089, "maxResults", newJInt(maxResults))
  add(query_598089, "key", newJString(key))
  add(path_598088, "entityType", newJString(entityType))
  add(path_598088, "entityKey", newJString(entityKey))
  add(query_598089, "filters", newJString(filters))
  add(path_598088, "date", newJString(date))
  add(query_598089, "prettyPrint", newJBool(prettyPrint))
  add(query_598089, "parameters", newJString(parameters))
  result = call_598087.call(path_598088, query_598089, nil, nil, nil)

var reportsEntityUsageReportsGet* = Call_ReportsEntityUsageReportsGet_598068(
    name: "reportsEntityUsageReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/usage/{entityType}/{entityKey}/dates/{date}",
    validator: validate_ReportsEntityUsageReportsGet_598069,
    base: "/admin/reports/v1", url: url_ReportsEntityUsageReportsGet_598070,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
