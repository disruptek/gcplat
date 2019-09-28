
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
  gcpServiceName = "calendar"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CalendarCalendarsInsert_579692 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarsInsert_579694(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarsInsert_579693(path: JsonNode; query: JsonNode;
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
  var valid_579806 = query.getOrDefault("fields")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "fields", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("userIp")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "userIp", valid_579823
  var valid_579824 = query.getOrDefault("key")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "key", valid_579824
  var valid_579825 = query.getOrDefault("prettyPrint")
  valid_579825 = validateParameter(valid_579825, JBool, required = false,
                                 default = newJBool(true))
  if valid_579825 != nil:
    section.add "prettyPrint", valid_579825
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

proc call*(call_579849: Call_CalendarCalendarsInsert_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a secondary calendar.
  ## 
  let valid = call_579849.validator(path, query, header, formData, body)
  let scheme = call_579849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579849.url(scheme.get, call_579849.host, call_579849.base,
                         call_579849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579849, url, valid)

proc call*(call_579920: Call_CalendarCalendarsInsert_579692; fields: string = "";
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
  var query_579921 = newJObject()
  var body_579923 = newJObject()
  add(query_579921, "fields", newJString(fields))
  add(query_579921, "quotaUser", newJString(quotaUser))
  add(query_579921, "alt", newJString(alt))
  add(query_579921, "oauth_token", newJString(oauthToken))
  add(query_579921, "userIp", newJString(userIp))
  add(query_579921, "key", newJString(key))
  if body != nil:
    body_579923 = body
  add(query_579921, "prettyPrint", newJBool(prettyPrint))
  result = call_579920.call(nil, query_579921, nil, nil, body_579923)

var calendarCalendarsInsert* = Call_CalendarCalendarsInsert_579692(
    name: "calendarCalendarsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars",
    validator: validate_CalendarCalendarsInsert_579693, base: "/calendar/v3",
    url: url_CalendarCalendarsInsert_579694, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsUpdate_579991 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarsUpdate_579993(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarsUpdate_579992(path: JsonNode; query: JsonNode;
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
  var valid_579994 = path.getOrDefault("calendarId")
  valid_579994 = validateParameter(valid_579994, JString, required = true,
                                 default = nil)
  if valid_579994 != nil:
    section.add "calendarId", valid_579994
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
  var valid_579995 = query.getOrDefault("fields")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "fields", valid_579995
  var valid_579996 = query.getOrDefault("quotaUser")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "quotaUser", valid_579996
  var valid_579997 = query.getOrDefault("alt")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("json"))
  if valid_579997 != nil:
    section.add "alt", valid_579997
  var valid_579998 = query.getOrDefault("oauth_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "oauth_token", valid_579998
  var valid_579999 = query.getOrDefault("userIp")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "userIp", valid_579999
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("prettyPrint")
  valid_580001 = validateParameter(valid_580001, JBool, required = false,
                                 default = newJBool(true))
  if valid_580001 != nil:
    section.add "prettyPrint", valid_580001
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

proc call*(call_580003: Call_CalendarCalendarsUpdate_579991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates metadata for a calendar.
  ## 
  let valid = call_580003.validator(path, query, header, formData, body)
  let scheme = call_580003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580003.url(scheme.get, call_580003.host, call_580003.base,
                         call_580003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580003, url, valid)

proc call*(call_580004: Call_CalendarCalendarsUpdate_579991; calendarId: string;
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
  var path_580005 = newJObject()
  var query_580006 = newJObject()
  var body_580007 = newJObject()
  add(query_580006, "fields", newJString(fields))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(query_580006, "alt", newJString(alt))
  add(path_580005, "calendarId", newJString(calendarId))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "userIp", newJString(userIp))
  add(query_580006, "key", newJString(key))
  if body != nil:
    body_580007 = body
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  result = call_580004.call(path_580005, query_580006, nil, nil, body_580007)

var calendarCalendarsUpdate* = Call_CalendarCalendarsUpdate_579991(
    name: "calendarCalendarsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsUpdate_579992, base: "/calendar/v3",
    url: url_CalendarCalendarsUpdate_579993, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsGet_579962 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarsGet_579964(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarsGet_579963(path: JsonNode; query: JsonNode;
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
  var valid_579979 = path.getOrDefault("calendarId")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "calendarId", valid_579979
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
  var valid_579980 = query.getOrDefault("fields")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "fields", valid_579980
  var valid_579981 = query.getOrDefault("quotaUser")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "quotaUser", valid_579981
  var valid_579982 = query.getOrDefault("alt")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("json"))
  if valid_579982 != nil:
    section.add "alt", valid_579982
  var valid_579983 = query.getOrDefault("oauth_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "oauth_token", valid_579983
  var valid_579984 = query.getOrDefault("userIp")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "userIp", valid_579984
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579987: Call_CalendarCalendarsGet_579962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for a calendar.
  ## 
  let valid = call_579987.validator(path, query, header, formData, body)
  let scheme = call_579987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579987.url(scheme.get, call_579987.host, call_579987.base,
                         call_579987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579987, url, valid)

proc call*(call_579988: Call_CalendarCalendarsGet_579962; calendarId: string;
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
  var path_579989 = newJObject()
  var query_579990 = newJObject()
  add(query_579990, "fields", newJString(fields))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(query_579990, "alt", newJString(alt))
  add(path_579989, "calendarId", newJString(calendarId))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(query_579990, "userIp", newJString(userIp))
  add(query_579990, "key", newJString(key))
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  result = call_579988.call(path_579989, query_579990, nil, nil, nil)

var calendarCalendarsGet* = Call_CalendarCalendarsGet_579962(
    name: "calendarCalendarsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsGet_579963, base: "/calendar/v3",
    url: url_CalendarCalendarsGet_579964, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsPatch_580023 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarsPatch_580025(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarsPatch_580024(path: JsonNode; query: JsonNode;
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
  var valid_580026 = path.getOrDefault("calendarId")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "calendarId", valid_580026
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
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("alt")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("json"))
  if valid_580029 != nil:
    section.add "alt", valid_580029
  var valid_580030 = query.getOrDefault("oauth_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "oauth_token", valid_580030
  var valid_580031 = query.getOrDefault("userIp")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "userIp", valid_580031
  var valid_580032 = query.getOrDefault("key")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "key", valid_580032
  var valid_580033 = query.getOrDefault("prettyPrint")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "prettyPrint", valid_580033
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

proc call*(call_580035: Call_CalendarCalendarsPatch_580023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates metadata for a calendar. This method supports patch semantics.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_CalendarCalendarsPatch_580023; calendarId: string;
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
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  var body_580039 = newJObject()
  add(query_580038, "fields", newJString(fields))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "alt", newJString(alt))
  add(path_580037, "calendarId", newJString(calendarId))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "userIp", newJString(userIp))
  add(query_580038, "key", newJString(key))
  if body != nil:
    body_580039 = body
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  result = call_580036.call(path_580037, query_580038, nil, nil, body_580039)

var calendarCalendarsPatch* = Call_CalendarCalendarsPatch_580023(
    name: "calendarCalendarsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsPatch_580024, base: "/calendar/v3",
    url: url_CalendarCalendarsPatch_580025, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsDelete_580008 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarsDelete_580010(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarsDelete_580009(path: JsonNode; query: JsonNode;
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
  var valid_580011 = path.getOrDefault("calendarId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "calendarId", valid_580011
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
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("userIp")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userIp", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_CalendarCalendarsDelete_580008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a secondary calendar. Use calendars.clear for clearing all events on primary calendars.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_CalendarCalendarsDelete_580008; calendarId: string;
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
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(path_580021, "calendarId", newJString(calendarId))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "userIp", newJString(userIp))
  add(query_580022, "key", newJString(key))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var calendarCalendarsDelete* = Call_CalendarCalendarsDelete_580008(
    name: "calendarCalendarsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/calendars/{calendarId}",
    validator: validate_CalendarCalendarsDelete_580009, base: "/calendar/v3",
    url: url_CalendarCalendarsDelete_580010, schemes: {Scheme.Https})
type
  Call_CalendarAclInsert_580059 = ref object of OpenApiRestCall_579424
proc url_CalendarAclInsert_580061(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclInsert_580060(path: JsonNode; query: JsonNode;
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
  var valid_580062 = path.getOrDefault("calendarId")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "calendarId", valid_580062
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
  var valid_580063 = query.getOrDefault("fields")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "fields", valid_580063
  var valid_580064 = query.getOrDefault("quotaUser")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "quotaUser", valid_580064
  var valid_580065 = query.getOrDefault("alt")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = newJString("json"))
  if valid_580065 != nil:
    section.add "alt", valid_580065
  var valid_580066 = query.getOrDefault("sendNotifications")
  valid_580066 = validateParameter(valid_580066, JBool, required = false, default = nil)
  if valid_580066 != nil:
    section.add "sendNotifications", valid_580066
  var valid_580067 = query.getOrDefault("oauth_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "oauth_token", valid_580067
  var valid_580068 = query.getOrDefault("userIp")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "userIp", valid_580068
  var valid_580069 = query.getOrDefault("key")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "key", valid_580069
  var valid_580070 = query.getOrDefault("prettyPrint")
  valid_580070 = validateParameter(valid_580070, JBool, required = false,
                                 default = newJBool(true))
  if valid_580070 != nil:
    section.add "prettyPrint", valid_580070
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

proc call*(call_580072: Call_CalendarAclInsert_580059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an access control rule.
  ## 
  let valid = call_580072.validator(path, query, header, formData, body)
  let scheme = call_580072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580072.url(scheme.get, call_580072.host, call_580072.base,
                         call_580072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580072, url, valid)

proc call*(call_580073: Call_CalendarAclInsert_580059; calendarId: string;
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
  var path_580074 = newJObject()
  var query_580075 = newJObject()
  var body_580076 = newJObject()
  add(query_580075, "fields", newJString(fields))
  add(query_580075, "quotaUser", newJString(quotaUser))
  add(query_580075, "alt", newJString(alt))
  add(path_580074, "calendarId", newJString(calendarId))
  add(query_580075, "sendNotifications", newJBool(sendNotifications))
  add(query_580075, "oauth_token", newJString(oauthToken))
  add(query_580075, "userIp", newJString(userIp))
  add(query_580075, "key", newJString(key))
  if body != nil:
    body_580076 = body
  add(query_580075, "prettyPrint", newJBool(prettyPrint))
  result = call_580073.call(path_580074, query_580075, nil, nil, body_580076)

var calendarAclInsert* = Call_CalendarAclInsert_580059(name: "calendarAclInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl", validator: validate_CalendarAclInsert_580060,
    base: "/calendar/v3", url: url_CalendarAclInsert_580061, schemes: {Scheme.Https})
type
  Call_CalendarAclList_580040 = ref object of OpenApiRestCall_579424
proc url_CalendarAclList_580042(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclList_580041(path: JsonNode; query: JsonNode;
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
  var valid_580043 = path.getOrDefault("calendarId")
  valid_580043 = validateParameter(valid_580043, JString, required = true,
                                 default = nil)
  if valid_580043 != nil:
    section.add "calendarId", valid_580043
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
  var valid_580044 = query.getOrDefault("fields")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "fields", valid_580044
  var valid_580045 = query.getOrDefault("pageToken")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "pageToken", valid_580045
  var valid_580046 = query.getOrDefault("quotaUser")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "quotaUser", valid_580046
  var valid_580047 = query.getOrDefault("alt")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("json"))
  if valid_580047 != nil:
    section.add "alt", valid_580047
  var valid_580048 = query.getOrDefault("oauth_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "oauth_token", valid_580048
  var valid_580049 = query.getOrDefault("syncToken")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "syncToken", valid_580049
  var valid_580050 = query.getOrDefault("userIp")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "userIp", valid_580050
  var valid_580051 = query.getOrDefault("maxResults")
  valid_580051 = validateParameter(valid_580051, JInt, required = false, default = nil)
  if valid_580051 != nil:
    section.add "maxResults", valid_580051
  var valid_580052 = query.getOrDefault("showDeleted")
  valid_580052 = validateParameter(valid_580052, JBool, required = false, default = nil)
  if valid_580052 != nil:
    section.add "showDeleted", valid_580052
  var valid_580053 = query.getOrDefault("key")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "key", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580055: Call_CalendarAclList_580040; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the rules in the access control list for the calendar.
  ## 
  let valid = call_580055.validator(path, query, header, formData, body)
  let scheme = call_580055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580055.url(scheme.get, call_580055.host, call_580055.base,
                         call_580055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580055, url, valid)

proc call*(call_580056: Call_CalendarAclList_580040; calendarId: string;
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
  var path_580057 = newJObject()
  var query_580058 = newJObject()
  add(query_580058, "fields", newJString(fields))
  add(query_580058, "pageToken", newJString(pageToken))
  add(query_580058, "quotaUser", newJString(quotaUser))
  add(query_580058, "alt", newJString(alt))
  add(path_580057, "calendarId", newJString(calendarId))
  add(query_580058, "oauth_token", newJString(oauthToken))
  add(query_580058, "syncToken", newJString(syncToken))
  add(query_580058, "userIp", newJString(userIp))
  add(query_580058, "maxResults", newJInt(maxResults))
  add(query_580058, "showDeleted", newJBool(showDeleted))
  add(query_580058, "key", newJString(key))
  add(query_580058, "prettyPrint", newJBool(prettyPrint))
  result = call_580056.call(path_580057, query_580058, nil, nil, nil)

var calendarAclList* = Call_CalendarAclList_580040(name: "calendarAclList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl", validator: validate_CalendarAclList_580041,
    base: "/calendar/v3", url: url_CalendarAclList_580042, schemes: {Scheme.Https})
type
  Call_CalendarAclWatch_580077 = ref object of OpenApiRestCall_579424
proc url_CalendarAclWatch_580079(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclWatch_580078(path: JsonNode; query: JsonNode;
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
  var valid_580080 = path.getOrDefault("calendarId")
  valid_580080 = validateParameter(valid_580080, JString, required = true,
                                 default = nil)
  if valid_580080 != nil:
    section.add "calendarId", valid_580080
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
  var valid_580081 = query.getOrDefault("fields")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "fields", valid_580081
  var valid_580082 = query.getOrDefault("pageToken")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "pageToken", valid_580082
  var valid_580083 = query.getOrDefault("quotaUser")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "quotaUser", valid_580083
  var valid_580084 = query.getOrDefault("alt")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("json"))
  if valid_580084 != nil:
    section.add "alt", valid_580084
  var valid_580085 = query.getOrDefault("oauth_token")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "oauth_token", valid_580085
  var valid_580086 = query.getOrDefault("syncToken")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "syncToken", valid_580086
  var valid_580087 = query.getOrDefault("userIp")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "userIp", valid_580087
  var valid_580088 = query.getOrDefault("maxResults")
  valid_580088 = validateParameter(valid_580088, JInt, required = false, default = nil)
  if valid_580088 != nil:
    section.add "maxResults", valid_580088
  var valid_580089 = query.getOrDefault("showDeleted")
  valid_580089 = validateParameter(valid_580089, JBool, required = false, default = nil)
  if valid_580089 != nil:
    section.add "showDeleted", valid_580089
  var valid_580090 = query.getOrDefault("key")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "key", valid_580090
  var valid_580091 = query.getOrDefault("prettyPrint")
  valid_580091 = validateParameter(valid_580091, JBool, required = false,
                                 default = newJBool(true))
  if valid_580091 != nil:
    section.add "prettyPrint", valid_580091
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

proc call*(call_580093: Call_CalendarAclWatch_580077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to ACL resources.
  ## 
  let valid = call_580093.validator(path, query, header, formData, body)
  let scheme = call_580093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580093.url(scheme.get, call_580093.host, call_580093.base,
                         call_580093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580093, url, valid)

proc call*(call_580094: Call_CalendarAclWatch_580077; calendarId: string;
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
  var path_580095 = newJObject()
  var query_580096 = newJObject()
  var body_580097 = newJObject()
  add(query_580096, "fields", newJString(fields))
  add(query_580096, "pageToken", newJString(pageToken))
  add(query_580096, "quotaUser", newJString(quotaUser))
  add(query_580096, "alt", newJString(alt))
  add(path_580095, "calendarId", newJString(calendarId))
  add(query_580096, "oauth_token", newJString(oauthToken))
  add(query_580096, "syncToken", newJString(syncToken))
  add(query_580096, "userIp", newJString(userIp))
  add(query_580096, "maxResults", newJInt(maxResults))
  add(query_580096, "showDeleted", newJBool(showDeleted))
  add(query_580096, "key", newJString(key))
  if resource != nil:
    body_580097 = resource
  add(query_580096, "prettyPrint", newJBool(prettyPrint))
  result = call_580094.call(path_580095, query_580096, nil, nil, body_580097)

var calendarAclWatch* = Call_CalendarAclWatch_580077(name: "calendarAclWatch",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/watch",
    validator: validate_CalendarAclWatch_580078, base: "/calendar/v3",
    url: url_CalendarAclWatch_580079, schemes: {Scheme.Https})
type
  Call_CalendarAclUpdate_580114 = ref object of OpenApiRestCall_579424
proc url_CalendarAclUpdate_580116(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclUpdate_580115(path: JsonNode; query: JsonNode;
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
  var valid_580117 = path.getOrDefault("calendarId")
  valid_580117 = validateParameter(valid_580117, JString, required = true,
                                 default = nil)
  if valid_580117 != nil:
    section.add "calendarId", valid_580117
  var valid_580118 = path.getOrDefault("ruleId")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "ruleId", valid_580118
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
  var valid_580119 = query.getOrDefault("fields")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "fields", valid_580119
  var valid_580120 = query.getOrDefault("quotaUser")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "quotaUser", valid_580120
  var valid_580121 = query.getOrDefault("alt")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("json"))
  if valid_580121 != nil:
    section.add "alt", valid_580121
  var valid_580122 = query.getOrDefault("sendNotifications")
  valid_580122 = validateParameter(valid_580122, JBool, required = false, default = nil)
  if valid_580122 != nil:
    section.add "sendNotifications", valid_580122
  var valid_580123 = query.getOrDefault("oauth_token")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "oauth_token", valid_580123
  var valid_580124 = query.getOrDefault("userIp")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "userIp", valid_580124
  var valid_580125 = query.getOrDefault("key")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "key", valid_580125
  var valid_580126 = query.getOrDefault("prettyPrint")
  valid_580126 = validateParameter(valid_580126, JBool, required = false,
                                 default = newJBool(true))
  if valid_580126 != nil:
    section.add "prettyPrint", valid_580126
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

proc call*(call_580128: Call_CalendarAclUpdate_580114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an access control rule.
  ## 
  let valid = call_580128.validator(path, query, header, formData, body)
  let scheme = call_580128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580128.url(scheme.get, call_580128.host, call_580128.base,
                         call_580128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580128, url, valid)

proc call*(call_580129: Call_CalendarAclUpdate_580114; calendarId: string;
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
  var path_580130 = newJObject()
  var query_580131 = newJObject()
  var body_580132 = newJObject()
  add(query_580131, "fields", newJString(fields))
  add(query_580131, "quotaUser", newJString(quotaUser))
  add(query_580131, "alt", newJString(alt))
  add(path_580130, "calendarId", newJString(calendarId))
  add(query_580131, "sendNotifications", newJBool(sendNotifications))
  add(query_580131, "oauth_token", newJString(oauthToken))
  add(query_580131, "userIp", newJString(userIp))
  add(query_580131, "key", newJString(key))
  add(path_580130, "ruleId", newJString(ruleId))
  if body != nil:
    body_580132 = body
  add(query_580131, "prettyPrint", newJBool(prettyPrint))
  result = call_580129.call(path_580130, query_580131, nil, nil, body_580132)

var calendarAclUpdate* = Call_CalendarAclUpdate_580114(name: "calendarAclUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclUpdate_580115, base: "/calendar/v3",
    url: url_CalendarAclUpdate_580116, schemes: {Scheme.Https})
type
  Call_CalendarAclGet_580098 = ref object of OpenApiRestCall_579424
proc url_CalendarAclGet_580100(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclGet_580099(path: JsonNode; query: JsonNode;
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
  var valid_580101 = path.getOrDefault("calendarId")
  valid_580101 = validateParameter(valid_580101, JString, required = true,
                                 default = nil)
  if valid_580101 != nil:
    section.add "calendarId", valid_580101
  var valid_580102 = path.getOrDefault("ruleId")
  valid_580102 = validateParameter(valid_580102, JString, required = true,
                                 default = nil)
  if valid_580102 != nil:
    section.add "ruleId", valid_580102
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
  var valid_580103 = query.getOrDefault("fields")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "fields", valid_580103
  var valid_580104 = query.getOrDefault("quotaUser")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "quotaUser", valid_580104
  var valid_580105 = query.getOrDefault("alt")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = newJString("json"))
  if valid_580105 != nil:
    section.add "alt", valid_580105
  var valid_580106 = query.getOrDefault("oauth_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "oauth_token", valid_580106
  var valid_580107 = query.getOrDefault("userIp")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "userIp", valid_580107
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("prettyPrint")
  valid_580109 = validateParameter(valid_580109, JBool, required = false,
                                 default = newJBool(true))
  if valid_580109 != nil:
    section.add "prettyPrint", valid_580109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580110: Call_CalendarAclGet_580098; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an access control rule.
  ## 
  let valid = call_580110.validator(path, query, header, formData, body)
  let scheme = call_580110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580110.url(scheme.get, call_580110.host, call_580110.base,
                         call_580110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580110, url, valid)

proc call*(call_580111: Call_CalendarAclGet_580098; calendarId: string;
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
  var path_580112 = newJObject()
  var query_580113 = newJObject()
  add(query_580113, "fields", newJString(fields))
  add(query_580113, "quotaUser", newJString(quotaUser))
  add(query_580113, "alt", newJString(alt))
  add(path_580112, "calendarId", newJString(calendarId))
  add(query_580113, "oauth_token", newJString(oauthToken))
  add(query_580113, "userIp", newJString(userIp))
  add(query_580113, "key", newJString(key))
  add(path_580112, "ruleId", newJString(ruleId))
  add(query_580113, "prettyPrint", newJBool(prettyPrint))
  result = call_580111.call(path_580112, query_580113, nil, nil, nil)

var calendarAclGet* = Call_CalendarAclGet_580098(name: "calendarAclGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclGet_580099, base: "/calendar/v3",
    url: url_CalendarAclGet_580100, schemes: {Scheme.Https})
type
  Call_CalendarAclPatch_580149 = ref object of OpenApiRestCall_579424
proc url_CalendarAclPatch_580151(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclPatch_580150(path: JsonNode; query: JsonNode;
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
  var valid_580152 = path.getOrDefault("calendarId")
  valid_580152 = validateParameter(valid_580152, JString, required = true,
                                 default = nil)
  if valid_580152 != nil:
    section.add "calendarId", valid_580152
  var valid_580153 = path.getOrDefault("ruleId")
  valid_580153 = validateParameter(valid_580153, JString, required = true,
                                 default = nil)
  if valid_580153 != nil:
    section.add "ruleId", valid_580153
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
  var valid_580154 = query.getOrDefault("fields")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "fields", valid_580154
  var valid_580155 = query.getOrDefault("quotaUser")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "quotaUser", valid_580155
  var valid_580156 = query.getOrDefault("alt")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = newJString("json"))
  if valid_580156 != nil:
    section.add "alt", valid_580156
  var valid_580157 = query.getOrDefault("sendNotifications")
  valid_580157 = validateParameter(valid_580157, JBool, required = false, default = nil)
  if valid_580157 != nil:
    section.add "sendNotifications", valid_580157
  var valid_580158 = query.getOrDefault("oauth_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "oauth_token", valid_580158
  var valid_580159 = query.getOrDefault("userIp")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "userIp", valid_580159
  var valid_580160 = query.getOrDefault("key")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "key", valid_580160
  var valid_580161 = query.getOrDefault("prettyPrint")
  valid_580161 = validateParameter(valid_580161, JBool, required = false,
                                 default = newJBool(true))
  if valid_580161 != nil:
    section.add "prettyPrint", valid_580161
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

proc call*(call_580163: Call_CalendarAclPatch_580149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an access control rule. This method supports patch semantics.
  ## 
  let valid = call_580163.validator(path, query, header, formData, body)
  let scheme = call_580163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580163.url(scheme.get, call_580163.host, call_580163.base,
                         call_580163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580163, url, valid)

proc call*(call_580164: Call_CalendarAclPatch_580149; calendarId: string;
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
  var path_580165 = newJObject()
  var query_580166 = newJObject()
  var body_580167 = newJObject()
  add(query_580166, "fields", newJString(fields))
  add(query_580166, "quotaUser", newJString(quotaUser))
  add(query_580166, "alt", newJString(alt))
  add(path_580165, "calendarId", newJString(calendarId))
  add(query_580166, "sendNotifications", newJBool(sendNotifications))
  add(query_580166, "oauth_token", newJString(oauthToken))
  add(query_580166, "userIp", newJString(userIp))
  add(query_580166, "key", newJString(key))
  add(path_580165, "ruleId", newJString(ruleId))
  if body != nil:
    body_580167 = body
  add(query_580166, "prettyPrint", newJBool(prettyPrint))
  result = call_580164.call(path_580165, query_580166, nil, nil, body_580167)

var calendarAclPatch* = Call_CalendarAclPatch_580149(name: "calendarAclPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclPatch_580150, base: "/calendar/v3",
    url: url_CalendarAclPatch_580151, schemes: {Scheme.Https})
type
  Call_CalendarAclDelete_580133 = ref object of OpenApiRestCall_579424
proc url_CalendarAclDelete_580135(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarAclDelete_580134(path: JsonNode; query: JsonNode;
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
  var valid_580136 = path.getOrDefault("calendarId")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = nil)
  if valid_580136 != nil:
    section.add "calendarId", valid_580136
  var valid_580137 = path.getOrDefault("ruleId")
  valid_580137 = validateParameter(valid_580137, JString, required = true,
                                 default = nil)
  if valid_580137 != nil:
    section.add "ruleId", valid_580137
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
  var valid_580138 = query.getOrDefault("fields")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "fields", valid_580138
  var valid_580139 = query.getOrDefault("quotaUser")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "quotaUser", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("userIp")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "userIp", valid_580142
  var valid_580143 = query.getOrDefault("key")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "key", valid_580143
  var valid_580144 = query.getOrDefault("prettyPrint")
  valid_580144 = validateParameter(valid_580144, JBool, required = false,
                                 default = newJBool(true))
  if valid_580144 != nil:
    section.add "prettyPrint", valid_580144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580145: Call_CalendarAclDelete_580133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an access control rule.
  ## 
  let valid = call_580145.validator(path, query, header, formData, body)
  let scheme = call_580145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580145.url(scheme.get, call_580145.host, call_580145.base,
                         call_580145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580145, url, valid)

proc call*(call_580146: Call_CalendarAclDelete_580133; calendarId: string;
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
  var path_580147 = newJObject()
  var query_580148 = newJObject()
  add(query_580148, "fields", newJString(fields))
  add(query_580148, "quotaUser", newJString(quotaUser))
  add(query_580148, "alt", newJString(alt))
  add(path_580147, "calendarId", newJString(calendarId))
  add(query_580148, "oauth_token", newJString(oauthToken))
  add(query_580148, "userIp", newJString(userIp))
  add(query_580148, "key", newJString(key))
  add(path_580147, "ruleId", newJString(ruleId))
  add(query_580148, "prettyPrint", newJBool(prettyPrint))
  result = call_580146.call(path_580147, query_580148, nil, nil, nil)

var calendarAclDelete* = Call_CalendarAclDelete_580133(name: "calendarAclDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/acl/{ruleId}",
    validator: validate_CalendarAclDelete_580134, base: "/calendar/v3",
    url: url_CalendarAclDelete_580135, schemes: {Scheme.Https})
type
  Call_CalendarCalendarsClear_580168 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarsClear_580170(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarsClear_580169(path: JsonNode; query: JsonNode;
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
  var valid_580171 = path.getOrDefault("calendarId")
  valid_580171 = validateParameter(valid_580171, JString, required = true,
                                 default = nil)
  if valid_580171 != nil:
    section.add "calendarId", valid_580171
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
  var valid_580172 = query.getOrDefault("fields")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "fields", valid_580172
  var valid_580173 = query.getOrDefault("quotaUser")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "quotaUser", valid_580173
  var valid_580174 = query.getOrDefault("alt")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = newJString("json"))
  if valid_580174 != nil:
    section.add "alt", valid_580174
  var valid_580175 = query.getOrDefault("oauth_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "oauth_token", valid_580175
  var valid_580176 = query.getOrDefault("userIp")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "userIp", valid_580176
  var valid_580177 = query.getOrDefault("key")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "key", valid_580177
  var valid_580178 = query.getOrDefault("prettyPrint")
  valid_580178 = validateParameter(valid_580178, JBool, required = false,
                                 default = newJBool(true))
  if valid_580178 != nil:
    section.add "prettyPrint", valid_580178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580179: Call_CalendarCalendarsClear_580168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears a primary calendar. This operation deletes all events associated with the primary calendar of an account.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_CalendarCalendarsClear_580168; calendarId: string;
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
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(query_580182, "alt", newJString(alt))
  add(path_580181, "calendarId", newJString(calendarId))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(query_580182, "userIp", newJString(userIp))
  add(query_580182, "key", newJString(key))
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  result = call_580180.call(path_580181, query_580182, nil, nil, nil)

var calendarCalendarsClear* = Call_CalendarCalendarsClear_580168(
    name: "calendarCalendarsClear", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/clear",
    validator: validate_CalendarCalendarsClear_580169, base: "/calendar/v3",
    url: url_CalendarCalendarsClear_580170, schemes: {Scheme.Https})
type
  Call_CalendarEventsInsert_580216 = ref object of OpenApiRestCall_579424
proc url_CalendarEventsInsert_580218(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsInsert_580217(path: JsonNode; query: JsonNode;
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
  var valid_580219 = path.getOrDefault("calendarId")
  valid_580219 = validateParameter(valid_580219, JString, required = true,
                                 default = nil)
  if valid_580219 != nil:
    section.add "calendarId", valid_580219
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
  var valid_580220 = query.getOrDefault("fields")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "fields", valid_580220
  var valid_580221 = query.getOrDefault("quotaUser")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "quotaUser", valid_580221
  var valid_580222 = query.getOrDefault("alt")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = newJString("json"))
  if valid_580222 != nil:
    section.add "alt", valid_580222
  var valid_580223 = query.getOrDefault("supportsAttachments")
  valid_580223 = validateParameter(valid_580223, JBool, required = false, default = nil)
  if valid_580223 != nil:
    section.add "supportsAttachments", valid_580223
  var valid_580224 = query.getOrDefault("maxAttendees")
  valid_580224 = validateParameter(valid_580224, JInt, required = false, default = nil)
  if valid_580224 != nil:
    section.add "maxAttendees", valid_580224
  var valid_580225 = query.getOrDefault("sendNotifications")
  valid_580225 = validateParameter(valid_580225, JBool, required = false, default = nil)
  if valid_580225 != nil:
    section.add "sendNotifications", valid_580225
  var valid_580226 = query.getOrDefault("oauth_token")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "oauth_token", valid_580226
  var valid_580227 = query.getOrDefault("conferenceDataVersion")
  valid_580227 = validateParameter(valid_580227, JInt, required = false, default = nil)
  if valid_580227 != nil:
    section.add "conferenceDataVersion", valid_580227
  var valid_580228 = query.getOrDefault("userIp")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "userIp", valid_580228
  var valid_580229 = query.getOrDefault("sendUpdates")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = newJString("all"))
  if valid_580229 != nil:
    section.add "sendUpdates", valid_580229
  var valid_580230 = query.getOrDefault("key")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "key", valid_580230
  var valid_580231 = query.getOrDefault("prettyPrint")
  valid_580231 = validateParameter(valid_580231, JBool, required = false,
                                 default = newJBool(true))
  if valid_580231 != nil:
    section.add "prettyPrint", valid_580231
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

proc call*(call_580233: Call_CalendarEventsInsert_580216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an event.
  ## 
  let valid = call_580233.validator(path, query, header, formData, body)
  let scheme = call_580233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580233.url(scheme.get, call_580233.host, call_580233.base,
                         call_580233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580233, url, valid)

proc call*(call_580234: Call_CalendarEventsInsert_580216; calendarId: string;
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
  var path_580235 = newJObject()
  var query_580236 = newJObject()
  var body_580237 = newJObject()
  add(query_580236, "fields", newJString(fields))
  add(query_580236, "quotaUser", newJString(quotaUser))
  add(query_580236, "alt", newJString(alt))
  add(query_580236, "supportsAttachments", newJBool(supportsAttachments))
  add(query_580236, "maxAttendees", newJInt(maxAttendees))
  add(path_580235, "calendarId", newJString(calendarId))
  add(query_580236, "sendNotifications", newJBool(sendNotifications))
  add(query_580236, "oauth_token", newJString(oauthToken))
  add(query_580236, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_580236, "userIp", newJString(userIp))
  add(query_580236, "sendUpdates", newJString(sendUpdates))
  add(query_580236, "key", newJString(key))
  if body != nil:
    body_580237 = body
  add(query_580236, "prettyPrint", newJBool(prettyPrint))
  result = call_580234.call(path_580235, query_580236, nil, nil, body_580237)

var calendarEventsInsert* = Call_CalendarEventsInsert_580216(
    name: "calendarEventsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events",
    validator: validate_CalendarEventsInsert_580217, base: "/calendar/v3",
    url: url_CalendarEventsInsert_580218, schemes: {Scheme.Https})
type
  Call_CalendarEventsList_580183 = ref object of OpenApiRestCall_579424
proc url_CalendarEventsList_580185(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsList_580184(path: JsonNode; query: JsonNode;
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
  var valid_580186 = path.getOrDefault("calendarId")
  valid_580186 = validateParameter(valid_580186, JString, required = true,
                                 default = nil)
  if valid_580186 != nil:
    section.add "calendarId", valid_580186
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
  var valid_580187 = query.getOrDefault("privateExtendedProperty")
  valid_580187 = validateParameter(valid_580187, JArray, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "privateExtendedProperty", valid_580187
  var valid_580188 = query.getOrDefault("fields")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "fields", valid_580188
  var valid_580189 = query.getOrDefault("pageToken")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "pageToken", valid_580189
  var valid_580190 = query.getOrDefault("quotaUser")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "quotaUser", valid_580190
  var valid_580191 = query.getOrDefault("alt")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = newJString("json"))
  if valid_580191 != nil:
    section.add "alt", valid_580191
  var valid_580192 = query.getOrDefault("maxAttendees")
  valid_580192 = validateParameter(valid_580192, JInt, required = false, default = nil)
  if valid_580192 != nil:
    section.add "maxAttendees", valid_580192
  var valid_580193 = query.getOrDefault("showHiddenInvitations")
  valid_580193 = validateParameter(valid_580193, JBool, required = false, default = nil)
  if valid_580193 != nil:
    section.add "showHiddenInvitations", valid_580193
  var valid_580194 = query.getOrDefault("timeMax")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "timeMax", valid_580194
  var valid_580195 = query.getOrDefault("oauth_token")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "oauth_token", valid_580195
  var valid_580196 = query.getOrDefault("timeMin")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "timeMin", valid_580196
  var valid_580197 = query.getOrDefault("syncToken")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "syncToken", valid_580197
  var valid_580198 = query.getOrDefault("userIp")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "userIp", valid_580198
  var valid_580200 = query.getOrDefault("maxResults")
  valid_580200 = validateParameter(valid_580200, JInt, required = false,
                                 default = newJInt(250))
  if valid_580200 != nil:
    section.add "maxResults", valid_580200
  var valid_580201 = query.getOrDefault("orderBy")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = newJString("startTime"))
  if valid_580201 != nil:
    section.add "orderBy", valid_580201
  var valid_580202 = query.getOrDefault("timeZone")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "timeZone", valid_580202
  var valid_580203 = query.getOrDefault("q")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "q", valid_580203
  var valid_580204 = query.getOrDefault("iCalUID")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "iCalUID", valid_580204
  var valid_580205 = query.getOrDefault("showDeleted")
  valid_580205 = validateParameter(valid_580205, JBool, required = false, default = nil)
  if valid_580205 != nil:
    section.add "showDeleted", valid_580205
  var valid_580206 = query.getOrDefault("key")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "key", valid_580206
  var valid_580207 = query.getOrDefault("updatedMin")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "updatedMin", valid_580207
  var valid_580208 = query.getOrDefault("singleEvents")
  valid_580208 = validateParameter(valid_580208, JBool, required = false, default = nil)
  if valid_580208 != nil:
    section.add "singleEvents", valid_580208
  var valid_580209 = query.getOrDefault("sharedExtendedProperty")
  valid_580209 = validateParameter(valid_580209, JArray, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "sharedExtendedProperty", valid_580209
  var valid_580210 = query.getOrDefault("alwaysIncludeEmail")
  valid_580210 = validateParameter(valid_580210, JBool, required = false, default = nil)
  if valid_580210 != nil:
    section.add "alwaysIncludeEmail", valid_580210
  var valid_580211 = query.getOrDefault("prettyPrint")
  valid_580211 = validateParameter(valid_580211, JBool, required = false,
                                 default = newJBool(true))
  if valid_580211 != nil:
    section.add "prettyPrint", valid_580211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580212: Call_CalendarEventsList_580183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns events on the specified calendar.
  ## 
  let valid = call_580212.validator(path, query, header, formData, body)
  let scheme = call_580212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580212.url(scheme.get, call_580212.host, call_580212.base,
                         call_580212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580212, url, valid)

proc call*(call_580213: Call_CalendarEventsList_580183; calendarId: string;
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
  var path_580214 = newJObject()
  var query_580215 = newJObject()
  if privateExtendedProperty != nil:
    query_580215.add "privateExtendedProperty", privateExtendedProperty
  add(query_580215, "fields", newJString(fields))
  add(query_580215, "pageToken", newJString(pageToken))
  add(query_580215, "quotaUser", newJString(quotaUser))
  add(query_580215, "alt", newJString(alt))
  add(query_580215, "maxAttendees", newJInt(maxAttendees))
  add(query_580215, "showHiddenInvitations", newJBool(showHiddenInvitations))
  add(path_580214, "calendarId", newJString(calendarId))
  add(query_580215, "timeMax", newJString(timeMax))
  add(query_580215, "oauth_token", newJString(oauthToken))
  add(query_580215, "timeMin", newJString(timeMin))
  add(query_580215, "syncToken", newJString(syncToken))
  add(query_580215, "userIp", newJString(userIp))
  add(query_580215, "maxResults", newJInt(maxResults))
  add(query_580215, "orderBy", newJString(orderBy))
  add(query_580215, "timeZone", newJString(timeZone))
  add(query_580215, "q", newJString(q))
  add(query_580215, "iCalUID", newJString(iCalUID))
  add(query_580215, "showDeleted", newJBool(showDeleted))
  add(query_580215, "key", newJString(key))
  add(query_580215, "updatedMin", newJString(updatedMin))
  add(query_580215, "singleEvents", newJBool(singleEvents))
  if sharedExtendedProperty != nil:
    query_580215.add "sharedExtendedProperty", sharedExtendedProperty
  add(query_580215, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_580215, "prettyPrint", newJBool(prettyPrint))
  result = call_580213.call(path_580214, query_580215, nil, nil, nil)

var calendarEventsList* = Call_CalendarEventsList_580183(
    name: "calendarEventsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events",
    validator: validate_CalendarEventsList_580184, base: "/calendar/v3",
    url: url_CalendarEventsList_580185, schemes: {Scheme.Https})
type
  Call_CalendarEventsImport_580238 = ref object of OpenApiRestCall_579424
proc url_CalendarEventsImport_580240(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsImport_580239(path: JsonNode; query: JsonNode;
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
  var valid_580241 = path.getOrDefault("calendarId")
  valid_580241 = validateParameter(valid_580241, JString, required = true,
                                 default = nil)
  if valid_580241 != nil:
    section.add "calendarId", valid_580241
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
  var valid_580242 = query.getOrDefault("fields")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "fields", valid_580242
  var valid_580243 = query.getOrDefault("quotaUser")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "quotaUser", valid_580243
  var valid_580244 = query.getOrDefault("alt")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("json"))
  if valid_580244 != nil:
    section.add "alt", valid_580244
  var valid_580245 = query.getOrDefault("supportsAttachments")
  valid_580245 = validateParameter(valid_580245, JBool, required = false, default = nil)
  if valid_580245 != nil:
    section.add "supportsAttachments", valid_580245
  var valid_580246 = query.getOrDefault("oauth_token")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "oauth_token", valid_580246
  var valid_580247 = query.getOrDefault("conferenceDataVersion")
  valid_580247 = validateParameter(valid_580247, JInt, required = false, default = nil)
  if valid_580247 != nil:
    section.add "conferenceDataVersion", valid_580247
  var valid_580248 = query.getOrDefault("userIp")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "userIp", valid_580248
  var valid_580249 = query.getOrDefault("key")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "key", valid_580249
  var valid_580250 = query.getOrDefault("prettyPrint")
  valid_580250 = validateParameter(valid_580250, JBool, required = false,
                                 default = newJBool(true))
  if valid_580250 != nil:
    section.add "prettyPrint", valid_580250
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

proc call*(call_580252: Call_CalendarEventsImport_580238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports an event. This operation is used to add a private copy of an existing event to a calendar.
  ## 
  let valid = call_580252.validator(path, query, header, formData, body)
  let scheme = call_580252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580252.url(scheme.get, call_580252.host, call_580252.base,
                         call_580252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580252, url, valid)

proc call*(call_580253: Call_CalendarEventsImport_580238; calendarId: string;
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
  var path_580254 = newJObject()
  var query_580255 = newJObject()
  var body_580256 = newJObject()
  add(query_580255, "fields", newJString(fields))
  add(query_580255, "quotaUser", newJString(quotaUser))
  add(query_580255, "alt", newJString(alt))
  add(query_580255, "supportsAttachments", newJBool(supportsAttachments))
  add(path_580254, "calendarId", newJString(calendarId))
  add(query_580255, "oauth_token", newJString(oauthToken))
  add(query_580255, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_580255, "userIp", newJString(userIp))
  add(query_580255, "key", newJString(key))
  if body != nil:
    body_580256 = body
  add(query_580255, "prettyPrint", newJBool(prettyPrint))
  result = call_580253.call(path_580254, query_580255, nil, nil, body_580256)

var calendarEventsImport* = Call_CalendarEventsImport_580238(
    name: "calendarEventsImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/import",
    validator: validate_CalendarEventsImport_580239, base: "/calendar/v3",
    url: url_CalendarEventsImport_580240, schemes: {Scheme.Https})
type
  Call_CalendarEventsQuickAdd_580257 = ref object of OpenApiRestCall_579424
proc url_CalendarEventsQuickAdd_580259(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsQuickAdd_580258(path: JsonNode; query: JsonNode;
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
  var valid_580260 = path.getOrDefault("calendarId")
  valid_580260 = validateParameter(valid_580260, JString, required = true,
                                 default = nil)
  if valid_580260 != nil:
    section.add "calendarId", valid_580260
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
  var valid_580261 = query.getOrDefault("fields")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "fields", valid_580261
  var valid_580262 = query.getOrDefault("quotaUser")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "quotaUser", valid_580262
  var valid_580263 = query.getOrDefault("alt")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = newJString("json"))
  if valid_580263 != nil:
    section.add "alt", valid_580263
  var valid_580264 = query.getOrDefault("sendNotifications")
  valid_580264 = validateParameter(valid_580264, JBool, required = false, default = nil)
  if valid_580264 != nil:
    section.add "sendNotifications", valid_580264
  var valid_580265 = query.getOrDefault("oauth_token")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "oauth_token", valid_580265
  var valid_580266 = query.getOrDefault("userIp")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "userIp", valid_580266
  var valid_580267 = query.getOrDefault("sendUpdates")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = newJString("all"))
  if valid_580267 != nil:
    section.add "sendUpdates", valid_580267
  var valid_580268 = query.getOrDefault("key")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "key", valid_580268
  assert query != nil, "query argument is necessary due to required `text` field"
  var valid_580269 = query.getOrDefault("text")
  valid_580269 = validateParameter(valid_580269, JString, required = true,
                                 default = nil)
  if valid_580269 != nil:
    section.add "text", valid_580269
  var valid_580270 = query.getOrDefault("prettyPrint")
  valid_580270 = validateParameter(valid_580270, JBool, required = false,
                                 default = newJBool(true))
  if valid_580270 != nil:
    section.add "prettyPrint", valid_580270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580271: Call_CalendarEventsQuickAdd_580257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an event based on a simple text string.
  ## 
  let valid = call_580271.validator(path, query, header, formData, body)
  let scheme = call_580271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580271.url(scheme.get, call_580271.host, call_580271.base,
                         call_580271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580271, url, valid)

proc call*(call_580272: Call_CalendarEventsQuickAdd_580257; calendarId: string;
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
  var path_580273 = newJObject()
  var query_580274 = newJObject()
  add(query_580274, "fields", newJString(fields))
  add(query_580274, "quotaUser", newJString(quotaUser))
  add(query_580274, "alt", newJString(alt))
  add(path_580273, "calendarId", newJString(calendarId))
  add(query_580274, "sendNotifications", newJBool(sendNotifications))
  add(query_580274, "oauth_token", newJString(oauthToken))
  add(query_580274, "userIp", newJString(userIp))
  add(query_580274, "sendUpdates", newJString(sendUpdates))
  add(query_580274, "key", newJString(key))
  add(query_580274, "text", newJString(text))
  add(query_580274, "prettyPrint", newJBool(prettyPrint))
  result = call_580272.call(path_580273, query_580274, nil, nil, nil)

var calendarEventsQuickAdd* = Call_CalendarEventsQuickAdd_580257(
    name: "calendarEventsQuickAdd", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/quickAdd",
    validator: validate_CalendarEventsQuickAdd_580258, base: "/calendar/v3",
    url: url_CalendarEventsQuickAdd_580259, schemes: {Scheme.Https})
type
  Call_CalendarEventsWatch_580275 = ref object of OpenApiRestCall_579424
proc url_CalendarEventsWatch_580277(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsWatch_580276(path: JsonNode; query: JsonNode;
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
  var valid_580278 = path.getOrDefault("calendarId")
  valid_580278 = validateParameter(valid_580278, JString, required = true,
                                 default = nil)
  if valid_580278 != nil:
    section.add "calendarId", valid_580278
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
  var valid_580279 = query.getOrDefault("privateExtendedProperty")
  valid_580279 = validateParameter(valid_580279, JArray, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "privateExtendedProperty", valid_580279
  var valid_580280 = query.getOrDefault("fields")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "fields", valid_580280
  var valid_580281 = query.getOrDefault("pageToken")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "pageToken", valid_580281
  var valid_580282 = query.getOrDefault("quotaUser")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "quotaUser", valid_580282
  var valid_580283 = query.getOrDefault("alt")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = newJString("json"))
  if valid_580283 != nil:
    section.add "alt", valid_580283
  var valid_580284 = query.getOrDefault("maxAttendees")
  valid_580284 = validateParameter(valid_580284, JInt, required = false, default = nil)
  if valid_580284 != nil:
    section.add "maxAttendees", valid_580284
  var valid_580285 = query.getOrDefault("showHiddenInvitations")
  valid_580285 = validateParameter(valid_580285, JBool, required = false, default = nil)
  if valid_580285 != nil:
    section.add "showHiddenInvitations", valid_580285
  var valid_580286 = query.getOrDefault("timeMax")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "timeMax", valid_580286
  var valid_580287 = query.getOrDefault("oauth_token")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "oauth_token", valid_580287
  var valid_580288 = query.getOrDefault("timeMin")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "timeMin", valid_580288
  var valid_580289 = query.getOrDefault("syncToken")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "syncToken", valid_580289
  var valid_580290 = query.getOrDefault("userIp")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "userIp", valid_580290
  var valid_580291 = query.getOrDefault("maxResults")
  valid_580291 = validateParameter(valid_580291, JInt, required = false,
                                 default = newJInt(250))
  if valid_580291 != nil:
    section.add "maxResults", valid_580291
  var valid_580292 = query.getOrDefault("orderBy")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = newJString("startTime"))
  if valid_580292 != nil:
    section.add "orderBy", valid_580292
  var valid_580293 = query.getOrDefault("timeZone")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "timeZone", valid_580293
  var valid_580294 = query.getOrDefault("q")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "q", valid_580294
  var valid_580295 = query.getOrDefault("iCalUID")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "iCalUID", valid_580295
  var valid_580296 = query.getOrDefault("showDeleted")
  valid_580296 = validateParameter(valid_580296, JBool, required = false, default = nil)
  if valid_580296 != nil:
    section.add "showDeleted", valid_580296
  var valid_580297 = query.getOrDefault("key")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "key", valid_580297
  var valid_580298 = query.getOrDefault("updatedMin")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "updatedMin", valid_580298
  var valid_580299 = query.getOrDefault("singleEvents")
  valid_580299 = validateParameter(valid_580299, JBool, required = false, default = nil)
  if valid_580299 != nil:
    section.add "singleEvents", valid_580299
  var valid_580300 = query.getOrDefault("sharedExtendedProperty")
  valid_580300 = validateParameter(valid_580300, JArray, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "sharedExtendedProperty", valid_580300
  var valid_580301 = query.getOrDefault("alwaysIncludeEmail")
  valid_580301 = validateParameter(valid_580301, JBool, required = false, default = nil)
  if valid_580301 != nil:
    section.add "alwaysIncludeEmail", valid_580301
  var valid_580302 = query.getOrDefault("prettyPrint")
  valid_580302 = validateParameter(valid_580302, JBool, required = false,
                                 default = newJBool(true))
  if valid_580302 != nil:
    section.add "prettyPrint", valid_580302
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

proc call*(call_580304: Call_CalendarEventsWatch_580275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to Events resources.
  ## 
  let valid = call_580304.validator(path, query, header, formData, body)
  let scheme = call_580304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580304.url(scheme.get, call_580304.host, call_580304.base,
                         call_580304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580304, url, valid)

proc call*(call_580305: Call_CalendarEventsWatch_580275; calendarId: string;
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
  var path_580306 = newJObject()
  var query_580307 = newJObject()
  var body_580308 = newJObject()
  if privateExtendedProperty != nil:
    query_580307.add "privateExtendedProperty", privateExtendedProperty
  add(query_580307, "fields", newJString(fields))
  add(query_580307, "pageToken", newJString(pageToken))
  add(query_580307, "quotaUser", newJString(quotaUser))
  add(query_580307, "alt", newJString(alt))
  add(query_580307, "maxAttendees", newJInt(maxAttendees))
  add(query_580307, "showHiddenInvitations", newJBool(showHiddenInvitations))
  add(path_580306, "calendarId", newJString(calendarId))
  add(query_580307, "timeMax", newJString(timeMax))
  add(query_580307, "oauth_token", newJString(oauthToken))
  add(query_580307, "timeMin", newJString(timeMin))
  add(query_580307, "syncToken", newJString(syncToken))
  add(query_580307, "userIp", newJString(userIp))
  add(query_580307, "maxResults", newJInt(maxResults))
  add(query_580307, "orderBy", newJString(orderBy))
  add(query_580307, "timeZone", newJString(timeZone))
  add(query_580307, "q", newJString(q))
  add(query_580307, "iCalUID", newJString(iCalUID))
  add(query_580307, "showDeleted", newJBool(showDeleted))
  add(query_580307, "key", newJString(key))
  add(query_580307, "updatedMin", newJString(updatedMin))
  add(query_580307, "singleEvents", newJBool(singleEvents))
  if sharedExtendedProperty != nil:
    query_580307.add "sharedExtendedProperty", sharedExtendedProperty
  if resource != nil:
    body_580308 = resource
  add(query_580307, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_580307, "prettyPrint", newJBool(prettyPrint))
  result = call_580305.call(path_580306, query_580307, nil, nil, body_580308)

var calendarEventsWatch* = Call_CalendarEventsWatch_580275(
    name: "calendarEventsWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/watch",
    validator: validate_CalendarEventsWatch_580276, base: "/calendar/v3",
    url: url_CalendarEventsWatch_580277, schemes: {Scheme.Https})
type
  Call_CalendarEventsUpdate_580328 = ref object of OpenApiRestCall_579424
proc url_CalendarEventsUpdate_580330(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsUpdate_580329(path: JsonNode; query: JsonNode;
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
  var valid_580333 = query.getOrDefault("fields")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "fields", valid_580333
  var valid_580334 = query.getOrDefault("quotaUser")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "quotaUser", valid_580334
  var valid_580335 = query.getOrDefault("alt")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("json"))
  if valid_580335 != nil:
    section.add "alt", valid_580335
  var valid_580336 = query.getOrDefault("supportsAttachments")
  valid_580336 = validateParameter(valid_580336, JBool, required = false, default = nil)
  if valid_580336 != nil:
    section.add "supportsAttachments", valid_580336
  var valid_580337 = query.getOrDefault("maxAttendees")
  valid_580337 = validateParameter(valid_580337, JInt, required = false, default = nil)
  if valid_580337 != nil:
    section.add "maxAttendees", valid_580337
  var valid_580338 = query.getOrDefault("sendNotifications")
  valid_580338 = validateParameter(valid_580338, JBool, required = false, default = nil)
  if valid_580338 != nil:
    section.add "sendNotifications", valid_580338
  var valid_580339 = query.getOrDefault("oauth_token")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "oauth_token", valid_580339
  var valid_580340 = query.getOrDefault("conferenceDataVersion")
  valid_580340 = validateParameter(valid_580340, JInt, required = false, default = nil)
  if valid_580340 != nil:
    section.add "conferenceDataVersion", valid_580340
  var valid_580341 = query.getOrDefault("userIp")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "userIp", valid_580341
  var valid_580342 = query.getOrDefault("sendUpdates")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = newJString("all"))
  if valid_580342 != nil:
    section.add "sendUpdates", valid_580342
  var valid_580343 = query.getOrDefault("key")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "key", valid_580343
  var valid_580344 = query.getOrDefault("alwaysIncludeEmail")
  valid_580344 = validateParameter(valid_580344, JBool, required = false, default = nil)
  if valid_580344 != nil:
    section.add "alwaysIncludeEmail", valid_580344
  var valid_580345 = query.getOrDefault("prettyPrint")
  valid_580345 = validateParameter(valid_580345, JBool, required = false,
                                 default = newJBool(true))
  if valid_580345 != nil:
    section.add "prettyPrint", valid_580345
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

proc call*(call_580347: Call_CalendarEventsUpdate_580328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an event.
  ## 
  let valid = call_580347.validator(path, query, header, formData, body)
  let scheme = call_580347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580347.url(scheme.get, call_580347.host, call_580347.base,
                         call_580347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580347, url, valid)

proc call*(call_580348: Call_CalendarEventsUpdate_580328; calendarId: string;
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
  var path_580349 = newJObject()
  var query_580350 = newJObject()
  var body_580351 = newJObject()
  add(query_580350, "fields", newJString(fields))
  add(query_580350, "quotaUser", newJString(quotaUser))
  add(query_580350, "alt", newJString(alt))
  add(query_580350, "supportsAttachments", newJBool(supportsAttachments))
  add(query_580350, "maxAttendees", newJInt(maxAttendees))
  add(path_580349, "calendarId", newJString(calendarId))
  add(query_580350, "sendNotifications", newJBool(sendNotifications))
  add(query_580350, "oauth_token", newJString(oauthToken))
  add(query_580350, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_580350, "userIp", newJString(userIp))
  add(query_580350, "sendUpdates", newJString(sendUpdates))
  add(path_580349, "eventId", newJString(eventId))
  add(query_580350, "key", newJString(key))
  add(query_580350, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if body != nil:
    body_580351 = body
  add(query_580350, "prettyPrint", newJBool(prettyPrint))
  result = call_580348.call(path_580349, query_580350, nil, nil, body_580351)

var calendarEventsUpdate* = Call_CalendarEventsUpdate_580328(
    name: "calendarEventsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsUpdate_580329, base: "/calendar/v3",
    url: url_CalendarEventsUpdate_580330, schemes: {Scheme.Https})
type
  Call_CalendarEventsGet_580309 = ref object of OpenApiRestCall_579424
proc url_CalendarEventsGet_580311(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsGet_580310(path: JsonNode; query: JsonNode;
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
  var valid_580312 = path.getOrDefault("calendarId")
  valid_580312 = validateParameter(valid_580312, JString, required = true,
                                 default = nil)
  if valid_580312 != nil:
    section.add "calendarId", valid_580312
  var valid_580313 = path.getOrDefault("eventId")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "eventId", valid_580313
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
  var valid_580314 = query.getOrDefault("fields")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "fields", valid_580314
  var valid_580315 = query.getOrDefault("quotaUser")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "quotaUser", valid_580315
  var valid_580316 = query.getOrDefault("alt")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = newJString("json"))
  if valid_580316 != nil:
    section.add "alt", valid_580316
  var valid_580317 = query.getOrDefault("maxAttendees")
  valid_580317 = validateParameter(valid_580317, JInt, required = false, default = nil)
  if valid_580317 != nil:
    section.add "maxAttendees", valid_580317
  var valid_580318 = query.getOrDefault("oauth_token")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "oauth_token", valid_580318
  var valid_580319 = query.getOrDefault("userIp")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "userIp", valid_580319
  var valid_580320 = query.getOrDefault("timeZone")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "timeZone", valid_580320
  var valid_580321 = query.getOrDefault("key")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "key", valid_580321
  var valid_580322 = query.getOrDefault("alwaysIncludeEmail")
  valid_580322 = validateParameter(valid_580322, JBool, required = false, default = nil)
  if valid_580322 != nil:
    section.add "alwaysIncludeEmail", valid_580322
  var valid_580323 = query.getOrDefault("prettyPrint")
  valid_580323 = validateParameter(valid_580323, JBool, required = false,
                                 default = newJBool(true))
  if valid_580323 != nil:
    section.add "prettyPrint", valid_580323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580324: Call_CalendarEventsGet_580309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an event.
  ## 
  let valid = call_580324.validator(path, query, header, formData, body)
  let scheme = call_580324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580324.url(scheme.get, call_580324.host, call_580324.base,
                         call_580324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580324, url, valid)

proc call*(call_580325: Call_CalendarEventsGet_580309; calendarId: string;
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
  var path_580326 = newJObject()
  var query_580327 = newJObject()
  add(query_580327, "fields", newJString(fields))
  add(query_580327, "quotaUser", newJString(quotaUser))
  add(query_580327, "alt", newJString(alt))
  add(query_580327, "maxAttendees", newJInt(maxAttendees))
  add(path_580326, "calendarId", newJString(calendarId))
  add(query_580327, "oauth_token", newJString(oauthToken))
  add(query_580327, "userIp", newJString(userIp))
  add(query_580327, "timeZone", newJString(timeZone))
  add(path_580326, "eventId", newJString(eventId))
  add(query_580327, "key", newJString(key))
  add(query_580327, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_580327, "prettyPrint", newJBool(prettyPrint))
  result = call_580325.call(path_580326, query_580327, nil, nil, nil)

var calendarEventsGet* = Call_CalendarEventsGet_580309(name: "calendarEventsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsGet_580310, base: "/calendar/v3",
    url: url_CalendarEventsGet_580311, schemes: {Scheme.Https})
type
  Call_CalendarEventsPatch_580370 = ref object of OpenApiRestCall_579424
proc url_CalendarEventsPatch_580372(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsPatch_580371(path: JsonNode; query: JsonNode;
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
  var valid_580373 = path.getOrDefault("calendarId")
  valid_580373 = validateParameter(valid_580373, JString, required = true,
                                 default = nil)
  if valid_580373 != nil:
    section.add "calendarId", valid_580373
  var valid_580374 = path.getOrDefault("eventId")
  valid_580374 = validateParameter(valid_580374, JString, required = true,
                                 default = nil)
  if valid_580374 != nil:
    section.add "eventId", valid_580374
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
  var valid_580375 = query.getOrDefault("fields")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "fields", valid_580375
  var valid_580376 = query.getOrDefault("quotaUser")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "quotaUser", valid_580376
  var valid_580377 = query.getOrDefault("alt")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = newJString("json"))
  if valid_580377 != nil:
    section.add "alt", valid_580377
  var valid_580378 = query.getOrDefault("supportsAttachments")
  valid_580378 = validateParameter(valid_580378, JBool, required = false, default = nil)
  if valid_580378 != nil:
    section.add "supportsAttachments", valid_580378
  var valid_580379 = query.getOrDefault("maxAttendees")
  valid_580379 = validateParameter(valid_580379, JInt, required = false, default = nil)
  if valid_580379 != nil:
    section.add "maxAttendees", valid_580379
  var valid_580380 = query.getOrDefault("sendNotifications")
  valid_580380 = validateParameter(valid_580380, JBool, required = false, default = nil)
  if valid_580380 != nil:
    section.add "sendNotifications", valid_580380
  var valid_580381 = query.getOrDefault("oauth_token")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "oauth_token", valid_580381
  var valid_580382 = query.getOrDefault("conferenceDataVersion")
  valid_580382 = validateParameter(valid_580382, JInt, required = false, default = nil)
  if valid_580382 != nil:
    section.add "conferenceDataVersion", valid_580382
  var valid_580383 = query.getOrDefault("userIp")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "userIp", valid_580383
  var valid_580384 = query.getOrDefault("sendUpdates")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = newJString("all"))
  if valid_580384 != nil:
    section.add "sendUpdates", valid_580384
  var valid_580385 = query.getOrDefault("key")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "key", valid_580385
  var valid_580386 = query.getOrDefault("alwaysIncludeEmail")
  valid_580386 = validateParameter(valid_580386, JBool, required = false, default = nil)
  if valid_580386 != nil:
    section.add "alwaysIncludeEmail", valid_580386
  var valid_580387 = query.getOrDefault("prettyPrint")
  valid_580387 = validateParameter(valid_580387, JBool, required = false,
                                 default = newJBool(true))
  if valid_580387 != nil:
    section.add "prettyPrint", valid_580387
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

proc call*(call_580389: Call_CalendarEventsPatch_580370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an event. This method supports patch semantics.
  ## 
  let valid = call_580389.validator(path, query, header, formData, body)
  let scheme = call_580389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580389.url(scheme.get, call_580389.host, call_580389.base,
                         call_580389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580389, url, valid)

proc call*(call_580390: Call_CalendarEventsPatch_580370; calendarId: string;
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
  var path_580391 = newJObject()
  var query_580392 = newJObject()
  var body_580393 = newJObject()
  add(query_580392, "fields", newJString(fields))
  add(query_580392, "quotaUser", newJString(quotaUser))
  add(query_580392, "alt", newJString(alt))
  add(query_580392, "supportsAttachments", newJBool(supportsAttachments))
  add(query_580392, "maxAttendees", newJInt(maxAttendees))
  add(path_580391, "calendarId", newJString(calendarId))
  add(query_580392, "sendNotifications", newJBool(sendNotifications))
  add(query_580392, "oauth_token", newJString(oauthToken))
  add(query_580392, "conferenceDataVersion", newJInt(conferenceDataVersion))
  add(query_580392, "userIp", newJString(userIp))
  add(query_580392, "sendUpdates", newJString(sendUpdates))
  add(path_580391, "eventId", newJString(eventId))
  add(query_580392, "key", newJString(key))
  add(query_580392, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  if body != nil:
    body_580393 = body
  add(query_580392, "prettyPrint", newJBool(prettyPrint))
  result = call_580390.call(path_580391, query_580392, nil, nil, body_580393)

var calendarEventsPatch* = Call_CalendarEventsPatch_580370(
    name: "calendarEventsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsPatch_580371, base: "/calendar/v3",
    url: url_CalendarEventsPatch_580372, schemes: {Scheme.Https})
type
  Call_CalendarEventsDelete_580352 = ref object of OpenApiRestCall_579424
proc url_CalendarEventsDelete_580354(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsDelete_580353(path: JsonNode; query: JsonNode;
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
  var valid_580357 = query.getOrDefault("fields")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "fields", valid_580357
  var valid_580358 = query.getOrDefault("quotaUser")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "quotaUser", valid_580358
  var valid_580359 = query.getOrDefault("alt")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = newJString("json"))
  if valid_580359 != nil:
    section.add "alt", valid_580359
  var valid_580360 = query.getOrDefault("sendNotifications")
  valid_580360 = validateParameter(valid_580360, JBool, required = false, default = nil)
  if valid_580360 != nil:
    section.add "sendNotifications", valid_580360
  var valid_580361 = query.getOrDefault("oauth_token")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "oauth_token", valid_580361
  var valid_580362 = query.getOrDefault("userIp")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "userIp", valid_580362
  var valid_580363 = query.getOrDefault("sendUpdates")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = newJString("all"))
  if valid_580363 != nil:
    section.add "sendUpdates", valid_580363
  var valid_580364 = query.getOrDefault("key")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "key", valid_580364
  var valid_580365 = query.getOrDefault("prettyPrint")
  valid_580365 = validateParameter(valid_580365, JBool, required = false,
                                 default = newJBool(true))
  if valid_580365 != nil:
    section.add "prettyPrint", valid_580365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580366: Call_CalendarEventsDelete_580352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an event.
  ## 
  let valid = call_580366.validator(path, query, header, formData, body)
  let scheme = call_580366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580366.url(scheme.get, call_580366.host, call_580366.base,
                         call_580366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580366, url, valid)

proc call*(call_580367: Call_CalendarEventsDelete_580352; calendarId: string;
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
  var path_580368 = newJObject()
  var query_580369 = newJObject()
  add(query_580369, "fields", newJString(fields))
  add(query_580369, "quotaUser", newJString(quotaUser))
  add(query_580369, "alt", newJString(alt))
  add(path_580368, "calendarId", newJString(calendarId))
  add(query_580369, "sendNotifications", newJBool(sendNotifications))
  add(query_580369, "oauth_token", newJString(oauthToken))
  add(query_580369, "userIp", newJString(userIp))
  add(query_580369, "sendUpdates", newJString(sendUpdates))
  add(path_580368, "eventId", newJString(eventId))
  add(query_580369, "key", newJString(key))
  add(query_580369, "prettyPrint", newJBool(prettyPrint))
  result = call_580367.call(path_580368, query_580369, nil, nil, nil)

var calendarEventsDelete* = Call_CalendarEventsDelete_580352(
    name: "calendarEventsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/calendars/{calendarId}/events/{eventId}",
    validator: validate_CalendarEventsDelete_580353, base: "/calendar/v3",
    url: url_CalendarEventsDelete_580354, schemes: {Scheme.Https})
type
  Call_CalendarEventsInstances_580394 = ref object of OpenApiRestCall_579424
proc url_CalendarEventsInstances_580396(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsInstances_580395(path: JsonNode; query: JsonNode;
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
  var valid_580397 = path.getOrDefault("calendarId")
  valid_580397 = validateParameter(valid_580397, JString, required = true,
                                 default = nil)
  if valid_580397 != nil:
    section.add "calendarId", valid_580397
  var valid_580398 = path.getOrDefault("eventId")
  valid_580398 = validateParameter(valid_580398, JString, required = true,
                                 default = nil)
  if valid_580398 != nil:
    section.add "eventId", valid_580398
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
  var valid_580399 = query.getOrDefault("fields")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "fields", valid_580399
  var valid_580400 = query.getOrDefault("pageToken")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "pageToken", valid_580400
  var valid_580401 = query.getOrDefault("quotaUser")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "quotaUser", valid_580401
  var valid_580402 = query.getOrDefault("originalStart")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "originalStart", valid_580402
  var valid_580403 = query.getOrDefault("alt")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = newJString("json"))
  if valid_580403 != nil:
    section.add "alt", valid_580403
  var valid_580404 = query.getOrDefault("maxAttendees")
  valid_580404 = validateParameter(valid_580404, JInt, required = false, default = nil)
  if valid_580404 != nil:
    section.add "maxAttendees", valid_580404
  var valid_580405 = query.getOrDefault("timeMax")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "timeMax", valid_580405
  var valid_580406 = query.getOrDefault("oauth_token")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "oauth_token", valid_580406
  var valid_580407 = query.getOrDefault("timeMin")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "timeMin", valid_580407
  var valid_580408 = query.getOrDefault("userIp")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "userIp", valid_580408
  var valid_580409 = query.getOrDefault("maxResults")
  valid_580409 = validateParameter(valid_580409, JInt, required = false, default = nil)
  if valid_580409 != nil:
    section.add "maxResults", valid_580409
  var valid_580410 = query.getOrDefault("timeZone")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "timeZone", valid_580410
  var valid_580411 = query.getOrDefault("showDeleted")
  valid_580411 = validateParameter(valid_580411, JBool, required = false, default = nil)
  if valid_580411 != nil:
    section.add "showDeleted", valid_580411
  var valid_580412 = query.getOrDefault("key")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "key", valid_580412
  var valid_580413 = query.getOrDefault("alwaysIncludeEmail")
  valid_580413 = validateParameter(valid_580413, JBool, required = false, default = nil)
  if valid_580413 != nil:
    section.add "alwaysIncludeEmail", valid_580413
  var valid_580414 = query.getOrDefault("prettyPrint")
  valid_580414 = validateParameter(valid_580414, JBool, required = false,
                                 default = newJBool(true))
  if valid_580414 != nil:
    section.add "prettyPrint", valid_580414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580415: Call_CalendarEventsInstances_580394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns instances of the specified recurring event.
  ## 
  let valid = call_580415.validator(path, query, header, formData, body)
  let scheme = call_580415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580415.url(scheme.get, call_580415.host, call_580415.base,
                         call_580415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580415, url, valid)

proc call*(call_580416: Call_CalendarEventsInstances_580394; calendarId: string;
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
  var path_580417 = newJObject()
  var query_580418 = newJObject()
  add(query_580418, "fields", newJString(fields))
  add(query_580418, "pageToken", newJString(pageToken))
  add(query_580418, "quotaUser", newJString(quotaUser))
  add(query_580418, "originalStart", newJString(originalStart))
  add(query_580418, "alt", newJString(alt))
  add(query_580418, "maxAttendees", newJInt(maxAttendees))
  add(path_580417, "calendarId", newJString(calendarId))
  add(query_580418, "timeMax", newJString(timeMax))
  add(query_580418, "oauth_token", newJString(oauthToken))
  add(query_580418, "timeMin", newJString(timeMin))
  add(query_580418, "userIp", newJString(userIp))
  add(query_580418, "maxResults", newJInt(maxResults))
  add(query_580418, "timeZone", newJString(timeZone))
  add(query_580418, "showDeleted", newJBool(showDeleted))
  add(path_580417, "eventId", newJString(eventId))
  add(query_580418, "key", newJString(key))
  add(query_580418, "alwaysIncludeEmail", newJBool(alwaysIncludeEmail))
  add(query_580418, "prettyPrint", newJBool(prettyPrint))
  result = call_580416.call(path_580417, query_580418, nil, nil, nil)

var calendarEventsInstances* = Call_CalendarEventsInstances_580394(
    name: "calendarEventsInstances", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}/instances",
    validator: validate_CalendarEventsInstances_580395, base: "/calendar/v3",
    url: url_CalendarEventsInstances_580396, schemes: {Scheme.Https})
type
  Call_CalendarEventsMove_580419 = ref object of OpenApiRestCall_579424
proc url_CalendarEventsMove_580421(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarEventsMove_580420(path: JsonNode; query: JsonNode;
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
  var valid_580422 = path.getOrDefault("calendarId")
  valid_580422 = validateParameter(valid_580422, JString, required = true,
                                 default = nil)
  if valid_580422 != nil:
    section.add "calendarId", valid_580422
  var valid_580423 = path.getOrDefault("eventId")
  valid_580423 = validateParameter(valid_580423, JString, required = true,
                                 default = nil)
  if valid_580423 != nil:
    section.add "eventId", valid_580423
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
  var valid_580424 = query.getOrDefault("fields")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "fields", valid_580424
  var valid_580425 = query.getOrDefault("quotaUser")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "quotaUser", valid_580425
  var valid_580426 = query.getOrDefault("alt")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = newJString("json"))
  if valid_580426 != nil:
    section.add "alt", valid_580426
  var valid_580427 = query.getOrDefault("sendNotifications")
  valid_580427 = validateParameter(valid_580427, JBool, required = false, default = nil)
  if valid_580427 != nil:
    section.add "sendNotifications", valid_580427
  var valid_580428 = query.getOrDefault("oauth_token")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "oauth_token", valid_580428
  var valid_580429 = query.getOrDefault("userIp")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "userIp", valid_580429
  var valid_580430 = query.getOrDefault("sendUpdates")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = newJString("all"))
  if valid_580430 != nil:
    section.add "sendUpdates", valid_580430
  var valid_580431 = query.getOrDefault("key")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "key", valid_580431
  assert query != nil,
        "query argument is necessary due to required `destination` field"
  var valid_580432 = query.getOrDefault("destination")
  valid_580432 = validateParameter(valid_580432, JString, required = true,
                                 default = nil)
  if valid_580432 != nil:
    section.add "destination", valid_580432
  var valid_580433 = query.getOrDefault("prettyPrint")
  valid_580433 = validateParameter(valid_580433, JBool, required = false,
                                 default = newJBool(true))
  if valid_580433 != nil:
    section.add "prettyPrint", valid_580433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580434: Call_CalendarEventsMove_580419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Moves an event to another calendar, i.e. changes an event's organizer.
  ## 
  let valid = call_580434.validator(path, query, header, formData, body)
  let scheme = call_580434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580434.url(scheme.get, call_580434.host, call_580434.base,
                         call_580434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580434, url, valid)

proc call*(call_580435: Call_CalendarEventsMove_580419; calendarId: string;
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
  var path_580436 = newJObject()
  var query_580437 = newJObject()
  add(query_580437, "fields", newJString(fields))
  add(query_580437, "quotaUser", newJString(quotaUser))
  add(query_580437, "alt", newJString(alt))
  add(path_580436, "calendarId", newJString(calendarId))
  add(query_580437, "sendNotifications", newJBool(sendNotifications))
  add(query_580437, "oauth_token", newJString(oauthToken))
  add(query_580437, "userIp", newJString(userIp))
  add(query_580437, "sendUpdates", newJString(sendUpdates))
  add(path_580436, "eventId", newJString(eventId))
  add(query_580437, "key", newJString(key))
  add(query_580437, "destination", newJString(destination))
  add(query_580437, "prettyPrint", newJBool(prettyPrint))
  result = call_580435.call(path_580436, query_580437, nil, nil, nil)

var calendarEventsMove* = Call_CalendarEventsMove_580419(
    name: "calendarEventsMove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/calendars/{calendarId}/events/{eventId}/move",
    validator: validate_CalendarEventsMove_580420, base: "/calendar/v3",
    url: url_CalendarEventsMove_580421, schemes: {Scheme.Https})
type
  Call_CalendarChannelsStop_580438 = ref object of OpenApiRestCall_579424
proc url_CalendarChannelsStop_580440(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarChannelsStop_580439(path: JsonNode; query: JsonNode;
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
  var valid_580441 = query.getOrDefault("fields")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "fields", valid_580441
  var valid_580442 = query.getOrDefault("quotaUser")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "quotaUser", valid_580442
  var valid_580443 = query.getOrDefault("alt")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = newJString("json"))
  if valid_580443 != nil:
    section.add "alt", valid_580443
  var valid_580444 = query.getOrDefault("oauth_token")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "oauth_token", valid_580444
  var valid_580445 = query.getOrDefault("userIp")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "userIp", valid_580445
  var valid_580446 = query.getOrDefault("key")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "key", valid_580446
  var valid_580447 = query.getOrDefault("prettyPrint")
  valid_580447 = validateParameter(valid_580447, JBool, required = false,
                                 default = newJBool(true))
  if valid_580447 != nil:
    section.add "prettyPrint", valid_580447
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

proc call*(call_580449: Call_CalendarChannelsStop_580438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_580449.validator(path, query, header, formData, body)
  let scheme = call_580449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580449.url(scheme.get, call_580449.host, call_580449.base,
                         call_580449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580449, url, valid)

proc call*(call_580450: Call_CalendarChannelsStop_580438; fields: string = "";
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
  var query_580451 = newJObject()
  var body_580452 = newJObject()
  add(query_580451, "fields", newJString(fields))
  add(query_580451, "quotaUser", newJString(quotaUser))
  add(query_580451, "alt", newJString(alt))
  add(query_580451, "oauth_token", newJString(oauthToken))
  add(query_580451, "userIp", newJString(userIp))
  add(query_580451, "key", newJString(key))
  if resource != nil:
    body_580452 = resource
  add(query_580451, "prettyPrint", newJBool(prettyPrint))
  result = call_580450.call(nil, query_580451, nil, nil, body_580452)

var calendarChannelsStop* = Call_CalendarChannelsStop_580438(
    name: "calendarChannelsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_CalendarChannelsStop_580439, base: "/calendar/v3",
    url: url_CalendarChannelsStop_580440, schemes: {Scheme.Https})
type
  Call_CalendarColorsGet_580453 = ref object of OpenApiRestCall_579424
proc url_CalendarColorsGet_580455(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarColorsGet_580454(path: JsonNode; query: JsonNode;
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
  var valid_580456 = query.getOrDefault("fields")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "fields", valid_580456
  var valid_580457 = query.getOrDefault("quotaUser")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "quotaUser", valid_580457
  var valid_580458 = query.getOrDefault("alt")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = newJString("json"))
  if valid_580458 != nil:
    section.add "alt", valid_580458
  var valid_580459 = query.getOrDefault("oauth_token")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "oauth_token", valid_580459
  var valid_580460 = query.getOrDefault("userIp")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "userIp", valid_580460
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580463: Call_CalendarColorsGet_580453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the color definitions for calendars and events.
  ## 
  let valid = call_580463.validator(path, query, header, formData, body)
  let scheme = call_580463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580463.url(scheme.get, call_580463.host, call_580463.base,
                         call_580463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580463, url, valid)

proc call*(call_580464: Call_CalendarColorsGet_580453; fields: string = "";
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
  var query_580465 = newJObject()
  add(query_580465, "fields", newJString(fields))
  add(query_580465, "quotaUser", newJString(quotaUser))
  add(query_580465, "alt", newJString(alt))
  add(query_580465, "oauth_token", newJString(oauthToken))
  add(query_580465, "userIp", newJString(userIp))
  add(query_580465, "key", newJString(key))
  add(query_580465, "prettyPrint", newJBool(prettyPrint))
  result = call_580464.call(nil, query_580465, nil, nil, nil)

var calendarColorsGet* = Call_CalendarColorsGet_580453(name: "calendarColorsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/colors",
    validator: validate_CalendarColorsGet_580454, base: "/calendar/v3",
    url: url_CalendarColorsGet_580455, schemes: {Scheme.Https})
type
  Call_CalendarFreebusyQuery_580466 = ref object of OpenApiRestCall_579424
proc url_CalendarFreebusyQuery_580468(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarFreebusyQuery_580467(path: JsonNode; query: JsonNode;
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
  var valid_580469 = query.getOrDefault("fields")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "fields", valid_580469
  var valid_580470 = query.getOrDefault("quotaUser")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "quotaUser", valid_580470
  var valid_580471 = query.getOrDefault("alt")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = newJString("json"))
  if valid_580471 != nil:
    section.add "alt", valid_580471
  var valid_580472 = query.getOrDefault("oauth_token")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "oauth_token", valid_580472
  var valid_580473 = query.getOrDefault("userIp")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "userIp", valid_580473
  var valid_580474 = query.getOrDefault("key")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "key", valid_580474
  var valid_580475 = query.getOrDefault("prettyPrint")
  valid_580475 = validateParameter(valid_580475, JBool, required = false,
                                 default = newJBool(true))
  if valid_580475 != nil:
    section.add "prettyPrint", valid_580475
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

proc call*(call_580477: Call_CalendarFreebusyQuery_580466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns free/busy information for a set of calendars.
  ## 
  let valid = call_580477.validator(path, query, header, formData, body)
  let scheme = call_580477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580477.url(scheme.get, call_580477.host, call_580477.base,
                         call_580477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580477, url, valid)

proc call*(call_580478: Call_CalendarFreebusyQuery_580466; fields: string = "";
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
  var query_580479 = newJObject()
  var body_580480 = newJObject()
  add(query_580479, "fields", newJString(fields))
  add(query_580479, "quotaUser", newJString(quotaUser))
  add(query_580479, "alt", newJString(alt))
  add(query_580479, "oauth_token", newJString(oauthToken))
  add(query_580479, "userIp", newJString(userIp))
  add(query_580479, "key", newJString(key))
  if body != nil:
    body_580480 = body
  add(query_580479, "prettyPrint", newJBool(prettyPrint))
  result = call_580478.call(nil, query_580479, nil, nil, body_580480)

var calendarFreebusyQuery* = Call_CalendarFreebusyQuery_580466(
    name: "calendarFreebusyQuery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/freeBusy",
    validator: validate_CalendarFreebusyQuery_580467, base: "/calendar/v3",
    url: url_CalendarFreebusyQuery_580468, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListInsert_580500 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarListInsert_580502(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarListInsert_580501(path: JsonNode; query: JsonNode;
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
  var valid_580503 = query.getOrDefault("fields")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "fields", valid_580503
  var valid_580504 = query.getOrDefault("quotaUser")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "quotaUser", valid_580504
  var valid_580505 = query.getOrDefault("alt")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = newJString("json"))
  if valid_580505 != nil:
    section.add "alt", valid_580505
  var valid_580506 = query.getOrDefault("colorRgbFormat")
  valid_580506 = validateParameter(valid_580506, JBool, required = false, default = nil)
  if valid_580506 != nil:
    section.add "colorRgbFormat", valid_580506
  var valid_580507 = query.getOrDefault("oauth_token")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "oauth_token", valid_580507
  var valid_580508 = query.getOrDefault("userIp")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "userIp", valid_580508
  var valid_580509 = query.getOrDefault("key")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "key", valid_580509
  var valid_580510 = query.getOrDefault("prettyPrint")
  valid_580510 = validateParameter(valid_580510, JBool, required = false,
                                 default = newJBool(true))
  if valid_580510 != nil:
    section.add "prettyPrint", valid_580510
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

proc call*(call_580512: Call_CalendarCalendarListInsert_580500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts an existing calendar into the user's calendar list.
  ## 
  let valid = call_580512.validator(path, query, header, formData, body)
  let scheme = call_580512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580512.url(scheme.get, call_580512.host, call_580512.base,
                         call_580512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580512, url, valid)

proc call*(call_580513: Call_CalendarCalendarListInsert_580500;
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
  var query_580514 = newJObject()
  var body_580515 = newJObject()
  add(query_580514, "fields", newJString(fields))
  add(query_580514, "quotaUser", newJString(quotaUser))
  add(query_580514, "alt", newJString(alt))
  add(query_580514, "colorRgbFormat", newJBool(colorRgbFormat))
  add(query_580514, "oauth_token", newJString(oauthToken))
  add(query_580514, "userIp", newJString(userIp))
  add(query_580514, "key", newJString(key))
  if body != nil:
    body_580515 = body
  add(query_580514, "prettyPrint", newJBool(prettyPrint))
  result = call_580513.call(nil, query_580514, nil, nil, body_580515)

var calendarCalendarListInsert* = Call_CalendarCalendarListInsert_580500(
    name: "calendarCalendarListInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/calendarList",
    validator: validate_CalendarCalendarListInsert_580501, base: "/calendar/v3",
    url: url_CalendarCalendarListInsert_580502, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListList_580481 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarListList_580483(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarListList_580482(path: JsonNode; query: JsonNode;
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
  var valid_580484 = query.getOrDefault("fields")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "fields", valid_580484
  var valid_580485 = query.getOrDefault("pageToken")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "pageToken", valid_580485
  var valid_580486 = query.getOrDefault("quotaUser")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "quotaUser", valid_580486
  var valid_580487 = query.getOrDefault("alt")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = newJString("json"))
  if valid_580487 != nil:
    section.add "alt", valid_580487
  var valid_580488 = query.getOrDefault("oauth_token")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "oauth_token", valid_580488
  var valid_580489 = query.getOrDefault("syncToken")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "syncToken", valid_580489
  var valid_580490 = query.getOrDefault("userIp")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "userIp", valid_580490
  var valid_580491 = query.getOrDefault("maxResults")
  valid_580491 = validateParameter(valid_580491, JInt, required = false, default = nil)
  if valid_580491 != nil:
    section.add "maxResults", valid_580491
  var valid_580492 = query.getOrDefault("showHidden")
  valid_580492 = validateParameter(valid_580492, JBool, required = false, default = nil)
  if valid_580492 != nil:
    section.add "showHidden", valid_580492
  var valid_580493 = query.getOrDefault("showDeleted")
  valid_580493 = validateParameter(valid_580493, JBool, required = false, default = nil)
  if valid_580493 != nil:
    section.add "showDeleted", valid_580493
  var valid_580494 = query.getOrDefault("key")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "key", valid_580494
  var valid_580495 = query.getOrDefault("prettyPrint")
  valid_580495 = validateParameter(valid_580495, JBool, required = false,
                                 default = newJBool(true))
  if valid_580495 != nil:
    section.add "prettyPrint", valid_580495
  var valid_580496 = query.getOrDefault("minAccessRole")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = newJString("freeBusyReader"))
  if valid_580496 != nil:
    section.add "minAccessRole", valid_580496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580497: Call_CalendarCalendarListList_580481; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the calendars on the user's calendar list.
  ## 
  let valid = call_580497.validator(path, query, header, formData, body)
  let scheme = call_580497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580497.url(scheme.get, call_580497.host, call_580497.base,
                         call_580497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580497, url, valid)

proc call*(call_580498: Call_CalendarCalendarListList_580481; fields: string = "";
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
  var query_580499 = newJObject()
  add(query_580499, "fields", newJString(fields))
  add(query_580499, "pageToken", newJString(pageToken))
  add(query_580499, "quotaUser", newJString(quotaUser))
  add(query_580499, "alt", newJString(alt))
  add(query_580499, "oauth_token", newJString(oauthToken))
  add(query_580499, "syncToken", newJString(syncToken))
  add(query_580499, "userIp", newJString(userIp))
  add(query_580499, "maxResults", newJInt(maxResults))
  add(query_580499, "showHidden", newJBool(showHidden))
  add(query_580499, "showDeleted", newJBool(showDeleted))
  add(query_580499, "key", newJString(key))
  add(query_580499, "prettyPrint", newJBool(prettyPrint))
  add(query_580499, "minAccessRole", newJString(minAccessRole))
  result = call_580498.call(nil, query_580499, nil, nil, nil)

var calendarCalendarListList* = Call_CalendarCalendarListList_580481(
    name: "calendarCalendarListList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/calendarList",
    validator: validate_CalendarCalendarListList_580482, base: "/calendar/v3",
    url: url_CalendarCalendarListList_580483, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListWatch_580516 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarListWatch_580518(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarCalendarListWatch_580517(path: JsonNode; query: JsonNode;
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
  var valid_580519 = query.getOrDefault("fields")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "fields", valid_580519
  var valid_580520 = query.getOrDefault("pageToken")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "pageToken", valid_580520
  var valid_580521 = query.getOrDefault("quotaUser")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "quotaUser", valid_580521
  var valid_580522 = query.getOrDefault("alt")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = newJString("json"))
  if valid_580522 != nil:
    section.add "alt", valid_580522
  var valid_580523 = query.getOrDefault("oauth_token")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "oauth_token", valid_580523
  var valid_580524 = query.getOrDefault("syncToken")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "syncToken", valid_580524
  var valid_580525 = query.getOrDefault("userIp")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "userIp", valid_580525
  var valid_580526 = query.getOrDefault("maxResults")
  valid_580526 = validateParameter(valid_580526, JInt, required = false, default = nil)
  if valid_580526 != nil:
    section.add "maxResults", valid_580526
  var valid_580527 = query.getOrDefault("showHidden")
  valid_580527 = validateParameter(valid_580527, JBool, required = false, default = nil)
  if valid_580527 != nil:
    section.add "showHidden", valid_580527
  var valid_580528 = query.getOrDefault("showDeleted")
  valid_580528 = validateParameter(valid_580528, JBool, required = false, default = nil)
  if valid_580528 != nil:
    section.add "showDeleted", valid_580528
  var valid_580529 = query.getOrDefault("key")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "key", valid_580529
  var valid_580530 = query.getOrDefault("prettyPrint")
  valid_580530 = validateParameter(valid_580530, JBool, required = false,
                                 default = newJBool(true))
  if valid_580530 != nil:
    section.add "prettyPrint", valid_580530
  var valid_580531 = query.getOrDefault("minAccessRole")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = newJString("freeBusyReader"))
  if valid_580531 != nil:
    section.add "minAccessRole", valid_580531
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

proc call*(call_580533: Call_CalendarCalendarListWatch_580516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to CalendarList resources.
  ## 
  let valid = call_580533.validator(path, query, header, formData, body)
  let scheme = call_580533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580533.url(scheme.get, call_580533.host, call_580533.base,
                         call_580533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580533, url, valid)

proc call*(call_580534: Call_CalendarCalendarListWatch_580516; fields: string = "";
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
  var query_580535 = newJObject()
  var body_580536 = newJObject()
  add(query_580535, "fields", newJString(fields))
  add(query_580535, "pageToken", newJString(pageToken))
  add(query_580535, "quotaUser", newJString(quotaUser))
  add(query_580535, "alt", newJString(alt))
  add(query_580535, "oauth_token", newJString(oauthToken))
  add(query_580535, "syncToken", newJString(syncToken))
  add(query_580535, "userIp", newJString(userIp))
  add(query_580535, "maxResults", newJInt(maxResults))
  add(query_580535, "showHidden", newJBool(showHidden))
  add(query_580535, "showDeleted", newJBool(showDeleted))
  add(query_580535, "key", newJString(key))
  if resource != nil:
    body_580536 = resource
  add(query_580535, "prettyPrint", newJBool(prettyPrint))
  add(query_580535, "minAccessRole", newJString(minAccessRole))
  result = call_580534.call(nil, query_580535, nil, nil, body_580536)

var calendarCalendarListWatch* = Call_CalendarCalendarListWatch_580516(
    name: "calendarCalendarListWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/calendarList/watch",
    validator: validate_CalendarCalendarListWatch_580517, base: "/calendar/v3",
    url: url_CalendarCalendarListWatch_580518, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListUpdate_580552 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarListUpdate_580554(protocol: Scheme; host: string;
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

proc validate_CalendarCalendarListUpdate_580553(path: JsonNode; query: JsonNode;
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
  var valid_580555 = path.getOrDefault("calendarId")
  valid_580555 = validateParameter(valid_580555, JString, required = true,
                                 default = nil)
  if valid_580555 != nil:
    section.add "calendarId", valid_580555
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
  var valid_580556 = query.getOrDefault("fields")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "fields", valid_580556
  var valid_580557 = query.getOrDefault("quotaUser")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "quotaUser", valid_580557
  var valid_580558 = query.getOrDefault("alt")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = newJString("json"))
  if valid_580558 != nil:
    section.add "alt", valid_580558
  var valid_580559 = query.getOrDefault("colorRgbFormat")
  valid_580559 = validateParameter(valid_580559, JBool, required = false, default = nil)
  if valid_580559 != nil:
    section.add "colorRgbFormat", valid_580559
  var valid_580560 = query.getOrDefault("oauth_token")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "oauth_token", valid_580560
  var valid_580561 = query.getOrDefault("userIp")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "userIp", valid_580561
  var valid_580562 = query.getOrDefault("key")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "key", valid_580562
  var valid_580563 = query.getOrDefault("prettyPrint")
  valid_580563 = validateParameter(valid_580563, JBool, required = false,
                                 default = newJBool(true))
  if valid_580563 != nil:
    section.add "prettyPrint", valid_580563
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

proc call*(call_580565: Call_CalendarCalendarListUpdate_580552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing calendar on the user's calendar list.
  ## 
  let valid = call_580565.validator(path, query, header, formData, body)
  let scheme = call_580565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580565.url(scheme.get, call_580565.host, call_580565.base,
                         call_580565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580565, url, valid)

proc call*(call_580566: Call_CalendarCalendarListUpdate_580552; calendarId: string;
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
  var path_580567 = newJObject()
  var query_580568 = newJObject()
  var body_580569 = newJObject()
  add(query_580568, "fields", newJString(fields))
  add(query_580568, "quotaUser", newJString(quotaUser))
  add(query_580568, "alt", newJString(alt))
  add(query_580568, "colorRgbFormat", newJBool(colorRgbFormat))
  add(path_580567, "calendarId", newJString(calendarId))
  add(query_580568, "oauth_token", newJString(oauthToken))
  add(query_580568, "userIp", newJString(userIp))
  add(query_580568, "key", newJString(key))
  if body != nil:
    body_580569 = body
  add(query_580568, "prettyPrint", newJBool(prettyPrint))
  result = call_580566.call(path_580567, query_580568, nil, nil, body_580569)

var calendarCalendarListUpdate* = Call_CalendarCalendarListUpdate_580552(
    name: "calendarCalendarListUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListUpdate_580553, base: "/calendar/v3",
    url: url_CalendarCalendarListUpdate_580554, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListGet_580537 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarListGet_580539(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarCalendarListGet_580538(path: JsonNode; query: JsonNode;
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
  var valid_580540 = path.getOrDefault("calendarId")
  valid_580540 = validateParameter(valid_580540, JString, required = true,
                                 default = nil)
  if valid_580540 != nil:
    section.add "calendarId", valid_580540
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
  var valid_580541 = query.getOrDefault("fields")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "fields", valid_580541
  var valid_580542 = query.getOrDefault("quotaUser")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = nil)
  if valid_580542 != nil:
    section.add "quotaUser", valid_580542
  var valid_580543 = query.getOrDefault("alt")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = newJString("json"))
  if valid_580543 != nil:
    section.add "alt", valid_580543
  var valid_580544 = query.getOrDefault("oauth_token")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "oauth_token", valid_580544
  var valid_580545 = query.getOrDefault("userIp")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "userIp", valid_580545
  var valid_580546 = query.getOrDefault("key")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "key", valid_580546
  var valid_580547 = query.getOrDefault("prettyPrint")
  valid_580547 = validateParameter(valid_580547, JBool, required = false,
                                 default = newJBool(true))
  if valid_580547 != nil:
    section.add "prettyPrint", valid_580547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580548: Call_CalendarCalendarListGet_580537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a calendar from the user's calendar list.
  ## 
  let valid = call_580548.validator(path, query, header, formData, body)
  let scheme = call_580548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580548.url(scheme.get, call_580548.host, call_580548.base,
                         call_580548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580548, url, valid)

proc call*(call_580549: Call_CalendarCalendarListGet_580537; calendarId: string;
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
  var path_580550 = newJObject()
  var query_580551 = newJObject()
  add(query_580551, "fields", newJString(fields))
  add(query_580551, "quotaUser", newJString(quotaUser))
  add(query_580551, "alt", newJString(alt))
  add(path_580550, "calendarId", newJString(calendarId))
  add(query_580551, "oauth_token", newJString(oauthToken))
  add(query_580551, "userIp", newJString(userIp))
  add(query_580551, "key", newJString(key))
  add(query_580551, "prettyPrint", newJBool(prettyPrint))
  result = call_580549.call(path_580550, query_580551, nil, nil, nil)

var calendarCalendarListGet* = Call_CalendarCalendarListGet_580537(
    name: "calendarCalendarListGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListGet_580538, base: "/calendar/v3",
    url: url_CalendarCalendarListGet_580539, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListPatch_580585 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarListPatch_580587(protocol: Scheme; host: string;
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

proc validate_CalendarCalendarListPatch_580586(path: JsonNode; query: JsonNode;
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
  var valid_580588 = path.getOrDefault("calendarId")
  valid_580588 = validateParameter(valid_580588, JString, required = true,
                                 default = nil)
  if valid_580588 != nil:
    section.add "calendarId", valid_580588
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
  var valid_580589 = query.getOrDefault("fields")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "fields", valid_580589
  var valid_580590 = query.getOrDefault("quotaUser")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "quotaUser", valid_580590
  var valid_580591 = query.getOrDefault("alt")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = newJString("json"))
  if valid_580591 != nil:
    section.add "alt", valid_580591
  var valid_580592 = query.getOrDefault("colorRgbFormat")
  valid_580592 = validateParameter(valid_580592, JBool, required = false, default = nil)
  if valid_580592 != nil:
    section.add "colorRgbFormat", valid_580592
  var valid_580593 = query.getOrDefault("oauth_token")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "oauth_token", valid_580593
  var valid_580594 = query.getOrDefault("userIp")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "userIp", valid_580594
  var valid_580595 = query.getOrDefault("key")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "key", valid_580595
  var valid_580596 = query.getOrDefault("prettyPrint")
  valid_580596 = validateParameter(valid_580596, JBool, required = false,
                                 default = newJBool(true))
  if valid_580596 != nil:
    section.add "prettyPrint", valid_580596
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

proc call*(call_580598: Call_CalendarCalendarListPatch_580585; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing calendar on the user's calendar list. This method supports patch semantics.
  ## 
  let valid = call_580598.validator(path, query, header, formData, body)
  let scheme = call_580598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580598.url(scheme.get, call_580598.host, call_580598.base,
                         call_580598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580598, url, valid)

proc call*(call_580599: Call_CalendarCalendarListPatch_580585; calendarId: string;
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
  var path_580600 = newJObject()
  var query_580601 = newJObject()
  var body_580602 = newJObject()
  add(query_580601, "fields", newJString(fields))
  add(query_580601, "quotaUser", newJString(quotaUser))
  add(query_580601, "alt", newJString(alt))
  add(query_580601, "colorRgbFormat", newJBool(colorRgbFormat))
  add(path_580600, "calendarId", newJString(calendarId))
  add(query_580601, "oauth_token", newJString(oauthToken))
  add(query_580601, "userIp", newJString(userIp))
  add(query_580601, "key", newJString(key))
  if body != nil:
    body_580602 = body
  add(query_580601, "prettyPrint", newJBool(prettyPrint))
  result = call_580599.call(path_580600, query_580601, nil, nil, body_580602)

var calendarCalendarListPatch* = Call_CalendarCalendarListPatch_580585(
    name: "calendarCalendarListPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListPatch_580586, base: "/calendar/v3",
    url: url_CalendarCalendarListPatch_580587, schemes: {Scheme.Https})
type
  Call_CalendarCalendarListDelete_580570 = ref object of OpenApiRestCall_579424
proc url_CalendarCalendarListDelete_580572(protocol: Scheme; host: string;
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

proc validate_CalendarCalendarListDelete_580571(path: JsonNode; query: JsonNode;
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
  var valid_580573 = path.getOrDefault("calendarId")
  valid_580573 = validateParameter(valid_580573, JString, required = true,
                                 default = nil)
  if valid_580573 != nil:
    section.add "calendarId", valid_580573
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
  var valid_580574 = query.getOrDefault("fields")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "fields", valid_580574
  var valid_580575 = query.getOrDefault("quotaUser")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "quotaUser", valid_580575
  var valid_580576 = query.getOrDefault("alt")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = newJString("json"))
  if valid_580576 != nil:
    section.add "alt", valid_580576
  var valid_580577 = query.getOrDefault("oauth_token")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "oauth_token", valid_580577
  var valid_580578 = query.getOrDefault("userIp")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "userIp", valid_580578
  var valid_580579 = query.getOrDefault("key")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "key", valid_580579
  var valid_580580 = query.getOrDefault("prettyPrint")
  valid_580580 = validateParameter(valid_580580, JBool, required = false,
                                 default = newJBool(true))
  if valid_580580 != nil:
    section.add "prettyPrint", valid_580580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580581: Call_CalendarCalendarListDelete_580570; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a calendar from the user's calendar list.
  ## 
  let valid = call_580581.validator(path, query, header, formData, body)
  let scheme = call_580581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580581.url(scheme.get, call_580581.host, call_580581.base,
                         call_580581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580581, url, valid)

proc call*(call_580582: Call_CalendarCalendarListDelete_580570; calendarId: string;
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
  var path_580583 = newJObject()
  var query_580584 = newJObject()
  add(query_580584, "fields", newJString(fields))
  add(query_580584, "quotaUser", newJString(quotaUser))
  add(query_580584, "alt", newJString(alt))
  add(path_580583, "calendarId", newJString(calendarId))
  add(query_580584, "oauth_token", newJString(oauthToken))
  add(query_580584, "userIp", newJString(userIp))
  add(query_580584, "key", newJString(key))
  add(query_580584, "prettyPrint", newJBool(prettyPrint))
  result = call_580582.call(path_580583, query_580584, nil, nil, nil)

var calendarCalendarListDelete* = Call_CalendarCalendarListDelete_580570(
    name: "calendarCalendarListDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/me/calendarList/{calendarId}",
    validator: validate_CalendarCalendarListDelete_580571, base: "/calendar/v3",
    url: url_CalendarCalendarListDelete_580572, schemes: {Scheme.Https})
type
  Call_CalendarSettingsList_580603 = ref object of OpenApiRestCall_579424
proc url_CalendarSettingsList_580605(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarSettingsList_580604(path: JsonNode; query: JsonNode;
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
  var valid_580606 = query.getOrDefault("fields")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "fields", valid_580606
  var valid_580607 = query.getOrDefault("pageToken")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "pageToken", valid_580607
  var valid_580608 = query.getOrDefault("quotaUser")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "quotaUser", valid_580608
  var valid_580609 = query.getOrDefault("alt")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = newJString("json"))
  if valid_580609 != nil:
    section.add "alt", valid_580609
  var valid_580610 = query.getOrDefault("oauth_token")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "oauth_token", valid_580610
  var valid_580611 = query.getOrDefault("syncToken")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "syncToken", valid_580611
  var valid_580612 = query.getOrDefault("userIp")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "userIp", valid_580612
  var valid_580613 = query.getOrDefault("maxResults")
  valid_580613 = validateParameter(valid_580613, JInt, required = false, default = nil)
  if valid_580613 != nil:
    section.add "maxResults", valid_580613
  var valid_580614 = query.getOrDefault("key")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "key", valid_580614
  var valid_580615 = query.getOrDefault("prettyPrint")
  valid_580615 = validateParameter(valid_580615, JBool, required = false,
                                 default = newJBool(true))
  if valid_580615 != nil:
    section.add "prettyPrint", valid_580615
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580616: Call_CalendarSettingsList_580603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns all user settings for the authenticated user.
  ## 
  let valid = call_580616.validator(path, query, header, formData, body)
  let scheme = call_580616.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580616.url(scheme.get, call_580616.host, call_580616.base,
                         call_580616.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580616, url, valid)

proc call*(call_580617: Call_CalendarSettingsList_580603; fields: string = "";
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
  var query_580618 = newJObject()
  add(query_580618, "fields", newJString(fields))
  add(query_580618, "pageToken", newJString(pageToken))
  add(query_580618, "quotaUser", newJString(quotaUser))
  add(query_580618, "alt", newJString(alt))
  add(query_580618, "oauth_token", newJString(oauthToken))
  add(query_580618, "syncToken", newJString(syncToken))
  add(query_580618, "userIp", newJString(userIp))
  add(query_580618, "maxResults", newJInt(maxResults))
  add(query_580618, "key", newJString(key))
  add(query_580618, "prettyPrint", newJBool(prettyPrint))
  result = call_580617.call(nil, query_580618, nil, nil, nil)

var calendarSettingsList* = Call_CalendarSettingsList_580603(
    name: "calendarSettingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/settings",
    validator: validate_CalendarSettingsList_580604, base: "/calendar/v3",
    url: url_CalendarSettingsList_580605, schemes: {Scheme.Https})
type
  Call_CalendarSettingsWatch_580619 = ref object of OpenApiRestCall_579424
proc url_CalendarSettingsWatch_580621(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CalendarSettingsWatch_580620(path: JsonNode; query: JsonNode;
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
  var valid_580622 = query.getOrDefault("fields")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "fields", valid_580622
  var valid_580623 = query.getOrDefault("pageToken")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = nil)
  if valid_580623 != nil:
    section.add "pageToken", valid_580623
  var valid_580624 = query.getOrDefault("quotaUser")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "quotaUser", valid_580624
  var valid_580625 = query.getOrDefault("alt")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = newJString("json"))
  if valid_580625 != nil:
    section.add "alt", valid_580625
  var valid_580626 = query.getOrDefault("oauth_token")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "oauth_token", valid_580626
  var valid_580627 = query.getOrDefault("syncToken")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "syncToken", valid_580627
  var valid_580628 = query.getOrDefault("userIp")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "userIp", valid_580628
  var valid_580629 = query.getOrDefault("maxResults")
  valid_580629 = validateParameter(valid_580629, JInt, required = false, default = nil)
  if valid_580629 != nil:
    section.add "maxResults", valid_580629
  var valid_580630 = query.getOrDefault("key")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "key", valid_580630
  var valid_580631 = query.getOrDefault("prettyPrint")
  valid_580631 = validateParameter(valid_580631, JBool, required = false,
                                 default = newJBool(true))
  if valid_580631 != nil:
    section.add "prettyPrint", valid_580631
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

proc call*(call_580633: Call_CalendarSettingsWatch_580619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes to Settings resources.
  ## 
  let valid = call_580633.validator(path, query, header, formData, body)
  let scheme = call_580633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580633.url(scheme.get, call_580633.host, call_580633.base,
                         call_580633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580633, url, valid)

proc call*(call_580634: Call_CalendarSettingsWatch_580619; fields: string = "";
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
  var query_580635 = newJObject()
  var body_580636 = newJObject()
  add(query_580635, "fields", newJString(fields))
  add(query_580635, "pageToken", newJString(pageToken))
  add(query_580635, "quotaUser", newJString(quotaUser))
  add(query_580635, "alt", newJString(alt))
  add(query_580635, "oauth_token", newJString(oauthToken))
  add(query_580635, "syncToken", newJString(syncToken))
  add(query_580635, "userIp", newJString(userIp))
  add(query_580635, "maxResults", newJInt(maxResults))
  add(query_580635, "key", newJString(key))
  if resource != nil:
    body_580636 = resource
  add(query_580635, "prettyPrint", newJBool(prettyPrint))
  result = call_580634.call(nil, query_580635, nil, nil, body_580636)

var calendarSettingsWatch* = Call_CalendarSettingsWatch_580619(
    name: "calendarSettingsWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/me/settings/watch",
    validator: validate_CalendarSettingsWatch_580620, base: "/calendar/v3",
    url: url_CalendarSettingsWatch_580621, schemes: {Scheme.Https})
type
  Call_CalendarSettingsGet_580637 = ref object of OpenApiRestCall_579424
proc url_CalendarSettingsGet_580639(protocol: Scheme; host: string; base: string;
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

proc validate_CalendarSettingsGet_580638(path: JsonNode; query: JsonNode;
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
  var valid_580640 = path.getOrDefault("setting")
  valid_580640 = validateParameter(valid_580640, JString, required = true,
                                 default = nil)
  if valid_580640 != nil:
    section.add "setting", valid_580640
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
  var valid_580641 = query.getOrDefault("fields")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "fields", valid_580641
  var valid_580642 = query.getOrDefault("quotaUser")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "quotaUser", valid_580642
  var valid_580643 = query.getOrDefault("alt")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = newJString("json"))
  if valid_580643 != nil:
    section.add "alt", valid_580643
  var valid_580644 = query.getOrDefault("oauth_token")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "oauth_token", valid_580644
  var valid_580645 = query.getOrDefault("userIp")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "userIp", valid_580645
  var valid_580646 = query.getOrDefault("key")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "key", valid_580646
  var valid_580647 = query.getOrDefault("prettyPrint")
  valid_580647 = validateParameter(valid_580647, JBool, required = false,
                                 default = newJBool(true))
  if valid_580647 != nil:
    section.add "prettyPrint", valid_580647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580648: Call_CalendarSettingsGet_580637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a single user setting.
  ## 
  let valid = call_580648.validator(path, query, header, formData, body)
  let scheme = call_580648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580648.url(scheme.get, call_580648.host, call_580648.base,
                         call_580648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580648, url, valid)

proc call*(call_580649: Call_CalendarSettingsGet_580637; setting: string;
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
  var path_580650 = newJObject()
  var query_580651 = newJObject()
  add(query_580651, "fields", newJString(fields))
  add(query_580651, "quotaUser", newJString(quotaUser))
  add(query_580651, "alt", newJString(alt))
  add(query_580651, "oauth_token", newJString(oauthToken))
  add(query_580651, "userIp", newJString(userIp))
  add(path_580650, "setting", newJString(setting))
  add(query_580651, "key", newJString(key))
  add(query_580651, "prettyPrint", newJBool(prettyPrint))
  result = call_580649.call(path_580650, query_580651, nil, nil, nil)

var calendarSettingsGet* = Call_CalendarSettingsGet_580637(
    name: "calendarSettingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/me/settings/{setting}",
    validator: validate_CalendarSettingsGet_580638, base: "/calendar/v3",
    url: url_CalendarSettingsGet_580639, schemes: {Scheme.Https})
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
