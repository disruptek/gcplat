
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

  OpenApiRestCall_579437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579437): Option[Scheme] {.used.} =
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
  gcpServiceName = "games"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GamesAchievementDefinitionsList_579705 = ref object of OpenApiRestCall_579437
proc url_GamesAchievementDefinitionsList_579707(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesAchievementDefinitionsList_579706(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the achievement definitions for your application.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of achievement resources to return in the response, used for paging. For any response, the actual number of achievement resources returned may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579819 = query.getOrDefault("fields")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "fields", valid_579819
  var valid_579820 = query.getOrDefault("pageToken")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "pageToken", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("language")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "language", valid_579836
  var valid_579837 = query.getOrDefault("oauth_token")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "oauth_token", valid_579837
  var valid_579838 = query.getOrDefault("userIp")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "userIp", valid_579838
  var valid_579839 = query.getOrDefault("maxResults")
  valid_579839 = validateParameter(valid_579839, JInt, required = false, default = nil)
  if valid_579839 != nil:
    section.add "maxResults", valid_579839
  var valid_579840 = query.getOrDefault("key")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "key", valid_579840
  var valid_579841 = query.getOrDefault("prettyPrint")
  valid_579841 = validateParameter(valid_579841, JBool, required = false,
                                 default = newJBool(true))
  if valid_579841 != nil:
    section.add "prettyPrint", valid_579841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579864: Call_GamesAchievementDefinitionsList_579705;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the achievement definitions for your application.
  ## 
  let valid = call_579864.validator(path, query, header, formData, body)
  let scheme = call_579864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579864.url(scheme.get, call_579864.host, call_579864.base,
                         call_579864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579864, url, valid)

proc call*(call_579935: Call_GamesAchievementDefinitionsList_579705;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesAchievementDefinitionsList
  ## Lists all the achievement definitions for your application.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of achievement resources to return in the response, used for paging. For any response, the actual number of achievement resources returned may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579936 = newJObject()
  add(query_579936, "fields", newJString(fields))
  add(query_579936, "pageToken", newJString(pageToken))
  add(query_579936, "quotaUser", newJString(quotaUser))
  add(query_579936, "alt", newJString(alt))
  add(query_579936, "language", newJString(language))
  add(query_579936, "oauth_token", newJString(oauthToken))
  add(query_579936, "userIp", newJString(userIp))
  add(query_579936, "maxResults", newJInt(maxResults))
  add(query_579936, "key", newJString(key))
  add(query_579936, "prettyPrint", newJBool(prettyPrint))
  result = call_579935.call(nil, query_579936, nil, nil, nil)

var gamesAchievementDefinitionsList* = Call_GamesAchievementDefinitionsList_579705(
    name: "gamesAchievementDefinitionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/achievements",
    validator: validate_GamesAchievementDefinitionsList_579706, base: "/games/v1",
    url: url_GamesAchievementDefinitionsList_579707, schemes: {Scheme.Https})
type
  Call_GamesAchievementsUpdateMultiple_579976 = ref object of OpenApiRestCall_579437
proc url_GamesAchievementsUpdateMultiple_579978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesAchievementsUpdateMultiple_579977(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates multiple achievements for the currently authenticated player.
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
  ##   builtinGameId: JString
  ##                : Override used only by built-in games in Play Games application.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579979 = query.getOrDefault("fields")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "fields", valid_579979
  var valid_579980 = query.getOrDefault("quotaUser")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "quotaUser", valid_579980
  var valid_579981 = query.getOrDefault("alt")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("json"))
  if valid_579981 != nil:
    section.add "alt", valid_579981
  var valid_579982 = query.getOrDefault("builtinGameId")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "builtinGameId", valid_579982
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579988: Call_GamesAchievementsUpdateMultiple_579976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates multiple achievements for the currently authenticated player.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_GamesAchievementsUpdateMultiple_579976;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          builtinGameId: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesAchievementsUpdateMultiple
  ## Updates multiple achievements for the currently authenticated player.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   builtinGameId: string
  ##                : Override used only by built-in games in Play Games application.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579990 = newJObject()
  var body_579991 = newJObject()
  add(query_579990, "fields", newJString(fields))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(query_579990, "alt", newJString(alt))
  add(query_579990, "builtinGameId", newJString(builtinGameId))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(query_579990, "userIp", newJString(userIp))
  add(query_579990, "key", newJString(key))
  if body != nil:
    body_579991 = body
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  result = call_579989.call(nil, query_579990, nil, nil, body_579991)

var gamesAchievementsUpdateMultiple* = Call_GamesAchievementsUpdateMultiple_579976(
    name: "gamesAchievementsUpdateMultiple", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/updateMultiple",
    validator: validate_GamesAchievementsUpdateMultiple_579977, base: "/games/v1",
    url: url_GamesAchievementsUpdateMultiple_579978, schemes: {Scheme.Https})
type
  Call_GamesAchievementsIncrement_579992 = ref object of OpenApiRestCall_579437
proc url_GamesAchievementsIncrement_579994(protocol: Scheme; host: string;
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

proc validate_GamesAchievementsIncrement_579993(path: JsonNode; query: JsonNode;
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
  var valid_580009 = path.getOrDefault("achievementId")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "achievementId", valid_580009
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : A randomly generated numeric ID for each request specified by the caller. This number is used at the server to ensure that the request is handled correctly across retries.
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
  ##   stepsToIncrement: JInt (required)
  ##                   : The number of steps to increment.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580010 = query.getOrDefault("fields")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "fields", valid_580010
  var valid_580011 = query.getOrDefault("requestId")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "requestId", valid_580011
  var valid_580012 = query.getOrDefault("quotaUser")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "quotaUser", valid_580012
  var valid_580013 = query.getOrDefault("alt")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("json"))
  if valid_580013 != nil:
    section.add "alt", valid_580013
  var valid_580014 = query.getOrDefault("oauth_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "oauth_token", valid_580014
  var valid_580015 = query.getOrDefault("userIp")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "userIp", valid_580015
  var valid_580016 = query.getOrDefault("key")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "key", valid_580016
  assert query != nil,
        "query argument is necessary due to required `stepsToIncrement` field"
  var valid_580017 = query.getOrDefault("stepsToIncrement")
  valid_580017 = validateParameter(valid_580017, JInt, required = true, default = nil)
  if valid_580017 != nil:
    section.add "stepsToIncrement", valid_580017
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

proc call*(call_580019: Call_GamesAchievementsIncrement_579992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Increments the steps of the achievement with the given ID for the currently authenticated player.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_GamesAchievementsIncrement_579992;
          stepsToIncrement: int; achievementId: string; fields: string = "";
          requestId: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesAchievementsIncrement
  ## Increments the steps of the achievement with the given ID for the currently authenticated player.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : A randomly generated numeric ID for each request specified by the caller. This number is used at the server to ensure that the request is handled correctly across retries.
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
  ##   stepsToIncrement: int (required)
  ##                   : The number of steps to increment.
  ##   achievementId: string (required)
  ##                : The ID of the achievement used by this method.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "requestId", newJString(requestId))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "userIp", newJString(userIp))
  add(query_580022, "key", newJString(key))
  add(query_580022, "stepsToIncrement", newJInt(stepsToIncrement))
  add(path_580021, "achievementId", newJString(achievementId))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var gamesAchievementsIncrement* = Call_GamesAchievementsIncrement_579992(
    name: "gamesAchievementsIncrement", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/increment",
    validator: validate_GamesAchievementsIncrement_579993, base: "/games/v1",
    url: url_GamesAchievementsIncrement_579994, schemes: {Scheme.Https})
type
  Call_GamesAchievementsReveal_580023 = ref object of OpenApiRestCall_579437
proc url_GamesAchievementsReveal_580025(protocol: Scheme; host: string; base: string;
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

proc validate_GamesAchievementsReveal_580024(path: JsonNode; query: JsonNode;
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
  var valid_580026 = path.getOrDefault("achievementId")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "achievementId", valid_580026
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
  if body != nil:
    result.add "body", body

proc call*(call_580034: Call_GamesAchievementsReveal_580023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the achievement with the given ID to REVEALED for the currently authenticated player.
  ## 
  let valid = call_580034.validator(path, query, header, formData, body)
  let scheme = call_580034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580034.url(scheme.get, call_580034.host, call_580034.base,
                         call_580034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580034, url, valid)

proc call*(call_580035: Call_GamesAchievementsReveal_580023; achievementId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesAchievementsReveal
  ## Sets the state of the achievement with the given ID to REVEALED for the currently authenticated player.
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
  ##   achievementId: string (required)
  ##                : The ID of the achievement used by this method.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580036 = newJObject()
  var query_580037 = newJObject()
  add(query_580037, "fields", newJString(fields))
  add(query_580037, "quotaUser", newJString(quotaUser))
  add(query_580037, "alt", newJString(alt))
  add(query_580037, "oauth_token", newJString(oauthToken))
  add(query_580037, "userIp", newJString(userIp))
  add(query_580037, "key", newJString(key))
  add(path_580036, "achievementId", newJString(achievementId))
  add(query_580037, "prettyPrint", newJBool(prettyPrint))
  result = call_580035.call(path_580036, query_580037, nil, nil, nil)

var gamesAchievementsReveal* = Call_GamesAchievementsReveal_580023(
    name: "gamesAchievementsReveal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/reveal",
    validator: validate_GamesAchievementsReveal_580024, base: "/games/v1",
    url: url_GamesAchievementsReveal_580025, schemes: {Scheme.Https})
type
  Call_GamesAchievementsSetStepsAtLeast_580038 = ref object of OpenApiRestCall_579437
proc url_GamesAchievementsSetStepsAtLeast_580040(protocol: Scheme; host: string;
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

proc validate_GamesAchievementsSetStepsAtLeast_580039(path: JsonNode;
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
  var valid_580041 = path.getOrDefault("achievementId")
  valid_580041 = validateParameter(valid_580041, JString, required = true,
                                 default = nil)
  if valid_580041 != nil:
    section.add "achievementId", valid_580041
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   steps: JInt (required)
  ##        : The minimum value to set the steps to.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580042 = query.getOrDefault("fields")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "fields", valid_580042
  var valid_580043 = query.getOrDefault("quotaUser")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "quotaUser", valid_580043
  var valid_580044 = query.getOrDefault("alt")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = newJString("json"))
  if valid_580044 != nil:
    section.add "alt", valid_580044
  assert query != nil, "query argument is necessary due to required `steps` field"
  var valid_580045 = query.getOrDefault("steps")
  valid_580045 = validateParameter(valid_580045, JInt, required = true, default = nil)
  if valid_580045 != nil:
    section.add "steps", valid_580045
  var valid_580046 = query.getOrDefault("oauth_token")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "oauth_token", valid_580046
  var valid_580047 = query.getOrDefault("userIp")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "userIp", valid_580047
  var valid_580048 = query.getOrDefault("key")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "key", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580050: Call_GamesAchievementsSetStepsAtLeast_580038;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the steps for the currently authenticated player towards unlocking an achievement. If the steps parameter is less than the current number of steps that the player already gained for the achievement, the achievement is not modified.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_GamesAchievementsSetStepsAtLeast_580038; steps: int;
          achievementId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesAchievementsSetStepsAtLeast
  ## Sets the steps for the currently authenticated player towards unlocking an achievement. If the steps parameter is less than the current number of steps that the player already gained for the achievement, the achievement is not modified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   steps: int (required)
  ##        : The minimum value to set the steps to.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   achievementId: string (required)
  ##                : The ID of the achievement used by this method.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "steps", newJInt(steps))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "userIp", newJString(userIp))
  add(query_580053, "key", newJString(key))
  add(path_580052, "achievementId", newJString(achievementId))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  result = call_580051.call(path_580052, query_580053, nil, nil, nil)

var gamesAchievementsSetStepsAtLeast* = Call_GamesAchievementsSetStepsAtLeast_580038(
    name: "gamesAchievementsSetStepsAtLeast", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/achievements/{achievementId}/setStepsAtLeast",
    validator: validate_GamesAchievementsSetStepsAtLeast_580039,
    base: "/games/v1", url: url_GamesAchievementsSetStepsAtLeast_580040,
    schemes: {Scheme.Https})
type
  Call_GamesAchievementsUnlock_580054 = ref object of OpenApiRestCall_579437
proc url_GamesAchievementsUnlock_580056(protocol: Scheme; host: string; base: string;
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

proc validate_GamesAchievementsUnlock_580055(path: JsonNode; query: JsonNode;
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
  var valid_580057 = path.getOrDefault("achievementId")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "achievementId", valid_580057
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   builtinGameId: JString
  ##                : Override used only by built-in games in Play Games application.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580058 = query.getOrDefault("fields")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "fields", valid_580058
  var valid_580059 = query.getOrDefault("quotaUser")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "quotaUser", valid_580059
  var valid_580060 = query.getOrDefault("alt")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("json"))
  if valid_580060 != nil:
    section.add "alt", valid_580060
  var valid_580061 = query.getOrDefault("builtinGameId")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "builtinGameId", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("userIp")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "userIp", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("prettyPrint")
  valid_580065 = validateParameter(valid_580065, JBool, required = false,
                                 default = newJBool(true))
  if valid_580065 != nil:
    section.add "prettyPrint", valid_580065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_GamesAchievementsUnlock_580054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unlocks this achievement for the currently authenticated player.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_GamesAchievementsUnlock_580054; achievementId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          builtinGameId: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesAchievementsUnlock
  ## Unlocks this achievement for the currently authenticated player.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   builtinGameId: string
  ##                : Override used only by built-in games in Play Games application.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   achievementId: string (required)
  ##                : The ID of the achievement used by this method.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "builtinGameId", newJString(builtinGameId))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "userIp", newJString(userIp))
  add(query_580069, "key", newJString(key))
  add(path_580068, "achievementId", newJString(achievementId))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  result = call_580067.call(path_580068, query_580069, nil, nil, nil)

var gamesAchievementsUnlock* = Call_GamesAchievementsUnlock_580054(
    name: "gamesAchievementsUnlock", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/unlock",
    validator: validate_GamesAchievementsUnlock_580055, base: "/games/v1",
    url: url_GamesAchievementsUnlock_580056, schemes: {Scheme.Https})
type
  Call_GamesApplicationsPlayed_580070 = ref object of OpenApiRestCall_579437
proc url_GamesApplicationsPlayed_580072(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesApplicationsPlayed_580071(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Indicate that the the currently authenticated user is playing your application.
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
  ##   builtinGameId: JString
  ##                : Override used only by built-in games in Play Games application.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580073 = query.getOrDefault("fields")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "fields", valid_580073
  var valid_580074 = query.getOrDefault("quotaUser")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "quotaUser", valid_580074
  var valid_580075 = query.getOrDefault("alt")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("json"))
  if valid_580075 != nil:
    section.add "alt", valid_580075
  var valid_580076 = query.getOrDefault("builtinGameId")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "builtinGameId", valid_580076
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("userIp")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "userIp", valid_580078
  var valid_580079 = query.getOrDefault("key")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "key", valid_580079
  var valid_580080 = query.getOrDefault("prettyPrint")
  valid_580080 = validateParameter(valid_580080, JBool, required = false,
                                 default = newJBool(true))
  if valid_580080 != nil:
    section.add "prettyPrint", valid_580080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580081: Call_GamesApplicationsPlayed_580070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicate that the the currently authenticated user is playing your application.
  ## 
  let valid = call_580081.validator(path, query, header, formData, body)
  let scheme = call_580081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580081.url(scheme.get, call_580081.host, call_580081.base,
                         call_580081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580081, url, valid)

proc call*(call_580082: Call_GamesApplicationsPlayed_580070; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; builtinGameId: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesApplicationsPlayed
  ## Indicate that the the currently authenticated user is playing your application.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   builtinGameId: string
  ##                : Override used only by built-in games in Play Games application.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580083 = newJObject()
  add(query_580083, "fields", newJString(fields))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(query_580083, "alt", newJString(alt))
  add(query_580083, "builtinGameId", newJString(builtinGameId))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(query_580083, "userIp", newJString(userIp))
  add(query_580083, "key", newJString(key))
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  result = call_580082.call(nil, query_580083, nil, nil, nil)

var gamesApplicationsPlayed* = Call_GamesApplicationsPlayed_580070(
    name: "gamesApplicationsPlayed", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/applications/played",
    validator: validate_GamesApplicationsPlayed_580071, base: "/games/v1",
    url: url_GamesApplicationsPlayed_580072, schemes: {Scheme.Https})
type
  Call_GamesApplicationsGet_580084 = ref object of OpenApiRestCall_579437
proc url_GamesApplicationsGet_580086(protocol: Scheme; host: string; base: string;
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

proc validate_GamesApplicationsGet_580085(path: JsonNode; query: JsonNode;
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
  var valid_580087 = path.getOrDefault("applicationId")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "applicationId", valid_580087
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   platformType: JString
  ##               : Restrict application details returned to the specific platform.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580088 = query.getOrDefault("fields")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "fields", valid_580088
  var valid_580089 = query.getOrDefault("quotaUser")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "quotaUser", valid_580089
  var valid_580090 = query.getOrDefault("alt")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = newJString("json"))
  if valid_580090 != nil:
    section.add "alt", valid_580090
  var valid_580091 = query.getOrDefault("language")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "language", valid_580091
  var valid_580092 = query.getOrDefault("oauth_token")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "oauth_token", valid_580092
  var valid_580093 = query.getOrDefault("userIp")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "userIp", valid_580093
  var valid_580094 = query.getOrDefault("key")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "key", valid_580094
  var valid_580095 = query.getOrDefault("platformType")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("ANDROID"))
  if valid_580095 != nil:
    section.add "platformType", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(true))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580097: Call_GamesApplicationsGet_580084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata of the application with the given ID. If the requested application is not available for the specified platformType, the returned response will not include any instance data.
  ## 
  let valid = call_580097.validator(path, query, header, formData, body)
  let scheme = call_580097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580097.url(scheme.get, call_580097.host, call_580097.base,
                         call_580097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580097, url, valid)

proc call*(call_580098: Call_GamesApplicationsGet_580084; applicationId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; platformType: string = "ANDROID"; prettyPrint: bool = true): Recallable =
  ## gamesApplicationsGet
  ## Retrieves the metadata of the application with the given ID. If the requested application is not available for the specified platformType, the returned response will not include any instance data.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   platformType: string
  ##               : Restrict application details returned to the specific platform.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580099 = newJObject()
  var query_580100 = newJObject()
  add(query_580100, "fields", newJString(fields))
  add(query_580100, "quotaUser", newJString(quotaUser))
  add(query_580100, "alt", newJString(alt))
  add(query_580100, "language", newJString(language))
  add(query_580100, "oauth_token", newJString(oauthToken))
  add(query_580100, "userIp", newJString(userIp))
  add(path_580099, "applicationId", newJString(applicationId))
  add(query_580100, "key", newJString(key))
  add(query_580100, "platformType", newJString(platformType))
  add(query_580100, "prettyPrint", newJBool(prettyPrint))
  result = call_580098.call(path_580099, query_580100, nil, nil, nil)

var gamesApplicationsGet* = Call_GamesApplicationsGet_580084(
    name: "gamesApplicationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}",
    validator: validate_GamesApplicationsGet_580085, base: "/games/v1",
    url: url_GamesApplicationsGet_580086, schemes: {Scheme.Https})
type
  Call_GamesApplicationsVerify_580101 = ref object of OpenApiRestCall_579437
proc url_GamesApplicationsVerify_580103(protocol: Scheme; host: string; base: string;
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

proc validate_GamesApplicationsVerify_580102(path: JsonNode; query: JsonNode;
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
  var valid_580104 = path.getOrDefault("applicationId")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "applicationId", valid_580104
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
  var valid_580105 = query.getOrDefault("fields")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "fields", valid_580105
  var valid_580106 = query.getOrDefault("quotaUser")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "quotaUser", valid_580106
  var valid_580107 = query.getOrDefault("alt")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("json"))
  if valid_580107 != nil:
    section.add "alt", valid_580107
  var valid_580108 = query.getOrDefault("oauth_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "oauth_token", valid_580108
  var valid_580109 = query.getOrDefault("userIp")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "userIp", valid_580109
  var valid_580110 = query.getOrDefault("key")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "key", valid_580110
  var valid_580111 = query.getOrDefault("prettyPrint")
  valid_580111 = validateParameter(valid_580111, JBool, required = false,
                                 default = newJBool(true))
  if valid_580111 != nil:
    section.add "prettyPrint", valid_580111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580112: Call_GamesApplicationsVerify_580101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies the auth token provided with this request is for the application with the specified ID, and returns the ID of the player it was granted for.
  ## 
  let valid = call_580112.validator(path, query, header, formData, body)
  let scheme = call_580112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580112.url(scheme.get, call_580112.host, call_580112.base,
                         call_580112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580112, url, valid)

proc call*(call_580113: Call_GamesApplicationsVerify_580101; applicationId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesApplicationsVerify
  ## Verifies the auth token provided with this request is for the application with the specified ID, and returns the ID of the player it was granted for.
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
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580114 = newJObject()
  var query_580115 = newJObject()
  add(query_580115, "fields", newJString(fields))
  add(query_580115, "quotaUser", newJString(quotaUser))
  add(query_580115, "alt", newJString(alt))
  add(query_580115, "oauth_token", newJString(oauthToken))
  add(query_580115, "userIp", newJString(userIp))
  add(path_580114, "applicationId", newJString(applicationId))
  add(query_580115, "key", newJString(key))
  add(query_580115, "prettyPrint", newJBool(prettyPrint))
  result = call_580113.call(path_580114, query_580115, nil, nil, nil)

var gamesApplicationsVerify* = Call_GamesApplicationsVerify_580101(
    name: "gamesApplicationsVerify", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}/verify",
    validator: validate_GamesApplicationsVerify_580102, base: "/games/v1",
    url: url_GamesApplicationsVerify_580103, schemes: {Scheme.Https})
type
  Call_GamesEventsListDefinitions_580116 = ref object of OpenApiRestCall_579437
proc url_GamesEventsListDefinitions_580118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesEventsListDefinitions_580117(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of the event definitions in this application.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of event definitions to return in the response, used for paging. For any response, the actual number of event definitions to return may be less than the specified maxResults.
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
  var valid_580120 = query.getOrDefault("pageToken")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "pageToken", valid_580120
  var valid_580121 = query.getOrDefault("quotaUser")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "quotaUser", valid_580121
  var valid_580122 = query.getOrDefault("alt")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("json"))
  if valid_580122 != nil:
    section.add "alt", valid_580122
  var valid_580123 = query.getOrDefault("language")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "language", valid_580123
  var valid_580124 = query.getOrDefault("oauth_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "oauth_token", valid_580124
  var valid_580125 = query.getOrDefault("userIp")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "userIp", valid_580125
  var valid_580126 = query.getOrDefault("maxResults")
  valid_580126 = validateParameter(valid_580126, JInt, required = false, default = nil)
  if valid_580126 != nil:
    section.add "maxResults", valid_580126
  var valid_580127 = query.getOrDefault("key")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "key", valid_580127
  var valid_580128 = query.getOrDefault("prettyPrint")
  valid_580128 = validateParameter(valid_580128, JBool, required = false,
                                 default = newJBool(true))
  if valid_580128 != nil:
    section.add "prettyPrint", valid_580128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580129: Call_GamesEventsListDefinitions_580116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the event definitions in this application.
  ## 
  let valid = call_580129.validator(path, query, header, formData, body)
  let scheme = call_580129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580129.url(scheme.get, call_580129.host, call_580129.base,
                         call_580129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580129, url, valid)

proc call*(call_580130: Call_GamesEventsListDefinitions_580116;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesEventsListDefinitions
  ## Returns a list of the event definitions in this application.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of event definitions to return in the response, used for paging. For any response, the actual number of event definitions to return may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580131 = newJObject()
  add(query_580131, "fields", newJString(fields))
  add(query_580131, "pageToken", newJString(pageToken))
  add(query_580131, "quotaUser", newJString(quotaUser))
  add(query_580131, "alt", newJString(alt))
  add(query_580131, "language", newJString(language))
  add(query_580131, "oauth_token", newJString(oauthToken))
  add(query_580131, "userIp", newJString(userIp))
  add(query_580131, "maxResults", newJInt(maxResults))
  add(query_580131, "key", newJString(key))
  add(query_580131, "prettyPrint", newJBool(prettyPrint))
  result = call_580130.call(nil, query_580131, nil, nil, nil)

var gamesEventsListDefinitions* = Call_GamesEventsListDefinitions_580116(
    name: "gamesEventsListDefinitions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/eventDefinitions",
    validator: validate_GamesEventsListDefinitions_580117, base: "/games/v1",
    url: url_GamesEventsListDefinitions_580118, schemes: {Scheme.Https})
type
  Call_GamesEventsRecord_580148 = ref object of OpenApiRestCall_579437
proc url_GamesEventsRecord_580150(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesEventsRecord_580149(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Records a batch of changes to the number of times events have occurred for the currently authenticated user of this application.
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580151 = query.getOrDefault("fields")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "fields", valid_580151
  var valid_580152 = query.getOrDefault("quotaUser")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "quotaUser", valid_580152
  var valid_580153 = query.getOrDefault("alt")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = newJString("json"))
  if valid_580153 != nil:
    section.add "alt", valid_580153
  var valid_580154 = query.getOrDefault("language")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "language", valid_580154
  var valid_580155 = query.getOrDefault("oauth_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "oauth_token", valid_580155
  var valid_580156 = query.getOrDefault("userIp")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "userIp", valid_580156
  var valid_580157 = query.getOrDefault("key")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "key", valid_580157
  var valid_580158 = query.getOrDefault("prettyPrint")
  valid_580158 = validateParameter(valid_580158, JBool, required = false,
                                 default = newJBool(true))
  if valid_580158 != nil:
    section.add "prettyPrint", valid_580158
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

proc call*(call_580160: Call_GamesEventsRecord_580148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Records a batch of changes to the number of times events have occurred for the currently authenticated user of this application.
  ## 
  let valid = call_580160.validator(path, query, header, formData, body)
  let scheme = call_580160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580160.url(scheme.get, call_580160.host, call_580160.base,
                         call_580160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580160, url, valid)

proc call*(call_580161: Call_GamesEventsRecord_580148; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; language: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesEventsRecord
  ## Records a batch of changes to the number of times events have occurred for the currently authenticated user of this application.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580162 = newJObject()
  var body_580163 = newJObject()
  add(query_580162, "fields", newJString(fields))
  add(query_580162, "quotaUser", newJString(quotaUser))
  add(query_580162, "alt", newJString(alt))
  add(query_580162, "language", newJString(language))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "userIp", newJString(userIp))
  add(query_580162, "key", newJString(key))
  if body != nil:
    body_580163 = body
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  result = call_580161.call(nil, query_580162, nil, nil, body_580163)

var gamesEventsRecord* = Call_GamesEventsRecord_580148(name: "gamesEventsRecord",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/events",
    validator: validate_GamesEventsRecord_580149, base: "/games/v1",
    url: url_GamesEventsRecord_580150, schemes: {Scheme.Https})
type
  Call_GamesEventsListByPlayer_580132 = ref object of OpenApiRestCall_579437
proc url_GamesEventsListByPlayer_580134(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesEventsListByPlayer_580133(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list showing the current progress on events in this application for the currently authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of events to return in the response, used for paging. For any response, the actual number of events to return may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580135 = query.getOrDefault("fields")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "fields", valid_580135
  var valid_580136 = query.getOrDefault("pageToken")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "pageToken", valid_580136
  var valid_580137 = query.getOrDefault("quotaUser")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "quotaUser", valid_580137
  var valid_580138 = query.getOrDefault("alt")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = newJString("json"))
  if valid_580138 != nil:
    section.add "alt", valid_580138
  var valid_580139 = query.getOrDefault("language")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "language", valid_580139
  var valid_580140 = query.getOrDefault("oauth_token")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "oauth_token", valid_580140
  var valid_580141 = query.getOrDefault("userIp")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "userIp", valid_580141
  var valid_580142 = query.getOrDefault("maxResults")
  valid_580142 = validateParameter(valid_580142, JInt, required = false, default = nil)
  if valid_580142 != nil:
    section.add "maxResults", valid_580142
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

proc call*(call_580145: Call_GamesEventsListByPlayer_580132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list showing the current progress on events in this application for the currently authenticated user.
  ## 
  let valid = call_580145.validator(path, query, header, formData, body)
  let scheme = call_580145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580145.url(scheme.get, call_580145.host, call_580145.base,
                         call_580145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580145, url, valid)

proc call*(call_580146: Call_GamesEventsListByPlayer_580132; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesEventsListByPlayer
  ## Returns a list showing the current progress on events in this application for the currently authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of events to return in the response, used for paging. For any response, the actual number of events to return may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580147 = newJObject()
  add(query_580147, "fields", newJString(fields))
  add(query_580147, "pageToken", newJString(pageToken))
  add(query_580147, "quotaUser", newJString(quotaUser))
  add(query_580147, "alt", newJString(alt))
  add(query_580147, "language", newJString(language))
  add(query_580147, "oauth_token", newJString(oauthToken))
  add(query_580147, "userIp", newJString(userIp))
  add(query_580147, "maxResults", newJInt(maxResults))
  add(query_580147, "key", newJString(key))
  add(query_580147, "prettyPrint", newJBool(prettyPrint))
  result = call_580146.call(nil, query_580147, nil, nil, nil)

var gamesEventsListByPlayer* = Call_GamesEventsListByPlayer_580132(
    name: "gamesEventsListByPlayer", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/events",
    validator: validate_GamesEventsListByPlayer_580133, base: "/games/v1",
    url: url_GamesEventsListByPlayer_580134, schemes: {Scheme.Https})
type
  Call_GamesLeaderboardsList_580164 = ref object of OpenApiRestCall_579437
proc url_GamesLeaderboardsList_580166(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesLeaderboardsList_580165(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the leaderboard metadata for your application.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of leaderboards to return in the response. For any response, the actual number of leaderboards returned may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580167 = query.getOrDefault("fields")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "fields", valid_580167
  var valid_580168 = query.getOrDefault("pageToken")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "pageToken", valid_580168
  var valid_580169 = query.getOrDefault("quotaUser")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "quotaUser", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("language")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "language", valid_580171
  var valid_580172 = query.getOrDefault("oauth_token")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "oauth_token", valid_580172
  var valid_580173 = query.getOrDefault("userIp")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "userIp", valid_580173
  var valid_580174 = query.getOrDefault("maxResults")
  valid_580174 = validateParameter(valid_580174, JInt, required = false, default = nil)
  if valid_580174 != nil:
    section.add "maxResults", valid_580174
  var valid_580175 = query.getOrDefault("key")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "key", valid_580175
  var valid_580176 = query.getOrDefault("prettyPrint")
  valid_580176 = validateParameter(valid_580176, JBool, required = false,
                                 default = newJBool(true))
  if valid_580176 != nil:
    section.add "prettyPrint", valid_580176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580177: Call_GamesLeaderboardsList_580164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the leaderboard metadata for your application.
  ## 
  let valid = call_580177.validator(path, query, header, formData, body)
  let scheme = call_580177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580177.url(scheme.get, call_580177.host, call_580177.base,
                         call_580177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580177, url, valid)

proc call*(call_580178: Call_GamesLeaderboardsList_580164; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesLeaderboardsList
  ## Lists all the leaderboard metadata for your application.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of leaderboards to return in the response. For any response, the actual number of leaderboards returned may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580179 = newJObject()
  add(query_580179, "fields", newJString(fields))
  add(query_580179, "pageToken", newJString(pageToken))
  add(query_580179, "quotaUser", newJString(quotaUser))
  add(query_580179, "alt", newJString(alt))
  add(query_580179, "language", newJString(language))
  add(query_580179, "oauth_token", newJString(oauthToken))
  add(query_580179, "userIp", newJString(userIp))
  add(query_580179, "maxResults", newJInt(maxResults))
  add(query_580179, "key", newJString(key))
  add(query_580179, "prettyPrint", newJBool(prettyPrint))
  result = call_580178.call(nil, query_580179, nil, nil, nil)

var gamesLeaderboardsList* = Call_GamesLeaderboardsList_580164(
    name: "gamesLeaderboardsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/leaderboards",
    validator: validate_GamesLeaderboardsList_580165, base: "/games/v1",
    url: url_GamesLeaderboardsList_580166, schemes: {Scheme.Https})
type
  Call_GamesScoresSubmitMultiple_580180 = ref object of OpenApiRestCall_579437
proc url_GamesScoresSubmitMultiple_580182(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesScoresSubmitMultiple_580181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submits multiple scores to leaderboards.
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580183 = query.getOrDefault("fields")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "fields", valid_580183
  var valid_580184 = query.getOrDefault("quotaUser")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "quotaUser", valid_580184
  var valid_580185 = query.getOrDefault("alt")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = newJString("json"))
  if valid_580185 != nil:
    section.add "alt", valid_580185
  var valid_580186 = query.getOrDefault("language")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "language", valid_580186
  var valid_580187 = query.getOrDefault("oauth_token")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "oauth_token", valid_580187
  var valid_580188 = query.getOrDefault("userIp")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "userIp", valid_580188
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

proc call*(call_580192: Call_GamesScoresSubmitMultiple_580180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits multiple scores to leaderboards.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_GamesScoresSubmitMultiple_580180; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; language: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesScoresSubmitMultiple
  ## Submits multiple scores to leaderboards.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580194 = newJObject()
  var body_580195 = newJObject()
  add(query_580194, "fields", newJString(fields))
  add(query_580194, "quotaUser", newJString(quotaUser))
  add(query_580194, "alt", newJString(alt))
  add(query_580194, "language", newJString(language))
  add(query_580194, "oauth_token", newJString(oauthToken))
  add(query_580194, "userIp", newJString(userIp))
  add(query_580194, "key", newJString(key))
  if body != nil:
    body_580195 = body
  add(query_580194, "prettyPrint", newJBool(prettyPrint))
  result = call_580193.call(nil, query_580194, nil, nil, body_580195)

var gamesScoresSubmitMultiple* = Call_GamesScoresSubmitMultiple_580180(
    name: "gamesScoresSubmitMultiple", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/leaderboards/scores",
    validator: validate_GamesScoresSubmitMultiple_580181, base: "/games/v1",
    url: url_GamesScoresSubmitMultiple_580182, schemes: {Scheme.Https})
type
  Call_GamesLeaderboardsGet_580196 = ref object of OpenApiRestCall_579437
proc url_GamesLeaderboardsGet_580198(protocol: Scheme; host: string; base: string;
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

proc validate_GamesLeaderboardsGet_580197(path: JsonNode; query: JsonNode;
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
  var valid_580199 = path.getOrDefault("leaderboardId")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "leaderboardId", valid_580199
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580200 = query.getOrDefault("fields")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "fields", valid_580200
  var valid_580201 = query.getOrDefault("quotaUser")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "quotaUser", valid_580201
  var valid_580202 = query.getOrDefault("alt")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("json"))
  if valid_580202 != nil:
    section.add "alt", valid_580202
  var valid_580203 = query.getOrDefault("language")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "language", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("userIp")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "userIp", valid_580205
  var valid_580206 = query.getOrDefault("key")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "key", valid_580206
  var valid_580207 = query.getOrDefault("prettyPrint")
  valid_580207 = validateParameter(valid_580207, JBool, required = false,
                                 default = newJBool(true))
  if valid_580207 != nil:
    section.add "prettyPrint", valid_580207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580208: Call_GamesLeaderboardsGet_580196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata of the leaderboard with the given ID.
  ## 
  let valid = call_580208.validator(path, query, header, formData, body)
  let scheme = call_580208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580208.url(scheme.get, call_580208.host, call_580208.base,
                         call_580208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580208, url, valid)

proc call*(call_580209: Call_GamesLeaderboardsGet_580196; leaderboardId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesLeaderboardsGet
  ## Retrieves the metadata of the leaderboard with the given ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580210 = newJObject()
  var query_580211 = newJObject()
  add(query_580211, "fields", newJString(fields))
  add(query_580211, "quotaUser", newJString(quotaUser))
  add(query_580211, "alt", newJString(alt))
  add(query_580211, "language", newJString(language))
  add(path_580210, "leaderboardId", newJString(leaderboardId))
  add(query_580211, "oauth_token", newJString(oauthToken))
  add(query_580211, "userIp", newJString(userIp))
  add(query_580211, "key", newJString(key))
  add(query_580211, "prettyPrint", newJBool(prettyPrint))
  result = call_580209.call(path_580210, query_580211, nil, nil, nil)

var gamesLeaderboardsGet* = Call_GamesLeaderboardsGet_580196(
    name: "gamesLeaderboardsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesLeaderboardsGet_580197, base: "/games/v1",
    url: url_GamesLeaderboardsGet_580198, schemes: {Scheme.Https})
type
  Call_GamesScoresSubmit_580212 = ref object of OpenApiRestCall_579437
proc url_GamesScoresSubmit_580214(protocol: Scheme; host: string; base: string;
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

proc validate_GamesScoresSubmit_580213(path: JsonNode; query: JsonNode;
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
  var valid_580215 = path.getOrDefault("leaderboardId")
  valid_580215 = validateParameter(valid_580215, JString, required = true,
                                 default = nil)
  if valid_580215 != nil:
    section.add "leaderboardId", valid_580215
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   scoreTag: JString
  ##           : Additional information about the score you're submitting. Values must contain no more than 64 URI-safe characters as defined by section 2.3 of RFC 3986.
  ##   score: JString (required)
  ##        : The score you're submitting. The submitted score is ignored if it is worse than a previously submitted score, where worse depends on the leaderboard sort order. The meaning of the score value depends on the leaderboard format type. For fixed-point, the score represents the raw value. For time, the score represents elapsed time in milliseconds. For currency, the score represents a value in micro units.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580216 = query.getOrDefault("fields")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "fields", valid_580216
  var valid_580217 = query.getOrDefault("quotaUser")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "quotaUser", valid_580217
  var valid_580218 = query.getOrDefault("alt")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("json"))
  if valid_580218 != nil:
    section.add "alt", valid_580218
  var valid_580219 = query.getOrDefault("language")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "language", valid_580219
  var valid_580220 = query.getOrDefault("oauth_token")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "oauth_token", valid_580220
  var valid_580221 = query.getOrDefault("userIp")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "userIp", valid_580221
  var valid_580222 = query.getOrDefault("key")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "key", valid_580222
  var valid_580223 = query.getOrDefault("scoreTag")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "scoreTag", valid_580223
  assert query != nil, "query argument is necessary due to required `score` field"
  var valid_580224 = query.getOrDefault("score")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "score", valid_580224
  var valid_580225 = query.getOrDefault("prettyPrint")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(true))
  if valid_580225 != nil:
    section.add "prettyPrint", valid_580225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580226: Call_GamesScoresSubmit_580212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a score to the specified leaderboard.
  ## 
  let valid = call_580226.validator(path, query, header, formData, body)
  let scheme = call_580226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580226.url(scheme.get, call_580226.host, call_580226.base,
                         call_580226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580226, url, valid)

proc call*(call_580227: Call_GamesScoresSubmit_580212; leaderboardId: string;
          score: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; scoreTag: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesScoresSubmit
  ## Submits a score to the specified leaderboard.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   scoreTag: string
  ##           : Additional information about the score you're submitting. Values must contain no more than 64 URI-safe characters as defined by section 2.3 of RFC 3986.
  ##   score: string (required)
  ##        : The score you're submitting. The submitted score is ignored if it is worse than a previously submitted score, where worse depends on the leaderboard sort order. The meaning of the score value depends on the leaderboard format type. For fixed-point, the score represents the raw value. For time, the score represents elapsed time in milliseconds. For currency, the score represents a value in micro units.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580228 = newJObject()
  var query_580229 = newJObject()
  add(query_580229, "fields", newJString(fields))
  add(query_580229, "quotaUser", newJString(quotaUser))
  add(query_580229, "alt", newJString(alt))
  add(query_580229, "language", newJString(language))
  add(path_580228, "leaderboardId", newJString(leaderboardId))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(query_580229, "userIp", newJString(userIp))
  add(query_580229, "key", newJString(key))
  add(query_580229, "scoreTag", newJString(scoreTag))
  add(query_580229, "score", newJString(score))
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  result = call_580227.call(path_580228, query_580229, nil, nil, nil)

var gamesScoresSubmit* = Call_GamesScoresSubmit_580212(name: "gamesScoresSubmit",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores",
    validator: validate_GamesScoresSubmit_580213, base: "/games/v1",
    url: url_GamesScoresSubmit_580214, schemes: {Scheme.Https})
type
  Call_GamesScoresList_580230 = ref object of OpenApiRestCall_579437
proc url_GamesScoresList_580232(protocol: Scheme; host: string; base: string;
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

proc validate_GamesScoresList_580231(path: JsonNode; query: JsonNode;
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
  var valid_580233 = path.getOrDefault("leaderboardId")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "leaderboardId", valid_580233
  var valid_580234 = path.getOrDefault("collection")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = newJString("PUBLIC"))
  if valid_580234 != nil:
    section.add "collection", valid_580234
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  ##   timeSpan: JString (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580235 = query.getOrDefault("fields")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "fields", valid_580235
  var valid_580236 = query.getOrDefault("pageToken")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "pageToken", valid_580236
  var valid_580237 = query.getOrDefault("quotaUser")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "quotaUser", valid_580237
  var valid_580238 = query.getOrDefault("alt")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("json"))
  if valid_580238 != nil:
    section.add "alt", valid_580238
  var valid_580239 = query.getOrDefault("language")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "language", valid_580239
  var valid_580240 = query.getOrDefault("oauth_token")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "oauth_token", valid_580240
  var valid_580241 = query.getOrDefault("userIp")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "userIp", valid_580241
  var valid_580242 = query.getOrDefault("maxResults")
  valid_580242 = validateParameter(valid_580242, JInt, required = false, default = nil)
  if valid_580242 != nil:
    section.add "maxResults", valid_580242
  assert query != nil,
        "query argument is necessary due to required `timeSpan` field"
  var valid_580243 = query.getOrDefault("timeSpan")
  valid_580243 = validateParameter(valid_580243, JString, required = true,
                                 default = newJString("ALL_TIME"))
  if valid_580243 != nil:
    section.add "timeSpan", valid_580243
  var valid_580244 = query.getOrDefault("key")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "key", valid_580244
  var valid_580245 = query.getOrDefault("prettyPrint")
  valid_580245 = validateParameter(valid_580245, JBool, required = false,
                                 default = newJBool(true))
  if valid_580245 != nil:
    section.add "prettyPrint", valid_580245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580246: Call_GamesScoresList_580230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the scores in a leaderboard, starting from the top.
  ## 
  let valid = call_580246.validator(path, query, header, formData, body)
  let scheme = call_580246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580246.url(scheme.get, call_580246.host, call_580246.base,
                         call_580246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580246, url, valid)

proc call*(call_580247: Call_GamesScoresList_580230; leaderboardId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = ""; oauthToken: string = "";
          collection: string = "PUBLIC"; userIp: string = ""; maxResults: int = 0;
          timeSpan: string = "ALL_TIME"; key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesScoresList
  ## Lists the scores in a leaderboard, starting from the top.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   collection: string (required)
  ##             : The collection of scores you're requesting.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  ##   timeSpan: string (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580248 = newJObject()
  var query_580249 = newJObject()
  add(query_580249, "fields", newJString(fields))
  add(query_580249, "pageToken", newJString(pageToken))
  add(query_580249, "quotaUser", newJString(quotaUser))
  add(query_580249, "alt", newJString(alt))
  add(query_580249, "language", newJString(language))
  add(path_580248, "leaderboardId", newJString(leaderboardId))
  add(query_580249, "oauth_token", newJString(oauthToken))
  add(path_580248, "collection", newJString(collection))
  add(query_580249, "userIp", newJString(userIp))
  add(query_580249, "maxResults", newJInt(maxResults))
  add(query_580249, "timeSpan", newJString(timeSpan))
  add(query_580249, "key", newJString(key))
  add(query_580249, "prettyPrint", newJBool(prettyPrint))
  result = call_580247.call(path_580248, query_580249, nil, nil, nil)

var gamesScoresList* = Call_GamesScoresList_580230(name: "gamesScoresList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/{collection}",
    validator: validate_GamesScoresList_580231, base: "/games/v1",
    url: url_GamesScoresList_580232, schemes: {Scheme.Https})
type
  Call_GamesScoresListWindow_580250 = ref object of OpenApiRestCall_579437
proc url_GamesScoresListWindow_580252(protocol: Scheme; host: string; base: string;
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

proc validate_GamesScoresListWindow_580251(path: JsonNode; query: JsonNode;
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
  var valid_580253 = path.getOrDefault("leaderboardId")
  valid_580253 = validateParameter(valid_580253, JString, required = true,
                                 default = nil)
  if valid_580253 != nil:
    section.add "leaderboardId", valid_580253
  var valid_580254 = path.getOrDefault("collection")
  valid_580254 = validateParameter(valid_580254, JString, required = true,
                                 default = newJString("PUBLIC"))
  if valid_580254 != nil:
    section.add "collection", valid_580254
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   resultsAbove: JInt
  ##               : The preferred number of scores to return above the player's score. More scores may be returned if the player is at the bottom of the leaderboard; fewer may be returned if the player is at the top. Must be less than or equal to maxResults.
  ##   maxResults: JInt
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  ##   timeSpan: JString (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   returnTopIfAbsent: JBool
  ##                    : True if the top scores should be returned when the player is not in the leaderboard. Defaults to true.
  section = newJObject()
  var valid_580255 = query.getOrDefault("fields")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "fields", valid_580255
  var valid_580256 = query.getOrDefault("pageToken")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "pageToken", valid_580256
  var valid_580257 = query.getOrDefault("quotaUser")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "quotaUser", valid_580257
  var valid_580258 = query.getOrDefault("alt")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = newJString("json"))
  if valid_580258 != nil:
    section.add "alt", valid_580258
  var valid_580259 = query.getOrDefault("language")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "language", valid_580259
  var valid_580260 = query.getOrDefault("oauth_token")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "oauth_token", valid_580260
  var valid_580261 = query.getOrDefault("userIp")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "userIp", valid_580261
  var valid_580262 = query.getOrDefault("resultsAbove")
  valid_580262 = validateParameter(valid_580262, JInt, required = false, default = nil)
  if valid_580262 != nil:
    section.add "resultsAbove", valid_580262
  var valid_580263 = query.getOrDefault("maxResults")
  valid_580263 = validateParameter(valid_580263, JInt, required = false, default = nil)
  if valid_580263 != nil:
    section.add "maxResults", valid_580263
  assert query != nil,
        "query argument is necessary due to required `timeSpan` field"
  var valid_580264 = query.getOrDefault("timeSpan")
  valid_580264 = validateParameter(valid_580264, JString, required = true,
                                 default = newJString("ALL_TIME"))
  if valid_580264 != nil:
    section.add "timeSpan", valid_580264
  var valid_580265 = query.getOrDefault("key")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "key", valid_580265
  var valid_580266 = query.getOrDefault("prettyPrint")
  valid_580266 = validateParameter(valid_580266, JBool, required = false,
                                 default = newJBool(true))
  if valid_580266 != nil:
    section.add "prettyPrint", valid_580266
  var valid_580267 = query.getOrDefault("returnTopIfAbsent")
  valid_580267 = validateParameter(valid_580267, JBool, required = false, default = nil)
  if valid_580267 != nil:
    section.add "returnTopIfAbsent", valid_580267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580268: Call_GamesScoresListWindow_580250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the scores in a leaderboard around (and including) a player's score.
  ## 
  let valid = call_580268.validator(path, query, header, formData, body)
  let scheme = call_580268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580268.url(scheme.get, call_580268.host, call_580268.base,
                         call_580268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580268, url, valid)

proc call*(call_580269: Call_GamesScoresListWindow_580250; leaderboardId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = ""; oauthToken: string = "";
          collection: string = "PUBLIC"; userIp: string = ""; resultsAbove: int = 0;
          maxResults: int = 0; timeSpan: string = "ALL_TIME"; key: string = "";
          prettyPrint: bool = true; returnTopIfAbsent: bool = false): Recallable =
  ## gamesScoresListWindow
  ## Lists the scores in a leaderboard around (and including) a player's score.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   collection: string (required)
  ##             : The collection of scores you're requesting.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   resultsAbove: int
  ##               : The preferred number of scores to return above the player's score. More scores may be returned if the player is at the bottom of the leaderboard; fewer may be returned if the player is at the top. Must be less than or equal to maxResults.
  ##   maxResults: int
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  ##   timeSpan: string (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   returnTopIfAbsent: bool
  ##                    : True if the top scores should be returned when the player is not in the leaderboard. Defaults to true.
  var path_580270 = newJObject()
  var query_580271 = newJObject()
  add(query_580271, "fields", newJString(fields))
  add(query_580271, "pageToken", newJString(pageToken))
  add(query_580271, "quotaUser", newJString(quotaUser))
  add(query_580271, "alt", newJString(alt))
  add(query_580271, "language", newJString(language))
  add(path_580270, "leaderboardId", newJString(leaderboardId))
  add(query_580271, "oauth_token", newJString(oauthToken))
  add(path_580270, "collection", newJString(collection))
  add(query_580271, "userIp", newJString(userIp))
  add(query_580271, "resultsAbove", newJInt(resultsAbove))
  add(query_580271, "maxResults", newJInt(maxResults))
  add(query_580271, "timeSpan", newJString(timeSpan))
  add(query_580271, "key", newJString(key))
  add(query_580271, "prettyPrint", newJBool(prettyPrint))
  add(query_580271, "returnTopIfAbsent", newJBool(returnTopIfAbsent))
  result = call_580269.call(path_580270, query_580271, nil, nil, nil)

var gamesScoresListWindow* = Call_GamesScoresListWindow_580250(
    name: "gamesScoresListWindow", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/window/{collection}",
    validator: validate_GamesScoresListWindow_580251, base: "/games/v1",
    url: url_GamesScoresListWindow_580252, schemes: {Scheme.Https})
type
  Call_GamesMetagameGetMetagameConfig_580272 = ref object of OpenApiRestCall_579437
proc url_GamesMetagameGetMetagameConfig_580274(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesMetagameGetMetagameConfig_580273(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return the metagame configuration data for the calling application.
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
  var valid_580275 = query.getOrDefault("fields")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "fields", valid_580275
  var valid_580276 = query.getOrDefault("quotaUser")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "quotaUser", valid_580276
  var valid_580277 = query.getOrDefault("alt")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = newJString("json"))
  if valid_580277 != nil:
    section.add "alt", valid_580277
  var valid_580278 = query.getOrDefault("oauth_token")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "oauth_token", valid_580278
  var valid_580279 = query.getOrDefault("userIp")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "userIp", valid_580279
  var valid_580280 = query.getOrDefault("key")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "key", valid_580280
  var valid_580281 = query.getOrDefault("prettyPrint")
  valid_580281 = validateParameter(valid_580281, JBool, required = false,
                                 default = newJBool(true))
  if valid_580281 != nil:
    section.add "prettyPrint", valid_580281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580282: Call_GamesMetagameGetMetagameConfig_580272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the metagame configuration data for the calling application.
  ## 
  let valid = call_580282.validator(path, query, header, formData, body)
  let scheme = call_580282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580282.url(scheme.get, call_580282.host, call_580282.base,
                         call_580282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580282, url, valid)

proc call*(call_580283: Call_GamesMetagameGetMetagameConfig_580272;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesMetagameGetMetagameConfig
  ## Return the metagame configuration data for the calling application.
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
  var query_580284 = newJObject()
  add(query_580284, "fields", newJString(fields))
  add(query_580284, "quotaUser", newJString(quotaUser))
  add(query_580284, "alt", newJString(alt))
  add(query_580284, "oauth_token", newJString(oauthToken))
  add(query_580284, "userIp", newJString(userIp))
  add(query_580284, "key", newJString(key))
  add(query_580284, "prettyPrint", newJBool(prettyPrint))
  result = call_580283.call(nil, query_580284, nil, nil, nil)

var gamesMetagameGetMetagameConfig* = Call_GamesMetagameGetMetagameConfig_580272(
    name: "gamesMetagameGetMetagameConfig", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metagameConfig",
    validator: validate_GamesMetagameGetMetagameConfig_580273, base: "/games/v1",
    url: url_GamesMetagameGetMetagameConfig_580274, schemes: {Scheme.Https})
type
  Call_GamesPlayersList_580285 = ref object of OpenApiRestCall_579437
proc url_GamesPlayersList_580287(protocol: Scheme; host: string; base: string;
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

proc validate_GamesPlayersList_580286(path: JsonNode; query: JsonNode;
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
  var valid_580288 = path.getOrDefault("collection")
  valid_580288 = validateParameter(valid_580288, JString, required = true,
                                 default = newJString("connected"))
  if valid_580288 != nil:
    section.add "collection", valid_580288
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of player resources to return in the response, used for paging. For any response, the actual number of player resources returned may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580289 = query.getOrDefault("fields")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "fields", valid_580289
  var valid_580290 = query.getOrDefault("pageToken")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "pageToken", valid_580290
  var valid_580291 = query.getOrDefault("quotaUser")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "quotaUser", valid_580291
  var valid_580292 = query.getOrDefault("alt")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = newJString("json"))
  if valid_580292 != nil:
    section.add "alt", valid_580292
  var valid_580293 = query.getOrDefault("language")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "language", valid_580293
  var valid_580294 = query.getOrDefault("oauth_token")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "oauth_token", valid_580294
  var valid_580295 = query.getOrDefault("userIp")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "userIp", valid_580295
  var valid_580296 = query.getOrDefault("maxResults")
  valid_580296 = validateParameter(valid_580296, JInt, required = false, default = nil)
  if valid_580296 != nil:
    section.add "maxResults", valid_580296
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580299: Call_GamesPlayersList_580285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the collection of players for the currently authenticated user.
  ## 
  let valid = call_580299.validator(path, query, header, formData, body)
  let scheme = call_580299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580299.url(scheme.get, call_580299.host, call_580299.base,
                         call_580299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580299, url, valid)

proc call*(call_580300: Call_GamesPlayersList_580285; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = "";
          collection: string = "connected"; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesPlayersList
  ## Get the collection of players for the currently authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   collection: string (required)
  ##             : Collection of players being retrieved
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of player resources to return in the response, used for paging. For any response, the actual number of player resources returned may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580301 = newJObject()
  var query_580302 = newJObject()
  add(query_580302, "fields", newJString(fields))
  add(query_580302, "pageToken", newJString(pageToken))
  add(query_580302, "quotaUser", newJString(quotaUser))
  add(query_580302, "alt", newJString(alt))
  add(query_580302, "language", newJString(language))
  add(query_580302, "oauth_token", newJString(oauthToken))
  add(path_580301, "collection", newJString(collection))
  add(query_580302, "userIp", newJString(userIp))
  add(query_580302, "maxResults", newJInt(maxResults))
  add(query_580302, "key", newJString(key))
  add(query_580302, "prettyPrint", newJBool(prettyPrint))
  result = call_580300.call(path_580301, query_580302, nil, nil, nil)

var gamesPlayersList* = Call_GamesPlayersList_580285(name: "gamesPlayersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/me/players/{collection}",
    validator: validate_GamesPlayersList_580286, base: "/games/v1",
    url: url_GamesPlayersList_580287, schemes: {Scheme.Https})
type
  Call_GamesPlayersGet_580303 = ref object of OpenApiRestCall_579437
proc url_GamesPlayersGet_580305(protocol: Scheme; host: string; base: string;
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

proc validate_GamesPlayersGet_580304(path: JsonNode; query: JsonNode;
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
  var valid_580306 = path.getOrDefault("playerId")
  valid_580306 = validateParameter(valid_580306, JString, required = true,
                                 default = nil)
  if valid_580306 != nil:
    section.add "playerId", valid_580306
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580307 = query.getOrDefault("fields")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "fields", valid_580307
  var valid_580308 = query.getOrDefault("quotaUser")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "quotaUser", valid_580308
  var valid_580309 = query.getOrDefault("alt")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = newJString("json"))
  if valid_580309 != nil:
    section.add "alt", valid_580309
  var valid_580310 = query.getOrDefault("language")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "language", valid_580310
  var valid_580311 = query.getOrDefault("oauth_token")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "oauth_token", valid_580311
  var valid_580312 = query.getOrDefault("userIp")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "userIp", valid_580312
  var valid_580313 = query.getOrDefault("key")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "key", valid_580313
  var valid_580314 = query.getOrDefault("prettyPrint")
  valid_580314 = validateParameter(valid_580314, JBool, required = false,
                                 default = newJBool(true))
  if valid_580314 != nil:
    section.add "prettyPrint", valid_580314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580315: Call_GamesPlayersGet_580303; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the Player resource with the given ID. To retrieve the player for the currently authenticated user, set playerId to me.
  ## 
  let valid = call_580315.validator(path, query, header, formData, body)
  let scheme = call_580315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580315.url(scheme.get, call_580315.host, call_580315.base,
                         call_580315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580315, url, valid)

proc call*(call_580316: Call_GamesPlayersGet_580303; playerId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesPlayersGet
  ## Retrieves the Player resource with the given ID. To retrieve the player for the currently authenticated user, set playerId to me.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580317 = newJObject()
  var query_580318 = newJObject()
  add(query_580318, "fields", newJString(fields))
  add(query_580318, "quotaUser", newJString(quotaUser))
  add(query_580318, "alt", newJString(alt))
  add(query_580318, "language", newJString(language))
  add(query_580318, "oauth_token", newJString(oauthToken))
  add(path_580317, "playerId", newJString(playerId))
  add(query_580318, "userIp", newJString(userIp))
  add(query_580318, "key", newJString(key))
  add(query_580318, "prettyPrint", newJBool(prettyPrint))
  result = call_580316.call(path_580317, query_580318, nil, nil, nil)

var gamesPlayersGet* = Call_GamesPlayersGet_580303(name: "gamesPlayersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/{playerId}", validator: validate_GamesPlayersGet_580304,
    base: "/games/v1", url: url_GamesPlayersGet_580305, schemes: {Scheme.Https})
type
  Call_GamesAchievementsList_580319 = ref object of OpenApiRestCall_579437
proc url_GamesAchievementsList_580321(protocol: Scheme; host: string; base: string;
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

proc validate_GamesAchievementsList_580320(path: JsonNode; query: JsonNode;
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
  var valid_580322 = path.getOrDefault("playerId")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "playerId", valid_580322
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of achievement resources to return in the response, used for paging. For any response, the actual number of achievement resources returned may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   state: JString
  ##        : Tells the server to return only achievements with the specified state. If this parameter isn't specified, all achievements are returned.
  section = newJObject()
  var valid_580323 = query.getOrDefault("fields")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "fields", valid_580323
  var valid_580324 = query.getOrDefault("pageToken")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "pageToken", valid_580324
  var valid_580325 = query.getOrDefault("quotaUser")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "quotaUser", valid_580325
  var valid_580326 = query.getOrDefault("alt")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("json"))
  if valid_580326 != nil:
    section.add "alt", valid_580326
  var valid_580327 = query.getOrDefault("language")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "language", valid_580327
  var valid_580328 = query.getOrDefault("oauth_token")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "oauth_token", valid_580328
  var valid_580329 = query.getOrDefault("userIp")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "userIp", valid_580329
  var valid_580330 = query.getOrDefault("maxResults")
  valid_580330 = validateParameter(valid_580330, JInt, required = false, default = nil)
  if valid_580330 != nil:
    section.add "maxResults", valid_580330
  var valid_580331 = query.getOrDefault("key")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "key", valid_580331
  var valid_580332 = query.getOrDefault("prettyPrint")
  valid_580332 = validateParameter(valid_580332, JBool, required = false,
                                 default = newJBool(true))
  if valid_580332 != nil:
    section.add "prettyPrint", valid_580332
  var valid_580333 = query.getOrDefault("state")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = newJString("ALL"))
  if valid_580333 != nil:
    section.add "state", valid_580333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580334: Call_GamesAchievementsList_580319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the progress for all your application's achievements for the currently authenticated player.
  ## 
  let valid = call_580334.validator(path, query, header, formData, body)
  let scheme = call_580334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580334.url(scheme.get, call_580334.host, call_580334.base,
                         call_580334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580334, url, valid)

proc call*(call_580335: Call_GamesAchievementsList_580319; playerId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true; state: string = "ALL"): Recallable =
  ## gamesAchievementsList
  ## Lists the progress for all your application's achievements for the currently authenticated player.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of achievement resources to return in the response, used for paging. For any response, the actual number of achievement resources returned may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   state: string
  ##        : Tells the server to return only achievements with the specified state. If this parameter isn't specified, all achievements are returned.
  var path_580336 = newJObject()
  var query_580337 = newJObject()
  add(query_580337, "fields", newJString(fields))
  add(query_580337, "pageToken", newJString(pageToken))
  add(query_580337, "quotaUser", newJString(quotaUser))
  add(query_580337, "alt", newJString(alt))
  add(query_580337, "language", newJString(language))
  add(query_580337, "oauth_token", newJString(oauthToken))
  add(path_580336, "playerId", newJString(playerId))
  add(query_580337, "userIp", newJString(userIp))
  add(query_580337, "maxResults", newJInt(maxResults))
  add(query_580337, "key", newJString(key))
  add(query_580337, "prettyPrint", newJBool(prettyPrint))
  add(query_580337, "state", newJString(state))
  result = call_580335.call(path_580336, query_580337, nil, nil, nil)

var gamesAchievementsList* = Call_GamesAchievementsList_580319(
    name: "gamesAchievementsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/players/{playerId}/achievements",
    validator: validate_GamesAchievementsList_580320, base: "/games/v1",
    url: url_GamesAchievementsList_580321, schemes: {Scheme.Https})
type
  Call_GamesMetagameListCategoriesByPlayer_580338 = ref object of OpenApiRestCall_579437
proc url_GamesMetagameListCategoriesByPlayer_580340(protocol: Scheme; host: string;
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

proc validate_GamesMetagameListCategoriesByPlayer_580339(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List play data aggregated per category for the player corresponding to playerId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collection: JString (required)
  ##             : The collection of categories for which data will be returned.
  ##   playerId: JString (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collection` field"
  var valid_580341 = path.getOrDefault("collection")
  valid_580341 = validateParameter(valid_580341, JString, required = true,
                                 default = newJString("all"))
  if valid_580341 != nil:
    section.add "collection", valid_580341
  var valid_580342 = path.getOrDefault("playerId")
  valid_580342 = validateParameter(valid_580342, JString, required = true,
                                 default = nil)
  if valid_580342 != nil:
    section.add "playerId", valid_580342
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of category resources to return in the response, used for paging. For any response, the actual number of category resources returned may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580343 = query.getOrDefault("fields")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "fields", valid_580343
  var valid_580344 = query.getOrDefault("pageToken")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "pageToken", valid_580344
  var valid_580345 = query.getOrDefault("quotaUser")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "quotaUser", valid_580345
  var valid_580346 = query.getOrDefault("alt")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = newJString("json"))
  if valid_580346 != nil:
    section.add "alt", valid_580346
  var valid_580347 = query.getOrDefault("language")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "language", valid_580347
  var valid_580348 = query.getOrDefault("oauth_token")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "oauth_token", valid_580348
  var valid_580349 = query.getOrDefault("userIp")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "userIp", valid_580349
  var valid_580350 = query.getOrDefault("maxResults")
  valid_580350 = validateParameter(valid_580350, JInt, required = false, default = nil)
  if valid_580350 != nil:
    section.add "maxResults", valid_580350
  var valid_580351 = query.getOrDefault("key")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "key", valid_580351
  var valid_580352 = query.getOrDefault("prettyPrint")
  valid_580352 = validateParameter(valid_580352, JBool, required = false,
                                 default = newJBool(true))
  if valid_580352 != nil:
    section.add "prettyPrint", valid_580352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580353: Call_GamesMetagameListCategoriesByPlayer_580338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List play data aggregated per category for the player corresponding to playerId.
  ## 
  let valid = call_580353.validator(path, query, header, formData, body)
  let scheme = call_580353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580353.url(scheme.get, call_580353.host, call_580353.base,
                         call_580353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580353, url, valid)

proc call*(call_580354: Call_GamesMetagameListCategoriesByPlayer_580338;
          playerId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; language: string = "";
          oauthToken: string = ""; collection: string = "all"; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesMetagameListCategoriesByPlayer
  ## List play data aggregated per category for the player corresponding to playerId.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   collection: string (required)
  ##             : The collection of categories for which data will be returned.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of category resources to return in the response, used for paging. For any response, the actual number of category resources returned may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580355 = newJObject()
  var query_580356 = newJObject()
  add(query_580356, "fields", newJString(fields))
  add(query_580356, "pageToken", newJString(pageToken))
  add(query_580356, "quotaUser", newJString(quotaUser))
  add(query_580356, "alt", newJString(alt))
  add(query_580356, "language", newJString(language))
  add(query_580356, "oauth_token", newJString(oauthToken))
  add(path_580355, "collection", newJString(collection))
  add(path_580355, "playerId", newJString(playerId))
  add(query_580356, "userIp", newJString(userIp))
  add(query_580356, "maxResults", newJInt(maxResults))
  add(query_580356, "key", newJString(key))
  add(query_580356, "prettyPrint", newJBool(prettyPrint))
  result = call_580354.call(path_580355, query_580356, nil, nil, nil)

var gamesMetagameListCategoriesByPlayer* = Call_GamesMetagameListCategoriesByPlayer_580338(
    name: "gamesMetagameListCategoriesByPlayer", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/players/{playerId}/categories/{collection}",
    validator: validate_GamesMetagameListCategoriesByPlayer_580339,
    base: "/games/v1", url: url_GamesMetagameListCategoriesByPlayer_580340,
    schemes: {Scheme.Https})
type
  Call_GamesScoresGet_580357 = ref object of OpenApiRestCall_579437
proc url_GamesScoresGet_580359(protocol: Scheme; host: string; base: string;
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

proc validate_GamesScoresGet_580358(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get high scores, and optionally ranks, in leaderboards for the currently authenticated player. For a specific time span, leaderboardId can be set to ALL to retrieve data for all leaderboards in a given time span.
  ## NOTE: You cannot ask for 'ALL' leaderboards and 'ALL' timeSpans in the same request; only one parameter may be set to 'ALL'.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   timeSpan: JString (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard. Can be set to 'ALL' to retrieve data for all leaderboards for this application.
  ##   playerId: JString (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `timeSpan` field"
  var valid_580360 = path.getOrDefault("timeSpan")
  valid_580360 = validateParameter(valid_580360, JString, required = true,
                                 default = newJString("ALL"))
  if valid_580360 != nil:
    section.add "timeSpan", valid_580360
  var valid_580361 = path.getOrDefault("leaderboardId")
  valid_580361 = validateParameter(valid_580361, JString, required = true,
                                 default = nil)
  if valid_580361 != nil:
    section.add "leaderboardId", valid_580361
  var valid_580362 = path.getOrDefault("playerId")
  valid_580362 = validateParameter(valid_580362, JString, required = true,
                                 default = nil)
  if valid_580362 != nil:
    section.add "playerId", valid_580362
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   includeRankType: JString
  ##                  : The types of ranks to return. If the parameter is omitted, no ranks will be returned.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580363 = query.getOrDefault("fields")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "fields", valid_580363
  var valid_580364 = query.getOrDefault("pageToken")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "pageToken", valid_580364
  var valid_580365 = query.getOrDefault("quotaUser")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "quotaUser", valid_580365
  var valid_580366 = query.getOrDefault("alt")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = newJString("json"))
  if valid_580366 != nil:
    section.add "alt", valid_580366
  var valid_580367 = query.getOrDefault("language")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "language", valid_580367
  var valid_580368 = query.getOrDefault("includeRankType")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = newJString("ALL"))
  if valid_580368 != nil:
    section.add "includeRankType", valid_580368
  var valid_580369 = query.getOrDefault("oauth_token")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "oauth_token", valid_580369
  var valid_580370 = query.getOrDefault("userIp")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "userIp", valid_580370
  var valid_580371 = query.getOrDefault("maxResults")
  valid_580371 = validateParameter(valid_580371, JInt, required = false, default = nil)
  if valid_580371 != nil:
    section.add "maxResults", valid_580371
  var valid_580372 = query.getOrDefault("key")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "key", valid_580372
  var valid_580373 = query.getOrDefault("prettyPrint")
  valid_580373 = validateParameter(valid_580373, JBool, required = false,
                                 default = newJBool(true))
  if valid_580373 != nil:
    section.add "prettyPrint", valid_580373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580374: Call_GamesScoresGet_580357; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get high scores, and optionally ranks, in leaderboards for the currently authenticated player. For a specific time span, leaderboardId can be set to ALL to retrieve data for all leaderboards in a given time span.
  ## NOTE: You cannot ask for 'ALL' leaderboards and 'ALL' timeSpans in the same request; only one parameter may be set to 'ALL'.
  ## 
  let valid = call_580374.validator(path, query, header, formData, body)
  let scheme = call_580374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580374.url(scheme.get, call_580374.host, call_580374.base,
                         call_580374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580374, url, valid)

proc call*(call_580375: Call_GamesScoresGet_580357; leaderboardId: string;
          playerId: string; timeSpan: string = "ALL"; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; includeRankType: string = "ALL";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesScoresGet
  ## Get high scores, and optionally ranks, in leaderboards for the currently authenticated player. For a specific time span, leaderboardId can be set to ALL to retrieve data for all leaderboards in a given time span.
  ## NOTE: You cannot ask for 'ALL' leaderboards and 'ALL' timeSpans in the same request; only one parameter may be set to 'ALL'.
  ##   timeSpan: string (required)
  ##           : The time span for the scores and ranks you're requesting.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   includeRankType: string
  ##                  : The types of ranks to return. If the parameter is omitted, no ranks will be returned.
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard. Can be set to 'ALL' to retrieve data for all leaderboards for this application.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of leaderboard scores to return in the response. For any response, the actual number of leaderboard scores returned may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580376 = newJObject()
  var query_580377 = newJObject()
  add(path_580376, "timeSpan", newJString(timeSpan))
  add(query_580377, "fields", newJString(fields))
  add(query_580377, "pageToken", newJString(pageToken))
  add(query_580377, "quotaUser", newJString(quotaUser))
  add(query_580377, "alt", newJString(alt))
  add(query_580377, "language", newJString(language))
  add(query_580377, "includeRankType", newJString(includeRankType))
  add(path_580376, "leaderboardId", newJString(leaderboardId))
  add(query_580377, "oauth_token", newJString(oauthToken))
  add(path_580376, "playerId", newJString(playerId))
  add(query_580377, "userIp", newJString(userIp))
  add(query_580377, "maxResults", newJInt(maxResults))
  add(query_580377, "key", newJString(key))
  add(query_580377, "prettyPrint", newJBool(prettyPrint))
  result = call_580375.call(path_580376, query_580377, nil, nil, nil)

var gamesScoresGet* = Call_GamesScoresGet_580357(name: "gamesScoresGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/players/{playerId}/leaderboards/{leaderboardId}/scores/{timeSpan}",
    validator: validate_GamesScoresGet_580358, base: "/games/v1",
    url: url_GamesScoresGet_580359, schemes: {Scheme.Https})
type
  Call_GamesQuestsList_580378 = ref object of OpenApiRestCall_579437
proc url_GamesQuestsList_580380(protocol: Scheme; host: string; base: string;
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

proc validate_GamesQuestsList_580379(path: JsonNode; query: JsonNode;
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
  var valid_580381 = path.getOrDefault("playerId")
  valid_580381 = validateParameter(valid_580381, JString, required = true,
                                 default = nil)
  if valid_580381 != nil:
    section.add "playerId", valid_580381
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of quest resources to return in the response, used for paging. For any response, the actual number of quest resources returned may be less than the specified maxResults. Acceptable values are 1 to 50, inclusive. (Default: 50).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580382 = query.getOrDefault("fields")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "fields", valid_580382
  var valid_580383 = query.getOrDefault("pageToken")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "pageToken", valid_580383
  var valid_580384 = query.getOrDefault("quotaUser")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "quotaUser", valid_580384
  var valid_580385 = query.getOrDefault("alt")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = newJString("json"))
  if valid_580385 != nil:
    section.add "alt", valid_580385
  var valid_580386 = query.getOrDefault("language")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "language", valid_580386
  var valid_580387 = query.getOrDefault("oauth_token")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "oauth_token", valid_580387
  var valid_580388 = query.getOrDefault("userIp")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "userIp", valid_580388
  var valid_580389 = query.getOrDefault("maxResults")
  valid_580389 = validateParameter(valid_580389, JInt, required = false, default = nil)
  if valid_580389 != nil:
    section.add "maxResults", valid_580389
  var valid_580390 = query.getOrDefault("key")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "key", valid_580390
  var valid_580391 = query.getOrDefault("prettyPrint")
  valid_580391 = validateParameter(valid_580391, JBool, required = false,
                                 default = newJBool(true))
  if valid_580391 != nil:
    section.add "prettyPrint", valid_580391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580392: Call_GamesQuestsList_580378; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of quests for your application and the currently authenticated player.
  ## 
  let valid = call_580392.validator(path, query, header, formData, body)
  let scheme = call_580392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580392.url(scheme.get, call_580392.host, call_580392.base,
                         call_580392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580392, url, valid)

proc call*(call_580393: Call_GamesQuestsList_580378; playerId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesQuestsList
  ## Get a list of quests for your application and the currently authenticated player.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of quest resources to return in the response, used for paging. For any response, the actual number of quest resources returned may be less than the specified maxResults. Acceptable values are 1 to 50, inclusive. (Default: 50).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580394 = newJObject()
  var query_580395 = newJObject()
  add(query_580395, "fields", newJString(fields))
  add(query_580395, "pageToken", newJString(pageToken))
  add(query_580395, "quotaUser", newJString(quotaUser))
  add(query_580395, "alt", newJString(alt))
  add(query_580395, "language", newJString(language))
  add(query_580395, "oauth_token", newJString(oauthToken))
  add(path_580394, "playerId", newJString(playerId))
  add(query_580395, "userIp", newJString(userIp))
  add(query_580395, "maxResults", newJInt(maxResults))
  add(query_580395, "key", newJString(key))
  add(query_580395, "prettyPrint", newJBool(prettyPrint))
  result = call_580393.call(path_580394, query_580395, nil, nil, nil)

var gamesQuestsList* = Call_GamesQuestsList_580378(name: "gamesQuestsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/{playerId}/quests", validator: validate_GamesQuestsList_580379,
    base: "/games/v1", url: url_GamesQuestsList_580380, schemes: {Scheme.Https})
type
  Call_GamesSnapshotsList_580396 = ref object of OpenApiRestCall_579437
proc url_GamesSnapshotsList_580398(protocol: Scheme; host: string; base: string;
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

proc validate_GamesSnapshotsList_580397(path: JsonNode; query: JsonNode;
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
  var valid_580399 = path.getOrDefault("playerId")
  valid_580399 = validateParameter(valid_580399, JString, required = true,
                                 default = nil)
  if valid_580399 != nil:
    section.add "playerId", valid_580399
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of snapshot resources to return in the response, used for paging. For any response, the actual number of snapshot resources returned may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580400 = query.getOrDefault("fields")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "fields", valid_580400
  var valid_580401 = query.getOrDefault("pageToken")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "pageToken", valid_580401
  var valid_580402 = query.getOrDefault("quotaUser")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "quotaUser", valid_580402
  var valid_580403 = query.getOrDefault("alt")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = newJString("json"))
  if valid_580403 != nil:
    section.add "alt", valid_580403
  var valid_580404 = query.getOrDefault("language")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "language", valid_580404
  var valid_580405 = query.getOrDefault("oauth_token")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "oauth_token", valid_580405
  var valid_580406 = query.getOrDefault("userIp")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "userIp", valid_580406
  var valid_580407 = query.getOrDefault("maxResults")
  valid_580407 = validateParameter(valid_580407, JInt, required = false, default = nil)
  if valid_580407 != nil:
    section.add "maxResults", valid_580407
  var valid_580408 = query.getOrDefault("key")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "key", valid_580408
  var valid_580409 = query.getOrDefault("prettyPrint")
  valid_580409 = validateParameter(valid_580409, JBool, required = false,
                                 default = newJBool(true))
  if valid_580409 != nil:
    section.add "prettyPrint", valid_580409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580410: Call_GamesSnapshotsList_580396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of snapshots created by your application for the player corresponding to the player ID.
  ## 
  let valid = call_580410.validator(path, query, header, formData, body)
  let scheme = call_580410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580410.url(scheme.get, call_580410.host, call_580410.base,
                         call_580410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580410, url, valid)

proc call*(call_580411: Call_GamesSnapshotsList_580396; playerId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesSnapshotsList
  ## Retrieves a list of snapshots created by your application for the player corresponding to the player ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of snapshot resources to return in the response, used for paging. For any response, the actual number of snapshot resources returned may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580412 = newJObject()
  var query_580413 = newJObject()
  add(query_580413, "fields", newJString(fields))
  add(query_580413, "pageToken", newJString(pageToken))
  add(query_580413, "quotaUser", newJString(quotaUser))
  add(query_580413, "alt", newJString(alt))
  add(query_580413, "language", newJString(language))
  add(query_580413, "oauth_token", newJString(oauthToken))
  add(path_580412, "playerId", newJString(playerId))
  add(query_580413, "userIp", newJString(userIp))
  add(query_580413, "maxResults", newJInt(maxResults))
  add(query_580413, "key", newJString(key))
  add(query_580413, "prettyPrint", newJBool(prettyPrint))
  result = call_580411.call(path_580412, query_580413, nil, nil, nil)

var gamesSnapshotsList* = Call_GamesSnapshotsList_580396(
    name: "gamesSnapshotsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/players/{playerId}/snapshots",
    validator: validate_GamesSnapshotsList_580397, base: "/games/v1",
    url: url_GamesSnapshotsList_580398, schemes: {Scheme.Https})
type
  Call_GamesPushtokensUpdate_580414 = ref object of OpenApiRestCall_579437
proc url_GamesPushtokensUpdate_580416(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesPushtokensUpdate_580415(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers a push token for the current user and application.
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
  var valid_580417 = query.getOrDefault("fields")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "fields", valid_580417
  var valid_580418 = query.getOrDefault("quotaUser")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "quotaUser", valid_580418
  var valid_580419 = query.getOrDefault("alt")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = newJString("json"))
  if valid_580419 != nil:
    section.add "alt", valid_580419
  var valid_580420 = query.getOrDefault("oauth_token")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "oauth_token", valid_580420
  var valid_580421 = query.getOrDefault("userIp")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "userIp", valid_580421
  var valid_580422 = query.getOrDefault("key")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "key", valid_580422
  var valid_580423 = query.getOrDefault("prettyPrint")
  valid_580423 = validateParameter(valid_580423, JBool, required = false,
                                 default = newJBool(true))
  if valid_580423 != nil:
    section.add "prettyPrint", valid_580423
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

proc call*(call_580425: Call_GamesPushtokensUpdate_580414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a push token for the current user and application.
  ## 
  let valid = call_580425.validator(path, query, header, formData, body)
  let scheme = call_580425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580425.url(scheme.get, call_580425.host, call_580425.base,
                         call_580425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580425, url, valid)

proc call*(call_580426: Call_GamesPushtokensUpdate_580414; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## gamesPushtokensUpdate
  ## Registers a push token for the current user and application.
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
  var query_580427 = newJObject()
  var body_580428 = newJObject()
  add(query_580427, "fields", newJString(fields))
  add(query_580427, "quotaUser", newJString(quotaUser))
  add(query_580427, "alt", newJString(alt))
  add(query_580427, "oauth_token", newJString(oauthToken))
  add(query_580427, "userIp", newJString(userIp))
  add(query_580427, "key", newJString(key))
  if body != nil:
    body_580428 = body
  add(query_580427, "prettyPrint", newJBool(prettyPrint))
  result = call_580426.call(nil, query_580427, nil, nil, body_580428)

var gamesPushtokensUpdate* = Call_GamesPushtokensUpdate_580414(
    name: "gamesPushtokensUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/pushtokens",
    validator: validate_GamesPushtokensUpdate_580415, base: "/games/v1",
    url: url_GamesPushtokensUpdate_580416, schemes: {Scheme.Https})
type
  Call_GamesPushtokensRemove_580429 = ref object of OpenApiRestCall_579437
proc url_GamesPushtokensRemove_580431(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesPushtokensRemove_580430(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a push token for the current user and application. Removing a non-existent push token will report success.
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
  var valid_580432 = query.getOrDefault("fields")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "fields", valid_580432
  var valid_580433 = query.getOrDefault("quotaUser")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "quotaUser", valid_580433
  var valid_580434 = query.getOrDefault("alt")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = newJString("json"))
  if valid_580434 != nil:
    section.add "alt", valid_580434
  var valid_580435 = query.getOrDefault("oauth_token")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "oauth_token", valid_580435
  var valid_580436 = query.getOrDefault("userIp")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "userIp", valid_580436
  var valid_580437 = query.getOrDefault("key")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "key", valid_580437
  var valid_580438 = query.getOrDefault("prettyPrint")
  valid_580438 = validateParameter(valid_580438, JBool, required = false,
                                 default = newJBool(true))
  if valid_580438 != nil:
    section.add "prettyPrint", valid_580438
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

proc call*(call_580440: Call_GamesPushtokensRemove_580429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a push token for the current user and application. Removing a non-existent push token will report success.
  ## 
  let valid = call_580440.validator(path, query, header, formData, body)
  let scheme = call_580440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580440.url(scheme.get, call_580440.host, call_580440.base,
                         call_580440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580440, url, valid)

proc call*(call_580441: Call_GamesPushtokensRemove_580429; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## gamesPushtokensRemove
  ## Removes a push token for the current user and application. Removing a non-existent push token will report success.
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
  var query_580442 = newJObject()
  var body_580443 = newJObject()
  add(query_580442, "fields", newJString(fields))
  add(query_580442, "quotaUser", newJString(quotaUser))
  add(query_580442, "alt", newJString(alt))
  add(query_580442, "oauth_token", newJString(oauthToken))
  add(query_580442, "userIp", newJString(userIp))
  add(query_580442, "key", newJString(key))
  if body != nil:
    body_580443 = body
  add(query_580442, "prettyPrint", newJBool(prettyPrint))
  result = call_580441.call(nil, query_580442, nil, nil, body_580443)

var gamesPushtokensRemove* = Call_GamesPushtokensRemove_580429(
    name: "gamesPushtokensRemove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pushtokens/remove",
    validator: validate_GamesPushtokensRemove_580430, base: "/games/v1",
    url: url_GamesPushtokensRemove_580431, schemes: {Scheme.Https})
type
  Call_GamesQuestsAccept_580444 = ref object of OpenApiRestCall_579437
proc url_GamesQuestsAccept_580446(protocol: Scheme; host: string; base: string;
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

proc validate_GamesQuestsAccept_580445(path: JsonNode; query: JsonNode;
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
  var valid_580447 = path.getOrDefault("questId")
  valid_580447 = validateParameter(valid_580447, JString, required = true,
                                 default = nil)
  if valid_580447 != nil:
    section.add "questId", valid_580447
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580448 = query.getOrDefault("fields")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "fields", valid_580448
  var valid_580449 = query.getOrDefault("quotaUser")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "quotaUser", valid_580449
  var valid_580450 = query.getOrDefault("alt")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = newJString("json"))
  if valid_580450 != nil:
    section.add "alt", valid_580450
  var valid_580451 = query.getOrDefault("language")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "language", valid_580451
  var valid_580452 = query.getOrDefault("oauth_token")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "oauth_token", valid_580452
  var valid_580453 = query.getOrDefault("userIp")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "userIp", valid_580453
  var valid_580454 = query.getOrDefault("key")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "key", valid_580454
  var valid_580455 = query.getOrDefault("prettyPrint")
  valid_580455 = validateParameter(valid_580455, JBool, required = false,
                                 default = newJBool(true))
  if valid_580455 != nil:
    section.add "prettyPrint", valid_580455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580456: Call_GamesQuestsAccept_580444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates that the currently authorized user will participate in the quest.
  ## 
  let valid = call_580456.validator(path, query, header, formData, body)
  let scheme = call_580456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580456.url(scheme.get, call_580456.host, call_580456.base,
                         call_580456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580456, url, valid)

proc call*(call_580457: Call_GamesQuestsAccept_580444; questId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesQuestsAccept
  ## Indicates that the currently authorized user will participate in the quest.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   questId: string (required)
  ##          : The ID of the quest.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580458 = newJObject()
  var query_580459 = newJObject()
  add(query_580459, "fields", newJString(fields))
  add(query_580459, "quotaUser", newJString(quotaUser))
  add(query_580459, "alt", newJString(alt))
  add(query_580459, "language", newJString(language))
  add(query_580459, "oauth_token", newJString(oauthToken))
  add(query_580459, "userIp", newJString(userIp))
  add(query_580459, "key", newJString(key))
  add(path_580458, "questId", newJString(questId))
  add(query_580459, "prettyPrint", newJBool(prettyPrint))
  result = call_580457.call(path_580458, query_580459, nil, nil, nil)

var gamesQuestsAccept* = Call_GamesQuestsAccept_580444(name: "gamesQuestsAccept",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/quests/{questId}/accept", validator: validate_GamesQuestsAccept_580445,
    base: "/games/v1", url: url_GamesQuestsAccept_580446, schemes: {Scheme.Https})
type
  Call_GamesQuestMilestonesClaim_580460 = ref object of OpenApiRestCall_579437
proc url_GamesQuestMilestonesClaim_580462(protocol: Scheme; host: string;
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

proc validate_GamesQuestMilestonesClaim_580461(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Report that a reward for the milestone corresponding to milestoneId for the quest corresponding to questId has been claimed by the currently authorized user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   milestoneId: JString (required)
  ##              : The ID of the milestone.
  ##   questId: JString (required)
  ##          : The ID of the quest.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `milestoneId` field"
  var valid_580463 = path.getOrDefault("milestoneId")
  valid_580463 = validateParameter(valid_580463, JString, required = true,
                                 default = nil)
  if valid_580463 != nil:
    section.add "milestoneId", valid_580463
  var valid_580464 = path.getOrDefault("questId")
  valid_580464 = validateParameter(valid_580464, JString, required = true,
                                 default = nil)
  if valid_580464 != nil:
    section.add "questId", valid_580464
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString (required)
  ##            : A numeric ID to ensure that the request is handled correctly across retries. Your client application must generate this ID randomly.
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
  var valid_580465 = query.getOrDefault("fields")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "fields", valid_580465
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_580466 = query.getOrDefault("requestId")
  valid_580466 = validateParameter(valid_580466, JString, required = true,
                                 default = nil)
  if valid_580466 != nil:
    section.add "requestId", valid_580466
  var valid_580467 = query.getOrDefault("quotaUser")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "quotaUser", valid_580467
  var valid_580468 = query.getOrDefault("alt")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = newJString("json"))
  if valid_580468 != nil:
    section.add "alt", valid_580468
  var valid_580469 = query.getOrDefault("oauth_token")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "oauth_token", valid_580469
  var valid_580470 = query.getOrDefault("userIp")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "userIp", valid_580470
  var valid_580471 = query.getOrDefault("key")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "key", valid_580471
  var valid_580472 = query.getOrDefault("prettyPrint")
  valid_580472 = validateParameter(valid_580472, JBool, required = false,
                                 default = newJBool(true))
  if valid_580472 != nil:
    section.add "prettyPrint", valid_580472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580473: Call_GamesQuestMilestonesClaim_580460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report that a reward for the milestone corresponding to milestoneId for the quest corresponding to questId has been claimed by the currently authorized user.
  ## 
  let valid = call_580473.validator(path, query, header, formData, body)
  let scheme = call_580473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580473.url(scheme.get, call_580473.host, call_580473.base,
                         call_580473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580473, url, valid)

proc call*(call_580474: Call_GamesQuestMilestonesClaim_580460; requestId: string;
          milestoneId: string; questId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesQuestMilestonesClaim
  ## Report that a reward for the milestone corresponding to milestoneId for the quest corresponding to questId has been claimed by the currently authorized user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string (required)
  ##            : A numeric ID to ensure that the request is handled correctly across retries. Your client application must generate this ID randomly.
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
  ##   milestoneId: string (required)
  ##              : The ID of the milestone.
  ##   questId: string (required)
  ##          : The ID of the quest.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580475 = newJObject()
  var query_580476 = newJObject()
  add(query_580476, "fields", newJString(fields))
  add(query_580476, "requestId", newJString(requestId))
  add(query_580476, "quotaUser", newJString(quotaUser))
  add(query_580476, "alt", newJString(alt))
  add(query_580476, "oauth_token", newJString(oauthToken))
  add(query_580476, "userIp", newJString(userIp))
  add(query_580476, "key", newJString(key))
  add(path_580475, "milestoneId", newJString(milestoneId))
  add(path_580475, "questId", newJString(questId))
  add(query_580476, "prettyPrint", newJBool(prettyPrint))
  result = call_580474.call(path_580475, query_580476, nil, nil, nil)

var gamesQuestMilestonesClaim* = Call_GamesQuestMilestonesClaim_580460(
    name: "gamesQuestMilestonesClaim", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/quests/{questId}/milestones/{milestoneId}/claim",
    validator: validate_GamesQuestMilestonesClaim_580461, base: "/games/v1",
    url: url_GamesQuestMilestonesClaim_580462, schemes: {Scheme.Https})
type
  Call_GamesRevisionsCheck_580477 = ref object of OpenApiRestCall_579437
proc url_GamesRevisionsCheck_580479(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesRevisionsCheck_580478(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Checks whether the games client is out of date.
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
  ##   clientRevision: JString (required)
  ##                 : The revision of the client SDK used by your application. Format:
  ## [PLATFORM_TYPE]:[VERSION_NUMBER]. Possible values of PLATFORM_TYPE are:
  ##  
  ## - "ANDROID" - Client is running the Android SDK. 
  ## - "IOS" - Client is running the iOS SDK. 
  ## - "WEB_APP" - Client is running as a Web App.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580480 = query.getOrDefault("fields")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "fields", valid_580480
  var valid_580481 = query.getOrDefault("quotaUser")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "quotaUser", valid_580481
  var valid_580482 = query.getOrDefault("alt")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = newJString("json"))
  if valid_580482 != nil:
    section.add "alt", valid_580482
  var valid_580483 = query.getOrDefault("oauth_token")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "oauth_token", valid_580483
  var valid_580484 = query.getOrDefault("userIp")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "userIp", valid_580484
  var valid_580485 = query.getOrDefault("key")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "key", valid_580485
  assert query != nil,
        "query argument is necessary due to required `clientRevision` field"
  var valid_580486 = query.getOrDefault("clientRevision")
  valid_580486 = validateParameter(valid_580486, JString, required = true,
                                 default = nil)
  if valid_580486 != nil:
    section.add "clientRevision", valid_580486
  var valid_580487 = query.getOrDefault("prettyPrint")
  valid_580487 = validateParameter(valid_580487, JBool, required = false,
                                 default = newJBool(true))
  if valid_580487 != nil:
    section.add "prettyPrint", valid_580487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580488: Call_GamesRevisionsCheck_580477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the games client is out of date.
  ## 
  let valid = call_580488.validator(path, query, header, formData, body)
  let scheme = call_580488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580488.url(scheme.get, call_580488.host, call_580488.base,
                         call_580488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580488, url, valid)

proc call*(call_580489: Call_GamesRevisionsCheck_580477; clientRevision: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesRevisionsCheck
  ## Checks whether the games client is out of date.
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
  ##   clientRevision: string (required)
  ##                 : The revision of the client SDK used by your application. Format:
  ## [PLATFORM_TYPE]:[VERSION_NUMBER]. Possible values of PLATFORM_TYPE are:
  ##  
  ## - "ANDROID" - Client is running the Android SDK. 
  ## - "IOS" - Client is running the iOS SDK. 
  ## - "WEB_APP" - Client is running as a Web App.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580490 = newJObject()
  add(query_580490, "fields", newJString(fields))
  add(query_580490, "quotaUser", newJString(quotaUser))
  add(query_580490, "alt", newJString(alt))
  add(query_580490, "oauth_token", newJString(oauthToken))
  add(query_580490, "userIp", newJString(userIp))
  add(query_580490, "key", newJString(key))
  add(query_580490, "clientRevision", newJString(clientRevision))
  add(query_580490, "prettyPrint", newJBool(prettyPrint))
  result = call_580489.call(nil, query_580490, nil, nil, nil)

var gamesRevisionsCheck* = Call_GamesRevisionsCheck_580477(
    name: "gamesRevisionsCheck", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/revisions/check",
    validator: validate_GamesRevisionsCheck_580478, base: "/games/v1",
    url: url_GamesRevisionsCheck_580479, schemes: {Scheme.Https})
type
  Call_GamesRoomsList_580491 = ref object of OpenApiRestCall_579437
proc url_GamesRoomsList_580493(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesRoomsList_580492(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns invitations to join rooms.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of rooms to return in the response, used for paging. For any response, the actual number of rooms to return may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580494 = query.getOrDefault("fields")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "fields", valid_580494
  var valid_580495 = query.getOrDefault("pageToken")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "pageToken", valid_580495
  var valid_580496 = query.getOrDefault("quotaUser")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "quotaUser", valid_580496
  var valid_580497 = query.getOrDefault("alt")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = newJString("json"))
  if valid_580497 != nil:
    section.add "alt", valid_580497
  var valid_580498 = query.getOrDefault("language")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "language", valid_580498
  var valid_580499 = query.getOrDefault("oauth_token")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "oauth_token", valid_580499
  var valid_580500 = query.getOrDefault("userIp")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "userIp", valid_580500
  var valid_580501 = query.getOrDefault("maxResults")
  valid_580501 = validateParameter(valid_580501, JInt, required = false, default = nil)
  if valid_580501 != nil:
    section.add "maxResults", valid_580501
  var valid_580502 = query.getOrDefault("key")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "key", valid_580502
  var valid_580503 = query.getOrDefault("prettyPrint")
  valid_580503 = validateParameter(valid_580503, JBool, required = false,
                                 default = newJBool(true))
  if valid_580503 != nil:
    section.add "prettyPrint", valid_580503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580504: Call_GamesRoomsList_580491; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns invitations to join rooms.
  ## 
  let valid = call_580504.validator(path, query, header, formData, body)
  let scheme = call_580504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580504.url(scheme.get, call_580504.host, call_580504.base,
                         call_580504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580504, url, valid)

proc call*(call_580505: Call_GamesRoomsList_580491; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesRoomsList
  ## Returns invitations to join rooms.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of rooms to return in the response, used for paging. For any response, the actual number of rooms to return may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580506 = newJObject()
  add(query_580506, "fields", newJString(fields))
  add(query_580506, "pageToken", newJString(pageToken))
  add(query_580506, "quotaUser", newJString(quotaUser))
  add(query_580506, "alt", newJString(alt))
  add(query_580506, "language", newJString(language))
  add(query_580506, "oauth_token", newJString(oauthToken))
  add(query_580506, "userIp", newJString(userIp))
  add(query_580506, "maxResults", newJInt(maxResults))
  add(query_580506, "key", newJString(key))
  add(query_580506, "prettyPrint", newJBool(prettyPrint))
  result = call_580505.call(nil, query_580506, nil, nil, nil)

var gamesRoomsList* = Call_GamesRoomsList_580491(name: "gamesRoomsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/rooms",
    validator: validate_GamesRoomsList_580492, base: "/games/v1",
    url: url_GamesRoomsList_580493, schemes: {Scheme.Https})
type
  Call_GamesRoomsCreate_580507 = ref object of OpenApiRestCall_579437
proc url_GamesRoomsCreate_580509(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesRoomsCreate_580508(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Create a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580510 = query.getOrDefault("fields")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "fields", valid_580510
  var valid_580511 = query.getOrDefault("quotaUser")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "quotaUser", valid_580511
  var valid_580512 = query.getOrDefault("alt")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = newJString("json"))
  if valid_580512 != nil:
    section.add "alt", valid_580512
  var valid_580513 = query.getOrDefault("language")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "language", valid_580513
  var valid_580514 = query.getOrDefault("oauth_token")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "oauth_token", valid_580514
  var valid_580515 = query.getOrDefault("userIp")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "userIp", valid_580515
  var valid_580516 = query.getOrDefault("key")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "key", valid_580516
  var valid_580517 = query.getOrDefault("prettyPrint")
  valid_580517 = validateParameter(valid_580517, JBool, required = false,
                                 default = newJBool(true))
  if valid_580517 != nil:
    section.add "prettyPrint", valid_580517
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

proc call*(call_580519: Call_GamesRoomsCreate_580507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580519.validator(path, query, header, formData, body)
  let scheme = call_580519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580519.url(scheme.get, call_580519.host, call_580519.base,
                         call_580519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580519, url, valid)

proc call*(call_580520: Call_GamesRoomsCreate_580507; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; language: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesRoomsCreate
  ## Create a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580521 = newJObject()
  var body_580522 = newJObject()
  add(query_580521, "fields", newJString(fields))
  add(query_580521, "quotaUser", newJString(quotaUser))
  add(query_580521, "alt", newJString(alt))
  add(query_580521, "language", newJString(language))
  add(query_580521, "oauth_token", newJString(oauthToken))
  add(query_580521, "userIp", newJString(userIp))
  add(query_580521, "key", newJString(key))
  if body != nil:
    body_580522 = body
  add(query_580521, "prettyPrint", newJBool(prettyPrint))
  result = call_580520.call(nil, query_580521, nil, nil, body_580522)

var gamesRoomsCreate* = Call_GamesRoomsCreate_580507(name: "gamesRoomsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/rooms/create",
    validator: validate_GamesRoomsCreate_580508, base: "/games/v1",
    url: url_GamesRoomsCreate_580509, schemes: {Scheme.Https})
type
  Call_GamesRoomsGet_580523 = ref object of OpenApiRestCall_579437
proc url_GamesRoomsGet_580525(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsGet_580524(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580526 = path.getOrDefault("roomId")
  valid_580526 = validateParameter(valid_580526, JString, required = true,
                                 default = nil)
  if valid_580526 != nil:
    section.add "roomId", valid_580526
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580527 = query.getOrDefault("fields")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "fields", valid_580527
  var valid_580528 = query.getOrDefault("quotaUser")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "quotaUser", valid_580528
  var valid_580529 = query.getOrDefault("alt")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = newJString("json"))
  if valid_580529 != nil:
    section.add "alt", valid_580529
  var valid_580530 = query.getOrDefault("language")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "language", valid_580530
  var valid_580531 = query.getOrDefault("oauth_token")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "oauth_token", valid_580531
  var valid_580532 = query.getOrDefault("userIp")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "userIp", valid_580532
  var valid_580533 = query.getOrDefault("key")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "key", valid_580533
  var valid_580534 = query.getOrDefault("prettyPrint")
  valid_580534 = validateParameter(valid_580534, JBool, required = false,
                                 default = newJBool(true))
  if valid_580534 != nil:
    section.add "prettyPrint", valid_580534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580535: Call_GamesRoomsGet_580523; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the data for a room.
  ## 
  let valid = call_580535.validator(path, query, header, formData, body)
  let scheme = call_580535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580535.url(scheme.get, call_580535.host, call_580535.base,
                         call_580535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580535, url, valid)

proc call*(call_580536: Call_GamesRoomsGet_580523; roomId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesRoomsGet
  ## Get the data for a room.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   roomId: string (required)
  ##         : The ID of the room.
  var path_580537 = newJObject()
  var query_580538 = newJObject()
  add(query_580538, "fields", newJString(fields))
  add(query_580538, "quotaUser", newJString(quotaUser))
  add(query_580538, "alt", newJString(alt))
  add(query_580538, "language", newJString(language))
  add(query_580538, "oauth_token", newJString(oauthToken))
  add(query_580538, "userIp", newJString(userIp))
  add(query_580538, "key", newJString(key))
  add(query_580538, "prettyPrint", newJBool(prettyPrint))
  add(path_580537, "roomId", newJString(roomId))
  result = call_580536.call(path_580537, query_580538, nil, nil, nil)

var gamesRoomsGet* = Call_GamesRoomsGet_580523(name: "gamesRoomsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/rooms/{roomId}",
    validator: validate_GamesRoomsGet_580524, base: "/games/v1",
    url: url_GamesRoomsGet_580525, schemes: {Scheme.Https})
type
  Call_GamesRoomsDecline_580539 = ref object of OpenApiRestCall_579437
proc url_GamesRoomsDecline_580541(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsDecline_580540(path: JsonNode; query: JsonNode;
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
  var valid_580542 = path.getOrDefault("roomId")
  valid_580542 = validateParameter(valid_580542, JString, required = true,
                                 default = nil)
  if valid_580542 != nil:
    section.add "roomId", valid_580542
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580543 = query.getOrDefault("fields")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = nil)
  if valid_580543 != nil:
    section.add "fields", valid_580543
  var valid_580544 = query.getOrDefault("quotaUser")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "quotaUser", valid_580544
  var valid_580545 = query.getOrDefault("alt")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = newJString("json"))
  if valid_580545 != nil:
    section.add "alt", valid_580545
  var valid_580546 = query.getOrDefault("language")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "language", valid_580546
  var valid_580547 = query.getOrDefault("oauth_token")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "oauth_token", valid_580547
  var valid_580548 = query.getOrDefault("userIp")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "userIp", valid_580548
  var valid_580549 = query.getOrDefault("key")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "key", valid_580549
  var valid_580550 = query.getOrDefault("prettyPrint")
  valid_580550 = validateParameter(valid_580550, JBool, required = false,
                                 default = newJBool(true))
  if valid_580550 != nil:
    section.add "prettyPrint", valid_580550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580551: Call_GamesRoomsDecline_580539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decline an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580551.validator(path, query, header, formData, body)
  let scheme = call_580551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580551.url(scheme.get, call_580551.host, call_580551.base,
                         call_580551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580551, url, valid)

proc call*(call_580552: Call_GamesRoomsDecline_580539; roomId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesRoomsDecline
  ## Decline an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   roomId: string (required)
  ##         : The ID of the room.
  var path_580553 = newJObject()
  var query_580554 = newJObject()
  add(query_580554, "fields", newJString(fields))
  add(query_580554, "quotaUser", newJString(quotaUser))
  add(query_580554, "alt", newJString(alt))
  add(query_580554, "language", newJString(language))
  add(query_580554, "oauth_token", newJString(oauthToken))
  add(query_580554, "userIp", newJString(userIp))
  add(query_580554, "key", newJString(key))
  add(query_580554, "prettyPrint", newJBool(prettyPrint))
  add(path_580553, "roomId", newJString(roomId))
  result = call_580552.call(path_580553, query_580554, nil, nil, nil)

var gamesRoomsDecline* = Call_GamesRoomsDecline_580539(name: "gamesRoomsDecline",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/decline", validator: validate_GamesRoomsDecline_580540,
    base: "/games/v1", url: url_GamesRoomsDecline_580541, schemes: {Scheme.Https})
type
  Call_GamesRoomsDismiss_580555 = ref object of OpenApiRestCall_579437
proc url_GamesRoomsDismiss_580557(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsDismiss_580556(path: JsonNode; query: JsonNode;
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
  var valid_580558 = path.getOrDefault("roomId")
  valid_580558 = validateParameter(valid_580558, JString, required = true,
                                 default = nil)
  if valid_580558 != nil:
    section.add "roomId", valid_580558
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
  var valid_580559 = query.getOrDefault("fields")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "fields", valid_580559
  var valid_580560 = query.getOrDefault("quotaUser")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "quotaUser", valid_580560
  var valid_580561 = query.getOrDefault("alt")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = newJString("json"))
  if valid_580561 != nil:
    section.add "alt", valid_580561
  var valid_580562 = query.getOrDefault("oauth_token")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "oauth_token", valid_580562
  var valid_580563 = query.getOrDefault("userIp")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "userIp", valid_580563
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580566: Call_GamesRoomsDismiss_580555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580566.validator(path, query, header, formData, body)
  let scheme = call_580566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580566.url(scheme.get, call_580566.host, call_580566.base,
                         call_580566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580566, url, valid)

proc call*(call_580567: Call_GamesRoomsDismiss_580555; roomId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesRoomsDismiss
  ## Dismiss an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
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
  ##   roomId: string (required)
  ##         : The ID of the room.
  var path_580568 = newJObject()
  var query_580569 = newJObject()
  add(query_580569, "fields", newJString(fields))
  add(query_580569, "quotaUser", newJString(quotaUser))
  add(query_580569, "alt", newJString(alt))
  add(query_580569, "oauth_token", newJString(oauthToken))
  add(query_580569, "userIp", newJString(userIp))
  add(query_580569, "key", newJString(key))
  add(query_580569, "prettyPrint", newJBool(prettyPrint))
  add(path_580568, "roomId", newJString(roomId))
  result = call_580567.call(path_580568, query_580569, nil, nil, nil)

var gamesRoomsDismiss* = Call_GamesRoomsDismiss_580555(name: "gamesRoomsDismiss",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/dismiss", validator: validate_GamesRoomsDismiss_580556,
    base: "/games/v1", url: url_GamesRoomsDismiss_580557, schemes: {Scheme.Https})
type
  Call_GamesRoomsJoin_580570 = ref object of OpenApiRestCall_579437
proc url_GamesRoomsJoin_580572(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsJoin_580571(path: JsonNode; query: JsonNode;
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
  var valid_580573 = path.getOrDefault("roomId")
  valid_580573 = validateParameter(valid_580573, JString, required = true,
                                 default = nil)
  if valid_580573 != nil:
    section.add "roomId", valid_580573
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
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
  var valid_580577 = query.getOrDefault("language")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "language", valid_580577
  var valid_580578 = query.getOrDefault("oauth_token")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "oauth_token", valid_580578
  var valid_580579 = query.getOrDefault("userIp")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "userIp", valid_580579
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

proc call*(call_580583: Call_GamesRoomsJoin_580570; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580583.validator(path, query, header, formData, body)
  let scheme = call_580583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580583.url(scheme.get, call_580583.host, call_580583.base,
                         call_580583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580583, url, valid)

proc call*(call_580584: Call_GamesRoomsJoin_580570; roomId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesRoomsJoin
  ## Join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   roomId: string (required)
  ##         : The ID of the room.
  var path_580585 = newJObject()
  var query_580586 = newJObject()
  var body_580587 = newJObject()
  add(query_580586, "fields", newJString(fields))
  add(query_580586, "quotaUser", newJString(quotaUser))
  add(query_580586, "alt", newJString(alt))
  add(query_580586, "language", newJString(language))
  add(query_580586, "oauth_token", newJString(oauthToken))
  add(query_580586, "userIp", newJString(userIp))
  add(query_580586, "key", newJString(key))
  if body != nil:
    body_580587 = body
  add(query_580586, "prettyPrint", newJBool(prettyPrint))
  add(path_580585, "roomId", newJString(roomId))
  result = call_580584.call(path_580585, query_580586, nil, nil, body_580587)

var gamesRoomsJoin* = Call_GamesRoomsJoin_580570(name: "gamesRoomsJoin",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/join", validator: validate_GamesRoomsJoin_580571,
    base: "/games/v1", url: url_GamesRoomsJoin_580572, schemes: {Scheme.Https})
type
  Call_GamesRoomsLeave_580588 = ref object of OpenApiRestCall_579437
proc url_GamesRoomsLeave_580590(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsLeave_580589(path: JsonNode; query: JsonNode;
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
  var valid_580591 = path.getOrDefault("roomId")
  valid_580591 = validateParameter(valid_580591, JString, required = true,
                                 default = nil)
  if valid_580591 != nil:
    section.add "roomId", valid_580591
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580592 = query.getOrDefault("fields")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "fields", valid_580592
  var valid_580593 = query.getOrDefault("quotaUser")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "quotaUser", valid_580593
  var valid_580594 = query.getOrDefault("alt")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = newJString("json"))
  if valid_580594 != nil:
    section.add "alt", valid_580594
  var valid_580595 = query.getOrDefault("language")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "language", valid_580595
  var valid_580596 = query.getOrDefault("oauth_token")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "oauth_token", valid_580596
  var valid_580597 = query.getOrDefault("userIp")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "userIp", valid_580597
  var valid_580598 = query.getOrDefault("key")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "key", valid_580598
  var valid_580599 = query.getOrDefault("prettyPrint")
  valid_580599 = validateParameter(valid_580599, JBool, required = false,
                                 default = newJBool(true))
  if valid_580599 != nil:
    section.add "prettyPrint", valid_580599
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

proc call*(call_580601: Call_GamesRoomsLeave_580588; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580601.validator(path, query, header, formData, body)
  let scheme = call_580601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580601.url(scheme.get, call_580601.host, call_580601.base,
                         call_580601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580601, url, valid)

proc call*(call_580602: Call_GamesRoomsLeave_580588; roomId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesRoomsLeave
  ## Leave a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   roomId: string (required)
  ##         : The ID of the room.
  var path_580603 = newJObject()
  var query_580604 = newJObject()
  var body_580605 = newJObject()
  add(query_580604, "fields", newJString(fields))
  add(query_580604, "quotaUser", newJString(quotaUser))
  add(query_580604, "alt", newJString(alt))
  add(query_580604, "language", newJString(language))
  add(query_580604, "oauth_token", newJString(oauthToken))
  add(query_580604, "userIp", newJString(userIp))
  add(query_580604, "key", newJString(key))
  if body != nil:
    body_580605 = body
  add(query_580604, "prettyPrint", newJBool(prettyPrint))
  add(path_580603, "roomId", newJString(roomId))
  result = call_580602.call(path_580603, query_580604, nil, nil, body_580605)

var gamesRoomsLeave* = Call_GamesRoomsLeave_580588(name: "gamesRoomsLeave",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/leave", validator: validate_GamesRoomsLeave_580589,
    base: "/games/v1", url: url_GamesRoomsLeave_580590, schemes: {Scheme.Https})
type
  Call_GamesRoomsReportStatus_580606 = ref object of OpenApiRestCall_579437
proc url_GamesRoomsReportStatus_580608(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsReportStatus_580607(path: JsonNode; query: JsonNode;
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
  var valid_580609 = path.getOrDefault("roomId")
  valid_580609 = validateParameter(valid_580609, JString, required = true,
                                 default = nil)
  if valid_580609 != nil:
    section.add "roomId", valid_580609
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580610 = query.getOrDefault("fields")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "fields", valid_580610
  var valid_580611 = query.getOrDefault("quotaUser")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "quotaUser", valid_580611
  var valid_580612 = query.getOrDefault("alt")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = newJString("json"))
  if valid_580612 != nil:
    section.add "alt", valid_580612
  var valid_580613 = query.getOrDefault("language")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "language", valid_580613
  var valid_580614 = query.getOrDefault("oauth_token")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "oauth_token", valid_580614
  var valid_580615 = query.getOrDefault("userIp")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "userIp", valid_580615
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

proc call*(call_580619: Call_GamesRoomsReportStatus_580606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates sent by a client reporting the status of peers in a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_580619.validator(path, query, header, formData, body)
  let scheme = call_580619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580619.url(scheme.get, call_580619.host, call_580619.base,
                         call_580619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580619, url, valid)

proc call*(call_580620: Call_GamesRoomsReportStatus_580606; roomId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesRoomsReportStatus
  ## Updates sent by a client reporting the status of peers in a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   roomId: string (required)
  ##         : The ID of the room.
  var path_580621 = newJObject()
  var query_580622 = newJObject()
  var body_580623 = newJObject()
  add(query_580622, "fields", newJString(fields))
  add(query_580622, "quotaUser", newJString(quotaUser))
  add(query_580622, "alt", newJString(alt))
  add(query_580622, "language", newJString(language))
  add(query_580622, "oauth_token", newJString(oauthToken))
  add(query_580622, "userIp", newJString(userIp))
  add(query_580622, "key", newJString(key))
  if body != nil:
    body_580623 = body
  add(query_580622, "prettyPrint", newJBool(prettyPrint))
  add(path_580621, "roomId", newJString(roomId))
  result = call_580620.call(path_580621, query_580622, nil, nil, body_580623)

var gamesRoomsReportStatus* = Call_GamesRoomsReportStatus_580606(
    name: "gamesRoomsReportStatus", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/{roomId}/reportstatus",
    validator: validate_GamesRoomsReportStatus_580607, base: "/games/v1",
    url: url_GamesRoomsReportStatus_580608, schemes: {Scheme.Https})
type
  Call_GamesSnapshotsGet_580624 = ref object of OpenApiRestCall_579437
proc url_GamesSnapshotsGet_580626(protocol: Scheme; host: string; base: string;
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

proc validate_GamesSnapshotsGet_580625(path: JsonNode; query: JsonNode;
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
  var valid_580627 = path.getOrDefault("snapshotId")
  valid_580627 = validateParameter(valid_580627, JString, required = true,
                                 default = nil)
  if valid_580627 != nil:
    section.add "snapshotId", valid_580627
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580628 = query.getOrDefault("fields")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "fields", valid_580628
  var valid_580629 = query.getOrDefault("quotaUser")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "quotaUser", valid_580629
  var valid_580630 = query.getOrDefault("alt")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = newJString("json"))
  if valid_580630 != nil:
    section.add "alt", valid_580630
  var valid_580631 = query.getOrDefault("language")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "language", valid_580631
  var valid_580632 = query.getOrDefault("oauth_token")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "oauth_token", valid_580632
  var valid_580633 = query.getOrDefault("userIp")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "userIp", valid_580633
  var valid_580634 = query.getOrDefault("key")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "key", valid_580634
  var valid_580635 = query.getOrDefault("prettyPrint")
  valid_580635 = validateParameter(valid_580635, JBool, required = false,
                                 default = newJBool(true))
  if valid_580635 != nil:
    section.add "prettyPrint", valid_580635
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580636: Call_GamesSnapshotsGet_580624; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata for a given snapshot ID.
  ## 
  let valid = call_580636.validator(path, query, header, formData, body)
  let scheme = call_580636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580636.url(scheme.get, call_580636.host, call_580636.base,
                         call_580636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580636, url, valid)

proc call*(call_580637: Call_GamesSnapshotsGet_580624; snapshotId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesSnapshotsGet
  ## Retrieves the metadata for a given snapshot ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   snapshotId: string (required)
  ##             : The ID of the snapshot.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580638 = newJObject()
  var query_580639 = newJObject()
  add(query_580639, "fields", newJString(fields))
  add(query_580639, "quotaUser", newJString(quotaUser))
  add(query_580639, "alt", newJString(alt))
  add(query_580639, "language", newJString(language))
  add(path_580638, "snapshotId", newJString(snapshotId))
  add(query_580639, "oauth_token", newJString(oauthToken))
  add(query_580639, "userIp", newJString(userIp))
  add(query_580639, "key", newJString(key))
  add(query_580639, "prettyPrint", newJBool(prettyPrint))
  result = call_580637.call(path_580638, query_580639, nil, nil, nil)

var gamesSnapshotsGet* = Call_GamesSnapshotsGet_580624(name: "gamesSnapshotsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/snapshots/{snapshotId}", validator: validate_GamesSnapshotsGet_580625,
    base: "/games/v1", url: url_GamesSnapshotsGet_580626, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesList_580640 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesList_580642(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesList_580641(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns turn-based matches the player is or was involved in.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   includeMatchData: JBool
  ##                   : True if match data should be returned in the response. Note that not all data will necessarily be returned if include_match_data is true; the server may decide to only return data for some of the matches to limit download size for the client. The remainder of the data for these matches will be retrievable on request.
  ##   maxCompletedMatches: JInt
  ##                      : The maximum number of completed or canceled matches to return in the response. If not set, all matches returned could be completed or canceled.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of matches to return in the response, used for paging. For any response, the actual number of matches to return may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580643 = query.getOrDefault("fields")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "fields", valid_580643
  var valid_580644 = query.getOrDefault("pageToken")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "pageToken", valid_580644
  var valid_580645 = query.getOrDefault("quotaUser")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "quotaUser", valid_580645
  var valid_580646 = query.getOrDefault("alt")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = newJString("json"))
  if valid_580646 != nil:
    section.add "alt", valid_580646
  var valid_580647 = query.getOrDefault("language")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "language", valid_580647
  var valid_580648 = query.getOrDefault("includeMatchData")
  valid_580648 = validateParameter(valid_580648, JBool, required = false, default = nil)
  if valid_580648 != nil:
    section.add "includeMatchData", valid_580648
  var valid_580649 = query.getOrDefault("maxCompletedMatches")
  valid_580649 = validateParameter(valid_580649, JInt, required = false, default = nil)
  if valid_580649 != nil:
    section.add "maxCompletedMatches", valid_580649
  var valid_580650 = query.getOrDefault("oauth_token")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = nil)
  if valid_580650 != nil:
    section.add "oauth_token", valid_580650
  var valid_580651 = query.getOrDefault("userIp")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "userIp", valid_580651
  var valid_580652 = query.getOrDefault("maxResults")
  valid_580652 = validateParameter(valid_580652, JInt, required = false, default = nil)
  if valid_580652 != nil:
    section.add "maxResults", valid_580652
  var valid_580653 = query.getOrDefault("key")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "key", valid_580653
  var valid_580654 = query.getOrDefault("prettyPrint")
  valid_580654 = validateParameter(valid_580654, JBool, required = false,
                                 default = newJBool(true))
  if valid_580654 != nil:
    section.add "prettyPrint", valid_580654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580655: Call_GamesTurnBasedMatchesList_580640; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns turn-based matches the player is or was involved in.
  ## 
  let valid = call_580655.validator(path, query, header, formData, body)
  let scheme = call_580655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580655.url(scheme.get, call_580655.host, call_580655.base,
                         call_580655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580655, url, valid)

proc call*(call_580656: Call_GamesTurnBasedMatchesList_580640; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; includeMatchData: bool = false;
          maxCompletedMatches: int = 0; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesList
  ## Returns turn-based matches the player is or was involved in.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   includeMatchData: bool
  ##                   : True if match data should be returned in the response. Note that not all data will necessarily be returned if include_match_data is true; the server may decide to only return data for some of the matches to limit download size for the client. The remainder of the data for these matches will be retrievable on request.
  ##   maxCompletedMatches: int
  ##                      : The maximum number of completed or canceled matches to return in the response. If not set, all matches returned could be completed or canceled.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of matches to return in the response, used for paging. For any response, the actual number of matches to return may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580657 = newJObject()
  add(query_580657, "fields", newJString(fields))
  add(query_580657, "pageToken", newJString(pageToken))
  add(query_580657, "quotaUser", newJString(quotaUser))
  add(query_580657, "alt", newJString(alt))
  add(query_580657, "language", newJString(language))
  add(query_580657, "includeMatchData", newJBool(includeMatchData))
  add(query_580657, "maxCompletedMatches", newJInt(maxCompletedMatches))
  add(query_580657, "oauth_token", newJString(oauthToken))
  add(query_580657, "userIp", newJString(userIp))
  add(query_580657, "maxResults", newJInt(maxResults))
  add(query_580657, "key", newJString(key))
  add(query_580657, "prettyPrint", newJBool(prettyPrint))
  result = call_580656.call(nil, query_580657, nil, nil, nil)

var gamesTurnBasedMatchesList* = Call_GamesTurnBasedMatchesList_580640(
    name: "gamesTurnBasedMatchesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches",
    validator: validate_GamesTurnBasedMatchesList_580641, base: "/games/v1",
    url: url_GamesTurnBasedMatchesList_580642, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesCreate_580658 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesCreate_580660(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesCreate_580659(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a turn-based match.
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
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580661 = query.getOrDefault("fields")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "fields", valid_580661
  var valid_580662 = query.getOrDefault("quotaUser")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "quotaUser", valid_580662
  var valid_580663 = query.getOrDefault("alt")
  valid_580663 = validateParameter(valid_580663, JString, required = false,
                                 default = newJString("json"))
  if valid_580663 != nil:
    section.add "alt", valid_580663
  var valid_580664 = query.getOrDefault("language")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "language", valid_580664
  var valid_580665 = query.getOrDefault("oauth_token")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = nil)
  if valid_580665 != nil:
    section.add "oauth_token", valid_580665
  var valid_580666 = query.getOrDefault("userIp")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = nil)
  if valid_580666 != nil:
    section.add "userIp", valid_580666
  var valid_580667 = query.getOrDefault("key")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "key", valid_580667
  var valid_580668 = query.getOrDefault("prettyPrint")
  valid_580668 = validateParameter(valid_580668, JBool, required = false,
                                 default = newJBool(true))
  if valid_580668 != nil:
    section.add "prettyPrint", valid_580668
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

proc call*(call_580670: Call_GamesTurnBasedMatchesCreate_580658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a turn-based match.
  ## 
  let valid = call_580670.validator(path, query, header, formData, body)
  let scheme = call_580670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580670.url(scheme.get, call_580670.host, call_580670.base,
                         call_580670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580670, url, valid)

proc call*(call_580671: Call_GamesTurnBasedMatchesCreate_580658;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesCreate
  ## Create a turn-based match.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580672 = newJObject()
  var body_580673 = newJObject()
  add(query_580672, "fields", newJString(fields))
  add(query_580672, "quotaUser", newJString(quotaUser))
  add(query_580672, "alt", newJString(alt))
  add(query_580672, "language", newJString(language))
  add(query_580672, "oauth_token", newJString(oauthToken))
  add(query_580672, "userIp", newJString(userIp))
  add(query_580672, "key", newJString(key))
  if body != nil:
    body_580673 = body
  add(query_580672, "prettyPrint", newJBool(prettyPrint))
  result = call_580671.call(nil, query_580672, nil, nil, body_580673)

var gamesTurnBasedMatchesCreate* = Call_GamesTurnBasedMatchesCreate_580658(
    name: "gamesTurnBasedMatchesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/create",
    validator: validate_GamesTurnBasedMatchesCreate_580659, base: "/games/v1",
    url: url_GamesTurnBasedMatchesCreate_580660, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesSync_580674 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesSync_580676(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesSync_580675(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns turn-based matches the player is or was involved in that changed since the last sync call, with the least recent changes coming first. Matches that should be removed from the local cache will have a status of MATCH_DELETED.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token returned by the previous request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   includeMatchData: JBool
  ##                   : True if match data should be returned in the response. Note that not all data will necessarily be returned if include_match_data is true; the server may decide to only return data for some of the matches to limit download size for the client. The remainder of the data for these matches will be retrievable on request.
  ##   maxCompletedMatches: JInt
  ##                      : The maximum number of completed or canceled matches to return in the response. If not set, all matches returned could be completed or canceled.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of matches to return in the response, used for paging. For any response, the actual number of matches to return may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580677 = query.getOrDefault("fields")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "fields", valid_580677
  var valid_580678 = query.getOrDefault("pageToken")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "pageToken", valid_580678
  var valid_580679 = query.getOrDefault("quotaUser")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "quotaUser", valid_580679
  var valid_580680 = query.getOrDefault("alt")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = newJString("json"))
  if valid_580680 != nil:
    section.add "alt", valid_580680
  var valid_580681 = query.getOrDefault("language")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = nil)
  if valid_580681 != nil:
    section.add "language", valid_580681
  var valid_580682 = query.getOrDefault("includeMatchData")
  valid_580682 = validateParameter(valid_580682, JBool, required = false, default = nil)
  if valid_580682 != nil:
    section.add "includeMatchData", valid_580682
  var valid_580683 = query.getOrDefault("maxCompletedMatches")
  valid_580683 = validateParameter(valid_580683, JInt, required = false, default = nil)
  if valid_580683 != nil:
    section.add "maxCompletedMatches", valid_580683
  var valid_580684 = query.getOrDefault("oauth_token")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "oauth_token", valid_580684
  var valid_580685 = query.getOrDefault("userIp")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "userIp", valid_580685
  var valid_580686 = query.getOrDefault("maxResults")
  valid_580686 = validateParameter(valid_580686, JInt, required = false, default = nil)
  if valid_580686 != nil:
    section.add "maxResults", valid_580686
  var valid_580687 = query.getOrDefault("key")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "key", valid_580687
  var valid_580688 = query.getOrDefault("prettyPrint")
  valid_580688 = validateParameter(valid_580688, JBool, required = false,
                                 default = newJBool(true))
  if valid_580688 != nil:
    section.add "prettyPrint", valid_580688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580689: Call_GamesTurnBasedMatchesSync_580674; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns turn-based matches the player is or was involved in that changed since the last sync call, with the least recent changes coming first. Matches that should be removed from the local cache will have a status of MATCH_DELETED.
  ## 
  let valid = call_580689.validator(path, query, header, formData, body)
  let scheme = call_580689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580689.url(scheme.get, call_580689.host, call_580689.base,
                         call_580689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580689, url, valid)

proc call*(call_580690: Call_GamesTurnBasedMatchesSync_580674; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; includeMatchData: bool = false;
          maxCompletedMatches: int = 0; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesSync
  ## Returns turn-based matches the player is or was involved in that changed since the last sync call, with the least recent changes coming first. Matches that should be removed from the local cache will have a status of MATCH_DELETED.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   includeMatchData: bool
  ##                   : True if match data should be returned in the response. Note that not all data will necessarily be returned if include_match_data is true; the server may decide to only return data for some of the matches to limit download size for the client. The remainder of the data for these matches will be retrievable on request.
  ##   maxCompletedMatches: int
  ##                      : The maximum number of completed or canceled matches to return in the response. If not set, all matches returned could be completed or canceled.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of matches to return in the response, used for paging. For any response, the actual number of matches to return may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580691 = newJObject()
  add(query_580691, "fields", newJString(fields))
  add(query_580691, "pageToken", newJString(pageToken))
  add(query_580691, "quotaUser", newJString(quotaUser))
  add(query_580691, "alt", newJString(alt))
  add(query_580691, "language", newJString(language))
  add(query_580691, "includeMatchData", newJBool(includeMatchData))
  add(query_580691, "maxCompletedMatches", newJInt(maxCompletedMatches))
  add(query_580691, "oauth_token", newJString(oauthToken))
  add(query_580691, "userIp", newJString(userIp))
  add(query_580691, "maxResults", newJInt(maxResults))
  add(query_580691, "key", newJString(key))
  add(query_580691, "prettyPrint", newJBool(prettyPrint))
  result = call_580690.call(nil, query_580691, nil, nil, nil)

var gamesTurnBasedMatchesSync* = Call_GamesTurnBasedMatchesSync_580674(
    name: "gamesTurnBasedMatchesSync", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches/sync",
    validator: validate_GamesTurnBasedMatchesSync_580675, base: "/games/v1",
    url: url_GamesTurnBasedMatchesSync_580676, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesGet_580692 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesGet_580694(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesGet_580693(path: JsonNode; query: JsonNode;
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
  var valid_580695 = path.getOrDefault("matchId")
  valid_580695 = validateParameter(valid_580695, JString, required = true,
                                 default = nil)
  if valid_580695 != nil:
    section.add "matchId", valid_580695
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   includeMatchData: JBool
  ##                   : Get match data along with metadata.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580696 = query.getOrDefault("fields")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "fields", valid_580696
  var valid_580697 = query.getOrDefault("quotaUser")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "quotaUser", valid_580697
  var valid_580698 = query.getOrDefault("alt")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = newJString("json"))
  if valid_580698 != nil:
    section.add "alt", valid_580698
  var valid_580699 = query.getOrDefault("language")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "language", valid_580699
  var valid_580700 = query.getOrDefault("includeMatchData")
  valid_580700 = validateParameter(valid_580700, JBool, required = false, default = nil)
  if valid_580700 != nil:
    section.add "includeMatchData", valid_580700
  var valid_580701 = query.getOrDefault("oauth_token")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "oauth_token", valid_580701
  var valid_580702 = query.getOrDefault("userIp")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "userIp", valid_580702
  var valid_580703 = query.getOrDefault("key")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "key", valid_580703
  var valid_580704 = query.getOrDefault("prettyPrint")
  valid_580704 = validateParameter(valid_580704, JBool, required = false,
                                 default = newJBool(true))
  if valid_580704 != nil:
    section.add "prettyPrint", valid_580704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580705: Call_GamesTurnBasedMatchesGet_580692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the data for a turn-based match.
  ## 
  let valid = call_580705.validator(path, query, header, formData, body)
  let scheme = call_580705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580705.url(scheme.get, call_580705.host, call_580705.base,
                         call_580705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580705, url, valid)

proc call*(call_580706: Call_GamesTurnBasedMatchesGet_580692; matchId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; includeMatchData: bool = false;
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesGet
  ## Get the data for a turn-based match.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   includeMatchData: bool
  ##                   : Get match data along with metadata.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580707 = newJObject()
  var query_580708 = newJObject()
  add(query_580708, "fields", newJString(fields))
  add(query_580708, "quotaUser", newJString(quotaUser))
  add(query_580708, "alt", newJString(alt))
  add(query_580708, "language", newJString(language))
  add(query_580708, "includeMatchData", newJBool(includeMatchData))
  add(query_580708, "oauth_token", newJString(oauthToken))
  add(query_580708, "userIp", newJString(userIp))
  add(query_580708, "key", newJString(key))
  add(path_580707, "matchId", newJString(matchId))
  add(query_580708, "prettyPrint", newJBool(prettyPrint))
  result = call_580706.call(path_580707, query_580708, nil, nil, nil)

var gamesTurnBasedMatchesGet* = Call_GamesTurnBasedMatchesGet_580692(
    name: "gamesTurnBasedMatchesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}",
    validator: validate_GamesTurnBasedMatchesGet_580693, base: "/games/v1",
    url: url_GamesTurnBasedMatchesGet_580694, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesCancel_580709 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesCancel_580711(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesCancel_580710(path: JsonNode; query: JsonNode;
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
  var valid_580712 = path.getOrDefault("matchId")
  valid_580712 = validateParameter(valid_580712, JString, required = true,
                                 default = nil)
  if valid_580712 != nil:
    section.add "matchId", valid_580712
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
  var valid_580713 = query.getOrDefault("fields")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "fields", valid_580713
  var valid_580714 = query.getOrDefault("quotaUser")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "quotaUser", valid_580714
  var valid_580715 = query.getOrDefault("alt")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = newJString("json"))
  if valid_580715 != nil:
    section.add "alt", valid_580715
  var valid_580716 = query.getOrDefault("oauth_token")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "oauth_token", valid_580716
  var valid_580717 = query.getOrDefault("userIp")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = nil)
  if valid_580717 != nil:
    section.add "userIp", valid_580717
  var valid_580718 = query.getOrDefault("key")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "key", valid_580718
  var valid_580719 = query.getOrDefault("prettyPrint")
  valid_580719 = validateParameter(valid_580719, JBool, required = false,
                                 default = newJBool(true))
  if valid_580719 != nil:
    section.add "prettyPrint", valid_580719
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580720: Call_GamesTurnBasedMatchesCancel_580709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a turn-based match.
  ## 
  let valid = call_580720.validator(path, query, header, formData, body)
  let scheme = call_580720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580720.url(scheme.get, call_580720.host, call_580720.base,
                         call_580720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580720, url, valid)

proc call*(call_580721: Call_GamesTurnBasedMatchesCancel_580709; matchId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesCancel
  ## Cancel a turn-based match.
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
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580722 = newJObject()
  var query_580723 = newJObject()
  add(query_580723, "fields", newJString(fields))
  add(query_580723, "quotaUser", newJString(quotaUser))
  add(query_580723, "alt", newJString(alt))
  add(query_580723, "oauth_token", newJString(oauthToken))
  add(query_580723, "userIp", newJString(userIp))
  add(query_580723, "key", newJString(key))
  add(path_580722, "matchId", newJString(matchId))
  add(query_580723, "prettyPrint", newJBool(prettyPrint))
  result = call_580721.call(path_580722, query_580723, nil, nil, nil)

var gamesTurnBasedMatchesCancel* = Call_GamesTurnBasedMatchesCancel_580709(
    name: "gamesTurnBasedMatchesCancel", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/cancel",
    validator: validate_GamesTurnBasedMatchesCancel_580710, base: "/games/v1",
    url: url_GamesTurnBasedMatchesCancel_580711, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesDecline_580724 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesDecline_580726(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesDecline_580725(path: JsonNode; query: JsonNode;
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
  var valid_580727 = path.getOrDefault("matchId")
  valid_580727 = validateParameter(valid_580727, JString, required = true,
                                 default = nil)
  if valid_580727 != nil:
    section.add "matchId", valid_580727
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580728 = query.getOrDefault("fields")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = nil)
  if valid_580728 != nil:
    section.add "fields", valid_580728
  var valid_580729 = query.getOrDefault("quotaUser")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = nil)
  if valid_580729 != nil:
    section.add "quotaUser", valid_580729
  var valid_580730 = query.getOrDefault("alt")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = newJString("json"))
  if valid_580730 != nil:
    section.add "alt", valid_580730
  var valid_580731 = query.getOrDefault("language")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "language", valid_580731
  var valid_580732 = query.getOrDefault("oauth_token")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "oauth_token", valid_580732
  var valid_580733 = query.getOrDefault("userIp")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "userIp", valid_580733
  var valid_580734 = query.getOrDefault("key")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "key", valid_580734
  var valid_580735 = query.getOrDefault("prettyPrint")
  valid_580735 = validateParameter(valid_580735, JBool, required = false,
                                 default = newJBool(true))
  if valid_580735 != nil:
    section.add "prettyPrint", valid_580735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580736: Call_GamesTurnBasedMatchesDecline_580724; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decline an invitation to play a turn-based match.
  ## 
  let valid = call_580736.validator(path, query, header, formData, body)
  let scheme = call_580736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580736.url(scheme.get, call_580736.host, call_580736.base,
                         call_580736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580736, url, valid)

proc call*(call_580737: Call_GamesTurnBasedMatchesDecline_580724; matchId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesDecline
  ## Decline an invitation to play a turn-based match.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580738 = newJObject()
  var query_580739 = newJObject()
  add(query_580739, "fields", newJString(fields))
  add(query_580739, "quotaUser", newJString(quotaUser))
  add(query_580739, "alt", newJString(alt))
  add(query_580739, "language", newJString(language))
  add(query_580739, "oauth_token", newJString(oauthToken))
  add(query_580739, "userIp", newJString(userIp))
  add(query_580739, "key", newJString(key))
  add(path_580738, "matchId", newJString(matchId))
  add(query_580739, "prettyPrint", newJBool(prettyPrint))
  result = call_580737.call(path_580738, query_580739, nil, nil, nil)

var gamesTurnBasedMatchesDecline* = Call_GamesTurnBasedMatchesDecline_580724(
    name: "gamesTurnBasedMatchesDecline", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/decline",
    validator: validate_GamesTurnBasedMatchesDecline_580725, base: "/games/v1",
    url: url_GamesTurnBasedMatchesDecline_580726, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesDismiss_580740 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesDismiss_580742(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesDismiss_580741(path: JsonNode; query: JsonNode;
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
  var valid_580743 = path.getOrDefault("matchId")
  valid_580743 = validateParameter(valid_580743, JString, required = true,
                                 default = nil)
  if valid_580743 != nil:
    section.add "matchId", valid_580743
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
  var valid_580744 = query.getOrDefault("fields")
  valid_580744 = validateParameter(valid_580744, JString, required = false,
                                 default = nil)
  if valid_580744 != nil:
    section.add "fields", valid_580744
  var valid_580745 = query.getOrDefault("quotaUser")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = nil)
  if valid_580745 != nil:
    section.add "quotaUser", valid_580745
  var valid_580746 = query.getOrDefault("alt")
  valid_580746 = validateParameter(valid_580746, JString, required = false,
                                 default = newJString("json"))
  if valid_580746 != nil:
    section.add "alt", valid_580746
  var valid_580747 = query.getOrDefault("oauth_token")
  valid_580747 = validateParameter(valid_580747, JString, required = false,
                                 default = nil)
  if valid_580747 != nil:
    section.add "oauth_token", valid_580747
  var valid_580748 = query.getOrDefault("userIp")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = nil)
  if valid_580748 != nil:
    section.add "userIp", valid_580748
  var valid_580749 = query.getOrDefault("key")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "key", valid_580749
  var valid_580750 = query.getOrDefault("prettyPrint")
  valid_580750 = validateParameter(valid_580750, JBool, required = false,
                                 default = newJBool(true))
  if valid_580750 != nil:
    section.add "prettyPrint", valid_580750
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580751: Call_GamesTurnBasedMatchesDismiss_580740; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss a turn-based match from the match list. The match will no longer show up in the list and will not generate notifications.
  ## 
  let valid = call_580751.validator(path, query, header, formData, body)
  let scheme = call_580751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580751.url(scheme.get, call_580751.host, call_580751.base,
                         call_580751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580751, url, valid)

proc call*(call_580752: Call_GamesTurnBasedMatchesDismiss_580740; matchId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesDismiss
  ## Dismiss a turn-based match from the match list. The match will no longer show up in the list and will not generate notifications.
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
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580753 = newJObject()
  var query_580754 = newJObject()
  add(query_580754, "fields", newJString(fields))
  add(query_580754, "quotaUser", newJString(quotaUser))
  add(query_580754, "alt", newJString(alt))
  add(query_580754, "oauth_token", newJString(oauthToken))
  add(query_580754, "userIp", newJString(userIp))
  add(query_580754, "key", newJString(key))
  add(path_580753, "matchId", newJString(matchId))
  add(query_580754, "prettyPrint", newJBool(prettyPrint))
  result = call_580752.call(path_580753, query_580754, nil, nil, nil)

var gamesTurnBasedMatchesDismiss* = Call_GamesTurnBasedMatchesDismiss_580740(
    name: "gamesTurnBasedMatchesDismiss", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/dismiss",
    validator: validate_GamesTurnBasedMatchesDismiss_580741, base: "/games/v1",
    url: url_GamesTurnBasedMatchesDismiss_580742, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesFinish_580755 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesFinish_580757(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesFinish_580756(path: JsonNode; query: JsonNode;
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
  var valid_580758 = path.getOrDefault("matchId")
  valid_580758 = validateParameter(valid_580758, JString, required = true,
                                 default = nil)
  if valid_580758 != nil:
    section.add "matchId", valid_580758
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580759 = query.getOrDefault("fields")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = nil)
  if valid_580759 != nil:
    section.add "fields", valid_580759
  var valid_580760 = query.getOrDefault("quotaUser")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "quotaUser", valid_580760
  var valid_580761 = query.getOrDefault("alt")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = newJString("json"))
  if valid_580761 != nil:
    section.add "alt", valid_580761
  var valid_580762 = query.getOrDefault("language")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "language", valid_580762
  var valid_580763 = query.getOrDefault("oauth_token")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "oauth_token", valid_580763
  var valid_580764 = query.getOrDefault("userIp")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "userIp", valid_580764
  var valid_580765 = query.getOrDefault("key")
  valid_580765 = validateParameter(valid_580765, JString, required = false,
                                 default = nil)
  if valid_580765 != nil:
    section.add "key", valid_580765
  var valid_580766 = query.getOrDefault("prettyPrint")
  valid_580766 = validateParameter(valid_580766, JBool, required = false,
                                 default = newJBool(true))
  if valid_580766 != nil:
    section.add "prettyPrint", valid_580766
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

proc call*(call_580768: Call_GamesTurnBasedMatchesFinish_580755; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finish a turn-based match. Each player should make this call once, after all results are in. Only the player whose turn it is may make the first call to Finish, and can pass in the final match state.
  ## 
  let valid = call_580768.validator(path, query, header, formData, body)
  let scheme = call_580768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580768.url(scheme.get, call_580768.host, call_580768.base,
                         call_580768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580768, url, valid)

proc call*(call_580769: Call_GamesTurnBasedMatchesFinish_580755; matchId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesFinish
  ## Finish a turn-based match. Each player should make this call once, after all results are in. Only the player whose turn it is may make the first call to Finish, and can pass in the final match state.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580770 = newJObject()
  var query_580771 = newJObject()
  var body_580772 = newJObject()
  add(query_580771, "fields", newJString(fields))
  add(query_580771, "quotaUser", newJString(quotaUser))
  add(query_580771, "alt", newJString(alt))
  add(query_580771, "language", newJString(language))
  add(query_580771, "oauth_token", newJString(oauthToken))
  add(query_580771, "userIp", newJString(userIp))
  add(query_580771, "key", newJString(key))
  add(path_580770, "matchId", newJString(matchId))
  if body != nil:
    body_580772 = body
  add(query_580771, "prettyPrint", newJBool(prettyPrint))
  result = call_580769.call(path_580770, query_580771, nil, nil, body_580772)

var gamesTurnBasedMatchesFinish* = Call_GamesTurnBasedMatchesFinish_580755(
    name: "gamesTurnBasedMatchesFinish", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/finish",
    validator: validate_GamesTurnBasedMatchesFinish_580756, base: "/games/v1",
    url: url_GamesTurnBasedMatchesFinish_580757, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesJoin_580773 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesJoin_580775(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesJoin_580774(path: JsonNode; query: JsonNode;
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
  var valid_580776 = path.getOrDefault("matchId")
  valid_580776 = validateParameter(valid_580776, JString, required = true,
                                 default = nil)
  if valid_580776 != nil:
    section.add "matchId", valid_580776
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580777 = query.getOrDefault("fields")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "fields", valid_580777
  var valid_580778 = query.getOrDefault("quotaUser")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "quotaUser", valid_580778
  var valid_580779 = query.getOrDefault("alt")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = newJString("json"))
  if valid_580779 != nil:
    section.add "alt", valid_580779
  var valid_580780 = query.getOrDefault("language")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "language", valid_580780
  var valid_580781 = query.getOrDefault("oauth_token")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "oauth_token", valid_580781
  var valid_580782 = query.getOrDefault("userIp")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "userIp", valid_580782
  var valid_580783 = query.getOrDefault("key")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "key", valid_580783
  var valid_580784 = query.getOrDefault("prettyPrint")
  valid_580784 = validateParameter(valid_580784, JBool, required = false,
                                 default = newJBool(true))
  if valid_580784 != nil:
    section.add "prettyPrint", valid_580784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580785: Call_GamesTurnBasedMatchesJoin_580773; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Join a turn-based match.
  ## 
  let valid = call_580785.validator(path, query, header, formData, body)
  let scheme = call_580785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580785.url(scheme.get, call_580785.host, call_580785.base,
                         call_580785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580785, url, valid)

proc call*(call_580786: Call_GamesTurnBasedMatchesJoin_580773; matchId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesJoin
  ## Join a turn-based match.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580787 = newJObject()
  var query_580788 = newJObject()
  add(query_580788, "fields", newJString(fields))
  add(query_580788, "quotaUser", newJString(quotaUser))
  add(query_580788, "alt", newJString(alt))
  add(query_580788, "language", newJString(language))
  add(query_580788, "oauth_token", newJString(oauthToken))
  add(query_580788, "userIp", newJString(userIp))
  add(query_580788, "key", newJString(key))
  add(path_580787, "matchId", newJString(matchId))
  add(query_580788, "prettyPrint", newJBool(prettyPrint))
  result = call_580786.call(path_580787, query_580788, nil, nil, nil)

var gamesTurnBasedMatchesJoin* = Call_GamesTurnBasedMatchesJoin_580773(
    name: "gamesTurnBasedMatchesJoin", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/join",
    validator: validate_GamesTurnBasedMatchesJoin_580774, base: "/games/v1",
    url: url_GamesTurnBasedMatchesJoin_580775, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesLeave_580789 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesLeave_580791(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesLeave_580790(path: JsonNode; query: JsonNode;
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
  var valid_580792 = path.getOrDefault("matchId")
  valid_580792 = validateParameter(valid_580792, JString, required = true,
                                 default = nil)
  if valid_580792 != nil:
    section.add "matchId", valid_580792
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580793 = query.getOrDefault("fields")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = nil)
  if valid_580793 != nil:
    section.add "fields", valid_580793
  var valid_580794 = query.getOrDefault("quotaUser")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = nil)
  if valid_580794 != nil:
    section.add "quotaUser", valid_580794
  var valid_580795 = query.getOrDefault("alt")
  valid_580795 = validateParameter(valid_580795, JString, required = false,
                                 default = newJString("json"))
  if valid_580795 != nil:
    section.add "alt", valid_580795
  var valid_580796 = query.getOrDefault("language")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "language", valid_580796
  var valid_580797 = query.getOrDefault("oauth_token")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "oauth_token", valid_580797
  var valid_580798 = query.getOrDefault("userIp")
  valid_580798 = validateParameter(valid_580798, JString, required = false,
                                 default = nil)
  if valid_580798 != nil:
    section.add "userIp", valid_580798
  var valid_580799 = query.getOrDefault("key")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "key", valid_580799
  var valid_580800 = query.getOrDefault("prettyPrint")
  valid_580800 = validateParameter(valid_580800, JBool, required = false,
                                 default = newJBool(true))
  if valid_580800 != nil:
    section.add "prettyPrint", valid_580800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580801: Call_GamesTurnBasedMatchesLeave_580789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a turn-based match when it is not the current player's turn, without canceling the match.
  ## 
  let valid = call_580801.validator(path, query, header, formData, body)
  let scheme = call_580801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580801.url(scheme.get, call_580801.host, call_580801.base,
                         call_580801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580801, url, valid)

proc call*(call_580802: Call_GamesTurnBasedMatchesLeave_580789; matchId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesLeave
  ## Leave a turn-based match when it is not the current player's turn, without canceling the match.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580803 = newJObject()
  var query_580804 = newJObject()
  add(query_580804, "fields", newJString(fields))
  add(query_580804, "quotaUser", newJString(quotaUser))
  add(query_580804, "alt", newJString(alt))
  add(query_580804, "language", newJString(language))
  add(query_580804, "oauth_token", newJString(oauthToken))
  add(query_580804, "userIp", newJString(userIp))
  add(query_580804, "key", newJString(key))
  add(path_580803, "matchId", newJString(matchId))
  add(query_580804, "prettyPrint", newJBool(prettyPrint))
  result = call_580802.call(path_580803, query_580804, nil, nil, nil)

var gamesTurnBasedMatchesLeave* = Call_GamesTurnBasedMatchesLeave_580789(
    name: "gamesTurnBasedMatchesLeave", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/leave",
    validator: validate_GamesTurnBasedMatchesLeave_580790, base: "/games/v1",
    url: url_GamesTurnBasedMatchesLeave_580791, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesLeaveTurn_580805 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesLeaveTurn_580807(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesLeaveTurn_580806(path: JsonNode;
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
  var valid_580808 = path.getOrDefault("matchId")
  valid_580808 = validateParameter(valid_580808, JString, required = true,
                                 default = nil)
  if valid_580808 != nil:
    section.add "matchId", valid_580808
  result.add "path", section
  ## parameters in `query` object:
  ##   matchVersion: JInt (required)
  ##               : The version of the match being updated.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   pendingParticipantId: JString
  ##                       : The ID of another participant who should take their turn next. If not set, the match will wait for other player(s) to join via automatching; this is only valid if automatch criteria is set on the match with remaining slots for automatched players.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `matchVersion` field"
  var valid_580809 = query.getOrDefault("matchVersion")
  valid_580809 = validateParameter(valid_580809, JInt, required = true, default = nil)
  if valid_580809 != nil:
    section.add "matchVersion", valid_580809
  var valid_580810 = query.getOrDefault("fields")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = nil)
  if valid_580810 != nil:
    section.add "fields", valid_580810
  var valid_580811 = query.getOrDefault("quotaUser")
  valid_580811 = validateParameter(valid_580811, JString, required = false,
                                 default = nil)
  if valid_580811 != nil:
    section.add "quotaUser", valid_580811
  var valid_580812 = query.getOrDefault("alt")
  valid_580812 = validateParameter(valid_580812, JString, required = false,
                                 default = newJString("json"))
  if valid_580812 != nil:
    section.add "alt", valid_580812
  var valid_580813 = query.getOrDefault("language")
  valid_580813 = validateParameter(valid_580813, JString, required = false,
                                 default = nil)
  if valid_580813 != nil:
    section.add "language", valid_580813
  var valid_580814 = query.getOrDefault("oauth_token")
  valid_580814 = validateParameter(valid_580814, JString, required = false,
                                 default = nil)
  if valid_580814 != nil:
    section.add "oauth_token", valid_580814
  var valid_580815 = query.getOrDefault("userIp")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "userIp", valid_580815
  var valid_580816 = query.getOrDefault("key")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = nil)
  if valid_580816 != nil:
    section.add "key", valid_580816
  var valid_580817 = query.getOrDefault("prettyPrint")
  valid_580817 = validateParameter(valid_580817, JBool, required = false,
                                 default = newJBool(true))
  if valid_580817 != nil:
    section.add "prettyPrint", valid_580817
  var valid_580818 = query.getOrDefault("pendingParticipantId")
  valid_580818 = validateParameter(valid_580818, JString, required = false,
                                 default = nil)
  if valid_580818 != nil:
    section.add "pendingParticipantId", valid_580818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580819: Call_GamesTurnBasedMatchesLeaveTurn_580805; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a turn-based match during the current player's turn, without canceling the match.
  ## 
  let valid = call_580819.validator(path, query, header, formData, body)
  let scheme = call_580819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580819.url(scheme.get, call_580819.host, call_580819.base,
                         call_580819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580819, url, valid)

proc call*(call_580820: Call_GamesTurnBasedMatchesLeaveTurn_580805;
          matchVersion: int; matchId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; language: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; pendingParticipantId: string = ""): Recallable =
  ## gamesTurnBasedMatchesLeaveTurn
  ## Leave a turn-based match during the current player's turn, without canceling the match.
  ##   matchVersion: int (required)
  ##               : The version of the match being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   pendingParticipantId: string
  ##                       : The ID of another participant who should take their turn next. If not set, the match will wait for other player(s) to join via automatching; this is only valid if automatch criteria is set on the match with remaining slots for automatched players.
  var path_580821 = newJObject()
  var query_580822 = newJObject()
  add(query_580822, "matchVersion", newJInt(matchVersion))
  add(query_580822, "fields", newJString(fields))
  add(query_580822, "quotaUser", newJString(quotaUser))
  add(query_580822, "alt", newJString(alt))
  add(query_580822, "language", newJString(language))
  add(query_580822, "oauth_token", newJString(oauthToken))
  add(query_580822, "userIp", newJString(userIp))
  add(query_580822, "key", newJString(key))
  add(path_580821, "matchId", newJString(matchId))
  add(query_580822, "prettyPrint", newJBool(prettyPrint))
  add(query_580822, "pendingParticipantId", newJString(pendingParticipantId))
  result = call_580820.call(path_580821, query_580822, nil, nil, nil)

var gamesTurnBasedMatchesLeaveTurn* = Call_GamesTurnBasedMatchesLeaveTurn_580805(
    name: "gamesTurnBasedMatchesLeaveTurn", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/leaveTurn",
    validator: validate_GamesTurnBasedMatchesLeaveTurn_580806, base: "/games/v1",
    url: url_GamesTurnBasedMatchesLeaveTurn_580807, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesRematch_580823 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesRematch_580825(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesRematch_580824(path: JsonNode; query: JsonNode;
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
  var valid_580826 = path.getOrDefault("matchId")
  valid_580826 = validateParameter(valid_580826, JString, required = true,
                                 default = nil)
  if valid_580826 != nil:
    section.add "matchId", valid_580826
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : A randomly generated numeric ID for each request specified by the caller. This number is used at the server to ensure that the request is handled correctly across retries.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580827 = query.getOrDefault("fields")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "fields", valid_580827
  var valid_580828 = query.getOrDefault("requestId")
  valid_580828 = validateParameter(valid_580828, JString, required = false,
                                 default = nil)
  if valid_580828 != nil:
    section.add "requestId", valid_580828
  var valid_580829 = query.getOrDefault("quotaUser")
  valid_580829 = validateParameter(valid_580829, JString, required = false,
                                 default = nil)
  if valid_580829 != nil:
    section.add "quotaUser", valid_580829
  var valid_580830 = query.getOrDefault("alt")
  valid_580830 = validateParameter(valid_580830, JString, required = false,
                                 default = newJString("json"))
  if valid_580830 != nil:
    section.add "alt", valid_580830
  var valid_580831 = query.getOrDefault("language")
  valid_580831 = validateParameter(valid_580831, JString, required = false,
                                 default = nil)
  if valid_580831 != nil:
    section.add "language", valid_580831
  var valid_580832 = query.getOrDefault("oauth_token")
  valid_580832 = validateParameter(valid_580832, JString, required = false,
                                 default = nil)
  if valid_580832 != nil:
    section.add "oauth_token", valid_580832
  var valid_580833 = query.getOrDefault("userIp")
  valid_580833 = validateParameter(valid_580833, JString, required = false,
                                 default = nil)
  if valid_580833 != nil:
    section.add "userIp", valid_580833
  var valid_580834 = query.getOrDefault("key")
  valid_580834 = validateParameter(valid_580834, JString, required = false,
                                 default = nil)
  if valid_580834 != nil:
    section.add "key", valid_580834
  var valid_580835 = query.getOrDefault("prettyPrint")
  valid_580835 = validateParameter(valid_580835, JBool, required = false,
                                 default = newJBool(true))
  if valid_580835 != nil:
    section.add "prettyPrint", valid_580835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580836: Call_GamesTurnBasedMatchesRematch_580823; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a rematch of a match that was previously completed, with the same participants. This can be called by only one player on a match still in their list; the player must have called Finish first. Returns the newly created match; it will be the caller's turn.
  ## 
  let valid = call_580836.validator(path, query, header, formData, body)
  let scheme = call_580836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580836.url(scheme.get, call_580836.host, call_580836.base,
                         call_580836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580836, url, valid)

proc call*(call_580837: Call_GamesTurnBasedMatchesRematch_580823; matchId: string;
          fields: string = ""; requestId: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesRematch
  ## Create a rematch of a match that was previously completed, with the same participants. This can be called by only one player on a match still in their list; the player must have called Finish first. Returns the newly created match; it will be the caller's turn.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : A randomly generated numeric ID for each request specified by the caller. This number is used at the server to ensure that the request is handled correctly across retries.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580838 = newJObject()
  var query_580839 = newJObject()
  add(query_580839, "fields", newJString(fields))
  add(query_580839, "requestId", newJString(requestId))
  add(query_580839, "quotaUser", newJString(quotaUser))
  add(query_580839, "alt", newJString(alt))
  add(query_580839, "language", newJString(language))
  add(query_580839, "oauth_token", newJString(oauthToken))
  add(query_580839, "userIp", newJString(userIp))
  add(query_580839, "key", newJString(key))
  add(path_580838, "matchId", newJString(matchId))
  add(query_580839, "prettyPrint", newJBool(prettyPrint))
  result = call_580837.call(path_580838, query_580839, nil, nil, nil)

var gamesTurnBasedMatchesRematch* = Call_GamesTurnBasedMatchesRematch_580823(
    name: "gamesTurnBasedMatchesRematch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/rematch",
    validator: validate_GamesTurnBasedMatchesRematch_580824, base: "/games/v1",
    url: url_GamesTurnBasedMatchesRematch_580825, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesTakeTurn_580840 = ref object of OpenApiRestCall_579437
proc url_GamesTurnBasedMatchesTakeTurn_580842(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesTakeTurn_580841(path: JsonNode; query: JsonNode;
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
  var valid_580843 = path.getOrDefault("matchId")
  valid_580843 = validateParameter(valid_580843, JString, required = true,
                                 default = nil)
  if valid_580843 != nil:
    section.add "matchId", valid_580843
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The preferred language to use for strings returned by this method.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580844 = query.getOrDefault("fields")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = nil)
  if valid_580844 != nil:
    section.add "fields", valid_580844
  var valid_580845 = query.getOrDefault("quotaUser")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "quotaUser", valid_580845
  var valid_580846 = query.getOrDefault("alt")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = newJString("json"))
  if valid_580846 != nil:
    section.add "alt", valid_580846
  var valid_580847 = query.getOrDefault("language")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "language", valid_580847
  var valid_580848 = query.getOrDefault("oauth_token")
  valid_580848 = validateParameter(valid_580848, JString, required = false,
                                 default = nil)
  if valid_580848 != nil:
    section.add "oauth_token", valid_580848
  var valid_580849 = query.getOrDefault("userIp")
  valid_580849 = validateParameter(valid_580849, JString, required = false,
                                 default = nil)
  if valid_580849 != nil:
    section.add "userIp", valid_580849
  var valid_580850 = query.getOrDefault("key")
  valid_580850 = validateParameter(valid_580850, JString, required = false,
                                 default = nil)
  if valid_580850 != nil:
    section.add "key", valid_580850
  var valid_580851 = query.getOrDefault("prettyPrint")
  valid_580851 = validateParameter(valid_580851, JBool, required = false,
                                 default = newJBool(true))
  if valid_580851 != nil:
    section.add "prettyPrint", valid_580851
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

proc call*(call_580853: Call_GamesTurnBasedMatchesTakeTurn_580840; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commit the results of a player turn.
  ## 
  let valid = call_580853.validator(path, query, header, formData, body)
  let scheme = call_580853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580853.url(scheme.get, call_580853.host, call_580853.base,
                         call_580853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580853, url, valid)

proc call*(call_580854: Call_GamesTurnBasedMatchesTakeTurn_580840; matchId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          language: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesTurnBasedMatchesTakeTurn
  ## Commit the results of a player turn.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The preferred language to use for strings returned by this method.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   matchId: string (required)
  ##          : The ID of the match.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580855 = newJObject()
  var query_580856 = newJObject()
  var body_580857 = newJObject()
  add(query_580856, "fields", newJString(fields))
  add(query_580856, "quotaUser", newJString(quotaUser))
  add(query_580856, "alt", newJString(alt))
  add(query_580856, "language", newJString(language))
  add(query_580856, "oauth_token", newJString(oauthToken))
  add(query_580856, "userIp", newJString(userIp))
  add(query_580856, "key", newJString(key))
  add(path_580855, "matchId", newJString(matchId))
  if body != nil:
    body_580857 = body
  add(query_580856, "prettyPrint", newJBool(prettyPrint))
  result = call_580854.call(path_580855, query_580856, nil, nil, body_580857)

var gamesTurnBasedMatchesTakeTurn* = Call_GamesTurnBasedMatchesTakeTurn_580840(
    name: "gamesTurnBasedMatchesTakeTurn", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/turn",
    validator: validate_GamesTurnBasedMatchesTakeTurn_580841, base: "/games/v1",
    url: url_GamesTurnBasedMatchesTakeTurn_580842, schemes: {Scheme.Https})
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
