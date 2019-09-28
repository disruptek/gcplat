
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReportsActivitiesList_579692 = ref object of OpenApiRestCall_579424
proc url_ReportsActivitiesList_579694(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_ReportsActivitiesList_579693(path: JsonNode; query: JsonNode;
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
  var valid_579820 = path.getOrDefault("applicationName")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "applicationName", valid_579820
  var valid_579821 = path.getOrDefault("userKey")
  valid_579821 = validateParameter(valid_579821, JString, required = true,
                                 default = nil)
  if valid_579821 != nil:
    section.add "userKey", valid_579821
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
  var valid_579822 = query.getOrDefault("fields")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "fields", valid_579822
  var valid_579823 = query.getOrDefault("pageToken")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "pageToken", valid_579823
  var valid_579824 = query.getOrDefault("quotaUser")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "quotaUser", valid_579824
  var valid_579838 = query.getOrDefault("alt")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = newJString("json"))
  if valid_579838 != nil:
    section.add "alt", valid_579838
  var valid_579839 = query.getOrDefault("customerId")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "customerId", valid_579839
  var valid_579840 = query.getOrDefault("oauth_token")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "oauth_token", valid_579840
  var valid_579841 = query.getOrDefault("endTime")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "endTime", valid_579841
  var valid_579842 = query.getOrDefault("userIp")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "userIp", valid_579842
  var valid_579843 = query.getOrDefault("maxResults")
  valid_579843 = validateParameter(valid_579843, JInt, required = false, default = nil)
  if valid_579843 != nil:
    section.add "maxResults", valid_579843
  var valid_579844 = query.getOrDefault("key")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "key", valid_579844
  var valid_579845 = query.getOrDefault("filters")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = nil)
  if valid_579845 != nil:
    section.add "filters", valid_579845
  var valid_579846 = query.getOrDefault("eventName")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "eventName", valid_579846
  var valid_579847 = query.getOrDefault("actorIpAddress")
  valid_579847 = validateParameter(valid_579847, JString, required = false,
                                 default = nil)
  if valid_579847 != nil:
    section.add "actorIpAddress", valid_579847
  var valid_579848 = query.getOrDefault("prettyPrint")
  valid_579848 = validateParameter(valid_579848, JBool, required = false,
                                 default = newJBool(true))
  if valid_579848 != nil:
    section.add "prettyPrint", valid_579848
  var valid_579849 = query.getOrDefault("startTime")
  valid_579849 = validateParameter(valid_579849, JString, required = false,
                                 default = nil)
  if valid_579849 != nil:
    section.add "startTime", valid_579849
  var valid_579850 = query.getOrDefault("orgUnitID")
  valid_579850 = validateParameter(valid_579850, JString, required = false,
                                 default = newJString(""))
  if valid_579850 != nil:
    section.add "orgUnitID", valid_579850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579873: Call_ReportsActivitiesList_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of activities for a specific customer and application.
  ## 
  let valid = call_579873.validator(path, query, header, formData, body)
  let scheme = call_579873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579873.url(scheme.get, call_579873.host, call_579873.base,
                         call_579873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579873, url, valid)

