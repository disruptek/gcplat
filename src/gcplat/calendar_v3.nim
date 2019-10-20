
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Calendar
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manipulates events and other calendar data.
## 
## https://developers.google.com/google-apps/calendar/firstapp
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
  gcpServiceName = "calendar"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CalendarCalendarsInsert_578625 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarsInsert_578627(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarsInsert_578626(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a secondary calendar.
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("alt")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("json"))
  if valid_578755 != nil:
    section.add "alt", valid_578755
  var valid_578756 = query.getOrDefault("userIp")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "userIp", valid_578756
  var valid_578757 = query.getOrDefault("quotaUser")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "quotaUser", valid_578757
  var valid_578758 = query.getOrDefault("fields")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "fields", valid_578758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578782: Call_CalendarCalendarsInsert_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a secondary calendar.
  ## 
  let valid = call_578782.validator(path, query, header, formData, body)
  let scheme = call_578782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578782.url(scheme.get, call_578782.host, call_578782.base,
                         call_578782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578782, url, valid)

proc call*(call_578853: Call_CalendarCalendarsInsert_578625; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## calendarCalendarsInsert
  ## Creates a secondary calendar.
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578854 = newJObject()
  var body_578856 = newJObject()
  add(query_578854, "key", newJString(key))
  add(query_578854, "prettyPrint", newJBool(prettyPrint))
  add(query_578854, "oauth_token", newJString(oauthToken))
  add(query_578854, "alt", newJString(alt))
  add(query_578854, "userIp", newJString(userIp))
  add(query_578854, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578856 = body
  add(query_578854, "fields", newJString(fields))
  result = call_578853.call(nil, query_578854, nil, nil, body_578856)

var calendarCalendarsInsert* = Call_CalendarCalendarsInsert_578625(
    name: "calendarCalendarsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars",
    validator: validate_CalendarCalendarsInsert_578626, base: "/calendar/v3",
    url: url_CalendarCalendarsInsert_578627, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsUpdate_578924 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarsUpdate_578926(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarsUpdate_578925(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates metadata for a calendar.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_578927 = path.getOrDefault("calendarId")
  valid_578927 = validateParameter(valid_578927, JString, required = true,
                                 default = nil)
  if valid_578927 != nil:
    section.add "calendarId", valid_578927
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
  var valid_578928 = query.getOrDefault("key")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "key", valid_578928
  var valid_578929 = query.getOrDefault("prettyPrint")
  valid_578929 = validateParameter(valid_578929, JBool, required = false,
                                 default = newJBool(true))
  if valid_578929 != nil:
    section.add "prettyPrint", valid_578929
  var valid_578930 = query.getOrDefault("oauth_token")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "oauth_token", valid_578930
  var valid_578931 = query.getOrDefault("alt")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("json"))
  if valid_578931 != nil:
    section.add "alt", valid_578931
  var valid_578932 = query.getOrDefault("userIp")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "userIp", valid_578932
  var valid_578933 = query.getOrDefault("quotaUser")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "quotaUser", valid_578933
  var valid_578934 = query.getOrDefault("fields")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "fields", valid_578934
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578936: Call_CalendarCalendarsUpdate_578924; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates metadata for a calendar.
  ## 
  let valid = call_578936.validator(path, query, header, formData, body)
  let scheme = call_578936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578936.url(scheme.get, call_578936.host, call_578936.base,
                         call_578936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578936, url, valid)

proc call*(call_578937: Call_CalendarCalendarsUpdate_578924; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## calendarCalendarsUpdate
  ## Updates metadata for a calendar.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578938 = newJObject()
  var query_578939 = newJObject()
  var body_578940 = newJObject()
  add(query_578939, "key", newJString(key))
  add(query_578939, "prettyPrint", newJBool(prettyPrint))
  add(query_578939, "oauth_token", newJString(oauthToken))
  add(path_578938, "calendarId", newJString(calendarId))
  add(query_578939, "alt", newJString(alt))
  add(query_578939, "userIp", newJString(userIp))
  add(query_578939, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578940 = body
  add(query_578939, "fields", newJString(fields))
  result = call_578937.call(path_578938, query_578939, nil, nil, body_578940)

var calendarCalendarsUpdate* = Call_CalendarCalendarsUpdate_578924(
    name: "calendarCalendarsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsUpdate_578925, base: "/calendar/v3",
    url: url_CalendarCalendarsUpdate_578926, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsGet_578895 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarsGet_578897(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarsGet_578896(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns metadata for a calendar.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_578912 = path.getOrDefault("calendarId")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "calendarId", valid_578912
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
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("prettyPrint")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "prettyPrint", valid_578914
  var valid_578915 = query.getOrDefault("oauth_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "oauth_token", valid_578915
  var valid_578916 = query.getOrDefault("alt")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("json"))
  if valid_578916 != nil:
    section.add "alt", valid_578916
  var valid_578917 = query.getOrDefault("userIp")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "userIp", valid_578917
  var valid_578918 = query.getOrDefault("quotaUser")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "quotaUser", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578920: Call_CalendarCalendarsGet_578895; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for a calendar.
  ## 
  let valid = call_578920.validator(path, query, header, formData, body)
  let scheme = call_578920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578920.url(scheme.get, call_578920.host, call_578920.base,
                         call_578920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578920, url, valid)

proc call*(call_578921: Call_CalendarCalendarsGet_578895; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## calendarCalendarsGet
  ## Returns metadata for a calendar.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578922 = newJObject()
  var query_578923 = newJObject()
  add(query_578923, "key", newJString(key))
  add(query_578923, "prettyPrint", newJBool(prettyPrint))
  add(query_578923, "oauth_token", newJString(oauthToken))
  add(path_578922, "calendarId", newJString(calendarId))
  add(query_578923, "alt", newJString(alt))
  add(query_578923, "userIp", newJString(userIp))
  add(query_578923, "quotaUser", newJString(quotaUser))
  add(query_578923, "fields", newJString(fields))
  result = call_578921.call(path_578922, query_578923, nil, nil, nil)

var calendarCalendarsGet* = Call_CalendarCalendarsGet_578895(
    name: "calendarCalendarsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsGet_578896, base: "/calendar/v3",
    url: url_CalendarCalendarsGet_578897, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsPatch_578956 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarsPatch_578958(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarsPatch_578957(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates metadata for a calendar. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_578959 = path.getOrDefault("calendarId")
  valid_578959 = validateParameter(valid_578959, JString, required = true,
                                 default = nil)
  if valid_578959 != nil:
    section.add "calendarId", valid_578959
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
  var valid_578960 = query.getOrDefault("key")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "key", valid_578960
  var valid_578961 = query.getOrDefault("prettyPrint")
  valid_578961 = validateParameter(valid_578961, JBool, required = false,
                                 default = newJBool(true))
  if valid_578961 != nil:
    section.add "prettyPrint", valid_578961
  var valid_578962 = query.getOrDefault("oauth_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "oauth_token", valid_578962
  var valid_578963 = query.getOrDefault("alt")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("json"))
  if valid_578963 != nil:
    section.add "alt", valid_578963
  var valid_578964 = query.getOrDefault("userIp")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "userIp", valid_578964
  var valid_578965 = query.getOrDefault("quotaUser")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "quotaUser", valid_578965
  var valid_578966 = query.getOrDefault("fields")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "fields", valid_578966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578968: Call_CalendarCalendarsPatch_578956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates metadata for a calendar. This method supports patch semantics.
  ## 
  let valid = call_578968.validator(path, query, header, formData, body)
  let scheme = call_578968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578968.url(scheme.get, call_578968.host, call_578968.base,
                         call_578968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578968, url, valid)

proc call*(call_578969: Call_CalendarCalendarsPatch_578956; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## calendarCalendarsPatch
  ## Updates metadata for a calendar. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578970 = newJObject()
  var query_578971 = newJObject()
  var body_578972 = newJObject()
  add(query_578971, "key", newJString(key))
  add(query_578971, "prettyPrint", newJBool(prettyPrint))
  add(query_578971, "oauth_token", newJString(oauthToken))
  add(path_578970, "calendarId", newJString(calendarId))
  add(query_578971, "alt", newJString(alt))
  add(query_578971, "userIp", newJString(userIp))
  add(query_578971, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578972 = body
  add(query_578971, "fields", newJString(fields))
  result = call_578969.call(path_578970, query_578971, nil, nil, body_578972)

var calendarCalendarsPatch* = Call_CalendarCalendarsPatch_578956(
    name: "calendarCalendarsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsPatch_578957, base: "/calendar/v3",
    url: url_CalendarCalendarsPatch_578958, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsDelete_578941 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarsDelete_578943(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarsDelete_578942(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_578944 = path.getOrDefault("calendarId")
  valid_578944 = validateParameter(valid_578944, JString, required = true,
                                 default = nil)
  if valid_578944 != nil:
    section.add "calendarId", valid_578944
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
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  var valid_578946 = query.getOrDefault("prettyPrint")
  valid_578946 = validateParameter(valid_578946, JBool, required = false,
                                 default = newJBool(true))
  if valid_578946 != nil:
    section.add "prettyPrint", valid_578946
  var valid_578947 = query.getOrDefault("oauth_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "oauth_token", valid_578947
  var valid_578948 = query.getOrDefault("alt")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("json"))
  if valid_578948 != nil:
    section.add "alt", valid_578948
  var valid_578949 = query.getOrDefault("userIp")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "userIp", valid_578949
  var valid_578950 = query.getOrDefault("quotaUser")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "quotaUser", valid_578950
  var valid_578951 = query.getOrDefault("fields")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "fields", valid_578951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578952: Call_CalendarCalendarsDelete_578941; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
  ## 
  let valid = call_578952.validator(path, query, header, formData, body)
  let scheme = call_578952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578952.url(scheme.get, call_578952.host, call_578952.base,
                         call_578952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578952, url, valid)

proc call*(call_578953: Call_CalendarCalendarsDelete_578941; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## calendarCalendarsDelete
  ## Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578954 = newJObject()
  var query_578955 = newJObject()
  add(query_578955, "key", newJString(key))
  add(query_578955, "prettyPrint", newJBool(prettyPrint))
  add(query_578955, "oauth_token", newJString(oauthToken))
  add(path_578954, "calendarId", newJString(calendarId))
  add(query_578955, "alt", newJString(alt))
  add(query_578955, "userIp", newJString(userIp))
  add(query_578955, "quotaUser", newJString(quotaUser))
  add(query_578955, "fields", newJString(fields))
  result = call_578953.call(path_578954, query_578955, nil, nil, nil)

var calendarCalendarsDelete* = Call_CalendarCalendarsDelete_578941(
    name: "calendarCalendarsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsDelete_578942, base: "/calendar/v3",
    url: url_CalendarCalendarsDelete_578943, schemes: {Scheme.Https})
type
  Call_CalendarAclInsert_578992 = ref object of OpenApiRestCall_578355
proc url_CalendarAclInsert_578994(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarAclInsert_578993(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates an access control rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_578995 = path.getOrDefault("calendarId")
  valid_578995 = validateParameter(valid_578995, JString, required = true,
                                 default = nil)
  if valid_578995 != nil:
    section.add "calendarId", valid_578995
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sendNotifications: JBool
  ##                    : Whether to send notifications about the calendar sharing change. Optional. The default is True.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578996 = query.getOrDefault("key")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "key", valid_578996
  var valid_578997 = query.getOrDefault("prettyPrint")
  valid_578997 = validateParameter(valid_578997, JBool, required = false,
                                 default = newJBool(true))
  if valid_578997 != nil:
    section.add "prettyPrint", valid_578997
  var valid_578998 = query.getOrDefault("oauth_token")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "oauth_token", valid_578998
  var valid_578999 = query.getOrDefault("sendNotifications")
  valid_578999 = validateParameter(valid_578999, JBool, required = false, default = nil)
  if valid_578999 != nil:
    section.add "sendNotifications", valid_578999
  var valid_579000 = query.getOrDefault("alt")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = newJString("json"))
  if valid_579000 != nil:
    section.add "alt", valid_579000
  var valid_579001 = query.getOrDefault("userIp")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "userIp", valid_579001
  var valid_579002 = query.getOrDefault("quotaUser")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "quotaUser", valid_579002
  var valid_579003 = query.getOrDefault("fields")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "fields", valid_579003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579005: Call_CalendarAclInsert_578992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an access control rule.
  ## 
  let valid = call_579005.validator(path, query, header, formData, body)
  let scheme = call_579005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579005.url(scheme.get, call_579005.host, call_579005.base,
                         call_579005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579005, url, valid)

proc call*(call_579006: Call_CalendarAclInsert_578992; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          sendNotifications: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## calendarAclInsert
  ## Creates an access control rule.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sendNotifications: bool
  ##                    : Whether to send notifications about the calendar sharing change. Optional. The default is True.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579007 = newJObject()
  var query_579008 = newJObject()
  var body_579009 = newJObject()
  add(query_579008, "key", newJString(key))
  add(query_579008, "prettyPrint", newJBool(prettyPrint))
  add(query_579008, "oauth_token", newJString(oauthToken))
  add(query_579008, "sendNotifications", newJBool(sendNotifications))
  add(path_579007, "calendarId", newJString(calendarId))
  add(query_579008, "alt", newJString(alt))
  add(query_579008, "userIp", newJString(userIp))
  add(query_579008, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579009 = body
  add(query_579008, "fields", newJString(fields))
  result = call_579006.call(path_579007, query_579008, nil, nil, body_579009)

var calendarAclInsert* = Call_CalendarAclInsert_578992(name: "calendarAclInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl", validator: validate_CalendarAclInsert_578993,
    base: "/calendar/v3", url: url_CalendarAclInsert_578994, schemes: {Scheme.Https})
type
  Call_CalendarAclList_578973 = ref object of OpenApiRestCall_578355
proc url_CalendarAclList_578975(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarAclList_578974(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns the rules in the access control list for the calendar.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_578976 = path.getOrDefault("calendarId")
  valid_578976 = validateParameter(valid_578976, JString, required = true,
                                 default = nil)
  if valid_578976 != nil:
    section.add "calendarId", valid_578976
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
  ##            : Token specifying which result page to return. Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: JBool
  ##              : Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  section = newJObject()
  var valid_578977 = query.getOrDefault("key")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "key", valid_578977
  var valid_578978 = query.getOrDefault("prettyPrint")
  valid_578978 = validateParameter(valid_578978, JBool, required = false,
                                 default = newJBool(true))
  if valid_578978 != nil:
    section.add "prettyPrint", valid_578978
  var valid_578979 = query.getOrDefault("oauth_token")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "oauth_token", valid_578979
  var valid_578980 = query.getOrDefault("alt")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = newJString("json"))
  if valid_578980 != nil:
    section.add "alt", valid_578980
  var valid_578981 = query.getOrDefault("userIp")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "userIp", valid_578981
  var valid_578982 = query.getOrDefault("quotaUser")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "quotaUser", valid_578982
  var valid_578983 = query.getOrDefault("pageToken")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "pageToken", valid_578983
  var valid_578984 = query.getOrDefault("fields")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "fields", valid_578984
  var valid_578985 = query.getOrDefault("syncToken")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "syncToken", valid_578985
  var valid_578986 = query.getOrDefault("showDeleted")
  valid_578986 = validateParameter(valid_578986, JBool, required = false, default = nil)
  if valid_578986 != nil:
    section.add "showDeleted", valid_578986
  var valid_578987 = query.getOrDefault("maxResults")
  valid_578987 = validateParameter(valid_578987, JInt, required = false, default = nil)
  if valid_578987 != nil:
    section.add "maxResults", valid_578987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578988: Call_CalendarAclList_578973; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the rules in the access control list for the calendar.
  ## 
  let valid = call_578988.validator(path, query, header, formData, body)
  let scheme = call_578988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578988.url(scheme.get, call_578988.host, call_578988.base,
                         call_578988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578988, url, valid)

proc call*(call_578989: Call_CalendarAclList_578973; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; syncToken: string = "";
          showDeleted: bool = false; maxResults: int = 0): Recallable =
  ## calendarAclList
  ## Returns the rules in the access control list for the calendar.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: bool
  ##              : Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  var path_578990 = newJObject()
  var query_578991 = newJObject()
  add(query_578991, "key", newJString(key))
  add(query_578991, "prettyPrint", newJBool(prettyPrint))
  add(query_578991, "oauth_token", newJString(oauthToken))
  add(path_578990, "calendarId", newJString(calendarId))
  add(query_578991, "alt", newJString(alt))
  add(query_578991, "userIp", newJString(userIp))
  add(query_578991, "quotaUser", newJString(quotaUser))
  add(query_578991, "pageToken", newJString(pageToken))
  add(query_578991, "fields", newJString(fields))
  add(query_578991, "syncToken", newJString(syncToken))
  add(query_578991, "showDeleted", newJBool(showDeleted))
  add(query_578991, "maxResults", newJInt(maxResults))
  result = call_578989.call(path_578990, query_578991, nil, nil, nil)

var calendarAclList* = Call_CalendarAclList_578973(name: "calendarAclList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl", validator: validate_CalendarAclList_578974,
    base: "/calendar/v3", url: url_CalendarAclList_578975, schemes: {Scheme.Https})
type
  Call_CalendarAclWatch_579010 = ref object of OpenApiRestCall_578355
proc url_CalendarAclWatch_579012(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/acl/watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarAclWatch_579011(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Watch for changes to ACL resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579013 = path.getOrDefault("calendarId")
  valid_579013 = validateParameter(valid_579013, JString, required = true,
                                 default = nil)
  if valid_579013 != nil:
    section.add "calendarId", valid_579013
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
  ##            : Token specifying which result page to return. Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: JBool
  ##              : Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  section = newJObject()
  var valid_579014 = query.getOrDefault("key")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "key", valid_579014
  var valid_579015 = query.getOrDefault("prettyPrint")
  valid_579015 = validateParameter(valid_579015, JBool, required = false,
                                 default = newJBool(true))
  if valid_579015 != nil:
    section.add "prettyPrint", valid_579015
  var valid_579016 = query.getOrDefault("oauth_token")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "oauth_token", valid_579016
  var valid_579017 = query.getOrDefault("alt")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = newJString("json"))
  if valid_579017 != nil:
    section.add "alt", valid_579017
  var valid_579018 = query.getOrDefault("userIp")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "userIp", valid_579018
  var valid_579019 = query.getOrDefault("quotaUser")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "quotaUser", valid_579019
  var valid_579020 = query.getOrDefault("pageToken")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "pageToken", valid_579020
  var valid_579021 = query.getOrDefault("fields")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "fields", valid_579021
  var valid_579022 = query.getOrDefault("syncToken")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "syncToken", valid_579022
  var valid_579023 = query.getOrDefault("showDeleted")
  valid_579023 = validateParameter(valid_579023, JBool, required = false, default = nil)
  if valid_579023 != nil:
    section.add "showDeleted", valid_579023
  var valid_579024 = query.getOrDefault("maxResults")
  valid_579024 = validateParameter(valid_579024, JInt, required = false, default = nil)
  if valid_579024 != nil:
    section.add "maxResults", valid_579024
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

proc call*(call_579026: Call_CalendarAclWatch_579010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to ACL resources.
  ## 
  let valid = call_579026.validator(path, query, header, formData, body)
  let scheme = call_579026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579026.url(scheme.get, call_579026.host, call_579026.base,
                         call_579026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579026, url, valid)

proc call*(call_579027: Call_CalendarAclWatch_579010; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; resource: JsonNode = nil; fields: string = "";
          syncToken: string = ""; showDeleted: bool = false; maxResults: int = 0): Recallable =
  ## calendarAclWatch
  ## Watch for changes to ACL resources.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: bool
  ##              : Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  var path_579028 = newJObject()
  var query_579029 = newJObject()
  var body_579030 = newJObject()
  add(query_579029, "key", newJString(key))
  add(query_579029, "prettyPrint", newJBool(prettyPrint))
  add(query_579029, "oauth_token", newJString(oauthToken))
  add(path_579028, "calendarId", newJString(calendarId))
  add(query_579029, "alt", newJString(alt))
  add(query_579029, "userIp", newJString(userIp))
  add(query_579029, "quotaUser", newJString(quotaUser))
  add(query_579029, "pageToken", newJString(pageToken))
  if resource != nil:
    body_579030 = resource
  add(query_579029, "fields", newJString(fields))
  add(query_579029, "syncToken", newJString(syncToken))
  add(query_579029, "showDeleted", newJBool(showDeleted))
  add(query_579029, "maxResults", newJInt(maxResults))
  result = call_579027.call(path_579028, query_579029, nil, nil, body_579030)

var calendarAclWatch* = Call_CalendarAclWatch_579010(name: "calendarAclWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/watch",
    validator: validate_CalendarAclWatch_579011, base: "/calendar/v3",
    url: url_CalendarAclWatch_579012, schemes: {Scheme.Https})
type
  Call_CalendarAclUpdate_579047 = ref object of OpenApiRestCall_578355
proc url_CalendarAclUpdate_579049(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "ruleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarAclUpdate_579048(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates an access control rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleId: JString (required)
  ##         : ACL rule identifier.
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleId` field"
  var valid_579050 = path.getOrDefault("ruleId")
  valid_579050 = validateParameter(valid_579050, JString, required = true,
                                 default = nil)
  if valid_579050 != nil:
    section.add "ruleId", valid_579050
  var valid_579051 = path.getOrDefault("calendarId")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "calendarId", valid_579051
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sendNotifications: JBool
  ##                    : Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579052 = query.getOrDefault("key")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "key", valid_579052
  var valid_579053 = query.getOrDefault("prettyPrint")
  valid_579053 = validateParameter(valid_579053, JBool, required = false,
                                 default = newJBool(true))
  if valid_579053 != nil:
    section.add "prettyPrint", valid_579053
  var valid_579054 = query.getOrDefault("oauth_token")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "oauth_token", valid_579054
  var valid_579055 = query.getOrDefault("sendNotifications")
  valid_579055 = validateParameter(valid_579055, JBool, required = false, default = nil)
  if valid_579055 != nil:
    section.add "sendNotifications", valid_579055
  var valid_579056 = query.getOrDefault("alt")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = newJString("json"))
  if valid_579056 != nil:
    section.add "alt", valid_579056
  var valid_579057 = query.getOrDefault("userIp")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "userIp", valid_579057
  var valid_579058 = query.getOrDefault("quotaUser")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "quotaUser", valid_579058
  var valid_579059 = query.getOrDefault("fields")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "fields", valid_579059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579061: Call_CalendarAclUpdate_579047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an access control rule.
  ## 
  let valid = call_579061.validator(path, query, header, formData, body)
  let scheme = call_579061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579061.url(scheme.get, call_579061.host, call_579061.base,
                         call_579061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579061, url, valid)

proc call*(call_579062: Call_CalendarAclUpdate_579047; ruleId: string;
          calendarId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; sendNotifications: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## calendarAclUpdate
  ## Updates an access control rule.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sendNotifications: bool
  ##                    : Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
  ##   ruleId: string (required)
  ##         : ACL rule identifier.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579063 = newJObject()
  var query_579064 = newJObject()
  var body_579065 = newJObject()
  add(query_579064, "key", newJString(key))
  add(query_579064, "prettyPrint", newJBool(prettyPrint))
  add(query_579064, "oauth_token", newJString(oauthToken))
  add(query_579064, "sendNotifications", newJBool(sendNotifications))
  add(path_579063, "ruleId", newJString(ruleId))
  add(path_579063, "calendarId", newJString(calendarId))
  add(query_579064, "alt", newJString(alt))
  add(query_579064, "userIp", newJString(userIp))
  add(query_579064, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579065 = body
  add(query_579064, "fields", newJString(fields))
  result = call_579062.call(path_579063, query_579064, nil, nil, body_579065)

var calendarAclUpdate* = Call_CalendarAclUpdate_579047(name: "calendarAclUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclUpdate_579048, base: "/calendar/v3",
    url: url_CalendarAclUpdate_579049, schemes: {Scheme.Https})
type
  Call_CalendarAclGet_579031 = ref object of OpenApiRestCall_578355
proc url_CalendarAclGet_579033(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "ruleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarAclGet_579032(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns an access control rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleId: JString (required)
  ##         : ACL rule identifier.
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleId` field"
  var valid_579034 = path.getOrDefault("ruleId")
  valid_579034 = validateParameter(valid_579034, JString, required = true,
                                 default = nil)
  if valid_579034 != nil:
    section.add "ruleId", valid_579034
  var valid_579035 = path.getOrDefault("calendarId")
  valid_579035 = validateParameter(valid_579035, JString, required = true,
                                 default = nil)
  if valid_579035 != nil:
    section.add "calendarId", valid_579035
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
  var valid_579036 = query.getOrDefault("key")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "key", valid_579036
  var valid_579037 = query.getOrDefault("prettyPrint")
  valid_579037 = validateParameter(valid_579037, JBool, required = false,
                                 default = newJBool(true))
  if valid_579037 != nil:
    section.add "prettyPrint", valid_579037
  var valid_579038 = query.getOrDefault("oauth_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "oauth_token", valid_579038
  var valid_579039 = query.getOrDefault("alt")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = newJString("json"))
  if valid_579039 != nil:
    section.add "alt", valid_579039
  var valid_579040 = query.getOrDefault("userIp")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "userIp", valid_579040
  var valid_579041 = query.getOrDefault("quotaUser")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "quotaUser", valid_579041
  var valid_579042 = query.getOrDefault("fields")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "fields", valid_579042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579043: Call_CalendarAclGet_579031; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an access control rule.
  ## 
  let valid = call_579043.validator(path, query, header, formData, body)
  let scheme = call_579043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579043.url(scheme.get, call_579043.host, call_579043.base,
                         call_579043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579043, url, valid)

proc call*(call_579044: Call_CalendarAclGet_579031; ruleId: string;
          calendarId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## calendarAclGet
  ## Returns an access control rule.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   ruleId: string (required)
  ##         : ACL rule identifier.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579045 = newJObject()
  var query_579046 = newJObject()
  add(query_579046, "key", newJString(key))
  add(query_579046, "prettyPrint", newJBool(prettyPrint))
  add(query_579046, "oauth_token", newJString(oauthToken))
  add(path_579045, "ruleId", newJString(ruleId))
  add(path_579045, "calendarId", newJString(calendarId))
  add(query_579046, "alt", newJString(alt))
  add(query_579046, "userIp", newJString(userIp))
  add(query_579046, "quotaUser", newJString(quotaUser))
  add(query_579046, "fields", newJString(fields))
  result = call_579044.call(path_579045, query_579046, nil, nil, nil)

var calendarAclGet* = Call_CalendarAclGet_579031(name: "calendarAclGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclGet_579032, base: "/calendar/v3",
    url: url_CalendarAclGet_579033, schemes: {Scheme.Https})
type
  Call_CalendarAclPatch_579082 = ref object of OpenApiRestCall_578355
proc url_CalendarAclPatch_579084(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "ruleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarAclPatch_579083(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates an access control rule. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleId: JString (required)
  ##         : ACL rule identifier.
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleId` field"
  var valid_579085 = path.getOrDefault("ruleId")
  valid_579085 = validateParameter(valid_579085, JString, required = true,
                                 default = nil)
  if valid_579085 != nil:
    section.add "ruleId", valid_579085
  var valid_579086 = path.getOrDefault("calendarId")
  valid_579086 = validateParameter(valid_579086, JString, required = true,
                                 default = nil)
  if valid_579086 != nil:
    section.add "calendarId", valid_579086
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sendNotifications: JBool
  ##                    : Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579087 = query.getOrDefault("key")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "key", valid_579087
  var valid_579088 = query.getOrDefault("prettyPrint")
  valid_579088 = validateParameter(valid_579088, JBool, required = false,
                                 default = newJBool(true))
  if valid_579088 != nil:
    section.add "prettyPrint", valid_579088
  var valid_579089 = query.getOrDefault("oauth_token")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "oauth_token", valid_579089
  var valid_579090 = query.getOrDefault("sendNotifications")
  valid_579090 = validateParameter(valid_579090, JBool, required = false, default = nil)
  if valid_579090 != nil:
    section.add "sendNotifications", valid_579090
  var valid_579091 = query.getOrDefault("alt")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = newJString("json"))
  if valid_579091 != nil:
    section.add "alt", valid_579091
  var valid_579092 = query.getOrDefault("userIp")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "userIp", valid_579092
  var valid_579093 = query.getOrDefault("quotaUser")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "quotaUser", valid_579093
  var valid_579094 = query.getOrDefault("fields")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "fields", valid_579094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579096: Call_CalendarAclPatch_579082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an access control rule. This method supports patch semantics.
  ## 
  let valid = call_579096.validator(path, query, header, formData, body)
  let scheme = call_579096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579096.url(scheme.get, call_579096.host, call_579096.base,
                         call_579096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579096, url, valid)

proc call*(call_579097: Call_CalendarAclPatch_579082; ruleId: string;
          calendarId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; sendNotifications: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## calendarAclPatch
  ## Updates an access control rule. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sendNotifications: bool
  ##                    : Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
  ##   ruleId: string (required)
  ##         : ACL rule identifier.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579098 = newJObject()
  var query_579099 = newJObject()
  var body_579100 = newJObject()
  add(query_579099, "key", newJString(key))
  add(query_579099, "prettyPrint", newJBool(prettyPrint))
  add(query_579099, "oauth_token", newJString(oauthToken))
  add(query_579099, "sendNotifications", newJBool(sendNotifications))
  add(path_579098, "ruleId", newJString(ruleId))
  add(path_579098, "calendarId", newJString(calendarId))
  add(query_579099, "alt", newJString(alt))
  add(query_579099, "userIp", newJString(userIp))
  add(query_579099, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579100 = body
  add(query_579099, "fields", newJString(fields))
  result = call_579097.call(path_579098, query_579099, nil, nil, body_579100)

var calendarAclPatch* = Call_CalendarAclPatch_579082(name: "calendarAclPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclPatch_579083, base: "/calendar/v3",
    url: url_CalendarAclPatch_579084, schemes: {Scheme.Https})
type
  Call_CalendarAclDelete_579066 = ref object of OpenApiRestCall_578355
proc url_CalendarAclDelete_579068(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "ruleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarAclDelete_579067(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an access control rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleId: JString (required)
  ##         : ACL rule identifier.
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleId` field"
  var valid_579069 = path.getOrDefault("ruleId")
  valid_579069 = validateParameter(valid_579069, JString, required = true,
                                 default = nil)
  if valid_579069 != nil:
    section.add "ruleId", valid_579069
  var valid_579070 = path.getOrDefault("calendarId")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "calendarId", valid_579070
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
  var valid_579071 = query.getOrDefault("key")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "key", valid_579071
  var valid_579072 = query.getOrDefault("prettyPrint")
  valid_579072 = validateParameter(valid_579072, JBool, required = false,
                                 default = newJBool(true))
  if valid_579072 != nil:
    section.add "prettyPrint", valid_579072
  var valid_579073 = query.getOrDefault("oauth_token")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "oauth_token", valid_579073
  var valid_579074 = query.getOrDefault("alt")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = newJString("json"))
  if valid_579074 != nil:
    section.add "alt", valid_579074
  var valid_579075 = query.getOrDefault("userIp")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "userIp", valid_579075
  var valid_579076 = query.getOrDefault("quotaUser")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "quotaUser", valid_579076
  var valid_579077 = query.getOrDefault("fields")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "fields", valid_579077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579078: Call_CalendarAclDelete_579066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an access control rule.
  ## 
  let valid = call_579078.validator(path, query, header, formData, body)
  let scheme = call_579078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579078.url(scheme.get, call_579078.host, call_579078.base,
                         call_579078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579078, url, valid)

proc call*(call_579079: Call_CalendarAclDelete_579066; ruleId: string;
          calendarId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## calendarAclDelete
  ## Deletes an access control rule.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   ruleId: string (required)
  ##         : ACL rule identifier.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579080 = newJObject()
  var query_579081 = newJObject()
  add(query_579081, "key", newJString(key))
  add(query_579081, "prettyPrint", newJBool(prettyPrint))
  add(query_579081, "oauth_token", newJString(oauthToken))
  add(path_579080, "ruleId", newJString(ruleId))
  add(path_579080, "calendarId", newJString(calendarId))
  add(query_579081, "alt", newJString(alt))
  add(query_579081, "userIp", newJString(userIp))
  add(query_579081, "quotaUser", newJString(quotaUser))
  add(query_579081, "fields", newJString(fields))
  result = call_579079.call(path_579080, query_579081, nil, nil, nil)

var calendarAclDelete* = Call_CalendarAclDelete_579066(name: "calendarAclDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclDelete_579067, base: "/calendar/v3",
    url: url_CalendarAclDelete_579068, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsClear_579101 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarsClear_579103(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/clear")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarsClear_579102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579104 = path.getOrDefault("calendarId")
  valid_579104 = validateParameter(valid_579104, JString, required = true,
                                 default = nil)
  if valid_579104 != nil:
    section.add "calendarId", valid_579104
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
  var valid_579105 = query.getOrDefault("key")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "key", valid_579105
  var valid_579106 = query.getOrDefault("prettyPrint")
  valid_579106 = validateParameter(valid_579106, JBool, required = false,
                                 default = newJBool(true))
  if valid_579106 != nil:
    section.add "prettyPrint", valid_579106
  var valid_579107 = query.getOrDefault("oauth_token")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "oauth_token", valid_579107
  var valid_579108 = query.getOrDefault("alt")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = newJString("json"))
  if valid_579108 != nil:
    section.add "alt", valid_579108
  var valid_579109 = query.getOrDefault("userIp")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "userIp", valid_579109
  var valid_579110 = query.getOrDefault("quotaUser")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "quotaUser", valid_579110
  var valid_579111 = query.getOrDefault("fields")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "fields", valid_579111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579112: Call_CalendarCalendarsClear_579101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
  ## 
  let valid = call_579112.validator(path, query, header, formData, body)
  let scheme = call_579112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579112.url(scheme.get, call_579112.host, call_579112.base,
                         call_579112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579112, url, valid)

proc call*(call_579113: Call_CalendarCalendarsClear_579101; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## calendarCalendarsClear
  ## Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579114 = newJObject()
  var query_579115 = newJObject()
  add(query_579115, "key", newJString(key))
  add(query_579115, "prettyPrint", newJBool(prettyPrint))
  add(query_579115, "oauth_token", newJString(oauthToken))
  add(path_579114, "calendarId", newJString(calendarId))
  add(query_579115, "alt", newJString(alt))
  add(query_579115, "userIp", newJString(userIp))
  add(query_579115, "quotaUser", newJString(quotaUser))
  add(query_579115, "fields", newJString(fields))
  result = call_579113.call(path_579114, query_579115, nil, nil, nil)

var calendarCalendarsClear* = Call_CalendarCalendarsClear_579101(
    name: "calendarCalendarsClear", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/clear",
    validator: validate_CalendarCalendarsClear_579102, base: "/calendar/v3",
    url: url_CalendarCalendarsClear_579103, schemes: {Scheme.Https})
type
  Call_CalendarEventsInsert_579149 = ref object of OpenApiRestCall_578355
proc url_CalendarEventsInsert_579151(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/events")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarEventsInsert_579150(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579152 = path.getOrDefault("calendarId")
  valid_579152 = validateParameter(valid_579152, JString, required = true,
                                 default = nil)
  if valid_579152 != nil:
    section.add "calendarId", valid_579152
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the creation of the new event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsAttachments: JBool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   conferenceDataVersion: JInt
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: JString
  ##              : Whether to send notifications about the creation of the new event. Note that some emails might still be sent. The default is false.
  section = newJObject()
  var valid_579153 = query.getOrDefault("key")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "key", valid_579153
  var valid_579154 = query.getOrDefault("prettyPrint")
  valid_579154 = validateParameter(valid_579154, JBool, required = false,
                                 default = newJBool(true))
  if valid_579154 != nil:
    section.add "prettyPrint", valid_579154
  var valid_579155 = query.getOrDefault("oauth_token")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "oauth_token", valid_579155
  var valid_579156 = query.getOrDefault("sendNotifications")
  valid_579156 = validateParameter(valid_579156, JBool, required = false, default = nil)
  if valid_579156 != nil:
    section.add "sendNotifications", valid_579156
  var valid_579157 = query.getOrDefault("maxAttendees")
  valid_579157 = validateParameter(valid_579157, JInt, required = false, default = nil)
  if valid_579157 != nil:
    section.add "maxAttendees", valid_579157
  var valid_579158 = query.getOrDefault("alt")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = newJString("json"))
  if valid_579158 != nil:
    section.add "alt", valid_579158
  var valid_579159 = query.getOrDefault("userIp")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "userIp", valid_579159
  var valid_579160 = query.getOrDefault("quotaUser")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "quotaUser", valid_579160
  var valid_579161 = query.getOrDefault("supportsAttachments")
  valid_579161 = validateParameter(valid_579161, JBool, required = false, default = nil)
  if valid_579161 != nil:
    section.add "supportsAttachments", valid_579161
  var valid_579162 = query.getOrDefault("conferenceDataVersion")
  valid_579162 = validateParameter(valid_579162, JInt, required = false, default = nil)
  if valid_579162 != nil:
    section.add "conferenceDataVersion", valid_579162
  var valid_579163 = query.getOrDefault("fields")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "fields", valid_579163
  var valid_579164 = query.getOrDefault("sendUpdates")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = newJString("all"))
  if valid_579164 != nil:
    section.add "sendUpdates", valid_579164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579166: Call_CalendarEventsInsert_579149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an event.
  ## 
  let valid = call_579166.validator(path, query, header, formData, body)
  let scheme = call_579166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579166.url(scheme.get, call_579166.host, call_579166.base,
                         call_579166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579166, url, valid)

proc call*(call_579167: Call_CalendarEventsInsert_579149; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          sendNotifications: bool = false; maxAttendees: int = 0; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          supportsAttachments: bool = false; body: JsonNode = nil;
          conferenceDataVersion: int = 0; fields: string = "";
          sendUpdates: string = "all"): Recallable =
  ## calendarEventsInsert
  ## Creates an event.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the creation of the new event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsAttachments: bool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   body: JObject
  ##   conferenceDataVersion: int
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: string
  ##              : Whether to send notifications about the creation of the new event. Note that some emails might still be sent. The default is false.
  var path_579168 = newJObject()
  var query_579169 = newJObject()
  var body_579170 = newJObject()
  add(query_579169, "key", newJString(key))
  add(query_579169, "prettyPrint", newJBool(prettyPrint))
  add(query_579169, "oauth_token", newJString(oauthToken))
  add(query_579169, "sendNotifications", newJBool(sendNotifications))
  add(path_579168, "calendarId", newJString(calendarId))
  add(query_579169, "maxAttendees", newJInt(maxAttendees))
  add(query_579169, "alt", newJString(alt))
  add(query_579169, "userIp", newJString(userIp))
  add(query_579169, "quotaUser", newJString(quotaUser))
  add(query_579169, "supportsAttachments", newJBool(supportsAttachments))
  if body != nil:
    body_579170 = body
  add(query_579169, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_579169, "fields", newJString(fields))
  add(query_579169, "sendUpdates", newJString(sendUpdates))
  result = call_579167.call(path_579168, query_579169, nil, nil, body_579170)

var calendarEventsInsert* = Call_CalendarEventsInsert_579149(
    name: "calendarEventsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events",
    validator: validate_CalendarEventsInsert_579150, base: "/calendar/v3",
    url: url_CalendarEventsInsert_579151, schemes: {Scheme.Https})
type
  Call_CalendarEventsList_579116 = ref object of OpenApiRestCall_578355
proc url_CalendarEventsList_579118(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/events")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarEventsList_579117(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns events on the specified calendar.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579119 = path.getOrDefault("calendarId")
  valid_579119 = validateParameter(valid_579119, JString, required = true,
                                 default = nil)
  if valid_579119 != nil:
    section.add "calendarId", valid_579119
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   iCalUID: JString
  ##          : Specifies event ID in the iCalendar format to be included in the response. Optional.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   q: JString
  ##    : Free text search terms to find events that match these terms in any field, except for extended properties. Optional.
  ##   privateExtendedProperty: JArray
  ##                          : Extended properties constraint specified as propertyName=value. Matches only private properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   timeMin: JString
  ##          : Lower bound (exclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMax is set, timeMin must be smaller than timeMax.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : The order of the events returned in the result. Optional. The default is an unspecified, stable order.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   timeZone: JString
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   timeMax: JString
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMin is set, timeMax must be greater than timeMin.
  ##   showHiddenInvitations: JBool
  ##                        : Whether to include hidden invitations in the result. Optional. The default is False.
  ##   singleEvents: JBool
  ##               : Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves. Optional. The default is False.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   sharedExtendedProperty: JArray
  ##                         : Extended properties constraint specified as propertyName=value. Matches only shared properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   updatedMin: JString
  ##             : Lower bound for an event's last modification time (as a RFC3339 timestamp) to filter by. When specified, entries deleted since this time will always be included regardless of showDeleted. Optional. The default is not to filter by last modification time.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All events deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## There are several query parameters that cannot be specified together with nextSyncToken to ensure consistency of the client state.
  ## 
  ## These are: 
  ## - iCalUID 
  ## - orderBy 
  ## - privateExtendedProperty 
  ## - q 
  ## - sharedExtendedProperty 
  ## - timeMin 
  ## - timeMax 
  ## - updatedMin If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: JBool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned. Optional. The default is False.
  ##   maxResults: JInt
  ##             : Maximum number of events returned on one result page. The number of events in the resulting page may be less than this value, or none at all, even if there are more events matching the query. Incomplete pages can be detected by a non-empty nextPageToken field in the response. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  section = newJObject()
  var valid_579120 = query.getOrDefault("key")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "key", valid_579120
  var valid_579121 = query.getOrDefault("prettyPrint")
  valid_579121 = validateParameter(valid_579121, JBool, required = false,
                                 default = newJBool(true))
  if valid_579121 != nil:
    section.add "prettyPrint", valid_579121
  var valid_579122 = query.getOrDefault("oauth_token")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "oauth_token", valid_579122
  var valid_579123 = query.getOrDefault("iCalUID")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "iCalUID", valid_579123
  var valid_579124 = query.getOrDefault("maxAttendees")
  valid_579124 = validateParameter(valid_579124, JInt, required = false, default = nil)
  if valid_579124 != nil:
    section.add "maxAttendees", valid_579124
  var valid_579125 = query.getOrDefault("q")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "q", valid_579125
  var valid_579126 = query.getOrDefault("privateExtendedProperty")
  valid_579126 = validateParameter(valid_579126, JArray, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "privateExtendedProperty", valid_579126
  var valid_579127 = query.getOrDefault("timeMin")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "timeMin", valid_579127
  var valid_579128 = query.getOrDefault("alt")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = newJString("json"))
  if valid_579128 != nil:
    section.add "alt", valid_579128
  var valid_579129 = query.getOrDefault("userIp")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "userIp", valid_579129
  var valid_579130 = query.getOrDefault("quotaUser")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "quotaUser", valid_579130
  var valid_579131 = query.getOrDefault("orderBy")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = newJString("startTime"))
  if valid_579131 != nil:
    section.add "orderBy", valid_579131
  var valid_579132 = query.getOrDefault("pageToken")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "pageToken", valid_579132
  var valid_579133 = query.getOrDefault("timeZone")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "timeZone", valid_579133
  var valid_579134 = query.getOrDefault("timeMax")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "timeMax", valid_579134
  var valid_579135 = query.getOrDefault("showHiddenInvitations")
  valid_579135 = validateParameter(valid_579135, JBool, required = false, default = nil)
  if valid_579135 != nil:
    section.add "showHiddenInvitations", valid_579135
  var valid_579136 = query.getOrDefault("singleEvents")
  valid_579136 = validateParameter(valid_579136, JBool, required = false, default = nil)
  if valid_579136 != nil:
    section.add "singleEvents", valid_579136
  var valid_579137 = query.getOrDefault("alwaysIncludeEmail")
  valid_579137 = validateParameter(valid_579137, JBool, required = false, default = nil)
  if valid_579137 != nil:
    section.add "alwaysIncludeEmail", valid_579137
  var valid_579138 = query.getOrDefault("sharedExtendedProperty")
  valid_579138 = validateParameter(valid_579138, JArray, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "sharedExtendedProperty", valid_579138
  var valid_579139 = query.getOrDefault("updatedMin")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "updatedMin", valid_579139
  var valid_579140 = query.getOrDefault("fields")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "fields", valid_579140
  var valid_579141 = query.getOrDefault("syncToken")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "syncToken", valid_579141
  var valid_579142 = query.getOrDefault("showDeleted")
  valid_579142 = validateParameter(valid_579142, JBool, required = false, default = nil)
  if valid_579142 != nil:
    section.add "showDeleted", valid_579142
  var valid_579144 = query.getOrDefault("maxResults")
  valid_579144 = validateParameter(valid_579144, JInt, required = false,
                                 default = newJInt(250))
  if valid_579144 != nil:
    section.add "maxResults", valid_579144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579145: Call_CalendarEventsList_579116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns events on the specified calendar.
  ## 
  let valid = call_579145.validator(path, query, header, formData, body)
  let scheme = call_579145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579145.url(scheme.get, call_579145.host, call_579145.base,
                         call_579145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579145, url, valid)

proc call*(call_579146: Call_CalendarEventsList_579116; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          iCalUID: string = ""; maxAttendees: int = 0; q: string = "";
          privateExtendedProperty: JsonNode = nil; timeMin: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = "startTime"; pageToken: string = ""; timeZone: string = "";
          timeMax: string = ""; showHiddenInvitations: bool = false;
          singleEvents: bool = false; alwaysIncludeEmail: bool = false;
          sharedExtendedProperty: JsonNode = nil; updatedMin: string = "";
          fields: string = ""; syncToken: string = ""; showDeleted: bool = false;
          maxResults: int = 250): Recallable =
  ## calendarEventsList
  ## Returns events on the specified calendar.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   iCalUID: string
  ##          : Specifies event ID in the iCalendar format to be included in the response. Optional.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   q: string
  ##    : Free text search terms to find events that match these terms in any field, except for extended properties. Optional.
  ##   privateExtendedProperty: JArray
  ##                          : Extended properties constraint specified as propertyName=value. Matches only private properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   timeMin: string
  ##          : Lower bound (exclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMax is set, timeMin must be smaller than timeMax.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : The order of the events returned in the result. Optional. The default is an unspecified, stable order.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   timeZone: string
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   timeMax: string
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMin is set, timeMax must be greater than timeMin.
  ##   showHiddenInvitations: bool
  ##                        : Whether to include hidden invitations in the result. Optional. The default is False.
  ##   singleEvents: bool
  ##               : Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves. Optional. The default is False.
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   sharedExtendedProperty: JArray
  ##                         : Extended properties constraint specified as propertyName=value. Matches only shared properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   updatedMin: string
  ##             : Lower bound for an event's last modification time (as a RFC3339 timestamp) to filter by. When specified, entries deleted since this time will always be included regardless of showDeleted. Optional. The default is not to filter by last modification time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All events deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## There are several query parameters that cannot be specified together with nextSyncToken to ensure consistency of the client state.
  ## 
  ## These are: 
  ## - iCalUID 
  ## - orderBy 
  ## - privateExtendedProperty 
  ## - q 
  ## - sharedExtendedProperty 
  ## - timeMin 
  ## - timeMax 
  ## - updatedMin If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: bool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned. Optional. The default is False.
  ##   maxResults: int
  ##             : Maximum number of events returned on one result page. The number of events in the resulting page may be less than this value, or none at all, even if there are more events matching the query. Incomplete pages can be detected by a non-empty nextPageToken field in the response. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  var path_579147 = newJObject()
  var query_579148 = newJObject()
  add(query_579148, "key", newJString(key))
  add(query_579148, "prettyPrint", newJBool(prettyPrint))
  add(query_579148, "oauth_token", newJString(oauthToken))
  add(query_579148, "iCalUID", newJString(iCalUID))
  add(path_579147, "calendarId", newJString(calendarId))
  add(query_579148, "maxAttendees", newJInt(maxAttendees))
  add(query_579148, "q", newJString(q))
  if privateExtendedProperty != nil:
    query_579148.add "privateExtendedProperty", privateExtendedProperty
  add(query_579148, "timeMin", newJString(timeMin))
  add(query_579148, "alt", newJString(alt))
  add(query_579148, "userIp", newJString(userIp))
  add(query_579148, "quotaUser", newJString(quotaUser))
  add(query_579148, "orderBy", newJString(orderBy))
  add(query_579148, "pageToken", newJString(pageToken))
  add(query_579148, "timeZone", newJString(timeZone))
  add(query_579148, "timeMax", newJString(timeMax))
  add(query_579148, "showHiddenInvitations", newJBool(showHiddenInvitations))
  add(query_579148, "singleEvents", newJBool(singleEvents))
  add(query_579148, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if sharedExtendedProperty != nil:
    query_579148.add "sharedExtendedProperty", sharedExtendedProperty
  add(query_579148, "updatedMin", newJString(updatedMin))
  add(query_579148, "fields", newJString(fields))
  add(query_579148, "syncToken", newJString(syncToken))
  add(query_579148, "showDeleted", newJBool(showDeleted))
  add(query_579148, "maxResults", newJInt(maxResults))
  result = call_579146.call(path_579147, query_579148, nil, nil, nil)

var calendarEventsList* = Call_CalendarEventsList_579116(
    name: "calendarEventsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events",
    validator: validate_CalendarEventsList_579117, base: "/calendar/v3",
    url: url_CalendarEventsList_579118, schemes: {Scheme.Https})
type
  Call_CalendarEventsImport_579171 = ref object of OpenApiRestCall_578355
proc url_CalendarEventsImport_579173(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/events/import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarEventsImport_579172(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports an event. This operation is used to add a private copy of an existing event to a calendar.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579174 = path.getOrDefault("calendarId")
  valid_579174 = validateParameter(valid_579174, JString, required = true,
                                 default = nil)
  if valid_579174 != nil:
    section.add "calendarId", valid_579174
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
  ##   supportsAttachments: JBool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   conferenceDataVersion: JInt
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579175 = query.getOrDefault("key")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "key", valid_579175
  var valid_579176 = query.getOrDefault("prettyPrint")
  valid_579176 = validateParameter(valid_579176, JBool, required = false,
                                 default = newJBool(true))
  if valid_579176 != nil:
    section.add "prettyPrint", valid_579176
  var valid_579177 = query.getOrDefault("oauth_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "oauth_token", valid_579177
  var valid_579178 = query.getOrDefault("alt")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = newJString("json"))
  if valid_579178 != nil:
    section.add "alt", valid_579178
  var valid_579179 = query.getOrDefault("userIp")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "userIp", valid_579179
  var valid_579180 = query.getOrDefault("quotaUser")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "quotaUser", valid_579180
  var valid_579181 = query.getOrDefault("supportsAttachments")
  valid_579181 = validateParameter(valid_579181, JBool, required = false, default = nil)
  if valid_579181 != nil:
    section.add "supportsAttachments", valid_579181
  var valid_579182 = query.getOrDefault("conferenceDataVersion")
  valid_579182 = validateParameter(valid_579182, JInt, required = false, default = nil)
  if valid_579182 != nil:
    section.add "conferenceDataVersion", valid_579182
  var valid_579183 = query.getOrDefault("fields")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "fields", valid_579183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579185: Call_CalendarEventsImport_579171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an event. This operation is used to add a private copy of an existing event to a calendar.
  ## 
  let valid = call_579185.validator(path, query, header, formData, body)
  let scheme = call_579185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579185.url(scheme.get, call_579185.host, call_579185.base,
                         call_579185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579185, url, valid)

proc call*(call_579186: Call_CalendarEventsImport_579171; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          supportsAttachments: bool = false; body: JsonNode = nil;
          conferenceDataVersion: int = 0; fields: string = ""): Recallable =
  ## calendarEventsImport
  ## Imports an event. This operation is used to add a private copy of an existing event to a calendar.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsAttachments: bool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   body: JObject
  ##   conferenceDataVersion: int
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579187 = newJObject()
  var query_579188 = newJObject()
  var body_579189 = newJObject()
  add(query_579188, "key", newJString(key))
  add(query_579188, "prettyPrint", newJBool(prettyPrint))
  add(query_579188, "oauth_token", newJString(oauthToken))
  add(path_579187, "calendarId", newJString(calendarId))
  add(query_579188, "alt", newJString(alt))
  add(query_579188, "userIp", newJString(userIp))
  add(query_579188, "quotaUser", newJString(quotaUser))
  add(query_579188, "supportsAttachments", newJBool(supportsAttachments))
  if body != nil:
    body_579189 = body
  add(query_579188, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_579188, "fields", newJString(fields))
  result = call_579186.call(path_579187, query_579188, nil, nil, body_579189)

var calendarEventsImport* = Call_CalendarEventsImport_579171(
    name: "calendarEventsImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/import",
    validator: validate_CalendarEventsImport_579172, base: "/calendar/v3",
    url: url_CalendarEventsImport_579173, schemes: {Scheme.Https})
type
  Call_CalendarEventsQuickAdd_579190 = ref object of OpenApiRestCall_578355
proc url_CalendarEventsQuickAdd_579192(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/events/quickAdd")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarEventsQuickAdd_579191(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an event based on a simple text string.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579193 = path.getOrDefault("calendarId")
  valid_579193 = validateParameter(valid_579193, JString, required = true,
                                 default = nil)
  if valid_579193 != nil:
    section.add "calendarId", valid_579193
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the creation of the event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   text: JString (required)
  ##       : The text describing the event to be created.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: JString
  ##              : Guests who should receive notifications about the creation of the new event.
  section = newJObject()
  var valid_579194 = query.getOrDefault("key")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "key", valid_579194
  var valid_579195 = query.getOrDefault("prettyPrint")
  valid_579195 = validateParameter(valid_579195, JBool, required = false,
                                 default = newJBool(true))
  if valid_579195 != nil:
    section.add "prettyPrint", valid_579195
  var valid_579196 = query.getOrDefault("oauth_token")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "oauth_token", valid_579196
  var valid_579197 = query.getOrDefault("sendNotifications")
  valid_579197 = validateParameter(valid_579197, JBool, required = false, default = nil)
  if valid_579197 != nil:
    section.add "sendNotifications", valid_579197
  var valid_579198 = query.getOrDefault("alt")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = newJString("json"))
  if valid_579198 != nil:
    section.add "alt", valid_579198
  var valid_579199 = query.getOrDefault("userIp")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "userIp", valid_579199
  var valid_579200 = query.getOrDefault("quotaUser")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "quotaUser", valid_579200
  assert query != nil, "query argument is necessary due to required `text` field"
  var valid_579201 = query.getOrDefault("text")
  valid_579201 = validateParameter(valid_579201, JString, required = true,
                                 default = nil)
  if valid_579201 != nil:
    section.add "text", valid_579201
  var valid_579202 = query.getOrDefault("fields")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "fields", valid_579202
  var valid_579203 = query.getOrDefault("sendUpdates")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = newJString("all"))
  if valid_579203 != nil:
    section.add "sendUpdates", valid_579203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579204: Call_CalendarEventsQuickAdd_579190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an event based on a simple text string.
  ## 
  let valid = call_579204.validator(path, query, header, formData, body)
  let scheme = call_579204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579204.url(scheme.get, call_579204.host, call_579204.base,
                         call_579204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579204, url, valid)

proc call*(call_579205: Call_CalendarEventsQuickAdd_579190; calendarId: string;
          text: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; sendNotifications: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; sendUpdates: string = "all"): Recallable =
  ## calendarEventsQuickAdd
  ## Creates an event based on a simple text string.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the creation of the event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   text: string (required)
  ##       : The text describing the event to be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: string
  ##              : Guests who should receive notifications about the creation of the new event.
  var path_579206 = newJObject()
  var query_579207 = newJObject()
  add(query_579207, "key", newJString(key))
  add(query_579207, "prettyPrint", newJBool(prettyPrint))
  add(query_579207, "oauth_token", newJString(oauthToken))
  add(query_579207, "sendNotifications", newJBool(sendNotifications))
  add(path_579206, "calendarId", newJString(calendarId))
  add(query_579207, "alt", newJString(alt))
  add(query_579207, "userIp", newJString(userIp))
  add(query_579207, "quotaUser", newJString(quotaUser))
  add(query_579207, "text", newJString(text))
  add(query_579207, "fields", newJString(fields))
  add(query_579207, "sendUpdates", newJString(sendUpdates))
  result = call_579205.call(path_579206, query_579207, nil, nil, nil)

var calendarEventsQuickAdd* = Call_CalendarEventsQuickAdd_579190(
    name: "calendarEventsQuickAdd", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/quickAdd",
    validator: validate_CalendarEventsQuickAdd_579191, base: "/calendar/v3",
    url: url_CalendarEventsQuickAdd_579192, schemes: {Scheme.Https})
type
  Call_CalendarEventsWatch_579208 = ref object of OpenApiRestCall_578355
proc url_CalendarEventsWatch_579210(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/events/watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarEventsWatch_579209(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Watch for changes to Events resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579211 = path.getOrDefault("calendarId")
  valid_579211 = validateParameter(valid_579211, JString, required = true,
                                 default = nil)
  if valid_579211 != nil:
    section.add "calendarId", valid_579211
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   iCalUID: JString
  ##          : Specifies event ID in the iCalendar format to be included in the response. Optional.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   q: JString
  ##    : Free text search terms to find events that match these terms in any field, except for extended properties. Optional.
  ##   privateExtendedProperty: JArray
  ##                          : Extended properties constraint specified as propertyName=value. Matches only private properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   timeMin: JString
  ##          : Lower bound (exclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMax is set, timeMin must be smaller than timeMax.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : The order of the events returned in the result. Optional. The default is an unspecified, stable order.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   timeZone: JString
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   timeMax: JString
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMin is set, timeMax must be greater than timeMin.
  ##   showHiddenInvitations: JBool
  ##                        : Whether to include hidden invitations in the result. Optional. The default is False.
  ##   singleEvents: JBool
  ##               : Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves. Optional. The default is False.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   sharedExtendedProperty: JArray
  ##                         : Extended properties constraint specified as propertyName=value. Matches only shared properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   updatedMin: JString
  ##             : Lower bound for an event's last modification time (as a RFC3339 timestamp) to filter by. When specified, entries deleted since this time will always be included regardless of showDeleted. Optional. The default is not to filter by last modification time.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All events deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## There are several query parameters that cannot be specified together with nextSyncToken to ensure consistency of the client state.
  ## 
  ## These are: 
  ## - iCalUID 
  ## - orderBy 
  ## - privateExtendedProperty 
  ## - q 
  ## - sharedExtendedProperty 
  ## - timeMin 
  ## - timeMax 
  ## - updatedMin If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: JBool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned. Optional. The default is False.
  ##   maxResults: JInt
  ##             : Maximum number of events returned on one result page. The number of events in the resulting page may be less than this value, or none at all, even if there are more events matching the query. Incomplete pages can be detected by a non-empty nextPageToken field in the response. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  section = newJObject()
  var valid_579212 = query.getOrDefault("key")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "key", valid_579212
  var valid_579213 = query.getOrDefault("prettyPrint")
  valid_579213 = validateParameter(valid_579213, JBool, required = false,
                                 default = newJBool(true))
  if valid_579213 != nil:
    section.add "prettyPrint", valid_579213
  var valid_579214 = query.getOrDefault("oauth_token")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "oauth_token", valid_579214
  var valid_579215 = query.getOrDefault("iCalUID")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "iCalUID", valid_579215
  var valid_579216 = query.getOrDefault("maxAttendees")
  valid_579216 = validateParameter(valid_579216, JInt, required = false, default = nil)
  if valid_579216 != nil:
    section.add "maxAttendees", valid_579216
  var valid_579217 = query.getOrDefault("q")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "q", valid_579217
  var valid_579218 = query.getOrDefault("privateExtendedProperty")
  valid_579218 = validateParameter(valid_579218, JArray, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "privateExtendedProperty", valid_579218
  var valid_579219 = query.getOrDefault("timeMin")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "timeMin", valid_579219
  var valid_579220 = query.getOrDefault("alt")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = newJString("json"))
  if valid_579220 != nil:
    section.add "alt", valid_579220
  var valid_579221 = query.getOrDefault("userIp")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "userIp", valid_579221
  var valid_579222 = query.getOrDefault("quotaUser")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "quotaUser", valid_579222
  var valid_579223 = query.getOrDefault("orderBy")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = newJString("startTime"))
  if valid_579223 != nil:
    section.add "orderBy", valid_579223
  var valid_579224 = query.getOrDefault("pageToken")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "pageToken", valid_579224
  var valid_579225 = query.getOrDefault("timeZone")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "timeZone", valid_579225
  var valid_579226 = query.getOrDefault("timeMax")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "timeMax", valid_579226
  var valid_579227 = query.getOrDefault("showHiddenInvitations")
  valid_579227 = validateParameter(valid_579227, JBool, required = false, default = nil)
  if valid_579227 != nil:
    section.add "showHiddenInvitations", valid_579227
  var valid_579228 = query.getOrDefault("singleEvents")
  valid_579228 = validateParameter(valid_579228, JBool, required = false, default = nil)
  if valid_579228 != nil:
    section.add "singleEvents", valid_579228
  var valid_579229 = query.getOrDefault("alwaysIncludeEmail")
  valid_579229 = validateParameter(valid_579229, JBool, required = false, default = nil)
  if valid_579229 != nil:
    section.add "alwaysIncludeEmail", valid_579229
  var valid_579230 = query.getOrDefault("sharedExtendedProperty")
  valid_579230 = validateParameter(valid_579230, JArray, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "sharedExtendedProperty", valid_579230
  var valid_579231 = query.getOrDefault("updatedMin")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "updatedMin", valid_579231
  var valid_579232 = query.getOrDefault("fields")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "fields", valid_579232
  var valid_579233 = query.getOrDefault("syncToken")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "syncToken", valid_579233
  var valid_579234 = query.getOrDefault("showDeleted")
  valid_579234 = validateParameter(valid_579234, JBool, required = false, default = nil)
  if valid_579234 != nil:
    section.add "showDeleted", valid_579234
  var valid_579235 = query.getOrDefault("maxResults")
  valid_579235 = validateParameter(valid_579235, JInt, required = false,
                                 default = newJInt(250))
  if valid_579235 != nil:
    section.add "maxResults", valid_579235
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

proc call*(call_579237: Call_CalendarEventsWatch_579208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to Events resources.
  ## 
  let valid = call_579237.validator(path, query, header, formData, body)
  let scheme = call_579237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579237.url(scheme.get, call_579237.host, call_579237.base,
                         call_579237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579237, url, valid)

proc call*(call_579238: Call_CalendarEventsWatch_579208; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          iCalUID: string = ""; maxAttendees: int = 0; q: string = "";
          privateExtendedProperty: JsonNode = nil; timeMin: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = "startTime"; pageToken: string = ""; timeZone: string = "";
          timeMax: string = ""; showHiddenInvitations: bool = false;
          singleEvents: bool = false; alwaysIncludeEmail: bool = false;
          sharedExtendedProperty: JsonNode = nil; resource: JsonNode = nil;
          updatedMin: string = ""; fields: string = ""; syncToken: string = "";
          showDeleted: bool = false; maxResults: int = 250): Recallable =
  ## calendarEventsWatch
  ## Watch for changes to Events resources.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   iCalUID: string
  ##          : Specifies event ID in the iCalendar format to be included in the response. Optional.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   q: string
  ##    : Free text search terms to find events that match these terms in any field, except for extended properties. Optional.
  ##   privateExtendedProperty: JArray
  ##                          : Extended properties constraint specified as propertyName=value. Matches only private properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   timeMin: string
  ##          : Lower bound (exclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMax is set, timeMin must be smaller than timeMax.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : The order of the events returned in the result. Optional. The default is an unspecified, stable order.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   timeZone: string
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   timeMax: string
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMin is set, timeMax must be greater than timeMin.
  ##   showHiddenInvitations: bool
  ##                        : Whether to include hidden invitations in the result. Optional. The default is False.
  ##   singleEvents: bool
  ##               : Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves. Optional. The default is False.
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   sharedExtendedProperty: JArray
  ##                         : Extended properties constraint specified as propertyName=value. Matches only shared properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   resource: JObject
  ##   updatedMin: string
  ##             : Lower bound for an event's last modification time (as a RFC3339 timestamp) to filter by. When specified, entries deleted since this time will always be included regardless of showDeleted. Optional. The default is not to filter by last modification time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All events deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## There are several query parameters that cannot be specified together with nextSyncToken to ensure consistency of the client state.
  ## 
  ## These are: 
  ## - iCalUID 
  ## - orderBy 
  ## - privateExtendedProperty 
  ## - q 
  ## - sharedExtendedProperty 
  ## - timeMin 
  ## - timeMax 
  ## - updatedMin If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: bool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned. Optional. The default is False.
  ##   maxResults: int
  ##             : Maximum number of events returned on one result page. The number of events in the resulting page may be less than this value, or none at all, even if there are more events matching the query. Incomplete pages can be detected by a non-empty nextPageToken field in the response. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  var path_579239 = newJObject()
  var query_579240 = newJObject()
  var body_579241 = newJObject()
  add(query_579240, "key", newJString(key))
  add(query_579240, "prettyPrint", newJBool(prettyPrint))
  add(query_579240, "oauth_token", newJString(oauthToken))
  add(query_579240, "iCalUID", newJString(iCalUID))
  add(path_579239, "calendarId", newJString(calendarId))
  add(query_579240, "maxAttendees", newJInt(maxAttendees))
  add(query_579240, "q", newJString(q))
  if privateExtendedProperty != nil:
    query_579240.add "privateExtendedProperty", privateExtendedProperty
  add(query_579240, "timeMin", newJString(timeMin))
  add(query_579240, "alt", newJString(alt))
  add(query_579240, "userIp", newJString(userIp))
  add(query_579240, "quotaUser", newJString(quotaUser))
  add(query_579240, "orderBy", newJString(orderBy))
  add(query_579240, "pageToken", newJString(pageToken))
  add(query_579240, "timeZone", newJString(timeZone))
  add(query_579240, "timeMax", newJString(timeMax))
  add(query_579240, "showHiddenInvitations", newJBool(showHiddenInvitations))
  add(query_579240, "singleEvents", newJBool(singleEvents))
  add(query_579240, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if sharedExtendedProperty != nil:
    query_579240.add "sharedExtendedProperty", sharedExtendedProperty
  if resource != nil:
    body_579241 = resource
  add(query_579240, "updatedMin", newJString(updatedMin))
  add(query_579240, "fields", newJString(fields))
  add(query_579240, "syncToken", newJString(syncToken))
  add(query_579240, "showDeleted", newJBool(showDeleted))
  add(query_579240, "maxResults", newJInt(maxResults))
  result = call_579238.call(path_579239, query_579240, nil, nil, body_579241)

var calendarEventsWatch* = Call_CalendarEventsWatch_579208(
    name: "calendarEventsWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/watch",
    validator: validate_CalendarEventsWatch_579209, base: "/calendar/v3",
    url: url_CalendarEventsWatch_579210, schemes: {Scheme.Https})
type
  Call_CalendarEventsUpdate_579261 = ref object of OpenApiRestCall_578355
proc url_CalendarEventsUpdate_579263(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  assert "eventId" in path, "`eventId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarEventsUpdate_579262(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   eventId: JString (required)
  ##          : Event identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579264 = path.getOrDefault("calendarId")
  valid_579264 = validateParameter(valid_579264, JString, required = true,
                                 default = nil)
  if valid_579264 != nil:
    section.add "calendarId", valid_579264
  var valid_579265 = path.getOrDefault("eventId")
  valid_579265 = validateParameter(valid_579265, JString, required = true,
                                 default = nil)
  if valid_579265 != nil:
    section.add "eventId", valid_579265
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the event update (for example, description changes, etc.). Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsAttachments: JBool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   conferenceDataVersion: JInt
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: JString
  ##              : Guests who should receive notifications about the event update (for example, title changes, etc.).
  section = newJObject()
  var valid_579266 = query.getOrDefault("key")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "key", valid_579266
  var valid_579267 = query.getOrDefault("prettyPrint")
  valid_579267 = validateParameter(valid_579267, JBool, required = false,
                                 default = newJBool(true))
  if valid_579267 != nil:
    section.add "prettyPrint", valid_579267
  var valid_579268 = query.getOrDefault("oauth_token")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "oauth_token", valid_579268
  var valid_579269 = query.getOrDefault("sendNotifications")
  valid_579269 = validateParameter(valid_579269, JBool, required = false, default = nil)
  if valid_579269 != nil:
    section.add "sendNotifications", valid_579269
  var valid_579270 = query.getOrDefault("maxAttendees")
  valid_579270 = validateParameter(valid_579270, JInt, required = false, default = nil)
  if valid_579270 != nil:
    section.add "maxAttendees", valid_579270
  var valid_579271 = query.getOrDefault("alt")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = newJString("json"))
  if valid_579271 != nil:
    section.add "alt", valid_579271
  var valid_579272 = query.getOrDefault("userIp")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "userIp", valid_579272
  var valid_579273 = query.getOrDefault("quotaUser")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "quotaUser", valid_579273
  var valid_579274 = query.getOrDefault("supportsAttachments")
  valid_579274 = validateParameter(valid_579274, JBool, required = false, default = nil)
  if valid_579274 != nil:
    section.add "supportsAttachments", valid_579274
  var valid_579275 = query.getOrDefault("alwaysIncludeEmail")
  valid_579275 = validateParameter(valid_579275, JBool, required = false, default = nil)
  if valid_579275 != nil:
    section.add "alwaysIncludeEmail", valid_579275
  var valid_579276 = query.getOrDefault("conferenceDataVersion")
  valid_579276 = validateParameter(valid_579276, JInt, required = false, default = nil)
  if valid_579276 != nil:
    section.add "conferenceDataVersion", valid_579276
  var valid_579277 = query.getOrDefault("fields")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "fields", valid_579277
  var valid_579278 = query.getOrDefault("sendUpdates")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = newJString("all"))
  if valid_579278 != nil:
    section.add "sendUpdates", valid_579278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579280: Call_CalendarEventsUpdate_579261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an event.
  ## 
  let valid = call_579280.validator(path, query, header, formData, body)
  let scheme = call_579280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579280.url(scheme.get, call_579280.host, call_579280.base,
                         call_579280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579280, url, valid)

proc call*(call_579281: Call_CalendarEventsUpdate_579261; calendarId: string;
          eventId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; sendNotifications: bool = false;
          maxAttendees: int = 0; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsAttachments: bool = false;
          alwaysIncludeEmail: bool = false; body: JsonNode = nil;
          conferenceDataVersion: int = 0; fields: string = "";
          sendUpdates: string = "all"): Recallable =
  ## calendarEventsUpdate
  ## Updates an event.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the event update (for example, description changes, etc.). Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   eventId: string (required)
  ##          : Event identifier.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsAttachments: bool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   body: JObject
  ##   conferenceDataVersion: int
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: string
  ##              : Guests who should receive notifications about the event update (for example, title changes, etc.).
  var path_579282 = newJObject()
  var query_579283 = newJObject()
  var body_579284 = newJObject()
  add(query_579283, "key", newJString(key))
  add(query_579283, "prettyPrint", newJBool(prettyPrint))
  add(query_579283, "oauth_token", newJString(oauthToken))
  add(query_579283, "sendNotifications", newJBool(sendNotifications))
  add(path_579282, "calendarId", newJString(calendarId))
  add(query_579283, "maxAttendees", newJInt(maxAttendees))
  add(path_579282, "eventId", newJString(eventId))
  add(query_579283, "alt", newJString(alt))
  add(query_579283, "userIp", newJString(userIp))
  add(query_579283, "quotaUser", newJString(quotaUser))
  add(query_579283, "supportsAttachments", newJBool(supportsAttachments))
  add(query_579283, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if body != nil:
    body_579284 = body
  add(query_579283, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_579283, "fields", newJString(fields))
  add(query_579283, "sendUpdates", newJString(sendUpdates))
  result = call_579281.call(path_579282, query_579283, nil, nil, body_579284)

var calendarEventsUpdate* = Call_CalendarEventsUpdate_579261(
    name: "calendarEventsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsUpdate_579262, base: "/calendar/v3",
    url: url_CalendarEventsUpdate_579263, schemes: {Scheme.Https})
type
  Call_CalendarEventsGet_579242 = ref object of OpenApiRestCall_578355
proc url_CalendarEventsGet_579244(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  assert "eventId" in path, "`eventId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarEventsGet_579243(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns an event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   eventId: JString (required)
  ##          : Event identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579245 = path.getOrDefault("calendarId")
  valid_579245 = validateParameter(valid_579245, JString, required = true,
                                 default = nil)
  if valid_579245 != nil:
    section.add "calendarId", valid_579245
  var valid_579246 = path.getOrDefault("eventId")
  valid_579246 = validateParameter(valid_579246, JString, required = true,
                                 default = nil)
  if valid_579246 != nil:
    section.add "eventId", valid_579246
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   timeZone: JString
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579247 = query.getOrDefault("key")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "key", valid_579247
  var valid_579248 = query.getOrDefault("prettyPrint")
  valid_579248 = validateParameter(valid_579248, JBool, required = false,
                                 default = newJBool(true))
  if valid_579248 != nil:
    section.add "prettyPrint", valid_579248
  var valid_579249 = query.getOrDefault("oauth_token")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "oauth_token", valid_579249
  var valid_579250 = query.getOrDefault("maxAttendees")
  valid_579250 = validateParameter(valid_579250, JInt, required = false, default = nil)
  if valid_579250 != nil:
    section.add "maxAttendees", valid_579250
  var valid_579251 = query.getOrDefault("alt")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = newJString("json"))
  if valid_579251 != nil:
    section.add "alt", valid_579251
  var valid_579252 = query.getOrDefault("userIp")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "userIp", valid_579252
  var valid_579253 = query.getOrDefault("quotaUser")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "quotaUser", valid_579253
  var valid_579254 = query.getOrDefault("timeZone")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "timeZone", valid_579254
  var valid_579255 = query.getOrDefault("alwaysIncludeEmail")
  valid_579255 = validateParameter(valid_579255, JBool, required = false, default = nil)
  if valid_579255 != nil:
    section.add "alwaysIncludeEmail", valid_579255
  var valid_579256 = query.getOrDefault("fields")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "fields", valid_579256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579257: Call_CalendarEventsGet_579242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an event.
  ## 
  let valid = call_579257.validator(path, query, header, formData, body)
  let scheme = call_579257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579257.url(scheme.get, call_579257.host, call_579257.base,
                         call_579257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579257, url, valid)

proc call*(call_579258: Call_CalendarEventsGet_579242; calendarId: string;
          eventId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; maxAttendees: int = 0; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; timeZone: string = "";
          alwaysIncludeEmail: bool = false; fields: string = ""): Recallable =
  ## calendarEventsGet
  ## Returns an event.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   eventId: string (required)
  ##          : Event identifier.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   timeZone: string
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579259 = newJObject()
  var query_579260 = newJObject()
  add(query_579260, "key", newJString(key))
  add(query_579260, "prettyPrint", newJBool(prettyPrint))
  add(query_579260, "oauth_token", newJString(oauthToken))
  add(path_579259, "calendarId", newJString(calendarId))
  add(query_579260, "maxAttendees", newJInt(maxAttendees))
  add(path_579259, "eventId", newJString(eventId))
  add(query_579260, "alt", newJString(alt))
  add(query_579260, "userIp", newJString(userIp))
  add(query_579260, "quotaUser", newJString(quotaUser))
  add(query_579260, "timeZone", newJString(timeZone))
  add(query_579260, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_579260, "fields", newJString(fields))
  result = call_579258.call(path_579259, query_579260, nil, nil, nil)

var calendarEventsGet* = Call_CalendarEventsGet_579242(name: "calendarEventsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsGet_579243, base: "/calendar/v3",
    url: url_CalendarEventsGet_579244, schemes: {Scheme.Https})
type
  Call_CalendarEventsPatch_579303 = ref object of OpenApiRestCall_578355
proc url_CalendarEventsPatch_579305(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  assert "eventId" in path, "`eventId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarEventsPatch_579304(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates an event. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   eventId: JString (required)
  ##          : Event identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579306 = path.getOrDefault("calendarId")
  valid_579306 = validateParameter(valid_579306, JString, required = true,
                                 default = nil)
  if valid_579306 != nil:
    section.add "calendarId", valid_579306
  var valid_579307 = path.getOrDefault("eventId")
  valid_579307 = validateParameter(valid_579307, JString, required = true,
                                 default = nil)
  if valid_579307 != nil:
    section.add "eventId", valid_579307
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the event update (for example, description changes, etc.). Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsAttachments: JBool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   conferenceDataVersion: JInt
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: JString
  ##              : Guests who should receive notifications about the event update (for example, title changes, etc.).
  section = newJObject()
  var valid_579308 = query.getOrDefault("key")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "key", valid_579308
  var valid_579309 = query.getOrDefault("prettyPrint")
  valid_579309 = validateParameter(valid_579309, JBool, required = false,
                                 default = newJBool(true))
  if valid_579309 != nil:
    section.add "prettyPrint", valid_579309
  var valid_579310 = query.getOrDefault("oauth_token")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "oauth_token", valid_579310
  var valid_579311 = query.getOrDefault("sendNotifications")
  valid_579311 = validateParameter(valid_579311, JBool, required = false, default = nil)
  if valid_579311 != nil:
    section.add "sendNotifications", valid_579311
  var valid_579312 = query.getOrDefault("maxAttendees")
  valid_579312 = validateParameter(valid_579312, JInt, required = false, default = nil)
  if valid_579312 != nil:
    section.add "maxAttendees", valid_579312
  var valid_579313 = query.getOrDefault("alt")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = newJString("json"))
  if valid_579313 != nil:
    section.add "alt", valid_579313
  var valid_579314 = query.getOrDefault("userIp")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "userIp", valid_579314
  var valid_579315 = query.getOrDefault("quotaUser")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "quotaUser", valid_579315
  var valid_579316 = query.getOrDefault("supportsAttachments")
  valid_579316 = validateParameter(valid_579316, JBool, required = false, default = nil)
  if valid_579316 != nil:
    section.add "supportsAttachments", valid_579316
  var valid_579317 = query.getOrDefault("alwaysIncludeEmail")
  valid_579317 = validateParameter(valid_579317, JBool, required = false, default = nil)
  if valid_579317 != nil:
    section.add "alwaysIncludeEmail", valid_579317
  var valid_579318 = query.getOrDefault("conferenceDataVersion")
  valid_579318 = validateParameter(valid_579318, JInt, required = false, default = nil)
  if valid_579318 != nil:
    section.add "conferenceDataVersion", valid_579318
  var valid_579319 = query.getOrDefault("fields")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "fields", valid_579319
  var valid_579320 = query.getOrDefault("sendUpdates")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = newJString("all"))
  if valid_579320 != nil:
    section.add "sendUpdates", valid_579320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579322: Call_CalendarEventsPatch_579303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an event. This method supports patch semantics.
  ## 
  let valid = call_579322.validator(path, query, header, formData, body)
  let scheme = call_579322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579322.url(scheme.get, call_579322.host, call_579322.base,
                         call_579322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579322, url, valid)

proc call*(call_579323: Call_CalendarEventsPatch_579303; calendarId: string;
          eventId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; sendNotifications: bool = false;
          maxAttendees: int = 0; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; supportsAttachments: bool = false;
          alwaysIncludeEmail: bool = false; body: JsonNode = nil;
          conferenceDataVersion: int = 0; fields: string = "";
          sendUpdates: string = "all"): Recallable =
  ## calendarEventsPatch
  ## Updates an event. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the event update (for example, description changes, etc.). Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   eventId: string (required)
  ##          : Event identifier.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   supportsAttachments: bool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   body: JObject
  ##   conferenceDataVersion: int
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: string
  ##              : Guests who should receive notifications about the event update (for example, title changes, etc.).
  var path_579324 = newJObject()
  var query_579325 = newJObject()
  var body_579326 = newJObject()
  add(query_579325, "key", newJString(key))
  add(query_579325, "prettyPrint", newJBool(prettyPrint))
  add(query_579325, "oauth_token", newJString(oauthToken))
  add(query_579325, "sendNotifications", newJBool(sendNotifications))
  add(path_579324, "calendarId", newJString(calendarId))
  add(query_579325, "maxAttendees", newJInt(maxAttendees))
  add(path_579324, "eventId", newJString(eventId))
  add(query_579325, "alt", newJString(alt))
  add(query_579325, "userIp", newJString(userIp))
  add(query_579325, "quotaUser", newJString(quotaUser))
  add(query_579325, "supportsAttachments", newJBool(supportsAttachments))
  add(query_579325, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if body != nil:
    body_579326 = body
  add(query_579325, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_579325, "fields", newJString(fields))
  add(query_579325, "sendUpdates", newJString(sendUpdates))
  result = call_579323.call(path_579324, query_579325, nil, nil, body_579326)

var calendarEventsPatch* = Call_CalendarEventsPatch_579303(
    name: "calendarEventsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsPatch_579304, base: "/calendar/v3",
    url: url_CalendarEventsPatch_579305, schemes: {Scheme.Https})
type
  Call_CalendarEventsDelete_579285 = ref object of OpenApiRestCall_578355
proc url_CalendarEventsDelete_579287(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  assert "eventId" in path, "`eventId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarEventsDelete_579286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   eventId: JString (required)
  ##          : Event identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579288 = path.getOrDefault("calendarId")
  valid_579288 = validateParameter(valid_579288, JString, required = true,
                                 default = nil)
  if valid_579288 != nil:
    section.add "calendarId", valid_579288
  var valid_579289 = path.getOrDefault("eventId")
  valid_579289 = validateParameter(valid_579289, JString, required = true,
                                 default = nil)
  if valid_579289 != nil:
    section.add "eventId", valid_579289
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the deletion of the event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: JString
  ##              : Guests who should receive notifications about the deletion of the event.
  section = newJObject()
  var valid_579290 = query.getOrDefault("key")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "key", valid_579290
  var valid_579291 = query.getOrDefault("prettyPrint")
  valid_579291 = validateParameter(valid_579291, JBool, required = false,
                                 default = newJBool(true))
  if valid_579291 != nil:
    section.add "prettyPrint", valid_579291
  var valid_579292 = query.getOrDefault("oauth_token")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "oauth_token", valid_579292
  var valid_579293 = query.getOrDefault("sendNotifications")
  valid_579293 = validateParameter(valid_579293, JBool, required = false, default = nil)
  if valid_579293 != nil:
    section.add "sendNotifications", valid_579293
  var valid_579294 = query.getOrDefault("alt")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = newJString("json"))
  if valid_579294 != nil:
    section.add "alt", valid_579294
  var valid_579295 = query.getOrDefault("userIp")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "userIp", valid_579295
  var valid_579296 = query.getOrDefault("quotaUser")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "quotaUser", valid_579296
  var valid_579297 = query.getOrDefault("fields")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "fields", valid_579297
  var valid_579298 = query.getOrDefault("sendUpdates")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = newJString("all"))
  if valid_579298 != nil:
    section.add "sendUpdates", valid_579298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579299: Call_CalendarEventsDelete_579285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an event.
  ## 
  let valid = call_579299.validator(path, query, header, formData, body)
  let scheme = call_579299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579299.url(scheme.get, call_579299.host, call_579299.base,
                         call_579299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579299, url, valid)

proc call*(call_579300: Call_CalendarEventsDelete_579285; calendarId: string;
          eventId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; sendNotifications: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; sendUpdates: string = "all"): Recallable =
  ## calendarEventsDelete
  ## Deletes an event.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the deletion of the event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   eventId: string (required)
  ##          : Event identifier.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: string
  ##              : Guests who should receive notifications about the deletion of the event.
  var path_579301 = newJObject()
  var query_579302 = newJObject()
  add(query_579302, "key", newJString(key))
  add(query_579302, "prettyPrint", newJBool(prettyPrint))
  add(query_579302, "oauth_token", newJString(oauthToken))
  add(query_579302, "sendNotifications", newJBool(sendNotifications))
  add(path_579301, "calendarId", newJString(calendarId))
  add(path_579301, "eventId", newJString(eventId))
  add(query_579302, "alt", newJString(alt))
  add(query_579302, "userIp", newJString(userIp))
  add(query_579302, "quotaUser", newJString(quotaUser))
  add(query_579302, "fields", newJString(fields))
  add(query_579302, "sendUpdates", newJString(sendUpdates))
  result = call_579300.call(path_579301, query_579302, nil, nil, nil)

var calendarEventsDelete* = Call_CalendarEventsDelete_579285(
    name: "calendarEventsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsDelete_579286, base: "/calendar/v3",
    url: url_CalendarEventsDelete_579287, schemes: {Scheme.Https})
type
  Call_CalendarEventsInstances_579327 = ref object of OpenApiRestCall_578355
proc url_CalendarEventsInstances_579329(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  assert "eventId" in path, "`eventId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventId"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarEventsInstances_579328(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns instances of the specified recurring event.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   eventId: JString (required)
  ##          : Recurring event identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579330 = path.getOrDefault("calendarId")
  valid_579330 = validateParameter(valid_579330, JString, required = true,
                                 default = nil)
  if valid_579330 != nil:
    section.add "calendarId", valid_579330
  var valid_579331 = path.getOrDefault("eventId")
  valid_579331 = validateParameter(valid_579331, JString, required = true,
                                 default = nil)
  if valid_579331 != nil:
    section.add "eventId", valid_579331
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   originalStart: JString
  ##                : The original start time of the instance in the result. Optional.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   timeMin: JString
  ##          : Lower bound (inclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   timeZone: JString
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   timeMax: JString
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   showDeleted: JBool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events will still be included if singleEvents is False. Optional. The default is False.
  ##   maxResults: JInt
  ##             : Maximum number of events returned on one result page. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  section = newJObject()
  var valid_579332 = query.getOrDefault("key")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "key", valid_579332
  var valid_579333 = query.getOrDefault("prettyPrint")
  valid_579333 = validateParameter(valid_579333, JBool, required = false,
                                 default = newJBool(true))
  if valid_579333 != nil:
    section.add "prettyPrint", valid_579333
  var valid_579334 = query.getOrDefault("oauth_token")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "oauth_token", valid_579334
  var valid_579335 = query.getOrDefault("originalStart")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "originalStart", valid_579335
  var valid_579336 = query.getOrDefault("maxAttendees")
  valid_579336 = validateParameter(valid_579336, JInt, required = false, default = nil)
  if valid_579336 != nil:
    section.add "maxAttendees", valid_579336
  var valid_579337 = query.getOrDefault("timeMin")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "timeMin", valid_579337
  var valid_579338 = query.getOrDefault("alt")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = newJString("json"))
  if valid_579338 != nil:
    section.add "alt", valid_579338
  var valid_579339 = query.getOrDefault("userIp")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "userIp", valid_579339
  var valid_579340 = query.getOrDefault("quotaUser")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "quotaUser", valid_579340
  var valid_579341 = query.getOrDefault("pageToken")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "pageToken", valid_579341
  var valid_579342 = query.getOrDefault("timeZone")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "timeZone", valid_579342
  var valid_579343 = query.getOrDefault("timeMax")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "timeMax", valid_579343
  var valid_579344 = query.getOrDefault("alwaysIncludeEmail")
  valid_579344 = validateParameter(valid_579344, JBool, required = false, default = nil)
  if valid_579344 != nil:
    section.add "alwaysIncludeEmail", valid_579344
  var valid_579345 = query.getOrDefault("fields")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "fields", valid_579345
  var valid_579346 = query.getOrDefault("showDeleted")
  valid_579346 = validateParameter(valid_579346, JBool, required = false, default = nil)
  if valid_579346 != nil:
    section.add "showDeleted", valid_579346
  var valid_579347 = query.getOrDefault("maxResults")
  valid_579347 = validateParameter(valid_579347, JInt, required = false, default = nil)
  if valid_579347 != nil:
    section.add "maxResults", valid_579347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579348: Call_CalendarEventsInstances_579327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns instances of the specified recurring event.
  ## 
  let valid = call_579348.validator(path, query, header, formData, body)
  let scheme = call_579348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579348.url(scheme.get, call_579348.host, call_579348.base,
                         call_579348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579348, url, valid)

proc call*(call_579349: Call_CalendarEventsInstances_579327; calendarId: string;
          eventId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; originalStart: string = ""; maxAttendees: int = 0;
          timeMin: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; timeZone: string = "";
          timeMax: string = ""; alwaysIncludeEmail: bool = false; fields: string = "";
          showDeleted: bool = false; maxResults: int = 0): Recallable =
  ## calendarEventsInstances
  ## Returns instances of the specified recurring event.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   originalStart: string
  ##                : The original start time of the instance in the result. Optional.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   eventId: string (required)
  ##          : Recurring event identifier.
  ##   timeMin: string
  ##          : Lower bound (inclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   timeZone: string
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   timeMax: string
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset.
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   showDeleted: bool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events will still be included if singleEvents is False. Optional. The default is False.
  ##   maxResults: int
  ##             : Maximum number of events returned on one result page. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  var path_579350 = newJObject()
  var query_579351 = newJObject()
  add(query_579351, "key", newJString(key))
  add(query_579351, "prettyPrint", newJBool(prettyPrint))
  add(query_579351, "oauth_token", newJString(oauthToken))
  add(query_579351, "originalStart", newJString(originalStart))
  add(path_579350, "calendarId", newJString(calendarId))
  add(query_579351, "maxAttendees", newJInt(maxAttendees))
  add(path_579350, "eventId", newJString(eventId))
  add(query_579351, "timeMin", newJString(timeMin))
  add(query_579351, "alt", newJString(alt))
  add(query_579351, "userIp", newJString(userIp))
  add(query_579351, "quotaUser", newJString(quotaUser))
  add(query_579351, "pageToken", newJString(pageToken))
  add(query_579351, "timeZone", newJString(timeZone))
  add(query_579351, "timeMax", newJString(timeMax))
  add(query_579351, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_579351, "fields", newJString(fields))
  add(query_579351, "showDeleted", newJBool(showDeleted))
  add(query_579351, "maxResults", newJInt(maxResults))
  result = call_579349.call(path_579350, query_579351, nil, nil, nil)

var calendarEventsInstances* = Call_CalendarEventsInstances_579327(
    name: "calendarEventsInstances", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}/instances",
    validator: validate_CalendarEventsInstances_579328, base: "/calendar/v3",
    url: url_CalendarEventsInstances_579329, schemes: {Scheme.Https})
type
  Call_CalendarEventsMove_579352 = ref object of OpenApiRestCall_578355
proc url_CalendarEventsMove_579354(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  assert "eventId" in path, "`eventId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId"),
               (kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventId"),
               (kind: ConstantSegment, value: "/move")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarEventsMove_579353(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Moves an event to another calendar, i.e. changes an event's organizer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier of the source calendar where the event currently is on.
  ##   eventId: JString (required)
  ##          : Event identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579355 = path.getOrDefault("calendarId")
  valid_579355 = validateParameter(valid_579355, JString, required = true,
                                 default = nil)
  if valid_579355 != nil:
    section.add "calendarId", valid_579355
  var valid_579356 = path.getOrDefault("eventId")
  valid_579356 = validateParameter(valid_579356, JString, required = true,
                                 default = nil)
  if valid_579356 != nil:
    section.add "eventId", valid_579356
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the change of the event's organizer. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   destination: JString (required)
  ##              : Calendar identifier of the target calendar where the event is to be moved to.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: JString
  ##              : Guests who should receive notifications about the change of the event's organizer.
  section = newJObject()
  var valid_579357 = query.getOrDefault("key")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "key", valid_579357
  var valid_579358 = query.getOrDefault("prettyPrint")
  valid_579358 = validateParameter(valid_579358, JBool, required = false,
                                 default = newJBool(true))
  if valid_579358 != nil:
    section.add "prettyPrint", valid_579358
  var valid_579359 = query.getOrDefault("oauth_token")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "oauth_token", valid_579359
  var valid_579360 = query.getOrDefault("sendNotifications")
  valid_579360 = validateParameter(valid_579360, JBool, required = false, default = nil)
  if valid_579360 != nil:
    section.add "sendNotifications", valid_579360
  var valid_579361 = query.getOrDefault("alt")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = newJString("json"))
  if valid_579361 != nil:
    section.add "alt", valid_579361
  var valid_579362 = query.getOrDefault("userIp")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "userIp", valid_579362
  var valid_579363 = query.getOrDefault("quotaUser")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "quotaUser", valid_579363
  assert query != nil,
        "query argument is necessary due to required `destination` field"
  var valid_579364 = query.getOrDefault("destination")
  valid_579364 = validateParameter(valid_579364, JString, required = true,
                                 default = nil)
  if valid_579364 != nil:
    section.add "destination", valid_579364
  var valid_579365 = query.getOrDefault("fields")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "fields", valid_579365
  var valid_579366 = query.getOrDefault("sendUpdates")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = newJString("all"))
  if valid_579366 != nil:
    section.add "sendUpdates", valid_579366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579367: Call_CalendarEventsMove_579352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves an event to another calendar, i.e. changes an event's organizer.
  ## 
  let valid = call_579367.validator(path, query, header, formData, body)
  let scheme = call_579367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579367.url(scheme.get, call_579367.host, call_579367.base,
                         call_579367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579367, url, valid)

proc call*(call_579368: Call_CalendarEventsMove_579352; calendarId: string;
          eventId: string; destination: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          sendNotifications: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""; sendUpdates: string = "all"): Recallable =
  ## calendarEventsMove
  ## Moves an event to another calendar, i.e. changes an event's organizer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the change of the event's organizer. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   calendarId: string (required)
  ##             : Calendar identifier of the source calendar where the event currently is on.
  ##   eventId: string (required)
  ##          : Event identifier.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   destination: string (required)
  ##              : Calendar identifier of the target calendar where the event is to be moved to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   sendUpdates: string
  ##              : Guests who should receive notifications about the change of the event's organizer.
  var path_579369 = newJObject()
  var query_579370 = newJObject()
  add(query_579370, "key", newJString(key))
  add(query_579370, "prettyPrint", newJBool(prettyPrint))
  add(query_579370, "oauth_token", newJString(oauthToken))
  add(query_579370, "sendNotifications", newJBool(sendNotifications))
  add(path_579369, "calendarId", newJString(calendarId))
  add(path_579369, "eventId", newJString(eventId))
  add(query_579370, "alt", newJString(alt))
  add(query_579370, "userIp", newJString(userIp))
  add(query_579370, "quotaUser", newJString(quotaUser))
  add(query_579370, "destination", newJString(destination))
  add(query_579370, "fields", newJString(fields))
  add(query_579370, "sendUpdates", newJString(sendUpdates))
  result = call_579368.call(path_579369, query_579370, nil, nil, nil)

var calendarEventsMove* = Call_CalendarEventsMove_579352(
    name: "calendarEventsMove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}/move",
    validator: validate_CalendarEventsMove_579353, base: "/calendar/v3",
    url: url_CalendarEventsMove_579354, schemes: {Scheme.Https})
type
  Call_CalendarChannelsStop_579371 = ref object of OpenApiRestCall_578355
proc url_CalendarChannelsStop_579373(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarChannelsStop_579372(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579374 = query.getOrDefault("key")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "key", valid_579374
  var valid_579375 = query.getOrDefault("prettyPrint")
  valid_579375 = validateParameter(valid_579375, JBool, required = false,
                                 default = newJBool(true))
  if valid_579375 != nil:
    section.add "prettyPrint", valid_579375
  var valid_579376 = query.getOrDefault("oauth_token")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "oauth_token", valid_579376
  var valid_579377 = query.getOrDefault("alt")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = newJString("json"))
  if valid_579377 != nil:
    section.add "alt", valid_579377
  var valid_579378 = query.getOrDefault("userIp")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "userIp", valid_579378
  var valid_579379 = query.getOrDefault("quotaUser")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "quotaUser", valid_579379
  var valid_579380 = query.getOrDefault("fields")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "fields", valid_579380
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

proc call*(call_579382: Call_CalendarChannelsStop_579371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_579382.validator(path, query, header, formData, body)
  let scheme = call_579382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579382.url(scheme.get, call_579382.host, call_579382.base,
                         call_579382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579382, url, valid)

proc call*(call_579383: Call_CalendarChannelsStop_579371; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; resource: JsonNode = nil;
          fields: string = ""): Recallable =
  ## calendarChannelsStop
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
  var query_579384 = newJObject()
  var body_579385 = newJObject()
  add(query_579384, "key", newJString(key))
  add(query_579384, "prettyPrint", newJBool(prettyPrint))
  add(query_579384, "oauth_token", newJString(oauthToken))
  add(query_579384, "alt", newJString(alt))
  add(query_579384, "userIp", newJString(userIp))
  add(query_579384, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_579385 = resource
  add(query_579384, "fields", newJString(fields))
  result = call_579383.call(nil, query_579384, nil, nil, body_579385)

var calendarChannelsStop* = Call_CalendarChannelsStop_579371(
    name: "calendarChannelsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_CalendarChannelsStop_579372, base: "/calendar/v3",
    url: url_CalendarChannelsStop_579373, schemes: {Scheme.Https})
type
  Call_CalendarColorsGet_579386 = ref object of OpenApiRestCall_578355
proc url_CalendarColorsGet_579388(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarColorsGet_579387(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the color definitions for calendars and events.
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
  var valid_579389 = query.getOrDefault("key")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "key", valid_579389
  var valid_579390 = query.getOrDefault("prettyPrint")
  valid_579390 = validateParameter(valid_579390, JBool, required = false,
                                 default = newJBool(true))
  if valid_579390 != nil:
    section.add "prettyPrint", valid_579390
  var valid_579391 = query.getOrDefault("oauth_token")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = nil)
  if valid_579391 != nil:
    section.add "oauth_token", valid_579391
  var valid_579392 = query.getOrDefault("alt")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = newJString("json"))
  if valid_579392 != nil:
    section.add "alt", valid_579392
  var valid_579393 = query.getOrDefault("userIp")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = nil)
  if valid_579393 != nil:
    section.add "userIp", valid_579393
  var valid_579394 = query.getOrDefault("quotaUser")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "quotaUser", valid_579394
  var valid_579395 = query.getOrDefault("fields")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "fields", valid_579395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579396: Call_CalendarColorsGet_579386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the color definitions for calendars and events.
  ## 
  let valid = call_579396.validator(path, query, header, formData, body)
  let scheme = call_579396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579396.url(scheme.get, call_579396.host, call_579396.base,
                         call_579396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579396, url, valid)

proc call*(call_579397: Call_CalendarColorsGet_579386; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## calendarColorsGet
  ## Returns the color definitions for calendars and events.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579398 = newJObject()
  add(query_579398, "key", newJString(key))
  add(query_579398, "prettyPrint", newJBool(prettyPrint))
  add(query_579398, "oauth_token", newJString(oauthToken))
  add(query_579398, "alt", newJString(alt))
  add(query_579398, "userIp", newJString(userIp))
  add(query_579398, "quotaUser", newJString(quotaUser))
  add(query_579398, "fields", newJString(fields))
  result = call_579397.call(nil, query_579398, nil, nil, nil)

var calendarColorsGet* = Call_CalendarColorsGet_579386(name: "calendarColorsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/colors",
    validator: validate_CalendarColorsGet_579387, base: "/calendar/v3",
    url: url_CalendarColorsGet_579388, schemes: {Scheme.Https})
type
  Call_CalendarFreebusyQuery_579399 = ref object of OpenApiRestCall_578355
proc url_CalendarFreebusyQuery_579401(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarFreebusyQuery_579400(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns free/busy information for a set of calendars.
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
  var valid_579402 = query.getOrDefault("key")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "key", valid_579402
  var valid_579403 = query.getOrDefault("prettyPrint")
  valid_579403 = validateParameter(valid_579403, JBool, required = false,
                                 default = newJBool(true))
  if valid_579403 != nil:
    section.add "prettyPrint", valid_579403
  var valid_579404 = query.getOrDefault("oauth_token")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "oauth_token", valid_579404
  var valid_579405 = query.getOrDefault("alt")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = newJString("json"))
  if valid_579405 != nil:
    section.add "alt", valid_579405
  var valid_579406 = query.getOrDefault("userIp")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "userIp", valid_579406
  var valid_579407 = query.getOrDefault("quotaUser")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "quotaUser", valid_579407
  var valid_579408 = query.getOrDefault("fields")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "fields", valid_579408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579410: Call_CalendarFreebusyQuery_579399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns free/busy information for a set of calendars.
  ## 
  let valid = call_579410.validator(path, query, header, formData, body)
  let scheme = call_579410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579410.url(scheme.get, call_579410.host, call_579410.base,
                         call_579410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579410, url, valid)

proc call*(call_579411: Call_CalendarFreebusyQuery_579399; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## calendarFreebusyQuery
  ## Returns free/busy information for a set of calendars.
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579412 = newJObject()
  var body_579413 = newJObject()
  add(query_579412, "key", newJString(key))
  add(query_579412, "prettyPrint", newJBool(prettyPrint))
  add(query_579412, "oauth_token", newJString(oauthToken))
  add(query_579412, "alt", newJString(alt))
  add(query_579412, "userIp", newJString(userIp))
  add(query_579412, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579413 = body
  add(query_579412, "fields", newJString(fields))
  result = call_579411.call(nil, query_579412, nil, nil, body_579413)

var calendarFreebusyQuery* = Call_CalendarFreebusyQuery_579399(
    name: "calendarFreebusyQuery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/freeBusy",
    validator: validate_CalendarFreebusyQuery_579400, base: "/calendar/v3",
    url: url_CalendarFreebusyQuery_579401, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListInsert_579433 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarListInsert_579435(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarListInsert_579434(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts an existing calendar into the user's calendar list.
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
  ##   colorRgbFormat: JBool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579436 = query.getOrDefault("key")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "key", valid_579436
  var valid_579437 = query.getOrDefault("prettyPrint")
  valid_579437 = validateParameter(valid_579437, JBool, required = false,
                                 default = newJBool(true))
  if valid_579437 != nil:
    section.add "prettyPrint", valid_579437
  var valid_579438 = query.getOrDefault("oauth_token")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "oauth_token", valid_579438
  var valid_579439 = query.getOrDefault("alt")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = newJString("json"))
  if valid_579439 != nil:
    section.add "alt", valid_579439
  var valid_579440 = query.getOrDefault("userIp")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "userIp", valid_579440
  var valid_579441 = query.getOrDefault("quotaUser")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "quotaUser", valid_579441
  var valid_579442 = query.getOrDefault("colorRgbFormat")
  valid_579442 = validateParameter(valid_579442, JBool, required = false, default = nil)
  if valid_579442 != nil:
    section.add "colorRgbFormat", valid_579442
  var valid_579443 = query.getOrDefault("fields")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "fields", valid_579443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579445: Call_CalendarCalendarListInsert_579433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts an existing calendar into the user's calendar list.
  ## 
  let valid = call_579445.validator(path, query, header, formData, body)
  let scheme = call_579445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579445.url(scheme.get, call_579445.host, call_579445.base,
                         call_579445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579445, url, valid)

proc call*(call_579446: Call_CalendarCalendarListInsert_579433; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; colorRgbFormat: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## calendarCalendarListInsert
  ## Inserts an existing calendar into the user's calendar list.
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
  ##   colorRgbFormat: bool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579447 = newJObject()
  var body_579448 = newJObject()
  add(query_579447, "key", newJString(key))
  add(query_579447, "prettyPrint", newJBool(prettyPrint))
  add(query_579447, "oauth_token", newJString(oauthToken))
  add(query_579447, "alt", newJString(alt))
  add(query_579447, "userIp", newJString(userIp))
  add(query_579447, "quotaUser", newJString(quotaUser))
  add(query_579447, "colorRgbFormat", newJBool(colorRgbFormat))
  if body != nil:
    body_579448 = body
  add(query_579447, "fields", newJString(fields))
  result = call_579446.call(nil, query_579447, nil, nil, body_579448)

var calendarCalendarListInsert* = Call_CalendarCalendarListInsert_579433(
    name: "calendarCalendarListInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/calendarList",
    validator: validate_CalendarCalendarListInsert_579434, base: "/calendar/v3",
    url: url_CalendarCalendarListInsert_579435, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListList_579414 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarListList_579416(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarListList_579415(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the calendars on the user's calendar list.
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
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   showHidden: JBool
  ##             : Whether to show hidden entries. Optional. The default is False.
  ##   minAccessRole: JString
  ##                : The minimum access role for the user in the returned entries. Optional. The default is no restriction.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.
  ## To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: JBool
  ##              : Whether to include deleted calendar list entries in the result. Optional. The default is False.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  section = newJObject()
  var valid_579417 = query.getOrDefault("key")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "key", valid_579417
  var valid_579418 = query.getOrDefault("prettyPrint")
  valid_579418 = validateParameter(valid_579418, JBool, required = false,
                                 default = newJBool(true))
  if valid_579418 != nil:
    section.add "prettyPrint", valid_579418
  var valid_579419 = query.getOrDefault("oauth_token")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "oauth_token", valid_579419
  var valid_579420 = query.getOrDefault("alt")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = newJString("json"))
  if valid_579420 != nil:
    section.add "alt", valid_579420
  var valid_579421 = query.getOrDefault("userIp")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "userIp", valid_579421
  var valid_579422 = query.getOrDefault("quotaUser")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "quotaUser", valid_579422
  var valid_579423 = query.getOrDefault("pageToken")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "pageToken", valid_579423
  var valid_579424 = query.getOrDefault("showHidden")
  valid_579424 = validateParameter(valid_579424, JBool, required = false, default = nil)
  if valid_579424 != nil:
    section.add "showHidden", valid_579424
  var valid_579425 = query.getOrDefault("minAccessRole")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = newJString("freeBusyReader"))
  if valid_579425 != nil:
    section.add "minAccessRole", valid_579425
  var valid_579426 = query.getOrDefault("fields")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "fields", valid_579426
  var valid_579427 = query.getOrDefault("syncToken")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "syncToken", valid_579427
  var valid_579428 = query.getOrDefault("showDeleted")
  valid_579428 = validateParameter(valid_579428, JBool, required = false, default = nil)
  if valid_579428 != nil:
    section.add "showDeleted", valid_579428
  var valid_579429 = query.getOrDefault("maxResults")
  valid_579429 = validateParameter(valid_579429, JInt, required = false, default = nil)
  if valid_579429 != nil:
    section.add "maxResults", valid_579429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579430: Call_CalendarCalendarListList_579414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the calendars on the user's calendar list.
  ## 
  let valid = call_579430.validator(path, query, header, formData, body)
  let scheme = call_579430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579430.url(scheme.get, call_579430.host, call_579430.base,
                         call_579430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579430, url, valid)

proc call*(call_579431: Call_CalendarCalendarListList_579414; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          showHidden: bool = false; minAccessRole: string = "freeBusyReader";
          fields: string = ""; syncToken: string = ""; showDeleted: bool = false;
          maxResults: int = 0): Recallable =
  ## calendarCalendarListList
  ## Returns the calendars on the user's calendar list.
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
  ##            : Token specifying which result page to return. Optional.
  ##   showHidden: bool
  ##             : Whether to show hidden entries. Optional. The default is False.
  ##   minAccessRole: string
  ##                : The minimum access role for the user in the returned entries. Optional. The default is no restriction.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.
  ## To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: bool
  ##              : Whether to include deleted calendar list entries in the result. Optional. The default is False.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  var query_579432 = newJObject()
  add(query_579432, "key", newJString(key))
  add(query_579432, "prettyPrint", newJBool(prettyPrint))
  add(query_579432, "oauth_token", newJString(oauthToken))
  add(query_579432, "alt", newJString(alt))
  add(query_579432, "userIp", newJString(userIp))
  add(query_579432, "quotaUser", newJString(quotaUser))
  add(query_579432, "pageToken", newJString(pageToken))
  add(query_579432, "showHidden", newJBool(showHidden))
  add(query_579432, "minAccessRole", newJString(minAccessRole))
  add(query_579432, "fields", newJString(fields))
  add(query_579432, "syncToken", newJString(syncToken))
  add(query_579432, "showDeleted", newJBool(showDeleted))
  add(query_579432, "maxResults", newJInt(maxResults))
  result = call_579431.call(nil, query_579432, nil, nil, nil)

var calendarCalendarListList* = Call_CalendarCalendarListList_579414(
    name: "calendarCalendarListList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/calendarList",
    validator: validate_CalendarCalendarListList_579415, base: "/calendar/v3",
    url: url_CalendarCalendarListList_579416, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListWatch_579449 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarListWatch_579451(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarListWatch_579450(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watch for changes to CalendarList resources.
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
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   showHidden: JBool
  ##             : Whether to show hidden entries. Optional. The default is False.
  ##   minAccessRole: JString
  ##                : The minimum access role for the user in the returned entries. Optional. The default is no restriction.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.
  ## To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: JBool
  ##              : Whether to include deleted calendar list entries in the result. Optional. The default is False.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  section = newJObject()
  var valid_579452 = query.getOrDefault("key")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = nil)
  if valid_579452 != nil:
    section.add "key", valid_579452
  var valid_579453 = query.getOrDefault("prettyPrint")
  valid_579453 = validateParameter(valid_579453, JBool, required = false,
                                 default = newJBool(true))
  if valid_579453 != nil:
    section.add "prettyPrint", valid_579453
  var valid_579454 = query.getOrDefault("oauth_token")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "oauth_token", valid_579454
  var valid_579455 = query.getOrDefault("alt")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = newJString("json"))
  if valid_579455 != nil:
    section.add "alt", valid_579455
  var valid_579456 = query.getOrDefault("userIp")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = nil)
  if valid_579456 != nil:
    section.add "userIp", valid_579456
  var valid_579457 = query.getOrDefault("quotaUser")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "quotaUser", valid_579457
  var valid_579458 = query.getOrDefault("pageToken")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "pageToken", valid_579458
  var valid_579459 = query.getOrDefault("showHidden")
  valid_579459 = validateParameter(valid_579459, JBool, required = false, default = nil)
  if valid_579459 != nil:
    section.add "showHidden", valid_579459
  var valid_579460 = query.getOrDefault("minAccessRole")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = newJString("freeBusyReader"))
  if valid_579460 != nil:
    section.add "minAccessRole", valid_579460
  var valid_579461 = query.getOrDefault("fields")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "fields", valid_579461
  var valid_579462 = query.getOrDefault("syncToken")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "syncToken", valid_579462
  var valid_579463 = query.getOrDefault("showDeleted")
  valid_579463 = validateParameter(valid_579463, JBool, required = false, default = nil)
  if valid_579463 != nil:
    section.add "showDeleted", valid_579463
  var valid_579464 = query.getOrDefault("maxResults")
  valid_579464 = validateParameter(valid_579464, JInt, required = false, default = nil)
  if valid_579464 != nil:
    section.add "maxResults", valid_579464
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

proc call*(call_579466: Call_CalendarCalendarListWatch_579449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to CalendarList resources.
  ## 
  let valid = call_579466.validator(path, query, header, formData, body)
  let scheme = call_579466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579466.url(scheme.get, call_579466.host, call_579466.base,
                         call_579466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579466, url, valid)

proc call*(call_579467: Call_CalendarCalendarListWatch_579449; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          showHidden: bool = false; minAccessRole: string = "freeBusyReader";
          resource: JsonNode = nil; fields: string = ""; syncToken: string = "";
          showDeleted: bool = false; maxResults: int = 0): Recallable =
  ## calendarCalendarListWatch
  ## Watch for changes to CalendarList resources.
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
  ##            : Token specifying which result page to return. Optional.
  ##   showHidden: bool
  ##             : Whether to show hidden entries. Optional. The default is False.
  ##   minAccessRole: string
  ##                : The minimum access role for the user in the returned entries. Optional. The default is no restriction.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.
  ## To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   showDeleted: bool
  ##              : Whether to include deleted calendar list entries in the result. Optional. The default is False.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  var query_579468 = newJObject()
  var body_579469 = newJObject()
  add(query_579468, "key", newJString(key))
  add(query_579468, "prettyPrint", newJBool(prettyPrint))
  add(query_579468, "oauth_token", newJString(oauthToken))
  add(query_579468, "alt", newJString(alt))
  add(query_579468, "userIp", newJString(userIp))
  add(query_579468, "quotaUser", newJString(quotaUser))
  add(query_579468, "pageToken", newJString(pageToken))
  add(query_579468, "showHidden", newJBool(showHidden))
  add(query_579468, "minAccessRole", newJString(minAccessRole))
  if resource != nil:
    body_579469 = resource
  add(query_579468, "fields", newJString(fields))
  add(query_579468, "syncToken", newJString(syncToken))
  add(query_579468, "showDeleted", newJBool(showDeleted))
  add(query_579468, "maxResults", newJInt(maxResults))
  result = call_579467.call(nil, query_579468, nil, nil, body_579469)

var calendarCalendarListWatch* = Call_CalendarCalendarListWatch_579449(
    name: "calendarCalendarListWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/calendarList/watch",
    validator: validate_CalendarCalendarListWatch_579450, base: "/calendar/v3",
    url: url_CalendarCalendarListWatch_579451, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListUpdate_579485 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarListUpdate_579487(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/me/calendarList/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarListUpdate_579486(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing calendar on the user's calendar list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579488 = path.getOrDefault("calendarId")
  valid_579488 = validateParameter(valid_579488, JString, required = true,
                                 default = nil)
  if valid_579488 != nil:
    section.add "calendarId", valid_579488
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
  ##   colorRgbFormat: JBool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579489 = query.getOrDefault("key")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = nil)
  if valid_579489 != nil:
    section.add "key", valid_579489
  var valid_579490 = query.getOrDefault("prettyPrint")
  valid_579490 = validateParameter(valid_579490, JBool, required = false,
                                 default = newJBool(true))
  if valid_579490 != nil:
    section.add "prettyPrint", valid_579490
  var valid_579491 = query.getOrDefault("oauth_token")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = nil)
  if valid_579491 != nil:
    section.add "oauth_token", valid_579491
  var valid_579492 = query.getOrDefault("alt")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = newJString("json"))
  if valid_579492 != nil:
    section.add "alt", valid_579492
  var valid_579493 = query.getOrDefault("userIp")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "userIp", valid_579493
  var valid_579494 = query.getOrDefault("quotaUser")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "quotaUser", valid_579494
  var valid_579495 = query.getOrDefault("colorRgbFormat")
  valid_579495 = validateParameter(valid_579495, JBool, required = false, default = nil)
  if valid_579495 != nil:
    section.add "colorRgbFormat", valid_579495
  var valid_579496 = query.getOrDefault("fields")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "fields", valid_579496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579498: Call_CalendarCalendarListUpdate_579485; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing calendar on the user's calendar list.
  ## 
  let valid = call_579498.validator(path, query, header, formData, body)
  let scheme = call_579498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579498.url(scheme.get, call_579498.host, call_579498.base,
                         call_579498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579498, url, valid)

proc call*(call_579499: Call_CalendarCalendarListUpdate_579485; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          colorRgbFormat: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## calendarCalendarListUpdate
  ## Updates an existing calendar on the user's calendar list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   colorRgbFormat: bool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579500 = newJObject()
  var query_579501 = newJObject()
  var body_579502 = newJObject()
  add(query_579501, "key", newJString(key))
  add(query_579501, "prettyPrint", newJBool(prettyPrint))
  add(query_579501, "oauth_token", newJString(oauthToken))
  add(path_579500, "calendarId", newJString(calendarId))
  add(query_579501, "alt", newJString(alt))
  add(query_579501, "userIp", newJString(userIp))
  add(query_579501, "quotaUser", newJString(quotaUser))
  add(query_579501, "colorRgbFormat", newJBool(colorRgbFormat))
  if body != nil:
    body_579502 = body
  add(query_579501, "fields", newJString(fields))
  result = call_579499.call(path_579500, query_579501, nil, nil, body_579502)

var calendarCalendarListUpdate* = Call_CalendarCalendarListUpdate_579485(
    name: "calendarCalendarListUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListUpdate_579486, base: "/calendar/v3",
    url: url_CalendarCalendarListUpdate_579487, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListGet_579470 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarListGet_579472(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/me/calendarList/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarListGet_579471(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a calendar from the user's calendar list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579473 = path.getOrDefault("calendarId")
  valid_579473 = validateParameter(valid_579473, JString, required = true,
                                 default = nil)
  if valid_579473 != nil:
    section.add "calendarId", valid_579473
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
  var valid_579474 = query.getOrDefault("key")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "key", valid_579474
  var valid_579475 = query.getOrDefault("prettyPrint")
  valid_579475 = validateParameter(valid_579475, JBool, required = false,
                                 default = newJBool(true))
  if valid_579475 != nil:
    section.add "prettyPrint", valid_579475
  var valid_579476 = query.getOrDefault("oauth_token")
  valid_579476 = validateParameter(valid_579476, JString, required = false,
                                 default = nil)
  if valid_579476 != nil:
    section.add "oauth_token", valid_579476
  var valid_579477 = query.getOrDefault("alt")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = newJString("json"))
  if valid_579477 != nil:
    section.add "alt", valid_579477
  var valid_579478 = query.getOrDefault("userIp")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = nil)
  if valid_579478 != nil:
    section.add "userIp", valid_579478
  var valid_579479 = query.getOrDefault("quotaUser")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "quotaUser", valid_579479
  var valid_579480 = query.getOrDefault("fields")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = nil)
  if valid_579480 != nil:
    section.add "fields", valid_579480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579481: Call_CalendarCalendarListGet_579470; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a calendar from the user's calendar list.
  ## 
  let valid = call_579481.validator(path, query, header, formData, body)
  let scheme = call_579481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579481.url(scheme.get, call_579481.host, call_579481.base,
                         call_579481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579481, url, valid)

proc call*(call_579482: Call_CalendarCalendarListGet_579470; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## calendarCalendarListGet
  ## Returns a calendar from the user's calendar list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579483 = newJObject()
  var query_579484 = newJObject()
  add(query_579484, "key", newJString(key))
  add(query_579484, "prettyPrint", newJBool(prettyPrint))
  add(query_579484, "oauth_token", newJString(oauthToken))
  add(path_579483, "calendarId", newJString(calendarId))
  add(query_579484, "alt", newJString(alt))
  add(query_579484, "userIp", newJString(userIp))
  add(query_579484, "quotaUser", newJString(quotaUser))
  add(query_579484, "fields", newJString(fields))
  result = call_579482.call(path_579483, query_579484, nil, nil, nil)

var calendarCalendarListGet* = Call_CalendarCalendarListGet_579470(
    name: "calendarCalendarListGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListGet_579471, base: "/calendar/v3",
    url: url_CalendarCalendarListGet_579472, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListPatch_579518 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarListPatch_579520(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/me/calendarList/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarListPatch_579519(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing calendar on the user's calendar list. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579521 = path.getOrDefault("calendarId")
  valid_579521 = validateParameter(valid_579521, JString, required = true,
                                 default = nil)
  if valid_579521 != nil:
    section.add "calendarId", valid_579521
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
  ##   colorRgbFormat: JBool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579522 = query.getOrDefault("key")
  valid_579522 = validateParameter(valid_579522, JString, required = false,
                                 default = nil)
  if valid_579522 != nil:
    section.add "key", valid_579522
  var valid_579523 = query.getOrDefault("prettyPrint")
  valid_579523 = validateParameter(valid_579523, JBool, required = false,
                                 default = newJBool(true))
  if valid_579523 != nil:
    section.add "prettyPrint", valid_579523
  var valid_579524 = query.getOrDefault("oauth_token")
  valid_579524 = validateParameter(valid_579524, JString, required = false,
                                 default = nil)
  if valid_579524 != nil:
    section.add "oauth_token", valid_579524
  var valid_579525 = query.getOrDefault("alt")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = newJString("json"))
  if valid_579525 != nil:
    section.add "alt", valid_579525
  var valid_579526 = query.getOrDefault("userIp")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = nil)
  if valid_579526 != nil:
    section.add "userIp", valid_579526
  var valid_579527 = query.getOrDefault("quotaUser")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "quotaUser", valid_579527
  var valid_579528 = query.getOrDefault("colorRgbFormat")
  valid_579528 = validateParameter(valid_579528, JBool, required = false, default = nil)
  if valid_579528 != nil:
    section.add "colorRgbFormat", valid_579528
  var valid_579529 = query.getOrDefault("fields")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "fields", valid_579529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579531: Call_CalendarCalendarListPatch_579518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing calendar on the user's calendar list. This method supports patch semantics.
  ## 
  let valid = call_579531.validator(path, query, header, formData, body)
  let scheme = call_579531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579531.url(scheme.get, call_579531.host, call_579531.base,
                         call_579531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579531, url, valid)

proc call*(call_579532: Call_CalendarCalendarListPatch_579518; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          colorRgbFormat: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## calendarCalendarListPatch
  ## Updates an existing calendar on the user's calendar list. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   colorRgbFormat: bool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579533 = newJObject()
  var query_579534 = newJObject()
  var body_579535 = newJObject()
  add(query_579534, "key", newJString(key))
  add(query_579534, "prettyPrint", newJBool(prettyPrint))
  add(query_579534, "oauth_token", newJString(oauthToken))
  add(path_579533, "calendarId", newJString(calendarId))
  add(query_579534, "alt", newJString(alt))
  add(query_579534, "userIp", newJString(userIp))
  add(query_579534, "quotaUser", newJString(quotaUser))
  add(query_579534, "colorRgbFormat", newJBool(colorRgbFormat))
  if body != nil:
    body_579535 = body
  add(query_579534, "fields", newJString(fields))
  result = call_579532.call(path_579533, query_579534, nil, nil, body_579535)

var calendarCalendarListPatch* = Call_CalendarCalendarListPatch_579518(
    name: "calendarCalendarListPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListPatch_579519, base: "/calendar/v3",
    url: url_CalendarCalendarListPatch_579520, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListDelete_579503 = ref object of OpenApiRestCall_578355
proc url_CalendarCalendarListDelete_579505(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/me/calendarList/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarListDelete_579504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a calendar from the user's calendar list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_579506 = path.getOrDefault("calendarId")
  valid_579506 = validateParameter(valid_579506, JString, required = true,
                                 default = nil)
  if valid_579506 != nil:
    section.add "calendarId", valid_579506
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
  var valid_579507 = query.getOrDefault("key")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "key", valid_579507
  var valid_579508 = query.getOrDefault("prettyPrint")
  valid_579508 = validateParameter(valid_579508, JBool, required = false,
                                 default = newJBool(true))
  if valid_579508 != nil:
    section.add "prettyPrint", valid_579508
  var valid_579509 = query.getOrDefault("oauth_token")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "oauth_token", valid_579509
  var valid_579510 = query.getOrDefault("alt")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = newJString("json"))
  if valid_579510 != nil:
    section.add "alt", valid_579510
  var valid_579511 = query.getOrDefault("userIp")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "userIp", valid_579511
  var valid_579512 = query.getOrDefault("quotaUser")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "quotaUser", valid_579512
  var valid_579513 = query.getOrDefault("fields")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "fields", valid_579513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579514: Call_CalendarCalendarListDelete_579503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a calendar from the user's calendar list.
  ## 
  let valid = call_579514.validator(path, query, header, formData, body)
  let scheme = call_579514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579514.url(scheme.get, call_579514.host, call_579514.base,
                         call_579514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579514, url, valid)

proc call*(call_579515: Call_CalendarCalendarListDelete_579503; calendarId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## calendarCalendarListDelete
  ## Removes a calendar from the user's calendar list.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579516 = newJObject()
  var query_579517 = newJObject()
  add(query_579517, "key", newJString(key))
  add(query_579517, "prettyPrint", newJBool(prettyPrint))
  add(query_579517, "oauth_token", newJString(oauthToken))
  add(path_579516, "calendarId", newJString(calendarId))
  add(query_579517, "alt", newJString(alt))
  add(query_579517, "userIp", newJString(userIp))
  add(query_579517, "quotaUser", newJString(quotaUser))
  add(query_579517, "fields", newJString(fields))
  result = call_579515.call(path_579516, query_579517, nil, nil, nil)

var calendarCalendarListDelete* = Call_CalendarCalendarListDelete_579503(
    name: "calendarCalendarListDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListDelete_579504, base: "/calendar/v3",
    url: url_CalendarCalendarListDelete_579505, schemes: {Scheme.Https})
type
  Call_CalendarSettingsList_579536 = ref object of OpenApiRestCall_578355
proc url_CalendarSettingsList_579538(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarSettingsList_579537(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all user settings for the authenticated user.
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
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  section = newJObject()
  var valid_579539 = query.getOrDefault("key")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "key", valid_579539
  var valid_579540 = query.getOrDefault("prettyPrint")
  valid_579540 = validateParameter(valid_579540, JBool, required = false,
                                 default = newJBool(true))
  if valid_579540 != nil:
    section.add "prettyPrint", valid_579540
  var valid_579541 = query.getOrDefault("oauth_token")
  valid_579541 = validateParameter(valid_579541, JString, required = false,
                                 default = nil)
  if valid_579541 != nil:
    section.add "oauth_token", valid_579541
  var valid_579542 = query.getOrDefault("alt")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = newJString("json"))
  if valid_579542 != nil:
    section.add "alt", valid_579542
  var valid_579543 = query.getOrDefault("userIp")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "userIp", valid_579543
  var valid_579544 = query.getOrDefault("quotaUser")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = nil)
  if valid_579544 != nil:
    section.add "quotaUser", valid_579544
  var valid_579545 = query.getOrDefault("pageToken")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "pageToken", valid_579545
  var valid_579546 = query.getOrDefault("fields")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "fields", valid_579546
  var valid_579547 = query.getOrDefault("syncToken")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "syncToken", valid_579547
  var valid_579548 = query.getOrDefault("maxResults")
  valid_579548 = validateParameter(valid_579548, JInt, required = false, default = nil)
  if valid_579548 != nil:
    section.add "maxResults", valid_579548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579549: Call_CalendarSettingsList_579536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all user settings for the authenticated user.
  ## 
  let valid = call_579549.validator(path, query, header, formData, body)
  let scheme = call_579549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579549.url(scheme.get, call_579549.host, call_579549.base,
                         call_579549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579549, url, valid)

proc call*(call_579550: Call_CalendarSettingsList_579536; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; syncToken: string = ""; maxResults: int = 0): Recallable =
  ## calendarSettingsList
  ## Returns all user settings for the authenticated user.
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
  ##            : Token specifying which result page to return. Optional.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  var query_579551 = newJObject()
  add(query_579551, "key", newJString(key))
  add(query_579551, "prettyPrint", newJBool(prettyPrint))
  add(query_579551, "oauth_token", newJString(oauthToken))
  add(query_579551, "alt", newJString(alt))
  add(query_579551, "userIp", newJString(userIp))
  add(query_579551, "quotaUser", newJString(quotaUser))
  add(query_579551, "pageToken", newJString(pageToken))
  add(query_579551, "fields", newJString(fields))
  add(query_579551, "syncToken", newJString(syncToken))
  add(query_579551, "maxResults", newJInt(maxResults))
  result = call_579550.call(nil, query_579551, nil, nil, nil)

var calendarSettingsList* = Call_CalendarSettingsList_579536(
    name: "calendarSettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/settings",
    validator: validate_CalendarSettingsList_579537, base: "/calendar/v3",
    url: url_CalendarSettingsList_579538, schemes: {Scheme.Https})
type
  Call_CalendarSettingsWatch_579552 = ref object of OpenApiRestCall_578355
proc url_CalendarSettingsWatch_579554(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarSettingsWatch_579553(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watch for changes to Settings resources.
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
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  section = newJObject()
  var valid_579555 = query.getOrDefault("key")
  valid_579555 = validateParameter(valid_579555, JString, required = false,
                                 default = nil)
  if valid_579555 != nil:
    section.add "key", valid_579555
  var valid_579556 = query.getOrDefault("prettyPrint")
  valid_579556 = validateParameter(valid_579556, JBool, required = false,
                                 default = newJBool(true))
  if valid_579556 != nil:
    section.add "prettyPrint", valid_579556
  var valid_579557 = query.getOrDefault("oauth_token")
  valid_579557 = validateParameter(valid_579557, JString, required = false,
                                 default = nil)
  if valid_579557 != nil:
    section.add "oauth_token", valid_579557
  var valid_579558 = query.getOrDefault("alt")
  valid_579558 = validateParameter(valid_579558, JString, required = false,
                                 default = newJString("json"))
  if valid_579558 != nil:
    section.add "alt", valid_579558
  var valid_579559 = query.getOrDefault("userIp")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "userIp", valid_579559
  var valid_579560 = query.getOrDefault("quotaUser")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = nil)
  if valid_579560 != nil:
    section.add "quotaUser", valid_579560
  var valid_579561 = query.getOrDefault("pageToken")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "pageToken", valid_579561
  var valid_579562 = query.getOrDefault("fields")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = nil)
  if valid_579562 != nil:
    section.add "fields", valid_579562
  var valid_579563 = query.getOrDefault("syncToken")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "syncToken", valid_579563
  var valid_579564 = query.getOrDefault("maxResults")
  valid_579564 = validateParameter(valid_579564, JInt, required = false, default = nil)
  if valid_579564 != nil:
    section.add "maxResults", valid_579564
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

proc call*(call_579566: Call_CalendarSettingsWatch_579552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to Settings resources.
  ## 
  let valid = call_579566.validator(path, query, header, formData, body)
  let scheme = call_579566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579566.url(scheme.get, call_579566.host, call_579566.base,
                         call_579566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579566, url, valid)

proc call*(call_579567: Call_CalendarSettingsWatch_579552; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          resource: JsonNode = nil; fields: string = ""; syncToken: string = "";
          maxResults: int = 0): Recallable =
  ## calendarSettingsWatch
  ## Watch for changes to Settings resources.
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
  ##            : Token specifying which result page to return. Optional.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  var query_579568 = newJObject()
  var body_579569 = newJObject()
  add(query_579568, "key", newJString(key))
  add(query_579568, "prettyPrint", newJBool(prettyPrint))
  add(query_579568, "oauth_token", newJString(oauthToken))
  add(query_579568, "alt", newJString(alt))
  add(query_579568, "userIp", newJString(userIp))
  add(query_579568, "quotaUser", newJString(quotaUser))
  add(query_579568, "pageToken", newJString(pageToken))
  if resource != nil:
    body_579569 = resource
  add(query_579568, "fields", newJString(fields))
  add(query_579568, "syncToken", newJString(syncToken))
  add(query_579568, "maxResults", newJInt(maxResults))
  result = call_579567.call(nil, query_579568, nil, nil, body_579569)

var calendarSettingsWatch* = Call_CalendarSettingsWatch_579552(
    name: "calendarSettingsWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/settings/watch",
    validator: validate_CalendarSettingsWatch_579553, base: "/calendar/v3",
    url: url_CalendarSettingsWatch_579554, schemes: {Scheme.Https})
type
  Call_CalendarSettingsGet_579570 = ref object of OpenApiRestCall_578355
proc url_CalendarSettingsGet_579572(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "setting" in path, "`setting` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/me/settings/"),
               (kind: VariableSegment, value: "setting")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarSettingsGet_579571(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a single user setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   setting: JString (required)
  ##          : The id of the user setting.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `setting` field"
  var valid_579573 = path.getOrDefault("setting")
  valid_579573 = validateParameter(valid_579573, JString, required = true,
                                 default = nil)
  if valid_579573 != nil:
    section.add "setting", valid_579573
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
  var valid_579574 = query.getOrDefault("key")
  valid_579574 = validateParameter(valid_579574, JString, required = false,
                                 default = nil)
  if valid_579574 != nil:
    section.add "key", valid_579574
  var valid_579575 = query.getOrDefault("prettyPrint")
  valid_579575 = validateParameter(valid_579575, JBool, required = false,
                                 default = newJBool(true))
  if valid_579575 != nil:
    section.add "prettyPrint", valid_579575
  var valid_579576 = query.getOrDefault("oauth_token")
  valid_579576 = validateParameter(valid_579576, JString, required = false,
                                 default = nil)
  if valid_579576 != nil:
    section.add "oauth_token", valid_579576
  var valid_579577 = query.getOrDefault("alt")
  valid_579577 = validateParameter(valid_579577, JString, required = false,
                                 default = newJString("json"))
  if valid_579577 != nil:
    section.add "alt", valid_579577
  var valid_579578 = query.getOrDefault("userIp")
  valid_579578 = validateParameter(valid_579578, JString, required = false,
                                 default = nil)
  if valid_579578 != nil:
    section.add "userIp", valid_579578
  var valid_579579 = query.getOrDefault("quotaUser")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = nil)
  if valid_579579 != nil:
    section.add "quotaUser", valid_579579
  var valid_579580 = query.getOrDefault("fields")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = nil)
  if valid_579580 != nil:
    section.add "fields", valid_579580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579581: Call_CalendarSettingsGet_579570; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single user setting.
  ## 
  let valid = call_579581.validator(path, query, header, formData, body)
  let scheme = call_579581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579581.url(scheme.get, call_579581.host, call_579581.base,
                         call_579581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579581, url, valid)

proc call*(call_579582: Call_CalendarSettingsGet_579570; setting: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## calendarSettingsGet
  ## Returns a single user setting.
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
  ##   setting: string (required)
  ##          : The id of the user setting.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579583 = newJObject()
  var query_579584 = newJObject()
  add(query_579584, "key", newJString(key))
  add(query_579584, "prettyPrint", newJBool(prettyPrint))
  add(query_579584, "oauth_token", newJString(oauthToken))
  add(query_579584, "alt", newJString(alt))
  add(query_579584, "userIp", newJString(userIp))
  add(query_579584, "quotaUser", newJString(quotaUser))
  add(path_579583, "setting", newJString(setting))
  add(query_579584, "fields", newJString(fields))
  result = call_579582.call(path_579583, query_579584, nil, nil, nil)

var calendarSettingsGet* = Call_CalendarSettingsGet_579570(
    name: "calendarSettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/settings/{setting}",
    validator: validate_CalendarSettingsGet_579571, base: "/calendar/v3",
    url: url_CalendarSettingsGet_579572, schemes: {Scheme.Https})
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
