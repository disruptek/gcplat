
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

  OpenApiRestCall_588466 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588466](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588466): Option[Scheme] {.used.} =
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
  gcpServiceName = "games"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GamesAchievementDefinitionsList_588734 = ref object of OpenApiRestCall_588466
proc url_GamesAchievementDefinitionsList_588736(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesAchievementDefinitionsList_588735(path: JsonNode;
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
  var valid_588848 = query.getOrDefault("fields")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "fields", valid_588848
  var valid_588849 = query.getOrDefault("pageToken")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "pageToken", valid_588849
  var valid_588850 = query.getOrDefault("quotaUser")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "quotaUser", valid_588850
  var valid_588864 = query.getOrDefault("alt")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("json"))
  if valid_588864 != nil:
    section.add "alt", valid_588864
  var valid_588865 = query.getOrDefault("language")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "language", valid_588865
  var valid_588866 = query.getOrDefault("oauth_token")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "oauth_token", valid_588866
  var valid_588867 = query.getOrDefault("userIp")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "userIp", valid_588867
  var valid_588868 = query.getOrDefault("maxResults")
  valid_588868 = validateParameter(valid_588868, JInt, required = false, default = nil)
  if valid_588868 != nil:
    section.add "maxResults", valid_588868
  var valid_588869 = query.getOrDefault("key")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "key", valid_588869
  var valid_588870 = query.getOrDefault("prettyPrint")
  valid_588870 = validateParameter(valid_588870, JBool, required = false,
                                 default = newJBool(true))
  if valid_588870 != nil:
    section.add "prettyPrint", valid_588870
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588893: Call_GamesAchievementDefinitionsList_588734;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the achievement definitions for your application.
  ## 
  let valid = call_588893.validator(path, query, header, formData, body)
  let scheme = call_588893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588893.url(scheme.get, call_588893.host, call_588893.base,
                         call_588893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588893, url, valid)

proc call*(call_588964: Call_GamesAchievementDefinitionsList_588734;
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
  var query_588965 = newJObject()
  add(query_588965, "fields", newJString(fields))
  add(query_588965, "pageToken", newJString(pageToken))
  add(query_588965, "quotaUser", newJString(quotaUser))
  add(query_588965, "alt", newJString(alt))
  add(query_588965, "language", newJString(language))
  add(query_588965, "oauth_token", newJString(oauthToken))
  add(query_588965, "userIp", newJString(userIp))
  add(query_588965, "maxResults", newJInt(maxResults))
  add(query_588965, "key", newJString(key))
  add(query_588965, "prettyPrint", newJBool(prettyPrint))
  result = call_588964.call(nil, query_588965, nil, nil, nil)

var gamesAchievementDefinitionsList* = Call_GamesAchievementDefinitionsList_588734(
    name: "gamesAchievementDefinitionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/achievements",
    validator: validate_GamesAchievementDefinitionsList_588735, base: "/games/v1",
    url: url_GamesAchievementDefinitionsList_588736, schemes: {Scheme.Https})
type
  Call_GamesAchievementsUpdateMultiple_589005 = ref object of OpenApiRestCall_588466
proc url_GamesAchievementsUpdateMultiple_589007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesAchievementsUpdateMultiple_589006(path: JsonNode;
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
  var valid_589008 = query.getOrDefault("fields")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "fields", valid_589008
  var valid_589009 = query.getOrDefault("quotaUser")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "quotaUser", valid_589009
  var valid_589010 = query.getOrDefault("alt")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = newJString("json"))
  if valid_589010 != nil:
    section.add "alt", valid_589010
  var valid_589011 = query.getOrDefault("builtinGameId")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "builtinGameId", valid_589011
  var valid_589012 = query.getOrDefault("oauth_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "oauth_token", valid_589012
  var valid_589013 = query.getOrDefault("userIp")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "userIp", valid_589013
  var valid_589014 = query.getOrDefault("key")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "key", valid_589014
  var valid_589015 = query.getOrDefault("prettyPrint")
  valid_589015 = validateParameter(valid_589015, JBool, required = false,
                                 default = newJBool(true))
  if valid_589015 != nil:
    section.add "prettyPrint", valid_589015
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

proc call*(call_589017: Call_GamesAchievementsUpdateMultiple_589005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates multiple achievements for the currently authenticated player.
  ## 
  let valid = call_589017.validator(path, query, header, formData, body)
  let scheme = call_589017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589017.url(scheme.get, call_589017.host, call_589017.base,
                         call_589017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589017, url, valid)

proc call*(call_589018: Call_GamesAchievementsUpdateMultiple_589005;
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
  var query_589019 = newJObject()
  var body_589020 = newJObject()
  add(query_589019, "fields", newJString(fields))
  add(query_589019, "quotaUser", newJString(quotaUser))
  add(query_589019, "alt", newJString(alt))
  add(query_589019, "builtinGameId", newJString(builtinGameId))
  add(query_589019, "oauth_token", newJString(oauthToken))
  add(query_589019, "userIp", newJString(userIp))
  add(query_589019, "key", newJString(key))
  if body != nil:
    body_589020 = body
  add(query_589019, "prettyPrint", newJBool(prettyPrint))
  result = call_589018.call(nil, query_589019, nil, nil, body_589020)

var gamesAchievementsUpdateMultiple* = Call_GamesAchievementsUpdateMultiple_589005(
    name: "gamesAchievementsUpdateMultiple", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/updateMultiple",
    validator: validate_GamesAchievementsUpdateMultiple_589006, base: "/games/v1",
    url: url_GamesAchievementsUpdateMultiple_589007, schemes: {Scheme.Https})
type
  Call_GamesAchievementsIncrement_589021 = ref object of OpenApiRestCall_588466
proc url_GamesAchievementsIncrement_589023(protocol: Scheme; host: string;
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

proc validate_GamesAchievementsIncrement_589022(path: JsonNode; query: JsonNode;
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
  var valid_589038 = path.getOrDefault("achievementId")
  valid_589038 = validateParameter(valid_589038, JString, required = true,
                                 default = nil)
  if valid_589038 != nil:
    section.add "achievementId", valid_589038
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
  var valid_589039 = query.getOrDefault("fields")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "fields", valid_589039
  var valid_589040 = query.getOrDefault("requestId")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "requestId", valid_589040
  var valid_589041 = query.getOrDefault("quotaUser")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "quotaUser", valid_589041
  var valid_589042 = query.getOrDefault("alt")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("json"))
  if valid_589042 != nil:
    section.add "alt", valid_589042
  var valid_589043 = query.getOrDefault("oauth_token")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "oauth_token", valid_589043
  var valid_589044 = query.getOrDefault("userIp")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "userIp", valid_589044
  var valid_589045 = query.getOrDefault("key")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "key", valid_589045
  assert query != nil,
        "query argument is necessary due to required `stepsToIncrement` field"
  var valid_589046 = query.getOrDefault("stepsToIncrement")
  valid_589046 = validateParameter(valid_589046, JInt, required = true, default = nil)
  if valid_589046 != nil:
    section.add "stepsToIncrement", valid_589046
  var valid_589047 = query.getOrDefault("prettyPrint")
  valid_589047 = validateParameter(valid_589047, JBool, required = false,
                                 default = newJBool(true))
  if valid_589047 != nil:
    section.add "prettyPrint", valid_589047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589048: Call_GamesAchievementsIncrement_589021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Increments the steps of the achievement with the given ID for the currently authenticated player.
  ## 
  let valid = call_589048.validator(path, query, header, formData, body)
  let scheme = call_589048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589048.url(scheme.get, call_589048.host, call_589048.base,
                         call_589048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589048, url, valid)

proc call*(call_589049: Call_GamesAchievementsIncrement_589021;
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
  var path_589050 = newJObject()
  var query_589051 = newJObject()
  add(query_589051, "fields", newJString(fields))
  add(query_589051, "requestId", newJString(requestId))
  add(query_589051, "quotaUser", newJString(quotaUser))
  add(query_589051, "alt", newJString(alt))
  add(query_589051, "oauth_token", newJString(oauthToken))
  add(query_589051, "userIp", newJString(userIp))
  add(query_589051, "key", newJString(key))
  add(query_589051, "stepsToIncrement", newJInt(stepsToIncrement))
  add(path_589050, "achievementId", newJString(achievementId))
  add(query_589051, "prettyPrint", newJBool(prettyPrint))
  result = call_589049.call(path_589050, query_589051, nil, nil, nil)

var gamesAchievementsIncrement* = Call_GamesAchievementsIncrement_589021(
    name: "gamesAchievementsIncrement", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/increment",
    validator: validate_GamesAchievementsIncrement_589022, base: "/games/v1",
    url: url_GamesAchievementsIncrement_589023, schemes: {Scheme.Https})
type
  Call_GamesAchievementsReveal_589052 = ref object of OpenApiRestCall_588466
proc url_GamesAchievementsReveal_589054(protocol: Scheme; host: string; base: string;
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

proc validate_GamesAchievementsReveal_589053(path: JsonNode; query: JsonNode;
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
  var valid_589055 = path.getOrDefault("achievementId")
  valid_589055 = validateParameter(valid_589055, JString, required = true,
                                 default = nil)
  if valid_589055 != nil:
    section.add "achievementId", valid_589055
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
  var valid_589056 = query.getOrDefault("fields")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "fields", valid_589056
  var valid_589057 = query.getOrDefault("quotaUser")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "quotaUser", valid_589057
  var valid_589058 = query.getOrDefault("alt")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = newJString("json"))
  if valid_589058 != nil:
    section.add "alt", valid_589058
  var valid_589059 = query.getOrDefault("oauth_token")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "oauth_token", valid_589059
  var valid_589060 = query.getOrDefault("userIp")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "userIp", valid_589060
  var valid_589061 = query.getOrDefault("key")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "key", valid_589061
  var valid_589062 = query.getOrDefault("prettyPrint")
  valid_589062 = validateParameter(valid_589062, JBool, required = false,
                                 default = newJBool(true))
  if valid_589062 != nil:
    section.add "prettyPrint", valid_589062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589063: Call_GamesAchievementsReveal_589052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the achievement with the given ID to REVEALED for the currently authenticated player.
  ## 
  let valid = call_589063.validator(path, query, header, formData, body)
  let scheme = call_589063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589063.url(scheme.get, call_589063.host, call_589063.base,
                         call_589063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589063, url, valid)

proc call*(call_589064: Call_GamesAchievementsReveal_589052; achievementId: string;
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
  var path_589065 = newJObject()
  var query_589066 = newJObject()
  add(query_589066, "fields", newJString(fields))
  add(query_589066, "quotaUser", newJString(quotaUser))
  add(query_589066, "alt", newJString(alt))
  add(query_589066, "oauth_token", newJString(oauthToken))
  add(query_589066, "userIp", newJString(userIp))
  add(query_589066, "key", newJString(key))
  add(path_589065, "achievementId", newJString(achievementId))
  add(query_589066, "prettyPrint", newJBool(prettyPrint))
  result = call_589064.call(path_589065, query_589066, nil, nil, nil)

var gamesAchievementsReveal* = Call_GamesAchievementsReveal_589052(
    name: "gamesAchievementsReveal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/reveal",
    validator: validate_GamesAchievementsReveal_589053, base: "/games/v1",
    url: url_GamesAchievementsReveal_589054, schemes: {Scheme.Https})
type
  Call_GamesAchievementsSetStepsAtLeast_589067 = ref object of OpenApiRestCall_588466
proc url_GamesAchievementsSetStepsAtLeast_589069(protocol: Scheme; host: string;
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

proc validate_GamesAchievementsSetStepsAtLeast_589068(path: JsonNode;
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
  var valid_589070 = path.getOrDefault("achievementId")
  valid_589070 = validateParameter(valid_589070, JString, required = true,
                                 default = nil)
  if valid_589070 != nil:
    section.add "achievementId", valid_589070
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
  var valid_589071 = query.getOrDefault("fields")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "fields", valid_589071
  var valid_589072 = query.getOrDefault("quotaUser")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "quotaUser", valid_589072
  var valid_589073 = query.getOrDefault("alt")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = newJString("json"))
  if valid_589073 != nil:
    section.add "alt", valid_589073
  assert query != nil, "query argument is necessary due to required `steps` field"
  var valid_589074 = query.getOrDefault("steps")
  valid_589074 = validateParameter(valid_589074, JInt, required = true, default = nil)
  if valid_589074 != nil:
    section.add "steps", valid_589074
  var valid_589075 = query.getOrDefault("oauth_token")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "oauth_token", valid_589075
  var valid_589076 = query.getOrDefault("userIp")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "userIp", valid_589076
  var valid_589077 = query.getOrDefault("key")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "key", valid_589077
  var valid_589078 = query.getOrDefault("prettyPrint")
  valid_589078 = validateParameter(valid_589078, JBool, required = false,
                                 default = newJBool(true))
  if valid_589078 != nil:
    section.add "prettyPrint", valid_589078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589079: Call_GamesAchievementsSetStepsAtLeast_589067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the steps for the currently authenticated player towards unlocking an achievement. If the steps parameter is less than the current number of steps that the player already gained for the achievement, the achievement is not modified.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_GamesAchievementsSetStepsAtLeast_589067; steps: int;
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
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "steps", newJInt(steps))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "userIp", newJString(userIp))
  add(query_589082, "key", newJString(key))
  add(path_589081, "achievementId", newJString(achievementId))
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  result = call_589080.call(path_589081, query_589082, nil, nil, nil)

var gamesAchievementsSetStepsAtLeast* = Call_GamesAchievementsSetStepsAtLeast_589067(
    name: "gamesAchievementsSetStepsAtLeast", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/achievements/{achievementId}/setStepsAtLeast",
    validator: validate_GamesAchievementsSetStepsAtLeast_589068,
    base: "/games/v1", url: url_GamesAchievementsSetStepsAtLeast_589069,
    schemes: {Scheme.Https})
type
  Call_GamesAchievementsUnlock_589083 = ref object of OpenApiRestCall_588466
proc url_GamesAchievementsUnlock_589085(protocol: Scheme; host: string; base: string;
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

proc validate_GamesAchievementsUnlock_589084(path: JsonNode; query: JsonNode;
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
  var valid_589086 = path.getOrDefault("achievementId")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "achievementId", valid_589086
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
  var valid_589087 = query.getOrDefault("fields")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "fields", valid_589087
  var valid_589088 = query.getOrDefault("quotaUser")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "quotaUser", valid_589088
  var valid_589089 = query.getOrDefault("alt")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = newJString("json"))
  if valid_589089 != nil:
    section.add "alt", valid_589089
  var valid_589090 = query.getOrDefault("builtinGameId")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "builtinGameId", valid_589090
  var valid_589091 = query.getOrDefault("oauth_token")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "oauth_token", valid_589091
  var valid_589092 = query.getOrDefault("userIp")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "userIp", valid_589092
  var valid_589093 = query.getOrDefault("key")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "key", valid_589093
  var valid_589094 = query.getOrDefault("prettyPrint")
  valid_589094 = validateParameter(valid_589094, JBool, required = false,
                                 default = newJBool(true))
  if valid_589094 != nil:
    section.add "prettyPrint", valid_589094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589095: Call_GamesAchievementsUnlock_589083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unlocks this achievement for the currently authenticated player.
  ## 
  let valid = call_589095.validator(path, query, header, formData, body)
  let scheme = call_589095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589095.url(scheme.get, call_589095.host, call_589095.base,
                         call_589095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589095, url, valid)

proc call*(call_589096: Call_GamesAchievementsUnlock_589083; achievementId: string;
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
  var path_589097 = newJObject()
  var query_589098 = newJObject()
  add(query_589098, "fields", newJString(fields))
  add(query_589098, "quotaUser", newJString(quotaUser))
  add(query_589098, "alt", newJString(alt))
  add(query_589098, "builtinGameId", newJString(builtinGameId))
  add(query_589098, "oauth_token", newJString(oauthToken))
  add(query_589098, "userIp", newJString(userIp))
  add(query_589098, "key", newJString(key))
  add(path_589097, "achievementId", newJString(achievementId))
  add(query_589098, "prettyPrint", newJBool(prettyPrint))
  result = call_589096.call(path_589097, query_589098, nil, nil, nil)

var gamesAchievementsUnlock* = Call_GamesAchievementsUnlock_589083(
    name: "gamesAchievementsUnlock", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/unlock",
    validator: validate_GamesAchievementsUnlock_589084, base: "/games/v1",
    url: url_GamesAchievementsUnlock_589085, schemes: {Scheme.Https})
type
  Call_GamesApplicationsPlayed_589099 = ref object of OpenApiRestCall_588466
proc url_GamesApplicationsPlayed_589101(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesApplicationsPlayed_589100(path: JsonNode; query: JsonNode;
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
  var valid_589102 = query.getOrDefault("fields")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "fields", valid_589102
  var valid_589103 = query.getOrDefault("quotaUser")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "quotaUser", valid_589103
  var valid_589104 = query.getOrDefault("alt")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = newJString("json"))
  if valid_589104 != nil:
    section.add "alt", valid_589104
  var valid_589105 = query.getOrDefault("builtinGameId")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "builtinGameId", valid_589105
  var valid_589106 = query.getOrDefault("oauth_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "oauth_token", valid_589106
  var valid_589107 = query.getOrDefault("userIp")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "userIp", valid_589107
  var valid_589108 = query.getOrDefault("key")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "key", valid_589108
  var valid_589109 = query.getOrDefault("prettyPrint")
  valid_589109 = validateParameter(valid_589109, JBool, required = false,
                                 default = newJBool(true))
  if valid_589109 != nil:
    section.add "prettyPrint", valid_589109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589110: Call_GamesApplicationsPlayed_589099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicate that the the currently authenticated user is playing your application.
  ## 
  let valid = call_589110.validator(path, query, header, formData, body)
  let scheme = call_589110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589110.url(scheme.get, call_589110.host, call_589110.base,
                         call_589110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589110, url, valid)

proc call*(call_589111: Call_GamesApplicationsPlayed_589099; fields: string = "";
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
  var query_589112 = newJObject()
  add(query_589112, "fields", newJString(fields))
  add(query_589112, "quotaUser", newJString(quotaUser))
  add(query_589112, "alt", newJString(alt))
  add(query_589112, "builtinGameId", newJString(builtinGameId))
  add(query_589112, "oauth_token", newJString(oauthToken))
  add(query_589112, "userIp", newJString(userIp))
  add(query_589112, "key", newJString(key))
  add(query_589112, "prettyPrint", newJBool(prettyPrint))
  result = call_589111.call(nil, query_589112, nil, nil, nil)

var gamesApplicationsPlayed* = Call_GamesApplicationsPlayed_589099(
    name: "gamesApplicationsPlayed", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/applications/played",
    validator: validate_GamesApplicationsPlayed_589100, base: "/games/v1",
    url: url_GamesApplicationsPlayed_589101, schemes: {Scheme.Https})
type
  Call_GamesApplicationsGet_589113 = ref object of OpenApiRestCall_588466
proc url_GamesApplicationsGet_589115(protocol: Scheme; host: string; base: string;
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

proc validate_GamesApplicationsGet_589114(path: JsonNode; query: JsonNode;
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
  var valid_589116 = path.getOrDefault("applicationId")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "applicationId", valid_589116
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
  var valid_589117 = query.getOrDefault("fields")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "fields", valid_589117
  var valid_589118 = query.getOrDefault("quotaUser")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "quotaUser", valid_589118
  var valid_589119 = query.getOrDefault("alt")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("json"))
  if valid_589119 != nil:
    section.add "alt", valid_589119
  var valid_589120 = query.getOrDefault("language")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "language", valid_589120
  var valid_589121 = query.getOrDefault("oauth_token")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "oauth_token", valid_589121
  var valid_589122 = query.getOrDefault("userIp")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "userIp", valid_589122
  var valid_589123 = query.getOrDefault("key")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "key", valid_589123
  var valid_589124 = query.getOrDefault("platformType")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = newJString("ANDROID"))
  if valid_589124 != nil:
    section.add "platformType", valid_589124
  var valid_589125 = query.getOrDefault("prettyPrint")
  valid_589125 = validateParameter(valid_589125, JBool, required = false,
                                 default = newJBool(true))
  if valid_589125 != nil:
    section.add "prettyPrint", valid_589125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589126: Call_GamesApplicationsGet_589113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata of the application with the given ID. If the requested application is not available for the specified platformType, the returned response will not include any instance data.
  ## 
  let valid = call_589126.validator(path, query, header, formData, body)
  let scheme = call_589126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589126.url(scheme.get, call_589126.host, call_589126.base,
                         call_589126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589126, url, valid)

proc call*(call_589127: Call_GamesApplicationsGet_589113; applicationId: string;
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
  var path_589128 = newJObject()
  var query_589129 = newJObject()
  add(query_589129, "fields", newJString(fields))
  add(query_589129, "quotaUser", newJString(quotaUser))
  add(query_589129, "alt", newJString(alt))
  add(query_589129, "language", newJString(language))
  add(query_589129, "oauth_token", newJString(oauthToken))
  add(query_589129, "userIp", newJString(userIp))
  add(path_589128, "applicationId", newJString(applicationId))
  add(query_589129, "key", newJString(key))
  add(query_589129, "platformType", newJString(platformType))
  add(query_589129, "prettyPrint", newJBool(prettyPrint))
  result = call_589127.call(path_589128, query_589129, nil, nil, nil)

var gamesApplicationsGet* = Call_GamesApplicationsGet_589113(
    name: "gamesApplicationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}",
    validator: validate_GamesApplicationsGet_589114, base: "/games/v1",
    url: url_GamesApplicationsGet_589115, schemes: {Scheme.Https})
type
  Call_GamesApplicationsVerify_589130 = ref object of OpenApiRestCall_588466
proc url_GamesApplicationsVerify_589132(protocol: Scheme; host: string; base: string;
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

proc validate_GamesApplicationsVerify_589131(path: JsonNode; query: JsonNode;
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
  var valid_589133 = path.getOrDefault("applicationId")
  valid_589133 = validateParameter(valid_589133, JString, required = true,
                                 default = nil)
  if valid_589133 != nil:
    section.add "applicationId", valid_589133
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
  var valid_589134 = query.getOrDefault("fields")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "fields", valid_589134
  var valid_589135 = query.getOrDefault("quotaUser")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "quotaUser", valid_589135
  var valid_589136 = query.getOrDefault("alt")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = newJString("json"))
  if valid_589136 != nil:
    section.add "alt", valid_589136
  var valid_589137 = query.getOrDefault("oauth_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "oauth_token", valid_589137
  var valid_589138 = query.getOrDefault("userIp")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "userIp", valid_589138
  var valid_589139 = query.getOrDefault("key")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "key", valid_589139
  var valid_589140 = query.getOrDefault("prettyPrint")
  valid_589140 = validateParameter(valid_589140, JBool, required = false,
                                 default = newJBool(true))
  if valid_589140 != nil:
    section.add "prettyPrint", valid_589140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589141: Call_GamesApplicationsVerify_589130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies the auth token provided with this request is for the application with the specified ID, and returns the ID of the player it was granted for.
  ## 
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_GamesApplicationsVerify_589130; applicationId: string;
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
  var path_589143 = newJObject()
  var query_589144 = newJObject()
  add(query_589144, "fields", newJString(fields))
  add(query_589144, "quotaUser", newJString(quotaUser))
  add(query_589144, "alt", newJString(alt))
  add(query_589144, "oauth_token", newJString(oauthToken))
  add(query_589144, "userIp", newJString(userIp))
  add(path_589143, "applicationId", newJString(applicationId))
  add(query_589144, "key", newJString(key))
  add(query_589144, "prettyPrint", newJBool(prettyPrint))
  result = call_589142.call(path_589143, query_589144, nil, nil, nil)

var gamesApplicationsVerify* = Call_GamesApplicationsVerify_589130(
    name: "gamesApplicationsVerify", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}/verify",
    validator: validate_GamesApplicationsVerify_589131, base: "/games/v1",
    url: url_GamesApplicationsVerify_589132, schemes: {Scheme.Https})
type
  Call_GamesEventsListDefinitions_589145 = ref object of OpenApiRestCall_588466
proc url_GamesEventsListDefinitions_589147(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesEventsListDefinitions_589146(path: JsonNode; query: JsonNode;
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
  var valid_589148 = query.getOrDefault("fields")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "fields", valid_589148
  var valid_589149 = query.getOrDefault("pageToken")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "pageToken", valid_589149
  var valid_589150 = query.getOrDefault("quotaUser")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "quotaUser", valid_589150
  var valid_589151 = query.getOrDefault("alt")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = newJString("json"))
  if valid_589151 != nil:
    section.add "alt", valid_589151
  var valid_589152 = query.getOrDefault("language")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "language", valid_589152
  var valid_589153 = query.getOrDefault("oauth_token")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "oauth_token", valid_589153
  var valid_589154 = query.getOrDefault("userIp")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "userIp", valid_589154
  var valid_589155 = query.getOrDefault("maxResults")
  valid_589155 = validateParameter(valid_589155, JInt, required = false, default = nil)
  if valid_589155 != nil:
    section.add "maxResults", valid_589155
  var valid_589156 = query.getOrDefault("key")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "key", valid_589156
  var valid_589157 = query.getOrDefault("prettyPrint")
  valid_589157 = validateParameter(valid_589157, JBool, required = false,
                                 default = newJBool(true))
  if valid_589157 != nil:
    section.add "prettyPrint", valid_589157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589158: Call_GamesEventsListDefinitions_589145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the event definitions in this application.
  ## 
  let valid = call_589158.validator(path, query, header, formData, body)
  let scheme = call_589158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589158.url(scheme.get, call_589158.host, call_589158.base,
                         call_589158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589158, url, valid)

proc call*(call_589159: Call_GamesEventsListDefinitions_589145;
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
  var query_589160 = newJObject()
  add(query_589160, "fields", newJString(fields))
  add(query_589160, "pageToken", newJString(pageToken))
  add(query_589160, "quotaUser", newJString(quotaUser))
  add(query_589160, "alt", newJString(alt))
  add(query_589160, "language", newJString(language))
  add(query_589160, "oauth_token", newJString(oauthToken))
  add(query_589160, "userIp", newJString(userIp))
  add(query_589160, "maxResults", newJInt(maxResults))
  add(query_589160, "key", newJString(key))
  add(query_589160, "prettyPrint", newJBool(prettyPrint))
  result = call_589159.call(nil, query_589160, nil, nil, nil)

var gamesEventsListDefinitions* = Call_GamesEventsListDefinitions_589145(
    name: "gamesEventsListDefinitions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/eventDefinitions",
    validator: validate_GamesEventsListDefinitions_589146, base: "/games/v1",
    url: url_GamesEventsListDefinitions_589147, schemes: {Scheme.Https})
type
  Call_GamesEventsRecord_589177 = ref object of OpenApiRestCall_588466
proc url_GamesEventsRecord_589179(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesEventsRecord_589178(path: JsonNode; query: JsonNode;
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
  var valid_589180 = query.getOrDefault("fields")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "fields", valid_589180
  var valid_589181 = query.getOrDefault("quotaUser")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "quotaUser", valid_589181
  var valid_589182 = query.getOrDefault("alt")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = newJString("json"))
  if valid_589182 != nil:
    section.add "alt", valid_589182
  var valid_589183 = query.getOrDefault("language")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "language", valid_589183
  var valid_589184 = query.getOrDefault("oauth_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "oauth_token", valid_589184
  var valid_589185 = query.getOrDefault("userIp")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "userIp", valid_589185
  var valid_589186 = query.getOrDefault("key")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "key", valid_589186
  var valid_589187 = query.getOrDefault("prettyPrint")
  valid_589187 = validateParameter(valid_589187, JBool, required = false,
                                 default = newJBool(true))
  if valid_589187 != nil:
    section.add "prettyPrint", valid_589187
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

proc call*(call_589189: Call_GamesEventsRecord_589177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Records a batch of changes to the number of times events have occurred for the currently authenticated user of this application.
  ## 
  let valid = call_589189.validator(path, query, header, formData, body)
  let scheme = call_589189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589189.url(scheme.get, call_589189.host, call_589189.base,
                         call_589189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589189, url, valid)

proc call*(call_589190: Call_GamesEventsRecord_589177; fields: string = "";
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
  var query_589191 = newJObject()
  var body_589192 = newJObject()
  add(query_589191, "fields", newJString(fields))
  add(query_589191, "quotaUser", newJString(quotaUser))
  add(query_589191, "alt", newJString(alt))
  add(query_589191, "language", newJString(language))
  add(query_589191, "oauth_token", newJString(oauthToken))
  add(query_589191, "userIp", newJString(userIp))
  add(query_589191, "key", newJString(key))
  if body != nil:
    body_589192 = body
  add(query_589191, "prettyPrint", newJBool(prettyPrint))
  result = call_589190.call(nil, query_589191, nil, nil, body_589192)

var gamesEventsRecord* = Call_GamesEventsRecord_589177(name: "gamesEventsRecord",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/events",
    validator: validate_GamesEventsRecord_589178, base: "/games/v1",
    url: url_GamesEventsRecord_589179, schemes: {Scheme.Https})
type
  Call_GamesEventsListByPlayer_589161 = ref object of OpenApiRestCall_588466
proc url_GamesEventsListByPlayer_589163(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesEventsListByPlayer_589162(path: JsonNode; query: JsonNode;
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
  var valid_589164 = query.getOrDefault("fields")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "fields", valid_589164
  var valid_589165 = query.getOrDefault("pageToken")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "pageToken", valid_589165
  var valid_589166 = query.getOrDefault("quotaUser")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "quotaUser", valid_589166
  var valid_589167 = query.getOrDefault("alt")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = newJString("json"))
  if valid_589167 != nil:
    section.add "alt", valid_589167
  var valid_589168 = query.getOrDefault("language")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "language", valid_589168
  var valid_589169 = query.getOrDefault("oauth_token")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "oauth_token", valid_589169
  var valid_589170 = query.getOrDefault("userIp")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "userIp", valid_589170
  var valid_589171 = query.getOrDefault("maxResults")
  valid_589171 = validateParameter(valid_589171, JInt, required = false, default = nil)
  if valid_589171 != nil:
    section.add "maxResults", valid_589171
  var valid_589172 = query.getOrDefault("key")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "key", valid_589172
  var valid_589173 = query.getOrDefault("prettyPrint")
  valid_589173 = validateParameter(valid_589173, JBool, required = false,
                                 default = newJBool(true))
  if valid_589173 != nil:
    section.add "prettyPrint", valid_589173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589174: Call_GamesEventsListByPlayer_589161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list showing the current progress on events in this application for the currently authenticated user.
  ## 
  let valid = call_589174.validator(path, query, header, formData, body)
  let scheme = call_589174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589174.url(scheme.get, call_589174.host, call_589174.base,
                         call_589174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589174, url, valid)

proc call*(call_589175: Call_GamesEventsListByPlayer_589161; fields: string = "";
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
  var query_589176 = newJObject()
  add(query_589176, "fields", newJString(fields))
  add(query_589176, "pageToken", newJString(pageToken))
  add(query_589176, "quotaUser", newJString(quotaUser))
  add(query_589176, "alt", newJString(alt))
  add(query_589176, "language", newJString(language))
  add(query_589176, "oauth_token", newJString(oauthToken))
  add(query_589176, "userIp", newJString(userIp))
  add(query_589176, "maxResults", newJInt(maxResults))
  add(query_589176, "key", newJString(key))
  add(query_589176, "prettyPrint", newJBool(prettyPrint))
  result = call_589175.call(nil, query_589176, nil, nil, nil)

var gamesEventsListByPlayer* = Call_GamesEventsListByPlayer_589161(
    name: "gamesEventsListByPlayer", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/events",
    validator: validate_GamesEventsListByPlayer_589162, base: "/games/v1",
    url: url_GamesEventsListByPlayer_589163, schemes: {Scheme.Https})
type
  Call_GamesLeaderboardsList_589193 = ref object of OpenApiRestCall_588466
proc url_GamesLeaderboardsList_589195(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesLeaderboardsList_589194(path: JsonNode; query: JsonNode;
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
  var valid_589196 = query.getOrDefault("fields")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "fields", valid_589196
  var valid_589197 = query.getOrDefault("pageToken")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "pageToken", valid_589197
  var valid_589198 = query.getOrDefault("quotaUser")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "quotaUser", valid_589198
  var valid_589199 = query.getOrDefault("alt")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = newJString("json"))
  if valid_589199 != nil:
    section.add "alt", valid_589199
  var valid_589200 = query.getOrDefault("language")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "language", valid_589200
  var valid_589201 = query.getOrDefault("oauth_token")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "oauth_token", valid_589201
  var valid_589202 = query.getOrDefault("userIp")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "userIp", valid_589202
  var valid_589203 = query.getOrDefault("maxResults")
  valid_589203 = validateParameter(valid_589203, JInt, required = false, default = nil)
  if valid_589203 != nil:
    section.add "maxResults", valid_589203
  var valid_589204 = query.getOrDefault("key")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "key", valid_589204
  var valid_589205 = query.getOrDefault("prettyPrint")
  valid_589205 = validateParameter(valid_589205, JBool, required = false,
                                 default = newJBool(true))
  if valid_589205 != nil:
    section.add "prettyPrint", valid_589205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589206: Call_GamesLeaderboardsList_589193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the leaderboard metadata for your application.
  ## 
  let valid = call_589206.validator(path, query, header, formData, body)
  let scheme = call_589206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589206.url(scheme.get, call_589206.host, call_589206.base,
                         call_589206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589206, url, valid)

proc call*(call_589207: Call_GamesLeaderboardsList_589193; fields: string = "";
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
  var query_589208 = newJObject()
  add(query_589208, "fields", newJString(fields))
  add(query_589208, "pageToken", newJString(pageToken))
  add(query_589208, "quotaUser", newJString(quotaUser))
  add(query_589208, "alt", newJString(alt))
  add(query_589208, "language", newJString(language))
  add(query_589208, "oauth_token", newJString(oauthToken))
  add(query_589208, "userIp", newJString(userIp))
  add(query_589208, "maxResults", newJInt(maxResults))
  add(query_589208, "key", newJString(key))
  add(query_589208, "prettyPrint", newJBool(prettyPrint))
  result = call_589207.call(nil, query_589208, nil, nil, nil)

var gamesLeaderboardsList* = Call_GamesLeaderboardsList_589193(
    name: "gamesLeaderboardsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/leaderboards",
    validator: validate_GamesLeaderboardsList_589194, base: "/games/v1",
    url: url_GamesLeaderboardsList_589195, schemes: {Scheme.Https})
type
  Call_GamesScoresSubmitMultiple_589209 = ref object of OpenApiRestCall_588466
proc url_GamesScoresSubmitMultiple_589211(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesScoresSubmitMultiple_589210(path: JsonNode; query: JsonNode;
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
  var valid_589212 = query.getOrDefault("fields")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "fields", valid_589212
  var valid_589213 = query.getOrDefault("quotaUser")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "quotaUser", valid_589213
  var valid_589214 = query.getOrDefault("alt")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = newJString("json"))
  if valid_589214 != nil:
    section.add "alt", valid_589214
  var valid_589215 = query.getOrDefault("language")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "language", valid_589215
  var valid_589216 = query.getOrDefault("oauth_token")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "oauth_token", valid_589216
  var valid_589217 = query.getOrDefault("userIp")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "userIp", valid_589217
  var valid_589218 = query.getOrDefault("key")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "key", valid_589218
  var valid_589219 = query.getOrDefault("prettyPrint")
  valid_589219 = validateParameter(valid_589219, JBool, required = false,
                                 default = newJBool(true))
  if valid_589219 != nil:
    section.add "prettyPrint", valid_589219
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

proc call*(call_589221: Call_GamesScoresSubmitMultiple_589209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits multiple scores to leaderboards.
  ## 
  let valid = call_589221.validator(path, query, header, formData, body)
  let scheme = call_589221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589221.url(scheme.get, call_589221.host, call_589221.base,
                         call_589221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589221, url, valid)

proc call*(call_589222: Call_GamesScoresSubmitMultiple_589209; fields: string = "";
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
  var query_589223 = newJObject()
  var body_589224 = newJObject()
  add(query_589223, "fields", newJString(fields))
  add(query_589223, "quotaUser", newJString(quotaUser))
  add(query_589223, "alt", newJString(alt))
  add(query_589223, "language", newJString(language))
  add(query_589223, "oauth_token", newJString(oauthToken))
  add(query_589223, "userIp", newJString(userIp))
  add(query_589223, "key", newJString(key))
  if body != nil:
    body_589224 = body
  add(query_589223, "prettyPrint", newJBool(prettyPrint))
  result = call_589222.call(nil, query_589223, nil, nil, body_589224)

var gamesScoresSubmitMultiple* = Call_GamesScoresSubmitMultiple_589209(
    name: "gamesScoresSubmitMultiple", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/leaderboards/scores",
    validator: validate_GamesScoresSubmitMultiple_589210, base: "/games/v1",
    url: url_GamesScoresSubmitMultiple_589211, schemes: {Scheme.Https})
type
  Call_GamesLeaderboardsGet_589225 = ref object of OpenApiRestCall_588466
proc url_GamesLeaderboardsGet_589227(protocol: Scheme; host: string; base: string;
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

proc validate_GamesLeaderboardsGet_589226(path: JsonNode; query: JsonNode;
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
  var valid_589228 = path.getOrDefault("leaderboardId")
  valid_589228 = validateParameter(valid_589228, JString, required = true,
                                 default = nil)
  if valid_589228 != nil:
    section.add "leaderboardId", valid_589228
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
  var valid_589229 = query.getOrDefault("fields")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "fields", valid_589229
  var valid_589230 = query.getOrDefault("quotaUser")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "quotaUser", valid_589230
  var valid_589231 = query.getOrDefault("alt")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = newJString("json"))
  if valid_589231 != nil:
    section.add "alt", valid_589231
  var valid_589232 = query.getOrDefault("language")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "language", valid_589232
  var valid_589233 = query.getOrDefault("oauth_token")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "oauth_token", valid_589233
  var valid_589234 = query.getOrDefault("userIp")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "userIp", valid_589234
  var valid_589235 = query.getOrDefault("key")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "key", valid_589235
  var valid_589236 = query.getOrDefault("prettyPrint")
  valid_589236 = validateParameter(valid_589236, JBool, required = false,
                                 default = newJBool(true))
  if valid_589236 != nil:
    section.add "prettyPrint", valid_589236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589237: Call_GamesLeaderboardsGet_589225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata of the leaderboard with the given ID.
  ## 
  let valid = call_589237.validator(path, query, header, formData, body)
  let scheme = call_589237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589237.url(scheme.get, call_589237.host, call_589237.base,
                         call_589237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589237, url, valid)

proc call*(call_589238: Call_GamesLeaderboardsGet_589225; leaderboardId: string;
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
  var path_589239 = newJObject()
  var query_589240 = newJObject()
  add(query_589240, "fields", newJString(fields))
  add(query_589240, "quotaUser", newJString(quotaUser))
  add(query_589240, "alt", newJString(alt))
  add(query_589240, "language", newJString(language))
  add(path_589239, "leaderboardId", newJString(leaderboardId))
  add(query_589240, "oauth_token", newJString(oauthToken))
  add(query_589240, "userIp", newJString(userIp))
  add(query_589240, "key", newJString(key))
  add(query_589240, "prettyPrint", newJBool(prettyPrint))
  result = call_589238.call(path_589239, query_589240, nil, nil, nil)

var gamesLeaderboardsGet* = Call_GamesLeaderboardsGet_589225(
    name: "gamesLeaderboardsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesLeaderboardsGet_589226, base: "/games/v1",
    url: url_GamesLeaderboardsGet_589227, schemes: {Scheme.Https})
type
  Call_GamesScoresSubmit_589241 = ref object of OpenApiRestCall_588466
proc url_GamesScoresSubmit_589243(protocol: Scheme; host: string; base: string;
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

proc validate_GamesScoresSubmit_589242(path: JsonNode; query: JsonNode;
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
  var valid_589244 = path.getOrDefault("leaderboardId")
  valid_589244 = validateParameter(valid_589244, JString, required = true,
                                 default = nil)
  if valid_589244 != nil:
    section.add "leaderboardId", valid_589244
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
  var valid_589245 = query.getOrDefault("fields")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "fields", valid_589245
  var valid_589246 = query.getOrDefault("quotaUser")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "quotaUser", valid_589246
  var valid_589247 = query.getOrDefault("alt")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = newJString("json"))
  if valid_589247 != nil:
    section.add "alt", valid_589247
  var valid_589248 = query.getOrDefault("language")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "language", valid_589248
  var valid_589249 = query.getOrDefault("oauth_token")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "oauth_token", valid_589249
  var valid_589250 = query.getOrDefault("userIp")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "userIp", valid_589250
  var valid_589251 = query.getOrDefault("key")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "key", valid_589251
  var valid_589252 = query.getOrDefault("scoreTag")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "scoreTag", valid_589252
  assert query != nil, "query argument is necessary due to required `score` field"
  var valid_589253 = query.getOrDefault("score")
  valid_589253 = validateParameter(valid_589253, JString, required = true,
                                 default = nil)
  if valid_589253 != nil:
    section.add "score", valid_589253
  var valid_589254 = query.getOrDefault("prettyPrint")
  valid_589254 = validateParameter(valid_589254, JBool, required = false,
                                 default = newJBool(true))
  if valid_589254 != nil:
    section.add "prettyPrint", valid_589254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589255: Call_GamesScoresSubmit_589241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a score to the specified leaderboard.
  ## 
  let valid = call_589255.validator(path, query, header, formData, body)
  let scheme = call_589255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589255.url(scheme.get, call_589255.host, call_589255.base,
                         call_589255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589255, url, valid)

proc call*(call_589256: Call_GamesScoresSubmit_589241; leaderboardId: string;
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
  var path_589257 = newJObject()
  var query_589258 = newJObject()
  add(query_589258, "fields", newJString(fields))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(query_589258, "language", newJString(language))
  add(path_589257, "leaderboardId", newJString(leaderboardId))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(query_589258, "userIp", newJString(userIp))
  add(query_589258, "key", newJString(key))
  add(query_589258, "scoreTag", newJString(scoreTag))
  add(query_589258, "score", newJString(score))
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  result = call_589256.call(path_589257, query_589258, nil, nil, nil)

var gamesScoresSubmit* = Call_GamesScoresSubmit_589241(name: "gamesScoresSubmit",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores",
    validator: validate_GamesScoresSubmit_589242, base: "/games/v1",
    url: url_GamesScoresSubmit_589243, schemes: {Scheme.Https})
type
  Call_GamesScoresList_589259 = ref object of OpenApiRestCall_588466
proc url_GamesScoresList_589261(protocol: Scheme; host: string; base: string;
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

proc validate_GamesScoresList_589260(path: JsonNode; query: JsonNode;
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
  var valid_589262 = path.getOrDefault("leaderboardId")
  valid_589262 = validateParameter(valid_589262, JString, required = true,
                                 default = nil)
  if valid_589262 != nil:
    section.add "leaderboardId", valid_589262
  var valid_589263 = path.getOrDefault("collection")
  valid_589263 = validateParameter(valid_589263, JString, required = true,
                                 default = newJString("PUBLIC"))
  if valid_589263 != nil:
    section.add "collection", valid_589263
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
  var valid_589264 = query.getOrDefault("fields")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "fields", valid_589264
  var valid_589265 = query.getOrDefault("pageToken")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "pageToken", valid_589265
  var valid_589266 = query.getOrDefault("quotaUser")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "quotaUser", valid_589266
  var valid_589267 = query.getOrDefault("alt")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = newJString("json"))
  if valid_589267 != nil:
    section.add "alt", valid_589267
  var valid_589268 = query.getOrDefault("language")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "language", valid_589268
  var valid_589269 = query.getOrDefault("oauth_token")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "oauth_token", valid_589269
  var valid_589270 = query.getOrDefault("userIp")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "userIp", valid_589270
  var valid_589271 = query.getOrDefault("maxResults")
  valid_589271 = validateParameter(valid_589271, JInt, required = false, default = nil)
  if valid_589271 != nil:
    section.add "maxResults", valid_589271
  assert query != nil,
        "query argument is necessary due to required `timeSpan` field"
  var valid_589272 = query.getOrDefault("timeSpan")
  valid_589272 = validateParameter(valid_589272, JString, required = true,
                                 default = newJString("ALL_TIME"))
  if valid_589272 != nil:
    section.add "timeSpan", valid_589272
  var valid_589273 = query.getOrDefault("key")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "key", valid_589273
  var valid_589274 = query.getOrDefault("prettyPrint")
  valid_589274 = validateParameter(valid_589274, JBool, required = false,
                                 default = newJBool(true))
  if valid_589274 != nil:
    section.add "prettyPrint", valid_589274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589275: Call_GamesScoresList_589259; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the scores in a leaderboard, starting from the top.
  ## 
  let valid = call_589275.validator(path, query, header, formData, body)
  let scheme = call_589275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589275.url(scheme.get, call_589275.host, call_589275.base,
                         call_589275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589275, url, valid)

proc call*(call_589276: Call_GamesScoresList_589259; leaderboardId: string;
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
  var path_589277 = newJObject()
  var query_589278 = newJObject()
  add(query_589278, "fields", newJString(fields))
  add(query_589278, "pageToken", newJString(pageToken))
  add(query_589278, "quotaUser", newJString(quotaUser))
  add(query_589278, "alt", newJString(alt))
  add(query_589278, "language", newJString(language))
  add(path_589277, "leaderboardId", newJString(leaderboardId))
  add(query_589278, "oauth_token", newJString(oauthToken))
  add(path_589277, "collection", newJString(collection))
  add(query_589278, "userIp", newJString(userIp))
  add(query_589278, "maxResults", newJInt(maxResults))
  add(query_589278, "timeSpan", newJString(timeSpan))
  add(query_589278, "key", newJString(key))
  add(query_589278, "prettyPrint", newJBool(prettyPrint))
  result = call_589276.call(path_589277, query_589278, nil, nil, nil)

var gamesScoresList* = Call_GamesScoresList_589259(name: "gamesScoresList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/{collection}",
    validator: validate_GamesScoresList_589260, base: "/games/v1",
    url: url_GamesScoresList_589261, schemes: {Scheme.Https})
type
  Call_GamesScoresListWindow_589279 = ref object of OpenApiRestCall_588466
proc url_GamesScoresListWindow_589281(protocol: Scheme; host: string; base: string;
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

proc validate_GamesScoresListWindow_589280(path: JsonNode; query: JsonNode;
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
  var valid_589282 = path.getOrDefault("leaderboardId")
  valid_589282 = validateParameter(valid_589282, JString, required = true,
                                 default = nil)
  if valid_589282 != nil:
    section.add "leaderboardId", valid_589282
  var valid_589283 = path.getOrDefault("collection")
  valid_589283 = validateParameter(valid_589283, JString, required = true,
                                 default = newJString("PUBLIC"))
  if valid_589283 != nil:
    section.add "collection", valid_589283
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
  var valid_589284 = query.getOrDefault("fields")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "fields", valid_589284
  var valid_589285 = query.getOrDefault("pageToken")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "pageToken", valid_589285
  var valid_589286 = query.getOrDefault("quotaUser")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "quotaUser", valid_589286
  var valid_589287 = query.getOrDefault("alt")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = newJString("json"))
  if valid_589287 != nil:
    section.add "alt", valid_589287
  var valid_589288 = query.getOrDefault("language")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "language", valid_589288
  var valid_589289 = query.getOrDefault("oauth_token")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "oauth_token", valid_589289
  var valid_589290 = query.getOrDefault("userIp")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "userIp", valid_589290
  var valid_589291 = query.getOrDefault("resultsAbove")
  valid_589291 = validateParameter(valid_589291, JInt, required = false, default = nil)
  if valid_589291 != nil:
    section.add "resultsAbove", valid_589291
  var valid_589292 = query.getOrDefault("maxResults")
  valid_589292 = validateParameter(valid_589292, JInt, required = false, default = nil)
  if valid_589292 != nil:
    section.add "maxResults", valid_589292
  assert query != nil,
        "query argument is necessary due to required `timeSpan` field"
  var valid_589293 = query.getOrDefault("timeSpan")
  valid_589293 = validateParameter(valid_589293, JString, required = true,
                                 default = newJString("ALL_TIME"))
  if valid_589293 != nil:
    section.add "timeSpan", valid_589293
  var valid_589294 = query.getOrDefault("key")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "key", valid_589294
  var valid_589295 = query.getOrDefault("prettyPrint")
  valid_589295 = validateParameter(valid_589295, JBool, required = false,
                                 default = newJBool(true))
  if valid_589295 != nil:
    section.add "prettyPrint", valid_589295
  var valid_589296 = query.getOrDefault("returnTopIfAbsent")
  valid_589296 = validateParameter(valid_589296, JBool, required = false, default = nil)
  if valid_589296 != nil:
    section.add "returnTopIfAbsent", valid_589296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589297: Call_GamesScoresListWindow_589279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the scores in a leaderboard around (and including) a player's score.
  ## 
  let valid = call_589297.validator(path, query, header, formData, body)
  let scheme = call_589297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589297.url(scheme.get, call_589297.host, call_589297.base,
                         call_589297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589297, url, valid)

proc call*(call_589298: Call_GamesScoresListWindow_589279; leaderboardId: string;
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
  var path_589299 = newJObject()
  var query_589300 = newJObject()
  add(query_589300, "fields", newJString(fields))
  add(query_589300, "pageToken", newJString(pageToken))
  add(query_589300, "quotaUser", newJString(quotaUser))
  add(query_589300, "alt", newJString(alt))
  add(query_589300, "language", newJString(language))
  add(path_589299, "leaderboardId", newJString(leaderboardId))
  add(query_589300, "oauth_token", newJString(oauthToken))
  add(path_589299, "collection", newJString(collection))
  add(query_589300, "userIp", newJString(userIp))
  add(query_589300, "resultsAbove", newJInt(resultsAbove))
  add(query_589300, "maxResults", newJInt(maxResults))
  add(query_589300, "timeSpan", newJString(timeSpan))
  add(query_589300, "key", newJString(key))
  add(query_589300, "prettyPrint", newJBool(prettyPrint))
  add(query_589300, "returnTopIfAbsent", newJBool(returnTopIfAbsent))
  result = call_589298.call(path_589299, query_589300, nil, nil, nil)

var gamesScoresListWindow* = Call_GamesScoresListWindow_589279(
    name: "gamesScoresListWindow", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/window/{collection}",
    validator: validate_GamesScoresListWindow_589280, base: "/games/v1",
    url: url_GamesScoresListWindow_589281, schemes: {Scheme.Https})
type
  Call_GamesMetagameGetMetagameConfig_589301 = ref object of OpenApiRestCall_588466
proc url_GamesMetagameGetMetagameConfig_589303(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesMetagameGetMetagameConfig_589302(path: JsonNode;
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
  var valid_589304 = query.getOrDefault("fields")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "fields", valid_589304
  var valid_589305 = query.getOrDefault("quotaUser")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "quotaUser", valid_589305
  var valid_589306 = query.getOrDefault("alt")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = newJString("json"))
  if valid_589306 != nil:
    section.add "alt", valid_589306
  var valid_589307 = query.getOrDefault("oauth_token")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "oauth_token", valid_589307
  var valid_589308 = query.getOrDefault("userIp")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "userIp", valid_589308
  var valid_589309 = query.getOrDefault("key")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "key", valid_589309
  var valid_589310 = query.getOrDefault("prettyPrint")
  valid_589310 = validateParameter(valid_589310, JBool, required = false,
                                 default = newJBool(true))
  if valid_589310 != nil:
    section.add "prettyPrint", valid_589310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589311: Call_GamesMetagameGetMetagameConfig_589301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the metagame configuration data for the calling application.
  ## 
  let valid = call_589311.validator(path, query, header, formData, body)
  let scheme = call_589311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589311.url(scheme.get, call_589311.host, call_589311.base,
                         call_589311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589311, url, valid)

proc call*(call_589312: Call_GamesMetagameGetMetagameConfig_589301;
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
  var query_589313 = newJObject()
  add(query_589313, "fields", newJString(fields))
  add(query_589313, "quotaUser", newJString(quotaUser))
  add(query_589313, "alt", newJString(alt))
  add(query_589313, "oauth_token", newJString(oauthToken))
  add(query_589313, "userIp", newJString(userIp))
  add(query_589313, "key", newJString(key))
  add(query_589313, "prettyPrint", newJBool(prettyPrint))
  result = call_589312.call(nil, query_589313, nil, nil, nil)

var gamesMetagameGetMetagameConfig* = Call_GamesMetagameGetMetagameConfig_589301(
    name: "gamesMetagameGetMetagameConfig", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metagameConfig",
    validator: validate_GamesMetagameGetMetagameConfig_589302, base: "/games/v1",
    url: url_GamesMetagameGetMetagameConfig_589303, schemes: {Scheme.Https})
type
  Call_GamesPlayersList_589314 = ref object of OpenApiRestCall_588466
proc url_GamesPlayersList_589316(protocol: Scheme; host: string; base: string;
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

proc validate_GamesPlayersList_589315(path: JsonNode; query: JsonNode;
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
  var valid_589317 = path.getOrDefault("collection")
  valid_589317 = validateParameter(valid_589317, JString, required = true,
                                 default = newJString("connected"))
  if valid_589317 != nil:
    section.add "collection", valid_589317
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
  var valid_589318 = query.getOrDefault("fields")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "fields", valid_589318
  var valid_589319 = query.getOrDefault("pageToken")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "pageToken", valid_589319
  var valid_589320 = query.getOrDefault("quotaUser")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "quotaUser", valid_589320
  var valid_589321 = query.getOrDefault("alt")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = newJString("json"))
  if valid_589321 != nil:
    section.add "alt", valid_589321
  var valid_589322 = query.getOrDefault("language")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "language", valid_589322
  var valid_589323 = query.getOrDefault("oauth_token")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "oauth_token", valid_589323
  var valid_589324 = query.getOrDefault("userIp")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "userIp", valid_589324
  var valid_589325 = query.getOrDefault("maxResults")
  valid_589325 = validateParameter(valid_589325, JInt, required = false, default = nil)
  if valid_589325 != nil:
    section.add "maxResults", valid_589325
  var valid_589326 = query.getOrDefault("key")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "key", valid_589326
  var valid_589327 = query.getOrDefault("prettyPrint")
  valid_589327 = validateParameter(valid_589327, JBool, required = false,
                                 default = newJBool(true))
  if valid_589327 != nil:
    section.add "prettyPrint", valid_589327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589328: Call_GamesPlayersList_589314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the collection of players for the currently authenticated user.
  ## 
  let valid = call_589328.validator(path, query, header, formData, body)
  let scheme = call_589328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589328.url(scheme.get, call_589328.host, call_589328.base,
                         call_589328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589328, url, valid)

proc call*(call_589329: Call_GamesPlayersList_589314; fields: string = "";
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
  var path_589330 = newJObject()
  var query_589331 = newJObject()
  add(query_589331, "fields", newJString(fields))
  add(query_589331, "pageToken", newJString(pageToken))
  add(query_589331, "quotaUser", newJString(quotaUser))
  add(query_589331, "alt", newJString(alt))
  add(query_589331, "language", newJString(language))
  add(query_589331, "oauth_token", newJString(oauthToken))
  add(path_589330, "collection", newJString(collection))
  add(query_589331, "userIp", newJString(userIp))
  add(query_589331, "maxResults", newJInt(maxResults))
  add(query_589331, "key", newJString(key))
  add(query_589331, "prettyPrint", newJBool(prettyPrint))
  result = call_589329.call(path_589330, query_589331, nil, nil, nil)

var gamesPlayersList* = Call_GamesPlayersList_589314(name: "gamesPlayersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/me/players/{collection}",
    validator: validate_GamesPlayersList_589315, base: "/games/v1",
    url: url_GamesPlayersList_589316, schemes: {Scheme.Https})
type
  Call_GamesPlayersGet_589332 = ref object of OpenApiRestCall_588466
proc url_GamesPlayersGet_589334(protocol: Scheme; host: string; base: string;
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

proc validate_GamesPlayersGet_589333(path: JsonNode; query: JsonNode;
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
  var valid_589335 = path.getOrDefault("playerId")
  valid_589335 = validateParameter(valid_589335, JString, required = true,
                                 default = nil)
  if valid_589335 != nil:
    section.add "playerId", valid_589335
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
  var valid_589336 = query.getOrDefault("fields")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "fields", valid_589336
  var valid_589337 = query.getOrDefault("quotaUser")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "quotaUser", valid_589337
  var valid_589338 = query.getOrDefault("alt")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = newJString("json"))
  if valid_589338 != nil:
    section.add "alt", valid_589338
  var valid_589339 = query.getOrDefault("language")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "language", valid_589339
  var valid_589340 = query.getOrDefault("oauth_token")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "oauth_token", valid_589340
  var valid_589341 = query.getOrDefault("userIp")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "userIp", valid_589341
  var valid_589342 = query.getOrDefault("key")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "key", valid_589342
  var valid_589343 = query.getOrDefault("prettyPrint")
  valid_589343 = validateParameter(valid_589343, JBool, required = false,
                                 default = newJBool(true))
  if valid_589343 != nil:
    section.add "prettyPrint", valid_589343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589344: Call_GamesPlayersGet_589332; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the Player resource with the given ID. To retrieve the player for the currently authenticated user, set playerId to me.
  ## 
  let valid = call_589344.validator(path, query, header, formData, body)
  let scheme = call_589344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589344.url(scheme.get, call_589344.host, call_589344.base,
                         call_589344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589344, url, valid)

proc call*(call_589345: Call_GamesPlayersGet_589332; playerId: string;
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
  var path_589346 = newJObject()
  var query_589347 = newJObject()
  add(query_589347, "fields", newJString(fields))
  add(query_589347, "quotaUser", newJString(quotaUser))
  add(query_589347, "alt", newJString(alt))
  add(query_589347, "language", newJString(language))
  add(query_589347, "oauth_token", newJString(oauthToken))
  add(path_589346, "playerId", newJString(playerId))
  add(query_589347, "userIp", newJString(userIp))
  add(query_589347, "key", newJString(key))
  add(query_589347, "prettyPrint", newJBool(prettyPrint))
  result = call_589345.call(path_589346, query_589347, nil, nil, nil)

var gamesPlayersGet* = Call_GamesPlayersGet_589332(name: "gamesPlayersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/{playerId}", validator: validate_GamesPlayersGet_589333,
    base: "/games/v1", url: url_GamesPlayersGet_589334, schemes: {Scheme.Https})
type
  Call_GamesAchievementsList_589348 = ref object of OpenApiRestCall_588466
proc url_GamesAchievementsList_589350(protocol: Scheme; host: string; base: string;
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

proc validate_GamesAchievementsList_589349(path: JsonNode; query: JsonNode;
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
  var valid_589351 = path.getOrDefault("playerId")
  valid_589351 = validateParameter(valid_589351, JString, required = true,
                                 default = nil)
  if valid_589351 != nil:
    section.add "playerId", valid_589351
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
  var valid_589352 = query.getOrDefault("fields")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "fields", valid_589352
  var valid_589353 = query.getOrDefault("pageToken")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "pageToken", valid_589353
  var valid_589354 = query.getOrDefault("quotaUser")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "quotaUser", valid_589354
  var valid_589355 = query.getOrDefault("alt")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = newJString("json"))
  if valid_589355 != nil:
    section.add "alt", valid_589355
  var valid_589356 = query.getOrDefault("language")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "language", valid_589356
  var valid_589357 = query.getOrDefault("oauth_token")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "oauth_token", valid_589357
  var valid_589358 = query.getOrDefault("userIp")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "userIp", valid_589358
  var valid_589359 = query.getOrDefault("maxResults")
  valid_589359 = validateParameter(valid_589359, JInt, required = false, default = nil)
  if valid_589359 != nil:
    section.add "maxResults", valid_589359
  var valid_589360 = query.getOrDefault("key")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "key", valid_589360
  var valid_589361 = query.getOrDefault("prettyPrint")
  valid_589361 = validateParameter(valid_589361, JBool, required = false,
                                 default = newJBool(true))
  if valid_589361 != nil:
    section.add "prettyPrint", valid_589361
  var valid_589362 = query.getOrDefault("state")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = newJString("ALL"))
  if valid_589362 != nil:
    section.add "state", valid_589362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589363: Call_GamesAchievementsList_589348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the progress for all your application's achievements for the currently authenticated player.
  ## 
  let valid = call_589363.validator(path, query, header, formData, body)
  let scheme = call_589363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589363.url(scheme.get, call_589363.host, call_589363.base,
                         call_589363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589363, url, valid)

proc call*(call_589364: Call_GamesAchievementsList_589348; playerId: string;
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
  var path_589365 = newJObject()
  var query_589366 = newJObject()
  add(query_589366, "fields", newJString(fields))
  add(query_589366, "pageToken", newJString(pageToken))
  add(query_589366, "quotaUser", newJString(quotaUser))
  add(query_589366, "alt", newJString(alt))
  add(query_589366, "language", newJString(language))
  add(query_589366, "oauth_token", newJString(oauthToken))
  add(path_589365, "playerId", newJString(playerId))
  add(query_589366, "userIp", newJString(userIp))
  add(query_589366, "maxResults", newJInt(maxResults))
  add(query_589366, "key", newJString(key))
  add(query_589366, "prettyPrint", newJBool(prettyPrint))
  add(query_589366, "state", newJString(state))
  result = call_589364.call(path_589365, query_589366, nil, nil, nil)

var gamesAchievementsList* = Call_GamesAchievementsList_589348(
    name: "gamesAchievementsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/players/{playerId}/achievements",
    validator: validate_GamesAchievementsList_589349, base: "/games/v1",
    url: url_GamesAchievementsList_589350, schemes: {Scheme.Https})
type
  Call_GamesMetagameListCategoriesByPlayer_589367 = ref object of OpenApiRestCall_588466
proc url_GamesMetagameListCategoriesByPlayer_589369(protocol: Scheme; host: string;
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

proc validate_GamesMetagameListCategoriesByPlayer_589368(path: JsonNode;
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
  var valid_589370 = path.getOrDefault("collection")
  valid_589370 = validateParameter(valid_589370, JString, required = true,
                                 default = newJString("all"))
  if valid_589370 != nil:
    section.add "collection", valid_589370
  var valid_589371 = path.getOrDefault("playerId")
  valid_589371 = validateParameter(valid_589371, JString, required = true,
                                 default = nil)
  if valid_589371 != nil:
    section.add "playerId", valid_589371
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
  var valid_589372 = query.getOrDefault("fields")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "fields", valid_589372
  var valid_589373 = query.getOrDefault("pageToken")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "pageToken", valid_589373
  var valid_589374 = query.getOrDefault("quotaUser")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "quotaUser", valid_589374
  var valid_589375 = query.getOrDefault("alt")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = newJString("json"))
  if valid_589375 != nil:
    section.add "alt", valid_589375
  var valid_589376 = query.getOrDefault("language")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "language", valid_589376
  var valid_589377 = query.getOrDefault("oauth_token")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "oauth_token", valid_589377
  var valid_589378 = query.getOrDefault("userIp")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "userIp", valid_589378
  var valid_589379 = query.getOrDefault("maxResults")
  valid_589379 = validateParameter(valid_589379, JInt, required = false, default = nil)
  if valid_589379 != nil:
    section.add "maxResults", valid_589379
  var valid_589380 = query.getOrDefault("key")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "key", valid_589380
  var valid_589381 = query.getOrDefault("prettyPrint")
  valid_589381 = validateParameter(valid_589381, JBool, required = false,
                                 default = newJBool(true))
  if valid_589381 != nil:
    section.add "prettyPrint", valid_589381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589382: Call_GamesMetagameListCategoriesByPlayer_589367;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List play data aggregated per category for the player corresponding to playerId.
  ## 
  let valid = call_589382.validator(path, query, header, formData, body)
  let scheme = call_589382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589382.url(scheme.get, call_589382.host, call_589382.base,
                         call_589382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589382, url, valid)

proc call*(call_589383: Call_GamesMetagameListCategoriesByPlayer_589367;
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
  var path_589384 = newJObject()
  var query_589385 = newJObject()
  add(query_589385, "fields", newJString(fields))
  add(query_589385, "pageToken", newJString(pageToken))
  add(query_589385, "quotaUser", newJString(quotaUser))
  add(query_589385, "alt", newJString(alt))
  add(query_589385, "language", newJString(language))
  add(query_589385, "oauth_token", newJString(oauthToken))
  add(path_589384, "collection", newJString(collection))
  add(path_589384, "playerId", newJString(playerId))
  add(query_589385, "userIp", newJString(userIp))
  add(query_589385, "maxResults", newJInt(maxResults))
  add(query_589385, "key", newJString(key))
  add(query_589385, "prettyPrint", newJBool(prettyPrint))
  result = call_589383.call(path_589384, query_589385, nil, nil, nil)

var gamesMetagameListCategoriesByPlayer* = Call_GamesMetagameListCategoriesByPlayer_589367(
    name: "gamesMetagameListCategoriesByPlayer", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/players/{playerId}/categories/{collection}",
    validator: validate_GamesMetagameListCategoriesByPlayer_589368,
    base: "/games/v1", url: url_GamesMetagameListCategoriesByPlayer_589369,
    schemes: {Scheme.Https})
type
  Call_GamesScoresGet_589386 = ref object of OpenApiRestCall_588466
proc url_GamesScoresGet_589388(protocol: Scheme; host: string; base: string;
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

proc validate_GamesScoresGet_589387(path: JsonNode; query: JsonNode;
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
  var valid_589389 = path.getOrDefault("timeSpan")
  valid_589389 = validateParameter(valid_589389, JString, required = true,
                                 default = newJString("ALL"))
  if valid_589389 != nil:
    section.add "timeSpan", valid_589389
  var valid_589390 = path.getOrDefault("leaderboardId")
  valid_589390 = validateParameter(valid_589390, JString, required = true,
                                 default = nil)
  if valid_589390 != nil:
    section.add "leaderboardId", valid_589390
  var valid_589391 = path.getOrDefault("playerId")
  valid_589391 = validateParameter(valid_589391, JString, required = true,
                                 default = nil)
  if valid_589391 != nil:
    section.add "playerId", valid_589391
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
  var valid_589392 = query.getOrDefault("fields")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "fields", valid_589392
  var valid_589393 = query.getOrDefault("pageToken")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "pageToken", valid_589393
  var valid_589394 = query.getOrDefault("quotaUser")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "quotaUser", valid_589394
  var valid_589395 = query.getOrDefault("alt")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = newJString("json"))
  if valid_589395 != nil:
    section.add "alt", valid_589395
  var valid_589396 = query.getOrDefault("language")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "language", valid_589396
  var valid_589397 = query.getOrDefault("includeRankType")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = newJString("ALL"))
  if valid_589397 != nil:
    section.add "includeRankType", valid_589397
  var valid_589398 = query.getOrDefault("oauth_token")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "oauth_token", valid_589398
  var valid_589399 = query.getOrDefault("userIp")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "userIp", valid_589399
  var valid_589400 = query.getOrDefault("maxResults")
  valid_589400 = validateParameter(valid_589400, JInt, required = false, default = nil)
  if valid_589400 != nil:
    section.add "maxResults", valid_589400
  var valid_589401 = query.getOrDefault("key")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "key", valid_589401
  var valid_589402 = query.getOrDefault("prettyPrint")
  valid_589402 = validateParameter(valid_589402, JBool, required = false,
                                 default = newJBool(true))
  if valid_589402 != nil:
    section.add "prettyPrint", valid_589402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589403: Call_GamesScoresGet_589386; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get high scores, and optionally ranks, in leaderboards for the currently authenticated player. For a specific time span, leaderboardId can be set to ALL to retrieve data for all leaderboards in a given time span.
  ## NOTE: You cannot ask for 'ALL' leaderboards and 'ALL' timeSpans in the same request; only one parameter may be set to 'ALL'.
  ## 
  let valid = call_589403.validator(path, query, header, formData, body)
  let scheme = call_589403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589403.url(scheme.get, call_589403.host, call_589403.base,
                         call_589403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589403, url, valid)

proc call*(call_589404: Call_GamesScoresGet_589386; leaderboardId: string;
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
  var path_589405 = newJObject()
  var query_589406 = newJObject()
  add(path_589405, "timeSpan", newJString(timeSpan))
  add(query_589406, "fields", newJString(fields))
  add(query_589406, "pageToken", newJString(pageToken))
  add(query_589406, "quotaUser", newJString(quotaUser))
  add(query_589406, "alt", newJString(alt))
  add(query_589406, "language", newJString(language))
  add(query_589406, "includeRankType", newJString(includeRankType))
  add(path_589405, "leaderboardId", newJString(leaderboardId))
  add(query_589406, "oauth_token", newJString(oauthToken))
  add(path_589405, "playerId", newJString(playerId))
  add(query_589406, "userIp", newJString(userIp))
  add(query_589406, "maxResults", newJInt(maxResults))
  add(query_589406, "key", newJString(key))
  add(query_589406, "prettyPrint", newJBool(prettyPrint))
  result = call_589404.call(path_589405, query_589406, nil, nil, nil)

var gamesScoresGet* = Call_GamesScoresGet_589386(name: "gamesScoresGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/players/{playerId}/leaderboards/{leaderboardId}/scores/{timeSpan}",
    validator: validate_GamesScoresGet_589387, base: "/games/v1",
    url: url_GamesScoresGet_589388, schemes: {Scheme.Https})
type
  Call_GamesQuestsList_589407 = ref object of OpenApiRestCall_588466
proc url_GamesQuestsList_589409(protocol: Scheme; host: string; base: string;
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

proc validate_GamesQuestsList_589408(path: JsonNode; query: JsonNode;
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
  var valid_589410 = path.getOrDefault("playerId")
  valid_589410 = validateParameter(valid_589410, JString, required = true,
                                 default = nil)
  if valid_589410 != nil:
    section.add "playerId", valid_589410
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
  var valid_589411 = query.getOrDefault("fields")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "fields", valid_589411
  var valid_589412 = query.getOrDefault("pageToken")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "pageToken", valid_589412
  var valid_589413 = query.getOrDefault("quotaUser")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "quotaUser", valid_589413
  var valid_589414 = query.getOrDefault("alt")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = newJString("json"))
  if valid_589414 != nil:
    section.add "alt", valid_589414
  var valid_589415 = query.getOrDefault("language")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "language", valid_589415
  var valid_589416 = query.getOrDefault("oauth_token")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "oauth_token", valid_589416
  var valid_589417 = query.getOrDefault("userIp")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "userIp", valid_589417
  var valid_589418 = query.getOrDefault("maxResults")
  valid_589418 = validateParameter(valid_589418, JInt, required = false, default = nil)
  if valid_589418 != nil:
    section.add "maxResults", valid_589418
  var valid_589419 = query.getOrDefault("key")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "key", valid_589419
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
  if body != nil:
    result.add "body", body

proc call*(call_589421: Call_GamesQuestsList_589407; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of quests for your application and the currently authenticated player.
  ## 
  let valid = call_589421.validator(path, query, header, formData, body)
  let scheme = call_589421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589421.url(scheme.get, call_589421.host, call_589421.base,
                         call_589421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589421, url, valid)

proc call*(call_589422: Call_GamesQuestsList_589407; playerId: string;
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
  var path_589423 = newJObject()
  var query_589424 = newJObject()
  add(query_589424, "fields", newJString(fields))
  add(query_589424, "pageToken", newJString(pageToken))
  add(query_589424, "quotaUser", newJString(quotaUser))
  add(query_589424, "alt", newJString(alt))
  add(query_589424, "language", newJString(language))
  add(query_589424, "oauth_token", newJString(oauthToken))
  add(path_589423, "playerId", newJString(playerId))
  add(query_589424, "userIp", newJString(userIp))
  add(query_589424, "maxResults", newJInt(maxResults))
  add(query_589424, "key", newJString(key))
  add(query_589424, "prettyPrint", newJBool(prettyPrint))
  result = call_589422.call(path_589423, query_589424, nil, nil, nil)

var gamesQuestsList* = Call_GamesQuestsList_589407(name: "gamesQuestsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/{playerId}/quests", validator: validate_GamesQuestsList_589408,
    base: "/games/v1", url: url_GamesQuestsList_589409, schemes: {Scheme.Https})
type
  Call_GamesSnapshotsList_589425 = ref object of OpenApiRestCall_588466
proc url_GamesSnapshotsList_589427(protocol: Scheme; host: string; base: string;
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

proc validate_GamesSnapshotsList_589426(path: JsonNode; query: JsonNode;
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
  var valid_589428 = path.getOrDefault("playerId")
  valid_589428 = validateParameter(valid_589428, JString, required = true,
                                 default = nil)
  if valid_589428 != nil:
    section.add "playerId", valid_589428
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
  var valid_589429 = query.getOrDefault("fields")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "fields", valid_589429
  var valid_589430 = query.getOrDefault("pageToken")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "pageToken", valid_589430
  var valid_589431 = query.getOrDefault("quotaUser")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "quotaUser", valid_589431
  var valid_589432 = query.getOrDefault("alt")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = newJString("json"))
  if valid_589432 != nil:
    section.add "alt", valid_589432
  var valid_589433 = query.getOrDefault("language")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "language", valid_589433
  var valid_589434 = query.getOrDefault("oauth_token")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "oauth_token", valid_589434
  var valid_589435 = query.getOrDefault("userIp")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "userIp", valid_589435
  var valid_589436 = query.getOrDefault("maxResults")
  valid_589436 = validateParameter(valid_589436, JInt, required = false, default = nil)
  if valid_589436 != nil:
    section.add "maxResults", valid_589436
  var valid_589437 = query.getOrDefault("key")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "key", valid_589437
  var valid_589438 = query.getOrDefault("prettyPrint")
  valid_589438 = validateParameter(valid_589438, JBool, required = false,
                                 default = newJBool(true))
  if valid_589438 != nil:
    section.add "prettyPrint", valid_589438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589439: Call_GamesSnapshotsList_589425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of snapshots created by your application for the player corresponding to the player ID.
  ## 
  let valid = call_589439.validator(path, query, header, formData, body)
  let scheme = call_589439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589439.url(scheme.get, call_589439.host, call_589439.base,
                         call_589439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589439, url, valid)

proc call*(call_589440: Call_GamesSnapshotsList_589425; playerId: string;
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
  var path_589441 = newJObject()
  var query_589442 = newJObject()
  add(query_589442, "fields", newJString(fields))
  add(query_589442, "pageToken", newJString(pageToken))
  add(query_589442, "quotaUser", newJString(quotaUser))
  add(query_589442, "alt", newJString(alt))
  add(query_589442, "language", newJString(language))
  add(query_589442, "oauth_token", newJString(oauthToken))
  add(path_589441, "playerId", newJString(playerId))
  add(query_589442, "userIp", newJString(userIp))
  add(query_589442, "maxResults", newJInt(maxResults))
  add(query_589442, "key", newJString(key))
  add(query_589442, "prettyPrint", newJBool(prettyPrint))
  result = call_589440.call(path_589441, query_589442, nil, nil, nil)

var gamesSnapshotsList* = Call_GamesSnapshotsList_589425(
    name: "gamesSnapshotsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/players/{playerId}/snapshots",
    validator: validate_GamesSnapshotsList_589426, base: "/games/v1",
    url: url_GamesSnapshotsList_589427, schemes: {Scheme.Https})
type
  Call_GamesPushtokensUpdate_589443 = ref object of OpenApiRestCall_588466
proc url_GamesPushtokensUpdate_589445(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesPushtokensUpdate_589444(path: JsonNode; query: JsonNode;
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
  var valid_589446 = query.getOrDefault("fields")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "fields", valid_589446
  var valid_589447 = query.getOrDefault("quotaUser")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = nil)
  if valid_589447 != nil:
    section.add "quotaUser", valid_589447
  var valid_589448 = query.getOrDefault("alt")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = newJString("json"))
  if valid_589448 != nil:
    section.add "alt", valid_589448
  var valid_589449 = query.getOrDefault("oauth_token")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "oauth_token", valid_589449
  var valid_589450 = query.getOrDefault("userIp")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "userIp", valid_589450
  var valid_589451 = query.getOrDefault("key")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "key", valid_589451
  var valid_589452 = query.getOrDefault("prettyPrint")
  valid_589452 = validateParameter(valid_589452, JBool, required = false,
                                 default = newJBool(true))
  if valid_589452 != nil:
    section.add "prettyPrint", valid_589452
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

proc call*(call_589454: Call_GamesPushtokensUpdate_589443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a push token for the current user and application.
  ## 
  let valid = call_589454.validator(path, query, header, formData, body)
  let scheme = call_589454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589454.url(scheme.get, call_589454.host, call_589454.base,
                         call_589454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589454, url, valid)

proc call*(call_589455: Call_GamesPushtokensUpdate_589443; fields: string = "";
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
  var query_589456 = newJObject()
  var body_589457 = newJObject()
  add(query_589456, "fields", newJString(fields))
  add(query_589456, "quotaUser", newJString(quotaUser))
  add(query_589456, "alt", newJString(alt))
  add(query_589456, "oauth_token", newJString(oauthToken))
  add(query_589456, "userIp", newJString(userIp))
  add(query_589456, "key", newJString(key))
  if body != nil:
    body_589457 = body
  add(query_589456, "prettyPrint", newJBool(prettyPrint))
  result = call_589455.call(nil, query_589456, nil, nil, body_589457)

var gamesPushtokensUpdate* = Call_GamesPushtokensUpdate_589443(
    name: "gamesPushtokensUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/pushtokens",
    validator: validate_GamesPushtokensUpdate_589444, base: "/games/v1",
    url: url_GamesPushtokensUpdate_589445, schemes: {Scheme.Https})
type
  Call_GamesPushtokensRemove_589458 = ref object of OpenApiRestCall_588466
proc url_GamesPushtokensRemove_589460(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesPushtokensRemove_589459(path: JsonNode; query: JsonNode;
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
  var valid_589461 = query.getOrDefault("fields")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "fields", valid_589461
  var valid_589462 = query.getOrDefault("quotaUser")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "quotaUser", valid_589462
  var valid_589463 = query.getOrDefault("alt")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = newJString("json"))
  if valid_589463 != nil:
    section.add "alt", valid_589463
  var valid_589464 = query.getOrDefault("oauth_token")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "oauth_token", valid_589464
  var valid_589465 = query.getOrDefault("userIp")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "userIp", valid_589465
  var valid_589466 = query.getOrDefault("key")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "key", valid_589466
  var valid_589467 = query.getOrDefault("prettyPrint")
  valid_589467 = validateParameter(valid_589467, JBool, required = false,
                                 default = newJBool(true))
  if valid_589467 != nil:
    section.add "prettyPrint", valid_589467
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

proc call*(call_589469: Call_GamesPushtokensRemove_589458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a push token for the current user and application. Removing a non-existent push token will report success.
  ## 
  let valid = call_589469.validator(path, query, header, formData, body)
  let scheme = call_589469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589469.url(scheme.get, call_589469.host, call_589469.base,
                         call_589469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589469, url, valid)

proc call*(call_589470: Call_GamesPushtokensRemove_589458; fields: string = "";
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
  var query_589471 = newJObject()
  var body_589472 = newJObject()
  add(query_589471, "fields", newJString(fields))
  add(query_589471, "quotaUser", newJString(quotaUser))
  add(query_589471, "alt", newJString(alt))
  add(query_589471, "oauth_token", newJString(oauthToken))
  add(query_589471, "userIp", newJString(userIp))
  add(query_589471, "key", newJString(key))
  if body != nil:
    body_589472 = body
  add(query_589471, "prettyPrint", newJBool(prettyPrint))
  result = call_589470.call(nil, query_589471, nil, nil, body_589472)

var gamesPushtokensRemove* = Call_GamesPushtokensRemove_589458(
    name: "gamesPushtokensRemove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pushtokens/remove",
    validator: validate_GamesPushtokensRemove_589459, base: "/games/v1",
    url: url_GamesPushtokensRemove_589460, schemes: {Scheme.Https})
type
  Call_GamesQuestsAccept_589473 = ref object of OpenApiRestCall_588466
proc url_GamesQuestsAccept_589475(protocol: Scheme; host: string; base: string;
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

proc validate_GamesQuestsAccept_589474(path: JsonNode; query: JsonNode;
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
  var valid_589476 = path.getOrDefault("questId")
  valid_589476 = validateParameter(valid_589476, JString, required = true,
                                 default = nil)
  if valid_589476 != nil:
    section.add "questId", valid_589476
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
  var valid_589477 = query.getOrDefault("fields")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "fields", valid_589477
  var valid_589478 = query.getOrDefault("quotaUser")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "quotaUser", valid_589478
  var valid_589479 = query.getOrDefault("alt")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = newJString("json"))
  if valid_589479 != nil:
    section.add "alt", valid_589479
  var valid_589480 = query.getOrDefault("language")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = nil)
  if valid_589480 != nil:
    section.add "language", valid_589480
  var valid_589481 = query.getOrDefault("oauth_token")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "oauth_token", valid_589481
  var valid_589482 = query.getOrDefault("userIp")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "userIp", valid_589482
  var valid_589483 = query.getOrDefault("key")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "key", valid_589483
  var valid_589484 = query.getOrDefault("prettyPrint")
  valid_589484 = validateParameter(valid_589484, JBool, required = false,
                                 default = newJBool(true))
  if valid_589484 != nil:
    section.add "prettyPrint", valid_589484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589485: Call_GamesQuestsAccept_589473; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates that the currently authorized user will participate in the quest.
  ## 
  let valid = call_589485.validator(path, query, header, formData, body)
  let scheme = call_589485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589485.url(scheme.get, call_589485.host, call_589485.base,
                         call_589485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589485, url, valid)

proc call*(call_589486: Call_GamesQuestsAccept_589473; questId: string;
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
  var path_589487 = newJObject()
  var query_589488 = newJObject()
  add(query_589488, "fields", newJString(fields))
  add(query_589488, "quotaUser", newJString(quotaUser))
  add(query_589488, "alt", newJString(alt))
  add(query_589488, "language", newJString(language))
  add(query_589488, "oauth_token", newJString(oauthToken))
  add(query_589488, "userIp", newJString(userIp))
  add(query_589488, "key", newJString(key))
  add(path_589487, "questId", newJString(questId))
  add(query_589488, "prettyPrint", newJBool(prettyPrint))
  result = call_589486.call(path_589487, query_589488, nil, nil, nil)

var gamesQuestsAccept* = Call_GamesQuestsAccept_589473(name: "gamesQuestsAccept",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/quests/{questId}/accept", validator: validate_GamesQuestsAccept_589474,
    base: "/games/v1", url: url_GamesQuestsAccept_589475, schemes: {Scheme.Https})
type
  Call_GamesQuestMilestonesClaim_589489 = ref object of OpenApiRestCall_588466
proc url_GamesQuestMilestonesClaim_589491(protocol: Scheme; host: string;
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

proc validate_GamesQuestMilestonesClaim_589490(path: JsonNode; query: JsonNode;
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
  var valid_589492 = path.getOrDefault("milestoneId")
  valid_589492 = validateParameter(valid_589492, JString, required = true,
                                 default = nil)
  if valid_589492 != nil:
    section.add "milestoneId", valid_589492
  var valid_589493 = path.getOrDefault("questId")
  valid_589493 = validateParameter(valid_589493, JString, required = true,
                                 default = nil)
  if valid_589493 != nil:
    section.add "questId", valid_589493
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
  var valid_589494 = query.getOrDefault("fields")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "fields", valid_589494
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_589495 = query.getOrDefault("requestId")
  valid_589495 = validateParameter(valid_589495, JString, required = true,
                                 default = nil)
  if valid_589495 != nil:
    section.add "requestId", valid_589495
  var valid_589496 = query.getOrDefault("quotaUser")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "quotaUser", valid_589496
  var valid_589497 = query.getOrDefault("alt")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = newJString("json"))
  if valid_589497 != nil:
    section.add "alt", valid_589497
  var valid_589498 = query.getOrDefault("oauth_token")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "oauth_token", valid_589498
  var valid_589499 = query.getOrDefault("userIp")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "userIp", valid_589499
  var valid_589500 = query.getOrDefault("key")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "key", valid_589500
  var valid_589501 = query.getOrDefault("prettyPrint")
  valid_589501 = validateParameter(valid_589501, JBool, required = false,
                                 default = newJBool(true))
  if valid_589501 != nil:
    section.add "prettyPrint", valid_589501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589502: Call_GamesQuestMilestonesClaim_589489; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report that a reward for the milestone corresponding to milestoneId for the quest corresponding to questId has been claimed by the currently authorized user.
  ## 
  let valid = call_589502.validator(path, query, header, formData, body)
  let scheme = call_589502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589502.url(scheme.get, call_589502.host, call_589502.base,
                         call_589502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589502, url, valid)

proc call*(call_589503: Call_GamesQuestMilestonesClaim_589489; requestId: string;
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
  var path_589504 = newJObject()
  var query_589505 = newJObject()
  add(query_589505, "fields", newJString(fields))
  add(query_589505, "requestId", newJString(requestId))
  add(query_589505, "quotaUser", newJString(quotaUser))
  add(query_589505, "alt", newJString(alt))
  add(query_589505, "oauth_token", newJString(oauthToken))
  add(query_589505, "userIp", newJString(userIp))
  add(query_589505, "key", newJString(key))
  add(path_589504, "milestoneId", newJString(milestoneId))
  add(path_589504, "questId", newJString(questId))
  add(query_589505, "prettyPrint", newJBool(prettyPrint))
  result = call_589503.call(path_589504, query_589505, nil, nil, nil)

var gamesQuestMilestonesClaim* = Call_GamesQuestMilestonesClaim_589489(
    name: "gamesQuestMilestonesClaim", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/quests/{questId}/milestones/{milestoneId}/claim",
    validator: validate_GamesQuestMilestonesClaim_589490, base: "/games/v1",
    url: url_GamesQuestMilestonesClaim_589491, schemes: {Scheme.Https})
type
  Call_GamesRevisionsCheck_589506 = ref object of OpenApiRestCall_588466
proc url_GamesRevisionsCheck_589508(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesRevisionsCheck_589507(path: JsonNode; query: JsonNode;
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
  var valid_589509 = query.getOrDefault("fields")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = nil)
  if valid_589509 != nil:
    section.add "fields", valid_589509
  var valid_589510 = query.getOrDefault("quotaUser")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "quotaUser", valid_589510
  var valid_589511 = query.getOrDefault("alt")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = newJString("json"))
  if valid_589511 != nil:
    section.add "alt", valid_589511
  var valid_589512 = query.getOrDefault("oauth_token")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "oauth_token", valid_589512
  var valid_589513 = query.getOrDefault("userIp")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "userIp", valid_589513
  var valid_589514 = query.getOrDefault("key")
  valid_589514 = validateParameter(valid_589514, JString, required = false,
                                 default = nil)
  if valid_589514 != nil:
    section.add "key", valid_589514
  assert query != nil,
        "query argument is necessary due to required `clientRevision` field"
  var valid_589515 = query.getOrDefault("clientRevision")
  valid_589515 = validateParameter(valid_589515, JString, required = true,
                                 default = nil)
  if valid_589515 != nil:
    section.add "clientRevision", valid_589515
  var valid_589516 = query.getOrDefault("prettyPrint")
  valid_589516 = validateParameter(valid_589516, JBool, required = false,
                                 default = newJBool(true))
  if valid_589516 != nil:
    section.add "prettyPrint", valid_589516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589517: Call_GamesRevisionsCheck_589506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the games client is out of date.
  ## 
  let valid = call_589517.validator(path, query, header, formData, body)
  let scheme = call_589517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589517.url(scheme.get, call_589517.host, call_589517.base,
                         call_589517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589517, url, valid)

proc call*(call_589518: Call_GamesRevisionsCheck_589506; clientRevision: string;
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
  var query_589519 = newJObject()
  add(query_589519, "fields", newJString(fields))
  add(query_589519, "quotaUser", newJString(quotaUser))
  add(query_589519, "alt", newJString(alt))
  add(query_589519, "oauth_token", newJString(oauthToken))
  add(query_589519, "userIp", newJString(userIp))
  add(query_589519, "key", newJString(key))
  add(query_589519, "clientRevision", newJString(clientRevision))
  add(query_589519, "prettyPrint", newJBool(prettyPrint))
  result = call_589518.call(nil, query_589519, nil, nil, nil)

var gamesRevisionsCheck* = Call_GamesRevisionsCheck_589506(
    name: "gamesRevisionsCheck", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/revisions/check",
    validator: validate_GamesRevisionsCheck_589507, base: "/games/v1",
    url: url_GamesRevisionsCheck_589508, schemes: {Scheme.Https})
type
  Call_GamesRoomsList_589520 = ref object of OpenApiRestCall_588466
proc url_GamesRoomsList_589522(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesRoomsList_589521(path: JsonNode; query: JsonNode;
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
  var valid_589523 = query.getOrDefault("fields")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "fields", valid_589523
  var valid_589524 = query.getOrDefault("pageToken")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "pageToken", valid_589524
  var valid_589525 = query.getOrDefault("quotaUser")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "quotaUser", valid_589525
  var valid_589526 = query.getOrDefault("alt")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = newJString("json"))
  if valid_589526 != nil:
    section.add "alt", valid_589526
  var valid_589527 = query.getOrDefault("language")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "language", valid_589527
  var valid_589528 = query.getOrDefault("oauth_token")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "oauth_token", valid_589528
  var valid_589529 = query.getOrDefault("userIp")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = nil)
  if valid_589529 != nil:
    section.add "userIp", valid_589529
  var valid_589530 = query.getOrDefault("maxResults")
  valid_589530 = validateParameter(valid_589530, JInt, required = false, default = nil)
  if valid_589530 != nil:
    section.add "maxResults", valid_589530
  var valid_589531 = query.getOrDefault("key")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "key", valid_589531
  var valid_589532 = query.getOrDefault("prettyPrint")
  valid_589532 = validateParameter(valid_589532, JBool, required = false,
                                 default = newJBool(true))
  if valid_589532 != nil:
    section.add "prettyPrint", valid_589532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589533: Call_GamesRoomsList_589520; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns invitations to join rooms.
  ## 
  let valid = call_589533.validator(path, query, header, formData, body)
  let scheme = call_589533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589533.url(scheme.get, call_589533.host, call_589533.base,
                         call_589533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589533, url, valid)

proc call*(call_589534: Call_GamesRoomsList_589520; fields: string = "";
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
  var query_589535 = newJObject()
  add(query_589535, "fields", newJString(fields))
  add(query_589535, "pageToken", newJString(pageToken))
  add(query_589535, "quotaUser", newJString(quotaUser))
  add(query_589535, "alt", newJString(alt))
  add(query_589535, "language", newJString(language))
  add(query_589535, "oauth_token", newJString(oauthToken))
  add(query_589535, "userIp", newJString(userIp))
  add(query_589535, "maxResults", newJInt(maxResults))
  add(query_589535, "key", newJString(key))
  add(query_589535, "prettyPrint", newJBool(prettyPrint))
  result = call_589534.call(nil, query_589535, nil, nil, nil)

var gamesRoomsList* = Call_GamesRoomsList_589520(name: "gamesRoomsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/rooms",
    validator: validate_GamesRoomsList_589521, base: "/games/v1",
    url: url_GamesRoomsList_589522, schemes: {Scheme.Https})
type
  Call_GamesRoomsCreate_589536 = ref object of OpenApiRestCall_588466
proc url_GamesRoomsCreate_589538(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesRoomsCreate_589537(path: JsonNode; query: JsonNode;
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
  var valid_589539 = query.getOrDefault("fields")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "fields", valid_589539
  var valid_589540 = query.getOrDefault("quotaUser")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "quotaUser", valid_589540
  var valid_589541 = query.getOrDefault("alt")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = newJString("json"))
  if valid_589541 != nil:
    section.add "alt", valid_589541
  var valid_589542 = query.getOrDefault("language")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "language", valid_589542
  var valid_589543 = query.getOrDefault("oauth_token")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "oauth_token", valid_589543
  var valid_589544 = query.getOrDefault("userIp")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "userIp", valid_589544
  var valid_589545 = query.getOrDefault("key")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "key", valid_589545
  var valid_589546 = query.getOrDefault("prettyPrint")
  valid_589546 = validateParameter(valid_589546, JBool, required = false,
                                 default = newJBool(true))
  if valid_589546 != nil:
    section.add "prettyPrint", valid_589546
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

proc call*(call_589548: Call_GamesRoomsCreate_589536; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_589548.validator(path, query, header, formData, body)
  let scheme = call_589548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589548.url(scheme.get, call_589548.host, call_589548.base,
                         call_589548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589548, url, valid)

proc call*(call_589549: Call_GamesRoomsCreate_589536; fields: string = "";
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
  var query_589550 = newJObject()
  var body_589551 = newJObject()
  add(query_589550, "fields", newJString(fields))
  add(query_589550, "quotaUser", newJString(quotaUser))
  add(query_589550, "alt", newJString(alt))
  add(query_589550, "language", newJString(language))
  add(query_589550, "oauth_token", newJString(oauthToken))
  add(query_589550, "userIp", newJString(userIp))
  add(query_589550, "key", newJString(key))
  if body != nil:
    body_589551 = body
  add(query_589550, "prettyPrint", newJBool(prettyPrint))
  result = call_589549.call(nil, query_589550, nil, nil, body_589551)

var gamesRoomsCreate* = Call_GamesRoomsCreate_589536(name: "gamesRoomsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/rooms/create",
    validator: validate_GamesRoomsCreate_589537, base: "/games/v1",
    url: url_GamesRoomsCreate_589538, schemes: {Scheme.Https})
type
  Call_GamesRoomsGet_589552 = ref object of OpenApiRestCall_588466
proc url_GamesRoomsGet_589554(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsGet_589553(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_589555 = path.getOrDefault("roomId")
  valid_589555 = validateParameter(valid_589555, JString, required = true,
                                 default = nil)
  if valid_589555 != nil:
    section.add "roomId", valid_589555
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
  var valid_589556 = query.getOrDefault("fields")
  valid_589556 = validateParameter(valid_589556, JString, required = false,
                                 default = nil)
  if valid_589556 != nil:
    section.add "fields", valid_589556
  var valid_589557 = query.getOrDefault("quotaUser")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "quotaUser", valid_589557
  var valid_589558 = query.getOrDefault("alt")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = newJString("json"))
  if valid_589558 != nil:
    section.add "alt", valid_589558
  var valid_589559 = query.getOrDefault("language")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "language", valid_589559
  var valid_589560 = query.getOrDefault("oauth_token")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "oauth_token", valid_589560
  var valid_589561 = query.getOrDefault("userIp")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "userIp", valid_589561
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589564: Call_GamesRoomsGet_589552; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the data for a room.
  ## 
  let valid = call_589564.validator(path, query, header, formData, body)
  let scheme = call_589564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589564.url(scheme.get, call_589564.host, call_589564.base,
                         call_589564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589564, url, valid)

proc call*(call_589565: Call_GamesRoomsGet_589552; roomId: string;
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
  var path_589566 = newJObject()
  var query_589567 = newJObject()
  add(query_589567, "fields", newJString(fields))
  add(query_589567, "quotaUser", newJString(quotaUser))
  add(query_589567, "alt", newJString(alt))
  add(query_589567, "language", newJString(language))
  add(query_589567, "oauth_token", newJString(oauthToken))
  add(query_589567, "userIp", newJString(userIp))
  add(query_589567, "key", newJString(key))
  add(query_589567, "prettyPrint", newJBool(prettyPrint))
  add(path_589566, "roomId", newJString(roomId))
  result = call_589565.call(path_589566, query_589567, nil, nil, nil)

var gamesRoomsGet* = Call_GamesRoomsGet_589552(name: "gamesRoomsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/rooms/{roomId}",
    validator: validate_GamesRoomsGet_589553, base: "/games/v1",
    url: url_GamesRoomsGet_589554, schemes: {Scheme.Https})
type
  Call_GamesRoomsDecline_589568 = ref object of OpenApiRestCall_588466
proc url_GamesRoomsDecline_589570(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsDecline_589569(path: JsonNode; query: JsonNode;
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
  var valid_589571 = path.getOrDefault("roomId")
  valid_589571 = validateParameter(valid_589571, JString, required = true,
                                 default = nil)
  if valid_589571 != nil:
    section.add "roomId", valid_589571
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
  var valid_589572 = query.getOrDefault("fields")
  valid_589572 = validateParameter(valid_589572, JString, required = false,
                                 default = nil)
  if valid_589572 != nil:
    section.add "fields", valid_589572
  var valid_589573 = query.getOrDefault("quotaUser")
  valid_589573 = validateParameter(valid_589573, JString, required = false,
                                 default = nil)
  if valid_589573 != nil:
    section.add "quotaUser", valid_589573
  var valid_589574 = query.getOrDefault("alt")
  valid_589574 = validateParameter(valid_589574, JString, required = false,
                                 default = newJString("json"))
  if valid_589574 != nil:
    section.add "alt", valid_589574
  var valid_589575 = query.getOrDefault("language")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = nil)
  if valid_589575 != nil:
    section.add "language", valid_589575
  var valid_589576 = query.getOrDefault("oauth_token")
  valid_589576 = validateParameter(valid_589576, JString, required = false,
                                 default = nil)
  if valid_589576 != nil:
    section.add "oauth_token", valid_589576
  var valid_589577 = query.getOrDefault("userIp")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "userIp", valid_589577
  var valid_589578 = query.getOrDefault("key")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "key", valid_589578
  var valid_589579 = query.getOrDefault("prettyPrint")
  valid_589579 = validateParameter(valid_589579, JBool, required = false,
                                 default = newJBool(true))
  if valid_589579 != nil:
    section.add "prettyPrint", valid_589579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589580: Call_GamesRoomsDecline_589568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decline an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_589580.validator(path, query, header, formData, body)
  let scheme = call_589580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589580.url(scheme.get, call_589580.host, call_589580.base,
                         call_589580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589580, url, valid)

proc call*(call_589581: Call_GamesRoomsDecline_589568; roomId: string;
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
  var path_589582 = newJObject()
  var query_589583 = newJObject()
  add(query_589583, "fields", newJString(fields))
  add(query_589583, "quotaUser", newJString(quotaUser))
  add(query_589583, "alt", newJString(alt))
  add(query_589583, "language", newJString(language))
  add(query_589583, "oauth_token", newJString(oauthToken))
  add(query_589583, "userIp", newJString(userIp))
  add(query_589583, "key", newJString(key))
  add(query_589583, "prettyPrint", newJBool(prettyPrint))
  add(path_589582, "roomId", newJString(roomId))
  result = call_589581.call(path_589582, query_589583, nil, nil, nil)

var gamesRoomsDecline* = Call_GamesRoomsDecline_589568(name: "gamesRoomsDecline",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/decline", validator: validate_GamesRoomsDecline_589569,
    base: "/games/v1", url: url_GamesRoomsDecline_589570, schemes: {Scheme.Https})
type
  Call_GamesRoomsDismiss_589584 = ref object of OpenApiRestCall_588466
proc url_GamesRoomsDismiss_589586(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsDismiss_589585(path: JsonNode; query: JsonNode;
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
  var valid_589587 = path.getOrDefault("roomId")
  valid_589587 = validateParameter(valid_589587, JString, required = true,
                                 default = nil)
  if valid_589587 != nil:
    section.add "roomId", valid_589587
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
  var valid_589588 = query.getOrDefault("fields")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = nil)
  if valid_589588 != nil:
    section.add "fields", valid_589588
  var valid_589589 = query.getOrDefault("quotaUser")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = nil)
  if valid_589589 != nil:
    section.add "quotaUser", valid_589589
  var valid_589590 = query.getOrDefault("alt")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = newJString("json"))
  if valid_589590 != nil:
    section.add "alt", valid_589590
  var valid_589591 = query.getOrDefault("oauth_token")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = nil)
  if valid_589591 != nil:
    section.add "oauth_token", valid_589591
  var valid_589592 = query.getOrDefault("userIp")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = nil)
  if valid_589592 != nil:
    section.add "userIp", valid_589592
  var valid_589593 = query.getOrDefault("key")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = nil)
  if valid_589593 != nil:
    section.add "key", valid_589593
  var valid_589594 = query.getOrDefault("prettyPrint")
  valid_589594 = validateParameter(valid_589594, JBool, required = false,
                                 default = newJBool(true))
  if valid_589594 != nil:
    section.add "prettyPrint", valid_589594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589595: Call_GamesRoomsDismiss_589584; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_589595.validator(path, query, header, formData, body)
  let scheme = call_589595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589595.url(scheme.get, call_589595.host, call_589595.base,
                         call_589595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589595, url, valid)

proc call*(call_589596: Call_GamesRoomsDismiss_589584; roomId: string;
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
  var path_589597 = newJObject()
  var query_589598 = newJObject()
  add(query_589598, "fields", newJString(fields))
  add(query_589598, "quotaUser", newJString(quotaUser))
  add(query_589598, "alt", newJString(alt))
  add(query_589598, "oauth_token", newJString(oauthToken))
  add(query_589598, "userIp", newJString(userIp))
  add(query_589598, "key", newJString(key))
  add(query_589598, "prettyPrint", newJBool(prettyPrint))
  add(path_589597, "roomId", newJString(roomId))
  result = call_589596.call(path_589597, query_589598, nil, nil, nil)

var gamesRoomsDismiss* = Call_GamesRoomsDismiss_589584(name: "gamesRoomsDismiss",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/dismiss", validator: validate_GamesRoomsDismiss_589585,
    base: "/games/v1", url: url_GamesRoomsDismiss_589586, schemes: {Scheme.Https})
type
  Call_GamesRoomsJoin_589599 = ref object of OpenApiRestCall_588466
proc url_GamesRoomsJoin_589601(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsJoin_589600(path: JsonNode; query: JsonNode;
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
  var valid_589602 = path.getOrDefault("roomId")
  valid_589602 = validateParameter(valid_589602, JString, required = true,
                                 default = nil)
  if valid_589602 != nil:
    section.add "roomId", valid_589602
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
  var valid_589603 = query.getOrDefault("fields")
  valid_589603 = validateParameter(valid_589603, JString, required = false,
                                 default = nil)
  if valid_589603 != nil:
    section.add "fields", valid_589603
  var valid_589604 = query.getOrDefault("quotaUser")
  valid_589604 = validateParameter(valid_589604, JString, required = false,
                                 default = nil)
  if valid_589604 != nil:
    section.add "quotaUser", valid_589604
  var valid_589605 = query.getOrDefault("alt")
  valid_589605 = validateParameter(valid_589605, JString, required = false,
                                 default = newJString("json"))
  if valid_589605 != nil:
    section.add "alt", valid_589605
  var valid_589606 = query.getOrDefault("language")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "language", valid_589606
  var valid_589607 = query.getOrDefault("oauth_token")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "oauth_token", valid_589607
  var valid_589608 = query.getOrDefault("userIp")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = nil)
  if valid_589608 != nil:
    section.add "userIp", valid_589608
  var valid_589609 = query.getOrDefault("key")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = nil)
  if valid_589609 != nil:
    section.add "key", valid_589609
  var valid_589610 = query.getOrDefault("prettyPrint")
  valid_589610 = validateParameter(valid_589610, JBool, required = false,
                                 default = newJBool(true))
  if valid_589610 != nil:
    section.add "prettyPrint", valid_589610
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

proc call*(call_589612: Call_GamesRoomsJoin_589599; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_589612.validator(path, query, header, formData, body)
  let scheme = call_589612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589612.url(scheme.get, call_589612.host, call_589612.base,
                         call_589612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589612, url, valid)

proc call*(call_589613: Call_GamesRoomsJoin_589599; roomId: string;
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
  var path_589614 = newJObject()
  var query_589615 = newJObject()
  var body_589616 = newJObject()
  add(query_589615, "fields", newJString(fields))
  add(query_589615, "quotaUser", newJString(quotaUser))
  add(query_589615, "alt", newJString(alt))
  add(query_589615, "language", newJString(language))
  add(query_589615, "oauth_token", newJString(oauthToken))
  add(query_589615, "userIp", newJString(userIp))
  add(query_589615, "key", newJString(key))
  if body != nil:
    body_589616 = body
  add(query_589615, "prettyPrint", newJBool(prettyPrint))
  add(path_589614, "roomId", newJString(roomId))
  result = call_589613.call(path_589614, query_589615, nil, nil, body_589616)

var gamesRoomsJoin* = Call_GamesRoomsJoin_589599(name: "gamesRoomsJoin",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/join", validator: validate_GamesRoomsJoin_589600,
    base: "/games/v1", url: url_GamesRoomsJoin_589601, schemes: {Scheme.Https})
type
  Call_GamesRoomsLeave_589617 = ref object of OpenApiRestCall_588466
proc url_GamesRoomsLeave_589619(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsLeave_589618(path: JsonNode; query: JsonNode;
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
  var valid_589620 = path.getOrDefault("roomId")
  valid_589620 = validateParameter(valid_589620, JString, required = true,
                                 default = nil)
  if valid_589620 != nil:
    section.add "roomId", valid_589620
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
  var valid_589621 = query.getOrDefault("fields")
  valid_589621 = validateParameter(valid_589621, JString, required = false,
                                 default = nil)
  if valid_589621 != nil:
    section.add "fields", valid_589621
  var valid_589622 = query.getOrDefault("quotaUser")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = nil)
  if valid_589622 != nil:
    section.add "quotaUser", valid_589622
  var valid_589623 = query.getOrDefault("alt")
  valid_589623 = validateParameter(valid_589623, JString, required = false,
                                 default = newJString("json"))
  if valid_589623 != nil:
    section.add "alt", valid_589623
  var valid_589624 = query.getOrDefault("language")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = nil)
  if valid_589624 != nil:
    section.add "language", valid_589624
  var valid_589625 = query.getOrDefault("oauth_token")
  valid_589625 = validateParameter(valid_589625, JString, required = false,
                                 default = nil)
  if valid_589625 != nil:
    section.add "oauth_token", valid_589625
  var valid_589626 = query.getOrDefault("userIp")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "userIp", valid_589626
  var valid_589627 = query.getOrDefault("key")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = nil)
  if valid_589627 != nil:
    section.add "key", valid_589627
  var valid_589628 = query.getOrDefault("prettyPrint")
  valid_589628 = validateParameter(valid_589628, JBool, required = false,
                                 default = newJBool(true))
  if valid_589628 != nil:
    section.add "prettyPrint", valid_589628
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

proc call*(call_589630: Call_GamesRoomsLeave_589617; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_589630.validator(path, query, header, formData, body)
  let scheme = call_589630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589630.url(scheme.get, call_589630.host, call_589630.base,
                         call_589630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589630, url, valid)

proc call*(call_589631: Call_GamesRoomsLeave_589617; roomId: string;
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
  var path_589632 = newJObject()
  var query_589633 = newJObject()
  var body_589634 = newJObject()
  add(query_589633, "fields", newJString(fields))
  add(query_589633, "quotaUser", newJString(quotaUser))
  add(query_589633, "alt", newJString(alt))
  add(query_589633, "language", newJString(language))
  add(query_589633, "oauth_token", newJString(oauthToken))
  add(query_589633, "userIp", newJString(userIp))
  add(query_589633, "key", newJString(key))
  if body != nil:
    body_589634 = body
  add(query_589633, "prettyPrint", newJBool(prettyPrint))
  add(path_589632, "roomId", newJString(roomId))
  result = call_589631.call(path_589632, query_589633, nil, nil, body_589634)

var gamesRoomsLeave* = Call_GamesRoomsLeave_589617(name: "gamesRoomsLeave",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/leave", validator: validate_GamesRoomsLeave_589618,
    base: "/games/v1", url: url_GamesRoomsLeave_589619, schemes: {Scheme.Https})
type
  Call_GamesRoomsReportStatus_589635 = ref object of OpenApiRestCall_588466
proc url_GamesRoomsReportStatus_589637(protocol: Scheme; host: string; base: string;
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

proc validate_GamesRoomsReportStatus_589636(path: JsonNode; query: JsonNode;
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
  var valid_589638 = path.getOrDefault("roomId")
  valid_589638 = validateParameter(valid_589638, JString, required = true,
                                 default = nil)
  if valid_589638 != nil:
    section.add "roomId", valid_589638
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
  var valid_589639 = query.getOrDefault("fields")
  valid_589639 = validateParameter(valid_589639, JString, required = false,
                                 default = nil)
  if valid_589639 != nil:
    section.add "fields", valid_589639
  var valid_589640 = query.getOrDefault("quotaUser")
  valid_589640 = validateParameter(valid_589640, JString, required = false,
                                 default = nil)
  if valid_589640 != nil:
    section.add "quotaUser", valid_589640
  var valid_589641 = query.getOrDefault("alt")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = newJString("json"))
  if valid_589641 != nil:
    section.add "alt", valid_589641
  var valid_589642 = query.getOrDefault("language")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = nil)
  if valid_589642 != nil:
    section.add "language", valid_589642
  var valid_589643 = query.getOrDefault("oauth_token")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "oauth_token", valid_589643
  var valid_589644 = query.getOrDefault("userIp")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "userIp", valid_589644
  var valid_589645 = query.getOrDefault("key")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = nil)
  if valid_589645 != nil:
    section.add "key", valid_589645
  var valid_589646 = query.getOrDefault("prettyPrint")
  valid_589646 = validateParameter(valid_589646, JBool, required = false,
                                 default = newJBool(true))
  if valid_589646 != nil:
    section.add "prettyPrint", valid_589646
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

proc call*(call_589648: Call_GamesRoomsReportStatus_589635; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates sent by a client reporting the status of peers in a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_589648.validator(path, query, header, formData, body)
  let scheme = call_589648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589648.url(scheme.get, call_589648.host, call_589648.base,
                         call_589648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589648, url, valid)

proc call*(call_589649: Call_GamesRoomsReportStatus_589635; roomId: string;
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
  var path_589650 = newJObject()
  var query_589651 = newJObject()
  var body_589652 = newJObject()
  add(query_589651, "fields", newJString(fields))
  add(query_589651, "quotaUser", newJString(quotaUser))
  add(query_589651, "alt", newJString(alt))
  add(query_589651, "language", newJString(language))
  add(query_589651, "oauth_token", newJString(oauthToken))
  add(query_589651, "userIp", newJString(userIp))
  add(query_589651, "key", newJString(key))
  if body != nil:
    body_589652 = body
  add(query_589651, "prettyPrint", newJBool(prettyPrint))
  add(path_589650, "roomId", newJString(roomId))
  result = call_589649.call(path_589650, query_589651, nil, nil, body_589652)

var gamesRoomsReportStatus* = Call_GamesRoomsReportStatus_589635(
    name: "gamesRoomsReportStatus", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/{roomId}/reportstatus",
    validator: validate_GamesRoomsReportStatus_589636, base: "/games/v1",
    url: url_GamesRoomsReportStatus_589637, schemes: {Scheme.Https})
type
  Call_GamesSnapshotsGet_589653 = ref object of OpenApiRestCall_588466
proc url_GamesSnapshotsGet_589655(protocol: Scheme; host: string; base: string;
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

proc validate_GamesSnapshotsGet_589654(path: JsonNode; query: JsonNode;
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
  var valid_589656 = path.getOrDefault("snapshotId")
  valid_589656 = validateParameter(valid_589656, JString, required = true,
                                 default = nil)
  if valid_589656 != nil:
    section.add "snapshotId", valid_589656
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
  var valid_589657 = query.getOrDefault("fields")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "fields", valid_589657
  var valid_589658 = query.getOrDefault("quotaUser")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = nil)
  if valid_589658 != nil:
    section.add "quotaUser", valid_589658
  var valid_589659 = query.getOrDefault("alt")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = newJString("json"))
  if valid_589659 != nil:
    section.add "alt", valid_589659
  var valid_589660 = query.getOrDefault("language")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = nil)
  if valid_589660 != nil:
    section.add "language", valid_589660
  var valid_589661 = query.getOrDefault("oauth_token")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = nil)
  if valid_589661 != nil:
    section.add "oauth_token", valid_589661
  var valid_589662 = query.getOrDefault("userIp")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "userIp", valid_589662
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
  if body != nil:
    result.add "body", body

proc call*(call_589665: Call_GamesSnapshotsGet_589653; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata for a given snapshot ID.
  ## 
  let valid = call_589665.validator(path, query, header, formData, body)
  let scheme = call_589665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589665.url(scheme.get, call_589665.host, call_589665.base,
                         call_589665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589665, url, valid)

proc call*(call_589666: Call_GamesSnapshotsGet_589653; snapshotId: string;
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
  var path_589667 = newJObject()
  var query_589668 = newJObject()
  add(query_589668, "fields", newJString(fields))
  add(query_589668, "quotaUser", newJString(quotaUser))
  add(query_589668, "alt", newJString(alt))
  add(query_589668, "language", newJString(language))
  add(path_589667, "snapshotId", newJString(snapshotId))
  add(query_589668, "oauth_token", newJString(oauthToken))
  add(query_589668, "userIp", newJString(userIp))
  add(query_589668, "key", newJString(key))
  add(query_589668, "prettyPrint", newJBool(prettyPrint))
  result = call_589666.call(path_589667, query_589668, nil, nil, nil)

var gamesSnapshotsGet* = Call_GamesSnapshotsGet_589653(name: "gamesSnapshotsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/snapshots/{snapshotId}", validator: validate_GamesSnapshotsGet_589654,
    base: "/games/v1", url: url_GamesSnapshotsGet_589655, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesList_589669 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesList_589671(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesList_589670(path: JsonNode; query: JsonNode;
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
  var valid_589672 = query.getOrDefault("fields")
  valid_589672 = validateParameter(valid_589672, JString, required = false,
                                 default = nil)
  if valid_589672 != nil:
    section.add "fields", valid_589672
  var valid_589673 = query.getOrDefault("pageToken")
  valid_589673 = validateParameter(valid_589673, JString, required = false,
                                 default = nil)
  if valid_589673 != nil:
    section.add "pageToken", valid_589673
  var valid_589674 = query.getOrDefault("quotaUser")
  valid_589674 = validateParameter(valid_589674, JString, required = false,
                                 default = nil)
  if valid_589674 != nil:
    section.add "quotaUser", valid_589674
  var valid_589675 = query.getOrDefault("alt")
  valid_589675 = validateParameter(valid_589675, JString, required = false,
                                 default = newJString("json"))
  if valid_589675 != nil:
    section.add "alt", valid_589675
  var valid_589676 = query.getOrDefault("language")
  valid_589676 = validateParameter(valid_589676, JString, required = false,
                                 default = nil)
  if valid_589676 != nil:
    section.add "language", valid_589676
  var valid_589677 = query.getOrDefault("includeMatchData")
  valid_589677 = validateParameter(valid_589677, JBool, required = false, default = nil)
  if valid_589677 != nil:
    section.add "includeMatchData", valid_589677
  var valid_589678 = query.getOrDefault("maxCompletedMatches")
  valid_589678 = validateParameter(valid_589678, JInt, required = false, default = nil)
  if valid_589678 != nil:
    section.add "maxCompletedMatches", valid_589678
  var valid_589679 = query.getOrDefault("oauth_token")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = nil)
  if valid_589679 != nil:
    section.add "oauth_token", valid_589679
  var valid_589680 = query.getOrDefault("userIp")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = nil)
  if valid_589680 != nil:
    section.add "userIp", valid_589680
  var valid_589681 = query.getOrDefault("maxResults")
  valid_589681 = validateParameter(valid_589681, JInt, required = false, default = nil)
  if valid_589681 != nil:
    section.add "maxResults", valid_589681
  var valid_589682 = query.getOrDefault("key")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = nil)
  if valid_589682 != nil:
    section.add "key", valid_589682
  var valid_589683 = query.getOrDefault("prettyPrint")
  valid_589683 = validateParameter(valid_589683, JBool, required = false,
                                 default = newJBool(true))
  if valid_589683 != nil:
    section.add "prettyPrint", valid_589683
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589684: Call_GamesTurnBasedMatchesList_589669; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns turn-based matches the player is or was involved in.
  ## 
  let valid = call_589684.validator(path, query, header, formData, body)
  let scheme = call_589684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589684.url(scheme.get, call_589684.host, call_589684.base,
                         call_589684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589684, url, valid)

proc call*(call_589685: Call_GamesTurnBasedMatchesList_589669; fields: string = "";
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
  var query_589686 = newJObject()
  add(query_589686, "fields", newJString(fields))
  add(query_589686, "pageToken", newJString(pageToken))
  add(query_589686, "quotaUser", newJString(quotaUser))
  add(query_589686, "alt", newJString(alt))
  add(query_589686, "language", newJString(language))
  add(query_589686, "includeMatchData", newJBool(includeMatchData))
  add(query_589686, "maxCompletedMatches", newJInt(maxCompletedMatches))
  add(query_589686, "oauth_token", newJString(oauthToken))
  add(query_589686, "userIp", newJString(userIp))
  add(query_589686, "maxResults", newJInt(maxResults))
  add(query_589686, "key", newJString(key))
  add(query_589686, "prettyPrint", newJBool(prettyPrint))
  result = call_589685.call(nil, query_589686, nil, nil, nil)

var gamesTurnBasedMatchesList* = Call_GamesTurnBasedMatchesList_589669(
    name: "gamesTurnBasedMatchesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches",
    validator: validate_GamesTurnBasedMatchesList_589670, base: "/games/v1",
    url: url_GamesTurnBasedMatchesList_589671, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesCreate_589687 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesCreate_589689(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesCreate_589688(path: JsonNode; query: JsonNode;
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
  var valid_589690 = query.getOrDefault("fields")
  valid_589690 = validateParameter(valid_589690, JString, required = false,
                                 default = nil)
  if valid_589690 != nil:
    section.add "fields", valid_589690
  var valid_589691 = query.getOrDefault("quotaUser")
  valid_589691 = validateParameter(valid_589691, JString, required = false,
                                 default = nil)
  if valid_589691 != nil:
    section.add "quotaUser", valid_589691
  var valid_589692 = query.getOrDefault("alt")
  valid_589692 = validateParameter(valid_589692, JString, required = false,
                                 default = newJString("json"))
  if valid_589692 != nil:
    section.add "alt", valid_589692
  var valid_589693 = query.getOrDefault("language")
  valid_589693 = validateParameter(valid_589693, JString, required = false,
                                 default = nil)
  if valid_589693 != nil:
    section.add "language", valid_589693
  var valid_589694 = query.getOrDefault("oauth_token")
  valid_589694 = validateParameter(valid_589694, JString, required = false,
                                 default = nil)
  if valid_589694 != nil:
    section.add "oauth_token", valid_589694
  var valid_589695 = query.getOrDefault("userIp")
  valid_589695 = validateParameter(valid_589695, JString, required = false,
                                 default = nil)
  if valid_589695 != nil:
    section.add "userIp", valid_589695
  var valid_589696 = query.getOrDefault("key")
  valid_589696 = validateParameter(valid_589696, JString, required = false,
                                 default = nil)
  if valid_589696 != nil:
    section.add "key", valid_589696
  var valid_589697 = query.getOrDefault("prettyPrint")
  valid_589697 = validateParameter(valid_589697, JBool, required = false,
                                 default = newJBool(true))
  if valid_589697 != nil:
    section.add "prettyPrint", valid_589697
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

proc call*(call_589699: Call_GamesTurnBasedMatchesCreate_589687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a turn-based match.
  ## 
  let valid = call_589699.validator(path, query, header, formData, body)
  let scheme = call_589699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589699.url(scheme.get, call_589699.host, call_589699.base,
                         call_589699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589699, url, valid)

proc call*(call_589700: Call_GamesTurnBasedMatchesCreate_589687;
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
  var query_589701 = newJObject()
  var body_589702 = newJObject()
  add(query_589701, "fields", newJString(fields))
  add(query_589701, "quotaUser", newJString(quotaUser))
  add(query_589701, "alt", newJString(alt))
  add(query_589701, "language", newJString(language))
  add(query_589701, "oauth_token", newJString(oauthToken))
  add(query_589701, "userIp", newJString(userIp))
  add(query_589701, "key", newJString(key))
  if body != nil:
    body_589702 = body
  add(query_589701, "prettyPrint", newJBool(prettyPrint))
  result = call_589700.call(nil, query_589701, nil, nil, body_589702)

var gamesTurnBasedMatchesCreate* = Call_GamesTurnBasedMatchesCreate_589687(
    name: "gamesTurnBasedMatchesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/create",
    validator: validate_GamesTurnBasedMatchesCreate_589688, base: "/games/v1",
    url: url_GamesTurnBasedMatchesCreate_589689, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesSync_589703 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesSync_589705(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesSync_589704(path: JsonNode; query: JsonNode;
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
  var valid_589706 = query.getOrDefault("fields")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = nil)
  if valid_589706 != nil:
    section.add "fields", valid_589706
  var valid_589707 = query.getOrDefault("pageToken")
  valid_589707 = validateParameter(valid_589707, JString, required = false,
                                 default = nil)
  if valid_589707 != nil:
    section.add "pageToken", valid_589707
  var valid_589708 = query.getOrDefault("quotaUser")
  valid_589708 = validateParameter(valid_589708, JString, required = false,
                                 default = nil)
  if valid_589708 != nil:
    section.add "quotaUser", valid_589708
  var valid_589709 = query.getOrDefault("alt")
  valid_589709 = validateParameter(valid_589709, JString, required = false,
                                 default = newJString("json"))
  if valid_589709 != nil:
    section.add "alt", valid_589709
  var valid_589710 = query.getOrDefault("language")
  valid_589710 = validateParameter(valid_589710, JString, required = false,
                                 default = nil)
  if valid_589710 != nil:
    section.add "language", valid_589710
  var valid_589711 = query.getOrDefault("includeMatchData")
  valid_589711 = validateParameter(valid_589711, JBool, required = false, default = nil)
  if valid_589711 != nil:
    section.add "includeMatchData", valid_589711
  var valid_589712 = query.getOrDefault("maxCompletedMatches")
  valid_589712 = validateParameter(valid_589712, JInt, required = false, default = nil)
  if valid_589712 != nil:
    section.add "maxCompletedMatches", valid_589712
  var valid_589713 = query.getOrDefault("oauth_token")
  valid_589713 = validateParameter(valid_589713, JString, required = false,
                                 default = nil)
  if valid_589713 != nil:
    section.add "oauth_token", valid_589713
  var valid_589714 = query.getOrDefault("userIp")
  valid_589714 = validateParameter(valid_589714, JString, required = false,
                                 default = nil)
  if valid_589714 != nil:
    section.add "userIp", valid_589714
  var valid_589715 = query.getOrDefault("maxResults")
  valid_589715 = validateParameter(valid_589715, JInt, required = false, default = nil)
  if valid_589715 != nil:
    section.add "maxResults", valid_589715
  var valid_589716 = query.getOrDefault("key")
  valid_589716 = validateParameter(valid_589716, JString, required = false,
                                 default = nil)
  if valid_589716 != nil:
    section.add "key", valid_589716
  var valid_589717 = query.getOrDefault("prettyPrint")
  valid_589717 = validateParameter(valid_589717, JBool, required = false,
                                 default = newJBool(true))
  if valid_589717 != nil:
    section.add "prettyPrint", valid_589717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589718: Call_GamesTurnBasedMatchesSync_589703; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns turn-based matches the player is or was involved in that changed since the last sync call, with the least recent changes coming first. Matches that should be removed from the local cache will have a status of MATCH_DELETED.
  ## 
  let valid = call_589718.validator(path, query, header, formData, body)
  let scheme = call_589718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589718.url(scheme.get, call_589718.host, call_589718.base,
                         call_589718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589718, url, valid)

proc call*(call_589719: Call_GamesTurnBasedMatchesSync_589703; fields: string = "";
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
  var query_589720 = newJObject()
  add(query_589720, "fields", newJString(fields))
  add(query_589720, "pageToken", newJString(pageToken))
  add(query_589720, "quotaUser", newJString(quotaUser))
  add(query_589720, "alt", newJString(alt))
  add(query_589720, "language", newJString(language))
  add(query_589720, "includeMatchData", newJBool(includeMatchData))
  add(query_589720, "maxCompletedMatches", newJInt(maxCompletedMatches))
  add(query_589720, "oauth_token", newJString(oauthToken))
  add(query_589720, "userIp", newJString(userIp))
  add(query_589720, "maxResults", newJInt(maxResults))
  add(query_589720, "key", newJString(key))
  add(query_589720, "prettyPrint", newJBool(prettyPrint))
  result = call_589719.call(nil, query_589720, nil, nil, nil)

var gamesTurnBasedMatchesSync* = Call_GamesTurnBasedMatchesSync_589703(
    name: "gamesTurnBasedMatchesSync", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches/sync",
    validator: validate_GamesTurnBasedMatchesSync_589704, base: "/games/v1",
    url: url_GamesTurnBasedMatchesSync_589705, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesGet_589721 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesGet_589723(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesGet_589722(path: JsonNode; query: JsonNode;
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
  var valid_589724 = path.getOrDefault("matchId")
  valid_589724 = validateParameter(valid_589724, JString, required = true,
                                 default = nil)
  if valid_589724 != nil:
    section.add "matchId", valid_589724
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
  var valid_589725 = query.getOrDefault("fields")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "fields", valid_589725
  var valid_589726 = query.getOrDefault("quotaUser")
  valid_589726 = validateParameter(valid_589726, JString, required = false,
                                 default = nil)
  if valid_589726 != nil:
    section.add "quotaUser", valid_589726
  var valid_589727 = query.getOrDefault("alt")
  valid_589727 = validateParameter(valid_589727, JString, required = false,
                                 default = newJString("json"))
  if valid_589727 != nil:
    section.add "alt", valid_589727
  var valid_589728 = query.getOrDefault("language")
  valid_589728 = validateParameter(valid_589728, JString, required = false,
                                 default = nil)
  if valid_589728 != nil:
    section.add "language", valid_589728
  var valid_589729 = query.getOrDefault("includeMatchData")
  valid_589729 = validateParameter(valid_589729, JBool, required = false, default = nil)
  if valid_589729 != nil:
    section.add "includeMatchData", valid_589729
  var valid_589730 = query.getOrDefault("oauth_token")
  valid_589730 = validateParameter(valid_589730, JString, required = false,
                                 default = nil)
  if valid_589730 != nil:
    section.add "oauth_token", valid_589730
  var valid_589731 = query.getOrDefault("userIp")
  valid_589731 = validateParameter(valid_589731, JString, required = false,
                                 default = nil)
  if valid_589731 != nil:
    section.add "userIp", valid_589731
  var valid_589732 = query.getOrDefault("key")
  valid_589732 = validateParameter(valid_589732, JString, required = false,
                                 default = nil)
  if valid_589732 != nil:
    section.add "key", valid_589732
  var valid_589733 = query.getOrDefault("prettyPrint")
  valid_589733 = validateParameter(valid_589733, JBool, required = false,
                                 default = newJBool(true))
  if valid_589733 != nil:
    section.add "prettyPrint", valid_589733
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589734: Call_GamesTurnBasedMatchesGet_589721; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the data for a turn-based match.
  ## 
  let valid = call_589734.validator(path, query, header, formData, body)
  let scheme = call_589734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589734.url(scheme.get, call_589734.host, call_589734.base,
                         call_589734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589734, url, valid)

proc call*(call_589735: Call_GamesTurnBasedMatchesGet_589721; matchId: string;
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
  var path_589736 = newJObject()
  var query_589737 = newJObject()
  add(query_589737, "fields", newJString(fields))
  add(query_589737, "quotaUser", newJString(quotaUser))
  add(query_589737, "alt", newJString(alt))
  add(query_589737, "language", newJString(language))
  add(query_589737, "includeMatchData", newJBool(includeMatchData))
  add(query_589737, "oauth_token", newJString(oauthToken))
  add(query_589737, "userIp", newJString(userIp))
  add(query_589737, "key", newJString(key))
  add(path_589736, "matchId", newJString(matchId))
  add(query_589737, "prettyPrint", newJBool(prettyPrint))
  result = call_589735.call(path_589736, query_589737, nil, nil, nil)

var gamesTurnBasedMatchesGet* = Call_GamesTurnBasedMatchesGet_589721(
    name: "gamesTurnBasedMatchesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}",
    validator: validate_GamesTurnBasedMatchesGet_589722, base: "/games/v1",
    url: url_GamesTurnBasedMatchesGet_589723, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesCancel_589738 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesCancel_589740(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesCancel_589739(path: JsonNode; query: JsonNode;
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
  var valid_589741 = path.getOrDefault("matchId")
  valid_589741 = validateParameter(valid_589741, JString, required = true,
                                 default = nil)
  if valid_589741 != nil:
    section.add "matchId", valid_589741
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
  var valid_589742 = query.getOrDefault("fields")
  valid_589742 = validateParameter(valid_589742, JString, required = false,
                                 default = nil)
  if valid_589742 != nil:
    section.add "fields", valid_589742
  var valid_589743 = query.getOrDefault("quotaUser")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = nil)
  if valid_589743 != nil:
    section.add "quotaUser", valid_589743
  var valid_589744 = query.getOrDefault("alt")
  valid_589744 = validateParameter(valid_589744, JString, required = false,
                                 default = newJString("json"))
  if valid_589744 != nil:
    section.add "alt", valid_589744
  var valid_589745 = query.getOrDefault("oauth_token")
  valid_589745 = validateParameter(valid_589745, JString, required = false,
                                 default = nil)
  if valid_589745 != nil:
    section.add "oauth_token", valid_589745
  var valid_589746 = query.getOrDefault("userIp")
  valid_589746 = validateParameter(valid_589746, JString, required = false,
                                 default = nil)
  if valid_589746 != nil:
    section.add "userIp", valid_589746
  var valid_589747 = query.getOrDefault("key")
  valid_589747 = validateParameter(valid_589747, JString, required = false,
                                 default = nil)
  if valid_589747 != nil:
    section.add "key", valid_589747
  var valid_589748 = query.getOrDefault("prettyPrint")
  valid_589748 = validateParameter(valid_589748, JBool, required = false,
                                 default = newJBool(true))
  if valid_589748 != nil:
    section.add "prettyPrint", valid_589748
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589749: Call_GamesTurnBasedMatchesCancel_589738; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a turn-based match.
  ## 
  let valid = call_589749.validator(path, query, header, formData, body)
  let scheme = call_589749.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589749.url(scheme.get, call_589749.host, call_589749.base,
                         call_589749.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589749, url, valid)

proc call*(call_589750: Call_GamesTurnBasedMatchesCancel_589738; matchId: string;
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
  var path_589751 = newJObject()
  var query_589752 = newJObject()
  add(query_589752, "fields", newJString(fields))
  add(query_589752, "quotaUser", newJString(quotaUser))
  add(query_589752, "alt", newJString(alt))
  add(query_589752, "oauth_token", newJString(oauthToken))
  add(query_589752, "userIp", newJString(userIp))
  add(query_589752, "key", newJString(key))
  add(path_589751, "matchId", newJString(matchId))
  add(query_589752, "prettyPrint", newJBool(prettyPrint))
  result = call_589750.call(path_589751, query_589752, nil, nil, nil)

var gamesTurnBasedMatchesCancel* = Call_GamesTurnBasedMatchesCancel_589738(
    name: "gamesTurnBasedMatchesCancel", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/cancel",
    validator: validate_GamesTurnBasedMatchesCancel_589739, base: "/games/v1",
    url: url_GamesTurnBasedMatchesCancel_589740, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesDecline_589753 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesDecline_589755(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesDecline_589754(path: JsonNode; query: JsonNode;
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
  var valid_589756 = path.getOrDefault("matchId")
  valid_589756 = validateParameter(valid_589756, JString, required = true,
                                 default = nil)
  if valid_589756 != nil:
    section.add "matchId", valid_589756
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
  var valid_589757 = query.getOrDefault("fields")
  valid_589757 = validateParameter(valid_589757, JString, required = false,
                                 default = nil)
  if valid_589757 != nil:
    section.add "fields", valid_589757
  var valid_589758 = query.getOrDefault("quotaUser")
  valid_589758 = validateParameter(valid_589758, JString, required = false,
                                 default = nil)
  if valid_589758 != nil:
    section.add "quotaUser", valid_589758
  var valid_589759 = query.getOrDefault("alt")
  valid_589759 = validateParameter(valid_589759, JString, required = false,
                                 default = newJString("json"))
  if valid_589759 != nil:
    section.add "alt", valid_589759
  var valid_589760 = query.getOrDefault("language")
  valid_589760 = validateParameter(valid_589760, JString, required = false,
                                 default = nil)
  if valid_589760 != nil:
    section.add "language", valid_589760
  var valid_589761 = query.getOrDefault("oauth_token")
  valid_589761 = validateParameter(valid_589761, JString, required = false,
                                 default = nil)
  if valid_589761 != nil:
    section.add "oauth_token", valid_589761
  var valid_589762 = query.getOrDefault("userIp")
  valid_589762 = validateParameter(valid_589762, JString, required = false,
                                 default = nil)
  if valid_589762 != nil:
    section.add "userIp", valid_589762
  var valid_589763 = query.getOrDefault("key")
  valid_589763 = validateParameter(valid_589763, JString, required = false,
                                 default = nil)
  if valid_589763 != nil:
    section.add "key", valid_589763
  var valid_589764 = query.getOrDefault("prettyPrint")
  valid_589764 = validateParameter(valid_589764, JBool, required = false,
                                 default = newJBool(true))
  if valid_589764 != nil:
    section.add "prettyPrint", valid_589764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589765: Call_GamesTurnBasedMatchesDecline_589753; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decline an invitation to play a turn-based match.
  ## 
  let valid = call_589765.validator(path, query, header, formData, body)
  let scheme = call_589765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589765.url(scheme.get, call_589765.host, call_589765.base,
                         call_589765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589765, url, valid)

proc call*(call_589766: Call_GamesTurnBasedMatchesDecline_589753; matchId: string;
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
  var path_589767 = newJObject()
  var query_589768 = newJObject()
  add(query_589768, "fields", newJString(fields))
  add(query_589768, "quotaUser", newJString(quotaUser))
  add(query_589768, "alt", newJString(alt))
  add(query_589768, "language", newJString(language))
  add(query_589768, "oauth_token", newJString(oauthToken))
  add(query_589768, "userIp", newJString(userIp))
  add(query_589768, "key", newJString(key))
  add(path_589767, "matchId", newJString(matchId))
  add(query_589768, "prettyPrint", newJBool(prettyPrint))
  result = call_589766.call(path_589767, query_589768, nil, nil, nil)

var gamesTurnBasedMatchesDecline* = Call_GamesTurnBasedMatchesDecline_589753(
    name: "gamesTurnBasedMatchesDecline", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/decline",
    validator: validate_GamesTurnBasedMatchesDecline_589754, base: "/games/v1",
    url: url_GamesTurnBasedMatchesDecline_589755, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesDismiss_589769 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesDismiss_589771(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesDismiss_589770(path: JsonNode; query: JsonNode;
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
  var valid_589772 = path.getOrDefault("matchId")
  valid_589772 = validateParameter(valid_589772, JString, required = true,
                                 default = nil)
  if valid_589772 != nil:
    section.add "matchId", valid_589772
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
  var valid_589773 = query.getOrDefault("fields")
  valid_589773 = validateParameter(valid_589773, JString, required = false,
                                 default = nil)
  if valid_589773 != nil:
    section.add "fields", valid_589773
  var valid_589774 = query.getOrDefault("quotaUser")
  valid_589774 = validateParameter(valid_589774, JString, required = false,
                                 default = nil)
  if valid_589774 != nil:
    section.add "quotaUser", valid_589774
  var valid_589775 = query.getOrDefault("alt")
  valid_589775 = validateParameter(valid_589775, JString, required = false,
                                 default = newJString("json"))
  if valid_589775 != nil:
    section.add "alt", valid_589775
  var valid_589776 = query.getOrDefault("oauth_token")
  valid_589776 = validateParameter(valid_589776, JString, required = false,
                                 default = nil)
  if valid_589776 != nil:
    section.add "oauth_token", valid_589776
  var valid_589777 = query.getOrDefault("userIp")
  valid_589777 = validateParameter(valid_589777, JString, required = false,
                                 default = nil)
  if valid_589777 != nil:
    section.add "userIp", valid_589777
  var valid_589778 = query.getOrDefault("key")
  valid_589778 = validateParameter(valid_589778, JString, required = false,
                                 default = nil)
  if valid_589778 != nil:
    section.add "key", valid_589778
  var valid_589779 = query.getOrDefault("prettyPrint")
  valid_589779 = validateParameter(valid_589779, JBool, required = false,
                                 default = newJBool(true))
  if valid_589779 != nil:
    section.add "prettyPrint", valid_589779
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589780: Call_GamesTurnBasedMatchesDismiss_589769; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss a turn-based match from the match list. The match will no longer show up in the list and will not generate notifications.
  ## 
  let valid = call_589780.validator(path, query, header, formData, body)
  let scheme = call_589780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589780.url(scheme.get, call_589780.host, call_589780.base,
                         call_589780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589780, url, valid)

proc call*(call_589781: Call_GamesTurnBasedMatchesDismiss_589769; matchId: string;
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
  var path_589782 = newJObject()
  var query_589783 = newJObject()
  add(query_589783, "fields", newJString(fields))
  add(query_589783, "quotaUser", newJString(quotaUser))
  add(query_589783, "alt", newJString(alt))
  add(query_589783, "oauth_token", newJString(oauthToken))
  add(query_589783, "userIp", newJString(userIp))
  add(query_589783, "key", newJString(key))
  add(path_589782, "matchId", newJString(matchId))
  add(query_589783, "prettyPrint", newJBool(prettyPrint))
  result = call_589781.call(path_589782, query_589783, nil, nil, nil)

var gamesTurnBasedMatchesDismiss* = Call_GamesTurnBasedMatchesDismiss_589769(
    name: "gamesTurnBasedMatchesDismiss", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/dismiss",
    validator: validate_GamesTurnBasedMatchesDismiss_589770, base: "/games/v1",
    url: url_GamesTurnBasedMatchesDismiss_589771, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesFinish_589784 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesFinish_589786(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesFinish_589785(path: JsonNode; query: JsonNode;
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
  var valid_589787 = path.getOrDefault("matchId")
  valid_589787 = validateParameter(valid_589787, JString, required = true,
                                 default = nil)
  if valid_589787 != nil:
    section.add "matchId", valid_589787
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
  var valid_589788 = query.getOrDefault("fields")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = nil)
  if valid_589788 != nil:
    section.add "fields", valid_589788
  var valid_589789 = query.getOrDefault("quotaUser")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "quotaUser", valid_589789
  var valid_589790 = query.getOrDefault("alt")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = newJString("json"))
  if valid_589790 != nil:
    section.add "alt", valid_589790
  var valid_589791 = query.getOrDefault("language")
  valid_589791 = validateParameter(valid_589791, JString, required = false,
                                 default = nil)
  if valid_589791 != nil:
    section.add "language", valid_589791
  var valid_589792 = query.getOrDefault("oauth_token")
  valid_589792 = validateParameter(valid_589792, JString, required = false,
                                 default = nil)
  if valid_589792 != nil:
    section.add "oauth_token", valid_589792
  var valid_589793 = query.getOrDefault("userIp")
  valid_589793 = validateParameter(valid_589793, JString, required = false,
                                 default = nil)
  if valid_589793 != nil:
    section.add "userIp", valid_589793
  var valid_589794 = query.getOrDefault("key")
  valid_589794 = validateParameter(valid_589794, JString, required = false,
                                 default = nil)
  if valid_589794 != nil:
    section.add "key", valid_589794
  var valid_589795 = query.getOrDefault("prettyPrint")
  valid_589795 = validateParameter(valid_589795, JBool, required = false,
                                 default = newJBool(true))
  if valid_589795 != nil:
    section.add "prettyPrint", valid_589795
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

proc call*(call_589797: Call_GamesTurnBasedMatchesFinish_589784; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finish a turn-based match. Each player should make this call once, after all results are in. Only the player whose turn it is may make the first call to Finish, and can pass in the final match state.
  ## 
  let valid = call_589797.validator(path, query, header, formData, body)
  let scheme = call_589797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589797.url(scheme.get, call_589797.host, call_589797.base,
                         call_589797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589797, url, valid)

proc call*(call_589798: Call_GamesTurnBasedMatchesFinish_589784; matchId: string;
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
  var path_589799 = newJObject()
  var query_589800 = newJObject()
  var body_589801 = newJObject()
  add(query_589800, "fields", newJString(fields))
  add(query_589800, "quotaUser", newJString(quotaUser))
  add(query_589800, "alt", newJString(alt))
  add(query_589800, "language", newJString(language))
  add(query_589800, "oauth_token", newJString(oauthToken))
  add(query_589800, "userIp", newJString(userIp))
  add(query_589800, "key", newJString(key))
  add(path_589799, "matchId", newJString(matchId))
  if body != nil:
    body_589801 = body
  add(query_589800, "prettyPrint", newJBool(prettyPrint))
  result = call_589798.call(path_589799, query_589800, nil, nil, body_589801)

var gamesTurnBasedMatchesFinish* = Call_GamesTurnBasedMatchesFinish_589784(
    name: "gamesTurnBasedMatchesFinish", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/finish",
    validator: validate_GamesTurnBasedMatchesFinish_589785, base: "/games/v1",
    url: url_GamesTurnBasedMatchesFinish_589786, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesJoin_589802 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesJoin_589804(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesJoin_589803(path: JsonNode; query: JsonNode;
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
  var valid_589805 = path.getOrDefault("matchId")
  valid_589805 = validateParameter(valid_589805, JString, required = true,
                                 default = nil)
  if valid_589805 != nil:
    section.add "matchId", valid_589805
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
  var valid_589806 = query.getOrDefault("fields")
  valid_589806 = validateParameter(valid_589806, JString, required = false,
                                 default = nil)
  if valid_589806 != nil:
    section.add "fields", valid_589806
  var valid_589807 = query.getOrDefault("quotaUser")
  valid_589807 = validateParameter(valid_589807, JString, required = false,
                                 default = nil)
  if valid_589807 != nil:
    section.add "quotaUser", valid_589807
  var valid_589808 = query.getOrDefault("alt")
  valid_589808 = validateParameter(valid_589808, JString, required = false,
                                 default = newJString("json"))
  if valid_589808 != nil:
    section.add "alt", valid_589808
  var valid_589809 = query.getOrDefault("language")
  valid_589809 = validateParameter(valid_589809, JString, required = false,
                                 default = nil)
  if valid_589809 != nil:
    section.add "language", valid_589809
  var valid_589810 = query.getOrDefault("oauth_token")
  valid_589810 = validateParameter(valid_589810, JString, required = false,
                                 default = nil)
  if valid_589810 != nil:
    section.add "oauth_token", valid_589810
  var valid_589811 = query.getOrDefault("userIp")
  valid_589811 = validateParameter(valid_589811, JString, required = false,
                                 default = nil)
  if valid_589811 != nil:
    section.add "userIp", valid_589811
  var valid_589812 = query.getOrDefault("key")
  valid_589812 = validateParameter(valid_589812, JString, required = false,
                                 default = nil)
  if valid_589812 != nil:
    section.add "key", valid_589812
  var valid_589813 = query.getOrDefault("prettyPrint")
  valid_589813 = validateParameter(valid_589813, JBool, required = false,
                                 default = newJBool(true))
  if valid_589813 != nil:
    section.add "prettyPrint", valid_589813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589814: Call_GamesTurnBasedMatchesJoin_589802; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Join a turn-based match.
  ## 
  let valid = call_589814.validator(path, query, header, formData, body)
  let scheme = call_589814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589814.url(scheme.get, call_589814.host, call_589814.base,
                         call_589814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589814, url, valid)

proc call*(call_589815: Call_GamesTurnBasedMatchesJoin_589802; matchId: string;
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
  var path_589816 = newJObject()
  var query_589817 = newJObject()
  add(query_589817, "fields", newJString(fields))
  add(query_589817, "quotaUser", newJString(quotaUser))
  add(query_589817, "alt", newJString(alt))
  add(query_589817, "language", newJString(language))
  add(query_589817, "oauth_token", newJString(oauthToken))
  add(query_589817, "userIp", newJString(userIp))
  add(query_589817, "key", newJString(key))
  add(path_589816, "matchId", newJString(matchId))
  add(query_589817, "prettyPrint", newJBool(prettyPrint))
  result = call_589815.call(path_589816, query_589817, nil, nil, nil)

var gamesTurnBasedMatchesJoin* = Call_GamesTurnBasedMatchesJoin_589802(
    name: "gamesTurnBasedMatchesJoin", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/join",
    validator: validate_GamesTurnBasedMatchesJoin_589803, base: "/games/v1",
    url: url_GamesTurnBasedMatchesJoin_589804, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesLeave_589818 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesLeave_589820(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesLeave_589819(path: JsonNode; query: JsonNode;
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
  var valid_589821 = path.getOrDefault("matchId")
  valid_589821 = validateParameter(valid_589821, JString, required = true,
                                 default = nil)
  if valid_589821 != nil:
    section.add "matchId", valid_589821
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
  var valid_589822 = query.getOrDefault("fields")
  valid_589822 = validateParameter(valid_589822, JString, required = false,
                                 default = nil)
  if valid_589822 != nil:
    section.add "fields", valid_589822
  var valid_589823 = query.getOrDefault("quotaUser")
  valid_589823 = validateParameter(valid_589823, JString, required = false,
                                 default = nil)
  if valid_589823 != nil:
    section.add "quotaUser", valid_589823
  var valid_589824 = query.getOrDefault("alt")
  valid_589824 = validateParameter(valid_589824, JString, required = false,
                                 default = newJString("json"))
  if valid_589824 != nil:
    section.add "alt", valid_589824
  var valid_589825 = query.getOrDefault("language")
  valid_589825 = validateParameter(valid_589825, JString, required = false,
                                 default = nil)
  if valid_589825 != nil:
    section.add "language", valid_589825
  var valid_589826 = query.getOrDefault("oauth_token")
  valid_589826 = validateParameter(valid_589826, JString, required = false,
                                 default = nil)
  if valid_589826 != nil:
    section.add "oauth_token", valid_589826
  var valid_589827 = query.getOrDefault("userIp")
  valid_589827 = validateParameter(valid_589827, JString, required = false,
                                 default = nil)
  if valid_589827 != nil:
    section.add "userIp", valid_589827
  var valid_589828 = query.getOrDefault("key")
  valid_589828 = validateParameter(valid_589828, JString, required = false,
                                 default = nil)
  if valid_589828 != nil:
    section.add "key", valid_589828
  var valid_589829 = query.getOrDefault("prettyPrint")
  valid_589829 = validateParameter(valid_589829, JBool, required = false,
                                 default = newJBool(true))
  if valid_589829 != nil:
    section.add "prettyPrint", valid_589829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589830: Call_GamesTurnBasedMatchesLeave_589818; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a turn-based match when it is not the current player's turn, without canceling the match.
  ## 
  let valid = call_589830.validator(path, query, header, formData, body)
  let scheme = call_589830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589830.url(scheme.get, call_589830.host, call_589830.base,
                         call_589830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589830, url, valid)

proc call*(call_589831: Call_GamesTurnBasedMatchesLeave_589818; matchId: string;
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
  var path_589832 = newJObject()
  var query_589833 = newJObject()
  add(query_589833, "fields", newJString(fields))
  add(query_589833, "quotaUser", newJString(quotaUser))
  add(query_589833, "alt", newJString(alt))
  add(query_589833, "language", newJString(language))
  add(query_589833, "oauth_token", newJString(oauthToken))
  add(query_589833, "userIp", newJString(userIp))
  add(query_589833, "key", newJString(key))
  add(path_589832, "matchId", newJString(matchId))
  add(query_589833, "prettyPrint", newJBool(prettyPrint))
  result = call_589831.call(path_589832, query_589833, nil, nil, nil)

var gamesTurnBasedMatchesLeave* = Call_GamesTurnBasedMatchesLeave_589818(
    name: "gamesTurnBasedMatchesLeave", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/leave",
    validator: validate_GamesTurnBasedMatchesLeave_589819, base: "/games/v1",
    url: url_GamesTurnBasedMatchesLeave_589820, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesLeaveTurn_589834 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesLeaveTurn_589836(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesLeaveTurn_589835(path: JsonNode;
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
  var valid_589837 = path.getOrDefault("matchId")
  valid_589837 = validateParameter(valid_589837, JString, required = true,
                                 default = nil)
  if valid_589837 != nil:
    section.add "matchId", valid_589837
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
  var valid_589838 = query.getOrDefault("matchVersion")
  valid_589838 = validateParameter(valid_589838, JInt, required = true, default = nil)
  if valid_589838 != nil:
    section.add "matchVersion", valid_589838
  var valid_589839 = query.getOrDefault("fields")
  valid_589839 = validateParameter(valid_589839, JString, required = false,
                                 default = nil)
  if valid_589839 != nil:
    section.add "fields", valid_589839
  var valid_589840 = query.getOrDefault("quotaUser")
  valid_589840 = validateParameter(valid_589840, JString, required = false,
                                 default = nil)
  if valid_589840 != nil:
    section.add "quotaUser", valid_589840
  var valid_589841 = query.getOrDefault("alt")
  valid_589841 = validateParameter(valid_589841, JString, required = false,
                                 default = newJString("json"))
  if valid_589841 != nil:
    section.add "alt", valid_589841
  var valid_589842 = query.getOrDefault("language")
  valid_589842 = validateParameter(valid_589842, JString, required = false,
                                 default = nil)
  if valid_589842 != nil:
    section.add "language", valid_589842
  var valid_589843 = query.getOrDefault("oauth_token")
  valid_589843 = validateParameter(valid_589843, JString, required = false,
                                 default = nil)
  if valid_589843 != nil:
    section.add "oauth_token", valid_589843
  var valid_589844 = query.getOrDefault("userIp")
  valid_589844 = validateParameter(valid_589844, JString, required = false,
                                 default = nil)
  if valid_589844 != nil:
    section.add "userIp", valid_589844
  var valid_589845 = query.getOrDefault("key")
  valid_589845 = validateParameter(valid_589845, JString, required = false,
                                 default = nil)
  if valid_589845 != nil:
    section.add "key", valid_589845
  var valid_589846 = query.getOrDefault("prettyPrint")
  valid_589846 = validateParameter(valid_589846, JBool, required = false,
                                 default = newJBool(true))
  if valid_589846 != nil:
    section.add "prettyPrint", valid_589846
  var valid_589847 = query.getOrDefault("pendingParticipantId")
  valid_589847 = validateParameter(valid_589847, JString, required = false,
                                 default = nil)
  if valid_589847 != nil:
    section.add "pendingParticipantId", valid_589847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589848: Call_GamesTurnBasedMatchesLeaveTurn_589834; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a turn-based match during the current player's turn, without canceling the match.
  ## 
  let valid = call_589848.validator(path, query, header, formData, body)
  let scheme = call_589848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589848.url(scheme.get, call_589848.host, call_589848.base,
                         call_589848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589848, url, valid)

proc call*(call_589849: Call_GamesTurnBasedMatchesLeaveTurn_589834;
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
  var path_589850 = newJObject()
  var query_589851 = newJObject()
  add(query_589851, "matchVersion", newJInt(matchVersion))
  add(query_589851, "fields", newJString(fields))
  add(query_589851, "quotaUser", newJString(quotaUser))
  add(query_589851, "alt", newJString(alt))
  add(query_589851, "language", newJString(language))
  add(query_589851, "oauth_token", newJString(oauthToken))
  add(query_589851, "userIp", newJString(userIp))
  add(query_589851, "key", newJString(key))
  add(path_589850, "matchId", newJString(matchId))
  add(query_589851, "prettyPrint", newJBool(prettyPrint))
  add(query_589851, "pendingParticipantId", newJString(pendingParticipantId))
  result = call_589849.call(path_589850, query_589851, nil, nil, nil)

var gamesTurnBasedMatchesLeaveTurn* = Call_GamesTurnBasedMatchesLeaveTurn_589834(
    name: "gamesTurnBasedMatchesLeaveTurn", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/leaveTurn",
    validator: validate_GamesTurnBasedMatchesLeaveTurn_589835, base: "/games/v1",
    url: url_GamesTurnBasedMatchesLeaveTurn_589836, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesRematch_589852 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesRematch_589854(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesRematch_589853(path: JsonNode; query: JsonNode;
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
  var valid_589855 = path.getOrDefault("matchId")
  valid_589855 = validateParameter(valid_589855, JString, required = true,
                                 default = nil)
  if valid_589855 != nil:
    section.add "matchId", valid_589855
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
  var valid_589856 = query.getOrDefault("fields")
  valid_589856 = validateParameter(valid_589856, JString, required = false,
                                 default = nil)
  if valid_589856 != nil:
    section.add "fields", valid_589856
  var valid_589857 = query.getOrDefault("requestId")
  valid_589857 = validateParameter(valid_589857, JString, required = false,
                                 default = nil)
  if valid_589857 != nil:
    section.add "requestId", valid_589857
  var valid_589858 = query.getOrDefault("quotaUser")
  valid_589858 = validateParameter(valid_589858, JString, required = false,
                                 default = nil)
  if valid_589858 != nil:
    section.add "quotaUser", valid_589858
  var valid_589859 = query.getOrDefault("alt")
  valid_589859 = validateParameter(valid_589859, JString, required = false,
                                 default = newJString("json"))
  if valid_589859 != nil:
    section.add "alt", valid_589859
  var valid_589860 = query.getOrDefault("language")
  valid_589860 = validateParameter(valid_589860, JString, required = false,
                                 default = nil)
  if valid_589860 != nil:
    section.add "language", valid_589860
  var valid_589861 = query.getOrDefault("oauth_token")
  valid_589861 = validateParameter(valid_589861, JString, required = false,
                                 default = nil)
  if valid_589861 != nil:
    section.add "oauth_token", valid_589861
  var valid_589862 = query.getOrDefault("userIp")
  valid_589862 = validateParameter(valid_589862, JString, required = false,
                                 default = nil)
  if valid_589862 != nil:
    section.add "userIp", valid_589862
  var valid_589863 = query.getOrDefault("key")
  valid_589863 = validateParameter(valid_589863, JString, required = false,
                                 default = nil)
  if valid_589863 != nil:
    section.add "key", valid_589863
  var valid_589864 = query.getOrDefault("prettyPrint")
  valid_589864 = validateParameter(valid_589864, JBool, required = false,
                                 default = newJBool(true))
  if valid_589864 != nil:
    section.add "prettyPrint", valid_589864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589865: Call_GamesTurnBasedMatchesRematch_589852; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a rematch of a match that was previously completed, with the same participants. This can be called by only one player on a match still in their list; the player must have called Finish first. Returns the newly created match; it will be the caller's turn.
  ## 
  let valid = call_589865.validator(path, query, header, formData, body)
  let scheme = call_589865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589865.url(scheme.get, call_589865.host, call_589865.base,
                         call_589865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589865, url, valid)

proc call*(call_589866: Call_GamesTurnBasedMatchesRematch_589852; matchId: string;
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
  var path_589867 = newJObject()
  var query_589868 = newJObject()
  add(query_589868, "fields", newJString(fields))
  add(query_589868, "requestId", newJString(requestId))
  add(query_589868, "quotaUser", newJString(quotaUser))
  add(query_589868, "alt", newJString(alt))
  add(query_589868, "language", newJString(language))
  add(query_589868, "oauth_token", newJString(oauthToken))
  add(query_589868, "userIp", newJString(userIp))
  add(query_589868, "key", newJString(key))
  add(path_589867, "matchId", newJString(matchId))
  add(query_589868, "prettyPrint", newJBool(prettyPrint))
  result = call_589866.call(path_589867, query_589868, nil, nil, nil)

var gamesTurnBasedMatchesRematch* = Call_GamesTurnBasedMatchesRematch_589852(
    name: "gamesTurnBasedMatchesRematch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/rematch",
    validator: validate_GamesTurnBasedMatchesRematch_589853, base: "/games/v1",
    url: url_GamesTurnBasedMatchesRematch_589854, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesTakeTurn_589869 = ref object of OpenApiRestCall_588466
proc url_GamesTurnBasedMatchesTakeTurn_589871(protocol: Scheme; host: string;
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

proc validate_GamesTurnBasedMatchesTakeTurn_589870(path: JsonNode; query: JsonNode;
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
  var valid_589872 = path.getOrDefault("matchId")
  valid_589872 = validateParameter(valid_589872, JString, required = true,
                                 default = nil)
  if valid_589872 != nil:
    section.add "matchId", valid_589872
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
  var valid_589873 = query.getOrDefault("fields")
  valid_589873 = validateParameter(valid_589873, JString, required = false,
                                 default = nil)
  if valid_589873 != nil:
    section.add "fields", valid_589873
  var valid_589874 = query.getOrDefault("quotaUser")
  valid_589874 = validateParameter(valid_589874, JString, required = false,
                                 default = nil)
  if valid_589874 != nil:
    section.add "quotaUser", valid_589874
  var valid_589875 = query.getOrDefault("alt")
  valid_589875 = validateParameter(valid_589875, JString, required = false,
                                 default = newJString("json"))
  if valid_589875 != nil:
    section.add "alt", valid_589875
  var valid_589876 = query.getOrDefault("language")
  valid_589876 = validateParameter(valid_589876, JString, required = false,
                                 default = nil)
  if valid_589876 != nil:
    section.add "language", valid_589876
  var valid_589877 = query.getOrDefault("oauth_token")
  valid_589877 = validateParameter(valid_589877, JString, required = false,
                                 default = nil)
  if valid_589877 != nil:
    section.add "oauth_token", valid_589877
  var valid_589878 = query.getOrDefault("userIp")
  valid_589878 = validateParameter(valid_589878, JString, required = false,
                                 default = nil)
  if valid_589878 != nil:
    section.add "userIp", valid_589878
  var valid_589879 = query.getOrDefault("key")
  valid_589879 = validateParameter(valid_589879, JString, required = false,
                                 default = nil)
  if valid_589879 != nil:
    section.add "key", valid_589879
  var valid_589880 = query.getOrDefault("prettyPrint")
  valid_589880 = validateParameter(valid_589880, JBool, required = false,
                                 default = newJBool(true))
  if valid_589880 != nil:
    section.add "prettyPrint", valid_589880
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

proc call*(call_589882: Call_GamesTurnBasedMatchesTakeTurn_589869; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commit the results of a player turn.
  ## 
  let valid = call_589882.validator(path, query, header, formData, body)
  let scheme = call_589882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589882.url(scheme.get, call_589882.host, call_589882.base,
                         call_589882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589882, url, valid)

proc call*(call_589883: Call_GamesTurnBasedMatchesTakeTurn_589869; matchId: string;
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
  var path_589884 = newJObject()
  var query_589885 = newJObject()
  var body_589886 = newJObject()
  add(query_589885, "fields", newJString(fields))
  add(query_589885, "quotaUser", newJString(quotaUser))
  add(query_589885, "alt", newJString(alt))
  add(query_589885, "language", newJString(language))
  add(query_589885, "oauth_token", newJString(oauthToken))
  add(query_589885, "userIp", newJString(userIp))
  add(query_589885, "key", newJString(key))
  add(path_589884, "matchId", newJString(matchId))
  if body != nil:
    body_589886 = body
  add(query_589885, "prettyPrint", newJBool(prettyPrint))
  result = call_589883.call(path_589884, query_589885, nil, nil, body_589886)

var gamesTurnBasedMatchesTakeTurn* = Call_GamesTurnBasedMatchesTakeTurn_589869(
    name: "gamesTurnBasedMatchesTakeTurn", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/turn",
    validator: validate_GamesTurnBasedMatchesTakeTurn_589870, base: "/games/v1",
    url: url_GamesTurnBasedMatchesTakeTurn_589871, schemes: {Scheme.Https})
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
