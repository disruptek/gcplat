
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play Game Services Management
## version: v1management
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Management API for Google Play Game Services.
## 
## https://developers.google.com/games/services
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
  gcpServiceName = "gamesManagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GamesManagementAchievementsResetAll_579692 = ref object of OpenApiRestCall_579424
proc url_GamesManagementAchievementsResetAll_579694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetAll_579693(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all achievements for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
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
  if body != nil:
    result.add "body", body

proc call*(call_579848: Call_GamesManagementAchievementsResetAll_579692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all achievements for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_579848.validator(path, query, header, formData, body)
  let scheme = call_579848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579848.url(scheme.get, call_579848.host, call_579848.base,
                         call_579848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579848, url, valid)

proc call*(call_579919: Call_GamesManagementAchievementsResetAll_579692;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementAchievementsResetAll
  ## Resets all achievements for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
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
  var query_579920 = newJObject()
  add(query_579920, "fields", newJString(fields))
  add(query_579920, "quotaUser", newJString(quotaUser))
  add(query_579920, "alt", newJString(alt))
  add(query_579920, "oauth_token", newJString(oauthToken))
  add(query_579920, "userIp", newJString(userIp))
  add(query_579920, "key", newJString(key))
  add(query_579920, "prettyPrint", newJBool(prettyPrint))
  result = call_579919.call(nil, query_579920, nil, nil, nil)

var gamesManagementAchievementsResetAll* = Call_GamesManagementAchievementsResetAll_579692(
    name: "gamesManagementAchievementsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/reset",
    validator: validate_GamesManagementAchievementsResetAll_579693,
    base: "/games/v1management", url: url_GamesManagementAchievementsResetAll_579694,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetAllForAllPlayers_579960 = ref object of OpenApiRestCall_579424
proc url_GamesManagementAchievementsResetAllForAllPlayers_579962(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetAllForAllPlayers_579961(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets all draft achievements for all players. This method is only available to user accounts for your developer console.
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
  var valid_579963 = query.getOrDefault("fields")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "fields", valid_579963
  var valid_579964 = query.getOrDefault("quotaUser")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "quotaUser", valid_579964
  var valid_579965 = query.getOrDefault("alt")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = newJString("json"))
  if valid_579965 != nil:
    section.add "alt", valid_579965
  var valid_579966 = query.getOrDefault("oauth_token")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "oauth_token", valid_579966
  var valid_579967 = query.getOrDefault("userIp")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "userIp", valid_579967
  var valid_579968 = query.getOrDefault("key")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "key", valid_579968
  var valid_579969 = query.getOrDefault("prettyPrint")
  valid_579969 = validateParameter(valid_579969, JBool, required = false,
                                 default = newJBool(true))
  if valid_579969 != nil:
    section.add "prettyPrint", valid_579969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579970: Call_GamesManagementAchievementsResetAllForAllPlayers_579960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft achievements for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_579970.validator(path, query, header, formData, body)
  let scheme = call_579970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579970.url(scheme.get, call_579970.host, call_579970.base,
                         call_579970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579970, url, valid)

proc call*(call_579971: Call_GamesManagementAchievementsResetAllForAllPlayers_579960;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementAchievementsResetAllForAllPlayers
  ## Resets all draft achievements for all players. This method is only available to user accounts for your developer console.
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
  var query_579972 = newJObject()
  add(query_579972, "fields", newJString(fields))
  add(query_579972, "quotaUser", newJString(quotaUser))
  add(query_579972, "alt", newJString(alt))
  add(query_579972, "oauth_token", newJString(oauthToken))
  add(query_579972, "userIp", newJString(userIp))
  add(query_579972, "key", newJString(key))
  add(query_579972, "prettyPrint", newJBool(prettyPrint))
  result = call_579971.call(nil, query_579972, nil, nil, nil)

var gamesManagementAchievementsResetAllForAllPlayers* = Call_GamesManagementAchievementsResetAllForAllPlayers_579960(
    name: "gamesManagementAchievementsResetAllForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/resetAllForAllPlayers",
    validator: validate_GamesManagementAchievementsResetAllForAllPlayers_579961,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetAllForAllPlayers_579962,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetMultipleForAllPlayers_579973 = ref object of OpenApiRestCall_579424
proc url_GamesManagementAchievementsResetMultipleForAllPlayers_579975(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetMultipleForAllPlayers_579974(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets achievements with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft achievements may be reset.
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
  var valid_579976 = query.getOrDefault("fields")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "fields", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("userIp")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "userIp", valid_579980
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

proc call*(call_579984: Call_GamesManagementAchievementsResetMultipleForAllPlayers_579973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets achievements with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft achievements may be reset.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_GamesManagementAchievementsResetMultipleForAllPlayers_579973;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesManagementAchievementsResetMultipleForAllPlayers
  ## Resets achievements with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft achievements may be reset.
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
  var query_579986 = newJObject()
  var body_579987 = newJObject()
  add(query_579986, "fields", newJString(fields))
  add(query_579986, "quotaUser", newJString(quotaUser))
  add(query_579986, "alt", newJString(alt))
  add(query_579986, "oauth_token", newJString(oauthToken))
  add(query_579986, "userIp", newJString(userIp))
  add(query_579986, "key", newJString(key))
  if body != nil:
    body_579987 = body
  add(query_579986, "prettyPrint", newJBool(prettyPrint))
  result = call_579985.call(nil, query_579986, nil, nil, body_579987)

var gamesManagementAchievementsResetMultipleForAllPlayers* = Call_GamesManagementAchievementsResetMultipleForAllPlayers_579973(
    name: "gamesManagementAchievementsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/resetMultipleForAllPlayers",
    validator: validate_GamesManagementAchievementsResetMultipleForAllPlayers_579974,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetMultipleForAllPlayers_579975,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsReset_579988 = ref object of OpenApiRestCall_579424
proc url_GamesManagementAchievementsReset_579990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "achievementId" in path, "`achievementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/achievements/"),
               (kind: VariableSegment, value: "achievementId"),
               (kind: ConstantSegment, value: "/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesManagementAchievementsReset_579989(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets the achievement with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   achievementId: JString (required)
  ##                : The ID of the achievement used by this method.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `achievementId` field"
  var valid_580005 = path.getOrDefault("achievementId")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "achievementId", valid_580005
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
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("quotaUser")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "quotaUser", valid_580007
  var valid_580008 = query.getOrDefault("alt")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("json"))
  if valid_580008 != nil:
    section.add "alt", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("userIp")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "userIp", valid_580010
  var valid_580011 = query.getOrDefault("key")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "key", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580013: Call_GamesManagementAchievementsReset_579988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the achievement with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_580013.validator(path, query, header, formData, body)
  let scheme = call_580013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580013.url(scheme.get, call_580013.host, call_580013.base,
                         call_580013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580013, url, valid)

proc call*(call_580014: Call_GamesManagementAchievementsReset_579988;
          achievementId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesManagementAchievementsReset
  ## Resets the achievement with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
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
  var path_580015 = newJObject()
  var query_580016 = newJObject()
  add(query_580016, "fields", newJString(fields))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(query_580016, "userIp", newJString(userIp))
  add(query_580016, "key", newJString(key))
  add(path_580015, "achievementId", newJString(achievementId))
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  result = call_580014.call(path_580015, query_580016, nil, nil, nil)

var gamesManagementAchievementsReset* = Call_GamesManagementAchievementsReset_579988(
    name: "gamesManagementAchievementsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/reset",
    validator: validate_GamesManagementAchievementsReset_579989,
    base: "/games/v1management", url: url_GamesManagementAchievementsReset_579990,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetForAllPlayers_580017 = ref object of OpenApiRestCall_579424
proc url_GamesManagementAchievementsResetForAllPlayers_580019(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "achievementId" in path, "`achievementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/achievements/"),
               (kind: VariableSegment, value: "achievementId"),
               (kind: ConstantSegment, value: "/resetForAllPlayers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesManagementAchievementsResetForAllPlayers_580018(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets the achievement with the given ID for all players. This method is only available to user accounts for your developer console. Only draft achievements can be reset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   achievementId: JString (required)
  ##                : The ID of the achievement used by this method.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `achievementId` field"
  var valid_580020 = path.getOrDefault("achievementId")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "achievementId", valid_580020
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
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
  var valid_580022 = query.getOrDefault("quotaUser")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "quotaUser", valid_580022
  var valid_580023 = query.getOrDefault("alt")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("json"))
  if valid_580023 != nil:
    section.add "alt", valid_580023
  var valid_580024 = query.getOrDefault("oauth_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "oauth_token", valid_580024
  var valid_580025 = query.getOrDefault("userIp")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "userIp", valid_580025
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  var valid_580027 = query.getOrDefault("prettyPrint")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "prettyPrint", valid_580027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580028: Call_GamesManagementAchievementsResetForAllPlayers_580017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the achievement with the given ID for all players. This method is only available to user accounts for your developer console. Only draft achievements can be reset.
  ## 
  let valid = call_580028.validator(path, query, header, formData, body)
  let scheme = call_580028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580028.url(scheme.get, call_580028.host, call_580028.base,
                         call_580028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580028, url, valid)

proc call*(call_580029: Call_GamesManagementAchievementsResetForAllPlayers_580017;
          achievementId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesManagementAchievementsResetForAllPlayers
  ## Resets the achievement with the given ID for all players. This method is only available to user accounts for your developer console. Only draft achievements can be reset.
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
  var path_580030 = newJObject()
  var query_580031 = newJObject()
  add(query_580031, "fields", newJString(fields))
  add(query_580031, "quotaUser", newJString(quotaUser))
  add(query_580031, "alt", newJString(alt))
  add(query_580031, "oauth_token", newJString(oauthToken))
  add(query_580031, "userIp", newJString(userIp))
  add(query_580031, "key", newJString(key))
  add(path_580030, "achievementId", newJString(achievementId))
  add(query_580031, "prettyPrint", newJBool(prettyPrint))
  result = call_580029.call(path_580030, query_580031, nil, nil, nil)

var gamesManagementAchievementsResetForAllPlayers* = Call_GamesManagementAchievementsResetForAllPlayers_580017(
    name: "gamesManagementAchievementsResetForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/{achievementId}/resetForAllPlayers",
    validator: validate_GamesManagementAchievementsResetForAllPlayers_580018,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetForAllPlayers_580019,
    schemes: {Scheme.Https})
type
  Call_GamesManagementApplicationsListHidden_580032 = ref object of OpenApiRestCall_579424
proc url_GamesManagementApplicationsListHidden_580034(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/players/hidden")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesManagementApplicationsListHidden_580033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of players hidden from the given application. This method is only available to user accounts for your developer console.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The application ID from the Google Play developer console.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_580035 = path.getOrDefault("applicationId")
  valid_580035 = validateParameter(valid_580035, JString, required = true,
                                 default = nil)
  if valid_580035 != nil:
    section.add "applicationId", valid_580035
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
  var valid_580036 = query.getOrDefault("fields")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "fields", valid_580036
  var valid_580037 = query.getOrDefault("pageToken")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "pageToken", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("alt")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("json"))
  if valid_580039 != nil:
    section.add "alt", valid_580039
  var valid_580040 = query.getOrDefault("oauth_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "oauth_token", valid_580040
  var valid_580041 = query.getOrDefault("userIp")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "userIp", valid_580041
  var valid_580042 = query.getOrDefault("maxResults")
  valid_580042 = validateParameter(valid_580042, JInt, required = false, default = nil)
  if valid_580042 != nil:
    section.add "maxResults", valid_580042
  var valid_580043 = query.getOrDefault("key")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "key", valid_580043
  var valid_580044 = query.getOrDefault("prettyPrint")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "prettyPrint", valid_580044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580045: Call_GamesManagementApplicationsListHidden_580032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of players hidden from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_580045.validator(path, query, header, formData, body)
  let scheme = call_580045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580045.url(scheme.get, call_580045.host, call_580045.base,
                         call_580045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580045, url, valid)

proc call*(call_580046: Call_GamesManagementApplicationsListHidden_580032;
          applicationId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementApplicationsListHidden
  ## Get the list of players hidden from the given application. This method is only available to user accounts for your developer console.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token returned by the previous request.
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
  ##   maxResults: int
  ##             : The maximum number of player resources to return in the response, used for paging. For any response, the actual number of player resources returned may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580047 = newJObject()
  var query_580048 = newJObject()
  add(query_580048, "fields", newJString(fields))
  add(query_580048, "pageToken", newJString(pageToken))
  add(query_580048, "quotaUser", newJString(quotaUser))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(query_580048, "userIp", newJString(userIp))
  add(path_580047, "applicationId", newJString(applicationId))
  add(query_580048, "maxResults", newJInt(maxResults))
  add(query_580048, "key", newJString(key))
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  result = call_580046.call(path_580047, query_580048, nil, nil, nil)

var gamesManagementApplicationsListHidden* = Call_GamesManagementApplicationsListHidden_580032(
    name: "gamesManagementApplicationsListHidden", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden",
    validator: validate_GamesManagementApplicationsListHidden_580033,
    base: "/games/v1management", url: url_GamesManagementApplicationsListHidden_580034,
    schemes: {Scheme.Https})
type
  Call_GamesManagementPlayersHide_580049 = ref object of OpenApiRestCall_579424
proc url_GamesManagementPlayersHide_580051(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "playerId" in path, "`playerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/players/hidden/"),
               (kind: VariableSegment, value: "playerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesManagementPlayersHide_580050(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Hide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   playerId: JString (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   applicationId: JString (required)
  ##                : The application ID from the Google Play developer console.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `playerId` field"
  var valid_580052 = path.getOrDefault("playerId")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "playerId", valid_580052
  var valid_580053 = path.getOrDefault("applicationId")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "applicationId", valid_580053
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
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("oauth_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "oauth_token", valid_580057
  var valid_580058 = query.getOrDefault("userIp")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "userIp", valid_580058
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580061: Call_GamesManagementPlayersHide_580049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_580061.validator(path, query, header, formData, body)
  let scheme = call_580061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580061.url(scheme.get, call_580061.host, call_580061.base,
                         call_580061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580061, url, valid)

proc call*(call_580062: Call_GamesManagementPlayersHide_580049; playerId: string;
          applicationId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesManagementPlayersHide
  ## Hide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580063 = newJObject()
  var query_580064 = newJObject()
  add(query_580064, "fields", newJString(fields))
  add(query_580064, "quotaUser", newJString(quotaUser))
  add(query_580064, "alt", newJString(alt))
  add(query_580064, "oauth_token", newJString(oauthToken))
  add(path_580063, "playerId", newJString(playerId))
  add(query_580064, "userIp", newJString(userIp))
  add(path_580063, "applicationId", newJString(applicationId))
  add(query_580064, "key", newJString(key))
  add(query_580064, "prettyPrint", newJBool(prettyPrint))
  result = call_580062.call(path_580063, query_580064, nil, nil, nil)

var gamesManagementPlayersHide* = Call_GamesManagementPlayersHide_580049(
    name: "gamesManagementPlayersHide", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden/{playerId}",
    validator: validate_GamesManagementPlayersHide_580050,
    base: "/games/v1management", url: url_GamesManagementPlayersHide_580051,
    schemes: {Scheme.Https})
type
  Call_GamesManagementPlayersUnhide_580065 = ref object of OpenApiRestCall_579424
proc url_GamesManagementPlayersUnhide_580067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "playerId" in path, "`playerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/players/hidden/"),
               (kind: VariableSegment, value: "playerId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesManagementPlayersUnhide_580066(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unhide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   playerId: JString (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   applicationId: JString (required)
  ##                : The application ID from the Google Play developer console.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `playerId` field"
  var valid_580068 = path.getOrDefault("playerId")
  valid_580068 = validateParameter(valid_580068, JString, required = true,
                                 default = nil)
  if valid_580068 != nil:
    section.add "playerId", valid_580068
  var valid_580069 = path.getOrDefault("applicationId")
  valid_580069 = validateParameter(valid_580069, JString, required = true,
                                 default = nil)
  if valid_580069 != nil:
    section.add "applicationId", valid_580069
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
  var valid_580070 = query.getOrDefault("fields")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "fields", valid_580070
  var valid_580071 = query.getOrDefault("quotaUser")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "quotaUser", valid_580071
  var valid_580072 = query.getOrDefault("alt")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("json"))
  if valid_580072 != nil:
    section.add "alt", valid_580072
  var valid_580073 = query.getOrDefault("oauth_token")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "oauth_token", valid_580073
  var valid_580074 = query.getOrDefault("userIp")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "userIp", valid_580074
  var valid_580075 = query.getOrDefault("key")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "key", valid_580075
  var valid_580076 = query.getOrDefault("prettyPrint")
  valid_580076 = validateParameter(valid_580076, JBool, required = false,
                                 default = newJBool(true))
  if valid_580076 != nil:
    section.add "prettyPrint", valid_580076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580077: Call_GamesManagementPlayersUnhide_580065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unhide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_580077.validator(path, query, header, formData, body)
  let scheme = call_580077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580077.url(scheme.get, call_580077.host, call_580077.base,
                         call_580077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580077, url, valid)

proc call*(call_580078: Call_GamesManagementPlayersUnhide_580065; playerId: string;
          applicationId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesManagementPlayersUnhide
  ## Unhide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   playerId: string (required)
  ##           : A player ID. A value of me may be used in place of the authenticated player's ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580079 = newJObject()
  var query_580080 = newJObject()
  add(query_580080, "fields", newJString(fields))
  add(query_580080, "quotaUser", newJString(quotaUser))
  add(query_580080, "alt", newJString(alt))
  add(query_580080, "oauth_token", newJString(oauthToken))
  add(path_580079, "playerId", newJString(playerId))
  add(query_580080, "userIp", newJString(userIp))
  add(path_580079, "applicationId", newJString(applicationId))
  add(query_580080, "key", newJString(key))
  add(query_580080, "prettyPrint", newJBool(prettyPrint))
  result = call_580078.call(path_580079, query_580080, nil, nil, nil)

var gamesManagementPlayersUnhide* = Call_GamesManagementPlayersUnhide_580065(
    name: "gamesManagementPlayersUnhide", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden/{playerId}",
    validator: validate_GamesManagementPlayersUnhide_580066,
    base: "/games/v1management", url: url_GamesManagementPlayersUnhide_580067,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetAll_580081 = ref object of OpenApiRestCall_579424
proc url_GamesManagementEventsResetAll_580083(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetAll_580082(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all player progress on all events for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player will also be reset.
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
  var valid_580084 = query.getOrDefault("fields")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "fields", valid_580084
  var valid_580085 = query.getOrDefault("quotaUser")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "quotaUser", valid_580085
  var valid_580086 = query.getOrDefault("alt")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = newJString("json"))
  if valid_580086 != nil:
    section.add "alt", valid_580086
  var valid_580087 = query.getOrDefault("oauth_token")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "oauth_token", valid_580087
  var valid_580088 = query.getOrDefault("userIp")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "userIp", valid_580088
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580091: Call_GamesManagementEventsResetAll_580081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on all events for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player will also be reset.
  ## 
  let valid = call_580091.validator(path, query, header, formData, body)
  let scheme = call_580091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580091.url(scheme.get, call_580091.host, call_580091.base,
                         call_580091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580091, url, valid)

proc call*(call_580092: Call_GamesManagementEventsResetAll_580081;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementEventsResetAll
  ## Resets all player progress on all events for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player will also be reset.
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
  var query_580093 = newJObject()
  add(query_580093, "fields", newJString(fields))
  add(query_580093, "quotaUser", newJString(quotaUser))
  add(query_580093, "alt", newJString(alt))
  add(query_580093, "oauth_token", newJString(oauthToken))
  add(query_580093, "userIp", newJString(userIp))
  add(query_580093, "key", newJString(key))
  add(query_580093, "prettyPrint", newJBool(prettyPrint))
  result = call_580092.call(nil, query_580093, nil, nil, nil)

var gamesManagementEventsResetAll* = Call_GamesManagementEventsResetAll_580081(
    name: "gamesManagementEventsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/reset",
    validator: validate_GamesManagementEventsResetAll_580082,
    base: "/games/v1management", url: url_GamesManagementEventsResetAll_580083,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetAllForAllPlayers_580094 = ref object of OpenApiRestCall_579424
proc url_GamesManagementEventsResetAllForAllPlayers_580096(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetAllForAllPlayers_580095(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all draft events for all players. This method is only available to user accounts for your developer console. All quests that use any of these events will also be reset.
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
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
  var valid_580098 = query.getOrDefault("quotaUser")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "quotaUser", valid_580098
  var valid_580099 = query.getOrDefault("alt")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("json"))
  if valid_580099 != nil:
    section.add "alt", valid_580099
  var valid_580100 = query.getOrDefault("oauth_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "oauth_token", valid_580100
  var valid_580101 = query.getOrDefault("userIp")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "userIp", valid_580101
  var valid_580102 = query.getOrDefault("key")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "key", valid_580102
  var valid_580103 = query.getOrDefault("prettyPrint")
  valid_580103 = validateParameter(valid_580103, JBool, required = false,
                                 default = newJBool(true))
  if valid_580103 != nil:
    section.add "prettyPrint", valid_580103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580104: Call_GamesManagementEventsResetAllForAllPlayers_580094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft events for all players. This method is only available to user accounts for your developer console. All quests that use any of these events will also be reset.
  ## 
  let valid = call_580104.validator(path, query, header, formData, body)
  let scheme = call_580104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580104.url(scheme.get, call_580104.host, call_580104.base,
                         call_580104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580104, url, valid)

proc call*(call_580105: Call_GamesManagementEventsResetAllForAllPlayers_580094;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementEventsResetAllForAllPlayers
  ## Resets all draft events for all players. This method is only available to user accounts for your developer console. All quests that use any of these events will also be reset.
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
  var query_580106 = newJObject()
  add(query_580106, "fields", newJString(fields))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(query_580106, "userIp", newJString(userIp))
  add(query_580106, "key", newJString(key))
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  result = call_580105.call(nil, query_580106, nil, nil, nil)

var gamesManagementEventsResetAllForAllPlayers* = Call_GamesManagementEventsResetAllForAllPlayers_580094(
    name: "gamesManagementEventsResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/resetAllForAllPlayers",
    validator: validate_GamesManagementEventsResetAllForAllPlayers_580095,
    base: "/games/v1management",
    url: url_GamesManagementEventsResetAllForAllPlayers_580096,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetMultipleForAllPlayers_580107 = ref object of OpenApiRestCall_579424
proc url_GamesManagementEventsResetMultipleForAllPlayers_580109(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetMultipleForAllPlayers_580108(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets events with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft events may be reset. All quests that use any of the events will also be reset.
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
  var valid_580110 = query.getOrDefault("fields")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "fields", valid_580110
  var valid_580111 = query.getOrDefault("quotaUser")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "quotaUser", valid_580111
  var valid_580112 = query.getOrDefault("alt")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = newJString("json"))
  if valid_580112 != nil:
    section.add "alt", valid_580112
  var valid_580113 = query.getOrDefault("oauth_token")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "oauth_token", valid_580113
  var valid_580114 = query.getOrDefault("userIp")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "userIp", valid_580114
  var valid_580115 = query.getOrDefault("key")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "key", valid_580115
  var valid_580116 = query.getOrDefault("prettyPrint")
  valid_580116 = validateParameter(valid_580116, JBool, required = false,
                                 default = newJBool(true))
  if valid_580116 != nil:
    section.add "prettyPrint", valid_580116
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

proc call*(call_580118: Call_GamesManagementEventsResetMultipleForAllPlayers_580107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets events with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft events may be reset. All quests that use any of the events will also be reset.
  ## 
  let valid = call_580118.validator(path, query, header, formData, body)
  let scheme = call_580118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580118.url(scheme.get, call_580118.host, call_580118.base,
                         call_580118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580118, url, valid)

proc call*(call_580119: Call_GamesManagementEventsResetMultipleForAllPlayers_580107;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesManagementEventsResetMultipleForAllPlayers
  ## Resets events with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft events may be reset. All quests that use any of the events will also be reset.
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
  var query_580120 = newJObject()
  var body_580121 = newJObject()
  add(query_580120, "fields", newJString(fields))
  add(query_580120, "quotaUser", newJString(quotaUser))
  add(query_580120, "alt", newJString(alt))
  add(query_580120, "oauth_token", newJString(oauthToken))
  add(query_580120, "userIp", newJString(userIp))
  add(query_580120, "key", newJString(key))
  if body != nil:
    body_580121 = body
  add(query_580120, "prettyPrint", newJBool(prettyPrint))
  result = call_580119.call(nil, query_580120, nil, nil, body_580121)

var gamesManagementEventsResetMultipleForAllPlayers* = Call_GamesManagementEventsResetMultipleForAllPlayers_580107(
    name: "gamesManagementEventsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/events/resetMultipleForAllPlayers",
    validator: validate_GamesManagementEventsResetMultipleForAllPlayers_580108,
    base: "/games/v1management",
    url: url_GamesManagementEventsResetMultipleForAllPlayers_580109,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsReset_580122 = ref object of OpenApiRestCall_579424
proc url_GamesManagementEventsReset_580124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "eventId" in path, "`eventId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventId"),
               (kind: ConstantSegment, value: "/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesManagementEventsReset_580123(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all player progress on the event with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player that use the event will also be reset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventId: JString (required)
  ##          : The ID of the event.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventId` field"
  var valid_580125 = path.getOrDefault("eventId")
  valid_580125 = validateParameter(valid_580125, JString, required = true,
                                 default = nil)
  if valid_580125 != nil:
    section.add "eventId", valid_580125
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
  var valid_580126 = query.getOrDefault("fields")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "fields", valid_580126
  var valid_580127 = query.getOrDefault("quotaUser")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "quotaUser", valid_580127
  var valid_580128 = query.getOrDefault("alt")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = newJString("json"))
  if valid_580128 != nil:
    section.add "alt", valid_580128
  var valid_580129 = query.getOrDefault("oauth_token")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "oauth_token", valid_580129
  var valid_580130 = query.getOrDefault("userIp")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "userIp", valid_580130
  var valid_580131 = query.getOrDefault("key")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "key", valid_580131
  var valid_580132 = query.getOrDefault("prettyPrint")
  valid_580132 = validateParameter(valid_580132, JBool, required = false,
                                 default = newJBool(true))
  if valid_580132 != nil:
    section.add "prettyPrint", valid_580132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580133: Call_GamesManagementEventsReset_580122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on the event with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player that use the event will also be reset.
  ## 
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_GamesManagementEventsReset_580122; eventId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementEventsReset
  ## Resets all player progress on the event with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player that use the event will also be reset.
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
  ##   eventId: string (required)
  ##          : The ID of the event.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580135 = newJObject()
  var query_580136 = newJObject()
  add(query_580136, "fields", newJString(fields))
  add(query_580136, "quotaUser", newJString(quotaUser))
  add(query_580136, "alt", newJString(alt))
  add(query_580136, "oauth_token", newJString(oauthToken))
  add(query_580136, "userIp", newJString(userIp))
  add(path_580135, "eventId", newJString(eventId))
  add(query_580136, "key", newJString(key))
  add(query_580136, "prettyPrint", newJBool(prettyPrint))
  result = call_580134.call(path_580135, query_580136, nil, nil, nil)

var gamesManagementEventsReset* = Call_GamesManagementEventsReset_580122(
    name: "gamesManagementEventsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/{eventId}/reset",
    validator: validate_GamesManagementEventsReset_580123,
    base: "/games/v1management", url: url_GamesManagementEventsReset_580124,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetForAllPlayers_580137 = ref object of OpenApiRestCall_579424
proc url_GamesManagementEventsResetForAllPlayers_580139(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "eventId" in path, "`eventId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventId"),
               (kind: ConstantSegment, value: "/resetForAllPlayers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesManagementEventsResetForAllPlayers_580138(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets the event with the given ID for all players. This method is only available to user accounts for your developer console. Only draft events can be reset. All quests that use the event will also be reset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventId: JString (required)
  ##          : The ID of the event.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventId` field"
  var valid_580140 = path.getOrDefault("eventId")
  valid_580140 = validateParameter(valid_580140, JString, required = true,
                                 default = nil)
  if valid_580140 != nil:
    section.add "eventId", valid_580140
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
  var valid_580141 = query.getOrDefault("fields")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "fields", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("alt")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("json"))
  if valid_580143 != nil:
    section.add "alt", valid_580143
  var valid_580144 = query.getOrDefault("oauth_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "oauth_token", valid_580144
  var valid_580145 = query.getOrDefault("userIp")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "userIp", valid_580145
  var valid_580146 = query.getOrDefault("key")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "key", valid_580146
  var valid_580147 = query.getOrDefault("prettyPrint")
  valid_580147 = validateParameter(valid_580147, JBool, required = false,
                                 default = newJBool(true))
  if valid_580147 != nil:
    section.add "prettyPrint", valid_580147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580148: Call_GamesManagementEventsResetForAllPlayers_580137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the event with the given ID for all players. This method is only available to user accounts for your developer console. Only draft events can be reset. All quests that use the event will also be reset.
  ## 
  let valid = call_580148.validator(path, query, header, formData, body)
  let scheme = call_580148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580148.url(scheme.get, call_580148.host, call_580148.base,
                         call_580148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580148, url, valid)

proc call*(call_580149: Call_GamesManagementEventsResetForAllPlayers_580137;
          eventId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesManagementEventsResetForAllPlayers
  ## Resets the event with the given ID for all players. This method is only available to user accounts for your developer console. Only draft events can be reset. All quests that use the event will also be reset.
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
  ##   eventId: string (required)
  ##          : The ID of the event.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580150 = newJObject()
  var query_580151 = newJObject()
  add(query_580151, "fields", newJString(fields))
  add(query_580151, "quotaUser", newJString(quotaUser))
  add(query_580151, "alt", newJString(alt))
  add(query_580151, "oauth_token", newJString(oauthToken))
  add(query_580151, "userIp", newJString(userIp))
  add(path_580150, "eventId", newJString(eventId))
  add(query_580151, "key", newJString(key))
  add(query_580151, "prettyPrint", newJBool(prettyPrint))
  result = call_580149.call(path_580150, query_580151, nil, nil, nil)

var gamesManagementEventsResetForAllPlayers* = Call_GamesManagementEventsResetForAllPlayers_580137(
    name: "gamesManagementEventsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/{eventId}/resetForAllPlayers",
    validator: validate_GamesManagementEventsResetForAllPlayers_580138,
    base: "/games/v1management", url: url_GamesManagementEventsResetForAllPlayers_580139,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresReset_580152 = ref object of OpenApiRestCall_579424
proc url_GamesManagementScoresReset_580154(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "leaderboardId" in path, "`leaderboardId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/leaderboards/"),
               (kind: VariableSegment, value: "leaderboardId"),
               (kind: ConstantSegment, value: "/scores/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesManagementScoresReset_580153(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets scores for the leaderboard with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `leaderboardId` field"
  var valid_580155 = path.getOrDefault("leaderboardId")
  valid_580155 = validateParameter(valid_580155, JString, required = true,
                                 default = nil)
  if valid_580155 != nil:
    section.add "leaderboardId", valid_580155
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
  var valid_580156 = query.getOrDefault("fields")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "fields", valid_580156
  var valid_580157 = query.getOrDefault("quotaUser")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "quotaUser", valid_580157
  var valid_580158 = query.getOrDefault("alt")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("json"))
  if valid_580158 != nil:
    section.add "alt", valid_580158
  var valid_580159 = query.getOrDefault("oauth_token")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "oauth_token", valid_580159
  var valid_580160 = query.getOrDefault("userIp")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "userIp", valid_580160
  var valid_580161 = query.getOrDefault("key")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "key", valid_580161
  var valid_580162 = query.getOrDefault("prettyPrint")
  valid_580162 = validateParameter(valid_580162, JBool, required = false,
                                 default = newJBool(true))
  if valid_580162 != nil:
    section.add "prettyPrint", valid_580162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580163: Call_GamesManagementScoresReset_580152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets scores for the leaderboard with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_580163.validator(path, query, header, formData, body)
  let scheme = call_580163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580163.url(scheme.get, call_580163.host, call_580163.base,
                         call_580163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580163, url, valid)

proc call*(call_580164: Call_GamesManagementScoresReset_580152;
          leaderboardId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesManagementScoresReset
  ## Resets scores for the leaderboard with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
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
  var path_580165 = newJObject()
  var query_580166 = newJObject()
  add(query_580166, "fields", newJString(fields))
  add(query_580166, "quotaUser", newJString(quotaUser))
  add(query_580166, "alt", newJString(alt))
  add(path_580165, "leaderboardId", newJString(leaderboardId))
  add(query_580166, "oauth_token", newJString(oauthToken))
  add(query_580166, "userIp", newJString(userIp))
  add(query_580166, "key", newJString(key))
  add(query_580166, "prettyPrint", newJBool(prettyPrint))
  result = call_580164.call(path_580165, query_580166, nil, nil, nil)

var gamesManagementScoresReset* = Call_GamesManagementScoresReset_580152(
    name: "gamesManagementScoresReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/reset",
    validator: validate_GamesManagementScoresReset_580153,
    base: "/games/v1management", url: url_GamesManagementScoresReset_580154,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetForAllPlayers_580167 = ref object of OpenApiRestCall_579424
proc url_GamesManagementScoresResetForAllPlayers_580169(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "leaderboardId" in path, "`leaderboardId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/leaderboards/"),
               (kind: VariableSegment, value: "leaderboardId"),
               (kind: ConstantSegment, value: "/scores/resetForAllPlayers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesManagementScoresResetForAllPlayers_580168(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets scores for the leaderboard with the given ID for all players. This method is only available to user accounts for your developer console. Only draft leaderboards can be reset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `leaderboardId` field"
  var valid_580170 = path.getOrDefault("leaderboardId")
  valid_580170 = validateParameter(valid_580170, JString, required = true,
                                 default = nil)
  if valid_580170 != nil:
    section.add "leaderboardId", valid_580170
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
  var valid_580171 = query.getOrDefault("fields")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "fields", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("alt")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("json"))
  if valid_580173 != nil:
    section.add "alt", valid_580173
  var valid_580174 = query.getOrDefault("oauth_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "oauth_token", valid_580174
  var valid_580175 = query.getOrDefault("userIp")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "userIp", valid_580175
  var valid_580176 = query.getOrDefault("key")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "key", valid_580176
  var valid_580177 = query.getOrDefault("prettyPrint")
  valid_580177 = validateParameter(valid_580177, JBool, required = false,
                                 default = newJBool(true))
  if valid_580177 != nil:
    section.add "prettyPrint", valid_580177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580178: Call_GamesManagementScoresResetForAllPlayers_580167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for the leaderboard with the given ID for all players. This method is only available to user accounts for your developer console. Only draft leaderboards can be reset.
  ## 
  let valid = call_580178.validator(path, query, header, formData, body)
  let scheme = call_580178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580178.url(scheme.get, call_580178.host, call_580178.base,
                         call_580178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580178, url, valid)

proc call*(call_580179: Call_GamesManagementScoresResetForAllPlayers_580167;
          leaderboardId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesManagementScoresResetForAllPlayers
  ## Resets scores for the leaderboard with the given ID for all players. This method is only available to user accounts for your developer console. Only draft leaderboards can be reset.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
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
  var path_580180 = newJObject()
  var query_580181 = newJObject()
  add(query_580181, "fields", newJString(fields))
  add(query_580181, "quotaUser", newJString(quotaUser))
  add(query_580181, "alt", newJString(alt))
  add(path_580180, "leaderboardId", newJString(leaderboardId))
  add(query_580181, "oauth_token", newJString(oauthToken))
  add(query_580181, "userIp", newJString(userIp))
  add(query_580181, "key", newJString(key))
  add(query_580181, "prettyPrint", newJBool(prettyPrint))
  result = call_580179.call(path_580180, query_580181, nil, nil, nil)

var gamesManagementScoresResetForAllPlayers* = Call_GamesManagementScoresResetForAllPlayers_580167(
    name: "gamesManagementScoresResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/resetForAllPlayers",
    validator: validate_GamesManagementScoresResetForAllPlayers_580168,
    base: "/games/v1management", url: url_GamesManagementScoresResetForAllPlayers_580169,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetAll_580182 = ref object of OpenApiRestCall_579424
proc url_GamesManagementQuestsResetAll_580184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetAll_580183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all player progress on all quests for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
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
  var valid_580185 = query.getOrDefault("fields")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "fields", valid_580185
  var valid_580186 = query.getOrDefault("quotaUser")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "quotaUser", valid_580186
  var valid_580187 = query.getOrDefault("alt")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("json"))
  if valid_580187 != nil:
    section.add "alt", valid_580187
  var valid_580188 = query.getOrDefault("oauth_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "oauth_token", valid_580188
  var valid_580189 = query.getOrDefault("userIp")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "userIp", valid_580189
  var valid_580190 = query.getOrDefault("key")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "key", valid_580190
  var valid_580191 = query.getOrDefault("prettyPrint")
  valid_580191 = validateParameter(valid_580191, JBool, required = false,
                                 default = newJBool(true))
  if valid_580191 != nil:
    section.add "prettyPrint", valid_580191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580192: Call_GamesManagementQuestsResetAll_580182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on all quests for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_GamesManagementQuestsResetAll_580182;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementQuestsResetAll
  ## Resets all player progress on all quests for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
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
  var query_580194 = newJObject()
  add(query_580194, "fields", newJString(fields))
  add(query_580194, "quotaUser", newJString(quotaUser))
  add(query_580194, "alt", newJString(alt))
  add(query_580194, "oauth_token", newJString(oauthToken))
  add(query_580194, "userIp", newJString(userIp))
  add(query_580194, "key", newJString(key))
  add(query_580194, "prettyPrint", newJBool(prettyPrint))
  result = call_580193.call(nil, query_580194, nil, nil, nil)

var gamesManagementQuestsResetAll* = Call_GamesManagementQuestsResetAll_580182(
    name: "gamesManagementQuestsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/reset",
    validator: validate_GamesManagementQuestsResetAll_580183,
    base: "/games/v1management", url: url_GamesManagementQuestsResetAll_580184,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetAllForAllPlayers_580195 = ref object of OpenApiRestCall_579424
proc url_GamesManagementQuestsResetAllForAllPlayers_580197(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetAllForAllPlayers_580196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all draft quests for all players. This method is only available to user accounts for your developer console.
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
  var valid_580198 = query.getOrDefault("fields")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "fields", valid_580198
  var valid_580199 = query.getOrDefault("quotaUser")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "quotaUser", valid_580199
  var valid_580200 = query.getOrDefault("alt")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = newJString("json"))
  if valid_580200 != nil:
    section.add "alt", valid_580200
  var valid_580201 = query.getOrDefault("oauth_token")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "oauth_token", valid_580201
  var valid_580202 = query.getOrDefault("userIp")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "userIp", valid_580202
  var valid_580203 = query.getOrDefault("key")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "key", valid_580203
  var valid_580204 = query.getOrDefault("prettyPrint")
  valid_580204 = validateParameter(valid_580204, JBool, required = false,
                                 default = newJBool(true))
  if valid_580204 != nil:
    section.add "prettyPrint", valid_580204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580205: Call_GamesManagementQuestsResetAllForAllPlayers_580195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft quests for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_580205.validator(path, query, header, formData, body)
  let scheme = call_580205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580205.url(scheme.get, call_580205.host, call_580205.base,
                         call_580205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580205, url, valid)

proc call*(call_580206: Call_GamesManagementQuestsResetAllForAllPlayers_580195;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementQuestsResetAllForAllPlayers
  ## Resets all draft quests for all players. This method is only available to user accounts for your developer console.
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
  var query_580207 = newJObject()
  add(query_580207, "fields", newJString(fields))
  add(query_580207, "quotaUser", newJString(quotaUser))
  add(query_580207, "alt", newJString(alt))
  add(query_580207, "oauth_token", newJString(oauthToken))
  add(query_580207, "userIp", newJString(userIp))
  add(query_580207, "key", newJString(key))
  add(query_580207, "prettyPrint", newJBool(prettyPrint))
  result = call_580206.call(nil, query_580207, nil, nil, nil)

var gamesManagementQuestsResetAllForAllPlayers* = Call_GamesManagementQuestsResetAllForAllPlayers_580195(
    name: "gamesManagementQuestsResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/resetAllForAllPlayers",
    validator: validate_GamesManagementQuestsResetAllForAllPlayers_580196,
    base: "/games/v1management",
    url: url_GamesManagementQuestsResetAllForAllPlayers_580197,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetMultipleForAllPlayers_580208 = ref object of OpenApiRestCall_579424
proc url_GamesManagementQuestsResetMultipleForAllPlayers_580210(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetMultipleForAllPlayers_580209(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets quests with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft quests may be reset.
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
  var valid_580211 = query.getOrDefault("fields")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "fields", valid_580211
  var valid_580212 = query.getOrDefault("quotaUser")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "quotaUser", valid_580212
  var valid_580213 = query.getOrDefault("alt")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("json"))
  if valid_580213 != nil:
    section.add "alt", valid_580213
  var valid_580214 = query.getOrDefault("oauth_token")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "oauth_token", valid_580214
  var valid_580215 = query.getOrDefault("userIp")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "userIp", valid_580215
  var valid_580216 = query.getOrDefault("key")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "key", valid_580216
  var valid_580217 = query.getOrDefault("prettyPrint")
  valid_580217 = validateParameter(valid_580217, JBool, required = false,
                                 default = newJBool(true))
  if valid_580217 != nil:
    section.add "prettyPrint", valid_580217
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

proc call*(call_580219: Call_GamesManagementQuestsResetMultipleForAllPlayers_580208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets quests with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft quests may be reset.
  ## 
  let valid = call_580219.validator(path, query, header, formData, body)
  let scheme = call_580219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580219.url(scheme.get, call_580219.host, call_580219.base,
                         call_580219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580219, url, valid)

proc call*(call_580220: Call_GamesManagementQuestsResetMultipleForAllPlayers_580208;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesManagementQuestsResetMultipleForAllPlayers
  ## Resets quests with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft quests may be reset.
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
  var query_580221 = newJObject()
  var body_580222 = newJObject()
  add(query_580221, "fields", newJString(fields))
  add(query_580221, "quotaUser", newJString(quotaUser))
  add(query_580221, "alt", newJString(alt))
  add(query_580221, "oauth_token", newJString(oauthToken))
  add(query_580221, "userIp", newJString(userIp))
  add(query_580221, "key", newJString(key))
  if body != nil:
    body_580222 = body
  add(query_580221, "prettyPrint", newJBool(prettyPrint))
  result = call_580220.call(nil, query_580221, nil, nil, body_580222)

var gamesManagementQuestsResetMultipleForAllPlayers* = Call_GamesManagementQuestsResetMultipleForAllPlayers_580208(
    name: "gamesManagementQuestsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/quests/resetMultipleForAllPlayers",
    validator: validate_GamesManagementQuestsResetMultipleForAllPlayers_580209,
    base: "/games/v1management",
    url: url_GamesManagementQuestsResetMultipleForAllPlayers_580210,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsReset_580223 = ref object of OpenApiRestCall_579424
proc url_GamesManagementQuestsReset_580225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "questId" in path, "`questId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/quests/"),
               (kind: VariableSegment, value: "questId"),
               (kind: ConstantSegment, value: "/reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesManagementQuestsReset_580224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all player progress on the quest with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   questId: JString (required)
  ##          : The ID of the quest.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `questId` field"
  var valid_580226 = path.getOrDefault("questId")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "questId", valid_580226
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
  var valid_580227 = query.getOrDefault("fields")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "fields", valid_580227
  var valid_580228 = query.getOrDefault("quotaUser")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "quotaUser", valid_580228
  var valid_580229 = query.getOrDefault("alt")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = newJString("json"))
  if valid_580229 != nil:
    section.add "alt", valid_580229
  var valid_580230 = query.getOrDefault("oauth_token")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "oauth_token", valid_580230
  var valid_580231 = query.getOrDefault("userIp")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "userIp", valid_580231
  var valid_580232 = query.getOrDefault("key")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "key", valid_580232
  var valid_580233 = query.getOrDefault("prettyPrint")
  valid_580233 = validateParameter(valid_580233, JBool, required = false,
                                 default = newJBool(true))
  if valid_580233 != nil:
    section.add "prettyPrint", valid_580233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580234: Call_GamesManagementQuestsReset_580223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on the quest with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_580234.validator(path, query, header, formData, body)
  let scheme = call_580234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580234.url(scheme.get, call_580234.host, call_580234.base,
                         call_580234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580234, url, valid)

proc call*(call_580235: Call_GamesManagementQuestsReset_580223; questId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementQuestsReset
  ## Resets all player progress on the quest with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
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
  ##   questId: string (required)
  ##          : The ID of the quest.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580236 = newJObject()
  var query_580237 = newJObject()
  add(query_580237, "fields", newJString(fields))
  add(query_580237, "quotaUser", newJString(quotaUser))
  add(query_580237, "alt", newJString(alt))
  add(query_580237, "oauth_token", newJString(oauthToken))
  add(query_580237, "userIp", newJString(userIp))
  add(query_580237, "key", newJString(key))
  add(path_580236, "questId", newJString(questId))
  add(query_580237, "prettyPrint", newJBool(prettyPrint))
  result = call_580235.call(path_580236, query_580237, nil, nil, nil)

var gamesManagementQuestsReset* = Call_GamesManagementQuestsReset_580223(
    name: "gamesManagementQuestsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/{questId}/reset",
    validator: validate_GamesManagementQuestsReset_580224,
    base: "/games/v1management", url: url_GamesManagementQuestsReset_580225,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetForAllPlayers_580238 = ref object of OpenApiRestCall_579424
proc url_GamesManagementQuestsResetForAllPlayers_580240(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "questId" in path, "`questId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/quests/"),
               (kind: VariableSegment, value: "questId"),
               (kind: ConstantSegment, value: "/resetForAllPlayers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesManagementQuestsResetForAllPlayers_580239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all player progress on the quest with the given ID for all players. This method is only available to user accounts for your developer console. Only draft quests can be reset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   questId: JString (required)
  ##          : The ID of the quest.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `questId` field"
  var valid_580241 = path.getOrDefault("questId")
  valid_580241 = validateParameter(valid_580241, JString, required = true,
                                 default = nil)
  if valid_580241 != nil:
    section.add "questId", valid_580241
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
  var valid_580245 = query.getOrDefault("oauth_token")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "oauth_token", valid_580245
  var valid_580246 = query.getOrDefault("userIp")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "userIp", valid_580246
  var valid_580247 = query.getOrDefault("key")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "key", valid_580247
  var valid_580248 = query.getOrDefault("prettyPrint")
  valid_580248 = validateParameter(valid_580248, JBool, required = false,
                                 default = newJBool(true))
  if valid_580248 != nil:
    section.add "prettyPrint", valid_580248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580249: Call_GamesManagementQuestsResetForAllPlayers_580238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all player progress on the quest with the given ID for all players. This method is only available to user accounts for your developer console. Only draft quests can be reset.
  ## 
  let valid = call_580249.validator(path, query, header, formData, body)
  let scheme = call_580249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580249.url(scheme.get, call_580249.host, call_580249.base,
                         call_580249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580249, url, valid)

proc call*(call_580250: Call_GamesManagementQuestsResetForAllPlayers_580238;
          questId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesManagementQuestsResetForAllPlayers
  ## Resets all player progress on the quest with the given ID for all players. This method is only available to user accounts for your developer console. Only draft quests can be reset.
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
  ##   questId: string (required)
  ##          : The ID of the quest.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580251 = newJObject()
  var query_580252 = newJObject()
  add(query_580252, "fields", newJString(fields))
  add(query_580252, "quotaUser", newJString(quotaUser))
  add(query_580252, "alt", newJString(alt))
  add(query_580252, "oauth_token", newJString(oauthToken))
  add(query_580252, "userIp", newJString(userIp))
  add(query_580252, "key", newJString(key))
  add(path_580251, "questId", newJString(questId))
  add(query_580252, "prettyPrint", newJBool(prettyPrint))
  result = call_580250.call(path_580251, query_580252, nil, nil, nil)

var gamesManagementQuestsResetForAllPlayers* = Call_GamesManagementQuestsResetForAllPlayers_580238(
    name: "gamesManagementQuestsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/{questId}/resetForAllPlayers",
    validator: validate_GamesManagementQuestsResetForAllPlayers_580239,
    base: "/games/v1management", url: url_GamesManagementQuestsResetForAllPlayers_580240,
    schemes: {Scheme.Https})
type
  Call_GamesManagementRoomsReset_580253 = ref object of OpenApiRestCall_579424
proc url_GamesManagementRoomsReset_580255(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementRoomsReset_580254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reset all rooms for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
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
  var valid_580256 = query.getOrDefault("fields")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "fields", valid_580256
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
  var valid_580259 = query.getOrDefault("oauth_token")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "oauth_token", valid_580259
  var valid_580260 = query.getOrDefault("userIp")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "userIp", valid_580260
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580263: Call_GamesManagementRoomsReset_580253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reset all rooms for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_GamesManagementRoomsReset_580253; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesManagementRoomsReset
  ## Reset all rooms for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
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
  var query_580265 = newJObject()
  add(query_580265, "fields", newJString(fields))
  add(query_580265, "quotaUser", newJString(quotaUser))
  add(query_580265, "alt", newJString(alt))
  add(query_580265, "oauth_token", newJString(oauthToken))
  add(query_580265, "userIp", newJString(userIp))
  add(query_580265, "key", newJString(key))
  add(query_580265, "prettyPrint", newJBool(prettyPrint))
  result = call_580264.call(nil, query_580265, nil, nil, nil)

var gamesManagementRoomsReset* = Call_GamesManagementRoomsReset_580253(
    name: "gamesManagementRoomsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/reset",
    validator: validate_GamesManagementRoomsReset_580254,
    base: "/games/v1management", url: url_GamesManagementRoomsReset_580255,
    schemes: {Scheme.Https})
type
  Call_GamesManagementRoomsResetForAllPlayers_580266 = ref object of OpenApiRestCall_579424
proc url_GamesManagementRoomsResetForAllPlayers_580268(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementRoomsResetForAllPlayers_580267(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes rooms where the only room participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
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
  var valid_580269 = query.getOrDefault("fields")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "fields", valid_580269
  var valid_580270 = query.getOrDefault("quotaUser")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "quotaUser", valid_580270
  var valid_580271 = query.getOrDefault("alt")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = newJString("json"))
  if valid_580271 != nil:
    section.add "alt", valid_580271
  var valid_580272 = query.getOrDefault("oauth_token")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "oauth_token", valid_580272
  var valid_580273 = query.getOrDefault("userIp")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "userIp", valid_580273
  var valid_580274 = query.getOrDefault("key")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "key", valid_580274
  var valid_580275 = query.getOrDefault("prettyPrint")
  valid_580275 = validateParameter(valid_580275, JBool, required = false,
                                 default = newJBool(true))
  if valid_580275 != nil:
    section.add "prettyPrint", valid_580275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580276: Call_GamesManagementRoomsResetForAllPlayers_580266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes rooms where the only room participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_580276.validator(path, query, header, formData, body)
  let scheme = call_580276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580276.url(scheme.get, call_580276.host, call_580276.base,
                         call_580276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580276, url, valid)

proc call*(call_580277: Call_GamesManagementRoomsResetForAllPlayers_580266;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementRoomsResetForAllPlayers
  ## Deletes rooms where the only room participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
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
  var query_580278 = newJObject()
  add(query_580278, "fields", newJString(fields))
  add(query_580278, "quotaUser", newJString(quotaUser))
  add(query_580278, "alt", newJString(alt))
  add(query_580278, "oauth_token", newJString(oauthToken))
  add(query_580278, "userIp", newJString(userIp))
  add(query_580278, "key", newJString(key))
  add(query_580278, "prettyPrint", newJBool(prettyPrint))
  result = call_580277.call(nil, query_580278, nil, nil, nil)

var gamesManagementRoomsResetForAllPlayers* = Call_GamesManagementRoomsResetForAllPlayers_580266(
    name: "gamesManagementRoomsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/resetForAllPlayers",
    validator: validate_GamesManagementRoomsResetForAllPlayers_580267,
    base: "/games/v1management", url: url_GamesManagementRoomsResetForAllPlayers_580268,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetAll_580279 = ref object of OpenApiRestCall_579424
proc url_GamesManagementScoresResetAll_580281(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetAll_580280(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all scores for all leaderboards for the currently authenticated players. This method is only accessible to whitelisted tester accounts for your application.
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
  var valid_580282 = query.getOrDefault("fields")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "fields", valid_580282
  var valid_580283 = query.getOrDefault("quotaUser")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "quotaUser", valid_580283
  var valid_580284 = query.getOrDefault("alt")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = newJString("json"))
  if valid_580284 != nil:
    section.add "alt", valid_580284
  var valid_580285 = query.getOrDefault("oauth_token")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "oauth_token", valid_580285
  var valid_580286 = query.getOrDefault("userIp")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "userIp", valid_580286
  var valid_580287 = query.getOrDefault("key")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "key", valid_580287
  var valid_580288 = query.getOrDefault("prettyPrint")
  valid_580288 = validateParameter(valid_580288, JBool, required = false,
                                 default = newJBool(true))
  if valid_580288 != nil:
    section.add "prettyPrint", valid_580288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580289: Call_GamesManagementScoresResetAll_580279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all scores for all leaderboards for the currently authenticated players. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_580289.validator(path, query, header, formData, body)
  let scheme = call_580289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580289.url(scheme.get, call_580289.host, call_580289.base,
                         call_580289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580289, url, valid)

proc call*(call_580290: Call_GamesManagementScoresResetAll_580279;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementScoresResetAll
  ## Resets all scores for all leaderboards for the currently authenticated players. This method is only accessible to whitelisted tester accounts for your application.
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
  var query_580291 = newJObject()
  add(query_580291, "fields", newJString(fields))
  add(query_580291, "quotaUser", newJString(quotaUser))
  add(query_580291, "alt", newJString(alt))
  add(query_580291, "oauth_token", newJString(oauthToken))
  add(query_580291, "userIp", newJString(userIp))
  add(query_580291, "key", newJString(key))
  add(query_580291, "prettyPrint", newJBool(prettyPrint))
  result = call_580290.call(nil, query_580291, nil, nil, nil)

var gamesManagementScoresResetAll* = Call_GamesManagementScoresResetAll_580279(
    name: "gamesManagementScoresResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/scores/reset",
    validator: validate_GamesManagementScoresResetAll_580280,
    base: "/games/v1management", url: url_GamesManagementScoresResetAll_580281,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetAllForAllPlayers_580292 = ref object of OpenApiRestCall_579424
proc url_GamesManagementScoresResetAllForAllPlayers_580294(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetAllForAllPlayers_580293(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets scores for all draft leaderboards for all players. This method is only available to user accounts for your developer console.
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
  var valid_580295 = query.getOrDefault("fields")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "fields", valid_580295
  var valid_580296 = query.getOrDefault("quotaUser")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "quotaUser", valid_580296
  var valid_580297 = query.getOrDefault("alt")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = newJString("json"))
  if valid_580297 != nil:
    section.add "alt", valid_580297
  var valid_580298 = query.getOrDefault("oauth_token")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "oauth_token", valid_580298
  var valid_580299 = query.getOrDefault("userIp")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "userIp", valid_580299
  var valid_580300 = query.getOrDefault("key")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "key", valid_580300
  var valid_580301 = query.getOrDefault("prettyPrint")
  valid_580301 = validateParameter(valid_580301, JBool, required = false,
                                 default = newJBool(true))
  if valid_580301 != nil:
    section.add "prettyPrint", valid_580301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580302: Call_GamesManagementScoresResetAllForAllPlayers_580292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for all draft leaderboards for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_580302.validator(path, query, header, formData, body)
  let scheme = call_580302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580302.url(scheme.get, call_580302.host, call_580302.base,
                         call_580302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580302, url, valid)

proc call*(call_580303: Call_GamesManagementScoresResetAllForAllPlayers_580292;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementScoresResetAllForAllPlayers
  ## Resets scores for all draft leaderboards for all players. This method is only available to user accounts for your developer console.
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
  var query_580304 = newJObject()
  add(query_580304, "fields", newJString(fields))
  add(query_580304, "quotaUser", newJString(quotaUser))
  add(query_580304, "alt", newJString(alt))
  add(query_580304, "oauth_token", newJString(oauthToken))
  add(query_580304, "userIp", newJString(userIp))
  add(query_580304, "key", newJString(key))
  add(query_580304, "prettyPrint", newJBool(prettyPrint))
  result = call_580303.call(nil, query_580304, nil, nil, nil)

var gamesManagementScoresResetAllForAllPlayers* = Call_GamesManagementScoresResetAllForAllPlayers_580292(
    name: "gamesManagementScoresResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/scores/resetAllForAllPlayers",
    validator: validate_GamesManagementScoresResetAllForAllPlayers_580293,
    base: "/games/v1management",
    url: url_GamesManagementScoresResetAllForAllPlayers_580294,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetMultipleForAllPlayers_580305 = ref object of OpenApiRestCall_579424
proc url_GamesManagementScoresResetMultipleForAllPlayers_580307(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetMultipleForAllPlayers_580306(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets scores for the leaderboards with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft leaderboards may be reset.
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
  var valid_580308 = query.getOrDefault("fields")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "fields", valid_580308
  var valid_580309 = query.getOrDefault("quotaUser")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "quotaUser", valid_580309
  var valid_580310 = query.getOrDefault("alt")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("json"))
  if valid_580310 != nil:
    section.add "alt", valid_580310
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580316: Call_GamesManagementScoresResetMultipleForAllPlayers_580305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for the leaderboards with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft leaderboards may be reset.
  ## 
  let valid = call_580316.validator(path, query, header, formData, body)
  let scheme = call_580316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580316.url(scheme.get, call_580316.host, call_580316.base,
                         call_580316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580316, url, valid)

proc call*(call_580317: Call_GamesManagementScoresResetMultipleForAllPlayers_580305;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesManagementScoresResetMultipleForAllPlayers
  ## Resets scores for the leaderboards with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft leaderboards may be reset.
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
  var query_580318 = newJObject()
  var body_580319 = newJObject()
  add(query_580318, "fields", newJString(fields))
  add(query_580318, "quotaUser", newJString(quotaUser))
  add(query_580318, "alt", newJString(alt))
  add(query_580318, "oauth_token", newJString(oauthToken))
  add(query_580318, "userIp", newJString(userIp))
  add(query_580318, "key", newJString(key))
  if body != nil:
    body_580319 = body
  add(query_580318, "prettyPrint", newJBool(prettyPrint))
  result = call_580317.call(nil, query_580318, nil, nil, body_580319)

var gamesManagementScoresResetMultipleForAllPlayers* = Call_GamesManagementScoresResetMultipleForAllPlayers_580305(
    name: "gamesManagementScoresResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/scores/resetMultipleForAllPlayers",
    validator: validate_GamesManagementScoresResetMultipleForAllPlayers_580306,
    base: "/games/v1management",
    url: url_GamesManagementScoresResetMultipleForAllPlayers_580307,
    schemes: {Scheme.Https})
type
  Call_GamesManagementTurnBasedMatchesReset_580320 = ref object of OpenApiRestCall_579424
proc url_GamesManagementTurnBasedMatchesReset_580322(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementTurnBasedMatchesReset_580321(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reset all turn-based match data for a user. This method is only accessible to whitelisted tester accounts for your application.
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
  var valid_580323 = query.getOrDefault("fields")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "fields", valid_580323
  var valid_580324 = query.getOrDefault("quotaUser")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "quotaUser", valid_580324
  var valid_580325 = query.getOrDefault("alt")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = newJString("json"))
  if valid_580325 != nil:
    section.add "alt", valid_580325
  var valid_580326 = query.getOrDefault("oauth_token")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "oauth_token", valid_580326
  var valid_580327 = query.getOrDefault("userIp")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "userIp", valid_580327
  var valid_580328 = query.getOrDefault("key")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "key", valid_580328
  var valid_580329 = query.getOrDefault("prettyPrint")
  valid_580329 = validateParameter(valid_580329, JBool, required = false,
                                 default = newJBool(true))
  if valid_580329 != nil:
    section.add "prettyPrint", valid_580329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580330: Call_GamesManagementTurnBasedMatchesReset_580320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset all turn-based match data for a user. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_580330.validator(path, query, header, formData, body)
  let scheme = call_580330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580330.url(scheme.get, call_580330.host, call_580330.base,
                         call_580330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580330, url, valid)

proc call*(call_580331: Call_GamesManagementTurnBasedMatchesReset_580320;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementTurnBasedMatchesReset
  ## Reset all turn-based match data for a user. This method is only accessible to whitelisted tester accounts for your application.
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
  var query_580332 = newJObject()
  add(query_580332, "fields", newJString(fields))
  add(query_580332, "quotaUser", newJString(quotaUser))
  add(query_580332, "alt", newJString(alt))
  add(query_580332, "oauth_token", newJString(oauthToken))
  add(query_580332, "userIp", newJString(userIp))
  add(query_580332, "key", newJString(key))
  add(query_580332, "prettyPrint", newJBool(prettyPrint))
  result = call_580331.call(nil, query_580332, nil, nil, nil)

var gamesManagementTurnBasedMatchesReset* = Call_GamesManagementTurnBasedMatchesReset_580320(
    name: "gamesManagementTurnBasedMatchesReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/reset",
    validator: validate_GamesManagementTurnBasedMatchesReset_580321,
    base: "/games/v1management", url: url_GamesManagementTurnBasedMatchesReset_580322,
    schemes: {Scheme.Https})
type
  Call_GamesManagementTurnBasedMatchesResetForAllPlayers_580333 = ref object of OpenApiRestCall_579424
proc url_GamesManagementTurnBasedMatchesResetForAllPlayers_580335(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementTurnBasedMatchesResetForAllPlayers_580334(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes turn-based matches where the only match participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
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
  var valid_580336 = query.getOrDefault("fields")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "fields", valid_580336
  var valid_580337 = query.getOrDefault("quotaUser")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "quotaUser", valid_580337
  var valid_580338 = query.getOrDefault("alt")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = newJString("json"))
  if valid_580338 != nil:
    section.add "alt", valid_580338
  var valid_580339 = query.getOrDefault("oauth_token")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "oauth_token", valid_580339
  var valid_580340 = query.getOrDefault("userIp")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "userIp", valid_580340
  var valid_580341 = query.getOrDefault("key")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "key", valid_580341
  var valid_580342 = query.getOrDefault("prettyPrint")
  valid_580342 = validateParameter(valid_580342, JBool, required = false,
                                 default = newJBool(true))
  if valid_580342 != nil:
    section.add "prettyPrint", valid_580342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580343: Call_GamesManagementTurnBasedMatchesResetForAllPlayers_580333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes turn-based matches where the only match participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_580343.validator(path, query, header, formData, body)
  let scheme = call_580343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580343.url(scheme.get, call_580343.host, call_580343.base,
                         call_580343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580343, url, valid)

proc call*(call_580344: Call_GamesManagementTurnBasedMatchesResetForAllPlayers_580333;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesManagementTurnBasedMatchesResetForAllPlayers
  ## Deletes turn-based matches where the only match participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
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
  var query_580345 = newJObject()
  add(query_580345, "fields", newJString(fields))
  add(query_580345, "quotaUser", newJString(quotaUser))
  add(query_580345, "alt", newJString(alt))
  add(query_580345, "oauth_token", newJString(oauthToken))
  add(query_580345, "userIp", newJString(userIp))
  add(query_580345, "key", newJString(key))
  add(query_580345, "prettyPrint", newJBool(prettyPrint))
  result = call_580344.call(nil, query_580345, nil, nil, nil)

var gamesManagementTurnBasedMatchesResetForAllPlayers* = Call_GamesManagementTurnBasedMatchesResetForAllPlayers_580333(
    name: "gamesManagementTurnBasedMatchesResetForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/turnbasedmatches/resetForAllPlayers",
    validator: validate_GamesManagementTurnBasedMatchesResetForAllPlayers_580334,
    base: "/games/v1management",
    url: url_GamesManagementTurnBasedMatchesResetForAllPlayers_580335,
    schemes: {Scheme.Https})
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
