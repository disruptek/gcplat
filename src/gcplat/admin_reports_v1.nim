
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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
  Call_ReportsActivitiesList_588725 = ref object of OpenApiRestCall_588457
proc url_ReportsActivitiesList_588727(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsActivitiesList_588726(path: JsonNode; query: JsonNode;
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
  var valid_588853 = path.getOrDefault("applicationName")
  valid_588853 = validateParameter(valid_588853, JString, required = true,
                                 default = nil)
  if valid_588853 != nil:
    section.add "applicationName", valid_588853
  var valid_588854 = path.getOrDefault("userKey")
  valid_588854 = validateParameter(valid_588854, JString, required = true,
                                 default = nil)
  if valid_588854 != nil:
    section.add "userKey", valid_588854
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
  var valid_588855 = query.getOrDefault("fields")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "fields", valid_588855
  var valid_588856 = query.getOrDefault("pageToken")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "pageToken", valid_588856
  var valid_588857 = query.getOrDefault("quotaUser")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "quotaUser", valid_588857
  var valid_588871 = query.getOrDefault("alt")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = newJString("json"))
  if valid_588871 != nil:
    section.add "alt", valid_588871
  var valid_588872 = query.getOrDefault("customerId")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "customerId", valid_588872
  var valid_588873 = query.getOrDefault("oauth_token")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = nil)
  if valid_588873 != nil:
    section.add "oauth_token", valid_588873
  var valid_588874 = query.getOrDefault("endTime")
  valid_588874 = validateParameter(valid_588874, JString, required = false,
                                 default = nil)
  if valid_588874 != nil:
    section.add "endTime", valid_588874
  var valid_588875 = query.getOrDefault("userIp")
  valid_588875 = validateParameter(valid_588875, JString, required = false,
                                 default = nil)
  if valid_588875 != nil:
    section.add "userIp", valid_588875
  var valid_588876 = query.getOrDefault("maxResults")
  valid_588876 = validateParameter(valid_588876, JInt, required = false, default = nil)
  if valid_588876 != nil:
    section.add "maxResults", valid_588876
  var valid_588877 = query.getOrDefault("key")
  valid_588877 = validateParameter(valid_588877, JString, required = false,
                                 default = nil)
  if valid_588877 != nil:
    section.add "key", valid_588877
  var valid_588878 = query.getOrDefault("filters")
  valid_588878 = validateParameter(valid_588878, JString, required = false,
                                 default = nil)
  if valid_588878 != nil:
    section.add "filters", valid_588878
  var valid_588879 = query.getOrDefault("eventName")
  valid_588879 = validateParameter(valid_588879, JString, required = false,
                                 default = nil)
  if valid_588879 != nil:
    section.add "eventName", valid_588879
  var valid_588880 = query.getOrDefault("actorIpAddress")
  valid_588880 = validateParameter(valid_588880, JString, required = false,
                                 default = nil)
  if valid_588880 != nil:
    section.add "actorIpAddress", valid_588880
  var valid_588881 = query.getOrDefault("prettyPrint")
  valid_588881 = validateParameter(valid_588881, JBool, required = false,
                                 default = newJBool(true))
  if valid_588881 != nil:
    section.add "prettyPrint", valid_588881
  var valid_588882 = query.getOrDefault("startTime")
  valid_588882 = validateParameter(valid_588882, JString, required = false,
                                 default = nil)
  if valid_588882 != nil:
    section.add "startTime", valid_588882
  var valid_588883 = query.getOrDefault("orgUnitID")
  valid_588883 = validateParameter(valid_588883, JString, required = false,
                                 default = newJString(""))
  if valid_588883 != nil:
    section.add "orgUnitID", valid_588883
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588906: Call_ReportsActivitiesList_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of activities for a specific customer and application.
  ## 
  let valid = call_588906.validator(path, query, header, formData, body)
  let scheme = call_588906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588906.url(scheme.get, call_588906.host, call_588906.base,
                         call_588906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588906, url, valid)

