
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
  gcpServiceName = "gamesManagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GamesManagementAchievementsResetAll_578625 = ref object of OpenApiRestCall_578355
proc url_GamesManagementAchievementsResetAll_578627(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetAll_578626(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all achievements for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("alt")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("json"))
  if valid_578755 != nil:
    section.add "alt", valid_578755
  var valid_578756 = query.getOrDefault("userIp")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "userIp", valid_578756
  var valid_578757 = query.getOrDefault("quotaUser")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "quotaUser", valid_578757
  var valid_578758 = query.getOrDefault("fields")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "fields", valid_578758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578781: Call_GamesManagementAchievementsResetAll_578625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all achievements for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_578781.validator(path, query, header, formData, body)
  let scheme = call_578781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578781.url(scheme.get, call_578781.host, call_578781.base,
                         call_578781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578781, url, valid)

proc call*(call_578852: Call_GamesManagementAchievementsResetAll_578625;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementAchievementsResetAll
  ## Resets all achievements for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
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
  var query_578853 = newJObject()
  add(query_578853, "key", newJString(key))
  add(query_578853, "prettyPrint", newJBool(prettyPrint))
  add(query_578853, "oauth_token", newJString(oauthToken))
  add(query_578853, "alt", newJString(alt))
  add(query_578853, "userIp", newJString(userIp))
  add(query_578853, "quotaUser", newJString(quotaUser))
  add(query_578853, "fields", newJString(fields))
  result = call_578852.call(nil, query_578853, nil, nil, nil)

var gamesManagementAchievementsResetAll* = Call_GamesManagementAchievementsResetAll_578625(
    name: "gamesManagementAchievementsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/reset",
    validator: validate_GamesManagementAchievementsResetAll_578626,
    base: "/games/v1management", url: url_GamesManagementAchievementsResetAll_578627,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetAllForAllPlayers_578893 = ref object of OpenApiRestCall_578355
proc url_GamesManagementAchievementsResetAllForAllPlayers_578895(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetAllForAllPlayers_578894(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets all draft achievements for all players. This method is only available to user accounts for your developer console.
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
  var valid_578896 = query.getOrDefault("key")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "key", valid_578896
  var valid_578897 = query.getOrDefault("prettyPrint")
  valid_578897 = validateParameter(valid_578897, JBool, required = false,
                                 default = newJBool(true))
  if valid_578897 != nil:
    section.add "prettyPrint", valid_578897
  var valid_578898 = query.getOrDefault("oauth_token")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "oauth_token", valid_578898
  var valid_578899 = query.getOrDefault("alt")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = newJString("json"))
  if valid_578899 != nil:
    section.add "alt", valid_578899
  var valid_578900 = query.getOrDefault("userIp")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "userIp", valid_578900
  var valid_578901 = query.getOrDefault("quotaUser")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "quotaUser", valid_578901
  var valid_578902 = query.getOrDefault("fields")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "fields", valid_578902
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578903: Call_GamesManagementAchievementsResetAllForAllPlayers_578893;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft achievements for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_578903.validator(path, query, header, formData, body)
  let scheme = call_578903.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578903.url(scheme.get, call_578903.host, call_578903.base,
                         call_578903.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578903, url, valid)

proc call*(call_578904: Call_GamesManagementAchievementsResetAllForAllPlayers_578893;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementAchievementsResetAllForAllPlayers
  ## Resets all draft achievements for all players. This method is only available to user accounts for your developer console.
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
  var query_578905 = newJObject()
  add(query_578905, "key", newJString(key))
  add(query_578905, "prettyPrint", newJBool(prettyPrint))
  add(query_578905, "oauth_token", newJString(oauthToken))
  add(query_578905, "alt", newJString(alt))
  add(query_578905, "userIp", newJString(userIp))
  add(query_578905, "quotaUser", newJString(quotaUser))
  add(query_578905, "fields", newJString(fields))
  result = call_578904.call(nil, query_578905, nil, nil, nil)

var gamesManagementAchievementsResetAllForAllPlayers* = Call_GamesManagementAchievementsResetAllForAllPlayers_578893(
    name: "gamesManagementAchievementsResetAllForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/resetAllForAllPlayers",
    validator: validate_GamesManagementAchievementsResetAllForAllPlayers_578894,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetAllForAllPlayers_578895,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetMultipleForAllPlayers_578906 = ref object of OpenApiRestCall_578355
proc url_GamesManagementAchievementsResetMultipleForAllPlayers_578908(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementAchievementsResetMultipleForAllPlayers_578907(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets achievements with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft achievements may be reset.
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
  var valid_578909 = query.getOrDefault("key")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "key", valid_578909
  var valid_578910 = query.getOrDefault("prettyPrint")
  valid_578910 = validateParameter(valid_578910, JBool, required = false,
                                 default = newJBool(true))
  if valid_578910 != nil:
    section.add "prettyPrint", valid_578910
  var valid_578911 = query.getOrDefault("oauth_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "oauth_token", valid_578911
  var valid_578912 = query.getOrDefault("alt")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = newJString("json"))
  if valid_578912 != nil:
    section.add "alt", valid_578912
  var valid_578913 = query.getOrDefault("userIp")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "userIp", valid_578913
  var valid_578914 = query.getOrDefault("quotaUser")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "quotaUser", valid_578914
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

proc call*(call_578917: Call_GamesManagementAchievementsResetMultipleForAllPlayers_578906;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets achievements with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft achievements may be reset.
  ## 
  let valid = call_578917.validator(path, query, header, formData, body)
  let scheme = call_578917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578917.url(scheme.get, call_578917.host, call_578917.base,
                         call_578917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578917, url, valid)

proc call*(call_578918: Call_GamesManagementAchievementsResetMultipleForAllPlayers_578906;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## gamesManagementAchievementsResetMultipleForAllPlayers
  ## Resets achievements with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft achievements may be reset.
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
  add(query_578919, "fields", newJString(fields))
  result = call_578918.call(nil, query_578919, nil, nil, body_578920)

var gamesManagementAchievementsResetMultipleForAllPlayers* = Call_GamesManagementAchievementsResetMultipleForAllPlayers_578906(
    name: "gamesManagementAchievementsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/resetMultipleForAllPlayers",
    validator: validate_GamesManagementAchievementsResetMultipleForAllPlayers_578907,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetMultipleForAllPlayers_578908,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsReset_578921 = ref object of OpenApiRestCall_578355
proc url_GamesManagementAchievementsReset_578923(protocol: Scheme; host: string;
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

proc validate_GamesManagementAchievementsReset_578922(path: JsonNode;
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_578945 = query.getOrDefault("fields")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "fields", valid_578945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578946: Call_GamesManagementAchievementsReset_578921;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the achievement with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_GamesManagementAchievementsReset_578921;
          achievementId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesManagementAchievementsReset
  ## Resets the achievement with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
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
  var path_578948 = newJObject()
  var query_578949 = newJObject()
  add(query_578949, "key", newJString(key))
  add(query_578949, "prettyPrint", newJBool(prettyPrint))
  add(query_578949, "oauth_token", newJString(oauthToken))
  add(query_578949, "alt", newJString(alt))
  add(query_578949, "userIp", newJString(userIp))
  add(query_578949, "quotaUser", newJString(quotaUser))
  add(path_578948, "achievementId", newJString(achievementId))
  add(query_578949, "fields", newJString(fields))
  result = call_578947.call(path_578948, query_578949, nil, nil, nil)

var gamesManagementAchievementsReset* = Call_GamesManagementAchievementsReset_578921(
    name: "gamesManagementAchievementsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/achievements/{achievementId}/reset",
    validator: validate_GamesManagementAchievementsReset_578922,
    base: "/games/v1management", url: url_GamesManagementAchievementsReset_578923,
    schemes: {Scheme.Https})
type
  Call_GamesManagementAchievementsResetForAllPlayers_578950 = ref object of OpenApiRestCall_578355
proc url_GamesManagementAchievementsResetForAllPlayers_578952(protocol: Scheme;
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

proc validate_GamesManagementAchievementsResetForAllPlayers_578951(
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
  var valid_578953 = path.getOrDefault("achievementId")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "achievementId", valid_578953
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
  var valid_578954 = query.getOrDefault("key")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "key", valid_578954
  var valid_578955 = query.getOrDefault("prettyPrint")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(true))
  if valid_578955 != nil:
    section.add "prettyPrint", valid_578955
  var valid_578956 = query.getOrDefault("oauth_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "oauth_token", valid_578956
  var valid_578957 = query.getOrDefault("alt")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("json"))
  if valid_578957 != nil:
    section.add "alt", valid_578957
  var valid_578958 = query.getOrDefault("userIp")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "userIp", valid_578958
  var valid_578959 = query.getOrDefault("quotaUser")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "quotaUser", valid_578959
  var valid_578960 = query.getOrDefault("fields")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "fields", valid_578960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578961: Call_GamesManagementAchievementsResetForAllPlayers_578950;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the achievement with the given ID for all players. This method is only available to user accounts for your developer console. Only draft achievements can be reset.
  ## 
  let valid = call_578961.validator(path, query, header, formData, body)
  let scheme = call_578961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578961.url(scheme.get, call_578961.host, call_578961.base,
                         call_578961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578961, url, valid)

proc call*(call_578962: Call_GamesManagementAchievementsResetForAllPlayers_578950;
          achievementId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesManagementAchievementsResetForAllPlayers
  ## Resets the achievement with the given ID for all players. This method is only available to user accounts for your developer console. Only draft achievements can be reset.
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
  var path_578963 = newJObject()
  var query_578964 = newJObject()
  add(query_578964, "key", newJString(key))
  add(query_578964, "prettyPrint", newJBool(prettyPrint))
  add(query_578964, "oauth_token", newJString(oauthToken))
  add(query_578964, "alt", newJString(alt))
  add(query_578964, "userIp", newJString(userIp))
  add(query_578964, "quotaUser", newJString(quotaUser))
  add(path_578963, "achievementId", newJString(achievementId))
  add(query_578964, "fields", newJString(fields))
  result = call_578962.call(path_578963, query_578964, nil, nil, nil)

var gamesManagementAchievementsResetForAllPlayers* = Call_GamesManagementAchievementsResetForAllPlayers_578950(
    name: "gamesManagementAchievementsResetForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/achievements/{achievementId}/resetForAllPlayers",
    validator: validate_GamesManagementAchievementsResetForAllPlayers_578951,
    base: "/games/v1management",
    url: url_GamesManagementAchievementsResetForAllPlayers_578952,
    schemes: {Scheme.Https})
type
  Call_GamesManagementApplicationsListHidden_578965 = ref object of OpenApiRestCall_578355
proc url_GamesManagementApplicationsListHidden_578967(protocol: Scheme;
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

proc validate_GamesManagementApplicationsListHidden_578966(path: JsonNode;
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
  var valid_578968 = path.getOrDefault("applicationId")
  valid_578968 = validateParameter(valid_578968, JString, required = true,
                                 default = nil)
  if valid_578968 != nil:
    section.add "applicationId", valid_578968
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
  ##   maxResults: JInt
  ##             : The maximum number of player resources to return in the response, used for paging. For any response, the actual number of player resources returned may be less than the specified maxResults.
  section = newJObject()
  var valid_578969 = query.getOrDefault("key")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "key", valid_578969
  var valid_578970 = query.getOrDefault("prettyPrint")
  valid_578970 = validateParameter(valid_578970, JBool, required = false,
                                 default = newJBool(true))
  if valid_578970 != nil:
    section.add "prettyPrint", valid_578970
  var valid_578971 = query.getOrDefault("oauth_token")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "oauth_token", valid_578971
  var valid_578972 = query.getOrDefault("alt")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = newJString("json"))
  if valid_578972 != nil:
    section.add "alt", valid_578972
  var valid_578973 = query.getOrDefault("userIp")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "userIp", valid_578973
  var valid_578974 = query.getOrDefault("quotaUser")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "quotaUser", valid_578974
  var valid_578975 = query.getOrDefault("pageToken")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "pageToken", valid_578975
  var valid_578976 = query.getOrDefault("fields")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "fields", valid_578976
  var valid_578977 = query.getOrDefault("maxResults")
  valid_578977 = validateParameter(valid_578977, JInt, required = false, default = nil)
  if valid_578977 != nil:
    section.add "maxResults", valid_578977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578978: Call_GamesManagementApplicationsListHidden_578965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of players hidden from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_578978.validator(path, query, header, formData, body)
  let scheme = call_578978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578978.url(scheme.get, call_578978.host, call_578978.base,
                         call_578978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578978, url, valid)

proc call*(call_578979: Call_GamesManagementApplicationsListHidden_578965;
          applicationId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## gamesManagementApplicationsListHidden
  ## Get the list of players hidden from the given application. This method is only available to user accounts for your developer console.
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
  ##   maxResults: int
  ##             : The maximum number of player resources to return in the response, used for paging. For any response, the actual number of player resources returned may be less than the specified maxResults.
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  var path_578980 = newJObject()
  var query_578981 = newJObject()
  add(query_578981, "key", newJString(key))
  add(query_578981, "prettyPrint", newJBool(prettyPrint))
  add(query_578981, "oauth_token", newJString(oauthToken))
  add(query_578981, "alt", newJString(alt))
  add(query_578981, "userIp", newJString(userIp))
  add(query_578981, "quotaUser", newJString(quotaUser))
  add(query_578981, "pageToken", newJString(pageToken))
  add(query_578981, "fields", newJString(fields))
  add(query_578981, "maxResults", newJInt(maxResults))
  add(path_578980, "applicationId", newJString(applicationId))
  result = call_578979.call(path_578980, query_578981, nil, nil, nil)

var gamesManagementApplicationsListHidden* = Call_GamesManagementApplicationsListHidden_578965(
    name: "gamesManagementApplicationsListHidden", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden",
    validator: validate_GamesManagementApplicationsListHidden_578966,
    base: "/games/v1management", url: url_GamesManagementApplicationsListHidden_578967,
    schemes: {Scheme.Https})
type
  Call_GamesManagementPlayersHide_578982 = ref object of OpenApiRestCall_578355
proc url_GamesManagementPlayersHide_578984(protocol: Scheme; host: string;
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

proc validate_GamesManagementPlayersHide_578983(path: JsonNode; query: JsonNode;
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
  var valid_578985 = path.getOrDefault("playerId")
  valid_578985 = validateParameter(valid_578985, JString, required = true,
                                 default = nil)
  if valid_578985 != nil:
    section.add "playerId", valid_578985
  var valid_578986 = path.getOrDefault("applicationId")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "applicationId", valid_578986
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
  var valid_578993 = query.getOrDefault("fields")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "fields", valid_578993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578994: Call_GamesManagementPlayersHide_578982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Hide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_578994.validator(path, query, header, formData, body)
  let scheme = call_578994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578994.url(scheme.get, call_578994.host, call_578994.base,
                         call_578994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578994, url, valid)

proc call*(call_578995: Call_GamesManagementPlayersHide_578982; playerId: string;
          applicationId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesManagementPlayersHide
  ## Hide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
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
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  var path_578996 = newJObject()
  var query_578997 = newJObject()
  add(query_578997, "key", newJString(key))
  add(query_578997, "prettyPrint", newJBool(prettyPrint))
  add(query_578997, "oauth_token", newJString(oauthToken))
  add(path_578996, "playerId", newJString(playerId))
  add(query_578997, "alt", newJString(alt))
  add(query_578997, "userIp", newJString(userIp))
  add(query_578997, "quotaUser", newJString(quotaUser))
  add(query_578997, "fields", newJString(fields))
  add(path_578996, "applicationId", newJString(applicationId))
  result = call_578995.call(path_578996, query_578997, nil, nil, nil)

var gamesManagementPlayersHide* = Call_GamesManagementPlayersHide_578982(
    name: "gamesManagementPlayersHide", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden/{playerId}",
    validator: validate_GamesManagementPlayersHide_578983,
    base: "/games/v1management", url: url_GamesManagementPlayersHide_578984,
    schemes: {Scheme.Https})
type
  Call_GamesManagementPlayersUnhide_578998 = ref object of OpenApiRestCall_578355
proc url_GamesManagementPlayersUnhide_579000(protocol: Scheme; host: string;
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

proc validate_GamesManagementPlayersUnhide_578999(path: JsonNode; query: JsonNode;
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
  var valid_579001 = path.getOrDefault("playerId")
  valid_579001 = validateParameter(valid_579001, JString, required = true,
                                 default = nil)
  if valid_579001 != nil:
    section.add "playerId", valid_579001
  var valid_579002 = path.getOrDefault("applicationId")
  valid_579002 = validateParameter(valid_579002, JString, required = true,
                                 default = nil)
  if valid_579002 != nil:
    section.add "applicationId", valid_579002
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
  var valid_579003 = query.getOrDefault("key")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "key", valid_579003
  var valid_579004 = query.getOrDefault("prettyPrint")
  valid_579004 = validateParameter(valid_579004, JBool, required = false,
                                 default = newJBool(true))
  if valid_579004 != nil:
    section.add "prettyPrint", valid_579004
  var valid_579005 = query.getOrDefault("oauth_token")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "oauth_token", valid_579005
  var valid_579006 = query.getOrDefault("alt")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = newJString("json"))
  if valid_579006 != nil:
    section.add "alt", valid_579006
  var valid_579007 = query.getOrDefault("userIp")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "userIp", valid_579007
  var valid_579008 = query.getOrDefault("quotaUser")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "quotaUser", valid_579008
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

proc call*(call_579010: Call_GamesManagementPlayersUnhide_578998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unhide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_579010.validator(path, query, header, formData, body)
  let scheme = call_579010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579010.url(scheme.get, call_579010.host, call_579010.base,
                         call_579010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579010, url, valid)

proc call*(call_579011: Call_GamesManagementPlayersUnhide_578998; playerId: string;
          applicationId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesManagementPlayersUnhide
  ## Unhide the given player's leaderboard scores from the given application. This method is only available to user accounts for your developer console.
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
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  var path_579012 = newJObject()
  var query_579013 = newJObject()
  add(query_579013, "key", newJString(key))
  add(query_579013, "prettyPrint", newJBool(prettyPrint))
  add(query_579013, "oauth_token", newJString(oauthToken))
  add(path_579012, "playerId", newJString(playerId))
  add(query_579013, "alt", newJString(alt))
  add(query_579013, "userIp", newJString(userIp))
  add(query_579013, "quotaUser", newJString(quotaUser))
  add(query_579013, "fields", newJString(fields))
  add(path_579012, "applicationId", newJString(applicationId))
  result = call_579011.call(path_579012, query_579013, nil, nil, nil)

var gamesManagementPlayersUnhide* = Call_GamesManagementPlayersUnhide_578998(
    name: "gamesManagementPlayersUnhide", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/applications/{applicationId}/players/hidden/{playerId}",
    validator: validate_GamesManagementPlayersUnhide_578999,
    base: "/games/v1management", url: url_GamesManagementPlayersUnhide_579000,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetAll_579014 = ref object of OpenApiRestCall_578355
proc url_GamesManagementEventsResetAll_579016(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetAll_579015(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all player progress on all events for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player will also be reset.
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579024: Call_GamesManagementEventsResetAll_579014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on all events for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player will also be reset.
  ## 
  let valid = call_579024.validator(path, query, header, formData, body)
  let scheme = call_579024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579024.url(scheme.get, call_579024.host, call_579024.base,
                         call_579024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579024, url, valid)

proc call*(call_579025: Call_GamesManagementEventsResetAll_579014;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementEventsResetAll
  ## Resets all player progress on all events for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player will also be reset.
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
  var query_579026 = newJObject()
  add(query_579026, "key", newJString(key))
  add(query_579026, "prettyPrint", newJBool(prettyPrint))
  add(query_579026, "oauth_token", newJString(oauthToken))
  add(query_579026, "alt", newJString(alt))
  add(query_579026, "userIp", newJString(userIp))
  add(query_579026, "quotaUser", newJString(quotaUser))
  add(query_579026, "fields", newJString(fields))
  result = call_579025.call(nil, query_579026, nil, nil, nil)

var gamesManagementEventsResetAll* = Call_GamesManagementEventsResetAll_579014(
    name: "gamesManagementEventsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/reset",
    validator: validate_GamesManagementEventsResetAll_579015,
    base: "/games/v1management", url: url_GamesManagementEventsResetAll_579016,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetAllForAllPlayers_579027 = ref object of OpenApiRestCall_578355
proc url_GamesManagementEventsResetAllForAllPlayers_579029(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetAllForAllPlayers_579028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all draft events for all players. This method is only available to user accounts for your developer console. All quests that use any of these events will also be reset.
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
  var valid_579030 = query.getOrDefault("key")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "key", valid_579030
  var valid_579031 = query.getOrDefault("prettyPrint")
  valid_579031 = validateParameter(valid_579031, JBool, required = false,
                                 default = newJBool(true))
  if valid_579031 != nil:
    section.add "prettyPrint", valid_579031
  var valid_579032 = query.getOrDefault("oauth_token")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "oauth_token", valid_579032
  var valid_579033 = query.getOrDefault("alt")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("json"))
  if valid_579033 != nil:
    section.add "alt", valid_579033
  var valid_579034 = query.getOrDefault("userIp")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "userIp", valid_579034
  var valid_579035 = query.getOrDefault("quotaUser")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "quotaUser", valid_579035
  var valid_579036 = query.getOrDefault("fields")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "fields", valid_579036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579037: Call_GamesManagementEventsResetAllForAllPlayers_579027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft events for all players. This method is only available to user accounts for your developer console. All quests that use any of these events will also be reset.
  ## 
  let valid = call_579037.validator(path, query, header, formData, body)
  let scheme = call_579037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579037.url(scheme.get, call_579037.host, call_579037.base,
                         call_579037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579037, url, valid)

proc call*(call_579038: Call_GamesManagementEventsResetAllForAllPlayers_579027;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementEventsResetAllForAllPlayers
  ## Resets all draft events for all players. This method is only available to user accounts for your developer console. All quests that use any of these events will also be reset.
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
  var query_579039 = newJObject()
  add(query_579039, "key", newJString(key))
  add(query_579039, "prettyPrint", newJBool(prettyPrint))
  add(query_579039, "oauth_token", newJString(oauthToken))
  add(query_579039, "alt", newJString(alt))
  add(query_579039, "userIp", newJString(userIp))
  add(query_579039, "quotaUser", newJString(quotaUser))
  add(query_579039, "fields", newJString(fields))
  result = call_579038.call(nil, query_579039, nil, nil, nil)

var gamesManagementEventsResetAllForAllPlayers* = Call_GamesManagementEventsResetAllForAllPlayers_579027(
    name: "gamesManagementEventsResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/resetAllForAllPlayers",
    validator: validate_GamesManagementEventsResetAllForAllPlayers_579028,
    base: "/games/v1management",
    url: url_GamesManagementEventsResetAllForAllPlayers_579029,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetMultipleForAllPlayers_579040 = ref object of OpenApiRestCall_578355
proc url_GamesManagementEventsResetMultipleForAllPlayers_579042(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementEventsResetMultipleForAllPlayers_579041(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets events with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft events may be reset. All quests that use any of the events will also be reset.
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
  var valid_579043 = query.getOrDefault("key")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "key", valid_579043
  var valid_579044 = query.getOrDefault("prettyPrint")
  valid_579044 = validateParameter(valid_579044, JBool, required = false,
                                 default = newJBool(true))
  if valid_579044 != nil:
    section.add "prettyPrint", valid_579044
  var valid_579045 = query.getOrDefault("oauth_token")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "oauth_token", valid_579045
  var valid_579046 = query.getOrDefault("alt")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("json"))
  if valid_579046 != nil:
    section.add "alt", valid_579046
  var valid_579047 = query.getOrDefault("userIp")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "userIp", valid_579047
  var valid_579048 = query.getOrDefault("quotaUser")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "quotaUser", valid_579048
  var valid_579049 = query.getOrDefault("fields")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "fields", valid_579049
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

proc call*(call_579051: Call_GamesManagementEventsResetMultipleForAllPlayers_579040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets events with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft events may be reset. All quests that use any of the events will also be reset.
  ## 
  let valid = call_579051.validator(path, query, header, formData, body)
  let scheme = call_579051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579051.url(scheme.get, call_579051.host, call_579051.base,
                         call_579051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579051, url, valid)

proc call*(call_579052: Call_GamesManagementEventsResetMultipleForAllPlayers_579040;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## gamesManagementEventsResetMultipleForAllPlayers
  ## Resets events with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft events may be reset. All quests that use any of the events will also be reset.
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
  var query_579053 = newJObject()
  var body_579054 = newJObject()
  add(query_579053, "key", newJString(key))
  add(query_579053, "prettyPrint", newJBool(prettyPrint))
  add(query_579053, "oauth_token", newJString(oauthToken))
  add(query_579053, "alt", newJString(alt))
  add(query_579053, "userIp", newJString(userIp))
  add(query_579053, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579054 = body
  add(query_579053, "fields", newJString(fields))
  result = call_579052.call(nil, query_579053, nil, nil, body_579054)

var gamesManagementEventsResetMultipleForAllPlayers* = Call_GamesManagementEventsResetMultipleForAllPlayers_579040(
    name: "gamesManagementEventsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/events/resetMultipleForAllPlayers",
    validator: validate_GamesManagementEventsResetMultipleForAllPlayers_579041,
    base: "/games/v1management",
    url: url_GamesManagementEventsResetMultipleForAllPlayers_579042,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsReset_579055 = ref object of OpenApiRestCall_578355
proc url_GamesManagementEventsReset_579057(protocol: Scheme; host: string;
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

proc validate_GamesManagementEventsReset_579056(path: JsonNode; query: JsonNode;
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
  var valid_579058 = path.getOrDefault("eventId")
  valid_579058 = validateParameter(valid_579058, JString, required = true,
                                 default = nil)
  if valid_579058 != nil:
    section.add "eventId", valid_579058
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
  var valid_579059 = query.getOrDefault("key")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "key", valid_579059
  var valid_579060 = query.getOrDefault("prettyPrint")
  valid_579060 = validateParameter(valid_579060, JBool, required = false,
                                 default = newJBool(true))
  if valid_579060 != nil:
    section.add "prettyPrint", valid_579060
  var valid_579061 = query.getOrDefault("oauth_token")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "oauth_token", valid_579061
  var valid_579062 = query.getOrDefault("alt")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = newJString("json"))
  if valid_579062 != nil:
    section.add "alt", valid_579062
  var valid_579063 = query.getOrDefault("userIp")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "userIp", valid_579063
  var valid_579064 = query.getOrDefault("quotaUser")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "quotaUser", valid_579064
  var valid_579065 = query.getOrDefault("fields")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "fields", valid_579065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579066: Call_GamesManagementEventsReset_579055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on the event with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player that use the event will also be reset.
  ## 
  let valid = call_579066.validator(path, query, header, formData, body)
  let scheme = call_579066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579066.url(scheme.get, call_579066.host, call_579066.base,
                         call_579066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579066, url, valid)

proc call*(call_579067: Call_GamesManagementEventsReset_579055; eventId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementEventsReset
  ## Resets all player progress on the event with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application. All quests for this player that use the event will also be reset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   eventId: string (required)
  ##          : The ID of the event.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579068 = newJObject()
  var query_579069 = newJObject()
  add(query_579069, "key", newJString(key))
  add(query_579069, "prettyPrint", newJBool(prettyPrint))
  add(query_579069, "oauth_token", newJString(oauthToken))
  add(path_579068, "eventId", newJString(eventId))
  add(query_579069, "alt", newJString(alt))
  add(query_579069, "userIp", newJString(userIp))
  add(query_579069, "quotaUser", newJString(quotaUser))
  add(query_579069, "fields", newJString(fields))
  result = call_579067.call(path_579068, query_579069, nil, nil, nil)

var gamesManagementEventsReset* = Call_GamesManagementEventsReset_579055(
    name: "gamesManagementEventsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/{eventId}/reset",
    validator: validate_GamesManagementEventsReset_579056,
    base: "/games/v1management", url: url_GamesManagementEventsReset_579057,
    schemes: {Scheme.Https})
type
  Call_GamesManagementEventsResetForAllPlayers_579070 = ref object of OpenApiRestCall_578355
proc url_GamesManagementEventsResetForAllPlayers_579072(protocol: Scheme;
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

proc validate_GamesManagementEventsResetForAllPlayers_579071(path: JsonNode;
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
  var valid_579073 = path.getOrDefault("eventId")
  valid_579073 = validateParameter(valid_579073, JString, required = true,
                                 default = nil)
  if valid_579073 != nil:
    section.add "eventId", valid_579073
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
  var valid_579074 = query.getOrDefault("key")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "key", valid_579074
  var valid_579075 = query.getOrDefault("prettyPrint")
  valid_579075 = validateParameter(valid_579075, JBool, required = false,
                                 default = newJBool(true))
  if valid_579075 != nil:
    section.add "prettyPrint", valid_579075
  var valid_579076 = query.getOrDefault("oauth_token")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "oauth_token", valid_579076
  var valid_579077 = query.getOrDefault("alt")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = newJString("json"))
  if valid_579077 != nil:
    section.add "alt", valid_579077
  var valid_579078 = query.getOrDefault("userIp")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "userIp", valid_579078
  var valid_579079 = query.getOrDefault("quotaUser")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "quotaUser", valid_579079
  var valid_579080 = query.getOrDefault("fields")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "fields", valid_579080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579081: Call_GamesManagementEventsResetForAllPlayers_579070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets the event with the given ID for all players. This method is only available to user accounts for your developer console. Only draft events can be reset. All quests that use the event will also be reset.
  ## 
  let valid = call_579081.validator(path, query, header, formData, body)
  let scheme = call_579081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579081.url(scheme.get, call_579081.host, call_579081.base,
                         call_579081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579081, url, valid)

proc call*(call_579082: Call_GamesManagementEventsResetForAllPlayers_579070;
          eventId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesManagementEventsResetForAllPlayers
  ## Resets the event with the given ID for all players. This method is only available to user accounts for your developer console. Only draft events can be reset. All quests that use the event will also be reset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   eventId: string (required)
  ##          : The ID of the event.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579083 = newJObject()
  var query_579084 = newJObject()
  add(query_579084, "key", newJString(key))
  add(query_579084, "prettyPrint", newJBool(prettyPrint))
  add(query_579084, "oauth_token", newJString(oauthToken))
  add(path_579083, "eventId", newJString(eventId))
  add(query_579084, "alt", newJString(alt))
  add(query_579084, "userIp", newJString(userIp))
  add(query_579084, "quotaUser", newJString(quotaUser))
  add(query_579084, "fields", newJString(fields))
  result = call_579082.call(path_579083, query_579084, nil, nil, nil)

var gamesManagementEventsResetForAllPlayers* = Call_GamesManagementEventsResetForAllPlayers_579070(
    name: "gamesManagementEventsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/events/{eventId}/resetForAllPlayers",
    validator: validate_GamesManagementEventsResetForAllPlayers_579071,
    base: "/games/v1management", url: url_GamesManagementEventsResetForAllPlayers_579072,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresReset_579085 = ref object of OpenApiRestCall_578355
proc url_GamesManagementScoresReset_579087(protocol: Scheme; host: string;
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

proc validate_GamesManagementScoresReset_579086(path: JsonNode; query: JsonNode;
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
  var valid_579088 = path.getOrDefault("leaderboardId")
  valid_579088 = validateParameter(valid_579088, JString, required = true,
                                 default = nil)
  if valid_579088 != nil:
    section.add "leaderboardId", valid_579088
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
  var valid_579089 = query.getOrDefault("key")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "key", valid_579089
  var valid_579090 = query.getOrDefault("prettyPrint")
  valid_579090 = validateParameter(valid_579090, JBool, required = false,
                                 default = newJBool(true))
  if valid_579090 != nil:
    section.add "prettyPrint", valid_579090
  var valid_579091 = query.getOrDefault("oauth_token")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "oauth_token", valid_579091
  var valid_579092 = query.getOrDefault("alt")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = newJString("json"))
  if valid_579092 != nil:
    section.add "alt", valid_579092
  var valid_579093 = query.getOrDefault("userIp")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "userIp", valid_579093
  var valid_579094 = query.getOrDefault("quotaUser")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "quotaUser", valid_579094
  var valid_579095 = query.getOrDefault("fields")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "fields", valid_579095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579096: Call_GamesManagementScoresReset_579085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets scores for the leaderboard with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_579096.validator(path, query, header, formData, body)
  let scheme = call_579096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579096.url(scheme.get, call_579096.host, call_579096.base,
                         call_579096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579096, url, valid)

proc call*(call_579097: Call_GamesManagementScoresReset_579085;
          leaderboardId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesManagementScoresReset
  ## Resets scores for the leaderboard with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
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
  var path_579098 = newJObject()
  var query_579099 = newJObject()
  add(query_579099, "key", newJString(key))
  add(query_579099, "prettyPrint", newJBool(prettyPrint))
  add(query_579099, "oauth_token", newJString(oauthToken))
  add(query_579099, "alt", newJString(alt))
  add(query_579099, "userIp", newJString(userIp))
  add(query_579099, "quotaUser", newJString(quotaUser))
  add(query_579099, "fields", newJString(fields))
  add(path_579098, "leaderboardId", newJString(leaderboardId))
  result = call_579097.call(path_579098, query_579099, nil, nil, nil)

var gamesManagementScoresReset* = Call_GamesManagementScoresReset_579085(
    name: "gamesManagementScoresReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/reset",
    validator: validate_GamesManagementScoresReset_579086,
    base: "/games/v1management", url: url_GamesManagementScoresReset_579087,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetForAllPlayers_579100 = ref object of OpenApiRestCall_578355
proc url_GamesManagementScoresResetForAllPlayers_579102(protocol: Scheme;
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

proc validate_GamesManagementScoresResetForAllPlayers_579101(path: JsonNode;
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
  var valid_579103 = path.getOrDefault("leaderboardId")
  valid_579103 = validateParameter(valid_579103, JString, required = true,
                                 default = nil)
  if valid_579103 != nil:
    section.add "leaderboardId", valid_579103
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
  var valid_579104 = query.getOrDefault("key")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "key", valid_579104
  var valid_579105 = query.getOrDefault("prettyPrint")
  valid_579105 = validateParameter(valid_579105, JBool, required = false,
                                 default = newJBool(true))
  if valid_579105 != nil:
    section.add "prettyPrint", valid_579105
  var valid_579106 = query.getOrDefault("oauth_token")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "oauth_token", valid_579106
  var valid_579107 = query.getOrDefault("alt")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = newJString("json"))
  if valid_579107 != nil:
    section.add "alt", valid_579107
  var valid_579108 = query.getOrDefault("userIp")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "userIp", valid_579108
  var valid_579109 = query.getOrDefault("quotaUser")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "quotaUser", valid_579109
  var valid_579110 = query.getOrDefault("fields")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "fields", valid_579110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579111: Call_GamesManagementScoresResetForAllPlayers_579100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for the leaderboard with the given ID for all players. This method is only available to user accounts for your developer console. Only draft leaderboards can be reset.
  ## 
  let valid = call_579111.validator(path, query, header, formData, body)
  let scheme = call_579111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579111.url(scheme.get, call_579111.host, call_579111.base,
                         call_579111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579111, url, valid)

proc call*(call_579112: Call_GamesManagementScoresResetForAllPlayers_579100;
          leaderboardId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesManagementScoresResetForAllPlayers
  ## Resets scores for the leaderboard with the given ID for all players. This method is only available to user accounts for your developer console. Only draft leaderboards can be reset.
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
  var path_579113 = newJObject()
  var query_579114 = newJObject()
  add(query_579114, "key", newJString(key))
  add(query_579114, "prettyPrint", newJBool(prettyPrint))
  add(query_579114, "oauth_token", newJString(oauthToken))
  add(query_579114, "alt", newJString(alt))
  add(query_579114, "userIp", newJString(userIp))
  add(query_579114, "quotaUser", newJString(quotaUser))
  add(query_579114, "fields", newJString(fields))
  add(path_579113, "leaderboardId", newJString(leaderboardId))
  result = call_579112.call(path_579113, query_579114, nil, nil, nil)

var gamesManagementScoresResetForAllPlayers* = Call_GamesManagementScoresResetForAllPlayers_579100(
    name: "gamesManagementScoresResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}/scores/resetForAllPlayers",
    validator: validate_GamesManagementScoresResetForAllPlayers_579101,
    base: "/games/v1management", url: url_GamesManagementScoresResetForAllPlayers_579102,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetAll_579115 = ref object of OpenApiRestCall_578355
proc url_GamesManagementQuestsResetAll_579117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetAll_579116(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all player progress on all quests for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
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
  var valid_579118 = query.getOrDefault("key")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "key", valid_579118
  var valid_579119 = query.getOrDefault("prettyPrint")
  valid_579119 = validateParameter(valid_579119, JBool, required = false,
                                 default = newJBool(true))
  if valid_579119 != nil:
    section.add "prettyPrint", valid_579119
  var valid_579120 = query.getOrDefault("oauth_token")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "oauth_token", valid_579120
  var valid_579121 = query.getOrDefault("alt")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = newJString("json"))
  if valid_579121 != nil:
    section.add "alt", valid_579121
  var valid_579122 = query.getOrDefault("userIp")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "userIp", valid_579122
  var valid_579123 = query.getOrDefault("quotaUser")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "quotaUser", valid_579123
  var valid_579124 = query.getOrDefault("fields")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "fields", valid_579124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579125: Call_GamesManagementQuestsResetAll_579115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on all quests for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_579125.validator(path, query, header, formData, body)
  let scheme = call_579125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579125.url(scheme.get, call_579125.host, call_579125.base,
                         call_579125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579125, url, valid)

proc call*(call_579126: Call_GamesManagementQuestsResetAll_579115;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementQuestsResetAll
  ## Resets all player progress on all quests for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
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
  var query_579127 = newJObject()
  add(query_579127, "key", newJString(key))
  add(query_579127, "prettyPrint", newJBool(prettyPrint))
  add(query_579127, "oauth_token", newJString(oauthToken))
  add(query_579127, "alt", newJString(alt))
  add(query_579127, "userIp", newJString(userIp))
  add(query_579127, "quotaUser", newJString(quotaUser))
  add(query_579127, "fields", newJString(fields))
  result = call_579126.call(nil, query_579127, nil, nil, nil)

var gamesManagementQuestsResetAll* = Call_GamesManagementQuestsResetAll_579115(
    name: "gamesManagementQuestsResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/reset",
    validator: validate_GamesManagementQuestsResetAll_579116,
    base: "/games/v1management", url: url_GamesManagementQuestsResetAll_579117,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetAllForAllPlayers_579128 = ref object of OpenApiRestCall_578355
proc url_GamesManagementQuestsResetAllForAllPlayers_579130(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetAllForAllPlayers_579129(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all draft quests for all players. This method is only available to user accounts for your developer console.
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
  var valid_579131 = query.getOrDefault("key")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "key", valid_579131
  var valid_579132 = query.getOrDefault("prettyPrint")
  valid_579132 = validateParameter(valid_579132, JBool, required = false,
                                 default = newJBool(true))
  if valid_579132 != nil:
    section.add "prettyPrint", valid_579132
  var valid_579133 = query.getOrDefault("oauth_token")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "oauth_token", valid_579133
  var valid_579134 = query.getOrDefault("alt")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = newJString("json"))
  if valid_579134 != nil:
    section.add "alt", valid_579134
  var valid_579135 = query.getOrDefault("userIp")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "userIp", valid_579135
  var valid_579136 = query.getOrDefault("quotaUser")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "quotaUser", valid_579136
  var valid_579137 = query.getOrDefault("fields")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "fields", valid_579137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579138: Call_GamesManagementQuestsResetAllForAllPlayers_579128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all draft quests for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_579138.validator(path, query, header, formData, body)
  let scheme = call_579138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579138.url(scheme.get, call_579138.host, call_579138.base,
                         call_579138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579138, url, valid)

proc call*(call_579139: Call_GamesManagementQuestsResetAllForAllPlayers_579128;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementQuestsResetAllForAllPlayers
  ## Resets all draft quests for all players. This method is only available to user accounts for your developer console.
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
  var query_579140 = newJObject()
  add(query_579140, "key", newJString(key))
  add(query_579140, "prettyPrint", newJBool(prettyPrint))
  add(query_579140, "oauth_token", newJString(oauthToken))
  add(query_579140, "alt", newJString(alt))
  add(query_579140, "userIp", newJString(userIp))
  add(query_579140, "quotaUser", newJString(quotaUser))
  add(query_579140, "fields", newJString(fields))
  result = call_579139.call(nil, query_579140, nil, nil, nil)

var gamesManagementQuestsResetAllForAllPlayers* = Call_GamesManagementQuestsResetAllForAllPlayers_579128(
    name: "gamesManagementQuestsResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/resetAllForAllPlayers",
    validator: validate_GamesManagementQuestsResetAllForAllPlayers_579129,
    base: "/games/v1management",
    url: url_GamesManagementQuestsResetAllForAllPlayers_579130,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetMultipleForAllPlayers_579141 = ref object of OpenApiRestCall_578355
proc url_GamesManagementQuestsResetMultipleForAllPlayers_579143(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementQuestsResetMultipleForAllPlayers_579142(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets quests with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft quests may be reset.
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
  var valid_579144 = query.getOrDefault("key")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "key", valid_579144
  var valid_579145 = query.getOrDefault("prettyPrint")
  valid_579145 = validateParameter(valid_579145, JBool, required = false,
                                 default = newJBool(true))
  if valid_579145 != nil:
    section.add "prettyPrint", valid_579145
  var valid_579146 = query.getOrDefault("oauth_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "oauth_token", valid_579146
  var valid_579147 = query.getOrDefault("alt")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = newJString("json"))
  if valid_579147 != nil:
    section.add "alt", valid_579147
  var valid_579148 = query.getOrDefault("userIp")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "userIp", valid_579148
  var valid_579149 = query.getOrDefault("quotaUser")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "quotaUser", valid_579149
  var valid_579150 = query.getOrDefault("fields")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "fields", valid_579150
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

proc call*(call_579152: Call_GamesManagementQuestsResetMultipleForAllPlayers_579141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets quests with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft quests may be reset.
  ## 
  let valid = call_579152.validator(path, query, header, formData, body)
  let scheme = call_579152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579152.url(scheme.get, call_579152.host, call_579152.base,
                         call_579152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579152, url, valid)

proc call*(call_579153: Call_GamesManagementQuestsResetMultipleForAllPlayers_579141;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## gamesManagementQuestsResetMultipleForAllPlayers
  ## Resets quests with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft quests may be reset.
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
  var query_579154 = newJObject()
  var body_579155 = newJObject()
  add(query_579154, "key", newJString(key))
  add(query_579154, "prettyPrint", newJBool(prettyPrint))
  add(query_579154, "oauth_token", newJString(oauthToken))
  add(query_579154, "alt", newJString(alt))
  add(query_579154, "userIp", newJString(userIp))
  add(query_579154, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579155 = body
  add(query_579154, "fields", newJString(fields))
  result = call_579153.call(nil, query_579154, nil, nil, body_579155)

var gamesManagementQuestsResetMultipleForAllPlayers* = Call_GamesManagementQuestsResetMultipleForAllPlayers_579141(
    name: "gamesManagementQuestsResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/quests/resetMultipleForAllPlayers",
    validator: validate_GamesManagementQuestsResetMultipleForAllPlayers_579142,
    base: "/games/v1management",
    url: url_GamesManagementQuestsResetMultipleForAllPlayers_579143,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsReset_579156 = ref object of OpenApiRestCall_578355
proc url_GamesManagementQuestsReset_579158(protocol: Scheme; host: string;
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

proc validate_GamesManagementQuestsReset_579157(path: JsonNode; query: JsonNode;
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
  var valid_579159 = path.getOrDefault("questId")
  valid_579159 = validateParameter(valid_579159, JString, required = true,
                                 default = nil)
  if valid_579159 != nil:
    section.add "questId", valid_579159
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
  var valid_579160 = query.getOrDefault("key")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "key", valid_579160
  var valid_579161 = query.getOrDefault("prettyPrint")
  valid_579161 = validateParameter(valid_579161, JBool, required = false,
                                 default = newJBool(true))
  if valid_579161 != nil:
    section.add "prettyPrint", valid_579161
  var valid_579162 = query.getOrDefault("oauth_token")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "oauth_token", valid_579162
  var valid_579163 = query.getOrDefault("alt")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = newJString("json"))
  if valid_579163 != nil:
    section.add "alt", valid_579163
  var valid_579164 = query.getOrDefault("userIp")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "userIp", valid_579164
  var valid_579165 = query.getOrDefault("quotaUser")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "quotaUser", valid_579165
  var valid_579166 = query.getOrDefault("fields")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "fields", valid_579166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579167: Call_GamesManagementQuestsReset_579156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all player progress on the quest with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_579167.validator(path, query, header, formData, body)
  let scheme = call_579167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579167.url(scheme.get, call_579167.host, call_579167.base,
                         call_579167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579167, url, valid)

proc call*(call_579168: Call_GamesManagementQuestsReset_579156; questId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementQuestsReset
  ## Resets all player progress on the quest with the given ID for the currently authenticated player. This method is only accessible to whitelisted tester accounts for your application.
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
  var path_579169 = newJObject()
  var query_579170 = newJObject()
  add(query_579170, "key", newJString(key))
  add(query_579170, "prettyPrint", newJBool(prettyPrint))
  add(query_579170, "oauth_token", newJString(oauthToken))
  add(path_579169, "questId", newJString(questId))
  add(query_579170, "alt", newJString(alt))
  add(query_579170, "userIp", newJString(userIp))
  add(query_579170, "quotaUser", newJString(quotaUser))
  add(query_579170, "fields", newJString(fields))
  result = call_579168.call(path_579169, query_579170, nil, nil, nil)

var gamesManagementQuestsReset* = Call_GamesManagementQuestsReset_579156(
    name: "gamesManagementQuestsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/{questId}/reset",
    validator: validate_GamesManagementQuestsReset_579157,
    base: "/games/v1management", url: url_GamesManagementQuestsReset_579158,
    schemes: {Scheme.Https})
type
  Call_GamesManagementQuestsResetForAllPlayers_579171 = ref object of OpenApiRestCall_578355
proc url_GamesManagementQuestsResetForAllPlayers_579173(protocol: Scheme;
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

proc validate_GamesManagementQuestsResetForAllPlayers_579172(path: JsonNode;
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
  var valid_579174 = path.getOrDefault("questId")
  valid_579174 = validateParameter(valid_579174, JString, required = true,
                                 default = nil)
  if valid_579174 != nil:
    section.add "questId", valid_579174
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
  var valid_579175 = query.getOrDefault("key")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "key", valid_579175
  var valid_579176 = query.getOrDefault("prettyPrint")
  valid_579176 = validateParameter(valid_579176, JBool, required = false,
                                 default = newJBool(true))
  if valid_579176 != nil:
    section.add "prettyPrint", valid_579176
  var valid_579177 = query.getOrDefault("oauth_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "oauth_token", valid_579177
  var valid_579178 = query.getOrDefault("alt")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = newJString("json"))
  if valid_579178 != nil:
    section.add "alt", valid_579178
  var valid_579179 = query.getOrDefault("userIp")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "userIp", valid_579179
  var valid_579180 = query.getOrDefault("quotaUser")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "quotaUser", valid_579180
  var valid_579181 = query.getOrDefault("fields")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "fields", valid_579181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579182: Call_GamesManagementQuestsResetForAllPlayers_579171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets all player progress on the quest with the given ID for all players. This method is only available to user accounts for your developer console. Only draft quests can be reset.
  ## 
  let valid = call_579182.validator(path, query, header, formData, body)
  let scheme = call_579182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579182.url(scheme.get, call_579182.host, call_579182.base,
                         call_579182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579182, url, valid)

proc call*(call_579183: Call_GamesManagementQuestsResetForAllPlayers_579171;
          questId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesManagementQuestsResetForAllPlayers
  ## Resets all player progress on the quest with the given ID for all players. This method is only available to user accounts for your developer console. Only draft quests can be reset.
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
  var path_579184 = newJObject()
  var query_579185 = newJObject()
  add(query_579185, "key", newJString(key))
  add(query_579185, "prettyPrint", newJBool(prettyPrint))
  add(query_579185, "oauth_token", newJString(oauthToken))
  add(path_579184, "questId", newJString(questId))
  add(query_579185, "alt", newJString(alt))
  add(query_579185, "userIp", newJString(userIp))
  add(query_579185, "quotaUser", newJString(quotaUser))
  add(query_579185, "fields", newJString(fields))
  result = call_579183.call(path_579184, query_579185, nil, nil, nil)

var gamesManagementQuestsResetForAllPlayers* = Call_GamesManagementQuestsResetForAllPlayers_579171(
    name: "gamesManagementQuestsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/quests/{questId}/resetForAllPlayers",
    validator: validate_GamesManagementQuestsResetForAllPlayers_579172,
    base: "/games/v1management", url: url_GamesManagementQuestsResetForAllPlayers_579173,
    schemes: {Scheme.Https})
type
  Call_GamesManagementRoomsReset_579186 = ref object of OpenApiRestCall_578355
proc url_GamesManagementRoomsReset_579188(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementRoomsReset_579187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reset all rooms for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
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
  var valid_579189 = query.getOrDefault("key")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "key", valid_579189
  var valid_579190 = query.getOrDefault("prettyPrint")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(true))
  if valid_579190 != nil:
    section.add "prettyPrint", valid_579190
  var valid_579191 = query.getOrDefault("oauth_token")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "oauth_token", valid_579191
  var valid_579192 = query.getOrDefault("alt")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("json"))
  if valid_579192 != nil:
    section.add "alt", valid_579192
  var valid_579193 = query.getOrDefault("userIp")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "userIp", valid_579193
  var valid_579194 = query.getOrDefault("quotaUser")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "quotaUser", valid_579194
  var valid_579195 = query.getOrDefault("fields")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "fields", valid_579195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579196: Call_GamesManagementRoomsReset_579186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reset all rooms for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_579196.validator(path, query, header, formData, body)
  let scheme = call_579196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579196.url(scheme.get, call_579196.host, call_579196.base,
                         call_579196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579196, url, valid)

proc call*(call_579197: Call_GamesManagementRoomsReset_579186; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesManagementRoomsReset
  ## Reset all rooms for the currently authenticated player for your application. This method is only accessible to whitelisted tester accounts for your application.
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
  var query_579198 = newJObject()
  add(query_579198, "key", newJString(key))
  add(query_579198, "prettyPrint", newJBool(prettyPrint))
  add(query_579198, "oauth_token", newJString(oauthToken))
  add(query_579198, "alt", newJString(alt))
  add(query_579198, "userIp", newJString(userIp))
  add(query_579198, "quotaUser", newJString(quotaUser))
  add(query_579198, "fields", newJString(fields))
  result = call_579197.call(nil, query_579198, nil, nil, nil)

var gamesManagementRoomsReset* = Call_GamesManagementRoomsReset_579186(
    name: "gamesManagementRoomsReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/reset",
    validator: validate_GamesManagementRoomsReset_579187,
    base: "/games/v1management", url: url_GamesManagementRoomsReset_579188,
    schemes: {Scheme.Https})
type
  Call_GamesManagementRoomsResetForAllPlayers_579199 = ref object of OpenApiRestCall_578355
proc url_GamesManagementRoomsResetForAllPlayers_579201(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementRoomsResetForAllPlayers_579200(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes rooms where the only room participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
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
  var valid_579202 = query.getOrDefault("key")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "key", valid_579202
  var valid_579203 = query.getOrDefault("prettyPrint")
  valid_579203 = validateParameter(valid_579203, JBool, required = false,
                                 default = newJBool(true))
  if valid_579203 != nil:
    section.add "prettyPrint", valid_579203
  var valid_579204 = query.getOrDefault("oauth_token")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "oauth_token", valid_579204
  var valid_579205 = query.getOrDefault("alt")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = newJString("json"))
  if valid_579205 != nil:
    section.add "alt", valid_579205
  var valid_579206 = query.getOrDefault("userIp")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "userIp", valid_579206
  var valid_579207 = query.getOrDefault("quotaUser")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "quotaUser", valid_579207
  var valid_579208 = query.getOrDefault("fields")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "fields", valid_579208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579209: Call_GamesManagementRoomsResetForAllPlayers_579199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes rooms where the only room participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_579209.validator(path, query, header, formData, body)
  let scheme = call_579209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579209.url(scheme.get, call_579209.host, call_579209.base,
                         call_579209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579209, url, valid)

proc call*(call_579210: Call_GamesManagementRoomsResetForAllPlayers_579199;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementRoomsResetForAllPlayers
  ## Deletes rooms where the only room participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
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
  var query_579211 = newJObject()
  add(query_579211, "key", newJString(key))
  add(query_579211, "prettyPrint", newJBool(prettyPrint))
  add(query_579211, "oauth_token", newJString(oauthToken))
  add(query_579211, "alt", newJString(alt))
  add(query_579211, "userIp", newJString(userIp))
  add(query_579211, "quotaUser", newJString(quotaUser))
  add(query_579211, "fields", newJString(fields))
  result = call_579210.call(nil, query_579211, nil, nil, nil)

var gamesManagementRoomsResetForAllPlayers* = Call_GamesManagementRoomsResetForAllPlayers_579199(
    name: "gamesManagementRoomsResetForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/rooms/resetForAllPlayers",
    validator: validate_GamesManagementRoomsResetForAllPlayers_579200,
    base: "/games/v1management", url: url_GamesManagementRoomsResetForAllPlayers_579201,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetAll_579212 = ref object of OpenApiRestCall_578355
proc url_GamesManagementScoresResetAll_579214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetAll_579213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets all scores for all leaderboards for the currently authenticated players. This method is only accessible to whitelisted tester accounts for your application.
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
  var valid_579215 = query.getOrDefault("key")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "key", valid_579215
  var valid_579216 = query.getOrDefault("prettyPrint")
  valid_579216 = validateParameter(valid_579216, JBool, required = false,
                                 default = newJBool(true))
  if valid_579216 != nil:
    section.add "prettyPrint", valid_579216
  var valid_579217 = query.getOrDefault("oauth_token")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "oauth_token", valid_579217
  var valid_579218 = query.getOrDefault("alt")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = newJString("json"))
  if valid_579218 != nil:
    section.add "alt", valid_579218
  var valid_579219 = query.getOrDefault("userIp")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "userIp", valid_579219
  var valid_579220 = query.getOrDefault("quotaUser")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "quotaUser", valid_579220
  var valid_579221 = query.getOrDefault("fields")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "fields", valid_579221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579222: Call_GamesManagementScoresResetAll_579212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets all scores for all leaderboards for the currently authenticated players. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_579222.validator(path, query, header, formData, body)
  let scheme = call_579222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579222.url(scheme.get, call_579222.host, call_579222.base,
                         call_579222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579222, url, valid)

proc call*(call_579223: Call_GamesManagementScoresResetAll_579212;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementScoresResetAll
  ## Resets all scores for all leaderboards for the currently authenticated players. This method is only accessible to whitelisted tester accounts for your application.
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
  var query_579224 = newJObject()
  add(query_579224, "key", newJString(key))
  add(query_579224, "prettyPrint", newJBool(prettyPrint))
  add(query_579224, "oauth_token", newJString(oauthToken))
  add(query_579224, "alt", newJString(alt))
  add(query_579224, "userIp", newJString(userIp))
  add(query_579224, "quotaUser", newJString(quotaUser))
  add(query_579224, "fields", newJString(fields))
  result = call_579223.call(nil, query_579224, nil, nil, nil)

var gamesManagementScoresResetAll* = Call_GamesManagementScoresResetAll_579212(
    name: "gamesManagementScoresResetAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/scores/reset",
    validator: validate_GamesManagementScoresResetAll_579213,
    base: "/games/v1management", url: url_GamesManagementScoresResetAll_579214,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetAllForAllPlayers_579225 = ref object of OpenApiRestCall_578355
proc url_GamesManagementScoresResetAllForAllPlayers_579227(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetAllForAllPlayers_579226(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets scores for all draft leaderboards for all players. This method is only available to user accounts for your developer console.
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
  var valid_579228 = query.getOrDefault("key")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "key", valid_579228
  var valid_579229 = query.getOrDefault("prettyPrint")
  valid_579229 = validateParameter(valid_579229, JBool, required = false,
                                 default = newJBool(true))
  if valid_579229 != nil:
    section.add "prettyPrint", valid_579229
  var valid_579230 = query.getOrDefault("oauth_token")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "oauth_token", valid_579230
  var valid_579231 = query.getOrDefault("alt")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = newJString("json"))
  if valid_579231 != nil:
    section.add "alt", valid_579231
  var valid_579232 = query.getOrDefault("userIp")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "userIp", valid_579232
  var valid_579233 = query.getOrDefault("quotaUser")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "quotaUser", valid_579233
  var valid_579234 = query.getOrDefault("fields")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "fields", valid_579234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579235: Call_GamesManagementScoresResetAllForAllPlayers_579225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for all draft leaderboards for all players. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_579235.validator(path, query, header, formData, body)
  let scheme = call_579235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579235.url(scheme.get, call_579235.host, call_579235.base,
                         call_579235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579235, url, valid)

proc call*(call_579236: Call_GamesManagementScoresResetAllForAllPlayers_579225;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementScoresResetAllForAllPlayers
  ## Resets scores for all draft leaderboards for all players. This method is only available to user accounts for your developer console.
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
  var query_579237 = newJObject()
  add(query_579237, "key", newJString(key))
  add(query_579237, "prettyPrint", newJBool(prettyPrint))
  add(query_579237, "oauth_token", newJString(oauthToken))
  add(query_579237, "alt", newJString(alt))
  add(query_579237, "userIp", newJString(userIp))
  add(query_579237, "quotaUser", newJString(quotaUser))
  add(query_579237, "fields", newJString(fields))
  result = call_579236.call(nil, query_579237, nil, nil, nil)

var gamesManagementScoresResetAllForAllPlayers* = Call_GamesManagementScoresResetAllForAllPlayers_579225(
    name: "gamesManagementScoresResetAllForAllPlayers", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/scores/resetAllForAllPlayers",
    validator: validate_GamesManagementScoresResetAllForAllPlayers_579226,
    base: "/games/v1management",
    url: url_GamesManagementScoresResetAllForAllPlayers_579227,
    schemes: {Scheme.Https})
type
  Call_GamesManagementScoresResetMultipleForAllPlayers_579238 = ref object of OpenApiRestCall_578355
proc url_GamesManagementScoresResetMultipleForAllPlayers_579240(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementScoresResetMultipleForAllPlayers_579239(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Resets scores for the leaderboards with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft leaderboards may be reset.
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
  var valid_579241 = query.getOrDefault("key")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "key", valid_579241
  var valid_579242 = query.getOrDefault("prettyPrint")
  valid_579242 = validateParameter(valid_579242, JBool, required = false,
                                 default = newJBool(true))
  if valid_579242 != nil:
    section.add "prettyPrint", valid_579242
  var valid_579243 = query.getOrDefault("oauth_token")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "oauth_token", valid_579243
  var valid_579244 = query.getOrDefault("alt")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = newJString("json"))
  if valid_579244 != nil:
    section.add "alt", valid_579244
  var valid_579245 = query.getOrDefault("userIp")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "userIp", valid_579245
  var valid_579246 = query.getOrDefault("quotaUser")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "quotaUser", valid_579246
  var valid_579247 = query.getOrDefault("fields")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "fields", valid_579247
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

proc call*(call_579249: Call_GamesManagementScoresResetMultipleForAllPlayers_579238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets scores for the leaderboards with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft leaderboards may be reset.
  ## 
  let valid = call_579249.validator(path, query, header, formData, body)
  let scheme = call_579249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579249.url(scheme.get, call_579249.host, call_579249.base,
                         call_579249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579249, url, valid)

proc call*(call_579250: Call_GamesManagementScoresResetMultipleForAllPlayers_579238;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## gamesManagementScoresResetMultipleForAllPlayers
  ## Resets scores for the leaderboards with the given IDs for all players. This method is only available to user accounts for your developer console. Only draft leaderboards may be reset.
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
  var query_579251 = newJObject()
  var body_579252 = newJObject()
  add(query_579251, "key", newJString(key))
  add(query_579251, "prettyPrint", newJBool(prettyPrint))
  add(query_579251, "oauth_token", newJString(oauthToken))
  add(query_579251, "alt", newJString(alt))
  add(query_579251, "userIp", newJString(userIp))
  add(query_579251, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579252 = body
  add(query_579251, "fields", newJString(fields))
  result = call_579250.call(nil, query_579251, nil, nil, body_579252)

var gamesManagementScoresResetMultipleForAllPlayers* = Call_GamesManagementScoresResetMultipleForAllPlayers_579238(
    name: "gamesManagementScoresResetMultipleForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/scores/resetMultipleForAllPlayers",
    validator: validate_GamesManagementScoresResetMultipleForAllPlayers_579239,
    base: "/games/v1management",
    url: url_GamesManagementScoresResetMultipleForAllPlayers_579240,
    schemes: {Scheme.Https})
type
  Call_GamesManagementTurnBasedMatchesReset_579253 = ref object of OpenApiRestCall_578355
proc url_GamesManagementTurnBasedMatchesReset_579255(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementTurnBasedMatchesReset_579254(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reset all turn-based match data for a user. This method is only accessible to whitelisted tester accounts for your application.
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
  var valid_579256 = query.getOrDefault("key")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "key", valid_579256
  var valid_579257 = query.getOrDefault("prettyPrint")
  valid_579257 = validateParameter(valid_579257, JBool, required = false,
                                 default = newJBool(true))
  if valid_579257 != nil:
    section.add "prettyPrint", valid_579257
  var valid_579258 = query.getOrDefault("oauth_token")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "oauth_token", valid_579258
  var valid_579259 = query.getOrDefault("alt")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = newJString("json"))
  if valid_579259 != nil:
    section.add "alt", valid_579259
  var valid_579260 = query.getOrDefault("userIp")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "userIp", valid_579260
  var valid_579261 = query.getOrDefault("quotaUser")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "quotaUser", valid_579261
  var valid_579262 = query.getOrDefault("fields")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "fields", valid_579262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579263: Call_GamesManagementTurnBasedMatchesReset_579253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reset all turn-based match data for a user. This method is only accessible to whitelisted tester accounts for your application.
  ## 
  let valid = call_579263.validator(path, query, header, formData, body)
  let scheme = call_579263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579263.url(scheme.get, call_579263.host, call_579263.base,
                         call_579263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579263, url, valid)

proc call*(call_579264: Call_GamesManagementTurnBasedMatchesReset_579253;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementTurnBasedMatchesReset
  ## Reset all turn-based match data for a user. This method is only accessible to whitelisted tester accounts for your application.
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
  var query_579265 = newJObject()
  add(query_579265, "key", newJString(key))
  add(query_579265, "prettyPrint", newJBool(prettyPrint))
  add(query_579265, "oauth_token", newJString(oauthToken))
  add(query_579265, "alt", newJString(alt))
  add(query_579265, "userIp", newJString(userIp))
  add(query_579265, "quotaUser", newJString(quotaUser))
  add(query_579265, "fields", newJString(fields))
  result = call_579264.call(nil, query_579265, nil, nil, nil)

var gamesManagementTurnBasedMatchesReset* = Call_GamesManagementTurnBasedMatchesReset_579253(
    name: "gamesManagementTurnBasedMatchesReset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/turnbasedmatches/reset",
    validator: validate_GamesManagementTurnBasedMatchesReset_579254,
    base: "/games/v1management", url: url_GamesManagementTurnBasedMatchesReset_579255,
    schemes: {Scheme.Https})
type
  Call_GamesManagementTurnBasedMatchesResetForAllPlayers_579266 = ref object of OpenApiRestCall_578355
proc url_GamesManagementTurnBasedMatchesResetForAllPlayers_579268(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GamesManagementTurnBasedMatchesResetForAllPlayers_579267(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes turn-based matches where the only match participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
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
  var valid_579269 = query.getOrDefault("key")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "key", valid_579269
  var valid_579270 = query.getOrDefault("prettyPrint")
  valid_579270 = validateParameter(valid_579270, JBool, required = false,
                                 default = newJBool(true))
  if valid_579270 != nil:
    section.add "prettyPrint", valid_579270
  var valid_579271 = query.getOrDefault("oauth_token")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "oauth_token", valid_579271
  var valid_579272 = query.getOrDefault("alt")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = newJString("json"))
  if valid_579272 != nil:
    section.add "alt", valid_579272
  var valid_579273 = query.getOrDefault("userIp")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "userIp", valid_579273
  var valid_579274 = query.getOrDefault("quotaUser")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "quotaUser", valid_579274
  var valid_579275 = query.getOrDefault("fields")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "fields", valid_579275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579276: Call_GamesManagementTurnBasedMatchesResetForAllPlayers_579266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes turn-based matches where the only match participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
  ## 
  let valid = call_579276.validator(path, query, header, formData, body)
  let scheme = call_579276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579276.url(scheme.get, call_579276.host, call_579276.base,
                         call_579276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579276, url, valid)

proc call*(call_579277: Call_GamesManagementTurnBasedMatchesResetForAllPlayers_579266;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## gamesManagementTurnBasedMatchesResetForAllPlayers
  ## Deletes turn-based matches where the only match participants are from whitelisted tester accounts for your application. This method is only available to user accounts for your developer console.
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
  var query_579278 = newJObject()
  add(query_579278, "key", newJString(key))
  add(query_579278, "prettyPrint", newJBool(prettyPrint))
  add(query_579278, "oauth_token", newJString(oauthToken))
  add(query_579278, "alt", newJString(alt))
  add(query_579278, "userIp", newJString(userIp))
  add(query_579278, "quotaUser", newJString(quotaUser))
  add(query_579278, "fields", newJString(fields))
  result = call_579277.call(nil, query_579278, nil, nil, nil)

var gamesManagementTurnBasedMatchesResetForAllPlayers* = Call_GamesManagementTurnBasedMatchesResetForAllPlayers_579266(
    name: "gamesManagementTurnBasedMatchesResetForAllPlayers",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/turnbasedmatches/resetForAllPlayers",
    validator: validate_GamesManagementTurnBasedMatchesResetForAllPlayers_579267,
    base: "/games/v1management",
    url: url_GamesManagementTurnBasedMatchesResetForAllPlayers_579268,
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
