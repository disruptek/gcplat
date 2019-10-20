
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_578364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578364): Option[Scheme] {.used.} =
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
  Call_GamesAchievementDefinitionsList_578634 = ref object of OpenApiRestCall_578364
proc url_GamesAchievementDefinitionsList_578636(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesAchievementDefinitionsList_578635(path: JsonNode;
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
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("alt")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("json"))
  if valid_578764 != nil:
    section.add "alt", valid_578764
  var valid_578765 = query.getOrDefault("userIp")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "userIp", valid_578765
  var valid_578766 = query.getOrDefault("quotaUser")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "quotaUser", valid_578766
  var valid_578767 = query.getOrDefault("pageToken")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "pageToken", valid_578767
  var valid_578768 = query.getOrDefault("fields")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "fields", valid_578768
  var valid_578769 = query.getOrDefault("language")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "language", valid_578769
  var valid_578770 = query.getOrDefault("maxResults")
  valid_578770 = validateParameter(valid_578770, JInt, required = false, default = nil)
  if valid_578770 != nil:
    section.add "maxResults", valid_578770
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578793: Call_GamesAchievementDefinitionsList_578634;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the achievement definitions for your application.
  ## 
  let valid = call_578793.validator(path, query, header, formData, body)
  let scheme = call_578793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578793.url(scheme.get, call_578793.host, call_578793.base,
                         call_578793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578793, url, valid)

proc call*(call_578864: Call_GamesAchievementDefinitionsList_578634;
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
  var query_578865 = newJObject()
  add(query_578865, "key", newJString(key))
  add(query_578865, "prettyPrint", newJBool(prettyPrint))
  add(query_578865, "oauth_token", newJString(oauthToken))
  add(query_578865, "alt", newJString(alt))
  add(query_578865, "userIp", newJString(userIp))
  add(query_578865, "quotaUser", newJString(quotaUser))
  add(query_578865, "pageToken", newJString(pageToken))
  add(query_578865, "fields", newJString(fields))
  add(query_578865, "language", newJString(language))
  add(query_578865, "maxResults", newJInt(maxResults))
  result = call_578864.call(nil, query_578865, nil, nil, nil)

var gamesAchievementDefinitionsList* = Call_GamesAchievementDefinitionsList_578634(
    name: "gamesAchievementDefinitionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/achievements",
    validator: validate_GamesAchievementDefinitionsList_578635, base: "/games/v1",
    url: url_GamesAchievementDefinitionsList_578636, schemes: {Scheme.Https})
type
  Call_GamesAchievementsUpdateMultiple_578905 = ref object of OpenApiRestCall_578364
proc url_GamesAchievementsUpdateMultiple_578907(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesAchievementsUpdateMultiple_578906(path: JsonNode;
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
  var valid_578908 = query.getOrDefault("key")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "key", valid_578908
  var valid_578909 = query.getOrDefault("prettyPrint")
  valid_578909 = validateParameter(valid_578909, JBool, required = false,
                                 default = newJBool(true))
  if valid_578909 != nil:
    section.add "prettyPrint", valid_578909
  var valid_578910 = query.getOrDefault("oauth_token")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "oauth_token", valid_578910
  var valid_578911 = query.getOrDefault("alt")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = newJString("json"))
  if valid_578911 != nil:
    section.add "alt", valid_578911
  var valid_578912 = query.getOrDefault("userIp")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "userIp", valid_578912
  var valid_578913 = query.getOrDefault("quotaUser")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "quotaUser", valid_578913
  var valid_578914 = query.getOrDefault("builtinGameId")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "builtinGameId", valid_578914
  var valid_578915 = query.getOrDefault("fields")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "fields", valid_578915
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

proc call*(call_578917: Call_GamesAchievementsUpdateMultiple_578905;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates multiple achievements for the currently authenticated player.
  ## 
  let valid = call_578917.validator(path, query, header, formData, body)
  let scheme = call_578917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578917.url(scheme.get, call_578917.host, call_578917.base,
                         call_578917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578917, url, valid)

proc call*(call_578918: Call_GamesAchievementsUpdateMultiple_578905;
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
  var query_578919 = newJObject()
  var body_578920 = newJObject()
  add(query_578919, "key", newJString(key))
  add(query_578919, "prettyPrint", newJBool(prettyPrint))
  add(query_578919, "oauth_token", newJString(oauthToken))
  add(query_578919, "alt", newJString(alt))
  add(query_578919, "userIp", newJString(userIp))
  add(query_578919, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578920 = body
  add(query_578919, "builtinGameId", newJString(builtinGameId))
  add(query_578919, "fields", newJString(fields))
  result = call_578918.call(nil, query_578919, nil, nil, body_578920)

var gamesAchievementsUpdateMultiple* = Call_GamesAchievementsUpdateMultiple_578905(
    name: "gamesAchievementsUpdateMultiple", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/updateMultiple",
    validator: validate_GamesAchievementsUpdateMultiple_578906, base: "/games/v1",
    url: url_GamesAchievementsUpdateMultiple_578907, schemes: {Scheme.Https})
type
  Call_GamesAchievementsIncrement_578921 = ref object of OpenApiRestCall_578364
proc url_GamesAchievementsIncrement_578923(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesAchievementsIncrement_578922(path: JsonNode; query: JsonNode;
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
  var valid_578938 = path.getOrDefault("achievementId")
  valid_578938 = validateParameter(valid_578938, JString, required = true,
                                 default = nil)
  if valid_578938 != nil:
    section.add "achievementId", valid_578938
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
  var valid_578939 = query.getOrDefault("key")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "key", valid_578939
  var valid_578940 = query.getOrDefault("prettyPrint")
  valid_578940 = validateParameter(valid_578940, JBool, required = false,
                                 default = newJBool(true))
  if valid_578940 != nil:
    section.add "prettyPrint", valid_578940
  var valid_578941 = query.getOrDefault("oauth_token")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "oauth_token", valid_578941
  var valid_578942 = query.getOrDefault("alt")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = newJString("json"))
  if valid_578942 != nil:
    section.add "alt", valid_578942
  var valid_578943 = query.getOrDefault("userIp")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "userIp", valid_578943
  var valid_578944 = query.getOrDefault("quotaUser")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "quotaUser", valid_578944
  var valid_578945 = query.getOrDefault("requestId")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "requestId", valid_578945
  var valid_578946 = query.getOrDefault("fields")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "fields", valid_578946
  assert query != nil,
        "query argument is necessary due to required `stepsToIncrement` field"
  var valid_578947 = query.getOrDefault("stepsToIncrement")
  valid_578947 = validateParameter(valid_578947, JInt, required = true, default = nil)
  if valid_578947 != nil:
    section.add "stepsToIncrement", valid_578947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578948: Call_GamesAchievementsIncrement_578921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Increments the steps of the achievement with the given ID for the currently authenticated player.
  ## 
  let valid = call_578948.validator(path, query, header, formData, body)
  let scheme = call_578948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578948.url(scheme.get, call_578948.host, call_578948.base,
                         call_578948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578948, url, valid)

proc call*(call_578949: Call_GamesAchievementsIncrement_578921;
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
  var path_578950 = newJObject()
  var query_578951 = newJObject()
  add(query_578951, "key", newJString(key))
  add(query_578951, "prettyPrint", newJBool(prettyPrint))
  add(query_578951, "oauth_token", newJString(oauthToken))
  add(query_578951, "alt", newJString(alt))
  add(query_578951, "userIp", newJString(userIp))
  add(query_578951, "quotaUser", newJString(quotaUser))
  add(path_578950, "achievementId", newJString(achievementId))
  add(query_578951, "requestId", newJString(requestId))
  add(query_578951, "fields", newJString(fields))
  add(query_578951, "stepsToIncrement", newJInt(stepsToIncrement))
  result = call_578949.call(path_578950, query_578951, nil, nil, nil)

var gamesAchievementsIncrement* = Call_GamesAchievementsIncrement_578921(
    name: "gamesAchievementsIncrement", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/increment",
    validator: validate_GamesAchievementsIncrement_578922, base: "/games/v1",
    url: url_GamesAchievementsIncrement_578923, schemes: {Scheme.Https})
type
  Call_GamesAchievementsReveal_578952 = ref object of OpenApiRestCall_578364
proc url_GamesAchievementsReveal_578954(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesAchievementsReveal_578953(path: JsonNode; query: JsonNode;
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
  var valid_578955 = path.getOrDefault("achievementId")
  valid_578955 = validateParameter(valid_578955, JString, required = true,
                                 default = nil)
  if valid_578955 != nil:
    section.add "achievementId", valid_578955
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
  var valid_578956 = query.getOrDefault("key")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "key", valid_578956
  var valid_578957 = query.getOrDefault("prettyPrint")
  valid_578957 = validateParameter(valid_578957, JBool, required = false,
                                 default = newJBool(true))
  if valid_578957 != nil:
    section.add "prettyPrint", valid_578957
  var valid_578958 = query.getOrDefault("oauth_token")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "oauth_token", valid_578958
  var valid_578959 = query.getOrDefault("alt")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = newJString("json"))
  if valid_578959 != nil:
    section.add "alt", valid_578959
  var valid_578960 = query.getOrDefault("userIp")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "userIp", valid_578960
  var valid_578961 = query.getOrDefault("quotaUser")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "quotaUser", valid_578961
  var valid_578962 = query.getOrDefault("fields")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "fields", valid_578962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578963: Call_GamesAchievementsReveal_578952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the achievement with the given ID to REVEALED for the currently authenticated player.
  ## 
  let valid = call_578963.validator(path, query, header, formData, body)
  let scheme = call_578963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578963.url(scheme.get, call_578963.host, call_578963.base,
                         call_578963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578963, url, valid)

proc call*(call_578964: Call_GamesAchievementsReveal_578952; achievementId: string;
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
  var path_578965 = newJObject()
  var query_578966 = newJObject()
  add(query_578966, "key", newJString(key))
  add(query_578966, "prettyPrint", newJBool(prettyPrint))
  add(query_578966, "oauth_token", newJString(oauthToken))
  add(query_578966, "alt", newJString(alt))
  add(query_578966, "userIp", newJString(userIp))
  add(query_578966, "quotaUser", newJString(quotaUser))
  add(path_578965, "achievementId", newJString(achievementId))
  add(query_578966, "fields", newJString(fields))
  result = call_578964.call(path_578965, query_578966, nil, nil, nil)

var gamesAchievementsReveal* = Call_GamesAchievementsReveal_578952(
    name: "gamesAchievementsReveal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/reveal",
    validator: validate_GamesAchievementsReveal_578953, base: "/games/v1",
    url: url_GamesAchievementsReveal_578954, schemes: {Scheme.Https})
type
  Call_GamesAchievementsSetStepsAtLeast_578967 = ref object of OpenApiRestCall_578364
proc url_GamesAchievementsSetStepsAtLeast_578969(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesAchievementsSetStepsAtLeast_578968(path: JsonNode;
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
  var valid_578970 = path.getOrDefault("achievementId")
  valid_578970 = validateParameter(valid_578970, JString, required = true,
                                 default = nil)
  if valid_578970 != nil:
    section.add "achievementId", valid_578970
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
  var valid_578971 = query.getOrDefault("key")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "key", valid_578971
  var valid_578972 = query.getOrDefault("prettyPrint")
  valid_578972 = validateParameter(valid_578972, JBool, required = false,
                                 default = newJBool(true))
  if valid_578972 != nil:
    section.add "prettyPrint", valid_578972
  var valid_578973 = query.getOrDefault("oauth_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "oauth_token", valid_578973
  assert query != nil, "query argument is necessary due to required `steps` field"
  var valid_578974 = query.getOrDefault("steps")
  valid_578974 = validateParameter(valid_578974, JInt, required = true, default = nil)
  if valid_578974 != nil:
    section.add "steps", valid_578974
  var valid_578975 = query.getOrDefault("alt")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = newJString("json"))
  if valid_578975 != nil:
    section.add "alt", valid_578975
  var valid_578976 = query.getOrDefault("userIp")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "userIp", valid_578976
  var valid_578977 = query.getOrDefault("quotaUser")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "quotaUser", valid_578977
  var valid_578978 = query.getOrDefault("fields")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "fields", valid_578978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578979: Call_GamesAchievementsSetStepsAtLeast_578967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the steps for the currently authenticated player towards unlocking an achievement. If the steps parameter is less than the current number of steps that the player already gained for the achievement, the achievement is not modified.
  ## 
  let valid = call_578979.validator(path, query, header, formData, body)
  let scheme = call_578979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578979.url(scheme.get, call_578979.host, call_578979.base,
                         call_578979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578979, url, valid)

proc call*(call_578980: Call_GamesAchievementsSetStepsAtLeast_578967; steps: int;
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
  var path_578981 = newJObject()
  var query_578982 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(query_578982, "steps", newJInt(steps))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "userIp", newJString(userIp))
  add(query_578982, "quotaUser", newJString(quotaUser))
  add(path_578981, "achievementId", newJString(achievementId))
  add(query_578982, "fields", newJString(fields))
  result = call_578980.call(path_578981, query_578982, nil, nil, nil)

var gamesAchievementsSetStepsAtLeast* = Call_GamesAchievementsSetStepsAtLeast_578967(
    name: "gamesAchievementsSetStepsAtLeast", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/achievements/{achievementId}/setStepsAtLeast",
    validator: validate_GamesAchievementsSetStepsAtLeast_578968,
    base: "/games/v1", url: url_GamesAchievementsSetStepsAtLeast_578969,
    schemes: {Scheme.Https})
type
  Call_GamesAchievementsUnlock_578983 = ref object of OpenApiRestCall_578364
proc url_GamesAchievementsUnlock_578985(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesAchievementsUnlock_578984(path: JsonNode; query: JsonNode;
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
  var valid_578986 = path.getOrDefault("achievementId")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "achievementId", valid_578986
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
  var valid_578987 = query.getOrDefault("key")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "key", valid_578987
  var valid_578988 = query.getOrDefault("prettyPrint")
  valid_578988 = validateParameter(valid_578988, JBool, required = false,
                                 default = newJBool(true))
  if valid_578988 != nil:
    section.add "prettyPrint", valid_578988
  var valid_578989 = query.getOrDefault("oauth_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "oauth_token", valid_578989
  var valid_578990 = query.getOrDefault("alt")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("json"))
  if valid_578990 != nil:
    section.add "alt", valid_578990
  var valid_578991 = query.getOrDefault("userIp")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "userIp", valid_578991
  var valid_578992 = query.getOrDefault("quotaUser")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "quotaUser", valid_578992
  var valid_578993 = query.getOrDefault("builtinGameId")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "builtinGameId", valid_578993
  var valid_578994 = query.getOrDefault("fields")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "fields", valid_578994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578995: Call_GamesAchievementsUnlock_578983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unlocks this achievement for the currently authenticated player.
  ## 
  let valid = call_578995.validator(path, query, header, formData, body)
  let scheme = call_578995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578995.url(scheme.get, call_578995.host, call_578995.base,
                         call_578995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578995, url, valid)

proc call*(call_578996: Call_GamesAchievementsUnlock_578983; achievementId: string;
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
  var path_578997 = newJObject()
  var query_578998 = newJObject()
  add(query_578998, "key", newJString(key))
  add(query_578998, "prettyPrint", newJBool(prettyPrint))
  add(query_578998, "oauth_token", newJString(oauthToken))
  add(query_578998, "alt", newJString(alt))
  add(query_578998, "userIp", newJString(userIp))
  add(query_578998, "quotaUser", newJString(quotaUser))
  add(path_578997, "achievementId", newJString(achievementId))
  add(query_578998, "builtinGameId", newJString(builtinGameId))
  add(query_578998, "fields", newJString(fields))
  result = call_578996.call(path_578997, query_578998, nil, nil, nil)

var gamesAchievementsUnlock* = Call_GamesAchievementsUnlock_578983(
    name: "gamesAchievementsUnlock", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/unlock",
    validator: validate_GamesAchievementsUnlock_578984, base: "/games/v1",
    url: url_GamesAchievementsUnlock_578985, schemes: {Scheme.Https})
type
  Call_GamesApplicationsPlayed_578999 = ref object of OpenApiRestCall_578364
proc url_GamesApplicationsPlayed_579001(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesApplicationsPlayed_579000(path: JsonNode; query: JsonNode;
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
  var valid_579002 = query.getOrDefault("key")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "key", valid_579002
  var valid_579003 = query.getOrDefault("prettyPrint")
  valid_579003 = validateParameter(valid_579003, JBool, required = false,
                                 default = newJBool(true))
  if valid_579003 != nil:
    section.add "prettyPrint", valid_579003
  var valid_579004 = query.getOrDefault("oauth_token")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "oauth_token", valid_579004
  var valid_579005 = query.getOrDefault("alt")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = newJString("json"))
  if valid_579005 != nil:
    section.add "alt", valid_579005
  var valid_579006 = query.getOrDefault("userIp")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "userIp", valid_579006
  var valid_579007 = query.getOrDefault("quotaUser")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "quotaUser", valid_579007
  var valid_579008 = query.getOrDefault("builtinGameId")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "builtinGameId", valid_579008
  var valid_579009 = query.getOrDefault("fields")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "fields", valid_579009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579010: Call_GamesApplicationsPlayed_578999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicate that the the currently authenticated user is playing your application.
  ## 
  let valid = call_579010.validator(path, query, header, formData, body)
  let scheme = call_579010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579010.url(scheme.get, call_579010.host, call_579010.base,
                         call_579010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579010, url, valid)

proc call*(call_579011: Call_GamesApplicationsPlayed_578999; key: string = "";
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
  var query_579012 = newJObject()
  add(query_579012, "key", newJString(key))
  add(query_579012, "prettyPrint", newJBool(prettyPrint))
  add(query_579012, "oauth_token", newJString(oauthToken))
  add(query_579012, "alt", newJString(alt))
  add(query_579012, "userIp", newJString(userIp))
  add(query_579012, "quotaUser", newJString(quotaUser))
  add(query_579012, "builtinGameId", newJString(builtinGameId))
  add(query_579012, "fields", newJString(fields))
  result = call_579011.call(nil, query_579012, nil, nil, nil)

var gamesApplicationsPlayed* = Call_GamesApplicationsPlayed_578999(
    name: "gamesApplicationsPlayed", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/applications/played",
    validator: validate_GamesApplicationsPlayed_579000, base: "/games/v1",
    url: url_GamesApplicationsPlayed_579001, schemes: {Scheme.Https})
type
  Call_GamesApplicationsGet_579013 = ref object of OpenApiRestCall_578364
proc url_GamesApplicationsGet_579015(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesApplicationsGet_579014(path: JsonNode; query: JsonNode;
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
  var valid_579016 = path.getOrDefault("applicationId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "applicationId", valid_579016
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
  var valid_579017 = query.getOrDefault("key")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "key", valid_579017
  var valid_579018 = query.getOrDefault("prettyPrint")
  valid_579018 = validateParameter(valid_579018, JBool, required = false,
                                 default = newJBool(true))
  if valid_579018 != nil:
    section.add "prettyPrint", valid_579018
  var valid_579019 = query.getOrDefault("oauth_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "oauth_token", valid_579019
  var valid_579020 = query.getOrDefault("alt")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = newJString("json"))
  if valid_579020 != nil:
    section.add "alt", valid_579020
  var valid_579021 = query.getOrDefault("userIp")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "userIp", valid_579021
  var valid_579022 = query.getOrDefault("quotaUser")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "quotaUser", valid_579022
  var valid_579023 = query.getOrDefault("fields")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "fields", valid_579023
  var valid_579024 = query.getOrDefault("language")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "language", valid_579024
  var valid_579025 = query.getOrDefault("platformType")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = newJString("ANDROID"))
  if valid_579025 != nil:
    section.add "platformType", valid_579025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579026: Call_GamesApplicationsGet_579013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata of the application with the given ID. If the requested application is not available for the specified platformType, the returned response will not include any instance data.
  ## 
  let valid = call_579026.validator(path, query, header, formData, body)
  let scheme = call_579026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579026.url(scheme.get, call_579026.host, call_579026.base,
                         call_579026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579026, url, valid)

proc call*(call_579027: Call_GamesApplicationsGet_579013; applicationId: string;
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
  var path_579028 = newJObject()
  var query_579029 = newJObject()
  add(query_579029, "key", newJString(key))
  add(query_579029, "prettyPrint", newJBool(prettyPrint))
  add(query_579029, "oauth_token", newJString(oauthToken))
  add(query_579029, "alt", newJString(alt))
  add(query_579029, "userIp", newJString(userIp))
  add(query_579029, "quotaUser", newJString(quotaUser))
  add(query_579029, "fields", newJString(fields))
  add(query_579029, "language", newJString(language))
  add(query_579029, "platformType", newJString(platformType))
  add(path_579028, "applicationId", newJString(applicationId))
  result = call_579027.call(path_579028, query_579029, nil, nil, nil)

var gamesApplicationsGet* = Call_GamesApplicationsGet_579013(
    name: "gamesApplicationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}",
    validator: validate_GamesApplicationsGet_579014, base: "/games/v1",
    url: url_GamesApplicationsGet_579015, schemes: {Scheme.Https})
type
  Call_GamesApplicationsVerify_579030 = ref object of OpenApiRestCall_578364
proc url_GamesApplicationsVerify_579032(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesApplicationsVerify_579031(path: JsonNode; query: JsonNode;
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
  var valid_579033 = path.getOrDefault("applicationId")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = nil)
  if valid_579033 != nil:
    section.add "applicationId", valid_579033
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
  var valid_579034 = query.getOrDefault("key")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "key", valid_579034
  var valid_579035 = query.getOrDefault("prettyPrint")
  valid_579035 = validateParameter(valid_579035, JBool, required = false,
                                 default = newJBool(true))
  if valid_579035 != nil:
    section.add "prettyPrint", valid_579035
  var valid_579036 = query.getOrDefault("oauth_token")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "oauth_token", valid_579036
  var valid_579037 = query.getOrDefault("alt")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = newJString("json"))
  if valid_579037 != nil:
    section.add "alt", valid_579037
  var valid_579038 = query.getOrDefault("userIp")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "userIp", valid_579038
  var valid_579039 = query.getOrDefault("quotaUser")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "quotaUser", valid_579039
  var valid_579040 = query.getOrDefault("fields")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "fields", valid_579040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579041: Call_GamesApplicationsVerify_579030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies the auth token provided with this request is for the application with the specified ID, and returns the ID of the player it was granted for.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_GamesApplicationsVerify_579030; applicationId: string;
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
  var path_579043 = newJObject()
  var query_579044 = newJObject()
  add(query_579044, "key", newJString(key))
  add(query_579044, "prettyPrint", newJBool(prettyPrint))
  add(query_579044, "oauth_token", newJString(oauthToken))
  add(query_579044, "alt", newJString(alt))
  add(query_579044, "userIp", newJString(userIp))
  add(query_579044, "quotaUser", newJString(quotaUser))
  add(query_579044, "fields", newJString(fields))
  add(path_579043, "applicationId", newJString(applicationId))
  result = call_579042.call(path_579043, query_579044, nil, nil, nil)

var gamesApplicationsVerify* = Call_GamesApplicationsVerify_579030(
    name: "gamesApplicationsVerify", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}/verify",
    validator: validate_GamesApplicationsVerify_579031, base: "/games/v1",
    url: url_GamesApplicationsVerify_579032, schemes: {Scheme.Https})
type
  Call_GamesEventsListDefinitions_579045 = ref object of OpenApiRestCall_578364
proc url_GamesEventsListDefinitions_579047(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesEventsListDefinitions_579046(path: JsonNode; query: JsonNode;
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
  var valid_579048 = query.getOrDefault("key")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "key", valid_579048
  var valid_579049 = query.getOrDefault("prettyPrint")
  valid_579049 = validateParameter(valid_579049, JBool, required = false,
                                 default = newJBool(true))
  if valid_579049 != nil:
    section.add "prettyPrint", valid_579049
  var valid_579050 = query.getOrDefault("oauth_token")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "oauth_token", valid_579050
  var valid_579051 = query.getOrDefault("alt")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = newJString("json"))
  if valid_579051 != nil:
    section.add "alt", valid_579051
  var valid_579052 = query.getOrDefault("userIp")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "userIp", valid_579052
  var valid_579053 = query.getOrDefault("quotaUser")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "quotaUser", valid_579053
  var valid_579054 = query.getOrDefault("pageToken")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "pageToken", valid_579054
  var valid_579055 = query.getOrDefault("fields")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "fields", valid_579055
  var valid_579056 = query.getOrDefault("language")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "language", valid_579056
  var valid_579057 = query.getOrDefault("maxResults")
  valid_579057 = validateParameter(valid_579057, JInt, required = false, default = nil)
  if valid_579057 != nil:
    section.add "maxResults", valid_579057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579058: Call_GamesEventsListDefinitions_579045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the event definitions in this application.
  ## 
  let valid = call_579058.validator(path, query, header, formData, body)
  let scheme = call_579058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579058.url(scheme.get, call_579058.host, call_579058.base,
                         call_579058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579058, url, valid)

proc call*(call_579059: Call_GamesEventsListDefinitions_579045; key: string = "";
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
  var query_579060 = newJObject()
  add(query_579060, "key", newJString(key))
  add(query_579060, "prettyPrint", newJBool(prettyPrint))
  add(query_579060, "oauth_token", newJString(oauthToken))
  add(query_579060, "alt", newJString(alt))
  add(query_579060, "userIp", newJString(userIp))
  add(query_579060, "quotaUser", newJString(quotaUser))
  add(query_579060, "pageToken", newJString(pageToken))
  add(query_579060, "fields", newJString(fields))
  add(query_579060, "language", newJString(language))
  add(query_579060, "maxResults", newJInt(maxResults))
  result = call_579059.call(nil, query_579060, nil, nil, nil)

var gamesEventsListDefinitions* = Call_GamesEventsListDefinitions_579045(
    name: "gamesEventsListDefinitions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/eventDefinitions",
    validator: validate_GamesEventsListDefinitions_579046, base: "/games/v1",
    url: url_GamesEventsListDefinitions_579047, schemes: {Scheme.Https})
type
  Call_GamesEventsRecord_579077 = ref object of OpenApiRestCall_578364
proc url_GamesEventsRecord_579079(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesEventsRecord_579078(path: JsonNode; query: JsonNode;
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
  var valid_579080 = query.getOrDefault("key")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "key", valid_579080
  var valid_579081 = query.getOrDefault("prettyPrint")
  valid_579081 = validateParameter(valid_579081, JBool, required = false,
                                 default = newJBool(true))
  if valid_579081 != nil:
    section.add "prettyPrint", valid_579081
  var valid_579082 = query.getOrDefault("oauth_token")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "oauth_token", valid_579082
  var valid_579083 = query.getOrDefault("alt")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = newJString("json"))
  if valid_579083 != nil:
    section.add "alt", valid_579083
  var valid_579084 = query.getOrDefault("userIp")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "userIp", valid_579084
  var valid_579085 = query.getOrDefault("quotaUser")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "quotaUser", valid_579085
  var valid_579086 = query.getOrDefault("fields")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "fields", valid_579086
  var valid_579087 = query.getOrDefault("language")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "language", valid_579087
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

proc call*(call_579089: Call_GamesEventsRecord_579077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Records a batch of changes to the number of times events have occurred for the currently authenticated user of this application.
  ## 
  let valid = call_579089.validator(path, query, header, formData, body)
  let scheme = call_579089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579089.url(scheme.get, call_579089.host, call_579089.base,
                         call_579089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579089, url, valid)

proc call*(call_579090: Call_GamesEventsRecord_579077; key: string = "";
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
  var query_579091 = newJObject()
  var body_579092 = newJObject()
  add(query_579091, "key", newJString(key))
  add(query_579091, "prettyPrint", newJBool(prettyPrint))
  add(query_579091, "oauth_token", newJString(oauthToken))
  add(query_579091, "alt", newJString(alt))
  add(query_579091, "userIp", newJString(userIp))
  add(query_579091, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579092 = body
  add(query_579091, "fields", newJString(fields))
  add(query_579091, "language", newJString(language))
  result = call_579090.call(nil, query_579091, nil, nil, body_579092)

var gamesEventsRecord* = Call_GamesEventsRecord_579077(name: "gamesEventsRecord",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/events",
    validator: validate_GamesEventsRecord_579078, base: "/games/v1",
    url: url_GamesEventsRecord_579079, schemes: {Scheme.Https})
type
  Call_GamesEventsListByPlayer_579061 = ref object of OpenApiRestCall_578364
proc url_GamesEventsListByPlayer_579063(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesEventsListByPlayer_579062(path: JsonNode; query: JsonNode;
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
  var valid_579064 = query.getOrDefault("key")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "key", valid_579064
  var valid_579065 = query.getOrDefault("prettyPrint")
  valid_579065 = validateParameter(valid_579065, JBool, required = false,
                                 default = newJBool(true))
  if valid_579065 != nil:
    section.add "prettyPrint", valid_579065
  var valid_579066 = query.getOrDefault("oauth_token")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "oauth_token", valid_579066
  var valid_579067 = query.getOrDefault("alt")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = newJString("json"))
  if valid_579067 != nil:
    section.add "alt", valid_579067
  var valid_579068 = query.getOrDefault("userIp")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "userIp", valid_579068
  var valid_579069 = query.getOrDefault("quotaUser")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "quotaUser", valid_579069
  var valid_579070 = query.getOrDefault("pageToken")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "pageToken", valid_579070
  var valid_579071 = query.getOrDefault("fields")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "fields", valid_579071
  var valid_579072 = query.getOrDefault("language")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "language", valid_579072
  var valid_579073 = query.getOrDefault("maxResults")
  valid_579073 = validateParameter(valid_579073, JInt, required = false, default = nil)
  if valid_579073 != nil:
    section.add "maxResults", valid_579073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579074: Call_GamesEventsListByPlayer_579061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list showing the current progress on events in this application for the currently authenticated user.
  ## 
  let valid = call_579074.validator(path, query, header, formData, body)
  let scheme = call_579074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579074.url(scheme.get, call_579074.host, call_579074.base,
                         call_579074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579074, url, valid)

proc call*(call_579075: Call_GamesEventsListByPlayer_579061; key: string = "";
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
  var query_579076 = newJObject()
  add(query_579076, "key", newJString(key))
  add(query_579076, "prettyPrint", newJBool(prettyPrint))
  add(query_579076, "oauth_token", newJString(oauthToken))
  add(query_579076, "alt", newJString(alt))
  add(query_579076, "userIp", newJString(userIp))
  add(query_579076, "quotaUser", newJString(quotaUser))
  add(query_579076, "pageToken", newJString(pageToken))
  add(query_579076, "fields", newJString(fields))
  add(query_579076, "language", newJString(language))
  add(query_579076, "maxResults", newJInt(maxResults))
  result = call_579075.call(nil, query_579076, nil, nil, nil)

var gamesEventsListByPlayer* = Call_GamesEventsListByPlayer_579061(
    name: "gamesEventsListByPlayer", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/events",
    validator: validate_GamesEventsListByPlayer_579062, base: "/games/v1",
    url: url_GamesEventsListByPlayer_579063, schemes: {Scheme.Https})
type
  Call_GamesLeaderboardsList_579093 = ref object of OpenApiRestCall_578364
proc url_GamesLeaderboardsList_579095(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesLeaderboardsList_579094(path: JsonNode; query: JsonNode;
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
  var valid_579096 = query.getOrDefault("key")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "key", valid_579096
  var valid_579097 = query.getOrDefault("prettyPrint")
  valid_579097 = validateParameter(valid_579097, JBool, required = false,
                                 default = newJBool(true))
  if valid_579097 != nil:
    section.add "prettyPrint", valid_579097
  var valid_579098 = query.getOrDefault("oauth_token")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "oauth_token", valid_579098
  var valid_579099 = query.getOrDefault("alt")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = newJString("json"))
  if valid_579099 != nil:
    section.add "alt", valid_579099
  var valid_579100 = query.getOrDefault("userIp")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "userIp", valid_579100
  var valid_579101 = query.getOrDefault("quotaUser")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "quotaUser", valid_579101
  var valid_579102 = query.getOrDefault("pageToken")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "pageToken", valid_579102
  var valid_579103 = query.getOrDefault("fields")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "fields", valid_579103
  var valid_579104 = query.getOrDefault("language")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "language", valid_579104
  var valid_579105 = query.getOrDefault("maxResults")
  valid_579105 = validateParameter(valid_579105, JInt, required = false, default = nil)
  if valid_579105 != nil:
    section.add "maxResults", valid_579105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579106: Call_GamesLeaderboardsList_579093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the leaderboard metadata for your application.
  ## 
  let valid = call_579106.validator(path, query, header, formData, body)
  let scheme = call_579106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579106.url(scheme.get, call_579106.host, call_579106.base,
                         call_579106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579106, url, valid)

proc call*(call_579107: Call_GamesLeaderboardsList_579093; key: string = "";
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
  var query_579108 = newJObject()
  add(query_579108, "key", newJString(key))
  add(query_579108, "prettyPrint", newJBool(prettyPrint))
  add(query_579108, "oauth_token", newJString(oauthToken))
  add(query_579108, "alt", newJString(alt))
  add(query_579108, "userIp", newJString(userIp))
  add(query_579108, "quotaUser", newJString(quotaUser))
  add(query_579108, "pageToken", newJString(pageToken))
  add(query_579108, "fields", newJString(fields))
  add(query_579108, "language", newJString(language))
  add(query_579108, "maxResults", newJInt(maxResults))
  result = call_579107.call(nil, query_579108, nil, nil, nil)

var gamesLeaderboardsList* = Call_GamesLeaderboardsList_579093(
    name: "gamesLeaderboardsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/leaderboards",
    validator: validate_GamesLeaderboardsList_579094, base: "/games/v1",
    url: url_GamesLeaderboardsList_579095, schemes: {Scheme.Https})
type
  Call_GamesScoresSubmitMultiple_579109 = ref object of OpenApiRestCall_578364
proc url_GamesScoresSubmitMultiple_579111(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesScoresSubmitMultiple_579110(path: JsonNode; query: JsonNode;
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
  var valid_579112 = query.getOrDefault("key")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "key", valid_579112
  var valid_579113 = query.getOrDefault("prettyPrint")
  valid_579113 = validateParameter(valid_579113, JBool, required = false,
                                 default = newJBool(true))
  if valid_579113 != nil:
    section.add "prettyPrint", valid_579113
  var valid_579114 = query.getOrDefault("oauth_token")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "oauth_token", valid_579114
  var valid_579115 = query.getOrDefault("alt")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = newJString("json"))
  if valid_579115 != nil:
    section.add "alt", valid_579115
  var valid_579116 = query.getOrDefault("userIp")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "userIp", valid_579116
  var valid_579117 = query.getOrDefault("quotaUser")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "quotaUser", valid_579117
  var valid_579118 = query.getOrDefault("fields")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "fields", valid_579118
  var valid_579119 = query.getOrDefault("language")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "language", valid_579119
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

proc call*(call_579121: Call_GamesScoresSubmitMultiple_579109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits multiple scores to leaderboards.
  ## 
  let valid = call_579121.validator(path, query, header, formData, body)
  let scheme = call_579121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579121.url(scheme.get, call_579121.host, call_579121.base,
                         call_579121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579121, url, valid)

proc call*(call_579122: Call_GamesScoresSubmitMultiple_579109; key: string = "";
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
  var query_579123 = newJObject()
  var body_579124 = newJObject()
  add(query_579123, "key", newJString(key))
  add(query_579123, "prettyPrint", newJBool(prettyPrint))
  add(query_579123, "oauth_token", newJString(oauthToken))
  add(query_579123, "alt", newJString(alt))
  add(query_579123, "userIp", newJString(userIp))
  add(query_579123, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579124 = body
  add(query_579123, "fields", newJString(fields))
  add(query_579123, "language", newJString(language))
  result = call_579122.call(nil, query_579123, nil, nil, body_579124)

var gamesScoresSubmitMultiple* = Call_GamesScoresSubmitMultiple_579109(
    name: "gamesScoresSubmitMultiple", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/leaderboards/scores",
    validator: validate_GamesScoresSubmitMultiple_579110, base: "/games/v1",
    url: url_GamesScoresSubmitMultiple_579111, schemes: {Scheme.Https})
type
  Call_GamesLeaderboardsGet_579125 = ref object of OpenApiRestCall_578364
proc url_GamesLeaderboardsGet_579127(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesLeaderboardsGet_579126(path: JsonNode; query: JsonNode;
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
  var valid_579128 = path.getOrDefault("leaderboardId")
  valid_579128 = validateParameter(valid_579128, JString, required = true,
                                 default = nil)
  if valid_579128 != nil:
    section.add "leaderboardId", valid_579128
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
  var valid_579129 = query.getOrDefault("key")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "key", valid_579129
  var valid_579130 = query.getOrDefault("prettyPrint")
  valid_579130 = validateParameter(valid_579130, JBool, required = false,
                                 default = newJBool(true))
  if valid_579130 != nil:
    section.add "prettyPrint", valid_579130
  var valid_579131 = query.getOrDefault("oauth_token")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "oauth_token", valid_579131
  var valid_579132 = query.getOrDefault("alt")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = newJString("json"))
  if valid_579132 != nil:
    section.add "alt", valid_579132
  var valid_579133 = query.getOrDefault("userIp")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "userIp", valid_579133
  var valid_579134 = query.getOrDefault("quotaUser")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "quotaUser", valid_579134
  var valid_579135 = query.getOrDefault("fields")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "fields", valid_579135
  var valid_579136 = query.getOrDefault("language")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "language", valid_579136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579137: Call_GamesLeaderboardsGet_579125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata of the leaderboard with the given ID.
  ## 
  let valid = call_579137.validator(path, query, header, formData, body)
  let scheme = call_579137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579137.url(scheme.get, call_579137.host, call_579137.base,
                         call_579137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579137, url, valid)

proc call*(call_579138: Call_GamesLeaderboardsGet_579125; leaderboardId: string;
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
  var path_579139 = newJObject()
  var query_579140 = newJObject()
  add(query_579140, "key", newJString(key))
  add(query_579140, "prettyPrint", newJBool(prettyPrint))
  add(query_579140, "oauth_token", newJString(oauthToken))
  add(query_579140, "alt", newJString(alt))
  add(query_579140, "userIp", newJString(userIp))
  add(query_579140, "quotaUser", newJString(quotaUser))
  add(query_579140, "fields", newJString(fields))
  add(path_579139, "leaderboardId", newJString(leaderboardId))
  add(query_579140, "language", newJString(language))
  result = call_579138.call(path_579139, query_579140, nil, nil, nil)

var gamesLeaderboardsGet* = Call_GamesLeaderboardsGet_579125(
    name: "gamesLeaderboardsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesLeaderboardsGet_579126, base: "/games/v1",
    url: url_GamesLeaderboardsGet_579127, schemes: {Scheme.Https})
type
  Call_GamesScoresSubmit_579141 = ref object of OpenApiRestCall_578364
proc url_GamesScoresSubmit_579143(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesScoresSubmit_579142(path: JsonNode; query: JsonNode;
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
  var valid_579144 = path.getOrDefault("leaderboardId")
  valid_579144 = validateParameter(valid_579144, JString, required = true,
                                 default = nil)
  if valid_579144 != nil:
    section.add "leaderboardId", valid_579144
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
  var valid_579145 = query.getOrDefault("key")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "key", valid_579145
  var valid_579146 = query.getOrDefault("scoreTag")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "scoreTag", valid_579146
  var valid_579147 = query.getOrDefault("prettyPrint")
  valid_579147 = validateParameter(valid_579147, JBool, required = false,
                                 default = newJBool(true))
  if valid_579147 != nil:
    section.add "prettyPrint", valid_579147
  var valid_579148 = query.getOrDefault("oauth_token")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "oauth_token", valid_579148
  var valid_579149 = query.getOrDefault("alt")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = newJString("json"))
  if valid_579149 != nil:
    section.add "alt", valid_579149
  var valid_579150 = query.getOrDefault("userIp")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "userIp", valid_579150
  var valid_579151 = query.getOrDefault("quotaUser")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "quotaUser", valid_579151
  assert query != nil, "query argument is necessary due to required `score` field"
  var valid_579152 = query.getOrDefault("score")
  valid_579152 = validateParameter(valid_579152, JString, required = true,
                                 default = nil)
  if valid_579152 != nil:
    section.add "score", valid_579152
  var valid_579153 = query.getOrDefault("fields")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "fields", valid_579153
  var valid_579154 = query.getOrDefault("language")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "language", valid_579154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579155: Call_GamesScoresSubmit_579141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a score to the specified leaderboard.
  ## 
  let valid = call_579155.validator(path, query, header, formData, body)
  let scheme = call_579155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579155.url(scheme.get, call_579155.host, call_579155.base,
                         call_579155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579155, url, valid)

proc call*(call_579156: Call_GamesScoresSubmit_579141; score: string;
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
  var path_579157 = newJObject()
  var query_579158 = newJObject()
  add(query_579158, "key", newJString(key))
  add(query_579158, "scoreTag", newJString(scoreTag))
  add(query_579158, "prettyPrint", newJBool(prettyPrint))
  add(query_579158, "oauth_token", newJString(oauthToken))
  add(query_579158, "alt", newJString(alt))
  add(query_579158, "userIp", newJString(userIp))
  add(query_579158, "quotaUser", newJString(quotaUser))
  add(query_579158, "score", newJString(score))
  add(query_579158, "fields", newJString(fields))
  add(path_579157, "leaderboardId", newJString(leaderboardId))
  add(query_579158, "language", newJString(language))
  result = call_579156.call(path_579157, query_579158, nil, nil, nil)

var gamesScoresSubmit* = Call_GamesScoresSubmit_579141(name: "gamesScoresSubmit",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores",
    validator: validate_GamesScoresSubmit_579142, base: "/games/v1",
    url: url_GamesScoresSubmit_579143, schemes: {Scheme.Https})
type
  Call_GamesScoresList_579159 = ref object of OpenApiRestCall_578364
proc url_GamesScoresList_579161(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesScoresList_579160(path: JsonNode; query: JsonNode;
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
  var valid_579162 = path.getOrDefault("leaderboardId")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "leaderboardId", valid_579162
  var valid_579163 = path.getOrDefault("collection")
  valid_579163 = validateParameter(valid_579163, JString, required = true,
                                 default = newJString("PUBLIC"))
  if valid_579163 != nil:
    section.add "collection", valid_579163
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
  var valid_579164 = query.getOrDefault("key")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "key", valid_579164
  var valid_579165 = query.getOrDefault("prettyPrint")
  valid_579165 = validateParameter(valid_579165, JBool, required = false,
                                 default = newJBool(true))
  if valid_579165 != nil:
    section.add "prettyPrint", valid_579165
  var valid_579166 = query.getOrDefault("oauth_token")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "oauth_token", valid_579166
  var valid_579167 = query.getOrDefault("alt")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = newJString("json"))
  if valid_579167 != nil:
    section.add "alt", valid_579167
  var valid_579168 = query.getOrDefault("userIp")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "userIp", valid_579168
  var valid_579169 = query.getOrDefault("quotaUser")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "quotaUser", valid_579169
  var valid_579170 = query.getOrDefault("pageToken")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "pageToken", valid_579170
  var valid_579171 = query.getOrDefault("fields")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "fields", valid_579171
  assert query != nil,
        "query argument is necessary due to required `timeSpan` field"
  var valid_579172 = query.getOrDefault("timeSpan")
  valid_579172 = validateParameter(valid_579172, JString, required = true,
                                 default = newJString("ALL_TIME"))
  if valid_579172 != nil:
    section.add "timeSpan", valid_579172
  var valid_579173 = query.getOrDefault("language")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "language", valid_579173
  var valid_579174 = query.getOrDefault("maxResults")
  valid_579174 = validateParameter(valid_579174, JInt, required = false, default = nil)
  if valid_579174 != nil:
    section.add "maxResults", valid_579174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579175: Call_GamesScoresList_579159; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the scores in a leaderboard, starting from the top.
  ## 
  let valid = call_579175.validator(path, query, header, formData, body)
  let scheme = call_579175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579175.url(scheme.get, call_579175.host, call_579175.base,
                         call_579175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579175, url, valid)

proc call*(call_579176: Call_GamesScoresList_579159; leaderboardId: string;
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
  var path_579177 = newJObject()
  var query_579178 = newJObject()
  add(query_579178, "key", newJString(key))
  add(query_579178, "prettyPrint", newJBool(prettyPrint))
  add(query_579178, "oauth_token", newJString(oauthToken))
  add(query_579178, "alt", newJString(alt))
  add(query_579178, "userIp", newJString(userIp))
  add(query_579178, "quotaUser", newJString(quotaUser))
  add(query_579178, "pageToken", newJString(pageToken))
  add(query_579178, "fields", newJString(fields))
  add(path_579177, "leaderboardId", newJString(leaderboardId))
  add(query_579178, "timeSpan", newJString(timeSpan))
  add(path_579177, "collection", newJString(collection))
  add(query_579178, "language", newJString(language))
  add(query_579178, "maxResults", newJInt(maxResults))
  result = call_579176.call(path_579177, query_579178, nil, nil, nil)

var gamesScoresList* = Call_GamesScoresList_579159(name: "gamesScoresList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/{collection}",
    validator: validate_GamesScoresList_579160, base: "/games/v1",
    url: url_GamesScoresList_579161, schemes: {Scheme.Https})
type
  Call_GamesScoresListWindow_579179 = ref object of OpenApiRestCall_578364
proc url_GamesScoresListWindow_579181(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesScoresListWindow_579180(path: JsonNode; query: JsonNode;
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
  var valid_579182 = path.getOrDefault("leaderboardId")
  valid_579182 = validateParameter(valid_579182, JString, required = true,
                                 default = nil)
  if valid_579182 != nil:
    section.add "leaderboardId", valid_579182
  var valid_579183 = path.getOrDefault("collection")
  valid_579183 = validateParameter(valid_579183, JString, required = true,
                                 default = newJString("PUBLIC"))
  if valid_579183 != nil:
    section.add "collection", valid_579183
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
  var valid_579184 = query.getOrDefault("key")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "key", valid_579184
  var valid_579185 = query.getOrDefault("prettyPrint")
  valid_579185 = validateParameter(valid_579185, JBool, required = false,
                                 default = newJBool(true))
  if valid_579185 != nil:
    section.add "prettyPrint", valid_579185
  var valid_579186 = query.getOrDefault("oauth_token")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "oauth_token", valid_579186
  var valid_579187 = query.getOrDefault("resultsAbove")
  valid_579187 = validateParameter(valid_579187, JInt, required = false, default = nil)
  if valid_579187 != nil:
    section.add "resultsAbove", valid_579187
  var valid_579188 = query.getOrDefault("alt")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = newJString("json"))
  if valid_579188 != nil:
    section.add "alt", valid_579188
  var valid_579189 = query.getOrDefault("userIp")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "userIp", valid_579189
  var valid_579190 = query.getOrDefault("quotaUser")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "quotaUser", valid_579190
  var valid_579191 = query.getOrDefault("pageToken")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "pageToken", valid_579191
  var valid_579192 = query.getOrDefault("returnTopIfAbsent")
  valid_579192 = validateParameter(valid_579192, JBool, required = false, default = nil)
  if valid_579192 != nil:
    section.add "returnTopIfAbsent", valid_579192
  var valid_579193 = query.getOrDefault("fields")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "fields", valid_579193
  assert query != nil,
        "query argument is necessary due to required `timeSpan` field"
  var valid_579194 = query.getOrDefault("timeSpan")
  valid_579194 = validateParameter(valid_579194, JString, required = true,
                                 default = newJString("ALL_TIME"))
  if valid_579194 != nil:
    section.add "timeSpan", valid_579194
  var valid_579195 = query.getOrDefault("language")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "language", valid_579195
  var valid_579196 = query.getOrDefault("maxResults")
  valid_579196 = validateParameter(valid_579196, JInt, required = false, default = nil)
  if valid_579196 != nil:
    section.add "maxResults", valid_579196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579197: Call_GamesScoresListWindow_579179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the scores in a leaderboard around (and including) a player's score.
  ## 
  let valid = call_579197.validator(path, query, header, formData, body)
  let scheme = call_579197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579197.url(scheme.get, call_579197.host, call_579197.base,
                         call_579197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579197, url, valid)

proc call*(call_579198: Call_GamesScoresListWindow_579179; leaderboardId: string;
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
  var path_579199 = newJObject()
  var query_579200 = newJObject()
  add(query_579200, "key", newJString(key))
  add(query_579200, "prettyPrint", newJBool(prettyPrint))
  add(query_579200, "oauth_token", newJString(oauthToken))
  add(query_579200, "resultsAbove", newJInt(resultsAbove))
  add(query_579200, "alt", newJString(alt))
  add(query_579200, "userIp", newJString(userIp))
  add(query_579200, "quotaUser", newJString(quotaUser))
  add(query_579200, "pageToken", newJString(pageToken))
  add(query_579200, "returnTopIfAbsent", newJBool(returnTopIfAbsent))
  add(query_579200, "fields", newJString(fields))
  add(path_579199, "leaderboardId", newJString(leaderboardId))
  add(query_579200, "timeSpan", newJString(timeSpan))
  add(path_579199, "collection", newJString(collection))
  add(query_579200, "language", newJString(language))
  add(query_579200, "maxResults", newJInt(maxResults))
  result = call_579198.call(path_579199, query_579200, nil, nil, nil)

var gamesScoresListWindow* = Call_GamesScoresListWindow_579179(
    name: "gamesScoresListWindow", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/window/{collection}",
    validator: validate_GamesScoresListWindow_579180, base: "/games/v1",
    url: url_GamesScoresListWindow_579181, schemes: {Scheme.Https})
type
  Call_GamesMetagameGetMetagameConfig_579201 = ref object of OpenApiRestCall_578364
proc url_GamesMetagameGetMetagameConfig_579203(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesMetagameGetMetagameConfig_579202(path: JsonNode;
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
  var valid_579204 = query.getOrDefault("key")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "key", valid_579204
  var valid_579205 = query.getOrDefault("prettyPrint")
  valid_579205 = validateParameter(valid_579205, JBool, required = false,
                                 default = newJBool(true))
  if valid_579205 != nil:
    section.add "prettyPrint", valid_579205
  var valid_579206 = query.getOrDefault("oauth_token")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "oauth_token", valid_579206
  var valid_579207 = query.getOrDefault("alt")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = newJString("json"))
  if valid_579207 != nil:
    section.add "alt", valid_579207
  var valid_579208 = query.getOrDefault("userIp")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "userIp", valid_579208
  var valid_579209 = query.getOrDefault("quotaUser")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "quotaUser", valid_579209
  var valid_579210 = query.getOrDefault("fields")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "fields", valid_579210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579211: Call_GamesMetagameGetMetagameConfig_579201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the metagame configuration data for the calling application.
  ## 
  let valid = call_579211.validator(path, query, header, formData, body)
  let scheme = call_579211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579211.url(scheme.get, call_579211.host, call_579211.base,
                         call_579211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579211, url, valid)

proc call*(call_579212: Call_GamesMetagameGetMetagameConfig_579201;
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
  var query_579213 = newJObject()
  add(query_579213, "key", newJString(key))
  add(query_579213, "prettyPrint", newJBool(prettyPrint))
  add(query_579213, "oauth_token", newJString(oauthToken))
  add(query_579213, "alt", newJString(alt))
  add(query_579213, "userIp", newJString(userIp))
  add(query_579213, "quotaUser", newJString(quotaUser))
  add(query_579213, "fields", newJString(fields))
  result = call_579212.call(nil, query_579213, nil, nil, nil)

var gamesMetagameGetMetagameConfig* = Call_GamesMetagameGetMetagameConfig_579201(
    name: "gamesMetagameGetMetagameConfig", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metagameConfig",
    validator: validate_GamesMetagameGetMetagameConfig_579202, base: "/games/v1",
    url: url_GamesMetagameGetMetagameConfig_579203, schemes: {Scheme.Https})
type
  Call_GamesPlayersList_579214 = ref object of OpenApiRestCall_578364
proc url_GamesPlayersList_579216(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesPlayersList_579215(path: JsonNode; query: JsonNode;
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
  var valid_579217 = path.getOrDefault("collection")
  valid_579217 = validateParameter(valid_579217, JString, required = true,
                                 default = newJString("connected"))
  if valid_579217 != nil:
    section.add "collection", valid_579217
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
  var valid_579218 = query.getOrDefault("key")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "key", valid_579218
  var valid_579219 = query.getOrDefault("prettyPrint")
  valid_579219 = validateParameter(valid_579219, JBool, required = false,
                                 default = newJBool(true))
  if valid_579219 != nil:
    section.add "prettyPrint", valid_579219
  var valid_579220 = query.getOrDefault("oauth_token")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "oauth_token", valid_579220
  var valid_579221 = query.getOrDefault("alt")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = newJString("json"))
  if valid_579221 != nil:
    section.add "alt", valid_579221
  var valid_579222 = query.getOrDefault("userIp")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "userIp", valid_579222
  var valid_579223 = query.getOrDefault("quotaUser")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "quotaUser", valid_579223
  var valid_579224 = query.getOrDefault("pageToken")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "pageToken", valid_579224
  var valid_579225 = query.getOrDefault("fields")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "fields", valid_579225
  var valid_579226 = query.getOrDefault("language")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "language", valid_579226
  var valid_579227 = query.getOrDefault("maxResults")
  valid_579227 = validateParameter(valid_579227, JInt, required = false, default = nil)
  if valid_579227 != nil:
    section.add "maxResults", valid_579227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579228: Call_GamesPlayersList_579214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the collection of players for the currently authenticated user.
  ## 
  let valid = call_579228.validator(path, query, header, formData, body)
  let scheme = call_579228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579228.url(scheme.get, call_579228.host, call_579228.base,
                         call_579228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579228, url, valid)

proc call*(call_579229: Call_GamesPlayersList_579214; key: string = "";
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
  var path_579230 = newJObject()
  var query_579231 = newJObject()
  add(query_579231, "key", newJString(key))
  add(query_579231, "prettyPrint", newJBool(prettyPrint))
  add(query_579231, "oauth_token", newJString(oauthToken))
  add(query_579231, "alt", newJString(alt))
  add(query_579231, "userIp", newJString(userIp))
  add(query_579231, "quotaUser", newJString(quotaUser))
  add(query_579231, "pageToken", newJString(pageToken))
  add(query_579231, "fields", newJString(fields))
  add(path_579230, "collection", newJString(collection))
  add(query_579231, "language", newJString(language))
  add(query_579231, "maxResults", newJInt(maxResults))
  result = call_579229.call(path_579230, query_579231, nil, nil, nil)

var gamesPlayersList* = Call_GamesPlayersList_579214(name: "gamesPlayersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/me/players/{collection}",
    validator: validate_GamesPlayersList_579215, base: "/games/v1",
    url: url_GamesPlayersList_579216, schemes: {Scheme.Https})
type
  Call_GamesPlayersGet_579232 = ref object of OpenApiRestCall_578364
proc url_GamesPlayersGet_579234(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesPlayersGet_579233(path: JsonNode; query: JsonNode;
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
  var valid_579235 = path.getOrDefault("playerId")
  valid_579235 = validateParameter(valid_579235, JString, required = true,
                                 default = nil)
  if valid_579235 != nil:
    section.add "playerId", valid_579235
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
  var valid_579236 = query.getOrDefault("key")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "key", valid_579236
  var valid_579237 = query.getOrDefault("prettyPrint")
  valid_579237 = validateParameter(valid_579237, JBool, required = false,
                                 default = newJBool(true))
  if valid_579237 != nil:
    section.add "prettyPrint", valid_579237
  var valid_579238 = query.getOrDefault("oauth_token")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "oauth_token", valid_579238
  var valid_579239 = query.getOrDefault("alt")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = newJString("json"))
  if valid_579239 != nil:
    section.add "alt", valid_579239
  var valid_579240 = query.getOrDefault("userIp")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "userIp", valid_579240
  var valid_579241 = query.getOrDefault("quotaUser")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "quotaUser", valid_579241
  var valid_579242 = query.getOrDefault("fields")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "fields", valid_579242
  var valid_579243 = query.getOrDefault("language")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "language", valid_579243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579244: Call_GamesPlayersGet_579232; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the Player resource with the given ID. To retrieve the player for the currently authenticated user, set playerId to me.
  ## 
  let valid = call_579244.validator(path, query, header, formData, body)
  let scheme = call_579244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579244.url(scheme.get, call_579244.host, call_579244.base,
                         call_579244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579244, url, valid)

proc call*(call_579245: Call_GamesPlayersGet_579232; playerId: string;
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
  var path_579246 = newJObject()
  var query_579247 = newJObject()
  add(query_579247, "key", newJString(key))
  add(query_579247, "prettyPrint", newJBool(prettyPrint))
  add(query_579247, "oauth_token", newJString(oauthToken))
  add(path_579246, "playerId", newJString(playerId))
  add(query_579247, "alt", newJString(alt))
  add(query_579247, "userIp", newJString(userIp))
  add(query_579247, "quotaUser", newJString(quotaUser))
  add(query_579247, "fields", newJString(fields))
  add(query_579247, "language", newJString(language))
  result = call_579245.call(path_579246, query_579247, nil, nil, nil)

var gamesPlayersGet* = Call_GamesPlayersGet_579232(name: "gamesPlayersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/{playerId}", validator: validate_GamesPlayersGet_579233,
    base: "/games/v1", url: url_GamesPlayersGet_579234, schemes: {Scheme.Https})
type
  Call_GamesAchievementsList_579248 = ref object of OpenApiRestCall_578364
proc url_GamesAchievementsList_579250(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesAchievementsList_579249(path: JsonNode; query: JsonNode;
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
  var valid_579251 = path.getOrDefault("playerId")
  valid_579251 = validateParameter(valid_579251, JString, required = true,
                                 default = nil)
  if valid_579251 != nil:
    section.add "playerId", valid_579251
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
  var valid_579252 = query.getOrDefault("key")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "key", valid_579252
  var valid_579253 = query.getOrDefault("prettyPrint")
  valid_579253 = validateParameter(valid_579253, JBool, required = false,
                                 default = newJBool(true))
  if valid_579253 != nil:
    section.add "prettyPrint", valid_579253
  var valid_579254 = query.getOrDefault("oauth_token")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "oauth_token", valid_579254
  var valid_579255 = query.getOrDefault("state")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = newJString("ALL"))
  if valid_579255 != nil:
    section.add "state", valid_579255
  var valid_579256 = query.getOrDefault("alt")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = newJString("json"))
  if valid_579256 != nil:
    section.add "alt", valid_579256
  var valid_579257 = query.getOrDefault("userIp")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "userIp", valid_579257
  var valid_579258 = query.getOrDefault("quotaUser")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "quotaUser", valid_579258
  var valid_579259 = query.getOrDefault("pageToken")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "pageToken", valid_579259
  var valid_579260 = query.getOrDefault("fields")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "fields", valid_579260
  var valid_579261 = query.getOrDefault("language")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "language", valid_579261
  var valid_579262 = query.getOrDefault("maxResults")
  valid_579262 = validateParameter(valid_579262, JInt, required = false, default = nil)
  if valid_579262 != nil:
    section.add "maxResults", valid_579262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579263: Call_GamesAchievementsList_579248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the progress for all your application's achievements for the currently authenticated player.
  ## 
  let valid = call_579263.validator(path, query, header, formData, body)
  let scheme = call_579263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579263.url(scheme.get, call_579263.host, call_579263.base,
                         call_579263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579263, url, valid)

proc call*(call_579264: Call_GamesAchievementsList_579248; playerId: string;
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
  var path_579265 = newJObject()
  var query_579266 = newJObject()
  add(query_579266, "key", newJString(key))
  add(query_579266, "prettyPrint", newJBool(prettyPrint))
  add(query_579266, "oauth_token", newJString(oauthToken))
  add(query_579266, "state", newJString(state))
  add(path_579265, "playerId", newJString(playerId))
  add(query_579266, "alt", newJString(alt))
  add(query_579266, "userIp", newJString(userIp))
  add(query_579266, "quotaUser", newJString(quotaUser))
  add(query_579266, "pageToken", newJString(pageToken))
  add(query_579266, "fields", newJString(fields))
  add(query_579266, "language", newJString(language))
  add(query_579266, "maxResults", newJInt(maxResults))
  result = call_579264.call(path_579265, query_579266, nil, nil, nil)

var gamesAchievementsList* = Call_GamesAchievementsList_579248(
    name: "gamesAchievementsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/players/{playerId}/achievements",
    validator: validate_GamesAchievementsList_579249, base: "/games/v1",
    url: url_GamesAchievementsList_579250, schemes: {Scheme.Https})
type
  Call_GamesMetagameListCategoriesByPlayer_579267 = ref object of OpenApiRestCall_578364
proc url_GamesMetagameListCategoriesByPlayer_579269(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesMetagameListCategoriesByPlayer_579268(path: JsonNode;
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
  var valid_579270 = path.getOrDefault("playerId")
  valid_579270 = validateParameter(valid_579270, JString, required = true,
                                 default = nil)
  if valid_579270 != nil:
    section.add "playerId", valid_579270
  var valid_579271 = path.getOrDefault("collection")
  valid_579271 = validateParameter(valid_579271, JString, required = true,
                                 default = newJString("all"))
  if valid_579271 != nil:
    section.add "collection", valid_579271
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
  var valid_579272 = query.getOrDefault("key")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "key", valid_579272
  var valid_579273 = query.getOrDefault("prettyPrint")
  valid_579273 = validateParameter(valid_579273, JBool, required = false,
                                 default = newJBool(true))
  if valid_579273 != nil:
    section.add "prettyPrint", valid_579273
  var valid_579274 = query.getOrDefault("oauth_token")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "oauth_token", valid_579274
  var valid_579275 = query.getOrDefault("alt")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = newJString("json"))
  if valid_579275 != nil:
    section.add "alt", valid_579275
  var valid_579276 = query.getOrDefault("userIp")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "userIp", valid_579276
  var valid_579277 = query.getOrDefault("quotaUser")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "quotaUser", valid_579277
  var valid_579278 = query.getOrDefault("pageToken")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "pageToken", valid_579278
  var valid_579279 = query.getOrDefault("fields")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "fields", valid_579279
  var valid_579280 = query.getOrDefault("language")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "language", valid_579280
  var valid_579281 = query.getOrDefault("maxResults")
  valid_579281 = validateParameter(valid_579281, JInt, required = false, default = nil)
  if valid_579281 != nil:
    section.add "maxResults", valid_579281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579282: Call_GamesMetagameListCategoriesByPlayer_579267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List play data aggregated per category for the player corresponding to playerId.
  ## 
  let valid = call_579282.validator(path, query, header, formData, body)
  let scheme = call_579282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579282.url(scheme.get, call_579282.host, call_579282.base,
                         call_579282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579282, url, valid)

proc call*(call_579283: Call_GamesMetagameListCategoriesByPlayer_579267;
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
  var path_579284 = newJObject()
  var query_579285 = newJObject()
  add(query_579285, "key", newJString(key))
  add(query_579285, "prettyPrint", newJBool(prettyPrint))
  add(query_579285, "oauth_token", newJString(oauthToken))
  add(path_579284, "playerId", newJString(playerId))
  add(query_579285, "alt", newJString(alt))
  add(query_579285, "userIp", newJString(userIp))
  add(query_579285, "quotaUser", newJString(quotaUser))
  add(query_579285, "pageToken", newJString(pageToken))
  add(query_579285, "fields", newJString(fields))
  add(path_579284, "collection", newJString(collection))
  add(query_579285, "language", newJString(language))
  add(query_579285, "maxResults", newJInt(maxResults))
  result = call_579283.call(path_579284, query_579285, nil, nil, nil)

var gamesMetagameListCategoriesByPlayer* = Call_GamesMetagameListCategoriesByPlayer_579267(
    name: "gamesMetagameListCategoriesByPlayer", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/players/{playerId}/categories/{collection}",
    validator: validate_GamesMetagameListCategoriesByPlayer_579268,
    base: "/games/v1", url: url_GamesMetagameListCategoriesByPlayer_579269,
    schemes: {Scheme.Https})
type
  Call_GamesScoresGet_579286 = ref object of OpenApiRestCall_578364
proc url_GamesScoresGet_579288(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesScoresGet_579287(path: JsonNode; query: JsonNode;
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
  var valid_579289 = path.getOrDefault("playerId")
  valid_579289 = validateParameter(valid_579289, JString, required = true,
                                 default = nil)
  if valid_579289 != nil:
    section.add "playerId", valid_579289
  var valid_579290 = path.getOrDefault("timeSpan")
  valid_579290 = validateParameter(valid_579290, JString, required = true,
                                 default = newJString("ALL"))
  if valid_579290 != nil:
    section.add "timeSpan", valid_579290
  var valid_579291 = path.getOrDefault("leaderboardId")
  valid_579291 = validateParameter(valid_579291, JString, required = true,
                                 default = nil)
  if valid_579291 != nil:
    section.add "leaderboardId", valid_579291
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
  var valid_579292 = query.getOrDefault("key")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "key", valid_579292
  var valid_579293 = query.getOrDefault("prettyPrint")
  valid_579293 = validateParameter(valid_579293, JBool, required = false,
                                 default = newJBool(true))
  if valid_579293 != nil:
    section.add "prettyPrint", valid_579293
  var valid_579294 = query.getOrDefault("oauth_token")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "oauth_token", valid_579294
  var valid_579295 = query.getOrDefault("alt")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = newJString("json"))
  if valid_579295 != nil:
    section.add "alt", valid_579295
  var valid_579296 = query.getOrDefault("userIp")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "userIp", valid_579296
  var valid_579297 = query.getOrDefault("quotaUser")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "quotaUser", valid_579297
  var valid_579298 = query.getOrDefault("includeRankType")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = newJString("ALL"))
  if valid_579298 != nil:
    section.add "includeRankType", valid_579298
  var valid_579299 = query.getOrDefault("pageToken")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "pageToken", valid_579299
  var valid_579300 = query.getOrDefault("fields")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "fields", valid_579300
  var valid_579301 = query.getOrDefault("language")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "language", valid_579301
  var valid_579302 = query.getOrDefault("maxResults")
  valid_579302 = validateParameter(valid_579302, JInt, required = false, default = nil)
  if valid_579302 != nil:
    section.add "maxResults", valid_579302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579303: Call_GamesScoresGet_579286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get high scores, and optionally ranks, in leaderboards for the currently authenticated player. For a specific time span, leaderboardId can be set to ALL to retrieve data for all leaderboards in a given time span.
  ## NOTE: You cannot ask for 'ALL' leaderboards and 'ALL' timeSpans in the same request; only one parameter may be set to 'ALL'.
  ## 
  let valid = call_579303.validator(path, query, header, formData, body)
  let scheme = call_579303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579303.url(scheme.get, call_579303.host, call_579303.base,
                         call_579303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579303, url, valid)

proc call*(call_579304: Call_GamesScoresGet_579286; playerId: string;
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
  var path_579305 = newJObject()
  var query_579306 = newJObject()
  add(query_579306, "key", newJString(key))
  add(query_579306, "prettyPrint", newJBool(prettyPrint))
  add(query_579306, "oauth_token", newJString(oauthToken))
  add(path_579305, "playerId", newJString(playerId))
  add(query_579306, "alt", newJString(alt))
  add(query_579306, "userIp", newJString(userIp))
  add(path_579305, "timeSpan", newJString(timeSpan))
  add(query_579306, "quotaUser", newJString(quotaUser))
  add(query_579306, "includeRankType", newJString(includeRankType))
  add(query_579306, "pageToken", newJString(pageToken))
  add(query_579306, "fields", newJString(fields))
  add(path_579305, "leaderboardId", newJString(leaderboardId))
  add(query_579306, "language", newJString(language))
  add(query_579306, "maxResults", newJInt(maxResults))
  result = call_579304.call(path_579305, query_579306, nil, nil, nil)

var gamesScoresGet* = Call_GamesScoresGet_579286(name: "gamesScoresGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/players/{playerId}/leaderboards/{leaderboardId}/scores/{timeSpan}",
    validator: validate_GamesScoresGet_579287, base: "/games/v1",
    url: url_GamesScoresGet_579288, schemes: {Scheme.Https})
type
  Call_GamesQuestsList_579307 = ref object of OpenApiRestCall_578364
proc url_GamesQuestsList_579309(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "playerId" in path, "`playerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/players/"),
               (kind: VariableSegment, value: "playerId"),
               (kind: ConstantSegment, value: "/quests")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesQuestsList_579308(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get a list of quests for your application and the currently authenticated player.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   playerId: JString (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `playerId` field"
  var valid_579310 = path.getOrDefault("playerId")
  valid_579310 = validateParameter(valid_579310, JString, required = true,
                                 default = nil)
  if valid_579310 != nil:
    section.add "playerId", valid_579310
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
  ##             : The maximum number of quest resources to return in the response, used for paging. For any response, the actual number of quest resources returned may be less than the specified maxResults. Acceptable values are 1 to 50, inclusive. (Default: 50).
  section = newJObject()
  var valid_579311 = query.getOrDefault("key")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "key", valid_579311
  var valid_579312 = query.getOrDefault("prettyPrint")
  valid_579312 = validateParameter(valid_579312, JBool, required = false,
                                 default = newJBool(true))
  if valid_579312 != nil:
    section.add "prettyPrint", valid_579312
  var valid_579313 = query.getOrDefault("oauth_token")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "oauth_token", valid_579313
  var valid_579314 = query.getOrDefault("alt")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = newJString("json"))
  if valid_579314 != nil:
    section.add "alt", valid_579314
  var valid_579315 = query.getOrDefault("userIp")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "userIp", valid_579315
  var valid_579316 = query.getOrDefault("quotaUser")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "quotaUser", valid_579316
  var valid_579317 = query.getOrDefault("pageToken")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "pageToken", valid_579317
  var valid_579318 = query.getOrDefault("fields")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "fields", valid_579318
  var valid_579319 = query.getOrDefault("language")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "language", valid_579319
  var valid_579320 = query.getOrDefault("maxResults")
  valid_579320 = validateParameter(valid_579320, JInt, required = false, default = nil)
  if valid_579320 != nil:
    section.add "maxResults", valid_579320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579321: Call_GamesQuestsList_579307; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of quests for your application and the currently authenticated player.
  ## 
  let valid = call_579321.validator(path, query, header, formData, body)
  let scheme = call_579321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579321.url(scheme.get, call_579321.host, call_579321.base,
                         call_579321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579321, url, valid)

proc call*(call_579322: Call_GamesQuestsList_579307; playerId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; language: string = "";
          maxResults: int = 0): Recallable =
  ## gamesQuestsList
  ## Get a list of quests for your application and the currently authenticated player.
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
  ##             : The maximum number of quest resources to return in the response, used for paging. For any response, the actual number of quest resources returned may be less than the specified maxResults. Acceptable values are 1 to 50, inclusive. (Default: 50).
  var path_579323 = newJObject()
  var query_579324 = newJObject()
  add(query_579324, "key", newJString(key))
  add(query_579324, "prettyPrint", newJBool(prettyPrint))
  add(query_579324, "oauth_token", newJString(oauthToken))
  add(path_579323, "playerId", newJString(playerId))
  add(query_579324, "alt", newJString(alt))
  add(query_579324, "userIp", newJString(userIp))
  add(query_579324, "quotaUser", newJString(quotaUser))
  add(query_579324, "pageToken", newJString(pageToken))
  add(query_579324, "fields", newJString(fields))
  add(query_579324, "language", newJString(language))
  add(query_579324, "maxResults", newJInt(maxResults))
  result = call_579322.call(path_579323, query_579324, nil, nil, nil)

var gamesQuestsList* = Call_GamesQuestsList_579307(name: "gamesQuestsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/{playerId}/quests", validator: validate_GamesQuestsList_579308,
    base: "/games/v1", url: url_GamesQuestsList_579309, schemes: {Scheme.Https})
type
  Call_GamesSnapshotsList_579325 = ref object of OpenApiRestCall_578364
proc url_GamesSnapshotsList_579327(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesSnapshotsList_579326(path: JsonNode; query: JsonNode;
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
  var valid_579328 = path.getOrDefault("playerId")
  valid_579328 = validateParameter(valid_579328, JString, required = true,
                                 default = nil)
  if valid_579328 != nil:
    section.add "playerId", valid_579328
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
  var valid_579329 = query.getOrDefault("key")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = nil)
  if valid_579329 != nil:
    section.add "key", valid_579329
  var valid_579330 = query.getOrDefault("prettyPrint")
  valid_579330 = validateParameter(valid_579330, JBool, required = false,
                                 default = newJBool(true))
  if valid_579330 != nil:
    section.add "prettyPrint", valid_579330
  var valid_579331 = query.getOrDefault("oauth_token")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "oauth_token", valid_579331
  var valid_579332 = query.getOrDefault("alt")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = newJString("json"))
  if valid_579332 != nil:
    section.add "alt", valid_579332
  var valid_579333 = query.getOrDefault("userIp")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "userIp", valid_579333
  var valid_579334 = query.getOrDefault("quotaUser")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "quotaUser", valid_579334
  var valid_579335 = query.getOrDefault("pageToken")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "pageToken", valid_579335
  var valid_579336 = query.getOrDefault("fields")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "fields", valid_579336
  var valid_579337 = query.getOrDefault("language")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "language", valid_579337
  var valid_579338 = query.getOrDefault("maxResults")
  valid_579338 = validateParameter(valid_579338, JInt, required = false, default = nil)
  if valid_579338 != nil:
    section.add "maxResults", valid_579338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579339: Call_GamesSnapshotsList_579325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of snapshots created by your application for the player corresponding to the player ID.
  ## 
  let valid = call_579339.validator(path, query, header, formData, body)
  let scheme = call_579339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579339.url(scheme.get, call_579339.host, call_579339.base,
                         call_579339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579339, url, valid)

proc call*(call_579340: Call_GamesSnapshotsList_579325; playerId: string;
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
  var path_579341 = newJObject()
  var query_579342 = newJObject()
  add(query_579342, "key", newJString(key))
  add(query_579342, "prettyPrint", newJBool(prettyPrint))
  add(query_579342, "oauth_token", newJString(oauthToken))
  add(path_579341, "playerId", newJString(playerId))
  add(query_579342, "alt", newJString(alt))
  add(query_579342, "userIp", newJString(userIp))
  add(query_579342, "quotaUser", newJString(quotaUser))
  add(query_579342, "pageToken", newJString(pageToken))
  add(query_579342, "fields", newJString(fields))
  add(query_579342, "language", newJString(language))
  add(query_579342, "maxResults", newJInt(maxResults))
  result = call_579340.call(path_579341, query_579342, nil, nil, nil)

var gamesSnapshotsList* = Call_GamesSnapshotsList_579325(
    name: "gamesSnapshotsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/players/{playerId}/snapshots",
    validator: validate_GamesSnapshotsList_579326, base: "/games/v1",
    url: url_GamesSnapshotsList_579327, schemes: {Scheme.Https})
type
  Call_GamesPushtokensUpdate_579343 = ref object of OpenApiRestCall_578364
proc url_GamesPushtokensUpdate_579345(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesPushtokensUpdate_579344(path: JsonNode; query: JsonNode;
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
  var valid_579346 = query.getOrDefault("key")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "key", valid_579346
  var valid_579347 = query.getOrDefault("prettyPrint")
  valid_579347 = validateParameter(valid_579347, JBool, required = false,
                                 default = newJBool(true))
  if valid_579347 != nil:
    section.add "prettyPrint", valid_579347
  var valid_579348 = query.getOrDefault("oauth_token")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "oauth_token", valid_579348
  var valid_579349 = query.getOrDefault("alt")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = newJString("json"))
  if valid_579349 != nil:
    section.add "alt", valid_579349
  var valid_579350 = query.getOrDefault("userIp")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "userIp", valid_579350
  var valid_579351 = query.getOrDefault("quotaUser")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "quotaUser", valid_579351
  var valid_579352 = query.getOrDefault("fields")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "fields", valid_579352
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

proc call*(call_579354: Call_GamesPushtokensUpdate_579343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a push token for the current user and application.
  ## 
  let valid = call_579354.validator(path, query, header, formData, body)
  let scheme = call_579354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579354.url(scheme.get, call_579354.host, call_579354.base,
                         call_579354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579354, url, valid)

proc call*(call_579355: Call_GamesPushtokensUpdate_579343; key: string = "";
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
  var query_579356 = newJObject()
  var body_579357 = newJObject()
  add(query_579356, "key", newJString(key))
  add(query_579356, "prettyPrint", newJBool(prettyPrint))
  add(query_579356, "oauth_token", newJString(oauthToken))
  add(query_579356, "alt", newJString(alt))
  add(query_579356, "userIp", newJString(userIp))
  add(query_579356, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579357 = body
  add(query_579356, "fields", newJString(fields))
  result = call_579355.call(nil, query_579356, nil, nil, body_579357)

var gamesPushtokensUpdate* = Call_GamesPushtokensUpdate_579343(
    name: "gamesPushtokensUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/pushtokens",
    validator: validate_GamesPushtokensUpdate_579344, base: "/games/v1",
    url: url_GamesPushtokensUpdate_579345, schemes: {Scheme.Https})
type
  Call_GamesPushtokensRemove_579358 = ref object of OpenApiRestCall_578364
proc url_GamesPushtokensRemove_579360(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesPushtokensRemove_579359(path: JsonNode; query: JsonNode;
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
  var valid_579361 = query.getOrDefault("key")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "key", valid_579361
  var valid_579362 = query.getOrDefault("prettyPrint")
  valid_579362 = validateParameter(valid_579362, JBool, required = false,
                                 default = newJBool(true))
  if valid_579362 != nil:
    section.add "prettyPrint", valid_579362
  var valid_579363 = query.getOrDefault("oauth_token")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "oauth_token", valid_579363
  var valid_579364 = query.getOrDefault("alt")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = newJString("json"))
  if valid_579364 != nil:
    section.add "alt", valid_579364
  var valid_579365 = query.getOrDefault("userIp")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "userIp", valid_579365
  var valid_579366 = query.getOrDefault("quotaUser")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "quotaUser", valid_579366
  var valid_579367 = query.getOrDefault("fields")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "fields", valid_579367
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

proc call*(call_579369: Call_GamesPushtokensRemove_579358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a push token for the current user and application. Removing a non-existent push token will report success.
  ## 
  let valid = call_579369.validator(path, query, header, formData, body)
  let scheme = call_579369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579369.url(scheme.get, call_579369.host, call_579369.base,
                         call_579369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579369, url, valid)

proc call*(call_579370: Call_GamesPushtokensRemove_579358; key: string = "";
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
  var query_579371 = newJObject()
  var body_579372 = newJObject()
  add(query_579371, "key", newJString(key))
  add(query_579371, "prettyPrint", newJBool(prettyPrint))
  add(query_579371, "oauth_token", newJString(oauthToken))
  add(query_579371, "alt", newJString(alt))
  add(query_579371, "userIp", newJString(userIp))
  add(query_579371, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579372 = body
  add(query_579371, "fields", newJString(fields))
  result = call_579370.call(nil, query_579371, nil, nil, body_579372)

var gamesPushtokensRemove* = Call_GamesPushtokensRemove_579358(
    name: "gamesPushtokensRemove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pushtokens/remove",
    validator: validate_GamesPushtokensRemove_579359, base: "/games/v1",
    url: url_GamesPushtokensRemove_579360, schemes: {Scheme.Https})
type
  Call_GamesQuestsAccept_579373 = ref object of OpenApiRestCall_578364
proc url_GamesQuestsAccept_579375(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "questId" in path, "`questId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/quests/"),
               (kind: VariableSegment, value: "questId"),
               (kind: ConstantSegment, value: "/accept")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesQuestsAccept_579374(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Indicates that the currently authorized user will participate in the quest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   questId: JString (required)
  ##          : The ID of the quest.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `questId` field"
  var valid_579376 = path.getOrDefault("questId")
  valid_579376 = validateParameter(valid_579376, JString, required = true,
                                 default = nil)
  if valid_579376 != nil:
    section.add "questId", valid_579376
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
  var valid_579377 = query.getOrDefault("key")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "key", valid_579377
  var valid_579378 = query.getOrDefault("prettyPrint")
  valid_579378 = validateParameter(valid_579378, JBool, required = false,
                                 default = newJBool(true))
  if valid_579378 != nil:
    section.add "prettyPrint", valid_579378
  var valid_579379 = query.getOrDefault("oauth_token")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "oauth_token", valid_579379
  var valid_579380 = query.getOrDefault("alt")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = newJString("json"))
  if valid_579380 != nil:
    section.add "alt", valid_579380
  var valid_579381 = query.getOrDefault("userIp")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "userIp", valid_579381
  var valid_579382 = query.getOrDefault("quotaUser")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "quotaUser", valid_579382
  var valid_579383 = query.getOrDefault("fields")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "fields", valid_579383
  var valid_579384 = query.getOrDefault("language")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "language", valid_579384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579385: Call_GamesQuestsAccept_579373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates that the currently authorized user will participate in the quest.
  ## 
  let valid = call_579385.validator(path, query, header, formData, body)
  let scheme = call_579385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579385.url(scheme.get, call_579385.host, call_579385.base,
                         call_579385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579385, url, valid)

proc call*(call_579386: Call_GamesQuestsAccept_579373; questId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; language: string = ""): Recallable =
  ## gamesQuestsAccept
  ## Indicates that the currently authorized user will participate in the quest.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   questId: string (required)
  ##          : The ID of the quest.
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
  var path_579387 = newJObject()
  var query_579388 = newJObject()
  add(query_579388, "key", newJString(key))
  add(query_579388, "prettyPrint", newJBool(prettyPrint))
  add(query_579388, "oauth_token", newJString(oauthToken))
  add(path_579387, "questId", newJString(questId))
  add(query_579388, "alt", newJString(alt))
  add(query_579388, "userIp", newJString(userIp))
  add(query_579388, "quotaUser", newJString(quotaUser))
  add(query_579388, "fields", newJString(fields))
  add(query_579388, "language", newJString(language))
  result = call_579386.call(path_579387, query_579388, nil, nil, nil)

var gamesQuestsAccept* = Call_GamesQuestsAccept_579373(name: "gamesQuestsAccept",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/quests/{questId}/accept", validator: validate_GamesQuestsAccept_579374,
    base: "/games/v1", url: url_GamesQuestsAccept_579375, schemes: {Scheme.Https})
type
  Call_GamesQuestMilestonesClaim_579389 = ref object of OpenApiRestCall_578364
proc url_GamesQuestMilestonesClaim_579391(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "questId" in path, "`questId` is a required path parameter"
  assert "milestoneId" in path, "`milestoneId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/quests/"),
               (kind: VariableSegment, value: "questId"),
               (kind: ConstantSegment, value: "/milestones/"),
               (kind: VariableSegment, value: "milestoneId"),
               (kind: ConstantSegment, value: "/claim")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesQuestMilestonesClaim_579390(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Report that a reward for the milestone corresponding to milestoneId for the quest corresponding to questId has been claimed by the currently authorized user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   questId: JString (required)
  ##          : The ID of the quest.
  ##   milestoneId: JString (required)
  ##              : The ID of the milestone.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `questId` field"
  var valid_579392 = path.getOrDefault("questId")
  valid_579392 = validateParameter(valid_579392, JString, required = true,
                                 default = nil)
  if valid_579392 != nil:
    section.add "questId", valid_579392
  var valid_579393 = path.getOrDefault("milestoneId")
  valid_579393 = validateParameter(valid_579393, JString, required = true,
                                 default = nil)
  if valid_579393 != nil:
    section.add "milestoneId", valid_579393
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
  ##   requestId: JString (required)
  ##            : A numeric ID to ensure that the request is handled correctly across retries. Your client application must generate this ID randomly.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579394 = query.getOrDefault("key")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "key", valid_579394
  var valid_579395 = query.getOrDefault("prettyPrint")
  valid_579395 = validateParameter(valid_579395, JBool, required = false,
                                 default = newJBool(true))
  if valid_579395 != nil:
    section.add "prettyPrint", valid_579395
  var valid_579396 = query.getOrDefault("oauth_token")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "oauth_token", valid_579396
  var valid_579397 = query.getOrDefault("alt")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = newJString("json"))
  if valid_579397 != nil:
    section.add "alt", valid_579397
  var valid_579398 = query.getOrDefault("userIp")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = nil)
  if valid_579398 != nil:
    section.add "userIp", valid_579398
  var valid_579399 = query.getOrDefault("quotaUser")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "quotaUser", valid_579399
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_579400 = query.getOrDefault("requestId")
  valid_579400 = validateParameter(valid_579400, JString, required = true,
                                 default = nil)
  if valid_579400 != nil:
    section.add "requestId", valid_579400
  var valid_579401 = query.getOrDefault("fields")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "fields", valid_579401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579402: Call_GamesQuestMilestonesClaim_579389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report that a reward for the milestone corresponding to milestoneId for the quest corresponding to questId has been claimed by the currently authorized user.
  ## 
  let valid = call_579402.validator(path, query, header, formData, body)
  let scheme = call_579402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579402.url(scheme.get, call_579402.host, call_579402.base,
                         call_579402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579402, url, valid)

proc call*(call_579403: Call_GamesQuestMilestonesClaim_579389; questId: string;
          milestoneId: string; requestId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesQuestMilestonesClaim
  ## Report that a reward for the milestone corresponding to milestoneId for the quest corresponding to questId has been claimed by the currently authorized user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   questId: string (required)
  ##          : The ID of the quest.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   milestoneId: string (required)
  ##              : The ID of the milestone.
  ##   requestId: string (required)
  ##            : A numeric ID to ensure that the request is handled correctly across retries. Your client application must generate this ID randomly.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579404 = newJObject()
  var query_579405 = newJObject()
  add(query_579405, "key", newJString(key))
  add(query_579405, "prettyPrint", newJBool(prettyPrint))
  add(query_579405, "oauth_token", newJString(oauthToken))
  add(path_579404, "questId", newJString(questId))
  add(query_579405, "alt", newJString(alt))
  add(query_579405, "userIp", newJString(userIp))
  add(query_579405, "quotaUser", newJString(quotaUser))
  add(path_579404, "milestoneId", newJString(milestoneId))
  add(query_579405, "requestId", newJString(requestId))
  add(query_579405, "fields", newJString(fields))
  result = call_579403.call(path_579404, query_579405, nil, nil, nil)

var gamesQuestMilestonesClaim* = Call_GamesQuestMilestonesClaim_579389(
    name: "gamesQuestMilestonesClaim", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/quests/{questId}/milestones/{milestoneId}/claim",
    validator: validate_GamesQuestMilestonesClaim_579390, base: "/games/v1",
    url: url_GamesQuestMilestonesClaim_579391, schemes: {Scheme.Https})
type
  Call_GamesRevisionsCheck_579406 = ref object of OpenApiRestCall_578364
proc url_GamesRevisionsCheck_579408(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesRevisionsCheck_579407(path: JsonNode; query: JsonNode;
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
  var valid_579409 = query.getOrDefault("key")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "key", valid_579409
  var valid_579410 = query.getOrDefault("prettyPrint")
  valid_579410 = validateParameter(valid_579410, JBool, required = false,
                                 default = newJBool(true))
  if valid_579410 != nil:
    section.add "prettyPrint", valid_579410
  var valid_579411 = query.getOrDefault("oauth_token")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "oauth_token", valid_579411
  assert query != nil,
        "query argument is necessary due to required `clientRevision` field"
  var valid_579412 = query.getOrDefault("clientRevision")
  valid_579412 = validateParameter(valid_579412, JString, required = true,
                                 default = nil)
  if valid_579412 != nil:
    section.add "clientRevision", valid_579412
  var valid_579413 = query.getOrDefault("alt")
  valid_579413 = validateParameter(valid_579413, JString, required = false,
                                 default = newJString("json"))
  if valid_579413 != nil:
    section.add "alt", valid_579413
  var valid_579414 = query.getOrDefault("userIp")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = nil)
  if valid_579414 != nil:
    section.add "userIp", valid_579414
  var valid_579415 = query.getOrDefault("quotaUser")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = nil)
  if valid_579415 != nil:
    section.add "quotaUser", valid_579415
  var valid_579416 = query.getOrDefault("fields")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "fields", valid_579416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579417: Call_GamesRevisionsCheck_579406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the games client is out of date.
  ## 
  let valid = call_579417.validator(path, query, header, formData, body)
  let scheme = call_579417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579417.url(scheme.get, call_579417.host, call_579417.base,
                         call_579417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579417, url, valid)

proc call*(call_579418: Call_GamesRevisionsCheck_579406; clientRevision: string;
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
  var query_579419 = newJObject()
  add(query_579419, "key", newJString(key))
  add(query_579419, "prettyPrint", newJBool(prettyPrint))
  add(query_579419, "oauth_token", newJString(oauthToken))
  add(query_579419, "clientRevision", newJString(clientRevision))
  add(query_579419, "alt", newJString(alt))
  add(query_579419, "userIp", newJString(userIp))
  add(query_579419, "quotaUser", newJString(quotaUser))
  add(query_579419, "fields", newJString(fields))
  result = call_579418.call(nil, query_579419, nil, nil, nil)

var gamesRevisionsCheck* = Call_GamesRevisionsCheck_579406(
    name: "gamesRevisionsCheck", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/revisions/check",
    validator: validate_GamesRevisionsCheck_579407, base: "/games/v1",
    url: url_GamesRevisionsCheck_579408, schemes: {Scheme.Https})
type
  Call_GamesRoomsList_579420 = ref object of OpenApiRestCall_578364
proc url_GamesRoomsList_579422(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesRoomsList_579421(path: JsonNode; query: JsonNode;
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
  var valid_579423 = query.getOrDefault("key")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "key", valid_579423
  var valid_579424 = query.getOrDefault("prettyPrint")
  valid_579424 = validateParameter(valid_579424, JBool, required = false,
                                 default = newJBool(true))
  if valid_579424 != nil:
    section.add "prettyPrint", valid_579424
  var valid_579425 = query.getOrDefault("oauth_token")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "oauth_token", valid_579425
  var valid_579426 = query.getOrDefault("alt")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = newJString("json"))
  if valid_579426 != nil:
    section.add "alt", valid_579426
  var valid_579427 = query.getOrDefault("userIp")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "userIp", valid_579427
  var valid_579428 = query.getOrDefault("quotaUser")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "quotaUser", valid_579428
  var valid_579429 = query.getOrDefault("pageToken")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "pageToken", valid_579429
  var valid_579430 = query.getOrDefault("fields")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = nil)
  if valid_579430 != nil:
    section.add "fields", valid_579430
  var valid_579431 = query.getOrDefault("language")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "language", valid_579431
  var valid_579432 = query.getOrDefault("maxResults")
  valid_579432 = validateParameter(valid_579432, JInt, required = false, default = nil)
  if valid_579432 != nil:
    section.add "maxResults", valid_579432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579433: Call_GamesRoomsList_579420; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns invitations to join rooms.
  ## 
  let valid = call_579433.validator(path, query, header, formData, body)
  let scheme = call_579433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579433.url(scheme.get, call_579433.host, call_579433.base,
                         call_579433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579433, url, valid)

proc call*(call_579434: Call_GamesRoomsList_579420; key: string = "";
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
  var query_579435 = newJObject()
  add(query_579435, "key", newJString(key))
  add(query_579435, "prettyPrint", newJBool(prettyPrint))
  add(query_579435, "oauth_token", newJString(oauthToken))
  add(query_579435, "alt", newJString(alt))
  add(query_579435, "userIp", newJString(userIp))
  add(query_579435, "quotaUser", newJString(quotaUser))
  add(query_579435, "pageToken", newJString(pageToken))
  add(query_579435, "fields", newJString(fields))
  add(query_579435, "language", newJString(language))
  add(query_579435, "maxResults", newJInt(maxResults))
  result = call_579434.call(nil, query_579435, nil, nil, nil)

var gamesRoomsList* = Call_GamesRoomsList_579420(name: "gamesRoomsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/rooms",
    validator: validate_GamesRoomsList_579421, base: "/games/v1",
    url: url_GamesRoomsList_579422, schemes: {Scheme.Https})
type
  Call_GamesRoomsCreate_579436 = ref object of OpenApiRestCall_578364
proc url_GamesRoomsCreate_579438(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesRoomsCreate_579437(path: JsonNode; query: JsonNode;
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
  var valid_579439 = query.getOrDefault("key")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "key", valid_579439
  var valid_579440 = query.getOrDefault("prettyPrint")
  valid_579440 = validateParameter(valid_579440, JBool, required = false,
                                 default = newJBool(true))
  if valid_579440 != nil:
    section.add "prettyPrint", valid_579440
  var valid_579441 = query.getOrDefault("oauth_token")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "oauth_token", valid_579441
  var valid_579442 = query.getOrDefault("alt")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = newJString("json"))
  if valid_579442 != nil:
    section.add "alt", valid_579442
  var valid_579443 = query.getOrDefault("userIp")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "userIp", valid_579443
  var valid_579444 = query.getOrDefault("quotaUser")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "quotaUser", valid_579444
  var valid_579445 = query.getOrDefault("fields")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "fields", valid_579445
  var valid_579446 = query.getOrDefault("language")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "language", valid_579446
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

proc call*(call_579448: Call_GamesRoomsCreate_579436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_579448.validator(path, query, header, formData, body)
  let scheme = call_579448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579448.url(scheme.get, call_579448.host, call_579448.base,
                         call_579448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579448, url, valid)

proc call*(call_579449: Call_GamesRoomsCreate_579436; key: string = "";
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
  var query_579450 = newJObject()
  var body_579451 = newJObject()
  add(query_579450, "key", newJString(key))
  add(query_579450, "prettyPrint", newJBool(prettyPrint))
  add(query_579450, "oauth_token", newJString(oauthToken))
  add(query_579450, "alt", newJString(alt))
  add(query_579450, "userIp", newJString(userIp))
  add(query_579450, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579451 = body
  add(query_579450, "fields", newJString(fields))
  add(query_579450, "language", newJString(language))
  result = call_579449.call(nil, query_579450, nil, nil, body_579451)

var gamesRoomsCreate* = Call_GamesRoomsCreate_579436(name: "gamesRoomsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/rooms/create",
    validator: validate_GamesRoomsCreate_579437, base: "/games/v1",
    url: url_GamesRoomsCreate_579438, schemes: {Scheme.Https})
type
  Call_GamesRoomsGet_579452 = ref object of OpenApiRestCall_578364
proc url_GamesRoomsGet_579454(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesRoomsGet_579453(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579455 = path.getOrDefault("roomId")
  valid_579455 = validateParameter(valid_579455, JString, required = true,
                                 default = nil)
  if valid_579455 != nil:
    section.add "roomId", valid_579455
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
  var valid_579456 = query.getOrDefault("key")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = nil)
  if valid_579456 != nil:
    section.add "key", valid_579456
  var valid_579457 = query.getOrDefault("prettyPrint")
  valid_579457 = validateParameter(valid_579457, JBool, required = false,
                                 default = newJBool(true))
  if valid_579457 != nil:
    section.add "prettyPrint", valid_579457
  var valid_579458 = query.getOrDefault("oauth_token")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "oauth_token", valid_579458
  var valid_579459 = query.getOrDefault("alt")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = newJString("json"))
  if valid_579459 != nil:
    section.add "alt", valid_579459
  var valid_579460 = query.getOrDefault("userIp")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "userIp", valid_579460
  var valid_579461 = query.getOrDefault("quotaUser")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "quotaUser", valid_579461
  var valid_579462 = query.getOrDefault("fields")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "fields", valid_579462
  var valid_579463 = query.getOrDefault("language")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "language", valid_579463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579464: Call_GamesRoomsGet_579452; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the data for a room.
  ## 
  let valid = call_579464.validator(path, query, header, formData, body)
  let scheme = call_579464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579464.url(scheme.get, call_579464.host, call_579464.base,
                         call_579464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579464, url, valid)

proc call*(call_579465: Call_GamesRoomsGet_579452; roomId: string; key: string = "";
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
  var path_579466 = newJObject()
  var query_579467 = newJObject()
  add(query_579467, "key", newJString(key))
  add(query_579467, "prettyPrint", newJBool(prettyPrint))
  add(query_579467, "oauth_token", newJString(oauthToken))
  add(query_579467, "alt", newJString(alt))
  add(query_579467, "userIp", newJString(userIp))
  add(query_579467, "quotaUser", newJString(quotaUser))
  add(path_579466, "roomId", newJString(roomId))
  add(query_579467, "fields", newJString(fields))
  add(query_579467, "language", newJString(language))
  result = call_579465.call(path_579466, query_579467, nil, nil, nil)

var gamesRoomsGet* = Call_GamesRoomsGet_579452(name: "gamesRoomsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/rooms/{roomId}",
    validator: validate_GamesRoomsGet_579453, base: "/games/v1",
    url: url_GamesRoomsGet_579454, schemes: {Scheme.Https})
type
  Call_GamesRoomsDecline_579468 = ref object of OpenApiRestCall_578364
proc url_GamesRoomsDecline_579470(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesRoomsDecline_579469(path: JsonNode; query: JsonNode;
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
  var valid_579471 = path.getOrDefault("roomId")
  valid_579471 = validateParameter(valid_579471, JString, required = true,
                                 default = nil)
  if valid_579471 != nil:
    section.add "roomId", valid_579471
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
  var valid_579472 = query.getOrDefault("key")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "key", valid_579472
  var valid_579473 = query.getOrDefault("prettyPrint")
  valid_579473 = validateParameter(valid_579473, JBool, required = false,
                                 default = newJBool(true))
  if valid_579473 != nil:
    section.add "prettyPrint", valid_579473
  var valid_579474 = query.getOrDefault("oauth_token")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "oauth_token", valid_579474
  var valid_579475 = query.getOrDefault("alt")
  valid_579475 = validateParameter(valid_579475, JString, required = false,
                                 default = newJString("json"))
  if valid_579475 != nil:
    section.add "alt", valid_579475
  var valid_579476 = query.getOrDefault("userIp")
  valid_579476 = validateParameter(valid_579476, JString, required = false,
                                 default = nil)
  if valid_579476 != nil:
    section.add "userIp", valid_579476
  var valid_579477 = query.getOrDefault("quotaUser")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "quotaUser", valid_579477
  var valid_579478 = query.getOrDefault("fields")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = nil)
  if valid_579478 != nil:
    section.add "fields", valid_579478
  var valid_579479 = query.getOrDefault("language")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "language", valid_579479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579480: Call_GamesRoomsDecline_579468; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decline an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_579480.validator(path, query, header, formData, body)
  let scheme = call_579480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579480.url(scheme.get, call_579480.host, call_579480.base,
                         call_579480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579480, url, valid)

proc call*(call_579481: Call_GamesRoomsDecline_579468; roomId: string;
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
  var path_579482 = newJObject()
  var query_579483 = newJObject()
  add(query_579483, "key", newJString(key))
  add(query_579483, "prettyPrint", newJBool(prettyPrint))
  add(query_579483, "oauth_token", newJString(oauthToken))
  add(query_579483, "alt", newJString(alt))
  add(query_579483, "userIp", newJString(userIp))
  add(query_579483, "quotaUser", newJString(quotaUser))
  add(path_579482, "roomId", newJString(roomId))
  add(query_579483, "fields", newJString(fields))
  add(query_579483, "language", newJString(language))
  result = call_579481.call(path_579482, query_579483, nil, nil, nil)

var gamesRoomsDecline* = Call_GamesRoomsDecline_579468(name: "gamesRoomsDecline",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/decline", validator: validate_GamesRoomsDecline_579469,
    base: "/games/v1", url: url_GamesRoomsDecline_579470, schemes: {Scheme.Https})
type
  Call_GamesRoomsDismiss_579484 = ref object of OpenApiRestCall_578364
proc url_GamesRoomsDismiss_579486(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesRoomsDismiss_579485(path: JsonNode; query: JsonNode;
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
  var valid_579487 = path.getOrDefault("roomId")
  valid_579487 = validateParameter(valid_579487, JString, required = true,
                                 default = nil)
  if valid_579487 != nil:
    section.add "roomId", valid_579487
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
  var valid_579488 = query.getOrDefault("key")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "key", valid_579488
  var valid_579489 = query.getOrDefault("prettyPrint")
  valid_579489 = validateParameter(valid_579489, JBool, required = false,
                                 default = newJBool(true))
  if valid_579489 != nil:
    section.add "prettyPrint", valid_579489
  var valid_579490 = query.getOrDefault("oauth_token")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "oauth_token", valid_579490
  var valid_579491 = query.getOrDefault("alt")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = newJString("json"))
  if valid_579491 != nil:
    section.add "alt", valid_579491
  var valid_579492 = query.getOrDefault("userIp")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = nil)
  if valid_579492 != nil:
    section.add "userIp", valid_579492
  var valid_579493 = query.getOrDefault("quotaUser")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "quotaUser", valid_579493
  var valid_579494 = query.getOrDefault("fields")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "fields", valid_579494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579495: Call_GamesRoomsDismiss_579484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_579495.validator(path, query, header, formData, body)
  let scheme = call_579495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579495.url(scheme.get, call_579495.host, call_579495.base,
                         call_579495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579495, url, valid)

proc call*(call_579496: Call_GamesRoomsDismiss_579484; roomId: string;
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
  var path_579497 = newJObject()
  var query_579498 = newJObject()
  add(query_579498, "key", newJString(key))
  add(query_579498, "prettyPrint", newJBool(prettyPrint))
  add(query_579498, "oauth_token", newJString(oauthToken))
  add(query_579498, "alt", newJString(alt))
  add(query_579498, "userIp", newJString(userIp))
  add(query_579498, "quotaUser", newJString(quotaUser))
  add(path_579497, "roomId", newJString(roomId))
  add(query_579498, "fields", newJString(fields))
  result = call_579496.call(path_579497, query_579498, nil, nil, nil)

var gamesRoomsDismiss* = Call_GamesRoomsDismiss_579484(name: "gamesRoomsDismiss",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/dismiss", validator: validate_GamesRoomsDismiss_579485,
    base: "/games/v1", url: url_GamesRoomsDismiss_579486, schemes: {Scheme.Https})
type
  Call_GamesRoomsJoin_579499 = ref object of OpenApiRestCall_578364
proc url_GamesRoomsJoin_579501(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesRoomsJoin_579500(path: JsonNode; query: JsonNode;
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
  var valid_579502 = path.getOrDefault("roomId")
  valid_579502 = validateParameter(valid_579502, JString, required = true,
                                 default = nil)
  if valid_579502 != nil:
    section.add "roomId", valid_579502
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
  var valid_579503 = query.getOrDefault("key")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = nil)
  if valid_579503 != nil:
    section.add "key", valid_579503
  var valid_579504 = query.getOrDefault("prettyPrint")
  valid_579504 = validateParameter(valid_579504, JBool, required = false,
                                 default = newJBool(true))
  if valid_579504 != nil:
    section.add "prettyPrint", valid_579504
  var valid_579505 = query.getOrDefault("oauth_token")
  valid_579505 = validateParameter(valid_579505, JString, required = false,
                                 default = nil)
  if valid_579505 != nil:
    section.add "oauth_token", valid_579505
  var valid_579506 = query.getOrDefault("alt")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = newJString("json"))
  if valid_579506 != nil:
    section.add "alt", valid_579506
  var valid_579507 = query.getOrDefault("userIp")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "userIp", valid_579507
  var valid_579508 = query.getOrDefault("quotaUser")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "quotaUser", valid_579508
  var valid_579509 = query.getOrDefault("fields")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "fields", valid_579509
  var valid_579510 = query.getOrDefault("language")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "language", valid_579510
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

proc call*(call_579512: Call_GamesRoomsJoin_579499; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_579512.validator(path, query, header, formData, body)
  let scheme = call_579512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579512.url(scheme.get, call_579512.host, call_579512.base,
                         call_579512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579512, url, valid)

proc call*(call_579513: Call_GamesRoomsJoin_579499; roomId: string; key: string = "";
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
  var path_579514 = newJObject()
  var query_579515 = newJObject()
  var body_579516 = newJObject()
  add(query_579515, "key", newJString(key))
  add(query_579515, "prettyPrint", newJBool(prettyPrint))
  add(query_579515, "oauth_token", newJString(oauthToken))
  add(query_579515, "alt", newJString(alt))
  add(query_579515, "userIp", newJString(userIp))
  add(query_579515, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579516 = body
  add(path_579514, "roomId", newJString(roomId))
  add(query_579515, "fields", newJString(fields))
  add(query_579515, "language", newJString(language))
  result = call_579513.call(path_579514, query_579515, nil, nil, body_579516)

var gamesRoomsJoin* = Call_GamesRoomsJoin_579499(name: "gamesRoomsJoin",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/join", validator: validate_GamesRoomsJoin_579500,
    base: "/games/v1", url: url_GamesRoomsJoin_579501, schemes: {Scheme.Https})
type
  Call_GamesRoomsLeave_579517 = ref object of OpenApiRestCall_578364
proc url_GamesRoomsLeave_579519(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesRoomsLeave_579518(path: JsonNode; query: JsonNode;
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
  var valid_579520 = path.getOrDefault("roomId")
  valid_579520 = validateParameter(valid_579520, JString, required = true,
                                 default = nil)
  if valid_579520 != nil:
    section.add "roomId", valid_579520
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
  var valid_579521 = query.getOrDefault("key")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "key", valid_579521
  var valid_579522 = query.getOrDefault("prettyPrint")
  valid_579522 = validateParameter(valid_579522, JBool, required = false,
                                 default = newJBool(true))
  if valid_579522 != nil:
    section.add "prettyPrint", valid_579522
  var valid_579523 = query.getOrDefault("oauth_token")
  valid_579523 = validateParameter(valid_579523, JString, required = false,
                                 default = nil)
  if valid_579523 != nil:
    section.add "oauth_token", valid_579523
  var valid_579524 = query.getOrDefault("alt")
  valid_579524 = validateParameter(valid_579524, JString, required = false,
                                 default = newJString("json"))
  if valid_579524 != nil:
    section.add "alt", valid_579524
  var valid_579525 = query.getOrDefault("userIp")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = nil)
  if valid_579525 != nil:
    section.add "userIp", valid_579525
  var valid_579526 = query.getOrDefault("quotaUser")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = nil)
  if valid_579526 != nil:
    section.add "quotaUser", valid_579526
  var valid_579527 = query.getOrDefault("fields")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "fields", valid_579527
  var valid_579528 = query.getOrDefault("language")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "language", valid_579528
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

proc call*(call_579530: Call_GamesRoomsLeave_579517; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_579530.validator(path, query, header, formData, body)
  let scheme = call_579530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579530.url(scheme.get, call_579530.host, call_579530.base,
                         call_579530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579530, url, valid)

proc call*(call_579531: Call_GamesRoomsLeave_579517; roomId: string;
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
  var path_579532 = newJObject()
  var query_579533 = newJObject()
  var body_579534 = newJObject()
  add(query_579533, "key", newJString(key))
  add(query_579533, "prettyPrint", newJBool(prettyPrint))
  add(query_579533, "oauth_token", newJString(oauthToken))
  add(query_579533, "alt", newJString(alt))
  add(query_579533, "userIp", newJString(userIp))
  add(query_579533, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579534 = body
  add(path_579532, "roomId", newJString(roomId))
  add(query_579533, "fields", newJString(fields))
  add(query_579533, "language", newJString(language))
  result = call_579531.call(path_579532, query_579533, nil, nil, body_579534)

var gamesRoomsLeave* = Call_GamesRoomsLeave_579517(name: "gamesRoomsLeave",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/leave", validator: validate_GamesRoomsLeave_579518,
    base: "/games/v1", url: url_GamesRoomsLeave_579519, schemes: {Scheme.Https})
type
  Call_GamesRoomsReportStatus_579535 = ref object of OpenApiRestCall_578364
proc url_GamesRoomsReportStatus_579537(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesRoomsReportStatus_579536(path: JsonNode; query: JsonNode;
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
  var valid_579538 = path.getOrDefault("roomId")
  valid_579538 = validateParameter(valid_579538, JString, required = true,
                                 default = nil)
  if valid_579538 != nil:
    section.add "roomId", valid_579538
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
  var valid_579545 = query.getOrDefault("fields")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "fields", valid_579545
  var valid_579546 = query.getOrDefault("language")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "language", valid_579546
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

proc call*(call_579548: Call_GamesRoomsReportStatus_579535; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates sent by a client reporting the status of peers in a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_579548.validator(path, query, header, formData, body)
  let scheme = call_579548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579548.url(scheme.get, call_579548.host, call_579548.base,
                         call_579548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579548, url, valid)

proc call*(call_579549: Call_GamesRoomsReportStatus_579535; roomId: string;
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
  var path_579550 = newJObject()
  var query_579551 = newJObject()
  var body_579552 = newJObject()
  add(query_579551, "key", newJString(key))
  add(query_579551, "prettyPrint", newJBool(prettyPrint))
  add(query_579551, "oauth_token", newJString(oauthToken))
  add(query_579551, "alt", newJString(alt))
  add(query_579551, "userIp", newJString(userIp))
  add(query_579551, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579552 = body
  add(path_579550, "roomId", newJString(roomId))
  add(query_579551, "fields", newJString(fields))
  add(query_579551, "language", newJString(language))
  result = call_579549.call(path_579550, query_579551, nil, nil, body_579552)

var gamesRoomsReportStatus* = Call_GamesRoomsReportStatus_579535(
    name: "gamesRoomsReportStatus", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/{roomId}/reportstatus",
    validator: validate_GamesRoomsReportStatus_579536, base: "/games/v1",
    url: url_GamesRoomsReportStatus_579537, schemes: {Scheme.Https})
type
  Call_GamesSnapshotsGet_579553 = ref object of OpenApiRestCall_578364
proc url_GamesSnapshotsGet_579555(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_GamesSnapshotsGet_579554(path: JsonNode; query: JsonNode;
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
  var valid_579556 = path.getOrDefault("snapshotId")
  valid_579556 = validateParameter(valid_579556, JString, required = true,
                                 default = nil)
  if valid_579556 != nil:
    section.add "snapshotId", valid_579556
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
  var valid_579557 = query.getOrDefault("key")
  valid_579557 = validateParameter(valid_579557, JString, required = false,
                                 default = nil)
  if valid_579557 != nil:
    section.add "key", valid_579557
  var valid_579558 = query.getOrDefault("prettyPrint")
  valid_579558 = validateParameter(valid_579558, JBool, required = false,
                                 default = newJBool(true))
  if valid_579558 != nil:
    section.add "prettyPrint", valid_579558
  var valid_579559 = query.getOrDefault("oauth_token")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "oauth_token", valid_579559
  var valid_579560 = query.getOrDefault("alt")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = newJString("json"))
  if valid_579560 != nil:
    section.add "alt", valid_579560
  var valid_579561 = query.getOrDefault("userIp")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "userIp", valid_579561
  var valid_579562 = query.getOrDefault("quotaUser")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = nil)
  if valid_579562 != nil:
    section.add "quotaUser", valid_579562
  var valid_579563 = query.getOrDefault("fields")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "fields", valid_579563
  var valid_579564 = query.getOrDefault("language")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = nil)
  if valid_579564 != nil:
    section.add "language", valid_579564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579565: Call_GamesSnapshotsGet_579553; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata for a given snapshot ID.
  ## 
  let valid = call_579565.validator(path, query, header, formData, body)
  let scheme = call_579565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579565.url(scheme.get, call_579565.host, call_579565.base,
                         call_579565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579565, url, valid)

proc call*(call_579566: Call_GamesSnapshotsGet_579553; snapshotId: string;
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
  var path_579567 = newJObject()
  var query_579568 = newJObject()
  add(query_579568, "key", newJString(key))
  add(query_579568, "prettyPrint", newJBool(prettyPrint))
  add(query_579568, "oauth_token", newJString(oauthToken))
  add(path_579567, "snapshotId", newJString(snapshotId))
  add(query_579568, "alt", newJString(alt))
  add(query_579568, "userIp", newJString(userIp))
  add(query_579568, "quotaUser", newJString(quotaUser))
  add(query_579568, "fields", newJString(fields))
  add(query_579568, "language", newJString(language))
  result = call_579566.call(path_579567, query_579568, nil, nil, nil)

var gamesSnapshotsGet* = Call_GamesSnapshotsGet_579553(name: "gamesSnapshotsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/snapshots/{snapshotId}", validator: validate_GamesSnapshotsGet_579554,
    base: "/games/v1", url: url_GamesSnapshotsGet_579555, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesList_579569 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesList_579571(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesList_579570(path: JsonNode; query: JsonNode;
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
  var valid_579572 = query.getOrDefault("key")
  valid_579572 = validateParameter(valid_579572, JString, required = false,
                                 default = nil)
  if valid_579572 != nil:
    section.add "key", valid_579572
  var valid_579573 = query.getOrDefault("maxCompletedMatches")
  valid_579573 = validateParameter(valid_579573, JInt, required = false, default = nil)
  if valid_579573 != nil:
    section.add "maxCompletedMatches", valid_579573
  var valid_579574 = query.getOrDefault("prettyPrint")
  valid_579574 = validateParameter(valid_579574, JBool, required = false,
                                 default = newJBool(true))
  if valid_579574 != nil:
    section.add "prettyPrint", valid_579574
  var valid_579575 = query.getOrDefault("oauth_token")
  valid_579575 = validateParameter(valid_579575, JString, required = false,
                                 default = nil)
  if valid_579575 != nil:
    section.add "oauth_token", valid_579575
  var valid_579576 = query.getOrDefault("includeMatchData")
  valid_579576 = validateParameter(valid_579576, JBool, required = false, default = nil)
  if valid_579576 != nil:
    section.add "includeMatchData", valid_579576
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
  var valid_579580 = query.getOrDefault("pageToken")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = nil)
  if valid_579580 != nil:
    section.add "pageToken", valid_579580
  var valid_579581 = query.getOrDefault("fields")
  valid_579581 = validateParameter(valid_579581, JString, required = false,
                                 default = nil)
  if valid_579581 != nil:
    section.add "fields", valid_579581
  var valid_579582 = query.getOrDefault("language")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "language", valid_579582
  var valid_579583 = query.getOrDefault("maxResults")
  valid_579583 = validateParameter(valid_579583, JInt, required = false, default = nil)
  if valid_579583 != nil:
    section.add "maxResults", valid_579583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579584: Call_GamesTurnBasedMatchesList_579569; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns turn-based matches the player is or was involved in.
  ## 
  let valid = call_579584.validator(path, query, header, formData, body)
  let scheme = call_579584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579584.url(scheme.get, call_579584.host, call_579584.base,
                         call_579584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579584, url, valid)

proc call*(call_579585: Call_GamesTurnBasedMatchesList_579569; key: string = "";
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
  var query_579586 = newJObject()
  add(query_579586, "key", newJString(key))
  add(query_579586, "maxCompletedMatches", newJInt(maxCompletedMatches))
  add(query_579586, "prettyPrint", newJBool(prettyPrint))
  add(query_579586, "oauth_token", newJString(oauthToken))
  add(query_579586, "includeMatchData", newJBool(includeMatchData))
  add(query_579586, "alt", newJString(alt))
  add(query_579586, "userIp", newJString(userIp))
  add(query_579586, "quotaUser", newJString(quotaUser))
  add(query_579586, "pageToken", newJString(pageToken))
  add(query_579586, "fields", newJString(fields))
  add(query_579586, "language", newJString(language))
  add(query_579586, "maxResults", newJInt(maxResults))
  result = call_579585.call(nil, query_579586, nil, nil, nil)

var gamesTurnBasedMatchesList* = Call_GamesTurnBasedMatchesList_579569(
    name: "gamesTurnBasedMatchesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches",
    validator: validate_GamesTurnBasedMatchesList_579570, base: "/games/v1",
    url: url_GamesTurnBasedMatchesList_579571, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesCreate_579587 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesCreate_579589(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesCreate_579588(path: JsonNode; query: JsonNode;
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
  var valid_579590 = query.getOrDefault("key")
  valid_579590 = validateParameter(valid_579590, JString, required = false,
                                 default = nil)
  if valid_579590 != nil:
    section.add "key", valid_579590
  var valid_579591 = query.getOrDefault("prettyPrint")
  valid_579591 = validateParameter(valid_579591, JBool, required = false,
                                 default = newJBool(true))
  if valid_579591 != nil:
    section.add "prettyPrint", valid_579591
  var valid_579592 = query.getOrDefault("oauth_token")
  valid_579592 = validateParameter(valid_579592, JString, required = false,
                                 default = nil)
  if valid_579592 != nil:
    section.add "oauth_token", valid_579592
  var valid_579593 = query.getOrDefault("alt")
  valid_579593 = validateParameter(valid_579593, JString, required = false,
                                 default = newJString("json"))
  if valid_579593 != nil:
    section.add "alt", valid_579593
  var valid_579594 = query.getOrDefault("userIp")
  valid_579594 = validateParameter(valid_579594, JString, required = false,
                                 default = nil)
  if valid_579594 != nil:
    section.add "userIp", valid_579594
  var valid_579595 = query.getOrDefault("quotaUser")
  valid_579595 = validateParameter(valid_579595, JString, required = false,
                                 default = nil)
  if valid_579595 != nil:
    section.add "quotaUser", valid_579595
  var valid_579596 = query.getOrDefault("fields")
  valid_579596 = validateParameter(valid_579596, JString, required = false,
                                 default = nil)
  if valid_579596 != nil:
    section.add "fields", valid_579596
  var valid_579597 = query.getOrDefault("language")
  valid_579597 = validateParameter(valid_579597, JString, required = false,
                                 default = nil)
  if valid_579597 != nil:
    section.add "language", valid_579597
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

proc call*(call_579599: Call_GamesTurnBasedMatchesCreate_579587; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a turn-based match.
  ## 
  let valid = call_579599.validator(path, query, header, formData, body)
  let scheme = call_579599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579599.url(scheme.get, call_579599.host, call_579599.base,
                         call_579599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579599, url, valid)

proc call*(call_579600: Call_GamesTurnBasedMatchesCreate_579587; key: string = "";
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
  var query_579601 = newJObject()
  var body_579602 = newJObject()
  add(query_579601, "key", newJString(key))
  add(query_579601, "prettyPrint", newJBool(prettyPrint))
  add(query_579601, "oauth_token", newJString(oauthToken))
  add(query_579601, "alt", newJString(alt))
  add(query_579601, "userIp", newJString(userIp))
  add(query_579601, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579602 = body
  add(query_579601, "fields", newJString(fields))
  add(query_579601, "language", newJString(language))
  result = call_579600.call(nil, query_579601, nil, nil, body_579602)

var gamesTurnBasedMatchesCreate* = Call_GamesTurnBasedMatchesCreate_579587(
    name: "gamesTurnBasedMatchesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/create",
    validator: validate_GamesTurnBasedMatchesCreate_579588, base: "/games/v1",
    url: url_GamesTurnBasedMatchesCreate_579589, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesSync_579603 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesSync_579605(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesSync_579604(path: JsonNode; query: JsonNode;
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
  var valid_579606 = query.getOrDefault("key")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "key", valid_579606
  var valid_579607 = query.getOrDefault("maxCompletedMatches")
  valid_579607 = validateParameter(valid_579607, JInt, required = false, default = nil)
  if valid_579607 != nil:
    section.add "maxCompletedMatches", valid_579607
  var valid_579608 = query.getOrDefault("prettyPrint")
  valid_579608 = validateParameter(valid_579608, JBool, required = false,
                                 default = newJBool(true))
  if valid_579608 != nil:
    section.add "prettyPrint", valid_579608
  var valid_579609 = query.getOrDefault("oauth_token")
  valid_579609 = validateParameter(valid_579609, JString, required = false,
                                 default = nil)
  if valid_579609 != nil:
    section.add "oauth_token", valid_579609
  var valid_579610 = query.getOrDefault("includeMatchData")
  valid_579610 = validateParameter(valid_579610, JBool, required = false, default = nil)
  if valid_579610 != nil:
    section.add "includeMatchData", valid_579610
  var valid_579611 = query.getOrDefault("alt")
  valid_579611 = validateParameter(valid_579611, JString, required = false,
                                 default = newJString("json"))
  if valid_579611 != nil:
    section.add "alt", valid_579611
  var valid_579612 = query.getOrDefault("userIp")
  valid_579612 = validateParameter(valid_579612, JString, required = false,
                                 default = nil)
  if valid_579612 != nil:
    section.add "userIp", valid_579612
  var valid_579613 = query.getOrDefault("quotaUser")
  valid_579613 = validateParameter(valid_579613, JString, required = false,
                                 default = nil)
  if valid_579613 != nil:
    section.add "quotaUser", valid_579613
  var valid_579614 = query.getOrDefault("pageToken")
  valid_579614 = validateParameter(valid_579614, JString, required = false,
                                 default = nil)
  if valid_579614 != nil:
    section.add "pageToken", valid_579614
  var valid_579615 = query.getOrDefault("fields")
  valid_579615 = validateParameter(valid_579615, JString, required = false,
                                 default = nil)
  if valid_579615 != nil:
    section.add "fields", valid_579615
  var valid_579616 = query.getOrDefault("language")
  valid_579616 = validateParameter(valid_579616, JString, required = false,
                                 default = nil)
  if valid_579616 != nil:
    section.add "language", valid_579616
  var valid_579617 = query.getOrDefault("maxResults")
  valid_579617 = validateParameter(valid_579617, JInt, required = false, default = nil)
  if valid_579617 != nil:
    section.add "maxResults", valid_579617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579618: Call_GamesTurnBasedMatchesSync_579603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns turn-based matches the player is or was involved in that changed since the last sync call, with the least recent changes coming first. Matches that should be removed from the local cache will have a status of MATCH_DELETED.
  ## 
  let valid = call_579618.validator(path, query, header, formData, body)
  let scheme = call_579618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579618.url(scheme.get, call_579618.host, call_579618.base,
                         call_579618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579618, url, valid)

proc call*(call_579619: Call_GamesTurnBasedMatchesSync_579603; key: string = "";
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
  var query_579620 = newJObject()
  add(query_579620, "key", newJString(key))
  add(query_579620, "maxCompletedMatches", newJInt(maxCompletedMatches))
  add(query_579620, "prettyPrint", newJBool(prettyPrint))
  add(query_579620, "oauth_token", newJString(oauthToken))
  add(query_579620, "includeMatchData", newJBool(includeMatchData))
  add(query_579620, "alt", newJString(alt))
  add(query_579620, "userIp", newJString(userIp))
  add(query_579620, "quotaUser", newJString(quotaUser))
  add(query_579620, "pageToken", newJString(pageToken))
  add(query_579620, "fields", newJString(fields))
  add(query_579620, "language", newJString(language))
  add(query_579620, "maxResults", newJInt(maxResults))
  result = call_579619.call(nil, query_579620, nil, nil, nil)

var gamesTurnBasedMatchesSync* = Call_GamesTurnBasedMatchesSync_579603(
    name: "gamesTurnBasedMatchesSync", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches/sync",
    validator: validate_GamesTurnBasedMatchesSync_579604, base: "/games/v1",
    url: url_GamesTurnBasedMatchesSync_579605, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesGet_579621 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesGet_579623(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesGet_579622(path: JsonNode; query: JsonNode;
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
  var valid_579624 = path.getOrDefault("matchId")
  valid_579624 = validateParameter(valid_579624, JString, required = true,
                                 default = nil)
  if valid_579624 != nil:
    section.add "matchId", valid_579624
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
  var valid_579625 = query.getOrDefault("key")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = nil)
  if valid_579625 != nil:
    section.add "key", valid_579625
  var valid_579626 = query.getOrDefault("prettyPrint")
  valid_579626 = validateParameter(valid_579626, JBool, required = false,
                                 default = newJBool(true))
  if valid_579626 != nil:
    section.add "prettyPrint", valid_579626
  var valid_579627 = query.getOrDefault("oauth_token")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = nil)
  if valid_579627 != nil:
    section.add "oauth_token", valid_579627
  var valid_579628 = query.getOrDefault("includeMatchData")
  valid_579628 = validateParameter(valid_579628, JBool, required = false, default = nil)
  if valid_579628 != nil:
    section.add "includeMatchData", valid_579628
  var valid_579629 = query.getOrDefault("alt")
  valid_579629 = validateParameter(valid_579629, JString, required = false,
                                 default = newJString("json"))
  if valid_579629 != nil:
    section.add "alt", valid_579629
  var valid_579630 = query.getOrDefault("userIp")
  valid_579630 = validateParameter(valid_579630, JString, required = false,
                                 default = nil)
  if valid_579630 != nil:
    section.add "userIp", valid_579630
  var valid_579631 = query.getOrDefault("quotaUser")
  valid_579631 = validateParameter(valid_579631, JString, required = false,
                                 default = nil)
  if valid_579631 != nil:
    section.add "quotaUser", valid_579631
  var valid_579632 = query.getOrDefault("fields")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = nil)
  if valid_579632 != nil:
    section.add "fields", valid_579632
  var valid_579633 = query.getOrDefault("language")
  valid_579633 = validateParameter(valid_579633, JString, required = false,
                                 default = nil)
  if valid_579633 != nil:
    section.add "language", valid_579633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579634: Call_GamesTurnBasedMatchesGet_579621; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the data for a turn-based match.
  ## 
  let valid = call_579634.validator(path, query, header, formData, body)
  let scheme = call_579634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579634.url(scheme.get, call_579634.host, call_579634.base,
                         call_579634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579634, url, valid)

proc call*(call_579635: Call_GamesTurnBasedMatchesGet_579621; matchId: string;
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
  var path_579636 = newJObject()
  var query_579637 = newJObject()
  add(query_579637, "key", newJString(key))
  add(query_579637, "prettyPrint", newJBool(prettyPrint))
  add(query_579637, "oauth_token", newJString(oauthToken))
  add(query_579637, "includeMatchData", newJBool(includeMatchData))
  add(query_579637, "alt", newJString(alt))
  add(query_579637, "userIp", newJString(userIp))
  add(query_579637, "quotaUser", newJString(quotaUser))
  add(query_579637, "fields", newJString(fields))
  add(path_579636, "matchId", newJString(matchId))
  add(query_579637, "language", newJString(language))
  result = call_579635.call(path_579636, query_579637, nil, nil, nil)

var gamesTurnBasedMatchesGet* = Call_GamesTurnBasedMatchesGet_579621(
    name: "gamesTurnBasedMatchesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}",
    validator: validate_GamesTurnBasedMatchesGet_579622, base: "/games/v1",
    url: url_GamesTurnBasedMatchesGet_579623, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesCancel_579638 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesCancel_579640(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesCancel_579639(path: JsonNode; query: JsonNode;
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
  var valid_579641 = path.getOrDefault("matchId")
  valid_579641 = validateParameter(valid_579641, JString, required = true,
                                 default = nil)
  if valid_579641 != nil:
    section.add "matchId", valid_579641
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
  var valid_579642 = query.getOrDefault("key")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "key", valid_579642
  var valid_579643 = query.getOrDefault("prettyPrint")
  valid_579643 = validateParameter(valid_579643, JBool, required = false,
                                 default = newJBool(true))
  if valid_579643 != nil:
    section.add "prettyPrint", valid_579643
  var valid_579644 = query.getOrDefault("oauth_token")
  valid_579644 = validateParameter(valid_579644, JString, required = false,
                                 default = nil)
  if valid_579644 != nil:
    section.add "oauth_token", valid_579644
  var valid_579645 = query.getOrDefault("alt")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = newJString("json"))
  if valid_579645 != nil:
    section.add "alt", valid_579645
  var valid_579646 = query.getOrDefault("userIp")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = nil)
  if valid_579646 != nil:
    section.add "userIp", valid_579646
  var valid_579647 = query.getOrDefault("quotaUser")
  valid_579647 = validateParameter(valid_579647, JString, required = false,
                                 default = nil)
  if valid_579647 != nil:
    section.add "quotaUser", valid_579647
  var valid_579648 = query.getOrDefault("fields")
  valid_579648 = validateParameter(valid_579648, JString, required = false,
                                 default = nil)
  if valid_579648 != nil:
    section.add "fields", valid_579648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579649: Call_GamesTurnBasedMatchesCancel_579638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a turn-based match.
  ## 
  let valid = call_579649.validator(path, query, header, formData, body)
  let scheme = call_579649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579649.url(scheme.get, call_579649.host, call_579649.base,
                         call_579649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579649, url, valid)

proc call*(call_579650: Call_GamesTurnBasedMatchesCancel_579638; matchId: string;
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
  var path_579651 = newJObject()
  var query_579652 = newJObject()
  add(query_579652, "key", newJString(key))
  add(query_579652, "prettyPrint", newJBool(prettyPrint))
  add(query_579652, "oauth_token", newJString(oauthToken))
  add(query_579652, "alt", newJString(alt))
  add(query_579652, "userIp", newJString(userIp))
  add(query_579652, "quotaUser", newJString(quotaUser))
  add(query_579652, "fields", newJString(fields))
  add(path_579651, "matchId", newJString(matchId))
  result = call_579650.call(path_579651, query_579652, nil, nil, nil)

var gamesTurnBasedMatchesCancel* = Call_GamesTurnBasedMatchesCancel_579638(
    name: "gamesTurnBasedMatchesCancel", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/cancel",
    validator: validate_GamesTurnBasedMatchesCancel_579639, base: "/games/v1",
    url: url_GamesTurnBasedMatchesCancel_579640, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesDecline_579653 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesDecline_579655(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesDecline_579654(path: JsonNode; query: JsonNode;
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
  var valid_579656 = path.getOrDefault("matchId")
  valid_579656 = validateParameter(valid_579656, JString, required = true,
                                 default = nil)
  if valid_579656 != nil:
    section.add "matchId", valid_579656
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
  var valid_579657 = query.getOrDefault("key")
  valid_579657 = validateParameter(valid_579657, JString, required = false,
                                 default = nil)
  if valid_579657 != nil:
    section.add "key", valid_579657
  var valid_579658 = query.getOrDefault("prettyPrint")
  valid_579658 = validateParameter(valid_579658, JBool, required = false,
                                 default = newJBool(true))
  if valid_579658 != nil:
    section.add "prettyPrint", valid_579658
  var valid_579659 = query.getOrDefault("oauth_token")
  valid_579659 = validateParameter(valid_579659, JString, required = false,
                                 default = nil)
  if valid_579659 != nil:
    section.add "oauth_token", valid_579659
  var valid_579660 = query.getOrDefault("alt")
  valid_579660 = validateParameter(valid_579660, JString, required = false,
                                 default = newJString("json"))
  if valid_579660 != nil:
    section.add "alt", valid_579660
  var valid_579661 = query.getOrDefault("userIp")
  valid_579661 = validateParameter(valid_579661, JString, required = false,
                                 default = nil)
  if valid_579661 != nil:
    section.add "userIp", valid_579661
  var valid_579662 = query.getOrDefault("quotaUser")
  valid_579662 = validateParameter(valid_579662, JString, required = false,
                                 default = nil)
  if valid_579662 != nil:
    section.add "quotaUser", valid_579662
  var valid_579663 = query.getOrDefault("fields")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "fields", valid_579663
  var valid_579664 = query.getOrDefault("language")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = nil)
  if valid_579664 != nil:
    section.add "language", valid_579664
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579665: Call_GamesTurnBasedMatchesDecline_579653; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decline an invitation to play a turn-based match.
  ## 
  let valid = call_579665.validator(path, query, header, formData, body)
  let scheme = call_579665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579665.url(scheme.get, call_579665.host, call_579665.base,
                         call_579665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579665, url, valid)

proc call*(call_579666: Call_GamesTurnBasedMatchesDecline_579653; matchId: string;
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
  var path_579667 = newJObject()
  var query_579668 = newJObject()
  add(query_579668, "key", newJString(key))
  add(query_579668, "prettyPrint", newJBool(prettyPrint))
  add(query_579668, "oauth_token", newJString(oauthToken))
  add(query_579668, "alt", newJString(alt))
  add(query_579668, "userIp", newJString(userIp))
  add(query_579668, "quotaUser", newJString(quotaUser))
  add(query_579668, "fields", newJString(fields))
  add(path_579667, "matchId", newJString(matchId))
  add(query_579668, "language", newJString(language))
  result = call_579666.call(path_579667, query_579668, nil, nil, nil)

var gamesTurnBasedMatchesDecline* = Call_GamesTurnBasedMatchesDecline_579653(
    name: "gamesTurnBasedMatchesDecline", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/decline",
    validator: validate_GamesTurnBasedMatchesDecline_579654, base: "/games/v1",
    url: url_GamesTurnBasedMatchesDecline_579655, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesDismiss_579669 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesDismiss_579671(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesDismiss_579670(path: JsonNode; query: JsonNode;
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
  var valid_579672 = path.getOrDefault("matchId")
  valid_579672 = validateParameter(valid_579672, JString, required = true,
                                 default = nil)
  if valid_579672 != nil:
    section.add "matchId", valid_579672
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
  var valid_579673 = query.getOrDefault("key")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = nil)
  if valid_579673 != nil:
    section.add "key", valid_579673
  var valid_579674 = query.getOrDefault("prettyPrint")
  valid_579674 = validateParameter(valid_579674, JBool, required = false,
                                 default = newJBool(true))
  if valid_579674 != nil:
    section.add "prettyPrint", valid_579674
  var valid_579675 = query.getOrDefault("oauth_token")
  valid_579675 = validateParameter(valid_579675, JString, required = false,
                                 default = nil)
  if valid_579675 != nil:
    section.add "oauth_token", valid_579675
  var valid_579676 = query.getOrDefault("alt")
  valid_579676 = validateParameter(valid_579676, JString, required = false,
                                 default = newJString("json"))
  if valid_579676 != nil:
    section.add "alt", valid_579676
  var valid_579677 = query.getOrDefault("userIp")
  valid_579677 = validateParameter(valid_579677, JString, required = false,
                                 default = nil)
  if valid_579677 != nil:
    section.add "userIp", valid_579677
  var valid_579678 = query.getOrDefault("quotaUser")
  valid_579678 = validateParameter(valid_579678, JString, required = false,
                                 default = nil)
  if valid_579678 != nil:
    section.add "quotaUser", valid_579678
  var valid_579679 = query.getOrDefault("fields")
  valid_579679 = validateParameter(valid_579679, JString, required = false,
                                 default = nil)
  if valid_579679 != nil:
    section.add "fields", valid_579679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579680: Call_GamesTurnBasedMatchesDismiss_579669; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss a turn-based match from the match list. The match will no longer show up in the list and will not generate notifications.
  ## 
  let valid = call_579680.validator(path, query, header, formData, body)
  let scheme = call_579680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579680.url(scheme.get, call_579680.host, call_579680.base,
                         call_579680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579680, url, valid)

proc call*(call_579681: Call_GamesTurnBasedMatchesDismiss_579669; matchId: string;
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
  var path_579682 = newJObject()
  var query_579683 = newJObject()
  add(query_579683, "key", newJString(key))
  add(query_579683, "prettyPrint", newJBool(prettyPrint))
  add(query_579683, "oauth_token", newJString(oauthToken))
  add(query_579683, "alt", newJString(alt))
  add(query_579683, "userIp", newJString(userIp))
  add(query_579683, "quotaUser", newJString(quotaUser))
  add(query_579683, "fields", newJString(fields))
  add(path_579682, "matchId", newJString(matchId))
  result = call_579681.call(path_579682, query_579683, nil, nil, nil)

var gamesTurnBasedMatchesDismiss* = Call_GamesTurnBasedMatchesDismiss_579669(
    name: "gamesTurnBasedMatchesDismiss", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/dismiss",
    validator: validate_GamesTurnBasedMatchesDismiss_579670, base: "/games/v1",
    url: url_GamesTurnBasedMatchesDismiss_579671, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesFinish_579684 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesFinish_579686(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesFinish_579685(path: JsonNode; query: JsonNode;
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
  var valid_579687 = path.getOrDefault("matchId")
  valid_579687 = validateParameter(valid_579687, JString, required = true,
                                 default = nil)
  if valid_579687 != nil:
    section.add "matchId", valid_579687
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
  var valid_579688 = query.getOrDefault("key")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = nil)
  if valid_579688 != nil:
    section.add "key", valid_579688
  var valid_579689 = query.getOrDefault("prettyPrint")
  valid_579689 = validateParameter(valid_579689, JBool, required = false,
                                 default = newJBool(true))
  if valid_579689 != nil:
    section.add "prettyPrint", valid_579689
  var valid_579690 = query.getOrDefault("oauth_token")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "oauth_token", valid_579690
  var valid_579691 = query.getOrDefault("alt")
  valid_579691 = validateParameter(valid_579691, JString, required = false,
                                 default = newJString("json"))
  if valid_579691 != nil:
    section.add "alt", valid_579691
  var valid_579692 = query.getOrDefault("userIp")
  valid_579692 = validateParameter(valid_579692, JString, required = false,
                                 default = nil)
  if valid_579692 != nil:
    section.add "userIp", valid_579692
  var valid_579693 = query.getOrDefault("quotaUser")
  valid_579693 = validateParameter(valid_579693, JString, required = false,
                                 default = nil)
  if valid_579693 != nil:
    section.add "quotaUser", valid_579693
  var valid_579694 = query.getOrDefault("fields")
  valid_579694 = validateParameter(valid_579694, JString, required = false,
                                 default = nil)
  if valid_579694 != nil:
    section.add "fields", valid_579694
  var valid_579695 = query.getOrDefault("language")
  valid_579695 = validateParameter(valid_579695, JString, required = false,
                                 default = nil)
  if valid_579695 != nil:
    section.add "language", valid_579695
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

proc call*(call_579697: Call_GamesTurnBasedMatchesFinish_579684; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finish a turn-based match. Each player should make this call once, after all results are in. Only the player whose turn it is may make the first call to Finish, and can pass in the final match state.
  ## 
  let valid = call_579697.validator(path, query, header, formData, body)
  let scheme = call_579697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579697.url(scheme.get, call_579697.host, call_579697.base,
                         call_579697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579697, url, valid)

proc call*(call_579698: Call_GamesTurnBasedMatchesFinish_579684; matchId: string;
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
  var path_579699 = newJObject()
  var query_579700 = newJObject()
  var body_579701 = newJObject()
  add(query_579700, "key", newJString(key))
  add(query_579700, "prettyPrint", newJBool(prettyPrint))
  add(query_579700, "oauth_token", newJString(oauthToken))
  add(query_579700, "alt", newJString(alt))
  add(query_579700, "userIp", newJString(userIp))
  add(query_579700, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579701 = body
  add(query_579700, "fields", newJString(fields))
  add(path_579699, "matchId", newJString(matchId))
  add(query_579700, "language", newJString(language))
  result = call_579698.call(path_579699, query_579700, nil, nil, body_579701)

var gamesTurnBasedMatchesFinish* = Call_GamesTurnBasedMatchesFinish_579684(
    name: "gamesTurnBasedMatchesFinish", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/finish",
    validator: validate_GamesTurnBasedMatchesFinish_579685, base: "/games/v1",
    url: url_GamesTurnBasedMatchesFinish_579686, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesJoin_579702 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesJoin_579704(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesJoin_579703(path: JsonNode; query: JsonNode;
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
  var valid_579705 = path.getOrDefault("matchId")
  valid_579705 = validateParameter(valid_579705, JString, required = true,
                                 default = nil)
  if valid_579705 != nil:
    section.add "matchId", valid_579705
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
  var valid_579706 = query.getOrDefault("key")
  valid_579706 = validateParameter(valid_579706, JString, required = false,
                                 default = nil)
  if valid_579706 != nil:
    section.add "key", valid_579706
  var valid_579707 = query.getOrDefault("prettyPrint")
  valid_579707 = validateParameter(valid_579707, JBool, required = false,
                                 default = newJBool(true))
  if valid_579707 != nil:
    section.add "prettyPrint", valid_579707
  var valid_579708 = query.getOrDefault("oauth_token")
  valid_579708 = validateParameter(valid_579708, JString, required = false,
                                 default = nil)
  if valid_579708 != nil:
    section.add "oauth_token", valid_579708
  var valid_579709 = query.getOrDefault("alt")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = newJString("json"))
  if valid_579709 != nil:
    section.add "alt", valid_579709
  var valid_579710 = query.getOrDefault("userIp")
  valid_579710 = validateParameter(valid_579710, JString, required = false,
                                 default = nil)
  if valid_579710 != nil:
    section.add "userIp", valid_579710
  var valid_579711 = query.getOrDefault("quotaUser")
  valid_579711 = validateParameter(valid_579711, JString, required = false,
                                 default = nil)
  if valid_579711 != nil:
    section.add "quotaUser", valid_579711
  var valid_579712 = query.getOrDefault("fields")
  valid_579712 = validateParameter(valid_579712, JString, required = false,
                                 default = nil)
  if valid_579712 != nil:
    section.add "fields", valid_579712
  var valid_579713 = query.getOrDefault("language")
  valid_579713 = validateParameter(valid_579713, JString, required = false,
                                 default = nil)
  if valid_579713 != nil:
    section.add "language", valid_579713
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579714: Call_GamesTurnBasedMatchesJoin_579702; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Join a turn-based match.
  ## 
  let valid = call_579714.validator(path, query, header, formData, body)
  let scheme = call_579714.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579714.url(scheme.get, call_579714.host, call_579714.base,
                         call_579714.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579714, url, valid)

proc call*(call_579715: Call_GamesTurnBasedMatchesJoin_579702; matchId: string;
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
  var path_579716 = newJObject()
  var query_579717 = newJObject()
  add(query_579717, "key", newJString(key))
  add(query_579717, "prettyPrint", newJBool(prettyPrint))
  add(query_579717, "oauth_token", newJString(oauthToken))
  add(query_579717, "alt", newJString(alt))
  add(query_579717, "userIp", newJString(userIp))
  add(query_579717, "quotaUser", newJString(quotaUser))
  add(query_579717, "fields", newJString(fields))
  add(path_579716, "matchId", newJString(matchId))
  add(query_579717, "language", newJString(language))
  result = call_579715.call(path_579716, query_579717, nil, nil, nil)

var gamesTurnBasedMatchesJoin* = Call_GamesTurnBasedMatchesJoin_579702(
    name: "gamesTurnBasedMatchesJoin", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/join",
    validator: validate_GamesTurnBasedMatchesJoin_579703, base: "/games/v1",
    url: url_GamesTurnBasedMatchesJoin_579704, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesLeave_579718 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesLeave_579720(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesLeave_579719(path: JsonNode; query: JsonNode;
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
  var valid_579721 = path.getOrDefault("matchId")
  valid_579721 = validateParameter(valid_579721, JString, required = true,
                                 default = nil)
  if valid_579721 != nil:
    section.add "matchId", valid_579721
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
  var valid_579722 = query.getOrDefault("key")
  valid_579722 = validateParameter(valid_579722, JString, required = false,
                                 default = nil)
  if valid_579722 != nil:
    section.add "key", valid_579722
  var valid_579723 = query.getOrDefault("prettyPrint")
  valid_579723 = validateParameter(valid_579723, JBool, required = false,
                                 default = newJBool(true))
  if valid_579723 != nil:
    section.add "prettyPrint", valid_579723
  var valid_579724 = query.getOrDefault("oauth_token")
  valid_579724 = validateParameter(valid_579724, JString, required = false,
                                 default = nil)
  if valid_579724 != nil:
    section.add "oauth_token", valid_579724
  var valid_579725 = query.getOrDefault("alt")
  valid_579725 = validateParameter(valid_579725, JString, required = false,
                                 default = newJString("json"))
  if valid_579725 != nil:
    section.add "alt", valid_579725
  var valid_579726 = query.getOrDefault("userIp")
  valid_579726 = validateParameter(valid_579726, JString, required = false,
                                 default = nil)
  if valid_579726 != nil:
    section.add "userIp", valid_579726
  var valid_579727 = query.getOrDefault("quotaUser")
  valid_579727 = validateParameter(valid_579727, JString, required = false,
                                 default = nil)
  if valid_579727 != nil:
    section.add "quotaUser", valid_579727
  var valid_579728 = query.getOrDefault("fields")
  valid_579728 = validateParameter(valid_579728, JString, required = false,
                                 default = nil)
  if valid_579728 != nil:
    section.add "fields", valid_579728
  var valid_579729 = query.getOrDefault("language")
  valid_579729 = validateParameter(valid_579729, JString, required = false,
                                 default = nil)
  if valid_579729 != nil:
    section.add "language", valid_579729
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579730: Call_GamesTurnBasedMatchesLeave_579718; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a turn-based match when it is not the current player's turn, without canceling the match.
  ## 
  let valid = call_579730.validator(path, query, header, formData, body)
  let scheme = call_579730.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579730.url(scheme.get, call_579730.host, call_579730.base,
                         call_579730.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579730, url, valid)

proc call*(call_579731: Call_GamesTurnBasedMatchesLeave_579718; matchId: string;
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
  var path_579732 = newJObject()
  var query_579733 = newJObject()
  add(query_579733, "key", newJString(key))
  add(query_579733, "prettyPrint", newJBool(prettyPrint))
  add(query_579733, "oauth_token", newJString(oauthToken))
  add(query_579733, "alt", newJString(alt))
  add(query_579733, "userIp", newJString(userIp))
  add(query_579733, "quotaUser", newJString(quotaUser))
  add(query_579733, "fields", newJString(fields))
  add(path_579732, "matchId", newJString(matchId))
  add(query_579733, "language", newJString(language))
  result = call_579731.call(path_579732, query_579733, nil, nil, nil)

var gamesTurnBasedMatchesLeave* = Call_GamesTurnBasedMatchesLeave_579718(
    name: "gamesTurnBasedMatchesLeave", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/leave",
    validator: validate_GamesTurnBasedMatchesLeave_579719, base: "/games/v1",
    url: url_GamesTurnBasedMatchesLeave_579720, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesLeaveTurn_579734 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesLeaveTurn_579736(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesLeaveTurn_579735(path: JsonNode;
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
  var valid_579737 = path.getOrDefault("matchId")
  valid_579737 = validateParameter(valid_579737, JString, required = true,
                                 default = nil)
  if valid_579737 != nil:
    section.add "matchId", valid_579737
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
  var valid_579738 = query.getOrDefault("key")
  valid_579738 = validateParameter(valid_579738, JString, required = false,
                                 default = nil)
  if valid_579738 != nil:
    section.add "key", valid_579738
  var valid_579739 = query.getOrDefault("prettyPrint")
  valid_579739 = validateParameter(valid_579739, JBool, required = false,
                                 default = newJBool(true))
  if valid_579739 != nil:
    section.add "prettyPrint", valid_579739
  var valid_579740 = query.getOrDefault("oauth_token")
  valid_579740 = validateParameter(valid_579740, JString, required = false,
                                 default = nil)
  if valid_579740 != nil:
    section.add "oauth_token", valid_579740
  assert query != nil,
        "query argument is necessary due to required `matchVersion` field"
  var valid_579741 = query.getOrDefault("matchVersion")
  valid_579741 = validateParameter(valid_579741, JInt, required = true, default = nil)
  if valid_579741 != nil:
    section.add "matchVersion", valid_579741
  var valid_579742 = query.getOrDefault("alt")
  valid_579742 = validateParameter(valid_579742, JString, required = false,
                                 default = newJString("json"))
  if valid_579742 != nil:
    section.add "alt", valid_579742
  var valid_579743 = query.getOrDefault("userIp")
  valid_579743 = validateParameter(valid_579743, JString, required = false,
                                 default = nil)
  if valid_579743 != nil:
    section.add "userIp", valid_579743
  var valid_579744 = query.getOrDefault("pendingParticipantId")
  valid_579744 = validateParameter(valid_579744, JString, required = false,
                                 default = nil)
  if valid_579744 != nil:
    section.add "pendingParticipantId", valid_579744
  var valid_579745 = query.getOrDefault("quotaUser")
  valid_579745 = validateParameter(valid_579745, JString, required = false,
                                 default = nil)
  if valid_579745 != nil:
    section.add "quotaUser", valid_579745
  var valid_579746 = query.getOrDefault("fields")
  valid_579746 = validateParameter(valid_579746, JString, required = false,
                                 default = nil)
  if valid_579746 != nil:
    section.add "fields", valid_579746
  var valid_579747 = query.getOrDefault("language")
  valid_579747 = validateParameter(valid_579747, JString, required = false,
                                 default = nil)
  if valid_579747 != nil:
    section.add "language", valid_579747
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579748: Call_GamesTurnBasedMatchesLeaveTurn_579734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a turn-based match during the current player's turn, without canceling the match.
  ## 
  let valid = call_579748.validator(path, query, header, formData, body)
  let scheme = call_579748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579748.url(scheme.get, call_579748.host, call_579748.base,
                         call_579748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579748, url, valid)

proc call*(call_579749: Call_GamesTurnBasedMatchesLeaveTurn_579734;
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
  var path_579750 = newJObject()
  var query_579751 = newJObject()
  add(query_579751, "key", newJString(key))
  add(query_579751, "prettyPrint", newJBool(prettyPrint))
  add(query_579751, "oauth_token", newJString(oauthToken))
  add(query_579751, "matchVersion", newJInt(matchVersion))
  add(query_579751, "alt", newJString(alt))
  add(query_579751, "userIp", newJString(userIp))
  add(query_579751, "pendingParticipantId", newJString(pendingParticipantId))
  add(query_579751, "quotaUser", newJString(quotaUser))
  add(query_579751, "fields", newJString(fields))
  add(path_579750, "matchId", newJString(matchId))
  add(query_579751, "language", newJString(language))
  result = call_579749.call(path_579750, query_579751, nil, nil, nil)

var gamesTurnBasedMatchesLeaveTurn* = Call_GamesTurnBasedMatchesLeaveTurn_579734(
    name: "gamesTurnBasedMatchesLeaveTurn", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/leaveTurn",
    validator: validate_GamesTurnBasedMatchesLeaveTurn_579735, base: "/games/v1",
    url: url_GamesTurnBasedMatchesLeaveTurn_579736, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesRematch_579752 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesRematch_579754(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesRematch_579753(path: JsonNode; query: JsonNode;
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
  var valid_579755 = path.getOrDefault("matchId")
  valid_579755 = validateParameter(valid_579755, JString, required = true,
                                 default = nil)
  if valid_579755 != nil:
    section.add "matchId", valid_579755
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
  var valid_579756 = query.getOrDefault("key")
  valid_579756 = validateParameter(valid_579756, JString, required = false,
                                 default = nil)
  if valid_579756 != nil:
    section.add "key", valid_579756
  var valid_579757 = query.getOrDefault("prettyPrint")
  valid_579757 = validateParameter(valid_579757, JBool, required = false,
                                 default = newJBool(true))
  if valid_579757 != nil:
    section.add "prettyPrint", valid_579757
  var valid_579758 = query.getOrDefault("oauth_token")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "oauth_token", valid_579758
  var valid_579759 = query.getOrDefault("alt")
  valid_579759 = validateParameter(valid_579759, JString, required = false,
                                 default = newJString("json"))
  if valid_579759 != nil:
    section.add "alt", valid_579759
  var valid_579760 = query.getOrDefault("userIp")
  valid_579760 = validateParameter(valid_579760, JString, required = false,
                                 default = nil)
  if valid_579760 != nil:
    section.add "userIp", valid_579760
  var valid_579761 = query.getOrDefault("quotaUser")
  valid_579761 = validateParameter(valid_579761, JString, required = false,
                                 default = nil)
  if valid_579761 != nil:
    section.add "quotaUser", valid_579761
  var valid_579762 = query.getOrDefault("requestId")
  valid_579762 = validateParameter(valid_579762, JString, required = false,
                                 default = nil)
  if valid_579762 != nil:
    section.add "requestId", valid_579762
  var valid_579763 = query.getOrDefault("fields")
  valid_579763 = validateParameter(valid_579763, JString, required = false,
                                 default = nil)
  if valid_579763 != nil:
    section.add "fields", valid_579763
  var valid_579764 = query.getOrDefault("language")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "language", valid_579764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579765: Call_GamesTurnBasedMatchesRematch_579752; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a rematch of a match that was previously completed, with the same participants. This can be called by only one player on a match still in their list; the player must have called Finish first. Returns the newly created match; it will be the caller's turn.
  ## 
  let valid = call_579765.validator(path, query, header, formData, body)
  let scheme = call_579765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579765.url(scheme.get, call_579765.host, call_579765.base,
                         call_579765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579765, url, valid)

proc call*(call_579766: Call_GamesTurnBasedMatchesRematch_579752; matchId: string;
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
  var path_579767 = newJObject()
  var query_579768 = newJObject()
  add(query_579768, "key", newJString(key))
  add(query_579768, "prettyPrint", newJBool(prettyPrint))
  add(query_579768, "oauth_token", newJString(oauthToken))
  add(query_579768, "alt", newJString(alt))
  add(query_579768, "userIp", newJString(userIp))
  add(query_579768, "quotaUser", newJString(quotaUser))
  add(query_579768, "requestId", newJString(requestId))
  add(query_579768, "fields", newJString(fields))
  add(path_579767, "matchId", newJString(matchId))
  add(query_579768, "language", newJString(language))
  result = call_579766.call(path_579767, query_579768, nil, nil, nil)

var gamesTurnBasedMatchesRematch* = Call_GamesTurnBasedMatchesRematch_579752(
    name: "gamesTurnBasedMatchesRematch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/rematch",
    validator: validate_GamesTurnBasedMatchesRematch_579753, base: "/games/v1",
    url: url_GamesTurnBasedMatchesRematch_579754, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesTakeTurn_579769 = ref object of OpenApiRestCall_578364
proc url_GamesTurnBasedMatchesTakeTurn_579771(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesTakeTurn_579770(path: JsonNode; query: JsonNode;
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
  var valid_579772 = path.getOrDefault("matchId")
  valid_579772 = validateParameter(valid_579772, JString, required = true,
                                 default = nil)
  if valid_579772 != nil:
    section.add "matchId", valid_579772
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
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579774 = query.getOrDefault("prettyPrint")
  valid_579774 = validateParameter(valid_579774, JBool, required = false,
                                 default = newJBool(true))
  if valid_579774 != nil:
    section.add "prettyPrint", valid_579774
  var valid_579775 = query.getOrDefault("oauth_token")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "oauth_token", valid_579775
  var valid_579776 = query.getOrDefault("alt")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = newJString("json"))
  if valid_579776 != nil:
    section.add "alt", valid_579776
  var valid_579777 = query.getOrDefault("userIp")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "userIp", valid_579777
  var valid_579778 = query.getOrDefault("quotaUser")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "quotaUser", valid_579778
  var valid_579779 = query.getOrDefault("fields")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "fields", valid_579779
  var valid_579780 = query.getOrDefault("language")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "language", valid_579780
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

proc call*(call_579782: Call_GamesTurnBasedMatchesTakeTurn_579769; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commit the results of a player turn.
  ## 
  let valid = call_579782.validator(path, query, header, formData, body)
  let scheme = call_579782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579782.url(scheme.get, call_579782.host, call_579782.base,
                         call_579782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579782, url, valid)

proc call*(call_579783: Call_GamesTurnBasedMatchesTakeTurn_579769; matchId: string;
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
  var path_579784 = newJObject()
  var query_579785 = newJObject()
  var body_579786 = newJObject()
  add(query_579785, "key", newJString(key))
  add(query_579785, "prettyPrint", newJBool(prettyPrint))
  add(query_579785, "oauth_token", newJString(oauthToken))
  add(query_579785, "alt", newJString(alt))
  add(query_579785, "userIp", newJString(userIp))
  add(query_579785, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579786 = body
  add(query_579785, "fields", newJString(fields))
  add(path_579784, "matchId", newJString(matchId))
  add(query_579785, "language", newJString(language))
  result = call_579783.call(path_579784, query_579785, nil, nil, body_579786)

var gamesTurnBasedMatchesTakeTurn* = Call_GamesTurnBasedMatchesTakeTurn_579769(
    name: "gamesTurnBasedMatchesTakeTurn", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/turn",
    validator: validate_GamesTurnBasedMatchesTakeTurn_579770, base: "/games/v1",
    url: url_GamesTurnBasedMatchesTakeTurn_579771, schemes: {Scheme.Https})
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
