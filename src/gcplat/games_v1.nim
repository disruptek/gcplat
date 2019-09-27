
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GamesAchievementDefinitionsList_593705 = ref object of OpenApiRestCall_593437
proc url_GamesAchievementDefinitionsList_593707(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesAchievementDefinitionsList_593706(path: JsonNode;
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
  var valid_593819 = query.getOrDefault("fields")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "fields", valid_593819
  var valid_593820 = query.getOrDefault("pageToken")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "pageToken", valid_593820
  var valid_593821 = query.getOrDefault("quotaUser")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "quotaUser", valid_593821
  var valid_593835 = query.getOrDefault("alt")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("json"))
  if valid_593835 != nil:
    section.add "alt", valid_593835
  var valid_593836 = query.getOrDefault("language")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "language", valid_593836
  var valid_593837 = query.getOrDefault("oauth_token")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "oauth_token", valid_593837
  var valid_593838 = query.getOrDefault("userIp")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "userIp", valid_593838
  var valid_593839 = query.getOrDefault("maxResults")
  valid_593839 = validateParameter(valid_593839, JInt, required = false, default = nil)
  if valid_593839 != nil:
    section.add "maxResults", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("prettyPrint")
  valid_593841 = validateParameter(valid_593841, JBool, required = false,
                                 default = newJBool(true))
  if valid_593841 != nil:
    section.add "prettyPrint", valid_593841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593864: Call_GamesAchievementDefinitionsList_593705;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the achievement definitions for your application.
  ## 
  let valid = call_593864.validator(path, query, header, formData, body)
  let scheme = call_593864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593864.url(scheme.get, call_593864.host, call_593864.base,
                         call_593864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593864, url, valid)

proc call*(call_593935: Call_GamesAchievementDefinitionsList_593705;
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
  var query_593936 = newJObject()
  add(query_593936, "fields", newJString(fields))
  add(query_593936, "pageToken", newJString(pageToken))
  add(query_593936, "quotaUser", newJString(quotaUser))
  add(query_593936, "alt", newJString(alt))
  add(query_593936, "language", newJString(language))
  add(query_593936, "oauth_token", newJString(oauthToken))
  add(query_593936, "userIp", newJString(userIp))
  add(query_593936, "maxResults", newJInt(maxResults))
  add(query_593936, "key", newJString(key))
  add(query_593936, "prettyPrint", newJBool(prettyPrint))
  result = call_593935.call(nil, query_593936, nil, nil, nil)

var gamesAchievementDefinitionsList* = Call_GamesAchievementDefinitionsList_593705(
    name: "gamesAchievementDefinitionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/achievements",
    validator: validate_GamesAchievementDefinitionsList_593706, base: "/games/v1",
    url: url_GamesAchievementDefinitionsList_593707, schemes: {Scheme.Https})
type
  Call_GamesAchievementsUpdateMultiple_593976 = ref object of OpenApiRestCall_593437
proc url_GamesAchievementsUpdateMultiple_593978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesAchievementsUpdateMultiple_593977(path: JsonNode;
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
  var valid_593979 = query.getOrDefault("fields")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "fields", valid_593979
  var valid_593980 = query.getOrDefault("quotaUser")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "quotaUser", valid_593980
  var valid_593981 = query.getOrDefault("alt")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = newJString("json"))
  if valid_593981 != nil:
    section.add "alt", valid_593981
  var valid_593982 = query.getOrDefault("builtinGameId")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "builtinGameId", valid_593982
  var valid_593983 = query.getOrDefault("oauth_token")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "oauth_token", valid_593983
  var valid_593984 = query.getOrDefault("userIp")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "userIp", valid_593984
  var valid_593985 = query.getOrDefault("key")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "key", valid_593985
  var valid_593986 = query.getOrDefault("prettyPrint")
  valid_593986 = validateParameter(valid_593986, JBool, required = false,
                                 default = newJBool(true))
  if valid_593986 != nil:
    section.add "prettyPrint", valid_593986
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

proc call*(call_593988: Call_GamesAchievementsUpdateMultiple_593976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates multiple achievements for the currently authenticated player.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_GamesAchievementsUpdateMultiple_593976;
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
  var query_593990 = newJObject()
  var body_593991 = newJObject()
  add(query_593990, "fields", newJString(fields))
  add(query_593990, "quotaUser", newJString(quotaUser))
  add(query_593990, "alt", newJString(alt))
  add(query_593990, "builtinGameId", newJString(builtinGameId))
  add(query_593990, "oauth_token", newJString(oauthToken))
  add(query_593990, "userIp", newJString(userIp))
  add(query_593990, "key", newJString(key))
  if body != nil:
    body_593991 = body
  add(query_593990, "prettyPrint", newJBool(prettyPrint))
  result = call_593989.call(nil, query_593990, nil, nil, body_593991)

var gamesAchievementsUpdateMultiple* = Call_GamesAchievementsUpdateMultiple_593976(
    name: "gamesAchievementsUpdateMultiple", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/updateMultiple",
    validator: validate_GamesAchievementsUpdateMultiple_593977, base: "/games/v1",
    url: url_GamesAchievementsUpdateMultiple_593978, schemes: {Scheme.Https})
type
  Call_GamesAchievementsIncrement_593992 = ref object of OpenApiRestCall_593437
proc url_GamesAchievementsIncrement_593994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesAchievementsIncrement_593993(path: JsonNode; query: JsonNode;
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
  var valid_594009 = path.getOrDefault("achievementId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "achievementId", valid_594009
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
  var valid_594010 = query.getOrDefault("fields")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "fields", valid_594010
  var valid_594011 = query.getOrDefault("requestId")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "requestId", valid_594011
  var valid_594012 = query.getOrDefault("quotaUser")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "quotaUser", valid_594012
  var valid_594013 = query.getOrDefault("alt")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = newJString("json"))
  if valid_594013 != nil:
    section.add "alt", valid_594013
  var valid_594014 = query.getOrDefault("oauth_token")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "oauth_token", valid_594014
  var valid_594015 = query.getOrDefault("userIp")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "userIp", valid_594015
  var valid_594016 = query.getOrDefault("key")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "key", valid_594016
  assert query != nil,
        "query argument is necessary due to required `stepsToIncrement` field"
  var valid_594017 = query.getOrDefault("stepsToIncrement")
  valid_594017 = validateParameter(valid_594017, JInt, required = true, default = nil)
  if valid_594017 != nil:
    section.add "stepsToIncrement", valid_594017
  var valid_594018 = query.getOrDefault("prettyPrint")
  valid_594018 = validateParameter(valid_594018, JBool, required = false,
                                 default = newJBool(true))
  if valid_594018 != nil:
    section.add "prettyPrint", valid_594018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_GamesAchievementsIncrement_593992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Increments the steps of the achievement with the given ID for the currently authenticated player.
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_GamesAchievementsIncrement_593992;
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
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  add(query_594022, "fields", newJString(fields))
  add(query_594022, "requestId", newJString(requestId))
  add(query_594022, "quotaUser", newJString(quotaUser))
  add(query_594022, "alt", newJString(alt))
  add(query_594022, "oauth_token", newJString(oauthToken))
  add(query_594022, "userIp", newJString(userIp))
  add(query_594022, "key", newJString(key))
  add(query_594022, "stepsToIncrement", newJInt(stepsToIncrement))
  add(path_594021, "achievementId", newJString(achievementId))
  add(query_594022, "prettyPrint", newJBool(prettyPrint))
  result = call_594020.call(path_594021, query_594022, nil, nil, nil)

var gamesAchievementsIncrement* = Call_GamesAchievementsIncrement_593992(
    name: "gamesAchievementsIncrement", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/increment",
    validator: validate_GamesAchievementsIncrement_593993, base: "/games/v1",
    url: url_GamesAchievementsIncrement_593994, schemes: {Scheme.Https})
type
  Call_GamesAchievementsReveal_594023 = ref object of OpenApiRestCall_593437
proc url_GamesAchievementsReveal_594025(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesAchievementsReveal_594024(path: JsonNode; query: JsonNode;
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
  var valid_594026 = path.getOrDefault("achievementId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "achievementId", valid_594026
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
  var valid_594027 = query.getOrDefault("fields")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "fields", valid_594027
  var valid_594028 = query.getOrDefault("quotaUser")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "quotaUser", valid_594028
  var valid_594029 = query.getOrDefault("alt")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = newJString("json"))
  if valid_594029 != nil:
    section.add "alt", valid_594029
  var valid_594030 = query.getOrDefault("oauth_token")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "oauth_token", valid_594030
  var valid_594031 = query.getOrDefault("userIp")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "userIp", valid_594031
  var valid_594032 = query.getOrDefault("key")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "key", valid_594032
  var valid_594033 = query.getOrDefault("prettyPrint")
  valid_594033 = validateParameter(valid_594033, JBool, required = false,
                                 default = newJBool(true))
  if valid_594033 != nil:
    section.add "prettyPrint", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_GamesAchievementsReveal_594023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the achievement with the given ID to REVEALED for the currently authenticated player.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_GamesAchievementsReveal_594023; achievementId: string;
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
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  add(query_594037, "fields", newJString(fields))
  add(query_594037, "quotaUser", newJString(quotaUser))
  add(query_594037, "alt", newJString(alt))
  add(query_594037, "oauth_token", newJString(oauthToken))
  add(query_594037, "userIp", newJString(userIp))
  add(query_594037, "key", newJString(key))
  add(path_594036, "achievementId", newJString(achievementId))
  add(query_594037, "prettyPrint", newJBool(prettyPrint))
  result = call_594035.call(path_594036, query_594037, nil, nil, nil)

var gamesAchievementsReveal* = Call_GamesAchievementsReveal_594023(
    name: "gamesAchievementsReveal", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/reveal",
    validator: validate_GamesAchievementsReveal_594024, base: "/games/v1",
    url: url_GamesAchievementsReveal_594025, schemes: {Scheme.Https})
type
  Call_GamesAchievementsSetStepsAtLeast_594038 = ref object of OpenApiRestCall_593437
proc url_GamesAchievementsSetStepsAtLeast_594040(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesAchievementsSetStepsAtLeast_594039(path: JsonNode;
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
  var valid_594041 = path.getOrDefault("achievementId")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "achievementId", valid_594041
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
  var valid_594042 = query.getOrDefault("fields")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "fields", valid_594042
  var valid_594043 = query.getOrDefault("quotaUser")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "quotaUser", valid_594043
  var valid_594044 = query.getOrDefault("alt")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = newJString("json"))
  if valid_594044 != nil:
    section.add "alt", valid_594044
  assert query != nil, "query argument is necessary due to required `steps` field"
  var valid_594045 = query.getOrDefault("steps")
  valid_594045 = validateParameter(valid_594045, JInt, required = true, default = nil)
  if valid_594045 != nil:
    section.add "steps", valid_594045
  var valid_594046 = query.getOrDefault("oauth_token")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "oauth_token", valid_594046
  var valid_594047 = query.getOrDefault("userIp")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "userIp", valid_594047
  var valid_594048 = query.getOrDefault("key")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "key", valid_594048
  var valid_594049 = query.getOrDefault("prettyPrint")
  valid_594049 = validateParameter(valid_594049, JBool, required = false,
                                 default = newJBool(true))
  if valid_594049 != nil:
    section.add "prettyPrint", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_GamesAchievementsSetStepsAtLeast_594038;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the steps for the currently authenticated player towards unlocking an achievement. If the steps parameter is less than the current number of steps that the player already gained for the achievement, the achievement is not modified.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_GamesAchievementsSetStepsAtLeast_594038; steps: int;
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
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(query_594053, "fields", newJString(fields))
  add(query_594053, "quotaUser", newJString(quotaUser))
  add(query_594053, "alt", newJString(alt))
  add(query_594053, "steps", newJInt(steps))
  add(query_594053, "oauth_token", newJString(oauthToken))
  add(query_594053, "userIp", newJString(userIp))
  add(query_594053, "key", newJString(key))
  add(path_594052, "achievementId", newJString(achievementId))
  add(query_594053, "prettyPrint", newJBool(prettyPrint))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var gamesAchievementsSetStepsAtLeast* = Call_GamesAchievementsSetStepsAtLeast_594038(
    name: "gamesAchievementsSetStepsAtLeast", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/achievements/{achievementId}/setStepsAtLeast",
    validator: validate_GamesAchievementsSetStepsAtLeast_594039,
    base: "/games/v1", url: url_GamesAchievementsSetStepsAtLeast_594040,
    schemes: {Scheme.Https})
type
  Call_GamesAchievementsUnlock_594054 = ref object of OpenApiRestCall_593437
proc url_GamesAchievementsUnlock_594056(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesAchievementsUnlock_594055(path: JsonNode; query: JsonNode;
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
  var valid_594057 = path.getOrDefault("achievementId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "achievementId", valid_594057
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
  var valid_594058 = query.getOrDefault("fields")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "fields", valid_594058
  var valid_594059 = query.getOrDefault("quotaUser")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "quotaUser", valid_594059
  var valid_594060 = query.getOrDefault("alt")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = newJString("json"))
  if valid_594060 != nil:
    section.add "alt", valid_594060
  var valid_594061 = query.getOrDefault("builtinGameId")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "builtinGameId", valid_594061
  var valid_594062 = query.getOrDefault("oauth_token")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "oauth_token", valid_594062
  var valid_594063 = query.getOrDefault("userIp")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "userIp", valid_594063
  var valid_594064 = query.getOrDefault("key")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "key", valid_594064
  var valid_594065 = query.getOrDefault("prettyPrint")
  valid_594065 = validateParameter(valid_594065, JBool, required = false,
                                 default = newJBool(true))
  if valid_594065 != nil:
    section.add "prettyPrint", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_GamesAchievementsUnlock_594054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unlocks this achievement for the currently authenticated player.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_GamesAchievementsUnlock_594054; achievementId: string;
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
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(query_594069, "fields", newJString(fields))
  add(query_594069, "quotaUser", newJString(quotaUser))
  add(query_594069, "alt", newJString(alt))
  add(query_594069, "builtinGameId", newJString(builtinGameId))
  add(query_594069, "oauth_token", newJString(oauthToken))
  add(query_594069, "userIp", newJString(userIp))
  add(query_594069, "key", newJString(key))
  add(path_594068, "achievementId", newJString(achievementId))
  add(query_594069, "prettyPrint", newJBool(prettyPrint))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var gamesAchievementsUnlock* = Call_GamesAchievementsUnlock_594054(
    name: "gamesAchievementsUnlock", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/unlock",
    validator: validate_GamesAchievementsUnlock_594055, base: "/games/v1",
    url: url_GamesAchievementsUnlock_594056, schemes: {Scheme.Https})
type
  Call_GamesApplicationsPlayed_594070 = ref object of OpenApiRestCall_593437
proc url_GamesApplicationsPlayed_594072(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesApplicationsPlayed_594071(path: JsonNode; query: JsonNode;
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
  var valid_594073 = query.getOrDefault("fields")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "fields", valid_594073
  var valid_594074 = query.getOrDefault("quotaUser")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "quotaUser", valid_594074
  var valid_594075 = query.getOrDefault("alt")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = newJString("json"))
  if valid_594075 != nil:
    section.add "alt", valid_594075
  var valid_594076 = query.getOrDefault("builtinGameId")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "builtinGameId", valid_594076
  var valid_594077 = query.getOrDefault("oauth_token")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "oauth_token", valid_594077
  var valid_594078 = query.getOrDefault("userIp")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "userIp", valid_594078
  var valid_594079 = query.getOrDefault("key")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "key", valid_594079
  var valid_594080 = query.getOrDefault("prettyPrint")
  valid_594080 = validateParameter(valid_594080, JBool, required = false,
                                 default = newJBool(true))
  if valid_594080 != nil:
    section.add "prettyPrint", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_GamesApplicationsPlayed_594070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicate that the the currently authenticated user is playing your application.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_GamesApplicationsPlayed_594070; fields: string = "";
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
  var query_594083 = newJObject()
  add(query_594083, "fields", newJString(fields))
  add(query_594083, "quotaUser", newJString(quotaUser))
  add(query_594083, "alt", newJString(alt))
  add(query_594083, "builtinGameId", newJString(builtinGameId))
  add(query_594083, "oauth_token", newJString(oauthToken))
  add(query_594083, "userIp", newJString(userIp))
  add(query_594083, "key", newJString(key))
  add(query_594083, "prettyPrint", newJBool(prettyPrint))
  result = call_594082.call(nil, query_594083, nil, nil, nil)

var gamesApplicationsPlayed* = Call_GamesApplicationsPlayed_594070(
    name: "gamesApplicationsPlayed", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/applications/played",
    validator: validate_GamesApplicationsPlayed_594071, base: "/games/v1",
    url: url_GamesApplicationsPlayed_594072, schemes: {Scheme.Https})
type
  Call_GamesApplicationsGet_594084 = ref object of OpenApiRestCall_593437
proc url_GamesApplicationsGet_594086(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesApplicationsGet_594085(path: JsonNode; query: JsonNode;
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
  var valid_594087 = path.getOrDefault("applicationId")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "applicationId", valid_594087
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
  var valid_594088 = query.getOrDefault("fields")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "fields", valid_594088
  var valid_594089 = query.getOrDefault("quotaUser")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "quotaUser", valid_594089
  var valid_594090 = query.getOrDefault("alt")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = newJString("json"))
  if valid_594090 != nil:
    section.add "alt", valid_594090
  var valid_594091 = query.getOrDefault("language")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "language", valid_594091
  var valid_594092 = query.getOrDefault("oauth_token")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "oauth_token", valid_594092
  var valid_594093 = query.getOrDefault("userIp")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "userIp", valid_594093
  var valid_594094 = query.getOrDefault("key")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "key", valid_594094
  var valid_594095 = query.getOrDefault("platformType")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = newJString("ANDROID"))
  if valid_594095 != nil:
    section.add "platformType", valid_594095
  var valid_594096 = query.getOrDefault("prettyPrint")
  valid_594096 = validateParameter(valid_594096, JBool, required = false,
                                 default = newJBool(true))
  if valid_594096 != nil:
    section.add "prettyPrint", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_GamesApplicationsGet_594084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata of the application with the given ID. If the requested application is not available for the specified platformType, the returned response will not include any instance data.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_GamesApplicationsGet_594084; applicationId: string;
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
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(query_594100, "fields", newJString(fields))
  add(query_594100, "quotaUser", newJString(quotaUser))
  add(query_594100, "alt", newJString(alt))
  add(query_594100, "language", newJString(language))
  add(query_594100, "oauth_token", newJString(oauthToken))
  add(query_594100, "userIp", newJString(userIp))
  add(path_594099, "applicationId", newJString(applicationId))
  add(query_594100, "key", newJString(key))
  add(query_594100, "platformType", newJString(platformType))
  add(query_594100, "prettyPrint", newJBool(prettyPrint))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var gamesApplicationsGet* = Call_GamesApplicationsGet_594084(
    name: "gamesApplicationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}",
    validator: validate_GamesApplicationsGet_594085, base: "/games/v1",
    url: url_GamesApplicationsGet_594086, schemes: {Scheme.Https})
type
  Call_GamesApplicationsVerify_594101 = ref object of OpenApiRestCall_593437
proc url_GamesApplicationsVerify_594103(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesApplicationsVerify_594102(path: JsonNode; query: JsonNode;
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
  var valid_594104 = path.getOrDefault("applicationId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "applicationId", valid_594104
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
  var valid_594105 = query.getOrDefault("fields")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "fields", valid_594105
  var valid_594106 = query.getOrDefault("quotaUser")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "quotaUser", valid_594106
  var valid_594107 = query.getOrDefault("alt")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = newJString("json"))
  if valid_594107 != nil:
    section.add "alt", valid_594107
  var valid_594108 = query.getOrDefault("oauth_token")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "oauth_token", valid_594108
  var valid_594109 = query.getOrDefault("userIp")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "userIp", valid_594109
  var valid_594110 = query.getOrDefault("key")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "key", valid_594110
  var valid_594111 = query.getOrDefault("prettyPrint")
  valid_594111 = validateParameter(valid_594111, JBool, required = false,
                                 default = newJBool(true))
  if valid_594111 != nil:
    section.add "prettyPrint", valid_594111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594112: Call_GamesApplicationsVerify_594101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Verifies the auth token provided with this request is for the application with the specified ID, and returns the ID of the player it was granted for.
  ## 
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_GamesApplicationsVerify_594101; applicationId: string;
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
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  add(query_594115, "fields", newJString(fields))
  add(query_594115, "quotaUser", newJString(quotaUser))
  add(query_594115, "alt", newJString(alt))
  add(query_594115, "oauth_token", newJString(oauthToken))
  add(query_594115, "userIp", newJString(userIp))
  add(path_594114, "applicationId", newJString(applicationId))
  add(query_594115, "key", newJString(key))
  add(query_594115, "prettyPrint", newJBool(prettyPrint))
  result = call_594113.call(path_594114, query_594115, nil, nil, nil)

var gamesApplicationsVerify* = Call_GamesApplicationsVerify_594101(
    name: "gamesApplicationsVerify", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/applications/{applicationId}/verify",
    validator: validate_GamesApplicationsVerify_594102, base: "/games/v1",
    url: url_GamesApplicationsVerify_594103, schemes: {Scheme.Https})
type
  Call_GamesEventsListDefinitions_594116 = ref object of OpenApiRestCall_593437
proc url_GamesEventsListDefinitions_594118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesEventsListDefinitions_594117(path: JsonNode; query: JsonNode;
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
  var valid_594119 = query.getOrDefault("fields")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "fields", valid_594119
  var valid_594120 = query.getOrDefault("pageToken")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "pageToken", valid_594120
  var valid_594121 = query.getOrDefault("quotaUser")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "quotaUser", valid_594121
  var valid_594122 = query.getOrDefault("alt")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = newJString("json"))
  if valid_594122 != nil:
    section.add "alt", valid_594122
  var valid_594123 = query.getOrDefault("language")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "language", valid_594123
  var valid_594124 = query.getOrDefault("oauth_token")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "oauth_token", valid_594124
  var valid_594125 = query.getOrDefault("userIp")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "userIp", valid_594125
  var valid_594126 = query.getOrDefault("maxResults")
  valid_594126 = validateParameter(valid_594126, JInt, required = false, default = nil)
  if valid_594126 != nil:
    section.add "maxResults", valid_594126
  var valid_594127 = query.getOrDefault("key")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "key", valid_594127
  var valid_594128 = query.getOrDefault("prettyPrint")
  valid_594128 = validateParameter(valid_594128, JBool, required = false,
                                 default = newJBool(true))
  if valid_594128 != nil:
    section.add "prettyPrint", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_GamesEventsListDefinitions_594116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of the event definitions in this application.
  ## 
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_GamesEventsListDefinitions_594116;
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
  var query_594131 = newJObject()
  add(query_594131, "fields", newJString(fields))
  add(query_594131, "pageToken", newJString(pageToken))
  add(query_594131, "quotaUser", newJString(quotaUser))
  add(query_594131, "alt", newJString(alt))
  add(query_594131, "language", newJString(language))
  add(query_594131, "oauth_token", newJString(oauthToken))
  add(query_594131, "userIp", newJString(userIp))
  add(query_594131, "maxResults", newJInt(maxResults))
  add(query_594131, "key", newJString(key))
  add(query_594131, "prettyPrint", newJBool(prettyPrint))
  result = call_594130.call(nil, query_594131, nil, nil, nil)

var gamesEventsListDefinitions* = Call_GamesEventsListDefinitions_594116(
    name: "gamesEventsListDefinitions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/eventDefinitions",
    validator: validate_GamesEventsListDefinitions_594117, base: "/games/v1",
    url: url_GamesEventsListDefinitions_594118, schemes: {Scheme.Https})
type
  Call_GamesEventsRecord_594148 = ref object of OpenApiRestCall_593437
proc url_GamesEventsRecord_594150(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesEventsRecord_594149(path: JsonNode; query: JsonNode;
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
  var valid_594151 = query.getOrDefault("fields")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "fields", valid_594151
  var valid_594152 = query.getOrDefault("quotaUser")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "quotaUser", valid_594152
  var valid_594153 = query.getOrDefault("alt")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = newJString("json"))
  if valid_594153 != nil:
    section.add "alt", valid_594153
  var valid_594154 = query.getOrDefault("language")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "language", valid_594154
  var valid_594155 = query.getOrDefault("oauth_token")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "oauth_token", valid_594155
  var valid_594156 = query.getOrDefault("userIp")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "userIp", valid_594156
  var valid_594157 = query.getOrDefault("key")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "key", valid_594157
  var valid_594158 = query.getOrDefault("prettyPrint")
  valid_594158 = validateParameter(valid_594158, JBool, required = false,
                                 default = newJBool(true))
  if valid_594158 != nil:
    section.add "prettyPrint", valid_594158
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

proc call*(call_594160: Call_GamesEventsRecord_594148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Records a batch of changes to the number of times events have occurred for the currently authenticated user of this application.
  ## 
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_GamesEventsRecord_594148; fields: string = "";
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
  var query_594162 = newJObject()
  var body_594163 = newJObject()
  add(query_594162, "fields", newJString(fields))
  add(query_594162, "quotaUser", newJString(quotaUser))
  add(query_594162, "alt", newJString(alt))
  add(query_594162, "language", newJString(language))
  add(query_594162, "oauth_token", newJString(oauthToken))
  add(query_594162, "userIp", newJString(userIp))
  add(query_594162, "key", newJString(key))
  if body != nil:
    body_594163 = body
  add(query_594162, "prettyPrint", newJBool(prettyPrint))
  result = call_594161.call(nil, query_594162, nil, nil, body_594163)

var gamesEventsRecord* = Call_GamesEventsRecord_594148(name: "gamesEventsRecord",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/events",
    validator: validate_GamesEventsRecord_594149, base: "/games/v1",
    url: url_GamesEventsRecord_594150, schemes: {Scheme.Https})
type
  Call_GamesEventsListByPlayer_594132 = ref object of OpenApiRestCall_593437
proc url_GamesEventsListByPlayer_594134(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesEventsListByPlayer_594133(path: JsonNode; query: JsonNode;
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
  var valid_594135 = query.getOrDefault("fields")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "fields", valid_594135
  var valid_594136 = query.getOrDefault("pageToken")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "pageToken", valid_594136
  var valid_594137 = query.getOrDefault("quotaUser")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "quotaUser", valid_594137
  var valid_594138 = query.getOrDefault("alt")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = newJString("json"))
  if valid_594138 != nil:
    section.add "alt", valid_594138
  var valid_594139 = query.getOrDefault("language")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "language", valid_594139
  var valid_594140 = query.getOrDefault("oauth_token")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "oauth_token", valid_594140
  var valid_594141 = query.getOrDefault("userIp")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "userIp", valid_594141
  var valid_594142 = query.getOrDefault("maxResults")
  valid_594142 = validateParameter(valid_594142, JInt, required = false, default = nil)
  if valid_594142 != nil:
    section.add "maxResults", valid_594142
  var valid_594143 = query.getOrDefault("key")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "key", valid_594143
  var valid_594144 = query.getOrDefault("prettyPrint")
  valid_594144 = validateParameter(valid_594144, JBool, required = false,
                                 default = newJBool(true))
  if valid_594144 != nil:
    section.add "prettyPrint", valid_594144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594145: Call_GamesEventsListByPlayer_594132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list showing the current progress on events in this application for the currently authenticated user.
  ## 
  let valid = call_594145.validator(path, query, header, formData, body)
  let scheme = call_594145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594145.url(scheme.get, call_594145.host, call_594145.base,
                         call_594145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594145, url, valid)

proc call*(call_594146: Call_GamesEventsListByPlayer_594132; fields: string = "";
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
  var query_594147 = newJObject()
  add(query_594147, "fields", newJString(fields))
  add(query_594147, "pageToken", newJString(pageToken))
  add(query_594147, "quotaUser", newJString(quotaUser))
  add(query_594147, "alt", newJString(alt))
  add(query_594147, "language", newJString(language))
  add(query_594147, "oauth_token", newJString(oauthToken))
  add(query_594147, "userIp", newJString(userIp))
  add(query_594147, "maxResults", newJInt(maxResults))
  add(query_594147, "key", newJString(key))
  add(query_594147, "prettyPrint", newJBool(prettyPrint))
  result = call_594146.call(nil, query_594147, nil, nil, nil)

var gamesEventsListByPlayer* = Call_GamesEventsListByPlayer_594132(
    name: "gamesEventsListByPlayer", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/events",
    validator: validate_GamesEventsListByPlayer_594133, base: "/games/v1",
    url: url_GamesEventsListByPlayer_594134, schemes: {Scheme.Https})
type
  Call_GamesLeaderboardsList_594164 = ref object of OpenApiRestCall_593437
proc url_GamesLeaderboardsList_594166(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesLeaderboardsList_594165(path: JsonNode; query: JsonNode;
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
  var valid_594167 = query.getOrDefault("fields")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "fields", valid_594167
  var valid_594168 = query.getOrDefault("pageToken")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "pageToken", valid_594168
  var valid_594169 = query.getOrDefault("quotaUser")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "quotaUser", valid_594169
  var valid_594170 = query.getOrDefault("alt")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = newJString("json"))
  if valid_594170 != nil:
    section.add "alt", valid_594170
  var valid_594171 = query.getOrDefault("language")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "language", valid_594171
  var valid_594172 = query.getOrDefault("oauth_token")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "oauth_token", valid_594172
  var valid_594173 = query.getOrDefault("userIp")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "userIp", valid_594173
  var valid_594174 = query.getOrDefault("maxResults")
  valid_594174 = validateParameter(valid_594174, JInt, required = false, default = nil)
  if valid_594174 != nil:
    section.add "maxResults", valid_594174
  var valid_594175 = query.getOrDefault("key")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "key", valid_594175
  var valid_594176 = query.getOrDefault("prettyPrint")
  valid_594176 = validateParameter(valid_594176, JBool, required = false,
                                 default = newJBool(true))
  if valid_594176 != nil:
    section.add "prettyPrint", valid_594176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594177: Call_GamesLeaderboardsList_594164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the leaderboard metadata for your application.
  ## 
  let valid = call_594177.validator(path, query, header, formData, body)
  let scheme = call_594177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594177.url(scheme.get, call_594177.host, call_594177.base,
                         call_594177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594177, url, valid)

proc call*(call_594178: Call_GamesLeaderboardsList_594164; fields: string = "";
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
  var query_594179 = newJObject()
  add(query_594179, "fields", newJString(fields))
  add(query_594179, "pageToken", newJString(pageToken))
  add(query_594179, "quotaUser", newJString(quotaUser))
  add(query_594179, "alt", newJString(alt))
  add(query_594179, "language", newJString(language))
  add(query_594179, "oauth_token", newJString(oauthToken))
  add(query_594179, "userIp", newJString(userIp))
  add(query_594179, "maxResults", newJInt(maxResults))
  add(query_594179, "key", newJString(key))
  add(query_594179, "prettyPrint", newJBool(prettyPrint))
  result = call_594178.call(nil, query_594179, nil, nil, nil)

var gamesLeaderboardsList* = Call_GamesLeaderboardsList_594164(
    name: "gamesLeaderboardsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/leaderboards",
    validator: validate_GamesLeaderboardsList_594165, base: "/games/v1",
    url: url_GamesLeaderboardsList_594166, schemes: {Scheme.Https})
type
  Call_GamesScoresSubmitMultiple_594180 = ref object of OpenApiRestCall_593437
proc url_GamesScoresSubmitMultiple_594182(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesScoresSubmitMultiple_594181(path: JsonNode; query: JsonNode;
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
  var valid_594183 = query.getOrDefault("fields")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "fields", valid_594183
  var valid_594184 = query.getOrDefault("quotaUser")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "quotaUser", valid_594184
  var valid_594185 = query.getOrDefault("alt")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = newJString("json"))
  if valid_594185 != nil:
    section.add "alt", valid_594185
  var valid_594186 = query.getOrDefault("language")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "language", valid_594186
  var valid_594187 = query.getOrDefault("oauth_token")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "oauth_token", valid_594187
  var valid_594188 = query.getOrDefault("userIp")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "userIp", valid_594188
  var valid_594189 = query.getOrDefault("key")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "key", valid_594189
  var valid_594190 = query.getOrDefault("prettyPrint")
  valid_594190 = validateParameter(valid_594190, JBool, required = false,
                                 default = newJBool(true))
  if valid_594190 != nil:
    section.add "prettyPrint", valid_594190
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

proc call*(call_594192: Call_GamesScoresSubmitMultiple_594180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits multiple scores to leaderboards.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_GamesScoresSubmitMultiple_594180; fields: string = "";
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
  var query_594194 = newJObject()
  var body_594195 = newJObject()
  add(query_594194, "fields", newJString(fields))
  add(query_594194, "quotaUser", newJString(quotaUser))
  add(query_594194, "alt", newJString(alt))
  add(query_594194, "language", newJString(language))
  add(query_594194, "oauth_token", newJString(oauthToken))
  add(query_594194, "userIp", newJString(userIp))
  add(query_594194, "key", newJString(key))
  if body != nil:
    body_594195 = body
  add(query_594194, "prettyPrint", newJBool(prettyPrint))
  result = call_594193.call(nil, query_594194, nil, nil, body_594195)

var gamesScoresSubmitMultiple* = Call_GamesScoresSubmitMultiple_594180(
    name: "gamesScoresSubmitMultiple", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/leaderboards/scores",
    validator: validate_GamesScoresSubmitMultiple_594181, base: "/games/v1",
    url: url_GamesScoresSubmitMultiple_594182, schemes: {Scheme.Https})
type
  Call_GamesLeaderboardsGet_594196 = ref object of OpenApiRestCall_593437
proc url_GamesLeaderboardsGet_594198(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "leaderboardId" in path, "`leaderboardId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/leaderboards/"),
               (kind: VariableSegment, value: "leaderboardId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesLeaderboardsGet_594197(path: JsonNode; query: JsonNode;
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
  var valid_594199 = path.getOrDefault("leaderboardId")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "leaderboardId", valid_594199
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
  var valid_594200 = query.getOrDefault("fields")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "fields", valid_594200
  var valid_594201 = query.getOrDefault("quotaUser")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "quotaUser", valid_594201
  var valid_594202 = query.getOrDefault("alt")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = newJString("json"))
  if valid_594202 != nil:
    section.add "alt", valid_594202
  var valid_594203 = query.getOrDefault("language")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "language", valid_594203
  var valid_594204 = query.getOrDefault("oauth_token")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "oauth_token", valid_594204
  var valid_594205 = query.getOrDefault("userIp")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "userIp", valid_594205
  var valid_594206 = query.getOrDefault("key")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "key", valid_594206
  var valid_594207 = query.getOrDefault("prettyPrint")
  valid_594207 = validateParameter(valid_594207, JBool, required = false,
                                 default = newJBool(true))
  if valid_594207 != nil:
    section.add "prettyPrint", valid_594207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594208: Call_GamesLeaderboardsGet_594196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata of the leaderboard with the given ID.
  ## 
  let valid = call_594208.validator(path, query, header, formData, body)
  let scheme = call_594208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594208.url(scheme.get, call_594208.host, call_594208.base,
                         call_594208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594208, url, valid)

proc call*(call_594209: Call_GamesLeaderboardsGet_594196; leaderboardId: string;
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
  var path_594210 = newJObject()
  var query_594211 = newJObject()
  add(query_594211, "fields", newJString(fields))
  add(query_594211, "quotaUser", newJString(quotaUser))
  add(query_594211, "alt", newJString(alt))
  add(query_594211, "language", newJString(language))
  add(path_594210, "leaderboardId", newJString(leaderboardId))
  add(query_594211, "oauth_token", newJString(oauthToken))
  add(query_594211, "userIp", newJString(userIp))
  add(query_594211, "key", newJString(key))
  add(query_594211, "prettyPrint", newJBool(prettyPrint))
  result = call_594209.call(path_594210, query_594211, nil, nil, nil)

var gamesLeaderboardsGet* = Call_GamesLeaderboardsGet_594196(
    name: "gamesLeaderboardsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesLeaderboardsGet_594197, base: "/games/v1",
    url: url_GamesLeaderboardsGet_594198, schemes: {Scheme.Https})
type
  Call_GamesScoresSubmit_594212 = ref object of OpenApiRestCall_593437
proc url_GamesScoresSubmit_594214(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesScoresSubmit_594213(path: JsonNode; query: JsonNode;
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
  var valid_594215 = path.getOrDefault("leaderboardId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "leaderboardId", valid_594215
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
  var valid_594216 = query.getOrDefault("fields")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "fields", valid_594216
  var valid_594217 = query.getOrDefault("quotaUser")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "quotaUser", valid_594217
  var valid_594218 = query.getOrDefault("alt")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = newJString("json"))
  if valid_594218 != nil:
    section.add "alt", valid_594218
  var valid_594219 = query.getOrDefault("language")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "language", valid_594219
  var valid_594220 = query.getOrDefault("oauth_token")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "oauth_token", valid_594220
  var valid_594221 = query.getOrDefault("userIp")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "userIp", valid_594221
  var valid_594222 = query.getOrDefault("key")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "key", valid_594222
  var valid_594223 = query.getOrDefault("scoreTag")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "scoreTag", valid_594223
  assert query != nil, "query argument is necessary due to required `score` field"
  var valid_594224 = query.getOrDefault("score")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "score", valid_594224
  var valid_594225 = query.getOrDefault("prettyPrint")
  valid_594225 = validateParameter(valid_594225, JBool, required = false,
                                 default = newJBool(true))
  if valid_594225 != nil:
    section.add "prettyPrint", valid_594225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594226: Call_GamesScoresSubmit_594212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submits a score to the specified leaderboard.
  ## 
  let valid = call_594226.validator(path, query, header, formData, body)
  let scheme = call_594226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594226.url(scheme.get, call_594226.host, call_594226.base,
                         call_594226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594226, url, valid)

proc call*(call_594227: Call_GamesScoresSubmit_594212; leaderboardId: string;
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
  var path_594228 = newJObject()
  var query_594229 = newJObject()
  add(query_594229, "fields", newJString(fields))
  add(query_594229, "quotaUser", newJString(quotaUser))
  add(query_594229, "alt", newJString(alt))
  add(query_594229, "language", newJString(language))
  add(path_594228, "leaderboardId", newJString(leaderboardId))
  add(query_594229, "oauth_token", newJString(oauthToken))
  add(query_594229, "userIp", newJString(userIp))
  add(query_594229, "key", newJString(key))
  add(query_594229, "scoreTag", newJString(scoreTag))
  add(query_594229, "score", newJString(score))
  add(query_594229, "prettyPrint", newJBool(prettyPrint))
  result = call_594227.call(path_594228, query_594229, nil, nil, nil)

var gamesScoresSubmit* = Call_GamesScoresSubmit_594212(name: "gamesScoresSubmit",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores",
    validator: validate_GamesScoresSubmit_594213, base: "/games/v1",
    url: url_GamesScoresSubmit_594214, schemes: {Scheme.Https})
type
  Call_GamesScoresList_594230 = ref object of OpenApiRestCall_593437
proc url_GamesScoresList_594232(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesScoresList_594231(path: JsonNode; query: JsonNode;
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
  var valid_594233 = path.getOrDefault("leaderboardId")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "leaderboardId", valid_594233
  var valid_594234 = path.getOrDefault("collection")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = newJString("PUBLIC"))
  if valid_594234 != nil:
    section.add "collection", valid_594234
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
  var valid_594235 = query.getOrDefault("fields")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "fields", valid_594235
  var valid_594236 = query.getOrDefault("pageToken")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "pageToken", valid_594236
  var valid_594237 = query.getOrDefault("quotaUser")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "quotaUser", valid_594237
  var valid_594238 = query.getOrDefault("alt")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = newJString("json"))
  if valid_594238 != nil:
    section.add "alt", valid_594238
  var valid_594239 = query.getOrDefault("language")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "language", valid_594239
  var valid_594240 = query.getOrDefault("oauth_token")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "oauth_token", valid_594240
  var valid_594241 = query.getOrDefault("userIp")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "userIp", valid_594241
  var valid_594242 = query.getOrDefault("maxResults")
  valid_594242 = validateParameter(valid_594242, JInt, required = false, default = nil)
  if valid_594242 != nil:
    section.add "maxResults", valid_594242
  assert query != nil,
        "query argument is necessary due to required `timeSpan` field"
  var valid_594243 = query.getOrDefault("timeSpan")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = newJString("ALL_TIME"))
  if valid_594243 != nil:
    section.add "timeSpan", valid_594243
  var valid_594244 = query.getOrDefault("key")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "key", valid_594244
  var valid_594245 = query.getOrDefault("prettyPrint")
  valid_594245 = validateParameter(valid_594245, JBool, required = false,
                                 default = newJBool(true))
  if valid_594245 != nil:
    section.add "prettyPrint", valid_594245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594246: Call_GamesScoresList_594230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the scores in a leaderboard, starting from the top.
  ## 
  let valid = call_594246.validator(path, query, header, formData, body)
  let scheme = call_594246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594246.url(scheme.get, call_594246.host, call_594246.base,
                         call_594246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594246, url, valid)

proc call*(call_594247: Call_GamesScoresList_594230; leaderboardId: string;
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
  var path_594248 = newJObject()
  var query_594249 = newJObject()
  add(query_594249, "fields", newJString(fields))
  add(query_594249, "pageToken", newJString(pageToken))
  add(query_594249, "quotaUser", newJString(quotaUser))
  add(query_594249, "alt", newJString(alt))
  add(query_594249, "language", newJString(language))
  add(path_594248, "leaderboardId", newJString(leaderboardId))
  add(query_594249, "oauth_token", newJString(oauthToken))
  add(path_594248, "collection", newJString(collection))
  add(query_594249, "userIp", newJString(userIp))
  add(query_594249, "maxResults", newJInt(maxResults))
  add(query_594249, "timeSpan", newJString(timeSpan))
  add(query_594249, "key", newJString(key))
  add(query_594249, "prettyPrint", newJBool(prettyPrint))
  result = call_594247.call(path_594248, query_594249, nil, nil, nil)

var gamesScoresList* = Call_GamesScoresList_594230(name: "gamesScoresList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/{collection}",
    validator: validate_GamesScoresList_594231, base: "/games/v1",
    url: url_GamesScoresList_594232, schemes: {Scheme.Https})
type
  Call_GamesScoresListWindow_594250 = ref object of OpenApiRestCall_593437
proc url_GamesScoresListWindow_594252(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesScoresListWindow_594251(path: JsonNode; query: JsonNode;
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
  var valid_594253 = path.getOrDefault("leaderboardId")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "leaderboardId", valid_594253
  var valid_594254 = path.getOrDefault("collection")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = newJString("PUBLIC"))
  if valid_594254 != nil:
    section.add "collection", valid_594254
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
  var valid_594255 = query.getOrDefault("fields")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "fields", valid_594255
  var valid_594256 = query.getOrDefault("pageToken")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "pageToken", valid_594256
  var valid_594257 = query.getOrDefault("quotaUser")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "quotaUser", valid_594257
  var valid_594258 = query.getOrDefault("alt")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = newJString("json"))
  if valid_594258 != nil:
    section.add "alt", valid_594258
  var valid_594259 = query.getOrDefault("language")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "language", valid_594259
  var valid_594260 = query.getOrDefault("oauth_token")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "oauth_token", valid_594260
  var valid_594261 = query.getOrDefault("userIp")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "userIp", valid_594261
  var valid_594262 = query.getOrDefault("resultsAbove")
  valid_594262 = validateParameter(valid_594262, JInt, required = false, default = nil)
  if valid_594262 != nil:
    section.add "resultsAbove", valid_594262
  var valid_594263 = query.getOrDefault("maxResults")
  valid_594263 = validateParameter(valid_594263, JInt, required = false, default = nil)
  if valid_594263 != nil:
    section.add "maxResults", valid_594263
  assert query != nil,
        "query argument is necessary due to required `timeSpan` field"
  var valid_594264 = query.getOrDefault("timeSpan")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = newJString("ALL_TIME"))
  if valid_594264 != nil:
    section.add "timeSpan", valid_594264
  var valid_594265 = query.getOrDefault("key")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "key", valid_594265
  var valid_594266 = query.getOrDefault("prettyPrint")
  valid_594266 = validateParameter(valid_594266, JBool, required = false,
                                 default = newJBool(true))
  if valid_594266 != nil:
    section.add "prettyPrint", valid_594266
  var valid_594267 = query.getOrDefault("returnTopIfAbsent")
  valid_594267 = validateParameter(valid_594267, JBool, required = false, default = nil)
  if valid_594267 != nil:
    section.add "returnTopIfAbsent", valid_594267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594268: Call_GamesScoresListWindow_594250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the scores in a leaderboard around (and including) a player's score.
  ## 
  let valid = call_594268.validator(path, query, header, formData, body)
  let scheme = call_594268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594268.url(scheme.get, call_594268.host, call_594268.base,
                         call_594268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594268, url, valid)

proc call*(call_594269: Call_GamesScoresListWindow_594250; leaderboardId: string;
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
  var path_594270 = newJObject()
  var query_594271 = newJObject()
  add(query_594271, "fields", newJString(fields))
  add(query_594271, "pageToken", newJString(pageToken))
  add(query_594271, "quotaUser", newJString(quotaUser))
  add(query_594271, "alt", newJString(alt))
  add(query_594271, "language", newJString(language))
  add(path_594270, "leaderboardId", newJString(leaderboardId))
  add(query_594271, "oauth_token", newJString(oauthToken))
  add(path_594270, "collection", newJString(collection))
  add(query_594271, "userIp", newJString(userIp))
  add(query_594271, "resultsAbove", newJInt(resultsAbove))
  add(query_594271, "maxResults", newJInt(maxResults))
  add(query_594271, "timeSpan", newJString(timeSpan))
  add(query_594271, "key", newJString(key))
  add(query_594271, "prettyPrint", newJBool(prettyPrint))
  add(query_594271, "returnTopIfAbsent", newJBool(returnTopIfAbsent))
  result = call_594269.call(path_594270, query_594271, nil, nil, nil)

var gamesScoresListWindow* = Call_GamesScoresListWindow_594250(
    name: "gamesScoresListWindow", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/window/{collection}",
    validator: validate_GamesScoresListWindow_594251, base: "/games/v1",
    url: url_GamesScoresListWindow_594252, schemes: {Scheme.Https})
type
  Call_GamesMetagameGetMetagameConfig_594272 = ref object of OpenApiRestCall_593437
proc url_GamesMetagameGetMetagameConfig_594274(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesMetagameGetMetagameConfig_594273(path: JsonNode;
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
  var valid_594275 = query.getOrDefault("fields")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "fields", valid_594275
  var valid_594276 = query.getOrDefault("quotaUser")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "quotaUser", valid_594276
  var valid_594277 = query.getOrDefault("alt")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = newJString("json"))
  if valid_594277 != nil:
    section.add "alt", valid_594277
  var valid_594278 = query.getOrDefault("oauth_token")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "oauth_token", valid_594278
  var valid_594279 = query.getOrDefault("userIp")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "userIp", valid_594279
  var valid_594280 = query.getOrDefault("key")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "key", valid_594280
  var valid_594281 = query.getOrDefault("prettyPrint")
  valid_594281 = validateParameter(valid_594281, JBool, required = false,
                                 default = newJBool(true))
  if valid_594281 != nil:
    section.add "prettyPrint", valid_594281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594282: Call_GamesMetagameGetMetagameConfig_594272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the metagame configuration data for the calling application.
  ## 
  let valid = call_594282.validator(path, query, header, formData, body)
  let scheme = call_594282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594282.url(scheme.get, call_594282.host, call_594282.base,
                         call_594282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594282, url, valid)

proc call*(call_594283: Call_GamesMetagameGetMetagameConfig_594272;
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
  var query_594284 = newJObject()
  add(query_594284, "fields", newJString(fields))
  add(query_594284, "quotaUser", newJString(quotaUser))
  add(query_594284, "alt", newJString(alt))
  add(query_594284, "oauth_token", newJString(oauthToken))
  add(query_594284, "userIp", newJString(userIp))
  add(query_594284, "key", newJString(key))
  add(query_594284, "prettyPrint", newJBool(prettyPrint))
  result = call_594283.call(nil, query_594284, nil, nil, nil)

var gamesMetagameGetMetagameConfig* = Call_GamesMetagameGetMetagameConfig_594272(
    name: "gamesMetagameGetMetagameConfig", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metagameConfig",
    validator: validate_GamesMetagameGetMetagameConfig_594273, base: "/games/v1",
    url: url_GamesMetagameGetMetagameConfig_594274, schemes: {Scheme.Https})
type
  Call_GamesPlayersList_594285 = ref object of OpenApiRestCall_593437
proc url_GamesPlayersList_594287(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "collection" in path, "`collection` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/players/me/players/"),
               (kind: VariableSegment, value: "collection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesPlayersList_594286(path: JsonNode; query: JsonNode;
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
  var valid_594288 = path.getOrDefault("collection")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = newJString("connected"))
  if valid_594288 != nil:
    section.add "collection", valid_594288
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
  var valid_594289 = query.getOrDefault("fields")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "fields", valid_594289
  var valid_594290 = query.getOrDefault("pageToken")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "pageToken", valid_594290
  var valid_594291 = query.getOrDefault("quotaUser")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "quotaUser", valid_594291
  var valid_594292 = query.getOrDefault("alt")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = newJString("json"))
  if valid_594292 != nil:
    section.add "alt", valid_594292
  var valid_594293 = query.getOrDefault("language")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "language", valid_594293
  var valid_594294 = query.getOrDefault("oauth_token")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "oauth_token", valid_594294
  var valid_594295 = query.getOrDefault("userIp")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "userIp", valid_594295
  var valid_594296 = query.getOrDefault("maxResults")
  valid_594296 = validateParameter(valid_594296, JInt, required = false, default = nil)
  if valid_594296 != nil:
    section.add "maxResults", valid_594296
  var valid_594297 = query.getOrDefault("key")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "key", valid_594297
  var valid_594298 = query.getOrDefault("prettyPrint")
  valid_594298 = validateParameter(valid_594298, JBool, required = false,
                                 default = newJBool(true))
  if valid_594298 != nil:
    section.add "prettyPrint", valid_594298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594299: Call_GamesPlayersList_594285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the collection of players for the currently authenticated user.
  ## 
  let valid = call_594299.validator(path, query, header, formData, body)
  let scheme = call_594299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594299.url(scheme.get, call_594299.host, call_594299.base,
                         call_594299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594299, url, valid)

proc call*(call_594300: Call_GamesPlayersList_594285; fields: string = "";
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
  var path_594301 = newJObject()
  var query_594302 = newJObject()
  add(query_594302, "fields", newJString(fields))
  add(query_594302, "pageToken", newJString(pageToken))
  add(query_594302, "quotaUser", newJString(quotaUser))
  add(query_594302, "alt", newJString(alt))
  add(query_594302, "language", newJString(language))
  add(query_594302, "oauth_token", newJString(oauthToken))
  add(path_594301, "collection", newJString(collection))
  add(query_594302, "userIp", newJString(userIp))
  add(query_594302, "maxResults", newJInt(maxResults))
  add(query_594302, "key", newJString(key))
  add(query_594302, "prettyPrint", newJBool(prettyPrint))
  result = call_594300.call(path_594301, query_594302, nil, nil, nil)

var gamesPlayersList* = Call_GamesPlayersList_594285(name: "gamesPlayersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/me/players/{collection}",
    validator: validate_GamesPlayersList_594286, base: "/games/v1",
    url: url_GamesPlayersList_594287, schemes: {Scheme.Https})
type
  Call_GamesPlayersGet_594303 = ref object of OpenApiRestCall_593437
proc url_GamesPlayersGet_594305(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "playerId" in path, "`playerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/players/"),
               (kind: VariableSegment, value: "playerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesPlayersGet_594304(path: JsonNode; query: JsonNode;
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
  var valid_594306 = path.getOrDefault("playerId")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "playerId", valid_594306
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
  var valid_594307 = query.getOrDefault("fields")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "fields", valid_594307
  var valid_594308 = query.getOrDefault("quotaUser")
  valid_594308 = validateParameter(valid_594308, JString, required = false,
                                 default = nil)
  if valid_594308 != nil:
    section.add "quotaUser", valid_594308
  var valid_594309 = query.getOrDefault("alt")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = newJString("json"))
  if valid_594309 != nil:
    section.add "alt", valid_594309
  var valid_594310 = query.getOrDefault("language")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "language", valid_594310
  var valid_594311 = query.getOrDefault("oauth_token")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "oauth_token", valid_594311
  var valid_594312 = query.getOrDefault("userIp")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "userIp", valid_594312
  var valid_594313 = query.getOrDefault("key")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "key", valid_594313
  var valid_594314 = query.getOrDefault("prettyPrint")
  valid_594314 = validateParameter(valid_594314, JBool, required = false,
                                 default = newJBool(true))
  if valid_594314 != nil:
    section.add "prettyPrint", valid_594314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594315: Call_GamesPlayersGet_594303; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the Player resource with the given ID. To retrieve the player for the currently authenticated user, set playerId to me.
  ## 
  let valid = call_594315.validator(path, query, header, formData, body)
  let scheme = call_594315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594315.url(scheme.get, call_594315.host, call_594315.base,
                         call_594315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594315, url, valid)

proc call*(call_594316: Call_GamesPlayersGet_594303; playerId: string;
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
  var path_594317 = newJObject()
  var query_594318 = newJObject()
  add(query_594318, "fields", newJString(fields))
  add(query_594318, "quotaUser", newJString(quotaUser))
  add(query_594318, "alt", newJString(alt))
  add(query_594318, "language", newJString(language))
  add(query_594318, "oauth_token", newJString(oauthToken))
  add(path_594317, "playerId", newJString(playerId))
  add(query_594318, "userIp", newJString(userIp))
  add(query_594318, "key", newJString(key))
  add(query_594318, "prettyPrint", newJBool(prettyPrint))
  result = call_594316.call(path_594317, query_594318, nil, nil, nil)

var gamesPlayersGet* = Call_GamesPlayersGet_594303(name: "gamesPlayersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/{playerId}", validator: validate_GamesPlayersGet_594304,
    base: "/games/v1", url: url_GamesPlayersGet_594305, schemes: {Scheme.Https})
type
  Call_GamesAchievementsList_594319 = ref object of OpenApiRestCall_593437
proc url_GamesAchievementsList_594321(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesAchievementsList_594320(path: JsonNode; query: JsonNode;
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
  var valid_594322 = path.getOrDefault("playerId")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "playerId", valid_594322
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
  var valid_594323 = query.getOrDefault("fields")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "fields", valid_594323
  var valid_594324 = query.getOrDefault("pageToken")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "pageToken", valid_594324
  var valid_594325 = query.getOrDefault("quotaUser")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "quotaUser", valid_594325
  var valid_594326 = query.getOrDefault("alt")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = newJString("json"))
  if valid_594326 != nil:
    section.add "alt", valid_594326
  var valid_594327 = query.getOrDefault("language")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "language", valid_594327
  var valid_594328 = query.getOrDefault("oauth_token")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "oauth_token", valid_594328
  var valid_594329 = query.getOrDefault("userIp")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "userIp", valid_594329
  var valid_594330 = query.getOrDefault("maxResults")
  valid_594330 = validateParameter(valid_594330, JInt, required = false, default = nil)
  if valid_594330 != nil:
    section.add "maxResults", valid_594330
  var valid_594331 = query.getOrDefault("key")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = nil)
  if valid_594331 != nil:
    section.add "key", valid_594331
  var valid_594332 = query.getOrDefault("prettyPrint")
  valid_594332 = validateParameter(valid_594332, JBool, required = false,
                                 default = newJBool(true))
  if valid_594332 != nil:
    section.add "prettyPrint", valid_594332
  var valid_594333 = query.getOrDefault("state")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = newJString("ALL"))
  if valid_594333 != nil:
    section.add "state", valid_594333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594334: Call_GamesAchievementsList_594319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the progress for all your application's achievements for the currently authenticated player.
  ## 
  let valid = call_594334.validator(path, query, header, formData, body)
  let scheme = call_594334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594334.url(scheme.get, call_594334.host, call_594334.base,
                         call_594334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594334, url, valid)

proc call*(call_594335: Call_GamesAchievementsList_594319; playerId: string;
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
  var path_594336 = newJObject()
  var query_594337 = newJObject()
  add(query_594337, "fields", newJString(fields))
  add(query_594337, "pageToken", newJString(pageToken))
  add(query_594337, "quotaUser", newJString(quotaUser))
  add(query_594337, "alt", newJString(alt))
  add(query_594337, "language", newJString(language))
  add(query_594337, "oauth_token", newJString(oauthToken))
  add(path_594336, "playerId", newJString(playerId))
  add(query_594337, "userIp", newJString(userIp))
  add(query_594337, "maxResults", newJInt(maxResults))
  add(query_594337, "key", newJString(key))
  add(query_594337, "prettyPrint", newJBool(prettyPrint))
  add(query_594337, "state", newJString(state))
  result = call_594335.call(path_594336, query_594337, nil, nil, nil)

var gamesAchievementsList* = Call_GamesAchievementsList_594319(
    name: "gamesAchievementsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/players/{playerId}/achievements",
    validator: validate_GamesAchievementsList_594320, base: "/games/v1",
    url: url_GamesAchievementsList_594321, schemes: {Scheme.Https})
type
  Call_GamesMetagameListCategoriesByPlayer_594338 = ref object of OpenApiRestCall_593437
proc url_GamesMetagameListCategoriesByPlayer_594340(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesMetagameListCategoriesByPlayer_594339(path: JsonNode;
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
  var valid_594341 = path.getOrDefault("collection")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = newJString("all"))
  if valid_594341 != nil:
    section.add "collection", valid_594341
  var valid_594342 = path.getOrDefault("playerId")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "playerId", valid_594342
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
  var valid_594343 = query.getOrDefault("fields")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "fields", valid_594343
  var valid_594344 = query.getOrDefault("pageToken")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "pageToken", valid_594344
  var valid_594345 = query.getOrDefault("quotaUser")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "quotaUser", valid_594345
  var valid_594346 = query.getOrDefault("alt")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = newJString("json"))
  if valid_594346 != nil:
    section.add "alt", valid_594346
  var valid_594347 = query.getOrDefault("language")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = nil)
  if valid_594347 != nil:
    section.add "language", valid_594347
  var valid_594348 = query.getOrDefault("oauth_token")
  valid_594348 = validateParameter(valid_594348, JString, required = false,
                                 default = nil)
  if valid_594348 != nil:
    section.add "oauth_token", valid_594348
  var valid_594349 = query.getOrDefault("userIp")
  valid_594349 = validateParameter(valid_594349, JString, required = false,
                                 default = nil)
  if valid_594349 != nil:
    section.add "userIp", valid_594349
  var valid_594350 = query.getOrDefault("maxResults")
  valid_594350 = validateParameter(valid_594350, JInt, required = false, default = nil)
  if valid_594350 != nil:
    section.add "maxResults", valid_594350
  var valid_594351 = query.getOrDefault("key")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "key", valid_594351
  var valid_594352 = query.getOrDefault("prettyPrint")
  valid_594352 = validateParameter(valid_594352, JBool, required = false,
                                 default = newJBool(true))
  if valid_594352 != nil:
    section.add "prettyPrint", valid_594352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594353: Call_GamesMetagameListCategoriesByPlayer_594338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List play data aggregated per category for the player corresponding to playerId.
  ## 
  let valid = call_594353.validator(path, query, header, formData, body)
  let scheme = call_594353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594353.url(scheme.get, call_594353.host, call_594353.base,
                         call_594353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594353, url, valid)

proc call*(call_594354: Call_GamesMetagameListCategoriesByPlayer_594338;
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
  var path_594355 = newJObject()
  var query_594356 = newJObject()
  add(query_594356, "fields", newJString(fields))
  add(query_594356, "pageToken", newJString(pageToken))
  add(query_594356, "quotaUser", newJString(quotaUser))
  add(query_594356, "alt", newJString(alt))
  add(query_594356, "language", newJString(language))
  add(query_594356, "oauth_token", newJString(oauthToken))
  add(path_594355, "collection", newJString(collection))
  add(path_594355, "playerId", newJString(playerId))
  add(query_594356, "userIp", newJString(userIp))
  add(query_594356, "maxResults", newJInt(maxResults))
  add(query_594356, "key", newJString(key))
  add(query_594356, "prettyPrint", newJBool(prettyPrint))
  result = call_594354.call(path_594355, query_594356, nil, nil, nil)

var gamesMetagameListCategoriesByPlayer* = Call_GamesMetagameListCategoriesByPlayer_594338(
    name: "gamesMetagameListCategoriesByPlayer", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/players/{playerId}/categories/{collection}",
    validator: validate_GamesMetagameListCategoriesByPlayer_594339,
    base: "/games/v1", url: url_GamesMetagameListCategoriesByPlayer_594340,
    schemes: {Scheme.Https})
type
  Call_GamesScoresGet_594357 = ref object of OpenApiRestCall_593437
proc url_GamesScoresGet_594359(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesScoresGet_594358(path: JsonNode; query: JsonNode;
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
  var valid_594360 = path.getOrDefault("timeSpan")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = newJString("ALL"))
  if valid_594360 != nil:
    section.add "timeSpan", valid_594360
  var valid_594361 = path.getOrDefault("leaderboardId")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "leaderboardId", valid_594361
  var valid_594362 = path.getOrDefault("playerId")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "playerId", valid_594362
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
  var valid_594363 = query.getOrDefault("fields")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "fields", valid_594363
  var valid_594364 = query.getOrDefault("pageToken")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "pageToken", valid_594364
  var valid_594365 = query.getOrDefault("quotaUser")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "quotaUser", valid_594365
  var valid_594366 = query.getOrDefault("alt")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = newJString("json"))
  if valid_594366 != nil:
    section.add "alt", valid_594366
  var valid_594367 = query.getOrDefault("language")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "language", valid_594367
  var valid_594368 = query.getOrDefault("includeRankType")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = newJString("ALL"))
  if valid_594368 != nil:
    section.add "includeRankType", valid_594368
  var valid_594369 = query.getOrDefault("oauth_token")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = nil)
  if valid_594369 != nil:
    section.add "oauth_token", valid_594369
  var valid_594370 = query.getOrDefault("userIp")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = nil)
  if valid_594370 != nil:
    section.add "userIp", valid_594370
  var valid_594371 = query.getOrDefault("maxResults")
  valid_594371 = validateParameter(valid_594371, JInt, required = false, default = nil)
  if valid_594371 != nil:
    section.add "maxResults", valid_594371
  var valid_594372 = query.getOrDefault("key")
  valid_594372 = validateParameter(valid_594372, JString, required = false,
                                 default = nil)
  if valid_594372 != nil:
    section.add "key", valid_594372
  var valid_594373 = query.getOrDefault("prettyPrint")
  valid_594373 = validateParameter(valid_594373, JBool, required = false,
                                 default = newJBool(true))
  if valid_594373 != nil:
    section.add "prettyPrint", valid_594373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594374: Call_GamesScoresGet_594357; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get high scores, and optionally ranks, in leaderboards for the currently authenticated player. For a specific time span, leaderboardId can be set to ALL to retrieve data for all leaderboards in a given time span.
  ## NOTE: You cannot ask for 'ALL' leaderboards and 'ALL' timeSpans in the same request; only one parameter may be set to 'ALL'.
  ## 
  let valid = call_594374.validator(path, query, header, formData, body)
  let scheme = call_594374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594374.url(scheme.get, call_594374.host, call_594374.base,
                         call_594374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594374, url, valid)

proc call*(call_594375: Call_GamesScoresGet_594357; leaderboardId: string;
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
  var path_594376 = newJObject()
  var query_594377 = newJObject()
  add(path_594376, "timeSpan", newJString(timeSpan))
  add(query_594377, "fields", newJString(fields))
  add(query_594377, "pageToken", newJString(pageToken))
  add(query_594377, "quotaUser", newJString(quotaUser))
  add(query_594377, "alt", newJString(alt))
  add(query_594377, "language", newJString(language))
  add(query_594377, "includeRankType", newJString(includeRankType))
  add(path_594376, "leaderboardId", newJString(leaderboardId))
  add(query_594377, "oauth_token", newJString(oauthToken))
  add(path_594376, "playerId", newJString(playerId))
  add(query_594377, "userIp", newJString(userIp))
  add(query_594377, "maxResults", newJInt(maxResults))
  add(query_594377, "key", newJString(key))
  add(query_594377, "prettyPrint", newJBool(prettyPrint))
  result = call_594375.call(path_594376, query_594377, nil, nil, nil)

var gamesScoresGet* = Call_GamesScoresGet_594357(name: "gamesScoresGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/players/{playerId}/leaderboards/{leaderboardId}/scores/{timeSpan}",
    validator: validate_GamesScoresGet_594358, base: "/games/v1",
    url: url_GamesScoresGet_594359, schemes: {Scheme.Https})
type
  Call_GamesQuestsList_594378 = ref object of OpenApiRestCall_593437
proc url_GamesQuestsList_594380(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesQuestsList_594379(path: JsonNode; query: JsonNode;
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
  var valid_594381 = path.getOrDefault("playerId")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "playerId", valid_594381
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
  var valid_594382 = query.getOrDefault("fields")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "fields", valid_594382
  var valid_594383 = query.getOrDefault("pageToken")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "pageToken", valid_594383
  var valid_594384 = query.getOrDefault("quotaUser")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "quotaUser", valid_594384
  var valid_594385 = query.getOrDefault("alt")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = newJString("json"))
  if valid_594385 != nil:
    section.add "alt", valid_594385
  var valid_594386 = query.getOrDefault("language")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = nil)
  if valid_594386 != nil:
    section.add "language", valid_594386
  var valid_594387 = query.getOrDefault("oauth_token")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = nil)
  if valid_594387 != nil:
    section.add "oauth_token", valid_594387
  var valid_594388 = query.getOrDefault("userIp")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "userIp", valid_594388
  var valid_594389 = query.getOrDefault("maxResults")
  valid_594389 = validateParameter(valid_594389, JInt, required = false, default = nil)
  if valid_594389 != nil:
    section.add "maxResults", valid_594389
  var valid_594390 = query.getOrDefault("key")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = nil)
  if valid_594390 != nil:
    section.add "key", valid_594390
  var valid_594391 = query.getOrDefault("prettyPrint")
  valid_594391 = validateParameter(valid_594391, JBool, required = false,
                                 default = newJBool(true))
  if valid_594391 != nil:
    section.add "prettyPrint", valid_594391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594392: Call_GamesQuestsList_594378; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of quests for your application and the currently authenticated player.
  ## 
  let valid = call_594392.validator(path, query, header, formData, body)
  let scheme = call_594392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594392.url(scheme.get, call_594392.host, call_594392.base,
                         call_594392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594392, url, valid)

proc call*(call_594393: Call_GamesQuestsList_594378; playerId: string;
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
  var path_594394 = newJObject()
  var query_594395 = newJObject()
  add(query_594395, "fields", newJString(fields))
  add(query_594395, "pageToken", newJString(pageToken))
  add(query_594395, "quotaUser", newJString(quotaUser))
  add(query_594395, "alt", newJString(alt))
  add(query_594395, "language", newJString(language))
  add(query_594395, "oauth_token", newJString(oauthToken))
  add(path_594394, "playerId", newJString(playerId))
  add(query_594395, "userIp", newJString(userIp))
  add(query_594395, "maxResults", newJInt(maxResults))
  add(query_594395, "key", newJString(key))
  add(query_594395, "prettyPrint", newJBool(prettyPrint))
  result = call_594393.call(path_594394, query_594395, nil, nil, nil)

var gamesQuestsList* = Call_GamesQuestsList_594378(name: "gamesQuestsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/players/{playerId}/quests", validator: validate_GamesQuestsList_594379,
    base: "/games/v1", url: url_GamesQuestsList_594380, schemes: {Scheme.Https})
type
  Call_GamesSnapshotsList_594396 = ref object of OpenApiRestCall_593437
proc url_GamesSnapshotsList_594398(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesSnapshotsList_594397(path: JsonNode; query: JsonNode;
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
  var valid_594399 = path.getOrDefault("playerId")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "playerId", valid_594399
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
  var valid_594400 = query.getOrDefault("fields")
  valid_594400 = validateParameter(valid_594400, JString, required = false,
                                 default = nil)
  if valid_594400 != nil:
    section.add "fields", valid_594400
  var valid_594401 = query.getOrDefault("pageToken")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "pageToken", valid_594401
  var valid_594402 = query.getOrDefault("quotaUser")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "quotaUser", valid_594402
  var valid_594403 = query.getOrDefault("alt")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = newJString("json"))
  if valid_594403 != nil:
    section.add "alt", valid_594403
  var valid_594404 = query.getOrDefault("language")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = nil)
  if valid_594404 != nil:
    section.add "language", valid_594404
  var valid_594405 = query.getOrDefault("oauth_token")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = nil)
  if valid_594405 != nil:
    section.add "oauth_token", valid_594405
  var valid_594406 = query.getOrDefault("userIp")
  valid_594406 = validateParameter(valid_594406, JString, required = false,
                                 default = nil)
  if valid_594406 != nil:
    section.add "userIp", valid_594406
  var valid_594407 = query.getOrDefault("maxResults")
  valid_594407 = validateParameter(valid_594407, JInt, required = false, default = nil)
  if valid_594407 != nil:
    section.add "maxResults", valid_594407
  var valid_594408 = query.getOrDefault("key")
  valid_594408 = validateParameter(valid_594408, JString, required = false,
                                 default = nil)
  if valid_594408 != nil:
    section.add "key", valid_594408
  var valid_594409 = query.getOrDefault("prettyPrint")
  valid_594409 = validateParameter(valid_594409, JBool, required = false,
                                 default = newJBool(true))
  if valid_594409 != nil:
    section.add "prettyPrint", valid_594409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594410: Call_GamesSnapshotsList_594396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of snapshots created by your application for the player corresponding to the player ID.
  ## 
  let valid = call_594410.validator(path, query, header, formData, body)
  let scheme = call_594410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594410.url(scheme.get, call_594410.host, call_594410.base,
                         call_594410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594410, url, valid)

proc call*(call_594411: Call_GamesSnapshotsList_594396; playerId: string;
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
  var path_594412 = newJObject()
  var query_594413 = newJObject()
  add(query_594413, "fields", newJString(fields))
  add(query_594413, "pageToken", newJString(pageToken))
  add(query_594413, "quotaUser", newJString(quotaUser))
  add(query_594413, "alt", newJString(alt))
  add(query_594413, "language", newJString(language))
  add(query_594413, "oauth_token", newJString(oauthToken))
  add(path_594412, "playerId", newJString(playerId))
  add(query_594413, "userIp", newJString(userIp))
  add(query_594413, "maxResults", newJInt(maxResults))
  add(query_594413, "key", newJString(key))
  add(query_594413, "prettyPrint", newJBool(prettyPrint))
  result = call_594411.call(path_594412, query_594413, nil, nil, nil)

var gamesSnapshotsList* = Call_GamesSnapshotsList_594396(
    name: "gamesSnapshotsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/players/{playerId}/snapshots",
    validator: validate_GamesSnapshotsList_594397, base: "/games/v1",
    url: url_GamesSnapshotsList_594398, schemes: {Scheme.Https})
type
  Call_GamesPushtokensUpdate_594414 = ref object of OpenApiRestCall_593437
proc url_GamesPushtokensUpdate_594416(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesPushtokensUpdate_594415(path: JsonNode; query: JsonNode;
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
  var valid_594417 = query.getOrDefault("fields")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "fields", valid_594417
  var valid_594418 = query.getOrDefault("quotaUser")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "quotaUser", valid_594418
  var valid_594419 = query.getOrDefault("alt")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = newJString("json"))
  if valid_594419 != nil:
    section.add "alt", valid_594419
  var valid_594420 = query.getOrDefault("oauth_token")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = nil)
  if valid_594420 != nil:
    section.add "oauth_token", valid_594420
  var valid_594421 = query.getOrDefault("userIp")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "userIp", valid_594421
  var valid_594422 = query.getOrDefault("key")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "key", valid_594422
  var valid_594423 = query.getOrDefault("prettyPrint")
  valid_594423 = validateParameter(valid_594423, JBool, required = false,
                                 default = newJBool(true))
  if valid_594423 != nil:
    section.add "prettyPrint", valid_594423
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

proc call*(call_594425: Call_GamesPushtokensUpdate_594414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a push token for the current user and application.
  ## 
  let valid = call_594425.validator(path, query, header, formData, body)
  let scheme = call_594425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594425.url(scheme.get, call_594425.host, call_594425.base,
                         call_594425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594425, url, valid)

proc call*(call_594426: Call_GamesPushtokensUpdate_594414; fields: string = "";
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
  var query_594427 = newJObject()
  var body_594428 = newJObject()
  add(query_594427, "fields", newJString(fields))
  add(query_594427, "quotaUser", newJString(quotaUser))
  add(query_594427, "alt", newJString(alt))
  add(query_594427, "oauth_token", newJString(oauthToken))
  add(query_594427, "userIp", newJString(userIp))
  add(query_594427, "key", newJString(key))
  if body != nil:
    body_594428 = body
  add(query_594427, "prettyPrint", newJBool(prettyPrint))
  result = call_594426.call(nil, query_594427, nil, nil, body_594428)

var gamesPushtokensUpdate* = Call_GamesPushtokensUpdate_594414(
    name: "gamesPushtokensUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/pushtokens",
    validator: validate_GamesPushtokensUpdate_594415, base: "/games/v1",
    url: url_GamesPushtokensUpdate_594416, schemes: {Scheme.Https})
type
  Call_GamesPushtokensRemove_594429 = ref object of OpenApiRestCall_593437
proc url_GamesPushtokensRemove_594431(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesPushtokensRemove_594430(path: JsonNode; query: JsonNode;
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
  var valid_594432 = query.getOrDefault("fields")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "fields", valid_594432
  var valid_594433 = query.getOrDefault("quotaUser")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = nil)
  if valid_594433 != nil:
    section.add "quotaUser", valid_594433
  var valid_594434 = query.getOrDefault("alt")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = newJString("json"))
  if valid_594434 != nil:
    section.add "alt", valid_594434
  var valid_594435 = query.getOrDefault("oauth_token")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = nil)
  if valid_594435 != nil:
    section.add "oauth_token", valid_594435
  var valid_594436 = query.getOrDefault("userIp")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "userIp", valid_594436
  var valid_594437 = query.getOrDefault("key")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = nil)
  if valid_594437 != nil:
    section.add "key", valid_594437
  var valid_594438 = query.getOrDefault("prettyPrint")
  valid_594438 = validateParameter(valid_594438, JBool, required = false,
                                 default = newJBool(true))
  if valid_594438 != nil:
    section.add "prettyPrint", valid_594438
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

proc call*(call_594440: Call_GamesPushtokensRemove_594429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a push token for the current user and application. Removing a non-existent push token will report success.
  ## 
  let valid = call_594440.validator(path, query, header, formData, body)
  let scheme = call_594440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594440.url(scheme.get, call_594440.host, call_594440.base,
                         call_594440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594440, url, valid)

proc call*(call_594441: Call_GamesPushtokensRemove_594429; fields: string = "";
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
  var query_594442 = newJObject()
  var body_594443 = newJObject()
  add(query_594442, "fields", newJString(fields))
  add(query_594442, "quotaUser", newJString(quotaUser))
  add(query_594442, "alt", newJString(alt))
  add(query_594442, "oauth_token", newJString(oauthToken))
  add(query_594442, "userIp", newJString(userIp))
  add(query_594442, "key", newJString(key))
  if body != nil:
    body_594443 = body
  add(query_594442, "prettyPrint", newJBool(prettyPrint))
  result = call_594441.call(nil, query_594442, nil, nil, body_594443)

var gamesPushtokensRemove* = Call_GamesPushtokensRemove_594429(
    name: "gamesPushtokensRemove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/pushtokens/remove",
    validator: validate_GamesPushtokensRemove_594430, base: "/games/v1",
    url: url_GamesPushtokensRemove_594431, schemes: {Scheme.Https})
type
  Call_GamesQuestsAccept_594444 = ref object of OpenApiRestCall_593437
proc url_GamesQuestsAccept_594446(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesQuestsAccept_594445(path: JsonNode; query: JsonNode;
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
  var valid_594447 = path.getOrDefault("questId")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "questId", valid_594447
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
  var valid_594448 = query.getOrDefault("fields")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = nil)
  if valid_594448 != nil:
    section.add "fields", valid_594448
  var valid_594449 = query.getOrDefault("quotaUser")
  valid_594449 = validateParameter(valid_594449, JString, required = false,
                                 default = nil)
  if valid_594449 != nil:
    section.add "quotaUser", valid_594449
  var valid_594450 = query.getOrDefault("alt")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = newJString("json"))
  if valid_594450 != nil:
    section.add "alt", valid_594450
  var valid_594451 = query.getOrDefault("language")
  valid_594451 = validateParameter(valid_594451, JString, required = false,
                                 default = nil)
  if valid_594451 != nil:
    section.add "language", valid_594451
  var valid_594452 = query.getOrDefault("oauth_token")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "oauth_token", valid_594452
  var valid_594453 = query.getOrDefault("userIp")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "userIp", valid_594453
  var valid_594454 = query.getOrDefault("key")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "key", valid_594454
  var valid_594455 = query.getOrDefault("prettyPrint")
  valid_594455 = validateParameter(valid_594455, JBool, required = false,
                                 default = newJBool(true))
  if valid_594455 != nil:
    section.add "prettyPrint", valid_594455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594456: Call_GamesQuestsAccept_594444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates that the currently authorized user will participate in the quest.
  ## 
  let valid = call_594456.validator(path, query, header, formData, body)
  let scheme = call_594456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594456.url(scheme.get, call_594456.host, call_594456.base,
                         call_594456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594456, url, valid)

proc call*(call_594457: Call_GamesQuestsAccept_594444; questId: string;
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
  var path_594458 = newJObject()
  var query_594459 = newJObject()
  add(query_594459, "fields", newJString(fields))
  add(query_594459, "quotaUser", newJString(quotaUser))
  add(query_594459, "alt", newJString(alt))
  add(query_594459, "language", newJString(language))
  add(query_594459, "oauth_token", newJString(oauthToken))
  add(query_594459, "userIp", newJString(userIp))
  add(query_594459, "key", newJString(key))
  add(path_594458, "questId", newJString(questId))
  add(query_594459, "prettyPrint", newJBool(prettyPrint))
  result = call_594457.call(path_594458, query_594459, nil, nil, nil)

var gamesQuestsAccept* = Call_GamesQuestsAccept_594444(name: "gamesQuestsAccept",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/quests/{questId}/accept", validator: validate_GamesQuestsAccept_594445,
    base: "/games/v1", url: url_GamesQuestsAccept_594446, schemes: {Scheme.Https})
type
  Call_GamesQuestMilestonesClaim_594460 = ref object of OpenApiRestCall_593437
proc url_GamesQuestMilestonesClaim_594462(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesQuestMilestonesClaim_594461(path: JsonNode; query: JsonNode;
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
  var valid_594463 = path.getOrDefault("milestoneId")
  valid_594463 = validateParameter(valid_594463, JString, required = true,
                                 default = nil)
  if valid_594463 != nil:
    section.add "milestoneId", valid_594463
  var valid_594464 = path.getOrDefault("questId")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "questId", valid_594464
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
  var valid_594465 = query.getOrDefault("fields")
  valid_594465 = validateParameter(valid_594465, JString, required = false,
                                 default = nil)
  if valid_594465 != nil:
    section.add "fields", valid_594465
  assert query != nil,
        "query argument is necessary due to required `requestId` field"
  var valid_594466 = query.getOrDefault("requestId")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "requestId", valid_594466
  var valid_594467 = query.getOrDefault("quotaUser")
  valid_594467 = validateParameter(valid_594467, JString, required = false,
                                 default = nil)
  if valid_594467 != nil:
    section.add "quotaUser", valid_594467
  var valid_594468 = query.getOrDefault("alt")
  valid_594468 = validateParameter(valid_594468, JString, required = false,
                                 default = newJString("json"))
  if valid_594468 != nil:
    section.add "alt", valid_594468
  var valid_594469 = query.getOrDefault("oauth_token")
  valid_594469 = validateParameter(valid_594469, JString, required = false,
                                 default = nil)
  if valid_594469 != nil:
    section.add "oauth_token", valid_594469
  var valid_594470 = query.getOrDefault("userIp")
  valid_594470 = validateParameter(valid_594470, JString, required = false,
                                 default = nil)
  if valid_594470 != nil:
    section.add "userIp", valid_594470
  var valid_594471 = query.getOrDefault("key")
  valid_594471 = validateParameter(valid_594471, JString, required = false,
                                 default = nil)
  if valid_594471 != nil:
    section.add "key", valid_594471
  var valid_594472 = query.getOrDefault("prettyPrint")
  valid_594472 = validateParameter(valid_594472, JBool, required = false,
                                 default = newJBool(true))
  if valid_594472 != nil:
    section.add "prettyPrint", valid_594472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594473: Call_GamesQuestMilestonesClaim_594460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report that a reward for the milestone corresponding to milestoneId for the quest corresponding to questId has been claimed by the currently authorized user.
  ## 
  let valid = call_594473.validator(path, query, header, formData, body)
  let scheme = call_594473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594473.url(scheme.get, call_594473.host, call_594473.base,
                         call_594473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594473, url, valid)

proc call*(call_594474: Call_GamesQuestMilestonesClaim_594460; requestId: string;
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
  var path_594475 = newJObject()
  var query_594476 = newJObject()
  add(query_594476, "fields", newJString(fields))
  add(query_594476, "requestId", newJString(requestId))
  add(query_594476, "quotaUser", newJString(quotaUser))
  add(query_594476, "alt", newJString(alt))
  add(query_594476, "oauth_token", newJString(oauthToken))
  add(query_594476, "userIp", newJString(userIp))
  add(query_594476, "key", newJString(key))
  add(path_594475, "milestoneId", newJString(milestoneId))
  add(path_594475, "questId", newJString(questId))
  add(query_594476, "prettyPrint", newJBool(prettyPrint))
  result = call_594474.call(path_594475, query_594476, nil, nil, nil)

var gamesQuestMilestonesClaim* = Call_GamesQuestMilestonesClaim_594460(
    name: "gamesQuestMilestonesClaim", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/quests/{questId}/milestones/{milestoneId}/claim",
    validator: validate_GamesQuestMilestonesClaim_594461, base: "/games/v1",
    url: url_GamesQuestMilestonesClaim_594462, schemes: {Scheme.Https})
type
  Call_GamesRevisionsCheck_594477 = ref object of OpenApiRestCall_593437
proc url_GamesRevisionsCheck_594479(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesRevisionsCheck_594478(path: JsonNode; query: JsonNode;
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
  var valid_594480 = query.getOrDefault("fields")
  valid_594480 = validateParameter(valid_594480, JString, required = false,
                                 default = nil)
  if valid_594480 != nil:
    section.add "fields", valid_594480
  var valid_594481 = query.getOrDefault("quotaUser")
  valid_594481 = validateParameter(valid_594481, JString, required = false,
                                 default = nil)
  if valid_594481 != nil:
    section.add "quotaUser", valid_594481
  var valid_594482 = query.getOrDefault("alt")
  valid_594482 = validateParameter(valid_594482, JString, required = false,
                                 default = newJString("json"))
  if valid_594482 != nil:
    section.add "alt", valid_594482
  var valid_594483 = query.getOrDefault("oauth_token")
  valid_594483 = validateParameter(valid_594483, JString, required = false,
                                 default = nil)
  if valid_594483 != nil:
    section.add "oauth_token", valid_594483
  var valid_594484 = query.getOrDefault("userIp")
  valid_594484 = validateParameter(valid_594484, JString, required = false,
                                 default = nil)
  if valid_594484 != nil:
    section.add "userIp", valid_594484
  var valid_594485 = query.getOrDefault("key")
  valid_594485 = validateParameter(valid_594485, JString, required = false,
                                 default = nil)
  if valid_594485 != nil:
    section.add "key", valid_594485
  assert query != nil,
        "query argument is necessary due to required `clientRevision` field"
  var valid_594486 = query.getOrDefault("clientRevision")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "clientRevision", valid_594486
  var valid_594487 = query.getOrDefault("prettyPrint")
  valid_594487 = validateParameter(valid_594487, JBool, required = false,
                                 default = newJBool(true))
  if valid_594487 != nil:
    section.add "prettyPrint", valid_594487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594488: Call_GamesRevisionsCheck_594477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the games client is out of date.
  ## 
  let valid = call_594488.validator(path, query, header, formData, body)
  let scheme = call_594488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594488.url(scheme.get, call_594488.host, call_594488.base,
                         call_594488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594488, url, valid)

proc call*(call_594489: Call_GamesRevisionsCheck_594477; clientRevision: string;
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
  var query_594490 = newJObject()
  add(query_594490, "fields", newJString(fields))
  add(query_594490, "quotaUser", newJString(quotaUser))
  add(query_594490, "alt", newJString(alt))
  add(query_594490, "oauth_token", newJString(oauthToken))
  add(query_594490, "userIp", newJString(userIp))
  add(query_594490, "key", newJString(key))
  add(query_594490, "clientRevision", newJString(clientRevision))
  add(query_594490, "prettyPrint", newJBool(prettyPrint))
  result = call_594489.call(nil, query_594490, nil, nil, nil)

var gamesRevisionsCheck* = Call_GamesRevisionsCheck_594477(
    name: "gamesRevisionsCheck", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/revisions/check",
    validator: validate_GamesRevisionsCheck_594478, base: "/games/v1",
    url: url_GamesRevisionsCheck_594479, schemes: {Scheme.Https})
type
  Call_GamesRoomsList_594491 = ref object of OpenApiRestCall_593437
proc url_GamesRoomsList_594493(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesRoomsList_594492(path: JsonNode; query: JsonNode;
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
  var valid_594494 = query.getOrDefault("fields")
  valid_594494 = validateParameter(valid_594494, JString, required = false,
                                 default = nil)
  if valid_594494 != nil:
    section.add "fields", valid_594494
  var valid_594495 = query.getOrDefault("pageToken")
  valid_594495 = validateParameter(valid_594495, JString, required = false,
                                 default = nil)
  if valid_594495 != nil:
    section.add "pageToken", valid_594495
  var valid_594496 = query.getOrDefault("quotaUser")
  valid_594496 = validateParameter(valid_594496, JString, required = false,
                                 default = nil)
  if valid_594496 != nil:
    section.add "quotaUser", valid_594496
  var valid_594497 = query.getOrDefault("alt")
  valid_594497 = validateParameter(valid_594497, JString, required = false,
                                 default = newJString("json"))
  if valid_594497 != nil:
    section.add "alt", valid_594497
  var valid_594498 = query.getOrDefault("language")
  valid_594498 = validateParameter(valid_594498, JString, required = false,
                                 default = nil)
  if valid_594498 != nil:
    section.add "language", valid_594498
  var valid_594499 = query.getOrDefault("oauth_token")
  valid_594499 = validateParameter(valid_594499, JString, required = false,
                                 default = nil)
  if valid_594499 != nil:
    section.add "oauth_token", valid_594499
  var valid_594500 = query.getOrDefault("userIp")
  valid_594500 = validateParameter(valid_594500, JString, required = false,
                                 default = nil)
  if valid_594500 != nil:
    section.add "userIp", valid_594500
  var valid_594501 = query.getOrDefault("maxResults")
  valid_594501 = validateParameter(valid_594501, JInt, required = false, default = nil)
  if valid_594501 != nil:
    section.add "maxResults", valid_594501
  var valid_594502 = query.getOrDefault("key")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = nil)
  if valid_594502 != nil:
    section.add "key", valid_594502
  var valid_594503 = query.getOrDefault("prettyPrint")
  valid_594503 = validateParameter(valid_594503, JBool, required = false,
                                 default = newJBool(true))
  if valid_594503 != nil:
    section.add "prettyPrint", valid_594503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594504: Call_GamesRoomsList_594491; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns invitations to join rooms.
  ## 
  let valid = call_594504.validator(path, query, header, formData, body)
  let scheme = call_594504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594504.url(scheme.get, call_594504.host, call_594504.base,
                         call_594504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594504, url, valid)

proc call*(call_594505: Call_GamesRoomsList_594491; fields: string = "";
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
  var query_594506 = newJObject()
  add(query_594506, "fields", newJString(fields))
  add(query_594506, "pageToken", newJString(pageToken))
  add(query_594506, "quotaUser", newJString(quotaUser))
  add(query_594506, "alt", newJString(alt))
  add(query_594506, "language", newJString(language))
  add(query_594506, "oauth_token", newJString(oauthToken))
  add(query_594506, "userIp", newJString(userIp))
  add(query_594506, "maxResults", newJInt(maxResults))
  add(query_594506, "key", newJString(key))
  add(query_594506, "prettyPrint", newJBool(prettyPrint))
  result = call_594505.call(nil, query_594506, nil, nil, nil)

var gamesRoomsList* = Call_GamesRoomsList_594491(name: "gamesRoomsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/rooms",
    validator: validate_GamesRoomsList_594492, base: "/games/v1",
    url: url_GamesRoomsList_594493, schemes: {Scheme.Https})
type
  Call_GamesRoomsCreate_594507 = ref object of OpenApiRestCall_593437
proc url_GamesRoomsCreate_594509(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesRoomsCreate_594508(path: JsonNode; query: JsonNode;
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
  var valid_594510 = query.getOrDefault("fields")
  valid_594510 = validateParameter(valid_594510, JString, required = false,
                                 default = nil)
  if valid_594510 != nil:
    section.add "fields", valid_594510
  var valid_594511 = query.getOrDefault("quotaUser")
  valid_594511 = validateParameter(valid_594511, JString, required = false,
                                 default = nil)
  if valid_594511 != nil:
    section.add "quotaUser", valid_594511
  var valid_594512 = query.getOrDefault("alt")
  valid_594512 = validateParameter(valid_594512, JString, required = false,
                                 default = newJString("json"))
  if valid_594512 != nil:
    section.add "alt", valid_594512
  var valid_594513 = query.getOrDefault("language")
  valid_594513 = validateParameter(valid_594513, JString, required = false,
                                 default = nil)
  if valid_594513 != nil:
    section.add "language", valid_594513
  var valid_594514 = query.getOrDefault("oauth_token")
  valid_594514 = validateParameter(valid_594514, JString, required = false,
                                 default = nil)
  if valid_594514 != nil:
    section.add "oauth_token", valid_594514
  var valid_594515 = query.getOrDefault("userIp")
  valid_594515 = validateParameter(valid_594515, JString, required = false,
                                 default = nil)
  if valid_594515 != nil:
    section.add "userIp", valid_594515
  var valid_594516 = query.getOrDefault("key")
  valid_594516 = validateParameter(valid_594516, JString, required = false,
                                 default = nil)
  if valid_594516 != nil:
    section.add "key", valid_594516
  var valid_594517 = query.getOrDefault("prettyPrint")
  valid_594517 = validateParameter(valid_594517, JBool, required = false,
                                 default = newJBool(true))
  if valid_594517 != nil:
    section.add "prettyPrint", valid_594517
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

proc call*(call_594519: Call_GamesRoomsCreate_594507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_594519.validator(path, query, header, formData, body)
  let scheme = call_594519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594519.url(scheme.get, call_594519.host, call_594519.base,
                         call_594519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594519, url, valid)

proc call*(call_594520: Call_GamesRoomsCreate_594507; fields: string = "";
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
  var query_594521 = newJObject()
  var body_594522 = newJObject()
  add(query_594521, "fields", newJString(fields))
  add(query_594521, "quotaUser", newJString(quotaUser))
  add(query_594521, "alt", newJString(alt))
  add(query_594521, "language", newJString(language))
  add(query_594521, "oauth_token", newJString(oauthToken))
  add(query_594521, "userIp", newJString(userIp))
  add(query_594521, "key", newJString(key))
  if body != nil:
    body_594522 = body
  add(query_594521, "prettyPrint", newJBool(prettyPrint))
  result = call_594520.call(nil, query_594521, nil, nil, body_594522)

var gamesRoomsCreate* = Call_GamesRoomsCreate_594507(name: "gamesRoomsCreate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/rooms/create",
    validator: validate_GamesRoomsCreate_594508, base: "/games/v1",
    url: url_GamesRoomsCreate_594509, schemes: {Scheme.Https})
type
  Call_GamesRoomsGet_594523 = ref object of OpenApiRestCall_593437
proc url_GamesRoomsGet_594525(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "roomId" in path, "`roomId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/rooms/"),
               (kind: VariableSegment, value: "roomId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesRoomsGet_594524(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594526 = path.getOrDefault("roomId")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "roomId", valid_594526
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
  var valid_594527 = query.getOrDefault("fields")
  valid_594527 = validateParameter(valid_594527, JString, required = false,
                                 default = nil)
  if valid_594527 != nil:
    section.add "fields", valid_594527
  var valid_594528 = query.getOrDefault("quotaUser")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = nil)
  if valid_594528 != nil:
    section.add "quotaUser", valid_594528
  var valid_594529 = query.getOrDefault("alt")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = newJString("json"))
  if valid_594529 != nil:
    section.add "alt", valid_594529
  var valid_594530 = query.getOrDefault("language")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = nil)
  if valid_594530 != nil:
    section.add "language", valid_594530
  var valid_594531 = query.getOrDefault("oauth_token")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = nil)
  if valid_594531 != nil:
    section.add "oauth_token", valid_594531
  var valid_594532 = query.getOrDefault("userIp")
  valid_594532 = validateParameter(valid_594532, JString, required = false,
                                 default = nil)
  if valid_594532 != nil:
    section.add "userIp", valid_594532
  var valid_594533 = query.getOrDefault("key")
  valid_594533 = validateParameter(valid_594533, JString, required = false,
                                 default = nil)
  if valid_594533 != nil:
    section.add "key", valid_594533
  var valid_594534 = query.getOrDefault("prettyPrint")
  valid_594534 = validateParameter(valid_594534, JBool, required = false,
                                 default = newJBool(true))
  if valid_594534 != nil:
    section.add "prettyPrint", valid_594534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594535: Call_GamesRoomsGet_594523; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the data for a room.
  ## 
  let valid = call_594535.validator(path, query, header, formData, body)
  let scheme = call_594535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594535.url(scheme.get, call_594535.host, call_594535.base,
                         call_594535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594535, url, valid)

proc call*(call_594536: Call_GamesRoomsGet_594523; roomId: string;
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
  var path_594537 = newJObject()
  var query_594538 = newJObject()
  add(query_594538, "fields", newJString(fields))
  add(query_594538, "quotaUser", newJString(quotaUser))
  add(query_594538, "alt", newJString(alt))
  add(query_594538, "language", newJString(language))
  add(query_594538, "oauth_token", newJString(oauthToken))
  add(query_594538, "userIp", newJString(userIp))
  add(query_594538, "key", newJString(key))
  add(query_594538, "prettyPrint", newJBool(prettyPrint))
  add(path_594537, "roomId", newJString(roomId))
  result = call_594536.call(path_594537, query_594538, nil, nil, nil)

var gamesRoomsGet* = Call_GamesRoomsGet_594523(name: "gamesRoomsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/rooms/{roomId}",
    validator: validate_GamesRoomsGet_594524, base: "/games/v1",
    url: url_GamesRoomsGet_594525, schemes: {Scheme.Https})
type
  Call_GamesRoomsDecline_594539 = ref object of OpenApiRestCall_593437
proc url_GamesRoomsDecline_594541(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesRoomsDecline_594540(path: JsonNode; query: JsonNode;
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
  var valid_594542 = path.getOrDefault("roomId")
  valid_594542 = validateParameter(valid_594542, JString, required = true,
                                 default = nil)
  if valid_594542 != nil:
    section.add "roomId", valid_594542
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
  var valid_594543 = query.getOrDefault("fields")
  valid_594543 = validateParameter(valid_594543, JString, required = false,
                                 default = nil)
  if valid_594543 != nil:
    section.add "fields", valid_594543
  var valid_594544 = query.getOrDefault("quotaUser")
  valid_594544 = validateParameter(valid_594544, JString, required = false,
                                 default = nil)
  if valid_594544 != nil:
    section.add "quotaUser", valid_594544
  var valid_594545 = query.getOrDefault("alt")
  valid_594545 = validateParameter(valid_594545, JString, required = false,
                                 default = newJString("json"))
  if valid_594545 != nil:
    section.add "alt", valid_594545
  var valid_594546 = query.getOrDefault("language")
  valid_594546 = validateParameter(valid_594546, JString, required = false,
                                 default = nil)
  if valid_594546 != nil:
    section.add "language", valid_594546
  var valid_594547 = query.getOrDefault("oauth_token")
  valid_594547 = validateParameter(valid_594547, JString, required = false,
                                 default = nil)
  if valid_594547 != nil:
    section.add "oauth_token", valid_594547
  var valid_594548 = query.getOrDefault("userIp")
  valid_594548 = validateParameter(valid_594548, JString, required = false,
                                 default = nil)
  if valid_594548 != nil:
    section.add "userIp", valid_594548
  var valid_594549 = query.getOrDefault("key")
  valid_594549 = validateParameter(valid_594549, JString, required = false,
                                 default = nil)
  if valid_594549 != nil:
    section.add "key", valid_594549
  var valid_594550 = query.getOrDefault("prettyPrint")
  valid_594550 = validateParameter(valid_594550, JBool, required = false,
                                 default = newJBool(true))
  if valid_594550 != nil:
    section.add "prettyPrint", valid_594550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594551: Call_GamesRoomsDecline_594539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decline an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_594551.validator(path, query, header, formData, body)
  let scheme = call_594551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594551.url(scheme.get, call_594551.host, call_594551.base,
                         call_594551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594551, url, valid)

proc call*(call_594552: Call_GamesRoomsDecline_594539; roomId: string;
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
  var path_594553 = newJObject()
  var query_594554 = newJObject()
  add(query_594554, "fields", newJString(fields))
  add(query_594554, "quotaUser", newJString(quotaUser))
  add(query_594554, "alt", newJString(alt))
  add(query_594554, "language", newJString(language))
  add(query_594554, "oauth_token", newJString(oauthToken))
  add(query_594554, "userIp", newJString(userIp))
  add(query_594554, "key", newJString(key))
  add(query_594554, "prettyPrint", newJBool(prettyPrint))
  add(path_594553, "roomId", newJString(roomId))
  result = call_594552.call(path_594553, query_594554, nil, nil, nil)

var gamesRoomsDecline* = Call_GamesRoomsDecline_594539(name: "gamesRoomsDecline",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/decline", validator: validate_GamesRoomsDecline_594540,
    base: "/games/v1", url: url_GamesRoomsDecline_594541, schemes: {Scheme.Https})
type
  Call_GamesRoomsDismiss_594555 = ref object of OpenApiRestCall_593437
proc url_GamesRoomsDismiss_594557(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesRoomsDismiss_594556(path: JsonNode; query: JsonNode;
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
  var valid_594558 = path.getOrDefault("roomId")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "roomId", valid_594558
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
  var valid_594559 = query.getOrDefault("fields")
  valid_594559 = validateParameter(valid_594559, JString, required = false,
                                 default = nil)
  if valid_594559 != nil:
    section.add "fields", valid_594559
  var valid_594560 = query.getOrDefault("quotaUser")
  valid_594560 = validateParameter(valid_594560, JString, required = false,
                                 default = nil)
  if valid_594560 != nil:
    section.add "quotaUser", valid_594560
  var valid_594561 = query.getOrDefault("alt")
  valid_594561 = validateParameter(valid_594561, JString, required = false,
                                 default = newJString("json"))
  if valid_594561 != nil:
    section.add "alt", valid_594561
  var valid_594562 = query.getOrDefault("oauth_token")
  valid_594562 = validateParameter(valid_594562, JString, required = false,
                                 default = nil)
  if valid_594562 != nil:
    section.add "oauth_token", valid_594562
  var valid_594563 = query.getOrDefault("userIp")
  valid_594563 = validateParameter(valid_594563, JString, required = false,
                                 default = nil)
  if valid_594563 != nil:
    section.add "userIp", valid_594563
  var valid_594564 = query.getOrDefault("key")
  valid_594564 = validateParameter(valid_594564, JString, required = false,
                                 default = nil)
  if valid_594564 != nil:
    section.add "key", valid_594564
  var valid_594565 = query.getOrDefault("prettyPrint")
  valid_594565 = validateParameter(valid_594565, JBool, required = false,
                                 default = newJBool(true))
  if valid_594565 != nil:
    section.add "prettyPrint", valid_594565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594566: Call_GamesRoomsDismiss_594555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss an invitation to join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_594566.validator(path, query, header, formData, body)
  let scheme = call_594566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594566.url(scheme.get, call_594566.host, call_594566.base,
                         call_594566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594566, url, valid)

proc call*(call_594567: Call_GamesRoomsDismiss_594555; roomId: string;
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
  var path_594568 = newJObject()
  var query_594569 = newJObject()
  add(query_594569, "fields", newJString(fields))
  add(query_594569, "quotaUser", newJString(quotaUser))
  add(query_594569, "alt", newJString(alt))
  add(query_594569, "oauth_token", newJString(oauthToken))
  add(query_594569, "userIp", newJString(userIp))
  add(query_594569, "key", newJString(key))
  add(query_594569, "prettyPrint", newJBool(prettyPrint))
  add(path_594568, "roomId", newJString(roomId))
  result = call_594567.call(path_594568, query_594569, nil, nil, nil)

var gamesRoomsDismiss* = Call_GamesRoomsDismiss_594555(name: "gamesRoomsDismiss",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/dismiss", validator: validate_GamesRoomsDismiss_594556,
    base: "/games/v1", url: url_GamesRoomsDismiss_594557, schemes: {Scheme.Https})
type
  Call_GamesRoomsJoin_594570 = ref object of OpenApiRestCall_593437
proc url_GamesRoomsJoin_594572(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesRoomsJoin_594571(path: JsonNode; query: JsonNode;
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
  var valid_594573 = path.getOrDefault("roomId")
  valid_594573 = validateParameter(valid_594573, JString, required = true,
                                 default = nil)
  if valid_594573 != nil:
    section.add "roomId", valid_594573
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
  var valid_594574 = query.getOrDefault("fields")
  valid_594574 = validateParameter(valid_594574, JString, required = false,
                                 default = nil)
  if valid_594574 != nil:
    section.add "fields", valid_594574
  var valid_594575 = query.getOrDefault("quotaUser")
  valid_594575 = validateParameter(valid_594575, JString, required = false,
                                 default = nil)
  if valid_594575 != nil:
    section.add "quotaUser", valid_594575
  var valid_594576 = query.getOrDefault("alt")
  valid_594576 = validateParameter(valid_594576, JString, required = false,
                                 default = newJString("json"))
  if valid_594576 != nil:
    section.add "alt", valid_594576
  var valid_594577 = query.getOrDefault("language")
  valid_594577 = validateParameter(valid_594577, JString, required = false,
                                 default = nil)
  if valid_594577 != nil:
    section.add "language", valid_594577
  var valid_594578 = query.getOrDefault("oauth_token")
  valid_594578 = validateParameter(valid_594578, JString, required = false,
                                 default = nil)
  if valid_594578 != nil:
    section.add "oauth_token", valid_594578
  var valid_594579 = query.getOrDefault("userIp")
  valid_594579 = validateParameter(valid_594579, JString, required = false,
                                 default = nil)
  if valid_594579 != nil:
    section.add "userIp", valid_594579
  var valid_594580 = query.getOrDefault("key")
  valid_594580 = validateParameter(valid_594580, JString, required = false,
                                 default = nil)
  if valid_594580 != nil:
    section.add "key", valid_594580
  var valid_594581 = query.getOrDefault("prettyPrint")
  valid_594581 = validateParameter(valid_594581, JBool, required = false,
                                 default = newJBool(true))
  if valid_594581 != nil:
    section.add "prettyPrint", valid_594581
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

proc call*(call_594583: Call_GamesRoomsJoin_594570; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Join a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_594583.validator(path, query, header, formData, body)
  let scheme = call_594583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594583.url(scheme.get, call_594583.host, call_594583.base,
                         call_594583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594583, url, valid)

proc call*(call_594584: Call_GamesRoomsJoin_594570; roomId: string;
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
  var path_594585 = newJObject()
  var query_594586 = newJObject()
  var body_594587 = newJObject()
  add(query_594586, "fields", newJString(fields))
  add(query_594586, "quotaUser", newJString(quotaUser))
  add(query_594586, "alt", newJString(alt))
  add(query_594586, "language", newJString(language))
  add(query_594586, "oauth_token", newJString(oauthToken))
  add(query_594586, "userIp", newJString(userIp))
  add(query_594586, "key", newJString(key))
  if body != nil:
    body_594587 = body
  add(query_594586, "prettyPrint", newJBool(prettyPrint))
  add(path_594585, "roomId", newJString(roomId))
  result = call_594584.call(path_594585, query_594586, nil, nil, body_594587)

var gamesRoomsJoin* = Call_GamesRoomsJoin_594570(name: "gamesRoomsJoin",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/join", validator: validate_GamesRoomsJoin_594571,
    base: "/games/v1", url: url_GamesRoomsJoin_594572, schemes: {Scheme.Https})
type
  Call_GamesRoomsLeave_594588 = ref object of OpenApiRestCall_593437
proc url_GamesRoomsLeave_594590(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesRoomsLeave_594589(path: JsonNode; query: JsonNode;
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
  var valid_594591 = path.getOrDefault("roomId")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "roomId", valid_594591
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
  var valid_594592 = query.getOrDefault("fields")
  valid_594592 = validateParameter(valid_594592, JString, required = false,
                                 default = nil)
  if valid_594592 != nil:
    section.add "fields", valid_594592
  var valid_594593 = query.getOrDefault("quotaUser")
  valid_594593 = validateParameter(valid_594593, JString, required = false,
                                 default = nil)
  if valid_594593 != nil:
    section.add "quotaUser", valid_594593
  var valid_594594 = query.getOrDefault("alt")
  valid_594594 = validateParameter(valid_594594, JString, required = false,
                                 default = newJString("json"))
  if valid_594594 != nil:
    section.add "alt", valid_594594
  var valid_594595 = query.getOrDefault("language")
  valid_594595 = validateParameter(valid_594595, JString, required = false,
                                 default = nil)
  if valid_594595 != nil:
    section.add "language", valid_594595
  var valid_594596 = query.getOrDefault("oauth_token")
  valid_594596 = validateParameter(valid_594596, JString, required = false,
                                 default = nil)
  if valid_594596 != nil:
    section.add "oauth_token", valid_594596
  var valid_594597 = query.getOrDefault("userIp")
  valid_594597 = validateParameter(valid_594597, JString, required = false,
                                 default = nil)
  if valid_594597 != nil:
    section.add "userIp", valid_594597
  var valid_594598 = query.getOrDefault("key")
  valid_594598 = validateParameter(valid_594598, JString, required = false,
                                 default = nil)
  if valid_594598 != nil:
    section.add "key", valid_594598
  var valid_594599 = query.getOrDefault("prettyPrint")
  valid_594599 = validateParameter(valid_594599, JBool, required = false,
                                 default = newJBool(true))
  if valid_594599 != nil:
    section.add "prettyPrint", valid_594599
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

proc call*(call_594601: Call_GamesRoomsLeave_594588; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_594601.validator(path, query, header, formData, body)
  let scheme = call_594601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594601.url(scheme.get, call_594601.host, call_594601.base,
                         call_594601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594601, url, valid)

proc call*(call_594602: Call_GamesRoomsLeave_594588; roomId: string;
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
  var path_594603 = newJObject()
  var query_594604 = newJObject()
  var body_594605 = newJObject()
  add(query_594604, "fields", newJString(fields))
  add(query_594604, "quotaUser", newJString(quotaUser))
  add(query_594604, "alt", newJString(alt))
  add(query_594604, "language", newJString(language))
  add(query_594604, "oauth_token", newJString(oauthToken))
  add(query_594604, "userIp", newJString(userIp))
  add(query_594604, "key", newJString(key))
  if body != nil:
    body_594605 = body
  add(query_594604, "prettyPrint", newJBool(prettyPrint))
  add(path_594603, "roomId", newJString(roomId))
  result = call_594602.call(path_594603, query_594604, nil, nil, body_594605)

var gamesRoomsLeave* = Call_GamesRoomsLeave_594588(name: "gamesRoomsLeave",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/rooms/{roomId}/leave", validator: validate_GamesRoomsLeave_594589,
    base: "/games/v1", url: url_GamesRoomsLeave_594590, schemes: {Scheme.Https})
type
  Call_GamesRoomsReportStatus_594606 = ref object of OpenApiRestCall_593437
proc url_GamesRoomsReportStatus_594608(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesRoomsReportStatus_594607(path: JsonNode; query: JsonNode;
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
  var valid_594609 = path.getOrDefault("roomId")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "roomId", valid_594609
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
  var valid_594610 = query.getOrDefault("fields")
  valid_594610 = validateParameter(valid_594610, JString, required = false,
                                 default = nil)
  if valid_594610 != nil:
    section.add "fields", valid_594610
  var valid_594611 = query.getOrDefault("quotaUser")
  valid_594611 = validateParameter(valid_594611, JString, required = false,
                                 default = nil)
  if valid_594611 != nil:
    section.add "quotaUser", valid_594611
  var valid_594612 = query.getOrDefault("alt")
  valid_594612 = validateParameter(valid_594612, JString, required = false,
                                 default = newJString("json"))
  if valid_594612 != nil:
    section.add "alt", valid_594612
  var valid_594613 = query.getOrDefault("language")
  valid_594613 = validateParameter(valid_594613, JString, required = false,
                                 default = nil)
  if valid_594613 != nil:
    section.add "language", valid_594613
  var valid_594614 = query.getOrDefault("oauth_token")
  valid_594614 = validateParameter(valid_594614, JString, required = false,
                                 default = nil)
  if valid_594614 != nil:
    section.add "oauth_token", valid_594614
  var valid_594615 = query.getOrDefault("userIp")
  valid_594615 = validateParameter(valid_594615, JString, required = false,
                                 default = nil)
  if valid_594615 != nil:
    section.add "userIp", valid_594615
  var valid_594616 = query.getOrDefault("key")
  valid_594616 = validateParameter(valid_594616, JString, required = false,
                                 default = nil)
  if valid_594616 != nil:
    section.add "key", valid_594616
  var valid_594617 = query.getOrDefault("prettyPrint")
  valid_594617 = validateParameter(valid_594617, JBool, required = false,
                                 default = newJBool(true))
  if valid_594617 != nil:
    section.add "prettyPrint", valid_594617
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

proc call*(call_594619: Call_GamesRoomsReportStatus_594606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates sent by a client reporting the status of peers in a room. For internal use by the Games SDK only. Calling this method directly is unsupported.
  ## 
  let valid = call_594619.validator(path, query, header, formData, body)
  let scheme = call_594619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594619.url(scheme.get, call_594619.host, call_594619.base,
                         call_594619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594619, url, valid)

proc call*(call_594620: Call_GamesRoomsReportStatus_594606; roomId: string;
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
  var path_594621 = newJObject()
  var query_594622 = newJObject()
  var body_594623 = newJObject()
  add(query_594622, "fields", newJString(fields))
  add(query_594622, "quotaUser", newJString(quotaUser))
  add(query_594622, "alt", newJString(alt))
  add(query_594622, "language", newJString(language))
  add(query_594622, "oauth_token", newJString(oauthToken))
  add(query_594622, "userIp", newJString(userIp))
  add(query_594622, "key", newJString(key))
  if body != nil:
    body_594623 = body
  add(query_594622, "prettyPrint", newJBool(prettyPrint))
  add(path_594621, "roomId", newJString(roomId))
  result = call_594620.call(path_594621, query_594622, nil, nil, body_594623)

var gamesRoomsReportStatus* = Call_GamesRoomsReportStatus_594606(
    name: "gamesRoomsReportStatus", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/{roomId}/reportstatus",
    validator: validate_GamesRoomsReportStatus_594607, base: "/games/v1",
    url: url_GamesRoomsReportStatus_594608, schemes: {Scheme.Https})
type
  Call_GamesSnapshotsGet_594624 = ref object of OpenApiRestCall_593437
proc url_GamesSnapshotsGet_594626(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshotId" in path, "`snapshotId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/snapshots/"),
               (kind: VariableSegment, value: "snapshotId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesSnapshotsGet_594625(path: JsonNode; query: JsonNode;
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
  var valid_594627 = path.getOrDefault("snapshotId")
  valid_594627 = validateParameter(valid_594627, JString, required = true,
                                 default = nil)
  if valid_594627 != nil:
    section.add "snapshotId", valid_594627
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
  var valid_594628 = query.getOrDefault("fields")
  valid_594628 = validateParameter(valid_594628, JString, required = false,
                                 default = nil)
  if valid_594628 != nil:
    section.add "fields", valid_594628
  var valid_594629 = query.getOrDefault("quotaUser")
  valid_594629 = validateParameter(valid_594629, JString, required = false,
                                 default = nil)
  if valid_594629 != nil:
    section.add "quotaUser", valid_594629
  var valid_594630 = query.getOrDefault("alt")
  valid_594630 = validateParameter(valid_594630, JString, required = false,
                                 default = newJString("json"))
  if valid_594630 != nil:
    section.add "alt", valid_594630
  var valid_594631 = query.getOrDefault("language")
  valid_594631 = validateParameter(valid_594631, JString, required = false,
                                 default = nil)
  if valid_594631 != nil:
    section.add "language", valid_594631
  var valid_594632 = query.getOrDefault("oauth_token")
  valid_594632 = validateParameter(valid_594632, JString, required = false,
                                 default = nil)
  if valid_594632 != nil:
    section.add "oauth_token", valid_594632
  var valid_594633 = query.getOrDefault("userIp")
  valid_594633 = validateParameter(valid_594633, JString, required = false,
                                 default = nil)
  if valid_594633 != nil:
    section.add "userIp", valid_594633
  var valid_594634 = query.getOrDefault("key")
  valid_594634 = validateParameter(valid_594634, JString, required = false,
                                 default = nil)
  if valid_594634 != nil:
    section.add "key", valid_594634
  var valid_594635 = query.getOrDefault("prettyPrint")
  valid_594635 = validateParameter(valid_594635, JBool, required = false,
                                 default = newJBool(true))
  if valid_594635 != nil:
    section.add "prettyPrint", valid_594635
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594636: Call_GamesSnapshotsGet_594624; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the metadata for a given snapshot ID.
  ## 
  let valid = call_594636.validator(path, query, header, formData, body)
  let scheme = call_594636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594636.url(scheme.get, call_594636.host, call_594636.base,
                         call_594636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594636, url, valid)

proc call*(call_594637: Call_GamesSnapshotsGet_594624; snapshotId: string;
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
  var path_594638 = newJObject()
  var query_594639 = newJObject()
  add(query_594639, "fields", newJString(fields))
  add(query_594639, "quotaUser", newJString(quotaUser))
  add(query_594639, "alt", newJString(alt))
  add(query_594639, "language", newJString(language))
  add(path_594638, "snapshotId", newJString(snapshotId))
  add(query_594639, "oauth_token", newJString(oauthToken))
  add(query_594639, "userIp", newJString(userIp))
  add(query_594639, "key", newJString(key))
  add(query_594639, "prettyPrint", newJBool(prettyPrint))
  result = call_594637.call(path_594638, query_594639, nil, nil, nil)

var gamesSnapshotsGet* = Call_GamesSnapshotsGet_594624(name: "gamesSnapshotsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/snapshots/{snapshotId}", validator: validate_GamesSnapshotsGet_594625,
    base: "/games/v1", url: url_GamesSnapshotsGet_594626, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesList_594640 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesList_594642(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesList_594641(path: JsonNode; query: JsonNode;
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
  var valid_594643 = query.getOrDefault("fields")
  valid_594643 = validateParameter(valid_594643, JString, required = false,
                                 default = nil)
  if valid_594643 != nil:
    section.add "fields", valid_594643
  var valid_594644 = query.getOrDefault("pageToken")
  valid_594644 = validateParameter(valid_594644, JString, required = false,
                                 default = nil)
  if valid_594644 != nil:
    section.add "pageToken", valid_594644
  var valid_594645 = query.getOrDefault("quotaUser")
  valid_594645 = validateParameter(valid_594645, JString, required = false,
                                 default = nil)
  if valid_594645 != nil:
    section.add "quotaUser", valid_594645
  var valid_594646 = query.getOrDefault("alt")
  valid_594646 = validateParameter(valid_594646, JString, required = false,
                                 default = newJString("json"))
  if valid_594646 != nil:
    section.add "alt", valid_594646
  var valid_594647 = query.getOrDefault("language")
  valid_594647 = validateParameter(valid_594647, JString, required = false,
                                 default = nil)
  if valid_594647 != nil:
    section.add "language", valid_594647
  var valid_594648 = query.getOrDefault("includeMatchData")
  valid_594648 = validateParameter(valid_594648, JBool, required = false, default = nil)
  if valid_594648 != nil:
    section.add "includeMatchData", valid_594648
  var valid_594649 = query.getOrDefault("maxCompletedMatches")
  valid_594649 = validateParameter(valid_594649, JInt, required = false, default = nil)
  if valid_594649 != nil:
    section.add "maxCompletedMatches", valid_594649
  var valid_594650 = query.getOrDefault("oauth_token")
  valid_594650 = validateParameter(valid_594650, JString, required = false,
                                 default = nil)
  if valid_594650 != nil:
    section.add "oauth_token", valid_594650
  var valid_594651 = query.getOrDefault("userIp")
  valid_594651 = validateParameter(valid_594651, JString, required = false,
                                 default = nil)
  if valid_594651 != nil:
    section.add "userIp", valid_594651
  var valid_594652 = query.getOrDefault("maxResults")
  valid_594652 = validateParameter(valid_594652, JInt, required = false, default = nil)
  if valid_594652 != nil:
    section.add "maxResults", valid_594652
  var valid_594653 = query.getOrDefault("key")
  valid_594653 = validateParameter(valid_594653, JString, required = false,
                                 default = nil)
  if valid_594653 != nil:
    section.add "key", valid_594653
  var valid_594654 = query.getOrDefault("prettyPrint")
  valid_594654 = validateParameter(valid_594654, JBool, required = false,
                                 default = newJBool(true))
  if valid_594654 != nil:
    section.add "prettyPrint", valid_594654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594655: Call_GamesTurnBasedMatchesList_594640; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns turn-based matches the player is or was involved in.
  ## 
  let valid = call_594655.validator(path, query, header, formData, body)
  let scheme = call_594655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594655.url(scheme.get, call_594655.host, call_594655.base,
                         call_594655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594655, url, valid)

proc call*(call_594656: Call_GamesTurnBasedMatchesList_594640; fields: string = "";
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
  var query_594657 = newJObject()
  add(query_594657, "fields", newJString(fields))
  add(query_594657, "pageToken", newJString(pageToken))
  add(query_594657, "quotaUser", newJString(quotaUser))
  add(query_594657, "alt", newJString(alt))
  add(query_594657, "language", newJString(language))
  add(query_594657, "includeMatchData", newJBool(includeMatchData))
  add(query_594657, "maxCompletedMatches", newJInt(maxCompletedMatches))
  add(query_594657, "oauth_token", newJString(oauthToken))
  add(query_594657, "userIp", newJString(userIp))
  add(query_594657, "maxResults", newJInt(maxResults))
  add(query_594657, "key", newJString(key))
  add(query_594657, "prettyPrint", newJBool(prettyPrint))
  result = call_594656.call(nil, query_594657, nil, nil, nil)

var gamesTurnBasedMatchesList* = Call_GamesTurnBasedMatchesList_594640(
    name: "gamesTurnBasedMatchesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches",
    validator: validate_GamesTurnBasedMatchesList_594641, base: "/games/v1",
    url: url_GamesTurnBasedMatchesList_594642, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesCreate_594658 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesCreate_594660(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesCreate_594659(path: JsonNode; query: JsonNode;
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
  var valid_594661 = query.getOrDefault("fields")
  valid_594661 = validateParameter(valid_594661, JString, required = false,
                                 default = nil)
  if valid_594661 != nil:
    section.add "fields", valid_594661
  var valid_594662 = query.getOrDefault("quotaUser")
  valid_594662 = validateParameter(valid_594662, JString, required = false,
                                 default = nil)
  if valid_594662 != nil:
    section.add "quotaUser", valid_594662
  var valid_594663 = query.getOrDefault("alt")
  valid_594663 = validateParameter(valid_594663, JString, required = false,
                                 default = newJString("json"))
  if valid_594663 != nil:
    section.add "alt", valid_594663
  var valid_594664 = query.getOrDefault("language")
  valid_594664 = validateParameter(valid_594664, JString, required = false,
                                 default = nil)
  if valid_594664 != nil:
    section.add "language", valid_594664
  var valid_594665 = query.getOrDefault("oauth_token")
  valid_594665 = validateParameter(valid_594665, JString, required = false,
                                 default = nil)
  if valid_594665 != nil:
    section.add "oauth_token", valid_594665
  var valid_594666 = query.getOrDefault("userIp")
  valid_594666 = validateParameter(valid_594666, JString, required = false,
                                 default = nil)
  if valid_594666 != nil:
    section.add "userIp", valid_594666
  var valid_594667 = query.getOrDefault("key")
  valid_594667 = validateParameter(valid_594667, JString, required = false,
                                 default = nil)
  if valid_594667 != nil:
    section.add "key", valid_594667
  var valid_594668 = query.getOrDefault("prettyPrint")
  valid_594668 = validateParameter(valid_594668, JBool, required = false,
                                 default = newJBool(true))
  if valid_594668 != nil:
    section.add "prettyPrint", valid_594668
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

proc call*(call_594670: Call_GamesTurnBasedMatchesCreate_594658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a turn-based match.
  ## 
  let valid = call_594670.validator(path, query, header, formData, body)
  let scheme = call_594670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594670.url(scheme.get, call_594670.host, call_594670.base,
                         call_594670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594670, url, valid)

proc call*(call_594671: Call_GamesTurnBasedMatchesCreate_594658;
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
  var query_594672 = newJObject()
  var body_594673 = newJObject()
  add(query_594672, "fields", newJString(fields))
  add(query_594672, "quotaUser", newJString(quotaUser))
  add(query_594672, "alt", newJString(alt))
  add(query_594672, "language", newJString(language))
  add(query_594672, "oauth_token", newJString(oauthToken))
  add(query_594672, "userIp", newJString(userIp))
  add(query_594672, "key", newJString(key))
  if body != nil:
    body_594673 = body
  add(query_594672, "prettyPrint", newJBool(prettyPrint))
  result = call_594671.call(nil, query_594672, nil, nil, body_594673)

var gamesTurnBasedMatchesCreate* = Call_GamesTurnBasedMatchesCreate_594658(
    name: "gamesTurnBasedMatchesCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/create",
    validator: validate_GamesTurnBasedMatchesCreate_594659, base: "/games/v1",
    url: url_GamesTurnBasedMatchesCreate_594660, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesSync_594674 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesSync_594676(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesTurnBasedMatchesSync_594675(path: JsonNode; query: JsonNode;
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
  var valid_594677 = query.getOrDefault("fields")
  valid_594677 = validateParameter(valid_594677, JString, required = false,
                                 default = nil)
  if valid_594677 != nil:
    section.add "fields", valid_594677
  var valid_594678 = query.getOrDefault("pageToken")
  valid_594678 = validateParameter(valid_594678, JString, required = false,
                                 default = nil)
  if valid_594678 != nil:
    section.add "pageToken", valid_594678
  var valid_594679 = query.getOrDefault("quotaUser")
  valid_594679 = validateParameter(valid_594679, JString, required = false,
                                 default = nil)
  if valid_594679 != nil:
    section.add "quotaUser", valid_594679
  var valid_594680 = query.getOrDefault("alt")
  valid_594680 = validateParameter(valid_594680, JString, required = false,
                                 default = newJString("json"))
  if valid_594680 != nil:
    section.add "alt", valid_594680
  var valid_594681 = query.getOrDefault("language")
  valid_594681 = validateParameter(valid_594681, JString, required = false,
                                 default = nil)
  if valid_594681 != nil:
    section.add "language", valid_594681
  var valid_594682 = query.getOrDefault("includeMatchData")
  valid_594682 = validateParameter(valid_594682, JBool, required = false, default = nil)
  if valid_594682 != nil:
    section.add "includeMatchData", valid_594682
  var valid_594683 = query.getOrDefault("maxCompletedMatches")
  valid_594683 = validateParameter(valid_594683, JInt, required = false, default = nil)
  if valid_594683 != nil:
    section.add "maxCompletedMatches", valid_594683
  var valid_594684 = query.getOrDefault("oauth_token")
  valid_594684 = validateParameter(valid_594684, JString, required = false,
                                 default = nil)
  if valid_594684 != nil:
    section.add "oauth_token", valid_594684
  var valid_594685 = query.getOrDefault("userIp")
  valid_594685 = validateParameter(valid_594685, JString, required = false,
                                 default = nil)
  if valid_594685 != nil:
    section.add "userIp", valid_594685
  var valid_594686 = query.getOrDefault("maxResults")
  valid_594686 = validateParameter(valid_594686, JInt, required = false, default = nil)
  if valid_594686 != nil:
    section.add "maxResults", valid_594686
  var valid_594687 = query.getOrDefault("key")
  valid_594687 = validateParameter(valid_594687, JString, required = false,
                                 default = nil)
  if valid_594687 != nil:
    section.add "key", valid_594687
  var valid_594688 = query.getOrDefault("prettyPrint")
  valid_594688 = validateParameter(valid_594688, JBool, required = false,
                                 default = newJBool(true))
  if valid_594688 != nil:
    section.add "prettyPrint", valid_594688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594689: Call_GamesTurnBasedMatchesSync_594674; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns turn-based matches the player is or was involved in that changed since the last sync call, with the least recent changes coming first. Matches that should be removed from the local cache will have a status of MATCH_DELETED.
  ## 
  let valid = call_594689.validator(path, query, header, formData, body)
  let scheme = call_594689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594689.url(scheme.get, call_594689.host, call_594689.base,
                         call_594689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594689, url, valid)

proc call*(call_594690: Call_GamesTurnBasedMatchesSync_594674; fields: string = "";
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
  var query_594691 = newJObject()
  add(query_594691, "fields", newJString(fields))
  add(query_594691, "pageToken", newJString(pageToken))
  add(query_594691, "quotaUser", newJString(quotaUser))
  add(query_594691, "alt", newJString(alt))
  add(query_594691, "language", newJString(language))
  add(query_594691, "includeMatchData", newJBool(includeMatchData))
  add(query_594691, "maxCompletedMatches", newJInt(maxCompletedMatches))
  add(query_594691, "oauth_token", newJString(oauthToken))
  add(query_594691, "userIp", newJString(userIp))
  add(query_594691, "maxResults", newJInt(maxResults))
  add(query_594691, "key", newJString(key))
  add(query_594691, "prettyPrint", newJBool(prettyPrint))
  result = call_594690.call(nil, query_594691, nil, nil, nil)

var gamesTurnBasedMatchesSync* = Call_GamesTurnBasedMatchesSync_594674(
    name: "gamesTurnBasedMatchesSync", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches/sync",
    validator: validate_GamesTurnBasedMatchesSync_594675, base: "/games/v1",
    url: url_GamesTurnBasedMatchesSync_594676, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesGet_594692 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesGet_594694(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "matchId" in path, "`matchId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/turnbasedmatches/"),
               (kind: VariableSegment, value: "matchId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesTurnBasedMatchesGet_594693(path: JsonNode; query: JsonNode;
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
  var valid_594695 = path.getOrDefault("matchId")
  valid_594695 = validateParameter(valid_594695, JString, required = true,
                                 default = nil)
  if valid_594695 != nil:
    section.add "matchId", valid_594695
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
  var valid_594696 = query.getOrDefault("fields")
  valid_594696 = validateParameter(valid_594696, JString, required = false,
                                 default = nil)
  if valid_594696 != nil:
    section.add "fields", valid_594696
  var valid_594697 = query.getOrDefault("quotaUser")
  valid_594697 = validateParameter(valid_594697, JString, required = false,
                                 default = nil)
  if valid_594697 != nil:
    section.add "quotaUser", valid_594697
  var valid_594698 = query.getOrDefault("alt")
  valid_594698 = validateParameter(valid_594698, JString, required = false,
                                 default = newJString("json"))
  if valid_594698 != nil:
    section.add "alt", valid_594698
  var valid_594699 = query.getOrDefault("language")
  valid_594699 = validateParameter(valid_594699, JString, required = false,
                                 default = nil)
  if valid_594699 != nil:
    section.add "language", valid_594699
  var valid_594700 = query.getOrDefault("includeMatchData")
  valid_594700 = validateParameter(valid_594700, JBool, required = false, default = nil)
  if valid_594700 != nil:
    section.add "includeMatchData", valid_594700
  var valid_594701 = query.getOrDefault("oauth_token")
  valid_594701 = validateParameter(valid_594701, JString, required = false,
                                 default = nil)
  if valid_594701 != nil:
    section.add "oauth_token", valid_594701
  var valid_594702 = query.getOrDefault("userIp")
  valid_594702 = validateParameter(valid_594702, JString, required = false,
                                 default = nil)
  if valid_594702 != nil:
    section.add "userIp", valid_594702
  var valid_594703 = query.getOrDefault("key")
  valid_594703 = validateParameter(valid_594703, JString, required = false,
                                 default = nil)
  if valid_594703 != nil:
    section.add "key", valid_594703
  var valid_594704 = query.getOrDefault("prettyPrint")
  valid_594704 = validateParameter(valid_594704, JBool, required = false,
                                 default = newJBool(true))
  if valid_594704 != nil:
    section.add "prettyPrint", valid_594704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594705: Call_GamesTurnBasedMatchesGet_594692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the data for a turn-based match.
  ## 
  let valid = call_594705.validator(path, query, header, formData, body)
  let scheme = call_594705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594705.url(scheme.get, call_594705.host, call_594705.base,
                         call_594705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594705, url, valid)

proc call*(call_594706: Call_GamesTurnBasedMatchesGet_594692; matchId: string;
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
  var path_594707 = newJObject()
  var query_594708 = newJObject()
  add(query_594708, "fields", newJString(fields))
  add(query_594708, "quotaUser", newJString(quotaUser))
  add(query_594708, "alt", newJString(alt))
  add(query_594708, "language", newJString(language))
  add(query_594708, "includeMatchData", newJBool(includeMatchData))
  add(query_594708, "oauth_token", newJString(oauthToken))
  add(query_594708, "userIp", newJString(userIp))
  add(query_594708, "key", newJString(key))
  add(path_594707, "matchId", newJString(matchId))
  add(query_594708, "prettyPrint", newJBool(prettyPrint))
  result = call_594706.call(path_594707, query_594708, nil, nil, nil)

var gamesTurnBasedMatchesGet* = Call_GamesTurnBasedMatchesGet_594692(
    name: "gamesTurnBasedMatchesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}",
    validator: validate_GamesTurnBasedMatchesGet_594693, base: "/games/v1",
    url: url_GamesTurnBasedMatchesGet_594694, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesCancel_594709 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesCancel_594711(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesTurnBasedMatchesCancel_594710(path: JsonNode; query: JsonNode;
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
  var valid_594712 = path.getOrDefault("matchId")
  valid_594712 = validateParameter(valid_594712, JString, required = true,
                                 default = nil)
  if valid_594712 != nil:
    section.add "matchId", valid_594712
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
  var valid_594713 = query.getOrDefault("fields")
  valid_594713 = validateParameter(valid_594713, JString, required = false,
                                 default = nil)
  if valid_594713 != nil:
    section.add "fields", valid_594713
  var valid_594714 = query.getOrDefault("quotaUser")
  valid_594714 = validateParameter(valid_594714, JString, required = false,
                                 default = nil)
  if valid_594714 != nil:
    section.add "quotaUser", valid_594714
  var valid_594715 = query.getOrDefault("alt")
  valid_594715 = validateParameter(valid_594715, JString, required = false,
                                 default = newJString("json"))
  if valid_594715 != nil:
    section.add "alt", valid_594715
  var valid_594716 = query.getOrDefault("oauth_token")
  valid_594716 = validateParameter(valid_594716, JString, required = false,
                                 default = nil)
  if valid_594716 != nil:
    section.add "oauth_token", valid_594716
  var valid_594717 = query.getOrDefault("userIp")
  valid_594717 = validateParameter(valid_594717, JString, required = false,
                                 default = nil)
  if valid_594717 != nil:
    section.add "userIp", valid_594717
  var valid_594718 = query.getOrDefault("key")
  valid_594718 = validateParameter(valid_594718, JString, required = false,
                                 default = nil)
  if valid_594718 != nil:
    section.add "key", valid_594718
  var valid_594719 = query.getOrDefault("prettyPrint")
  valid_594719 = validateParameter(valid_594719, JBool, required = false,
                                 default = newJBool(true))
  if valid_594719 != nil:
    section.add "prettyPrint", valid_594719
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594720: Call_GamesTurnBasedMatchesCancel_594709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a turn-based match.
  ## 
  let valid = call_594720.validator(path, query, header, formData, body)
  let scheme = call_594720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594720.url(scheme.get, call_594720.host, call_594720.base,
                         call_594720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594720, url, valid)

proc call*(call_594721: Call_GamesTurnBasedMatchesCancel_594709; matchId: string;
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
  var path_594722 = newJObject()
  var query_594723 = newJObject()
  add(query_594723, "fields", newJString(fields))
  add(query_594723, "quotaUser", newJString(quotaUser))
  add(query_594723, "alt", newJString(alt))
  add(query_594723, "oauth_token", newJString(oauthToken))
  add(query_594723, "userIp", newJString(userIp))
  add(query_594723, "key", newJString(key))
  add(path_594722, "matchId", newJString(matchId))
  add(query_594723, "prettyPrint", newJBool(prettyPrint))
  result = call_594721.call(path_594722, query_594723, nil, nil, nil)

var gamesTurnBasedMatchesCancel* = Call_GamesTurnBasedMatchesCancel_594709(
    name: "gamesTurnBasedMatchesCancel", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/cancel",
    validator: validate_GamesTurnBasedMatchesCancel_594710, base: "/games/v1",
    url: url_GamesTurnBasedMatchesCancel_594711, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesDecline_594724 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesDecline_594726(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesTurnBasedMatchesDecline_594725(path: JsonNode; query: JsonNode;
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
  var valid_594727 = path.getOrDefault("matchId")
  valid_594727 = validateParameter(valid_594727, JString, required = true,
                                 default = nil)
  if valid_594727 != nil:
    section.add "matchId", valid_594727
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
  var valid_594728 = query.getOrDefault("fields")
  valid_594728 = validateParameter(valid_594728, JString, required = false,
                                 default = nil)
  if valid_594728 != nil:
    section.add "fields", valid_594728
  var valid_594729 = query.getOrDefault("quotaUser")
  valid_594729 = validateParameter(valid_594729, JString, required = false,
                                 default = nil)
  if valid_594729 != nil:
    section.add "quotaUser", valid_594729
  var valid_594730 = query.getOrDefault("alt")
  valid_594730 = validateParameter(valid_594730, JString, required = false,
                                 default = newJString("json"))
  if valid_594730 != nil:
    section.add "alt", valid_594730
  var valid_594731 = query.getOrDefault("language")
  valid_594731 = validateParameter(valid_594731, JString, required = false,
                                 default = nil)
  if valid_594731 != nil:
    section.add "language", valid_594731
  var valid_594732 = query.getOrDefault("oauth_token")
  valid_594732 = validateParameter(valid_594732, JString, required = false,
                                 default = nil)
  if valid_594732 != nil:
    section.add "oauth_token", valid_594732
  var valid_594733 = query.getOrDefault("userIp")
  valid_594733 = validateParameter(valid_594733, JString, required = false,
                                 default = nil)
  if valid_594733 != nil:
    section.add "userIp", valid_594733
  var valid_594734 = query.getOrDefault("key")
  valid_594734 = validateParameter(valid_594734, JString, required = false,
                                 default = nil)
  if valid_594734 != nil:
    section.add "key", valid_594734
  var valid_594735 = query.getOrDefault("prettyPrint")
  valid_594735 = validateParameter(valid_594735, JBool, required = false,
                                 default = newJBool(true))
  if valid_594735 != nil:
    section.add "prettyPrint", valid_594735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594736: Call_GamesTurnBasedMatchesDecline_594724; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Decline an invitation to play a turn-based match.
  ## 
  let valid = call_594736.validator(path, query, header, formData, body)
  let scheme = call_594736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594736.url(scheme.get, call_594736.host, call_594736.base,
                         call_594736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594736, url, valid)

proc call*(call_594737: Call_GamesTurnBasedMatchesDecline_594724; matchId: string;
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
  var path_594738 = newJObject()
  var query_594739 = newJObject()
  add(query_594739, "fields", newJString(fields))
  add(query_594739, "quotaUser", newJString(quotaUser))
  add(query_594739, "alt", newJString(alt))
  add(query_594739, "language", newJString(language))
  add(query_594739, "oauth_token", newJString(oauthToken))
  add(query_594739, "userIp", newJString(userIp))
  add(query_594739, "key", newJString(key))
  add(path_594738, "matchId", newJString(matchId))
  add(query_594739, "prettyPrint", newJBool(prettyPrint))
  result = call_594737.call(path_594738, query_594739, nil, nil, nil)

var gamesTurnBasedMatchesDecline* = Call_GamesTurnBasedMatchesDecline_594724(
    name: "gamesTurnBasedMatchesDecline", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/decline",
    validator: validate_GamesTurnBasedMatchesDecline_594725, base: "/games/v1",
    url: url_GamesTurnBasedMatchesDecline_594726, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesDismiss_594740 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesDismiss_594742(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesTurnBasedMatchesDismiss_594741(path: JsonNode; query: JsonNode;
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
  var valid_594743 = path.getOrDefault("matchId")
  valid_594743 = validateParameter(valid_594743, JString, required = true,
                                 default = nil)
  if valid_594743 != nil:
    section.add "matchId", valid_594743
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
  var valid_594744 = query.getOrDefault("fields")
  valid_594744 = validateParameter(valid_594744, JString, required = false,
                                 default = nil)
  if valid_594744 != nil:
    section.add "fields", valid_594744
  var valid_594745 = query.getOrDefault("quotaUser")
  valid_594745 = validateParameter(valid_594745, JString, required = false,
                                 default = nil)
  if valid_594745 != nil:
    section.add "quotaUser", valid_594745
  var valid_594746 = query.getOrDefault("alt")
  valid_594746 = validateParameter(valid_594746, JString, required = false,
                                 default = newJString("json"))
  if valid_594746 != nil:
    section.add "alt", valid_594746
  var valid_594747 = query.getOrDefault("oauth_token")
  valid_594747 = validateParameter(valid_594747, JString, required = false,
                                 default = nil)
  if valid_594747 != nil:
    section.add "oauth_token", valid_594747
  var valid_594748 = query.getOrDefault("userIp")
  valid_594748 = validateParameter(valid_594748, JString, required = false,
                                 default = nil)
  if valid_594748 != nil:
    section.add "userIp", valid_594748
  var valid_594749 = query.getOrDefault("key")
  valid_594749 = validateParameter(valid_594749, JString, required = false,
                                 default = nil)
  if valid_594749 != nil:
    section.add "key", valid_594749
  var valid_594750 = query.getOrDefault("prettyPrint")
  valid_594750 = validateParameter(valid_594750, JBool, required = false,
                                 default = newJBool(true))
  if valid_594750 != nil:
    section.add "prettyPrint", valid_594750
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594751: Call_GamesTurnBasedMatchesDismiss_594740; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss a turn-based match from the match list. The match will no longer show up in the list and will not generate notifications.
  ## 
  let valid = call_594751.validator(path, query, header, formData, body)
  let scheme = call_594751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594751.url(scheme.get, call_594751.host, call_594751.base,
                         call_594751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594751, url, valid)

proc call*(call_594752: Call_GamesTurnBasedMatchesDismiss_594740; matchId: string;
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
  var path_594753 = newJObject()
  var query_594754 = newJObject()
  add(query_594754, "fields", newJString(fields))
  add(query_594754, "quotaUser", newJString(quotaUser))
  add(query_594754, "alt", newJString(alt))
  add(query_594754, "oauth_token", newJString(oauthToken))
  add(query_594754, "userIp", newJString(userIp))
  add(query_594754, "key", newJString(key))
  add(path_594753, "matchId", newJString(matchId))
  add(query_594754, "prettyPrint", newJBool(prettyPrint))
  result = call_594752.call(path_594753, query_594754, nil, nil, nil)

var gamesTurnBasedMatchesDismiss* = Call_GamesTurnBasedMatchesDismiss_594740(
    name: "gamesTurnBasedMatchesDismiss", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/dismiss",
    validator: validate_GamesTurnBasedMatchesDismiss_594741, base: "/games/v1",
    url: url_GamesTurnBasedMatchesDismiss_594742, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesFinish_594755 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesFinish_594757(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesTurnBasedMatchesFinish_594756(path: JsonNode; query: JsonNode;
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
  var valid_594758 = path.getOrDefault("matchId")
  valid_594758 = validateParameter(valid_594758, JString, required = true,
                                 default = nil)
  if valid_594758 != nil:
    section.add "matchId", valid_594758
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
  var valid_594759 = query.getOrDefault("fields")
  valid_594759 = validateParameter(valid_594759, JString, required = false,
                                 default = nil)
  if valid_594759 != nil:
    section.add "fields", valid_594759
  var valid_594760 = query.getOrDefault("quotaUser")
  valid_594760 = validateParameter(valid_594760, JString, required = false,
                                 default = nil)
  if valid_594760 != nil:
    section.add "quotaUser", valid_594760
  var valid_594761 = query.getOrDefault("alt")
  valid_594761 = validateParameter(valid_594761, JString, required = false,
                                 default = newJString("json"))
  if valid_594761 != nil:
    section.add "alt", valid_594761
  var valid_594762 = query.getOrDefault("language")
  valid_594762 = validateParameter(valid_594762, JString, required = false,
                                 default = nil)
  if valid_594762 != nil:
    section.add "language", valid_594762
  var valid_594763 = query.getOrDefault("oauth_token")
  valid_594763 = validateParameter(valid_594763, JString, required = false,
                                 default = nil)
  if valid_594763 != nil:
    section.add "oauth_token", valid_594763
  var valid_594764 = query.getOrDefault("userIp")
  valid_594764 = validateParameter(valid_594764, JString, required = false,
                                 default = nil)
  if valid_594764 != nil:
    section.add "userIp", valid_594764
  var valid_594765 = query.getOrDefault("key")
  valid_594765 = validateParameter(valid_594765, JString, required = false,
                                 default = nil)
  if valid_594765 != nil:
    section.add "key", valid_594765
  var valid_594766 = query.getOrDefault("prettyPrint")
  valid_594766 = validateParameter(valid_594766, JBool, required = false,
                                 default = newJBool(true))
  if valid_594766 != nil:
    section.add "prettyPrint", valid_594766
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

proc call*(call_594768: Call_GamesTurnBasedMatchesFinish_594755; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finish a turn-based match. Each player should make this call once, after all results are in. Only the player whose turn it is may make the first call to Finish, and can pass in the final match state.
  ## 
  let valid = call_594768.validator(path, query, header, formData, body)
  let scheme = call_594768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594768.url(scheme.get, call_594768.host, call_594768.base,
                         call_594768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594768, url, valid)

proc call*(call_594769: Call_GamesTurnBasedMatchesFinish_594755; matchId: string;
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
  var path_594770 = newJObject()
  var query_594771 = newJObject()
  var body_594772 = newJObject()
  add(query_594771, "fields", newJString(fields))
  add(query_594771, "quotaUser", newJString(quotaUser))
  add(query_594771, "alt", newJString(alt))
  add(query_594771, "language", newJString(language))
  add(query_594771, "oauth_token", newJString(oauthToken))
  add(query_594771, "userIp", newJString(userIp))
  add(query_594771, "key", newJString(key))
  add(path_594770, "matchId", newJString(matchId))
  if body != nil:
    body_594772 = body
  add(query_594771, "prettyPrint", newJBool(prettyPrint))
  result = call_594769.call(path_594770, query_594771, nil, nil, body_594772)

var gamesTurnBasedMatchesFinish* = Call_GamesTurnBasedMatchesFinish_594755(
    name: "gamesTurnBasedMatchesFinish", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/finish",
    validator: validate_GamesTurnBasedMatchesFinish_594756, base: "/games/v1",
    url: url_GamesTurnBasedMatchesFinish_594757, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesJoin_594773 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesJoin_594775(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesTurnBasedMatchesJoin_594774(path: JsonNode; query: JsonNode;
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
  var valid_594776 = path.getOrDefault("matchId")
  valid_594776 = validateParameter(valid_594776, JString, required = true,
                                 default = nil)
  if valid_594776 != nil:
    section.add "matchId", valid_594776
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
  var valid_594777 = query.getOrDefault("fields")
  valid_594777 = validateParameter(valid_594777, JString, required = false,
                                 default = nil)
  if valid_594777 != nil:
    section.add "fields", valid_594777
  var valid_594778 = query.getOrDefault("quotaUser")
  valid_594778 = validateParameter(valid_594778, JString, required = false,
                                 default = nil)
  if valid_594778 != nil:
    section.add "quotaUser", valid_594778
  var valid_594779 = query.getOrDefault("alt")
  valid_594779 = validateParameter(valid_594779, JString, required = false,
                                 default = newJString("json"))
  if valid_594779 != nil:
    section.add "alt", valid_594779
  var valid_594780 = query.getOrDefault("language")
  valid_594780 = validateParameter(valid_594780, JString, required = false,
                                 default = nil)
  if valid_594780 != nil:
    section.add "language", valid_594780
  var valid_594781 = query.getOrDefault("oauth_token")
  valid_594781 = validateParameter(valid_594781, JString, required = false,
                                 default = nil)
  if valid_594781 != nil:
    section.add "oauth_token", valid_594781
  var valid_594782 = query.getOrDefault("userIp")
  valid_594782 = validateParameter(valid_594782, JString, required = false,
                                 default = nil)
  if valid_594782 != nil:
    section.add "userIp", valid_594782
  var valid_594783 = query.getOrDefault("key")
  valid_594783 = validateParameter(valid_594783, JString, required = false,
                                 default = nil)
  if valid_594783 != nil:
    section.add "key", valid_594783
  var valid_594784 = query.getOrDefault("prettyPrint")
  valid_594784 = validateParameter(valid_594784, JBool, required = false,
                                 default = newJBool(true))
  if valid_594784 != nil:
    section.add "prettyPrint", valid_594784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594785: Call_GamesTurnBasedMatchesJoin_594773; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Join a turn-based match.
  ## 
  let valid = call_594785.validator(path, query, header, formData, body)
  let scheme = call_594785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594785.url(scheme.get, call_594785.host, call_594785.base,
                         call_594785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594785, url, valid)

proc call*(call_594786: Call_GamesTurnBasedMatchesJoin_594773; matchId: string;
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
  var path_594787 = newJObject()
  var query_594788 = newJObject()
  add(query_594788, "fields", newJString(fields))
  add(query_594788, "quotaUser", newJString(quotaUser))
  add(query_594788, "alt", newJString(alt))
  add(query_594788, "language", newJString(language))
  add(query_594788, "oauth_token", newJString(oauthToken))
  add(query_594788, "userIp", newJString(userIp))
  add(query_594788, "key", newJString(key))
  add(path_594787, "matchId", newJString(matchId))
  add(query_594788, "prettyPrint", newJBool(prettyPrint))
  result = call_594786.call(path_594787, query_594788, nil, nil, nil)

var gamesTurnBasedMatchesJoin* = Call_GamesTurnBasedMatchesJoin_594773(
    name: "gamesTurnBasedMatchesJoin", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/join",
    validator: validate_GamesTurnBasedMatchesJoin_594774, base: "/games/v1",
    url: url_GamesTurnBasedMatchesJoin_594775, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesLeave_594789 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesLeave_594791(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesTurnBasedMatchesLeave_594790(path: JsonNode; query: JsonNode;
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
  var valid_594792 = path.getOrDefault("matchId")
  valid_594792 = validateParameter(valid_594792, JString, required = true,
                                 default = nil)
  if valid_594792 != nil:
    section.add "matchId", valid_594792
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
  var valid_594793 = query.getOrDefault("fields")
  valid_594793 = validateParameter(valid_594793, JString, required = false,
                                 default = nil)
  if valid_594793 != nil:
    section.add "fields", valid_594793
  var valid_594794 = query.getOrDefault("quotaUser")
  valid_594794 = validateParameter(valid_594794, JString, required = false,
                                 default = nil)
  if valid_594794 != nil:
    section.add "quotaUser", valid_594794
  var valid_594795 = query.getOrDefault("alt")
  valid_594795 = validateParameter(valid_594795, JString, required = false,
                                 default = newJString("json"))
  if valid_594795 != nil:
    section.add "alt", valid_594795
  var valid_594796 = query.getOrDefault("language")
  valid_594796 = validateParameter(valid_594796, JString, required = false,
                                 default = nil)
  if valid_594796 != nil:
    section.add "language", valid_594796
  var valid_594797 = query.getOrDefault("oauth_token")
  valid_594797 = validateParameter(valid_594797, JString, required = false,
                                 default = nil)
  if valid_594797 != nil:
    section.add "oauth_token", valid_594797
  var valid_594798 = query.getOrDefault("userIp")
  valid_594798 = validateParameter(valid_594798, JString, required = false,
                                 default = nil)
  if valid_594798 != nil:
    section.add "userIp", valid_594798
  var valid_594799 = query.getOrDefault("key")
  valid_594799 = validateParameter(valid_594799, JString, required = false,
                                 default = nil)
  if valid_594799 != nil:
    section.add "key", valid_594799
  var valid_594800 = query.getOrDefault("prettyPrint")
  valid_594800 = validateParameter(valid_594800, JBool, required = false,
                                 default = newJBool(true))
  if valid_594800 != nil:
    section.add "prettyPrint", valid_594800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594801: Call_GamesTurnBasedMatchesLeave_594789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a turn-based match when it is not the current player's turn, without canceling the match.
  ## 
  let valid = call_594801.validator(path, query, header, formData, body)
  let scheme = call_594801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594801.url(scheme.get, call_594801.host, call_594801.base,
                         call_594801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594801, url, valid)

proc call*(call_594802: Call_GamesTurnBasedMatchesLeave_594789; matchId: string;
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
  var path_594803 = newJObject()
  var query_594804 = newJObject()
  add(query_594804, "fields", newJString(fields))
  add(query_594804, "quotaUser", newJString(quotaUser))
  add(query_594804, "alt", newJString(alt))
  add(query_594804, "language", newJString(language))
  add(query_594804, "oauth_token", newJString(oauthToken))
  add(query_594804, "userIp", newJString(userIp))
  add(query_594804, "key", newJString(key))
  add(path_594803, "matchId", newJString(matchId))
  add(query_594804, "prettyPrint", newJBool(prettyPrint))
  result = call_594802.call(path_594803, query_594804, nil, nil, nil)

var gamesTurnBasedMatchesLeave* = Call_GamesTurnBasedMatchesLeave_594789(
    name: "gamesTurnBasedMatchesLeave", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/leave",
    validator: validate_GamesTurnBasedMatchesLeave_594790, base: "/games/v1",
    url: url_GamesTurnBasedMatchesLeave_594791, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesLeaveTurn_594805 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesLeaveTurn_594807(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesTurnBasedMatchesLeaveTurn_594806(path: JsonNode;
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
  var valid_594808 = path.getOrDefault("matchId")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "matchId", valid_594808
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
  var valid_594809 = query.getOrDefault("matchVersion")
  valid_594809 = validateParameter(valid_594809, JInt, required = true, default = nil)
  if valid_594809 != nil:
    section.add "matchVersion", valid_594809
  var valid_594810 = query.getOrDefault("fields")
  valid_594810 = validateParameter(valid_594810, JString, required = false,
                                 default = nil)
  if valid_594810 != nil:
    section.add "fields", valid_594810
  var valid_594811 = query.getOrDefault("quotaUser")
  valid_594811 = validateParameter(valid_594811, JString, required = false,
                                 default = nil)
  if valid_594811 != nil:
    section.add "quotaUser", valid_594811
  var valid_594812 = query.getOrDefault("alt")
  valid_594812 = validateParameter(valid_594812, JString, required = false,
                                 default = newJString("json"))
  if valid_594812 != nil:
    section.add "alt", valid_594812
  var valid_594813 = query.getOrDefault("language")
  valid_594813 = validateParameter(valid_594813, JString, required = false,
                                 default = nil)
  if valid_594813 != nil:
    section.add "language", valid_594813
  var valid_594814 = query.getOrDefault("oauth_token")
  valid_594814 = validateParameter(valid_594814, JString, required = false,
                                 default = nil)
  if valid_594814 != nil:
    section.add "oauth_token", valid_594814
  var valid_594815 = query.getOrDefault("userIp")
  valid_594815 = validateParameter(valid_594815, JString, required = false,
                                 default = nil)
  if valid_594815 != nil:
    section.add "userIp", valid_594815
  var valid_594816 = query.getOrDefault("key")
  valid_594816 = validateParameter(valid_594816, JString, required = false,
                                 default = nil)
  if valid_594816 != nil:
    section.add "key", valid_594816
  var valid_594817 = query.getOrDefault("prettyPrint")
  valid_594817 = validateParameter(valid_594817, JBool, required = false,
                                 default = newJBool(true))
  if valid_594817 != nil:
    section.add "prettyPrint", valid_594817
  var valid_594818 = query.getOrDefault("pendingParticipantId")
  valid_594818 = validateParameter(valid_594818, JString, required = false,
                                 default = nil)
  if valid_594818 != nil:
    section.add "pendingParticipantId", valid_594818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594819: Call_GamesTurnBasedMatchesLeaveTurn_594805; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Leave a turn-based match during the current player's turn, without canceling the match.
  ## 
  let valid = call_594819.validator(path, query, header, formData, body)
  let scheme = call_594819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594819.url(scheme.get, call_594819.host, call_594819.base,
                         call_594819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594819, url, valid)

proc call*(call_594820: Call_GamesTurnBasedMatchesLeaveTurn_594805;
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
  var path_594821 = newJObject()
  var query_594822 = newJObject()
  add(query_594822, "matchVersion", newJInt(matchVersion))
  add(query_594822, "fields", newJString(fields))
  add(query_594822, "quotaUser", newJString(quotaUser))
  add(query_594822, "alt", newJString(alt))
  add(query_594822, "language", newJString(language))
  add(query_594822, "oauth_token", newJString(oauthToken))
  add(query_594822, "userIp", newJString(userIp))
  add(query_594822, "key", newJString(key))
  add(path_594821, "matchId", newJString(matchId))
  add(query_594822, "prettyPrint", newJBool(prettyPrint))
  add(query_594822, "pendingParticipantId", newJString(pendingParticipantId))
  result = call_594820.call(path_594821, query_594822, nil, nil, nil)

var gamesTurnBasedMatchesLeaveTurn* = Call_GamesTurnBasedMatchesLeaveTurn_594805(
    name: "gamesTurnBasedMatchesLeaveTurn", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/leaveTurn",
    validator: validate_GamesTurnBasedMatchesLeaveTurn_594806, base: "/games/v1",
    url: url_GamesTurnBasedMatchesLeaveTurn_594807, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesRematch_594823 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesRematch_594825(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesTurnBasedMatchesRematch_594824(path: JsonNode; query: JsonNode;
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
  var valid_594826 = path.getOrDefault("matchId")
  valid_594826 = validateParameter(valid_594826, JString, required = true,
                                 default = nil)
  if valid_594826 != nil:
    section.add "matchId", valid_594826
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
  var valid_594827 = query.getOrDefault("fields")
  valid_594827 = validateParameter(valid_594827, JString, required = false,
                                 default = nil)
  if valid_594827 != nil:
    section.add "fields", valid_594827
  var valid_594828 = query.getOrDefault("requestId")
  valid_594828 = validateParameter(valid_594828, JString, required = false,
                                 default = nil)
  if valid_594828 != nil:
    section.add "requestId", valid_594828
  var valid_594829 = query.getOrDefault("quotaUser")
  valid_594829 = validateParameter(valid_594829, JString, required = false,
                                 default = nil)
  if valid_594829 != nil:
    section.add "quotaUser", valid_594829
  var valid_594830 = query.getOrDefault("alt")
  valid_594830 = validateParameter(valid_594830, JString, required = false,
                                 default = newJString("json"))
  if valid_594830 != nil:
    section.add "alt", valid_594830
  var valid_594831 = query.getOrDefault("language")
  valid_594831 = validateParameter(valid_594831, JString, required = false,
                                 default = nil)
  if valid_594831 != nil:
    section.add "language", valid_594831
  var valid_594832 = query.getOrDefault("oauth_token")
  valid_594832 = validateParameter(valid_594832, JString, required = false,
                                 default = nil)
  if valid_594832 != nil:
    section.add "oauth_token", valid_594832
  var valid_594833 = query.getOrDefault("userIp")
  valid_594833 = validateParameter(valid_594833, JString, required = false,
                                 default = nil)
  if valid_594833 != nil:
    section.add "userIp", valid_594833
  var valid_594834 = query.getOrDefault("key")
  valid_594834 = validateParameter(valid_594834, JString, required = false,
                                 default = nil)
  if valid_594834 != nil:
    section.add "key", valid_594834
  var valid_594835 = query.getOrDefault("prettyPrint")
  valid_594835 = validateParameter(valid_594835, JBool, required = false,
                                 default = newJBool(true))
  if valid_594835 != nil:
    section.add "prettyPrint", valid_594835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594836: Call_GamesTurnBasedMatchesRematch_594823; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a rematch of a match that was previously completed, with the same participants. This can be called by only one player on a match still in their list; the player must have called Finish first. Returns the newly created match; it will be the caller's turn.
  ## 
  let valid = call_594836.validator(path, query, header, formData, body)
  let scheme = call_594836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594836.url(scheme.get, call_594836.host, call_594836.base,
                         call_594836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594836, url, valid)

proc call*(call_594837: Call_GamesTurnBasedMatchesRematch_594823; matchId: string;
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
  var path_594838 = newJObject()
  var query_594839 = newJObject()
  add(query_594839, "fields", newJString(fields))
  add(query_594839, "requestId", newJString(requestId))
  add(query_594839, "quotaUser", newJString(quotaUser))
  add(query_594839, "alt", newJString(alt))
  add(query_594839, "language", newJString(language))
  add(query_594839, "oauth_token", newJString(oauthToken))
  add(query_594839, "userIp", newJString(userIp))
  add(query_594839, "key", newJString(key))
  add(path_594838, "matchId", newJString(matchId))
  add(query_594839, "prettyPrint", newJBool(prettyPrint))
  result = call_594837.call(path_594838, query_594839, nil, nil, nil)

var gamesTurnBasedMatchesRematch* = Call_GamesTurnBasedMatchesRematch_594823(
    name: "gamesTurnBasedMatchesRematch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/rematch",
    validator: validate_GamesTurnBasedMatchesRematch_594824, base: "/games/v1",
    url: url_GamesTurnBasedMatchesRematch_594825, schemes: {Scheme.Https})
type
  Call_GamesTurnBasedMatchesTakeTurn_594840 = ref object of OpenApiRestCall_593437
proc url_GamesTurnBasedMatchesTakeTurn_594842(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesTurnBasedMatchesTakeTurn_594841(path: JsonNode; query: JsonNode;
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
  var valid_594843 = path.getOrDefault("matchId")
  valid_594843 = validateParameter(valid_594843, JString, required = true,
                                 default = nil)
  if valid_594843 != nil:
    section.add "matchId", valid_594843
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
  var valid_594844 = query.getOrDefault("fields")
  valid_594844 = validateParameter(valid_594844, JString, required = false,
                                 default = nil)
  if valid_594844 != nil:
    section.add "fields", valid_594844
  var valid_594845 = query.getOrDefault("quotaUser")
  valid_594845 = validateParameter(valid_594845, JString, required = false,
                                 default = nil)
  if valid_594845 != nil:
    section.add "quotaUser", valid_594845
  var valid_594846 = query.getOrDefault("alt")
  valid_594846 = validateParameter(valid_594846, JString, required = false,
                                 default = newJString("json"))
  if valid_594846 != nil:
    section.add "alt", valid_594846
  var valid_594847 = query.getOrDefault("language")
  valid_594847 = validateParameter(valid_594847, JString, required = false,
                                 default = nil)
  if valid_594847 != nil:
    section.add "language", valid_594847
  var valid_594848 = query.getOrDefault("oauth_token")
  valid_594848 = validateParameter(valid_594848, JString, required = false,
                                 default = nil)
  if valid_594848 != nil:
    section.add "oauth_token", valid_594848
  var valid_594849 = query.getOrDefault("userIp")
  valid_594849 = validateParameter(valid_594849, JString, required = false,
                                 default = nil)
  if valid_594849 != nil:
    section.add "userIp", valid_594849
  var valid_594850 = query.getOrDefault("key")
  valid_594850 = validateParameter(valid_594850, JString, required = false,
                                 default = nil)
  if valid_594850 != nil:
    section.add "key", valid_594850
  var valid_594851 = query.getOrDefault("prettyPrint")
  valid_594851 = validateParameter(valid_594851, JBool, required = false,
                                 default = newJBool(true))
  if valid_594851 != nil:
    section.add "prettyPrint", valid_594851
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

proc call*(call_594853: Call_GamesTurnBasedMatchesTakeTurn_594840; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commit the results of a player turn.
  ## 
  let valid = call_594853.validator(path, query, header, formData, body)
  let scheme = call_594853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594853.url(scheme.get, call_594853.host, call_594853.base,
                         call_594853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594853, url, valid)

proc call*(call_594854: Call_GamesTurnBasedMatchesTakeTurn_594840; matchId: string;
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
  var path_594855 = newJObject()
  var query_594856 = newJObject()
  var body_594857 = newJObject()
  add(query_594856, "fields", newJString(fields))
  add(query_594856, "quotaUser", newJString(quotaUser))
  add(query_594856, "alt", newJString(alt))
  add(query_594856, "language", newJString(language))
  add(query_594856, "oauth_token", newJString(oauthToken))
  add(query_594856, "userIp", newJString(userIp))
  add(query_594856, "key", newJString(key))
  add(path_594855, "matchId", newJString(matchId))
  if body != nil:
    body_594857 = body
  add(query_594856, "prettyPrint", newJBool(prettyPrint))
  result = call_594854.call(path_594855, query_594856, nil, nil, body_594857)

var gamesTurnBasedMatchesTakeTurn* = Call_GamesTurnBasedMatchesTakeTurn_594840(
    name: "gamesTurnBasedMatchesTakeTurn", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/turnbasedmatches/{matchId}/turn",
    validator: validate_GamesTurnBasedMatchesTakeTurn_594841, base: "/games/v1",
    url: url_GamesTurnBasedMatchesTakeTurn_594842, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
