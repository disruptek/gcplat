
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
  Call_ReportsActivitiesList_578625 = ref object of OpenApiRestCall_578355
proc url_ReportsActivitiesList_578627(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsActivitiesList_578626(path: JsonNode; query: JsonNode;
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
  var valid_578753 = path.getOrDefault("applicationName")
  valid_578753 = validateParameter(valid_578753, JString, required = true,
                                 default = nil)
  if valid_578753 != nil:
    section.add "applicationName", valid_578753
  var valid_578754 = path.getOrDefault("userKey")
  valid_578754 = validateParameter(valid_578754, JString, required = true,
                                 default = nil)
  if valid_578754 != nil:
    section.add "userKey", valid_578754
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endTime: JString
  ##          : Return events which occurred at or before this time.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   eventName: JString
  ##            : Name of the event being queried.
  ##   startTime: JString
  ##            : Return events which occurred at or after this time.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   actorIpAddress: JString
  ##                 : IP Address of host where the event was performed. Supports both IPv4 and IPv6 addresses.
  ##   pageToken: JString
  ##            : Token to specify next page.
  ##   orgUnitID: JString
  ##            : the organizational unit's(OU) ID to filter activities from users belonging to a specific OU or one of its sub-OU(s)
  ##   filters: JString
  ##          : Event parameters in the form [parameter1 name][operator][parameter1 value],[parameter2 name][operator][parameter2 value],...
  ##   customerId: JString
  ##             : Represents the customer for which the data is to be fetched.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Number of activity records to be shown in each page.
  section = newJObject()
  var valid_578755 = query.getOrDefault("key")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "key", valid_578755
  var valid_578756 = query.getOrDefault("endTime")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "endTime", valid_578756
  var valid_578770 = query.getOrDefault("prettyPrint")
  valid_578770 = validateParameter(valid_578770, JBool, required = false,
                                 default = newJBool(true))
  if valid_578770 != nil:
    section.add "prettyPrint", valid_578770
  var valid_578771 = query.getOrDefault("oauth_token")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "oauth_token", valid_578771
  var valid_578772 = query.getOrDefault("eventName")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "eventName", valid_578772
  var valid_578773 = query.getOrDefault("startTime")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "startTime", valid_578773
  var valid_578774 = query.getOrDefault("alt")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = newJString("json"))
  if valid_578774 != nil:
    section.add "alt", valid_578774
  var valid_578775 = query.getOrDefault("userIp")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = nil)
  if valid_578775 != nil:
    section.add "userIp", valid_578775
  var valid_578776 = query.getOrDefault("quotaUser")
  valid_578776 = validateParameter(valid_578776, JString, required = false,
                                 default = nil)
  if valid_578776 != nil:
    section.add "quotaUser", valid_578776
  var valid_578777 = query.getOrDefault("actorIpAddress")
  valid_578777 = validateParameter(valid_578777, JString, required = false,
                                 default = nil)
  if valid_578777 != nil:
    section.add "actorIpAddress", valid_578777
  var valid_578778 = query.getOrDefault("pageToken")
  valid_578778 = validateParameter(valid_578778, JString, required = false,
                                 default = nil)
  if valid_578778 != nil:
    section.add "pageToken", valid_578778
  var valid_578779 = query.getOrDefault("orgUnitID")
  valid_578779 = validateParameter(valid_578779, JString, required = false,
                                 default = newJString(""))
  if valid_578779 != nil:
    section.add "orgUnitID", valid_578779
  var valid_578780 = query.getOrDefault("filters")
  valid_578780 = validateParameter(valid_578780, JString, required = false,
                                 default = nil)
  if valid_578780 != nil:
    section.add "filters", valid_578780
  var valid_578781 = query.getOrDefault("customerId")
  valid_578781 = validateParameter(valid_578781, JString, required = false,
                                 default = nil)
  if valid_578781 != nil:
    section.add "customerId", valid_578781
  var valid_578782 = query.getOrDefault("fields")
  valid_578782 = validateParameter(valid_578782, JString, required = false,
                                 default = nil)
  if valid_578782 != nil:
    section.add "fields", valid_578782
  var valid_578783 = query.getOrDefault("maxResults")
  valid_578783 = validateParameter(valid_578783, JInt, required = false, default = nil)
  if valid_578783 != nil:
    section.add "maxResults", valid_578783
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578806: Call_ReportsActivitiesList_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of activities for a specific customer and application.
  ## 
  let valid = call_578806.validator(path, query, header, formData, body)
  let scheme = call_578806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578806.url(scheme.get, call_578806.host, call_578806.base,
                         call_578806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578806, url, valid)

