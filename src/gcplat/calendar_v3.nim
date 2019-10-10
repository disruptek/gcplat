
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
  gcpServiceName = "calendar"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CalendarCalendarsInsert_588725 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarsInsert_588727(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarsInsert_588726(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a secondary calendar.
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
  var valid_588839 = query.getOrDefault("fields")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "fields", valid_588839
  var valid_588840 = query.getOrDefault("quotaUser")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "quotaUser", valid_588840
  var valid_588854 = query.getOrDefault("alt")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = newJString("json"))
  if valid_588854 != nil:
    section.add "alt", valid_588854
  var valid_588855 = query.getOrDefault("oauth_token")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "oauth_token", valid_588855
  var valid_588856 = query.getOrDefault("userIp")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "userIp", valid_588856
  var valid_588857 = query.getOrDefault("key")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "key", valid_588857
  var valid_588858 = query.getOrDefault("prettyPrint")
  valid_588858 = validateParameter(valid_588858, JBool, required = false,
                                 default = newJBool(true))
  if valid_588858 != nil:
    section.add "prettyPrint", valid_588858
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

proc call*(call_588882: Call_CalendarCalendarsInsert_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a secondary calendar.
  ## 
  let valid = call_588882.validator(path, query, header, formData, body)
  let scheme = call_588882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588882.url(scheme.get, call_588882.host, call_588882.base,
                         call_588882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588882, url, valid)

proc call*(call_588953: Call_CalendarCalendarsInsert_588725; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## calendarCalendarsInsert
  ## Creates a secondary calendar.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588954 = newJObject()
  var body_588956 = newJObject()
  add(query_588954, "fields", newJString(fields))
  add(query_588954, "quotaUser", newJString(quotaUser))
  add(query_588954, "alt", newJString(alt))
  add(query_588954, "oauth_token", newJString(oauthToken))
  add(query_588954, "userIp", newJString(userIp))
  add(query_588954, "key", newJString(key))
  if body != nil:
    body_588956 = body
  add(query_588954, "prettyPrint", newJBool(prettyPrint))
  result = call_588953.call(nil, query_588954, nil, nil, body_588956)

var calendarCalendarsInsert* = Call_CalendarCalendarsInsert_588725(
    name: "calendarCalendarsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars",
    validator: validate_CalendarCalendarsInsert_588726, base: "/calendar/v3",
    url: url_CalendarCalendarsInsert_588727, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsUpdate_589024 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarsUpdate_589026(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarsUpdate_589025(path: JsonNode; query: JsonNode;
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
  var valid_589027 = path.getOrDefault("calendarId")
  valid_589027 = validateParameter(valid_589027, JString, required = true,
                                 default = nil)
  if valid_589027 != nil:
    section.add "calendarId", valid_589027
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
  var valid_589028 = query.getOrDefault("fields")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "fields", valid_589028
  var valid_589029 = query.getOrDefault("quotaUser")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "quotaUser", valid_589029
  var valid_589030 = query.getOrDefault("alt")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = newJString("json"))
  if valid_589030 != nil:
    section.add "alt", valid_589030
  var valid_589031 = query.getOrDefault("oauth_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "oauth_token", valid_589031
  var valid_589032 = query.getOrDefault("userIp")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "userIp", valid_589032
  var valid_589033 = query.getOrDefault("key")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "key", valid_589033
  var valid_589034 = query.getOrDefault("prettyPrint")
  valid_589034 = validateParameter(valid_589034, JBool, required = false,
                                 default = newJBool(true))
  if valid_589034 != nil:
    section.add "prettyPrint", valid_589034
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

proc call*(call_589036: Call_CalendarCalendarsUpdate_589024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates metadata for a calendar.
  ## 
  let valid = call_589036.validator(path, query, header, formData, body)
  let scheme = call_589036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589036.url(scheme.get, call_589036.host, call_589036.base,
                         call_589036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589036, url, valid)

proc call*(call_589037: Call_CalendarCalendarsUpdate_589024; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## calendarCalendarsUpdate
  ## Updates metadata for a calendar.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589038 = newJObject()
  var query_589039 = newJObject()
  var body_589040 = newJObject()
  add(query_589039, "fields", newJString(fields))
  add(query_589039, "quotaUser", newJString(quotaUser))
  add(query_589039, "alt", newJString(alt))
  add(path_589038, "calendarId", newJString(calendarId))
  add(query_589039, "oauth_token", newJString(oauthToken))
  add(query_589039, "userIp", newJString(userIp))
  add(query_589039, "key", newJString(key))
  if body != nil:
    body_589040 = body
  add(query_589039, "prettyPrint", newJBool(prettyPrint))
  result = call_589037.call(path_589038, query_589039, nil, nil, body_589040)

var calendarCalendarsUpdate* = Call_CalendarCalendarsUpdate_589024(
    name: "calendarCalendarsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsUpdate_589025, base: "/calendar/v3",
    url: url_CalendarCalendarsUpdate_589026, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsGet_588995 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarsGet_588997(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarsGet_588996(path: JsonNode; query: JsonNode;
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
  var valid_589012 = path.getOrDefault("calendarId")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "calendarId", valid_589012
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
  var valid_589013 = query.getOrDefault("fields")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "fields", valid_589013
  var valid_589014 = query.getOrDefault("quotaUser")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "quotaUser", valid_589014
  var valid_589015 = query.getOrDefault("alt")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("json"))
  if valid_589015 != nil:
    section.add "alt", valid_589015
  var valid_589016 = query.getOrDefault("oauth_token")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "oauth_token", valid_589016
  var valid_589017 = query.getOrDefault("userIp")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "userIp", valid_589017
  var valid_589018 = query.getOrDefault("key")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "key", valid_589018
  var valid_589019 = query.getOrDefault("prettyPrint")
  valid_589019 = validateParameter(valid_589019, JBool, required = false,
                                 default = newJBool(true))
  if valid_589019 != nil:
    section.add "prettyPrint", valid_589019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589020: Call_CalendarCalendarsGet_588995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for a calendar.
  ## 
  let valid = call_589020.validator(path, query, header, formData, body)
  let scheme = call_589020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589020.url(scheme.get, call_589020.host, call_589020.base,
                         call_589020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589020, url, valid)

proc call*(call_589021: Call_CalendarCalendarsGet_588995; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## calendarCalendarsGet
  ## Returns metadata for a calendar.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589022 = newJObject()
  var query_589023 = newJObject()
  add(query_589023, "fields", newJString(fields))
  add(query_589023, "quotaUser", newJString(quotaUser))
  add(query_589023, "alt", newJString(alt))
  add(path_589022, "calendarId", newJString(calendarId))
  add(query_589023, "oauth_token", newJString(oauthToken))
  add(query_589023, "userIp", newJString(userIp))
  add(query_589023, "key", newJString(key))
  add(query_589023, "prettyPrint", newJBool(prettyPrint))
  result = call_589021.call(path_589022, query_589023, nil, nil, nil)

var calendarCalendarsGet* = Call_CalendarCalendarsGet_588995(
    name: "calendarCalendarsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsGet_588996, base: "/calendar/v3",
    url: url_CalendarCalendarsGet_588997, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsPatch_589056 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarsPatch_589058(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarsPatch_589057(path: JsonNode; query: JsonNode;
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
  var valid_589059 = path.getOrDefault("calendarId")
  valid_589059 = validateParameter(valid_589059, JString, required = true,
                                 default = nil)
  if valid_589059 != nil:
    section.add "calendarId", valid_589059
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
  var valid_589060 = query.getOrDefault("fields")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "fields", valid_589060
  var valid_589061 = query.getOrDefault("quotaUser")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "quotaUser", valid_589061
  var valid_589062 = query.getOrDefault("alt")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = newJString("json"))
  if valid_589062 != nil:
    section.add "alt", valid_589062
  var valid_589063 = query.getOrDefault("oauth_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "oauth_token", valid_589063
  var valid_589064 = query.getOrDefault("userIp")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "userIp", valid_589064
  var valid_589065 = query.getOrDefault("key")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "key", valid_589065
  var valid_589066 = query.getOrDefault("prettyPrint")
  valid_589066 = validateParameter(valid_589066, JBool, required = false,
                                 default = newJBool(true))
  if valid_589066 != nil:
    section.add "prettyPrint", valid_589066
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

proc call*(call_589068: Call_CalendarCalendarsPatch_589056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates metadata for a calendar. This method supports patch semantics.
  ## 
  let valid = call_589068.validator(path, query, header, formData, body)
  let scheme = call_589068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589068.url(scheme.get, call_589068.host, call_589068.base,
                         call_589068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589068, url, valid)

proc call*(call_589069: Call_CalendarCalendarsPatch_589056; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## calendarCalendarsPatch
  ## Updates metadata for a calendar. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589070 = newJObject()
  var query_589071 = newJObject()
  var body_589072 = newJObject()
  add(query_589071, "fields", newJString(fields))
  add(query_589071, "quotaUser", newJString(quotaUser))
  add(query_589071, "alt", newJString(alt))
  add(path_589070, "calendarId", newJString(calendarId))
  add(query_589071, "oauth_token", newJString(oauthToken))
  add(query_589071, "userIp", newJString(userIp))
  add(query_589071, "key", newJString(key))
  if body != nil:
    body_589072 = body
  add(query_589071, "prettyPrint", newJBool(prettyPrint))
  result = call_589069.call(path_589070, query_589071, nil, nil, body_589072)

var calendarCalendarsPatch* = Call_CalendarCalendarsPatch_589056(
    name: "calendarCalendarsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsPatch_589057, base: "/calendar/v3",
    url: url_CalendarCalendarsPatch_589058, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsDelete_589041 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarsDelete_589043(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarsDelete_589042(path: JsonNode; query: JsonNode;
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
  var valid_589044 = path.getOrDefault("calendarId")
  valid_589044 = validateParameter(valid_589044, JString, required = true,
                                 default = nil)
  if valid_589044 != nil:
    section.add "calendarId", valid_589044
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
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("userIp")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "userIp", valid_589049
  var valid_589050 = query.getOrDefault("key")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "key", valid_589050
  var valid_589051 = query.getOrDefault("prettyPrint")
  valid_589051 = validateParameter(valid_589051, JBool, required = false,
                                 default = newJBool(true))
  if valid_589051 != nil:
    section.add "prettyPrint", valid_589051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589052: Call_CalendarCalendarsDelete_589041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
  ## 
  let valid = call_589052.validator(path, query, header, formData, body)
  let scheme = call_589052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589052.url(scheme.get, call_589052.host, call_589052.base,
                         call_589052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589052, url, valid)

proc call*(call_589053: Call_CalendarCalendarsDelete_589041; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## calendarCalendarsDelete
  ## Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589054 = newJObject()
  var query_589055 = newJObject()
  add(query_589055, "fields", newJString(fields))
  add(query_589055, "quotaUser", newJString(quotaUser))
  add(query_589055, "alt", newJString(alt))
  add(path_589054, "calendarId", newJString(calendarId))
  add(query_589055, "oauth_token", newJString(oauthToken))
  add(query_589055, "userIp", newJString(userIp))
  add(query_589055, "key", newJString(key))
  add(query_589055, "prettyPrint", newJBool(prettyPrint))
  result = call_589053.call(path_589054, query_589055, nil, nil, nil)

var calendarCalendarsDelete* = Call_CalendarCalendarsDelete_589041(
    name: "calendarCalendarsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsDelete_589042, base: "/calendar/v3",
    url: url_CalendarCalendarsDelete_589043, schemes: {Scheme.Https})
type
  Call_CalendarAclInsert_589092 = ref object of OpenApiRestCall_588457
proc url_CalendarAclInsert_589094(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclInsert_589093(path: JsonNode; query: JsonNode;
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
  var valid_589095 = path.getOrDefault("calendarId")
  valid_589095 = validateParameter(valid_589095, JString, required = true,
                                 default = nil)
  if valid_589095 != nil:
    section.add "calendarId", valid_589095
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sendNotifications: JBool
  ##                    : Whether to send notifications about the calendar sharing change. Optional. The default is True.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589096 = query.getOrDefault("fields")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "fields", valid_589096
  var valid_589097 = query.getOrDefault("quotaUser")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "quotaUser", valid_589097
  var valid_589098 = query.getOrDefault("alt")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("json"))
  if valid_589098 != nil:
    section.add "alt", valid_589098
  var valid_589099 = query.getOrDefault("sendNotifications")
  valid_589099 = validateParameter(valid_589099, JBool, required = false, default = nil)
  if valid_589099 != nil:
    section.add "sendNotifications", valid_589099
  var valid_589100 = query.getOrDefault("oauth_token")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "oauth_token", valid_589100
  var valid_589101 = query.getOrDefault("userIp")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "userIp", valid_589101
  var valid_589102 = query.getOrDefault("key")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "key", valid_589102
  var valid_589103 = query.getOrDefault("prettyPrint")
  valid_589103 = validateParameter(valid_589103, JBool, required = false,
                                 default = newJBool(true))
  if valid_589103 != nil:
    section.add "prettyPrint", valid_589103
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

proc call*(call_589105: Call_CalendarAclInsert_589092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an access control rule.
  ## 
  let valid = call_589105.validator(path, query, header, formData, body)
  let scheme = call_589105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589105.url(scheme.get, call_589105.host, call_589105.base,
                         call_589105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589105, url, valid)

proc call*(call_589106: Call_CalendarAclInsert_589092; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          sendNotifications: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## calendarAclInsert
  ## Creates an access control rule.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   sendNotifications: bool
  ##                    : Whether to send notifications about the calendar sharing change. Optional. The default is True.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589107 = newJObject()
  var query_589108 = newJObject()
  var body_589109 = newJObject()
  add(query_589108, "fields", newJString(fields))
  add(query_589108, "quotaUser", newJString(quotaUser))
  add(query_589108, "alt", newJString(alt))
  add(path_589107, "calendarId", newJString(calendarId))
  add(query_589108, "sendNotifications", newJBool(sendNotifications))
  add(query_589108, "oauth_token", newJString(oauthToken))
  add(query_589108, "userIp", newJString(userIp))
  add(query_589108, "key", newJString(key))
  if body != nil:
    body_589109 = body
  add(query_589108, "prettyPrint", newJBool(prettyPrint))
  result = call_589106.call(path_589107, query_589108, nil, nil, body_589109)

var calendarAclInsert* = Call_CalendarAclInsert_589092(name: "calendarAclInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl", validator: validate_CalendarAclInsert_589093,
    base: "/calendar/v3", url: url_CalendarAclInsert_589094, schemes: {Scheme.Https})
type
  Call_CalendarAclList_589073 = ref object of OpenApiRestCall_588457
proc url_CalendarAclList_589075(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclList_589074(path: JsonNode; query: JsonNode;
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
  var valid_589076 = path.getOrDefault("calendarId")
  valid_589076 = validateParameter(valid_589076, JString, required = true,
                                 default = nil)
  if valid_589076 != nil:
    section.add "calendarId", valid_589076
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   showDeleted: JBool
  ##              : Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589077 = query.getOrDefault("fields")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "fields", valid_589077
  var valid_589078 = query.getOrDefault("pageToken")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "pageToken", valid_589078
  var valid_589079 = query.getOrDefault("quotaUser")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "quotaUser", valid_589079
  var valid_589080 = query.getOrDefault("alt")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = newJString("json"))
  if valid_589080 != nil:
    section.add "alt", valid_589080
  var valid_589081 = query.getOrDefault("oauth_token")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "oauth_token", valid_589081
  var valid_589082 = query.getOrDefault("syncToken")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "syncToken", valid_589082
  var valid_589083 = query.getOrDefault("userIp")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "userIp", valid_589083
  var valid_589084 = query.getOrDefault("maxResults")
  valid_589084 = validateParameter(valid_589084, JInt, required = false, default = nil)
  if valid_589084 != nil:
    section.add "maxResults", valid_589084
  var valid_589085 = query.getOrDefault("showDeleted")
  valid_589085 = validateParameter(valid_589085, JBool, required = false, default = nil)
  if valid_589085 != nil:
    section.add "showDeleted", valid_589085
  var valid_589086 = query.getOrDefault("key")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "key", valid_589086
  var valid_589087 = query.getOrDefault("prettyPrint")
  valid_589087 = validateParameter(valid_589087, JBool, required = false,
                                 default = newJBool(true))
  if valid_589087 != nil:
    section.add "prettyPrint", valid_589087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589088: Call_CalendarAclList_589073; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the rules in the access control list for the calendar.
  ## 
  let valid = call_589088.validator(path, query, header, formData, body)
  let scheme = call_589088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589088.url(scheme.get, call_589088.host, call_589088.base,
                         call_589088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589088, url, valid)

proc call*(call_589089: Call_CalendarAclList_589073; calendarId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; syncToken: string = "";
          userIp: string = ""; maxResults: int = 0; showDeleted: bool = false;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## calendarAclList
  ## Returns the rules in the access control list for the calendar.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   showDeleted: bool
  ##              : Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589090 = newJObject()
  var query_589091 = newJObject()
  add(query_589091, "fields", newJString(fields))
  add(query_589091, "pageToken", newJString(pageToken))
  add(query_589091, "quotaUser", newJString(quotaUser))
  add(query_589091, "alt", newJString(alt))
  add(path_589090, "calendarId", newJString(calendarId))
  add(query_589091, "oauth_token", newJString(oauthToken))
  add(query_589091, "syncToken", newJString(syncToken))
  add(query_589091, "userIp", newJString(userIp))
  add(query_589091, "maxResults", newJInt(maxResults))
  add(query_589091, "showDeleted", newJBool(showDeleted))
  add(query_589091, "key", newJString(key))
  add(query_589091, "prettyPrint", newJBool(prettyPrint))
  result = call_589089.call(path_589090, query_589091, nil, nil, nil)

var calendarAclList* = Call_CalendarAclList_589073(name: "calendarAclList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl", validator: validate_CalendarAclList_589074,
    base: "/calendar/v3", url: url_CalendarAclList_589075, schemes: {Scheme.Https})
type
  Call_CalendarAclWatch_589110 = ref object of OpenApiRestCall_588457
proc url_CalendarAclWatch_589112(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclWatch_589111(path: JsonNode; query: JsonNode;
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
  var valid_589113 = path.getOrDefault("calendarId")
  valid_589113 = validateParameter(valid_589113, JString, required = true,
                                 default = nil)
  if valid_589113 != nil:
    section.add "calendarId", valid_589113
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   showDeleted: JBool
  ##              : Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589114 = query.getOrDefault("fields")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "fields", valid_589114
  var valid_589115 = query.getOrDefault("pageToken")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "pageToken", valid_589115
  var valid_589116 = query.getOrDefault("quotaUser")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "quotaUser", valid_589116
  var valid_589117 = query.getOrDefault("alt")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = newJString("json"))
  if valid_589117 != nil:
    section.add "alt", valid_589117
  var valid_589118 = query.getOrDefault("oauth_token")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "oauth_token", valid_589118
  var valid_589119 = query.getOrDefault("syncToken")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "syncToken", valid_589119
  var valid_589120 = query.getOrDefault("userIp")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "userIp", valid_589120
  var valid_589121 = query.getOrDefault("maxResults")
  valid_589121 = validateParameter(valid_589121, JInt, required = false, default = nil)
  if valid_589121 != nil:
    section.add "maxResults", valid_589121
  var valid_589122 = query.getOrDefault("showDeleted")
  valid_589122 = validateParameter(valid_589122, JBool, required = false, default = nil)
  if valid_589122 != nil:
    section.add "showDeleted", valid_589122
  var valid_589123 = query.getOrDefault("key")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "key", valid_589123
  var valid_589124 = query.getOrDefault("prettyPrint")
  valid_589124 = validateParameter(valid_589124, JBool, required = false,
                                 default = newJBool(true))
  if valid_589124 != nil:
    section.add "prettyPrint", valid_589124
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

proc call*(call_589126: Call_CalendarAclWatch_589110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to ACL resources.
  ## 
  let valid = call_589126.validator(path, query, header, formData, body)
  let scheme = call_589126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589126.url(scheme.get, call_589126.host, call_589126.base,
                         call_589126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589126, url, valid)

proc call*(call_589127: Call_CalendarAclWatch_589110; calendarId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; syncToken: string = "";
          userIp: string = ""; maxResults: int = 0; showDeleted: bool = false;
          key: string = ""; resource: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## calendarAclWatch
  ## Watch for changes to ACL resources.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. All entries deleted since the previous list request will always be in the result set and it is not allowed to set showDeleted to False.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   showDeleted: bool
  ##              : Whether to include deleted ACLs in the result. Deleted ACLs are represented by role equal to "none". Deleted ACLs will always be included if syncToken is provided. Optional. The default is False.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589128 = newJObject()
  var query_589129 = newJObject()
  var body_589130 = newJObject()
  add(query_589129, "fields", newJString(fields))
  add(query_589129, "pageToken", newJString(pageToken))
  add(query_589129, "quotaUser", newJString(quotaUser))
  add(query_589129, "alt", newJString(alt))
  add(path_589128, "calendarId", newJString(calendarId))
  add(query_589129, "oauth_token", newJString(oauthToken))
  add(query_589129, "syncToken", newJString(syncToken))
  add(query_589129, "userIp", newJString(userIp))
  add(query_589129, "maxResults", newJInt(maxResults))
  add(query_589129, "showDeleted", newJBool(showDeleted))
  add(query_589129, "key", newJString(key))
  if resource != nil:
    body_589130 = resource
  add(query_589129, "prettyPrint", newJBool(prettyPrint))
  result = call_589127.call(path_589128, query_589129, nil, nil, body_589130)

var calendarAclWatch* = Call_CalendarAclWatch_589110(name: "calendarAclWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/watch",
    validator: validate_CalendarAclWatch_589111, base: "/calendar/v3",
    url: url_CalendarAclWatch_589112, schemes: {Scheme.Https})
type
  Call_CalendarAclUpdate_589147 = ref object of OpenApiRestCall_588457
proc url_CalendarAclUpdate_589149(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclUpdate_589148(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates an access control rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   ruleId: JString (required)
  ##         : ACL rule identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_589150 = path.getOrDefault("calendarId")
  valid_589150 = validateParameter(valid_589150, JString, required = true,
                                 default = nil)
  if valid_589150 != nil:
    section.add "calendarId", valid_589150
  var valid_589151 = path.getOrDefault("ruleId")
  valid_589151 = validateParameter(valid_589151, JString, required = true,
                                 default = nil)
  if valid_589151 != nil:
    section.add "ruleId", valid_589151
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sendNotifications: JBool
  ##                    : Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589152 = query.getOrDefault("fields")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "fields", valid_589152
  var valid_589153 = query.getOrDefault("quotaUser")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "quotaUser", valid_589153
  var valid_589154 = query.getOrDefault("alt")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = newJString("json"))
  if valid_589154 != nil:
    section.add "alt", valid_589154
  var valid_589155 = query.getOrDefault("sendNotifications")
  valid_589155 = validateParameter(valid_589155, JBool, required = false, default = nil)
  if valid_589155 != nil:
    section.add "sendNotifications", valid_589155
  var valid_589156 = query.getOrDefault("oauth_token")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "oauth_token", valid_589156
  var valid_589157 = query.getOrDefault("userIp")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "userIp", valid_589157
  var valid_589158 = query.getOrDefault("key")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "key", valid_589158
  var valid_589159 = query.getOrDefault("prettyPrint")
  valid_589159 = validateParameter(valid_589159, JBool, required = false,
                                 default = newJBool(true))
  if valid_589159 != nil:
    section.add "prettyPrint", valid_589159
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

proc call*(call_589161: Call_CalendarAclUpdate_589147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an access control rule.
  ## 
  let valid = call_589161.validator(path, query, header, formData, body)
  let scheme = call_589161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589161.url(scheme.get, call_589161.host, call_589161.base,
                         call_589161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589161, url, valid)

proc call*(call_589162: Call_CalendarAclUpdate_589147; calendarId: string;
          ruleId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; sendNotifications: bool = false;
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## calendarAclUpdate
  ## Updates an access control rule.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   sendNotifications: bool
  ##                    : Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ruleId: string (required)
  ##         : ACL rule identifier.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589163 = newJObject()
  var query_589164 = newJObject()
  var body_589165 = newJObject()
  add(query_589164, "fields", newJString(fields))
  add(query_589164, "quotaUser", newJString(quotaUser))
  add(query_589164, "alt", newJString(alt))
  add(path_589163, "calendarId", newJString(calendarId))
  add(query_589164, "sendNotifications", newJBool(sendNotifications))
  add(query_589164, "oauth_token", newJString(oauthToken))
  add(query_589164, "userIp", newJString(userIp))
  add(query_589164, "key", newJString(key))
  add(path_589163, "ruleId", newJString(ruleId))
  if body != nil:
    body_589165 = body
  add(query_589164, "prettyPrint", newJBool(prettyPrint))
  result = call_589162.call(path_589163, query_589164, nil, nil, body_589165)

var calendarAclUpdate* = Call_CalendarAclUpdate_589147(name: "calendarAclUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclUpdate_589148, base: "/calendar/v3",
    url: url_CalendarAclUpdate_589149, schemes: {Scheme.Https})
type
  Call_CalendarAclGet_589131 = ref object of OpenApiRestCall_588457
proc url_CalendarAclGet_589133(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclGet_589132(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns an access control rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   ruleId: JString (required)
  ##         : ACL rule identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_589134 = path.getOrDefault("calendarId")
  valid_589134 = validateParameter(valid_589134, JString, required = true,
                                 default = nil)
  if valid_589134 != nil:
    section.add "calendarId", valid_589134
  var valid_589135 = path.getOrDefault("ruleId")
  valid_589135 = validateParameter(valid_589135, JString, required = true,
                                 default = nil)
  if valid_589135 != nil:
    section.add "ruleId", valid_589135
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
  var valid_589136 = query.getOrDefault("fields")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "fields", valid_589136
  var valid_589137 = query.getOrDefault("quotaUser")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "quotaUser", valid_589137
  var valid_589138 = query.getOrDefault("alt")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = newJString("json"))
  if valid_589138 != nil:
    section.add "alt", valid_589138
  var valid_589139 = query.getOrDefault("oauth_token")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "oauth_token", valid_589139
  var valid_589140 = query.getOrDefault("userIp")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "userIp", valid_589140
  var valid_589141 = query.getOrDefault("key")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "key", valid_589141
  var valid_589142 = query.getOrDefault("prettyPrint")
  valid_589142 = validateParameter(valid_589142, JBool, required = false,
                                 default = newJBool(true))
  if valid_589142 != nil:
    section.add "prettyPrint", valid_589142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589143: Call_CalendarAclGet_589131; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an access control rule.
  ## 
  let valid = call_589143.validator(path, query, header, formData, body)
  let scheme = call_589143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589143.url(scheme.get, call_589143.host, call_589143.base,
                         call_589143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589143, url, valid)

proc call*(call_589144: Call_CalendarAclGet_589131; calendarId: string;
          ruleId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## calendarAclGet
  ## Returns an access control rule.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ruleId: string (required)
  ##         : ACL rule identifier.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589145 = newJObject()
  var query_589146 = newJObject()
  add(query_589146, "fields", newJString(fields))
  add(query_589146, "quotaUser", newJString(quotaUser))
  add(query_589146, "alt", newJString(alt))
  add(path_589145, "calendarId", newJString(calendarId))
  add(query_589146, "oauth_token", newJString(oauthToken))
  add(query_589146, "userIp", newJString(userIp))
  add(query_589146, "key", newJString(key))
  add(path_589145, "ruleId", newJString(ruleId))
  add(query_589146, "prettyPrint", newJBool(prettyPrint))
  result = call_589144.call(path_589145, query_589146, nil, nil, nil)

var calendarAclGet* = Call_CalendarAclGet_589131(name: "calendarAclGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclGet_589132, base: "/calendar/v3",
    url: url_CalendarAclGet_589133, schemes: {Scheme.Https})
type
  Call_CalendarAclPatch_589182 = ref object of OpenApiRestCall_588457
proc url_CalendarAclPatch_589184(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclPatch_589183(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates an access control rule. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   ruleId: JString (required)
  ##         : ACL rule identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_589185 = path.getOrDefault("calendarId")
  valid_589185 = validateParameter(valid_589185, JString, required = true,
                                 default = nil)
  if valid_589185 != nil:
    section.add "calendarId", valid_589185
  var valid_589186 = path.getOrDefault("ruleId")
  valid_589186 = validateParameter(valid_589186, JString, required = true,
                                 default = nil)
  if valid_589186 != nil:
    section.add "ruleId", valid_589186
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sendNotifications: JBool
  ##                    : Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589187 = query.getOrDefault("fields")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "fields", valid_589187
  var valid_589188 = query.getOrDefault("quotaUser")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "quotaUser", valid_589188
  var valid_589189 = query.getOrDefault("alt")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = newJString("json"))
  if valid_589189 != nil:
    section.add "alt", valid_589189
  var valid_589190 = query.getOrDefault("sendNotifications")
  valid_589190 = validateParameter(valid_589190, JBool, required = false, default = nil)
  if valid_589190 != nil:
    section.add "sendNotifications", valid_589190
  var valid_589191 = query.getOrDefault("oauth_token")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "oauth_token", valid_589191
  var valid_589192 = query.getOrDefault("userIp")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "userIp", valid_589192
  var valid_589193 = query.getOrDefault("key")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "key", valid_589193
  var valid_589194 = query.getOrDefault("prettyPrint")
  valid_589194 = validateParameter(valid_589194, JBool, required = false,
                                 default = newJBool(true))
  if valid_589194 != nil:
    section.add "prettyPrint", valid_589194
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

proc call*(call_589196: Call_CalendarAclPatch_589182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an access control rule. This method supports patch semantics.
  ## 
  let valid = call_589196.validator(path, query, header, formData, body)
  let scheme = call_589196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589196.url(scheme.get, call_589196.host, call_589196.base,
                         call_589196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589196, url, valid)

proc call*(call_589197: Call_CalendarAclPatch_589182; calendarId: string;
          ruleId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; sendNotifications: bool = false;
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## calendarAclPatch
  ## Updates an access control rule. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   sendNotifications: bool
  ##                    : Whether to send notifications about the calendar sharing change. Note that there are no notifications on access removal. Optional. The default is True.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ruleId: string (required)
  ##         : ACL rule identifier.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589198 = newJObject()
  var query_589199 = newJObject()
  var body_589200 = newJObject()
  add(query_589199, "fields", newJString(fields))
  add(query_589199, "quotaUser", newJString(quotaUser))
  add(query_589199, "alt", newJString(alt))
  add(path_589198, "calendarId", newJString(calendarId))
  add(query_589199, "sendNotifications", newJBool(sendNotifications))
  add(query_589199, "oauth_token", newJString(oauthToken))
  add(query_589199, "userIp", newJString(userIp))
  add(query_589199, "key", newJString(key))
  add(path_589198, "ruleId", newJString(ruleId))
  if body != nil:
    body_589200 = body
  add(query_589199, "prettyPrint", newJBool(prettyPrint))
  result = call_589197.call(path_589198, query_589199, nil, nil, body_589200)

var calendarAclPatch* = Call_CalendarAclPatch_589182(name: "calendarAclPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclPatch_589183, base: "/calendar/v3",
    url: url_CalendarAclPatch_589184, schemes: {Scheme.Https})
type
  Call_CalendarAclDelete_589166 = ref object of OpenApiRestCall_588457
proc url_CalendarAclDelete_589168(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclDelete_589167(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an access control rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarId: JString (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   ruleId: JString (required)
  ##         : ACL rule identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarId` field"
  var valid_589169 = path.getOrDefault("calendarId")
  valid_589169 = validateParameter(valid_589169, JString, required = true,
                                 default = nil)
  if valid_589169 != nil:
    section.add "calendarId", valid_589169
  var valid_589170 = path.getOrDefault("ruleId")
  valid_589170 = validateParameter(valid_589170, JString, required = true,
                                 default = nil)
  if valid_589170 != nil:
    section.add "ruleId", valid_589170
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
  var valid_589171 = query.getOrDefault("fields")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "fields", valid_589171
  var valid_589172 = query.getOrDefault("quotaUser")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "quotaUser", valid_589172
  var valid_589173 = query.getOrDefault("alt")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = newJString("json"))
  if valid_589173 != nil:
    section.add "alt", valid_589173
  var valid_589174 = query.getOrDefault("oauth_token")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "oauth_token", valid_589174
  var valid_589175 = query.getOrDefault("userIp")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "userIp", valid_589175
  var valid_589176 = query.getOrDefault("key")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "key", valid_589176
  var valid_589177 = query.getOrDefault("prettyPrint")
  valid_589177 = validateParameter(valid_589177, JBool, required = false,
                                 default = newJBool(true))
  if valid_589177 != nil:
    section.add "prettyPrint", valid_589177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589178: Call_CalendarAclDelete_589166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an access control rule.
  ## 
  let valid = call_589178.validator(path, query, header, formData, body)
  let scheme = call_589178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589178.url(scheme.get, call_589178.host, call_589178.base,
                         call_589178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589178, url, valid)

proc call*(call_589179: Call_CalendarAclDelete_589166; calendarId: string;
          ruleId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## calendarAclDelete
  ## Deletes an access control rule.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ruleId: string (required)
  ##         : ACL rule identifier.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589180 = newJObject()
  var query_589181 = newJObject()
  add(query_589181, "fields", newJString(fields))
  add(query_589181, "quotaUser", newJString(quotaUser))
  add(query_589181, "alt", newJString(alt))
  add(path_589180, "calendarId", newJString(calendarId))
  add(query_589181, "oauth_token", newJString(oauthToken))
  add(query_589181, "userIp", newJString(userIp))
  add(query_589181, "key", newJString(key))
  add(path_589180, "ruleId", newJString(ruleId))
  add(query_589181, "prettyPrint", newJBool(prettyPrint))
  result = call_589179.call(path_589180, query_589181, nil, nil, nil)

var calendarAclDelete* = Call_CalendarAclDelete_589166(name: "calendarAclDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclDelete_589167, base: "/calendar/v3",
    url: url_CalendarAclDelete_589168, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsClear_589201 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarsClear_589203(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarsClear_589202(path: JsonNode; query: JsonNode;
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
  var valid_589204 = path.getOrDefault("calendarId")
  valid_589204 = validateParameter(valid_589204, JString, required = true,
                                 default = nil)
  if valid_589204 != nil:
    section.add "calendarId", valid_589204
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
  var valid_589205 = query.getOrDefault("fields")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "fields", valid_589205
  var valid_589206 = query.getOrDefault("quotaUser")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "quotaUser", valid_589206
  var valid_589207 = query.getOrDefault("alt")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = newJString("json"))
  if valid_589207 != nil:
    section.add "alt", valid_589207
  var valid_589208 = query.getOrDefault("oauth_token")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "oauth_token", valid_589208
  var valid_589209 = query.getOrDefault("userIp")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "userIp", valid_589209
  var valid_589210 = query.getOrDefault("key")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "key", valid_589210
  var valid_589211 = query.getOrDefault("prettyPrint")
  valid_589211 = validateParameter(valid_589211, JBool, required = false,
                                 default = newJBool(true))
  if valid_589211 != nil:
    section.add "prettyPrint", valid_589211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589212: Call_CalendarCalendarsClear_589201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
  ## 
  let valid = call_589212.validator(path, query, header, formData, body)
  let scheme = call_589212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589212.url(scheme.get, call_589212.host, call_589212.base,
                         call_589212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589212, url, valid)

proc call*(call_589213: Call_CalendarCalendarsClear_589201; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## calendarCalendarsClear
  ## Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589214 = newJObject()
  var query_589215 = newJObject()
  add(query_589215, "fields", newJString(fields))
  add(query_589215, "quotaUser", newJString(quotaUser))
  add(query_589215, "alt", newJString(alt))
  add(path_589214, "calendarId", newJString(calendarId))
  add(query_589215, "oauth_token", newJString(oauthToken))
  add(query_589215, "userIp", newJString(userIp))
  add(query_589215, "key", newJString(key))
  add(query_589215, "prettyPrint", newJBool(prettyPrint))
  result = call_589213.call(path_589214, query_589215, nil, nil, nil)

var calendarCalendarsClear* = Call_CalendarCalendarsClear_589201(
    name: "calendarCalendarsClear", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/clear",
    validator: validate_CalendarCalendarsClear_589202, base: "/calendar/v3",
    url: url_CalendarCalendarsClear_589203, schemes: {Scheme.Https})
type
  Call_CalendarEventsInsert_589249 = ref object of OpenApiRestCall_588457
proc url_CalendarEventsInsert_589251(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsInsert_589250(path: JsonNode; query: JsonNode;
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
  var valid_589252 = path.getOrDefault("calendarId")
  valid_589252 = validateParameter(valid_589252, JString, required = true,
                                 default = nil)
  if valid_589252 != nil:
    section.add "calendarId", valid_589252
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   supportsAttachments: JBool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the creation of the new event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   conferenceDataVersion: JInt
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: JString
  ##              : Whether to send notifications about the creation of the new event. Note that some emails might still be sent. The default is false.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589253 = query.getOrDefault("fields")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "fields", valid_589253
  var valid_589254 = query.getOrDefault("quotaUser")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "quotaUser", valid_589254
  var valid_589255 = query.getOrDefault("alt")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = newJString("json"))
  if valid_589255 != nil:
    section.add "alt", valid_589255
  var valid_589256 = query.getOrDefault("supportsAttachments")
  valid_589256 = validateParameter(valid_589256, JBool, required = false, default = nil)
  if valid_589256 != nil:
    section.add "supportsAttachments", valid_589256
  var valid_589257 = query.getOrDefault("maxAttendees")
  valid_589257 = validateParameter(valid_589257, JInt, required = false, default = nil)
  if valid_589257 != nil:
    section.add "maxAttendees", valid_589257
  var valid_589258 = query.getOrDefault("sendNotifications")
  valid_589258 = validateParameter(valid_589258, JBool, required = false, default = nil)
  if valid_589258 != nil:
    section.add "sendNotifications", valid_589258
  var valid_589259 = query.getOrDefault("oauth_token")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "oauth_token", valid_589259
  var valid_589260 = query.getOrDefault("conferenceDataVersion")
  valid_589260 = validateParameter(valid_589260, JInt, required = false, default = nil)
  if valid_589260 != nil:
    section.add "conferenceDataVersion", valid_589260
  var valid_589261 = query.getOrDefault("userIp")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "userIp", valid_589261
  var valid_589262 = query.getOrDefault("sendUpdates")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = newJString("all"))
  if valid_589262 != nil:
    section.add "sendUpdates", valid_589262
  var valid_589263 = query.getOrDefault("key")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "key", valid_589263
  var valid_589264 = query.getOrDefault("prettyPrint")
  valid_589264 = validateParameter(valid_589264, JBool, required = false,
                                 default = newJBool(true))
  if valid_589264 != nil:
    section.add "prettyPrint", valid_589264
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

proc call*(call_589266: Call_CalendarEventsInsert_589249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an event.
  ## 
  let valid = call_589266.validator(path, query, header, formData, body)
  let scheme = call_589266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589266.url(scheme.get, call_589266.host, call_589266.base,
                         call_589266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589266, url, valid)

proc call*(call_589267: Call_CalendarEventsInsert_589249; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          supportsAttachments: bool = false; maxAttendees: int = 0;
          sendNotifications: bool = false; oauthToken: string = "";
          conferenceDataVersion: int = 0; userIp: string = "";
          sendUpdates: string = "all"; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## calendarEventsInsert
  ## Creates an event.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   supportsAttachments: bool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the creation of the new event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   conferenceDataVersion: int
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: string
  ##              : Whether to send notifications about the creation of the new event. Note that some emails might still be sent. The default is false.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589268 = newJObject()
  var query_589269 = newJObject()
  var body_589270 = newJObject()
  add(query_589269, "fields", newJString(fields))
  add(query_589269, "quotaUser", newJString(quotaUser))
  add(query_589269, "alt", newJString(alt))
  add(query_589269, "supportsAttachments", newJBool(supportsAttachments))
  add(query_589269, "maxAttendees", newJInt(maxAttendees))
  add(path_589268, "calendarId", newJString(calendarId))
  add(query_589269, "sendNotifications", newJBool(sendNotifications))
  add(query_589269, "oauth_token", newJString(oauthToken))
  add(query_589269, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_589269, "userIp", newJString(userIp))
  add(query_589269, "sendUpdates", newJString(sendUpdates))
  add(query_589269, "key", newJString(key))
  if body != nil:
    body_589270 = body
  add(query_589269, "prettyPrint", newJBool(prettyPrint))
  result = call_589267.call(path_589268, query_589269, nil, nil, body_589270)

var calendarEventsInsert* = Call_CalendarEventsInsert_589249(
    name: "calendarEventsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events",
    validator: validate_CalendarEventsInsert_589250, base: "/calendar/v3",
    url: url_CalendarEventsInsert_589251, schemes: {Scheme.Https})
type
  Call_CalendarEventsList_589216 = ref object of OpenApiRestCall_588457
proc url_CalendarEventsList_589218(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsList_589217(path: JsonNode; query: JsonNode;
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
  var valid_589219 = path.getOrDefault("calendarId")
  valid_589219 = validateParameter(valid_589219, JString, required = true,
                                 default = nil)
  if valid_589219 != nil:
    section.add "calendarId", valid_589219
  result.add "path", section
  ## parameters in `query` object:
  ##   privateExtendedProperty: JArray
  ##                          : Extended properties constraint specified as propertyName=value. Matches only private properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   showHiddenInvitations: JBool
  ##                        : Whether to include hidden invitations in the result. Optional. The default is False.
  ##   timeMax: JString
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMin is set, timeMax must be greater than timeMin.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   timeMin: JString
  ##          : Lower bound (exclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMax is set, timeMin must be smaller than timeMax.
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
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of events returned on one result page. The number of events in the resulting page may be less than this value, or none at all, even if there are more events matching the query. Incomplete pages can be detected by a non-empty nextPageToken field in the response. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  ##   orderBy: JString
  ##          : The order of the events returned in the result. Optional. The default is an unspecified, stable order.
  ##   timeZone: JString
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   q: JString
  ##    : Free text search terms to find events that match these terms in any field, except for extended properties. Optional.
  ##   iCalUID: JString
  ##          : Specifies event ID in the iCalendar format to be included in the response. Optional.
  ##   showDeleted: JBool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned. Optional. The default is False.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   updatedMin: JString
  ##             : Lower bound for an event's last modification time (as a RFC3339 timestamp) to filter by. When specified, entries deleted since this time will always be included regardless of showDeleted. Optional. The default is not to filter by last modification time.
  ##   singleEvents: JBool
  ##               : Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves. Optional. The default is False.
  ##   sharedExtendedProperty: JArray
  ##                         : Extended properties constraint specified as propertyName=value. Matches only shared properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589220 = query.getOrDefault("privateExtendedProperty")
  valid_589220 = validateParameter(valid_589220, JArray, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "privateExtendedProperty", valid_589220
  var valid_589221 = query.getOrDefault("fields")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "fields", valid_589221
  var valid_589222 = query.getOrDefault("pageToken")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "pageToken", valid_589222
  var valid_589223 = query.getOrDefault("quotaUser")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "quotaUser", valid_589223
  var valid_589224 = query.getOrDefault("alt")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = newJString("json"))
  if valid_589224 != nil:
    section.add "alt", valid_589224
  var valid_589225 = query.getOrDefault("maxAttendees")
  valid_589225 = validateParameter(valid_589225, JInt, required = false, default = nil)
  if valid_589225 != nil:
    section.add "maxAttendees", valid_589225
  var valid_589226 = query.getOrDefault("showHiddenInvitations")
  valid_589226 = validateParameter(valid_589226, JBool, required = false, default = nil)
  if valid_589226 != nil:
    section.add "showHiddenInvitations", valid_589226
  var valid_589227 = query.getOrDefault("timeMax")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "timeMax", valid_589227
  var valid_589228 = query.getOrDefault("oauth_token")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "oauth_token", valid_589228
  var valid_589229 = query.getOrDefault("timeMin")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "timeMin", valid_589229
  var valid_589230 = query.getOrDefault("syncToken")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "syncToken", valid_589230
  var valid_589231 = query.getOrDefault("userIp")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "userIp", valid_589231
  var valid_589233 = query.getOrDefault("maxResults")
  valid_589233 = validateParameter(valid_589233, JInt, required = false,
                                 default = newJInt(250))
  if valid_589233 != nil:
    section.add "maxResults", valid_589233
  var valid_589234 = query.getOrDefault("orderBy")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = newJString("startTime"))
  if valid_589234 != nil:
    section.add "orderBy", valid_589234
  var valid_589235 = query.getOrDefault("timeZone")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "timeZone", valid_589235
  var valid_589236 = query.getOrDefault("q")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "q", valid_589236
  var valid_589237 = query.getOrDefault("iCalUID")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "iCalUID", valid_589237
  var valid_589238 = query.getOrDefault("showDeleted")
  valid_589238 = validateParameter(valid_589238, JBool, required = false, default = nil)
  if valid_589238 != nil:
    section.add "showDeleted", valid_589238
  var valid_589239 = query.getOrDefault("key")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "key", valid_589239
  var valid_589240 = query.getOrDefault("updatedMin")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "updatedMin", valid_589240
  var valid_589241 = query.getOrDefault("singleEvents")
  valid_589241 = validateParameter(valid_589241, JBool, required = false, default = nil)
  if valid_589241 != nil:
    section.add "singleEvents", valid_589241
  var valid_589242 = query.getOrDefault("sharedExtendedProperty")
  valid_589242 = validateParameter(valid_589242, JArray, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "sharedExtendedProperty", valid_589242
  var valid_589243 = query.getOrDefault("alwaysIncludeEmail")
  valid_589243 = validateParameter(valid_589243, JBool, required = false, default = nil)
  if valid_589243 != nil:
    section.add "alwaysIncludeEmail", valid_589243
  var valid_589244 = query.getOrDefault("prettyPrint")
  valid_589244 = validateParameter(valid_589244, JBool, required = false,
                                 default = newJBool(true))
  if valid_589244 != nil:
    section.add "prettyPrint", valid_589244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589245: Call_CalendarEventsList_589216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns events on the specified calendar.
  ## 
  let valid = call_589245.validator(path, query, header, formData, body)
  let scheme = call_589245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589245.url(scheme.get, call_589245.host, call_589245.base,
                         call_589245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589245, url, valid)

proc call*(call_589246: Call_CalendarEventsList_589216; calendarId: string;
          privateExtendedProperty: JsonNode = nil; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          maxAttendees: int = 0; showHiddenInvitations: bool = false;
          timeMax: string = ""; oauthToken: string = ""; timeMin: string = "";
          syncToken: string = ""; userIp: string = ""; maxResults: int = 250;
          orderBy: string = "startTime"; timeZone: string = ""; q: string = "";
          iCalUID: string = ""; showDeleted: bool = false; key: string = "";
          updatedMin: string = ""; singleEvents: bool = false;
          sharedExtendedProperty: JsonNode = nil; alwaysIncludeEmail: bool = false;
          prettyPrint: bool = true): Recallable =
  ## calendarEventsList
  ## Returns events on the specified calendar.
  ##   privateExtendedProperty: JArray
  ##                          : Extended properties constraint specified as propertyName=value. Matches only private properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   showHiddenInvitations: bool
  ##                        : Whether to include hidden invitations in the result. Optional. The default is False.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   timeMax: string
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMin is set, timeMax must be greater than timeMin.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   timeMin: string
  ##          : Lower bound (exclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMax is set, timeMin must be smaller than timeMax.
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
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of events returned on one result page. The number of events in the resulting page may be less than this value, or none at all, even if there are more events matching the query. Incomplete pages can be detected by a non-empty nextPageToken field in the response. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  ##   orderBy: string
  ##          : The order of the events returned in the result. Optional. The default is an unspecified, stable order.
  ##   timeZone: string
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   q: string
  ##    : Free text search terms to find events that match these terms in any field, except for extended properties. Optional.
  ##   iCalUID: string
  ##          : Specifies event ID in the iCalendar format to be included in the response. Optional.
  ##   showDeleted: bool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned. Optional. The default is False.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   updatedMin: string
  ##             : Lower bound for an event's last modification time (as a RFC3339 timestamp) to filter by. When specified, entries deleted since this time will always be included regardless of showDeleted. Optional. The default is not to filter by last modification time.
  ##   singleEvents: bool
  ##               : Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves. Optional. The default is False.
  ##   sharedExtendedProperty: JArray
  ##                         : Extended properties constraint specified as propertyName=value. Matches only shared properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589247 = newJObject()
  var query_589248 = newJObject()
  if privateExtendedProperty != nil:
    query_589248.add "privateExtendedProperty", privateExtendedProperty
  add(query_589248, "fields", newJString(fields))
  add(query_589248, "pageToken", newJString(pageToken))
  add(query_589248, "quotaUser", newJString(quotaUser))
  add(query_589248, "alt", newJString(alt))
  add(query_589248, "maxAttendees", newJInt(maxAttendees))
  add(query_589248, "showHiddenInvitations", newJBool(showHiddenInvitations))
  add(path_589247, "calendarId", newJString(calendarId))
  add(query_589248, "timeMax", newJString(timeMax))
  add(query_589248, "oauth_token", newJString(oauthToken))
  add(query_589248, "timeMin", newJString(timeMin))
  add(query_589248, "syncToken", newJString(syncToken))
  add(query_589248, "userIp", newJString(userIp))
  add(query_589248, "maxResults", newJInt(maxResults))
  add(query_589248, "orderBy", newJString(orderBy))
  add(query_589248, "timeZone", newJString(timeZone))
  add(query_589248, "q", newJString(q))
  add(query_589248, "iCalUID", newJString(iCalUID))
  add(query_589248, "showDeleted", newJBool(showDeleted))
  add(query_589248, "key", newJString(key))
  add(query_589248, "updatedMin", newJString(updatedMin))
  add(query_589248, "singleEvents", newJBool(singleEvents))
  if sharedExtendedProperty != nil:
    query_589248.add "sharedExtendedProperty", sharedExtendedProperty
  add(query_589248, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_589248, "prettyPrint", newJBool(prettyPrint))
  result = call_589246.call(path_589247, query_589248, nil, nil, nil)

var calendarEventsList* = Call_CalendarEventsList_589216(
    name: "calendarEventsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events",
    validator: validate_CalendarEventsList_589217, base: "/calendar/v3",
    url: url_CalendarEventsList_589218, schemes: {Scheme.Https})
type
  Call_CalendarEventsImport_589271 = ref object of OpenApiRestCall_588457
proc url_CalendarEventsImport_589273(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsImport_589272(path: JsonNode; query: JsonNode;
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
  var valid_589274 = path.getOrDefault("calendarId")
  valid_589274 = validateParameter(valid_589274, JString, required = true,
                                 default = nil)
  if valid_589274 != nil:
    section.add "calendarId", valid_589274
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   supportsAttachments: JBool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   conferenceDataVersion: JInt
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589275 = query.getOrDefault("fields")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "fields", valid_589275
  var valid_589276 = query.getOrDefault("quotaUser")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "quotaUser", valid_589276
  var valid_589277 = query.getOrDefault("alt")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = newJString("json"))
  if valid_589277 != nil:
    section.add "alt", valid_589277
  var valid_589278 = query.getOrDefault("supportsAttachments")
  valid_589278 = validateParameter(valid_589278, JBool, required = false, default = nil)
  if valid_589278 != nil:
    section.add "supportsAttachments", valid_589278
  var valid_589279 = query.getOrDefault("oauth_token")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "oauth_token", valid_589279
  var valid_589280 = query.getOrDefault("conferenceDataVersion")
  valid_589280 = validateParameter(valid_589280, JInt, required = false, default = nil)
  if valid_589280 != nil:
    section.add "conferenceDataVersion", valid_589280
  var valid_589281 = query.getOrDefault("userIp")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "userIp", valid_589281
  var valid_589282 = query.getOrDefault("key")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "key", valid_589282
  var valid_589283 = query.getOrDefault("prettyPrint")
  valid_589283 = validateParameter(valid_589283, JBool, required = false,
                                 default = newJBool(true))
  if valid_589283 != nil:
    section.add "prettyPrint", valid_589283
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

proc call*(call_589285: Call_CalendarEventsImport_589271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an event. This operation is used to add a private copy of an existing event to a calendar.
  ## 
  let valid = call_589285.validator(path, query, header, formData, body)
  let scheme = call_589285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589285.url(scheme.get, call_589285.host, call_589285.base,
                         call_589285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589285, url, valid)

proc call*(call_589286: Call_CalendarEventsImport_589271; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          supportsAttachments: bool = false; oauthToken: string = "";
          conferenceDataVersion: int = 0; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## calendarEventsImport
  ## Imports an event. This operation is used to add a private copy of an existing event to a calendar.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   supportsAttachments: bool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   conferenceDataVersion: int
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589287 = newJObject()
  var query_589288 = newJObject()
  var body_589289 = newJObject()
  add(query_589288, "fields", newJString(fields))
  add(query_589288, "quotaUser", newJString(quotaUser))
  add(query_589288, "alt", newJString(alt))
  add(query_589288, "supportsAttachments", newJBool(supportsAttachments))
  add(path_589287, "calendarId", newJString(calendarId))
  add(query_589288, "oauth_token", newJString(oauthToken))
  add(query_589288, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_589288, "userIp", newJString(userIp))
  add(query_589288, "key", newJString(key))
  if body != nil:
    body_589289 = body
  add(query_589288, "prettyPrint", newJBool(prettyPrint))
  result = call_589286.call(path_589287, query_589288, nil, nil, body_589289)

var calendarEventsImport* = Call_CalendarEventsImport_589271(
    name: "calendarEventsImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/import",
    validator: validate_CalendarEventsImport_589272, base: "/calendar/v3",
    url: url_CalendarEventsImport_589273, schemes: {Scheme.Https})
type
  Call_CalendarEventsQuickAdd_589290 = ref object of OpenApiRestCall_588457
proc url_CalendarEventsQuickAdd_589292(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsQuickAdd_589291(path: JsonNode; query: JsonNode;
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
  var valid_589293 = path.getOrDefault("calendarId")
  valid_589293 = validateParameter(valid_589293, JString, required = true,
                                 default = nil)
  if valid_589293 != nil:
    section.add "calendarId", valid_589293
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the creation of the event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: JString
  ##              : Guests who should receive notifications about the creation of the new event.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   text: JString (required)
  ##       : The text describing the event to be created.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589294 = query.getOrDefault("fields")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "fields", valid_589294
  var valid_589295 = query.getOrDefault("quotaUser")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "quotaUser", valid_589295
  var valid_589296 = query.getOrDefault("alt")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = newJString("json"))
  if valid_589296 != nil:
    section.add "alt", valid_589296
  var valid_589297 = query.getOrDefault("sendNotifications")
  valid_589297 = validateParameter(valid_589297, JBool, required = false, default = nil)
  if valid_589297 != nil:
    section.add "sendNotifications", valid_589297
  var valid_589298 = query.getOrDefault("oauth_token")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "oauth_token", valid_589298
  var valid_589299 = query.getOrDefault("userIp")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "userIp", valid_589299
  var valid_589300 = query.getOrDefault("sendUpdates")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = newJString("all"))
  if valid_589300 != nil:
    section.add "sendUpdates", valid_589300
  var valid_589301 = query.getOrDefault("key")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "key", valid_589301
  assert query != nil, "query argument is necessary due to required `text` field"
  var valid_589302 = query.getOrDefault("text")
  valid_589302 = validateParameter(valid_589302, JString, required = true,
                                 default = nil)
  if valid_589302 != nil:
    section.add "text", valid_589302
  var valid_589303 = query.getOrDefault("prettyPrint")
  valid_589303 = validateParameter(valid_589303, JBool, required = false,
                                 default = newJBool(true))
  if valid_589303 != nil:
    section.add "prettyPrint", valid_589303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589304: Call_CalendarEventsQuickAdd_589290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an event based on a simple text string.
  ## 
  let valid = call_589304.validator(path, query, header, formData, body)
  let scheme = call_589304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589304.url(scheme.get, call_589304.host, call_589304.base,
                         call_589304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589304, url, valid)

proc call*(call_589305: Call_CalendarEventsQuickAdd_589290; calendarId: string;
          text: string; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          sendNotifications: bool = false; oauthToken: string = ""; userIp: string = "";
          sendUpdates: string = "all"; key: string = ""; prettyPrint: bool = true): Recallable =
  ## calendarEventsQuickAdd
  ## Creates an event based on a simple text string.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the creation of the event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: string
  ##              : Guests who should receive notifications about the creation of the new event.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   text: string (required)
  ##       : The text describing the event to be created.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589306 = newJObject()
  var query_589307 = newJObject()
  add(query_589307, "fields", newJString(fields))
  add(query_589307, "quotaUser", newJString(quotaUser))
  add(query_589307, "alt", newJString(alt))
  add(path_589306, "calendarId", newJString(calendarId))
  add(query_589307, "sendNotifications", newJBool(sendNotifications))
  add(query_589307, "oauth_token", newJString(oauthToken))
  add(query_589307, "userIp", newJString(userIp))
  add(query_589307, "sendUpdates", newJString(sendUpdates))
  add(query_589307, "key", newJString(key))
  add(query_589307, "text", newJString(text))
  add(query_589307, "prettyPrint", newJBool(prettyPrint))
  result = call_589305.call(path_589306, query_589307, nil, nil, nil)

var calendarEventsQuickAdd* = Call_CalendarEventsQuickAdd_589290(
    name: "calendarEventsQuickAdd", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/quickAdd",
    validator: validate_CalendarEventsQuickAdd_589291, base: "/calendar/v3",
    url: url_CalendarEventsQuickAdd_589292, schemes: {Scheme.Https})
type
  Call_CalendarEventsWatch_589308 = ref object of OpenApiRestCall_588457
proc url_CalendarEventsWatch_589310(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsWatch_589309(path: JsonNode; query: JsonNode;
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
  var valid_589311 = path.getOrDefault("calendarId")
  valid_589311 = validateParameter(valid_589311, JString, required = true,
                                 default = nil)
  if valid_589311 != nil:
    section.add "calendarId", valid_589311
  result.add "path", section
  ## parameters in `query` object:
  ##   privateExtendedProperty: JArray
  ##                          : Extended properties constraint specified as propertyName=value. Matches only private properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   showHiddenInvitations: JBool
  ##                        : Whether to include hidden invitations in the result. Optional. The default is False.
  ##   timeMax: JString
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMin is set, timeMax must be greater than timeMin.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   timeMin: JString
  ##          : Lower bound (exclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMax is set, timeMin must be smaller than timeMax.
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
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of events returned on one result page. The number of events in the resulting page may be less than this value, or none at all, even if there are more events matching the query. Incomplete pages can be detected by a non-empty nextPageToken field in the response. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  ##   orderBy: JString
  ##          : The order of the events returned in the result. Optional. The default is an unspecified, stable order.
  ##   timeZone: JString
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   q: JString
  ##    : Free text search terms to find events that match these terms in any field, except for extended properties. Optional.
  ##   iCalUID: JString
  ##          : Specifies event ID in the iCalendar format to be included in the response. Optional.
  ##   showDeleted: JBool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned. Optional. The default is False.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   updatedMin: JString
  ##             : Lower bound for an event's last modification time (as a RFC3339 timestamp) to filter by. When specified, entries deleted since this time will always be included regardless of showDeleted. Optional. The default is not to filter by last modification time.
  ##   singleEvents: JBool
  ##               : Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves. Optional. The default is False.
  ##   sharedExtendedProperty: JArray
  ##                         : Extended properties constraint specified as propertyName=value. Matches only shared properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589312 = query.getOrDefault("privateExtendedProperty")
  valid_589312 = validateParameter(valid_589312, JArray, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "privateExtendedProperty", valid_589312
  var valid_589313 = query.getOrDefault("fields")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "fields", valid_589313
  var valid_589314 = query.getOrDefault("pageToken")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "pageToken", valid_589314
  var valid_589315 = query.getOrDefault("quotaUser")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "quotaUser", valid_589315
  var valid_589316 = query.getOrDefault("alt")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = newJString("json"))
  if valid_589316 != nil:
    section.add "alt", valid_589316
  var valid_589317 = query.getOrDefault("maxAttendees")
  valid_589317 = validateParameter(valid_589317, JInt, required = false, default = nil)
  if valid_589317 != nil:
    section.add "maxAttendees", valid_589317
  var valid_589318 = query.getOrDefault("showHiddenInvitations")
  valid_589318 = validateParameter(valid_589318, JBool, required = false, default = nil)
  if valid_589318 != nil:
    section.add "showHiddenInvitations", valid_589318
  var valid_589319 = query.getOrDefault("timeMax")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "timeMax", valid_589319
  var valid_589320 = query.getOrDefault("oauth_token")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "oauth_token", valid_589320
  var valid_589321 = query.getOrDefault("timeMin")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "timeMin", valid_589321
  var valid_589322 = query.getOrDefault("syncToken")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "syncToken", valid_589322
  var valid_589323 = query.getOrDefault("userIp")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "userIp", valid_589323
  var valid_589324 = query.getOrDefault("maxResults")
  valid_589324 = validateParameter(valid_589324, JInt, required = false,
                                 default = newJInt(250))
  if valid_589324 != nil:
    section.add "maxResults", valid_589324
  var valid_589325 = query.getOrDefault("orderBy")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = newJString("startTime"))
  if valid_589325 != nil:
    section.add "orderBy", valid_589325
  var valid_589326 = query.getOrDefault("timeZone")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "timeZone", valid_589326
  var valid_589327 = query.getOrDefault("q")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "q", valid_589327
  var valid_589328 = query.getOrDefault("iCalUID")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "iCalUID", valid_589328
  var valid_589329 = query.getOrDefault("showDeleted")
  valid_589329 = validateParameter(valid_589329, JBool, required = false, default = nil)
  if valid_589329 != nil:
    section.add "showDeleted", valid_589329
  var valid_589330 = query.getOrDefault("key")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "key", valid_589330
  var valid_589331 = query.getOrDefault("updatedMin")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "updatedMin", valid_589331
  var valid_589332 = query.getOrDefault("singleEvents")
  valid_589332 = validateParameter(valid_589332, JBool, required = false, default = nil)
  if valid_589332 != nil:
    section.add "singleEvents", valid_589332
  var valid_589333 = query.getOrDefault("sharedExtendedProperty")
  valid_589333 = validateParameter(valid_589333, JArray, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "sharedExtendedProperty", valid_589333
  var valid_589334 = query.getOrDefault("alwaysIncludeEmail")
  valid_589334 = validateParameter(valid_589334, JBool, required = false, default = nil)
  if valid_589334 != nil:
    section.add "alwaysIncludeEmail", valid_589334
  var valid_589335 = query.getOrDefault("prettyPrint")
  valid_589335 = validateParameter(valid_589335, JBool, required = false,
                                 default = newJBool(true))
  if valid_589335 != nil:
    section.add "prettyPrint", valid_589335
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

proc call*(call_589337: Call_CalendarEventsWatch_589308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to Events resources.
  ## 
  let valid = call_589337.validator(path, query, header, formData, body)
  let scheme = call_589337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589337.url(scheme.get, call_589337.host, call_589337.base,
                         call_589337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589337, url, valid)

proc call*(call_589338: Call_CalendarEventsWatch_589308; calendarId: string;
          privateExtendedProperty: JsonNode = nil; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          maxAttendees: int = 0; showHiddenInvitations: bool = false;
          timeMax: string = ""; oauthToken: string = ""; timeMin: string = "";
          syncToken: string = ""; userIp: string = ""; maxResults: int = 250;
          orderBy: string = "startTime"; timeZone: string = ""; q: string = "";
          iCalUID: string = ""; showDeleted: bool = false; key: string = "";
          updatedMin: string = ""; singleEvents: bool = false;
          sharedExtendedProperty: JsonNode = nil; resource: JsonNode = nil;
          alwaysIncludeEmail: bool = false; prettyPrint: bool = true): Recallable =
  ## calendarEventsWatch
  ## Watch for changes to Events resources.
  ##   privateExtendedProperty: JArray
  ##                          : Extended properties constraint specified as propertyName=value. Matches only private properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   showHiddenInvitations: bool
  ##                        : Whether to include hidden invitations in the result. Optional. The default is False.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   timeMax: string
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMin is set, timeMax must be greater than timeMin.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   timeMin: string
  ##          : Lower bound (exclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset, for example, 2011-06-03T10:00:00-07:00, 2011-06-03T10:00:00Z. Milliseconds may be provided but are ignored. If timeMax is set, timeMin must be smaller than timeMax.
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
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of events returned on one result page. The number of events in the resulting page may be less than this value, or none at all, even if there are more events matching the query. Incomplete pages can be detected by a non-empty nextPageToken field in the response. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  ##   orderBy: string
  ##          : The order of the events returned in the result. Optional. The default is an unspecified, stable order.
  ##   timeZone: string
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   q: string
  ##    : Free text search terms to find events that match these terms in any field, except for extended properties. Optional.
  ##   iCalUID: string
  ##          : Specifies event ID in the iCalendar format to be included in the response. Optional.
  ##   showDeleted: bool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned. Optional. The default is False.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   updatedMin: string
  ##             : Lower bound for an event's last modification time (as a RFC3339 timestamp) to filter by. When specified, entries deleted since this time will always be included regardless of showDeleted. Optional. The default is not to filter by last modification time.
  ##   singleEvents: bool
  ##               : Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves. Optional. The default is False.
  ##   sharedExtendedProperty: JArray
  ##                         : Extended properties constraint specified as propertyName=value. Matches only shared properties. This parameter might be repeated multiple times to return events that match all given constraints.
  ##   resource: JObject
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589339 = newJObject()
  var query_589340 = newJObject()
  var body_589341 = newJObject()
  if privateExtendedProperty != nil:
    query_589340.add "privateExtendedProperty", privateExtendedProperty
  add(query_589340, "fields", newJString(fields))
  add(query_589340, "pageToken", newJString(pageToken))
  add(query_589340, "quotaUser", newJString(quotaUser))
  add(query_589340, "alt", newJString(alt))
  add(query_589340, "maxAttendees", newJInt(maxAttendees))
  add(query_589340, "showHiddenInvitations", newJBool(showHiddenInvitations))
  add(path_589339, "calendarId", newJString(calendarId))
  add(query_589340, "timeMax", newJString(timeMax))
  add(query_589340, "oauth_token", newJString(oauthToken))
  add(query_589340, "timeMin", newJString(timeMin))
  add(query_589340, "syncToken", newJString(syncToken))
  add(query_589340, "userIp", newJString(userIp))
  add(query_589340, "maxResults", newJInt(maxResults))
  add(query_589340, "orderBy", newJString(orderBy))
  add(query_589340, "timeZone", newJString(timeZone))
  add(query_589340, "q", newJString(q))
  add(query_589340, "iCalUID", newJString(iCalUID))
  add(query_589340, "showDeleted", newJBool(showDeleted))
  add(query_589340, "key", newJString(key))
  add(query_589340, "updatedMin", newJString(updatedMin))
  add(query_589340, "singleEvents", newJBool(singleEvents))
  if sharedExtendedProperty != nil:
    query_589340.add "sharedExtendedProperty", sharedExtendedProperty
  if resource != nil:
    body_589341 = resource
  add(query_589340, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_589340, "prettyPrint", newJBool(prettyPrint))
  result = call_589338.call(path_589339, query_589340, nil, nil, body_589341)

var calendarEventsWatch* = Call_CalendarEventsWatch_589308(
    name: "calendarEventsWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/watch",
    validator: validate_CalendarEventsWatch_589309, base: "/calendar/v3",
    url: url_CalendarEventsWatch_589310, schemes: {Scheme.Https})
type
  Call_CalendarEventsUpdate_589361 = ref object of OpenApiRestCall_588457
proc url_CalendarEventsUpdate_589363(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsUpdate_589362(path: JsonNode; query: JsonNode;
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
  var valid_589364 = path.getOrDefault("calendarId")
  valid_589364 = validateParameter(valid_589364, JString, required = true,
                                 default = nil)
  if valid_589364 != nil:
    section.add "calendarId", valid_589364
  var valid_589365 = path.getOrDefault("eventId")
  valid_589365 = validateParameter(valid_589365, JString, required = true,
                                 default = nil)
  if valid_589365 != nil:
    section.add "eventId", valid_589365
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   supportsAttachments: JBool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the event update (for example, description changes, etc.). Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   conferenceDataVersion: JInt
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: JString
  ##              : Guests who should receive notifications about the event update (for example, title changes, etc.).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589366 = query.getOrDefault("fields")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "fields", valid_589366
  var valid_589367 = query.getOrDefault("quotaUser")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "quotaUser", valid_589367
  var valid_589368 = query.getOrDefault("alt")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = newJString("json"))
  if valid_589368 != nil:
    section.add "alt", valid_589368
  var valid_589369 = query.getOrDefault("supportsAttachments")
  valid_589369 = validateParameter(valid_589369, JBool, required = false, default = nil)
  if valid_589369 != nil:
    section.add "supportsAttachments", valid_589369
  var valid_589370 = query.getOrDefault("maxAttendees")
  valid_589370 = validateParameter(valid_589370, JInt, required = false, default = nil)
  if valid_589370 != nil:
    section.add "maxAttendees", valid_589370
  var valid_589371 = query.getOrDefault("sendNotifications")
  valid_589371 = validateParameter(valid_589371, JBool, required = false, default = nil)
  if valid_589371 != nil:
    section.add "sendNotifications", valid_589371
  var valid_589372 = query.getOrDefault("oauth_token")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "oauth_token", valid_589372
  var valid_589373 = query.getOrDefault("conferenceDataVersion")
  valid_589373 = validateParameter(valid_589373, JInt, required = false, default = nil)
  if valid_589373 != nil:
    section.add "conferenceDataVersion", valid_589373
  var valid_589374 = query.getOrDefault("userIp")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "userIp", valid_589374
  var valid_589375 = query.getOrDefault("sendUpdates")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = newJString("all"))
  if valid_589375 != nil:
    section.add "sendUpdates", valid_589375
  var valid_589376 = query.getOrDefault("key")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "key", valid_589376
  var valid_589377 = query.getOrDefault("alwaysIncludeEmail")
  valid_589377 = validateParameter(valid_589377, JBool, required = false, default = nil)
  if valid_589377 != nil:
    section.add "alwaysIncludeEmail", valid_589377
  var valid_589378 = query.getOrDefault("prettyPrint")
  valid_589378 = validateParameter(valid_589378, JBool, required = false,
                                 default = newJBool(true))
  if valid_589378 != nil:
    section.add "prettyPrint", valid_589378
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

proc call*(call_589380: Call_CalendarEventsUpdate_589361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an event.
  ## 
  let valid = call_589380.validator(path, query, header, formData, body)
  let scheme = call_589380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589380.url(scheme.get, call_589380.host, call_589380.base,
                         call_589380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589380, url, valid)

proc call*(call_589381: Call_CalendarEventsUpdate_589361; calendarId: string;
          eventId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; supportsAttachments: bool = false;
          maxAttendees: int = 0; sendNotifications: bool = false;
          oauthToken: string = ""; conferenceDataVersion: int = 0; userIp: string = "";
          sendUpdates: string = "all"; key: string = "";
          alwaysIncludeEmail: bool = false; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## calendarEventsUpdate
  ## Updates an event.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   supportsAttachments: bool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the event update (for example, description changes, etc.). Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   conferenceDataVersion: int
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: string
  ##              : Guests who should receive notifications about the event update (for example, title changes, etc.).
  ##   eventId: string (required)
  ##          : Event identifier.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589382 = newJObject()
  var query_589383 = newJObject()
  var body_589384 = newJObject()
  add(query_589383, "fields", newJString(fields))
  add(query_589383, "quotaUser", newJString(quotaUser))
  add(query_589383, "alt", newJString(alt))
  add(query_589383, "supportsAttachments", newJBool(supportsAttachments))
  add(query_589383, "maxAttendees", newJInt(maxAttendees))
  add(path_589382, "calendarId", newJString(calendarId))
  add(query_589383, "sendNotifications", newJBool(sendNotifications))
  add(query_589383, "oauth_token", newJString(oauthToken))
  add(query_589383, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_589383, "userIp", newJString(userIp))
  add(query_589383, "sendUpdates", newJString(sendUpdates))
  add(path_589382, "eventId", newJString(eventId))
  add(query_589383, "key", newJString(key))
  add(query_589383, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if body != nil:
    body_589384 = body
  add(query_589383, "prettyPrint", newJBool(prettyPrint))
  result = call_589381.call(path_589382, query_589383, nil, nil, body_589384)

var calendarEventsUpdate* = Call_CalendarEventsUpdate_589361(
    name: "calendarEventsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsUpdate_589362, base: "/calendar/v3",
    url: url_CalendarEventsUpdate_589363, schemes: {Scheme.Https})
type
  Call_CalendarEventsGet_589342 = ref object of OpenApiRestCall_588457
proc url_CalendarEventsGet_589344(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsGet_589343(path: JsonNode; query: JsonNode;
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
  var valid_589345 = path.getOrDefault("calendarId")
  valid_589345 = validateParameter(valid_589345, JString, required = true,
                                 default = nil)
  if valid_589345 != nil:
    section.add "calendarId", valid_589345
  var valid_589346 = path.getOrDefault("eventId")
  valid_589346 = validateParameter(valid_589346, JString, required = true,
                                 default = nil)
  if valid_589346 != nil:
    section.add "eventId", valid_589346
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   timeZone: JString
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589347 = query.getOrDefault("fields")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "fields", valid_589347
  var valid_589348 = query.getOrDefault("quotaUser")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "quotaUser", valid_589348
  var valid_589349 = query.getOrDefault("alt")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = newJString("json"))
  if valid_589349 != nil:
    section.add "alt", valid_589349
  var valid_589350 = query.getOrDefault("maxAttendees")
  valid_589350 = validateParameter(valid_589350, JInt, required = false, default = nil)
  if valid_589350 != nil:
    section.add "maxAttendees", valid_589350
  var valid_589351 = query.getOrDefault("oauth_token")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "oauth_token", valid_589351
  var valid_589352 = query.getOrDefault("userIp")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "userIp", valid_589352
  var valid_589353 = query.getOrDefault("timeZone")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "timeZone", valid_589353
  var valid_589354 = query.getOrDefault("key")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "key", valid_589354
  var valid_589355 = query.getOrDefault("alwaysIncludeEmail")
  valid_589355 = validateParameter(valid_589355, JBool, required = false, default = nil)
  if valid_589355 != nil:
    section.add "alwaysIncludeEmail", valid_589355
  var valid_589356 = query.getOrDefault("prettyPrint")
  valid_589356 = validateParameter(valid_589356, JBool, required = false,
                                 default = newJBool(true))
  if valid_589356 != nil:
    section.add "prettyPrint", valid_589356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589357: Call_CalendarEventsGet_589342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an event.
  ## 
  let valid = call_589357.validator(path, query, header, formData, body)
  let scheme = call_589357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589357.url(scheme.get, call_589357.host, call_589357.base,
                         call_589357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589357, url, valid)

proc call*(call_589358: Call_CalendarEventsGet_589342; calendarId: string;
          eventId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; maxAttendees: int = 0; oauthToken: string = "";
          userIp: string = ""; timeZone: string = ""; key: string = "";
          alwaysIncludeEmail: bool = false; prettyPrint: bool = true): Recallable =
  ## calendarEventsGet
  ## Returns an event.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   timeZone: string
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   eventId: string (required)
  ##          : Event identifier.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589359 = newJObject()
  var query_589360 = newJObject()
  add(query_589360, "fields", newJString(fields))
  add(query_589360, "quotaUser", newJString(quotaUser))
  add(query_589360, "alt", newJString(alt))
  add(query_589360, "maxAttendees", newJInt(maxAttendees))
  add(path_589359, "calendarId", newJString(calendarId))
  add(query_589360, "oauth_token", newJString(oauthToken))
  add(query_589360, "userIp", newJString(userIp))
  add(query_589360, "timeZone", newJString(timeZone))
  add(path_589359, "eventId", newJString(eventId))
  add(query_589360, "key", newJString(key))
  add(query_589360, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_589360, "prettyPrint", newJBool(prettyPrint))
  result = call_589358.call(path_589359, query_589360, nil, nil, nil)

var calendarEventsGet* = Call_CalendarEventsGet_589342(name: "calendarEventsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsGet_589343, base: "/calendar/v3",
    url: url_CalendarEventsGet_589344, schemes: {Scheme.Https})
type
  Call_CalendarEventsPatch_589403 = ref object of OpenApiRestCall_588457
proc url_CalendarEventsPatch_589405(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsPatch_589404(path: JsonNode; query: JsonNode;
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
  var valid_589406 = path.getOrDefault("calendarId")
  valid_589406 = validateParameter(valid_589406, JString, required = true,
                                 default = nil)
  if valid_589406 != nil:
    section.add "calendarId", valid_589406
  var valid_589407 = path.getOrDefault("eventId")
  valid_589407 = validateParameter(valid_589407, JString, required = true,
                                 default = nil)
  if valid_589407 != nil:
    section.add "eventId", valid_589407
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   supportsAttachments: JBool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the event update (for example, description changes, etc.). Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   conferenceDataVersion: JInt
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: JString
  ##              : Guests who should receive notifications about the event update (for example, title changes, etc.).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589408 = query.getOrDefault("fields")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "fields", valid_589408
  var valid_589409 = query.getOrDefault("quotaUser")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "quotaUser", valid_589409
  var valid_589410 = query.getOrDefault("alt")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = newJString("json"))
  if valid_589410 != nil:
    section.add "alt", valid_589410
  var valid_589411 = query.getOrDefault("supportsAttachments")
  valid_589411 = validateParameter(valid_589411, JBool, required = false, default = nil)
  if valid_589411 != nil:
    section.add "supportsAttachments", valid_589411
  var valid_589412 = query.getOrDefault("maxAttendees")
  valid_589412 = validateParameter(valid_589412, JInt, required = false, default = nil)
  if valid_589412 != nil:
    section.add "maxAttendees", valid_589412
  var valid_589413 = query.getOrDefault("sendNotifications")
  valid_589413 = validateParameter(valid_589413, JBool, required = false, default = nil)
  if valid_589413 != nil:
    section.add "sendNotifications", valid_589413
  var valid_589414 = query.getOrDefault("oauth_token")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "oauth_token", valid_589414
  var valid_589415 = query.getOrDefault("conferenceDataVersion")
  valid_589415 = validateParameter(valid_589415, JInt, required = false, default = nil)
  if valid_589415 != nil:
    section.add "conferenceDataVersion", valid_589415
  var valid_589416 = query.getOrDefault("userIp")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "userIp", valid_589416
  var valid_589417 = query.getOrDefault("sendUpdates")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = newJString("all"))
  if valid_589417 != nil:
    section.add "sendUpdates", valid_589417
  var valid_589418 = query.getOrDefault("key")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "key", valid_589418
  var valid_589419 = query.getOrDefault("alwaysIncludeEmail")
  valid_589419 = validateParameter(valid_589419, JBool, required = false, default = nil)
  if valid_589419 != nil:
    section.add "alwaysIncludeEmail", valid_589419
  var valid_589420 = query.getOrDefault("prettyPrint")
  valid_589420 = validateParameter(valid_589420, JBool, required = false,
                                 default = newJBool(true))
  if valid_589420 != nil:
    section.add "prettyPrint", valid_589420
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

proc call*(call_589422: Call_CalendarEventsPatch_589403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an event. This method supports patch semantics.
  ## 
  let valid = call_589422.validator(path, query, header, formData, body)
  let scheme = call_589422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589422.url(scheme.get, call_589422.host, call_589422.base,
                         call_589422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589422, url, valid)

proc call*(call_589423: Call_CalendarEventsPatch_589403; calendarId: string;
          eventId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; supportsAttachments: bool = false;
          maxAttendees: int = 0; sendNotifications: bool = false;
          oauthToken: string = ""; conferenceDataVersion: int = 0; userIp: string = "";
          sendUpdates: string = "all"; key: string = "";
          alwaysIncludeEmail: bool = false; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## calendarEventsPatch
  ## Updates an event. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   supportsAttachments: bool
  ##                      : Whether API client performing operation supports event attachments. Optional. The default is False.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the event update (for example, description changes, etc.). Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   conferenceDataVersion: int
  ##                        : Version number of conference data supported by the API client. Version 0 assumes no conference data support and ignores conference data in the event's body. Version 1 enables support for copying of ConferenceData as well as for creating new conferences using the createRequest field of conferenceData. The default is 0.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: string
  ##              : Guests who should receive notifications about the event update (for example, title changes, etc.).
  ##   eventId: string (required)
  ##          : Event identifier.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589424 = newJObject()
  var query_589425 = newJObject()
  var body_589426 = newJObject()
  add(query_589425, "fields", newJString(fields))
  add(query_589425, "quotaUser", newJString(quotaUser))
  add(query_589425, "alt", newJString(alt))
  add(query_589425, "supportsAttachments", newJBool(supportsAttachments))
  add(query_589425, "maxAttendees", newJInt(maxAttendees))
  add(path_589424, "calendarId", newJString(calendarId))
  add(query_589425, "sendNotifications", newJBool(sendNotifications))
  add(query_589425, "oauth_token", newJString(oauthToken))
  add(query_589425, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_589425, "userIp", newJString(userIp))
  add(query_589425, "sendUpdates", newJString(sendUpdates))
  add(path_589424, "eventId", newJString(eventId))
  add(query_589425, "key", newJString(key))
  add(query_589425, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if body != nil:
    body_589426 = body
  add(query_589425, "prettyPrint", newJBool(prettyPrint))
  result = call_589423.call(path_589424, query_589425, nil, nil, body_589426)

var calendarEventsPatch* = Call_CalendarEventsPatch_589403(
    name: "calendarEventsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsPatch_589404, base: "/calendar/v3",
    url: url_CalendarEventsPatch_589405, schemes: {Scheme.Https})
type
  Call_CalendarEventsDelete_589385 = ref object of OpenApiRestCall_588457
proc url_CalendarEventsDelete_589387(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsDelete_589386(path: JsonNode; query: JsonNode;
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
  var valid_589388 = path.getOrDefault("calendarId")
  valid_589388 = validateParameter(valid_589388, JString, required = true,
                                 default = nil)
  if valid_589388 != nil:
    section.add "calendarId", valid_589388
  var valid_589389 = path.getOrDefault("eventId")
  valid_589389 = validateParameter(valid_589389, JString, required = true,
                                 default = nil)
  if valid_589389 != nil:
    section.add "eventId", valid_589389
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the deletion of the event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: JString
  ##              : Guests who should receive notifications about the deletion of the event.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589390 = query.getOrDefault("fields")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "fields", valid_589390
  var valid_589391 = query.getOrDefault("quotaUser")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "quotaUser", valid_589391
  var valid_589392 = query.getOrDefault("alt")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = newJString("json"))
  if valid_589392 != nil:
    section.add "alt", valid_589392
  var valid_589393 = query.getOrDefault("sendNotifications")
  valid_589393 = validateParameter(valid_589393, JBool, required = false, default = nil)
  if valid_589393 != nil:
    section.add "sendNotifications", valid_589393
  var valid_589394 = query.getOrDefault("oauth_token")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "oauth_token", valid_589394
  var valid_589395 = query.getOrDefault("userIp")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "userIp", valid_589395
  var valid_589396 = query.getOrDefault("sendUpdates")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = newJString("all"))
  if valid_589396 != nil:
    section.add "sendUpdates", valid_589396
  var valid_589397 = query.getOrDefault("key")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "key", valid_589397
  var valid_589398 = query.getOrDefault("prettyPrint")
  valid_589398 = validateParameter(valid_589398, JBool, required = false,
                                 default = newJBool(true))
  if valid_589398 != nil:
    section.add "prettyPrint", valid_589398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589399: Call_CalendarEventsDelete_589385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an event.
  ## 
  let valid = call_589399.validator(path, query, header, formData, body)
  let scheme = call_589399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589399.url(scheme.get, call_589399.host, call_589399.base,
                         call_589399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589399, url, valid)

proc call*(call_589400: Call_CalendarEventsDelete_589385; calendarId: string;
          eventId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; sendNotifications: bool = false;
          oauthToken: string = ""; userIp: string = ""; sendUpdates: string = "all";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## calendarEventsDelete
  ## Deletes an event.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the deletion of the event. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: string
  ##              : Guests who should receive notifications about the deletion of the event.
  ##   eventId: string (required)
  ##          : Event identifier.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589401 = newJObject()
  var query_589402 = newJObject()
  add(query_589402, "fields", newJString(fields))
  add(query_589402, "quotaUser", newJString(quotaUser))
  add(query_589402, "alt", newJString(alt))
  add(path_589401, "calendarId", newJString(calendarId))
  add(query_589402, "sendNotifications", newJBool(sendNotifications))
  add(query_589402, "oauth_token", newJString(oauthToken))
  add(query_589402, "userIp", newJString(userIp))
  add(query_589402, "sendUpdates", newJString(sendUpdates))
  add(path_589401, "eventId", newJString(eventId))
  add(query_589402, "key", newJString(key))
  add(query_589402, "prettyPrint", newJBool(prettyPrint))
  result = call_589400.call(path_589401, query_589402, nil, nil, nil)

var calendarEventsDelete* = Call_CalendarEventsDelete_589385(
    name: "calendarEventsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsDelete_589386, base: "/calendar/v3",
    url: url_CalendarEventsDelete_589387, schemes: {Scheme.Https})
type
  Call_CalendarEventsInstances_589427 = ref object of OpenApiRestCall_588457
proc url_CalendarEventsInstances_589429(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsInstances_589428(path: JsonNode; query: JsonNode;
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
  var valid_589430 = path.getOrDefault("calendarId")
  valid_589430 = validateParameter(valid_589430, JString, required = true,
                                 default = nil)
  if valid_589430 != nil:
    section.add "calendarId", valid_589430
  var valid_589431 = path.getOrDefault("eventId")
  valid_589431 = validateParameter(valid_589431, JString, required = true,
                                 default = nil)
  if valid_589431 != nil:
    section.add "eventId", valid_589431
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   originalStart: JString
  ##                : The original start time of the instance in the result. Optional.
  ##   alt: JString
  ##      : Data format for the response.
  ##   maxAttendees: JInt
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   timeMax: JString
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   timeMin: JString
  ##          : Lower bound (inclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of events returned on one result page. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  ##   timeZone: JString
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   showDeleted: JBool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events will still be included if singleEvents is False. Optional. The default is False.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alwaysIncludeEmail: JBool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589432 = query.getOrDefault("fields")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "fields", valid_589432
  var valid_589433 = query.getOrDefault("pageToken")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "pageToken", valid_589433
  var valid_589434 = query.getOrDefault("quotaUser")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "quotaUser", valid_589434
  var valid_589435 = query.getOrDefault("originalStart")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "originalStart", valid_589435
  var valid_589436 = query.getOrDefault("alt")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = newJString("json"))
  if valid_589436 != nil:
    section.add "alt", valid_589436
  var valid_589437 = query.getOrDefault("maxAttendees")
  valid_589437 = validateParameter(valid_589437, JInt, required = false, default = nil)
  if valid_589437 != nil:
    section.add "maxAttendees", valid_589437
  var valid_589438 = query.getOrDefault("timeMax")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "timeMax", valid_589438
  var valid_589439 = query.getOrDefault("oauth_token")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "oauth_token", valid_589439
  var valid_589440 = query.getOrDefault("timeMin")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "timeMin", valid_589440
  var valid_589441 = query.getOrDefault("userIp")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "userIp", valid_589441
  var valid_589442 = query.getOrDefault("maxResults")
  valid_589442 = validateParameter(valid_589442, JInt, required = false, default = nil)
  if valid_589442 != nil:
    section.add "maxResults", valid_589442
  var valid_589443 = query.getOrDefault("timeZone")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "timeZone", valid_589443
  var valid_589444 = query.getOrDefault("showDeleted")
  valid_589444 = validateParameter(valid_589444, JBool, required = false, default = nil)
  if valid_589444 != nil:
    section.add "showDeleted", valid_589444
  var valid_589445 = query.getOrDefault("key")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "key", valid_589445
  var valid_589446 = query.getOrDefault("alwaysIncludeEmail")
  valid_589446 = validateParameter(valid_589446, JBool, required = false, default = nil)
  if valid_589446 != nil:
    section.add "alwaysIncludeEmail", valid_589446
  var valid_589447 = query.getOrDefault("prettyPrint")
  valid_589447 = validateParameter(valid_589447, JBool, required = false,
                                 default = newJBool(true))
  if valid_589447 != nil:
    section.add "prettyPrint", valid_589447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589448: Call_CalendarEventsInstances_589427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns instances of the specified recurring event.
  ## 
  let valid = call_589448.validator(path, query, header, formData, body)
  let scheme = call_589448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589448.url(scheme.get, call_589448.host, call_589448.base,
                         call_589448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589448, url, valid)

proc call*(call_589449: Call_CalendarEventsInstances_589427; calendarId: string;
          eventId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; originalStart: string = ""; alt: string = "json";
          maxAttendees: int = 0; timeMax: string = ""; oauthToken: string = "";
          timeMin: string = ""; userIp: string = ""; maxResults: int = 0;
          timeZone: string = ""; showDeleted: bool = false; key: string = "";
          alwaysIncludeEmail: bool = false; prettyPrint: bool = true): Recallable =
  ## calendarEventsInstances
  ## Returns instances of the specified recurring event.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   originalStart: string
  ##                : The original start time of the instance in the result. Optional.
  ##   alt: string
  ##      : Data format for the response.
  ##   maxAttendees: int
  ##               : The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned. Optional.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   timeMax: string
  ##          : Upper bound (exclusive) for an event's start time to filter by. Optional. The default is not to filter by start time. Must be an RFC3339 timestamp with mandatory time zone offset.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   timeMin: string
  ##          : Lower bound (inclusive) for an event's end time to filter by. Optional. The default is not to filter by end time. Must be an RFC3339 timestamp with mandatory time zone offset.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of events returned on one result page. By default the value is 250 events. The page size can never be larger than 2500 events. Optional.
  ##   timeZone: string
  ##           : Time zone used in the response. Optional. The default is the time zone of the calendar.
  ##   showDeleted: bool
  ##              : Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events will still be included if singleEvents is False. Optional. The default is False.
  ##   eventId: string (required)
  ##          : Recurring event identifier.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alwaysIncludeEmail: bool
  ##                     : Whether to always include a value in the email field for the organizer, creator and attendees, even if no real email is available (i.e. a generated, non-working value will be provided). The use of this option is discouraged and should only be used by clients which cannot handle the absence of an email address value in the mentioned places. Optional. The default is False.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589450 = newJObject()
  var query_589451 = newJObject()
  add(query_589451, "fields", newJString(fields))
  add(query_589451, "pageToken", newJString(pageToken))
  add(query_589451, "quotaUser", newJString(quotaUser))
  add(query_589451, "originalStart", newJString(originalStart))
  add(query_589451, "alt", newJString(alt))
  add(query_589451, "maxAttendees", newJInt(maxAttendees))
  add(path_589450, "calendarId", newJString(calendarId))
  add(query_589451, "timeMax", newJString(timeMax))
  add(query_589451, "oauth_token", newJString(oauthToken))
  add(query_589451, "timeMin", newJString(timeMin))
  add(query_589451, "userIp", newJString(userIp))
  add(query_589451, "maxResults", newJInt(maxResults))
  add(query_589451, "timeZone", newJString(timeZone))
  add(query_589451, "showDeleted", newJBool(showDeleted))
  add(path_589450, "eventId", newJString(eventId))
  add(query_589451, "key", newJString(key))
  add(query_589451, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_589451, "prettyPrint", newJBool(prettyPrint))
  result = call_589449.call(path_589450, query_589451, nil, nil, nil)

var calendarEventsInstances* = Call_CalendarEventsInstances_589427(
    name: "calendarEventsInstances", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}/instances",
    validator: validate_CalendarEventsInstances_589428, base: "/calendar/v3",
    url: url_CalendarEventsInstances_589429, schemes: {Scheme.Https})
type
  Call_CalendarEventsMove_589452 = ref object of OpenApiRestCall_588457
proc url_CalendarEventsMove_589454(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsMove_589453(path: JsonNode; query: JsonNode;
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
  var valid_589455 = path.getOrDefault("calendarId")
  valid_589455 = validateParameter(valid_589455, JString, required = true,
                                 default = nil)
  if valid_589455 != nil:
    section.add "calendarId", valid_589455
  var valid_589456 = path.getOrDefault("eventId")
  valid_589456 = validateParameter(valid_589456, JString, required = true,
                                 default = nil)
  if valid_589456 != nil:
    section.add "eventId", valid_589456
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sendNotifications: JBool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the change of the event's organizer. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: JString
  ##              : Guests who should receive notifications about the change of the event's organizer.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   destination: JString (required)
  ##              : Calendar identifier of the target calendar where the event is to be moved to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589457 = query.getOrDefault("fields")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "fields", valid_589457
  var valid_589458 = query.getOrDefault("quotaUser")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "quotaUser", valid_589458
  var valid_589459 = query.getOrDefault("alt")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = newJString("json"))
  if valid_589459 != nil:
    section.add "alt", valid_589459
  var valid_589460 = query.getOrDefault("sendNotifications")
  valid_589460 = validateParameter(valid_589460, JBool, required = false, default = nil)
  if valid_589460 != nil:
    section.add "sendNotifications", valid_589460
  var valid_589461 = query.getOrDefault("oauth_token")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "oauth_token", valid_589461
  var valid_589462 = query.getOrDefault("userIp")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "userIp", valid_589462
  var valid_589463 = query.getOrDefault("sendUpdates")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = newJString("all"))
  if valid_589463 != nil:
    section.add "sendUpdates", valid_589463
  var valid_589464 = query.getOrDefault("key")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "key", valid_589464
  assert query != nil,
        "query argument is necessary due to required `destination` field"
  var valid_589465 = query.getOrDefault("destination")
  valid_589465 = validateParameter(valid_589465, JString, required = true,
                                 default = nil)
  if valid_589465 != nil:
    section.add "destination", valid_589465
  var valid_589466 = query.getOrDefault("prettyPrint")
  valid_589466 = validateParameter(valid_589466, JBool, required = false,
                                 default = newJBool(true))
  if valid_589466 != nil:
    section.add "prettyPrint", valid_589466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589467: Call_CalendarEventsMove_589452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves an event to another calendar, i.e. changes an event's organizer.
  ## 
  let valid = call_589467.validator(path, query, header, formData, body)
  let scheme = call_589467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589467.url(scheme.get, call_589467.host, call_589467.base,
                         call_589467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589467, url, valid)

proc call*(call_589468: Call_CalendarEventsMove_589452; calendarId: string;
          eventId: string; destination: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; sendNotifications: bool = false;
          oauthToken: string = ""; userIp: string = ""; sendUpdates: string = "all";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## calendarEventsMove
  ## Moves an event to another calendar, i.e. changes an event's organizer.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier of the source calendar where the event currently is on.
  ##   sendNotifications: bool
  ##                    : Deprecated. Please use sendUpdates instead.
  ## 
  ## Whether to send notifications about the change of the event's organizer. Note that some emails might still be sent even if you set the value to false. The default is false.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sendUpdates: string
  ##              : Guests who should receive notifications about the change of the event's organizer.
  ##   eventId: string (required)
  ##          : Event identifier.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   destination: string (required)
  ##              : Calendar identifier of the target calendar where the event is to be moved to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589469 = newJObject()
  var query_589470 = newJObject()
  add(query_589470, "fields", newJString(fields))
  add(query_589470, "quotaUser", newJString(quotaUser))
  add(query_589470, "alt", newJString(alt))
  add(path_589469, "calendarId", newJString(calendarId))
  add(query_589470, "sendNotifications", newJBool(sendNotifications))
  add(query_589470, "oauth_token", newJString(oauthToken))
  add(query_589470, "userIp", newJString(userIp))
  add(query_589470, "sendUpdates", newJString(sendUpdates))
  add(path_589469, "eventId", newJString(eventId))
  add(query_589470, "key", newJString(key))
  add(query_589470, "destination", newJString(destination))
  add(query_589470, "prettyPrint", newJBool(prettyPrint))
  result = call_589468.call(path_589469, query_589470, nil, nil, nil)

var calendarEventsMove* = Call_CalendarEventsMove_589452(
    name: "calendarEventsMove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}/move",
    validator: validate_CalendarEventsMove_589453, base: "/calendar/v3",
    url: url_CalendarEventsMove_589454, schemes: {Scheme.Https})
type
  Call_CalendarChannelsStop_589471 = ref object of OpenApiRestCall_588457
proc url_CalendarChannelsStop_589473(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarChannelsStop_589472(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589474 = query.getOrDefault("fields")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "fields", valid_589474
  var valid_589475 = query.getOrDefault("quotaUser")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "quotaUser", valid_589475
  var valid_589476 = query.getOrDefault("alt")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = newJString("json"))
  if valid_589476 != nil:
    section.add "alt", valid_589476
  var valid_589477 = query.getOrDefault("oauth_token")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "oauth_token", valid_589477
  var valid_589478 = query.getOrDefault("userIp")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "userIp", valid_589478
  var valid_589479 = query.getOrDefault("key")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "key", valid_589479
  var valid_589480 = query.getOrDefault("prettyPrint")
  valid_589480 = validateParameter(valid_589480, JBool, required = false,
                                 default = newJBool(true))
  if valid_589480 != nil:
    section.add "prettyPrint", valid_589480
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

proc call*(call_589482: Call_CalendarChannelsStop_589471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_589482.validator(path, query, header, formData, body)
  let scheme = call_589482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589482.url(scheme.get, call_589482.host, call_589482.base,
                         call_589482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589482, url, valid)

proc call*(call_589483: Call_CalendarChannelsStop_589471; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## calendarChannelsStop
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
  var query_589484 = newJObject()
  var body_589485 = newJObject()
  add(query_589484, "fields", newJString(fields))
  add(query_589484, "quotaUser", newJString(quotaUser))
  add(query_589484, "alt", newJString(alt))
  add(query_589484, "oauth_token", newJString(oauthToken))
  add(query_589484, "userIp", newJString(userIp))
  add(query_589484, "key", newJString(key))
  if resource != nil:
    body_589485 = resource
  add(query_589484, "prettyPrint", newJBool(prettyPrint))
  result = call_589483.call(nil, query_589484, nil, nil, body_589485)

var calendarChannelsStop* = Call_CalendarChannelsStop_589471(
    name: "calendarChannelsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_CalendarChannelsStop_589472, base: "/calendar/v3",
    url: url_CalendarChannelsStop_589473, schemes: {Scheme.Https})
type
  Call_CalendarColorsGet_589486 = ref object of OpenApiRestCall_588457
proc url_CalendarColorsGet_589488(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarColorsGet_589487(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the color definitions for calendars and events.
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
  var valid_589489 = query.getOrDefault("fields")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = nil)
  if valid_589489 != nil:
    section.add "fields", valid_589489
  var valid_589490 = query.getOrDefault("quotaUser")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "quotaUser", valid_589490
  var valid_589491 = query.getOrDefault("alt")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = newJString("json"))
  if valid_589491 != nil:
    section.add "alt", valid_589491
  var valid_589492 = query.getOrDefault("oauth_token")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = nil)
  if valid_589492 != nil:
    section.add "oauth_token", valid_589492
  var valid_589493 = query.getOrDefault("userIp")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "userIp", valid_589493
  var valid_589494 = query.getOrDefault("key")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "key", valid_589494
  var valid_589495 = query.getOrDefault("prettyPrint")
  valid_589495 = validateParameter(valid_589495, JBool, required = false,
                                 default = newJBool(true))
  if valid_589495 != nil:
    section.add "prettyPrint", valid_589495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589496: Call_CalendarColorsGet_589486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the color definitions for calendars and events.
  ## 
  let valid = call_589496.validator(path, query, header, formData, body)
  let scheme = call_589496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589496.url(scheme.get, call_589496.host, call_589496.base,
                         call_589496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589496, url, valid)

proc call*(call_589497: Call_CalendarColorsGet_589486; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## calendarColorsGet
  ## Returns the color definitions for calendars and events.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589498 = newJObject()
  add(query_589498, "fields", newJString(fields))
  add(query_589498, "quotaUser", newJString(quotaUser))
  add(query_589498, "alt", newJString(alt))
  add(query_589498, "oauth_token", newJString(oauthToken))
  add(query_589498, "userIp", newJString(userIp))
  add(query_589498, "key", newJString(key))
  add(query_589498, "prettyPrint", newJBool(prettyPrint))
  result = call_589497.call(nil, query_589498, nil, nil, nil)

var calendarColorsGet* = Call_CalendarColorsGet_589486(name: "calendarColorsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/colors",
    validator: validate_CalendarColorsGet_589487, base: "/calendar/v3",
    url: url_CalendarColorsGet_589488, schemes: {Scheme.Https})
type
  Call_CalendarFreebusyQuery_589499 = ref object of OpenApiRestCall_588457
proc url_CalendarFreebusyQuery_589501(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarFreebusyQuery_589500(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns free/busy information for a set of calendars.
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
  var valid_589502 = query.getOrDefault("fields")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "fields", valid_589502
  var valid_589503 = query.getOrDefault("quotaUser")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "quotaUser", valid_589503
  var valid_589504 = query.getOrDefault("alt")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = newJString("json"))
  if valid_589504 != nil:
    section.add "alt", valid_589504
  var valid_589505 = query.getOrDefault("oauth_token")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "oauth_token", valid_589505
  var valid_589506 = query.getOrDefault("userIp")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "userIp", valid_589506
  var valid_589507 = query.getOrDefault("key")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "key", valid_589507
  var valid_589508 = query.getOrDefault("prettyPrint")
  valid_589508 = validateParameter(valid_589508, JBool, required = false,
                                 default = newJBool(true))
  if valid_589508 != nil:
    section.add "prettyPrint", valid_589508
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

proc call*(call_589510: Call_CalendarFreebusyQuery_589499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns free/busy information for a set of calendars.
  ## 
  let valid = call_589510.validator(path, query, header, formData, body)
  let scheme = call_589510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589510.url(scheme.get, call_589510.host, call_589510.base,
                         call_589510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589510, url, valid)

proc call*(call_589511: Call_CalendarFreebusyQuery_589499; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## calendarFreebusyQuery
  ## Returns free/busy information for a set of calendars.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589512 = newJObject()
  var body_589513 = newJObject()
  add(query_589512, "fields", newJString(fields))
  add(query_589512, "quotaUser", newJString(quotaUser))
  add(query_589512, "alt", newJString(alt))
  add(query_589512, "oauth_token", newJString(oauthToken))
  add(query_589512, "userIp", newJString(userIp))
  add(query_589512, "key", newJString(key))
  if body != nil:
    body_589513 = body
  add(query_589512, "prettyPrint", newJBool(prettyPrint))
  result = call_589511.call(nil, query_589512, nil, nil, body_589513)

var calendarFreebusyQuery* = Call_CalendarFreebusyQuery_589499(
    name: "calendarFreebusyQuery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/freeBusy",
    validator: validate_CalendarFreebusyQuery_589500, base: "/calendar/v3",
    url: url_CalendarFreebusyQuery_589501, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListInsert_589533 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarListInsert_589535(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarListInsert_589534(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts an existing calendar into the user's calendar list.
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
  ##   colorRgbFormat: JBool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589536 = query.getOrDefault("fields")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "fields", valid_589536
  var valid_589537 = query.getOrDefault("quotaUser")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "quotaUser", valid_589537
  var valid_589538 = query.getOrDefault("alt")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = newJString("json"))
  if valid_589538 != nil:
    section.add "alt", valid_589538
  var valid_589539 = query.getOrDefault("colorRgbFormat")
  valid_589539 = validateParameter(valid_589539, JBool, required = false, default = nil)
  if valid_589539 != nil:
    section.add "colorRgbFormat", valid_589539
  var valid_589540 = query.getOrDefault("oauth_token")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "oauth_token", valid_589540
  var valid_589541 = query.getOrDefault("userIp")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "userIp", valid_589541
  var valid_589542 = query.getOrDefault("key")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "key", valid_589542
  var valid_589543 = query.getOrDefault("prettyPrint")
  valid_589543 = validateParameter(valid_589543, JBool, required = false,
                                 default = newJBool(true))
  if valid_589543 != nil:
    section.add "prettyPrint", valid_589543
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

proc call*(call_589545: Call_CalendarCalendarListInsert_589533; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts an existing calendar into the user's calendar list.
  ## 
  let valid = call_589545.validator(path, query, header, formData, body)
  let scheme = call_589545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589545.url(scheme.get, call_589545.host, call_589545.base,
                         call_589545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589545, url, valid)

proc call*(call_589546: Call_CalendarCalendarListInsert_589533;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          colorRgbFormat: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## calendarCalendarListInsert
  ## Inserts an existing calendar into the user's calendar list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   colorRgbFormat: bool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589547 = newJObject()
  var body_589548 = newJObject()
  add(query_589547, "fields", newJString(fields))
  add(query_589547, "quotaUser", newJString(quotaUser))
  add(query_589547, "alt", newJString(alt))
  add(query_589547, "colorRgbFormat", newJBool(colorRgbFormat))
  add(query_589547, "oauth_token", newJString(oauthToken))
  add(query_589547, "userIp", newJString(userIp))
  add(query_589547, "key", newJString(key))
  if body != nil:
    body_589548 = body
  add(query_589547, "prettyPrint", newJBool(prettyPrint))
  result = call_589546.call(nil, query_589547, nil, nil, body_589548)

var calendarCalendarListInsert* = Call_CalendarCalendarListInsert_589533(
    name: "calendarCalendarListInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/calendarList",
    validator: validate_CalendarCalendarListInsert_589534, base: "/calendar/v3",
    url: url_CalendarCalendarListInsert_589535, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListList_589514 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarListList_589516(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarListList_589515(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the calendars on the user's calendar list.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.
  ## To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   showHidden: JBool
  ##             : Whether to show hidden entries. Optional. The default is False.
  ##   showDeleted: JBool
  ##              : Whether to include deleted calendar list entries in the result. Optional. The default is False.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   minAccessRole: JString
  ##                : The minimum access role for the user in the returned entries. Optional. The default is no restriction.
  section = newJObject()
  var valid_589517 = query.getOrDefault("fields")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "fields", valid_589517
  var valid_589518 = query.getOrDefault("pageToken")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "pageToken", valid_589518
  var valid_589519 = query.getOrDefault("quotaUser")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "quotaUser", valid_589519
  var valid_589520 = query.getOrDefault("alt")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = newJString("json"))
  if valid_589520 != nil:
    section.add "alt", valid_589520
  var valid_589521 = query.getOrDefault("oauth_token")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "oauth_token", valid_589521
  var valid_589522 = query.getOrDefault("syncToken")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "syncToken", valid_589522
  var valid_589523 = query.getOrDefault("userIp")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "userIp", valid_589523
  var valid_589524 = query.getOrDefault("maxResults")
  valid_589524 = validateParameter(valid_589524, JInt, required = false, default = nil)
  if valid_589524 != nil:
    section.add "maxResults", valid_589524
  var valid_589525 = query.getOrDefault("showHidden")
  valid_589525 = validateParameter(valid_589525, JBool, required = false, default = nil)
  if valid_589525 != nil:
    section.add "showHidden", valid_589525
  var valid_589526 = query.getOrDefault("showDeleted")
  valid_589526 = validateParameter(valid_589526, JBool, required = false, default = nil)
  if valid_589526 != nil:
    section.add "showDeleted", valid_589526
  var valid_589527 = query.getOrDefault("key")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "key", valid_589527
  var valid_589528 = query.getOrDefault("prettyPrint")
  valid_589528 = validateParameter(valid_589528, JBool, required = false,
                                 default = newJBool(true))
  if valid_589528 != nil:
    section.add "prettyPrint", valid_589528
  var valid_589529 = query.getOrDefault("minAccessRole")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = newJString("freeBusyReader"))
  if valid_589529 != nil:
    section.add "minAccessRole", valid_589529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589530: Call_CalendarCalendarListList_589514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the calendars on the user's calendar list.
  ## 
  let valid = call_589530.validator(path, query, header, formData, body)
  let scheme = call_589530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589530.url(scheme.get, call_589530.host, call_589530.base,
                         call_589530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589530, url, valid)

proc call*(call_589531: Call_CalendarCalendarListList_589514; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; syncToken: string = ""; userIp: string = "";
          maxResults: int = 0; showHidden: bool = false; showDeleted: bool = false;
          key: string = ""; prettyPrint: bool = true;
          minAccessRole: string = "freeBusyReader"): Recallable =
  ## calendarCalendarListList
  ## Returns the calendars on the user's calendar list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.
  ## To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   showHidden: bool
  ##             : Whether to show hidden entries. Optional. The default is False.
  ##   showDeleted: bool
  ##              : Whether to include deleted calendar list entries in the result. Optional. The default is False.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   minAccessRole: string
  ##                : The minimum access role for the user in the returned entries. Optional. The default is no restriction.
  var query_589532 = newJObject()
  add(query_589532, "fields", newJString(fields))
  add(query_589532, "pageToken", newJString(pageToken))
  add(query_589532, "quotaUser", newJString(quotaUser))
  add(query_589532, "alt", newJString(alt))
  add(query_589532, "oauth_token", newJString(oauthToken))
  add(query_589532, "syncToken", newJString(syncToken))
  add(query_589532, "userIp", newJString(userIp))
  add(query_589532, "maxResults", newJInt(maxResults))
  add(query_589532, "showHidden", newJBool(showHidden))
  add(query_589532, "showDeleted", newJBool(showDeleted))
  add(query_589532, "key", newJString(key))
  add(query_589532, "prettyPrint", newJBool(prettyPrint))
  add(query_589532, "minAccessRole", newJString(minAccessRole))
  result = call_589531.call(nil, query_589532, nil, nil, nil)

var calendarCalendarListList* = Call_CalendarCalendarListList_589514(
    name: "calendarCalendarListList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/calendarList",
    validator: validate_CalendarCalendarListList_589515, base: "/calendar/v3",
    url: url_CalendarCalendarListList_589516, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListWatch_589549 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarListWatch_589551(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarListWatch_589550(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watch for changes to CalendarList resources.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.
  ## To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   showHidden: JBool
  ##             : Whether to show hidden entries. Optional. The default is False.
  ##   showDeleted: JBool
  ##              : Whether to include deleted calendar list entries in the result. Optional. The default is False.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   minAccessRole: JString
  ##                : The minimum access role for the user in the returned entries. Optional. The default is no restriction.
  section = newJObject()
  var valid_589552 = query.getOrDefault("fields")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = nil)
  if valid_589552 != nil:
    section.add "fields", valid_589552
  var valid_589553 = query.getOrDefault("pageToken")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "pageToken", valid_589553
  var valid_589554 = query.getOrDefault("quotaUser")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = nil)
  if valid_589554 != nil:
    section.add "quotaUser", valid_589554
  var valid_589555 = query.getOrDefault("alt")
  valid_589555 = validateParameter(valid_589555, JString, required = false,
                                 default = newJString("json"))
  if valid_589555 != nil:
    section.add "alt", valid_589555
  var valid_589556 = query.getOrDefault("oauth_token")
  valid_589556 = validateParameter(valid_589556, JString, required = false,
                                 default = nil)
  if valid_589556 != nil:
    section.add "oauth_token", valid_589556
  var valid_589557 = query.getOrDefault("syncToken")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "syncToken", valid_589557
  var valid_589558 = query.getOrDefault("userIp")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "userIp", valid_589558
  var valid_589559 = query.getOrDefault("maxResults")
  valid_589559 = validateParameter(valid_589559, JInt, required = false, default = nil)
  if valid_589559 != nil:
    section.add "maxResults", valid_589559
  var valid_589560 = query.getOrDefault("showHidden")
  valid_589560 = validateParameter(valid_589560, JBool, required = false, default = nil)
  if valid_589560 != nil:
    section.add "showHidden", valid_589560
  var valid_589561 = query.getOrDefault("showDeleted")
  valid_589561 = validateParameter(valid_589561, JBool, required = false, default = nil)
  if valid_589561 != nil:
    section.add "showDeleted", valid_589561
  var valid_589562 = query.getOrDefault("key")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "key", valid_589562
  var valid_589563 = query.getOrDefault("prettyPrint")
  valid_589563 = validateParameter(valid_589563, JBool, required = false,
                                 default = newJBool(true))
  if valid_589563 != nil:
    section.add "prettyPrint", valid_589563
  var valid_589564 = query.getOrDefault("minAccessRole")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = newJString("freeBusyReader"))
  if valid_589564 != nil:
    section.add "minAccessRole", valid_589564
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

proc call*(call_589566: Call_CalendarCalendarListWatch_589549; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to CalendarList resources.
  ## 
  let valid = call_589566.validator(path, query, header, formData, body)
  let scheme = call_589566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589566.url(scheme.get, call_589566.host, call_589566.base,
                         call_589566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589566, url, valid)

proc call*(call_589567: Call_CalendarCalendarListWatch_589549; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; syncToken: string = ""; userIp: string = "";
          maxResults: int = 0; showHidden: bool = false; showDeleted: bool = false;
          key: string = ""; resource: JsonNode = nil; prettyPrint: bool = true;
          minAccessRole: string = "freeBusyReader"): Recallable =
  ## calendarCalendarListWatch
  ## Watch for changes to CalendarList resources.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then. If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.
  ## To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   showHidden: bool
  ##             : Whether to show hidden entries. Optional. The default is False.
  ##   showDeleted: bool
  ##              : Whether to include deleted calendar list entries in the result. Optional. The default is False.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   minAccessRole: string
  ##                : The minimum access role for the user in the returned entries. Optional. The default is no restriction.
  var query_589568 = newJObject()
  var body_589569 = newJObject()
  add(query_589568, "fields", newJString(fields))
  add(query_589568, "pageToken", newJString(pageToken))
  add(query_589568, "quotaUser", newJString(quotaUser))
  add(query_589568, "alt", newJString(alt))
  add(query_589568, "oauth_token", newJString(oauthToken))
  add(query_589568, "syncToken", newJString(syncToken))
  add(query_589568, "userIp", newJString(userIp))
  add(query_589568, "maxResults", newJInt(maxResults))
  add(query_589568, "showHidden", newJBool(showHidden))
  add(query_589568, "showDeleted", newJBool(showDeleted))
  add(query_589568, "key", newJString(key))
  if resource != nil:
    body_589569 = resource
  add(query_589568, "prettyPrint", newJBool(prettyPrint))
  add(query_589568, "minAccessRole", newJString(minAccessRole))
  result = call_589567.call(nil, query_589568, nil, nil, body_589569)

var calendarCalendarListWatch* = Call_CalendarCalendarListWatch_589549(
    name: "calendarCalendarListWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/calendarList/watch",
    validator: validate_CalendarCalendarListWatch_589550, base: "/calendar/v3",
    url: url_CalendarCalendarListWatch_589551, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListUpdate_589585 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarListUpdate_589587(protocol: Scheme; host: string;
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

proc validate_CalendarCalendarListUpdate_589586(path: JsonNode; query: JsonNode;
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
  var valid_589588 = path.getOrDefault("calendarId")
  valid_589588 = validateParameter(valid_589588, JString, required = true,
                                 default = nil)
  if valid_589588 != nil:
    section.add "calendarId", valid_589588
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   colorRgbFormat: JBool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589589 = query.getOrDefault("fields")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = nil)
  if valid_589589 != nil:
    section.add "fields", valid_589589
  var valid_589590 = query.getOrDefault("quotaUser")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = nil)
  if valid_589590 != nil:
    section.add "quotaUser", valid_589590
  var valid_589591 = query.getOrDefault("alt")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = newJString("json"))
  if valid_589591 != nil:
    section.add "alt", valid_589591
  var valid_589592 = query.getOrDefault("colorRgbFormat")
  valid_589592 = validateParameter(valid_589592, JBool, required = false, default = nil)
  if valid_589592 != nil:
    section.add "colorRgbFormat", valid_589592
  var valid_589593 = query.getOrDefault("oauth_token")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = nil)
  if valid_589593 != nil:
    section.add "oauth_token", valid_589593
  var valid_589594 = query.getOrDefault("userIp")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = nil)
  if valid_589594 != nil:
    section.add "userIp", valid_589594
  var valid_589595 = query.getOrDefault("key")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = nil)
  if valid_589595 != nil:
    section.add "key", valid_589595
  var valid_589596 = query.getOrDefault("prettyPrint")
  valid_589596 = validateParameter(valid_589596, JBool, required = false,
                                 default = newJBool(true))
  if valid_589596 != nil:
    section.add "prettyPrint", valid_589596
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

proc call*(call_589598: Call_CalendarCalendarListUpdate_589585; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing calendar on the user's calendar list.
  ## 
  let valid = call_589598.validator(path, query, header, formData, body)
  let scheme = call_589598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589598.url(scheme.get, call_589598.host, call_589598.base,
                         call_589598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589598, url, valid)

proc call*(call_589599: Call_CalendarCalendarListUpdate_589585; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          colorRgbFormat: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## calendarCalendarListUpdate
  ## Updates an existing calendar on the user's calendar list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   colorRgbFormat: bool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589600 = newJObject()
  var query_589601 = newJObject()
  var body_589602 = newJObject()
  add(query_589601, "fields", newJString(fields))
  add(query_589601, "quotaUser", newJString(quotaUser))
  add(query_589601, "alt", newJString(alt))
  add(query_589601, "colorRgbFormat", newJBool(colorRgbFormat))
  add(path_589600, "calendarId", newJString(calendarId))
  add(query_589601, "oauth_token", newJString(oauthToken))
  add(query_589601, "userIp", newJString(userIp))
  add(query_589601, "key", newJString(key))
  if body != nil:
    body_589602 = body
  add(query_589601, "prettyPrint", newJBool(prettyPrint))
  result = call_589599.call(path_589600, query_589601, nil, nil, body_589602)

var calendarCalendarListUpdate* = Call_CalendarCalendarListUpdate_589585(
    name: "calendarCalendarListUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListUpdate_589586, base: "/calendar/v3",
    url: url_CalendarCalendarListUpdate_589587, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListGet_589570 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarListGet_589572(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarListGet_589571(path: JsonNode; query: JsonNode;
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
  var valid_589573 = path.getOrDefault("calendarId")
  valid_589573 = validateParameter(valid_589573, JString, required = true,
                                 default = nil)
  if valid_589573 != nil:
    section.add "calendarId", valid_589573
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
  var valid_589574 = query.getOrDefault("fields")
  valid_589574 = validateParameter(valid_589574, JString, required = false,
                                 default = nil)
  if valid_589574 != nil:
    section.add "fields", valid_589574
  var valid_589575 = query.getOrDefault("quotaUser")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = nil)
  if valid_589575 != nil:
    section.add "quotaUser", valid_589575
  var valid_589576 = query.getOrDefault("alt")
  valid_589576 = validateParameter(valid_589576, JString, required = false,
                                 default = newJString("json"))
  if valid_589576 != nil:
    section.add "alt", valid_589576
  var valid_589577 = query.getOrDefault("oauth_token")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "oauth_token", valid_589577
  var valid_589578 = query.getOrDefault("userIp")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "userIp", valid_589578
  var valid_589579 = query.getOrDefault("key")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "key", valid_589579
  var valid_589580 = query.getOrDefault("prettyPrint")
  valid_589580 = validateParameter(valid_589580, JBool, required = false,
                                 default = newJBool(true))
  if valid_589580 != nil:
    section.add "prettyPrint", valid_589580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589581: Call_CalendarCalendarListGet_589570; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a calendar from the user's calendar list.
  ## 
  let valid = call_589581.validator(path, query, header, formData, body)
  let scheme = call_589581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589581.url(scheme.get, call_589581.host, call_589581.base,
                         call_589581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589581, url, valid)

proc call*(call_589582: Call_CalendarCalendarListGet_589570; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## calendarCalendarListGet
  ## Returns a calendar from the user's calendar list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589583 = newJObject()
  var query_589584 = newJObject()
  add(query_589584, "fields", newJString(fields))
  add(query_589584, "quotaUser", newJString(quotaUser))
  add(query_589584, "alt", newJString(alt))
  add(path_589583, "calendarId", newJString(calendarId))
  add(query_589584, "oauth_token", newJString(oauthToken))
  add(query_589584, "userIp", newJString(userIp))
  add(query_589584, "key", newJString(key))
  add(query_589584, "prettyPrint", newJBool(prettyPrint))
  result = call_589582.call(path_589583, query_589584, nil, nil, nil)

var calendarCalendarListGet* = Call_CalendarCalendarListGet_589570(
    name: "calendarCalendarListGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListGet_589571, base: "/calendar/v3",
    url: url_CalendarCalendarListGet_589572, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListPatch_589618 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarListPatch_589620(protocol: Scheme; host: string;
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

proc validate_CalendarCalendarListPatch_589619(path: JsonNode; query: JsonNode;
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
  var valid_589621 = path.getOrDefault("calendarId")
  valid_589621 = validateParameter(valid_589621, JString, required = true,
                                 default = nil)
  if valid_589621 != nil:
    section.add "calendarId", valid_589621
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   colorRgbFormat: JBool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589622 = query.getOrDefault("fields")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = nil)
  if valid_589622 != nil:
    section.add "fields", valid_589622
  var valid_589623 = query.getOrDefault("quotaUser")
  valid_589623 = validateParameter(valid_589623, JString, required = false,
                                 default = nil)
  if valid_589623 != nil:
    section.add "quotaUser", valid_589623
  var valid_589624 = query.getOrDefault("alt")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = newJString("json"))
  if valid_589624 != nil:
    section.add "alt", valid_589624
  var valid_589625 = query.getOrDefault("colorRgbFormat")
  valid_589625 = validateParameter(valid_589625, JBool, required = false, default = nil)
  if valid_589625 != nil:
    section.add "colorRgbFormat", valid_589625
  var valid_589626 = query.getOrDefault("oauth_token")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "oauth_token", valid_589626
  var valid_589627 = query.getOrDefault("userIp")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = nil)
  if valid_589627 != nil:
    section.add "userIp", valid_589627
  var valid_589628 = query.getOrDefault("key")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = nil)
  if valid_589628 != nil:
    section.add "key", valid_589628
  var valid_589629 = query.getOrDefault("prettyPrint")
  valid_589629 = validateParameter(valid_589629, JBool, required = false,
                                 default = newJBool(true))
  if valid_589629 != nil:
    section.add "prettyPrint", valid_589629
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

proc call*(call_589631: Call_CalendarCalendarListPatch_589618; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing calendar on the user's calendar list. This method supports patch semantics.
  ## 
  let valid = call_589631.validator(path, query, header, formData, body)
  let scheme = call_589631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589631.url(scheme.get, call_589631.host, call_589631.base,
                         call_589631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589631, url, valid)

proc call*(call_589632: Call_CalendarCalendarListPatch_589618; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          colorRgbFormat: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## calendarCalendarListPatch
  ## Updates an existing calendar on the user's calendar list. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   colorRgbFormat: bool
  ##                 : Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically. Optional. The default is False.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589633 = newJObject()
  var query_589634 = newJObject()
  var body_589635 = newJObject()
  add(query_589634, "fields", newJString(fields))
  add(query_589634, "quotaUser", newJString(quotaUser))
  add(query_589634, "alt", newJString(alt))
  add(query_589634, "colorRgbFormat", newJBool(colorRgbFormat))
  add(path_589633, "calendarId", newJString(calendarId))
  add(query_589634, "oauth_token", newJString(oauthToken))
  add(query_589634, "userIp", newJString(userIp))
  add(query_589634, "key", newJString(key))
  if body != nil:
    body_589635 = body
  add(query_589634, "prettyPrint", newJBool(prettyPrint))
  result = call_589632.call(path_589633, query_589634, nil, nil, body_589635)

var calendarCalendarListPatch* = Call_CalendarCalendarListPatch_589618(
    name: "calendarCalendarListPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListPatch_589619, base: "/calendar/v3",
    url: url_CalendarCalendarListPatch_589620, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListDelete_589603 = ref object of OpenApiRestCall_588457
proc url_CalendarCalendarListDelete_589605(protocol: Scheme; host: string;
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

proc validate_CalendarCalendarListDelete_589604(path: JsonNode; query: JsonNode;
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
  var valid_589606 = path.getOrDefault("calendarId")
  valid_589606 = validateParameter(valid_589606, JString, required = true,
                                 default = nil)
  if valid_589606 != nil:
    section.add "calendarId", valid_589606
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
  var valid_589607 = query.getOrDefault("fields")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "fields", valid_589607
  var valid_589608 = query.getOrDefault("quotaUser")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = nil)
  if valid_589608 != nil:
    section.add "quotaUser", valid_589608
  var valid_589609 = query.getOrDefault("alt")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = newJString("json"))
  if valid_589609 != nil:
    section.add "alt", valid_589609
  var valid_589610 = query.getOrDefault("oauth_token")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = nil)
  if valid_589610 != nil:
    section.add "oauth_token", valid_589610
  var valid_589611 = query.getOrDefault("userIp")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "userIp", valid_589611
  var valid_589612 = query.getOrDefault("key")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "key", valid_589612
  var valid_589613 = query.getOrDefault("prettyPrint")
  valid_589613 = validateParameter(valid_589613, JBool, required = false,
                                 default = newJBool(true))
  if valid_589613 != nil:
    section.add "prettyPrint", valid_589613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589614: Call_CalendarCalendarListDelete_589603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a calendar from the user's calendar list.
  ## 
  let valid = call_589614.validator(path, query, header, formData, body)
  let scheme = call_589614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589614.url(scheme.get, call_589614.host, call_589614.base,
                         call_589614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589614, url, valid)

proc call*(call_589615: Call_CalendarCalendarListDelete_589603; calendarId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## calendarCalendarListDelete
  ## Removes a calendar from the user's calendar list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   calendarId: string (required)
  ##             : Calendar identifier. To retrieve calendar IDs call the calendarList.list method. If you want to access the primary calendar of the currently logged in user, use the "primary" keyword.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589616 = newJObject()
  var query_589617 = newJObject()
  add(query_589617, "fields", newJString(fields))
  add(query_589617, "quotaUser", newJString(quotaUser))
  add(query_589617, "alt", newJString(alt))
  add(path_589616, "calendarId", newJString(calendarId))
  add(query_589617, "oauth_token", newJString(oauthToken))
  add(query_589617, "userIp", newJString(userIp))
  add(query_589617, "key", newJString(key))
  add(query_589617, "prettyPrint", newJBool(prettyPrint))
  result = call_589615.call(path_589616, query_589617, nil, nil, nil)

var calendarCalendarListDelete* = Call_CalendarCalendarListDelete_589603(
    name: "calendarCalendarListDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListDelete_589604, base: "/calendar/v3",
    url: url_CalendarCalendarListDelete_589605, schemes: {Scheme.Https})
type
  Call_CalendarSettingsList_589636 = ref object of OpenApiRestCall_588457
proc url_CalendarSettingsList_589638(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarSettingsList_589637(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns all user settings for the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589639 = query.getOrDefault("fields")
  valid_589639 = validateParameter(valid_589639, JString, required = false,
                                 default = nil)
  if valid_589639 != nil:
    section.add "fields", valid_589639
  var valid_589640 = query.getOrDefault("pageToken")
  valid_589640 = validateParameter(valid_589640, JString, required = false,
                                 default = nil)
  if valid_589640 != nil:
    section.add "pageToken", valid_589640
  var valid_589641 = query.getOrDefault("quotaUser")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = nil)
  if valid_589641 != nil:
    section.add "quotaUser", valid_589641
  var valid_589642 = query.getOrDefault("alt")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = newJString("json"))
  if valid_589642 != nil:
    section.add "alt", valid_589642
  var valid_589643 = query.getOrDefault("oauth_token")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "oauth_token", valid_589643
  var valid_589644 = query.getOrDefault("syncToken")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "syncToken", valid_589644
  var valid_589645 = query.getOrDefault("userIp")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = nil)
  if valid_589645 != nil:
    section.add "userIp", valid_589645
  var valid_589646 = query.getOrDefault("maxResults")
  valid_589646 = validateParameter(valid_589646, JInt, required = false, default = nil)
  if valid_589646 != nil:
    section.add "maxResults", valid_589646
  var valid_589647 = query.getOrDefault("key")
  valid_589647 = validateParameter(valid_589647, JString, required = false,
                                 default = nil)
  if valid_589647 != nil:
    section.add "key", valid_589647
  var valid_589648 = query.getOrDefault("prettyPrint")
  valid_589648 = validateParameter(valid_589648, JBool, required = false,
                                 default = newJBool(true))
  if valid_589648 != nil:
    section.add "prettyPrint", valid_589648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589649: Call_CalendarSettingsList_589636; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all user settings for the authenticated user.
  ## 
  let valid = call_589649.validator(path, query, header, formData, body)
  let scheme = call_589649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589649.url(scheme.get, call_589649.host, call_589649.base,
                         call_589649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589649, url, valid)

proc call*(call_589650: Call_CalendarSettingsList_589636; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; syncToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## calendarSettingsList
  ## Returns all user settings for the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589651 = newJObject()
  add(query_589651, "fields", newJString(fields))
  add(query_589651, "pageToken", newJString(pageToken))
  add(query_589651, "quotaUser", newJString(quotaUser))
  add(query_589651, "alt", newJString(alt))
  add(query_589651, "oauth_token", newJString(oauthToken))
  add(query_589651, "syncToken", newJString(syncToken))
  add(query_589651, "userIp", newJString(userIp))
  add(query_589651, "maxResults", newJInt(maxResults))
  add(query_589651, "key", newJString(key))
  add(query_589651, "prettyPrint", newJBool(prettyPrint))
  result = call_589650.call(nil, query_589651, nil, nil, nil)

var calendarSettingsList* = Call_CalendarSettingsList_589636(
    name: "calendarSettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/settings",
    validator: validate_CalendarSettingsList_589637, base: "/calendar/v3",
    url: url_CalendarSettingsList_589638, schemes: {Scheme.Https})
type
  Call_CalendarSettingsWatch_589652 = ref object of OpenApiRestCall_588457
proc url_CalendarSettingsWatch_589654(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarSettingsWatch_589653(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watch for changes to Settings resources.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   syncToken: JString
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589655 = query.getOrDefault("fields")
  valid_589655 = validateParameter(valid_589655, JString, required = false,
                                 default = nil)
  if valid_589655 != nil:
    section.add "fields", valid_589655
  var valid_589656 = query.getOrDefault("pageToken")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "pageToken", valid_589656
  var valid_589657 = query.getOrDefault("quotaUser")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "quotaUser", valid_589657
  var valid_589658 = query.getOrDefault("alt")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = newJString("json"))
  if valid_589658 != nil:
    section.add "alt", valid_589658
  var valid_589659 = query.getOrDefault("oauth_token")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = nil)
  if valid_589659 != nil:
    section.add "oauth_token", valid_589659
  var valid_589660 = query.getOrDefault("syncToken")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = nil)
  if valid_589660 != nil:
    section.add "syncToken", valid_589660
  var valid_589661 = query.getOrDefault("userIp")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = nil)
  if valid_589661 != nil:
    section.add "userIp", valid_589661
  var valid_589662 = query.getOrDefault("maxResults")
  valid_589662 = validateParameter(valid_589662, JInt, required = false, default = nil)
  if valid_589662 != nil:
    section.add "maxResults", valid_589662
  var valid_589663 = query.getOrDefault("key")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "key", valid_589663
  var valid_589664 = query.getOrDefault("prettyPrint")
  valid_589664 = validateParameter(valid_589664, JBool, required = false,
                                 default = newJBool(true))
  if valid_589664 != nil:
    section.add "prettyPrint", valid_589664
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

proc call*(call_589666: Call_CalendarSettingsWatch_589652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to Settings resources.
  ## 
  let valid = call_589666.validator(path, query, header, formData, body)
  let scheme = call_589666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589666.url(scheme.get, call_589666.host, call_589666.base,
                         call_589666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589666, url, valid)

proc call*(call_589667: Call_CalendarSettingsWatch_589652; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; syncToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## calendarSettingsWatch
  ## Watch for changes to Settings resources.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token specifying which result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   syncToken: string
  ##            : Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.
  ## If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
  ## Learn more about incremental synchronization.
  ## Optional. The default is to return all entries.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of entries returned on one result page. By default the value is 100 entries. The page size can never be larger than 250 entries. Optional.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589668 = newJObject()
  var body_589669 = newJObject()
  add(query_589668, "fields", newJString(fields))
  add(query_589668, "pageToken", newJString(pageToken))
  add(query_589668, "quotaUser", newJString(quotaUser))
  add(query_589668, "alt", newJString(alt))
  add(query_589668, "oauth_token", newJString(oauthToken))
  add(query_589668, "syncToken", newJString(syncToken))
  add(query_589668, "userIp", newJString(userIp))
  add(query_589668, "maxResults", newJInt(maxResults))
  add(query_589668, "key", newJString(key))
  if resource != nil:
    body_589669 = resource
  add(query_589668, "prettyPrint", newJBool(prettyPrint))
  result = call_589667.call(nil, query_589668, nil, nil, body_589669)

var calendarSettingsWatch* = Call_CalendarSettingsWatch_589652(
    name: "calendarSettingsWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/settings/watch",
    validator: validate_CalendarSettingsWatch_589653, base: "/calendar/v3",
    url: url_CalendarSettingsWatch_589654, schemes: {Scheme.Https})
type
  Call_CalendarSettingsGet_589670 = ref object of OpenApiRestCall_588457
proc url_CalendarSettingsGet_589672(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarSettingsGet_589671(path: JsonNode; query: JsonNode;
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
  var valid_589673 = path.getOrDefault("setting")
  valid_589673 = validateParameter(valid_589673, JString, required = true,
                                 default = nil)
  if valid_589673 != nil:
    section.add "setting", valid_589673
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
  var valid_589674 = query.getOrDefault("fields")
  valid_589674 = validateParameter(valid_589674, JString, required = false,
                                 default = nil)
  if valid_589674 != nil:
    section.add "fields", valid_589674
  var valid_589675 = query.getOrDefault("quotaUser")
  valid_589675 = validateParameter(valid_589675, JString, required = false,
                                 default = nil)
  if valid_589675 != nil:
    section.add "quotaUser", valid_589675
  var valid_589676 = query.getOrDefault("alt")
  valid_589676 = validateParameter(valid_589676, JString, required = false,
                                 default = newJString("json"))
  if valid_589676 != nil:
    section.add "alt", valid_589676
  var valid_589677 = query.getOrDefault("oauth_token")
  valid_589677 = validateParameter(valid_589677, JString, required = false,
                                 default = nil)
  if valid_589677 != nil:
    section.add "oauth_token", valid_589677
  var valid_589678 = query.getOrDefault("userIp")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = nil)
  if valid_589678 != nil:
    section.add "userIp", valid_589678
  var valid_589679 = query.getOrDefault("key")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = nil)
  if valid_589679 != nil:
    section.add "key", valid_589679
  var valid_589680 = query.getOrDefault("prettyPrint")
  valid_589680 = validateParameter(valid_589680, JBool, required = false,
                                 default = newJBool(true))
  if valid_589680 != nil:
    section.add "prettyPrint", valid_589680
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589681: Call_CalendarSettingsGet_589670; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single user setting.
  ## 
  let valid = call_589681.validator(path, query, header, formData, body)
  let scheme = call_589681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589681.url(scheme.get, call_589681.host, call_589681.base,
                         call_589681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589681, url, valid)

proc call*(call_589682: Call_CalendarSettingsGet_589670; setting: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## calendarSettingsGet
  ## Returns a single user setting.
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
  ##   setting: string (required)
  ##          : The id of the user setting.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589683 = newJObject()
  var query_589684 = newJObject()
  add(query_589684, "fields", newJString(fields))
  add(query_589684, "quotaUser", newJString(quotaUser))
  add(query_589684, "alt", newJString(alt))
  add(query_589684, "oauth_token", newJString(oauthToken))
  add(query_589684, "userIp", newJString(userIp))
  add(path_589683, "setting", newJString(setting))
  add(query_589684, "key", newJString(key))
  add(query_589684, "prettyPrint", newJBool(prettyPrint))
  result = call_589682.call(path_589683, query_589684, nil, nil, nil)

var calendarSettingsGet* = Call_CalendarSettingsGet_589670(
    name: "calendarSettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/settings/{setting}",
    validator: validate_CalendarSettingsGet_589671, base: "/calendar/v3",
    url: url_CalendarSettingsGet_589672, schemes: {Scheme.Https})
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
