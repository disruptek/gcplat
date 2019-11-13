
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play Game Services
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The API for Google Play Game Services.
## 
## https://developers.google.com/games/services/
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

  OpenApiRestCall_579389 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579389](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579389): Option[Scheme] {.used.} =
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
  gcpServiceName = "games"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GamesAchievementDefinitionsList_579659 = ref object of OpenApiRestCall_579389
proc url_GamesAchievementDefinitionsList_579661(protocol: Scheme; host: string;
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

proc validate_GamesAchievementDefinitionsList_579660(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the achievement definitions for your application.
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
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of achievement resources to return in the response, used for paging. For any response, the actual number of achievement resources returned may be less than the specified maxResults.
  section = newJObject()
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579787 = query.getOrDefault("prettyPrint")
  valid_579787 = validateParameter(valid_579787, JBool, required = false,
                                 default = newJBool(true))
  if valid_579787 != nil:
    section.add "prettyPrint", valid_579787
  var valid_579788 = query.getOrDefault("oauth_token")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "oauth_token", valid_579788
  var valid_579789 = query.getOrDefault("alt")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = newJString("json"))
  if valid_579789 != nil:
    section.add "alt", valid_579789
  var valid_579790 = query.getOrDefault("userIp")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "userIp", valid_579790
  var valid_579791 = query.getOrDefault("quotaUser")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "quotaUser", valid_579791
  var valid_579792 = query.getOrDefault("pageToken")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "pageToken", valid_579792
  var valid_579793 = query.getOrDefault("fields")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "fields", valid_579793
  var valid_579794 = query.getOrDefault("language")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "language", valid_579794
  var valid_579795 = query.getOrDefault("maxResults")
  valid_579795 = validateParameter(valid_579795, JInt, required = false, default = nil)
  if valid_579795 != nil:
    section.add "maxResults", valid_579795
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579818: Call_GamesAchievementDefinitionsList_579659;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the achievement definitions for your application.
  ## 
  let valid = call_579818.validator(path, query, header, formData, body)
  let scheme = call_579818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579818.url(scheme.get, call_579818.host, call_579818.base,
                         call_579818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579818, url, valid)

proc call*(call_579889: Call_GamesAchievementDefinitionsList_579659;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; language: string = "";
          maxResults: int = 0): Recallable =
  ## gamesAchievementDefinitionsList
  ## Lists all the achievement definitions for your application.
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
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of achievement resources to return in the response, used for paging. For any response, the actual number of achievement resources returned may be less than the specified maxResults.
  var query_579890 = newJObject()
  add(query_579890, "key", newJString(key))
  add(query_579890, "prettyPrint", newJBool(prettyPrint))
  add(query_579890, "oauth_token", newJString(oauthToken))
  add(query_579890, "alt", newJString(alt))
  add(query_579890, "userIp", newJString(userIp))
  add(query_579890, "quotaUser", newJString(quotaUser))
  add(query_579890, "pageToken", newJString(pageToken))
  add(query_579890, "fields", newJString(fields))
  add(query_579890, "language", newJString(language))
  add(query_579890, "maxResults", newJInt(maxResults))
  result = call_579889.call(nil, query_579890, nil, nil, nil)

var gamesAchievementDefinitionsList* = Call_GamesAchievementDefinitionsList_579659(
    name: "gamesAchievementDefinitionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/achievements",
    validator: validate_GamesAchievementDefinitionsList_579660, base: "/games/v1",
    url: url_GamesAchievementDefinitionsList_579661, schemes: {Scheme.Https})
type
  Call_GamesAchievementsUpdateMultiple_579930 = ref object of OpenApiRestCall_579389
proc url_GamesAchievementsUpdateMultiple_579932(protocol: Scheme; host: string;
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

proc validate_GamesAchievementsUpdateMultiple_579931(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates multiple achievements for the currently authenticated player.
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
  ##   builtinGameId: JString
  ##                : Override used only by built-in games in Play Games application.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579933 = query.getOrDefault("key")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "key", valid_579933
  var valid_579934 = query.getOrDefault("prettyPrint")
  valid_579934 = validateParameter(valid_579934, JBool, required = false,
                                 default = newJBool(true))
  if valid_579934 != nil:
    section.add "prettyPrint", valid_579934
  var valid_579935 = query.getOrDefault("oauth_token")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "oauth_token", valid_579935
  var valid_579936 = query.getOrDefault("alt")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = newJString("json"))
  if valid_579936 != nil:
    section.add "alt", valid_579936
  var valid_579937 = query.getOrDefault("userIp")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "userIp", valid_579937
  var valid_579938 = query.getOrDefault("quotaUser")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "quotaUser", valid_579938
  var valid_579939 = query.getOrDefault("builtinGameId")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "builtinGameId", valid_579939
  var valid_579940 = query.getOrDefault("fields")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "fields", valid_579940
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

proc call*(call_579942: Call_GamesAchievementsUpdateMultiple_579930;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates multiple achievements for the currently authenticated player.
  ## 
  let valid = call_579942.validator(path, query, header, formData, body)
  let scheme = call_579942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579942.url(scheme.get, call_579942.host, call_579942.base,
                         call_579942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579942, url, valid)

proc call*(call_579943: Call_GamesAchievementsUpdateMultiple_579930;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; builtinGameId: string = ""; fields: string = ""): Recallable =
  ## gamesAchievementsUpdateMultiple
  ## Updates multiple achievements for the currently authenticated player.
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
  ##   builtinGameId: string
  ##                : Override used only by built-in games in Play Games application.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579944 = newJObject()
  var body_579945 = newJObject()
  add(query_579944, "key", newJString(key))
  add(query_579944, "prettyPrint", newJBool(prettyPrint))
  add(query_579944, "oauth_token", newJString(oauthToken))
  add(query_579944, "alt", newJString(alt))
  add(query_579944, "userIp", newJString(userIp))
  add(query_579944, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579945 = body
  add(query_579944, "builtinGameId", newJString(builtinGameId))
  add(query_579944, "fields", newJString(fields))
  result = call_579943.call(nil, query_579944, nil, nil, body_579945)

var gamesAchievementsUpdateMultiple* = Call_GamesAchievementsUpdateMultiple_579930(
    name: "gamesAchievementsUpdateMultiple", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/updateMultiple",
    validator: validate_GamesAchievementsUpdateMultiple_579931, base: "/games/v1",
    url: url_GamesAchievementsUpdateMultiple_579932, schemes: {Scheme.Https})
type
  Call_GamesAchievementsIncrement_579946 = ref object of OpenApiRestCall_579389
proc url_GamesAchievementsIncrement_579948(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "achievementId" in path, "`achievementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/achievements/"),
               (kind: VariableSegment, value: "achievementId"),
               (kind: ConstantSegment, value: "/increment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesAchievementsIncrement_579947(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Increments the steps of the achievement with the given ID for the currently authenticated player.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   achievementId: JString (required)
  ##                : The ID of the achievement used by this method.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `achievementId` field"
  var valid_579963 = path.getOrDefault("achievementId")
  valid_579963 = validateParameter(valid_579963, JString, required = true,
                                 default = nil)
  if valid_579963 != nil:
    section.add "achievementId", valid_579963
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
  ##   requestId: JString
  ##            : A randomly generated numeric ID for each request specified by the caller. This number is used at the server to ensure that the request is handled correctly across retries.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   stepsToIncrement: JInt (required)
  ##                   : The number of steps to increment.
  section = newJObject()
  var valid_579964 = query.getOrDefault("key")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "key", valid_579964
  var valid_579965 = query.getOrDefault("prettyPrint")
  valid_579965 = validateParameter(valid_579965, JBool, required = false,
                                 default = newJBool(true))
  if valid_579965 != nil:
    section.add "prettyPrint", valid_579965
  var valid_579966 = query.getOrDefault("oauth_token")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "oauth_token", valid_579966
  var valid_579967 = query.getOrDefault("alt")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = newJString("json"))
  if valid_579967 != nil:
    section.add "alt", valid_579967
  var valid_579968 = query.getOrDefault("userIp")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "userIp", valid_579968
  var valid_579969 = query.getOrDefault("quotaUser")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "quotaUser", valid_579969
  var valid_579970 = query.getOrDefault("requestId")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "requestId", valid_579970
  var valid_579971 = query.getOrDefault("fields")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "fields", valid_579971
  assert query != nil,
        "query argument is necessary due to required `stepsToIncrement` field"
  var valid_579972 = query.getOrDefault("stepsToIncrement")
  valid_579972 = validateParameter(valid_579972, JInt, required = true, default = nil)
  if valid_579972 != nil:
    section.add "stepsToIncrement", valid_579972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579973: Call_GamesAchievementsIncrement_579946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Increments the steps of the achievement with the given ID for the currently authenticated player.
  ## 
  let valid = call_579973.validator(path, query, header, formData, body)
  let scheme = call_579973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579973.url(scheme.get, call_579973.host, call_579973.base,
                         call_579973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579973, url, valid)

proc call*(call_579974: Call_GamesAchievementsIncrement_579946;
          achievementId: string; stepsToIncrement: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; requestId: string = "";
          fields: string = ""): Recallable =
  ## gamesAchievementsIncrement
  ## Increments the steps of the achievement with the given ID for the currently authenticated player.
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
  ##   achievementId: string (required)
  ##                : The ID of the achievement used by this method.
  ##   requestId: string
  ##            : A randomly generated numeric ID for each request specified by the caller. This number is used at the server to ensure that the request is handled correctly across retries.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   stepsToIncrement: int (required)
  ##                   : The number of steps to increment.
  var path_579975 = newJObject()
  var query_579976 = newJObject()
  add(query_579976, "key", newJString(key))
  add(query_579976, "prettyPrint", newJBool(prettyPrint))
  add(query_579976, "oauth_token", newJString(oauthToken))
  add(query_579976, "alt", newJString(alt))
  add(query_579976, "userIp", newJString(userIp))
  add(query_579976, "quotaUser", newJString(quotaUser))
  add(path_579975, "achievementId", newJString(achievementId))
  add(query_579976, "requestId", newJString(requestId))
  add(query_579976, "fields", newJString(fields))
  add(query_579976, "stepsToIncrement", newJInt(stepsToIncrement))
  result = call_579974.call(path_579975, query_579976, nil, nil, nil)

var gamesAchievementsIncrement* = Call_GamesAchievementsIncrement_579946(
    name: "gamesAchievementsIncrement", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/increment",
    validator: validate_GamesAchievementsIncrement_579947, base: "/games/v1",
    url: url_GamesAchievementsIncrement_579948, schemes: {Scheme.Https})
type
  Call_GamesAchievementsReveal_579977 = ref object of OpenApiRestCall_579389
proc url_GamesAchievementsReveal_579979(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "achievementId" in path, "`achievementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/achievements/"),
               (kind: VariableSegment, value: "achievementId"),
               (kind: ConstantSegment, value: "/reveal")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesAchievementsReveal_579978(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the state of the achievement with the given ID to REVEALED for the currently authenticated player.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   achievementId: JString (required)
  ##                : The ID of the achievement used by this method.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `achievementId` field"
  var valid_579980 = path.getOrDefault("achievementId")
  valid_579980 = validateParameter(valid_579980, JString, required = true,
                                 default = nil)
  if valid_579980 != nil:
    section.add "achievementId", valid_579980
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
  var valid_579981 = query.getOrDefault("key")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "key", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(true))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
  var valid_579983 = query.getOrDefault("oauth_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "oauth_token", valid_579983
  var valid_579984 = query.getOrDefault("alt")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("json"))
  if valid_579984 != nil:
    section.add "alt", valid_579984
  var valid_579985 = query.getOrDefault("userIp")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "userIp", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("fields")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "fields", valid_579987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579988: Call_GamesAchievementsReveal_579977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the achievement with the given ID to REVEALED for the currently authenticated player.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_GamesAchievementsReveal_579977; achievementId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesAchievementsReveal
  ## Sets the state of the achievement with the given ID to REVEALED for the currently authenticated player.
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
  ##   achievementId: string (required)
  ##                : The ID of the achievement used by this method.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579990 = newJObject()
  var query_579991 = newJObject()
  add(query_579991, "key", newJString(key))
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  add(query_579991, "oauth_token", newJString(oauthToken))
  add(query_579991, "alt", newJString(alt))
  add(query_579991, "userIp", newJString(userIp))
  add(query_579991, "quotaUser", newJString(quotaUser))
  add(path_579990, "achievementId", newJString(achievementId))
  add(query_579991, "fields", newJString(fields))
  result = call_579989.call(path_579990, query_579991, nil, nil, nil)

var gamesAchievementsReveal* = Call_GamesAchievementsReveal_579977(
    name: "gamesAchievementsReveal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/reveal",
    validator: validate_GamesAchievementsReveal_579978, base: "/games/v1",
    url: url_GamesAchievementsReveal_579979, schemes: {Scheme.Https})
type
  Call_GamesAchievementsSetStepsAtLeast_579992 = ref object of OpenApiRestCall_579389
proc url_GamesAchievementsSetStepsAtLeast_579994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "achievementId" in path, "`achievementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/achievements/"),
               (kind: VariableSegment, value: "achievementId"),
               (kind: ConstantSegment, value: "/setStepsAtLeast")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesAchievementsSetStepsAtLeast_579993(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the steps for the currently authenticated player towards unlocking an achievement. If the steps parameter is less than the current number of steps that the player already gained for the achievement, the achievement is not modified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   achievementId: JString (required)
  ##                : The ID of the achievement used by this method.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `achievementId` field"
  var valid_579995 = path.getOrDefault("achievementId")
  valid_579995 = validateParameter(valid_579995, JString, required = true,
                                 default = nil)
  if valid_579995 != nil:
    section.add "achievementId", valid_579995
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   steps: JInt (required)
  ##        : The minimum value to set the steps to.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("prettyPrint")
  valid_579997 = validateParameter(valid_579997, JBool, required = false,
                                 default = newJBool(true))
  if valid_579997 != nil:
    section.add "prettyPrint", valid_579997
  var valid_579998 = query.getOrDefault("oauth_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "oauth_token", valid_579998
  assert query != nil, "query argument is necessary due to required `steps` field"
  var valid_579999 = query.getOrDefault("steps")
  valid_579999 = validateParameter(valid_579999, JInt, required = true, default = nil)
  if valid_579999 != nil:
    section.add "steps", valid_579999
  var valid_580000 = query.getOrDefault("alt")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("json"))
  if valid_580000 != nil:
    section.add "alt", valid_580000
  var valid_580001 = query.getOrDefault("userIp")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "userIp", valid_580001
  var valid_580002 = query.getOrDefault("quotaUser")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "quotaUser", valid_580002
  var valid_580003 = query.getOrDefault("fields")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "fields", valid_580003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_GamesAchievementsSetStepsAtLeast_579992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the steps for the currently authenticated player towards unlocking an achievement. If the steps parameter is less than the current number of steps that the player already gained for the achievement, the achievement is not modified.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_GamesAchievementsSetStepsAtLeast_579992; steps: int;
          achievementId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesAchievementsSetStepsAtLeast
  ## Sets the steps for the currently authenticated player towards unlocking an achievement. If the steps parameter is less than the current number of steps that the player already gained for the achievement, the achievement is not modified.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   steps: int (required)
  ##        : The minimum value to set the steps to.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   achievementId: string (required)
  ##                : The ID of the achievement used by this method.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  add(query_580007, "key", newJString(key))
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "steps", newJInt(steps))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "userIp", newJString(userIp))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(path_580006, "achievementId", newJString(achievementId))
  add(query_580007, "fields", newJString(fields))
  result = call_580005.call(path_580006, query_580007, nil, nil, nil)

var gamesAchievementsSetStepsAtLeast* = Call_GamesAchievementsSetStepsAtLeast_579992(
    name: "gamesAchievementsSetStepsAtLeast", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/achievements/{achievementId}/setStepsAtLeast",
    validator: validate_GamesAchievementsSetStepsAtLeast_579993,
    base: "/games/v1", url: url_GamesAchievementsSetStepsAtLeast_579994,
    schemes: {Scheme.Https})
type
  Call_GamesAchievementsUnlock_580008 = ref object of OpenApiRestCall_579389
proc url_GamesAchievementsUnlock_580010(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "achievementId" in path, "`achievementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/achievements/"),
               (kind: VariableSegment, value: "achievementId"),
               (kind: ConstantSegment, value: "/unlock")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesAchievementsUnlock_580009(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unlocks this achievement for the currently authenticated player.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   achievementId: JString (required)
  ##                : The ID of the achievement used by this method.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `achievementId` field"
  var valid_580011 = path.getOrDefault("achievementId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "achievementId", valid_580011
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
  ##   builtinGameId: JString
  ##                : Override used only by built-in games in Play Games application.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("prettyPrint")
  valid_580013 = validateParameter(valid_580013, JBool, required = false,
                                 default = newJBool(true))
  if valid_580013 != nil:
    section.add "prettyPrint", valid_580013
  var valid_580014 = query.getOrDefault("oauth_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "oauth_token", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("userIp")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userIp", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("builtinGameId")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "builtinGameId", valid_580018
  var valid_580019 = query.getOrDefault("fields")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "fields", valid_580019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580020: Call_GamesAchievementsUnlock_580008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unlocks this achievement for the currently authenticated player.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_GamesAchievementsUnlock_580008; achievementId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          builtinGameId: string = ""; fields: string = ""): Recallable =
  ## gamesAchievementsUnlock
  ## Unlocks this achievement for the currently authenticated player.
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
  ##   achievementId: string (required)
  ##                : The ID of the achievement used by this method.
  ##   builtinGameId: string
  ##                : Override used only by built-in games in Play Games application.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580022 = newJObject()
  var query_580023 = newJObject()
  add(query_580023, "key", newJString(key))
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "userIp", newJString(userIp))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(path_580022, "achievementId", newJString(achievementId))
  add(query_580023, "builtinGameId", newJString(builtinGameId))
  add(query_580023, "fields", newJString(fields))
  result = call_580021.call(path_580022, query_580023, nil, nil, nil)

var gamesAchievementsUnlock* = Call_GamesAchievementsUnlock_580008(
    name: "gamesAchievementsUnlock", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/unlock",
    validator: validate_GamesAchievementsUnlock_580009, base: "/games/v1",
    url: url_GamesAchievementsUnlock_580010, schemes: {Scheme.Https})
type
  Call_GamesApplicationsPlayed_580024 = ref object of OpenApiRestCall_579389
proc url_GamesApplicationsPlayed_580026(protocol: Scheme; host: string; base: string;
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

proc validate_GamesApplicationsPlayed_580025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Indicate that the the currently authenticated user is playing your application.
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
  ##   builtinGameId: JString
  ##                : Override used only by built-in games in Play Games application.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580027 = query.getOrDefault("key")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "key", valid_580027
  var valid_580028 = query.getOrDefault("prettyPrint")
  valid_580028 = validateParameter(valid_580028, JBool, required = false,
                                 default = newJBool(true))
  if valid_580028 != nil:
    section.add "prettyPrint", valid_580028
  var valid_580029 = query.getOrDefault("oauth_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "oauth_token", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("userIp")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "userIp", valid_580031
  var valid_580032 = query.getOrDefault("quotaUser")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "quotaUser", valid_580032
  var valid_580033 = query.getOrDefault("builtinGameId")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "builtinGameId", valid_580033
  var valid_580034 = query.getOrDefault("fields")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "fields", valid_580034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580035: Call_GamesApplicationsPlayed_580024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicate that the the currently authenticated user is playing your application.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_GamesApplicationsPlayed_580024; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; builtinGameId: string = "";
          fields: string = ""): Recallable =
  ## gamesApplicationsPlayed
  ## Indicate that the the currently authenticated user is playing your application.
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
  ##   builtinGameId: string
  ##                : Override used only by built-in games in Play Games application.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580037 = newJObject()
  add(query_580037, "key", newJString(key))
  add(query_580037, "prettyPrint", newJBool(prettyPrint))
  add(query_580037, "oauth_token", newJString(oauthToken))
  add(query_580037, "alt", newJString(alt))
  add(query_580037, "userIp", newJString(userIp))
  add(query_580037, "quotaUser", newJString(quotaUser))
  add(query_580037, "builtinGameId", newJString(builtinGameId))
  add(query_580037, "fields", newJString(fields))
  result = call_580036.call(nil, query_580037, nil, nil, nil)

var gamesApplicationsPlayed* = Call_GamesApplicationsPlayed_580024(
    name: "gamesApplicationsPlayed", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/applications/played",
    validator: validate_GamesApplicationsPlayed_580025, base: "/games/v1",
    url: url_GamesApplicationsPlayed_580026, schemes: {Scheme.Https})
type
  Call_GamesApplicationsGet_580038 = ref object of OpenApiRestCall_579389
proc url_GamesApplicationsGet_580040(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesApplicationsGet_580039(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metadata of the application with the given ID. If the requested application is not available for the specified platformType, the returned response will not include any instance data.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The application ID from the Google Play developer console.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_580041 = path.getOrDefault("applicationId")
  valid_580041 = validateParameter(valid_580041, JString, required = true,
                                 default = nil)
  if valid_580041 != nil:
    section.add "applicationId", valid_580041
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   platformType: JString
  ##               : Restrict application details returned to the specific platform.
  section = newJObject()
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("prettyPrint")
  valid_580043 = validateParameter(valid_580043, JBool, required = false,
                                 default = newJBool(true))
  if valid_580043 != nil:
    section.add "prettyPrint", valid_580043
  var valid_580044 = query.getOrDefault("oauth_token")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "oauth_token", valid_580044
  var valid_580045 = query.getOrDefault("alt")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = newJString("json"))
  if valid_580045 != nil:
    section.add "alt", valid_580045
  var valid_580046 = query.getOrDefault("userIp")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "userIp", valid_580046
  var valid_580047 = query.getOrDefault("quotaUser")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "quotaUser", valid_580047
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("language")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "language", valid_580049
  var valid_580050 = query.getOrDefault("platformType")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("ANDROID"))
  if valid_580050 != nil:
    section.add "platformType", valid_580050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580051: Call_GamesApplicationsGet_580038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata of the application with the given ID. If the requested application is not available for the specified platformType, the returned response will not include any instance data.
  ## 
  let valid = call_580051.validator(path, query, header, formData, body)
  let scheme = call_580051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580051.url(scheme.get, call_580051.host, call_580051.base,
                         call_580051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580051, url, valid)

proc call*(call_580052: Call_GamesApplicationsGet_580038; applicationId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; language: string = ""; platformType: string = "ANDROID"): Recallable =
  ## gamesApplicationsGet
  ## Retrieves the metadata of the application with the given ID. If the requested application is not available for the specified platformType, the returned response will not include any instance data.
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
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   platformType: string
  ##               : Restrict application details returned to the specific platform.
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  var path_580053 = newJObject()
  var query_580054 = newJObject()
  add(query_580054, "key", newJString(key))
  add(query_580054, "prettyPrint", newJBool(prettyPrint))
  add(query_580054, "oauth_token", newJString(oauthToken))
  add(query_580054, "alt", newJString(alt))
  add(query_580054, "userIp", newJString(userIp))
  add(query_580054, "quotaUser", newJString(quotaUser))
  add(query_580054, "fields", newJString(fields))
  add(query_580054, "language", newJString(language))
  add(query_580054, "platformType", newJString(platformType))
  add(path_580053, "applicationId", newJString(applicationId))
  result = call_580052.call(path_580053, query_580054, nil, nil, nil)

var gamesApplicationsGet* = Call_GamesApplicationsGet_580038(
    name: "gamesApplicationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}",
    validator: validate_GamesApplicationsGet_580039, base: "/games/v1",
    url: url_GamesApplicationsGet_580040, schemes: {Scheme.Https})
type
  Call_GamesApplicationsVerify_580055 = ref object of OpenApiRestCall_579389
proc url_GamesApplicationsVerify_580057(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/verify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesApplicationsVerify_580056(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies the auth token provided with this request is for the application with the specified ID, and returns the ID of the player it was granted for.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The application ID from the Google Play developer console.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_580058 = path.getOrDefault("applicationId")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "applicationId", valid_580058
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
  var valid_580059 = query.getOrDefault("key")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "key", valid_580059
  var valid_580060 = query.getOrDefault("prettyPrint")
  valid_580060 = validateParameter(valid_580060, JBool, required = false,
                                 default = newJBool(true))
  if valid_580060 != nil:
    section.add "prettyPrint", valid_580060
  var valid_580061 = query.getOrDefault("oauth_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "oauth_token", valid_580061
  var valid_580062 = query.getOrDefault("alt")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("json"))
  if valid_580062 != nil:
    section.add "alt", valid_580062
  var valid_580063 = query.getOrDefault("userIp")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "userIp", valid_580063
  var valid_580064 = query.getOrDefault("quotaUser")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "quotaUser", valid_580064
  var valid_580065 = query.getOrDefault("fields")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "fields", valid_580065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_GamesApplicationsVerify_580055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies the auth token provided with this request is for the application with the specified ID, and returns the ID of the player it was granted for.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_GamesApplicationsVerify_580055; applicationId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesApplicationsVerify
  ## Verifies the auth token provided with this request is for the application with the specified ID, and returns the ID of the player it was granted for.
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
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  add(query_580069, "key", newJString(key))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "userIp", newJString(userIp))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(query_580069, "fields", newJString(fields))
  add(path_580068, "applicationId", newJString(applicationId))
  result = call_580067.call(path_580068, query_580069, nil, nil, nil)

var gamesApplicationsVerify* = Call_GamesApplicationsVerify_580055(
    name: "gamesApplicationsVerify", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}/verify",
    validator: validate_GamesApplicationsVerify_580056, base: "/games/v1",
    url: url_GamesApplicationsVerify_580057, schemes: {Scheme.Https})
type
  Call_GamesEventsListDefinitions_580070 = ref object of OpenApiRestCall_579389
proc url_GamesEventsListDefinitions_580072(protocol: Scheme; host: string;
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

proc validate_GamesEventsListDefinitions_580071(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of the event definitions in this application.
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
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of event definitions to return in the response, used for paging. For any response, the actual number of event definitions to return may be less than the specified maxResults.
  section = newJObject()
  var valid_580073 = query.getOrDefault("key")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "key", valid_580073
  var valid_580074 = query.getOrDefault("prettyPrint")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(true))
  if valid_580074 != nil:
    section.add "prettyPrint", valid_580074
  var valid_580075 = query.getOrDefault("oauth_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "oauth_token", valid_580075
  var valid_580076 = query.getOrDefault("alt")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("json"))
  if valid_580076 != nil:
    section.add "alt", valid_580076
  var valid_580077 = query.getOrDefault("userIp")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "userIp", valid_580077
  var valid_580078 = query.getOrDefault("quotaUser")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "quotaUser", valid_580078
  var valid_580079 = query.getOrDefault("pageToken")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "pageToken", valid_580079
  var valid_580080 = query.getOrDefault("fields")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "fields", valid_580080
  var valid_580081 = query.getOrDefault("language")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "language", valid_580081
  var valid_580082 = query.getOrDefault("maxResults")
  valid_580082 = validateParameter(valid_580082, JInt, required = false, default = nil)
  if valid_580082 != nil:
    section.add "maxResults", valid_580082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580083: Call_GamesEventsListDefinitions_580070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the event definitions in this application.
  ## 
  let valid = call_580083.validator(path, query, header, formData, body)
  let scheme = call_580083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580083.url(scheme.get, call_580083.host, call_580083.base,
                         call_580083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580083, url, valid)

proc call*(call_580084: Call_GamesEventsListDefinitions_580070; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; language: string = ""; maxResults: int = 0): Recallable =
  ## gamesEventsListDefinitions
  ## Returns a list of the event definitions in this application.
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
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of event definitions to return in the response, used for paging. For any response, the actual number of event definitions to return may be less than the specified maxResults.
  var query_580085 = newJObject()
  add(query_580085, "key", newJString(key))
  add(query_580085, "prettyPrint", newJBool(prettyPrint))
  add(query_580085, "oauth_token", newJString(oauthToken))
  add(query_580085, "alt", newJString(alt))
  add(query_580085, "userIp", newJString(userIp))
  add(query_580085, "quotaUser", newJString(quotaUser))
  add(query_580085, "pageToken", newJString(pageToken))
  add(query_580085, "fields", newJString(fields))
  add(query_580085, "language", newJString(language))
  add(query_580085, "maxResults", newJInt(maxResults))
  result = call_580084.call(nil, query_580085, nil, nil, nil)

var gamesEventsListDefinitions* = Call_GamesEventsListDefinitions_580070(
    name: "gamesEventsListDefinitions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/eventDefinitions",
    validator: validate_GamesEventsListDefinitions_580071, base: "/games/v1",
    url: url_GamesEventsListDefinitions_580072, schemes: {Scheme.Https})
type
  Call_GamesEventsRecord_580102 = ref object of OpenApiRestCall_579389
proc url_GamesEventsRecord_580104(protocol: Scheme; host: string; base: string;
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

proc validate_GamesEventsRecord_580103(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Records a batch of changes to the number of times events have occurred for the currently authenticated user of this application.
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580105 = query.getOrDefault("key")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "key", valid_580105
  var valid_580106 = query.getOrDefault("prettyPrint")
  valid_580106 = validateParameter(valid_580106, JBool, required = false,
                                 default = newJBool(true))
  if valid_580106 != nil:
    section.add "prettyPrint", valid_580106
  var valid_580107 = query.getOrDefault("oauth_token")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "oauth_token", valid_580107
  var valid_580108 = query.getOrDefault("alt")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = newJString("json"))
  if valid_580108 != nil:
    section.add "alt", valid_580108
  var valid_580109 = query.getOrDefault("userIp")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "userIp", valid_580109
  var valid_580110 = query.getOrDefault("quotaUser")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "quotaUser", valid_580110
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("language")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "language", valid_580112
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

proc call*(call_580114: Call_GamesEventsRecord_580102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Records a batch of changes to the number of times events have occurred for the currently authenticated user of this application.
  ## 
  let valid = call_580114.validator(path, query, header, formData, body)
  let scheme = call_580114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580114.url(scheme.get, call_580114.host, call_580114.base,
                         call_580114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580114, url, valid)

proc call*(call_580115: Call_GamesEventsRecord_580102; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""; language: string = ""): Recallable =
  ## gamesEventsRecord
  ## Records a batch of changes to the number of times events have occurred for the currently authenticated user of this application.
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
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var query_580116 = newJObject()
  var body_580117 = newJObject()
  add(query_580116, "key", newJString(key))
  add(query_580116, "prettyPrint", newJBool(prettyPrint))
  add(query_580116, "oauth_token", newJString(oauthToken))
  add(query_580116, "alt", newJString(alt))
  add(query_580116, "userIp", newJString(userIp))
  add(query_580116, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580117 = body
  add(query_580116, "fields", newJString(fields))
  add(query_580116, "language", newJString(language))
  result = call_580115.call(nil, query_580116, nil, nil, body_580117)

var gamesEventsRecord* = Call_GamesEventsRecord_580102(name: "gamesEventsRecord",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/events",
    validator: validate_GamesEventsRecord_580103, base: "/games/v1",
    url: url_GamesEventsRecord_580104, schemes: {Scheme.Https})
type
  Call_GamesEventsListByPlayer_580086 = ref object of OpenApiRestCall_579389
proc url_GamesEventsListByPlayer_580088(protocol: Scheme; host: string; base: string;
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

proc validate_GamesEventsListByPlayer_580087(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list showing the current progress on events in this application for the currently authenticated user.
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
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of events to return in the response, used for paging. For any response, the actual number of events to return may be less than the specified maxResults.
  section = newJObject()
  var valid_580089 = query.getOrDefault("key")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "key", valid_580089
  var valid_580090 = query.getOrDefault("prettyPrint")
  valid_580090 = validateParameter(valid_580090, JBool, required = false,
                                 default = newJBool(true))
  if valid_580090 != nil:
    section.add "prettyPrint", valid_580090
  var valid_580091 = query.getOrDefault("oauth_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "oauth_token", valid_580091
  var valid_580092 = query.getOrDefault("alt")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("json"))
  if valid_580092 != nil:
    section.add "alt", valid_580092
  var valid_580093 = query.getOrDefault("userIp")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "userIp", valid_580093
  var valid_580094 = query.getOrDefault("quotaUser")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "quotaUser", valid_580094
  var valid_580095 = query.getOrDefault("pageToken")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "pageToken", valid_580095
  var valid_580096 = query.getOrDefault("fields")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "fields", valid_580096
  var valid_580097 = query.getOrDefault("language")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "language", valid_580097
  var valid_580098 = query.getOrDefault("maxResults")
  valid_580098 = validateParameter(valid_580098, JInt, required = false, default = nil)
  if valid_580098 != nil:
    section.add "maxResults", valid_580098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580099: Call_GamesEventsListByPlayer_580086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list showing the current progress on events in this application for the currently authenticated user.
  ## 
  let valid = call_580099.validator(path, query, header, formData, body)
  let scheme = call_580099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580099.url(scheme.get, call_580099.host, call_580099.base,
                         call_580099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580099, url, valid)

proc call*(call_580100: Call_GamesEventsListByPlayer_580086; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; language: string = ""; maxResults: int = 0): Recallable =
  ## gamesEventsListByPlayer
  ## Returns a list showing the current progress on events in this application for the currently authenticated user.
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
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of events to return in the response, used for paging. For any response, the actual number of events to return may be less than the specified maxResults.
  var query_580101 = newJObject()
  add(query_580101, "key", newJString(key))
  add(query_580101, "prettyPrint", newJBool(prettyPrint))
  add(query_580101, "oauth_token", newJString(oauthToken))
  add(query_580101, "alt", newJString(alt))
  add(query_580101, "userIp", newJString(userIp))
  add(query_580101, "quotaUser", newJString(quotaUser))
  add(query_580101, "pageToken", newJString(pageToken))
  add(query_580101, "fields", newJString(fields))
  add(query_580101, "language", newJString(language))
  add(query_580101, "maxResults", newJInt(maxResults))
  result = call_580100.call(nil, query_580101, nil, nil, nil)

var gamesEventsListByPlayer* = Call_GamesEventsListByPlayer_580086(
    name: "gamesEventsListByPlayer", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/events",
    validator: validate_GamesEventsListByPlayer_580087, base: "/games/v1",
    url: url_GamesEventsListByPlayer_580088, schemes: {Scheme.Https})
type
  Call_GamesLeaderboardsList_580118 = ref object of OpenApiRestCall_579389
proc url_GamesLeaderboardsList_580120(protocol: Scheme; host: string; base: string;
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

proc validate_GamesLeaderboardsList_580119(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the leaderboard metadata for your application.
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
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of leaderboards to return in the response. For any response, the actual number of leaderboards returned may be less than the specified maxResults.
  section = newJObject()
  var valid_580121 = query.getOrDefault("key")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "key", valid_580121
  var valid_580122 = query.getOrDefault("prettyPrint")
  valid_580122 = validateParameter(valid_580122, JBool, required = false,
                                 default = newJBool(true))
  if valid_580122 != nil:
    section.add "prettyPrint", valid_580122
  var valid_580123 = query.getOrDefault("oauth_token")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "oauth_token", valid_580123
  var valid_580124 = query.getOrDefault("alt")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = newJString("json"))
  if valid_580124 != nil:
    section.add "alt", valid_580124
  var valid_580125 = query.getOrDefault("userIp")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "userIp", valid_580125
  var valid_580126 = query.getOrDefault("quotaUser")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "quotaUser", valid_580126
  var valid_580127 = query.getOrDefault("pageToken")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "pageToken", valid_580127
  var valid_580128 = query.getOrDefault("fields")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "fields", valid_580128
  var valid_580129 = query.getOrDefault("language")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "language", valid_580129
  var valid_580130 = query.getOrDefault("maxResults")
  valid_580130 = validateParameter(valid_580130, JInt, required = false, default = nil)
  if valid_580130 != nil:
    section.add "maxResults", valid_580130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580131: Call_GamesLeaderboardsList_580118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the leaderboard metadata for your application.
  ## 
  let valid = call_580131.validator(path, query, header, formData, body)
  let scheme = call_580131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580131.url(scheme.get, call_580131.host, call_580131.base,
                         call_580131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580131, url, valid)

proc call*(call_580132: Call_GamesLeaderboardsList_580118; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; language: string = ""; maxResults: int = 0): Recallable =
  ## gamesLeaderboardsList
  ## Lists all the leaderboard metadata for your application.
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
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of leaderboards to return in the response. For any response, the actual number of leaderboards returned may be less than the specified maxResults.
  var query_580133 = newJObject()
  add(query_580133, "key", newJString(key))
  add(query_580133, "prettyPrint", newJBool(prettyPrint))
  add(query_580133, "oauth_token", newJString(oauthToken))
  add(query_580133, "alt", newJString(alt))
  add(query_580133, "userIp", newJString(userIp))
  add(query_580133, "quotaUser", newJString(quotaUser))
  add(query_580133, "pageToken", newJString(pageToken))
  add(query_580133, "fields", newJString(fields))
  add(query_580133, "language", newJString(language))
  add(query_580133, "maxResults", newJInt(maxResults))
  result = call_580132.call(nil, query_580133, nil, nil, nil)

var gamesLeaderboardsList* = Call_GamesLeaderboardsList_580118(
    name: "gamesLeaderboardsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/leaderboards",
    validator: validate_GamesLeaderboardsList_580119, base: "/games/v1",
    url: url_GamesLeaderboardsList_580120, schemes: {Scheme.Https})
type
  Call_GamesScoresSubmitMultiple_580134 = ref object of OpenApiRestCall_579389
proc url_GamesScoresSubmitMultiple_580136(protocol: Scheme; host: string;
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

proc validate_GamesScoresSubmitMultiple_580135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submits multiple scores to leaderboards.
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580137 = query.getOrDefault("key")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "key", valid_580137
  var valid_580138 = query.getOrDefault("prettyPrint")
  valid_580138 = validateParameter(valid_580138, JBool, required = false,
                                 default = newJBool(true))
  if valid_580138 != nil:
    section.add "prettyPrint", valid_580138
  var valid_580139 = query.getOrDefault("oauth_token")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "oauth_token", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("userIp")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "userIp", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("fields")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "fields", valid_580143
  var valid_580144 = query.getOrDefault("language")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "language", valid_580144
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

proc call*(call_580146: Call_GamesScoresSubmitMultiple_580134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits multiple scores to leaderboards.
  ## 
  let valid = call_580146.validator(path, query, header, formData, body)
  let scheme = call_580146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580146.url(scheme.get, call_580146.host, call_580146.base,
                         call_580146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580146, url, valid)

proc call*(call_580147: Call_GamesScoresSubmitMultiple_580134; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""; language: string = ""): Recallable =
  ## gamesScoresSubmitMultiple
  ## Submits multiple scores to leaderboards.
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
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var query_580148 = newJObject()
  var body_580149 = newJObject()
  add(query_580148, "key", newJString(key))
  add(query_580148, "prettyPrint", newJBool(prettyPrint))
  add(query_580148, "oauth_token", newJString(oauthToken))
  add(query_580148, "alt", newJString(alt))
  add(query_580148, "userIp", newJString(userIp))
  add(query_580148, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580149 = body
  add(query_580148, "fields", newJString(fields))
  add(query_580148, "language", newJString(language))
  result = call_580147.call(nil, query_580148, nil, nil, body_580149)

var gamesScoresSubmitMultiple* = Call_GamesScoresSubmitMultiple_580134(
    name: "gamesScoresSubmitMultiple", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/leaderboards/scores",
    validator: validate_GamesScoresSubmitMultiple_580135, base: "/games/v1",
    url: url_GamesScoresSubmitMultiple_580136, schemes: {Scheme.Https})
type
  Call_GamesLeaderboardsGet_580150 = ref object of OpenApiRestCall_579389
proc url_GamesLeaderboardsGet_580152(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "leaderboardId" in path, "`leaderboardId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/leaderboards/"),
               (kind: VariableSegment, value: "leaderboardId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesLeaderboardsGet_580151(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the metadata of the leaderboard with the given ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `leaderboardId` field"
  var valid_580153 = path.getOrDefault("leaderboardId")
  valid_580153 = validateParameter(valid_580153, JString, required = true,
                                 default = nil)
  if valid_580153 != nil:
    section.add "leaderboardId", valid_580153
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580154 = query.getOrDefault("key")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "key", valid_580154
  var valid_580155 = query.getOrDefault("prettyPrint")
  valid_580155 = validateParameter(valid_580155, JBool, required = false,
                                 default = newJBool(true))
  if valid_580155 != nil:
    section.add "prettyPrint", valid_580155
  var valid_580156 = query.getOrDefault("oauth_token")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "oauth_token", valid_580156
  var valid_580157 = query.getOrDefault("alt")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = newJString("json"))
  if valid_580157 != nil:
    section.add "alt", valid_580157
  var valid_580158 = query.getOrDefault("userIp")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "userIp", valid_580158
  var valid_580159 = query.getOrDefault("quotaUser")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "quotaUser", valid_580159
  var valid_580160 = query.getOrDefault("fields")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "fields", valid_580160
  var valid_580161 = query.getOrDefault("language")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "language", valid_580161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580162: Call_GamesLeaderboardsGet_580150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata of the leaderboard with the given ID.
  ## 
  let valid = call_580162.validator(path, query, header, formData, body)
  let scheme = call_580162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580162.url(scheme.get, call_580162.host, call_580162.base,
                         call_580162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580162, url, valid)

proc call*(call_580163: Call_GamesLeaderboardsGet_580150; leaderboardId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; language: string = ""): Recallable =
  ## gamesLeaderboardsGet
  ## Retrieves the metadata of the leaderboard with the given ID.
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
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580164 = newJObject()
  var query_580165 = newJObject()
  add(query_580165, "key", newJString(key))
  add(query_580165, "prettyPrint", newJBool(prettyPrint))
  add(query_580165, "oauth_token", newJString(oauthToken))
  add(query_580165, "alt", newJString(alt))
  add(query_580165, "userIp", newJString(userIp))
  add(query_580165, "quotaUser", newJString(quotaUser))
  add(query_580165, "fields", newJString(fields))
  add(path_580164, "leaderboardId", newJString(leaderboardId))
  add(query_580165, "language", newJString(language))
  result = call_580163.call(path_580164, query_580165, nil, nil, nil)

var gamesLeaderboardsGet* = Call_GamesLeaderboardsGet_580150(
    name: "gamesLeaderboardsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesLeaderboardsGet_580151, base: "/games/v1",
    url: url_GamesLeaderboardsGet_580152, schemes: {Scheme.Https})
type
  Call_GamesScoresSubmit_580166 = ref object of OpenApiRestCall_579389
proc url_GamesScoresSubmit_580168(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "leaderboardId" in path, "`leaderboardId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/leaderboards/"),
               (kind: VariableSegment, value: "leaderboardId"),
               (kind: ConstantSegment, value: "/scores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesScoresSubmit_580167(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Submits a score to the specified leaderboard.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `leaderboardId` field"
  var valid_580169 = path.getOrDefault("leaderboardId")
  valid_580169 = validateParameter(valid_580169, JString, required = true,
                                 default = nil)
  if valid_580169 != nil:
    section.add "leaderboardId", valid_580169
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   scoreTag: JString
  ##           : Additional information about the score you're submitting. Values must contain no more than 64 URI-safe characters as defined by section 2.3 of RFC 3986.
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
  ##   score: JString (required)
  ##        : The score you're submitting. The submitted score is ignored if it is worse than a previously submitted score, where worse depends on the leaderboard sort order. The meaning of the score value depends on the leaderboard format type. For fixed-point, the score represents the raw value. For time, the score represents elapsed time in milliseconds. For currency, the score represents a value in micro units.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580170 = query.getOrDefault("key")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "key", valid_580170
  var valid_580171 = query.getOrDefault("scoreTag")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "scoreTag", valid_580171
  var valid_580172 = query.getOrDefault("prettyPrint")
  valid_580172 = validateParameter(valid_580172, JBool, required = false,
                                 default = newJBool(true))
  if valid_580172 != nil:
    section.add "prettyPrint", valid_580172
  var valid_580173 = query.getOrDefault("oauth_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "oauth_token", valid_580173
  var valid_580174 = query.getOrDefault("alt")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = newJString("json"))
  if valid_580174 != nil:
    section.add "alt", valid_580174
  var valid_580175 = query.getOrDefault("userIp")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "userIp", valid_580175
  var valid_580176 = query.getOrDefault("quotaUser")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "quotaUser", valid_580176
  assert query != nil, "query argument is necessary due to required `score` field"
  var valid_580177 = query.getOrDefault("score")
  valid_580177 = validateParameter(valid_580177, JString, required = true,
                                 default = nil)
  if valid_580177 != nil:
    section.add "score", valid_580177
  var valid_580178 = query.getOrDefault("fields")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "fields", valid_580178
  var valid_580179 = query.getOrDefault("language")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "language", valid_580179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580180: Call_GamesScoresSubmit_580166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a score to the specified leaderboard.
  ## 
  let valid = call_580180.validator(path, query, header, formData, body)
  let scheme = call_580180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580180.url(scheme.get, call_580180.host, call_580180.base,
                         call_580180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580180, url, valid)

proc call*(call_580181: Call_GamesScoresSubmit_580166; score: string;
          leaderboardId: string; key: string = ""; scoreTag: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = "";
          language: string = ""): Recallable =
  ## gamesScoresSubmit
  ## Submits a score to the specified leaderboard.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   scoreTag: string
  ##           : Additional information about the score you're submitting. Values must contain no more than 64 URI-safe characters as defined by section 2.3 of RFC 3986.
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
  ##   score: string (required)
  ##        : The score you're submitting. The submitted score is ignored if it is worse than a previously submitted score, where worse depends on the leaderboard sort order. The meaning of the score value depends on the leaderboard format type. For fixed-point, the score represents the raw value. For time, the score represents elapsed time in milliseconds. For currency, the score represents a value in micro units.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580182 = newJObject()
  var query_580183 = newJObject()
  add(query_580183, "key", newJString(key))
  add(query_580183, "scoreTag", newJString(scoreTag))
  add(query_580183, "prettyPrint", newJBool(prettyPrint))
  add(query_580183, "oauth_token", newJString(oauthToken))
  add(query_580183, "alt", newJString(alt))
  add(query_580183, "userIp", newJString(userIp))
  add(query_580183, "quotaUser", newJString(quotaUser))
  add(query_580183, "score", newJString(score))
  add(query_580183, "fields", newJString(fields))
  add(path_580182, "leaderboardId", newJString(leaderboardId))
  add(query_580183, "language", newJString(language))
  result = call_580181.call(path_580182, query_580183, nil, nil, nil)

var gamesScoresSubmit* = Call_GamesScoresSubmit_580166(name: "gamesScoresSubmit",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores",
    validator: validate_GamesScoresSubmit_580167, base: "/games/v1",
    url: url_GamesScoresSubmit_580168, schemes: {Scheme.Https})
type
  Call_GamesScoresList_580184 = ref object of OpenApiRestCall_579389
proc url_GamesScoresList_580186(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "leaderboardId" in path, "`leaderboardId` is a required path parameter"
  assert "collection" in path, "`collection` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/leaderboards/"),
               (kind: VariableSegment, value: "leaderboardId"),
               (kind: ConstantSegment, value: "/scores/"),
               (kind: VariableSegment, value: "collection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesScoresList_580185(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists the scores in a leaderboard, starting from the top.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard.
  ##   collection: JString (required)
  ##             : The collection of scores you're requesting.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `leaderboardId` field"
  var valid_580187 = path.getOrDefault("leaderboardId")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "leaderboardId", valid_580187
  var valid_580188 = path.getOrDefault("collection")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = newJString("PUBLIC"))
  if valid_580188 != nil:
    section.add "collection", valid_580188
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
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   timeSpan: JString (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  section = newJObject()
  var valid_580189 = query.getOrDefault("key")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "key", valid_580189
  var valid_580190 = query.getOrDefault("prettyPrint")
  valid_580190 = validateParameter(valid_580190, JBool, required = false,
                                 default = newJBool(true))
  if valid_580190 != nil:
    section.add "prettyPrint", valid_580190
  var valid_580191 = query.getOrDefault("oauth_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "oauth_token", valid_580191
  var valid_580192 = query.getOrDefault("alt")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("json"))
  if valid_580192 != nil:
    section.add "alt", valid_580192
  var valid_580193 = query.getOrDefault("userIp")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "userIp", valid_580193
  var valid_580194 = query.getOrDefault("quotaUser")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "quotaUser", valid_580194
  var valid_580195 = query.getOrDefault("pageToken")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "pageToken", valid_580195
  var valid_580196 = query.getOrDefault("fields")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "fields", valid_580196
  assert query != nil,
        "query argument is necessary due to required `timeSpan` field"
  var valid_580197 = query.getOrDefault("timeSpan")
  valid_580197 = validateParameter(valid_580197, JString, required = true,
                                 default = newJString("ALL_TIME"))
  if valid_580197 != nil:
    section.add "timeSpan", valid_580197
  var valid_580198 = query.getOrDefault("language")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "language", valid_580198
  var valid_580199 = query.getOrDefault("maxResults")
  valid_580199 = validateParameter(valid_580199, JInt, required = false, default = nil)
  if valid_580199 != nil:
    section.add "maxResults", valid_580199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580200: Call_GamesScoresList_580184; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the scores in a leaderboard, starting from the top.
  ## 
  let valid = call_580200.validator(path, query, header, formData, body)
  let scheme = call_580200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580200.url(scheme.get, call_580200.host, call_580200.base,
                         call_580200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580200, url, valid)

proc call*(call_580201: Call_GamesScoresList_580184; leaderboardId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; timeSpan: string = "ALL_TIME";
          collection: string = "PUBLIC"; language: string = ""; maxResults: int = 0): Recallable =
  ## gamesScoresList
  ## Lists the scores in a leaderboard, starting from the top.
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
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard.
  ##   timeSpan: string (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   collection: string (required)
  ##             : The collection of scores you're requesting.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  var path_580202 = newJObject()
  var query_580203 = newJObject()
  add(query_580203, "key", newJString(key))
  add(query_580203, "prettyPrint", newJBool(prettyPrint))
  add(query_580203, "oauth_token", newJString(oauthToken))
  add(query_580203, "alt", newJString(alt))
  add(query_580203, "userIp", newJString(userIp))
  add(query_580203, "quotaUser", newJString(quotaUser))
  add(query_580203, "pageToken", newJString(pageToken))
  add(query_580203, "fields", newJString(fields))
  add(path_580202, "leaderboardId", newJString(leaderboardId))
  add(query_580203, "timeSpan", newJString(timeSpan))
  add(path_580202, "collection", newJString(collection))
  add(query_580203, "language", newJString(language))
  add(query_580203, "maxResults", newJInt(maxResults))
  result = call_580201.call(path_580202, query_580203, nil, nil, nil)

var gamesScoresList* = Call_GamesScoresList_580184(name: "gamesScoresList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/{collection}",
    validator: validate_GamesScoresList_580185, base: "/games/v1",
    url: url_GamesScoresList_580186, schemes: {Scheme.Https})
type
  Call_GamesScoresListWindow_580204 = ref object of OpenApiRestCall_579389
proc url_GamesScoresListWindow_580206(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "leaderboardId" in path, "`leaderboardId` is a required path parameter"
  assert "collection" in path, "`collection` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/leaderboards/"),
               (kind: VariableSegment, value: "leaderboardId"),
               (kind: ConstantSegment, value: "/window/"),
               (kind: VariableSegment, value: "collection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesScoresListWindow_580205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the scores in a leaderboard around (and including) a player's score.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard.
  ##   collection: JString (required)
  ##             : The collection of scores you're requesting.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `leaderboardId` field"
  var valid_580207 = path.getOrDefault("leaderboardId")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "leaderboardId", valid_580207
  var valid_580208 = path.getOrDefault("collection")
  valid_580208 = validateParameter(valid_580208, JString, required = true,
                                 default = newJString("PUBLIC"))
  if valid_580208 != nil:
    section.add "collection", valid_580208
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   resultsAbove: JInt
  ##               : The preferred number of scores to return above the player's score. More scores may be returned if the player is at the bottom of the leaderboard; fewer may be returned if the player is at the top. Must be less than or equal to maxResults.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   returnTopIfAbsent: JBool
  ##                    : True if the top scores should be returned when the player is not in the leaderboard. Defaults to true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   timeSpan: JString (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  section = newJObject()
  var valid_580209 = query.getOrDefault("key")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "key", valid_580209
  var valid_580210 = query.getOrDefault("prettyPrint")
  valid_580210 = validateParameter(valid_580210, JBool, required = false,
                                 default = newJBool(true))
  if valid_580210 != nil:
    section.add "prettyPrint", valid_580210
  var valid_580211 = query.getOrDefault("oauth_token")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "oauth_token", valid_580211
  var valid_580212 = query.getOrDefault("resultsAbove")
  valid_580212 = validateParameter(valid_580212, JInt, required = false, default = nil)
  if valid_580212 != nil:
    section.add "resultsAbove", valid_580212
  var valid_580213 = query.getOrDefault("alt")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("json"))
  if valid_580213 != nil:
    section.add "alt", valid_580213
  var valid_580214 = query.getOrDefault("userIp")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "userIp", valid_580214
  var valid_580215 = query.getOrDefault("quotaUser")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "quotaUser", valid_580215
  var valid_580216 = query.getOrDefault("pageToken")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "pageToken", valid_580216
  var valid_580217 = query.getOrDefault("returnTopIfAbsent")
  valid_580217 = validateParameter(valid_580217, JBool, required = false, default = nil)
  if valid_580217 != nil:
    section.add "returnTopIfAbsent", valid_580217
  var valid_580218 = query.getOrDefault("fields")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "fields", valid_580218
  assert query != nil,
        "query argument is necessary due to required `timeSpan` field"
  var valid_580219 = query.getOrDefault("timeSpan")
  valid_580219 = validateParameter(valid_580219, JString, required = true,
                                 default = newJString("ALL_TIME"))
  if valid_580219 != nil:
    section.add "timeSpan", valid_580219
  var valid_580220 = query.getOrDefault("language")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "language", valid_580220
  var valid_580221 = query.getOrDefault("maxResults")
  valid_580221 = validateParameter(valid_580221, JInt, required = false, default = nil)
  if valid_580221 != nil:
    section.add "maxResults", valid_580221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580222: Call_GamesScoresListWindow_580204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the scores in a leaderboard around (and including) a player's score.
  ## 
  let valid = call_580222.validator(path, query, header, formData, body)
  let scheme = call_580222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580222.url(scheme.get, call_580222.host, call_580222.base,
                         call_580222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580222, url, valid)

proc call*(call_580223: Call_GamesScoresListWindow_580204; leaderboardId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          resultsAbove: int = 0; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = "";
          returnTopIfAbsent: bool = false; fields: string = "";
          timeSpan: string = "ALL_TIME"; collection: string = "PUBLIC";
          language: string = ""; maxResults: int = 0): Recallable =
  ## gamesScoresListWindow
  ## Lists the scores in a leaderboard around (and including) a player's score.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resultsAbove: int
  ##               : The preferred number of scores to return above the player's score. More scores may be returned if the player is at the bottom of the leaderboard; fewer may be returned if the player is at the top. Must be less than or equal to maxResults.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   returnTopIfAbsent: bool
  ##                    : True if the top scores should be returned when the player is not in the leaderboard. Defaults to true.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard.
  ##   timeSpan: string (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   collection: string (required)
  ##             : The collection of scores you're requesting.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  var path_580224 = newJObject()
  var query_580225 = newJObject()
  add(query_580225, "key", newJString(key))
  add(query_580225, "prettyPrint", newJBool(prettyPrint))
  add(query_580225, "oauth_token", newJString(oauthToken))
  add(query_580225, "resultsAbove", newJInt(resultsAbove))
  add(query_580225, "alt", newJString(alt))
  add(query_580225, "userIp", newJString(userIp))
  add(query_580225, "quotaUser", newJString(quotaUser))
  add(query_580225, "pageToken", newJString(pageToken))
  add(query_580225, "returnTopIfAbsent", newJBool(returnTopIfAbsent))
  add(query_580225, "fields", newJString(fields))
  add(path_580224, "leaderboardId", newJString(leaderboardId))
  add(query_580225, "timeSpan", newJString(timeSpan))
  add(path_580224, "collection", newJString(collection))
  add(query_580225, "language", newJString(language))
  add(query_580225, "maxResults", newJInt(maxResults))
  result = call_580223.call(path_580224, query_580225, nil, nil, nil)

var gamesScoresListWindow* = Call_GamesScoresListWindow_580204(
    name: "gamesScoresListWindow", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/window/{collection}",
    validator: validate_GamesScoresListWindow_580205, base: "/games/v1",
    url: url_GamesScoresListWindow_580206, schemes: {Scheme.Https})
type
  Call_GamesMetagameGetMetagameConfig_580226 = ref object of OpenApiRestCall_579389
proc url_GamesMetagameGetMetagameConfig_580228(protocol: Scheme; host: string;
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

proc validate_GamesMetagameGetMetagameConfig_580227(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return the metagame configuration data for the calling application.
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
  var valid_580229 = query.getOrDefault("key")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "key", valid_580229
  var valid_580230 = query.getOrDefault("prettyPrint")
  valid_580230 = validateParameter(valid_580230, JBool, required = false,
                                 default = newJBool(true))
  if valid_580230 != nil:
    section.add "prettyPrint", valid_580230
  var valid_580231 = query.getOrDefault("oauth_token")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "oauth_token", valid_580231
  var valid_580232 = query.getOrDefault("alt")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = newJString("json"))
  if valid_580232 != nil:
    section.add "alt", valid_580232
  var valid_580233 = query.getOrDefault("userIp")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "userIp", valid_580233
  var valid_580234 = query.getOrDefault("quotaUser")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "quotaUser", valid_580234
  var valid_580235 = query.getOrDefault("fields")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "fields", valid_580235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580236: Call_GamesMetagameGetMetagameConfig_580226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the metagame configuration data for the calling application.
  ## 
  let valid = call_580236.validator(path, query, header, formData, body)
  let scheme = call_580236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580236.url(scheme.get, call_580236.host, call_580236.base,
                         call_580236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580236, url, valid)

proc call*(call_580237: Call_GamesMetagameGetMetagameConfig_580226;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesMetagameGetMetagameConfig
  ## Return the metagame configuration data for the calling application.
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
  var query_580238 = newJObject()
  add(query_580238, "key", newJString(key))
  add(query_580238, "prettyPrint", newJBool(prettyPrint))
  add(query_580238, "oauth_token", newJString(oauthToken))
  add(query_580238, "alt", newJString(alt))
  add(query_580238, "userIp", newJString(userIp))
  add(query_580238, "quotaUser", newJString(quotaUser))
  add(query_580238, "fields", newJString(fields))
  result = call_580237.call(nil, query_580238, nil, nil, nil)

var gamesMetagameGetMetagameConfig* = Call_GamesMetagameGetMetagameConfig_580226(
    name: "gamesMetagameGetMetagameConfig", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metagameConfig",
    validator: validate_GamesMetagameGetMetagameConfig_580227, base: "/games/v1",
    url: url_GamesMetagameGetMetagameConfig_580228, schemes: {Scheme.Https})
type
  Call_GamesPlayersList_580239 = ref object of OpenApiRestCall_579389
proc url_GamesPlayersList_580241(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "collection" in path, "`collection` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/players/me/players/"),
               (kind: VariableSegment, value: "collection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesPlayersList_580240(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get the collection of players for the currently authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collection: JString (required)
  ##             : Collection of players being retrieved
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collection` field"
  var valid_580242 = path.getOrDefault("collection")
  valid_580242 = validateParameter(valid_580242, JString, required = true,
                                 default = newJString("connected"))
  if valid_580242 != nil:
    section.add "collection", valid_580242
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
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of player resources to return in the response, used for paging. For any response, the actual number of player resources returned may be less than the specified maxResults.
  section = newJObject()
  var valid_580243 = query.getOrDefault("key")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "key", valid_580243
  var valid_580244 = query.getOrDefault("prettyPrint")
  valid_580244 = validateParameter(valid_580244, JBool, required = false,
                                 default = newJBool(true))
  if valid_580244 != nil:
    section.add "prettyPrint", valid_580244
  var valid_580245 = query.getOrDefault("oauth_token")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "oauth_token", valid_580245
  var valid_580246 = query.getOrDefault("alt")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = newJString("json"))
  if valid_580246 != nil:
    section.add "alt", valid_580246
  var valid_580247 = query.getOrDefault("userIp")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "userIp", valid_580247
  var valid_580248 = query.getOrDefault("quotaUser")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "quotaUser", valid_580248
  var valid_580249 = query.getOrDefault("pageToken")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "pageToken", valid_580249
  var valid_580250 = query.getOrDefault("fields")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "fields", valid_580250
  var valid_580251 = query.getOrDefault("language")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "language", valid_580251
  var valid_580252 = query.getOrDefault("maxResults")
  valid_580252 = validateParameter(valid_580252, JInt, required = false, default = nil)
  if valid_580252 != nil:
    section.add "maxResults", valid_580252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580253: Call_GamesPlayersList_580239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the collection of players for the currently authenticated user.
  ## 
  let valid = call_580253.validator(path, query, header, formData, body)
  let scheme = call_580253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580253.url(scheme.get, call_580253.host, call_580253.base,
                         call_580253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580253, url, valid)

proc call*(call_580254: Call_GamesPlayersList_580239; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; collection: string = "connected"; language: string = "";
          maxResults: int = 0): Recallable =
  ## gamesPlayersList
  ## Get the collection of players for the currently authenticated user.
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
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   collection: string (required)
  ##             : Collection of players being retrieved
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of player resources to return in the response, used for paging. For any response, the actual number of player resources returned may be less than the specified maxResults.
  var path_580255 = newJObject()
  var query_580256 = newJObject()
  add(query_580256, "key", newJString(key))
  add(query_580256, "prettyPrint", newJBool(prettyPrint))
  add(query_580256, "oauth_token", newJString(oauthToken))
  add(query_580256, "alt", newJString(alt))
  add(query_580256, "userIp", newJString(userIp))
  add(query_580256, "quotaUser", newJString(quotaUser))
  add(query_580256, "pageToken", newJString(pageToken))
  add(query_580256, "fields", newJString(fields))
  add(path_580255, "collection", newJString(collection))
  add(query_580256, "language", newJString(language))
  add(query_580256, "maxResults", newJInt(maxResults))
  result = call_580254.call(path_580255, query_580256, nil, nil, nil)

var gamesPlayersList* = Call_GamesPlayersList_580239(name: "gamesPlayersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/me/players/{collection}",
    validator: validate_GamesPlayersList_580240, base: "/games/v1",
    url: url_GamesPlayersList_580241, schemes: {Scheme.Https})
type
  Call_GamesPlayersGet_580257 = ref object of OpenApiRestCall_579389
proc url_GamesPlayersGet_580259(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "playerId" in path, "`playerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/players/"),
               (kind: VariableSegment, value: "playerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesPlayersGet_580258(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves the Player resource with the given ID. To retrieve the player for the currently authenticated user, set playerId to me.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   playerId: JString (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `playerId` field"
  var valid_580260 = path.getOrDefault("playerId")
  valid_580260 = validateParameter(valid_580260, JString, required = true,
                                 default = nil)
  if valid_580260 != nil:
    section.add "playerId", valid_580260
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580261 = query.getOrDefault("key")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "key", valid_580261
  var valid_580262 = query.getOrDefault("prettyPrint")
  valid_580262 = validateParameter(valid_580262, JBool, required = false,
                                 default = newJBool(true))
  if valid_580262 != nil:
    section.add "prettyPrint", valid_580262
  var valid_580263 = query.getOrDefault("oauth_token")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "oauth_token", valid_580263
  var valid_580264 = query.getOrDefault("alt")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = newJString("json"))
  if valid_580264 != nil:
    section.add "alt", valid_580264
  var valid_580265 = query.getOrDefault("userIp")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "userIp", valid_580265
  var valid_580266 = query.getOrDefault("quotaUser")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "quotaUser", valid_580266
  var valid_580267 = query.getOrDefault("fields")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "fields", valid_580267
  var valid_580268 = query.getOrDefault("language")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "language", valid_580268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580269: Call_GamesPlayersGet_580257; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the Player resource with the given ID. To retrieve the player for the currently authenticated user, set playerId to me.
  ## 
  let valid = call_580269.validator(path, query, header, formData, body)
  let scheme = call_580269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580269.url(scheme.get, call_580269.host, call_580269.base,
                         call_580269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580269, url, valid)

proc call*(call_580270: Call_GamesPlayersGet_580257; playerId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; language: string = ""): Recallable =
  ## gamesPlayersGet
  ## Retrieves the Player resource with the given ID. To retrieve the player for the currently authenticated user, set playerId to me.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580271 = newJObject()
  var query_580272 = newJObject()
  add(query_580272, "key", newJString(key))
  add(query_580272, "prettyPrint", newJBool(prettyPrint))
  add(query_580272, "oauth_token", newJString(oauthToken))
  add(path_580271, "playerId", newJString(playerId))
  add(query_580272, "alt", newJString(alt))
  add(query_580272, "userIp", newJString(userIp))
  add(query_580272, "quotaUser", newJString(quotaUser))
  add(query_580272, "fields", newJString(fields))
  add(query_580272, "language", newJString(language))
  result = call_580270.call(path_580271, query_580272, nil, nil, nil)

var gamesPlayersGet* = Call_GamesPlayersGet_580257(name: "gamesPlayersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/{playerId}", validator: validate_GamesPlayersGet_580258,
    base: "/games/v1", url: url_GamesPlayersGet_580259, schemes: {Scheme.Https})
type
  Call_GamesAchievementsList_580273 = ref object of OpenApiRestCall_579389
proc url_GamesAchievementsList_580275(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "playerId" in path, "`playerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/players/"),
               (kind: VariableSegment, value: "playerId"),
               (kind: ConstantSegment, value: "/achievements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesAchievementsList_580274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the progress for all your application's achievements for the currently authenticated player.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   playerId: JString (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `playerId` field"
  var valid_580276 = path.getOrDefault("playerId")
  valid_580276 = validateParameter(valid_580276, JString, required = true,
                                 default = nil)
  if valid_580276 != nil:
    section.add "playerId", valid_580276
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   state: JString
  ##        : Tells the server to return only achievements with the specified state. If this parameter isn't specified, all achievements are returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of achievement resources to return in the response, used for paging. For any response, the actual number of achievement resources returned may be less than the specified maxResults.
  section = newJObject()
  var valid_580277 = query.getOrDefault("key")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "key", valid_580277
  var valid_580278 = query.getOrDefault("prettyPrint")
  valid_580278 = validateParameter(valid_580278, JBool, required = false,
                                 default = newJBool(true))
  if valid_580278 != nil:
    section.add "prettyPrint", valid_580278
  var valid_580279 = query.getOrDefault("oauth_token")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "oauth_token", valid_580279
  var valid_580280 = query.getOrDefault("state")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = newJString("ALL"))
  if valid_580280 != nil:
    section.add "state", valid_580280
  var valid_580281 = query.getOrDefault("alt")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = newJString("json"))
  if valid_580281 != nil:
    section.add "alt", valid_580281
  var valid_580282 = query.getOrDefault("userIp")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "userIp", valid_580282
  var valid_580283 = query.getOrDefault("quotaUser")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "quotaUser", valid_580283
  var valid_580284 = query.getOrDefault("pageToken")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "pageToken", valid_580284
  var valid_580285 = query.getOrDefault("fields")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "fields", valid_580285
  var valid_580286 = query.getOrDefault("language")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "language", valid_580286
  var valid_580287 = query.getOrDefault("maxResults")
  valid_580287 = validateParameter(valid_580287, JInt, required = false, default = nil)
  if valid_580287 != nil:
    section.add "maxResults", valid_580287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580288: Call_GamesAchievementsList_580273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the progress for all your application's achievements for the currently authenticated player.
  ## 
  let valid = call_580288.validator(path, query, header, formData, body)
  let scheme = call_580288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580288.url(scheme.get, call_580288.host, call_580288.base,
                         call_580288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580288, url, valid)

proc call*(call_580289: Call_GamesAchievementsList_580273; playerId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          state: string = "ALL"; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          language: string = ""; maxResults: int = 0): Recallable =
  ## gamesAchievementsList
  ## Lists the progress for all your application's achievements for the currently authenticated player.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   state: string
  ##        : Tells the server to return only achievements with the specified state. If this parameter isn't specified, all achievements are returned.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of achievement resources to return in the response, used for paging. For any response, the actual number of achievement resources returned may be less than the specified maxResults.
  var path_580290 = newJObject()
  var query_580291 = newJObject()
  add(query_580291, "key", newJString(key))
  add(query_580291, "prettyPrint", newJBool(prettyPrint))
  add(query_580291, "oauth_token", newJString(oauthToken))
  add(query_580291, "state", newJString(state))
  add(path_580290, "playerId", newJString(playerId))
  add(query_580291, "alt", newJString(alt))
  add(query_580291, "userIp", newJString(userIp))
  add(query_580291, "quotaUser", newJString(quotaUser))
  add(query_580291, "pageToken", newJString(pageToken))
  add(query_580291, "fields", newJString(fields))
  add(query_580291, "language", newJString(language))
  add(query_580291, "maxResults", newJInt(maxResults))
  result = call_580289.call(path_580290, query_580291, nil, nil, nil)

var gamesAchievementsList* = Call_GamesAchievementsList_580273(
    name: "gamesAchievementsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/players/{playerId}/achievements",
    validator: validate_GamesAchievementsList_580274, base: "/games/v1",
    url: url_GamesAchievementsList_580275, schemes: {Scheme.Https})
type
  Call_GamesMetagameListCategoriesByPlayer_580292 = ref object of OpenApiRestCall_579389
proc url_GamesMetagameListCategoriesByPlayer_580294(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "playerId" in path, "`playerId` is a required path parameter"
  assert "collection" in path, "`collection` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/players/"),
               (kind: VariableSegment, value: "playerId"),
               (kind: ConstantSegment, value: "/categories/"),
               (kind: VariableSegment, value: "collection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesMetagameListCategoriesByPlayer_580293(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List play data aggregated per category for the player corresponding to playerId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   playerId: JString (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   collection: JString (required)
  ##             : The collection of categories for which data will be returned.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `playerId` field"
  var valid_580295 = path.getOrDefault("playerId")
  valid_580295 = validateParameter(valid_580295, JString, required = true,
                                 default = nil)
  if valid_580295 != nil:
    section.add "playerId", valid_580295
  var valid_580296 = path.getOrDefault("collection")
  valid_580296 = validateParameter(valid_580296, JString, required = true,
                                 default = newJString("all"))
  if valid_580296 != nil:
    section.add "collection", valid_580296
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
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of category resources to return in the response, used for paging. For any response, the actual number of category resources returned may be less than the specified maxResults.
  section = newJObject()
  var valid_580297 = query.getOrDefault("key")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "key", valid_580297
  var valid_580298 = query.getOrDefault("prettyPrint")
  valid_580298 = validateParameter(valid_580298, JBool, required = false,
                                 default = newJBool(true))
  if valid_580298 != nil:
    section.add "prettyPrint", valid_580298
  var valid_580299 = query.getOrDefault("oauth_token")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "oauth_token", valid_580299
  var valid_580300 = query.getOrDefault("alt")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = newJString("json"))
  if valid_580300 != nil:
    section.add "alt", valid_580300
  var valid_580301 = query.getOrDefault("userIp")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "userIp", valid_580301
  var valid_580302 = query.getOrDefault("quotaUser")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "quotaUser", valid_580302
  var valid_580303 = query.getOrDefault("pageToken")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "pageToken", valid_580303
  var valid_580304 = query.getOrDefault("fields")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "fields", valid_580304
  var valid_580305 = query.getOrDefault("language")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "language", valid_580305
  var valid_580306 = query.getOrDefault("maxResults")
  valid_580306 = validateParameter(valid_580306, JInt, required = false, default = nil)
  if valid_580306 != nil:
    section.add "maxResults", valid_580306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580307: Call_GamesMetagameListCategoriesByPlayer_580292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List play data aggregated per category for the player corresponding to playerId.
  ## 
  let valid = call_580307.validator(path, query, header, formData, body)
  let scheme = call_580307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580307.url(scheme.get, call_580307.host, call_580307.base,
                         call_580307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580307, url, valid)

proc call*(call_580308: Call_GamesMetagameListCategoriesByPlayer_580292;
          playerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          collection: string = "all"; language: string = ""; maxResults: int = 0): Recallable =
  ## gamesMetagameListCategoriesByPlayer
  ## List play data aggregated per category for the player corresponding to playerId.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   collection: string (required)
  ##             : The collection of categories for which data will be returned.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of category resources to return in the response, used for paging. For any response, the actual number of category resources returned may be less than the specified maxResults.
  var path_580309 = newJObject()
  var query_580310 = newJObject()
  add(query_580310, "key", newJString(key))
  add(query_580310, "prettyPrint", newJBool(prettyPrint))
  add(query_580310, "oauth_token", newJString(oauthToken))
  add(path_580309, "playerId", newJString(playerId))
  add(query_580310, "alt", newJString(alt))
  add(query_580310, "userIp", newJString(userIp))
  add(query_580310, "quotaUser", newJString(quotaUser))
  add(query_580310, "pageToken", newJString(pageToken))
  add(query_580310, "fields", newJString(fields))
  add(path_580309, "collection", newJString(collection))
  add(query_580310, "language", newJString(language))
  add(query_580310, "maxResults", newJInt(maxResults))
  result = call_580308.call(path_580309, query_580310, nil, nil, nil)

var gamesMetagameListCategoriesByPlayer* = Call_GamesMetagameListCategoriesByPlayer_580292(
    name: "gamesMetagameListCategoriesByPlayer", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/players/{playerId}/categories/{collection}",
    validator: validate_GamesMetagameListCategoriesByPlayer_580293,
    base: "/games/v1", url: url_GamesMetagameListCategoriesByPlayer_580294,
    schemes: {Scheme.Https})
type
  Call_GamesScoresGet_580311 = ref object of OpenApiRestCall_579389
proc url_GamesScoresGet_580313(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "playerId" in path, "`playerId` is a required path parameter"
  assert "leaderboardId" in path, "`leaderboardId` is a required path parameter"
  assert "timeSpan" in path, "`timeSpan` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/players/"),
               (kind: VariableSegment, value: "playerId"),
               (kind: ConstantSegment, value: "/leaderboards/"),
               (kind: VariableSegment, value: "leaderboardId"),
               (kind: ConstantSegment, value: "/scores/"),
               (kind: VariableSegment, value: "timeSpan")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesScoresGet_580312(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get high scores, and optionally ranks, in leaderboards for the currently authenticated player. For a specific time span, leaderboardId can be set to ALL to retrieve data for all leaderboards in a given time span.
  ## NOTE: You cannot ask for 'ALL' leaderboards and 'ALL' timeSpans in the same request; only one parameter may be set to 'ALL'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   playerId: JString (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   timeSpan: JString (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard. Can be set to 'ALL' to retrieve data for all leaderboards for this application.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `playerId` field"
  var valid_580314 = path.getOrDefault("playerId")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "playerId", valid_580314
  var valid_580315 = path.getOrDefault("timeSpan")
  valid_580315 = validateParameter(valid_580315, JString, required = true,
                                 default = newJString("ALL"))
  if valid_580315 != nil:
    section.add "timeSpan", valid_580315
  var valid_580316 = path.getOrDefault("leaderboardId")
  valid_580316 = validateParameter(valid_580316, JString, required = true,
                                 default = nil)
  if valid_580316 != nil:
    section.add "leaderboardId", valid_580316
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
  ##   includeRankType: JString
  ##                  : The types of ranks to return. If the parameter is omitted, no ranks will be returned.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  section = newJObject()
  var valid_580317 = query.getOrDefault("key")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "key", valid_580317
  var valid_580318 = query.getOrDefault("prettyPrint")
  valid_580318 = validateParameter(valid_580318, JBool, required = false,
                                 default = newJBool(true))
  if valid_580318 != nil:
    section.add "prettyPrint", valid_580318
  var valid_580319 = query.getOrDefault("oauth_token")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "oauth_token", valid_580319
  var valid_580320 = query.getOrDefault("alt")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = newJString("json"))
  if valid_580320 != nil:
    section.add "alt", valid_580320
  var valid_580321 = query.getOrDefault("userIp")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "userIp", valid_580321
  var valid_580322 = query.getOrDefault("quotaUser")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "quotaUser", valid_580322
  var valid_580323 = query.getOrDefault("includeRankType")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = newJString("ALL"))
  if valid_580323 != nil:
    section.add "includeRankType", valid_580323
  var valid_580324 = query.getOrDefault("pageToken")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "pageToken", valid_580324
  var valid_580325 = query.getOrDefault("fields")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "fields", valid_580325
  var valid_580326 = query.getOrDefault("language")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "language", valid_580326
  var valid_580327 = query.getOrDefault("maxResults")
  valid_580327 = validateParameter(valid_580327, JInt, required = false, default = nil)
  if valid_580327 != nil:
    section.add "maxResults", valid_580327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580328: Call_GamesScoresGet_580311; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get high scores, and optionally ranks, in leaderboards for the currently authenticated player. For a specific time span, leaderboardId can be set to ALL to retrieve data for all leaderboards in a given time span.
  ## NOTE: You cannot ask for 'ALL' leaderboards and 'ALL' timeSpans in the same request; only one parameter may be set to 'ALL'.
  ## 
  let valid = call_580328.validator(path, query, header, formData, body)
  let scheme = call_580328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580328.url(scheme.get, call_580328.host, call_580328.base,
                         call_580328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580328, url, valid)

proc call*(call_580329: Call_GamesScoresGet_580311; playerId: string;
          leaderboardId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          timeSpan: string = "ALL"; quotaUser: string = "";
          includeRankType: string = "ALL"; pageToken: string = ""; fields: string = "";
          language: string = ""; maxResults: int = 0): Recallable =
  ## gamesScoresGet
  ## Get high scores, and optionally ranks, in leaderboards for the currently authenticated player. For a specific time span, leaderboardId can be set to ALL to retrieve data for all leaderboards in a given time span.
  ## NOTE: You cannot ask for 'ALL' leaderboards and 'ALL' timeSpans in the same request; only one parameter may be set to 'ALL'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   timeSpan: string (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeRankType: string
  ##                  : The types of ranks to return. If the parameter is omitted, no ranks will be returned.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard. Can be set to 'ALL' to retrieve data for all leaderboards for this application.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  var path_580330 = newJObject()
  var query_580331 = newJObject()
  add(query_580331, "key", newJString(key))
  add(query_580331, "prettyPrint", newJBool(prettyPrint))
  add(query_580331, "oauth_token", newJString(oauthToken))
  add(path_580330, "playerId", newJString(playerId))
  add(query_580331, "alt", newJString(alt))
  add(query_580331, "userIp", newJString(userIp))
  add(path_580330, "timeSpan", newJString(timeSpan))
  add(query_580331, "quotaUser", newJString(quotaUser))
  add(query_580331, "includeRankType", newJString(includeRankType))
  add(query_580331, "pageToken", newJString(pageToken))
  add(query_580331, "fields", newJString(fields))
  add(path_580330, "leaderboardId", newJString(leaderboardId))
  add(query_580331, "language", newJString(language))
  add(query_580331, "maxResults", newJInt(maxResults))
  result = call_580329.call(path_580330, query_580331, nil, nil, nil)

var gamesScoresGet* = Call_GamesScoresGet_580311(name: "gamesScoresGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/players/{playerId}/leaderboards/{leaderboardId}/scores/{timeSpan}",
    validator: validate_GamesScoresGet_580312, base: "/games/v1",
    url: url_GamesScoresGet_580313, schemes: {Scheme.Https})
type
  Call_GamesSnapshotsList_580332 = ref object of OpenApiRestCall_579389
proc url_GamesSnapshotsList_580334(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "playerId" in path, "`playerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/players/"),
               (kind: VariableSegment, value: "playerId"),
               (kind: ConstantSegment, value: "/snapshots")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesSnapshotsList_580333(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of snapshots created by your application for the player corresponding to the player ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   playerId: JString (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `playerId` field"
  var valid_580335 = path.getOrDefault("playerId")
  valid_580335 = validateParameter(valid_580335, JString, required = true,
                                 default = nil)
  if valid_580335 != nil:
    section.add "playerId", valid_580335
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
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of snapshot resources to return in the response, used for paging. For any response, the actual number of snapshot resources returned may be less than the specified maxResults.
  section = newJObject()
  var valid_580336 = query.getOrDefault("key")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "key", valid_580336
  var valid_580337 = query.getOrDefault("prettyPrint")
  valid_580337 = validateParameter(valid_580337, JBool, required = false,
                                 default = newJBool(true))
  if valid_580337 != nil:
    section.add "prettyPrint", valid_580337
  var valid_580338 = query.getOrDefault("oauth_token")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "oauth_token", valid_580338
  var valid_580339 = query.getOrDefault("alt")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = newJString("json"))
  if valid_580339 != nil:
    section.add "alt", valid_580339
  var valid_580340 = query.getOrDefault("userIp")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "userIp", valid_580340
  var valid_580341 = query.getOrDefault("quotaUser")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "quotaUser", valid_580341
  var valid_580342 = query.getOrDefault("pageToken")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "pageToken", valid_580342
  var valid_580343 = query.getOrDefault("fields")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "fields", valid_580343
  var valid_580344 = query.getOrDefault("language")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "language", valid_580344
  var valid_580345 = query.getOrDefault("maxResults")
  valid_580345 = validateParameter(valid_580345, JInt, required = false, default = nil)
  if valid_580345 != nil:
    section.add "maxResults", valid_580345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580346: Call_GamesSnapshotsList_580332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of snapshots created by your application for the player corresponding to the player ID.
  ## 
  let valid = call_580346.validator(path, query, header, formData, body)
  let scheme = call_580346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580346.url(scheme.get, call_580346.host, call_580346.base,
                         call_580346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580346, url, valid)

proc call*(call_580347: Call_GamesSnapshotsList_580332; playerId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; language: string = "";
          maxResults: int = 0): Recallable =
  ## gamesSnapshotsList
  ## Retrieves a list of snapshots created by your application for the player corresponding to the player ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of snapshot resources to return in the response, used for paging. For any response, the actual number of snapshot resources returned may be less than the specified maxResults.
  var path_580348 = newJObject()
  var query_580349 = newJObject()
  add(query_580349, "key", newJString(key))
  add(query_580349, "prettyPrint", newJBool(prettyPrint))
  add(query_580349, "oauth_token", newJString(oauthToken))
  add(path_580348, "playerId", newJString(playerId))
  add(query_580349, "alt", newJString(alt))
  add(query_580349, "userIp", newJString(userIp))
  add(query_580349, "quotaUser", newJString(quotaUser))
  add(query_580349, "pageToken", newJString(pageToken))
  add(query_580349, "fields", newJString(fields))
  add(query_580349, "language", newJString(language))
  add(query_580349, "maxResults", newJInt(maxResults))
  result = call_580347.call(path_580348, query_580349, nil, nil, nil)

var gamesSnapshotsList* = Call_GamesSnapshotsList_580332(
    name: "gamesSnapshotsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/players/{playerId}/snapshots",
    validator: validate_GamesSnapshotsList_580333, base: "/games/v1",
    url: url_GamesSnapshotsList_580334, schemes: {Scheme.Https})
type
  Call_GamesPushtokensUpdate_580350 = ref object of OpenApiRestCall_579389
proc url_GamesPushtokensUpdate_580352(protocol: Scheme; host: string; base: string;
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

proc validate_GamesPushtokensUpdate_580351(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers a push token for the current user and application.
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
  var valid_580353 = query.getOrDefault("key")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "key", valid_580353
  var valid_580354 = query.getOrDefault("prettyPrint")
  valid_580354 = validateParameter(valid_580354, JBool, required = false,
                                 default = newJBool(true))
  if valid_580354 != nil:
    section.add "prettyPrint", valid_580354
  var valid_580355 = query.getOrDefault("oauth_token")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "oauth_token", valid_580355
  var valid_580356 = query.getOrDefault("alt")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = newJString("json"))
  if valid_580356 != nil:
    section.add "alt", valid_580356
  var valid_580357 = query.getOrDefault("userIp")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "userIp", valid_580357
  var valid_580358 = query.getOrDefault("quotaUser")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "quotaUser", valid_580358
  var valid_580359 = query.getOrDefault("fields")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "fields", valid_580359
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

proc call*(call_580361: Call_GamesPushtokensUpdate_580350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a push token for the current user and application.
  ## 
  let valid = call_580361.validator(path, query, header, formData, body)
  let scheme = call_580361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580361.url(scheme.get, call_580361.host, call_580361.base,
                         call_580361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580361, url, valid)

proc call*(call_580362: Call_GamesPushtokensUpdate_580350; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## gamesPushtokensUpdate
  ## Registers a push token for the current user and application.
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
  var query_580363 = newJObject()
  var body_580364 = newJObject()
  add(query_580363, "key", newJString(key))
  add(query_580363, "prettyPrint", newJBool(prettyPrint))
  add(query_580363, "oauth_token", newJString(oauthToken))
  add(query_580363, "alt", newJString(alt))
  add(query_580363, "userIp", newJString(userIp))
  add(query_580363, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580364 = body
  add(query_580363, "fields", newJString(fields))
  result = call_580362.call(nil, query_580363, nil, nil, body_580364)

var gamesPushtokensUpdate* = Call_GamesPushtokensUpdate_580350(
    name: "gamesPushtokensUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/pushtokens",
    validator: validate_GamesPushtokensUpdate_580351, base: "/games/v1",
    url: url_GamesPushtokensUpdate_580352, schemes: {Scheme.Https})
type
  Call_GamesPushtokensRemove_580365 = ref object of OpenApiRestCall_579389
proc url_GamesPushtokensRemove_580367(protocol: Scheme; host: string; base: string;
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

proc validate_GamesPushtokensRemove_580366(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a push token for the current user and application. Removing a non-existent push token will report success.
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
  var valid_580368 = query.getOrDefault("key")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "key", valid_580368
  var valid_580369 = query.getOrDefault("prettyPrint")
  valid_580369 = validateParameter(valid_580369, JBool, required = false,
                                 default = newJBool(true))
  if valid_580369 != nil:
    section.add "prettyPrint", valid_580369
  var valid_580370 = query.getOrDefault("oauth_token")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "oauth_token", valid_580370
  var valid_580371 = query.getOrDefault("alt")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = newJString("json"))
  if valid_580371 != nil:
    section.add "alt", valid_580371
  var valid_580372 = query.getOrDefault("userIp")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "userIp", valid_580372
  var valid_580373 = query.getOrDefault("quotaUser")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "quotaUser", valid_580373
  var valid_580374 = query.getOrDefault("fields")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "fields", valid_580374
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

proc call*(call_580376: Call_GamesPushtokensRemove_580365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a push token for the current user and application. Removing a non-existent push token will report success.
  ## 
  let valid = call_580376.validator(path, query, header, formData, body)
  let scheme = call_580376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580376.url(scheme.get, call_580376.host, call_580376.base,
                         call_580376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580376, url, valid)

proc call*(call_580377: Call_GamesPushtokensRemove_580365; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## gamesPushtokensRemove
  ## Removes a push token for the current user and application. Removing a non-existent push token will report success.
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
  var query_580378 = newJObject()
  var body_580379 = newJObject()
  add(query_580378, "key", newJString(key))
  add(query_580378, "prettyPrint", newJBool(prettyPrint))
  add(query_580378, "oauth_token", newJString(oauthToken))
  add(query_580378, "alt", newJString(alt))
  add(query_580378, "userIp", newJString(userIp))
  add(query_580378, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580379 = body
  add(query_580378, "fields", newJString(fields))
  result = call_580377.call(nil, query_580378, nil, nil, body_580379)

var gamesPushtokensRemove* = Call_GamesPushtokensRemove_580365(
    name: "gamesPushtokensRemove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pushtokens/remove",
    validator: validate_GamesPushtokensRemove_580366, base: "/games/v1",
    url: url_GamesPushtokensRemove_580367, schemes: {Scheme.Https})
type
  Call_GamesRevisionsCheck_580380 = ref object of OpenApiRestCall_579389
proc url_GamesRevisionsCheck_580382(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRevisionsCheck_580381(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Checks whether the games client is out of date.
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
  ##   clientRevision: JString (required)
  ##                 : The revision of the client SDK used by your application. Format:
  ## [PLATFORM_TYPE]:[VERSION_NUMBER]. Possible values of PLATFORM_TYPE are:
  ##  
  ## - "ANDROID" - Client is running the Android SDK. 
  ## - "IOS" - Client is running the iOS SDK. 
  ## - "WEB_APP" - Client is running as a Web App.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580383 = query.getOrDefault("key")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "key", valid_580383
  var valid_580384 = query.getOrDefault("prettyPrint")
  valid_580384 = validateParameter(valid_580384, JBool, required = false,
                                 default = newJBool(true))
  if valid_580384 != nil:
    section.add "prettyPrint", valid_580384
  var valid_580385 = query.getOrDefault("oauth_token")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "oauth_token", valid_580385
  assert query != nil,
        "query argument is necessary due to required `clientRevision` field"
  var valid_580386 = query.getOrDefault("clientRevision")
  valid_580386 = validateParameter(valid_580386, JString, required = true,
                                 default = nil)
  if valid_580386 != nil:
    section.add "clientRevision", valid_580386
  var valid_580387 = query.getOrDefault("alt")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = newJString("json"))
  if valid_580387 != nil:
    section.add "alt", valid_580387
  var valid_580388 = query.getOrDefault("userIp")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "userIp", valid_580388
  var valid_580389 = query.getOrDefault("quotaUser")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "quotaUser", valid_580389
  var valid_580390 = query.getOrDefault("fields")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "fields", valid_580390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580391: Call_GamesRevisionsCheck_580380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the games client is out of date.
  ## 
  let valid = call_580391.validator(path, query, header, formData, body)
  let scheme = call_580391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580391.url(scheme.get, call_580391.host, call_580391.base,
                         call_580391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580391, url, valid)

proc call*(call_580392: Call_GamesRevisionsCheck_580380; clientRevision: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesRevisionsCheck
  ## Checks whether the games client is out of date.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   clientRevision: string (required)
  ##                 : The revision of the client SDK used by your application. Format:
  ## [PLATFORM_TYPE]:[VERSION_NUMBER]. Possible values of PLATFORM_TYPE are:
  ##  
  ## - "ANDROID" - Client is running the Android SDK. 
  ## - "IOS" - Client is running the iOS SDK. 
  ## - "WEB_APP" - Client is running as a Web App.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_580393 = newJObject()
  add(query_580393, "key", newJString(key))
  add(query_580393, "prettyPrint", newJBool(prettyPrint))
  add(query_580393, "oauth_token", newJString(oauthToken))
  add(query_580393, "clientRevision", newJString(clientRevision))
  add(query_580393, "alt", newJString(alt))
  add(query_580393, "userIp", newJString(userIp))
  add(query_580393, "quotaUser", newJString(quotaUser))
  add(query_580393, "fields", newJString(fields))
  result = call_580392.call(nil, query_580393, nil, nil, nil)

var gamesRevisionsCheck* = Call_GamesRevisionsCheck_580380(
    name: "gamesRevisionsCheck", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/revisions/check",
    validator: validate_GamesRevisionsCheck_580381, base: "/games/v1",
    url: url_GamesRevisionsCheck_580382, schemes: {Scheme.Https})
type
  Call_GamesRoomsList_580394 = ref object of OpenApiRestCall_579389
proc url_GamesRoomsList_580396(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsList_580395(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns invitations to join rooms.
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
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of rooms to return in the response, used for paging. For any response, the actual number of rooms to return may be less than the specified maxResults.
  section = newJObject()
  var valid_580397 = query.getOrDefault("key")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "key", valid_580397
  var valid_580398 = query.getOrDefault("prettyPrint")
  valid_580398 = validateParameter(valid_580398, JBool, required = false,
                                 default = newJBool(true))
  if valid_580398 != nil:
    section.add "prettyPrint", valid_580398
  var valid_580399 = query.getOrDefault("oauth_token")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "oauth_token", valid_580399
  var valid_580400 = query.getOrDefault("alt")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = newJString("json"))
  if valid_580400 != nil:
    section.add "alt", valid_580400
  var valid_580401 = query.getOrDefault("userIp")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "userIp", valid_580401
  var valid_580402 = query.getOrDefault("quotaUser")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "quotaUser", valid_580402
  var valid_580403 = query.getOrDefault("pageToken")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "pageToken", valid_580403
  var valid_580404 = query.getOrDefault("fields")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "fields", valid_580404
  var valid_580405 = query.getOrDefault("language")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "language", valid_580405
  var valid_580406 = query.getOrDefault("maxResults")
  valid_580406 = validateParameter(valid_580406, JInt, required = false, default = nil)
  if valid_580406 != nil:
    section.add "maxResults", valid_580406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580407: Call_GamesRoomsList_580394; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns invitations to join rooms.
  ## 
  let valid = call_580407.validator(path, query, header, formData, body)
  let scheme = call_580407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580407.url(scheme.get, call_580407.host, call_580407.base,
                         call_580407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580407, url, valid)

proc call*(call_580408: Call_GamesRoomsList_580394; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; language: string = ""; maxResults: int = 0): Recallable =
  ## gamesRoomsList
  ## Returns invitations to join rooms.
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
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of rooms to return in the response, used for paging. For any response, the actual number of rooms to return may be less than the specified maxResults.
  var query_580409 = newJObject()
  add(query_580409, "key", newJString(key))
  add(query_580409, "prettyPrint", newJBool(prettyPrint))
  add(query_580409, "oauth_token", newJString(oauthToken))
  add(query_580409, "alt", newJString(alt))
  add(query_580409, "userIp", newJString(userIp))
  add(query_580409, "quotaUser", newJString(quotaUser))
  add(query_580409, "pageToken", newJString(pageToken))
  add(query_580409, "fields", newJString(fields))
  add(query_580409, "language", newJString(language))
  add(query_580409, "maxResults", newJInt(maxResults))
  result = call_580408.call(nil, query_580409, nil, nil, nil)

var gamesRoomsList* = Call_GamesRoomsList_580394(name: "gamesRoomsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/rooms",
    validator: validate_GamesRoomsList_580395, base: "/games/v1",
    url: url_GamesRoomsList_580396, schemes: {Scheme.Https})
type
  Call_GamesRoomsCreate_580410 = ref object of OpenApiRestCall_579389
proc url_GamesRoomsCreate_580412(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsCreate_580411(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Create a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580413 = query.getOrDefault("key")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "key", valid_580413
  var valid_580414 = query.getOrDefault("prettyPrint")
  valid_580414 = validateParameter(valid_580414, JBool, required = false,
                                 default = newJBool(true))
  if valid_580414 != nil:
    section.add "prettyPrint", valid_580414
  var valid_580415 = query.getOrDefault("oauth_token")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "oauth_token", valid_580415
  var valid_580416 = query.getOrDefault("alt")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = newJString("json"))
  if valid_580416 != nil:
    section.add "alt", valid_580416
  var valid_580417 = query.getOrDefault("userIp")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "userIp", valid_580417
  var valid_580418 = query.getOrDefault("quotaUser")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "quotaUser", valid_580418
  var valid_580419 = query.getOrDefault("fields")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "fields", valid_580419
  var valid_580420 = query.getOrDefault("language")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "language", valid_580420
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

proc call*(call_580422: Call_GamesRoomsCreate_580410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580422.validator(path, query, header, formData, body)
  let scheme = call_580422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580422.url(scheme.get, call_580422.host, call_580422.base,
                         call_580422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580422, url, valid)

proc call*(call_580423: Call_GamesRoomsCreate_580410; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""; language: string = ""): Recallable =
  ## gamesRoomsCreate
  ## Create a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
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
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var query_580424 = newJObject()
  var body_580425 = newJObject()
  add(query_580424, "key", newJString(key))
  add(query_580424, "prettyPrint", newJBool(prettyPrint))
  add(query_580424, "oauth_token", newJString(oauthToken))
  add(query_580424, "alt", newJString(alt))
  add(query_580424, "userIp", newJString(userIp))
  add(query_580424, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580425 = body
  add(query_580424, "fields", newJString(fields))
  add(query_580424, "language", newJString(language))
  result = call_580423.call(nil, query_580424, nil, nil, body_580425)

var gamesRoomsCreate* = Call_GamesRoomsCreate_580410(name: "gamesRoomsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/rooms/create",
    validator: validate_GamesRoomsCreate_580411, base: "/games/v1",
    url: url_GamesRoomsCreate_580412, schemes: {Scheme.Https})
type
  Call_GamesRoomsGet_580426 = ref object of OpenApiRestCall_579389
proc url_GamesRoomsGet_580428(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "roomId" in path, "`roomId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/rooms/"),
               (kind: VariableSegment, value: "roomId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesRoomsGet_580427(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the data for a room.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roomId: JString (required)
  ##         : The ID of the room.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roomId` field"
  var valid_580429 = path.getOrDefault("roomId")
  valid_580429 = validateParameter(valid_580429, JString, required = true,
                                 default = nil)
  if valid_580429 != nil:
    section.add "roomId", valid_580429
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580430 = query.getOrDefault("key")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "key", valid_580430
  var valid_580431 = query.getOrDefault("prettyPrint")
  valid_580431 = validateParameter(valid_580431, JBool, required = false,
                                 default = newJBool(true))
  if valid_580431 != nil:
    section.add "prettyPrint", valid_580431
  var valid_580432 = query.getOrDefault("oauth_token")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "oauth_token", valid_580432
  var valid_580433 = query.getOrDefault("alt")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = newJString("json"))
  if valid_580433 != nil:
    section.add "alt", valid_580433
  var valid_580434 = query.getOrDefault("userIp")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "userIp", valid_580434
  var valid_580435 = query.getOrDefault("quotaUser")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "quotaUser", valid_580435
  var valid_580436 = query.getOrDefault("fields")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "fields", valid_580436
  var valid_580437 = query.getOrDefault("language")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "language", valid_580437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580438: Call_GamesRoomsGet_580426; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the data for a room.
  ## 
  let valid = call_580438.validator(path, query, header, formData, body)
  let scheme = call_580438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580438.url(scheme.get, call_580438.host, call_580438.base,
                         call_580438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580438, url, valid)

proc call*(call_580439: Call_GamesRoomsGet_580426; roomId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = "";
          language: string = ""): Recallable =
  ## gamesRoomsGet
  ## Get the data for a room.
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
  ##   roomId: string (required)
  ##         : The ID of the room.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580440 = newJObject()
  var query_580441 = newJObject()
  add(query_580441, "key", newJString(key))
  add(query_580441, "prettyPrint", newJBool(prettyPrint))
  add(query_580441, "oauth_token", newJString(oauthToken))
  add(query_580441, "alt", newJString(alt))
  add(query_580441, "userIp", newJString(userIp))
  add(query_580441, "quotaUser", newJString(quotaUser))
  add(path_580440, "roomId", newJString(roomId))
  add(query_580441, "fields", newJString(fields))
  add(query_580441, "language", newJString(language))
  result = call_580439.call(path_580440, query_580441, nil, nil, nil)

var gamesRoomsGet* = Call_GamesRoomsGet_580426(name: "gamesRoomsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/rooms/{roomId}",
    validator: validate_GamesRoomsGet_580427, base: "/games/v1",
    url: url_GamesRoomsGet_580428, schemes: {Scheme.Https})
type
  Call_GamesRoomsDecline_580442 = ref object of OpenApiRestCall_579389
proc url_GamesRoomsDecline_580444(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "roomId" in path, "`roomId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/rooms/"),
               (kind: VariableSegment, value: "roomId"),
               (kind: ConstantSegment, value: "/decline")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesRoomsDecline_580443(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Decline an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roomId: JString (required)
  ##         : The ID of the room.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roomId` field"
  var valid_580445 = path.getOrDefault("roomId")
  valid_580445 = validateParameter(valid_580445, JString, required = true,
                                 default = nil)
  if valid_580445 != nil:
    section.add "roomId", valid_580445
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
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
  var valid_580448 = query.getOrDefault("oauth_token")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "oauth_token", valid_580448
  var valid_580449 = query.getOrDefault("alt")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = newJString("json"))
  if valid_580449 != nil:
    section.add "alt", valid_580449
  var valid_580450 = query.getOrDefault("userIp")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "userIp", valid_580450
  var valid_580451 = query.getOrDefault("quotaUser")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "quotaUser", valid_580451
  var valid_580452 = query.getOrDefault("fields")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "fields", valid_580452
  var valid_580453 = query.getOrDefault("language")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "language", valid_580453
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580454: Call_GamesRoomsDecline_580442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decline an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580454.validator(path, query, header, formData, body)
  let scheme = call_580454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580454.url(scheme.get, call_580454.host, call_580454.base,
                         call_580454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580454, url, valid)

proc call*(call_580455: Call_GamesRoomsDecline_580442; roomId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; language: string = ""): Recallable =
  ## gamesRoomsDecline
  ## Decline an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
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
  ##   roomId: string (required)
  ##         : The ID of the room.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580456 = newJObject()
  var query_580457 = newJObject()
  add(query_580457, "key", newJString(key))
  add(query_580457, "prettyPrint", newJBool(prettyPrint))
  add(query_580457, "oauth_token", newJString(oauthToken))
  add(query_580457, "alt", newJString(alt))
  add(query_580457, "userIp", newJString(userIp))
  add(query_580457, "quotaUser", newJString(quotaUser))
  add(path_580456, "roomId", newJString(roomId))
  add(query_580457, "fields", newJString(fields))
  add(query_580457, "language", newJString(language))
  result = call_580455.call(path_580456, query_580457, nil, nil, nil)

var gamesRoomsDecline* = Call_GamesRoomsDecline_580442(name: "gamesRoomsDecline",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/decline", validator: validate_GamesRoomsDecline_580443,
    base: "/games/v1", url: url_GamesRoomsDecline_580444, schemes: {Scheme.Https})
type
  Call_GamesRoomsDismiss_580458 = ref object of OpenApiRestCall_579389
proc url_GamesRoomsDismiss_580460(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "roomId" in path, "`roomId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/rooms/"),
               (kind: VariableSegment, value: "roomId"),
               (kind: ConstantSegment, value: "/dismiss")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesRoomsDismiss_580459(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Dismiss an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roomId: JString (required)
  ##         : The ID of the room.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roomId` field"
  var valid_580461 = path.getOrDefault("roomId")
  valid_580461 = validateParameter(valid_580461, JString, required = true,
                                 default = nil)
  if valid_580461 != nil:
    section.add "roomId", valid_580461
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
  var valid_580462 = query.getOrDefault("key")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "key", valid_580462
  var valid_580463 = query.getOrDefault("prettyPrint")
  valid_580463 = validateParameter(valid_580463, JBool, required = false,
                                 default = newJBool(true))
  if valid_580463 != nil:
    section.add "prettyPrint", valid_580463
  var valid_580464 = query.getOrDefault("oauth_token")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "oauth_token", valid_580464
  var valid_580465 = query.getOrDefault("alt")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = newJString("json"))
  if valid_580465 != nil:
    section.add "alt", valid_580465
  var valid_580466 = query.getOrDefault("userIp")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "userIp", valid_580466
  var valid_580467 = query.getOrDefault("quotaUser")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "quotaUser", valid_580467
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
  if body != nil:
    result.add "body", body

proc call*(call_580469: Call_GamesRoomsDismiss_580458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580469.validator(path, query, header, formData, body)
  let scheme = call_580469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580469.url(scheme.get, call_580469.host, call_580469.base,
                         call_580469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580469, url, valid)

proc call*(call_580470: Call_GamesRoomsDismiss_580458; roomId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesRoomsDismiss
  ## Dismiss an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
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
  ##   roomId: string (required)
  ##         : The ID of the room.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580471 = newJObject()
  var query_580472 = newJObject()
  add(query_580472, "key", newJString(key))
  add(query_580472, "prettyPrint", newJBool(prettyPrint))
  add(query_580472, "oauth_token", newJString(oauthToken))
  add(query_580472, "alt", newJString(alt))
  add(query_580472, "userIp", newJString(userIp))
  add(query_580472, "quotaUser", newJString(quotaUser))
  add(path_580471, "roomId", newJString(roomId))
  add(query_580472, "fields", newJString(fields))
  result = call_580470.call(path_580471, query_580472, nil, nil, nil)

var gamesRoomsDismiss* = Call_GamesRoomsDismiss_580458(name: "gamesRoomsDismiss",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/dismiss", validator: validate_GamesRoomsDismiss_580459,
    base: "/games/v1", url: url_GamesRoomsDismiss_580460, schemes: {Scheme.Https})
type
  Call_GamesRoomsJoin_580473 = ref object of OpenApiRestCall_579389
proc url_GamesRoomsJoin_580475(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "roomId" in path, "`roomId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/rooms/"),
               (kind: VariableSegment, value: "roomId"),
               (kind: ConstantSegment, value: "/join")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesRoomsJoin_580474(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roomId: JString (required)
  ##         : The ID of the room.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roomId` field"
  var valid_580476 = path.getOrDefault("roomId")
  valid_580476 = validateParameter(valid_580476, JString, required = true,
                                 default = nil)
  if valid_580476 != nil:
    section.add "roomId", valid_580476
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
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
  var valid_580483 = query.getOrDefault("fields")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "fields", valid_580483
  var valid_580484 = query.getOrDefault("language")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "language", valid_580484
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

proc call*(call_580486: Call_GamesRoomsJoin_580473; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580486.validator(path, query, header, formData, body)
  let scheme = call_580486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580486.url(scheme.get, call_580486.host, call_580486.base,
                         call_580486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580486, url, valid)

proc call*(call_580487: Call_GamesRoomsJoin_580473; roomId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""; language: string = ""): Recallable =
  ## gamesRoomsJoin
  ## Join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
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
  ##   roomId: string (required)
  ##         : The ID of the room.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580488 = newJObject()
  var query_580489 = newJObject()
  var body_580490 = newJObject()
  add(query_580489, "key", newJString(key))
  add(query_580489, "prettyPrint", newJBool(prettyPrint))
  add(query_580489, "oauth_token", newJString(oauthToken))
  add(query_580489, "alt", newJString(alt))
  add(query_580489, "userIp", newJString(userIp))
  add(query_580489, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580490 = body
  add(path_580488, "roomId", newJString(roomId))
  add(query_580489, "fields", newJString(fields))
  add(query_580489, "language", newJString(language))
  result = call_580487.call(path_580488, query_580489, nil, nil, body_580490)

var gamesRoomsJoin* = Call_GamesRoomsJoin_580473(name: "gamesRoomsJoin",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/join", validator: validate_GamesRoomsJoin_580474,
    base: "/games/v1", url: url_GamesRoomsJoin_580475, schemes: {Scheme.Https})
type
  Call_GamesRoomsLeave_580491 = ref object of OpenApiRestCall_579389
proc url_GamesRoomsLeave_580493(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "roomId" in path, "`roomId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/rooms/"),
               (kind: VariableSegment, value: "roomId"),
               (kind: ConstantSegment, value: "/leave")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesRoomsLeave_580492(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Leave a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roomId: JString (required)
  ##         : The ID of the room.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roomId` field"
  var valid_580494 = path.getOrDefault("roomId")
  valid_580494 = validateParameter(valid_580494, JString, required = true,
                                 default = nil)
  if valid_580494 != nil:
    section.add "roomId", valid_580494
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580495 = query.getOrDefault("key")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "key", valid_580495
  var valid_580496 = query.getOrDefault("prettyPrint")
  valid_580496 = validateParameter(valid_580496, JBool, required = false,
                                 default = newJBool(true))
  if valid_580496 != nil:
    section.add "prettyPrint", valid_580496
  var valid_580497 = query.getOrDefault("oauth_token")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "oauth_token", valid_580497
  var valid_580498 = query.getOrDefault("alt")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = newJString("json"))
  if valid_580498 != nil:
    section.add "alt", valid_580498
  var valid_580499 = query.getOrDefault("userIp")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "userIp", valid_580499
  var valid_580500 = query.getOrDefault("quotaUser")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "quotaUser", valid_580500
  var valid_580501 = query.getOrDefault("fields")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "fields", valid_580501
  var valid_580502 = query.getOrDefault("language")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "language", valid_580502
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

proc call*(call_580504: Call_GamesRoomsLeave_580491; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580504.validator(path, query, header, formData, body)
  let scheme = call_580504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580504.url(scheme.get, call_580504.host, call_580504.base,
                         call_580504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580504, url, valid)

proc call*(call_580505: Call_GamesRoomsLeave_580491; roomId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""; language: string = ""): Recallable =
  ## gamesRoomsLeave
  ## Leave a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
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
  ##   roomId: string (required)
  ##         : The ID of the room.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580506 = newJObject()
  var query_580507 = newJObject()
  var body_580508 = newJObject()
  add(query_580507, "key", newJString(key))
  add(query_580507, "prettyPrint", newJBool(prettyPrint))
  add(query_580507, "oauth_token", newJString(oauthToken))
  add(query_580507, "alt", newJString(alt))
  add(query_580507, "userIp", newJString(userIp))
  add(query_580507, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580508 = body
  add(path_580506, "roomId", newJString(roomId))
  add(query_580507, "fields", newJString(fields))
  add(query_580507, "language", newJString(language))
  result = call_580505.call(path_580506, query_580507, nil, nil, body_580508)

var gamesRoomsLeave* = Call_GamesRoomsLeave_580491(name: "gamesRoomsLeave",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/leave", validator: validate_GamesRoomsLeave_580492,
    base: "/games/v1", url: url_GamesRoomsLeave_580493, schemes: {Scheme.Https})
type
  Call_GamesRoomsReportStatus_580509 = ref object of OpenApiRestCall_579389
proc url_GamesRoomsReportStatus_580511(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "roomId" in path, "`roomId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/rooms/"),
               (kind: VariableSegment, value: "roomId"),
               (kind: ConstantSegment, value: "/reportstatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesRoomsReportStatus_580510(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates sent by a client reporting the status of peers in a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roomId: JString (required)
  ##         : The ID of the room.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roomId` field"
  var valid_580512 = path.getOrDefault("roomId")
  valid_580512 = validateParameter(valid_580512, JString, required = true,
                                 default = nil)
  if valid_580512 != nil:
    section.add "roomId", valid_580512
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580513 = query.getOrDefault("key")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "key", valid_580513
  var valid_580514 = query.getOrDefault("prettyPrint")
  valid_580514 = validateParameter(valid_580514, JBool, required = false,
                                 default = newJBool(true))
  if valid_580514 != nil:
    section.add "prettyPrint", valid_580514
  var valid_580515 = query.getOrDefault("oauth_token")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "oauth_token", valid_580515
  var valid_580516 = query.getOrDefault("alt")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = newJString("json"))
  if valid_580516 != nil:
    section.add "alt", valid_580516
  var valid_580517 = query.getOrDefault("userIp")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "userIp", valid_580517
  var valid_580518 = query.getOrDefault("quotaUser")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "quotaUser", valid_580518
  var valid_580519 = query.getOrDefault("fields")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "fields", valid_580519
  var valid_580520 = query.getOrDefault("language")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "language", valid_580520
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

proc call*(call_580522: Call_GamesRoomsReportStatus_580509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates sent by a client reporting the status of peers in a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580522.validator(path, query, header, formData, body)
  let scheme = call_580522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580522.url(scheme.get, call_580522.host, call_580522.base,
                         call_580522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580522, url, valid)

proc call*(call_580523: Call_GamesRoomsReportStatus_580509; roomId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""; language: string = ""): Recallable =
  ## gamesRoomsReportStatus
  ## Updates sent by a client reporting the status of peers in a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
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
  ##   roomId: string (required)
  ##         : The ID of the room.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580524 = newJObject()
  var query_580525 = newJObject()
  var body_580526 = newJObject()
  add(query_580525, "key", newJString(key))
  add(query_580525, "prettyPrint", newJBool(prettyPrint))
  add(query_580525, "oauth_token", newJString(oauthToken))
  add(query_580525, "alt", newJString(alt))
  add(query_580525, "userIp", newJString(userIp))
  add(query_580525, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580526 = body
  add(path_580524, "roomId", newJString(roomId))
  add(query_580525, "fields", newJString(fields))
  add(query_580525, "language", newJString(language))
  result = call_580523.call(path_580524, query_580525, nil, nil, body_580526)

var gamesRoomsReportStatus* = Call_GamesRoomsReportStatus_580509(
    name: "gamesRoomsReportStatus", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/{roomId}/reportstatus",
    validator: validate_GamesRoomsReportStatus_580510, base: "/games/v1",
    url: url_GamesRoomsReportStatus_580511, schemes: {Scheme.Https})
type
  Call_GamesSnapshotsGet_580527 = ref object of OpenApiRestCall_579389
proc url_GamesSnapshotsGet_580529(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshotId" in path, "`snapshotId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesSnapshotsGet_580528(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves the metadata for a given snapshot ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshotId: JString (required)
  ##             : The ID of the snapshot.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `snapshotId` field"
  var valid_580530 = path.getOrDefault("snapshotId")
  valid_580530 = validateParameter(valid_580530, JString, required = true,
                                 default = nil)
  if valid_580530 != nil:
    section.add "snapshotId", valid_580530
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580531 = query.getOrDefault("key")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "key", valid_580531
  var valid_580532 = query.getOrDefault("prettyPrint")
  valid_580532 = validateParameter(valid_580532, JBool, required = false,
                                 default = newJBool(true))
  if valid_580532 != nil:
    section.add "prettyPrint", valid_580532
  var valid_580533 = query.getOrDefault("oauth_token")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "oauth_token", valid_580533
  var valid_580534 = query.getOrDefault("alt")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = newJString("json"))
  if valid_580534 != nil:
    section.add "alt", valid_580534
  var valid_580535 = query.getOrDefault("userIp")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "userIp", valid_580535
  var valid_580536 = query.getOrDefault("quotaUser")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "quotaUser", valid_580536
  var valid_580537 = query.getOrDefault("fields")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "fields", valid_580537
  var valid_580538 = query.getOrDefault("language")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "language", valid_580538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580539: Call_GamesSnapshotsGet_580527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata for a given snapshot ID.
  ## 
  let valid = call_580539.validator(path, query, header, formData, body)
  let scheme = call_580539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580539.url(scheme.get, call_580539.host, call_580539.base,
                         call_580539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580539, url, valid)

proc call*(call_580540: Call_GamesSnapshotsGet_580527; snapshotId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; language: string = ""): Recallable =
  ## gamesSnapshotsGet
  ## Retrieves the metadata for a given snapshot ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   snapshotId: string (required)
  ##             : The ID of the snapshot.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580541 = newJObject()
  var query_580542 = newJObject()
  add(query_580542, "key", newJString(key))
  add(query_580542, "prettyPrint", newJBool(prettyPrint))
  add(query_580542, "oauth_token", newJString(oauthToken))
  add(path_580541, "snapshotId", newJString(snapshotId))
  add(query_580542, "alt", newJString(alt))
  add(query_580542, "userIp", newJString(userIp))
  add(query_580542, "quotaUser", newJString(quotaUser))
  add(query_580542, "fields", newJString(fields))
  add(query_580542, "language", newJString(language))
  result = call_580540.call(path_580541, query_580542, nil, nil, nil)

var gamesSnapshotsGet* = Call_GamesSnapshotsGet_580527(name: "gamesSnapshotsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/snapshots/{snapshotId}", validator: validate_GamesSnapshotsGet_580528,
    base: "/games/v1", url: url_GamesSnapshotsGet_580529, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesList_580543 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesList_580545(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesList_580544(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns turn-based matches the player is or was involved in.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxCompletedMatches: JInt
  ##                      : The maximum number of completed or canceled matches to return in the response. If not set, all matches returned could be completed or canceled.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeMatchData: JBool
  ##                   : True if match data should be returned in the response. Note that not all data will necessarily be returned if include_match_data is true; the server may decide to only return data for some of the matches to limit download size for the client. The remainder of the data for these matches will be retrievable on request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of matches to return in the response, used for paging. For any response, the actual number of matches to return may be less than the specified maxResults.
  section = newJObject()
  var valid_580546 = query.getOrDefault("key")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "key", valid_580546
  var valid_580547 = query.getOrDefault("maxCompletedMatches")
  valid_580547 = validateParameter(valid_580547, JInt, required = false, default = nil)
  if valid_580547 != nil:
    section.add "maxCompletedMatches", valid_580547
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
  var valid_580550 = query.getOrDefault("includeMatchData")
  valid_580550 = validateParameter(valid_580550, JBool, required = false, default = nil)
  if valid_580550 != nil:
    section.add "includeMatchData", valid_580550
  var valid_580551 = query.getOrDefault("alt")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = newJString("json"))
  if valid_580551 != nil:
    section.add "alt", valid_580551
  var valid_580552 = query.getOrDefault("userIp")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "userIp", valid_580552
  var valid_580553 = query.getOrDefault("quotaUser")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "quotaUser", valid_580553
  var valid_580554 = query.getOrDefault("pageToken")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "pageToken", valid_580554
  var valid_580555 = query.getOrDefault("fields")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "fields", valid_580555
  var valid_580556 = query.getOrDefault("language")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "language", valid_580556
  var valid_580557 = query.getOrDefault("maxResults")
  valid_580557 = validateParameter(valid_580557, JInt, required = false, default = nil)
  if valid_580557 != nil:
    section.add "maxResults", valid_580557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580558: Call_GamesTurnBasedMatchesList_580543; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns turn-based matches the player is or was involved in.
  ## 
  let valid = call_580558.validator(path, query, header, formData, body)
  let scheme = call_580558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580558.url(scheme.get, call_580558.host, call_580558.base,
                         call_580558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580558, url, valid)

proc call*(call_580559: Call_GamesTurnBasedMatchesList_580543; key: string = "";
          maxCompletedMatches: int = 0; prettyPrint: bool = true;
          oauthToken: string = ""; includeMatchData: bool = false; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; language: string = ""; maxResults: int = 0): Recallable =
  ## gamesTurnBasedMatchesList
  ## Returns turn-based matches the player is or was involved in.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxCompletedMatches: int
  ##                      : The maximum number of completed or canceled matches to return in the response. If not set, all matches returned could be completed or canceled.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeMatchData: bool
  ##                   : True if match data should be returned in the response. Note that not all data will necessarily be returned if include_match_data is true; the server may decide to only return data for some of the matches to limit download size for the client. The remainder of the data for these matches will be retrievable on request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of matches to return in the response, used for paging. For any response, the actual number of matches to return may be less than the specified maxResults.
  var query_580560 = newJObject()
  add(query_580560, "key", newJString(key))
  add(query_580560, "maxCompletedMatches", newJInt(maxCompletedMatches))
  add(query_580560, "prettyPrint", newJBool(prettyPrint))
  add(query_580560, "oauth_token", newJString(oauthToken))
  add(query_580560, "includeMatchData", newJBool(includeMatchData))
  add(query_580560, "alt", newJString(alt))
  add(query_580560, "userIp", newJString(userIp))
  add(query_580560, "quotaUser", newJString(quotaUser))
  add(query_580560, "pageToken", newJString(pageToken))
  add(query_580560, "fields", newJString(fields))
  add(query_580560, "language", newJString(language))
  add(query_580560, "maxResults", newJInt(maxResults))
  result = call_580559.call(nil, query_580560, nil, nil, nil)

var gamesTurnBasedMatchesList* = Call_GamesTurnBasedMatchesList_580543(
    name: "gamesTurnBasedMatchesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches",
    validator: validate_GamesTurnBasedMatchesList_580544, base: "/games/v1",
    url: url_GamesTurnBasedMatchesList_580545, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesCreate_580561 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesCreate_580563(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesCreate_580562(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a turn-based match.
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
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
  var valid_580570 = query.getOrDefault("fields")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "fields", valid_580570
  var valid_580571 = query.getOrDefault("language")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "language", valid_580571
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

proc call*(call_580573: Call_GamesTurnBasedMatchesCreate_580561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a turn-based match.
  ## 
  let valid = call_580573.validator(path, query, header, formData, body)
  let scheme = call_580573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580573.url(scheme.get, call_580573.host, call_580573.base,
                         call_580573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580573, url, valid)

proc call*(call_580574: Call_GamesTurnBasedMatchesCreate_580561; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""; language: string = ""): Recallable =
  ## gamesTurnBasedMatchesCreate
  ## Create a turn-based match.
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
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var query_580575 = newJObject()
  var body_580576 = newJObject()
  add(query_580575, "key", newJString(key))
  add(query_580575, "prettyPrint", newJBool(prettyPrint))
  add(query_580575, "oauth_token", newJString(oauthToken))
  add(query_580575, "alt", newJString(alt))
  add(query_580575, "userIp", newJString(userIp))
  add(query_580575, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580576 = body
  add(query_580575, "fields", newJString(fields))
  add(query_580575, "language", newJString(language))
  result = call_580574.call(nil, query_580575, nil, nil, body_580576)

var gamesTurnBasedMatchesCreate* = Call_GamesTurnBasedMatchesCreate_580561(
    name: "gamesTurnBasedMatchesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/create",
    validator: validate_GamesTurnBasedMatchesCreate_580562, base: "/games/v1",
    url: url_GamesTurnBasedMatchesCreate_580563, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesSync_580577 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesSync_580579(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesSync_580578(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns turn-based matches the player is or was involved in that changed since the last sync call, with the least recent changes coming first. Matches that should be removed from the local cache will have a status of MATCH_DELETED.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxCompletedMatches: JInt
  ##                      : The maximum number of completed or canceled matches to return in the response. If not set, all matches returned could be completed or canceled.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeMatchData: JBool
  ##                   : True if match data should be returned in the response. Note that not all data will necessarily be returned if include_match_data is true; the server may decide to only return data for some of the matches to limit download size for the client. The remainder of the data for these matches will be retrievable on request.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: JInt
  ##             : The maximum number of matches to return in the response, used for paging. For any response, the actual number of matches to return may be less than the specified maxResults.
  section = newJObject()
  var valid_580580 = query.getOrDefault("key")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "key", valid_580580
  var valid_580581 = query.getOrDefault("maxCompletedMatches")
  valid_580581 = validateParameter(valid_580581, JInt, required = false, default = nil)
  if valid_580581 != nil:
    section.add "maxCompletedMatches", valid_580581
  var valid_580582 = query.getOrDefault("prettyPrint")
  valid_580582 = validateParameter(valid_580582, JBool, required = false,
                                 default = newJBool(true))
  if valid_580582 != nil:
    section.add "prettyPrint", valid_580582
  var valid_580583 = query.getOrDefault("oauth_token")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "oauth_token", valid_580583
  var valid_580584 = query.getOrDefault("includeMatchData")
  valid_580584 = validateParameter(valid_580584, JBool, required = false, default = nil)
  if valid_580584 != nil:
    section.add "includeMatchData", valid_580584
  var valid_580585 = query.getOrDefault("alt")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = newJString("json"))
  if valid_580585 != nil:
    section.add "alt", valid_580585
  var valid_580586 = query.getOrDefault("userIp")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "userIp", valid_580586
  var valid_580587 = query.getOrDefault("quotaUser")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "quotaUser", valid_580587
  var valid_580588 = query.getOrDefault("pageToken")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "pageToken", valid_580588
  var valid_580589 = query.getOrDefault("fields")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "fields", valid_580589
  var valid_580590 = query.getOrDefault("language")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "language", valid_580590
  var valid_580591 = query.getOrDefault("maxResults")
  valid_580591 = validateParameter(valid_580591, JInt, required = false, default = nil)
  if valid_580591 != nil:
    section.add "maxResults", valid_580591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580592: Call_GamesTurnBasedMatchesSync_580577; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns turn-based matches the player is or was involved in that changed since the last sync call, with the least recent changes coming first. Matches that should be removed from the local cache will have a status of MATCH_DELETED.
  ## 
  let valid = call_580592.validator(path, query, header, formData, body)
  let scheme = call_580592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580592.url(scheme.get, call_580592.host, call_580592.base,
                         call_580592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580592, url, valid)

proc call*(call_580593: Call_GamesTurnBasedMatchesSync_580577; key: string = "";
          maxCompletedMatches: int = 0; prettyPrint: bool = true;
          oauthToken: string = ""; includeMatchData: bool = false; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; language: string = ""; maxResults: int = 0): Recallable =
  ## gamesTurnBasedMatchesSync
  ## Returns turn-based matches the player is or was involved in that changed since the last sync call, with the least recent changes coming first. Matches that should be removed from the local cache will have a status of MATCH_DELETED.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxCompletedMatches: int
  ##                      : The maximum number of completed or canceled matches to return in the response. If not set, all matches returned could be completed or canceled.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeMatchData: bool
  ##                   : True if match data should be returned in the response. Note that not all data will necessarily be returned if include_match_data is true; the server may decide to only return data for some of the matches to limit download size for the client. The remainder of the data for these matches will be retrievable on request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   maxResults: int
  ##             : The maximum number of matches to return in the response, used for paging. For any response, the actual number of matches to return may be less than the specified maxResults.
  var query_580594 = newJObject()
  add(query_580594, "key", newJString(key))
  add(query_580594, "maxCompletedMatches", newJInt(maxCompletedMatches))
  add(query_580594, "prettyPrint", newJBool(prettyPrint))
  add(query_580594, "oauth_token", newJString(oauthToken))
  add(query_580594, "includeMatchData", newJBool(includeMatchData))
  add(query_580594, "alt", newJString(alt))
  add(query_580594, "userIp", newJString(userIp))
  add(query_580594, "quotaUser", newJString(quotaUser))
  add(query_580594, "pageToken", newJString(pageToken))
  add(query_580594, "fields", newJString(fields))
  add(query_580594, "language", newJString(language))
  add(query_580594, "maxResults", newJInt(maxResults))
  result = call_580593.call(nil, query_580594, nil, nil, nil)

var gamesTurnBasedMatchesSync* = Call_GamesTurnBasedMatchesSync_580577(
    name: "gamesTurnBasedMatchesSync", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches/sync",
    validator: validate_GamesTurnBasedMatchesSync_580578, base: "/games/v1",
    url: url_GamesTurnBasedMatchesSync_580579, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesGet_580595 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesGet_580597(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matchId" in path, "`matchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/turnbasedmatches/"),
               (kind: VariableSegment, value: "matchId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesGet_580596(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the data for a turn-based match.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matchId: JString (required)
  ##          : The ID of the match.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matchId` field"
  var valid_580598 = path.getOrDefault("matchId")
  valid_580598 = validateParameter(valid_580598, JString, required = true,
                                 default = nil)
  if valid_580598 != nil:
    section.add "matchId", valid_580598
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeMatchData: JBool
  ##                   : Get match data along with metadata.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
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
  var valid_580602 = query.getOrDefault("includeMatchData")
  valid_580602 = validateParameter(valid_580602, JBool, required = false, default = nil)
  if valid_580602 != nil:
    section.add "includeMatchData", valid_580602
  var valid_580603 = query.getOrDefault("alt")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = newJString("json"))
  if valid_580603 != nil:
    section.add "alt", valid_580603
  var valid_580604 = query.getOrDefault("userIp")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "userIp", valid_580604
  var valid_580605 = query.getOrDefault("quotaUser")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "quotaUser", valid_580605
  var valid_580606 = query.getOrDefault("fields")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "fields", valid_580606
  var valid_580607 = query.getOrDefault("language")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "language", valid_580607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580608: Call_GamesTurnBasedMatchesGet_580595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the data for a turn-based match.
  ## 
  let valid = call_580608.validator(path, query, header, formData, body)
  let scheme = call_580608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580608.url(scheme.get, call_580608.host, call_580608.base,
                         call_580608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580608, url, valid)

proc call*(call_580609: Call_GamesTurnBasedMatchesGet_580595; matchId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          includeMatchData: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""; language: string = ""): Recallable =
  ## gamesTurnBasedMatchesGet
  ## Get the data for a turn-based match.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeMatchData: bool
  ##                   : Get match data along with metadata.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580610 = newJObject()
  var query_580611 = newJObject()
  add(query_580611, "key", newJString(key))
  add(query_580611, "prettyPrint", newJBool(prettyPrint))
  add(query_580611, "oauth_token", newJString(oauthToken))
  add(query_580611, "includeMatchData", newJBool(includeMatchData))
  add(query_580611, "alt", newJString(alt))
  add(query_580611, "userIp", newJString(userIp))
  add(query_580611, "quotaUser", newJString(quotaUser))
  add(query_580611, "fields", newJString(fields))
  add(path_580610, "matchId", newJString(matchId))
  add(query_580611, "language", newJString(language))
  result = call_580609.call(path_580610, query_580611, nil, nil, nil)

var gamesTurnBasedMatchesGet* = Call_GamesTurnBasedMatchesGet_580595(
    name: "gamesTurnBasedMatchesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}",
    validator: validate_GamesTurnBasedMatchesGet_580596, base: "/games/v1",
    url: url_GamesTurnBasedMatchesGet_580597, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesCancel_580612 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesCancel_580614(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matchId" in path, "`matchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/turnbasedmatches/"),
               (kind: VariableSegment, value: "matchId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesCancel_580613(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancel a turn-based match.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matchId: JString (required)
  ##          : The ID of the match.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matchId` field"
  var valid_580615 = path.getOrDefault("matchId")
  valid_580615 = validateParameter(valid_580615, JString, required = true,
                                 default = nil)
  if valid_580615 != nil:
    section.add "matchId", valid_580615
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
  var valid_580616 = query.getOrDefault("key")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = nil)
  if valid_580616 != nil:
    section.add "key", valid_580616
  var valid_580617 = query.getOrDefault("prettyPrint")
  valid_580617 = validateParameter(valid_580617, JBool, required = false,
                                 default = newJBool(true))
  if valid_580617 != nil:
    section.add "prettyPrint", valid_580617
  var valid_580618 = query.getOrDefault("oauth_token")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "oauth_token", valid_580618
  var valid_580619 = query.getOrDefault("alt")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = newJString("json"))
  if valid_580619 != nil:
    section.add "alt", valid_580619
  var valid_580620 = query.getOrDefault("userIp")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = nil)
  if valid_580620 != nil:
    section.add "userIp", valid_580620
  var valid_580621 = query.getOrDefault("quotaUser")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = nil)
  if valid_580621 != nil:
    section.add "quotaUser", valid_580621
  var valid_580622 = query.getOrDefault("fields")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "fields", valid_580622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580623: Call_GamesTurnBasedMatchesCancel_580612; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a turn-based match.
  ## 
  let valid = call_580623.validator(path, query, header, formData, body)
  let scheme = call_580623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580623.url(scheme.get, call_580623.host, call_580623.base,
                         call_580623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580623, url, valid)

proc call*(call_580624: Call_GamesTurnBasedMatchesCancel_580612; matchId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesTurnBasedMatchesCancel
  ## Cancel a turn-based match.
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
  ##   matchId: string (required)
  ##          : The ID of the match.
  var path_580625 = newJObject()
  var query_580626 = newJObject()
  add(query_580626, "key", newJString(key))
  add(query_580626, "prettyPrint", newJBool(prettyPrint))
  add(query_580626, "oauth_token", newJString(oauthToken))
  add(query_580626, "alt", newJString(alt))
  add(query_580626, "userIp", newJString(userIp))
  add(query_580626, "quotaUser", newJString(quotaUser))
  add(query_580626, "fields", newJString(fields))
  add(path_580625, "matchId", newJString(matchId))
  result = call_580624.call(path_580625, query_580626, nil, nil, nil)

var gamesTurnBasedMatchesCancel* = Call_GamesTurnBasedMatchesCancel_580612(
    name: "gamesTurnBasedMatchesCancel", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/cancel",
    validator: validate_GamesTurnBasedMatchesCancel_580613, base: "/games/v1",
    url: url_GamesTurnBasedMatchesCancel_580614, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesDecline_580627 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesDecline_580629(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matchId" in path, "`matchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/turnbasedmatches/"),
               (kind: VariableSegment, value: "matchId"),
               (kind: ConstantSegment, value: "/decline")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesDecline_580628(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Decline an invitation to play a turn-based match.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matchId: JString (required)
  ##          : The ID of the match.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matchId` field"
  var valid_580630 = path.getOrDefault("matchId")
  valid_580630 = validateParameter(valid_580630, JString, required = true,
                                 default = nil)
  if valid_580630 != nil:
    section.add "matchId", valid_580630
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580631 = query.getOrDefault("key")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "key", valid_580631
  var valid_580632 = query.getOrDefault("prettyPrint")
  valid_580632 = validateParameter(valid_580632, JBool, required = false,
                                 default = newJBool(true))
  if valid_580632 != nil:
    section.add "prettyPrint", valid_580632
  var valid_580633 = query.getOrDefault("oauth_token")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "oauth_token", valid_580633
  var valid_580634 = query.getOrDefault("alt")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = newJString("json"))
  if valid_580634 != nil:
    section.add "alt", valid_580634
  var valid_580635 = query.getOrDefault("userIp")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "userIp", valid_580635
  var valid_580636 = query.getOrDefault("quotaUser")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "quotaUser", valid_580636
  var valid_580637 = query.getOrDefault("fields")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "fields", valid_580637
  var valid_580638 = query.getOrDefault("language")
  valid_580638 = validateParameter(valid_580638, JString, required = false,
                                 default = nil)
  if valid_580638 != nil:
    section.add "language", valid_580638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580639: Call_GamesTurnBasedMatchesDecline_580627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decline an invitation to play a turn-based match.
  ## 
  let valid = call_580639.validator(path, query, header, formData, body)
  let scheme = call_580639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580639.url(scheme.get, call_580639.host, call_580639.base,
                         call_580639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580639, url, valid)

proc call*(call_580640: Call_GamesTurnBasedMatchesDecline_580627; matchId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; language: string = ""): Recallable =
  ## gamesTurnBasedMatchesDecline
  ## Decline an invitation to play a turn-based match.
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
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580641 = newJObject()
  var query_580642 = newJObject()
  add(query_580642, "key", newJString(key))
  add(query_580642, "prettyPrint", newJBool(prettyPrint))
  add(query_580642, "oauth_token", newJString(oauthToken))
  add(query_580642, "alt", newJString(alt))
  add(query_580642, "userIp", newJString(userIp))
  add(query_580642, "quotaUser", newJString(quotaUser))
  add(query_580642, "fields", newJString(fields))
  add(path_580641, "matchId", newJString(matchId))
  add(query_580642, "language", newJString(language))
  result = call_580640.call(path_580641, query_580642, nil, nil, nil)

var gamesTurnBasedMatchesDecline* = Call_GamesTurnBasedMatchesDecline_580627(
    name: "gamesTurnBasedMatchesDecline", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/decline",
    validator: validate_GamesTurnBasedMatchesDecline_580628, base: "/games/v1",
    url: url_GamesTurnBasedMatchesDecline_580629, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesDismiss_580643 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesDismiss_580645(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matchId" in path, "`matchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/turnbasedmatches/"),
               (kind: VariableSegment, value: "matchId"),
               (kind: ConstantSegment, value: "/dismiss")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesDismiss_580644(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Dismiss a turn-based match from the match list. The match will no longer show up in the list and will not generate notifications.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matchId: JString (required)
  ##          : The ID of the match.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matchId` field"
  var valid_580646 = path.getOrDefault("matchId")
  valid_580646 = validateParameter(valid_580646, JString, required = true,
                                 default = nil)
  if valid_580646 != nil:
    section.add "matchId", valid_580646
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
  var valid_580647 = query.getOrDefault("key")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "key", valid_580647
  var valid_580648 = query.getOrDefault("prettyPrint")
  valid_580648 = validateParameter(valid_580648, JBool, required = false,
                                 default = newJBool(true))
  if valid_580648 != nil:
    section.add "prettyPrint", valid_580648
  var valid_580649 = query.getOrDefault("oauth_token")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "oauth_token", valid_580649
  var valid_580650 = query.getOrDefault("alt")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = newJString("json"))
  if valid_580650 != nil:
    section.add "alt", valid_580650
  var valid_580651 = query.getOrDefault("userIp")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "userIp", valid_580651
  var valid_580652 = query.getOrDefault("quotaUser")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "quotaUser", valid_580652
  var valid_580653 = query.getOrDefault("fields")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "fields", valid_580653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580654: Call_GamesTurnBasedMatchesDismiss_580643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss a turn-based match from the match list. The match will no longer show up in the list and will not generate notifications.
  ## 
  let valid = call_580654.validator(path, query, header, formData, body)
  let scheme = call_580654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580654.url(scheme.get, call_580654.host, call_580654.base,
                         call_580654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580654, url, valid)

proc call*(call_580655: Call_GamesTurnBasedMatchesDismiss_580643; matchId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesTurnBasedMatchesDismiss
  ## Dismiss a turn-based match from the match list. The match will no longer show up in the list and will not generate notifications.
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
  ##   matchId: string (required)
  ##          : The ID of the match.
  var path_580656 = newJObject()
  var query_580657 = newJObject()
  add(query_580657, "key", newJString(key))
  add(query_580657, "prettyPrint", newJBool(prettyPrint))
  add(query_580657, "oauth_token", newJString(oauthToken))
  add(query_580657, "alt", newJString(alt))
  add(query_580657, "userIp", newJString(userIp))
  add(query_580657, "quotaUser", newJString(quotaUser))
  add(query_580657, "fields", newJString(fields))
  add(path_580656, "matchId", newJString(matchId))
  result = call_580655.call(path_580656, query_580657, nil, nil, nil)

var gamesTurnBasedMatchesDismiss* = Call_GamesTurnBasedMatchesDismiss_580643(
    name: "gamesTurnBasedMatchesDismiss", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/dismiss",
    validator: validate_GamesTurnBasedMatchesDismiss_580644, base: "/games/v1",
    url: url_GamesTurnBasedMatchesDismiss_580645, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesFinish_580658 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesFinish_580660(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matchId" in path, "`matchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/turnbasedmatches/"),
               (kind: VariableSegment, value: "matchId"),
               (kind: ConstantSegment, value: "/finish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesFinish_580659(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finish a turn-based match. Each player should make this call once, after all results are in. Only the player whose turn it is may make the first call to Finish, and can pass in the final match state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matchId: JString (required)
  ##          : The ID of the match.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matchId` field"
  var valid_580661 = path.getOrDefault("matchId")
  valid_580661 = validateParameter(valid_580661, JString, required = true,
                                 default = nil)
  if valid_580661 != nil:
    section.add "matchId", valid_580661
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580662 = query.getOrDefault("key")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "key", valid_580662
  var valid_580663 = query.getOrDefault("prettyPrint")
  valid_580663 = validateParameter(valid_580663, JBool, required = false,
                                 default = newJBool(true))
  if valid_580663 != nil:
    section.add "prettyPrint", valid_580663
  var valid_580664 = query.getOrDefault("oauth_token")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "oauth_token", valid_580664
  var valid_580665 = query.getOrDefault("alt")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = newJString("json"))
  if valid_580665 != nil:
    section.add "alt", valid_580665
  var valid_580666 = query.getOrDefault("userIp")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = nil)
  if valid_580666 != nil:
    section.add "userIp", valid_580666
  var valid_580667 = query.getOrDefault("quotaUser")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "quotaUser", valid_580667
  var valid_580668 = query.getOrDefault("fields")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "fields", valid_580668
  var valid_580669 = query.getOrDefault("language")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "language", valid_580669
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

proc call*(call_580671: Call_GamesTurnBasedMatchesFinish_580658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finish a turn-based match. Each player should make this call once, after all results are in. Only the player whose turn it is may make the first call to Finish, and can pass in the final match state.
  ## 
  let valid = call_580671.validator(path, query, header, formData, body)
  let scheme = call_580671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580671.url(scheme.get, call_580671.host, call_580671.base,
                         call_580671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580671, url, valid)

proc call*(call_580672: Call_GamesTurnBasedMatchesFinish_580658; matchId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""; language: string = ""): Recallable =
  ## gamesTurnBasedMatchesFinish
  ## Finish a turn-based match. Each player should make this call once, after all results are in. Only the player whose turn it is may make the first call to Finish, and can pass in the final match state.
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
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580673 = newJObject()
  var query_580674 = newJObject()
  var body_580675 = newJObject()
  add(query_580674, "key", newJString(key))
  add(query_580674, "prettyPrint", newJBool(prettyPrint))
  add(query_580674, "oauth_token", newJString(oauthToken))
  add(query_580674, "alt", newJString(alt))
  add(query_580674, "userIp", newJString(userIp))
  add(query_580674, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580675 = body
  add(query_580674, "fields", newJString(fields))
  add(path_580673, "matchId", newJString(matchId))
  add(query_580674, "language", newJString(language))
  result = call_580672.call(path_580673, query_580674, nil, nil, body_580675)

var gamesTurnBasedMatchesFinish* = Call_GamesTurnBasedMatchesFinish_580658(
    name: "gamesTurnBasedMatchesFinish", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/finish",
    validator: validate_GamesTurnBasedMatchesFinish_580659, base: "/games/v1",
    url: url_GamesTurnBasedMatchesFinish_580660, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesJoin_580676 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesJoin_580678(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matchId" in path, "`matchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/turnbasedmatches/"),
               (kind: VariableSegment, value: "matchId"),
               (kind: ConstantSegment, value: "/join")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesJoin_580677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Join a turn-based match.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matchId: JString (required)
  ##          : The ID of the match.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matchId` field"
  var valid_580679 = path.getOrDefault("matchId")
  valid_580679 = validateParameter(valid_580679, JString, required = true,
                                 default = nil)
  if valid_580679 != nil:
    section.add "matchId", valid_580679
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580680 = query.getOrDefault("key")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "key", valid_580680
  var valid_580681 = query.getOrDefault("prettyPrint")
  valid_580681 = validateParameter(valid_580681, JBool, required = false,
                                 default = newJBool(true))
  if valid_580681 != nil:
    section.add "prettyPrint", valid_580681
  var valid_580682 = query.getOrDefault("oauth_token")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = nil)
  if valid_580682 != nil:
    section.add "oauth_token", valid_580682
  var valid_580683 = query.getOrDefault("alt")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = newJString("json"))
  if valid_580683 != nil:
    section.add "alt", valid_580683
  var valid_580684 = query.getOrDefault("userIp")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "userIp", valid_580684
  var valid_580685 = query.getOrDefault("quotaUser")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "quotaUser", valid_580685
  var valid_580686 = query.getOrDefault("fields")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "fields", valid_580686
  var valid_580687 = query.getOrDefault("language")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "language", valid_580687
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580688: Call_GamesTurnBasedMatchesJoin_580676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Join a turn-based match.
  ## 
  let valid = call_580688.validator(path, query, header, formData, body)
  let scheme = call_580688.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580688.url(scheme.get, call_580688.host, call_580688.base,
                         call_580688.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580688, url, valid)

proc call*(call_580689: Call_GamesTurnBasedMatchesJoin_580676; matchId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; language: string = ""): Recallable =
  ## gamesTurnBasedMatchesJoin
  ## Join a turn-based match.
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
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580690 = newJObject()
  var query_580691 = newJObject()
  add(query_580691, "key", newJString(key))
  add(query_580691, "prettyPrint", newJBool(prettyPrint))
  add(query_580691, "oauth_token", newJString(oauthToken))
  add(query_580691, "alt", newJString(alt))
  add(query_580691, "userIp", newJString(userIp))
  add(query_580691, "quotaUser", newJString(quotaUser))
  add(query_580691, "fields", newJString(fields))
  add(path_580690, "matchId", newJString(matchId))
  add(query_580691, "language", newJString(language))
  result = call_580689.call(path_580690, query_580691, nil, nil, nil)

var gamesTurnBasedMatchesJoin* = Call_GamesTurnBasedMatchesJoin_580676(
    name: "gamesTurnBasedMatchesJoin", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/join",
    validator: validate_GamesTurnBasedMatchesJoin_580677, base: "/games/v1",
    url: url_GamesTurnBasedMatchesJoin_580678, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesLeave_580692 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesLeave_580694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matchId" in path, "`matchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/turnbasedmatches/"),
               (kind: VariableSegment, value: "matchId"),
               (kind: ConstantSegment, value: "/leave")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesLeave_580693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Leave a turn-based match when it is not the current player's turn, without canceling the match.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matchId: JString (required)
  ##          : The ID of the match.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matchId` field"
  var valid_580695 = path.getOrDefault("matchId")
  valid_580695 = validateParameter(valid_580695, JString, required = true,
                                 default = nil)
  if valid_580695 != nil:
    section.add "matchId", valid_580695
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580696 = query.getOrDefault("key")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "key", valid_580696
  var valid_580697 = query.getOrDefault("prettyPrint")
  valid_580697 = validateParameter(valid_580697, JBool, required = false,
                                 default = newJBool(true))
  if valid_580697 != nil:
    section.add "prettyPrint", valid_580697
  var valid_580698 = query.getOrDefault("oauth_token")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "oauth_token", valid_580698
  var valid_580699 = query.getOrDefault("alt")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = newJString("json"))
  if valid_580699 != nil:
    section.add "alt", valid_580699
  var valid_580700 = query.getOrDefault("userIp")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "userIp", valid_580700
  var valid_580701 = query.getOrDefault("quotaUser")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "quotaUser", valid_580701
  var valid_580702 = query.getOrDefault("fields")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "fields", valid_580702
  var valid_580703 = query.getOrDefault("language")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "language", valid_580703
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580704: Call_GamesTurnBasedMatchesLeave_580692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a turn-based match when it is not the current player's turn, without canceling the match.
  ## 
  let valid = call_580704.validator(path, query, header, formData, body)
  let scheme = call_580704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580704.url(scheme.get, call_580704.host, call_580704.base,
                         call_580704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580704, url, valid)

proc call*(call_580705: Call_GamesTurnBasedMatchesLeave_580692; matchId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; language: string = ""): Recallable =
  ## gamesTurnBasedMatchesLeave
  ## Leave a turn-based match when it is not the current player's turn, without canceling the match.
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
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580706 = newJObject()
  var query_580707 = newJObject()
  add(query_580707, "key", newJString(key))
  add(query_580707, "prettyPrint", newJBool(prettyPrint))
  add(query_580707, "oauth_token", newJString(oauthToken))
  add(query_580707, "alt", newJString(alt))
  add(query_580707, "userIp", newJString(userIp))
  add(query_580707, "quotaUser", newJString(quotaUser))
  add(query_580707, "fields", newJString(fields))
  add(path_580706, "matchId", newJString(matchId))
  add(query_580707, "language", newJString(language))
  result = call_580705.call(path_580706, query_580707, nil, nil, nil)

var gamesTurnBasedMatchesLeave* = Call_GamesTurnBasedMatchesLeave_580692(
    name: "gamesTurnBasedMatchesLeave", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/leave",
    validator: validate_GamesTurnBasedMatchesLeave_580693, base: "/games/v1",
    url: url_GamesTurnBasedMatchesLeave_580694, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesLeaveTurn_580708 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesLeaveTurn_580710(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matchId" in path, "`matchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/turnbasedmatches/"),
               (kind: VariableSegment, value: "matchId"),
               (kind: ConstantSegment, value: "/leaveTurn")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesLeaveTurn_580709(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Leave a turn-based match during the current player's turn, without canceling the match.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matchId: JString (required)
  ##          : The ID of the match.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matchId` field"
  var valid_580711 = path.getOrDefault("matchId")
  valid_580711 = validateParameter(valid_580711, JString, required = true,
                                 default = nil)
  if valid_580711 != nil:
    section.add "matchId", valid_580711
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   matchVersion: JInt (required)
  ##               : The version of the match being updated.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   pendingParticipantId: JString
  ##                       : The ID of another participant who should take their turn next. If not set, the match will wait for other player(s) to join via automatching; this is only valid if automatch criteria is set on the match with remaining slots for automatched players.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580712 = query.getOrDefault("key")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "key", valid_580712
  var valid_580713 = query.getOrDefault("prettyPrint")
  valid_580713 = validateParameter(valid_580713, JBool, required = false,
                                 default = newJBool(true))
  if valid_580713 != nil:
    section.add "prettyPrint", valid_580713
  var valid_580714 = query.getOrDefault("oauth_token")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "oauth_token", valid_580714
  assert query != nil,
        "query argument is necessary due to required `matchVersion` field"
  var valid_580715 = query.getOrDefault("matchVersion")
  valid_580715 = validateParameter(valid_580715, JInt, required = true, default = nil)
  if valid_580715 != nil:
    section.add "matchVersion", valid_580715
  var valid_580716 = query.getOrDefault("alt")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = newJString("json"))
  if valid_580716 != nil:
    section.add "alt", valid_580716
  var valid_580717 = query.getOrDefault("userIp")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = nil)
  if valid_580717 != nil:
    section.add "userIp", valid_580717
  var valid_580718 = query.getOrDefault("pendingParticipantId")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "pendingParticipantId", valid_580718
  var valid_580719 = query.getOrDefault("quotaUser")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "quotaUser", valid_580719
  var valid_580720 = query.getOrDefault("fields")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "fields", valid_580720
  var valid_580721 = query.getOrDefault("language")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "language", valid_580721
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580722: Call_GamesTurnBasedMatchesLeaveTurn_580708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a turn-based match during the current player's turn, without canceling the match.
  ## 
  let valid = call_580722.validator(path, query, header, formData, body)
  let scheme = call_580722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580722.url(scheme.get, call_580722.host, call_580722.base,
                         call_580722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580722, url, valid)

proc call*(call_580723: Call_GamesTurnBasedMatchesLeaveTurn_580708;
          matchVersion: int; matchId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; pendingParticipantId: string = "";
          quotaUser: string = ""; fields: string = ""; language: string = ""): Recallable =
  ## gamesTurnBasedMatchesLeaveTurn
  ## Leave a turn-based match during the current player's turn, without canceling the match.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   matchVersion: int (required)
  ##               : The version of the match being updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   pendingParticipantId: string
  ##                       : The ID of another participant who should take their turn next. If not set, the match will wait for other player(s) to join via automatching; this is only valid if automatch criteria is set on the match with remaining slots for automatched players.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580724 = newJObject()
  var query_580725 = newJObject()
  add(query_580725, "key", newJString(key))
  add(query_580725, "prettyPrint", newJBool(prettyPrint))
  add(query_580725, "oauth_token", newJString(oauthToken))
  add(query_580725, "matchVersion", newJInt(matchVersion))
  add(query_580725, "alt", newJString(alt))
  add(query_580725, "userIp", newJString(userIp))
  add(query_580725, "pendingParticipantId", newJString(pendingParticipantId))
  add(query_580725, "quotaUser", newJString(quotaUser))
  add(query_580725, "fields", newJString(fields))
  add(path_580724, "matchId", newJString(matchId))
  add(query_580725, "language", newJString(language))
  result = call_580723.call(path_580724, query_580725, nil, nil, nil)

var gamesTurnBasedMatchesLeaveTurn* = Call_GamesTurnBasedMatchesLeaveTurn_580708(
    name: "gamesTurnBasedMatchesLeaveTurn", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/leaveTurn",
    validator: validate_GamesTurnBasedMatchesLeaveTurn_580709, base: "/games/v1",
    url: url_GamesTurnBasedMatchesLeaveTurn_580710, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesRematch_580726 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesRematch_580728(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matchId" in path, "`matchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/turnbasedmatches/"),
               (kind: VariableSegment, value: "matchId"),
               (kind: ConstantSegment, value: "/rematch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesRematch_580727(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a rematch of a match that was previously completed, with the same participants. This can be called by only one player on a match still in their list; the player must have called Finish first. Returns the newly created match; it will be the caller's turn.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matchId: JString (required)
  ##          : The ID of the match.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matchId` field"
  var valid_580729 = path.getOrDefault("matchId")
  valid_580729 = validateParameter(valid_580729, JString, required = true,
                                 default = nil)
  if valid_580729 != nil:
    section.add "matchId", valid_580729
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
  ##   requestId: JString
  ##            : A randomly generated numeric ID for each request specified by the caller. This number is used at the server to ensure that the request is handled correctly across retries.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580730 = query.getOrDefault("key")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "key", valid_580730
  var valid_580731 = query.getOrDefault("prettyPrint")
  valid_580731 = validateParameter(valid_580731, JBool, required = false,
                                 default = newJBool(true))
  if valid_580731 != nil:
    section.add "prettyPrint", valid_580731
  var valid_580732 = query.getOrDefault("oauth_token")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "oauth_token", valid_580732
  var valid_580733 = query.getOrDefault("alt")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = newJString("json"))
  if valid_580733 != nil:
    section.add "alt", valid_580733
  var valid_580734 = query.getOrDefault("userIp")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "userIp", valid_580734
  var valid_580735 = query.getOrDefault("quotaUser")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "quotaUser", valid_580735
  var valid_580736 = query.getOrDefault("requestId")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "requestId", valid_580736
  var valid_580737 = query.getOrDefault("fields")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "fields", valid_580737
  var valid_580738 = query.getOrDefault("language")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "language", valid_580738
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580739: Call_GamesTurnBasedMatchesRematch_580726; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a rematch of a match that was previously completed, with the same participants. This can be called by only one player on a match still in their list; the player must have called Finish first. Returns the newly created match; it will be the caller's turn.
  ## 
  let valid = call_580739.validator(path, query, header, formData, body)
  let scheme = call_580739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580739.url(scheme.get, call_580739.host, call_580739.base,
                         call_580739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580739, url, valid)

proc call*(call_580740: Call_GamesTurnBasedMatchesRematch_580726; matchId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          requestId: string = ""; fields: string = ""; language: string = ""): Recallable =
  ## gamesTurnBasedMatchesRematch
  ## Create a rematch of a match that was previously completed, with the same participants. This can be called by only one player on a match still in their list; the player must have called Finish first. Returns the newly created match; it will be the caller's turn.
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
  ##   requestId: string
  ##            : A randomly generated numeric ID for each request specified by the caller. This number is used at the server to ensure that the request is handled correctly across retries.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580741 = newJObject()
  var query_580742 = newJObject()
  add(query_580742, "key", newJString(key))
  add(query_580742, "prettyPrint", newJBool(prettyPrint))
  add(query_580742, "oauth_token", newJString(oauthToken))
  add(query_580742, "alt", newJString(alt))
  add(query_580742, "userIp", newJString(userIp))
  add(query_580742, "quotaUser", newJString(quotaUser))
  add(query_580742, "requestId", newJString(requestId))
  add(query_580742, "fields", newJString(fields))
  add(path_580741, "matchId", newJString(matchId))
  add(query_580742, "language", newJString(language))
  result = call_580740.call(path_580741, query_580742, nil, nil, nil)

var gamesTurnBasedMatchesRematch* = Call_GamesTurnBasedMatchesRematch_580726(
    name: "gamesTurnBasedMatchesRematch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/rematch",
    validator: validate_GamesTurnBasedMatchesRematch_580727, base: "/games/v1",
    url: url_GamesTurnBasedMatchesRematch_580728, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesTakeTurn_580743 = ref object of OpenApiRestCall_579389
proc url_GamesTurnBasedMatchesTakeTurn_580745(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "matchId" in path, "`matchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/turnbasedmatches/"),
               (kind: VariableSegment, value: "matchId"),
               (kind: ConstantSegment, value: "/turn")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesTakeTurn_580744(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Commit the results of a player turn.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   matchId: JString (required)
  ##          : The ID of the match.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `matchId` field"
  var valid_580746 = path.getOrDefault("matchId")
  valid_580746 = validateParameter(valid_580746, JString, required = true,
                                 default = nil)
  if valid_580746 != nil:
    section.add "matchId", valid_580746
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  section = newJObject()
  var valid_580747 = query.getOrDefault("key")
  valid_580747 = validateParameter(valid_580747, JString, required = false,
                                 default = nil)
  if valid_580747 != nil:
    section.add "key", valid_580747
  var valid_580748 = query.getOrDefault("prettyPrint")
  valid_580748 = validateParameter(valid_580748, JBool, required = false,
                                 default = newJBool(true))
  if valid_580748 != nil:
    section.add "prettyPrint", valid_580748
  var valid_580749 = query.getOrDefault("oauth_token")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "oauth_token", valid_580749
  var valid_580750 = query.getOrDefault("alt")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = newJString("json"))
  if valid_580750 != nil:
    section.add "alt", valid_580750
  var valid_580751 = query.getOrDefault("userIp")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "userIp", valid_580751
  var valid_580752 = query.getOrDefault("quotaUser")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "quotaUser", valid_580752
  var valid_580753 = query.getOrDefault("fields")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "fields", valid_580753
  var valid_580754 = query.getOrDefault("language")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "language", valid_580754
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

proc call*(call_580756: Call_GamesTurnBasedMatchesTakeTurn_580743; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commit the results of a player turn.
  ## 
  let valid = call_580756.validator(path, query, header, formData, body)
  let scheme = call_580756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580756.url(scheme.get, call_580756.host, call_580756.base,
                         call_580756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580756, url, valid)

proc call*(call_580757: Call_GamesTurnBasedMatchesTakeTurn_580743; matchId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""; language: string = ""): Recallable =
  ## gamesTurnBasedMatchesTakeTurn
  ## Commit the results of a player turn.
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
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  var path_580758 = newJObject()
  var query_580759 = newJObject()
  var body_580760 = newJObject()
  add(query_580759, "key", newJString(key))
  add(query_580759, "prettyPrint", newJBool(prettyPrint))
  add(query_580759, "oauth_token", newJString(oauthToken))
  add(query_580759, "alt", newJString(alt))
  add(query_580759, "userIp", newJString(userIp))
  add(query_580759, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580760 = body
  add(query_580759, "fields", newJString(fields))
  add(path_580758, "matchId", newJString(matchId))
  add(query_580759, "language", newJString(language))
  result = call_580757.call(path_580758, query_580759, nil, nil, body_580760)

var gamesTurnBasedMatchesTakeTurn* = Call_GamesTurnBasedMatchesTakeTurn_580743(
    name: "gamesTurnBasedMatchesTakeTurn", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/turn",
    validator: validate_GamesTurnBasedMatchesTakeTurn_580744, base: "/games/v1",
    url: url_GamesTurnBasedMatchesTakeTurn_580745, schemes: {Scheme.Https})
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