proc call*(call_578877: Call_ReportsActivitiesList_578625; applicationName: string;
          userKey: string; key: string = ""; endTime: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; eventName: string = "";
          startTime: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; actorIpAddress: string = ""; pageToken: string = "";
          orgUnitID: string = ""; filters: string = ""; customerId: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## reportsActivitiesList
  ## Retrieves a list of activities for a specific customer and application.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endTime: string
  ##          : Return events which occurred at or before this time.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   eventName: string
  ##            : Name of the event being queried.
  ##   applicationName: string (required)
  ##                  : Application name for which the events are to be retrieved.
  ##   startTime: string
  ##            : Return events which occurred at or after this time.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   actorIpAddress: string
  ##                 : IP Address of host where the event was performed. Supports both IPv4 and IPv6 addresses.
  ##   pageToken: string
  ##            : Token to specify next page.
  ##   orgUnitID: string
  ##            : the organizational unit's(OU) ID to filter activities from users belonging to a specific OU or one of its sub-OU(s)
  ##   filters: string
  ##          : Event parameters in the form [parameter1 name][operator][parameter1 value],[parameter2 name][operator][parameter2 value],...
  ##   customerId: string
  ##             : Represents the customer for which the data is to be fetched.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Number of activity records to be shown in each page.
  ##   userKey: string (required)
  ##          : Represents the profile id or the user email for which the data should be filtered. When 'all' is specified as the userKey, it returns usageReports for all users.
  var path_578878 = newJObject()
  var query_578880 = newJObject()
  add(query_578880, "key", newJString(key))
  add(query_578880, "endTime", newJString(endTime))
  add(query_578880, "prettyPrint", newJBool(prettyPrint))
  add(query_578880, "oauth_token", newJString(oauthToken))
  add(query_578880, "eventName", newJString(eventName))
  add(path_578878, "applicationName", newJString(applicationName))
  add(query_578880, "startTime", newJString(startTime))
  add(query_578880, "alt", newJString(alt))
  add(query_578880, "userIp", newJString(userIp))
  add(query_578880, "quotaUser", newJString(quotaUser))
  add(query_578880, "actorIpAddress", newJString(actorIpAddress))
  add(query_578880, "pageToken", newJString(pageToken))
  add(query_578880, "orgUnitID", newJString(orgUnitID))
  add(query_578880, "filters", newJString(filters))
  add(query_578880, "customerId", newJString(customerId))
  add(query_578880, "fields", newJString(fields))
  add(query_578880, "maxResults", newJInt(maxResults))
  add(path_578878, "userKey", newJString(userKey))
  result = call_578877.call(path_578878, query_578880, nil, nil, nil)

var reportsActivitiesList* = Call_ReportsActivitiesList_578625(
    name: "reportsActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activity/users/{userKey}/applications/{applicationName}",
    validator: validate_ReportsActivitiesList_578626, base: "/admin/reports/v1",
    url: url_ReportsActivitiesList_578627, schemes: {Scheme.Https})
type
  Call_ReportsActivitiesWatch_578919 = ref object of OpenApiRestCall_578355
proc url_ReportsActivitiesWatch_578921(protocol: Scheme; host: string; base: string;
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

proc validate_ReportsActivitiesWatch_578920(path: JsonNode; query: JsonNode;
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
  var valid_578922 = path.getOrDefault("applicationName")
  valid_578922 = validateParameter(valid_578922, JString, required = true,
                                 default = nil)
  if valid_578922 != nil:
    section.add "applicationName", valid_578922
  var valid_578923 = path.getOrDefault("userKey")
  valid_578923 = validateParameter(valid_578923, JString, required = true,
                                 default = nil)
  if valid_578923 != nil:
    section.add "userKey", valid_578923
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endTime: JString
  ##          : Return events which occurred at or before this time.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   eventName: JString
  ##            : Name of the event being queried.
  ##   startTime: JString
  ##            : Return events which occurred at or after this time.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   actorIpAddress: JString
  ##                 : IP Address of host where the event was performed. Supports both IPv4 and IPv6 addresses.
  ##   pageToken: JString
  ##            : Token to specify next page.
  ##   orgUnitID: JString
  ##            : the organizational unit's(OU) ID to filter activities from users belonging to a specific OU or one of its sub-OU(s)
  ##   filters: JString
  ##          : Event parameters in the form [parameter1 name][operator][parameter1 value],[parameter2 name][operator][parameter2 value],...
  ##   customerId: JString
  ##             : Represents the customer for which the data is to be fetched.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Number of activity records to be shown in each page.
  section = newJObject()
  var valid_578924 = query.getOrDefault("key")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "key", valid_578924
  var valid_578925 = query.getOrDefault("endTime")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "endTime", valid_578925
  var valid_578926 = query.getOrDefault("prettyPrint")
  valid_578926 = validateParameter(valid_578926, JBool, required = false,
                                 default = newJBool(true))
  if valid_578926 != nil:
    section.add "prettyPrint", valid_578926
  var valid_578927 = query.getOrDefault("oauth_token")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "oauth_token", valid_578927
  var valid_578928 = query.getOrDefault("eventName")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "eventName", valid_578928
  var valid_578929 = query.getOrDefault("startTime")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "startTime", valid_578929
  var valid_578930 = query.getOrDefault("alt")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("json"))
  if valid_578930 != nil:
    section.add "alt", valid_578930
  var valid_578931 = query.getOrDefault("userIp")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "userIp", valid_578931
  var valid_578932 = query.getOrDefault("quotaUser")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "quotaUser", valid_578932
  var valid_578933 = query.getOrDefault("actorIpAddress")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "actorIpAddress", valid_578933
  var valid_578934 = query.getOrDefault("pageToken")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "pageToken", valid_578934
  var valid_578935 = query.getOrDefault("orgUnitID")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString(""))
  if valid_578935 != nil:
    section.add "orgUnitID", valid_578935
  var valid_578936 = query.getOrDefault("filters")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "filters", valid_578936
  var valid_578937 = query.getOrDefault("customerId")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "customerId", valid_578937
  var valid_578938 = query.getOrDefault("fields")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "fields", valid_578938
  var valid_578939 = query.getOrDefault("maxResults")
  valid_578939 = validateParameter(valid_578939, JInt, required = false, default = nil)
  if valid_578939 != nil:
    section.add "maxResults", valid_578939
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

proc call*(call_578941: Call_ReportsActivitiesWatch_578919; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Push changes to activities
  ## 
  let valid = call_578941.validator(path, query, header, formData, body)
  let scheme = call_578941.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578941.url(scheme.get, call_578941.host, call_578941.base,
                         call_578941.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578941, url, valid)

proc call*(call_578942: Call_ReportsActivitiesWatch_578919;
          applicationName: string; userKey: string; key: string = "";
          endTime: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          eventName: string = ""; startTime: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; actorIpAddress: string = "";
          pageToken: string = ""; orgUnitID: string = ""; filters: string = "";
          customerId: string = ""; resource: JsonNode = nil; fields: string = "";
          maxResults: int = 0): Recallable =
  ## reportsActivitiesWatch
  ## Push changes to activities
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   endTime: string
  ##          : Return events which occurred at or before this time.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   eventName: string
  ##            : Name of the event being queried.
  ##   applicationName: string (required)
  ##                  : Application name for which the events are to be retrieved.
  ##   startTime: string
  ##            : Return events which occurred at or after this time.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   actorIpAddress: string
  ##                 : IP Address of host where the event was performed. Supports both IPv4 and IPv6 addresses.
  ##   pageToken: string
  ##            : Token to specify next page.
  ##   orgUnitID: string
  ##            : the organizational unit's(OU) ID to filter activities from users belonging to a specific OU or one of its sub-OU(s)
  ##   filters: string
  ##          : Event parameters in the form [parameter1 name][operator][parameter1 value],[parameter2 name][operator][parameter2 value],...
  ##   customerId: string
  ##             : Represents the customer for which the data is to be fetched.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Number of activity records to be shown in each page.
  ##   userKey: string (required)
  ##          : Represents the profile id or the user email for which the data should be filtered. When 'all' is specified as the userKey, it returns usageReports for all users.
  var path_578943 = newJObject()
  var query_578944 = newJObject()
  var body_578945 = newJObject()
  add(query_578944, "key", newJString(key))
  add(query_578944, "endTime", newJString(endTime))
  add(query_578944, "prettyPrint", newJBool(prettyPrint))
  add(query_578944, "oauth_token", newJString(oauthToken))
  add(query_578944, "eventName", newJString(eventName))
  add(path_578943, "applicationName", newJString(applicationName))
  add(query_578944, "startTime", newJString(startTime))
  add(query_578944, "alt", newJString(alt))
  add(query_578944, "userIp", newJString(userIp))
  add(query_578944, "quotaUser", newJString(quotaUser))
  add(query_578944, "actorIpAddress", newJString(actorIpAddress))
  add(query_578944, "pageToken", newJString(pageToken))
  add(query_578944, "orgUnitID", newJString(orgUnitID))
  add(query_578944, "filters", newJString(filters))
  add(query_578944, "customerId", newJString(customerId))
  if resource != nil:
    body_578945 = resource
  add(query_578944, "fields", newJString(fields))
  add(query_578944, "maxResults", newJInt(maxResults))
  add(path_578943, "userKey", newJString(userKey))
  result = call_578942.call(path_578943, query_578944, nil, nil, body_578945)

var reportsActivitiesWatch* = Call_ReportsActivitiesWatch_578919(
    name: "reportsActivitiesWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/activity/users/{userKey}/applications/{applicationName}/watch",
    validator: validate_ReportsActivitiesWatch_578920, base: "/admin/reports/v1",
    url: url_ReportsActivitiesWatch_578921, schemes: {Scheme.Https})
type
  Call_AdminChannelsStop_578946 = ref object of OpenApiRestCall_578355
proc url_AdminChannelsStop_578948(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdminChannelsStop_578947(path: JsonNode; query: JsonNode;
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
  var valid_578949 = query.getOrDefault("key")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "key", valid_578949
  var valid_578950 = query.getOrDefault("prettyPrint")
  valid_578950 = validateParameter(valid_578950, JBool, required = false,
                                 default = newJBool(true))
  if valid_578950 != nil:
    section.add "prettyPrint", valid_578950
  var valid_578951 = query.getOrDefault("oauth_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "oauth_token", valid_578951
  var valid_578952 = query.getOrDefault("alt")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = newJString("json"))
  if valid_578952 != nil:
    section.add "alt", valid_578952
  var valid_578953 = query.getOrDefault("userIp")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "userIp", valid_578953
  var valid_578954 = query.getOrDefault("quotaUser")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "quotaUser", valid_578954
  var valid_578955 = query.getOrDefault("fields")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "fields", valid_578955
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

proc call*(call_578957: Call_AdminChannelsStop_578946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_578957.validator(path, query, header, formData, body)
  let scheme = call_578957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578957.url(scheme.get, call_578957.host, call_578957.base,
                         call_578957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578957, url, valid)

proc call*(call_578958: Call_AdminChannelsStop_578946; key: string = "";
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
  var query_578959 = newJObject()
  var body_578960 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "userIp", newJString(userIp))
  add(query_578959, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_578960 = resource
  add(query_578959, "fields", newJString(fields))
  result = call_578958.call(nil, query_578959, nil, nil, body_578960)

var adminChannelsStop* = Call_AdminChannelsStop_578946(name: "adminChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/admin/reports_v1/channels/stop",
    validator: validate_AdminChannelsStop_578947, base: "/admin/reports/v1",
    url: url_AdminChannelsStop_578948, schemes: {Scheme.Https})
type
  Call_ReportsCustomerUsageReportsGet_578961 = ref object of OpenApiRestCall_578355
proc url_ReportsCustomerUsageReportsGet_578963(protocol: Scheme; host: string;
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

proc validate_ReportsCustomerUsageReportsGet_578962(path: JsonNode;
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
  var valid_578964 = path.getOrDefault("date")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "date", valid_578964
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
  ##            : Token to specify next page.
  ##   customerId: JString
  ##             : Represents the customer for which the data is to be fetched.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   parameters: JString
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
  section = newJObject()
  var valid_578965 = query.getOrDefault("key")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "key", valid_578965
  var valid_578966 = query.getOrDefault("prettyPrint")
  valid_578966 = validateParameter(valid_578966, JBool, required = false,
                                 default = newJBool(true))
  if valid_578966 != nil:
    section.add "prettyPrint", valid_578966
  var valid_578967 = query.getOrDefault("oauth_token")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "oauth_token", valid_578967
  var valid_578968 = query.getOrDefault("alt")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("json"))
  if valid_578968 != nil:
    section.add "alt", valid_578968
  var valid_578969 = query.getOrDefault("userIp")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "userIp", valid_578969
  var valid_578970 = query.getOrDefault("quotaUser")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "quotaUser", valid_578970
  var valid_578971 = query.getOrDefault("pageToken")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "pageToken", valid_578971
  var valid_578972 = query.getOrDefault("customerId")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "customerId", valid_578972
  var valid_578973 = query.getOrDefault("fields")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "fields", valid_578973
  var valid_578974 = query.getOrDefault("parameters")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "parameters", valid_578974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578975: Call_ReportsCustomerUsageReportsGet_578961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a specific customer.
  ## 
  let valid = call_578975.validator(path, query, header, formData, body)
  let scheme = call_578975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578975.url(scheme.get, call_578975.host, call_578975.base,
                         call_578975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578975, url, valid)

proc call*(call_578976: Call_ReportsCustomerUsageReportsGet_578961; date: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; customerId: string = ""; fields: string = "";
          parameters: string = ""): Recallable =
  ## reportsCustomerUsageReportsGet
  ## Retrieves a report which is a collection of properties / statistics for a specific customer.
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
  ##            : Token to specify next page.
  ##   customerId: string
  ##             : Represents the customer for which the data is to be fetched.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   date: string (required)
  ##       : Represents the date in yyyy-mm-dd format for which the data is to be fetched.
  ##   parameters: string
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
  var path_578977 = newJObject()
  var query_578978 = newJObject()
  add(query_578978, "key", newJString(key))
  add(query_578978, "prettyPrint", newJBool(prettyPrint))
  add(query_578978, "oauth_token", newJString(oauthToken))
  add(query_578978, "alt", newJString(alt))
  add(query_578978, "userIp", newJString(userIp))
  add(query_578978, "quotaUser", newJString(quotaUser))
  add(query_578978, "pageToken", newJString(pageToken))
  add(query_578978, "customerId", newJString(customerId))
  add(query_578978, "fields", newJString(fields))
  add(path_578977, "date", newJString(date))
  add(query_578978, "parameters", newJString(parameters))
  result = call_578976.call(path_578977, query_578978, nil, nil, nil)

var reportsCustomerUsageReportsGet* = Call_ReportsCustomerUsageReportsGet_578961(
    name: "reportsCustomerUsageReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/usage/dates/{date}",
    validator: validate_ReportsCustomerUsageReportsGet_578962,
    base: "/admin/reports/v1", url: url_ReportsCustomerUsageReportsGet_578963,
    schemes: {Scheme.Https})
type
  Call_ReportsUserUsageReportGet_578979 = ref object of OpenApiRestCall_578355
proc url_ReportsUserUsageReportGet_578981(protocol: Scheme; host: string;
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

proc validate_ReportsUserUsageReportGet_578980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a report which is a collection of properties / statistics for a set of users.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   date: JString (required)
  ##       : Represents the date in yyyy-mm-dd format for which the data is to be fetched.
  ##   userKey: JString (required)
  ##          : Represents the profile id or the user email for which the data should be filtered.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `date` field"
  var valid_578982 = path.getOrDefault("date")
  valid_578982 = validateParameter(valid_578982, JString, required = true,
                                 default = nil)
  if valid_578982 != nil:
    section.add "date", valid_578982
  var valid_578983 = path.getOrDefault("userKey")
  valid_578983 = validateParameter(valid_578983, JString, required = true,
                                 default = nil)
  if valid_578983 != nil:
    section.add "userKey", valid_578983
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   parameters: JString
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
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
  ##            : Token to specify next page.
  ##   orgUnitID: JString
  ##            : the organizational unit's ID to filter usage parameters from users belonging to a specific OU or one of its sub-OU(s).
  ##   filters: JString
  ##          : Represents the set of filters including parameter operator value.
  ##   customerId: JString
  ##             : Represents the customer for which the data is to be fetched.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Maximum allowed is 1000
  section = newJObject()
  var valid_578984 = query.getOrDefault("key")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "key", valid_578984
  var valid_578985 = query.getOrDefault("parameters")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "parameters", valid_578985
  var valid_578986 = query.getOrDefault("prettyPrint")
  valid_578986 = validateParameter(valid_578986, JBool, required = false,
                                 default = newJBool(true))
  if valid_578986 != nil:
    section.add "prettyPrint", valid_578986
  var valid_578987 = query.getOrDefault("oauth_token")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "oauth_token", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("userIp")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "userIp", valid_578989
  var valid_578990 = query.getOrDefault("quotaUser")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "quotaUser", valid_578990
  var valid_578991 = query.getOrDefault("pageToken")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "pageToken", valid_578991
  var valid_578992 = query.getOrDefault("orgUnitID")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = newJString(""))
  if valid_578992 != nil:
    section.add "orgUnitID", valid_578992
  var valid_578993 = query.getOrDefault("filters")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "filters", valid_578993
  var valid_578994 = query.getOrDefault("customerId")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "customerId", valid_578994
  var valid_578995 = query.getOrDefault("fields")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "fields", valid_578995
  var valid_578996 = query.getOrDefault("maxResults")
  valid_578996 = validateParameter(valid_578996, JInt, required = false, default = nil)
  if valid_578996 != nil:
    section.add "maxResults", valid_578996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578997: Call_ReportsUserUsageReportGet_578979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a set of users.
  ## 
  let valid = call_578997.validator(path, query, header, formData, body)
  let scheme = call_578997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578997.url(scheme.get, call_578997.host, call_578997.base,
                         call_578997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578997, url, valid)

proc call*(call_578998: Call_ReportsUserUsageReportGet_578979; date: string;
          userKey: string; key: string = ""; parameters: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          orgUnitID: string = ""; filters: string = ""; customerId: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## reportsUserUsageReportGet
  ## Retrieves a report which is a collection of properties / statistics for a set of users.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   parameters: string
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
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
  ##            : Token to specify next page.
  ##   orgUnitID: string
  ##            : the organizational unit's ID to filter usage parameters from users belonging to a specific OU or one of its sub-OU(s).
  ##   filters: string
  ##          : Represents the set of filters including parameter operator value.
  ##   customerId: string
  ##             : Represents the customer for which the data is to be fetched.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   date: string (required)
  ##       : Represents the date in yyyy-mm-dd format for which the data is to be fetched.
  ##   maxResults: int
  ##             : Maximum number of results to return. Maximum allowed is 1000
  ##   userKey: string (required)
  ##          : Represents the profile id or the user email for which the data should be filtered.
  var path_578999 = newJObject()
  var query_579000 = newJObject()
  add(query_579000, "key", newJString(key))
  add(query_579000, "parameters", newJString(parameters))
  add(query_579000, "prettyPrint", newJBool(prettyPrint))
  add(query_579000, "oauth_token", newJString(oauthToken))
  add(query_579000, "alt", newJString(alt))
  add(query_579000, "userIp", newJString(userIp))
  add(query_579000, "quotaUser", newJString(quotaUser))
  add(query_579000, "pageToken", newJString(pageToken))
  add(query_579000, "orgUnitID", newJString(orgUnitID))
  add(query_579000, "filters", newJString(filters))
  add(query_579000, "customerId", newJString(customerId))
  add(query_579000, "fields", newJString(fields))
  add(path_578999, "date", newJString(date))
  add(query_579000, "maxResults", newJInt(maxResults))
  add(path_578999, "userKey", newJString(userKey))
  result = call_578998.call(path_578999, query_579000, nil, nil, nil)

var reportsUserUsageReportGet* = Call_ReportsUserUsageReportGet_578979(
    name: "reportsUserUsageReportGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/usage/users/{userKey}/dates/{date}",
    validator: validate_ReportsUserUsageReportGet_578980,
    base: "/admin/reports/v1", url: url_ReportsUserUsageReportGet_578981,
    schemes: {Scheme.Https})
type
  Call_ReportsEntityUsageReportsGet_579001 = ref object of OpenApiRestCall_578355
proc url_ReportsEntityUsageReportsGet_579003(protocol: Scheme; host: string;
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

proc validate_ReportsEntityUsageReportsGet_579002(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a report which is a collection of properties / statistics for a set of objects.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityKey: JString (required)
  ##            : Represents the key of object for which the data should be filtered.
  ##   entityType: JString (required)
  ##             : Type of object. Should be one of - gplus_communities.
  ##   date: JString (required)
  ##       : Represents the date in yyyy-mm-dd format for which the data is to be fetched.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityKey` field"
  var valid_579004 = path.getOrDefault("entityKey")
  valid_579004 = validateParameter(valid_579004, JString, required = true,
                                 default = nil)
  if valid_579004 != nil:
    section.add "entityKey", valid_579004
  var valid_579005 = path.getOrDefault("entityType")
  valid_579005 = validateParameter(valid_579005, JString, required = true,
                                 default = nil)
  if valid_579005 != nil:
    section.add "entityType", valid_579005
  var valid_579006 = path.getOrDefault("date")
  valid_579006 = validateParameter(valid_579006, JString, required = true,
                                 default = nil)
  if valid_579006 != nil:
    section.add "date", valid_579006
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
  ##            : Token to specify next page.
  ##   filters: JString
  ##          : Represents the set of filters including parameter operator value.
  ##   customerId: JString
  ##             : Represents the customer for which the data is to be fetched.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Maximum allowed is 1000
  ##   parameters: JString
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
  section = newJObject()
  var valid_579007 = query.getOrDefault("key")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "key", valid_579007
  var valid_579008 = query.getOrDefault("prettyPrint")
  valid_579008 = validateParameter(valid_579008, JBool, required = false,
                                 default = newJBool(true))
  if valid_579008 != nil:
    section.add "prettyPrint", valid_579008
  var valid_579009 = query.getOrDefault("oauth_token")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "oauth_token", valid_579009
  var valid_579010 = query.getOrDefault("alt")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = newJString("json"))
  if valid_579010 != nil:
    section.add "alt", valid_579010
  var valid_579011 = query.getOrDefault("userIp")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "userIp", valid_579011
  var valid_579012 = query.getOrDefault("quotaUser")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "quotaUser", valid_579012
  var valid_579013 = query.getOrDefault("pageToken")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "pageToken", valid_579013
  var valid_579014 = query.getOrDefault("filters")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "filters", valid_579014
  var valid_579015 = query.getOrDefault("customerId")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "customerId", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
  var valid_579017 = query.getOrDefault("maxResults")
  valid_579017 = validateParameter(valid_579017, JInt, required = false, default = nil)
  if valid_579017 != nil:
    section.add "maxResults", valid_579017
  var valid_579018 = query.getOrDefault("parameters")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "parameters", valid_579018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579019: Call_ReportsEntityUsageReportsGet_579001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a report which is a collection of properties / statistics for a set of objects.
  ## 
  let valid = call_579019.validator(path, query, header, formData, body)
  let scheme = call_579019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579019.url(scheme.get, call_579019.host, call_579019.base,
                         call_579019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579019, url, valid)

proc call*(call_579020: Call_ReportsEntityUsageReportsGet_579001;
          entityKey: string; entityType: string; date: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          filters: string = ""; customerId: string = ""; fields: string = "";
          maxResults: int = 0; parameters: string = ""): Recallable =
  ## reportsEntityUsageReportsGet
  ## Retrieves a report which is a collection of properties / statistics for a set of objects.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   entityKey: string (required)
  ##            : Represents the key of object for which the data should be filtered.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to specify next page.
  ##   filters: string
  ##          : Represents the set of filters including parameter operator value.
  ##   customerId: string
  ##             : Represents the customer for which the data is to be fetched.
  ##   entityType: string (required)
  ##             : Type of object. Should be one of - gplus_communities.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   date: string (required)
  ##       : Represents the date in yyyy-mm-dd format for which the data is to be fetched.
  ##   maxResults: int
  ##             : Maximum number of results to return. Maximum allowed is 1000
  ##   parameters: string
  ##             : Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1, app_name2:param_name2.
  var path_579021 = newJObject()
  var query_579022 = newJObject()
  add(query_579022, "key", newJString(key))
  add(query_579022, "prettyPrint", newJBool(prettyPrint))
  add(query_579022, "oauth_token", newJString(oauthToken))
  add(path_579021, "entityKey", newJString(entityKey))
  add(query_579022, "alt", newJString(alt))
  add(query_579022, "userIp", newJString(userIp))
  add(query_579022, "quotaUser", newJString(quotaUser))
  add(query_579022, "pageToken", newJString(pageToken))
  add(query_579022, "filters", newJString(filters))
  add(query_579022, "customerId", newJString(customerId))
  add(path_579021, "entityType", newJString(entityType))
  add(query_579022, "fields", newJString(fields))
  add(path_579021, "date", newJString(date))
  add(query_579022, "maxResults", newJInt(maxResults))
  add(query_579022, "parameters", newJString(parameters))
  result = call_579020.call(path_579021, query_579022, nil, nil, nil)

var reportsEntityUsageReportsGet* = Call_ReportsEntityUsageReportsGet_579001(
    name: "reportsEntityUsageReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/usage/{entityType}/{entityKey}/dates/{date}",
    validator: validate_ReportsEntityUsageReportsGet_579002,
    base: "/admin/reports/v1", url: url_ReportsEntityUsageReportsGet_579003,
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