proc call*(call_588977: Call_ReportsActivitiesList_588725; applicationName: string;
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
  var path_588978 = newJObject()
  var query_588980 = newJObject()
  add(query_588980, "fields", newJString(fields))
  add(query_588980, "pageToken", newJString(pageToken))
  add(query_588980, "quotaUser", newJString(quotaUser))
  add(path_588978, "applicationName", newJString(applicationName))
  add(query_588980, "alt", newJString(alt))
  add(query_588980, "customerId", newJString(customerId))
  add(query_588980, "oauth_token", newJString(oauthToken))
  add(query_588980, "endTime", newJString(endTime))
  add(query_588980, "userIp", newJString(userIp))
  add(path_588978, "userKey", newJString(userKey))
  add(query_588980, "maxResults", newJInt(maxResults))
  add(query_588980, "key", newJString(key))
  add(query_588980, "filters", newJString(filters))
  add(query_588980, "eventName", newJString(eventName))
  add(query_588980, "actorIpAddress", newJString(actorIpAddress))
  add(query_588980, "prettyPrint", newJBool(prettyPrint))
  add(query_588980, "startTime", newJString(startTime))
  add(query_588980, "orgUnitID", newJString(orgUnitID))
  result = call_588977.call(path_588978, query_588980, nil, nil, nil)

var reportsActivitiesList* = Call_ReportsActivitiesList_588725(
    name: "reportsActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activity/users/{userKey}/applications/{applicationName}",
    validator: validate_ReportsActivitiesList_588726, base: "/admin/reports/v1",
    url: url_ReportsActivitiesList_588727, schemes: {Scheme.Https})
type
  Call_ReportsActivitiesWatch_589019 = ref object of OpenApiRestCall_588457
proc url_ReportsActivitiesWatch_589021(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsActivitiesWatch_589020(path: JsonNode; query: JsonNode;
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
  var valid_589022 = path.getOrDefault("applicationName")
  valid_589022 = validateParameter(valid_589022, JString, required = true,
                                 default = nil)
  if valid_589022 != nil:
    section.add "applicationName", valid_589022
  var valid_589023 = path.getOrDefault("userKey")
  valid_589023 = validateParameter(valid_589023, JString, required = true,
                                 default = nil)
  if valid_589023 != nil:
    section.add "userKey", valid_589023
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
  var valid_589024 = query.getOrDefault("fields")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "fields", valid_589024
  var valid_589025 = query.getOrDefault("pageToken")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "pageToken", valid_589025
  var valid_589026 = query.getOrDefault("quotaUser")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "quotaUser", valid_589026
  var valid_589027 = query.getOrDefault("alt")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = newJString("json"))
  if valid_589027 != nil:
    section.add "alt", valid_589027
  var valid_589028 = query.getOrDefault("customerId")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "customerId", valid_589028
  var valid_589029 = query.getOrDefault("oauth_token")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "oauth_token", valid_589029
  var valid_589030 = query.getOrDefault("endTime")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "endTime", valid_589030
  var valid_589031 = query.getOrDefault("userIp")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "userIp", valid_589031
  var valid_589032 = query.getOrDefault("maxResults")
  valid_589032 = validateParameter(valid_589032, JInt, required = false, default = nil)
  if valid_589032 != nil:
    section.add "maxResults", valid_589032
  var valid_589033 = query.getOrDefault("key")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "key", valid_589033
  var valid_589034 = query.getOrDefault("filters")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "filters", valid_589034
  var valid_589035 = query.getOrDefault("eventName")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "eventName", valid_589035
  var valid_589036 = query.getOrDefault("actorIpAddress")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "actorIpAddress", valid_589036
  var valid_589037 = query.getOrDefault("prettyPrint")
  valid_589037 = validateParameter(valid_589037, JBool, required = false,
                                 default = newJBool(true))
  if valid_589037 != nil:
    section.add "prettyPrint", valid_589037
  var valid_589038 = query.getOrDefault("startTime")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "startTime", valid_589038
  var valid_589039 = query.getOrDefault("orgUnitID")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString(""))
  if valid_589039 != nil:
    section.add "orgUnitID", valid_589039
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

proc call*(call_589041: Call_ReportsActivitiesWatch_589019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Push changes to activities
  ## 
  let valid = call_589041.validator(path, query, header, formData, body)
  let scheme = call_589041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589041.url(scheme.get, call_589041.host, call_589041.base,
                         call_589041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589041, url, valid)

proc call*(call_589042: Call_ReportsActivitiesWatch_589019;
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
  var path_589043 = newJObject()
  var query_589044 = newJObject()
  var body_589045 = newJObject()
  add(query_589044, "fields", newJString(fields))
  add(query_589044, "pageToken", newJString(pageToken))
  add(query_589044, "quotaUser", newJString(quotaUser))
  add(path_589043, "applicationName", newJString(applicationName))
  add(query_589044, "alt", newJString(alt))
  add(query_589044, "customerId", newJString(customerId))
  add(query_589044, "oauth_token", newJString(oauthToken))
  add(query_589044, "endTime", newJString(endTime))
  add(query_589044, "userIp", newJString(userIp))
  add(path_589043, "userKey", newJString(userKey))
  add(query_589044, "maxResults", newJInt(maxResults))
  add(query_589044, "key", newJString(key))
  add(query_589044, "filters", newJString(filters))
  if resource != nil:
    body_589045 = resource
  add(query_589044, "eventName", newJString(eventName))
  add(query_589044, "actorIpAddress", newJString(actorIpAddress))
  add(query_589044, "prettyPrint", newJBool(prettyPrint))
  add(query_589044, "startTime", newJString(startTime))
  add(query_589044, "orgUnitID", newJString(orgUnitID))
  result = call_589042.call(path_589043, query_589044, nil, nil, body_589045)

var reportsActivitiesWatch* = Call_ReportsActivitiesWatch_589019(
    name: "reportsActivitiesWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/activity/users/{userKey}/applications/{applicationName}/watch",
    validator: validate_ReportsActivitiesWatch_589020, base: "/admin/reports/v1",
    url: url_ReportsActivitiesWatch_589021, schemes: {Scheme.Https})
type
  Call_AdminChannelsStop_589046 = ref object of OpenApiRestCall_588457
proc url_AdminChannelsStop_589048(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdminChannelsStop_589047(path: JsonNode; query: JsonNode;
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
  var valid_589049 = query.getOrDefault("fields")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "fields", valid_589049
  var valid_589050 = query.getOrDefault("quotaUser")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "quotaUser", valid_589050
  var valid_589051 = query.getOrDefault("alt")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = newJString("json"))
  if valid_589051 != nil:
    section.add "alt", valid_589051
  var valid_589052 = query.getOrDefault("oauth_token")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "oauth_token", valid_589052
  var valid_589053 = query.getOrDefault("userIp")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "userIp", valid_589053
  var valid_589054 = query.getOrDefault("key")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "key", valid_589054
  var valid_589055 = query.getOrDefault("prettyPrint")
  valid_589055 = validateParameter(valid_589055, JBool, required = false,
                                 default = newJBool(true))
  if valid_589055 != nil:
    section.add "prettyPrint", valid_589055
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

proc call*(call_589057: Call_AdminChannelsStop_589046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_AdminChannelsStop_589046; fields: string = "";
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
  var query_589059 = newJObject()
  var body_589060 = newJObject()
  add(query_589059, "fields", newJString(fields))
  add(query_589059, "quotaUser", newJString(quotaUser))
  add(query_589059, "alt", newJString(alt))
  add(query_589059, "oauth_token", newJString(oauthToken))
  add(query_589059, "userIp", newJString(userIp))
  add(query_589059, "key", newJString(key))
  if resource != nil:
    body_589060 = resource
  add(query_589059, "prettyPrint", newJBool(prettyPrint))
  result = call_589058.call(nil, query_589059, nil, nil, body_589060)

var adminChannelsStop* = Call_AdminChannelsStop_589046(name: "adminChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/admin/reports_v1/channels/stop",
    validator: validate_AdminChannelsStop_589047, base: "/admin/reports/v1",
    url: url_AdminChannelsStop_589048, schemes: {Scheme.Https})
type
  Call_ReportsCustomerUsageReportsGet_589061 = ref object of OpenApiRestCall_588457
proc url_ReportsCustomerUsageReportsGet_589063(protocol: Scheme; host: string;
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

proc validate_ReportsCustomerUsageReportsGet_589062(path: JsonNode;
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
  var valid_589064 = path.getOrDefault("date")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "date", valid_589064
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
  var valid_589065 = query.getOrDefault("fields")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "fields", valid_589065
  var valid_589066 = query.getOrDefault("pageToken")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "pageToken", valid_589066
  var valid_589067 = query.getOrDefault("quotaUser")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "quotaUser", valid_589067
  var valid_589068 = query.getOrDefault("alt")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("json"))
  if valid_589068 != nil:
    section.add "alt", valid_589068
  var valid_589069 = query.getOrDefault("customerId")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "customerId", valid_589069
  var valid_589070 = query.getOrDefault("oauth_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "oauth_token", valid_589070
  var valid_589071 = query.getOrDefault("userIp")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "userIp", valid_589071
  var valid_589072 = query.getOrDefault("key")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "key", valid_589072
  var valid_589073 = query.getOrDefault("prettyPrint")
  valid_589073 = validateParameter(valid_589073, JBool, required = false,
                                 default = newJBool(true))
  if valid_589073 != nil:
    section.add "prettyPrint", valid_589073
  var valid_589074 = query.getOrDefault("parameters")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "parameters", valid_589074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589075: Call_ReportsCustomerUsageReportsGet_589061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a specific customer.
  ## 
  let valid = call_589075.validator(path, query, header, formData, body)
  let scheme = call_589075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589075.url(scheme.get, call_589075.host, call_589075.base,
                         call_589075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589075, url, valid)

proc call*(call_589076: Call_ReportsCustomerUsageReportsGet_589061; date: string;
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
  var path_589077 = newJObject()
  var query_589078 = newJObject()
  add(query_589078, "fields", newJString(fields))
  add(query_589078, "pageToken", newJString(pageToken))
  add(query_589078, "quotaUser", newJString(quotaUser))
  add(query_589078, "alt", newJString(alt))
  add(query_589078, "customerId", newJString(customerId))
  add(query_589078, "oauth_token", newJString(oauthToken))
  add(query_589078, "userIp", newJString(userIp))
  add(query_589078, "key", newJString(key))
  add(path_589077, "date", newJString(date))
  add(query_589078, "prettyPrint", newJBool(prettyPrint))
  add(query_589078, "parameters", newJString(parameters))
  result = call_589076.call(path_589077, query_589078, nil, nil, nil)

var reportsCustomerUsageReportsGet* = Call_ReportsCustomerUsageReportsGet_589061(
    name: "reportsCustomerUsageReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/usage/dates/{date}",
    validator: validate_ReportsCustomerUsageReportsGet_589062,
    base: "/admin/reports/v1", url: url_ReportsCustomerUsageReportsGet_589063,
    schemes: {Scheme.Https})
type
  Call_ReportsUserUsageReportGet_589079 = ref object of OpenApiRestCall_588457
proc url_ReportsUserUsageReportGet_589081(protocol: Scheme; host: string;
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

proc validate_ReportsUserUsageReportGet_589080(path: JsonNode; query: JsonNode;
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
  var valid_589082 = path.getOrDefault("userKey")
  valid_589082 = validateParameter(valid_589082, JString, required = true,
                                 default = nil)
  if valid_589082 != nil:
    section.add "userKey", valid_589082
  var valid_589083 = path.getOrDefault("date")
  valid_589083 = validateParameter(valid_589083, JString, required = true,
                                 default = nil)
  if valid_589083 != nil:
    section.add "date", valid_589083
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
  var valid_589084 = query.getOrDefault("fields")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "fields", valid_589084
  var valid_589085 = query.getOrDefault("pageToken")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "pageToken", valid_589085
  var valid_589086 = query.getOrDefault("quotaUser")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "quotaUser", valid_589086
  var valid_589087 = query.getOrDefault("alt")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("json"))
  if valid_589087 != nil:
    section.add "alt", valid_589087
  var valid_589088 = query.getOrDefault("customerId")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "customerId", valid_589088
  var valid_589089 = query.getOrDefault("oauth_token")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "oauth_token", valid_589089
  var valid_589090 = query.getOrDefault("userIp")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "userIp", valid_589090
  var valid_589091 = query.getOrDefault("maxResults")
  valid_589091 = validateParameter(valid_589091, JInt, required = false, default = nil)
  if valid_589091 != nil:
    section.add "maxResults", valid_589091
  var valid_589092 = query.getOrDefault("key")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "key", valid_589092
  var valid_589093 = query.getOrDefault("filters")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "filters", valid_589093
  var valid_589094 = query.getOrDefault("prettyPrint")
  valid_589094 = validateParameter(valid_589094, JBool, required = false,
                                 default = newJBool(true))
  if valid_589094 != nil:
    section.add "prettyPrint", valid_589094
  var valid_589095 = query.getOrDefault("orgUnitID")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString(""))
  if valid_589095 != nil:
    section.add "orgUnitID", valid_589095
  var valid_589096 = query.getOrDefault("parameters")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "parameters", valid_589096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589097: Call_ReportsUserUsageReportGet_589079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a set of users.
  ## 
  let valid = call_589097.validator(path, query, header, formData, body)
  let scheme = call_589097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589097.url(scheme.get, call_589097.host, call_589097.base,
                         call_589097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589097, url, valid)

proc call*(call_589098: Call_ReportsUserUsageReportGet_589079; userKey: string;
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
  var path_589099 = newJObject()
  var query_589100 = newJObject()
  add(query_589100, "fields", newJString(fields))
  add(query_589100, "pageToken", newJString(pageToken))
  add(query_589100, "quotaUser", newJString(quotaUser))
  add(query_589100, "alt", newJString(alt))
  add(query_589100, "customerId", newJString(customerId))
  add(query_589100, "oauth_token", newJString(oauthToken))
  add(query_589100, "userIp", newJString(userIp))
  add(path_589099, "userKey", newJString(userKey))
  add(query_589100, "maxResults", newJInt(maxResults))
  add(query_589100, "key", newJString(key))
  add(query_589100, "filters", newJString(filters))
  add(path_589099, "date", newJString(date))
  add(query_589100, "prettyPrint", newJBool(prettyPrint))
  add(query_589100, "orgUnitID", newJString(orgUnitID))
  add(query_589100, "parameters", newJString(parameters))
  result = call_589098.call(path_589099, query_589100, nil, nil, nil)

var reportsUserUsageReportGet* = Call_ReportsUserUsageReportGet_589079(
    name: "reportsUserUsageReportGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/usage/users/{userKey}/dates/{date}",
    validator: validate_ReportsUserUsageReportGet_589080,
    base: "/admin/reports/v1", url: url_ReportsUserUsageReportGet_589081,
    schemes: {Scheme.Https})
type
  Call_ReportsEntityUsageReportsGet_589101 = ref object of OpenApiRestCall_588457
proc url_ReportsEntityUsageReportsGet_589103(protocol: Scheme; host: string;
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

proc validate_ReportsEntityUsageReportsGet_589102(path: JsonNode; query: JsonNode;
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
  var valid_589104 = path.getOrDefault("entityType")
  valid_589104 = validateParameter(valid_589104, JString, required = true,
                                 default = nil)
  if valid_589104 != nil:
    section.add "entityType", valid_589104
  var valid_589105 = path.getOrDefault("entityKey")
  valid_589105 = validateParameter(valid_589105, JString, required = true,
                                 default = nil)
  if valid_589105 != nil:
    section.add "entityKey", valid_589105
  var valid_589106 = path.getOrDefault("date")
  valid_589106 = validateParameter(valid_589106, JString, required = true,
                                 default = nil)
  if valid_589106 != nil:
    section.add "date", valid_589106
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
  var valid_589107 = query.getOrDefault("fields")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "fields", valid_589107
  var valid_589108 = query.getOrDefault("pageToken")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "pageToken", valid_589108
  var valid_589109 = query.getOrDefault("quotaUser")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "quotaUser", valid_589109
  var valid_589110 = query.getOrDefault("alt")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = newJString("json"))
  if valid_589110 != nil:
    section.add "alt", valid_589110
  var valid_589111 = query.getOrDefault("customerId")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "customerId", valid_589111
  var valid_589112 = query.getOrDefault("oauth_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "oauth_token", valid_589112
  var valid_589113 = query.getOrDefault("userIp")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "userIp", valid_589113
  var valid_589114 = query.getOrDefault("maxResults")
  valid_589114 = validateParameter(valid_589114, JInt, required = false, default = nil)
  if valid_589114 != nil:
    section.add "maxResults", valid_589114
  var valid_589115 = query.getOrDefault("key")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "key", valid_589115
  var valid_589116 = query.getOrDefault("filters")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "filters", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
  var valid_589118 = query.getOrDefault("parameters")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "parameters", valid_589118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589119: Call_ReportsEntityUsageReportsGet_589101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a set of objects.
  ## 
  let valid = call_589119.validator(path, query, header, formData, body)
  let scheme = call_589119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589119.url(scheme.get, call_589119.host, call_589119.base,
                         call_589119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589119, url, valid)

proc call*(call_589120: Call_ReportsEntityUsageReportsGet_589101;
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
  var path_589121 = newJObject()
  var query_589122 = newJObject()
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "pageToken", newJString(pageToken))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(query_589122, "alt", newJString(alt))
  add(query_589122, "customerId", newJString(customerId))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(query_589122, "userIp", newJString(userIp))
  add(query_589122, "maxResults", newJInt(maxResults))
  add(query_589122, "key", newJString(key))
  add(path_589121, "entityType", newJString(entityType))
  add(path_589121, "entityKey", newJString(entityKey))
  add(query_589122, "filters", newJString(filters))
  add(path_589121, "date", newJString(date))
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  add(query_589122, "parameters", newJString(parameters))
  result = call_589120.call(path_589121, query_589122, nil, nil, nil)

var reportsEntityUsageReportsGet* = Call_ReportsEntityUsageReportsGet_589101(
    name: "reportsEntityUsageReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/usage/{entityType}/{entityKey}/dates/{date}",
    validator: validate_ReportsEntityUsageReportsGet_589102,
    base: "/admin/reports/v1", url: url_ReportsEntityUsageReportsGet_589103,
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