proc call*(call_579944: Call_ReportsActivitiesList_579692; applicationName: string;
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
  var path_579945 = newJObject()
  var query_579947 = newJObject()
  add(query_579947, "fields", newJString(fields))
  add(query_579947, "pageToken", newJString(pageToken))
  add(query_579947, "quotaUser", newJString(quotaUser))
  add(path_579945, "applicationName", newJString(applicationName))
  add(query_579947, "alt", newJString(alt))
  add(query_579947, "customerId", newJString(customerId))
  add(query_579947, "oauth_token", newJString(oauthToken))
  add(query_579947, "endTime", newJString(endTime))
  add(query_579947, "userIp", newJString(userIp))
  add(path_579945, "userKey", newJString(userKey))
  add(query_579947, "maxResults", newJInt(maxResults))
  add(query_579947, "key", newJString(key))
  add(query_579947, "filters", newJString(filters))
  add(query_579947, "eventName", newJString(eventName))
  add(query_579947, "actorIpAddress", newJString(actorIpAddress))
  add(query_579947, "prettyPrint", newJBool(prettyPrint))
  add(query_579947, "startTime", newJString(startTime))
  add(query_579947, "orgUnitID", newJString(orgUnitID))
  result = call_579944.call(path_579945, query_579947, nil, nil, nil)

var reportsActivitiesList* = Call_ReportsActivitiesList_579692(
    name: "reportsActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activity/users/{userKey}/applications/{applicationName}",
    validator: validate_ReportsActivitiesList_579693, base: "/admin/reports/v1",
    url: url_ReportsActivitiesList_579694, schemes: {Scheme.Https})
type
  Call_ReportsActivitiesWatch_579986 = ref object of OpenApiRestCall_579424
proc url_ReportsActivitiesWatch_579988(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_ReportsActivitiesWatch_579987(path: JsonNode; query: JsonNode;
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
  var valid_579989 = path.getOrDefault("applicationName")
  valid_579989 = validateParameter(valid_579989, JString, required = true,
                                 default = nil)
  if valid_579989 != nil:
    section.add "applicationName", valid_579989
  var valid_579990 = path.getOrDefault("userKey")
  valid_579990 = validateParameter(valid_579990, JString, required = true,
                                 default = nil)
  if valid_579990 != nil:
    section.add "userKey", valid_579990
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
  var valid_579991 = query.getOrDefault("fields")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "fields", valid_579991
  var valid_579992 = query.getOrDefault("pageToken")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "pageToken", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("alt")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("json"))
  if valid_579994 != nil:
    section.add "alt", valid_579994
  var valid_579995 = query.getOrDefault("customerId")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "customerId", valid_579995
  var valid_579996 = query.getOrDefault("oauth_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "oauth_token", valid_579996
  var valid_579997 = query.getOrDefault("endTime")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "endTime", valid_579997
  var valid_579998 = query.getOrDefault("userIp")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "userIp", valid_579998
  var valid_579999 = query.getOrDefault("maxResults")
  valid_579999 = validateParameter(valid_579999, JInt, required = false, default = nil)
  if valid_579999 != nil:
    section.add "maxResults", valid_579999
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("filters")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "filters", valid_580001
  var valid_580002 = query.getOrDefault("eventName")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "eventName", valid_580002
  var valid_580003 = query.getOrDefault("actorIpAddress")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "actorIpAddress", valid_580003
  var valid_580004 = query.getOrDefault("prettyPrint")
  valid_580004 = validateParameter(valid_580004, JBool, required = false,
                                 default = newJBool(true))
  if valid_580004 != nil:
    section.add "prettyPrint", valid_580004
  var valid_580005 = query.getOrDefault("startTime")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "startTime", valid_580005
  var valid_580006 = query.getOrDefault("orgUnitID")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = newJString(""))
  if valid_580006 != nil:
    section.add "orgUnitID", valid_580006
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

proc call*(call_580008: Call_ReportsActivitiesWatch_579986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Push changes to activities
  ## 
  let valid = call_580008.validator(path, query, header, formData, body)
  let scheme = call_580008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580008.url(scheme.get, call_580008.host, call_580008.base,
                         call_580008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580008, url, valid)

proc call*(call_580009: Call_ReportsActivitiesWatch_579986;
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
  var path_580010 = newJObject()
  var query_580011 = newJObject()
  var body_580012 = newJObject()
  add(query_580011, "fields", newJString(fields))
  add(query_580011, "pageToken", newJString(pageToken))
  add(query_580011, "quotaUser", newJString(quotaUser))
  add(path_580010, "applicationName", newJString(applicationName))
  add(query_580011, "alt", newJString(alt))
  add(query_580011, "customerId", newJString(customerId))
  add(query_580011, "oauth_token", newJString(oauthToken))
  add(query_580011, "endTime", newJString(endTime))
  add(query_580011, "userIp", newJString(userIp))
  add(path_580010, "userKey", newJString(userKey))
  add(query_580011, "maxResults", newJInt(maxResults))
  add(query_580011, "key", newJString(key))
  add(query_580011, "filters", newJString(filters))
  if resource != nil:
    body_580012 = resource
  add(query_580011, "eventName", newJString(eventName))
  add(query_580011, "actorIpAddress", newJString(actorIpAddress))
  add(query_580011, "prettyPrint", newJBool(prettyPrint))
  add(query_580011, "startTime", newJString(startTime))
  add(query_580011, "orgUnitID", newJString(orgUnitID))
  result = call_580009.call(path_580010, query_580011, nil, nil, body_580012)

var reportsActivitiesWatch* = Call_ReportsActivitiesWatch_579986(
    name: "reportsActivitiesWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/activity/users/{userKey}/applications/{applicationName}/watch",
    validator: validate_ReportsActivitiesWatch_579987, base: "/admin/reports/v1",
    url: url_ReportsActivitiesWatch_579988, schemes: {Scheme.Https})
type
  Call_AdminChannelsStop_580013 = ref object of OpenApiRestCall_579424
proc url_AdminChannelsStop_580015(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdminChannelsStop_580014(path: JsonNode; query: JsonNode;
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
  var valid_580016 = query.getOrDefault("fields")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "fields", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("alt")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("json"))
  if valid_580018 != nil:
    section.add "alt", valid_580018
  var valid_580019 = query.getOrDefault("oauth_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "oauth_token", valid_580019
  var valid_580020 = query.getOrDefault("userIp")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "userIp", valid_580020
  var valid_580021 = query.getOrDefault("key")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "key", valid_580021
  var valid_580022 = query.getOrDefault("prettyPrint")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(true))
  if valid_580022 != nil:
    section.add "prettyPrint", valid_580022
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

proc call*(call_580024: Call_AdminChannelsStop_580013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_AdminChannelsStop_580013; fields: string = "";
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
  var query_580026 = newJObject()
  var body_580027 = newJObject()
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "userIp", newJString(userIp))
  add(query_580026, "key", newJString(key))
  if resource != nil:
    body_580027 = resource
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  result = call_580025.call(nil, query_580026, nil, nil, body_580027)

var adminChannelsStop* = Call_AdminChannelsStop_580013(name: "adminChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/admin/reports_v1/channels/stop",
    validator: validate_AdminChannelsStop_580014, base: "/admin/reports/v1",
    url: url_AdminChannelsStop_580015, schemes: {Scheme.Https})
type
  Call_ReportsCustomerUsageReportsGet_580028 = ref object of OpenApiRestCall_579424
proc url_ReportsCustomerUsageReportsGet_580030(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_ReportsCustomerUsageReportsGet_580029(path: JsonNode;
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
  var valid_580031 = path.getOrDefault("date")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "date", valid_580031
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
  var valid_580032 = query.getOrDefault("fields")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "fields", valid_580032
  var valid_580033 = query.getOrDefault("pageToken")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "pageToken", valid_580033
  var valid_580034 = query.getOrDefault("quotaUser")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "quotaUser", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("customerId")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "customerId", valid_580036
  var valid_580037 = query.getOrDefault("oauth_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "oauth_token", valid_580037
  var valid_580038 = query.getOrDefault("userIp")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "userIp", valid_580038
  var valid_580039 = query.getOrDefault("key")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "key", valid_580039
  var valid_580040 = query.getOrDefault("prettyPrint")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "prettyPrint", valid_580040
  var valid_580041 = query.getOrDefault("parameters")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "parameters", valid_580041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580042: Call_ReportsCustomerUsageReportsGet_580028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a specific customer.
  ## 
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_ReportsCustomerUsageReportsGet_580028; date: string;
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
  var path_580044 = newJObject()
  var query_580045 = newJObject()
  add(query_580045, "fields", newJString(fields))
  add(query_580045, "pageToken", newJString(pageToken))
  add(query_580045, "quotaUser", newJString(quotaUser))
  add(query_580045, "alt", newJString(alt))
  add(query_580045, "customerId", newJString(customerId))
  add(query_580045, "oauth_token", newJString(oauthToken))
  add(query_580045, "userIp", newJString(userIp))
  add(query_580045, "key", newJString(key))
  add(path_580044, "date", newJString(date))
  add(query_580045, "prettyPrint", newJBool(prettyPrint))
  add(query_580045, "parameters", newJString(parameters))
  result = call_580043.call(path_580044, query_580045, nil, nil, nil)

var reportsCustomerUsageReportsGet* = Call_ReportsCustomerUsageReportsGet_580028(
    name: "reportsCustomerUsageReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/usage/dates/{date}",
    validator: validate_ReportsCustomerUsageReportsGet_580029,
    base: "/admin/reports/v1", url: url_ReportsCustomerUsageReportsGet_580030,
    schemes: {Scheme.Https})
type
  Call_ReportsUserUsageReportGet_580046 = ref object of OpenApiRestCall_579424
proc url_ReportsUserUsageReportGet_580048(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_ReportsUserUsageReportGet_580047(path: JsonNode; query: JsonNode;
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
  var valid_580049 = path.getOrDefault("userKey")
  valid_580049 = validateParameter(valid_580049, JString, required = true,
                                 default = nil)
  if valid_580049 != nil:
    section.add "userKey", valid_580049
  var valid_580050 = path.getOrDefault("date")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "date", valid_580050
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
  var valid_580051 = query.getOrDefault("fields")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "fields", valid_580051
  var valid_580052 = query.getOrDefault("pageToken")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "pageToken", valid_580052
  var valid_580053 = query.getOrDefault("quotaUser")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "quotaUser", valid_580053
  var valid_580054 = query.getOrDefault("alt")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("json"))
  if valid_580054 != nil:
    section.add "alt", valid_580054
  var valid_580055 = query.getOrDefault("customerId")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "customerId", valid_580055
  var valid_580056 = query.getOrDefault("oauth_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "oauth_token", valid_580056
  var valid_580057 = query.getOrDefault("userIp")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "userIp", valid_580057
  var valid_580058 = query.getOrDefault("maxResults")
  valid_580058 = validateParameter(valid_580058, JInt, required = false, default = nil)
  if valid_580058 != nil:
    section.add "maxResults", valid_580058
  var valid_580059 = query.getOrDefault("key")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "key", valid_580059
  var valid_580060 = query.getOrDefault("filters")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "filters", valid_580060
  var valid_580061 = query.getOrDefault("prettyPrint")
  valid_580061 = validateParameter(valid_580061, JBool, required = false,
                                 default = newJBool(true))
  if valid_580061 != nil:
    section.add "prettyPrint", valid_580061
  var valid_580062 = query.getOrDefault("orgUnitID")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString(""))
  if valid_580062 != nil:
    section.add "orgUnitID", valid_580062
  var valid_580063 = query.getOrDefault("parameters")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "parameters", valid_580063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580064: Call_ReportsUserUsageReportGet_580046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a set of users.
  ## 
  let valid = call_580064.validator(path, query, header, formData, body)
  let scheme = call_580064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580064.url(scheme.get, call_580064.host, call_580064.base,
                         call_580064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580064, url, valid)

proc call*(call_580065: Call_ReportsUserUsageReportGet_580046; userKey: string;
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
  var path_580066 = newJObject()
  var query_580067 = newJObject()
  add(query_580067, "fields", newJString(fields))
  add(query_580067, "pageToken", newJString(pageToken))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "customerId", newJString(customerId))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(query_580067, "userIp", newJString(userIp))
  add(path_580066, "userKey", newJString(userKey))
  add(query_580067, "maxResults", newJInt(maxResults))
  add(query_580067, "key", newJString(key))
  add(query_580067, "filters", newJString(filters))
  add(path_580066, "date", newJString(date))
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  add(query_580067, "orgUnitID", newJString(orgUnitID))
  add(query_580067, "parameters", newJString(parameters))
  result = call_580065.call(path_580066, query_580067, nil, nil, nil)

var reportsUserUsageReportGet* = Call_ReportsUserUsageReportGet_580046(
    name: "reportsUserUsageReportGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/usage/users/{userKey}/dates/{date}",
    validator: validate_ReportsUserUsageReportGet_580047,
    base: "/admin/reports/v1", url: url_ReportsUserUsageReportGet_580048,
    schemes: {Scheme.Https})
type
  Call_ReportsEntityUsageReportsGet_580068 = ref object of OpenApiRestCall_579424
proc url_ReportsEntityUsageReportsGet_580070(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_ReportsEntityUsageReportsGet_580069(path: JsonNode; query: JsonNode;
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
  var valid_580071 = path.getOrDefault("entityType")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "entityType", valid_580071
  var valid_580072 = path.getOrDefault("entityKey")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "entityKey", valid_580072
  var valid_580073 = path.getOrDefault("date")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "date", valid_580073
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
  var valid_580074 = query.getOrDefault("fields")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "fields", valid_580074
  var valid_580075 = query.getOrDefault("pageToken")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "pageToken", valid_580075
  var valid_580076 = query.getOrDefault("quotaUser")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "quotaUser", valid_580076
  var valid_580077 = query.getOrDefault("alt")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("json"))
  if valid_580077 != nil:
    section.add "alt", valid_580077
  var valid_580078 = query.getOrDefault("customerId")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "customerId", valid_580078
  var valid_580079 = query.getOrDefault("oauth_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "oauth_token", valid_580079
  var valid_580080 = query.getOrDefault("userIp")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "userIp", valid_580080
  var valid_580081 = query.getOrDefault("maxResults")
  valid_580081 = validateParameter(valid_580081, JInt, required = false, default = nil)
  if valid_580081 != nil:
    section.add "maxResults", valid_580081
  var valid_580082 = query.getOrDefault("key")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "key", valid_580082
  var valid_580083 = query.getOrDefault("filters")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "filters", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
  var valid_580085 = query.getOrDefault("parameters")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "parameters", valid_580085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580086: Call_ReportsEntityUsageReportsGet_580068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a set of objects.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_ReportsEntityUsageReportsGet_580068;
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
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "pageToken", newJString(pageToken))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "customerId", newJString(customerId))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "userIp", newJString(userIp))
  add(query_580089, "maxResults", newJInt(maxResults))
  add(query_580089, "key", newJString(key))
  add(path_580088, "entityType", newJString(entityType))
  add(path_580088, "entityKey", newJString(entityKey))
  add(query_580089, "filters", newJString(filters))
  add(path_580088, "date", newJString(date))
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  add(query_580089, "parameters", newJString(parameters))
  result = call_580087.call(path_580088, query_580089, nil, nil, nil)

var reportsEntityUsageReportsGet* = Call_ReportsEntityUsageReportsGet_580068(
    name: "reportsEntityUsageReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/usage/{entityType}/{entityKey}/dates/{date}",
    validator: validate_ReportsEntityUsageReportsGet_580069,
    base: "/admin/reports/v1", url: url_ReportsEntityUsageReportsGet_580070,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
