
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
  gcpServiceName = "gamesManagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GamesManagementAchievementsResetAll_588725 = ref object of OpenApiRestCall_588457
proc url_GamesManagementAchievementsResetAll_588727(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetAll_588726(path: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_588881: Call_GamesManagementAchievementsResetAll_588725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all achievements for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_588881.validator(path, query, header, formData, body)
  let scheme = call_588881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588881.url(scheme.get, call_588881.host, call_588881.base,
                         call_588881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588881, url, valid)

proc call*(call_588952: Call_GamesManagementAchievementsResetAll_588725;
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
  var query_588953 = newJObject()
  add(query_588953, "fields", newJString(fields))
  add(query_588953, "quotaUser", newJString(quotaUser))
  add(query_588953, "alt", newJString(alt))
  add(query_588953, "oauth_token", newJString(oauthToken))
  add(query_588953, "userIp", newJString(userIp))
  add(query_588953, "key", newJString(key))
  add(query_588953, "prettyPrint", newJBool(prettyPrint))
  result = call_588952.call(nil, query_588953, nil, nil, nil)

var gamesManagementAchievementsResetAll* = Call_GamesManagementAchievementsResetAll_588725(
    name: "gamesManagementAchievementsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/reset",
    validator: validate_GamesManagementAchievementsResetAll_588726,
    base: "/games/v1management", url: url_GamesManagementAchievementsResetAll_588727,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetAllForAllPlayers_588993 = ref object of OpenApiRestCall_588457
proc url_GamesManagementAchievementsResetAllForAllPlayers_588995(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetAllForAllPlayers_588994(
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
  var valid_588996 = query.getOrDefault("fields")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "fields", valid_588996
  var valid_588997 = query.getOrDefault("quotaUser")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "quotaUser", valid_588997
  var valid_588998 = query.getOrDefault("alt")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = newJString("json"))
  if valid_588998 != nil:
    section.add "alt", valid_588998
  var valid_588999 = query.getOrDefault("oauth_token")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "oauth_token", valid_588999
  var valid_589000 = query.getOrDefault("userIp")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "userIp", valid_589000
  var valid_589001 = query.getOrDefault("key")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "key", valid_589001
  var valid_589002 = query.getOrDefault("prettyPrint")
  valid_589002 = validateParameter(valid_589002, JBool, required = false,
                                 default = newJBool(true))
  if valid_589002 != nil:
    section.add "prettyPrint", valid_589002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589003: Call_GamesManagementAchievementsResetAllForAllPlayers_588993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft achievements for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_589003.validator(path, query, header, formData, body)
  let scheme = call_589003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589003.url(scheme.get, call_589003.host, call_589003.base,
                         call_589003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589003, url, valid)

proc call*(call_589004: Call_GamesManagementAchievementsResetAllForAllPlayers_588993;
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
  var query_589005 = newJObject()
  add(query_589005, "fields", newJString(fields))
  add(query_589005, "quotaUser", newJString(quotaUser))
  add(query_589005, "alt", newJString(alt))
  add(query_589005, "oauth_token", newJString(oauthToken))
  add(query_589005, "userIp", newJString(userIp))
  add(query_589005, "key", newJString(key))
  add(query_589005, "prettyPrint", newJBool(prettyPrint))
  result = call_589004.call(nil, query_589005, nil, nil, nil)

var gamesManagementAchievementsResetAllForAllPlayers* = Call_GamesManagementAchievementsResetAllForAllPlayers_588993(
    name: "gamesManagementAchievementsResetAllForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/resetAllForAllPlayers",
    validator: validate_GamesManagementAchievementsResetAllForAllPlayers_588994,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetAllForAllPlayers_588995,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetMultipleForAllPlayers_589006 = ref object of OpenApiRestCall_588457
proc url_GamesManagementAchievementsResetMultipleForAllPlayers_589008(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetMultipleForAllPlayers_589007(
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
  var valid_589009 = query.getOrDefault("fields")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "fields", valid_589009
  var valid_589010 = query.getOrDefault("quotaUser")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "quotaUser", valid_589010
  var valid_589011 = query.getOrDefault("alt")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("json"))
  if valid_589011 != nil:
    section.add "alt", valid_589011
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

proc call*(call_589017: Call_GamesManagementAchievementsResetMultipleForAllPlayers_589006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets achievements with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft achievements may be reset.
  ## 
  let valid = call_589017.validator(path, query, header, formData, body)
  let scheme = call_589017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589017.url(scheme.get, call_589017.host, call_589017.base,
                         call_589017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589017, url, valid)

proc call*(call_589018: Call_GamesManagementAchievementsResetMultipleForAllPlayers_589006;
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
  var query_589019 = newJObject()
  var body_589020 = newJObject()
  add(query_589019, "fields", newJString(fields))
  add(query_589019, "quotaUser", newJString(quotaUser))
  add(query_589019, "alt", newJString(alt))
  add(query_589019, "oauth_token", newJString(oauthToken))
  add(query_589019, "userIp", newJString(userIp))
  add(query_589019, "key", newJString(key))
  if body != nil:
    body_589020 = body
  add(query_589019, "prettyPrint", newJBool(prettyPrint))
  result = call_589018.call(nil, query_589019, nil, nil, body_589020)

var gamesManagementAchievementsResetMultipleForAllPlayers* = Call_GamesManagementAchievementsResetMultipleForAllPlayers_589006(
    name: "gamesManagementAchievementsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/resetMultipleForAllPlayers",
    validator: validate_GamesManagementAchievementsResetMultipleForAllPlayers_589007,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetMultipleForAllPlayers_589008,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsReset_589021 = ref object of OpenApiRestCall_588457
proc url_GamesManagementAchievementsReset_589023(protocol: Scheme; host: string;
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

proc validate_GamesManagementAchievementsReset_589022(path: JsonNode;
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
  var valid_589038 = path.getOrDefault("achievementId")
  valid_589038 = validateParameter(valid_589038, JString, required = true,
                                 default = nil)
  if valid_589038 != nil:
    section.add "achievementId", valid_589038
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
  var valid_589039 = query.getOrDefault("fields")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "fields", valid_589039
  var valid_589040 = query.getOrDefault("quotaUser")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "quotaUser", valid_589040
  var valid_589041 = query.getOrDefault("alt")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = newJString("json"))
  if valid_589041 != nil:
    section.add "alt", valid_589041
  var valid_589042 = query.getOrDefault("oauth_token")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "oauth_token", valid_589042
  var valid_589043 = query.getOrDefault("userIp")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "userIp", valid_589043
  var valid_589044 = query.getOrDefault("key")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "key", valid_589044
  var valid_589045 = query.getOrDefault("prettyPrint")
  valid_589045 = validateParameter(valid_589045, JBool, required = false,
                                 default = newJBool(true))
  if valid_589045 != nil:
    section.add "prettyPrint", valid_589045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589046: Call_GamesManagementAchievementsReset_589021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the achievement with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_589046.validator(path, query, header, formData, body)
  let scheme = call_589046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589046.url(scheme.get, call_589046.host, call_589046.base,
                         call_589046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589046, url, valid)

proc call*(call_589047: Call_GamesManagementAchievementsReset_589021;
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
  var path_589048 = newJObject()
  var query_589049 = newJObject()
  add(query_589049, "fields", newJString(fields))
  add(query_589049, "quotaUser", newJString(quotaUser))
  add(query_589049, "alt", newJString(alt))
  add(query_589049, "oauth_token", newJString(oauthToken))
  add(query_589049, "userIp", newJString(userIp))
  add(query_589049, "key", newJString(key))
  add(path_589048, "achievementId", newJString(achievementId))
  add(query_589049, "prettyPrint", newJBool(prettyPrint))
  result = call_589047.call(path_589048, query_589049, nil, nil, nil)

var gamesManagementAchievementsReset* = Call_GamesManagementAchievementsReset_589021(
    name: "gamesManagementAchievementsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/reset",
    validator: validate_GamesManagementAchievementsReset_589022,
    base: "/games/v1management", url: url_GamesManagementAchievementsReset_589023,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetForAllPlayers_589050 = ref object of OpenApiRestCall_588457
proc url_GamesManagementAchievementsResetForAllPlayers_589052(protocol: Scheme;
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

proc validate_GamesManagementAchievementsResetForAllPlayers_589051(
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
  var valid_589053 = path.getOrDefault("achievementId")
  valid_589053 = validateParameter(valid_589053, JString, required = true,
                                 default = nil)
  if valid_589053 != nil:
    section.add "achievementId", valid_589053
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
  var valid_589054 = query.getOrDefault("fields")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "fields", valid_589054
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("alt")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("json"))
  if valid_589056 != nil:
    section.add "alt", valid_589056
  var valid_589057 = query.getOrDefault("oauth_token")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "oauth_token", valid_589057
  var valid_589058 = query.getOrDefault("userIp")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "userIp", valid_589058
  var valid_589059 = query.getOrDefault("key")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "key", valid_589059
  var valid_589060 = query.getOrDefault("prettyPrint")
  valid_589060 = validateParameter(valid_589060, JBool, required = false,
                                 default = newJBool(true))
  if valid_589060 != nil:
    section.add "prettyPrint", valid_589060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589061: Call_GamesManagementAchievementsResetForAllPlayers_589050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the achievement with the given ID for all players. This method is only available to user accounts for your developer console. Only draft achievements can be reset.
  ## 
  let valid = call_589061.validator(path, query, header, formData, body)
  let scheme = call_589061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589061.url(scheme.get, call_589061.host, call_589061.base,
                         call_589061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589061, url, valid)

proc call*(call_589062: Call_GamesManagementAchievementsResetForAllPlayers_589050;
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
  var path_589063 = newJObject()
  var query_589064 = newJObject()
  add(query_589064, "fields", newJString(fields))
  add(query_589064, "quotaUser", newJString(quotaUser))
  add(query_589064, "alt", newJString(alt))
  add(query_589064, "oauth_token", newJString(oauthToken))
  add(query_589064, "userIp", newJString(userIp))
  add(query_589064, "key", newJString(key))
  add(path_589063, "achievementId", newJString(achievementId))
  add(query_589064, "prettyPrint", newJBool(prettyPrint))
  result = call_589062.call(path_589063, query_589064, nil, nil, nil)

var gamesManagementAchievementsResetForAllPlayers* = Call_GamesManagementAchievementsResetForAllPlayers_589050(
    name: "gamesManagementAchievementsResetForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/{achievementId}/resetForAllPlayers",
    validator: validate_GamesManagementAchievementsResetForAllPlayers_589051,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetForAllPlayers_589052,
    schemes: {Scheme.Https})
type
  Call_GamesManagementApplicationsListHidden_589065 = ref object of OpenApiRestCall_588457
proc url_GamesManagementApplicationsListHidden_589067(protocol: Scheme;
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

proc validate_GamesManagementApplicationsListHidden_589066(path: JsonNode;
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
  var valid_589068 = path.getOrDefault("applicationId")
  valid_589068 = validateParameter(valid_589068, JString, required = true,
                                 default = nil)
  if valid_589068 != nil:
    section.add "applicationId", valid_589068
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
  var valid_589069 = query.getOrDefault("fields")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "fields", valid_589069
  var valid_589070 = query.getOrDefault("pageToken")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "pageToken", valid_589070
  var valid_589071 = query.getOrDefault("quotaUser")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "quotaUser", valid_589071
  var valid_589072 = query.getOrDefault("alt")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("json"))
  if valid_589072 != nil:
    section.add "alt", valid_589072
  var valid_589073 = query.getOrDefault("oauth_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "oauth_token", valid_589073
  var valid_589074 = query.getOrDefault("userIp")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "userIp", valid_589074
  var valid_589075 = query.getOrDefault("maxResults")
  valid_589075 = validateParameter(valid_589075, JInt, required = false, default = nil)
  if valid_589075 != nil:
    section.add "maxResults", valid_589075
  var valid_589076 = query.getOrDefault("key")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "key", valid_589076
  var valid_589077 = query.getOrDefault("prettyPrint")
  valid_589077 = validateParameter(valid_589077, JBool, required = false,
                                 default = newJBool(true))
  if valid_589077 != nil:
    section.add "prettyPrint", valid_589077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589078: Call_GamesManagementApplicationsListHidden_589065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of players hidden from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_589078.validator(path, query, header, formData, body)
  let scheme = call_589078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589078.url(scheme.get, call_589078.host, call_589078.base,
                         call_589078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589078, url, valid)

proc call*(call_589079: Call_GamesManagementApplicationsListHidden_589065;
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
  var path_589080 = newJObject()
  var query_589081 = newJObject()
  add(query_589081, "fields", newJString(fields))
  add(query_589081, "pageToken", newJString(pageToken))
  add(query_589081, "quotaUser", newJString(quotaUser))
  add(query_589081, "alt", newJString(alt))
  add(query_589081, "oauth_token", newJString(oauthToken))
  add(query_589081, "userIp", newJString(userIp))
  add(path_589080, "applicationId", newJString(applicationId))
  add(query_589081, "maxResults", newJInt(maxResults))
  add(query_589081, "key", newJString(key))
  add(query_589081, "prettyPrint", newJBool(prettyPrint))
  result = call_589079.call(path_589080, query_589081, nil, nil, nil)

var gamesManagementApplicationsListHidden* = Call_GamesManagementApplicationsListHidden_589065(
    name: "gamesManagementApplicationsListHidden", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden",
    validator: validate_GamesManagementApplicationsListHidden_589066,
    base: "/games/v1management", url: url_GamesManagementApplicationsListHidden_589067,
    schemes: {Scheme.Https})
type
  Call_GamesManagementPlayersHide_589082 = ref object of OpenApiRestCall_588457
proc url_GamesManagementPlayersHide_589084(protocol: Scheme; host: string;
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

proc validate_GamesManagementPlayersHide_589083(path: JsonNode; query: JsonNode;
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
  var valid_589085 = path.getOrDefault("playerId")
  valid_589085 = validateParameter(valid_589085, JString, required = true,
                                 default = nil)
  if valid_589085 != nil:
    section.add "playerId", valid_589085
  var valid_589086 = path.getOrDefault("applicationId")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "applicationId", valid_589086
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
  var valid_589090 = query.getOrDefault("oauth_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "oauth_token", valid_589090
  var valid_589091 = query.getOrDefault("userIp")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "userIp", valid_589091
  var valid_589092 = query.getOrDefault("key")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "key", valid_589092
  var valid_589093 = query.getOrDefault("prettyPrint")
  valid_589093 = validateParameter(valid_589093, JBool, required = false,
                                 default = newJBool(true))
  if valid_589093 != nil:
    section.add "prettyPrint", valid_589093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589094: Call_GamesManagementPlayersHide_589082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_589094.validator(path, query, header, formData, body)
  let scheme = call_589094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589094.url(scheme.get, call_589094.host, call_589094.base,
                         call_589094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589094, url, valid)

proc call*(call_589095: Call_GamesManagementPlayersHide_589082; playerId: string;
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
  var path_589096 = newJObject()
  var query_589097 = newJObject()
  add(query_589097, "fields", newJString(fields))
  add(query_589097, "quotaUser", newJString(quotaUser))
  add(query_589097, "alt", newJString(alt))
  add(query_589097, "oauth_token", newJString(oauthToken))
  add(path_589096, "playerId", newJString(playerId))
  add(query_589097, "userIp", newJString(userIp))
  add(path_589096, "applicationId", newJString(applicationId))
  add(query_589097, "key", newJString(key))
  add(query_589097, "prettyPrint", newJBool(prettyPrint))
  result = call_589095.call(path_589096, query_589097, nil, nil, nil)

var gamesManagementPlayersHide* = Call_GamesManagementPlayersHide_589082(
    name: "gamesManagementPlayersHide", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden/{playerId}",
    validator: validate_GamesManagementPlayersHide_589083,
    base: "/games/v1management", url: url_GamesManagementPlayersHide_589084,
    schemes: {Scheme.Https})
type
  Call_GamesManagementPlayersUnhide_589098 = ref object of OpenApiRestCall_588457
proc url_GamesManagementPlayersUnhide_589100(protocol: Scheme; host: string;
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

proc validate_GamesManagementPlayersUnhide_589099(path: JsonNode; query: JsonNode;
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
  var valid_589101 = path.getOrDefault("playerId")
  valid_589101 = validateParameter(valid_589101, JString, required = true,
                                 default = nil)
  if valid_589101 != nil:
    section.add "playerId", valid_589101
  var valid_589102 = path.getOrDefault("applicationId")
  valid_589102 = validateParameter(valid_589102, JString, required = true,
                                 default = nil)
  if valid_589102 != nil:
    section.add "applicationId", valid_589102
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
  var valid_589103 = query.getOrDefault("fields")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "fields", valid_589103
  var valid_589104 = query.getOrDefault("quotaUser")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "quotaUser", valid_589104
  var valid_589105 = query.getOrDefault("alt")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = newJString("json"))
  if valid_589105 != nil:
    section.add "alt", valid_589105
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

proc call*(call_589110: Call_GamesManagementPlayersUnhide_589098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unhide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_589110.validator(path, query, header, formData, body)
  let scheme = call_589110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589110.url(scheme.get, call_589110.host, call_589110.base,
                         call_589110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589110, url, valid)

proc call*(call_589111: Call_GamesManagementPlayersUnhide_589098; playerId: string;
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
  var path_589112 = newJObject()
  var query_589113 = newJObject()
  add(query_589113, "fields", newJString(fields))
  add(query_589113, "quotaUser", newJString(quotaUser))
  add(query_589113, "alt", newJString(alt))
  add(query_589113, "oauth_token", newJString(oauthToken))
  add(path_589112, "playerId", newJString(playerId))
  add(query_589113, "userIp", newJString(userIp))
  add(path_589112, "applicationId", newJString(applicationId))
  add(query_589113, "key", newJString(key))
  add(query_589113, "prettyPrint", newJBool(prettyPrint))
  result = call_589111.call(path_589112, query_589113, nil, nil, nil)

var gamesManagementPlayersUnhide* = Call_GamesManagementPlayersUnhide_589098(
    name: "gamesManagementPlayersUnhide", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden/{playerId}",
    validator: validate_GamesManagementPlayersUnhide_589099,
    base: "/games/v1management", url: url_GamesManagementPlayersUnhide_589100,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetAll_589114 = ref object of OpenApiRestCall_588457
proc url_GamesManagementEventsResetAll_589116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetAll_589115(path: JsonNode; query: JsonNode;
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
  var valid_589120 = query.getOrDefault("oauth_token")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "oauth_token", valid_589120
  var valid_589121 = query.getOrDefault("userIp")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "userIp", valid_589121
  var valid_589122 = query.getOrDefault("key")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "key", valid_589122
  var valid_589123 = query.getOrDefault("prettyPrint")
  valid_589123 = validateParameter(valid_589123, JBool, required = false,
                                 default = newJBool(true))
  if valid_589123 != nil:
    section.add "prettyPrint", valid_589123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589124: Call_GamesManagementEventsResetAll_589114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on all events for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player will also be reset.
  ## 
  let valid = call_589124.validator(path, query, header, formData, body)
  let scheme = call_589124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589124.url(scheme.get, call_589124.host, call_589124.base,
                         call_589124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589124, url, valid)

proc call*(call_589125: Call_GamesManagementEventsResetAll_589114;
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
  var query_589126 = newJObject()
  add(query_589126, "fields", newJString(fields))
  add(query_589126, "quotaUser", newJString(quotaUser))
  add(query_589126, "alt", newJString(alt))
  add(query_589126, "oauth_token", newJString(oauthToken))
  add(query_589126, "userIp", newJString(userIp))
  add(query_589126, "key", newJString(key))
  add(query_589126, "prettyPrint", newJBool(prettyPrint))
  result = call_589125.call(nil, query_589126, nil, nil, nil)

var gamesManagementEventsResetAll* = Call_GamesManagementEventsResetAll_589114(
    name: "gamesManagementEventsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/reset",
    validator: validate_GamesManagementEventsResetAll_589115,
    base: "/games/v1management", url: url_GamesManagementEventsResetAll_589116,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetAllForAllPlayers_589127 = ref object of OpenApiRestCall_588457
proc url_GamesManagementEventsResetAllForAllPlayers_589129(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetAllForAllPlayers_589128(path: JsonNode;
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
  var valid_589130 = query.getOrDefault("fields")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "fields", valid_589130
  var valid_589131 = query.getOrDefault("quotaUser")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "quotaUser", valid_589131
  var valid_589132 = query.getOrDefault("alt")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("json"))
  if valid_589132 != nil:
    section.add "alt", valid_589132
  var valid_589133 = query.getOrDefault("oauth_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "oauth_token", valid_589133
  var valid_589134 = query.getOrDefault("userIp")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "userIp", valid_589134
  var valid_589135 = query.getOrDefault("key")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "key", valid_589135
  var valid_589136 = query.getOrDefault("prettyPrint")
  valid_589136 = validateParameter(valid_589136, JBool, required = false,
                                 default = newJBool(true))
  if valid_589136 != nil:
    section.add "prettyPrint", valid_589136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589137: Call_GamesManagementEventsResetAllForAllPlayers_589127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft events for all players. This method is only available to user accounts for your developer console. All quests that use any of these events will also be reset.
  ## 
  let valid = call_589137.validator(path, query, header, formData, body)
  let scheme = call_589137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589137.url(scheme.get, call_589137.host, call_589137.base,
                         call_589137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589137, url, valid)

proc call*(call_589138: Call_GamesManagementEventsResetAllForAllPlayers_589127;
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
  var query_589139 = newJObject()
  add(query_589139, "fields", newJString(fields))
  add(query_589139, "quotaUser", newJString(quotaUser))
  add(query_589139, "alt", newJString(alt))
  add(query_589139, "oauth_token", newJString(oauthToken))
  add(query_589139, "userIp", newJString(userIp))
  add(query_589139, "key", newJString(key))
  add(query_589139, "prettyPrint", newJBool(prettyPrint))
  result = call_589138.call(nil, query_589139, nil, nil, nil)

var gamesManagementEventsResetAllForAllPlayers* = Call_GamesManagementEventsResetAllForAllPlayers_589127(
    name: "gamesManagementEventsResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/resetAllForAllPlayers",
    validator: validate_GamesManagementEventsResetAllForAllPlayers_589128,
    base: "/games/v1management",
    url: url_GamesManagementEventsResetAllForAllPlayers_589129,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetMultipleForAllPlayers_589140 = ref object of OpenApiRestCall_588457
proc url_GamesManagementEventsResetMultipleForAllPlayers_589142(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetMultipleForAllPlayers_589141(
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
  var valid_589143 = query.getOrDefault("fields")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "fields", valid_589143
  var valid_589144 = query.getOrDefault("quotaUser")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "quotaUser", valid_589144
  var valid_589145 = query.getOrDefault("alt")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("json"))
  if valid_589145 != nil:
    section.add "alt", valid_589145
  var valid_589146 = query.getOrDefault("oauth_token")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "oauth_token", valid_589146
  var valid_589147 = query.getOrDefault("userIp")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "userIp", valid_589147
  var valid_589148 = query.getOrDefault("key")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "key", valid_589148
  var valid_589149 = query.getOrDefault("prettyPrint")
  valid_589149 = validateParameter(valid_589149, JBool, required = false,
                                 default = newJBool(true))
  if valid_589149 != nil:
    section.add "prettyPrint", valid_589149
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

proc call*(call_589151: Call_GamesManagementEventsResetMultipleForAllPlayers_589140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets events with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft events may be reset. All quests that use any of the events will also be reset.
  ## 
  let valid = call_589151.validator(path, query, header, formData, body)
  let scheme = call_589151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589151.url(scheme.get, call_589151.host, call_589151.base,
                         call_589151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589151, url, valid)

proc call*(call_589152: Call_GamesManagementEventsResetMultipleForAllPlayers_589140;
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
  var query_589153 = newJObject()
  var body_589154 = newJObject()
  add(query_589153, "fields", newJString(fields))
  add(query_589153, "quotaUser", newJString(quotaUser))
  add(query_589153, "alt", newJString(alt))
  add(query_589153, "oauth_token", newJString(oauthToken))
  add(query_589153, "userIp", newJString(userIp))
  add(query_589153, "key", newJString(key))
  if body != nil:
    body_589154 = body
  add(query_589153, "prettyPrint", newJBool(prettyPrint))
  result = call_589152.call(nil, query_589153, nil, nil, body_589154)

var gamesManagementEventsResetMultipleForAllPlayers* = Call_GamesManagementEventsResetMultipleForAllPlayers_589140(
    name: "gamesManagementEventsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/events/resetMultipleForAllPlayers",
    validator: validate_GamesManagementEventsResetMultipleForAllPlayers_589141,
    base: "/games/v1management",
    url: url_GamesManagementEventsResetMultipleForAllPlayers_589142,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsReset_589155 = ref object of OpenApiRestCall_588457
proc url_GamesManagementEventsReset_589157(protocol: Scheme; host: string;
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

proc validate_GamesManagementEventsReset_589156(path: JsonNode; query: JsonNode;
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
  var valid_589158 = path.getOrDefault("eventId")
  valid_589158 = validateParameter(valid_589158, JString, required = true,
                                 default = nil)
  if valid_589158 != nil:
    section.add "eventId", valid_589158
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
  var valid_589159 = query.getOrDefault("fields")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "fields", valid_589159
  var valid_589160 = query.getOrDefault("quotaUser")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "quotaUser", valid_589160
  var valid_589161 = query.getOrDefault("alt")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = newJString("json"))
  if valid_589161 != nil:
    section.add "alt", valid_589161
  var valid_589162 = query.getOrDefault("oauth_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "oauth_token", valid_589162
  var valid_589163 = query.getOrDefault("userIp")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "userIp", valid_589163
  var valid_589164 = query.getOrDefault("key")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "key", valid_589164
  var valid_589165 = query.getOrDefault("prettyPrint")
  valid_589165 = validateParameter(valid_589165, JBool, required = false,
                                 default = newJBool(true))
  if valid_589165 != nil:
    section.add "prettyPrint", valid_589165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589166: Call_GamesManagementEventsReset_589155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on the event with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player that use the event will also be reset.
  ## 
  let valid = call_589166.validator(path, query, header, formData, body)
  let scheme = call_589166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589166.url(scheme.get, call_589166.host, call_589166.base,
                         call_589166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589166, url, valid)

proc call*(call_589167: Call_GamesManagementEventsReset_589155; eventId: string;
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
  var path_589168 = newJObject()
  var query_589169 = newJObject()
  add(query_589169, "fields", newJString(fields))
  add(query_589169, "quotaUser", newJString(quotaUser))
  add(query_589169, "alt", newJString(alt))
  add(query_589169, "oauth_token", newJString(oauthToken))
  add(query_589169, "userIp", newJString(userIp))
  add(path_589168, "eventId", newJString(eventId))
  add(query_589169, "key", newJString(key))
  add(query_589169, "prettyPrint", newJBool(prettyPrint))
  result = call_589167.call(path_589168, query_589169, nil, nil, nil)

var gamesManagementEventsReset* = Call_GamesManagementEventsReset_589155(
    name: "gamesManagementEventsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/{eventId}/reset",
    validator: validate_GamesManagementEventsReset_589156,
    base: "/games/v1management", url: url_GamesManagementEventsReset_589157,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetForAllPlayers_589170 = ref object of OpenApiRestCall_588457
proc url_GamesManagementEventsResetForAllPlayers_589172(protocol: Scheme;
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

proc validate_GamesManagementEventsResetForAllPlayers_589171(path: JsonNode;
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
  var valid_589173 = path.getOrDefault("eventId")
  valid_589173 = validateParameter(valid_589173, JString, required = true,
                                 default = nil)
  if valid_589173 != nil:
    section.add "eventId", valid_589173
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
  var valid_589174 = query.getOrDefault("fields")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "fields", valid_589174
  var valid_589175 = query.getOrDefault("quotaUser")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "quotaUser", valid_589175
  var valid_589176 = query.getOrDefault("alt")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = newJString("json"))
  if valid_589176 != nil:
    section.add "alt", valid_589176
  var valid_589177 = query.getOrDefault("oauth_token")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "oauth_token", valid_589177
  var valid_589178 = query.getOrDefault("userIp")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "userIp", valid_589178
  var valid_589179 = query.getOrDefault("key")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "key", valid_589179
  var valid_589180 = query.getOrDefault("prettyPrint")
  valid_589180 = validateParameter(valid_589180, JBool, required = false,
                                 default = newJBool(true))
  if valid_589180 != nil:
    section.add "prettyPrint", valid_589180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589181: Call_GamesManagementEventsResetForAllPlayers_589170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the event with the given ID for all players. This method is only available to user accounts for your developer console. Only draft events can be reset. All quests that use the event will also be reset.
  ## 
  let valid = call_589181.validator(path, query, header, formData, body)
  let scheme = call_589181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589181.url(scheme.get, call_589181.host, call_589181.base,
                         call_589181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589181, url, valid)

proc call*(call_589182: Call_GamesManagementEventsResetForAllPlayers_589170;
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
  var path_589183 = newJObject()
  var query_589184 = newJObject()
  add(query_589184, "fields", newJString(fields))
  add(query_589184, "quotaUser", newJString(quotaUser))
  add(query_589184, "alt", newJString(alt))
  add(query_589184, "oauth_token", newJString(oauthToken))
  add(query_589184, "userIp", newJString(userIp))
  add(path_589183, "eventId", newJString(eventId))
  add(query_589184, "key", newJString(key))
  add(query_589184, "prettyPrint", newJBool(prettyPrint))
  result = call_589182.call(path_589183, query_589184, nil, nil, nil)

var gamesManagementEventsResetForAllPlayers* = Call_GamesManagementEventsResetForAllPlayers_589170(
    name: "gamesManagementEventsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/{eventId}/resetForAllPlayers",
    validator: validate_GamesManagementEventsResetForAllPlayers_589171,
    base: "/games/v1management", url: url_GamesManagementEventsResetForAllPlayers_589172,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresReset_589185 = ref object of OpenApiRestCall_588457
proc url_GamesManagementScoresReset_589187(protocol: Scheme; host: string;
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

proc validate_GamesManagementScoresReset_589186(path: JsonNode; query: JsonNode;
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
  var valid_589188 = path.getOrDefault("leaderboardId")
  valid_589188 = validateParameter(valid_589188, JString, required = true,
                                 default = nil)
  if valid_589188 != nil:
    section.add "leaderboardId", valid_589188
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
  var valid_589189 = query.getOrDefault("fields")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "fields", valid_589189
  var valid_589190 = query.getOrDefault("quotaUser")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "quotaUser", valid_589190
  var valid_589191 = query.getOrDefault("alt")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = newJString("json"))
  if valid_589191 != nil:
    section.add "alt", valid_589191
  var valid_589192 = query.getOrDefault("oauth_token")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "oauth_token", valid_589192
  var valid_589193 = query.getOrDefault("userIp")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "userIp", valid_589193
  var valid_589194 = query.getOrDefault("key")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "key", valid_589194
  var valid_589195 = query.getOrDefault("prettyPrint")
  valid_589195 = validateParameter(valid_589195, JBool, required = false,
                                 default = newJBool(true))
  if valid_589195 != nil:
    section.add "prettyPrint", valid_589195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589196: Call_GamesManagementScoresReset_589185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets scores for the leaderboard with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_589196.validator(path, query, header, formData, body)
  let scheme = call_589196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589196.url(scheme.get, call_589196.host, call_589196.base,
                         call_589196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589196, url, valid)

proc call*(call_589197: Call_GamesManagementScoresReset_589185;
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
  var path_589198 = newJObject()
  var query_589199 = newJObject()
  add(query_589199, "fields", newJString(fields))
  add(query_589199, "quotaUser", newJString(quotaUser))
  add(query_589199, "alt", newJString(alt))
  add(path_589198, "leaderboardId", newJString(leaderboardId))
  add(query_589199, "oauth_token", newJString(oauthToken))
  add(query_589199, "userIp", newJString(userIp))
  add(query_589199, "key", newJString(key))
  add(query_589199, "prettyPrint", newJBool(prettyPrint))
  result = call_589197.call(path_589198, query_589199, nil, nil, nil)

var gamesManagementScoresReset* = Call_GamesManagementScoresReset_589185(
    name: "gamesManagementScoresReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/reset",
    validator: validate_GamesManagementScoresReset_589186,
    base: "/games/v1management", url: url_GamesManagementScoresReset_589187,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetForAllPlayers_589200 = ref object of OpenApiRestCall_588457
proc url_GamesManagementScoresResetForAllPlayers_589202(protocol: Scheme;
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

proc validate_GamesManagementScoresResetForAllPlayers_589201(path: JsonNode;
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
  var valid_589203 = path.getOrDefault("leaderboardId")
  valid_589203 = validateParameter(valid_589203, JString, required = true,
                                 default = nil)
  if valid_589203 != nil:
    section.add "leaderboardId", valid_589203
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
  var valid_589204 = query.getOrDefault("fields")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "fields", valid_589204
  var valid_589205 = query.getOrDefault("quotaUser")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "quotaUser", valid_589205
  var valid_589206 = query.getOrDefault("alt")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = newJString("json"))
  if valid_589206 != nil:
    section.add "alt", valid_589206
  var valid_589207 = query.getOrDefault("oauth_token")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "oauth_token", valid_589207
  var valid_589208 = query.getOrDefault("userIp")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "userIp", valid_589208
  var valid_589209 = query.getOrDefault("key")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "key", valid_589209
  var valid_589210 = query.getOrDefault("prettyPrint")
  valid_589210 = validateParameter(valid_589210, JBool, required = false,
                                 default = newJBool(true))
  if valid_589210 != nil:
    section.add "prettyPrint", valid_589210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589211: Call_GamesManagementScoresResetForAllPlayers_589200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for the leaderboard with the given ID for all players. This method is only available to user accounts for your developer console. Only draft leaderboards can be reset.
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_GamesManagementScoresResetForAllPlayers_589200;
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
  var path_589213 = newJObject()
  var query_589214 = newJObject()
  add(query_589214, "fields", newJString(fields))
  add(query_589214, "quotaUser", newJString(quotaUser))
  add(query_589214, "alt", newJString(alt))
  add(path_589213, "leaderboardId", newJString(leaderboardId))
  add(query_589214, "oauth_token", newJString(oauthToken))
  add(query_589214, "userIp", newJString(userIp))
  add(query_589214, "key", newJString(key))
  add(query_589214, "prettyPrint", newJBool(prettyPrint))
  result = call_589212.call(path_589213, query_589214, nil, nil, nil)

var gamesManagementScoresResetForAllPlayers* = Call_GamesManagementScoresResetForAllPlayers_589200(
    name: "gamesManagementScoresResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/resetForAllPlayers",
    validator: validate_GamesManagementScoresResetForAllPlayers_589201,
    base: "/games/v1management", url: url_GamesManagementScoresResetForAllPlayers_589202,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetAll_589215 = ref object of OpenApiRestCall_588457
proc url_GamesManagementQuestsResetAll_589217(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetAll_589216(path: JsonNode; query: JsonNode;
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
  var valid_589218 = query.getOrDefault("fields")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "fields", valid_589218
  var valid_589219 = query.getOrDefault("quotaUser")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "quotaUser", valid_589219
  var valid_589220 = query.getOrDefault("alt")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = newJString("json"))
  if valid_589220 != nil:
    section.add "alt", valid_589220
  var valid_589221 = query.getOrDefault("oauth_token")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "oauth_token", valid_589221
  var valid_589222 = query.getOrDefault("userIp")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "userIp", valid_589222
  var valid_589223 = query.getOrDefault("key")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "key", valid_589223
  var valid_589224 = query.getOrDefault("prettyPrint")
  valid_589224 = validateParameter(valid_589224, JBool, required = false,
                                 default = newJBool(true))
  if valid_589224 != nil:
    section.add "prettyPrint", valid_589224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589225: Call_GamesManagementQuestsResetAll_589215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on all quests for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_589225.validator(path, query, header, formData, body)
  let scheme = call_589225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589225.url(scheme.get, call_589225.host, call_589225.base,
                         call_589225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589225, url, valid)

proc call*(call_589226: Call_GamesManagementQuestsResetAll_589215;
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
  var query_589227 = newJObject()
  add(query_589227, "fields", newJString(fields))
  add(query_589227, "quotaUser", newJString(quotaUser))
  add(query_589227, "alt", newJString(alt))
  add(query_589227, "oauth_token", newJString(oauthToken))
  add(query_589227, "userIp", newJString(userIp))
  add(query_589227, "key", newJString(key))
  add(query_589227, "prettyPrint", newJBool(prettyPrint))
  result = call_589226.call(nil, query_589227, nil, nil, nil)

var gamesManagementQuestsResetAll* = Call_GamesManagementQuestsResetAll_589215(
    name: "gamesManagementQuestsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/reset",
    validator: validate_GamesManagementQuestsResetAll_589216,
    base: "/games/v1management", url: url_GamesManagementQuestsResetAll_589217,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetAllForAllPlayers_589228 = ref object of OpenApiRestCall_588457
proc url_GamesManagementQuestsResetAllForAllPlayers_589230(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetAllForAllPlayers_589229(path: JsonNode;
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
  var valid_589231 = query.getOrDefault("fields")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "fields", valid_589231
  var valid_589232 = query.getOrDefault("quotaUser")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "quotaUser", valid_589232
  var valid_589233 = query.getOrDefault("alt")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = newJString("json"))
  if valid_589233 != nil:
    section.add "alt", valid_589233
  var valid_589234 = query.getOrDefault("oauth_token")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "oauth_token", valid_589234
  var valid_589235 = query.getOrDefault("userIp")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "userIp", valid_589235
  var valid_589236 = query.getOrDefault("key")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "key", valid_589236
  var valid_589237 = query.getOrDefault("prettyPrint")
  valid_589237 = validateParameter(valid_589237, JBool, required = false,
                                 default = newJBool(true))
  if valid_589237 != nil:
    section.add "prettyPrint", valid_589237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589238: Call_GamesManagementQuestsResetAllForAllPlayers_589228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft quests for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_589238.validator(path, query, header, formData, body)
  let scheme = call_589238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589238.url(scheme.get, call_589238.host, call_589238.base,
                         call_589238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589238, url, valid)

proc call*(call_589239: Call_GamesManagementQuestsResetAllForAllPlayers_589228;
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
  var query_589240 = newJObject()
  add(query_589240, "fields", newJString(fields))
  add(query_589240, "quotaUser", newJString(quotaUser))
  add(query_589240, "alt", newJString(alt))
  add(query_589240, "oauth_token", newJString(oauthToken))
  add(query_589240, "userIp", newJString(userIp))
  add(query_589240, "key", newJString(key))
  add(query_589240, "prettyPrint", newJBool(prettyPrint))
  result = call_589239.call(nil, query_589240, nil, nil, nil)

var gamesManagementQuestsResetAllForAllPlayers* = Call_GamesManagementQuestsResetAllForAllPlayers_589228(
    name: "gamesManagementQuestsResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/resetAllForAllPlayers",
    validator: validate_GamesManagementQuestsResetAllForAllPlayers_589229,
    base: "/games/v1management",
    url: url_GamesManagementQuestsResetAllForAllPlayers_589230,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetMultipleForAllPlayers_589241 = ref object of OpenApiRestCall_588457
proc url_GamesManagementQuestsResetMultipleForAllPlayers_589243(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetMultipleForAllPlayers_589242(
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
  var valid_589244 = query.getOrDefault("fields")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "fields", valid_589244
  var valid_589245 = query.getOrDefault("quotaUser")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "quotaUser", valid_589245
  var valid_589246 = query.getOrDefault("alt")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = newJString("json"))
  if valid_589246 != nil:
    section.add "alt", valid_589246
  var valid_589247 = query.getOrDefault("oauth_token")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "oauth_token", valid_589247
  var valid_589248 = query.getOrDefault("userIp")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "userIp", valid_589248
  var valid_589249 = query.getOrDefault("key")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "key", valid_589249
  var valid_589250 = query.getOrDefault("prettyPrint")
  valid_589250 = validateParameter(valid_589250, JBool, required = false,
                                 default = newJBool(true))
  if valid_589250 != nil:
    section.add "prettyPrint", valid_589250
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

proc call*(call_589252: Call_GamesManagementQuestsResetMultipleForAllPlayers_589241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets quests with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft quests may be reset.
  ## 
  let valid = call_589252.validator(path, query, header, formData, body)
  let scheme = call_589252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589252.url(scheme.get, call_589252.host, call_589252.base,
                         call_589252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589252, url, valid)

proc call*(call_589253: Call_GamesManagementQuestsResetMultipleForAllPlayers_589241;
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
  var query_589254 = newJObject()
  var body_589255 = newJObject()
  add(query_589254, "fields", newJString(fields))
  add(query_589254, "quotaUser", newJString(quotaUser))
  add(query_589254, "alt", newJString(alt))
  add(query_589254, "oauth_token", newJString(oauthToken))
  add(query_589254, "userIp", newJString(userIp))
  add(query_589254, "key", newJString(key))
  if body != nil:
    body_589255 = body
  add(query_589254, "prettyPrint", newJBool(prettyPrint))
  result = call_589253.call(nil, query_589254, nil, nil, body_589255)

var gamesManagementQuestsResetMultipleForAllPlayers* = Call_GamesManagementQuestsResetMultipleForAllPlayers_589241(
    name: "gamesManagementQuestsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/quests/resetMultipleForAllPlayers",
    validator: validate_GamesManagementQuestsResetMultipleForAllPlayers_589242,
    base: "/games/v1management",
    url: url_GamesManagementQuestsResetMultipleForAllPlayers_589243,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsReset_589256 = ref object of OpenApiRestCall_588457
proc url_GamesManagementQuestsReset_589258(protocol: Scheme; host: string;
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

proc validate_GamesManagementQuestsReset_589257(path: JsonNode; query: JsonNode;
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
  var valid_589259 = path.getOrDefault("questId")
  valid_589259 = validateParameter(valid_589259, JString, required = true,
                                 default = nil)
  if valid_589259 != nil:
    section.add "questId", valid_589259
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
  var valid_589260 = query.getOrDefault("fields")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "fields", valid_589260
  var valid_589261 = query.getOrDefault("quotaUser")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "quotaUser", valid_589261
  var valid_589262 = query.getOrDefault("alt")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = newJString("json"))
  if valid_589262 != nil:
    section.add "alt", valid_589262
  var valid_589263 = query.getOrDefault("oauth_token")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "oauth_token", valid_589263
  var valid_589264 = query.getOrDefault("userIp")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "userIp", valid_589264
  var valid_589265 = query.getOrDefault("key")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "key", valid_589265
  var valid_589266 = query.getOrDefault("prettyPrint")
  valid_589266 = validateParameter(valid_589266, JBool, required = false,
                                 default = newJBool(true))
  if valid_589266 != nil:
    section.add "prettyPrint", valid_589266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589267: Call_GamesManagementQuestsReset_589256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on the quest with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_589267.validator(path, query, header, formData, body)
  let scheme = call_589267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589267.url(scheme.get, call_589267.host, call_589267.base,
                         call_589267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589267, url, valid)

proc call*(call_589268: Call_GamesManagementQuestsReset_589256; questId: string;
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
  var path_589269 = newJObject()
  var query_589270 = newJObject()
  add(query_589270, "fields", newJString(fields))
  add(query_589270, "quotaUser", newJString(quotaUser))
  add(query_589270, "alt", newJString(alt))
  add(query_589270, "oauth_token", newJString(oauthToken))
  add(query_589270, "userIp", newJString(userIp))
  add(query_589270, "key", newJString(key))
  add(path_589269, "questId", newJString(questId))
  add(query_589270, "prettyPrint", newJBool(prettyPrint))
  result = call_589268.call(path_589269, query_589270, nil, nil, nil)

var gamesManagementQuestsReset* = Call_GamesManagementQuestsReset_589256(
    name: "gamesManagementQuestsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/{questId}/reset",
    validator: validate_GamesManagementQuestsReset_589257,
    base: "/games/v1management", url: url_GamesManagementQuestsReset_589258,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetForAllPlayers_589271 = ref object of OpenApiRestCall_588457
proc url_GamesManagementQuestsResetForAllPlayers_589273(protocol: Scheme;
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

proc validate_GamesManagementQuestsResetForAllPlayers_589272(path: JsonNode;
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
  var valid_589274 = path.getOrDefault("questId")
  valid_589274 = validateParameter(valid_589274, JString, required = true,
                                 default = nil)
  if valid_589274 != nil:
    section.add "questId", valid_589274
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
  var valid_589278 = query.getOrDefault("oauth_token")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "oauth_token", valid_589278
  var valid_589279 = query.getOrDefault("userIp")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "userIp", valid_589279
  var valid_589280 = query.getOrDefault("key")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "key", valid_589280
  var valid_589281 = query.getOrDefault("prettyPrint")
  valid_589281 = validateParameter(valid_589281, JBool, required = false,
                                 default = newJBool(true))
  if valid_589281 != nil:
    section.add "prettyPrint", valid_589281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589282: Call_GamesManagementQuestsResetForAllPlayers_589271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all player progress on the quest with the given ID for all players. This method is only available to user accounts for your developer console. Only draft quests can be reset.
  ## 
  let valid = call_589282.validator(path, query, header, formData, body)
  let scheme = call_589282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589282.url(scheme.get, call_589282.host, call_589282.base,
                         call_589282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589282, url, valid)

proc call*(call_589283: Call_GamesManagementQuestsResetForAllPlayers_589271;
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
  var path_589284 = newJObject()
  var query_589285 = newJObject()
  add(query_589285, "fields", newJString(fields))
  add(query_589285, "quotaUser", newJString(quotaUser))
  add(query_589285, "alt", newJString(alt))
  add(query_589285, "oauth_token", newJString(oauthToken))
  add(query_589285, "userIp", newJString(userIp))
  add(query_589285, "key", newJString(key))
  add(path_589284, "questId", newJString(questId))
  add(query_589285, "prettyPrint", newJBool(prettyPrint))
  result = call_589283.call(path_589284, query_589285, nil, nil, nil)

var gamesManagementQuestsResetForAllPlayers* = Call_GamesManagementQuestsResetForAllPlayers_589271(
    name: "gamesManagementQuestsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/{questId}/resetForAllPlayers",
    validator: validate_GamesManagementQuestsResetForAllPlayers_589272,
    base: "/games/v1management", url: url_GamesManagementQuestsResetForAllPlayers_589273,
    schemes: {Scheme.Https})
type
  Call_GamesManagementRoomsReset_589286 = ref object of OpenApiRestCall_588457
proc url_GamesManagementRoomsReset_589288(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementRoomsReset_589287(path: JsonNode; query: JsonNode;
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
  var valid_589289 = query.getOrDefault("fields")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "fields", valid_589289
  var valid_589290 = query.getOrDefault("quotaUser")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "quotaUser", valid_589290
  var valid_589291 = query.getOrDefault("alt")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = newJString("json"))
  if valid_589291 != nil:
    section.add "alt", valid_589291
  var valid_589292 = query.getOrDefault("oauth_token")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "oauth_token", valid_589292
  var valid_589293 = query.getOrDefault("userIp")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "userIp", valid_589293
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589296: Call_GamesManagementRoomsReset_589286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reset all rooms for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_589296.validator(path, query, header, formData, body)
  let scheme = call_589296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589296.url(scheme.get, call_589296.host, call_589296.base,
                         call_589296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589296, url, valid)

proc call*(call_589297: Call_GamesManagementRoomsReset_589286; fields: string = "";
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
  var query_589298 = newJObject()
  add(query_589298, "fields", newJString(fields))
  add(query_589298, "quotaUser", newJString(quotaUser))
  add(query_589298, "alt", newJString(alt))
  add(query_589298, "oauth_token", newJString(oauthToken))
  add(query_589298, "userIp", newJString(userIp))
  add(query_589298, "key", newJString(key))
  add(query_589298, "prettyPrint", newJBool(prettyPrint))
  result = call_589297.call(nil, query_589298, nil, nil, nil)

var gamesManagementRoomsReset* = Call_GamesManagementRoomsReset_589286(
    name: "gamesManagementRoomsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/reset",
    validator: validate_GamesManagementRoomsReset_589287,
    base: "/games/v1management", url: url_GamesManagementRoomsReset_589288,
    schemes: {Scheme.Https})
type
  Call_GamesManagementRoomsResetForAllPlayers_589299 = ref object of OpenApiRestCall_588457
proc url_GamesManagementRoomsResetForAllPlayers_589301(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementRoomsResetForAllPlayers_589300(path: JsonNode;
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
  var valid_589302 = query.getOrDefault("fields")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "fields", valid_589302
  var valid_589303 = query.getOrDefault("quotaUser")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "quotaUser", valid_589303
  var valid_589304 = query.getOrDefault("alt")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = newJString("json"))
  if valid_589304 != nil:
    section.add "alt", valid_589304
  var valid_589305 = query.getOrDefault("oauth_token")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "oauth_token", valid_589305
  var valid_589306 = query.getOrDefault("userIp")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "userIp", valid_589306
  var valid_589307 = query.getOrDefault("key")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "key", valid_589307
  var valid_589308 = query.getOrDefault("prettyPrint")
  valid_589308 = validateParameter(valid_589308, JBool, required = false,
                                 default = newJBool(true))
  if valid_589308 != nil:
    section.add "prettyPrint", valid_589308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589309: Call_GamesManagementRoomsResetForAllPlayers_589299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes rooms where the only room participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_589309.validator(path, query, header, formData, body)
  let scheme = call_589309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589309.url(scheme.get, call_589309.host, call_589309.base,
                         call_589309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589309, url, valid)

proc call*(call_589310: Call_GamesManagementRoomsResetForAllPlayers_589299;
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
  var query_589311 = newJObject()
  add(query_589311, "fields", newJString(fields))
  add(query_589311, "quotaUser", newJString(quotaUser))
  add(query_589311, "alt", newJString(alt))
  add(query_589311, "oauth_token", newJString(oauthToken))
  add(query_589311, "userIp", newJString(userIp))
  add(query_589311, "key", newJString(key))
  add(query_589311, "prettyPrint", newJBool(prettyPrint))
  result = call_589310.call(nil, query_589311, nil, nil, nil)

var gamesManagementRoomsResetForAllPlayers* = Call_GamesManagementRoomsResetForAllPlayers_589299(
    name: "gamesManagementRoomsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/resetForAllPlayers",
    validator: validate_GamesManagementRoomsResetForAllPlayers_589300,
    base: "/games/v1management", url: url_GamesManagementRoomsResetForAllPlayers_589301,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetAll_589312 = ref object of OpenApiRestCall_588457
proc url_GamesManagementScoresResetAll_589314(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetAll_589313(path: JsonNode; query: JsonNode;
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
  var valid_589315 = query.getOrDefault("fields")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "fields", valid_589315
  var valid_589316 = query.getOrDefault("quotaUser")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "quotaUser", valid_589316
  var valid_589317 = query.getOrDefault("alt")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = newJString("json"))
  if valid_589317 != nil:
    section.add "alt", valid_589317
  var valid_589318 = query.getOrDefault("oauth_token")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "oauth_token", valid_589318
  var valid_589319 = query.getOrDefault("userIp")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "userIp", valid_589319
  var valid_589320 = query.getOrDefault("key")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "key", valid_589320
  var valid_589321 = query.getOrDefault("prettyPrint")
  valid_589321 = validateParameter(valid_589321, JBool, required = false,
                                 default = newJBool(true))
  if valid_589321 != nil:
    section.add "prettyPrint", valid_589321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589322: Call_GamesManagementScoresResetAll_589312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all scores for all leaderboards for the currently authenticated players. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_589322.validator(path, query, header, formData, body)
  let scheme = call_589322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589322.url(scheme.get, call_589322.host, call_589322.base,
                         call_589322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589322, url, valid)

proc call*(call_589323: Call_GamesManagementScoresResetAll_589312;
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
  var query_589324 = newJObject()
  add(query_589324, "fields", newJString(fields))
  add(query_589324, "quotaUser", newJString(quotaUser))
  add(query_589324, "alt", newJString(alt))
  add(query_589324, "oauth_token", newJString(oauthToken))
  add(query_589324, "userIp", newJString(userIp))
  add(query_589324, "key", newJString(key))
  add(query_589324, "prettyPrint", newJBool(prettyPrint))
  result = call_589323.call(nil, query_589324, nil, nil, nil)

var gamesManagementScoresResetAll* = Call_GamesManagementScoresResetAll_589312(
    name: "gamesManagementScoresResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/scores/reset",
    validator: validate_GamesManagementScoresResetAll_589313,
    base: "/games/v1management", url: url_GamesManagementScoresResetAll_589314,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetAllForAllPlayers_589325 = ref object of OpenApiRestCall_588457
proc url_GamesManagementScoresResetAllForAllPlayers_589327(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetAllForAllPlayers_589326(path: JsonNode;
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
  var valid_589328 = query.getOrDefault("fields")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "fields", valid_589328
  var valid_589329 = query.getOrDefault("quotaUser")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "quotaUser", valid_589329
  var valid_589330 = query.getOrDefault("alt")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = newJString("json"))
  if valid_589330 != nil:
    section.add "alt", valid_589330
  var valid_589331 = query.getOrDefault("oauth_token")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "oauth_token", valid_589331
  var valid_589332 = query.getOrDefault("userIp")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "userIp", valid_589332
  var valid_589333 = query.getOrDefault("key")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "key", valid_589333
  var valid_589334 = query.getOrDefault("prettyPrint")
  valid_589334 = validateParameter(valid_589334, JBool, required = false,
                                 default = newJBool(true))
  if valid_589334 != nil:
    section.add "prettyPrint", valid_589334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589335: Call_GamesManagementScoresResetAllForAllPlayers_589325;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for all draft leaderboards for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_589335.validator(path, query, header, formData, body)
  let scheme = call_589335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589335.url(scheme.get, call_589335.host, call_589335.base,
                         call_589335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589335, url, valid)

proc call*(call_589336: Call_GamesManagementScoresResetAllForAllPlayers_589325;
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
  var query_589337 = newJObject()
  add(query_589337, "fields", newJString(fields))
  add(query_589337, "quotaUser", newJString(quotaUser))
  add(query_589337, "alt", newJString(alt))
  add(query_589337, "oauth_token", newJString(oauthToken))
  add(query_589337, "userIp", newJString(userIp))
  add(query_589337, "key", newJString(key))
  add(query_589337, "prettyPrint", newJBool(prettyPrint))
  result = call_589336.call(nil, query_589337, nil, nil, nil)

var gamesManagementScoresResetAllForAllPlayers* = Call_GamesManagementScoresResetAllForAllPlayers_589325(
    name: "gamesManagementScoresResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/scores/resetAllForAllPlayers",
    validator: validate_GamesManagementScoresResetAllForAllPlayers_589326,
    base: "/games/v1management",
    url: url_GamesManagementScoresResetAllForAllPlayers_589327,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetMultipleForAllPlayers_589338 = ref object of OpenApiRestCall_588457
proc url_GamesManagementScoresResetMultipleForAllPlayers_589340(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetMultipleForAllPlayers_589339(
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
  var valid_589341 = query.getOrDefault("fields")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "fields", valid_589341
  var valid_589342 = query.getOrDefault("quotaUser")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "quotaUser", valid_589342
  var valid_589343 = query.getOrDefault("alt")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = newJString("json"))
  if valid_589343 != nil:
    section.add "alt", valid_589343
  var valid_589344 = query.getOrDefault("oauth_token")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "oauth_token", valid_589344
  var valid_589345 = query.getOrDefault("userIp")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "userIp", valid_589345
  var valid_589346 = query.getOrDefault("key")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "key", valid_589346
  var valid_589347 = query.getOrDefault("prettyPrint")
  valid_589347 = validateParameter(valid_589347, JBool, required = false,
                                 default = newJBool(true))
  if valid_589347 != nil:
    section.add "prettyPrint", valid_589347
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

proc call*(call_589349: Call_GamesManagementScoresResetMultipleForAllPlayers_589338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for the leaderboards with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft leaderboards may be reset.
  ## 
  let valid = call_589349.validator(path, query, header, formData, body)
  let scheme = call_589349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589349.url(scheme.get, call_589349.host, call_589349.base,
                         call_589349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589349, url, valid)

proc call*(call_589350: Call_GamesManagementScoresResetMultipleForAllPlayers_589338;
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
  var query_589351 = newJObject()
  var body_589352 = newJObject()
  add(query_589351, "fields", newJString(fields))
  add(query_589351, "quotaUser", newJString(quotaUser))
  add(query_589351, "alt", newJString(alt))
  add(query_589351, "oauth_token", newJString(oauthToken))
  add(query_589351, "userIp", newJString(userIp))
  add(query_589351, "key", newJString(key))
  if body != nil:
    body_589352 = body
  add(query_589351, "prettyPrint", newJBool(prettyPrint))
  result = call_589350.call(nil, query_589351, nil, nil, body_589352)

var gamesManagementScoresResetMultipleForAllPlayers* = Call_GamesManagementScoresResetMultipleForAllPlayers_589338(
    name: "gamesManagementScoresResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/scores/resetMultipleForAllPlayers",
    validator: validate_GamesManagementScoresResetMultipleForAllPlayers_589339,
    base: "/games/v1management",
    url: url_GamesManagementScoresResetMultipleForAllPlayers_589340,
    schemes: {Scheme.Https})
type
  Call_GamesManagementTurnBasedMatchesReset_589353 = ref object of OpenApiRestCall_588457
proc url_GamesManagementTurnBasedMatchesReset_589355(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementTurnBasedMatchesReset_589354(path: JsonNode;
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
  var valid_589356 = query.getOrDefault("fields")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "fields", valid_589356
  var valid_589357 = query.getOrDefault("quotaUser")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "quotaUser", valid_589357
  var valid_589358 = query.getOrDefault("alt")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = newJString("json"))
  if valid_589358 != nil:
    section.add "alt", valid_589358
  var valid_589359 = query.getOrDefault("oauth_token")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "oauth_token", valid_589359
  var valid_589360 = query.getOrDefault("userIp")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "userIp", valid_589360
  var valid_589361 = query.getOrDefault("key")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "key", valid_589361
  var valid_589362 = query.getOrDefault("prettyPrint")
  valid_589362 = validateParameter(valid_589362, JBool, required = false,
                                 default = newJBool(true))
  if valid_589362 != nil:
    section.add "prettyPrint", valid_589362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589363: Call_GamesManagementTurnBasedMatchesReset_589353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset all turn-based match data for a user. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_589363.validator(path, query, header, formData, body)
  let scheme = call_589363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589363.url(scheme.get, call_589363.host, call_589363.base,
                         call_589363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589363, url, valid)

proc call*(call_589364: Call_GamesManagementTurnBasedMatchesReset_589353;
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
  var query_589365 = newJObject()
  add(query_589365, "fields", newJString(fields))
  add(query_589365, "quotaUser", newJString(quotaUser))
  add(query_589365, "alt", newJString(alt))
  add(query_589365, "oauth_token", newJString(oauthToken))
  add(query_589365, "userIp", newJString(userIp))
  add(query_589365, "key", newJString(key))
  add(query_589365, "prettyPrint", newJBool(prettyPrint))
  result = call_589364.call(nil, query_589365, nil, nil, nil)

var gamesManagementTurnBasedMatchesReset* = Call_GamesManagementTurnBasedMatchesReset_589353(
    name: "gamesManagementTurnBasedMatchesReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/reset",
    validator: validate_GamesManagementTurnBasedMatchesReset_589354,
    base: "/games/v1management", url: url_GamesManagementTurnBasedMatchesReset_589355,
    schemes: {Scheme.Https})
type
  Call_GamesManagementTurnBasedMatchesResetForAllPlayers_589366 = ref object of OpenApiRestCall_588457
proc url_GamesManagementTurnBasedMatchesResetForAllPlayers_589368(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementTurnBasedMatchesResetForAllPlayers_589367(
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
  var valid_589369 = query.getOrDefault("fields")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "fields", valid_589369
  var valid_589370 = query.getOrDefault("quotaUser")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "quotaUser", valid_589370
  var valid_589371 = query.getOrDefault("alt")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = newJString("json"))
  if valid_589371 != nil:
    section.add "alt", valid_589371
  var valid_589372 = query.getOrDefault("oauth_token")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "oauth_token", valid_589372
  var valid_589373 = query.getOrDefault("userIp")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "userIp", valid_589373
  var valid_589374 = query.getOrDefault("key")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "key", valid_589374
  var valid_589375 = query.getOrDefault("prettyPrint")
  valid_589375 = validateParameter(valid_589375, JBool, required = false,
                                 default = newJBool(true))
  if valid_589375 != nil:
    section.add "prettyPrint", valid_589375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589376: Call_GamesManagementTurnBasedMatchesResetForAllPlayers_589366;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes turn-based matches where the only match participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_589376.validator(path, query, header, formData, body)
  let scheme = call_589376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589376.url(scheme.get, call_589376.host, call_589376.base,
                         call_589376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589376, url, valid)

proc call*(call_589377: Call_GamesManagementTurnBasedMatchesResetForAllPlayers_589366;
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
  var query_589378 = newJObject()
  add(query_589378, "fields", newJString(fields))
  add(query_589378, "quotaUser", newJString(quotaUser))
  add(query_589378, "alt", newJString(alt))
  add(query_589378, "oauth_token", newJString(oauthToken))
  add(query_589378, "userIp", newJString(userIp))
  add(query_589378, "key", newJString(key))
  add(query_589378, "prettyPrint", newJBool(prettyPrint))
  result = call_589377.call(nil, query_589378, nil, nil, nil)

var gamesManagementTurnBasedMatchesResetForAllPlayers* = Call_GamesManagementTurnBasedMatchesResetForAllPlayers_589366(
    name: "gamesManagementTurnBasedMatchesResetForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/turnbasedmatches/resetForAllPlayers",
    validator: validate_GamesManagementTurnBasedMatchesResetForAllPlayers_589367,
    base: "/games/v1management",
    url: url_GamesManagementTurnBasedMatchesResetForAllPlayers_589368,
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
