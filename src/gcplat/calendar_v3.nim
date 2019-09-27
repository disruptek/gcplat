
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "calendar"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CalendarCalendarsInsert_597692 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarsInsert_597694(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CalendarCalendarsInsert_597693(path: JsonNode; query: JsonNode;
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
  var valid_597806 = query.getOrDefault("fields")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "fields", valid_597806
  var valid_597807 = query.getOrDefault("quotaUser")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "quotaUser", valid_597807
  var valid_597821 = query.getOrDefault("alt")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = newJString("json"))
  if valid_597821 != nil:
    section.add "alt", valid_597821
  var valid_597822 = query.getOrDefault("oauth_token")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = nil)
  if valid_597822 != nil:
    section.add "oauth_token", valid_597822
  var valid_597823 = query.getOrDefault("userIp")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "userIp", valid_597823
  var valid_597824 = query.getOrDefault("key")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "key", valid_597824
  var valid_597825 = query.getOrDefault("prettyPrint")
  valid_597825 = validateParameter(valid_597825, JBool, required = false,
                                 default = newJBool(true))
  if valid_597825 != nil:
    section.add "prettyPrint", valid_597825
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

proc call*(call_597849: Call_CalendarCalendarsInsert_597692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a secondary calendar.
  ## 
  let valid = call_597849.validator(path, query, header, formData, body)
  let scheme = call_597849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597849.url(scheme.get, call_597849.host, call_597849.base,
                         call_597849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597849, url, valid)

proc call*(call_597920: Call_CalendarCalendarsInsert_597692; fields: string = "";
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
  var query_597921 = newJObject()
  var body_597923 = newJObject()
  add(query_597921, "fields", newJString(fields))
  add(query_597921, "quotaUser", newJString(quotaUser))
  add(query_597921, "alt", newJString(alt))
  add(query_597921, "oauth_token", newJString(oauthToken))
  add(query_597921, "userIp", newJString(userIp))
  add(query_597921, "key", newJString(key))
  if body != nil:
    body_597923 = body
  add(query_597921, "prettyPrint", newJBool(prettyPrint))
  result = call_597920.call(nil, query_597921, nil, nil, body_597923)

var calendarCalendarsInsert* = Call_CalendarCalendarsInsert_597692(
    name: "calendarCalendarsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars",
    validator: validate_CalendarCalendarsInsert_597693, base: "/calendar/v3",
    url: url_CalendarCalendarsInsert_597694, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsUpdate_597991 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarsUpdate_597993(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarsUpdate_597992(path: JsonNode; query: JsonNode;
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
  var valid_597994 = path.getOrDefault("calendarId")
  valid_597994 = validateParameter(valid_597994, JString, required = true,
                                 default = nil)
  if valid_597994 != nil:
    section.add "calendarId", valid_597994
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
  var valid_597995 = query.getOrDefault("fields")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "fields", valid_597995
  var valid_597996 = query.getOrDefault("quotaUser")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "quotaUser", valid_597996
  var valid_597997 = query.getOrDefault("alt")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = newJString("json"))
  if valid_597997 != nil:
    section.add "alt", valid_597997
  var valid_597998 = query.getOrDefault("oauth_token")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "oauth_token", valid_597998
  var valid_597999 = query.getOrDefault("userIp")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "userIp", valid_597999
  var valid_598000 = query.getOrDefault("key")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "key", valid_598000
  var valid_598001 = query.getOrDefault("prettyPrint")
  valid_598001 = validateParameter(valid_598001, JBool, required = false,
                                 default = newJBool(true))
  if valid_598001 != nil:
    section.add "prettyPrint", valid_598001
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

proc call*(call_598003: Call_CalendarCalendarsUpdate_597991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates metadata for a calendar.
  ## 
  let valid = call_598003.validator(path, query, header, formData, body)
  let scheme = call_598003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598003.url(scheme.get, call_598003.host, call_598003.base,
                         call_598003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598003, url, valid)

proc call*(call_598004: Call_CalendarCalendarsUpdate_597991; calendarId: string;
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
  var path_598005 = newJObject()
  var query_598006 = newJObject()
  var body_598007 = newJObject()
  add(query_598006, "fields", newJString(fields))
  add(query_598006, "quotaUser", newJString(quotaUser))
  add(query_598006, "alt", newJString(alt))
  add(path_598005, "calendarId", newJString(calendarId))
  add(query_598006, "oauth_token", newJString(oauthToken))
  add(query_598006, "userIp", newJString(userIp))
  add(query_598006, "key", newJString(key))
  if body != nil:
    body_598007 = body
  add(query_598006, "prettyPrint", newJBool(prettyPrint))
  result = call_598004.call(path_598005, query_598006, nil, nil, body_598007)

var calendarCalendarsUpdate* = Call_CalendarCalendarsUpdate_597991(
    name: "calendarCalendarsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsUpdate_597992, base: "/calendar/v3",
    url: url_CalendarCalendarsUpdate_597993, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsGet_597962 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarsGet_597964(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarsGet_597963(path: JsonNode; query: JsonNode;
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
  var valid_597979 = path.getOrDefault("calendarId")
  valid_597979 = validateParameter(valid_597979, JString, required = true,
                                 default = nil)
  if valid_597979 != nil:
    section.add "calendarId", valid_597979
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
  var valid_597980 = query.getOrDefault("fields")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "fields", valid_597980
  var valid_597981 = query.getOrDefault("quotaUser")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "quotaUser", valid_597981
  var valid_597982 = query.getOrDefault("alt")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = newJString("json"))
  if valid_597982 != nil:
    section.add "alt", valid_597982
  var valid_597983 = query.getOrDefault("oauth_token")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "oauth_token", valid_597983
  var valid_597984 = query.getOrDefault("userIp")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "userIp", valid_597984
  var valid_597985 = query.getOrDefault("key")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "key", valid_597985
  var valid_597986 = query.getOrDefault("prettyPrint")
  valid_597986 = validateParameter(valid_597986, JBool, required = false,
                                 default = newJBool(true))
  if valid_597986 != nil:
    section.add "prettyPrint", valid_597986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597987: Call_CalendarCalendarsGet_597962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for a calendar.
  ## 
  let valid = call_597987.validator(path, query, header, formData, body)
  let scheme = call_597987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597987.url(scheme.get, call_597987.host, call_597987.base,
                         call_597987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597987, url, valid)

proc call*(call_597988: Call_CalendarCalendarsGet_597962; calendarId: string;
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
  var path_597989 = newJObject()
  var query_597990 = newJObject()
  add(query_597990, "fields", newJString(fields))
  add(query_597990, "quotaUser", newJString(quotaUser))
  add(query_597990, "alt", newJString(alt))
  add(path_597989, "calendarId", newJString(calendarId))
  add(query_597990, "oauth_token", newJString(oauthToken))
  add(query_597990, "userIp", newJString(userIp))
  add(query_597990, "key", newJString(key))
  add(query_597990, "prettyPrint", newJBool(prettyPrint))
  result = call_597988.call(path_597989, query_597990, nil, nil, nil)

var calendarCalendarsGet* = Call_CalendarCalendarsGet_597962(
    name: "calendarCalendarsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsGet_597963, base: "/calendar/v3",
    url: url_CalendarCalendarsGet_597964, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsPatch_598023 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarsPatch_598025(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarsPatch_598024(path: JsonNode; query: JsonNode;
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
  var valid_598026 = path.getOrDefault("calendarId")
  valid_598026 = validateParameter(valid_598026, JString, required = true,
                                 default = nil)
  if valid_598026 != nil:
    section.add "calendarId", valid_598026
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
  var valid_598027 = query.getOrDefault("fields")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "fields", valid_598027
  var valid_598028 = query.getOrDefault("quotaUser")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "quotaUser", valid_598028
  var valid_598029 = query.getOrDefault("alt")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = newJString("json"))
  if valid_598029 != nil:
    section.add "alt", valid_598029
  var valid_598030 = query.getOrDefault("oauth_token")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "oauth_token", valid_598030
  var valid_598031 = query.getOrDefault("userIp")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "userIp", valid_598031
  var valid_598032 = query.getOrDefault("key")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "key", valid_598032
  var valid_598033 = query.getOrDefault("prettyPrint")
  valid_598033 = validateParameter(valid_598033, JBool, required = false,
                                 default = newJBool(true))
  if valid_598033 != nil:
    section.add "prettyPrint", valid_598033
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

proc call*(call_598035: Call_CalendarCalendarsPatch_598023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates metadata for a calendar. This method supports patch semantics.
  ## 
  let valid = call_598035.validator(path, query, header, formData, body)
  let scheme = call_598035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598035.url(scheme.get, call_598035.host, call_598035.base,
                         call_598035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598035, url, valid)

proc call*(call_598036: Call_CalendarCalendarsPatch_598023; calendarId: string;
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
  var path_598037 = newJObject()
  var query_598038 = newJObject()
  var body_598039 = newJObject()
  add(query_598038, "fields", newJString(fields))
  add(query_598038, "quotaUser", newJString(quotaUser))
  add(query_598038, "alt", newJString(alt))
  add(path_598037, "calendarId", newJString(calendarId))
  add(query_598038, "oauth_token", newJString(oauthToken))
  add(query_598038, "userIp", newJString(userIp))
  add(query_598038, "key", newJString(key))
  if body != nil:
    body_598039 = body
  add(query_598038, "prettyPrint", newJBool(prettyPrint))
  result = call_598036.call(path_598037, query_598038, nil, nil, body_598039)

var calendarCalendarsPatch* = Call_CalendarCalendarsPatch_598023(
    name: "calendarCalendarsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsPatch_598024, base: "/calendar/v3",
    url: url_CalendarCalendarsPatch_598025, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsDelete_598008 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarsDelete_598010(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/calendars/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarsDelete_598009(path: JsonNode; query: JsonNode;
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
  var valid_598011 = path.getOrDefault("calendarId")
  valid_598011 = validateParameter(valid_598011, JString, required = true,
                                 default = nil)
  if valid_598011 != nil:
    section.add "calendarId", valid_598011
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
  var valid_598012 = query.getOrDefault("fields")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "fields", valid_598012
  var valid_598013 = query.getOrDefault("quotaUser")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "quotaUser", valid_598013
  var valid_598014 = query.getOrDefault("alt")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("json"))
  if valid_598014 != nil:
    section.add "alt", valid_598014
  var valid_598015 = query.getOrDefault("oauth_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "oauth_token", valid_598015
  var valid_598016 = query.getOrDefault("userIp")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "userIp", valid_598016
  var valid_598017 = query.getOrDefault("key")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "key", valid_598017
  var valid_598018 = query.getOrDefault("prettyPrint")
  valid_598018 = validateParameter(valid_598018, JBool, required = false,
                                 default = newJBool(true))
  if valid_598018 != nil:
    section.add "prettyPrint", valid_598018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598019: Call_CalendarCalendarsDelete_598008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
  ## 
  let valid = call_598019.validator(path, query, header, formData, body)
  let scheme = call_598019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598019.url(scheme.get, call_598019.host, call_598019.base,
                         call_598019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598019, url, valid)

proc call*(call_598020: Call_CalendarCalendarsDelete_598008; calendarId: string;
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
  var path_598021 = newJObject()
  var query_598022 = newJObject()
  add(query_598022, "fields", newJString(fields))
  add(query_598022, "quotaUser", newJString(quotaUser))
  add(query_598022, "alt", newJString(alt))
  add(path_598021, "calendarId", newJString(calendarId))
  add(query_598022, "oauth_token", newJString(oauthToken))
  add(query_598022, "userIp", newJString(userIp))
  add(query_598022, "key", newJString(key))
  add(query_598022, "prettyPrint", newJBool(prettyPrint))
  result = call_598020.call(path_598021, query_598022, nil, nil, nil)

var calendarCalendarsDelete* = Call_CalendarCalendarsDelete_598008(
    name: "calendarCalendarsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsDelete_598009, base: "/calendar/v3",
    url: url_CalendarCalendarsDelete_598010, schemes: {Scheme.Https})
type
  Call_CalendarAclInsert_598059 = ref object of OpenApiRestCall_597424
proc url_CalendarAclInsert_598061(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarAclInsert_598060(path: JsonNode; query: JsonNode;
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
  var valid_598062 = path.getOrDefault("calendarId")
  valid_598062 = validateParameter(valid_598062, JString, required = true,
                                 default = nil)
  if valid_598062 != nil:
    section.add "calendarId", valid_598062
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
  var valid_598063 = query.getOrDefault("fields")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "fields", valid_598063
  var valid_598064 = query.getOrDefault("quotaUser")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "quotaUser", valid_598064
  var valid_598065 = query.getOrDefault("alt")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = newJString("json"))
  if valid_598065 != nil:
    section.add "alt", valid_598065
  var valid_598066 = query.getOrDefault("sendNotifications")
  valid_598066 = validateParameter(valid_598066, JBool, required = false, default = nil)
  if valid_598066 != nil:
    section.add "sendNotifications", valid_598066
  var valid_598067 = query.getOrDefault("oauth_token")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "oauth_token", valid_598067
  var valid_598068 = query.getOrDefault("userIp")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "userIp", valid_598068
  var valid_598069 = query.getOrDefault("key")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "key", valid_598069
  var valid_598070 = query.getOrDefault("prettyPrint")
  valid_598070 = validateParameter(valid_598070, JBool, required = false,
                                 default = newJBool(true))
  if valid_598070 != nil:
    section.add "prettyPrint", valid_598070
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

proc call*(call_598072: Call_CalendarAclInsert_598059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an access control rule.
  ## 
  let valid = call_598072.validator(path, query, header, formData, body)
  let scheme = call_598072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598072.url(scheme.get, call_598072.host, call_598072.base,
                         call_598072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598072, url, valid)

proc call*(call_598073: Call_CalendarAclInsert_598059; calendarId: string;
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
  var path_598074 = newJObject()
  var query_598075 = newJObject()
  var body_598076 = newJObject()
  add(query_598075, "fields", newJString(fields))
  add(query_598075, "quotaUser", newJString(quotaUser))
  add(query_598075, "alt", newJString(alt))
  add(path_598074, "calendarId", newJString(calendarId))
  add(query_598075, "sendNotifications", newJBool(sendNotifications))
  add(query_598075, "oauth_token", newJString(oauthToken))
  add(query_598075, "userIp", newJString(userIp))
  add(query_598075, "key", newJString(key))
  if body != nil:
    body_598076 = body
  add(query_598075, "prettyPrint", newJBool(prettyPrint))
  result = call_598073.call(path_598074, query_598075, nil, nil, body_598076)

var calendarAclInsert* = Call_CalendarAclInsert_598059(name: "calendarAclInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl", validator: validate_CalendarAclInsert_598060,
    base: "/calendar/v3", url: url_CalendarAclInsert_598061, schemes: {Scheme.Https})
type
  Call_CalendarAclList_598040 = ref object of OpenApiRestCall_597424
proc url_CalendarAclList_598042(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarAclList_598041(path: JsonNode; query: JsonNode;
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
  var valid_598043 = path.getOrDefault("calendarId")
  valid_598043 = validateParameter(valid_598043, JString, required = true,
                                 default = nil)
  if valid_598043 != nil:
    section.add "calendarId", valid_598043
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
  var valid_598044 = query.getOrDefault("fields")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = nil)
  if valid_598044 != nil:
    section.add "fields", valid_598044
  var valid_598045 = query.getOrDefault("pageToken")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "pageToken", valid_598045
  var valid_598046 = query.getOrDefault("quotaUser")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "quotaUser", valid_598046
  var valid_598047 = query.getOrDefault("alt")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = newJString("json"))
  if valid_598047 != nil:
    section.add "alt", valid_598047
  var valid_598048 = query.getOrDefault("oauth_token")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "oauth_token", valid_598048
  var valid_598049 = query.getOrDefault("syncToken")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "syncToken", valid_598049
  var valid_598050 = query.getOrDefault("userIp")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "userIp", valid_598050
  var valid_598051 = query.getOrDefault("maxResults")
  valid_598051 = validateParameter(valid_598051, JInt, required = false, default = nil)
  if valid_598051 != nil:
    section.add "maxResults", valid_598051
  var valid_598052 = query.getOrDefault("showDeleted")
  valid_598052 = validateParameter(valid_598052, JBool, required = false, default = nil)
  if valid_598052 != nil:
    section.add "showDeleted", valid_598052
  var valid_598053 = query.getOrDefault("key")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "key", valid_598053
  var valid_598054 = query.getOrDefault("prettyPrint")
  valid_598054 = validateParameter(valid_598054, JBool, required = false,
                                 default = newJBool(true))
  if valid_598054 != nil:
    section.add "prettyPrint", valid_598054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598055: Call_CalendarAclList_598040; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the rules in the access control list for the calendar.
  ## 
  let valid = call_598055.validator(path, query, header, formData, body)
  let scheme = call_598055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598055.url(scheme.get, call_598055.host, call_598055.base,
                         call_598055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598055, url, valid)

proc call*(call_598056: Call_CalendarAclList_598040; calendarId: string;
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
  var path_598057 = newJObject()
  var query_598058 = newJObject()
  add(query_598058, "fields", newJString(fields))
  add(query_598058, "pageToken", newJString(pageToken))
  add(query_598058, "quotaUser", newJString(quotaUser))
  add(query_598058, "alt", newJString(alt))
  add(path_598057, "calendarId", newJString(calendarId))
  add(query_598058, "oauth_token", newJString(oauthToken))
  add(query_598058, "syncToken", newJString(syncToken))
  add(query_598058, "userIp", newJString(userIp))
  add(query_598058, "maxResults", newJInt(maxResults))
  add(query_598058, "showDeleted", newJBool(showDeleted))
  add(query_598058, "key", newJString(key))
  add(query_598058, "prettyPrint", newJBool(prettyPrint))
  result = call_598056.call(path_598057, query_598058, nil, nil, nil)

var calendarAclList* = Call_CalendarAclList_598040(name: "calendarAclList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl", validator: validate_CalendarAclList_598041,
    base: "/calendar/v3", url: url_CalendarAclList_598042, schemes: {Scheme.Https})
type
  Call_CalendarAclWatch_598077 = ref object of OpenApiRestCall_597424
proc url_CalendarAclWatch_598079(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarAclWatch_598078(path: JsonNode; query: JsonNode;
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
  var valid_598080 = path.getOrDefault("calendarId")
  valid_598080 = validateParameter(valid_598080, JString, required = true,
                                 default = nil)
  if valid_598080 != nil:
    section.add "calendarId", valid_598080
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
  var valid_598081 = query.getOrDefault("fields")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "fields", valid_598081
  var valid_598082 = query.getOrDefault("pageToken")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "pageToken", valid_598082
  var valid_598083 = query.getOrDefault("quotaUser")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "quotaUser", valid_598083
  var valid_598084 = query.getOrDefault("alt")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = newJString("json"))
  if valid_598084 != nil:
    section.add "alt", valid_598084
  var valid_598085 = query.getOrDefault("oauth_token")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "oauth_token", valid_598085
  var valid_598086 = query.getOrDefault("syncToken")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "syncToken", valid_598086
  var valid_598087 = query.getOrDefault("userIp")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "userIp", valid_598087
  var valid_598088 = query.getOrDefault("maxResults")
  valid_598088 = validateParameter(valid_598088, JInt, required = false, default = nil)
  if valid_598088 != nil:
    section.add "maxResults", valid_598088
  var valid_598089 = query.getOrDefault("showDeleted")
  valid_598089 = validateParameter(valid_598089, JBool, required = false, default = nil)
  if valid_598089 != nil:
    section.add "showDeleted", valid_598089
  var valid_598090 = query.getOrDefault("key")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "key", valid_598090
  var valid_598091 = query.getOrDefault("prettyPrint")
  valid_598091 = validateParameter(valid_598091, JBool, required = false,
                                 default = newJBool(true))
  if valid_598091 != nil:
    section.add "prettyPrint", valid_598091
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

proc call*(call_598093: Call_CalendarAclWatch_598077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to ACL resources.
  ## 
  let valid = call_598093.validator(path, query, header, formData, body)
  let scheme = call_598093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598093.url(scheme.get, call_598093.host, call_598093.base,
                         call_598093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598093, url, valid)

proc call*(call_598094: Call_CalendarAclWatch_598077; calendarId: string;
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
  var path_598095 = newJObject()
  var query_598096 = newJObject()
  var body_598097 = newJObject()
  add(query_598096, "fields", newJString(fields))
  add(query_598096, "pageToken", newJString(pageToken))
  add(query_598096, "quotaUser", newJString(quotaUser))
  add(query_598096, "alt", newJString(alt))
  add(path_598095, "calendarId", newJString(calendarId))
  add(query_598096, "oauth_token", newJString(oauthToken))
  add(query_598096, "syncToken", newJString(syncToken))
  add(query_598096, "userIp", newJString(userIp))
  add(query_598096, "maxResults", newJInt(maxResults))
  add(query_598096, "showDeleted", newJBool(showDeleted))
  add(query_598096, "key", newJString(key))
  if resource != nil:
    body_598097 = resource
  add(query_598096, "prettyPrint", newJBool(prettyPrint))
  result = call_598094.call(path_598095, query_598096, nil, nil, body_598097)

var calendarAclWatch* = Call_CalendarAclWatch_598077(name: "calendarAclWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/watch",
    validator: validate_CalendarAclWatch_598078, base: "/calendar/v3",
    url: url_CalendarAclWatch_598079, schemes: {Scheme.Https})
type
  Call_CalendarAclUpdate_598114 = ref object of OpenApiRestCall_597424
proc url_CalendarAclUpdate_598116(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarAclUpdate_598115(path: JsonNode; query: JsonNode;
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
  var valid_598117 = path.getOrDefault("calendarId")
  valid_598117 = validateParameter(valid_598117, JString, required = true,
                                 default = nil)
  if valid_598117 != nil:
    section.add "calendarId", valid_598117
  var valid_598118 = path.getOrDefault("ruleId")
  valid_598118 = validateParameter(valid_598118, JString, required = true,
                                 default = nil)
  if valid_598118 != nil:
    section.add "ruleId", valid_598118
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
  var valid_598119 = query.getOrDefault("fields")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "fields", valid_598119
  var valid_598120 = query.getOrDefault("quotaUser")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "quotaUser", valid_598120
  var valid_598121 = query.getOrDefault("alt")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = newJString("json"))
  if valid_598121 != nil:
    section.add "alt", valid_598121
  var valid_598122 = query.getOrDefault("sendNotifications")
  valid_598122 = validateParameter(valid_598122, JBool, required = false, default = nil)
  if valid_598122 != nil:
    section.add "sendNotifications", valid_598122
  var valid_598123 = query.getOrDefault("oauth_token")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "oauth_token", valid_598123
  var valid_598124 = query.getOrDefault("userIp")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "userIp", valid_598124
  var valid_598125 = query.getOrDefault("key")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "key", valid_598125
  var valid_598126 = query.getOrDefault("prettyPrint")
  valid_598126 = validateParameter(valid_598126, JBool, required = false,
                                 default = newJBool(true))
  if valid_598126 != nil:
    section.add "prettyPrint", valid_598126
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

proc call*(call_598128: Call_CalendarAclUpdate_598114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an access control rule.
  ## 
  let valid = call_598128.validator(path, query, header, formData, body)
  let scheme = call_598128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598128.url(scheme.get, call_598128.host, call_598128.base,
                         call_598128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598128, url, valid)

proc call*(call_598129: Call_CalendarAclUpdate_598114; calendarId: string;
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
  var path_598130 = newJObject()
  var query_598131 = newJObject()
  var body_598132 = newJObject()
  add(query_598131, "fields", newJString(fields))
  add(query_598131, "quotaUser", newJString(quotaUser))
  add(query_598131, "alt", newJString(alt))
  add(path_598130, "calendarId", newJString(calendarId))
  add(query_598131, "sendNotifications", newJBool(sendNotifications))
  add(query_598131, "oauth_token", newJString(oauthToken))
  add(query_598131, "userIp", newJString(userIp))
  add(query_598131, "key", newJString(key))
  add(path_598130, "ruleId", newJString(ruleId))
  if body != nil:
    body_598132 = body
  add(query_598131, "prettyPrint", newJBool(prettyPrint))
  result = call_598129.call(path_598130, query_598131, nil, nil, body_598132)

var calendarAclUpdate* = Call_CalendarAclUpdate_598114(name: "calendarAclUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclUpdate_598115, base: "/calendar/v3",
    url: url_CalendarAclUpdate_598116, schemes: {Scheme.Https})
type
  Call_CalendarAclGet_598098 = ref object of OpenApiRestCall_597424
proc url_CalendarAclGet_598100(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarAclGet_598099(path: JsonNode; query: JsonNode;
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
  var valid_598101 = path.getOrDefault("calendarId")
  valid_598101 = validateParameter(valid_598101, JString, required = true,
                                 default = nil)
  if valid_598101 != nil:
    section.add "calendarId", valid_598101
  var valid_598102 = path.getOrDefault("ruleId")
  valid_598102 = validateParameter(valid_598102, JString, required = true,
                                 default = nil)
  if valid_598102 != nil:
    section.add "ruleId", valid_598102
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
  var valid_598103 = query.getOrDefault("fields")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "fields", valid_598103
  var valid_598104 = query.getOrDefault("quotaUser")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "quotaUser", valid_598104
  var valid_598105 = query.getOrDefault("alt")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = newJString("json"))
  if valid_598105 != nil:
    section.add "alt", valid_598105
  var valid_598106 = query.getOrDefault("oauth_token")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "oauth_token", valid_598106
  var valid_598107 = query.getOrDefault("userIp")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "userIp", valid_598107
  var valid_598108 = query.getOrDefault("key")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "key", valid_598108
  var valid_598109 = query.getOrDefault("prettyPrint")
  valid_598109 = validateParameter(valid_598109, JBool, required = false,
                                 default = newJBool(true))
  if valid_598109 != nil:
    section.add "prettyPrint", valid_598109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598110: Call_CalendarAclGet_598098; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an access control rule.
  ## 
  let valid = call_598110.validator(path, query, header, formData, body)
  let scheme = call_598110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598110.url(scheme.get, call_598110.host, call_598110.base,
                         call_598110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598110, url, valid)

proc call*(call_598111: Call_CalendarAclGet_598098; calendarId: string;
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
  var path_598112 = newJObject()
  var query_598113 = newJObject()
  add(query_598113, "fields", newJString(fields))
  add(query_598113, "quotaUser", newJString(quotaUser))
  add(query_598113, "alt", newJString(alt))
  add(path_598112, "calendarId", newJString(calendarId))
  add(query_598113, "oauth_token", newJString(oauthToken))
  add(query_598113, "userIp", newJString(userIp))
  add(query_598113, "key", newJString(key))
  add(path_598112, "ruleId", newJString(ruleId))
  add(query_598113, "prettyPrint", newJBool(prettyPrint))
  result = call_598111.call(path_598112, query_598113, nil, nil, nil)

var calendarAclGet* = Call_CalendarAclGet_598098(name: "calendarAclGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclGet_598099, base: "/calendar/v3",
    url: url_CalendarAclGet_598100, schemes: {Scheme.Https})
type
  Call_CalendarAclPatch_598149 = ref object of OpenApiRestCall_597424
proc url_CalendarAclPatch_598151(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarAclPatch_598150(path: JsonNode; query: JsonNode;
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
  var valid_598152 = path.getOrDefault("calendarId")
  valid_598152 = validateParameter(valid_598152, JString, required = true,
                                 default = nil)
  if valid_598152 != nil:
    section.add "calendarId", valid_598152
  var valid_598153 = path.getOrDefault("ruleId")
  valid_598153 = validateParameter(valid_598153, JString, required = true,
                                 default = nil)
  if valid_598153 != nil:
    section.add "ruleId", valid_598153
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
  var valid_598154 = query.getOrDefault("fields")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "fields", valid_598154
  var valid_598155 = query.getOrDefault("quotaUser")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "quotaUser", valid_598155
  var valid_598156 = query.getOrDefault("alt")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = newJString("json"))
  if valid_598156 != nil:
    section.add "alt", valid_598156
  var valid_598157 = query.getOrDefault("sendNotifications")
  valid_598157 = validateParameter(valid_598157, JBool, required = false, default = nil)
  if valid_598157 != nil:
    section.add "sendNotifications", valid_598157
  var valid_598158 = query.getOrDefault("oauth_token")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "oauth_token", valid_598158
  var valid_598159 = query.getOrDefault("userIp")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "userIp", valid_598159
  var valid_598160 = query.getOrDefault("key")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "key", valid_598160
  var valid_598161 = query.getOrDefault("prettyPrint")
  valid_598161 = validateParameter(valid_598161, JBool, required = false,
                                 default = newJBool(true))
  if valid_598161 != nil:
    section.add "prettyPrint", valid_598161
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

proc call*(call_598163: Call_CalendarAclPatch_598149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an access control rule. This method supports patch semantics.
  ## 
  let valid = call_598163.validator(path, query, header, formData, body)
  let scheme = call_598163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598163.url(scheme.get, call_598163.host, call_598163.base,
                         call_598163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598163, url, valid)

proc call*(call_598164: Call_CalendarAclPatch_598149; calendarId: string;
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
  var path_598165 = newJObject()
  var query_598166 = newJObject()
  var body_598167 = newJObject()
  add(query_598166, "fields", newJString(fields))
  add(query_598166, "quotaUser", newJString(quotaUser))
  add(query_598166, "alt", newJString(alt))
  add(path_598165, "calendarId", newJString(calendarId))
  add(query_598166, "sendNotifications", newJBool(sendNotifications))
  add(query_598166, "oauth_token", newJString(oauthToken))
  add(query_598166, "userIp", newJString(userIp))
  add(query_598166, "key", newJString(key))
  add(path_598165, "ruleId", newJString(ruleId))
  if body != nil:
    body_598167 = body
  add(query_598166, "prettyPrint", newJBool(prettyPrint))
  result = call_598164.call(path_598165, query_598166, nil, nil, body_598167)

var calendarAclPatch* = Call_CalendarAclPatch_598149(name: "calendarAclPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclPatch_598150, base: "/calendar/v3",
    url: url_CalendarAclPatch_598151, schemes: {Scheme.Https})
type
  Call_CalendarAclDelete_598133 = ref object of OpenApiRestCall_597424
proc url_CalendarAclDelete_598135(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarAclDelete_598134(path: JsonNode; query: JsonNode;
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
  var valid_598136 = path.getOrDefault("calendarId")
  valid_598136 = validateParameter(valid_598136, JString, required = true,
                                 default = nil)
  if valid_598136 != nil:
    section.add "calendarId", valid_598136
  var valid_598137 = path.getOrDefault("ruleId")
  valid_598137 = validateParameter(valid_598137, JString, required = true,
                                 default = nil)
  if valid_598137 != nil:
    section.add "ruleId", valid_598137
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
  var valid_598138 = query.getOrDefault("fields")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "fields", valid_598138
  var valid_598139 = query.getOrDefault("quotaUser")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "quotaUser", valid_598139
  var valid_598140 = query.getOrDefault("alt")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = newJString("json"))
  if valid_598140 != nil:
    section.add "alt", valid_598140
  var valid_598141 = query.getOrDefault("oauth_token")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "oauth_token", valid_598141
  var valid_598142 = query.getOrDefault("userIp")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "userIp", valid_598142
  var valid_598143 = query.getOrDefault("key")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "key", valid_598143
  var valid_598144 = query.getOrDefault("prettyPrint")
  valid_598144 = validateParameter(valid_598144, JBool, required = false,
                                 default = newJBool(true))
  if valid_598144 != nil:
    section.add "prettyPrint", valid_598144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598145: Call_CalendarAclDelete_598133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an access control rule.
  ## 
  let valid = call_598145.validator(path, query, header, formData, body)
  let scheme = call_598145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598145.url(scheme.get, call_598145.host, call_598145.base,
                         call_598145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598145, url, valid)

proc call*(call_598146: Call_CalendarAclDelete_598133; calendarId: string;
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
  var path_598147 = newJObject()
  var query_598148 = newJObject()
  add(query_598148, "fields", newJString(fields))
  add(query_598148, "quotaUser", newJString(quotaUser))
  add(query_598148, "alt", newJString(alt))
  add(path_598147, "calendarId", newJString(calendarId))
  add(query_598148, "oauth_token", newJString(oauthToken))
  add(query_598148, "userIp", newJString(userIp))
  add(query_598148, "key", newJString(key))
  add(path_598147, "ruleId", newJString(ruleId))
  add(query_598148, "prettyPrint", newJBool(prettyPrint))
  result = call_598146.call(path_598147, query_598148, nil, nil, nil)

var calendarAclDelete* = Call_CalendarAclDelete_598133(name: "calendarAclDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclDelete_598134, base: "/calendar/v3",
    url: url_CalendarAclDelete_598135, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsClear_598168 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarsClear_598170(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarCalendarsClear_598169(path: JsonNode; query: JsonNode;
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
  var valid_598171 = path.getOrDefault("calendarId")
  valid_598171 = validateParameter(valid_598171, JString, required = true,
                                 default = nil)
  if valid_598171 != nil:
    section.add "calendarId", valid_598171
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
  var valid_598172 = query.getOrDefault("fields")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = nil)
  if valid_598172 != nil:
    section.add "fields", valid_598172
  var valid_598173 = query.getOrDefault("quotaUser")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = nil)
  if valid_598173 != nil:
    section.add "quotaUser", valid_598173
  var valid_598174 = query.getOrDefault("alt")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = newJString("json"))
  if valid_598174 != nil:
    section.add "alt", valid_598174
  var valid_598175 = query.getOrDefault("oauth_token")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "oauth_token", valid_598175
  var valid_598176 = query.getOrDefault("userIp")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = nil)
  if valid_598176 != nil:
    section.add "userIp", valid_598176
  var valid_598177 = query.getOrDefault("key")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "key", valid_598177
  var valid_598178 = query.getOrDefault("prettyPrint")
  valid_598178 = validateParameter(valid_598178, JBool, required = false,
                                 default = newJBool(true))
  if valid_598178 != nil:
    section.add "prettyPrint", valid_598178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598179: Call_CalendarCalendarsClear_598168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
  ## 
  let valid = call_598179.validator(path, query, header, formData, body)
  let scheme = call_598179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598179.url(scheme.get, call_598179.host, call_598179.base,
                         call_598179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598179, url, valid)

proc call*(call_598180: Call_CalendarCalendarsClear_598168; calendarId: string;
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
  var path_598181 = newJObject()
  var query_598182 = newJObject()
  add(query_598182, "fields", newJString(fields))
  add(query_598182, "quotaUser", newJString(quotaUser))
  add(query_598182, "alt", newJString(alt))
  add(path_598181, "calendarId", newJString(calendarId))
  add(query_598182, "oauth_token", newJString(oauthToken))
  add(query_598182, "userIp", newJString(userIp))
  add(query_598182, "key", newJString(key))
  add(query_598182, "prettyPrint", newJBool(prettyPrint))
  result = call_598180.call(path_598181, query_598182, nil, nil, nil)

var calendarCalendarsClear* = Call_CalendarCalendarsClear_598168(
    name: "calendarCalendarsClear", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/clear",
    validator: validate_CalendarCalendarsClear_598169, base: "/calendar/v3",
    url: url_CalendarCalendarsClear_598170, schemes: {Scheme.Https})
type
  Call_CalendarEventsInsert_598216 = ref object of OpenApiRestCall_597424
proc url_CalendarEventsInsert_598218(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarEventsInsert_598217(path: JsonNode; query: JsonNode;
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
  var valid_598219 = path.getOrDefault("calendarId")
  valid_598219 = validateParameter(valid_598219, JString, required = true,
                                 default = nil)
  if valid_598219 != nil:
    section.add "calendarId", valid_598219
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
  var valid_598220 = query.getOrDefault("fields")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = nil)
  if valid_598220 != nil:
    section.add "fields", valid_598220
  var valid_598221 = query.getOrDefault("quotaUser")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = nil)
  if valid_598221 != nil:
    section.add "quotaUser", valid_598221
  var valid_598222 = query.getOrDefault("alt")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = newJString("json"))
  if valid_598222 != nil:
    section.add "alt", valid_598222
  var valid_598223 = query.getOrDefault("supportsAttachments")
  valid_598223 = validateParameter(valid_598223, JBool, required = false, default = nil)
  if valid_598223 != nil:
    section.add "supportsAttachments", valid_598223
  var valid_598224 = query.getOrDefault("maxAttendees")
  valid_598224 = validateParameter(valid_598224, JInt, required = false, default = nil)
  if valid_598224 != nil:
    section.add "maxAttendees", valid_598224
  var valid_598225 = query.getOrDefault("sendNotifications")
  valid_598225 = validateParameter(valid_598225, JBool, required = false, default = nil)
  if valid_598225 != nil:
    section.add "sendNotifications", valid_598225
  var valid_598226 = query.getOrDefault("oauth_token")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "oauth_token", valid_598226
  var valid_598227 = query.getOrDefault("conferenceDataVersion")
  valid_598227 = validateParameter(valid_598227, JInt, required = false, default = nil)
  if valid_598227 != nil:
    section.add "conferenceDataVersion", valid_598227
  var valid_598228 = query.getOrDefault("userIp")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "userIp", valid_598228
  var valid_598229 = query.getOrDefault("sendUpdates")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = newJString("all"))
  if valid_598229 != nil:
    section.add "sendUpdates", valid_598229
  var valid_598230 = query.getOrDefault("key")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "key", valid_598230
  var valid_598231 = query.getOrDefault("prettyPrint")
  valid_598231 = validateParameter(valid_598231, JBool, required = false,
                                 default = newJBool(true))
  if valid_598231 != nil:
    section.add "prettyPrint", valid_598231
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

proc call*(call_598233: Call_CalendarEventsInsert_598216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an event.
  ## 
  let valid = call_598233.validator(path, query, header, formData, body)
  let scheme = call_598233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598233.url(scheme.get, call_598233.host, call_598233.base,
                         call_598233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598233, url, valid)

proc call*(call_598234: Call_CalendarEventsInsert_598216; calendarId: string;
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
  var path_598235 = newJObject()
  var query_598236 = newJObject()
  var body_598237 = newJObject()
  add(query_598236, "fields", newJString(fields))
  add(query_598236, "quotaUser", newJString(quotaUser))
  add(query_598236, "alt", newJString(alt))
  add(query_598236, "supportsAttachments", newJBool(supportsAttachments))
  add(query_598236, "maxAttendees", newJInt(maxAttendees))
  add(path_598235, "calendarId", newJString(calendarId))
  add(query_598236, "sendNotifications", newJBool(sendNotifications))
  add(query_598236, "oauth_token", newJString(oauthToken))
  add(query_598236, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_598236, "userIp", newJString(userIp))
  add(query_598236, "sendUpdates", newJString(sendUpdates))
  add(query_598236, "key", newJString(key))
  if body != nil:
    body_598237 = body
  add(query_598236, "prettyPrint", newJBool(prettyPrint))
  result = call_598234.call(path_598235, query_598236, nil, nil, body_598237)

var calendarEventsInsert* = Call_CalendarEventsInsert_598216(
    name: "calendarEventsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events",
    validator: validate_CalendarEventsInsert_598217, base: "/calendar/v3",
    url: url_CalendarEventsInsert_598218, schemes: {Scheme.Https})
type
  Call_CalendarEventsList_598183 = ref object of OpenApiRestCall_597424
proc url_CalendarEventsList_598185(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarEventsList_598184(path: JsonNode; query: JsonNode;
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
  var valid_598186 = path.getOrDefault("calendarId")
  valid_598186 = validateParameter(valid_598186, JString, required = true,
                                 default = nil)
  if valid_598186 != nil:
    section.add "calendarId", valid_598186
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
  var valid_598187 = query.getOrDefault("privateExtendedProperty")
  valid_598187 = validateParameter(valid_598187, JArray, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "privateExtendedProperty", valid_598187
  var valid_598188 = query.getOrDefault("fields")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "fields", valid_598188
  var valid_598189 = query.getOrDefault("pageToken")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "pageToken", valid_598189
  var valid_598190 = query.getOrDefault("quotaUser")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "quotaUser", valid_598190
  var valid_598191 = query.getOrDefault("alt")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = newJString("json"))
  if valid_598191 != nil:
    section.add "alt", valid_598191
  var valid_598192 = query.getOrDefault("maxAttendees")
  valid_598192 = validateParameter(valid_598192, JInt, required = false, default = nil)
  if valid_598192 != nil:
    section.add "maxAttendees", valid_598192
  var valid_598193 = query.getOrDefault("showHiddenInvitations")
  valid_598193 = validateParameter(valid_598193, JBool, required = false, default = nil)
  if valid_598193 != nil:
    section.add "showHiddenInvitations", valid_598193
  var valid_598194 = query.getOrDefault("timeMax")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "timeMax", valid_598194
  var valid_598195 = query.getOrDefault("oauth_token")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "oauth_token", valid_598195
  var valid_598196 = query.getOrDefault("timeMin")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "timeMin", valid_598196
  var valid_598197 = query.getOrDefault("syncToken")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "syncToken", valid_598197
  var valid_598198 = query.getOrDefault("userIp")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = nil)
  if valid_598198 != nil:
    section.add "userIp", valid_598198
  var valid_598200 = query.getOrDefault("maxResults")
  valid_598200 = validateParameter(valid_598200, JInt, required = false,
                                 default = newJInt(250))
  if valid_598200 != nil:
    section.add "maxResults", valid_598200
  var valid_598201 = query.getOrDefault("orderBy")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = newJString("startTime"))
  if valid_598201 != nil:
    section.add "orderBy", valid_598201
  var valid_598202 = query.getOrDefault("timeZone")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "timeZone", valid_598202
  var valid_598203 = query.getOrDefault("q")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "q", valid_598203
  var valid_598204 = query.getOrDefault("iCalUID")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "iCalUID", valid_598204
  var valid_598205 = query.getOrDefault("showDeleted")
  valid_598205 = validateParameter(valid_598205, JBool, required = false, default = nil)
  if valid_598205 != nil:
    section.add "showDeleted", valid_598205
  var valid_598206 = query.getOrDefault("key")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "key", valid_598206
  var valid_598207 = query.getOrDefault("updatedMin")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "updatedMin", valid_598207
  var valid_598208 = query.getOrDefault("singleEvents")
  valid_598208 = validateParameter(valid_598208, JBool, required = false, default = nil)
  if valid_598208 != nil:
    section.add "singleEvents", valid_598208
  var valid_598209 = query.getOrDefault("sharedExtendedProperty")
  valid_598209 = validateParameter(valid_598209, JArray, required = false,
                                 default = nil)
  if valid_598209 != nil:
    section.add "sharedExtendedProperty", valid_598209
  var valid_598210 = query.getOrDefault("alwaysIncludeEmail")
  valid_598210 = validateParameter(valid_598210, JBool, required = false, default = nil)
  if valid_598210 != nil:
    section.add "alwaysIncludeEmail", valid_598210
  var valid_598211 = query.getOrDefault("prettyPrint")
  valid_598211 = validateParameter(valid_598211, JBool, required = false,
                                 default = newJBool(true))
  if valid_598211 != nil:
    section.add "prettyPrint", valid_598211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598212: Call_CalendarEventsList_598183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns events on the specified calendar.
  ## 
  let valid = call_598212.validator(path, query, header, formData, body)
  let scheme = call_598212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598212.url(scheme.get, call_598212.host, call_598212.base,
                         call_598212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598212, url, valid)

proc call*(call_598213: Call_CalendarEventsList_598183; calendarId: string;
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
  var path_598214 = newJObject()
  var query_598215 = newJObject()
  if privateExtendedProperty != nil:
    query_598215.add "privateExtendedProperty", privateExtendedProperty
  add(query_598215, "fields", newJString(fields))
  add(query_598215, "pageToken", newJString(pageToken))
  add(query_598215, "quotaUser", newJString(quotaUser))
  add(query_598215, "alt", newJString(alt))
  add(query_598215, "maxAttendees", newJInt(maxAttendees))
  add(query_598215, "showHiddenInvitations", newJBool(showHiddenInvitations))
  add(path_598214, "calendarId", newJString(calendarId))
  add(query_598215, "timeMax", newJString(timeMax))
  add(query_598215, "oauth_token", newJString(oauthToken))
  add(query_598215, "timeMin", newJString(timeMin))
  add(query_598215, "syncToken", newJString(syncToken))
  add(query_598215, "userIp", newJString(userIp))
  add(query_598215, "maxResults", newJInt(maxResults))
  add(query_598215, "orderBy", newJString(orderBy))
  add(query_598215, "timeZone", newJString(timeZone))
  add(query_598215, "q", newJString(q))
  add(query_598215, "iCalUID", newJString(iCalUID))
  add(query_598215, "showDeleted", newJBool(showDeleted))
  add(query_598215, "key", newJString(key))
  add(query_598215, "updatedMin", newJString(updatedMin))
  add(query_598215, "singleEvents", newJBool(singleEvents))
  if sharedExtendedProperty != nil:
    query_598215.add "sharedExtendedProperty", sharedExtendedProperty
  add(query_598215, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_598215, "prettyPrint", newJBool(prettyPrint))
  result = call_598213.call(path_598214, query_598215, nil, nil, nil)

var calendarEventsList* = Call_CalendarEventsList_598183(
    name: "calendarEventsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events",
    validator: validate_CalendarEventsList_598184, base: "/calendar/v3",
    url: url_CalendarEventsList_598185, schemes: {Scheme.Https})
type
  Call_CalendarEventsImport_598238 = ref object of OpenApiRestCall_597424
proc url_CalendarEventsImport_598240(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarEventsImport_598239(path: JsonNode; query: JsonNode;
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
  var valid_598241 = path.getOrDefault("calendarId")
  valid_598241 = validateParameter(valid_598241, JString, required = true,
                                 default = nil)
  if valid_598241 != nil:
    section.add "calendarId", valid_598241
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
  var valid_598242 = query.getOrDefault("fields")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = nil)
  if valid_598242 != nil:
    section.add "fields", valid_598242
  var valid_598243 = query.getOrDefault("quotaUser")
  valid_598243 = validateParameter(valid_598243, JString, required = false,
                                 default = nil)
  if valid_598243 != nil:
    section.add "quotaUser", valid_598243
  var valid_598244 = query.getOrDefault("alt")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = newJString("json"))
  if valid_598244 != nil:
    section.add "alt", valid_598244
  var valid_598245 = query.getOrDefault("supportsAttachments")
  valid_598245 = validateParameter(valid_598245, JBool, required = false, default = nil)
  if valid_598245 != nil:
    section.add "supportsAttachments", valid_598245
  var valid_598246 = query.getOrDefault("oauth_token")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "oauth_token", valid_598246
  var valid_598247 = query.getOrDefault("conferenceDataVersion")
  valid_598247 = validateParameter(valid_598247, JInt, required = false, default = nil)
  if valid_598247 != nil:
    section.add "conferenceDataVersion", valid_598247
  var valid_598248 = query.getOrDefault("userIp")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "userIp", valid_598248
  var valid_598249 = query.getOrDefault("key")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "key", valid_598249
  var valid_598250 = query.getOrDefault("prettyPrint")
  valid_598250 = validateParameter(valid_598250, JBool, required = false,
                                 default = newJBool(true))
  if valid_598250 != nil:
    section.add "prettyPrint", valid_598250
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

proc call*(call_598252: Call_CalendarEventsImport_598238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an event. This operation is used to add a private copy of an existing event to a calendar.
  ## 
  let valid = call_598252.validator(path, query, header, formData, body)
  let scheme = call_598252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598252.url(scheme.get, call_598252.host, call_598252.base,
                         call_598252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598252, url, valid)

proc call*(call_598253: Call_CalendarEventsImport_598238; calendarId: string;
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
  var path_598254 = newJObject()
  var query_598255 = newJObject()
  var body_598256 = newJObject()
  add(query_598255, "fields", newJString(fields))
  add(query_598255, "quotaUser", newJString(quotaUser))
  add(query_598255, "alt", newJString(alt))
  add(query_598255, "supportsAttachments", newJBool(supportsAttachments))
  add(path_598254, "calendarId", newJString(calendarId))
  add(query_598255, "oauth_token", newJString(oauthToken))
  add(query_598255, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_598255, "userIp", newJString(userIp))
  add(query_598255, "key", newJString(key))
  if body != nil:
    body_598256 = body
  add(query_598255, "prettyPrint", newJBool(prettyPrint))
  result = call_598253.call(path_598254, query_598255, nil, nil, body_598256)

var calendarEventsImport* = Call_CalendarEventsImport_598238(
    name: "calendarEventsImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/import",
    validator: validate_CalendarEventsImport_598239, base: "/calendar/v3",
    url: url_CalendarEventsImport_598240, schemes: {Scheme.Https})
type
  Call_CalendarEventsQuickAdd_598257 = ref object of OpenApiRestCall_597424
proc url_CalendarEventsQuickAdd_598259(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarEventsQuickAdd_598258(path: JsonNode; query: JsonNode;
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
  var valid_598260 = path.getOrDefault("calendarId")
  valid_598260 = validateParameter(valid_598260, JString, required = true,
                                 default = nil)
  if valid_598260 != nil:
    section.add "calendarId", valid_598260
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
  var valid_598261 = query.getOrDefault("fields")
  valid_598261 = validateParameter(valid_598261, JString, required = false,
                                 default = nil)
  if valid_598261 != nil:
    section.add "fields", valid_598261
  var valid_598262 = query.getOrDefault("quotaUser")
  valid_598262 = validateParameter(valid_598262, JString, required = false,
                                 default = nil)
  if valid_598262 != nil:
    section.add "quotaUser", valid_598262
  var valid_598263 = query.getOrDefault("alt")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = newJString("json"))
  if valid_598263 != nil:
    section.add "alt", valid_598263
  var valid_598264 = query.getOrDefault("sendNotifications")
  valid_598264 = validateParameter(valid_598264, JBool, required = false, default = nil)
  if valid_598264 != nil:
    section.add "sendNotifications", valid_598264
  var valid_598265 = query.getOrDefault("oauth_token")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "oauth_token", valid_598265
  var valid_598266 = query.getOrDefault("userIp")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "userIp", valid_598266
  var valid_598267 = query.getOrDefault("sendUpdates")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = newJString("all"))
  if valid_598267 != nil:
    section.add "sendUpdates", valid_598267
  var valid_598268 = query.getOrDefault("key")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "key", valid_598268
  assert query != nil, "query argument is necessary due to required `text` field"
  var valid_598269 = query.getOrDefault("text")
  valid_598269 = validateParameter(valid_598269, JString, required = true,
                                 default = nil)
  if valid_598269 != nil:
    section.add "text", valid_598269
  var valid_598270 = query.getOrDefault("prettyPrint")
  valid_598270 = validateParameter(valid_598270, JBool, required = false,
                                 default = newJBool(true))
  if valid_598270 != nil:
    section.add "prettyPrint", valid_598270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598271: Call_CalendarEventsQuickAdd_598257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an event based on a simple text string.
  ## 
  let valid = call_598271.validator(path, query, header, formData, body)
  let scheme = call_598271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598271.url(scheme.get, call_598271.host, call_598271.base,
                         call_598271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598271, url, valid)

proc call*(call_598272: Call_CalendarEventsQuickAdd_598257; calendarId: string;
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
  var path_598273 = newJObject()
  var query_598274 = newJObject()
  add(query_598274, "fields", newJString(fields))
  add(query_598274, "quotaUser", newJString(quotaUser))
  add(query_598274, "alt", newJString(alt))
  add(path_598273, "calendarId", newJString(calendarId))
  add(query_598274, "sendNotifications", newJBool(sendNotifications))
  add(query_598274, "oauth_token", newJString(oauthToken))
  add(query_598274, "userIp", newJString(userIp))
  add(query_598274, "sendUpdates", newJString(sendUpdates))
  add(query_598274, "key", newJString(key))
  add(query_598274, "text", newJString(text))
  add(query_598274, "prettyPrint", newJBool(prettyPrint))
  result = call_598272.call(path_598273, query_598274, nil, nil, nil)

var calendarEventsQuickAdd* = Call_CalendarEventsQuickAdd_598257(
    name: "calendarEventsQuickAdd", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/quickAdd",
    validator: validate_CalendarEventsQuickAdd_598258, base: "/calendar/v3",
    url: url_CalendarEventsQuickAdd_598259, schemes: {Scheme.Https})
type
  Call_CalendarEventsWatch_598275 = ref object of OpenApiRestCall_597424
proc url_CalendarEventsWatch_598277(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarEventsWatch_598276(path: JsonNode; query: JsonNode;
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
  var valid_598278 = path.getOrDefault("calendarId")
  valid_598278 = validateParameter(valid_598278, JString, required = true,
                                 default = nil)
  if valid_598278 != nil:
    section.add "calendarId", valid_598278
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
  var valid_598279 = query.getOrDefault("privateExtendedProperty")
  valid_598279 = validateParameter(valid_598279, JArray, required = false,
                                 default = nil)
  if valid_598279 != nil:
    section.add "privateExtendedProperty", valid_598279
  var valid_598280 = query.getOrDefault("fields")
  valid_598280 = validateParameter(valid_598280, JString, required = false,
                                 default = nil)
  if valid_598280 != nil:
    section.add "fields", valid_598280
  var valid_598281 = query.getOrDefault("pageToken")
  valid_598281 = validateParameter(valid_598281, JString, required = false,
                                 default = nil)
  if valid_598281 != nil:
    section.add "pageToken", valid_598281
  var valid_598282 = query.getOrDefault("quotaUser")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = nil)
  if valid_598282 != nil:
    section.add "quotaUser", valid_598282
  var valid_598283 = query.getOrDefault("alt")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = newJString("json"))
  if valid_598283 != nil:
    section.add "alt", valid_598283
  var valid_598284 = query.getOrDefault("maxAttendees")
  valid_598284 = validateParameter(valid_598284, JInt, required = false, default = nil)
  if valid_598284 != nil:
    section.add "maxAttendees", valid_598284
  var valid_598285 = query.getOrDefault("showHiddenInvitations")
  valid_598285 = validateParameter(valid_598285, JBool, required = false, default = nil)
  if valid_598285 != nil:
    section.add "showHiddenInvitations", valid_598285
  var valid_598286 = query.getOrDefault("timeMax")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "timeMax", valid_598286
  var valid_598287 = query.getOrDefault("oauth_token")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "oauth_token", valid_598287
  var valid_598288 = query.getOrDefault("timeMin")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = nil)
  if valid_598288 != nil:
    section.add "timeMin", valid_598288
  var valid_598289 = query.getOrDefault("syncToken")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "syncToken", valid_598289
  var valid_598290 = query.getOrDefault("userIp")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = nil)
  if valid_598290 != nil:
    section.add "userIp", valid_598290
  var valid_598291 = query.getOrDefault("maxResults")
  valid_598291 = validateParameter(valid_598291, JInt, required = false,
                                 default = newJInt(250))
  if valid_598291 != nil:
    section.add "maxResults", valid_598291
  var valid_598292 = query.getOrDefault("orderBy")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = newJString("startTime"))
  if valid_598292 != nil:
    section.add "orderBy", valid_598292
  var valid_598293 = query.getOrDefault("timeZone")
  valid_598293 = validateParameter(valid_598293, JString, required = false,
                                 default = nil)
  if valid_598293 != nil:
    section.add "timeZone", valid_598293
  var valid_598294 = query.getOrDefault("q")
  valid_598294 = validateParameter(valid_598294, JString, required = false,
                                 default = nil)
  if valid_598294 != nil:
    section.add "q", valid_598294
  var valid_598295 = query.getOrDefault("iCalUID")
  valid_598295 = validateParameter(valid_598295, JString, required = false,
                                 default = nil)
  if valid_598295 != nil:
    section.add "iCalUID", valid_598295
  var valid_598296 = query.getOrDefault("showDeleted")
  valid_598296 = validateParameter(valid_598296, JBool, required = false, default = nil)
  if valid_598296 != nil:
    section.add "showDeleted", valid_598296
  var valid_598297 = query.getOrDefault("key")
  valid_598297 = validateParameter(valid_598297, JString, required = false,
                                 default = nil)
  if valid_598297 != nil:
    section.add "key", valid_598297
  var valid_598298 = query.getOrDefault("updatedMin")
  valid_598298 = validateParameter(valid_598298, JString, required = false,
                                 default = nil)
  if valid_598298 != nil:
    section.add "updatedMin", valid_598298
  var valid_598299 = query.getOrDefault("singleEvents")
  valid_598299 = validateParameter(valid_598299, JBool, required = false, default = nil)
  if valid_598299 != nil:
    section.add "singleEvents", valid_598299
  var valid_598300 = query.getOrDefault("sharedExtendedProperty")
  valid_598300 = validateParameter(valid_598300, JArray, required = false,
                                 default = nil)
  if valid_598300 != nil:
    section.add "sharedExtendedProperty", valid_598300
  var valid_598301 = query.getOrDefault("alwaysIncludeEmail")
  valid_598301 = validateParameter(valid_598301, JBool, required = false, default = nil)
  if valid_598301 != nil:
    section.add "alwaysIncludeEmail", valid_598301
  var valid_598302 = query.getOrDefault("prettyPrint")
  valid_598302 = validateParameter(valid_598302, JBool, required = false,
                                 default = newJBool(true))
  if valid_598302 != nil:
    section.add "prettyPrint", valid_598302
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

proc call*(call_598304: Call_CalendarEventsWatch_598275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to Events resources.
  ## 
  let valid = call_598304.validator(path, query, header, formData, body)
  let scheme = call_598304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598304.url(scheme.get, call_598304.host, call_598304.base,
                         call_598304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598304, url, valid)

proc call*(call_598305: Call_CalendarEventsWatch_598275; calendarId: string;
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
  var path_598306 = newJObject()
  var query_598307 = newJObject()
  var body_598308 = newJObject()
  if privateExtendedProperty != nil:
    query_598307.add "privateExtendedProperty", privateExtendedProperty
  add(query_598307, "fields", newJString(fields))
  add(query_598307, "pageToken", newJString(pageToken))
  add(query_598307, "quotaUser", newJString(quotaUser))
  add(query_598307, "alt", newJString(alt))
  add(query_598307, "maxAttendees", newJInt(maxAttendees))
  add(query_598307, "showHiddenInvitations", newJBool(showHiddenInvitations))
  add(path_598306, "calendarId", newJString(calendarId))
  add(query_598307, "timeMax", newJString(timeMax))
  add(query_598307, "oauth_token", newJString(oauthToken))
  add(query_598307, "timeMin", newJString(timeMin))
  add(query_598307, "syncToken", newJString(syncToken))
  add(query_598307, "userIp", newJString(userIp))
  add(query_598307, "maxResults", newJInt(maxResults))
  add(query_598307, "orderBy", newJString(orderBy))
  add(query_598307, "timeZone", newJString(timeZone))
  add(query_598307, "q", newJString(q))
  add(query_598307, "iCalUID", newJString(iCalUID))
  add(query_598307, "showDeleted", newJBool(showDeleted))
  add(query_598307, "key", newJString(key))
  add(query_598307, "updatedMin", newJString(updatedMin))
  add(query_598307, "singleEvents", newJBool(singleEvents))
  if sharedExtendedProperty != nil:
    query_598307.add "sharedExtendedProperty", sharedExtendedProperty
  if resource != nil:
    body_598308 = resource
  add(query_598307, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_598307, "prettyPrint", newJBool(prettyPrint))
  result = call_598305.call(path_598306, query_598307, nil, nil, body_598308)

var calendarEventsWatch* = Call_CalendarEventsWatch_598275(
    name: "calendarEventsWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/watch",
    validator: validate_CalendarEventsWatch_598276, base: "/calendar/v3",
    url: url_CalendarEventsWatch_598277, schemes: {Scheme.Https})
type
  Call_CalendarEventsUpdate_598328 = ref object of OpenApiRestCall_597424
proc url_CalendarEventsUpdate_598330(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarEventsUpdate_598329(path: JsonNode; query: JsonNode;
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
  var valid_598331 = path.getOrDefault("calendarId")
  valid_598331 = validateParameter(valid_598331, JString, required = true,
                                 default = nil)
  if valid_598331 != nil:
    section.add "calendarId", valid_598331
  var valid_598332 = path.getOrDefault("eventId")
  valid_598332 = validateParameter(valid_598332, JString, required = true,
                                 default = nil)
  if valid_598332 != nil:
    section.add "eventId", valid_598332
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
  var valid_598333 = query.getOrDefault("fields")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "fields", valid_598333
  var valid_598334 = query.getOrDefault("quotaUser")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = nil)
  if valid_598334 != nil:
    section.add "quotaUser", valid_598334
  var valid_598335 = query.getOrDefault("alt")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = newJString("json"))
  if valid_598335 != nil:
    section.add "alt", valid_598335
  var valid_598336 = query.getOrDefault("supportsAttachments")
  valid_598336 = validateParameter(valid_598336, JBool, required = false, default = nil)
  if valid_598336 != nil:
    section.add "supportsAttachments", valid_598336
  var valid_598337 = query.getOrDefault("maxAttendees")
  valid_598337 = validateParameter(valid_598337, JInt, required = false, default = nil)
  if valid_598337 != nil:
    section.add "maxAttendees", valid_598337
  var valid_598338 = query.getOrDefault("sendNotifications")
  valid_598338 = validateParameter(valid_598338, JBool, required = false, default = nil)
  if valid_598338 != nil:
    section.add "sendNotifications", valid_598338
  var valid_598339 = query.getOrDefault("oauth_token")
  valid_598339 = validateParameter(valid_598339, JString, required = false,
                                 default = nil)
  if valid_598339 != nil:
    section.add "oauth_token", valid_598339
  var valid_598340 = query.getOrDefault("conferenceDataVersion")
  valid_598340 = validateParameter(valid_598340, JInt, required = false, default = nil)
  if valid_598340 != nil:
    section.add "conferenceDataVersion", valid_598340
  var valid_598341 = query.getOrDefault("userIp")
  valid_598341 = validateParameter(valid_598341, JString, required = false,
                                 default = nil)
  if valid_598341 != nil:
    section.add "userIp", valid_598341
  var valid_598342 = query.getOrDefault("sendUpdates")
  valid_598342 = validateParameter(valid_598342, JString, required = false,
                                 default = newJString("all"))
  if valid_598342 != nil:
    section.add "sendUpdates", valid_598342
  var valid_598343 = query.getOrDefault("key")
  valid_598343 = validateParameter(valid_598343, JString, required = false,
                                 default = nil)
  if valid_598343 != nil:
    section.add "key", valid_598343
  var valid_598344 = query.getOrDefault("alwaysIncludeEmail")
  valid_598344 = validateParameter(valid_598344, JBool, required = false, default = nil)
  if valid_598344 != nil:
    section.add "alwaysIncludeEmail", valid_598344
  var valid_598345 = query.getOrDefault("prettyPrint")
  valid_598345 = validateParameter(valid_598345, JBool, required = false,
                                 default = newJBool(true))
  if valid_598345 != nil:
    section.add "prettyPrint", valid_598345
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

proc call*(call_598347: Call_CalendarEventsUpdate_598328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an event.
  ## 
  let valid = call_598347.validator(path, query, header, formData, body)
  let scheme = call_598347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598347.url(scheme.get, call_598347.host, call_598347.base,
                         call_598347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598347, url, valid)

proc call*(call_598348: Call_CalendarEventsUpdate_598328; calendarId: string;
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
  var path_598349 = newJObject()
  var query_598350 = newJObject()
  var body_598351 = newJObject()
  add(query_598350, "fields", newJString(fields))
  add(query_598350, "quotaUser", newJString(quotaUser))
  add(query_598350, "alt", newJString(alt))
  add(query_598350, "supportsAttachments", newJBool(supportsAttachments))
  add(query_598350, "maxAttendees", newJInt(maxAttendees))
  add(path_598349, "calendarId", newJString(calendarId))
  add(query_598350, "sendNotifications", newJBool(sendNotifications))
  add(query_598350, "oauth_token", newJString(oauthToken))
  add(query_598350, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_598350, "userIp", newJString(userIp))
  add(query_598350, "sendUpdates", newJString(sendUpdates))
  add(path_598349, "eventId", newJString(eventId))
  add(query_598350, "key", newJString(key))
  add(query_598350, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if body != nil:
    body_598351 = body
  add(query_598350, "prettyPrint", newJBool(prettyPrint))
  result = call_598348.call(path_598349, query_598350, nil, nil, body_598351)

var calendarEventsUpdate* = Call_CalendarEventsUpdate_598328(
    name: "calendarEventsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsUpdate_598329, base: "/calendar/v3",
    url: url_CalendarEventsUpdate_598330, schemes: {Scheme.Https})
type
  Call_CalendarEventsGet_598309 = ref object of OpenApiRestCall_597424
proc url_CalendarEventsGet_598311(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarEventsGet_598310(path: JsonNode; query: JsonNode;
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
  var valid_598312 = path.getOrDefault("calendarId")
  valid_598312 = validateParameter(valid_598312, JString, required = true,
                                 default = nil)
  if valid_598312 != nil:
    section.add "calendarId", valid_598312
  var valid_598313 = path.getOrDefault("eventId")
  valid_598313 = validateParameter(valid_598313, JString, required = true,
                                 default = nil)
  if valid_598313 != nil:
    section.add "eventId", valid_598313
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
  var valid_598314 = query.getOrDefault("fields")
  valid_598314 = validateParameter(valid_598314, JString, required = false,
                                 default = nil)
  if valid_598314 != nil:
    section.add "fields", valid_598314
  var valid_598315 = query.getOrDefault("quotaUser")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "quotaUser", valid_598315
  var valid_598316 = query.getOrDefault("alt")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = newJString("json"))
  if valid_598316 != nil:
    section.add "alt", valid_598316
  var valid_598317 = query.getOrDefault("maxAttendees")
  valid_598317 = validateParameter(valid_598317, JInt, required = false, default = nil)
  if valid_598317 != nil:
    section.add "maxAttendees", valid_598317
  var valid_598318 = query.getOrDefault("oauth_token")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = nil)
  if valid_598318 != nil:
    section.add "oauth_token", valid_598318
  var valid_598319 = query.getOrDefault("userIp")
  valid_598319 = validateParameter(valid_598319, JString, required = false,
                                 default = nil)
  if valid_598319 != nil:
    section.add "userIp", valid_598319
  var valid_598320 = query.getOrDefault("timeZone")
  valid_598320 = validateParameter(valid_598320, JString, required = false,
                                 default = nil)
  if valid_598320 != nil:
    section.add "timeZone", valid_598320
  var valid_598321 = query.getOrDefault("key")
  valid_598321 = validateParameter(valid_598321, JString, required = false,
                                 default = nil)
  if valid_598321 != nil:
    section.add "key", valid_598321
  var valid_598322 = query.getOrDefault("alwaysIncludeEmail")
  valid_598322 = validateParameter(valid_598322, JBool, required = false, default = nil)
  if valid_598322 != nil:
    section.add "alwaysIncludeEmail", valid_598322
  var valid_598323 = query.getOrDefault("prettyPrint")
  valid_598323 = validateParameter(valid_598323, JBool, required = false,
                                 default = newJBool(true))
  if valid_598323 != nil:
    section.add "prettyPrint", valid_598323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598324: Call_CalendarEventsGet_598309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an event.
  ## 
  let valid = call_598324.validator(path, query, header, formData, body)
  let scheme = call_598324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598324.url(scheme.get, call_598324.host, call_598324.base,
                         call_598324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598324, url, valid)

proc call*(call_598325: Call_CalendarEventsGet_598309; calendarId: string;
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
  var path_598326 = newJObject()
  var query_598327 = newJObject()
  add(query_598327, "fields", newJString(fields))
  add(query_598327, "quotaUser", newJString(quotaUser))
  add(query_598327, "alt", newJString(alt))
  add(query_598327, "maxAttendees", newJInt(maxAttendees))
  add(path_598326, "calendarId", newJString(calendarId))
  add(query_598327, "oauth_token", newJString(oauthToken))
  add(query_598327, "userIp", newJString(userIp))
  add(query_598327, "timeZone", newJString(timeZone))
  add(path_598326, "eventId", newJString(eventId))
  add(query_598327, "key", newJString(key))
  add(query_598327, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_598327, "prettyPrint", newJBool(prettyPrint))
  result = call_598325.call(path_598326, query_598327, nil, nil, nil)

var calendarEventsGet* = Call_CalendarEventsGet_598309(name: "calendarEventsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsGet_598310, base: "/calendar/v3",
    url: url_CalendarEventsGet_598311, schemes: {Scheme.Https})
type
  Call_CalendarEventsPatch_598370 = ref object of OpenApiRestCall_597424
proc url_CalendarEventsPatch_598372(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarEventsPatch_598371(path: JsonNode; query: JsonNode;
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
  var valid_598373 = path.getOrDefault("calendarId")
  valid_598373 = validateParameter(valid_598373, JString, required = true,
                                 default = nil)
  if valid_598373 != nil:
    section.add "calendarId", valid_598373
  var valid_598374 = path.getOrDefault("eventId")
  valid_598374 = validateParameter(valid_598374, JString, required = true,
                                 default = nil)
  if valid_598374 != nil:
    section.add "eventId", valid_598374
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
  var valid_598375 = query.getOrDefault("fields")
  valid_598375 = validateParameter(valid_598375, JString, required = false,
                                 default = nil)
  if valid_598375 != nil:
    section.add "fields", valid_598375
  var valid_598376 = query.getOrDefault("quotaUser")
  valid_598376 = validateParameter(valid_598376, JString, required = false,
                                 default = nil)
  if valid_598376 != nil:
    section.add "quotaUser", valid_598376
  var valid_598377 = query.getOrDefault("alt")
  valid_598377 = validateParameter(valid_598377, JString, required = false,
                                 default = newJString("json"))
  if valid_598377 != nil:
    section.add "alt", valid_598377
  var valid_598378 = query.getOrDefault("supportsAttachments")
  valid_598378 = validateParameter(valid_598378, JBool, required = false, default = nil)
  if valid_598378 != nil:
    section.add "supportsAttachments", valid_598378
  var valid_598379 = query.getOrDefault("maxAttendees")
  valid_598379 = validateParameter(valid_598379, JInt, required = false, default = nil)
  if valid_598379 != nil:
    section.add "maxAttendees", valid_598379
  var valid_598380 = query.getOrDefault("sendNotifications")
  valid_598380 = validateParameter(valid_598380, JBool, required = false, default = nil)
  if valid_598380 != nil:
    section.add "sendNotifications", valid_598380
  var valid_598381 = query.getOrDefault("oauth_token")
  valid_598381 = validateParameter(valid_598381, JString, required = false,
                                 default = nil)
  if valid_598381 != nil:
    section.add "oauth_token", valid_598381
  var valid_598382 = query.getOrDefault("conferenceDataVersion")
  valid_598382 = validateParameter(valid_598382, JInt, required = false, default = nil)
  if valid_598382 != nil:
    section.add "conferenceDataVersion", valid_598382
  var valid_598383 = query.getOrDefault("userIp")
  valid_598383 = validateParameter(valid_598383, JString, required = false,
                                 default = nil)
  if valid_598383 != nil:
    section.add "userIp", valid_598383
  var valid_598384 = query.getOrDefault("sendUpdates")
  valid_598384 = validateParameter(valid_598384, JString, required = false,
                                 default = newJString("all"))
  if valid_598384 != nil:
    section.add "sendUpdates", valid_598384
  var valid_598385 = query.getOrDefault("key")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "key", valid_598385
  var valid_598386 = query.getOrDefault("alwaysIncludeEmail")
  valid_598386 = validateParameter(valid_598386, JBool, required = false, default = nil)
  if valid_598386 != nil:
    section.add "alwaysIncludeEmail", valid_598386
  var valid_598387 = query.getOrDefault("prettyPrint")
  valid_598387 = validateParameter(valid_598387, JBool, required = false,
                                 default = newJBool(true))
  if valid_598387 != nil:
    section.add "prettyPrint", valid_598387
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

proc call*(call_598389: Call_CalendarEventsPatch_598370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an event. This method supports patch semantics.
  ## 
  let valid = call_598389.validator(path, query, header, formData, body)
  let scheme = call_598389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598389.url(scheme.get, call_598389.host, call_598389.base,
                         call_598389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598389, url, valid)

proc call*(call_598390: Call_CalendarEventsPatch_598370; calendarId: string;
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
  var path_598391 = newJObject()
  var query_598392 = newJObject()
  var body_598393 = newJObject()
  add(query_598392, "fields", newJString(fields))
  add(query_598392, "quotaUser", newJString(quotaUser))
  add(query_598392, "alt", newJString(alt))
  add(query_598392, "supportsAttachments", newJBool(supportsAttachments))
  add(query_598392, "maxAttendees", newJInt(maxAttendees))
  add(path_598391, "calendarId", newJString(calendarId))
  add(query_598392, "sendNotifications", newJBool(sendNotifications))
  add(query_598392, "oauth_token", newJString(oauthToken))
  add(query_598392, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_598392, "userIp", newJString(userIp))
  add(query_598392, "sendUpdates", newJString(sendUpdates))
  add(path_598391, "eventId", newJString(eventId))
  add(query_598392, "key", newJString(key))
  add(query_598392, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if body != nil:
    body_598393 = body
  add(query_598392, "prettyPrint", newJBool(prettyPrint))
  result = call_598390.call(path_598391, query_598392, nil, nil, body_598393)

var calendarEventsPatch* = Call_CalendarEventsPatch_598370(
    name: "calendarEventsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsPatch_598371, base: "/calendar/v3",
    url: url_CalendarEventsPatch_598372, schemes: {Scheme.Https})
type
  Call_CalendarEventsDelete_598352 = ref object of OpenApiRestCall_597424
proc url_CalendarEventsDelete_598354(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarEventsDelete_598353(path: JsonNode; query: JsonNode;
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
  var valid_598355 = path.getOrDefault("calendarId")
  valid_598355 = validateParameter(valid_598355, JString, required = true,
                                 default = nil)
  if valid_598355 != nil:
    section.add "calendarId", valid_598355
  var valid_598356 = path.getOrDefault("eventId")
  valid_598356 = validateParameter(valid_598356, JString, required = true,
                                 default = nil)
  if valid_598356 != nil:
    section.add "eventId", valid_598356
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
  var valid_598357 = query.getOrDefault("fields")
  valid_598357 = validateParameter(valid_598357, JString, required = false,
                                 default = nil)
  if valid_598357 != nil:
    section.add "fields", valid_598357
  var valid_598358 = query.getOrDefault("quotaUser")
  valid_598358 = validateParameter(valid_598358, JString, required = false,
                                 default = nil)
  if valid_598358 != nil:
    section.add "quotaUser", valid_598358
  var valid_598359 = query.getOrDefault("alt")
  valid_598359 = validateParameter(valid_598359, JString, required = false,
                                 default = newJString("json"))
  if valid_598359 != nil:
    section.add "alt", valid_598359
  var valid_598360 = query.getOrDefault("sendNotifications")
  valid_598360 = validateParameter(valid_598360, JBool, required = false, default = nil)
  if valid_598360 != nil:
    section.add "sendNotifications", valid_598360
  var valid_598361 = query.getOrDefault("oauth_token")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = nil)
  if valid_598361 != nil:
    section.add "oauth_token", valid_598361
  var valid_598362 = query.getOrDefault("userIp")
  valid_598362 = validateParameter(valid_598362, JString, required = false,
                                 default = nil)
  if valid_598362 != nil:
    section.add "userIp", valid_598362
  var valid_598363 = query.getOrDefault("sendUpdates")
  valid_598363 = validateParameter(valid_598363, JString, required = false,
                                 default = newJString("all"))
  if valid_598363 != nil:
    section.add "sendUpdates", valid_598363
  var valid_598364 = query.getOrDefault("key")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = nil)
  if valid_598364 != nil:
    section.add "key", valid_598364
  var valid_598365 = query.getOrDefault("prettyPrint")
  valid_598365 = validateParameter(valid_598365, JBool, required = false,
                                 default = newJBool(true))
  if valid_598365 != nil:
    section.add "prettyPrint", valid_598365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598366: Call_CalendarEventsDelete_598352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an event.
  ## 
  let valid = call_598366.validator(path, query, header, formData, body)
  let scheme = call_598366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598366.url(scheme.get, call_598366.host, call_598366.base,
                         call_598366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598366, url, valid)

proc call*(call_598367: Call_CalendarEventsDelete_598352; calendarId: string;
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
  var path_598368 = newJObject()
  var query_598369 = newJObject()
  add(query_598369, "fields", newJString(fields))
  add(query_598369, "quotaUser", newJString(quotaUser))
  add(query_598369, "alt", newJString(alt))
  add(path_598368, "calendarId", newJString(calendarId))
  add(query_598369, "sendNotifications", newJBool(sendNotifications))
  add(query_598369, "oauth_token", newJString(oauthToken))
  add(query_598369, "userIp", newJString(userIp))
  add(query_598369, "sendUpdates", newJString(sendUpdates))
  add(path_598368, "eventId", newJString(eventId))
  add(query_598369, "key", newJString(key))
  add(query_598369, "prettyPrint", newJBool(prettyPrint))
  result = call_598367.call(path_598368, query_598369, nil, nil, nil)

var calendarEventsDelete* = Call_CalendarEventsDelete_598352(
    name: "calendarEventsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsDelete_598353, base: "/calendar/v3",
    url: url_CalendarEventsDelete_598354, schemes: {Scheme.Https})
type
  Call_CalendarEventsInstances_598394 = ref object of OpenApiRestCall_597424
proc url_CalendarEventsInstances_598396(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarEventsInstances_598395(path: JsonNode; query: JsonNode;
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
  var valid_598397 = path.getOrDefault("calendarId")
  valid_598397 = validateParameter(valid_598397, JString, required = true,
                                 default = nil)
  if valid_598397 != nil:
    section.add "calendarId", valid_598397
  var valid_598398 = path.getOrDefault("eventId")
  valid_598398 = validateParameter(valid_598398, JString, required = true,
                                 default = nil)
  if valid_598398 != nil:
    section.add "eventId", valid_598398
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
  var valid_598399 = query.getOrDefault("fields")
  valid_598399 = validateParameter(valid_598399, JString, required = false,
                                 default = nil)
  if valid_598399 != nil:
    section.add "fields", valid_598399
  var valid_598400 = query.getOrDefault("pageToken")
  valid_598400 = validateParameter(valid_598400, JString, required = false,
                                 default = nil)
  if valid_598400 != nil:
    section.add "pageToken", valid_598400
  var valid_598401 = query.getOrDefault("quotaUser")
  valid_598401 = validateParameter(valid_598401, JString, required = false,
                                 default = nil)
  if valid_598401 != nil:
    section.add "quotaUser", valid_598401
  var valid_598402 = query.getOrDefault("originalStart")
  valid_598402 = validateParameter(valid_598402, JString, required = false,
                                 default = nil)
  if valid_598402 != nil:
    section.add "originalStart", valid_598402
  var valid_598403 = query.getOrDefault("alt")
  valid_598403 = validateParameter(valid_598403, JString, required = false,
                                 default = newJString("json"))
  if valid_598403 != nil:
    section.add "alt", valid_598403
  var valid_598404 = query.getOrDefault("maxAttendees")
  valid_598404 = validateParameter(valid_598404, JInt, required = false, default = nil)
  if valid_598404 != nil:
    section.add "maxAttendees", valid_598404
  var valid_598405 = query.getOrDefault("timeMax")
  valid_598405 = validateParameter(valid_598405, JString, required = false,
                                 default = nil)
  if valid_598405 != nil:
    section.add "timeMax", valid_598405
  var valid_598406 = query.getOrDefault("oauth_token")
  valid_598406 = validateParameter(valid_598406, JString, required = false,
                                 default = nil)
  if valid_598406 != nil:
    section.add "oauth_token", valid_598406
  var valid_598407 = query.getOrDefault("timeMin")
  valid_598407 = validateParameter(valid_598407, JString, required = false,
                                 default = nil)
  if valid_598407 != nil:
    section.add "timeMin", valid_598407
  var valid_598408 = query.getOrDefault("userIp")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = nil)
  if valid_598408 != nil:
    section.add "userIp", valid_598408
  var valid_598409 = query.getOrDefault("maxResults")
  valid_598409 = validateParameter(valid_598409, JInt, required = false, default = nil)
  if valid_598409 != nil:
    section.add "maxResults", valid_598409
  var valid_598410 = query.getOrDefault("timeZone")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = nil)
  if valid_598410 != nil:
    section.add "timeZone", valid_598410
  var valid_598411 = query.getOrDefault("showDeleted")
  valid_598411 = validateParameter(valid_598411, JBool, required = false, default = nil)
  if valid_598411 != nil:
    section.add "showDeleted", valid_598411
  var valid_598412 = query.getOrDefault("key")
  valid_598412 = validateParameter(valid_598412, JString, required = false,
                                 default = nil)
  if valid_598412 != nil:
    section.add "key", valid_598412
  var valid_598413 = query.getOrDefault("alwaysIncludeEmail")
  valid_598413 = validateParameter(valid_598413, JBool, required = false, default = nil)
  if valid_598413 != nil:
    section.add "alwaysIncludeEmail", valid_598413
  var valid_598414 = query.getOrDefault("prettyPrint")
  valid_598414 = validateParameter(valid_598414, JBool, required = false,
                                 default = newJBool(true))
  if valid_598414 != nil:
    section.add "prettyPrint", valid_598414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598415: Call_CalendarEventsInstances_598394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns instances of the specified recurring event.
  ## 
  let valid = call_598415.validator(path, query, header, formData, body)
  let scheme = call_598415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598415.url(scheme.get, call_598415.host, call_598415.base,
                         call_598415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598415, url, valid)

proc call*(call_598416: Call_CalendarEventsInstances_598394; calendarId: string;
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
  var path_598417 = newJObject()
  var query_598418 = newJObject()
  add(query_598418, "fields", newJString(fields))
  add(query_598418, "pageToken", newJString(pageToken))
  add(query_598418, "quotaUser", newJString(quotaUser))
  add(query_598418, "originalStart", newJString(originalStart))
  add(query_598418, "alt", newJString(alt))
  add(query_598418, "maxAttendees", newJInt(maxAttendees))
  add(path_598417, "calendarId", newJString(calendarId))
  add(query_598418, "timeMax", newJString(timeMax))
  add(query_598418, "oauth_token", newJString(oauthToken))
  add(query_598418, "timeMin", newJString(timeMin))
  add(query_598418, "userIp", newJString(userIp))
  add(query_598418, "maxResults", newJInt(maxResults))
  add(query_598418, "timeZone", newJString(timeZone))
  add(query_598418, "showDeleted", newJBool(showDeleted))
  add(path_598417, "eventId", newJString(eventId))
  add(query_598418, "key", newJString(key))
  add(query_598418, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_598418, "prettyPrint", newJBool(prettyPrint))
  result = call_598416.call(path_598417, query_598418, nil, nil, nil)

var calendarEventsInstances* = Call_CalendarEventsInstances_598394(
    name: "calendarEventsInstances", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}/instances",
    validator: validate_CalendarEventsInstances_598395, base: "/calendar/v3",
    url: url_CalendarEventsInstances_598396, schemes: {Scheme.Https})
type
  Call_CalendarEventsMove_598419 = ref object of OpenApiRestCall_597424
proc url_CalendarEventsMove_598421(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CalendarEventsMove_598420(path: JsonNode; query: JsonNode;
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
  var valid_598422 = path.getOrDefault("calendarId")
  valid_598422 = validateParameter(valid_598422, JString, required = true,
                                 default = nil)
  if valid_598422 != nil:
    section.add "calendarId", valid_598422
  var valid_598423 = path.getOrDefault("eventId")
  valid_598423 = validateParameter(valid_598423, JString, required = true,
                                 default = nil)
  if valid_598423 != nil:
    section.add "eventId", valid_598423
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
  var valid_598424 = query.getOrDefault("fields")
  valid_598424 = validateParameter(valid_598424, JString, required = false,
                                 default = nil)
  if valid_598424 != nil:
    section.add "fields", valid_598424
  var valid_598425 = query.getOrDefault("quotaUser")
  valid_598425 = validateParameter(valid_598425, JString, required = false,
                                 default = nil)
  if valid_598425 != nil:
    section.add "quotaUser", valid_598425
  var valid_598426 = query.getOrDefault("alt")
  valid_598426 = validateParameter(valid_598426, JString, required = false,
                                 default = newJString("json"))
  if valid_598426 != nil:
    section.add "alt", valid_598426
  var valid_598427 = query.getOrDefault("sendNotifications")
  valid_598427 = validateParameter(valid_598427, JBool, required = false, default = nil)
  if valid_598427 != nil:
    section.add "sendNotifications", valid_598427
  var valid_598428 = query.getOrDefault("oauth_token")
  valid_598428 = validateParameter(valid_598428, JString, required = false,
                                 default = nil)
  if valid_598428 != nil:
    section.add "oauth_token", valid_598428
  var valid_598429 = query.getOrDefault("userIp")
  valid_598429 = validateParameter(valid_598429, JString, required = false,
                                 default = nil)
  if valid_598429 != nil:
    section.add "userIp", valid_598429
  var valid_598430 = query.getOrDefault("sendUpdates")
  valid_598430 = validateParameter(valid_598430, JString, required = false,
                                 default = newJString("all"))
  if valid_598430 != nil:
    section.add "sendUpdates", valid_598430
  var valid_598431 = query.getOrDefault("key")
  valid_598431 = validateParameter(valid_598431, JString, required = false,
                                 default = nil)
  if valid_598431 != nil:
    section.add "key", valid_598431
  assert query != nil,
        "query argument is necessary due to required `destination` field"
  var valid_598432 = query.getOrDefault("destination")
  valid_598432 = validateParameter(valid_598432, JString, required = true,
                                 default = nil)
  if valid_598432 != nil:
    section.add "destination", valid_598432
  var valid_598433 = query.getOrDefault("prettyPrint")
  valid_598433 = validateParameter(valid_598433, JBool, required = false,
                                 default = newJBool(true))
  if valid_598433 != nil:
    section.add "prettyPrint", valid_598433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598434: Call_CalendarEventsMove_598419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves an event to another calendar, i.e. changes an event's organizer.
  ## 
  let valid = call_598434.validator(path, query, header, formData, body)
  let scheme = call_598434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598434.url(scheme.get, call_598434.host, call_598434.base,
                         call_598434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598434, url, valid)

proc call*(call_598435: Call_CalendarEventsMove_598419; calendarId: string;
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
  var path_598436 = newJObject()
  var query_598437 = newJObject()
  add(query_598437, "fields", newJString(fields))
  add(query_598437, "quotaUser", newJString(quotaUser))
  add(query_598437, "alt", newJString(alt))
  add(path_598436, "calendarId", newJString(calendarId))
  add(query_598437, "sendNotifications", newJBool(sendNotifications))
  add(query_598437, "oauth_token", newJString(oauthToken))
  add(query_598437, "userIp", newJString(userIp))
  add(query_598437, "sendUpdates", newJString(sendUpdates))
  add(path_598436, "eventId", newJString(eventId))
  add(query_598437, "key", newJString(key))
  add(query_598437, "destination", newJString(destination))
  add(query_598437, "prettyPrint", newJBool(prettyPrint))
  result = call_598435.call(path_598436, query_598437, nil, nil, nil)

var calendarEventsMove* = Call_CalendarEventsMove_598419(
    name: "calendarEventsMove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}/move",
    validator: validate_CalendarEventsMove_598420, base: "/calendar/v3",
    url: url_CalendarEventsMove_598421, schemes: {Scheme.Https})
type
  Call_CalendarChannelsStop_598438 = ref object of OpenApiRestCall_597424
proc url_CalendarChannelsStop_598440(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CalendarChannelsStop_598439(path: JsonNode; query: JsonNode;
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
  var valid_598441 = query.getOrDefault("fields")
  valid_598441 = validateParameter(valid_598441, JString, required = false,
                                 default = nil)
  if valid_598441 != nil:
    section.add "fields", valid_598441
  var valid_598442 = query.getOrDefault("quotaUser")
  valid_598442 = validateParameter(valid_598442, JString, required = false,
                                 default = nil)
  if valid_598442 != nil:
    section.add "quotaUser", valid_598442
  var valid_598443 = query.getOrDefault("alt")
  valid_598443 = validateParameter(valid_598443, JString, required = false,
                                 default = newJString("json"))
  if valid_598443 != nil:
    section.add "alt", valid_598443
  var valid_598444 = query.getOrDefault("oauth_token")
  valid_598444 = validateParameter(valid_598444, JString, required = false,
                                 default = nil)
  if valid_598444 != nil:
    section.add "oauth_token", valid_598444
  var valid_598445 = query.getOrDefault("userIp")
  valid_598445 = validateParameter(valid_598445, JString, required = false,
                                 default = nil)
  if valid_598445 != nil:
    section.add "userIp", valid_598445
  var valid_598446 = query.getOrDefault("key")
  valid_598446 = validateParameter(valid_598446, JString, required = false,
                                 default = nil)
  if valid_598446 != nil:
    section.add "key", valid_598446
  var valid_598447 = query.getOrDefault("prettyPrint")
  valid_598447 = validateParameter(valid_598447, JBool, required = false,
                                 default = newJBool(true))
  if valid_598447 != nil:
    section.add "prettyPrint", valid_598447
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

proc call*(call_598449: Call_CalendarChannelsStop_598438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_598449.validator(path, query, header, formData, body)
  let scheme = call_598449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598449.url(scheme.get, call_598449.host, call_598449.base,
                         call_598449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598449, url, valid)

proc call*(call_598450: Call_CalendarChannelsStop_598438; fields: string = "";
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
  var query_598451 = newJObject()
  var body_598452 = newJObject()
  add(query_598451, "fields", newJString(fields))
  add(query_598451, "quotaUser", newJString(quotaUser))
  add(query_598451, "alt", newJString(alt))
  add(query_598451, "oauth_token", newJString(oauthToken))
  add(query_598451, "userIp", newJString(userIp))
  add(query_598451, "key", newJString(key))
  if resource != nil:
    body_598452 = resource
  add(query_598451, "prettyPrint", newJBool(prettyPrint))
  result = call_598450.call(nil, query_598451, nil, nil, body_598452)

var calendarChannelsStop* = Call_CalendarChannelsStop_598438(
    name: "calendarChannelsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_CalendarChannelsStop_598439, base: "/calendar/v3",
    url: url_CalendarChannelsStop_598440, schemes: {Scheme.Https})
type
  Call_CalendarColorsGet_598453 = ref object of OpenApiRestCall_597424
proc url_CalendarColorsGet_598455(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CalendarColorsGet_598454(path: JsonNode; query: JsonNode;
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
  var valid_598456 = query.getOrDefault("fields")
  valid_598456 = validateParameter(valid_598456, JString, required = false,
                                 default = nil)
  if valid_598456 != nil:
    section.add "fields", valid_598456
  var valid_598457 = query.getOrDefault("quotaUser")
  valid_598457 = validateParameter(valid_598457, JString, required = false,
                                 default = nil)
  if valid_598457 != nil:
    section.add "quotaUser", valid_598457
  var valid_598458 = query.getOrDefault("alt")
  valid_598458 = validateParameter(valid_598458, JString, required = false,
                                 default = newJString("json"))
  if valid_598458 != nil:
    section.add "alt", valid_598458
  var valid_598459 = query.getOrDefault("oauth_token")
  valid_598459 = validateParameter(valid_598459, JString, required = false,
                                 default = nil)
  if valid_598459 != nil:
    section.add "oauth_token", valid_598459
  var valid_598460 = query.getOrDefault("userIp")
  valid_598460 = validateParameter(valid_598460, JString, required = false,
                                 default = nil)
  if valid_598460 != nil:
    section.add "userIp", valid_598460
  var valid_598461 = query.getOrDefault("key")
  valid_598461 = validateParameter(valid_598461, JString, required = false,
                                 default = nil)
  if valid_598461 != nil:
    section.add "key", valid_598461
  var valid_598462 = query.getOrDefault("prettyPrint")
  valid_598462 = validateParameter(valid_598462, JBool, required = false,
                                 default = newJBool(true))
  if valid_598462 != nil:
    section.add "prettyPrint", valid_598462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598463: Call_CalendarColorsGet_598453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the color definitions for calendars and events.
  ## 
  let valid = call_598463.validator(path, query, header, formData, body)
  let scheme = call_598463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598463.url(scheme.get, call_598463.host, call_598463.base,
                         call_598463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598463, url, valid)

proc call*(call_598464: Call_CalendarColorsGet_598453; fields: string = "";
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
  var query_598465 = newJObject()
  add(query_598465, "fields", newJString(fields))
  add(query_598465, "quotaUser", newJString(quotaUser))
  add(query_598465, "alt", newJString(alt))
  add(query_598465, "oauth_token", newJString(oauthToken))
  add(query_598465, "userIp", newJString(userIp))
  add(query_598465, "key", newJString(key))
  add(query_598465, "prettyPrint", newJBool(prettyPrint))
  result = call_598464.call(nil, query_598465, nil, nil, nil)

var calendarColorsGet* = Call_CalendarColorsGet_598453(name: "calendarColorsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/colors",
    validator: validate_CalendarColorsGet_598454, base: "/calendar/v3",
    url: url_CalendarColorsGet_598455, schemes: {Scheme.Https})
type
  Call_CalendarFreebusyQuery_598466 = ref object of OpenApiRestCall_597424
proc url_CalendarFreebusyQuery_598468(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CalendarFreebusyQuery_598467(path: JsonNode; query: JsonNode;
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
  var valid_598469 = query.getOrDefault("fields")
  valid_598469 = validateParameter(valid_598469, JString, required = false,
                                 default = nil)
  if valid_598469 != nil:
    section.add "fields", valid_598469
  var valid_598470 = query.getOrDefault("quotaUser")
  valid_598470 = validateParameter(valid_598470, JString, required = false,
                                 default = nil)
  if valid_598470 != nil:
    section.add "quotaUser", valid_598470
  var valid_598471 = query.getOrDefault("alt")
  valid_598471 = validateParameter(valid_598471, JString, required = false,
                                 default = newJString("json"))
  if valid_598471 != nil:
    section.add "alt", valid_598471
  var valid_598472 = query.getOrDefault("oauth_token")
  valid_598472 = validateParameter(valid_598472, JString, required = false,
                                 default = nil)
  if valid_598472 != nil:
    section.add "oauth_token", valid_598472
  var valid_598473 = query.getOrDefault("userIp")
  valid_598473 = validateParameter(valid_598473, JString, required = false,
                                 default = nil)
  if valid_598473 != nil:
    section.add "userIp", valid_598473
  var valid_598474 = query.getOrDefault("key")
  valid_598474 = validateParameter(valid_598474, JString, required = false,
                                 default = nil)
  if valid_598474 != nil:
    section.add "key", valid_598474
  var valid_598475 = query.getOrDefault("prettyPrint")
  valid_598475 = validateParameter(valid_598475, JBool, required = false,
                                 default = newJBool(true))
  if valid_598475 != nil:
    section.add "prettyPrint", valid_598475
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

proc call*(call_598477: Call_CalendarFreebusyQuery_598466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns free/busy information for a set of calendars.
  ## 
  let valid = call_598477.validator(path, query, header, formData, body)
  let scheme = call_598477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598477.url(scheme.get, call_598477.host, call_598477.base,
                         call_598477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598477, url, valid)

proc call*(call_598478: Call_CalendarFreebusyQuery_598466; fields: string = "";
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
  var query_598479 = newJObject()
  var body_598480 = newJObject()
  add(query_598479, "fields", newJString(fields))
  add(query_598479, "quotaUser", newJString(quotaUser))
  add(query_598479, "alt", newJString(alt))
  add(query_598479, "oauth_token", newJString(oauthToken))
  add(query_598479, "userIp", newJString(userIp))
  add(query_598479, "key", newJString(key))
  if body != nil:
    body_598480 = body
  add(query_598479, "prettyPrint", newJBool(prettyPrint))
  result = call_598478.call(nil, query_598479, nil, nil, body_598480)

var calendarFreebusyQuery* = Call_CalendarFreebusyQuery_598466(
    name: "calendarFreebusyQuery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/freeBusy",
    validator: validate_CalendarFreebusyQuery_598467, base: "/calendar/v3",
    url: url_CalendarFreebusyQuery_598468, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListInsert_598500 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarListInsert_598502(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CalendarCalendarListInsert_598501(path: JsonNode; query: JsonNode;
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
  var valid_598503 = query.getOrDefault("fields")
  valid_598503 = validateParameter(valid_598503, JString, required = false,
                                 default = nil)
  if valid_598503 != nil:
    section.add "fields", valid_598503
  var valid_598504 = query.getOrDefault("quotaUser")
  valid_598504 = validateParameter(valid_598504, JString, required = false,
                                 default = nil)
  if valid_598504 != nil:
    section.add "quotaUser", valid_598504
  var valid_598505 = query.getOrDefault("alt")
  valid_598505 = validateParameter(valid_598505, JString, required = false,
                                 default = newJString("json"))
  if valid_598505 != nil:
    section.add "alt", valid_598505
  var valid_598506 = query.getOrDefault("colorRgbFormat")
  valid_598506 = validateParameter(valid_598506, JBool, required = false, default = nil)
  if valid_598506 != nil:
    section.add "colorRgbFormat", valid_598506
  var valid_598507 = query.getOrDefault("oauth_token")
  valid_598507 = validateParameter(valid_598507, JString, required = false,
                                 default = nil)
  if valid_598507 != nil:
    section.add "oauth_token", valid_598507
  var valid_598508 = query.getOrDefault("userIp")
  valid_598508 = validateParameter(valid_598508, JString, required = false,
                                 default = nil)
  if valid_598508 != nil:
    section.add "userIp", valid_598508
  var valid_598509 = query.getOrDefault("key")
  valid_598509 = validateParameter(valid_598509, JString, required = false,
                                 default = nil)
  if valid_598509 != nil:
    section.add "key", valid_598509
  var valid_598510 = query.getOrDefault("prettyPrint")
  valid_598510 = validateParameter(valid_598510, JBool, required = false,
                                 default = newJBool(true))
  if valid_598510 != nil:
    section.add "prettyPrint", valid_598510
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

proc call*(call_598512: Call_CalendarCalendarListInsert_598500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts an existing calendar into the user's calendar list.
  ## 
  let valid = call_598512.validator(path, query, header, formData, body)
  let scheme = call_598512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598512.url(scheme.get, call_598512.host, call_598512.base,
                         call_598512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598512, url, valid)

proc call*(call_598513: Call_CalendarCalendarListInsert_598500;
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
  var query_598514 = newJObject()
  var body_598515 = newJObject()
  add(query_598514, "fields", newJString(fields))
  add(query_598514, "quotaUser", newJString(quotaUser))
  add(query_598514, "alt", newJString(alt))
  add(query_598514, "colorRgbFormat", newJBool(colorRgbFormat))
  add(query_598514, "oauth_token", newJString(oauthToken))
  add(query_598514, "userIp", newJString(userIp))
  add(query_598514, "key", newJString(key))
  if body != nil:
    body_598515 = body
  add(query_598514, "prettyPrint", newJBool(prettyPrint))
  result = call_598513.call(nil, query_598514, nil, nil, body_598515)

var calendarCalendarListInsert* = Call_CalendarCalendarListInsert_598500(
    name: "calendarCalendarListInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/calendarList",
    validator: validate_CalendarCalendarListInsert_598501, base: "/calendar/v3",
    url: url_CalendarCalendarListInsert_598502, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListList_598481 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarListList_598483(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CalendarCalendarListList_598482(path: JsonNode; query: JsonNode;
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
  var valid_598484 = query.getOrDefault("fields")
  valid_598484 = validateParameter(valid_598484, JString, required = false,
                                 default = nil)
  if valid_598484 != nil:
    section.add "fields", valid_598484
  var valid_598485 = query.getOrDefault("pageToken")
  valid_598485 = validateParameter(valid_598485, JString, required = false,
                                 default = nil)
  if valid_598485 != nil:
    section.add "pageToken", valid_598485
  var valid_598486 = query.getOrDefault("quotaUser")
  valid_598486 = validateParameter(valid_598486, JString, required = false,
                                 default = nil)
  if valid_598486 != nil:
    section.add "quotaUser", valid_598486
  var valid_598487 = query.getOrDefault("alt")
  valid_598487 = validateParameter(valid_598487, JString, required = false,
                                 default = newJString("json"))
  if valid_598487 != nil:
    section.add "alt", valid_598487
  var valid_598488 = query.getOrDefault("oauth_token")
  valid_598488 = validateParameter(valid_598488, JString, required = false,
                                 default = nil)
  if valid_598488 != nil:
    section.add "oauth_token", valid_598488
  var valid_598489 = query.getOrDefault("syncToken")
  valid_598489 = validateParameter(valid_598489, JString, required = false,
                                 default = nil)
  if valid_598489 != nil:
    section.add "syncToken", valid_598489
  var valid_598490 = query.getOrDefault("userIp")
  valid_598490 = validateParameter(valid_598490, JString, required = false,
                                 default = nil)
  if valid_598490 != nil:
    section.add "userIp", valid_598490
  var valid_598491 = query.getOrDefault("maxResults")
  valid_598491 = validateParameter(valid_598491, JInt, required = false, default = nil)
  if valid_598491 != nil:
    section.add "maxResults", valid_598491
  var valid_598492 = query.getOrDefault("showHidden")
  valid_598492 = validateParameter(valid_598492, JBool, required = false, default = nil)
  if valid_598492 != nil:
    section.add "showHidden", valid_598492
  var valid_598493 = query.getOrDefault("showDeleted")
  valid_598493 = validateParameter(valid_598493, JBool, required = false, default = nil)
  if valid_598493 != nil:
    section.add "showDeleted", valid_598493
  var valid_598494 = query.getOrDefault("key")
  valid_598494 = validateParameter(valid_598494, JString, required = false,
                                 default = nil)
  if valid_598494 != nil:
    section.add "key", valid_598494
  var valid_598495 = query.getOrDefault("prettyPrint")
  valid_598495 = validateParameter(valid_598495, JBool, required = false,
                                 default = newJBool(true))
  if valid_598495 != nil:
    section.add "prettyPrint", valid_598495
  var valid_598496 = query.getOrDefault("minAccessRole")
  valid_598496 = validateParameter(valid_598496, JString, required = false,
                                 default = newJString("freeBusyReader"))
  if valid_598496 != nil:
    section.add "minAccessRole", valid_598496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598497: Call_CalendarCalendarListList_598481; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the calendars on the user's calendar list.
  ## 
  let valid = call_598497.validator(path, query, header, formData, body)
  let scheme = call_598497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598497.url(scheme.get, call_598497.host, call_598497.base,
                         call_598497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598497, url, valid)

proc call*(call_598498: Call_CalendarCalendarListList_598481; fields: string = "";
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
  var query_598499 = newJObject()
  add(query_598499, "fields", newJString(fields))
  add(query_598499, "pageToken", newJString(pageToken))
  add(query_598499, "quotaUser", newJString(quotaUser))
  add(query_598499, "alt", newJString(alt))
  add(query_598499, "oauth_token", newJString(oauthToken))
  add(query_598499, "syncToken", newJString(syncToken))
  add(query_598499, "userIp", newJString(userIp))
  add(query_598499, "maxResults", newJInt(maxResults))
  add(query_598499, "showHidden", newJBool(showHidden))
  add(query_598499, "showDeleted", newJBool(showDeleted))
  add(query_598499, "key", newJString(key))
  add(query_598499, "prettyPrint", newJBool(prettyPrint))
  add(query_598499, "minAccessRole", newJString(minAccessRole))
  result = call_598498.call(nil, query_598499, nil, nil, nil)

var calendarCalendarListList* = Call_CalendarCalendarListList_598481(
    name: "calendarCalendarListList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/calendarList",
    validator: validate_CalendarCalendarListList_598482, base: "/calendar/v3",
    url: url_CalendarCalendarListList_598483, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListWatch_598516 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarListWatch_598518(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CalendarCalendarListWatch_598517(path: JsonNode; query: JsonNode;
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
  var valid_598519 = query.getOrDefault("fields")
  valid_598519 = validateParameter(valid_598519, JString, required = false,
                                 default = nil)
  if valid_598519 != nil:
    section.add "fields", valid_598519
  var valid_598520 = query.getOrDefault("pageToken")
  valid_598520 = validateParameter(valid_598520, JString, required = false,
                                 default = nil)
  if valid_598520 != nil:
    section.add "pageToken", valid_598520
  var valid_598521 = query.getOrDefault("quotaUser")
  valid_598521 = validateParameter(valid_598521, JString, required = false,
                                 default = nil)
  if valid_598521 != nil:
    section.add "quotaUser", valid_598521
  var valid_598522 = query.getOrDefault("alt")
  valid_598522 = validateParameter(valid_598522, JString, required = false,
                                 default = newJString("json"))
  if valid_598522 != nil:
    section.add "alt", valid_598522
  var valid_598523 = query.getOrDefault("oauth_token")
  valid_598523 = validateParameter(valid_598523, JString, required = false,
                                 default = nil)
  if valid_598523 != nil:
    section.add "oauth_token", valid_598523
  var valid_598524 = query.getOrDefault("syncToken")
  valid_598524 = validateParameter(valid_598524, JString, required = false,
                                 default = nil)
  if valid_598524 != nil:
    section.add "syncToken", valid_598524
  var valid_598525 = query.getOrDefault("userIp")
  valid_598525 = validateParameter(valid_598525, JString, required = false,
                                 default = nil)
  if valid_598525 != nil:
    section.add "userIp", valid_598525
  var valid_598526 = query.getOrDefault("maxResults")
  valid_598526 = validateParameter(valid_598526, JInt, required = false, default = nil)
  if valid_598526 != nil:
    section.add "maxResults", valid_598526
  var valid_598527 = query.getOrDefault("showHidden")
  valid_598527 = validateParameter(valid_598527, JBool, required = false, default = nil)
  if valid_598527 != nil:
    section.add "showHidden", valid_598527
  var valid_598528 = query.getOrDefault("showDeleted")
  valid_598528 = validateParameter(valid_598528, JBool, required = false, default = nil)
  if valid_598528 != nil:
    section.add "showDeleted", valid_598528
  var valid_598529 = query.getOrDefault("key")
  valid_598529 = validateParameter(valid_598529, JString, required = false,
                                 default = nil)
  if valid_598529 != nil:
    section.add "key", valid_598529
  var valid_598530 = query.getOrDefault("prettyPrint")
  valid_598530 = validateParameter(valid_598530, JBool, required = false,
                                 default = newJBool(true))
  if valid_598530 != nil:
    section.add "prettyPrint", valid_598530
  var valid_598531 = query.getOrDefault("minAccessRole")
  valid_598531 = validateParameter(valid_598531, JString, required = false,
                                 default = newJString("freeBusyReader"))
  if valid_598531 != nil:
    section.add "minAccessRole", valid_598531
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

proc call*(call_598533: Call_CalendarCalendarListWatch_598516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to CalendarList resources.
  ## 
  let valid = call_598533.validator(path, query, header, formData, body)
  let scheme = call_598533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598533.url(scheme.get, call_598533.host, call_598533.base,
                         call_598533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598533, url, valid)

proc call*(call_598534: Call_CalendarCalendarListWatch_598516; fields: string = "";
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
  var query_598535 = newJObject()
  var body_598536 = newJObject()
  add(query_598535, "fields", newJString(fields))
  add(query_598535, "pageToken", newJString(pageToken))
  add(query_598535, "quotaUser", newJString(quotaUser))
  add(query_598535, "alt", newJString(alt))
  add(query_598535, "oauth_token", newJString(oauthToken))
  add(query_598535, "syncToken", newJString(syncToken))
  add(query_598535, "userIp", newJString(userIp))
  add(query_598535, "maxResults", newJInt(maxResults))
  add(query_598535, "showHidden", newJBool(showHidden))
  add(query_598535, "showDeleted", newJBool(showDeleted))
  add(query_598535, "key", newJString(key))
  if resource != nil:
    body_598536 = resource
  add(query_598535, "prettyPrint", newJBool(prettyPrint))
  add(query_598535, "minAccessRole", newJString(minAccessRole))
  result = call_598534.call(nil, query_598535, nil, nil, body_598536)

var calendarCalendarListWatch* = Call_CalendarCalendarListWatch_598516(
    name: "calendarCalendarListWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/calendarList/watch",
    validator: validate_CalendarCalendarListWatch_598517, base: "/calendar/v3",
    url: url_CalendarCalendarListWatch_598518, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListUpdate_598552 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarListUpdate_598554(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/me/calendarList/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarListUpdate_598553(path: JsonNode; query: JsonNode;
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
  var valid_598555 = path.getOrDefault("calendarId")
  valid_598555 = validateParameter(valid_598555, JString, required = true,
                                 default = nil)
  if valid_598555 != nil:
    section.add "calendarId", valid_598555
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
  var valid_598556 = query.getOrDefault("fields")
  valid_598556 = validateParameter(valid_598556, JString, required = false,
                                 default = nil)
  if valid_598556 != nil:
    section.add "fields", valid_598556
  var valid_598557 = query.getOrDefault("quotaUser")
  valid_598557 = validateParameter(valid_598557, JString, required = false,
                                 default = nil)
  if valid_598557 != nil:
    section.add "quotaUser", valid_598557
  var valid_598558 = query.getOrDefault("alt")
  valid_598558 = validateParameter(valid_598558, JString, required = false,
                                 default = newJString("json"))
  if valid_598558 != nil:
    section.add "alt", valid_598558
  var valid_598559 = query.getOrDefault("colorRgbFormat")
  valid_598559 = validateParameter(valid_598559, JBool, required = false, default = nil)
  if valid_598559 != nil:
    section.add "colorRgbFormat", valid_598559
  var valid_598560 = query.getOrDefault("oauth_token")
  valid_598560 = validateParameter(valid_598560, JString, required = false,
                                 default = nil)
  if valid_598560 != nil:
    section.add "oauth_token", valid_598560
  var valid_598561 = query.getOrDefault("userIp")
  valid_598561 = validateParameter(valid_598561, JString, required = false,
                                 default = nil)
  if valid_598561 != nil:
    section.add "userIp", valid_598561
  var valid_598562 = query.getOrDefault("key")
  valid_598562 = validateParameter(valid_598562, JString, required = false,
                                 default = nil)
  if valid_598562 != nil:
    section.add "key", valid_598562
  var valid_598563 = query.getOrDefault("prettyPrint")
  valid_598563 = validateParameter(valid_598563, JBool, required = false,
                                 default = newJBool(true))
  if valid_598563 != nil:
    section.add "prettyPrint", valid_598563
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

proc call*(call_598565: Call_CalendarCalendarListUpdate_598552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing calendar on the user's calendar list.
  ## 
  let valid = call_598565.validator(path, query, header, formData, body)
  let scheme = call_598565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598565.url(scheme.get, call_598565.host, call_598565.base,
                         call_598565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598565, url, valid)

proc call*(call_598566: Call_CalendarCalendarListUpdate_598552; calendarId: string;
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
  var path_598567 = newJObject()
  var query_598568 = newJObject()
  var body_598569 = newJObject()
  add(query_598568, "fields", newJString(fields))
  add(query_598568, "quotaUser", newJString(quotaUser))
  add(query_598568, "alt", newJString(alt))
  add(query_598568, "colorRgbFormat", newJBool(colorRgbFormat))
  add(path_598567, "calendarId", newJString(calendarId))
  add(query_598568, "oauth_token", newJString(oauthToken))
  add(query_598568, "userIp", newJString(userIp))
  add(query_598568, "key", newJString(key))
  if body != nil:
    body_598569 = body
  add(query_598568, "prettyPrint", newJBool(prettyPrint))
  result = call_598566.call(path_598567, query_598568, nil, nil, body_598569)

var calendarCalendarListUpdate* = Call_CalendarCalendarListUpdate_598552(
    name: "calendarCalendarListUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListUpdate_598553, base: "/calendar/v3",
    url: url_CalendarCalendarListUpdate_598554, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListGet_598537 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarListGet_598539(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/me/calendarList/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarListGet_598538(path: JsonNode; query: JsonNode;
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
  var valid_598540 = path.getOrDefault("calendarId")
  valid_598540 = validateParameter(valid_598540, JString, required = true,
                                 default = nil)
  if valid_598540 != nil:
    section.add "calendarId", valid_598540
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
  var valid_598541 = query.getOrDefault("fields")
  valid_598541 = validateParameter(valid_598541, JString, required = false,
                                 default = nil)
  if valid_598541 != nil:
    section.add "fields", valid_598541
  var valid_598542 = query.getOrDefault("quotaUser")
  valid_598542 = validateParameter(valid_598542, JString, required = false,
                                 default = nil)
  if valid_598542 != nil:
    section.add "quotaUser", valid_598542
  var valid_598543 = query.getOrDefault("alt")
  valid_598543 = validateParameter(valid_598543, JString, required = false,
                                 default = newJString("json"))
  if valid_598543 != nil:
    section.add "alt", valid_598543
  var valid_598544 = query.getOrDefault("oauth_token")
  valid_598544 = validateParameter(valid_598544, JString, required = false,
                                 default = nil)
  if valid_598544 != nil:
    section.add "oauth_token", valid_598544
  var valid_598545 = query.getOrDefault("userIp")
  valid_598545 = validateParameter(valid_598545, JString, required = false,
                                 default = nil)
  if valid_598545 != nil:
    section.add "userIp", valid_598545
  var valid_598546 = query.getOrDefault("key")
  valid_598546 = validateParameter(valid_598546, JString, required = false,
                                 default = nil)
  if valid_598546 != nil:
    section.add "key", valid_598546
  var valid_598547 = query.getOrDefault("prettyPrint")
  valid_598547 = validateParameter(valid_598547, JBool, required = false,
                                 default = newJBool(true))
  if valid_598547 != nil:
    section.add "prettyPrint", valid_598547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598548: Call_CalendarCalendarListGet_598537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a calendar from the user's calendar list.
  ## 
  let valid = call_598548.validator(path, query, header, formData, body)
  let scheme = call_598548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598548.url(scheme.get, call_598548.host, call_598548.base,
                         call_598548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598548, url, valid)

proc call*(call_598549: Call_CalendarCalendarListGet_598537; calendarId: string;
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
  var path_598550 = newJObject()
  var query_598551 = newJObject()
  add(query_598551, "fields", newJString(fields))
  add(query_598551, "quotaUser", newJString(quotaUser))
  add(query_598551, "alt", newJString(alt))
  add(path_598550, "calendarId", newJString(calendarId))
  add(query_598551, "oauth_token", newJString(oauthToken))
  add(query_598551, "userIp", newJString(userIp))
  add(query_598551, "key", newJString(key))
  add(query_598551, "prettyPrint", newJBool(prettyPrint))
  result = call_598549.call(path_598550, query_598551, nil, nil, nil)

var calendarCalendarListGet* = Call_CalendarCalendarListGet_598537(
    name: "calendarCalendarListGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListGet_598538, base: "/calendar/v3",
    url: url_CalendarCalendarListGet_598539, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListPatch_598585 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarListPatch_598587(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/me/calendarList/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarListPatch_598586(path: JsonNode; query: JsonNode;
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
  var valid_598588 = path.getOrDefault("calendarId")
  valid_598588 = validateParameter(valid_598588, JString, required = true,
                                 default = nil)
  if valid_598588 != nil:
    section.add "calendarId", valid_598588
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
  var valid_598589 = query.getOrDefault("fields")
  valid_598589 = validateParameter(valid_598589, JString, required = false,
                                 default = nil)
  if valid_598589 != nil:
    section.add "fields", valid_598589
  var valid_598590 = query.getOrDefault("quotaUser")
  valid_598590 = validateParameter(valid_598590, JString, required = false,
                                 default = nil)
  if valid_598590 != nil:
    section.add "quotaUser", valid_598590
  var valid_598591 = query.getOrDefault("alt")
  valid_598591 = validateParameter(valid_598591, JString, required = false,
                                 default = newJString("json"))
  if valid_598591 != nil:
    section.add "alt", valid_598591
  var valid_598592 = query.getOrDefault("colorRgbFormat")
  valid_598592 = validateParameter(valid_598592, JBool, required = false, default = nil)
  if valid_598592 != nil:
    section.add "colorRgbFormat", valid_598592
  var valid_598593 = query.getOrDefault("oauth_token")
  valid_598593 = validateParameter(valid_598593, JString, required = false,
                                 default = nil)
  if valid_598593 != nil:
    section.add "oauth_token", valid_598593
  var valid_598594 = query.getOrDefault("userIp")
  valid_598594 = validateParameter(valid_598594, JString, required = false,
                                 default = nil)
  if valid_598594 != nil:
    section.add "userIp", valid_598594
  var valid_598595 = query.getOrDefault("key")
  valid_598595 = validateParameter(valid_598595, JString, required = false,
                                 default = nil)
  if valid_598595 != nil:
    section.add "key", valid_598595
  var valid_598596 = query.getOrDefault("prettyPrint")
  valid_598596 = validateParameter(valid_598596, JBool, required = false,
                                 default = newJBool(true))
  if valid_598596 != nil:
    section.add "prettyPrint", valid_598596
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

proc call*(call_598598: Call_CalendarCalendarListPatch_598585; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing calendar on the user's calendar list. This method supports patch semantics.
  ## 
  let valid = call_598598.validator(path, query, header, formData, body)
  let scheme = call_598598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598598.url(scheme.get, call_598598.host, call_598598.base,
                         call_598598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598598, url, valid)

proc call*(call_598599: Call_CalendarCalendarListPatch_598585; calendarId: string;
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
  var path_598600 = newJObject()
  var query_598601 = newJObject()
  var body_598602 = newJObject()
  add(query_598601, "fields", newJString(fields))
  add(query_598601, "quotaUser", newJString(quotaUser))
  add(query_598601, "alt", newJString(alt))
  add(query_598601, "colorRgbFormat", newJBool(colorRgbFormat))
  add(path_598600, "calendarId", newJString(calendarId))
  add(query_598601, "oauth_token", newJString(oauthToken))
  add(query_598601, "userIp", newJString(userIp))
  add(query_598601, "key", newJString(key))
  if body != nil:
    body_598602 = body
  add(query_598601, "prettyPrint", newJBool(prettyPrint))
  result = call_598599.call(path_598600, query_598601, nil, nil, body_598602)

var calendarCalendarListPatch* = Call_CalendarCalendarListPatch_598585(
    name: "calendarCalendarListPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListPatch_598586, base: "/calendar/v3",
    url: url_CalendarCalendarListPatch_598587, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListDelete_598570 = ref object of OpenApiRestCall_597424
proc url_CalendarCalendarListDelete_598572(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "calendarId" in path, "`calendarId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/me/calendarList/"),
               (kind: VariableSegment, value: "calendarId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarCalendarListDelete_598571(path: JsonNode; query: JsonNode;
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
  var valid_598573 = path.getOrDefault("calendarId")
  valid_598573 = validateParameter(valid_598573, JString, required = true,
                                 default = nil)
  if valid_598573 != nil:
    section.add "calendarId", valid_598573
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
  var valid_598574 = query.getOrDefault("fields")
  valid_598574 = validateParameter(valid_598574, JString, required = false,
                                 default = nil)
  if valid_598574 != nil:
    section.add "fields", valid_598574
  var valid_598575 = query.getOrDefault("quotaUser")
  valid_598575 = validateParameter(valid_598575, JString, required = false,
                                 default = nil)
  if valid_598575 != nil:
    section.add "quotaUser", valid_598575
  var valid_598576 = query.getOrDefault("alt")
  valid_598576 = validateParameter(valid_598576, JString, required = false,
                                 default = newJString("json"))
  if valid_598576 != nil:
    section.add "alt", valid_598576
  var valid_598577 = query.getOrDefault("oauth_token")
  valid_598577 = validateParameter(valid_598577, JString, required = false,
                                 default = nil)
  if valid_598577 != nil:
    section.add "oauth_token", valid_598577
  var valid_598578 = query.getOrDefault("userIp")
  valid_598578 = validateParameter(valid_598578, JString, required = false,
                                 default = nil)
  if valid_598578 != nil:
    section.add "userIp", valid_598578
  var valid_598579 = query.getOrDefault("key")
  valid_598579 = validateParameter(valid_598579, JString, required = false,
                                 default = nil)
  if valid_598579 != nil:
    section.add "key", valid_598579
  var valid_598580 = query.getOrDefault("prettyPrint")
  valid_598580 = validateParameter(valid_598580, JBool, required = false,
                                 default = newJBool(true))
  if valid_598580 != nil:
    section.add "prettyPrint", valid_598580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598581: Call_CalendarCalendarListDelete_598570; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a calendar from the user's calendar list.
  ## 
  let valid = call_598581.validator(path, query, header, formData, body)
  let scheme = call_598581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598581.url(scheme.get, call_598581.host, call_598581.base,
                         call_598581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598581, url, valid)

proc call*(call_598582: Call_CalendarCalendarListDelete_598570; calendarId: string;
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
  var path_598583 = newJObject()
  var query_598584 = newJObject()
  add(query_598584, "fields", newJString(fields))
  add(query_598584, "quotaUser", newJString(quotaUser))
  add(query_598584, "alt", newJString(alt))
  add(path_598583, "calendarId", newJString(calendarId))
  add(query_598584, "oauth_token", newJString(oauthToken))
  add(query_598584, "userIp", newJString(userIp))
  add(query_598584, "key", newJString(key))
  add(query_598584, "prettyPrint", newJBool(prettyPrint))
  result = call_598582.call(path_598583, query_598584, nil, nil, nil)

var calendarCalendarListDelete* = Call_CalendarCalendarListDelete_598570(
    name: "calendarCalendarListDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListDelete_598571, base: "/calendar/v3",
    url: url_CalendarCalendarListDelete_598572, schemes: {Scheme.Https})
type
  Call_CalendarSettingsList_598603 = ref object of OpenApiRestCall_597424
proc url_CalendarSettingsList_598605(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CalendarSettingsList_598604(path: JsonNode; query: JsonNode;
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
  var valid_598606 = query.getOrDefault("fields")
  valid_598606 = validateParameter(valid_598606, JString, required = false,
                                 default = nil)
  if valid_598606 != nil:
    section.add "fields", valid_598606
  var valid_598607 = query.getOrDefault("pageToken")
  valid_598607 = validateParameter(valid_598607, JString, required = false,
                                 default = nil)
  if valid_598607 != nil:
    section.add "pageToken", valid_598607
  var valid_598608 = query.getOrDefault("quotaUser")
  valid_598608 = validateParameter(valid_598608, JString, required = false,
                                 default = nil)
  if valid_598608 != nil:
    section.add "quotaUser", valid_598608
  var valid_598609 = query.getOrDefault("alt")
  valid_598609 = validateParameter(valid_598609, JString, required = false,
                                 default = newJString("json"))
  if valid_598609 != nil:
    section.add "alt", valid_598609
  var valid_598610 = query.getOrDefault("oauth_token")
  valid_598610 = validateParameter(valid_598610, JString, required = false,
                                 default = nil)
  if valid_598610 != nil:
    section.add "oauth_token", valid_598610
  var valid_598611 = query.getOrDefault("syncToken")
  valid_598611 = validateParameter(valid_598611, JString, required = false,
                                 default = nil)
  if valid_598611 != nil:
    section.add "syncToken", valid_598611
  var valid_598612 = query.getOrDefault("userIp")
  valid_598612 = validateParameter(valid_598612, JString, required = false,
                                 default = nil)
  if valid_598612 != nil:
    section.add "userIp", valid_598612
  var valid_598613 = query.getOrDefault("maxResults")
  valid_598613 = validateParameter(valid_598613, JInt, required = false, default = nil)
  if valid_598613 != nil:
    section.add "maxResults", valid_598613
  var valid_598614 = query.getOrDefault("key")
  valid_598614 = validateParameter(valid_598614, JString, required = false,
                                 default = nil)
  if valid_598614 != nil:
    section.add "key", valid_598614
  var valid_598615 = query.getOrDefault("prettyPrint")
  valid_598615 = validateParameter(valid_598615, JBool, required = false,
                                 default = newJBool(true))
  if valid_598615 != nil:
    section.add "prettyPrint", valid_598615
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598616: Call_CalendarSettingsList_598603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all user settings for the authenticated user.
  ## 
  let valid = call_598616.validator(path, query, header, formData, body)
  let scheme = call_598616.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598616.url(scheme.get, call_598616.host, call_598616.base,
                         call_598616.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598616, url, valid)

proc call*(call_598617: Call_CalendarSettingsList_598603; fields: string = "";
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
  var query_598618 = newJObject()
  add(query_598618, "fields", newJString(fields))
  add(query_598618, "pageToken", newJString(pageToken))
  add(query_598618, "quotaUser", newJString(quotaUser))
  add(query_598618, "alt", newJString(alt))
  add(query_598618, "oauth_token", newJString(oauthToken))
  add(query_598618, "syncToken", newJString(syncToken))
  add(query_598618, "userIp", newJString(userIp))
  add(query_598618, "maxResults", newJInt(maxResults))
  add(query_598618, "key", newJString(key))
  add(query_598618, "prettyPrint", newJBool(prettyPrint))
  result = call_598617.call(nil, query_598618, nil, nil, nil)

var calendarSettingsList* = Call_CalendarSettingsList_598603(
    name: "calendarSettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/settings",
    validator: validate_CalendarSettingsList_598604, base: "/calendar/v3",
    url: url_CalendarSettingsList_598605, schemes: {Scheme.Https})
type
  Call_CalendarSettingsWatch_598619 = ref object of OpenApiRestCall_597424
proc url_CalendarSettingsWatch_598621(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CalendarSettingsWatch_598620(path: JsonNode; query: JsonNode;
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
  var valid_598622 = query.getOrDefault("fields")
  valid_598622 = validateParameter(valid_598622, JString, required = false,
                                 default = nil)
  if valid_598622 != nil:
    section.add "fields", valid_598622
  var valid_598623 = query.getOrDefault("pageToken")
  valid_598623 = validateParameter(valid_598623, JString, required = false,
                                 default = nil)
  if valid_598623 != nil:
    section.add "pageToken", valid_598623
  var valid_598624 = query.getOrDefault("quotaUser")
  valid_598624 = validateParameter(valid_598624, JString, required = false,
                                 default = nil)
  if valid_598624 != nil:
    section.add "quotaUser", valid_598624
  var valid_598625 = query.getOrDefault("alt")
  valid_598625 = validateParameter(valid_598625, JString, required = false,
                                 default = newJString("json"))
  if valid_598625 != nil:
    section.add "alt", valid_598625
  var valid_598626 = query.getOrDefault("oauth_token")
  valid_598626 = validateParameter(valid_598626, JString, required = false,
                                 default = nil)
  if valid_598626 != nil:
    section.add "oauth_token", valid_598626
  var valid_598627 = query.getOrDefault("syncToken")
  valid_598627 = validateParameter(valid_598627, JString, required = false,
                                 default = nil)
  if valid_598627 != nil:
    section.add "syncToken", valid_598627
  var valid_598628 = query.getOrDefault("userIp")
  valid_598628 = validateParameter(valid_598628, JString, required = false,
                                 default = nil)
  if valid_598628 != nil:
    section.add "userIp", valid_598628
  var valid_598629 = query.getOrDefault("maxResults")
  valid_598629 = validateParameter(valid_598629, JInt, required = false, default = nil)
  if valid_598629 != nil:
    section.add "maxResults", valid_598629
  var valid_598630 = query.getOrDefault("key")
  valid_598630 = validateParameter(valid_598630, JString, required = false,
                                 default = nil)
  if valid_598630 != nil:
    section.add "key", valid_598630
  var valid_598631 = query.getOrDefault("prettyPrint")
  valid_598631 = validateParameter(valid_598631, JBool, required = false,
                                 default = newJBool(true))
  if valid_598631 != nil:
    section.add "prettyPrint", valid_598631
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

proc call*(call_598633: Call_CalendarSettingsWatch_598619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to Settings resources.
  ## 
  let valid = call_598633.validator(path, query, header, formData, body)
  let scheme = call_598633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598633.url(scheme.get, call_598633.host, call_598633.base,
                         call_598633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598633, url, valid)

proc call*(call_598634: Call_CalendarSettingsWatch_598619; fields: string = "";
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
  var query_598635 = newJObject()
  var body_598636 = newJObject()
  add(query_598635, "fields", newJString(fields))
  add(query_598635, "pageToken", newJString(pageToken))
  add(query_598635, "quotaUser", newJString(quotaUser))
  add(query_598635, "alt", newJString(alt))
  add(query_598635, "oauth_token", newJString(oauthToken))
  add(query_598635, "syncToken", newJString(syncToken))
  add(query_598635, "userIp", newJString(userIp))
  add(query_598635, "maxResults", newJInt(maxResults))
  add(query_598635, "key", newJString(key))
  if resource != nil:
    body_598636 = resource
  add(query_598635, "prettyPrint", newJBool(prettyPrint))
  result = call_598634.call(nil, query_598635, nil, nil, body_598636)

var calendarSettingsWatch* = Call_CalendarSettingsWatch_598619(
    name: "calendarSettingsWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/settings/watch",
    validator: validate_CalendarSettingsWatch_598620, base: "/calendar/v3",
    url: url_CalendarSettingsWatch_598621, schemes: {Scheme.Https})
type
  Call_CalendarSettingsGet_598637 = ref object of OpenApiRestCall_597424
proc url_CalendarSettingsGet_598639(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "setting" in path, "`setting` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/me/settings/"),
               (kind: VariableSegment, value: "setting")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CalendarSettingsGet_598638(path: JsonNode; query: JsonNode;
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
  var valid_598640 = path.getOrDefault("setting")
  valid_598640 = validateParameter(valid_598640, JString, required = true,
                                 default = nil)
  if valid_598640 != nil:
    section.add "setting", valid_598640
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
  var valid_598641 = query.getOrDefault("fields")
  valid_598641 = validateParameter(valid_598641, JString, required = false,
                                 default = nil)
  if valid_598641 != nil:
    section.add "fields", valid_598641
  var valid_598642 = query.getOrDefault("quotaUser")
  valid_598642 = validateParameter(valid_598642, JString, required = false,
                                 default = nil)
  if valid_598642 != nil:
    section.add "quotaUser", valid_598642
  var valid_598643 = query.getOrDefault("alt")
  valid_598643 = validateParameter(valid_598643, JString, required = false,
                                 default = newJString("json"))
  if valid_598643 != nil:
    section.add "alt", valid_598643
  var valid_598644 = query.getOrDefault("oauth_token")
  valid_598644 = validateParameter(valid_598644, JString, required = false,
                                 default = nil)
  if valid_598644 != nil:
    section.add "oauth_token", valid_598644
  var valid_598645 = query.getOrDefault("userIp")
  valid_598645 = validateParameter(valid_598645, JString, required = false,
                                 default = nil)
  if valid_598645 != nil:
    section.add "userIp", valid_598645
  var valid_598646 = query.getOrDefault("key")
  valid_598646 = validateParameter(valid_598646, JString, required = false,
                                 default = nil)
  if valid_598646 != nil:
    section.add "key", valid_598646
  var valid_598647 = query.getOrDefault("prettyPrint")
  valid_598647 = validateParameter(valid_598647, JBool, required = false,
                                 default = newJBool(true))
  if valid_598647 != nil:
    section.add "prettyPrint", valid_598647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598648: Call_CalendarSettingsGet_598637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single user setting.
  ## 
  let valid = call_598648.validator(path, query, header, formData, body)
  let scheme = call_598648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598648.url(scheme.get, call_598648.host, call_598648.base,
                         call_598648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598648, url, valid)

proc call*(call_598649: Call_CalendarSettingsGet_598637; setting: string;
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
  var path_598650 = newJObject()
  var query_598651 = newJObject()
  add(query_598651, "fields", newJString(fields))
  add(query_598651, "quotaUser", newJString(quotaUser))
  add(query_598651, "alt", newJString(alt))
  add(query_598651, "oauth_token", newJString(oauthToken))
  add(query_598651, "userIp", newJString(userIp))
  add(path_598650, "setting", newJString(setting))
  add(query_598651, "key", newJString(key))
  add(query_598651, "prettyPrint", newJBool(prettyPrint))
  result = call_598649.call(path_598650, query_598651, nil, nil, nil)

var calendarSettingsGet* = Call_CalendarSettingsGet_598637(
    name: "calendarSettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/settings/{setting}",
    validator: validate_CalendarSettingsGet_598638, base: "/calendar/v3",
    url: url_CalendarSettingsGet_598639, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
