
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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
  gcpServiceName = "calendar"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CalendarCalendarsInsert_579650 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarsInsert_579652(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CalendarCalendarsInsert_579651(path: JsonNode; query: JsonNode;
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
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("alt")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("json"))
  if valid_579780 != nil:
    section.add "alt", valid_579780
  var valid_579781 = query.getOrDefault("userIp")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "userIp", valid_579781
  var valid_579782 = query.getOrDefault("quotaUser")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "quotaUser", valid_579782
  var valid_579783 = query.getOrDefault("fields")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "fields", valid_579783
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

proc call*(call_579807: Call_CalendarCalendarsInsert_579650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a secondary calendar.
  ## 
  let valid = call_579807.validator(path, query, header, formData, body)
  let scheme = call_579807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579807.url(scheme.get, call_579807.host, call_579807.base,
                         call_579807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579807, url, valid)

proc call*(call_579878: Call_CalendarCalendarsInsert_579650; key: string = "";
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
  var query_579879 = newJObject()
  var body_579881 = newJObject()
  add(query_579879, "key", newJString(key))
  add(query_579879, "prettyPrint", newJBool(prettyPrint))
  add(query_579879, "oauth_token", newJString(oauthToken))
  add(query_579879, "alt", newJString(alt))
  add(query_579879, "userIp", newJString(userIp))
  add(query_579879, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579881 = body
  add(query_579879, "fields", newJString(fields))
  result = call_579878.call(nil, query_579879, nil, nil, body_579881)

var calendarCalendarsInsert* = Call_CalendarCalendarsInsert_579650(
    name: "calendarCalendarsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars",
    validator: validate_CalendarCalendarsInsert_579651, base: "/calendar/v3",
    url: url_CalendarCalendarsInsert_579652, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsUpdate_579949 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarsUpdate_579951(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarCalendarsUpdate_579950(path: JsonNode; query: JsonNode;
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
  var valid_579952 = path.getOrDefault("calendarId")
  valid_579952 = validateParameter(valid_579952, JString, required = true,
                                 default = nil)
  if valid_579952 != nil:
    section.add "calendarId", valid_579952
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
  var valid_579953 = query.getOrDefault("key")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "key", valid_579953
  var valid_579954 = query.getOrDefault("prettyPrint")
  valid_579954 = validateParameter(valid_579954, JBool, required = false,
                                 default = newJBool(true))
  if valid_579954 != nil:
    section.add "prettyPrint", valid_579954
  var valid_579955 = query.getOrDefault("oauth_token")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "oauth_token", valid_579955
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
  var valid_579959 = query.getOrDefault("fields")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "fields", valid_579959
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

proc call*(call_579961: Call_CalendarCalendarsUpdate_579949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates metadata for a calendar.
  ## 
  let valid = call_579961.validator(path, query, header, formData, body)
  let scheme = call_579961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579961.url(scheme.get, call_579961.host, call_579961.base,
                         call_579961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579961, url, valid)

proc call*(call_579962: Call_CalendarCalendarsUpdate_579949; calendarId: string;
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
  var path_579963 = newJObject()
  var query_579964 = newJObject()
  var body_579965 = newJObject()
  add(query_579964, "key", newJString(key))
  add(query_579964, "prettyPrint", newJBool(prettyPrint))
  add(query_579964, "oauth_token", newJString(oauthToken))
  add(path_579963, "calendarId", newJString(calendarId))
  add(query_579964, "alt", newJString(alt))
  add(query_579964, "userIp", newJString(userIp))
  add(query_579964, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579965 = body
  add(query_579964, "fields", newJString(fields))
  result = call_579962.call(path_579963, query_579964, nil, nil, body_579965)

var calendarCalendarsUpdate* = Call_CalendarCalendarsUpdate_579949(
    name: "calendarCalendarsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsUpdate_579950, base: "/calendar/v3",
    url: url_CalendarCalendarsUpdate_579951, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsGet_579920 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarsGet_579922(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarCalendarsGet_579921(path: JsonNode; query: JsonNode;
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
  var valid_579937 = path.getOrDefault("calendarId")
  valid_579937 = validateParameter(valid_579937, JString, required = true,
                                 default = nil)
  if valid_579937 != nil:
    section.add "calendarId", valid_579937
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
  var valid_579938 = query.getOrDefault("key")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "key", valid_579938
  var valid_579939 = query.getOrDefault("prettyPrint")
  valid_579939 = validateParameter(valid_579939, JBool, required = false,
                                 default = newJBool(true))
  if valid_579939 != nil:
    section.add "prettyPrint", valid_579939
  var valid_579940 = query.getOrDefault("oauth_token")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "oauth_token", valid_579940
  var valid_579941 = query.getOrDefault("alt")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = newJString("json"))
  if valid_579941 != nil:
    section.add "alt", valid_579941
  var valid_579942 = query.getOrDefault("userIp")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "userIp", valid_579942
  var valid_579943 = query.getOrDefault("quotaUser")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "quotaUser", valid_579943
  var valid_579944 = query.getOrDefault("fields")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "fields", valid_579944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579945: Call_CalendarCalendarsGet_579920; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for a calendar.
  ## 
  let valid = call_579945.validator(path, query, header, formData, body)
  let scheme = call_579945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579945.url(scheme.get, call_579945.host, call_579945.base,
                         call_579945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579945, url, valid)

proc call*(call_579946: Call_CalendarCalendarsGet_579920; calendarId: string;
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
  var path_579947 = newJObject()
  var query_579948 = newJObject()
  add(query_579948, "key", newJString(key))
  add(query_579948, "prettyPrint", newJBool(prettyPrint))
  add(query_579948, "oauth_token", newJString(oauthToken))
  add(path_579947, "calendarId", newJString(calendarId))
  add(query_579948, "alt", newJString(alt))
  add(query_579948, "userIp", newJString(userIp))
  add(query_579948, "quotaUser", newJString(quotaUser))
  add(query_579948, "fields", newJString(fields))
  result = call_579946.call(path_579947, query_579948, nil, nil, nil)

var calendarCalendarsGet* = Call_CalendarCalendarsGet_579920(
    name: "calendarCalendarsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsGet_579921, base: "/calendar/v3",
    url: url_CalendarCalendarsGet_579922, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsPatch_579981 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarsPatch_579983(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarCalendarsPatch_579982(path: JsonNode; query: JsonNode;
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
  var valid_579984 = path.getOrDefault("calendarId")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "calendarId", valid_579984
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
  var valid_579985 = query.getOrDefault("key")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "key", valid_579985
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
  var valid_579987 = query.getOrDefault("oauth_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "oauth_token", valid_579987
  var valid_579988 = query.getOrDefault("alt")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("json"))
  if valid_579988 != nil:
    section.add "alt", valid_579988
  var valid_579989 = query.getOrDefault("userIp")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "userIp", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("fields")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "fields", valid_579991
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

proc call*(call_579993: Call_CalendarCalendarsPatch_579981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates metadata for a calendar. This method supports patch semantics.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_CalendarCalendarsPatch_579981; calendarId: string;
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
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  var body_579997 = newJObject()
  add(query_579996, "key", newJString(key))
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(path_579995, "calendarId", newJString(calendarId))
  add(query_579996, "alt", newJString(alt))
  add(query_579996, "userIp", newJString(userIp))
  add(query_579996, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579997 = body
  add(query_579996, "fields", newJString(fields))
  result = call_579994.call(path_579995, query_579996, nil, nil, body_579997)

var calendarCalendarsPatch* = Call_CalendarCalendarsPatch_579981(
    name: "calendarCalendarsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsPatch_579982, base: "/calendar/v3",
    url: url_CalendarCalendarsPatch_579983, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsDelete_579966 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarsDelete_579968(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarCalendarsDelete_579967(path: JsonNode; query: JsonNode;
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
  var valid_579969 = path.getOrDefault("calendarId")
  valid_579969 = validateParameter(valid_579969, JString, required = true,
                                 default = nil)
  if valid_579969 != nil:
    section.add "calendarId", valid_579969
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
  var valid_579970 = query.getOrDefault("key")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "key", valid_579970
  var valid_579971 = query.getOrDefault("prettyPrint")
  valid_579971 = validateParameter(valid_579971, JBool, required = false,
                                 default = newJBool(true))
  if valid_579971 != nil:
    section.add "prettyPrint", valid_579971
  var valid_579972 = query.getOrDefault("oauth_token")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "oauth_token", valid_579972
  var valid_579973 = query.getOrDefault("alt")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString("json"))
  if valid_579973 != nil:
    section.add "alt", valid_579973
  var valid_579974 = query.getOrDefault("userIp")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "userIp", valid_579974
  var valid_579975 = query.getOrDefault("quotaUser")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "quotaUser", valid_579975
  var valid_579976 = query.getOrDefault("fields")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "fields", valid_579976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579977: Call_CalendarCalendarsDelete_579966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
  ## 
  let valid = call_579977.validator(path, query, header, formData, body)
  let scheme = call_579977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579977.url(scheme.get, call_579977.host, call_579977.base,
                         call_579977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579977, url, valid)

proc call*(call_579978: Call_CalendarCalendarsDelete_579966; calendarId: string;
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
  var path_579979 = newJObject()
  var query_579980 = newJObject()
  add(query_579980, "key", newJString(key))
  add(query_579980, "prettyPrint", newJBool(prettyPrint))
  add(query_579980, "oauth_token", newJString(oauthToken))
  add(path_579979, "calendarId", newJString(calendarId))
  add(query_579980, "alt", newJString(alt))
  add(query_579980, "userIp", newJString(userIp))
  add(query_579980, "quotaUser", newJString(quotaUser))
  add(query_579980, "fields", newJString(fields))
  result = call_579978.call(path_579979, query_579980, nil, nil, nil)

var calendarCalendarsDelete* = Call_CalendarCalendarsDelete_579966(
    name: "calendarCalendarsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsDelete_579967, base: "/calendar/v3",
    url: url_CalendarCalendarsDelete_579968, schemes: {Scheme.Https})
type
  Call_CalendarAclInsert_580017 = ref object of OpenApiRestCall_579380
proc url_CalendarAclInsert_580019(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarAclInsert_580018(path: JsonNode; query: JsonNode;
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
  var valid_580020 = path.getOrDefault("calendarId")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "calendarId", valid_580020
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
  var valid_580023 = query.getOrDefault("oauth_token")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "oauth_token", valid_580023
  var valid_580024 = query.getOrDefault("sendNotifications")
  valid_580024 = validateParameter(valid_580024, JBool, required = false, default = nil)
  if valid_580024 != nil:
    section.add "sendNotifications", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("userIp")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "userIp", valid_580026
  var valid_580027 = query.getOrDefault("quotaUser")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "quotaUser", valid_580027
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
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

proc call*(call_580030: Call_CalendarAclInsert_580017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an access control rule.
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_CalendarAclInsert_580017; calendarId: string;
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
  var path_580032 = newJObject()
  var query_580033 = newJObject()
  var body_580034 = newJObject()
  add(query_580033, "key", newJString(key))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "sendNotifications", newJBool(sendNotifications))
  add(path_580032, "calendarId", newJString(calendarId))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "userIp", newJString(userIp))
  add(query_580033, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580034 = body
  add(query_580033, "fields", newJString(fields))
  result = call_580031.call(path_580032, query_580033, nil, nil, body_580034)

var calendarAclInsert* = Call_CalendarAclInsert_580017(name: "calendarAclInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl", validator: validate_CalendarAclInsert_580018,
    base: "/calendar/v3", url: url_CalendarAclInsert_580019, schemes: {Scheme.Https})
type
  Call_CalendarAclList_579998 = ref object of OpenApiRestCall_579380
proc url_CalendarAclList_580000(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarAclList_579999(path: JsonNode; query: JsonNode;
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
  var valid_580001 = path.getOrDefault("calendarId")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "calendarId", valid_580001
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
  var valid_580002 = query.getOrDefault("key")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "key", valid_580002
  var valid_580003 = query.getOrDefault("prettyPrint")
  valid_580003 = validateParameter(valid_580003, JBool, required = false,
                                 default = newJBool(true))
  if valid_580003 != nil:
    section.add "prettyPrint", valid_580003
  var valid_580004 = query.getOrDefault("oauth_token")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "oauth_token", valid_580004
  var valid_580005 = query.getOrDefault("alt")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("json"))
  if valid_580005 != nil:
    section.add "alt", valid_580005
  var valid_580006 = query.getOrDefault("userIp")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "userIp", valid_580006
  var valid_580007 = query.getOrDefault("quotaUser")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "quotaUser", valid_580007
  var valid_580008 = query.getOrDefault("pageToken")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "pageToken", valid_580008
  var valid_580009 = query.getOrDefault("fields")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "fields", valid_580009
  var valid_580010 = query.getOrDefault("syncToken")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "syncToken", valid_580010
  var valid_580011 = query.getOrDefault("showDeleted")
  valid_580011 = validateParameter(valid_580011, JBool, required = false, default = nil)
  if valid_580011 != nil:
    section.add "showDeleted", valid_580011
  var valid_580012 = query.getOrDefault("maxResults")
  valid_580012 = validateParameter(valid_580012, JInt, required = false, default = nil)
  if valid_580012 != nil:
    section.add "maxResults", valid_580012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580013: Call_CalendarAclList_579998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the rules in the access control list for the calendar.
  ## 
  let valid = call_580013.validator(path, query, header, formData, body)
  let scheme = call_580013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580013.url(scheme.get, call_580013.host, call_580013.base,
                         call_580013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580013, url, valid)

proc call*(call_580014: Call_CalendarAclList_579998; calendarId: string;
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
  var path_580015 = newJObject()
  var query_580016 = newJObject()
  add(query_580016, "key", newJString(key))
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(path_580015, "calendarId", newJString(calendarId))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "userIp", newJString(userIp))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(query_580016, "pageToken", newJString(pageToken))
  add(query_580016, "fields", newJString(fields))
  add(query_580016, "syncToken", newJString(syncToken))
  add(query_580016, "showDeleted", newJBool(showDeleted))
  add(query_580016, "maxResults", newJInt(maxResults))
  result = call_580014.call(path_580015, query_580016, nil, nil, nil)

var calendarAclList* = Call_CalendarAclList_579998(name: "calendarAclList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl", validator: validate_CalendarAclList_579999,
    base: "/calendar/v3", url: url_CalendarAclList_580000, schemes: {Scheme.Https})
type
  Call_CalendarAclWatch_580035 = ref object of OpenApiRestCall_579380
proc url_CalendarAclWatch_580037(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarAclWatch_580036(path: JsonNode; query: JsonNode;
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
  var valid_580038 = path.getOrDefault("calendarId")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "calendarId", valid_580038
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
  var valid_580041 = query.getOrDefault("oauth_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "oauth_token", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("userIp")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "userIp", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("pageToken")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "pageToken", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("syncToken")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "syncToken", valid_580047
  var valid_580048 = query.getOrDefault("showDeleted")
  valid_580048 = validateParameter(valid_580048, JBool, required = false, default = nil)
  if valid_580048 != nil:
    section.add "showDeleted", valid_580048
  var valid_580049 = query.getOrDefault("maxResults")
  valid_580049 = validateParameter(valid_580049, JInt, required = false, default = nil)
  if valid_580049 != nil:
    section.add "maxResults", valid_580049
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

proc call*(call_580051: Call_CalendarAclWatch_580035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to ACL resources.
  ## 
  let valid = call_580051.validator(path, query, header, formData, body)
  let scheme = call_580051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580051.url(scheme.get, call_580051.host, call_580051.base,
                         call_580051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580051, url, valid)

proc call*(call_580052: Call_CalendarAclWatch_580035; calendarId: string;
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
  var path_580053 = newJObject()
  var query_580054 = newJObject()
  var body_580055 = newJObject()
  add(query_580054, "key", newJString(key))
  add(query_580054, "prettyPrint", newJBool(prettyPrint))
  add(query_580054, "oauth_token", newJString(oauthToken))
  add(path_580053, "calendarId", newJString(calendarId))
  add(query_580054, "alt", newJString(alt))
  add(query_580054, "userIp", newJString(userIp))
  add(query_580054, "quotaUser", newJString(quotaUser))
  add(query_580054, "pageToken", newJString(pageToken))
  if resource != nil:
    body_580055 = resource
  add(query_580054, "fields", newJString(fields))
  add(query_580054, "syncToken", newJString(syncToken))
  add(query_580054, "showDeleted", newJBool(showDeleted))
  add(query_580054, "maxResults", newJInt(maxResults))
  result = call_580052.call(path_580053, query_580054, nil, nil, body_580055)

var calendarAclWatch* = Call_CalendarAclWatch_580035(name: "calendarAclWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/watch",
    validator: validate_CalendarAclWatch_580036, base: "/calendar/v3",
    url: url_CalendarAclWatch_580037, schemes: {Scheme.Https})
type
  Call_CalendarAclUpdate_580072 = ref object of OpenApiRestCall_579380
proc url_CalendarAclUpdate_580074(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarAclUpdate_580073(path: JsonNode; query: JsonNode;
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
  var valid_580075 = path.getOrDefault("ruleId")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "ruleId", valid_580075
  var valid_580076 = path.getOrDefault("calendarId")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "calendarId", valid_580076
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
  var valid_580077 = query.getOrDefault("key")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "key", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
  var valid_580079 = query.getOrDefault("oauth_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "oauth_token", valid_580079
  var valid_580080 = query.getOrDefault("sendNotifications")
  valid_580080 = validateParameter(valid_580080, JBool, required = false, default = nil)
  if valid_580080 != nil:
    section.add "sendNotifications", valid_580080
  var valid_580081 = query.getOrDefault("alt")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("json"))
  if valid_580081 != nil:
    section.add "alt", valid_580081
  var valid_580082 = query.getOrDefault("userIp")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "userIp", valid_580082
  var valid_580083 = query.getOrDefault("quotaUser")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "quotaUser", valid_580083
  var valid_580084 = query.getOrDefault("fields")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "fields", valid_580084
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

proc call*(call_580086: Call_CalendarAclUpdate_580072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an access control rule.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_CalendarAclUpdate_580072; ruleId: string;
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
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  var body_580090 = newJObject()
  add(query_580089, "key", newJString(key))
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "sendNotifications", newJBool(sendNotifications))
  add(path_580088, "ruleId", newJString(ruleId))
  add(path_580088, "calendarId", newJString(calendarId))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "userIp", newJString(userIp))
  add(query_580089, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580090 = body
  add(query_580089, "fields", newJString(fields))
  result = call_580087.call(path_580088, query_580089, nil, nil, body_580090)

var calendarAclUpdate* = Call_CalendarAclUpdate_580072(name: "calendarAclUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclUpdate_580073, base: "/calendar/v3",
    url: url_CalendarAclUpdate_580074, schemes: {Scheme.Https})
type
  Call_CalendarAclGet_580056 = ref object of OpenApiRestCall_579380
proc url_CalendarAclGet_580058(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarAclGet_580057(path: JsonNode; query: JsonNode;
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
  var valid_580059 = path.getOrDefault("ruleId")
  valid_580059 = validateParameter(valid_580059, JString, required = true,
                                 default = nil)
  if valid_580059 != nil:
    section.add "ruleId", valid_580059
  var valid_580060 = path.getOrDefault("calendarId")
  valid_580060 = validateParameter(valid_580060, JString, required = true,
                                 default = nil)
  if valid_580060 != nil:
    section.add "calendarId", valid_580060
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
  var valid_580061 = query.getOrDefault("key")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "key", valid_580061
  var valid_580062 = query.getOrDefault("prettyPrint")
  valid_580062 = validateParameter(valid_580062, JBool, required = false,
                                 default = newJBool(true))
  if valid_580062 != nil:
    section.add "prettyPrint", valid_580062
  var valid_580063 = query.getOrDefault("oauth_token")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "oauth_token", valid_580063
  var valid_580064 = query.getOrDefault("alt")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = newJString("json"))
  if valid_580064 != nil:
    section.add "alt", valid_580064
  var valid_580065 = query.getOrDefault("userIp")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "userIp", valid_580065
  var valid_580066 = query.getOrDefault("quotaUser")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "quotaUser", valid_580066
  var valid_580067 = query.getOrDefault("fields")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "fields", valid_580067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580068: Call_CalendarAclGet_580056; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an access control rule.
  ## 
  let valid = call_580068.validator(path, query, header, formData, body)
  let scheme = call_580068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580068.url(scheme.get, call_580068.host, call_580068.base,
                         call_580068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580068, url, valid)

proc call*(call_580069: Call_CalendarAclGet_580056; ruleId: string;
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
  var path_580070 = newJObject()
  var query_580071 = newJObject()
  add(query_580071, "key", newJString(key))
  add(query_580071, "prettyPrint", newJBool(prettyPrint))
  add(query_580071, "oauth_token", newJString(oauthToken))
  add(path_580070, "ruleId", newJString(ruleId))
  add(path_580070, "calendarId", newJString(calendarId))
  add(query_580071, "alt", newJString(alt))
  add(query_580071, "userIp", newJString(userIp))
  add(query_580071, "quotaUser", newJString(quotaUser))
  add(query_580071, "fields", newJString(fields))
  result = call_580069.call(path_580070, query_580071, nil, nil, nil)

var calendarAclGet* = Call_CalendarAclGet_580056(name: "calendarAclGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclGet_580057, base: "/calendar/v3",
    url: url_CalendarAclGet_580058, schemes: {Scheme.Https})
type
  Call_CalendarAclPatch_580107 = ref object of OpenApiRestCall_579380
proc url_CalendarAclPatch_580109(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarAclPatch_580108(path: JsonNode; query: JsonNode;
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
  var valid_580110 = path.getOrDefault("ruleId")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "ruleId", valid_580110
  var valid_580111 = path.getOrDefault("calendarId")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "calendarId", valid_580111
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
  var valid_580112 = query.getOrDefault("key")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "key", valid_580112
  var valid_580113 = query.getOrDefault("prettyPrint")
  valid_580113 = validateParameter(valid_580113, JBool, required = false,
                                 default = newJBool(true))
  if valid_580113 != nil:
    section.add "prettyPrint", valid_580113
  var valid_580114 = query.getOrDefault("oauth_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "oauth_token", valid_580114
  var valid_580115 = query.getOrDefault("sendNotifications")
  valid_580115 = validateParameter(valid_580115, JBool, required = false, default = nil)
  if valid_580115 != nil:
    section.add "sendNotifications", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("userIp")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "userIp", valid_580117
  var valid_580118 = query.getOrDefault("quotaUser")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "quotaUser", valid_580118
  var valid_580119 = query.getOrDefault("fields")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "fields", valid_580119
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

proc call*(call_580121: Call_CalendarAclPatch_580107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an access control rule. This method supports patch semantics.
  ## 
  let valid = call_580121.validator(path, query, header, formData, body)
  let scheme = call_580121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580121.url(scheme.get, call_580121.host, call_580121.base,
                         call_580121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580121, url, valid)

proc call*(call_580122: Call_CalendarAclPatch_580107; ruleId: string;
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
  var path_580123 = newJObject()
  var query_580124 = newJObject()
  var body_580125 = newJObject()
  add(query_580124, "key", newJString(key))
  add(query_580124, "prettyPrint", newJBool(prettyPrint))
  add(query_580124, "oauth_token", newJString(oauthToken))
  add(query_580124, "sendNotifications", newJBool(sendNotifications))
  add(path_580123, "ruleId", newJString(ruleId))
  add(path_580123, "calendarId", newJString(calendarId))
  add(query_580124, "alt", newJString(alt))
  add(query_580124, "userIp", newJString(userIp))
  add(query_580124, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580125 = body
  add(query_580124, "fields", newJString(fields))
  result = call_580122.call(path_580123, query_580124, nil, nil, body_580125)

var calendarAclPatch* = Call_CalendarAclPatch_580107(name: "calendarAclPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclPatch_580108, base: "/calendar/v3",
    url: url_CalendarAclPatch_580109, schemes: {Scheme.Https})
type
  Call_CalendarAclDelete_580091 = ref object of OpenApiRestCall_579380
proc url_CalendarAclDelete_580093(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarAclDelete_580092(path: JsonNode; query: JsonNode;
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
  var valid_580094 = path.getOrDefault("ruleId")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "ruleId", valid_580094
  var valid_580095 = path.getOrDefault("calendarId")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "calendarId", valid_580095
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
  var valid_580096 = query.getOrDefault("key")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "key", valid_580096
  var valid_580097 = query.getOrDefault("prettyPrint")
  valid_580097 = validateParameter(valid_580097, JBool, required = false,
                                 default = newJBool(true))
  if valid_580097 != nil:
    section.add "prettyPrint", valid_580097
  var valid_580098 = query.getOrDefault("oauth_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "oauth_token", valid_580098
  var valid_580099 = query.getOrDefault("alt")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("json"))
  if valid_580099 != nil:
    section.add "alt", valid_580099
  var valid_580100 = query.getOrDefault("userIp")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "userIp", valid_580100
  var valid_580101 = query.getOrDefault("quotaUser")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "quotaUser", valid_580101
  var valid_580102 = query.getOrDefault("fields")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "fields", valid_580102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580103: Call_CalendarAclDelete_580091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an access control rule.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_CalendarAclDelete_580091; ruleId: string;
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
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  add(query_580106, "key", newJString(key))
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(path_580105, "ruleId", newJString(ruleId))
  add(path_580105, "calendarId", newJString(calendarId))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "userIp", newJString(userIp))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(query_580106, "fields", newJString(fields))
  result = call_580104.call(path_580105, query_580106, nil, nil, nil)

var calendarAclDelete* = Call_CalendarAclDelete_580091(name: "calendarAclDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclDelete_580092, base: "/calendar/v3",
    url: url_CalendarAclDelete_580093, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsClear_580126 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarsClear_580128(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarCalendarsClear_580127(path: JsonNode; query: JsonNode;
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
  var valid_580129 = path.getOrDefault("calendarId")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "calendarId", valid_580129
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
  var valid_580130 = query.getOrDefault("key")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "key", valid_580130
  var valid_580131 = query.getOrDefault("prettyPrint")
  valid_580131 = validateParameter(valid_580131, JBool, required = false,
                                 default = newJBool(true))
  if valid_580131 != nil:
    section.add "prettyPrint", valid_580131
  var valid_580132 = query.getOrDefault("oauth_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "oauth_token", valid_580132
  var valid_580133 = query.getOrDefault("alt")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = newJString("json"))
  if valid_580133 != nil:
    section.add "alt", valid_580133
  var valid_580134 = query.getOrDefault("userIp")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "userIp", valid_580134
  var valid_580135 = query.getOrDefault("quotaUser")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "quotaUser", valid_580135
  var valid_580136 = query.getOrDefault("fields")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "fields", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580137: Call_CalendarCalendarsClear_580126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
  ## 
  let valid = call_580137.validator(path, query, header, formData, body)
  let scheme = call_580137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580137.url(scheme.get, call_580137.host, call_580137.base,
                         call_580137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580137, url, valid)

proc call*(call_580138: Call_CalendarCalendarsClear_580126; calendarId: string;
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
  var path_580139 = newJObject()
  var query_580140 = newJObject()
  add(query_580140, "key", newJString(key))
  add(query_580140, "prettyPrint", newJBool(prettyPrint))
  add(query_580140, "oauth_token", newJString(oauthToken))
  add(path_580139, "calendarId", newJString(calendarId))
  add(query_580140, "alt", newJString(alt))
  add(query_580140, "userIp", newJString(userIp))
  add(query_580140, "quotaUser", newJString(quotaUser))
  add(query_580140, "fields", newJString(fields))
  result = call_580138.call(path_580139, query_580140, nil, nil, nil)

var calendarCalendarsClear* = Call_CalendarCalendarsClear_580126(
    name: "calendarCalendarsClear", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/clear",
    validator: validate_CalendarCalendarsClear_580127, base: "/calendar/v3",
    url: url_CalendarCalendarsClear_580128, schemes: {Scheme.Https})
type
  Call_CalendarEventsInsert_580174 = ref object of OpenApiRestCall_579380
proc url_CalendarEventsInsert_580176(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarEventsInsert_580175(path: JsonNode; query: JsonNode;
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
  var valid_580177 = path.getOrDefault("calendarId")
  valid_580177 = validateParameter(valid_580177, JString, required = true,
                                 default = nil)
  if valid_580177 != nil:
    section.add "calendarId", valid_580177
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
  var valid_580178 = query.getOrDefault("key")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "key", valid_580178
  var valid_580179 = query.getOrDefault("prettyPrint")
  valid_580179 = validateParameter(valid_580179, JBool, required = false,
                                 default = newJBool(true))
  if valid_580179 != nil:
    section.add "prettyPrint", valid_580179
  var valid_580180 = query.getOrDefault("oauth_token")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "oauth_token", valid_580180
  var valid_580181 = query.getOrDefault("sendNotifications")
  valid_580181 = validateParameter(valid_580181, JBool, required = false, default = nil)
  if valid_580181 != nil:
    section.add "sendNotifications", valid_580181
  var valid_580182 = query.getOrDefault("maxAttendees")
  valid_580182 = validateParameter(valid_580182, JInt, required = false, default = nil)
  if valid_580182 != nil:
    section.add "maxAttendees", valid_580182
  var valid_580183 = query.getOrDefault("alt")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = newJString("json"))
  if valid_580183 != nil:
    section.add "alt", valid_580183
  var valid_580184 = query.getOrDefault("userIp")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "userIp", valid_580184
  var valid_580185 = query.getOrDefault("quotaUser")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "quotaUser", valid_580185
  var valid_580186 = query.getOrDefault("supportsAttachments")
  valid_580186 = validateParameter(valid_580186, JBool, required = false, default = nil)
  if valid_580186 != nil:
    section.add "supportsAttachments", valid_580186
  var valid_580187 = query.getOrDefault("conferenceDataVersion")
  valid_580187 = validateParameter(valid_580187, JInt, required = false, default = nil)
  if valid_580187 != nil:
    section.add "conferenceDataVersion", valid_580187
  var valid_580188 = query.getOrDefault("fields")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "fields", valid_580188
  var valid_580189 = query.getOrDefault("sendUpdates")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = newJString("all"))
  if valid_580189 != nil:
    section.add "sendUpdates", valid_580189
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

proc call*(call_580191: Call_CalendarEventsInsert_580174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an event.
  ## 
  let valid = call_580191.validator(path, query, header, formData, body)
  let scheme = call_580191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580191.url(scheme.get, call_580191.host, call_580191.base,
                         call_580191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580191, url, valid)

proc call*(call_580192: Call_CalendarEventsInsert_580174; calendarId: string;
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
  var path_580193 = newJObject()
  var query_580194 = newJObject()
  var body_580195 = newJObject()
  add(query_580194, "key", newJString(key))
  add(query_580194, "prettyPrint", newJBool(prettyPrint))
  add(query_580194, "oauth_token", newJString(oauthToken))
  add(query_580194, "sendNotifications", newJBool(sendNotifications))
  add(path_580193, "calendarId", newJString(calendarId))
  add(query_580194, "maxAttendees", newJInt(maxAttendees))
  add(query_580194, "alt", newJString(alt))
  add(query_580194, "userIp", newJString(userIp))
  add(query_580194, "quotaUser", newJString(quotaUser))
  add(query_580194, "supportsAttachments", newJBool(supportsAttachments))
  if body != nil:
    body_580195 = body
  add(query_580194, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_580194, "fields", newJString(fields))
  add(query_580194, "sendUpdates", newJString(sendUpdates))
  result = call_580192.call(path_580193, query_580194, nil, nil, body_580195)

var calendarEventsInsert* = Call_CalendarEventsInsert_580174(
    name: "calendarEventsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events",
    validator: validate_CalendarEventsInsert_580175, base: "/calendar/v3",
    url: url_CalendarEventsInsert_580176, schemes: {Scheme.Https})
type
  Call_CalendarEventsList_580141 = ref object of OpenApiRestCall_579380
proc url_CalendarEventsList_580143(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarEventsList_580142(path: JsonNode; query: JsonNode;
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
  var valid_580144 = path.getOrDefault("calendarId")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "calendarId", valid_580144
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
  var valid_580145 = query.getOrDefault("key")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "key", valid_580145
  var valid_580146 = query.getOrDefault("prettyPrint")
  valid_580146 = validateParameter(valid_580146, JBool, required = false,
                                 default = newJBool(true))
  if valid_580146 != nil:
    section.add "prettyPrint", valid_580146
  var valid_580147 = query.getOrDefault("oauth_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "oauth_token", valid_580147
  var valid_580148 = query.getOrDefault("iCalUID")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "iCalUID", valid_580148
  var valid_580149 = query.getOrDefault("maxAttendees")
  valid_580149 = validateParameter(valid_580149, JInt, required = false, default = nil)
  if valid_580149 != nil:
    section.add "maxAttendees", valid_580149
  var valid_580150 = query.getOrDefault("q")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "q", valid_580150
  var valid_580151 = query.getOrDefault("privateExtendedProperty")
  valid_580151 = validateParameter(valid_580151, JArray, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "privateExtendedProperty", valid_580151
  var valid_580152 = query.getOrDefault("timeMin")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "timeMin", valid_580152
  var valid_580153 = query.getOrDefault("alt")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = newJString("json"))
  if valid_580153 != nil:
    section.add "alt", valid_580153
  var valid_580154 = query.getOrDefault("userIp")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "userIp", valid_580154
  var valid_580155 = query.getOrDefault("quotaUser")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "quotaUser", valid_580155
  var valid_580156 = query.getOrDefault("orderBy")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = newJString("startTime"))
  if valid_580156 != nil:
    section.add "orderBy", valid_580156
  var valid_580157 = query.getOrDefault("pageToken")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "pageToken", valid_580157
  var valid_580158 = query.getOrDefault("timeZone")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "timeZone", valid_580158
  var valid_580159 = query.getOrDefault("timeMax")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "timeMax", valid_580159
  var valid_580160 = query.getOrDefault("showHiddenInvitations")
  valid_580160 = validateParameter(valid_580160, JBool, required = false, default = nil)
  if valid_580160 != nil:
    section.add "showHiddenInvitations", valid_580160
  var valid_580161 = query.getOrDefault("singleEvents")
  valid_580161 = validateParameter(valid_580161, JBool, required = false, default = nil)
  if valid_580161 != nil:
    section.add "singleEvents", valid_580161
  var valid_580162 = query.getOrDefault("alwaysIncludeEmail")
  valid_580162 = validateParameter(valid_580162, JBool, required = false, default = nil)
  if valid_580162 != nil:
    section.add "alwaysIncludeEmail", valid_580162
  var valid_580163 = query.getOrDefault("sharedExtendedProperty")
  valid_580163 = validateParameter(valid_580163, JArray, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "sharedExtendedProperty", valid_580163
  var valid_580164 = query.getOrDefault("updatedMin")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "updatedMin", valid_580164
  var valid_580165 = query.getOrDefault("fields")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "fields", valid_580165
  var valid_580166 = query.getOrDefault("syncToken")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "syncToken", valid_580166
  var valid_580167 = query.getOrDefault("showDeleted")
  valid_580167 = validateParameter(valid_580167, JBool, required = false, default = nil)
  if valid_580167 != nil:
    section.add "showDeleted", valid_580167
  var valid_580169 = query.getOrDefault("maxResults")
  valid_580169 = validateParameter(valid_580169, JInt, required = false,
                                 default = newJInt(250))
  if valid_580169 != nil:
    section.add "maxResults", valid_580169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580170: Call_CalendarEventsList_580141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns events on the specified calendar.
  ## 
  let valid = call_580170.validator(path, query, header, formData, body)
  let scheme = call_580170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580170.url(scheme.get, call_580170.host, call_580170.base,
                         call_580170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580170, url, valid)

proc call*(call_580171: Call_CalendarEventsList_580141; calendarId: string;
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
  var path_580172 = newJObject()
  var query_580173 = newJObject()
  add(query_580173, "key", newJString(key))
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(query_580173, "iCalUID", newJString(iCalUID))
  add(path_580172, "calendarId", newJString(calendarId))
  add(query_580173, "maxAttendees", newJInt(maxAttendees))
  add(query_580173, "q", newJString(q))
  if privateExtendedProperty != nil:
    query_580173.add "privateExtendedProperty", privateExtendedProperty
  add(query_580173, "timeMin", newJString(timeMin))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "userIp", newJString(userIp))
  add(query_580173, "quotaUser", newJString(quotaUser))
  add(query_580173, "orderBy", newJString(orderBy))
  add(query_580173, "pageToken", newJString(pageToken))
  add(query_580173, "timeZone", newJString(timeZone))
  add(query_580173, "timeMax", newJString(timeMax))
  add(query_580173, "showHiddenInvitations", newJBool(showHiddenInvitations))
  add(query_580173, "singleEvents", newJBool(singleEvents))
  add(query_580173, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if sharedExtendedProperty != nil:
    query_580173.add "sharedExtendedProperty", sharedExtendedProperty
  add(query_580173, "updatedMin", newJString(updatedMin))
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "syncToken", newJString(syncToken))
  add(query_580173, "showDeleted", newJBool(showDeleted))
  add(query_580173, "maxResults", newJInt(maxResults))
  result = call_580171.call(path_580172, query_580173, nil, nil, nil)

var calendarEventsList* = Call_CalendarEventsList_580141(
    name: "calendarEventsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events",
    validator: validate_CalendarEventsList_580142, base: "/calendar/v3",
    url: url_CalendarEventsList_580143, schemes: {Scheme.Https})
type
  Call_CalendarEventsImport_580196 = ref object of OpenApiRestCall_579380
proc url_CalendarEventsImport_580198(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarEventsImport_580197(path: JsonNode; query: JsonNode;
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
  var valid_580199 = path.getOrDefault("calendarId")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "calendarId", valid_580199
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
  var valid_580200 = query.getOrDefault("key")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "key", valid_580200
  var valid_580201 = query.getOrDefault("prettyPrint")
  valid_580201 = validateParameter(valid_580201, JBool, required = false,
                                 default = newJBool(true))
  if valid_580201 != nil:
    section.add "prettyPrint", valid_580201
  var valid_580202 = query.getOrDefault("oauth_token")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "oauth_token", valid_580202
  var valid_580203 = query.getOrDefault("alt")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = newJString("json"))
  if valid_580203 != nil:
    section.add "alt", valid_580203
  var valid_580204 = query.getOrDefault("userIp")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "userIp", valid_580204
  var valid_580205 = query.getOrDefault("quotaUser")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "quotaUser", valid_580205
  var valid_580206 = query.getOrDefault("supportsAttachments")
  valid_580206 = validateParameter(valid_580206, JBool, required = false, default = nil)
  if valid_580206 != nil:
    section.add "supportsAttachments", valid_580206
  var valid_580207 = query.getOrDefault("conferenceDataVersion")
  valid_580207 = validateParameter(valid_580207, JInt, required = false, default = nil)
  if valid_580207 != nil:
    section.add "conferenceDataVersion", valid_580207
  var valid_580208 = query.getOrDefault("fields")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "fields", valid_580208
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

proc call*(call_580210: Call_CalendarEventsImport_580196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an event. This operation is used to add a private copy of an existing event to a calendar.
  ## 
  let valid = call_580210.validator(path, query, header, formData, body)
  let scheme = call_580210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580210.url(scheme.get, call_580210.host, call_580210.base,
                         call_580210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580210, url, valid)

proc call*(call_580211: Call_CalendarEventsImport_580196; calendarId: string;
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
  var path_580212 = newJObject()
  var query_580213 = newJObject()
  var body_580214 = newJObject()
  add(query_580213, "key", newJString(key))
  add(query_580213, "prettyPrint", newJBool(prettyPrint))
  add(query_580213, "oauth_token", newJString(oauthToken))
  add(path_580212, "calendarId", newJString(calendarId))
  add(query_580213, "alt", newJString(alt))
  add(query_580213, "userIp", newJString(userIp))
  add(query_580213, "quotaUser", newJString(quotaUser))
  add(query_580213, "supportsAttachments", newJBool(supportsAttachments))
  if body != nil:
    body_580214 = body
  add(query_580213, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_580213, "fields", newJString(fields))
  result = call_580211.call(path_580212, query_580213, nil, nil, body_580214)

var calendarEventsImport* = Call_CalendarEventsImport_580196(
    name: "calendarEventsImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/import",
    validator: validate_CalendarEventsImport_580197, base: "/calendar/v3",
    url: url_CalendarEventsImport_580198, schemes: {Scheme.Https})
type
  Call_CalendarEventsQuickAdd_580215 = ref object of OpenApiRestCall_579380
proc url_CalendarEventsQuickAdd_580217(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarEventsQuickAdd_580216(path: JsonNode; query: JsonNode;
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
  var valid_580218 = path.getOrDefault("calendarId")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "calendarId", valid_580218
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
  var valid_580219 = query.getOrDefault("key")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "key", valid_580219
  var valid_580220 = query.getOrDefault("prettyPrint")
  valid_580220 = validateParameter(valid_580220, JBool, required = false,
                                 default = newJBool(true))
  if valid_580220 != nil:
    section.add "prettyPrint", valid_580220
  var valid_580221 = query.getOrDefault("oauth_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "oauth_token", valid_580221
  var valid_580222 = query.getOrDefault("sendNotifications")
  valid_580222 = validateParameter(valid_580222, JBool, required = false, default = nil)
  if valid_580222 != nil:
    section.add "sendNotifications", valid_580222
  var valid_580223 = query.getOrDefault("alt")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = newJString("json"))
  if valid_580223 != nil:
    section.add "alt", valid_580223
  var valid_580224 = query.getOrDefault("userIp")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "userIp", valid_580224
  var valid_580225 = query.getOrDefault("quotaUser")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "quotaUser", valid_580225
  assert query != nil, "query argument is necessary due to required `text` field"
  var valid_580226 = query.getOrDefault("text")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "text", valid_580226
  var valid_580227 = query.getOrDefault("fields")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "fields", valid_580227
  var valid_580228 = query.getOrDefault("sendUpdates")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("all"))
  if valid_580228 != nil:
    section.add "sendUpdates", valid_580228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580229: Call_CalendarEventsQuickAdd_580215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an event based on a simple text string.
  ## 
  let valid = call_580229.validator(path, query, header, formData, body)
  let scheme = call_580229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580229.url(scheme.get, call_580229.host, call_580229.base,
                         call_580229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580229, url, valid)

proc call*(call_580230: Call_CalendarEventsQuickAdd_580215; calendarId: string;
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
  var path_580231 = newJObject()
  var query_580232 = newJObject()
  add(query_580232, "key", newJString(key))
  add(query_580232, "prettyPrint", newJBool(prettyPrint))
  add(query_580232, "oauth_token", newJString(oauthToken))
  add(query_580232, "sendNotifications", newJBool(sendNotifications))
  add(path_580231, "calendarId", newJString(calendarId))
  add(query_580232, "alt", newJString(alt))
  add(query_580232, "userIp", newJString(userIp))
  add(query_580232, "quotaUser", newJString(quotaUser))
  add(query_580232, "text", newJString(text))
  add(query_580232, "fields", newJString(fields))
  add(query_580232, "sendUpdates", newJString(sendUpdates))
  result = call_580230.call(path_580231, query_580232, nil, nil, nil)

var calendarEventsQuickAdd* = Call_CalendarEventsQuickAdd_580215(
    name: "calendarEventsQuickAdd", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/quickAdd",
    validator: validate_CalendarEventsQuickAdd_580216, base: "/calendar/v3",
    url: url_CalendarEventsQuickAdd_580217, schemes: {Scheme.Https})
type
  Call_CalendarEventsWatch_580233 = ref object of OpenApiRestCall_579380
proc url_CalendarEventsWatch_580235(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarEventsWatch_580234(path: JsonNode; query: JsonNode;
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
  var valid_580236 = path.getOrDefault("calendarId")
  valid_580236 = validateParameter(valid_580236, JString, required = true,
                                 default = nil)
  if valid_580236 != nil:
    section.add "calendarId", valid_580236
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
  var valid_580237 = query.getOrDefault("key")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "key", valid_580237
  var valid_580238 = query.getOrDefault("prettyPrint")
  valid_580238 = validateParameter(valid_580238, JBool, required = false,
                                 default = newJBool(true))
  if valid_580238 != nil:
    section.add "prettyPrint", valid_580238
  var valid_580239 = query.getOrDefault("oauth_token")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "oauth_token", valid_580239
  var valid_580240 = query.getOrDefault("iCalUID")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "iCalUID", valid_580240
  var valid_580241 = query.getOrDefault("maxAttendees")
  valid_580241 = validateParameter(valid_580241, JInt, required = false, default = nil)
  if valid_580241 != nil:
    section.add "maxAttendees", valid_580241
  var valid_580242 = query.getOrDefault("q")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "q", valid_580242
  var valid_580243 = query.getOrDefault("privateExtendedProperty")
  valid_580243 = validateParameter(valid_580243, JArray, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "privateExtendedProperty", valid_580243
  var valid_580244 = query.getOrDefault("timeMin")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "timeMin", valid_580244
  var valid_580245 = query.getOrDefault("alt")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = newJString("json"))
  if valid_580245 != nil:
    section.add "alt", valid_580245
  var valid_580246 = query.getOrDefault("userIp")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "userIp", valid_580246
  var valid_580247 = query.getOrDefault("quotaUser")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "quotaUser", valid_580247
  var valid_580248 = query.getOrDefault("orderBy")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = newJString("startTime"))
  if valid_580248 != nil:
    section.add "orderBy", valid_580248
  var valid_580249 = query.getOrDefault("pageToken")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "pageToken", valid_580249
  var valid_580250 = query.getOrDefault("timeZone")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "timeZone", valid_580250
  var valid_580251 = query.getOrDefault("timeMax")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "timeMax", valid_580251
  var valid_580252 = query.getOrDefault("showHiddenInvitations")
  valid_580252 = validateParameter(valid_580252, JBool, required = false, default = nil)
  if valid_580252 != nil:
    section.add "showHiddenInvitations", valid_580252
  var valid_580253 = query.getOrDefault("singleEvents")
  valid_580253 = validateParameter(valid_580253, JBool, required = false, default = nil)
  if valid_580253 != nil:
    section.add "singleEvents", valid_580253
  var valid_580254 = query.getOrDefault("alwaysIncludeEmail")
  valid_580254 = validateParameter(valid_580254, JBool, required = false, default = nil)
  if valid_580254 != nil:
    section.add "alwaysIncludeEmail", valid_580254
  var valid_580255 = query.getOrDefault("sharedExtendedProperty")
  valid_580255 = validateParameter(valid_580255, JArray, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "sharedExtendedProperty", valid_580255
  var valid_580256 = query.getOrDefault("updatedMin")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "updatedMin", valid_580256
  var valid_580257 = query.getOrDefault("fields")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "fields", valid_580257
  var valid_580258 = query.getOrDefault("syncToken")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "syncToken", valid_580258
  var valid_580259 = query.getOrDefault("showDeleted")
  valid_580259 = validateParameter(valid_580259, JBool, required = false, default = nil)
  if valid_580259 != nil:
    section.add "showDeleted", valid_580259
  var valid_580260 = query.getOrDefault("maxResults")
  valid_580260 = validateParameter(valid_580260, JInt, required = false,
                                 default = newJInt(250))
  if valid_580260 != nil:
    section.add "maxResults", valid_580260
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

proc call*(call_580262: Call_CalendarEventsWatch_580233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to Events resources.
  ## 
  let valid = call_580262.validator(path, query, header, formData, body)
  let scheme = call_580262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580262.url(scheme.get, call_580262.host, call_580262.base,
                         call_580262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580262, url, valid)

proc call*(call_580263: Call_CalendarEventsWatch_580233; calendarId: string;
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
  var path_580264 = newJObject()
  var query_580265 = newJObject()
  var body_580266 = newJObject()
  add(query_580265, "key", newJString(key))
  add(query_580265, "prettyPrint", newJBool(prettyPrint))
  add(query_580265, "oauth_token", newJString(oauthToken))
  add(query_580265, "iCalUID", newJString(iCalUID))
  add(path_580264, "calendarId", newJString(calendarId))
  add(query_580265, "maxAttendees", newJInt(maxAttendees))
  add(query_580265, "q", newJString(q))
  if privateExtendedProperty != nil:
    query_580265.add "privateExtendedProperty", privateExtendedProperty
  add(query_580265, "timeMin", newJString(timeMin))
  add(query_580265, "alt", newJString(alt))
  add(query_580265, "userIp", newJString(userIp))
  add(query_580265, "quotaUser", newJString(quotaUser))
  add(query_580265, "orderBy", newJString(orderBy))
  add(query_580265, "pageToken", newJString(pageToken))
  add(query_580265, "timeZone", newJString(timeZone))
  add(query_580265, "timeMax", newJString(timeMax))
  add(query_580265, "showHiddenInvitations", newJBool(showHiddenInvitations))
  add(query_580265, "singleEvents", newJBool(singleEvents))
  add(query_580265, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if sharedExtendedProperty != nil:
    query_580265.add "sharedExtendedProperty", sharedExtendedProperty
  if resource != nil:
    body_580266 = resource
  add(query_580265, "updatedMin", newJString(updatedMin))
  add(query_580265, "fields", newJString(fields))
  add(query_580265, "syncToken", newJString(syncToken))
  add(query_580265, "showDeleted", newJBool(showDeleted))
  add(query_580265, "maxResults", newJInt(maxResults))
  result = call_580263.call(path_580264, query_580265, nil, nil, body_580266)

var calendarEventsWatch* = Call_CalendarEventsWatch_580233(
    name: "calendarEventsWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/watch",
    validator: validate_CalendarEventsWatch_580234, base: "/calendar/v3",
    url: url_CalendarEventsWatch_580235, schemes: {Scheme.Https})
type
  Call_CalendarEventsUpdate_580286 = ref object of OpenApiRestCall_579380
proc url_CalendarEventsUpdate_580288(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarEventsUpdate_580287(path: JsonNode; query: JsonNode;
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
  var valid_580289 = path.getOrDefault("calendarId")
  valid_580289 = validateParameter(valid_580289, JString, required = true,
                                 default = nil)
  if valid_580289 != nil:
    section.add "calendarId", valid_580289
  var valid_580290 = path.getOrDefault("eventId")
  valid_580290 = validateParameter(valid_580290, JString, required = true,
                                 default = nil)
  if valid_580290 != nil:
    section.add "eventId", valid_580290
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
  var valid_580291 = query.getOrDefault("key")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "key", valid_580291
  var valid_580292 = query.getOrDefault("prettyPrint")
  valid_580292 = validateParameter(valid_580292, JBool, required = false,
                                 default = newJBool(true))
  if valid_580292 != nil:
    section.add "prettyPrint", valid_580292
  var valid_580293 = query.getOrDefault("oauth_token")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "oauth_token", valid_580293
  var valid_580294 = query.getOrDefault("sendNotifications")
  valid_580294 = validateParameter(valid_580294, JBool, required = false, default = nil)
  if valid_580294 != nil:
    section.add "sendNotifications", valid_580294
  var valid_580295 = query.getOrDefault("maxAttendees")
  valid_580295 = validateParameter(valid_580295, JInt, required = false, default = nil)
  if valid_580295 != nil:
    section.add "maxAttendees", valid_580295
  var valid_580296 = query.getOrDefault("alt")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("json"))
  if valid_580296 != nil:
    section.add "alt", valid_580296
  var valid_580297 = query.getOrDefault("userIp")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "userIp", valid_580297
  var valid_580298 = query.getOrDefault("quotaUser")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "quotaUser", valid_580298
  var valid_580299 = query.getOrDefault("supportsAttachments")
  valid_580299 = validateParameter(valid_580299, JBool, required = false, default = nil)
  if valid_580299 != nil:
    section.add "supportsAttachments", valid_580299
  var valid_580300 = query.getOrDefault("alwaysIncludeEmail")
  valid_580300 = validateParameter(valid_580300, JBool, required = false, default = nil)
  if valid_580300 != nil:
    section.add "alwaysIncludeEmail", valid_580300
  var valid_580301 = query.getOrDefault("conferenceDataVersion")
  valid_580301 = validateParameter(valid_580301, JInt, required = false, default = nil)
  if valid_580301 != nil:
    section.add "conferenceDataVersion", valid_580301
  var valid_580302 = query.getOrDefault("fields")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "fields", valid_580302
  var valid_580303 = query.getOrDefault("sendUpdates")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = newJString("all"))
  if valid_580303 != nil:
    section.add "sendUpdates", valid_580303
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

proc call*(call_580305: Call_CalendarEventsUpdate_580286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an event.
  ## 
  let valid = call_580305.validator(path, query, header, formData, body)
  let scheme = call_580305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580305.url(scheme.get, call_580305.host, call_580305.base,
                         call_580305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580305, url, valid)

proc call*(call_580306: Call_CalendarEventsUpdate_580286; calendarId: string;
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
  var path_580307 = newJObject()
  var query_580308 = newJObject()
  var body_580309 = newJObject()
  add(query_580308, "key", newJString(key))
  add(query_580308, "prettyPrint", newJBool(prettyPrint))
  add(query_580308, "oauth_token", newJString(oauthToken))
  add(query_580308, "sendNotifications", newJBool(sendNotifications))
  add(path_580307, "calendarId", newJString(calendarId))
  add(query_580308, "maxAttendees", newJInt(maxAttendees))
  add(path_580307, "eventId", newJString(eventId))
  add(query_580308, "alt", newJString(alt))
  add(query_580308, "userIp", newJString(userIp))
  add(query_580308, "quotaUser", newJString(quotaUser))
  add(query_580308, "supportsAttachments", newJBool(supportsAttachments))
  add(query_580308, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if body != nil:
    body_580309 = body
  add(query_580308, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_580308, "fields", newJString(fields))
  add(query_580308, "sendUpdates", newJString(sendUpdates))
  result = call_580306.call(path_580307, query_580308, nil, nil, body_580309)

var calendarEventsUpdate* = Call_CalendarEventsUpdate_580286(
    name: "calendarEventsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsUpdate_580287, base: "/calendar/v3",
    url: url_CalendarEventsUpdate_580288, schemes: {Scheme.Https})
type
  Call_CalendarEventsGet_580267 = ref object of OpenApiRestCall_579380
proc url_CalendarEventsGet_580269(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarEventsGet_580268(path: JsonNode; query: JsonNode;
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
  var valid_580270 = path.getOrDefault("calendarId")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "calendarId", valid_580270
  var valid_580271 = path.getOrDefault("eventId")
  valid_580271 = validateParameter(valid_580271, JString, required = true,
                                 default = nil)
  if valid_580271 != nil:
    section.add "eventId", valid_580271
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
  var valid_580272 = query.getOrDefault("key")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "key", valid_580272
  var valid_580273 = query.getOrDefault("prettyPrint")
  valid_580273 = validateParameter(valid_580273, JBool, required = false,
                                 default = newJBool(true))
  if valid_580273 != nil:
    section.add "prettyPrint", valid_580273
  var valid_580274 = query.getOrDefault("oauth_token")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "oauth_token", valid_580274
  var valid_580275 = query.getOrDefault("maxAttendees")
  valid_580275 = validateParameter(valid_580275, JInt, required = false, default = nil)
  if valid_580275 != nil:
    section.add "maxAttendees", valid_580275
  var valid_580276 = query.getOrDefault("alt")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = newJString("json"))
  if valid_580276 != nil:
    section.add "alt", valid_580276
  var valid_580277 = query.getOrDefault("userIp")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "userIp", valid_580277
  var valid_580278 = query.getOrDefault("quotaUser")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "quotaUser", valid_580278
  var valid_580279 = query.getOrDefault("timeZone")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "timeZone", valid_580279
  var valid_580280 = query.getOrDefault("alwaysIncludeEmail")
  valid_580280 = validateParameter(valid_580280, JBool, required = false, default = nil)
  if valid_580280 != nil:
    section.add "alwaysIncludeEmail", valid_580280
  var valid_580281 = query.getOrDefault("fields")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "fields", valid_580281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580282: Call_CalendarEventsGet_580267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an event.
  ## 
  let valid = call_580282.validator(path, query, header, formData, body)
  let scheme = call_580282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580282.url(scheme.get, call_580282.host, call_580282.base,
                         call_580282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580282, url, valid)

proc call*(call_580283: Call_CalendarEventsGet_580267; calendarId: string;
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
  var path_580284 = newJObject()
  var query_580285 = newJObject()
  add(query_580285, "key", newJString(key))
  add(query_580285, "prettyPrint", newJBool(prettyPrint))
  add(query_580285, "oauth_token", newJString(oauthToken))
  add(path_580284, "calendarId", newJString(calendarId))
  add(query_580285, "maxAttendees", newJInt(maxAttendees))
  add(path_580284, "eventId", newJString(eventId))
  add(query_580285, "alt", newJString(alt))
  add(query_580285, "userIp", newJString(userIp))
  add(query_580285, "quotaUser", newJString(quotaUser))
  add(query_580285, "timeZone", newJString(timeZone))
  add(query_580285, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_580285, "fields", newJString(fields))
  result = call_580283.call(path_580284, query_580285, nil, nil, nil)

var calendarEventsGet* = Call_CalendarEventsGet_580267(name: "calendarEventsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsGet_580268, base: "/calendar/v3",
    url: url_CalendarEventsGet_580269, schemes: {Scheme.Https})
type
  Call_CalendarEventsPatch_580328 = ref object of OpenApiRestCall_579380
proc url_CalendarEventsPatch_580330(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarEventsPatch_580329(path: JsonNode; query: JsonNode;
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
  var valid_580331 = path.getOrDefault("calendarId")
  valid_580331 = validateParameter(valid_580331, JString, required = true,
                                 default = nil)
  if valid_580331 != nil:
    section.add "calendarId", valid_580331
  var valid_580332 = path.getOrDefault("eventId")
  valid_580332 = validateParameter(valid_580332, JString, required = true,
                                 default = nil)
  if valid_580332 != nil:
    section.add "eventId", valid_580332
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
  var valid_580333 = query.getOrDefault("key")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "key", valid_580333
  var valid_580334 = query.getOrDefault("prettyPrint")
  valid_580334 = validateParameter(valid_580334, JBool, required = false,
                                 default = newJBool(true))
  if valid_580334 != nil:
    section.add "prettyPrint", valid_580334
  var valid_580335 = query.getOrDefault("oauth_token")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "oauth_token", valid_580335
  var valid_580336 = query.getOrDefault("sendNotifications")
  valid_580336 = validateParameter(valid_580336, JBool, required = false, default = nil)
  if valid_580336 != nil:
    section.add "sendNotifications", valid_580336
  var valid_580337 = query.getOrDefault("maxAttendees")
  valid_580337 = validateParameter(valid_580337, JInt, required = false, default = nil)
  if valid_580337 != nil:
    section.add "maxAttendees", valid_580337
  var valid_580338 = query.getOrDefault("alt")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = newJString("json"))
  if valid_580338 != nil:
    section.add "alt", valid_580338
  var valid_580339 = query.getOrDefault("userIp")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "userIp", valid_580339
  var valid_580340 = query.getOrDefault("quotaUser")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "quotaUser", valid_580340
  var valid_580341 = query.getOrDefault("supportsAttachments")
  valid_580341 = validateParameter(valid_580341, JBool, required = false, default = nil)
  if valid_580341 != nil:
    section.add "supportsAttachments", valid_580341
  var valid_580342 = query.getOrDefault("alwaysIncludeEmail")
  valid_580342 = validateParameter(valid_580342, JBool, required = false, default = nil)
  if valid_580342 != nil:
    section.add "alwaysIncludeEmail", valid_580342
  var valid_580343 = query.getOrDefault("conferenceDataVersion")
  valid_580343 = validateParameter(valid_580343, JInt, required = false, default = nil)
  if valid_580343 != nil:
    section.add "conferenceDataVersion", valid_580343
  var valid_580344 = query.getOrDefault("fields")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "fields", valid_580344
  var valid_580345 = query.getOrDefault("sendUpdates")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = newJString("all"))
  if valid_580345 != nil:
    section.add "sendUpdates", valid_580345
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

proc call*(call_580347: Call_CalendarEventsPatch_580328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an event. This method supports patch semantics.
  ## 
  let valid = call_580347.validator(path, query, header, formData, body)
  let scheme = call_580347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580347.url(scheme.get, call_580347.host, call_580347.base,
                         call_580347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580347, url, valid)

proc call*(call_580348: Call_CalendarEventsPatch_580328; calendarId: string;
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
  var path_580349 = newJObject()
  var query_580350 = newJObject()
  var body_580351 = newJObject()
  add(query_580350, "key", newJString(key))
  add(query_580350, "prettyPrint", newJBool(prettyPrint))
  add(query_580350, "oauth_token", newJString(oauthToken))
  add(query_580350, "sendNotifications", newJBool(sendNotifications))
  add(path_580349, "calendarId", newJString(calendarId))
  add(query_580350, "maxAttendees", newJInt(maxAttendees))
  add(path_580349, "eventId", newJString(eventId))
  add(query_580350, "alt", newJString(alt))
  add(query_580350, "userIp", newJString(userIp))
  add(query_580350, "quotaUser", newJString(quotaUser))
  add(query_580350, "supportsAttachments", newJBool(supportsAttachments))
  add(query_580350, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if body != nil:
    body_580351 = body
  add(query_580350, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_580350, "fields", newJString(fields))
  add(query_580350, "sendUpdates", newJString(sendUpdates))
  result = call_580348.call(path_580349, query_580350, nil, nil, body_580351)

var calendarEventsPatch* = Call_CalendarEventsPatch_580328(
    name: "calendarEventsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsPatch_580329, base: "/calendar/v3",
    url: url_CalendarEventsPatch_580330, schemes: {Scheme.Https})
type
  Call_CalendarEventsDelete_580310 = ref object of OpenApiRestCall_579380
proc url_CalendarEventsDelete_580312(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarEventsDelete_580311(path: JsonNode; query: JsonNode;
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
  var valid_580313 = path.getOrDefault("calendarId")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "calendarId", valid_580313
  var valid_580314 = path.getOrDefault("eventId")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "eventId", valid_580314
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
  var valid_580315 = query.getOrDefault("key")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "key", valid_580315
  var valid_580316 = query.getOrDefault("prettyPrint")
  valid_580316 = validateParameter(valid_580316, JBool, required = false,
                                 default = newJBool(true))
  if valid_580316 != nil:
    section.add "prettyPrint", valid_580316
  var valid_580317 = query.getOrDefault("oauth_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "oauth_token", valid_580317
  var valid_580318 = query.getOrDefault("sendNotifications")
  valid_580318 = validateParameter(valid_580318, JBool, required = false, default = nil)
  if valid_580318 != nil:
    section.add "sendNotifications", valid_580318
  var valid_580319 = query.getOrDefault("alt")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = newJString("json"))
  if valid_580319 != nil:
    section.add "alt", valid_580319
  var valid_580320 = query.getOrDefault("userIp")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "userIp", valid_580320
  var valid_580321 = query.getOrDefault("quotaUser")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "quotaUser", valid_580321
  var valid_580322 = query.getOrDefault("fields")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "fields", valid_580322
  var valid_580323 = query.getOrDefault("sendUpdates")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = newJString("all"))
  if valid_580323 != nil:
    section.add "sendUpdates", valid_580323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580324: Call_CalendarEventsDelete_580310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an event.
  ## 
  let valid = call_580324.validator(path, query, header, formData, body)
  let scheme = call_580324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580324.url(scheme.get, call_580324.host, call_580324.base,
                         call_580324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580324, url, valid)

proc call*(call_580325: Call_CalendarEventsDelete_580310; calendarId: string;
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
  var path_580326 = newJObject()
  var query_580327 = newJObject()
  add(query_580327, "key", newJString(key))
  add(query_580327, "prettyPrint", newJBool(prettyPrint))
  add(query_580327, "oauth_token", newJString(oauthToken))
  add(query_580327, "sendNotifications", newJBool(sendNotifications))
  add(path_580326, "calendarId", newJString(calendarId))
  add(path_580326, "eventId", newJString(eventId))
  add(query_580327, "alt", newJString(alt))
  add(query_580327, "userIp", newJString(userIp))
  add(query_580327, "quotaUser", newJString(quotaUser))
  add(query_580327, "fields", newJString(fields))
  add(query_580327, "sendUpdates", newJString(sendUpdates))
  result = call_580325.call(path_580326, query_580327, nil, nil, nil)

var calendarEventsDelete* = Call_CalendarEventsDelete_580310(
    name: "calendarEventsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsDelete_580311, base: "/calendar/v3",
    url: url_CalendarEventsDelete_580312, schemes: {Scheme.Https})
type
  Call_CalendarEventsInstances_580352 = ref object of OpenApiRestCall_579380
proc url_CalendarEventsInstances_580354(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarEventsInstances_580353(path: JsonNode; query: JsonNode;
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
  var valid_580355 = path.getOrDefault("calendarId")
  valid_580355 = validateParameter(valid_580355, JString, required = true,
                                 default = nil)
  if valid_580355 != nil:
    section.add "calendarId", valid_580355
  var valid_580356 = path.getOrDefault("eventId")
  valid_580356 = validateParameter(valid_580356, JString, required = true,
                                 default = nil)
  if valid_580356 != nil:
    section.add "eventId", valid_580356
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
  var valid_580357 = query.getOrDefault("key")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "key", valid_580357
  var valid_580358 = query.getOrDefault("prettyPrint")
  valid_580358 = validateParameter(valid_580358, JBool, required = false,
                                 default = newJBool(true))
  if valid_580358 != nil:
    section.add "prettyPrint", valid_580358
  var valid_580359 = query.getOrDefault("oauth_token")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "oauth_token", valid_580359
  var valid_580360 = query.getOrDefault("originalStart")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "originalStart", valid_580360
  var valid_580361 = query.getOrDefault("maxAttendees")
  valid_580361 = validateParameter(valid_580361, JInt, required = false, default = nil)
  if valid_580361 != nil:
    section.add "maxAttendees", valid_580361
  var valid_580362 = query.getOrDefault("timeMin")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "timeMin", valid_580362
  var valid_580363 = query.getOrDefault("alt")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = newJString("json"))
  if valid_580363 != nil:
    section.add "alt", valid_580363
  var valid_580364 = query.getOrDefault("userIp")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "userIp", valid_580364
  var valid_580365 = query.getOrDefault("quotaUser")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "quotaUser", valid_580365
  var valid_580366 = query.getOrDefault("pageToken")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "pageToken", valid_580366
  var valid_580367 = query.getOrDefault("timeZone")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "timeZone", valid_580367
  var valid_580368 = query.getOrDefault("timeMax")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "timeMax", valid_580368
  var valid_580369 = query.getOrDefault("alwaysIncludeEmail")
  valid_580369 = validateParameter(valid_580369, JBool, required = false, default = nil)
  if valid_580369 != nil:
    section.add "alwaysIncludeEmail", valid_580369
  var valid_580370 = query.getOrDefault("fields")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "fields", valid_580370
  var valid_580371 = query.getOrDefault("showDeleted")
  valid_580371 = validateParameter(valid_580371, JBool, required = false, default = nil)
  if valid_580371 != nil:
    section.add "showDeleted", valid_580371
  var valid_580372 = query.getOrDefault("maxResults")
  valid_580372 = validateParameter(valid_580372, JInt, required = false, default = nil)
  if valid_580372 != nil:
    section.add "maxResults", valid_580372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580373: Call_CalendarEventsInstances_580352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns instances of the specified recurring event.
  ## 
  let valid = call_580373.validator(path, query, header, formData, body)
  let scheme = call_580373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580373.url(scheme.get, call_580373.host, call_580373.base,
                         call_580373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580373, url, valid)

proc call*(call_580374: Call_CalendarEventsInstances_580352; calendarId: string;
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
  var path_580375 = newJObject()
  var query_580376 = newJObject()
  add(query_580376, "key", newJString(key))
  add(query_580376, "prettyPrint", newJBool(prettyPrint))
  add(query_580376, "oauth_token", newJString(oauthToken))
  add(query_580376, "originalStart", newJString(originalStart))
  add(path_580375, "calendarId", newJString(calendarId))
  add(query_580376, "maxAttendees", newJInt(maxAttendees))
  add(path_580375, "eventId", newJString(eventId))
  add(query_580376, "timeMin", newJString(timeMin))
  add(query_580376, "alt", newJString(alt))
  add(query_580376, "userIp", newJString(userIp))
  add(query_580376, "quotaUser", newJString(quotaUser))
  add(query_580376, "pageToken", newJString(pageToken))
  add(query_580376, "timeZone", newJString(timeZone))
  add(query_580376, "timeMax", newJString(timeMax))
  add(query_580376, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_580376, "fields", newJString(fields))
  add(query_580376, "showDeleted", newJBool(showDeleted))
  add(query_580376, "maxResults", newJInt(maxResults))
  result = call_580374.call(path_580375, query_580376, nil, nil, nil)

var calendarEventsInstances* = Call_CalendarEventsInstances_580352(
    name: "calendarEventsInstances", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}/instances",
    validator: validate_CalendarEventsInstances_580353, base: "/calendar/v3",
    url: url_CalendarEventsInstances_580354, schemes: {Scheme.Https})
type
  Call_CalendarEventsMove_580377 = ref object of OpenApiRestCall_579380
proc url_CalendarEventsMove_580379(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarEventsMove_580378(path: JsonNode; query: JsonNode;
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
  var valid_580380 = path.getOrDefault("calendarId")
  valid_580380 = validateParameter(valid_580380, JString, required = true,
                                 default = nil)
  if valid_580380 != nil:
    section.add "calendarId", valid_580380
  var valid_580381 = path.getOrDefault("eventId")
  valid_580381 = validateParameter(valid_580381, JString, required = true,
                                 default = nil)
  if valid_580381 != nil:
    section.add "eventId", valid_580381
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
  var valid_580382 = query.getOrDefault("key")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "key", valid_580382
  var valid_580383 = query.getOrDefault("prettyPrint")
  valid_580383 = validateParameter(valid_580383, JBool, required = false,
                                 default = newJBool(true))
  if valid_580383 != nil:
    section.add "prettyPrint", valid_580383
  var valid_580384 = query.getOrDefault("oauth_token")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "oauth_token", valid_580384
  var valid_580385 = query.getOrDefault("sendNotifications")
  valid_580385 = validateParameter(valid_580385, JBool, required = false, default = nil)
  if valid_580385 != nil:
    section.add "sendNotifications", valid_580385
  var valid_580386 = query.getOrDefault("alt")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = newJString("json"))
  if valid_580386 != nil:
    section.add "alt", valid_580386
  var valid_580387 = query.getOrDefault("userIp")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "userIp", valid_580387
  var valid_580388 = query.getOrDefault("quotaUser")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "quotaUser", valid_580388
  assert query != nil,
        "query argument is necessary due to required `destination` field"
  var valid_580389 = query.getOrDefault("destination")
  valid_580389 = validateParameter(valid_580389, JString, required = true,
                                 default = nil)
  if valid_580389 != nil:
    section.add "destination", valid_580389
  var valid_580390 = query.getOrDefault("fields")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "fields", valid_580390
  var valid_580391 = query.getOrDefault("sendUpdates")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = newJString("all"))
  if valid_580391 != nil:
    section.add "sendUpdates", valid_580391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580392: Call_CalendarEventsMove_580377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves an event to another calendar, i.e. changes an event's organizer.
  ## 
  let valid = call_580392.validator(path, query, header, formData, body)
  let scheme = call_580392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580392.url(scheme.get, call_580392.host, call_580392.base,
                         call_580392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580392, url, valid)

proc call*(call_580393: Call_CalendarEventsMove_580377; calendarId: string;
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
  var path_580394 = newJObject()
  var query_580395 = newJObject()
  add(query_580395, "key", newJString(key))
  add(query_580395, "prettyPrint", newJBool(prettyPrint))
  add(query_580395, "oauth_token", newJString(oauthToken))
  add(query_580395, "sendNotifications", newJBool(sendNotifications))
  add(path_580394, "calendarId", newJString(calendarId))
  add(path_580394, "eventId", newJString(eventId))
  add(query_580395, "alt", newJString(alt))
  add(query_580395, "userIp", newJString(userIp))
  add(query_580395, "quotaUser", newJString(quotaUser))
  add(query_580395, "destination", newJString(destination))
  add(query_580395, "fields", newJString(fields))
  add(query_580395, "sendUpdates", newJString(sendUpdates))
  result = call_580393.call(path_580394, query_580395, nil, nil, nil)

var calendarEventsMove* = Call_CalendarEventsMove_580377(
    name: "calendarEventsMove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}/move",
    validator: validate_CalendarEventsMove_580378, base: "/calendar/v3",
    url: url_CalendarEventsMove_580379, schemes: {Scheme.Https})
type
  Call_CalendarChannelsStop_580396 = ref object of OpenApiRestCall_579380
proc url_CalendarChannelsStop_580398(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarChannelsStop_580397(path: JsonNode; query: JsonNode;
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
  var valid_580399 = query.getOrDefault("key")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "key", valid_580399
  var valid_580400 = query.getOrDefault("prettyPrint")
  valid_580400 = validateParameter(valid_580400, JBool, required = false,
                                 default = newJBool(true))
  if valid_580400 != nil:
    section.add "prettyPrint", valid_580400
  var valid_580401 = query.getOrDefault("oauth_token")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "oauth_token", valid_580401
  var valid_580402 = query.getOrDefault("alt")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = newJString("json"))
  if valid_580402 != nil:
    section.add "alt", valid_580402
  var valid_580403 = query.getOrDefault("userIp")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "userIp", valid_580403
  var valid_580404 = query.getOrDefault("quotaUser")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "quotaUser", valid_580404
  var valid_580405 = query.getOrDefault("fields")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "fields", valid_580405
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

proc call*(call_580407: Call_CalendarChannelsStop_580396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_580407.validator(path, query, header, formData, body)
  let scheme = call_580407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580407.url(scheme.get, call_580407.host, call_580407.base,
                         call_580407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580407, url, valid)

proc call*(call_580408: Call_CalendarChannelsStop_580396; key: string = "";
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
  var query_580409 = newJObject()
  var body_580410 = newJObject()
  add(query_580409, "key", newJString(key))
  add(query_580409, "prettyPrint", newJBool(prettyPrint))
  add(query_580409, "oauth_token", newJString(oauthToken))
  add(query_580409, "alt", newJString(alt))
  add(query_580409, "userIp", newJString(userIp))
  add(query_580409, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_580410 = resource
  add(query_580409, "fields", newJString(fields))
  result = call_580408.call(nil, query_580409, nil, nil, body_580410)

var calendarChannelsStop* = Call_CalendarChannelsStop_580396(
    name: "calendarChannelsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_CalendarChannelsStop_580397, base: "/calendar/v3",
    url: url_CalendarChannelsStop_580398, schemes: {Scheme.Https})
type
  Call_CalendarColorsGet_580411 = ref object of OpenApiRestCall_579380
proc url_CalendarColorsGet_580413(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarColorsGet_580412(path: JsonNode; query: JsonNode;
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
  var valid_580414 = query.getOrDefault("key")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "key", valid_580414
  var valid_580415 = query.getOrDefault("prettyPrint")
  valid_580415 = validateParameter(valid_580415, JBool, required = false,
                                 default = newJBool(true))
  if valid_580415 != nil:
    section.add "prettyPrint", valid_580415
  var valid_580416 = query.getOrDefault("oauth_token")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "oauth_token", valid_580416
  var valid_580417 = query.getOrDefault("alt")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = newJString("json"))
  if valid_580417 != nil:
    section.add "alt", valid_580417
  var valid_580418 = query.getOrDefault("userIp")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "userIp", valid_580418
  var valid_580419 = query.getOrDefault("quotaUser")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "quotaUser", valid_580419
  var valid_580420 = query.getOrDefault("fields")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "fields", valid_580420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580421: Call_CalendarColorsGet_580411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the color definitions for calendars and events.
  ## 
  let valid = call_580421.validator(path, query, header, formData, body)
  let scheme = call_580421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580421.url(scheme.get, call_580421.host, call_580421.base,
                         call_580421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580421, url, valid)

proc call*(call_580422: Call_CalendarColorsGet_580411; key: string = "";
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
  var query_580423 = newJObject()
  add(query_580423, "key", newJString(key))
  add(query_580423, "prettyPrint", newJBool(prettyPrint))
  add(query_580423, "oauth_token", newJString(oauthToken))
  add(query_580423, "alt", newJString(alt))
  add(query_580423, "userIp", newJString(userIp))
  add(query_580423, "quotaUser", newJString(quotaUser))
  add(query_580423, "fields", newJString(fields))
  result = call_580422.call(nil, query_580423, nil, nil, nil)

var calendarColorsGet* = Call_CalendarColorsGet_580411(name: "calendarColorsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/colors",
    validator: validate_CalendarColorsGet_580412, base: "/calendar/v3",
    url: url_CalendarColorsGet_580413, schemes: {Scheme.Https})
type
  Call_CalendarFreebusyQuery_580424 = ref object of OpenApiRestCall_579380
proc url_CalendarFreebusyQuery_580426(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarFreebusyQuery_580425(path: JsonNode; query: JsonNode;
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
  var valid_580427 = query.getOrDefault("key")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "key", valid_580427
  var valid_580428 = query.getOrDefault("prettyPrint")
  valid_580428 = validateParameter(valid_580428, JBool, required = false,
                                 default = newJBool(true))
  if valid_580428 != nil:
    section.add "prettyPrint", valid_580428
  var valid_580429 = query.getOrDefault("oauth_token")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "oauth_token", valid_580429
  var valid_580430 = query.getOrDefault("alt")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = newJString("json"))
  if valid_580430 != nil:
    section.add "alt", valid_580430
  var valid_580431 = query.getOrDefault("userIp")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "userIp", valid_580431
  var valid_580432 = query.getOrDefault("quotaUser")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "quotaUser", valid_580432
  var valid_580433 = query.getOrDefault("fields")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "fields", valid_580433
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

proc call*(call_580435: Call_CalendarFreebusyQuery_580424; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns free/busy information for a set of calendars.
  ## 
  let valid = call_580435.validator(path, query, header, formData, body)
  let scheme = call_580435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580435.url(scheme.get, call_580435.host, call_580435.base,
                         call_580435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580435, url, valid)

proc call*(call_580436: Call_CalendarFreebusyQuery_580424; key: string = "";
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
  var query_580437 = newJObject()
  var body_580438 = newJObject()
  add(query_580437, "key", newJString(key))
  add(query_580437, "prettyPrint", newJBool(prettyPrint))
  add(query_580437, "oauth_token", newJString(oauthToken))
  add(query_580437, "alt", newJString(alt))
  add(query_580437, "userIp", newJString(userIp))
  add(query_580437, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580438 = body
  add(query_580437, "fields", newJString(fields))
  result = call_580436.call(nil, query_580437, nil, nil, body_580438)

var calendarFreebusyQuery* = Call_CalendarFreebusyQuery_580424(
    name: "calendarFreebusyQuery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/freeBusy",
    validator: validate_CalendarFreebusyQuery_580425, base: "/calendar/v3",
    url: url_CalendarFreebusyQuery_580426, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListInsert_580458 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarListInsert_580460(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CalendarCalendarListInsert_580459(path: JsonNode; query: JsonNode;
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
  var valid_580461 = query.getOrDefault("key")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "key", valid_580461
  var valid_580462 = query.getOrDefault("prettyPrint")
  valid_580462 = validateParameter(valid_580462, JBool, required = false,
                                 default = newJBool(true))
  if valid_580462 != nil:
    section.add "prettyPrint", valid_580462
  var valid_580463 = query.getOrDefault("oauth_token")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "oauth_token", valid_580463
  var valid_580464 = query.getOrDefault("alt")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = newJString("json"))
  if valid_580464 != nil:
    section.add "alt", valid_580464
  var valid_580465 = query.getOrDefault("userIp")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "userIp", valid_580465
  var valid_580466 = query.getOrDefault("quotaUser")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "quotaUser", valid_580466
  var valid_580467 = query.getOrDefault("colorRgbFormat")
  valid_580467 = validateParameter(valid_580467, JBool, required = false, default = nil)
  if valid_580467 != nil:
    section.add "colorRgbFormat", valid_580467
  var valid_580468 = query.getOrDefault("fields")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "fields", valid_580468
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

proc call*(call_580470: Call_CalendarCalendarListInsert_580458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts an existing calendar into the user's calendar list.
  ## 
  let valid = call_580470.validator(path, query, header, formData, body)
  let scheme = call_580470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580470.url(scheme.get, call_580470.host, call_580470.base,
                         call_580470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580470, url, valid)

proc call*(call_580471: Call_CalendarCalendarListInsert_580458; key: string = "";
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
  var query_580472 = newJObject()
  var body_580473 = newJObject()
  add(query_580472, "key", newJString(key))
  add(query_580472, "prettyPrint", newJBool(prettyPrint))
  add(query_580472, "oauth_token", newJString(oauthToken))
  add(query_580472, "alt", newJString(alt))
  add(query_580472, "userIp", newJString(userIp))
  add(query_580472, "quotaUser", newJString(quotaUser))
  add(query_580472, "colorRgbFormat", newJBool(colorRgbFormat))
  if body != nil:
    body_580473 = body
  add(query_580472, "fields", newJString(fields))
  result = call_580471.call(nil, query_580472, nil, nil, body_580473)

var calendarCalendarListInsert* = Call_CalendarCalendarListInsert_580458(
    name: "calendarCalendarListInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/calendarList",
    validator: validate_CalendarCalendarListInsert_580459, base: "/calendar/v3",
    url: url_CalendarCalendarListInsert_580460, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListList_580439 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarListList_580441(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CalendarCalendarListList_580440(path: JsonNode; query: JsonNode;
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
  var valid_580442 = query.getOrDefault("key")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "key", valid_580442
  var valid_580443 = query.getOrDefault("prettyPrint")
  valid_580443 = validateParameter(valid_580443, JBool, required = false,
                                 default = newJBool(true))
  if valid_580443 != nil:
    section.add "prettyPrint", valid_580443
  var valid_580444 = query.getOrDefault("oauth_token")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "oauth_token", valid_580444
  var valid_580445 = query.getOrDefault("alt")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = newJString("json"))
  if valid_580445 != nil:
    section.add "alt", valid_580445
  var valid_580446 = query.getOrDefault("userIp")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "userIp", valid_580446
  var valid_580447 = query.getOrDefault("quotaUser")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "quotaUser", valid_580447
  var valid_580448 = query.getOrDefault("pageToken")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "pageToken", valid_580448
  var valid_580449 = query.getOrDefault("showHidden")
  valid_580449 = validateParameter(valid_580449, JBool, required = false, default = nil)
  if valid_580449 != nil:
    section.add "showHidden", valid_580449
  var valid_580450 = query.getOrDefault("minAccessRole")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = newJString("freeBusyReader"))
  if valid_580450 != nil:
    section.add "minAccessRole", valid_580450
  var valid_580451 = query.getOrDefault("fields")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "fields", valid_580451
  var valid_580452 = query.getOrDefault("syncToken")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "syncToken", valid_580452
  var valid_580453 = query.getOrDefault("showDeleted")
  valid_580453 = validateParameter(valid_580453, JBool, required = false, default = nil)
  if valid_580453 != nil:
    section.add "showDeleted", valid_580453
  var valid_580454 = query.getOrDefault("maxResults")
  valid_580454 = validateParameter(valid_580454, JInt, required = false, default = nil)
  if valid_580454 != nil:
    section.add "maxResults", valid_580454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580455: Call_CalendarCalendarListList_580439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the calendars on the user's calendar list.
  ## 
  let valid = call_580455.validator(path, query, header, formData, body)
  let scheme = call_580455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580455.url(scheme.get, call_580455.host, call_580455.base,
                         call_580455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580455, url, valid)

proc call*(call_580456: Call_CalendarCalendarListList_580439; key: string = "";
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
  var query_580457 = newJObject()
  add(query_580457, "key", newJString(key))
  add(query_580457, "prettyPrint", newJBool(prettyPrint))
  add(query_580457, "oauth_token", newJString(oauthToken))
  add(query_580457, "alt", newJString(alt))
  add(query_580457, "userIp", newJString(userIp))
  add(query_580457, "quotaUser", newJString(quotaUser))
  add(query_580457, "pageToken", newJString(pageToken))
  add(query_580457, "showHidden", newJBool(showHidden))
  add(query_580457, "minAccessRole", newJString(minAccessRole))
  add(query_580457, "fields", newJString(fields))
  add(query_580457, "syncToken", newJString(syncToken))
  add(query_580457, "showDeleted", newJBool(showDeleted))
  add(query_580457, "maxResults", newJInt(maxResults))
  result = call_580456.call(nil, query_580457, nil, nil, nil)

var calendarCalendarListList* = Call_CalendarCalendarListList_580439(
    name: "calendarCalendarListList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/calendarList",
    validator: validate_CalendarCalendarListList_580440, base: "/calendar/v3",
    url: url_CalendarCalendarListList_580441, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListWatch_580474 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarListWatch_580476(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CalendarCalendarListWatch_580475(path: JsonNode; query: JsonNode;
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
  var valid_580477 = query.getOrDefault("key")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "key", valid_580477
  var valid_580478 = query.getOrDefault("prettyPrint")
  valid_580478 = validateParameter(valid_580478, JBool, required = false,
                                 default = newJBool(true))
  if valid_580478 != nil:
    section.add "prettyPrint", valid_580478
  var valid_580479 = query.getOrDefault("oauth_token")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "oauth_token", valid_580479
  var valid_580480 = query.getOrDefault("alt")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = newJString("json"))
  if valid_580480 != nil:
    section.add "alt", valid_580480
  var valid_580481 = query.getOrDefault("userIp")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "userIp", valid_580481
  var valid_580482 = query.getOrDefault("quotaUser")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "quotaUser", valid_580482
  var valid_580483 = query.getOrDefault("pageToken")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "pageToken", valid_580483
  var valid_580484 = query.getOrDefault("showHidden")
  valid_580484 = validateParameter(valid_580484, JBool, required = false, default = nil)
  if valid_580484 != nil:
    section.add "showHidden", valid_580484
  var valid_580485 = query.getOrDefault("minAccessRole")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = newJString("freeBusyReader"))
  if valid_580485 != nil:
    section.add "minAccessRole", valid_580485
  var valid_580486 = query.getOrDefault("fields")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "fields", valid_580486
  var valid_580487 = query.getOrDefault("syncToken")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "syncToken", valid_580487
  var valid_580488 = query.getOrDefault("showDeleted")
  valid_580488 = validateParameter(valid_580488, JBool, required = false, default = nil)
  if valid_580488 != nil:
    section.add "showDeleted", valid_580488
  var valid_580489 = query.getOrDefault("maxResults")
  valid_580489 = validateParameter(valid_580489, JInt, required = false, default = nil)
  if valid_580489 != nil:
    section.add "maxResults", valid_580489
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

proc call*(call_580491: Call_CalendarCalendarListWatch_580474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to CalendarList resources.
  ## 
  let valid = call_580491.validator(path, query, header, formData, body)
  let scheme = call_580491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580491.url(scheme.get, call_580491.host, call_580491.base,
                         call_580491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580491, url, valid)

proc call*(call_580492: Call_CalendarCalendarListWatch_580474; key: string = "";
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
  var query_580493 = newJObject()
  var body_580494 = newJObject()
  add(query_580493, "key", newJString(key))
  add(query_580493, "prettyPrint", newJBool(prettyPrint))
  add(query_580493, "oauth_token", newJString(oauthToken))
  add(query_580493, "alt", newJString(alt))
  add(query_580493, "userIp", newJString(userIp))
  add(query_580493, "quotaUser", newJString(quotaUser))
  add(query_580493, "pageToken", newJString(pageToken))
  add(query_580493, "showHidden", newJBool(showHidden))
  add(query_580493, "minAccessRole", newJString(minAccessRole))
  if resource != nil:
    body_580494 = resource
  add(query_580493, "fields", newJString(fields))
  add(query_580493, "syncToken", newJString(syncToken))
  add(query_580493, "showDeleted", newJBool(showDeleted))
  add(query_580493, "maxResults", newJInt(maxResults))
  result = call_580492.call(nil, query_580493, nil, nil, body_580494)

var calendarCalendarListWatch* = Call_CalendarCalendarListWatch_580474(
    name: "calendarCalendarListWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/calendarList/watch",
    validator: validate_CalendarCalendarListWatch_580475, base: "/calendar/v3",
    url: url_CalendarCalendarListWatch_580476, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListUpdate_580510 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarListUpdate_580512(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarCalendarListUpdate_580511(path: JsonNode; query: JsonNode;
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
  var valid_580513 = path.getOrDefault("calendarId")
  valid_580513 = validateParameter(valid_580513, JString, required = true,
                                 default = nil)
  if valid_580513 != nil:
    section.add "calendarId", valid_580513
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
  var valid_580514 = query.getOrDefault("key")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "key", valid_580514
  var valid_580515 = query.getOrDefault("prettyPrint")
  valid_580515 = validateParameter(valid_580515, JBool, required = false,
                                 default = newJBool(true))
  if valid_580515 != nil:
    section.add "prettyPrint", valid_580515
  var valid_580516 = query.getOrDefault("oauth_token")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "oauth_token", valid_580516
  var valid_580517 = query.getOrDefault("alt")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = newJString("json"))
  if valid_580517 != nil:
    section.add "alt", valid_580517
  var valid_580518 = query.getOrDefault("userIp")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "userIp", valid_580518
  var valid_580519 = query.getOrDefault("quotaUser")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "quotaUser", valid_580519
  var valid_580520 = query.getOrDefault("colorRgbFormat")
  valid_580520 = validateParameter(valid_580520, JBool, required = false, default = nil)
  if valid_580520 != nil:
    section.add "colorRgbFormat", valid_580520
  var valid_580521 = query.getOrDefault("fields")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "fields", valid_580521
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

proc call*(call_580523: Call_CalendarCalendarListUpdate_580510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing calendar on the user's calendar list.
  ## 
  let valid = call_580523.validator(path, query, header, formData, body)
  let scheme = call_580523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580523.url(scheme.get, call_580523.host, call_580523.base,
                         call_580523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580523, url, valid)

proc call*(call_580524: Call_CalendarCalendarListUpdate_580510; calendarId: string;
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
  var path_580525 = newJObject()
  var query_580526 = newJObject()
  var body_580527 = newJObject()
  add(query_580526, "key", newJString(key))
  add(query_580526, "prettyPrint", newJBool(prettyPrint))
  add(query_580526, "oauth_token", newJString(oauthToken))
  add(path_580525, "calendarId", newJString(calendarId))
  add(query_580526, "alt", newJString(alt))
  add(query_580526, "userIp", newJString(userIp))
  add(query_580526, "quotaUser", newJString(quotaUser))
  add(query_580526, "colorRgbFormat", newJBool(colorRgbFormat))
  if body != nil:
    body_580527 = body
  add(query_580526, "fields", newJString(fields))
  result = call_580524.call(path_580525, query_580526, nil, nil, body_580527)

var calendarCalendarListUpdate* = Call_CalendarCalendarListUpdate_580510(
    name: "calendarCalendarListUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListUpdate_580511, base: "/calendar/v3",
    url: url_CalendarCalendarListUpdate_580512, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListGet_580495 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarListGet_580497(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarCalendarListGet_580496(path: JsonNode; query: JsonNode;
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
  var valid_580498 = path.getOrDefault("calendarId")
  valid_580498 = validateParameter(valid_580498, JString, required = true,
                                 default = nil)
  if valid_580498 != nil:
    section.add "calendarId", valid_580498
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
  var valid_580499 = query.getOrDefault("key")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "key", valid_580499
  var valid_580500 = query.getOrDefault("prettyPrint")
  valid_580500 = validateParameter(valid_580500, JBool, required = false,
                                 default = newJBool(true))
  if valid_580500 != nil:
    section.add "prettyPrint", valid_580500
  var valid_580501 = query.getOrDefault("oauth_token")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "oauth_token", valid_580501
  var valid_580502 = query.getOrDefault("alt")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = newJString("json"))
  if valid_580502 != nil:
    section.add "alt", valid_580502
  var valid_580503 = query.getOrDefault("userIp")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "userIp", valid_580503
  var valid_580504 = query.getOrDefault("quotaUser")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "quotaUser", valid_580504
  var valid_580505 = query.getOrDefault("fields")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "fields", valid_580505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580506: Call_CalendarCalendarListGet_580495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a calendar from the user's calendar list.
  ## 
  let valid = call_580506.validator(path, query, header, formData, body)
  let scheme = call_580506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580506.url(scheme.get, call_580506.host, call_580506.base,
                         call_580506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580506, url, valid)

proc call*(call_580507: Call_CalendarCalendarListGet_580495; calendarId: string;
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
  var path_580508 = newJObject()
  var query_580509 = newJObject()
  add(query_580509, "key", newJString(key))
  add(query_580509, "prettyPrint", newJBool(prettyPrint))
  add(query_580509, "oauth_token", newJString(oauthToken))
  add(path_580508, "calendarId", newJString(calendarId))
  add(query_580509, "alt", newJString(alt))
  add(query_580509, "userIp", newJString(userIp))
  add(query_580509, "quotaUser", newJString(quotaUser))
  add(query_580509, "fields", newJString(fields))
  result = call_580507.call(path_580508, query_580509, nil, nil, nil)

var calendarCalendarListGet* = Call_CalendarCalendarListGet_580495(
    name: "calendarCalendarListGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListGet_580496, base: "/calendar/v3",
    url: url_CalendarCalendarListGet_580497, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListPatch_580543 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarListPatch_580545(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarCalendarListPatch_580544(path: JsonNode; query: JsonNode;
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
  var valid_580546 = path.getOrDefault("calendarId")
  valid_580546 = validateParameter(valid_580546, JString, required = true,
                                 default = nil)
  if valid_580546 != nil:
    section.add "calendarId", valid_580546
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
  var valid_580547 = query.getOrDefault("key")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "key", valid_580547
  var valid_580548 = query.getOrDefault("prettyPrint")
  valid_580548 = validateParameter(valid_580548, JBool, required = false,
                                 default = newJBool(true))
  if valid_580548 != nil:
    section.add "prettyPrint", valid_580548
  var valid_580549 = query.getOrDefault("oauth_token")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "oauth_token", valid_580549
  var valid_580550 = query.getOrDefault("alt")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = newJString("json"))
  if valid_580550 != nil:
    section.add "alt", valid_580550
  var valid_580551 = query.getOrDefault("userIp")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "userIp", valid_580551
  var valid_580552 = query.getOrDefault("quotaUser")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "quotaUser", valid_580552
  var valid_580553 = query.getOrDefault("colorRgbFormat")
  valid_580553 = validateParameter(valid_580553, JBool, required = false, default = nil)
  if valid_580553 != nil:
    section.add "colorRgbFormat", valid_580553
  var valid_580554 = query.getOrDefault("fields")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "fields", valid_580554
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

proc call*(call_580556: Call_CalendarCalendarListPatch_580543; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing calendar on the user's calendar list. This method supports patch semantics.
  ## 
  let valid = call_580556.validator(path, query, header, formData, body)
  let scheme = call_580556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580556.url(scheme.get, call_580556.host, call_580556.base,
                         call_580556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580556, url, valid)

proc call*(call_580557: Call_CalendarCalendarListPatch_580543; calendarId: string;
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
  var path_580558 = newJObject()
  var query_580559 = newJObject()
  var body_580560 = newJObject()
  add(query_580559, "key", newJString(key))
  add(query_580559, "prettyPrint", newJBool(prettyPrint))
  add(query_580559, "oauth_token", newJString(oauthToken))
  add(path_580558, "calendarId", newJString(calendarId))
  add(query_580559, "alt", newJString(alt))
  add(query_580559, "userIp", newJString(userIp))
  add(query_580559, "quotaUser", newJString(quotaUser))
  add(query_580559, "colorRgbFormat", newJBool(colorRgbFormat))
  if body != nil:
    body_580560 = body
  add(query_580559, "fields", newJString(fields))
  result = call_580557.call(path_580558, query_580559, nil, nil, body_580560)

var calendarCalendarListPatch* = Call_CalendarCalendarListPatch_580543(
    name: "calendarCalendarListPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListPatch_580544, base: "/calendar/v3",
    url: url_CalendarCalendarListPatch_580545, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListDelete_580528 = ref object of OpenApiRestCall_579380
proc url_CalendarCalendarListDelete_580530(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarCalendarListDelete_580529(path: JsonNode; query: JsonNode;
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
  var valid_580531 = path.getOrDefault("calendarId")
  valid_580531 = validateParameter(valid_580531, JString, required = true,
                                 default = nil)
  if valid_580531 != nil:
    section.add "calendarId", valid_580531
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
  var valid_580532 = query.getOrDefault("key")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "key", valid_580532
  var valid_580533 = query.getOrDefault("prettyPrint")
  valid_580533 = validateParameter(valid_580533, JBool, required = false,
                                 default = newJBool(true))
  if valid_580533 != nil:
    section.add "prettyPrint", valid_580533
  var valid_580534 = query.getOrDefault("oauth_token")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "oauth_token", valid_580534
  var valid_580535 = query.getOrDefault("alt")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = newJString("json"))
  if valid_580535 != nil:
    section.add "alt", valid_580535
  var valid_580536 = query.getOrDefault("userIp")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "userIp", valid_580536
  var valid_580537 = query.getOrDefault("quotaUser")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "quotaUser", valid_580537
  var valid_580538 = query.getOrDefault("fields")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "fields", valid_580538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580539: Call_CalendarCalendarListDelete_580528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a calendar from the user's calendar list.
  ## 
  let valid = call_580539.validator(path, query, header, formData, body)
  let scheme = call_580539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580539.url(scheme.get, call_580539.host, call_580539.base,
                         call_580539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580539, url, valid)

proc call*(call_580540: Call_CalendarCalendarListDelete_580528; calendarId: string;
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
  var path_580541 = newJObject()
  var query_580542 = newJObject()
  add(query_580542, "key", newJString(key))
  add(query_580542, "prettyPrint", newJBool(prettyPrint))
  add(query_580542, "oauth_token", newJString(oauthToken))
  add(path_580541, "calendarId", newJString(calendarId))
  add(query_580542, "alt", newJString(alt))
  add(query_580542, "userIp", newJString(userIp))
  add(query_580542, "quotaUser", newJString(quotaUser))
  add(query_580542, "fields", newJString(fields))
  result = call_580540.call(path_580541, query_580542, nil, nil, nil)

var calendarCalendarListDelete* = Call_CalendarCalendarListDelete_580528(
    name: "calendarCalendarListDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListDelete_580529, base: "/calendar/v3",
    url: url_CalendarCalendarListDelete_580530, schemes: {Scheme.Https})
type
  Call_CalendarSettingsList_580561 = ref object of OpenApiRestCall_579380
proc url_CalendarSettingsList_580563(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarSettingsList_580562(path: JsonNode; query: JsonNode;
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
  var valid_580564 = query.getOrDefault("key")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "key", valid_580564
  var valid_580565 = query.getOrDefault("prettyPrint")
  valid_580565 = validateParameter(valid_580565, JBool, required = false,
                                 default = newJBool(true))
  if valid_580565 != nil:
    section.add "prettyPrint", valid_580565
  var valid_580566 = query.getOrDefault("oauth_token")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "oauth_token", valid_580566
  var valid_580567 = query.getOrDefault("alt")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = newJString("json"))
  if valid_580567 != nil:
    section.add "alt", valid_580567
  var valid_580568 = query.getOrDefault("userIp")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "userIp", valid_580568
  var valid_580569 = query.getOrDefault("quotaUser")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "quotaUser", valid_580569
  var valid_580570 = query.getOrDefault("pageToken")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "pageToken", valid_580570
  var valid_580571 = query.getOrDefault("fields")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "fields", valid_580571
  var valid_580572 = query.getOrDefault("syncToken")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "syncToken", valid_580572
  var valid_580573 = query.getOrDefault("maxResults")
  valid_580573 = validateParameter(valid_580573, JInt, required = false, default = nil)
  if valid_580573 != nil:
    section.add "maxResults", valid_580573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580574: Call_CalendarSettingsList_580561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all user settings for the authenticated user.
  ## 
  let valid = call_580574.validator(path, query, header, formData, body)
  let scheme = call_580574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580574.url(scheme.get, call_580574.host, call_580574.base,
                         call_580574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580574, url, valid)

proc call*(call_580575: Call_CalendarSettingsList_580561; key: string = "";
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
  var query_580576 = newJObject()
  add(query_580576, "key", newJString(key))
  add(query_580576, "prettyPrint", newJBool(prettyPrint))
  add(query_580576, "oauth_token", newJString(oauthToken))
  add(query_580576, "alt", newJString(alt))
  add(query_580576, "userIp", newJString(userIp))
  add(query_580576, "quotaUser", newJString(quotaUser))
  add(query_580576, "pageToken", newJString(pageToken))
  add(query_580576, "fields", newJString(fields))
  add(query_580576, "syncToken", newJString(syncToken))
  add(query_580576, "maxResults", newJInt(maxResults))
  result = call_580575.call(nil, query_580576, nil, nil, nil)

var calendarSettingsList* = Call_CalendarSettingsList_580561(
    name: "calendarSettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/settings",
    validator: validate_CalendarSettingsList_580562, base: "/calendar/v3",
    url: url_CalendarSettingsList_580563, schemes: {Scheme.Https})
type
  Call_CalendarSettingsWatch_580577 = ref object of OpenApiRestCall_579380
proc url_CalendarSettingsWatch_580579(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarSettingsWatch_580578(path: JsonNode; query: JsonNode;
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
  var valid_580580 = query.getOrDefault("key")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "key", valid_580580
  var valid_580581 = query.getOrDefault("prettyPrint")
  valid_580581 = validateParameter(valid_580581, JBool, required = false,
                                 default = newJBool(true))
  if valid_580581 != nil:
    section.add "prettyPrint", valid_580581
  var valid_580582 = query.getOrDefault("oauth_token")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "oauth_token", valid_580582
  var valid_580583 = query.getOrDefault("alt")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = newJString("json"))
  if valid_580583 != nil:
    section.add "alt", valid_580583
  var valid_580584 = query.getOrDefault("userIp")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "userIp", valid_580584
  var valid_580585 = query.getOrDefault("quotaUser")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "quotaUser", valid_580585
  var valid_580586 = query.getOrDefault("pageToken")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "pageToken", valid_580586
  var valid_580587 = query.getOrDefault("fields")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "fields", valid_580587
  var valid_580588 = query.getOrDefault("syncToken")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "syncToken", valid_580588
  var valid_580589 = query.getOrDefault("maxResults")
  valid_580589 = validateParameter(valid_580589, JInt, required = false, default = nil)
  if valid_580589 != nil:
    section.add "maxResults", valid_580589
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

proc call*(call_580591: Call_CalendarSettingsWatch_580577; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to Settings resources.
  ## 
  let valid = call_580591.validator(path, query, header, formData, body)
  let scheme = call_580591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580591.url(scheme.get, call_580591.host, call_580591.base,
                         call_580591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580591, url, valid)

proc call*(call_580592: Call_CalendarSettingsWatch_580577; key: string = "";
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
  var query_580593 = newJObject()
  var body_580594 = newJObject()
  add(query_580593, "key", newJString(key))
  add(query_580593, "prettyPrint", newJBool(prettyPrint))
  add(query_580593, "oauth_token", newJString(oauthToken))
  add(query_580593, "alt", newJString(alt))
  add(query_580593, "userIp", newJString(userIp))
  add(query_580593, "quotaUser", newJString(quotaUser))
  add(query_580593, "pageToken", newJString(pageToken))
  if resource != nil:
    body_580594 = resource
  add(query_580593, "fields", newJString(fields))
  add(query_580593, "syncToken", newJString(syncToken))
  add(query_580593, "maxResults", newJInt(maxResults))
  result = call_580592.call(nil, query_580593, nil, nil, body_580594)

var calendarSettingsWatch* = Call_CalendarSettingsWatch_580577(
    name: "calendarSettingsWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/settings/watch",
    validator: validate_CalendarSettingsWatch_580578, base: "/calendar/v3",
    url: url_CalendarSettingsWatch_580579, schemes: {Scheme.Https})
type
  Call_CalendarSettingsGet_580595 = ref object of OpenApiRestCall_579380
proc url_CalendarSettingsGet_580597(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CalendarSettingsGet_580596(path: JsonNode; query: JsonNode;
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
  var valid_580598 = path.getOrDefault("setting")
  valid_580598 = validateParameter(valid_580598, JString, required = true,
                                 default = nil)
  if valid_580598 != nil:
    section.add "setting", valid_580598
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
  var valid_580599 = query.getOrDefault("key")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "key", valid_580599
  var valid_580600 = query.getOrDefault("prettyPrint")
  valid_580600 = validateParameter(valid_580600, JBool, required = false,
                                 default = newJBool(true))
  if valid_580600 != nil:
    section.add "prettyPrint", valid_580600
  var valid_580601 = query.getOrDefault("oauth_token")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "oauth_token", valid_580601
  var valid_580602 = query.getOrDefault("alt")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = newJString("json"))
  if valid_580602 != nil:
    section.add "alt", valid_580602
  var valid_580603 = query.getOrDefault("userIp")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "userIp", valid_580603
  var valid_580604 = query.getOrDefault("quotaUser")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "quotaUser", valid_580604
  var valid_580605 = query.getOrDefault("fields")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "fields", valid_580605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580606: Call_CalendarSettingsGet_580595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single user setting.
  ## 
  let valid = call_580606.validator(path, query, header, formData, body)
  let scheme = call_580606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580606.url(scheme.get, call_580606.host, call_580606.base,
                         call_580606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580606, url, valid)

proc call*(call_580607: Call_CalendarSettingsGet_580595; setting: string;
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
  var path_580608 = newJObject()
  var query_580609 = newJObject()
  add(query_580609, "key", newJString(key))
  add(query_580609, "prettyPrint", newJBool(prettyPrint))
  add(query_580609, "oauth_token", newJString(oauthToken))
  add(query_580609, "alt", newJString(alt))
  add(query_580609, "userIp", newJString(userIp))
  add(query_580609, "quotaUser", newJString(quotaUser))
  add(path_580608, "setting", newJString(setting))
  add(query_580609, "fields", newJString(fields))
  result = call_580607.call(path_580608, query_580609, nil, nil, nil)

var calendarSettingsGet* = Call_CalendarSettingsGet_580595(
    name: "calendarSettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/settings/{setting}",
    validator: validate_CalendarSettingsGet_580596, base: "/calendar/v3",
    url: url_CalendarSettingsGet_580597, schemes: {Scheme.Https})
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
