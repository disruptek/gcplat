
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GamesManagementAchievementsResetAll_593692 = ref object of OpenApiRestCall_593424
proc url_GamesManagementAchievementsResetAll_593694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetAll_593693(path: JsonNode;
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
  var valid_593806 = query.getOrDefault("fields")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "fields", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593821 = query.getOrDefault("alt")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = newJString("json"))
  if valid_593821 != nil:
    section.add "alt", valid_593821
  var valid_593822 = query.getOrDefault("oauth_token")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "oauth_token", valid_593822
  var valid_593823 = query.getOrDefault("userIp")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "userIp", valid_593823
  var valid_593824 = query.getOrDefault("key")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "key", valid_593824
  var valid_593825 = query.getOrDefault("prettyPrint")
  valid_593825 = validateParameter(valid_593825, JBool, required = false,
                                 default = newJBool(true))
  if valid_593825 != nil:
    section.add "prettyPrint", valid_593825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593848: Call_GamesManagementAchievementsResetAll_593692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all achievements for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_593848.validator(path, query, header, formData, body)
  let scheme = call_593848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593848.url(scheme.get, call_593848.host, call_593848.base,
                         call_593848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593848, url, valid)

proc call*(call_593919: Call_GamesManagementAchievementsResetAll_593692;
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
  var query_593920 = newJObject()
  add(query_593920, "fields", newJString(fields))
  add(query_593920, "quotaUser", newJString(quotaUser))
  add(query_593920, "alt", newJString(alt))
  add(query_593920, "oauth_token", newJString(oauthToken))
  add(query_593920, "userIp", newJString(userIp))
  add(query_593920, "key", newJString(key))
  add(query_593920, "prettyPrint", newJBool(prettyPrint))
  result = call_593919.call(nil, query_593920, nil, nil, nil)

var gamesManagementAchievementsResetAll* = Call_GamesManagementAchievementsResetAll_593692(
    name: "gamesManagementAchievementsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/reset",
    validator: validate_GamesManagementAchievementsResetAll_593693,
    base: "/games/v1management", url: url_GamesManagementAchievementsResetAll_593694,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetAllForAllPlayers_593960 = ref object of OpenApiRestCall_593424
proc url_GamesManagementAchievementsResetAllForAllPlayers_593962(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetAllForAllPlayers_593961(
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
  var valid_593963 = query.getOrDefault("fields")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "fields", valid_593963
  var valid_593964 = query.getOrDefault("quotaUser")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "quotaUser", valid_593964
  var valid_593965 = query.getOrDefault("alt")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = newJString("json"))
  if valid_593965 != nil:
    section.add "alt", valid_593965
  var valid_593966 = query.getOrDefault("oauth_token")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "oauth_token", valid_593966
  var valid_593967 = query.getOrDefault("userIp")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "userIp", valid_593967
  var valid_593968 = query.getOrDefault("key")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "key", valid_593968
  var valid_593969 = query.getOrDefault("prettyPrint")
  valid_593969 = validateParameter(valid_593969, JBool, required = false,
                                 default = newJBool(true))
  if valid_593969 != nil:
    section.add "prettyPrint", valid_593969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593970: Call_GamesManagementAchievementsResetAllForAllPlayers_593960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft achievements for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_593970.validator(path, query, header, formData, body)
  let scheme = call_593970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593970.url(scheme.get, call_593970.host, call_593970.base,
                         call_593970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593970, url, valid)

proc call*(call_593971: Call_GamesManagementAchievementsResetAllForAllPlayers_593960;
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
  var query_593972 = newJObject()
  add(query_593972, "fields", newJString(fields))
  add(query_593972, "quotaUser", newJString(quotaUser))
  add(query_593972, "alt", newJString(alt))
  add(query_593972, "oauth_token", newJString(oauthToken))
  add(query_593972, "userIp", newJString(userIp))
  add(query_593972, "key", newJString(key))
  add(query_593972, "prettyPrint", newJBool(prettyPrint))
  result = call_593971.call(nil, query_593972, nil, nil, nil)

var gamesManagementAchievementsResetAllForAllPlayers* = Call_GamesManagementAchievementsResetAllForAllPlayers_593960(
    name: "gamesManagementAchievementsResetAllForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/resetAllForAllPlayers",
    validator: validate_GamesManagementAchievementsResetAllForAllPlayers_593961,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetAllForAllPlayers_593962,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetMultipleForAllPlayers_593973 = ref object of OpenApiRestCall_593424
proc url_GamesManagementAchievementsResetMultipleForAllPlayers_593975(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetMultipleForAllPlayers_593974(
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
  var valid_593976 = query.getOrDefault("fields")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "fields", valid_593976
  var valid_593977 = query.getOrDefault("quotaUser")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "quotaUser", valid_593977
  var valid_593978 = query.getOrDefault("alt")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("json"))
  if valid_593978 != nil:
    section.add "alt", valid_593978
  var valid_593979 = query.getOrDefault("oauth_token")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "oauth_token", valid_593979
  var valid_593980 = query.getOrDefault("userIp")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "userIp", valid_593980
  var valid_593981 = query.getOrDefault("key")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "key", valid_593981
  var valid_593982 = query.getOrDefault("prettyPrint")
  valid_593982 = validateParameter(valid_593982, JBool, required = false,
                                 default = newJBool(true))
  if valid_593982 != nil:
    section.add "prettyPrint", valid_593982
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

proc call*(call_593984: Call_GamesManagementAchievementsResetMultipleForAllPlayers_593973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets achievements with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft achievements may be reset.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_GamesManagementAchievementsResetMultipleForAllPlayers_593973;
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
  var query_593986 = newJObject()
  var body_593987 = newJObject()
  add(query_593986, "fields", newJString(fields))
  add(query_593986, "quotaUser", newJString(quotaUser))
  add(query_593986, "alt", newJString(alt))
  add(query_593986, "oauth_token", newJString(oauthToken))
  add(query_593986, "userIp", newJString(userIp))
  add(query_593986, "key", newJString(key))
  if body != nil:
    body_593987 = body
  add(query_593986, "prettyPrint", newJBool(prettyPrint))
  result = call_593985.call(nil, query_593986, nil, nil, body_593987)

var gamesManagementAchievementsResetMultipleForAllPlayers* = Call_GamesManagementAchievementsResetMultipleForAllPlayers_593973(
    name: "gamesManagementAchievementsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/resetMultipleForAllPlayers",
    validator: validate_GamesManagementAchievementsResetMultipleForAllPlayers_593974,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetMultipleForAllPlayers_593975,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsReset_593988 = ref object of OpenApiRestCall_593424
proc url_GamesManagementAchievementsReset_593990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesManagementAchievementsReset_593989(path: JsonNode;
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
  var valid_594005 = path.getOrDefault("achievementId")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "achievementId", valid_594005
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
  var valid_594006 = query.getOrDefault("fields")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "fields", valid_594006
  var valid_594007 = query.getOrDefault("quotaUser")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "quotaUser", valid_594007
  var valid_594008 = query.getOrDefault("alt")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = newJString("json"))
  if valid_594008 != nil:
    section.add "alt", valid_594008
  var valid_594009 = query.getOrDefault("oauth_token")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "oauth_token", valid_594009
  var valid_594010 = query.getOrDefault("userIp")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "userIp", valid_594010
  var valid_594011 = query.getOrDefault("key")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "key", valid_594011
  var valid_594012 = query.getOrDefault("prettyPrint")
  valid_594012 = validateParameter(valid_594012, JBool, required = false,
                                 default = newJBool(true))
  if valid_594012 != nil:
    section.add "prettyPrint", valid_594012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594013: Call_GamesManagementAchievementsReset_593988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the achievement with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_GamesManagementAchievementsReset_593988;
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
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  add(query_594016, "fields", newJString(fields))
  add(query_594016, "quotaUser", newJString(quotaUser))
  add(query_594016, "alt", newJString(alt))
  add(query_594016, "oauth_token", newJString(oauthToken))
  add(query_594016, "userIp", newJString(userIp))
  add(query_594016, "key", newJString(key))
  add(path_594015, "achievementId", newJString(achievementId))
  add(query_594016, "prettyPrint", newJBool(prettyPrint))
  result = call_594014.call(path_594015, query_594016, nil, nil, nil)

var gamesManagementAchievementsReset* = Call_GamesManagementAchievementsReset_593988(
    name: "gamesManagementAchievementsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/reset",
    validator: validate_GamesManagementAchievementsReset_593989,
    base: "/games/v1management", url: url_GamesManagementAchievementsReset_593990,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetForAllPlayers_594017 = ref object of OpenApiRestCall_593424
proc url_GamesManagementAchievementsResetForAllPlayers_594019(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesManagementAchievementsResetForAllPlayers_594018(
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
  var valid_594020 = path.getOrDefault("achievementId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "achievementId", valid_594020
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
  var valid_594021 = query.getOrDefault("fields")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "fields", valid_594021
  var valid_594022 = query.getOrDefault("quotaUser")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "quotaUser", valid_594022
  var valid_594023 = query.getOrDefault("alt")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = newJString("json"))
  if valid_594023 != nil:
    section.add "alt", valid_594023
  var valid_594024 = query.getOrDefault("oauth_token")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "oauth_token", valid_594024
  var valid_594025 = query.getOrDefault("userIp")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "userIp", valid_594025
  var valid_594026 = query.getOrDefault("key")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "key", valid_594026
  var valid_594027 = query.getOrDefault("prettyPrint")
  valid_594027 = validateParameter(valid_594027, JBool, required = false,
                                 default = newJBool(true))
  if valid_594027 != nil:
    section.add "prettyPrint", valid_594027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_GamesManagementAchievementsResetForAllPlayers_594017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the achievement with the given ID for all players. This method is only available to user accounts for your developer console. Only draft achievements can be reset.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_GamesManagementAchievementsResetForAllPlayers_594017;
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
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  add(query_594031, "fields", newJString(fields))
  add(query_594031, "quotaUser", newJString(quotaUser))
  add(query_594031, "alt", newJString(alt))
  add(query_594031, "oauth_token", newJString(oauthToken))
  add(query_594031, "userIp", newJString(userIp))
  add(query_594031, "key", newJString(key))
  add(path_594030, "achievementId", newJString(achievementId))
  add(query_594031, "prettyPrint", newJBool(prettyPrint))
  result = call_594029.call(path_594030, query_594031, nil, nil, nil)

var gamesManagementAchievementsResetForAllPlayers* = Call_GamesManagementAchievementsResetForAllPlayers_594017(
    name: "gamesManagementAchievementsResetForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/{achievementId}/resetForAllPlayers",
    validator: validate_GamesManagementAchievementsResetForAllPlayers_594018,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetForAllPlayers_594019,
    schemes: {Scheme.Https})
type
  Call_GamesManagementApplicationsListHidden_594032 = ref object of OpenApiRestCall_593424
proc url_GamesManagementApplicationsListHidden_594034(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesManagementApplicationsListHidden_594033(path: JsonNode;
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
  var valid_594035 = path.getOrDefault("applicationId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "applicationId", valid_594035
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
  var valid_594036 = query.getOrDefault("fields")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "fields", valid_594036
  var valid_594037 = query.getOrDefault("pageToken")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "pageToken", valid_594037
  var valid_594038 = query.getOrDefault("quotaUser")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "quotaUser", valid_594038
  var valid_594039 = query.getOrDefault("alt")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("json"))
  if valid_594039 != nil:
    section.add "alt", valid_594039
  var valid_594040 = query.getOrDefault("oauth_token")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "oauth_token", valid_594040
  var valid_594041 = query.getOrDefault("userIp")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "userIp", valid_594041
  var valid_594042 = query.getOrDefault("maxResults")
  valid_594042 = validateParameter(valid_594042, JInt, required = false, default = nil)
  if valid_594042 != nil:
    section.add "maxResults", valid_594042
  var valid_594043 = query.getOrDefault("key")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "key", valid_594043
  var valid_594044 = query.getOrDefault("prettyPrint")
  valid_594044 = validateParameter(valid_594044, JBool, required = false,
                                 default = newJBool(true))
  if valid_594044 != nil:
    section.add "prettyPrint", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_GamesManagementApplicationsListHidden_594032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of players hidden from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_GamesManagementApplicationsListHidden_594032;
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
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(query_594048, "fields", newJString(fields))
  add(query_594048, "pageToken", newJString(pageToken))
  add(query_594048, "quotaUser", newJString(quotaUser))
  add(query_594048, "alt", newJString(alt))
  add(query_594048, "oauth_token", newJString(oauthToken))
  add(query_594048, "userIp", newJString(userIp))
  add(path_594047, "applicationId", newJString(applicationId))
  add(query_594048, "maxResults", newJInt(maxResults))
  add(query_594048, "key", newJString(key))
  add(query_594048, "prettyPrint", newJBool(prettyPrint))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var gamesManagementApplicationsListHidden* = Call_GamesManagementApplicationsListHidden_594032(
    name: "gamesManagementApplicationsListHidden", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden",
    validator: validate_GamesManagementApplicationsListHidden_594033,
    base: "/games/v1management", url: url_GamesManagementApplicationsListHidden_594034,
    schemes: {Scheme.Https})
type
  Call_GamesManagementPlayersHide_594049 = ref object of OpenApiRestCall_593424
proc url_GamesManagementPlayersHide_594051(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesManagementPlayersHide_594050(path: JsonNode; query: JsonNode;
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
  var valid_594052 = path.getOrDefault("playerId")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "playerId", valid_594052
  var valid_594053 = path.getOrDefault("applicationId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "applicationId", valid_594053
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
  var valid_594054 = query.getOrDefault("fields")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "fields", valid_594054
  var valid_594055 = query.getOrDefault("quotaUser")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "quotaUser", valid_594055
  var valid_594056 = query.getOrDefault("alt")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = newJString("json"))
  if valid_594056 != nil:
    section.add "alt", valid_594056
  var valid_594057 = query.getOrDefault("oauth_token")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "oauth_token", valid_594057
  var valid_594058 = query.getOrDefault("userIp")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "userIp", valid_594058
  var valid_594059 = query.getOrDefault("key")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "key", valid_594059
  var valid_594060 = query.getOrDefault("prettyPrint")
  valid_594060 = validateParameter(valid_594060, JBool, required = false,
                                 default = newJBool(true))
  if valid_594060 != nil:
    section.add "prettyPrint", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_GamesManagementPlayersHide_594049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_GamesManagementPlayersHide_594049; playerId: string;
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
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(query_594064, "fields", newJString(fields))
  add(query_594064, "quotaUser", newJString(quotaUser))
  add(query_594064, "alt", newJString(alt))
  add(query_594064, "oauth_token", newJString(oauthToken))
  add(path_594063, "playerId", newJString(playerId))
  add(query_594064, "userIp", newJString(userIp))
  add(path_594063, "applicationId", newJString(applicationId))
  add(query_594064, "key", newJString(key))
  add(query_594064, "prettyPrint", newJBool(prettyPrint))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var gamesManagementPlayersHide* = Call_GamesManagementPlayersHide_594049(
    name: "gamesManagementPlayersHide", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden/{playerId}",
    validator: validate_GamesManagementPlayersHide_594050,
    base: "/games/v1management", url: url_GamesManagementPlayersHide_594051,
    schemes: {Scheme.Https})
type
  Call_GamesManagementPlayersUnhide_594065 = ref object of OpenApiRestCall_593424
proc url_GamesManagementPlayersUnhide_594067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesManagementPlayersUnhide_594066(path: JsonNode; query: JsonNode;
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
  var valid_594068 = path.getOrDefault("playerId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "playerId", valid_594068
  var valid_594069 = path.getOrDefault("applicationId")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "applicationId", valid_594069
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
  var valid_594070 = query.getOrDefault("fields")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "fields", valid_594070
  var valid_594071 = query.getOrDefault("quotaUser")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "quotaUser", valid_594071
  var valid_594072 = query.getOrDefault("alt")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = newJString("json"))
  if valid_594072 != nil:
    section.add "alt", valid_594072
  var valid_594073 = query.getOrDefault("oauth_token")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "oauth_token", valid_594073
  var valid_594074 = query.getOrDefault("userIp")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "userIp", valid_594074
  var valid_594075 = query.getOrDefault("key")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "key", valid_594075
  var valid_594076 = query.getOrDefault("prettyPrint")
  valid_594076 = validateParameter(valid_594076, JBool, required = false,
                                 default = newJBool(true))
  if valid_594076 != nil:
    section.add "prettyPrint", valid_594076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_GamesManagementPlayersUnhide_594065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unhide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_GamesManagementPlayersUnhide_594065; playerId: string;
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
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  add(query_594080, "fields", newJString(fields))
  add(query_594080, "quotaUser", newJString(quotaUser))
  add(query_594080, "alt", newJString(alt))
  add(query_594080, "oauth_token", newJString(oauthToken))
  add(path_594079, "playerId", newJString(playerId))
  add(query_594080, "userIp", newJString(userIp))
  add(path_594079, "applicationId", newJString(applicationId))
  add(query_594080, "key", newJString(key))
  add(query_594080, "prettyPrint", newJBool(prettyPrint))
  result = call_594078.call(path_594079, query_594080, nil, nil, nil)

var gamesManagementPlayersUnhide* = Call_GamesManagementPlayersUnhide_594065(
    name: "gamesManagementPlayersUnhide", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden/{playerId}",
    validator: validate_GamesManagementPlayersUnhide_594066,
    base: "/games/v1management", url: url_GamesManagementPlayersUnhide_594067,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetAll_594081 = ref object of OpenApiRestCall_593424
proc url_GamesManagementEventsResetAll_594083(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetAll_594082(path: JsonNode; query: JsonNode;
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
  var valid_594084 = query.getOrDefault("fields")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "fields", valid_594084
  var valid_594085 = query.getOrDefault("quotaUser")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "quotaUser", valid_594085
  var valid_594086 = query.getOrDefault("alt")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = newJString("json"))
  if valid_594086 != nil:
    section.add "alt", valid_594086
  var valid_594087 = query.getOrDefault("oauth_token")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "oauth_token", valid_594087
  var valid_594088 = query.getOrDefault("userIp")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "userIp", valid_594088
  var valid_594089 = query.getOrDefault("key")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "key", valid_594089
  var valid_594090 = query.getOrDefault("prettyPrint")
  valid_594090 = validateParameter(valid_594090, JBool, required = false,
                                 default = newJBool(true))
  if valid_594090 != nil:
    section.add "prettyPrint", valid_594090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_GamesManagementEventsResetAll_594081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on all events for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player will also be reset.
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_GamesManagementEventsResetAll_594081;
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
  var query_594093 = newJObject()
  add(query_594093, "fields", newJString(fields))
  add(query_594093, "quotaUser", newJString(quotaUser))
  add(query_594093, "alt", newJString(alt))
  add(query_594093, "oauth_token", newJString(oauthToken))
  add(query_594093, "userIp", newJString(userIp))
  add(query_594093, "key", newJString(key))
  add(query_594093, "prettyPrint", newJBool(prettyPrint))
  result = call_594092.call(nil, query_594093, nil, nil, nil)

var gamesManagementEventsResetAll* = Call_GamesManagementEventsResetAll_594081(
    name: "gamesManagementEventsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/reset",
    validator: validate_GamesManagementEventsResetAll_594082,
    base: "/games/v1management", url: url_GamesManagementEventsResetAll_594083,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetAllForAllPlayers_594094 = ref object of OpenApiRestCall_593424
proc url_GamesManagementEventsResetAllForAllPlayers_594096(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetAllForAllPlayers_594095(path: JsonNode;
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
  var valid_594097 = query.getOrDefault("fields")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "fields", valid_594097
  var valid_594098 = query.getOrDefault("quotaUser")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "quotaUser", valid_594098
  var valid_594099 = query.getOrDefault("alt")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = newJString("json"))
  if valid_594099 != nil:
    section.add "alt", valid_594099
  var valid_594100 = query.getOrDefault("oauth_token")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "oauth_token", valid_594100
  var valid_594101 = query.getOrDefault("userIp")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "userIp", valid_594101
  var valid_594102 = query.getOrDefault("key")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "key", valid_594102
  var valid_594103 = query.getOrDefault("prettyPrint")
  valid_594103 = validateParameter(valid_594103, JBool, required = false,
                                 default = newJBool(true))
  if valid_594103 != nil:
    section.add "prettyPrint", valid_594103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594104: Call_GamesManagementEventsResetAllForAllPlayers_594094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft events for all players. This method is only available to user accounts for your developer console. All quests that use any of these events will also be reset.
  ## 
  let valid = call_594104.validator(path, query, header, formData, body)
  let scheme = call_594104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594104.url(scheme.get, call_594104.host, call_594104.base,
                         call_594104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594104, url, valid)

proc call*(call_594105: Call_GamesManagementEventsResetAllForAllPlayers_594094;
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
  var query_594106 = newJObject()
  add(query_594106, "fields", newJString(fields))
  add(query_594106, "quotaUser", newJString(quotaUser))
  add(query_594106, "alt", newJString(alt))
  add(query_594106, "oauth_token", newJString(oauthToken))
  add(query_594106, "userIp", newJString(userIp))
  add(query_594106, "key", newJString(key))
  add(query_594106, "prettyPrint", newJBool(prettyPrint))
  result = call_594105.call(nil, query_594106, nil, nil, nil)

var gamesManagementEventsResetAllForAllPlayers* = Call_GamesManagementEventsResetAllForAllPlayers_594094(
    name: "gamesManagementEventsResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/resetAllForAllPlayers",
    validator: validate_GamesManagementEventsResetAllForAllPlayers_594095,
    base: "/games/v1management",
    url: url_GamesManagementEventsResetAllForAllPlayers_594096,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetMultipleForAllPlayers_594107 = ref object of OpenApiRestCall_593424
proc url_GamesManagementEventsResetMultipleForAllPlayers_594109(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetMultipleForAllPlayers_594108(
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
  var valid_594110 = query.getOrDefault("fields")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "fields", valid_594110
  var valid_594111 = query.getOrDefault("quotaUser")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "quotaUser", valid_594111
  var valid_594112 = query.getOrDefault("alt")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = newJString("json"))
  if valid_594112 != nil:
    section.add "alt", valid_594112
  var valid_594113 = query.getOrDefault("oauth_token")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "oauth_token", valid_594113
  var valid_594114 = query.getOrDefault("userIp")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "userIp", valid_594114
  var valid_594115 = query.getOrDefault("key")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "key", valid_594115
  var valid_594116 = query.getOrDefault("prettyPrint")
  valid_594116 = validateParameter(valid_594116, JBool, required = false,
                                 default = newJBool(true))
  if valid_594116 != nil:
    section.add "prettyPrint", valid_594116
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

proc call*(call_594118: Call_GamesManagementEventsResetMultipleForAllPlayers_594107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets events with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft events may be reset. All quests that use any of the events will also be reset.
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_GamesManagementEventsResetMultipleForAllPlayers_594107;
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
  var query_594120 = newJObject()
  var body_594121 = newJObject()
  add(query_594120, "fields", newJString(fields))
  add(query_594120, "quotaUser", newJString(quotaUser))
  add(query_594120, "alt", newJString(alt))
  add(query_594120, "oauth_token", newJString(oauthToken))
  add(query_594120, "userIp", newJString(userIp))
  add(query_594120, "key", newJString(key))
  if body != nil:
    body_594121 = body
  add(query_594120, "prettyPrint", newJBool(prettyPrint))
  result = call_594119.call(nil, query_594120, nil, nil, body_594121)

var gamesManagementEventsResetMultipleForAllPlayers* = Call_GamesManagementEventsResetMultipleForAllPlayers_594107(
    name: "gamesManagementEventsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/events/resetMultipleForAllPlayers",
    validator: validate_GamesManagementEventsResetMultipleForAllPlayers_594108,
    base: "/games/v1management",
    url: url_GamesManagementEventsResetMultipleForAllPlayers_594109,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsReset_594122 = ref object of OpenApiRestCall_593424
proc url_GamesManagementEventsReset_594124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesManagementEventsReset_594123(path: JsonNode; query: JsonNode;
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
  var valid_594125 = path.getOrDefault("eventId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "eventId", valid_594125
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
  var valid_594126 = query.getOrDefault("fields")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "fields", valid_594126
  var valid_594127 = query.getOrDefault("quotaUser")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "quotaUser", valid_594127
  var valid_594128 = query.getOrDefault("alt")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = newJString("json"))
  if valid_594128 != nil:
    section.add "alt", valid_594128
  var valid_594129 = query.getOrDefault("oauth_token")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "oauth_token", valid_594129
  var valid_594130 = query.getOrDefault("userIp")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "userIp", valid_594130
  var valid_594131 = query.getOrDefault("key")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "key", valid_594131
  var valid_594132 = query.getOrDefault("prettyPrint")
  valid_594132 = validateParameter(valid_594132, JBool, required = false,
                                 default = newJBool(true))
  if valid_594132 != nil:
    section.add "prettyPrint", valid_594132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_GamesManagementEventsReset_594122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on the event with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player that use the event will also be reset.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_GamesManagementEventsReset_594122; eventId: string;
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
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  add(query_594136, "fields", newJString(fields))
  add(query_594136, "quotaUser", newJString(quotaUser))
  add(query_594136, "alt", newJString(alt))
  add(query_594136, "oauth_token", newJString(oauthToken))
  add(query_594136, "userIp", newJString(userIp))
  add(path_594135, "eventId", newJString(eventId))
  add(query_594136, "key", newJString(key))
  add(query_594136, "prettyPrint", newJBool(prettyPrint))
  result = call_594134.call(path_594135, query_594136, nil, nil, nil)

var gamesManagementEventsReset* = Call_GamesManagementEventsReset_594122(
    name: "gamesManagementEventsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/{eventId}/reset",
    validator: validate_GamesManagementEventsReset_594123,
    base: "/games/v1management", url: url_GamesManagementEventsReset_594124,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetForAllPlayers_594137 = ref object of OpenApiRestCall_593424
proc url_GamesManagementEventsResetForAllPlayers_594139(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesManagementEventsResetForAllPlayers_594138(path: JsonNode;
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
  var valid_594140 = path.getOrDefault("eventId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "eventId", valid_594140
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
  var valid_594141 = query.getOrDefault("fields")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "fields", valid_594141
  var valid_594142 = query.getOrDefault("quotaUser")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "quotaUser", valid_594142
  var valid_594143 = query.getOrDefault("alt")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = newJString("json"))
  if valid_594143 != nil:
    section.add "alt", valid_594143
  var valid_594144 = query.getOrDefault("oauth_token")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "oauth_token", valid_594144
  var valid_594145 = query.getOrDefault("userIp")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "userIp", valid_594145
  var valid_594146 = query.getOrDefault("key")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "key", valid_594146
  var valid_594147 = query.getOrDefault("prettyPrint")
  valid_594147 = validateParameter(valid_594147, JBool, required = false,
                                 default = newJBool(true))
  if valid_594147 != nil:
    section.add "prettyPrint", valid_594147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594148: Call_GamesManagementEventsResetForAllPlayers_594137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the event with the given ID for all players. This method is only available to user accounts for your developer console. Only draft events can be reset. All quests that use the event will also be reset.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_GamesManagementEventsResetForAllPlayers_594137;
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
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  add(query_594151, "fields", newJString(fields))
  add(query_594151, "quotaUser", newJString(quotaUser))
  add(query_594151, "alt", newJString(alt))
  add(query_594151, "oauth_token", newJString(oauthToken))
  add(query_594151, "userIp", newJString(userIp))
  add(path_594150, "eventId", newJString(eventId))
  add(query_594151, "key", newJString(key))
  add(query_594151, "prettyPrint", newJBool(prettyPrint))
  result = call_594149.call(path_594150, query_594151, nil, nil, nil)

var gamesManagementEventsResetForAllPlayers* = Call_GamesManagementEventsResetForAllPlayers_594137(
    name: "gamesManagementEventsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/{eventId}/resetForAllPlayers",
    validator: validate_GamesManagementEventsResetForAllPlayers_594138,
    base: "/games/v1management", url: url_GamesManagementEventsResetForAllPlayers_594139,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresReset_594152 = ref object of OpenApiRestCall_593424
proc url_GamesManagementScoresReset_594154(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesManagementScoresReset_594153(path: JsonNode; query: JsonNode;
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
  var valid_594155 = path.getOrDefault("leaderboardId")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "leaderboardId", valid_594155
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
  var valid_594156 = query.getOrDefault("fields")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "fields", valid_594156
  var valid_594157 = query.getOrDefault("quotaUser")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "quotaUser", valid_594157
  var valid_594158 = query.getOrDefault("alt")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = newJString("json"))
  if valid_594158 != nil:
    section.add "alt", valid_594158
  var valid_594159 = query.getOrDefault("oauth_token")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "oauth_token", valid_594159
  var valid_594160 = query.getOrDefault("userIp")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "userIp", valid_594160
  var valid_594161 = query.getOrDefault("key")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "key", valid_594161
  var valid_594162 = query.getOrDefault("prettyPrint")
  valid_594162 = validateParameter(valid_594162, JBool, required = false,
                                 default = newJBool(true))
  if valid_594162 != nil:
    section.add "prettyPrint", valid_594162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594163: Call_GamesManagementScoresReset_594152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets scores for the leaderboard with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_594163.validator(path, query, header, formData, body)
  let scheme = call_594163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594163.url(scheme.get, call_594163.host, call_594163.base,
                         call_594163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594163, url, valid)

proc call*(call_594164: Call_GamesManagementScoresReset_594152;
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
  var path_594165 = newJObject()
  var query_594166 = newJObject()
  add(query_594166, "fields", newJString(fields))
  add(query_594166, "quotaUser", newJString(quotaUser))
  add(query_594166, "alt", newJString(alt))
  add(path_594165, "leaderboardId", newJString(leaderboardId))
  add(query_594166, "oauth_token", newJString(oauthToken))
  add(query_594166, "userIp", newJString(userIp))
  add(query_594166, "key", newJString(key))
  add(query_594166, "prettyPrint", newJBool(prettyPrint))
  result = call_594164.call(path_594165, query_594166, nil, nil, nil)

var gamesManagementScoresReset* = Call_GamesManagementScoresReset_594152(
    name: "gamesManagementScoresReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/reset",
    validator: validate_GamesManagementScoresReset_594153,
    base: "/games/v1management", url: url_GamesManagementScoresReset_594154,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetForAllPlayers_594167 = ref object of OpenApiRestCall_593424
proc url_GamesManagementScoresResetForAllPlayers_594169(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesManagementScoresResetForAllPlayers_594168(path: JsonNode;
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
  var valid_594170 = path.getOrDefault("leaderboardId")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "leaderboardId", valid_594170
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
  var valid_594171 = query.getOrDefault("fields")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "fields", valid_594171
  var valid_594172 = query.getOrDefault("quotaUser")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "quotaUser", valid_594172
  var valid_594173 = query.getOrDefault("alt")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = newJString("json"))
  if valid_594173 != nil:
    section.add "alt", valid_594173
  var valid_594174 = query.getOrDefault("oauth_token")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "oauth_token", valid_594174
  var valid_594175 = query.getOrDefault("userIp")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "userIp", valid_594175
  var valid_594176 = query.getOrDefault("key")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "key", valid_594176
  var valid_594177 = query.getOrDefault("prettyPrint")
  valid_594177 = validateParameter(valid_594177, JBool, required = false,
                                 default = newJBool(true))
  if valid_594177 != nil:
    section.add "prettyPrint", valid_594177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594178: Call_GamesManagementScoresResetForAllPlayers_594167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for the leaderboard with the given ID for all players. This method is only available to user accounts for your developer console. Only draft leaderboards can be reset.
  ## 
  let valid = call_594178.validator(path, query, header, formData, body)
  let scheme = call_594178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594178.url(scheme.get, call_594178.host, call_594178.base,
                         call_594178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594178, url, valid)

proc call*(call_594179: Call_GamesManagementScoresResetForAllPlayers_594167;
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
  var path_594180 = newJObject()
  var query_594181 = newJObject()
  add(query_594181, "fields", newJString(fields))
  add(query_594181, "quotaUser", newJString(quotaUser))
  add(query_594181, "alt", newJString(alt))
  add(path_594180, "leaderboardId", newJString(leaderboardId))
  add(query_594181, "oauth_token", newJString(oauthToken))
  add(query_594181, "userIp", newJString(userIp))
  add(query_594181, "key", newJString(key))
  add(query_594181, "prettyPrint", newJBool(prettyPrint))
  result = call_594179.call(path_594180, query_594181, nil, nil, nil)

var gamesManagementScoresResetForAllPlayers* = Call_GamesManagementScoresResetForAllPlayers_594167(
    name: "gamesManagementScoresResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/resetForAllPlayers",
    validator: validate_GamesManagementScoresResetForAllPlayers_594168,
    base: "/games/v1management", url: url_GamesManagementScoresResetForAllPlayers_594169,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetAll_594182 = ref object of OpenApiRestCall_593424
proc url_GamesManagementQuestsResetAll_594184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetAll_594183(path: JsonNode; query: JsonNode;
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
  var valid_594185 = query.getOrDefault("fields")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "fields", valid_594185
  var valid_594186 = query.getOrDefault("quotaUser")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "quotaUser", valid_594186
  var valid_594187 = query.getOrDefault("alt")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = newJString("json"))
  if valid_594187 != nil:
    section.add "alt", valid_594187
  var valid_594188 = query.getOrDefault("oauth_token")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "oauth_token", valid_594188
  var valid_594189 = query.getOrDefault("userIp")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "userIp", valid_594189
  var valid_594190 = query.getOrDefault("key")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "key", valid_594190
  var valid_594191 = query.getOrDefault("prettyPrint")
  valid_594191 = validateParameter(valid_594191, JBool, required = false,
                                 default = newJBool(true))
  if valid_594191 != nil:
    section.add "prettyPrint", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_GamesManagementQuestsResetAll_594182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on all quests for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_GamesManagementQuestsResetAll_594182;
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
  var query_594194 = newJObject()
  add(query_594194, "fields", newJString(fields))
  add(query_594194, "quotaUser", newJString(quotaUser))
  add(query_594194, "alt", newJString(alt))
  add(query_594194, "oauth_token", newJString(oauthToken))
  add(query_594194, "userIp", newJString(userIp))
  add(query_594194, "key", newJString(key))
  add(query_594194, "prettyPrint", newJBool(prettyPrint))
  result = call_594193.call(nil, query_594194, nil, nil, nil)

var gamesManagementQuestsResetAll* = Call_GamesManagementQuestsResetAll_594182(
    name: "gamesManagementQuestsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/reset",
    validator: validate_GamesManagementQuestsResetAll_594183,
    base: "/games/v1management", url: url_GamesManagementQuestsResetAll_594184,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetAllForAllPlayers_594195 = ref object of OpenApiRestCall_593424
proc url_GamesManagementQuestsResetAllForAllPlayers_594197(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetAllForAllPlayers_594196(path: JsonNode;
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
  var valid_594198 = query.getOrDefault("fields")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "fields", valid_594198
  var valid_594199 = query.getOrDefault("quotaUser")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "quotaUser", valid_594199
  var valid_594200 = query.getOrDefault("alt")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = newJString("json"))
  if valid_594200 != nil:
    section.add "alt", valid_594200
  var valid_594201 = query.getOrDefault("oauth_token")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "oauth_token", valid_594201
  var valid_594202 = query.getOrDefault("userIp")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "userIp", valid_594202
  var valid_594203 = query.getOrDefault("key")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "key", valid_594203
  var valid_594204 = query.getOrDefault("prettyPrint")
  valid_594204 = validateParameter(valid_594204, JBool, required = false,
                                 default = newJBool(true))
  if valid_594204 != nil:
    section.add "prettyPrint", valid_594204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594205: Call_GamesManagementQuestsResetAllForAllPlayers_594195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft quests for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_GamesManagementQuestsResetAllForAllPlayers_594195;
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
  var query_594207 = newJObject()
  add(query_594207, "fields", newJString(fields))
  add(query_594207, "quotaUser", newJString(quotaUser))
  add(query_594207, "alt", newJString(alt))
  add(query_594207, "oauth_token", newJString(oauthToken))
  add(query_594207, "userIp", newJString(userIp))
  add(query_594207, "key", newJString(key))
  add(query_594207, "prettyPrint", newJBool(prettyPrint))
  result = call_594206.call(nil, query_594207, nil, nil, nil)

var gamesManagementQuestsResetAllForAllPlayers* = Call_GamesManagementQuestsResetAllForAllPlayers_594195(
    name: "gamesManagementQuestsResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/resetAllForAllPlayers",
    validator: validate_GamesManagementQuestsResetAllForAllPlayers_594196,
    base: "/games/v1management",
    url: url_GamesManagementQuestsResetAllForAllPlayers_594197,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetMultipleForAllPlayers_594208 = ref object of OpenApiRestCall_593424
proc url_GamesManagementQuestsResetMultipleForAllPlayers_594210(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetMultipleForAllPlayers_594209(
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
  var valid_594211 = query.getOrDefault("fields")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "fields", valid_594211
  var valid_594212 = query.getOrDefault("quotaUser")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "quotaUser", valid_594212
  var valid_594213 = query.getOrDefault("alt")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = newJString("json"))
  if valid_594213 != nil:
    section.add "alt", valid_594213
  var valid_594214 = query.getOrDefault("oauth_token")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "oauth_token", valid_594214
  var valid_594215 = query.getOrDefault("userIp")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "userIp", valid_594215
  var valid_594216 = query.getOrDefault("key")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "key", valid_594216
  var valid_594217 = query.getOrDefault("prettyPrint")
  valid_594217 = validateParameter(valid_594217, JBool, required = false,
                                 default = newJBool(true))
  if valid_594217 != nil:
    section.add "prettyPrint", valid_594217
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

proc call*(call_594219: Call_GamesManagementQuestsResetMultipleForAllPlayers_594208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets quests with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft quests may be reset.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_GamesManagementQuestsResetMultipleForAllPlayers_594208;
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
  var query_594221 = newJObject()
  var body_594222 = newJObject()
  add(query_594221, "fields", newJString(fields))
  add(query_594221, "quotaUser", newJString(quotaUser))
  add(query_594221, "alt", newJString(alt))
  add(query_594221, "oauth_token", newJString(oauthToken))
  add(query_594221, "userIp", newJString(userIp))
  add(query_594221, "key", newJString(key))
  if body != nil:
    body_594222 = body
  add(query_594221, "prettyPrint", newJBool(prettyPrint))
  result = call_594220.call(nil, query_594221, nil, nil, body_594222)

var gamesManagementQuestsResetMultipleForAllPlayers* = Call_GamesManagementQuestsResetMultipleForAllPlayers_594208(
    name: "gamesManagementQuestsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/quests/resetMultipleForAllPlayers",
    validator: validate_GamesManagementQuestsResetMultipleForAllPlayers_594209,
    base: "/games/v1management",
    url: url_GamesManagementQuestsResetMultipleForAllPlayers_594210,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsReset_594223 = ref object of OpenApiRestCall_593424
proc url_GamesManagementQuestsReset_594225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesManagementQuestsReset_594224(path: JsonNode; query: JsonNode;
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
  var valid_594226 = path.getOrDefault("questId")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "questId", valid_594226
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
  var valid_594227 = query.getOrDefault("fields")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "fields", valid_594227
  var valid_594228 = query.getOrDefault("quotaUser")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "quotaUser", valid_594228
  var valid_594229 = query.getOrDefault("alt")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = newJString("json"))
  if valid_594229 != nil:
    section.add "alt", valid_594229
  var valid_594230 = query.getOrDefault("oauth_token")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "oauth_token", valid_594230
  var valid_594231 = query.getOrDefault("userIp")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "userIp", valid_594231
  var valid_594232 = query.getOrDefault("key")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "key", valid_594232
  var valid_594233 = query.getOrDefault("prettyPrint")
  valid_594233 = validateParameter(valid_594233, JBool, required = false,
                                 default = newJBool(true))
  if valid_594233 != nil:
    section.add "prettyPrint", valid_594233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594234: Call_GamesManagementQuestsReset_594223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on the quest with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_594234.validator(path, query, header, formData, body)
  let scheme = call_594234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594234.url(scheme.get, call_594234.host, call_594234.base,
                         call_594234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594234, url, valid)

proc call*(call_594235: Call_GamesManagementQuestsReset_594223; questId: string;
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
  var path_594236 = newJObject()
  var query_594237 = newJObject()
  add(query_594237, "fields", newJString(fields))
  add(query_594237, "quotaUser", newJString(quotaUser))
  add(query_594237, "alt", newJString(alt))
  add(query_594237, "oauth_token", newJString(oauthToken))
  add(query_594237, "userIp", newJString(userIp))
  add(query_594237, "key", newJString(key))
  add(path_594236, "questId", newJString(questId))
  add(query_594237, "prettyPrint", newJBool(prettyPrint))
  result = call_594235.call(path_594236, query_594237, nil, nil, nil)

var gamesManagementQuestsReset* = Call_GamesManagementQuestsReset_594223(
    name: "gamesManagementQuestsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/{questId}/reset",
    validator: validate_GamesManagementQuestsReset_594224,
    base: "/games/v1management", url: url_GamesManagementQuestsReset_594225,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetForAllPlayers_594238 = ref object of OpenApiRestCall_593424
proc url_GamesManagementQuestsResetForAllPlayers_594240(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GamesManagementQuestsResetForAllPlayers_594239(path: JsonNode;
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
  var valid_594241 = path.getOrDefault("questId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "questId", valid_594241
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
  var valid_594242 = query.getOrDefault("fields")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "fields", valid_594242
  var valid_594243 = query.getOrDefault("quotaUser")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "quotaUser", valid_594243
  var valid_594244 = query.getOrDefault("alt")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = newJString("json"))
  if valid_594244 != nil:
    section.add "alt", valid_594244
  var valid_594245 = query.getOrDefault("oauth_token")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "oauth_token", valid_594245
  var valid_594246 = query.getOrDefault("userIp")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "userIp", valid_594246
  var valid_594247 = query.getOrDefault("key")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "key", valid_594247
  var valid_594248 = query.getOrDefault("prettyPrint")
  valid_594248 = validateParameter(valid_594248, JBool, required = false,
                                 default = newJBool(true))
  if valid_594248 != nil:
    section.add "prettyPrint", valid_594248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594249: Call_GamesManagementQuestsResetForAllPlayers_594238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all player progress on the quest with the given ID for all players. This method is only available to user accounts for your developer console. Only draft quests can be reset.
  ## 
  let valid = call_594249.validator(path, query, header, formData, body)
  let scheme = call_594249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594249.url(scheme.get, call_594249.host, call_594249.base,
                         call_594249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594249, url, valid)

proc call*(call_594250: Call_GamesManagementQuestsResetForAllPlayers_594238;
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
  var path_594251 = newJObject()
  var query_594252 = newJObject()
  add(query_594252, "fields", newJString(fields))
  add(query_594252, "quotaUser", newJString(quotaUser))
  add(query_594252, "alt", newJString(alt))
  add(query_594252, "oauth_token", newJString(oauthToken))
  add(query_594252, "userIp", newJString(userIp))
  add(query_594252, "key", newJString(key))
  add(path_594251, "questId", newJString(questId))
  add(query_594252, "prettyPrint", newJBool(prettyPrint))
  result = call_594250.call(path_594251, query_594252, nil, nil, nil)

var gamesManagementQuestsResetForAllPlayers* = Call_GamesManagementQuestsResetForAllPlayers_594238(
    name: "gamesManagementQuestsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/{questId}/resetForAllPlayers",
    validator: validate_GamesManagementQuestsResetForAllPlayers_594239,
    base: "/games/v1management", url: url_GamesManagementQuestsResetForAllPlayers_594240,
    schemes: {Scheme.Https})
type
  Call_GamesManagementRoomsReset_594253 = ref object of OpenApiRestCall_593424
proc url_GamesManagementRoomsReset_594255(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementRoomsReset_594254(path: JsonNode; query: JsonNode;
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
  var valid_594256 = query.getOrDefault("fields")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "fields", valid_594256
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
  var valid_594259 = query.getOrDefault("oauth_token")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "oauth_token", valid_594259
  var valid_594260 = query.getOrDefault("userIp")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "userIp", valid_594260
  var valid_594261 = query.getOrDefault("key")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "key", valid_594261
  var valid_594262 = query.getOrDefault("prettyPrint")
  valid_594262 = validateParameter(valid_594262, JBool, required = false,
                                 default = newJBool(true))
  if valid_594262 != nil:
    section.add "prettyPrint", valid_594262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594263: Call_GamesManagementRoomsReset_594253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reset all rooms for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_GamesManagementRoomsReset_594253; fields: string = "";
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
  var query_594265 = newJObject()
  add(query_594265, "fields", newJString(fields))
  add(query_594265, "quotaUser", newJString(quotaUser))
  add(query_594265, "alt", newJString(alt))
  add(query_594265, "oauth_token", newJString(oauthToken))
  add(query_594265, "userIp", newJString(userIp))
  add(query_594265, "key", newJString(key))
  add(query_594265, "prettyPrint", newJBool(prettyPrint))
  result = call_594264.call(nil, query_594265, nil, nil, nil)

var gamesManagementRoomsReset* = Call_GamesManagementRoomsReset_594253(
    name: "gamesManagementRoomsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/reset",
    validator: validate_GamesManagementRoomsReset_594254,
    base: "/games/v1management", url: url_GamesManagementRoomsReset_594255,
    schemes: {Scheme.Https})
type
  Call_GamesManagementRoomsResetForAllPlayers_594266 = ref object of OpenApiRestCall_593424
proc url_GamesManagementRoomsResetForAllPlayers_594268(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementRoomsResetForAllPlayers_594267(path: JsonNode;
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
  var valid_594269 = query.getOrDefault("fields")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = nil)
  if valid_594269 != nil:
    section.add "fields", valid_594269
  var valid_594270 = query.getOrDefault("quotaUser")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "quotaUser", valid_594270
  var valid_594271 = query.getOrDefault("alt")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = newJString("json"))
  if valid_594271 != nil:
    section.add "alt", valid_594271
  var valid_594272 = query.getOrDefault("oauth_token")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "oauth_token", valid_594272
  var valid_594273 = query.getOrDefault("userIp")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "userIp", valid_594273
  var valid_594274 = query.getOrDefault("key")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "key", valid_594274
  var valid_594275 = query.getOrDefault("prettyPrint")
  valid_594275 = validateParameter(valid_594275, JBool, required = false,
                                 default = newJBool(true))
  if valid_594275 != nil:
    section.add "prettyPrint", valid_594275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594276: Call_GamesManagementRoomsResetForAllPlayers_594266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes rooms where the only room participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_594276.validator(path, query, header, formData, body)
  let scheme = call_594276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594276.url(scheme.get, call_594276.host, call_594276.base,
                         call_594276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594276, url, valid)

proc call*(call_594277: Call_GamesManagementRoomsResetForAllPlayers_594266;
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
  var query_594278 = newJObject()
  add(query_594278, "fields", newJString(fields))
  add(query_594278, "quotaUser", newJString(quotaUser))
  add(query_594278, "alt", newJString(alt))
  add(query_594278, "oauth_token", newJString(oauthToken))
  add(query_594278, "userIp", newJString(userIp))
  add(query_594278, "key", newJString(key))
  add(query_594278, "prettyPrint", newJBool(prettyPrint))
  result = call_594277.call(nil, query_594278, nil, nil, nil)

var gamesManagementRoomsResetForAllPlayers* = Call_GamesManagementRoomsResetForAllPlayers_594266(
    name: "gamesManagementRoomsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/resetForAllPlayers",
    validator: validate_GamesManagementRoomsResetForAllPlayers_594267,
    base: "/games/v1management", url: url_GamesManagementRoomsResetForAllPlayers_594268,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetAll_594279 = ref object of OpenApiRestCall_593424
proc url_GamesManagementScoresResetAll_594281(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetAll_594280(path: JsonNode; query: JsonNode;
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
  var valid_594282 = query.getOrDefault("fields")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "fields", valid_594282
  var valid_594283 = query.getOrDefault("quotaUser")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "quotaUser", valid_594283
  var valid_594284 = query.getOrDefault("alt")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = newJString("json"))
  if valid_594284 != nil:
    section.add "alt", valid_594284
  var valid_594285 = query.getOrDefault("oauth_token")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "oauth_token", valid_594285
  var valid_594286 = query.getOrDefault("userIp")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "userIp", valid_594286
  var valid_594287 = query.getOrDefault("key")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "key", valid_594287
  var valid_594288 = query.getOrDefault("prettyPrint")
  valid_594288 = validateParameter(valid_594288, JBool, required = false,
                                 default = newJBool(true))
  if valid_594288 != nil:
    section.add "prettyPrint", valid_594288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594289: Call_GamesManagementScoresResetAll_594279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all scores for all leaderboards for the currently authenticated players. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_594289.validator(path, query, header, formData, body)
  let scheme = call_594289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594289.url(scheme.get, call_594289.host, call_594289.base,
                         call_594289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594289, url, valid)

proc call*(call_594290: Call_GamesManagementScoresResetAll_594279;
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
  var query_594291 = newJObject()
  add(query_594291, "fields", newJString(fields))
  add(query_594291, "quotaUser", newJString(quotaUser))
  add(query_594291, "alt", newJString(alt))
  add(query_594291, "oauth_token", newJString(oauthToken))
  add(query_594291, "userIp", newJString(userIp))
  add(query_594291, "key", newJString(key))
  add(query_594291, "prettyPrint", newJBool(prettyPrint))
  result = call_594290.call(nil, query_594291, nil, nil, nil)

var gamesManagementScoresResetAll* = Call_GamesManagementScoresResetAll_594279(
    name: "gamesManagementScoresResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/scores/reset",
    validator: validate_GamesManagementScoresResetAll_594280,
    base: "/games/v1management", url: url_GamesManagementScoresResetAll_594281,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetAllForAllPlayers_594292 = ref object of OpenApiRestCall_593424
proc url_GamesManagementScoresResetAllForAllPlayers_594294(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetAllForAllPlayers_594293(path: JsonNode;
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
  var valid_594295 = query.getOrDefault("fields")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "fields", valid_594295
  var valid_594296 = query.getOrDefault("quotaUser")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "quotaUser", valid_594296
  var valid_594297 = query.getOrDefault("alt")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = newJString("json"))
  if valid_594297 != nil:
    section.add "alt", valid_594297
  var valid_594298 = query.getOrDefault("oauth_token")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "oauth_token", valid_594298
  var valid_594299 = query.getOrDefault("userIp")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "userIp", valid_594299
  var valid_594300 = query.getOrDefault("key")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "key", valid_594300
  var valid_594301 = query.getOrDefault("prettyPrint")
  valid_594301 = validateParameter(valid_594301, JBool, required = false,
                                 default = newJBool(true))
  if valid_594301 != nil:
    section.add "prettyPrint", valid_594301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594302: Call_GamesManagementScoresResetAllForAllPlayers_594292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for all draft leaderboards for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_594302.validator(path, query, header, formData, body)
  let scheme = call_594302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594302.url(scheme.get, call_594302.host, call_594302.base,
                         call_594302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594302, url, valid)

proc call*(call_594303: Call_GamesManagementScoresResetAllForAllPlayers_594292;
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
  var query_594304 = newJObject()
  add(query_594304, "fields", newJString(fields))
  add(query_594304, "quotaUser", newJString(quotaUser))
  add(query_594304, "alt", newJString(alt))
  add(query_594304, "oauth_token", newJString(oauthToken))
  add(query_594304, "userIp", newJString(userIp))
  add(query_594304, "key", newJString(key))
  add(query_594304, "prettyPrint", newJBool(prettyPrint))
  result = call_594303.call(nil, query_594304, nil, nil, nil)

var gamesManagementScoresResetAllForAllPlayers* = Call_GamesManagementScoresResetAllForAllPlayers_594292(
    name: "gamesManagementScoresResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/scores/resetAllForAllPlayers",
    validator: validate_GamesManagementScoresResetAllForAllPlayers_594293,
    base: "/games/v1management",
    url: url_GamesManagementScoresResetAllForAllPlayers_594294,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetMultipleForAllPlayers_594305 = ref object of OpenApiRestCall_593424
proc url_GamesManagementScoresResetMultipleForAllPlayers_594307(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetMultipleForAllPlayers_594306(
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
  var valid_594308 = query.getOrDefault("fields")
  valid_594308 = validateParameter(valid_594308, JString, required = false,
                                 default = nil)
  if valid_594308 != nil:
    section.add "fields", valid_594308
  var valid_594309 = query.getOrDefault("quotaUser")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "quotaUser", valid_594309
  var valid_594310 = query.getOrDefault("alt")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = newJString("json"))
  if valid_594310 != nil:
    section.add "alt", valid_594310
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594316: Call_GamesManagementScoresResetMultipleForAllPlayers_594305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for the leaderboards with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft leaderboards may be reset.
  ## 
  let valid = call_594316.validator(path, query, header, formData, body)
  let scheme = call_594316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594316.url(scheme.get, call_594316.host, call_594316.base,
                         call_594316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594316, url, valid)

proc call*(call_594317: Call_GamesManagementScoresResetMultipleForAllPlayers_594305;
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
  var query_594318 = newJObject()
  var body_594319 = newJObject()
  add(query_594318, "fields", newJString(fields))
  add(query_594318, "quotaUser", newJString(quotaUser))
  add(query_594318, "alt", newJString(alt))
  add(query_594318, "oauth_token", newJString(oauthToken))
  add(query_594318, "userIp", newJString(userIp))
  add(query_594318, "key", newJString(key))
  if body != nil:
    body_594319 = body
  add(query_594318, "prettyPrint", newJBool(prettyPrint))
  result = call_594317.call(nil, query_594318, nil, nil, body_594319)

var gamesManagementScoresResetMultipleForAllPlayers* = Call_GamesManagementScoresResetMultipleForAllPlayers_594305(
    name: "gamesManagementScoresResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/scores/resetMultipleForAllPlayers",
    validator: validate_GamesManagementScoresResetMultipleForAllPlayers_594306,
    base: "/games/v1management",
    url: url_GamesManagementScoresResetMultipleForAllPlayers_594307,
    schemes: {Scheme.Https})
type
  Call_GamesManagementTurnBasedMatchesReset_594320 = ref object of OpenApiRestCall_593424
proc url_GamesManagementTurnBasedMatchesReset_594322(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementTurnBasedMatchesReset_594321(path: JsonNode;
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
  var valid_594323 = query.getOrDefault("fields")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "fields", valid_594323
  var valid_594324 = query.getOrDefault("quotaUser")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "quotaUser", valid_594324
  var valid_594325 = query.getOrDefault("alt")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = newJString("json"))
  if valid_594325 != nil:
    section.add "alt", valid_594325
  var valid_594326 = query.getOrDefault("oauth_token")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "oauth_token", valid_594326
  var valid_594327 = query.getOrDefault("userIp")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "userIp", valid_594327
  var valid_594328 = query.getOrDefault("key")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "key", valid_594328
  var valid_594329 = query.getOrDefault("prettyPrint")
  valid_594329 = validateParameter(valid_594329, JBool, required = false,
                                 default = newJBool(true))
  if valid_594329 != nil:
    section.add "prettyPrint", valid_594329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594330: Call_GamesManagementTurnBasedMatchesReset_594320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset all turn-based match data for a user. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_GamesManagementTurnBasedMatchesReset_594320;
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
  var query_594332 = newJObject()
  add(query_594332, "fields", newJString(fields))
  add(query_594332, "quotaUser", newJString(quotaUser))
  add(query_594332, "alt", newJString(alt))
  add(query_594332, "oauth_token", newJString(oauthToken))
  add(query_594332, "userIp", newJString(userIp))
  add(query_594332, "key", newJString(key))
  add(query_594332, "prettyPrint", newJBool(prettyPrint))
  result = call_594331.call(nil, query_594332, nil, nil, nil)

var gamesManagementTurnBasedMatchesReset* = Call_GamesManagementTurnBasedMatchesReset_594320(
    name: "gamesManagementTurnBasedMatchesReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/reset",
    validator: validate_GamesManagementTurnBasedMatchesReset_594321,
    base: "/games/v1management", url: url_GamesManagementTurnBasedMatchesReset_594322,
    schemes: {Scheme.Https})
type
  Call_GamesManagementTurnBasedMatchesResetForAllPlayers_594333 = ref object of OpenApiRestCall_593424
proc url_GamesManagementTurnBasedMatchesResetForAllPlayers_594335(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GamesManagementTurnBasedMatchesResetForAllPlayers_594334(
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
  var valid_594336 = query.getOrDefault("fields")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "fields", valid_594336
  var valid_594337 = query.getOrDefault("quotaUser")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "quotaUser", valid_594337
  var valid_594338 = query.getOrDefault("alt")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = newJString("json"))
  if valid_594338 != nil:
    section.add "alt", valid_594338
  var valid_594339 = query.getOrDefault("oauth_token")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "oauth_token", valid_594339
  var valid_594340 = query.getOrDefault("userIp")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "userIp", valid_594340
  var valid_594341 = query.getOrDefault("key")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "key", valid_594341
  var valid_594342 = query.getOrDefault("prettyPrint")
  valid_594342 = validateParameter(valid_594342, JBool, required = false,
                                 default = newJBool(true))
  if valid_594342 != nil:
    section.add "prettyPrint", valid_594342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594343: Call_GamesManagementTurnBasedMatchesResetForAllPlayers_594333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes turn-based matches where the only match participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_594343.validator(path, query, header, formData, body)
  let scheme = call_594343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594343.url(scheme.get, call_594343.host, call_594343.base,
                         call_594343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594343, url, valid)

proc call*(call_594344: Call_GamesManagementTurnBasedMatchesResetForAllPlayers_594333;
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
  var query_594345 = newJObject()
  add(query_594345, "fields", newJString(fields))
  add(query_594345, "quotaUser", newJString(quotaUser))
  add(query_594345, "alt", newJString(alt))
  add(query_594345, "oauth_token", newJString(oauthToken))
  add(query_594345, "userIp", newJString(userIp))
  add(query_594345, "key", newJString(key))
  add(query_594345, "prettyPrint", newJBool(prettyPrint))
  result = call_594344.call(nil, query_594345, nil, nil, nil)

var gamesManagementTurnBasedMatchesResetForAllPlayers* = Call_GamesManagementTurnBasedMatchesResetForAllPlayers_594333(
    name: "gamesManagementTurnBasedMatchesResetForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/turnbasedmatches/resetForAllPlayers",
    validator: validate_GamesManagementTurnBasedMatchesResetForAllPlayers_594334,
    base: "/games/v1management",
    url: url_GamesManagementTurnBasedMatchesResetForAllPlayers_594335,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
