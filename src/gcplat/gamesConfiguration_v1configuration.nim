
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play Game Services Publishing
## version: v1configuration
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Publishing API for Google Play Game Services.
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
  gcpServiceName = "gamesConfiguration"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GamesConfigurationAchievementConfigurationsUpdate_589009 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationAchievementConfigurationsUpdate_589011(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "achievementId" in path, "`achievementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/achievements/"),
               (kind: VariableSegment, value: "achievementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesConfigurationAchievementConfigurationsUpdate_589010(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update the metadata of the achievement configuration with the given ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   achievementId: JString (required)
  ##                : The ID of the achievement used by this method.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `achievementId` field"
  var valid_589012 = path.getOrDefault("achievementId")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "achievementId", valid_589012
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
  var valid_589013 = query.getOrDefault("fields")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "fields", valid_589013
  var valid_589014 = query.getOrDefault("quotaUser")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "quotaUser", valid_589014
  var valid_589015 = query.getOrDefault("alt")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("json"))
  if valid_589015 != nil:
    section.add "alt", valid_589015
  var valid_589016 = query.getOrDefault("oauth_token")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "oauth_token", valid_589016
  var valid_589017 = query.getOrDefault("userIp")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "userIp", valid_589017
  var valid_589018 = query.getOrDefault("key")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "key", valid_589018
  var valid_589019 = query.getOrDefault("prettyPrint")
  valid_589019 = validateParameter(valid_589019, JBool, required = false,
                                 default = newJBool(true))
  if valid_589019 != nil:
    section.add "prettyPrint", valid_589019
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

proc call*(call_589021: Call_GamesConfigurationAchievementConfigurationsUpdate_589009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the metadata of the achievement configuration with the given ID.
  ## 
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_GamesConfigurationAchievementConfigurationsUpdate_589009;
          achievementId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesConfigurationAchievementConfigurationsUpdate
  ## Update the metadata of the achievement configuration with the given ID.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589023 = newJObject()
  var query_589024 = newJObject()
  var body_589025 = newJObject()
  add(query_589024, "fields", newJString(fields))
  add(query_589024, "quotaUser", newJString(quotaUser))
  add(query_589024, "alt", newJString(alt))
  add(query_589024, "oauth_token", newJString(oauthToken))
  add(query_589024, "userIp", newJString(userIp))
  add(query_589024, "key", newJString(key))
  add(path_589023, "achievementId", newJString(achievementId))
  if body != nil:
    body_589025 = body
  add(query_589024, "prettyPrint", newJBool(prettyPrint))
  result = call_589022.call(path_589023, query_589024, nil, nil, body_589025)

var gamesConfigurationAchievementConfigurationsUpdate* = Call_GamesConfigurationAchievementConfigurationsUpdate_589009(
    name: "gamesConfigurationAchievementConfigurationsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/achievements/{achievementId}",
    validator: validate_GamesConfigurationAchievementConfigurationsUpdate_589010,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsUpdate_589011,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationAchievementConfigurationsGet_588725 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationAchievementConfigurationsGet_588727(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "achievementId" in path, "`achievementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/achievements/"),
               (kind: VariableSegment, value: "achievementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesConfigurationAchievementConfigurationsGet_588726(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the metadata of the achievement configuration with the given ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   achievementId: JString (required)
  ##                : The ID of the achievement used by this method.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `achievementId` field"
  var valid_588853 = path.getOrDefault("achievementId")
  valid_588853 = validateParameter(valid_588853, JString, required = true,
                                 default = nil)
  if valid_588853 != nil:
    section.add "achievementId", valid_588853
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
  var valid_588854 = query.getOrDefault("fields")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "fields", valid_588854
  var valid_588855 = query.getOrDefault("quotaUser")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "quotaUser", valid_588855
  var valid_588869 = query.getOrDefault("alt")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = newJString("json"))
  if valid_588869 != nil:
    section.add "alt", valid_588869
  var valid_588870 = query.getOrDefault("oauth_token")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = nil)
  if valid_588870 != nil:
    section.add "oauth_token", valid_588870
  var valid_588871 = query.getOrDefault("userIp")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "userIp", valid_588871
  var valid_588872 = query.getOrDefault("key")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "key", valid_588872
  var valid_588873 = query.getOrDefault("prettyPrint")
  valid_588873 = validateParameter(valid_588873, JBool, required = false,
                                 default = newJBool(true))
  if valid_588873 != nil:
    section.add "prettyPrint", valid_588873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588896: Call_GamesConfigurationAchievementConfigurationsGet_588725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metadata of the achievement configuration with the given ID.
  ## 
  let valid = call_588896.validator(path, query, header, formData, body)
  let scheme = call_588896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588896.url(scheme.get, call_588896.host, call_588896.base,
                         call_588896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588896, url, valid)

proc call*(call_588967: Call_GamesConfigurationAchievementConfigurationsGet_588725;
          achievementId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesConfigurationAchievementConfigurationsGet
  ## Retrieves the metadata of the achievement configuration with the given ID.
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
  var path_588968 = newJObject()
  var query_588970 = newJObject()
  add(query_588970, "fields", newJString(fields))
  add(query_588970, "quotaUser", newJString(quotaUser))
  add(query_588970, "alt", newJString(alt))
  add(query_588970, "oauth_token", newJString(oauthToken))
  add(query_588970, "userIp", newJString(userIp))
  add(query_588970, "key", newJString(key))
  add(path_588968, "achievementId", newJString(achievementId))
  add(query_588970, "prettyPrint", newJBool(prettyPrint))
  result = call_588967.call(path_588968, query_588970, nil, nil, nil)

var gamesConfigurationAchievementConfigurationsGet* = Call_GamesConfigurationAchievementConfigurationsGet_588725(
    name: "gamesConfigurationAchievementConfigurationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/achievements/{achievementId}",
    validator: validate_GamesConfigurationAchievementConfigurationsGet_588726,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsGet_588727,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationAchievementConfigurationsPatch_589041 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationAchievementConfigurationsPatch_589043(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "achievementId" in path, "`achievementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/achievements/"),
               (kind: VariableSegment, value: "achievementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesConfigurationAchievementConfigurationsPatch_589042(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update the metadata of the achievement configuration with the given ID. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   achievementId: JString (required)
  ##                : The ID of the achievement used by this method.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `achievementId` field"
  var valid_589044 = path.getOrDefault("achievementId")
  valid_589044 = validateParameter(valid_589044, JString, required = true,
                                 default = nil)
  if valid_589044 != nil:
    section.add "achievementId", valid_589044
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
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("userIp")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "userIp", valid_589049
  var valid_589050 = query.getOrDefault("key")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "key", valid_589050
  var valid_589051 = query.getOrDefault("prettyPrint")
  valid_589051 = validateParameter(valid_589051, JBool, required = false,
                                 default = newJBool(true))
  if valid_589051 != nil:
    section.add "prettyPrint", valid_589051
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

proc call*(call_589053: Call_GamesConfigurationAchievementConfigurationsPatch_589041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the metadata of the achievement configuration with the given ID. This method supports patch semantics.
  ## 
  let valid = call_589053.validator(path, query, header, formData, body)
  let scheme = call_589053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589053.url(scheme.get, call_589053.host, call_589053.base,
                         call_589053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589053, url, valid)

proc call*(call_589054: Call_GamesConfigurationAchievementConfigurationsPatch_589041;
          achievementId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesConfigurationAchievementConfigurationsPatch
  ## Update the metadata of the achievement configuration with the given ID. This method supports patch semantics.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589055 = newJObject()
  var query_589056 = newJObject()
  var body_589057 = newJObject()
  add(query_589056, "fields", newJString(fields))
  add(query_589056, "quotaUser", newJString(quotaUser))
  add(query_589056, "alt", newJString(alt))
  add(query_589056, "oauth_token", newJString(oauthToken))
  add(query_589056, "userIp", newJString(userIp))
  add(query_589056, "key", newJString(key))
  add(path_589055, "achievementId", newJString(achievementId))
  if body != nil:
    body_589057 = body
  add(query_589056, "prettyPrint", newJBool(prettyPrint))
  result = call_589054.call(path_589055, query_589056, nil, nil, body_589057)

var gamesConfigurationAchievementConfigurationsPatch* = Call_GamesConfigurationAchievementConfigurationsPatch_589041(
    name: "gamesConfigurationAchievementConfigurationsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/achievements/{achievementId}",
    validator: validate_GamesConfigurationAchievementConfigurationsPatch_589042,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsPatch_589043,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationAchievementConfigurationsDelete_589026 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationAchievementConfigurationsDelete_589028(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "achievementId" in path, "`achievementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/achievements/"),
               (kind: VariableSegment, value: "achievementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesConfigurationAchievementConfigurationsDelete_589027(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete the achievement configuration with the given ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   achievementId: JString (required)
  ##                : The ID of the achievement used by this method.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `achievementId` field"
  var valid_589029 = path.getOrDefault("achievementId")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "achievementId", valid_589029
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
  var valid_589030 = query.getOrDefault("fields")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "fields", valid_589030
  var valid_589031 = query.getOrDefault("quotaUser")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "quotaUser", valid_589031
  var valid_589032 = query.getOrDefault("alt")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("json"))
  if valid_589032 != nil:
    section.add "alt", valid_589032
  var valid_589033 = query.getOrDefault("oauth_token")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "oauth_token", valid_589033
  var valid_589034 = query.getOrDefault("userIp")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "userIp", valid_589034
  var valid_589035 = query.getOrDefault("key")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "key", valid_589035
  var valid_589036 = query.getOrDefault("prettyPrint")
  valid_589036 = validateParameter(valid_589036, JBool, required = false,
                                 default = newJBool(true))
  if valid_589036 != nil:
    section.add "prettyPrint", valid_589036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589037: Call_GamesConfigurationAchievementConfigurationsDelete_589026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the achievement configuration with the given ID.
  ## 
  let valid = call_589037.validator(path, query, header, formData, body)
  let scheme = call_589037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589037.url(scheme.get, call_589037.host, call_589037.base,
                         call_589037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589037, url, valid)

proc call*(call_589038: Call_GamesConfigurationAchievementConfigurationsDelete_589026;
          achievementId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesConfigurationAchievementConfigurationsDelete
  ## Delete the achievement configuration with the given ID.
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
  var path_589039 = newJObject()
  var query_589040 = newJObject()
  add(query_589040, "fields", newJString(fields))
  add(query_589040, "quotaUser", newJString(quotaUser))
  add(query_589040, "alt", newJString(alt))
  add(query_589040, "oauth_token", newJString(oauthToken))
  add(query_589040, "userIp", newJString(userIp))
  add(query_589040, "key", newJString(key))
  add(path_589039, "achievementId", newJString(achievementId))
  add(query_589040, "prettyPrint", newJBool(prettyPrint))
  result = call_589038.call(path_589039, query_589040, nil, nil, nil)

var gamesConfigurationAchievementConfigurationsDelete* = Call_GamesConfigurationAchievementConfigurationsDelete_589026(
    name: "gamesConfigurationAchievementConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/achievements/{achievementId}",
    validator: validate_GamesConfigurationAchievementConfigurationsDelete_589027,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsDelete_589028,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationAchievementConfigurationsInsert_589075 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationAchievementConfigurationsInsert_589077(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/achievements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesConfigurationAchievementConfigurationsInsert_589076(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Insert a new achievement configuration in this application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The application ID from the Google Play developer console.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_589078 = path.getOrDefault("applicationId")
  valid_589078 = validateParameter(valid_589078, JString, required = true,
                                 default = nil)
  if valid_589078 != nil:
    section.add "applicationId", valid_589078
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
  var valid_589079 = query.getOrDefault("fields")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "fields", valid_589079
  var valid_589080 = query.getOrDefault("quotaUser")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "quotaUser", valid_589080
  var valid_589081 = query.getOrDefault("alt")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = newJString("json"))
  if valid_589081 != nil:
    section.add "alt", valid_589081
  var valid_589082 = query.getOrDefault("oauth_token")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "oauth_token", valid_589082
  var valid_589083 = query.getOrDefault("userIp")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "userIp", valid_589083
  var valid_589084 = query.getOrDefault("key")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "key", valid_589084
  var valid_589085 = query.getOrDefault("prettyPrint")
  valid_589085 = validateParameter(valid_589085, JBool, required = false,
                                 default = newJBool(true))
  if valid_589085 != nil:
    section.add "prettyPrint", valid_589085
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

proc call*(call_589087: Call_GamesConfigurationAchievementConfigurationsInsert_589075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert a new achievement configuration in this application.
  ## 
  let valid = call_589087.validator(path, query, header, formData, body)
  let scheme = call_589087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589087.url(scheme.get, call_589087.host, call_589087.base,
                         call_589087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589087, url, valid)

proc call*(call_589088: Call_GamesConfigurationAchievementConfigurationsInsert_589075;
          applicationId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesConfigurationAchievementConfigurationsInsert
  ## Insert a new achievement configuration in this application.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589089 = newJObject()
  var query_589090 = newJObject()
  var body_589091 = newJObject()
  add(query_589090, "fields", newJString(fields))
  add(query_589090, "quotaUser", newJString(quotaUser))
  add(query_589090, "alt", newJString(alt))
  add(query_589090, "oauth_token", newJString(oauthToken))
  add(query_589090, "userIp", newJString(userIp))
  add(path_589089, "applicationId", newJString(applicationId))
  add(query_589090, "key", newJString(key))
  if body != nil:
    body_589091 = body
  add(query_589090, "prettyPrint", newJBool(prettyPrint))
  result = call_589088.call(path_589089, query_589090, nil, nil, body_589091)

var gamesConfigurationAchievementConfigurationsInsert* = Call_GamesConfigurationAchievementConfigurationsInsert_589075(
    name: "gamesConfigurationAchievementConfigurationsInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/applications/{applicationId}/achievements",
    validator: validate_GamesConfigurationAchievementConfigurationsInsert_589076,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsInsert_589077,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationAchievementConfigurationsList_589058 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationAchievementConfigurationsList_589060(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/achievements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesConfigurationAchievementConfigurationsList_589059(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a list of the achievement configurations in this application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The application ID from the Google Play developer console.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_589061 = path.getOrDefault("applicationId")
  valid_589061 = validateParameter(valid_589061, JString, required = true,
                                 default = nil)
  if valid_589061 != nil:
    section.add "applicationId", valid_589061
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
  ##             : The maximum number of resource configurations to return in the response, used for paging. For any response, the actual number of resources returned may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589062 = query.getOrDefault("fields")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "fields", valid_589062
  var valid_589063 = query.getOrDefault("pageToken")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "pageToken", valid_589063
  var valid_589064 = query.getOrDefault("quotaUser")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "quotaUser", valid_589064
  var valid_589065 = query.getOrDefault("alt")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("json"))
  if valid_589065 != nil:
    section.add "alt", valid_589065
  var valid_589066 = query.getOrDefault("oauth_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "oauth_token", valid_589066
  var valid_589067 = query.getOrDefault("userIp")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "userIp", valid_589067
  var valid_589068 = query.getOrDefault("maxResults")
  valid_589068 = validateParameter(valid_589068, JInt, required = false, default = nil)
  if valid_589068 != nil:
    section.add "maxResults", valid_589068
  var valid_589069 = query.getOrDefault("key")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "key", valid_589069
  var valid_589070 = query.getOrDefault("prettyPrint")
  valid_589070 = validateParameter(valid_589070, JBool, required = false,
                                 default = newJBool(true))
  if valid_589070 != nil:
    section.add "prettyPrint", valid_589070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589071: Call_GamesConfigurationAchievementConfigurationsList_589058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of the achievement configurations in this application.
  ## 
  let valid = call_589071.validator(path, query, header, formData, body)
  let scheme = call_589071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589071.url(scheme.get, call_589071.host, call_589071.base,
                         call_589071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589071, url, valid)

proc call*(call_589072: Call_GamesConfigurationAchievementConfigurationsList_589058;
          applicationId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesConfigurationAchievementConfigurationsList
  ## Returns a list of the achievement configurations in this application.
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
  ##             : The maximum number of resource configurations to return in the response, used for paging. For any response, the actual number of resources returned may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589073 = newJObject()
  var query_589074 = newJObject()
  add(query_589074, "fields", newJString(fields))
  add(query_589074, "pageToken", newJString(pageToken))
  add(query_589074, "quotaUser", newJString(quotaUser))
  add(query_589074, "alt", newJString(alt))
  add(query_589074, "oauth_token", newJString(oauthToken))
  add(query_589074, "userIp", newJString(userIp))
  add(path_589073, "applicationId", newJString(applicationId))
  add(query_589074, "maxResults", newJInt(maxResults))
  add(query_589074, "key", newJString(key))
  add(query_589074, "prettyPrint", newJBool(prettyPrint))
  result = call_589072.call(path_589073, query_589074, nil, nil, nil)

var gamesConfigurationAchievementConfigurationsList* = Call_GamesConfigurationAchievementConfigurationsList_589058(
    name: "gamesConfigurationAchievementConfigurationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/applications/{applicationId}/achievements",
    validator: validate_GamesConfigurationAchievementConfigurationsList_589059,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsList_589060,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsInsert_589109 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationLeaderboardConfigurationsInsert_589111(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/leaderboards")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesConfigurationLeaderboardConfigurationsInsert_589110(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Insert a new leaderboard configuration in this application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The application ID from the Google Play developer console.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_589112 = path.getOrDefault("applicationId")
  valid_589112 = validateParameter(valid_589112, JString, required = true,
                                 default = nil)
  if valid_589112 != nil:
    section.add "applicationId", valid_589112
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
  var valid_589113 = query.getOrDefault("fields")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "fields", valid_589113
  var valid_589114 = query.getOrDefault("quotaUser")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "quotaUser", valid_589114
  var valid_589115 = query.getOrDefault("alt")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = newJString("json"))
  if valid_589115 != nil:
    section.add "alt", valid_589115
  var valid_589116 = query.getOrDefault("oauth_token")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "oauth_token", valid_589116
  var valid_589117 = query.getOrDefault("userIp")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "userIp", valid_589117
  var valid_589118 = query.getOrDefault("key")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "key", valid_589118
  var valid_589119 = query.getOrDefault("prettyPrint")
  valid_589119 = validateParameter(valid_589119, JBool, required = false,
                                 default = newJBool(true))
  if valid_589119 != nil:
    section.add "prettyPrint", valid_589119
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

proc call*(call_589121: Call_GamesConfigurationLeaderboardConfigurationsInsert_589109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert a new leaderboard configuration in this application.
  ## 
  let valid = call_589121.validator(path, query, header, formData, body)
  let scheme = call_589121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589121.url(scheme.get, call_589121.host, call_589121.base,
                         call_589121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589121, url, valid)

proc call*(call_589122: Call_GamesConfigurationLeaderboardConfigurationsInsert_589109;
          applicationId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsInsert
  ## Insert a new leaderboard configuration in this application.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589123 = newJObject()
  var query_589124 = newJObject()
  var body_589125 = newJObject()
  add(query_589124, "fields", newJString(fields))
  add(query_589124, "quotaUser", newJString(quotaUser))
  add(query_589124, "alt", newJString(alt))
  add(query_589124, "oauth_token", newJString(oauthToken))
  add(query_589124, "userIp", newJString(userIp))
  add(path_589123, "applicationId", newJString(applicationId))
  add(query_589124, "key", newJString(key))
  if body != nil:
    body_589125 = body
  add(query_589124, "prettyPrint", newJBool(prettyPrint))
  result = call_589122.call(path_589123, query_589124, nil, nil, body_589125)

var gamesConfigurationLeaderboardConfigurationsInsert* = Call_GamesConfigurationLeaderboardConfigurationsInsert_589109(
    name: "gamesConfigurationLeaderboardConfigurationsInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/applications/{applicationId}/leaderboards",
    validator: validate_GamesConfigurationLeaderboardConfigurationsInsert_589110,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsInsert_589111,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsList_589092 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationLeaderboardConfigurationsList_589094(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/leaderboards")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesConfigurationLeaderboardConfigurationsList_589093(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a list of the leaderboard configurations in this application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The application ID from the Google Play developer console.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_589095 = path.getOrDefault("applicationId")
  valid_589095 = validateParameter(valid_589095, JString, required = true,
                                 default = nil)
  if valid_589095 != nil:
    section.add "applicationId", valid_589095
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
  ##             : The maximum number of resource configurations to return in the response, used for paging. For any response, the actual number of resources returned may be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589096 = query.getOrDefault("fields")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "fields", valid_589096
  var valid_589097 = query.getOrDefault("pageToken")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "pageToken", valid_589097
  var valid_589098 = query.getOrDefault("quotaUser")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "quotaUser", valid_589098
  var valid_589099 = query.getOrDefault("alt")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = newJString("json"))
  if valid_589099 != nil:
    section.add "alt", valid_589099
  var valid_589100 = query.getOrDefault("oauth_token")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "oauth_token", valid_589100
  var valid_589101 = query.getOrDefault("userIp")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "userIp", valid_589101
  var valid_589102 = query.getOrDefault("maxResults")
  valid_589102 = validateParameter(valid_589102, JInt, required = false, default = nil)
  if valid_589102 != nil:
    section.add "maxResults", valid_589102
  var valid_589103 = query.getOrDefault("key")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "key", valid_589103
  var valid_589104 = query.getOrDefault("prettyPrint")
  valid_589104 = validateParameter(valid_589104, JBool, required = false,
                                 default = newJBool(true))
  if valid_589104 != nil:
    section.add "prettyPrint", valid_589104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589105: Call_GamesConfigurationLeaderboardConfigurationsList_589092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of the leaderboard configurations in this application.
  ## 
  let valid = call_589105.validator(path, query, header, formData, body)
  let scheme = call_589105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589105.url(scheme.get, call_589105.host, call_589105.base,
                         call_589105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589105, url, valid)

proc call*(call_589106: Call_GamesConfigurationLeaderboardConfigurationsList_589092;
          applicationId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsList
  ## Returns a list of the leaderboard configurations in this application.
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
  ##             : The maximum number of resource configurations to return in the response, used for paging. For any response, the actual number of resources returned may be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589107 = newJObject()
  var query_589108 = newJObject()
  add(query_589108, "fields", newJString(fields))
  add(query_589108, "pageToken", newJString(pageToken))
  add(query_589108, "quotaUser", newJString(quotaUser))
  add(query_589108, "alt", newJString(alt))
  add(query_589108, "oauth_token", newJString(oauthToken))
  add(query_589108, "userIp", newJString(userIp))
  add(path_589107, "applicationId", newJString(applicationId))
  add(query_589108, "maxResults", newJInt(maxResults))
  add(query_589108, "key", newJString(key))
  add(query_589108, "prettyPrint", newJBool(prettyPrint))
  result = call_589106.call(path_589107, query_589108, nil, nil, nil)

var gamesConfigurationLeaderboardConfigurationsList* = Call_GamesConfigurationLeaderboardConfigurationsList_589092(
    name: "gamesConfigurationLeaderboardConfigurationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/applications/{applicationId}/leaderboards",
    validator: validate_GamesConfigurationLeaderboardConfigurationsList_589093,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsList_589094,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationImageConfigurationsUpload_589126 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationImageConfigurationsUpload_589128(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "imageType" in path, "`imageType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "resourceId"),
               (kind: ConstantSegment, value: "/imageType/"),
               (kind: VariableSegment, value: "imageType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GamesConfigurationImageConfigurationsUpload_589127(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads an image for a resource with the given ID and image type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageType: JString (required)
  ##            : Selects which image in a resource for this method.
  ##   resourceId: JString (required)
  ##             : The ID of the resource used by this method.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageType` field"
  var valid_589129 = path.getOrDefault("imageType")
  valid_589129 = validateParameter(valid_589129, JString, required = true,
                                 default = newJString("ACHIEVEMENT_ICON"))
  if valid_589129 != nil:
    section.add "imageType", valid_589129
  var valid_589130 = path.getOrDefault("resourceId")
  valid_589130 = validateParameter(valid_589130, JString, required = true,
                                 default = nil)
  if valid_589130 != nil:
    section.add "resourceId", valid_589130
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
  var valid_589131 = query.getOrDefault("fields")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "fields", valid_589131
  var valid_589132 = query.getOrDefault("quotaUser")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "quotaUser", valid_589132
  var valid_589133 = query.getOrDefault("alt")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = newJString("json"))
  if valid_589133 != nil:
    section.add "alt", valid_589133
  var valid_589134 = query.getOrDefault("oauth_token")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "oauth_token", valid_589134
  var valid_589135 = query.getOrDefault("userIp")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "userIp", valid_589135
  var valid_589136 = query.getOrDefault("key")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "key", valid_589136
  var valid_589137 = query.getOrDefault("prettyPrint")
  valid_589137 = validateParameter(valid_589137, JBool, required = false,
                                 default = newJBool(true))
  if valid_589137 != nil:
    section.add "prettyPrint", valid_589137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589138: Call_GamesConfigurationImageConfigurationsUpload_589126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads an image for a resource with the given ID and image type.
  ## 
  let valid = call_589138.validator(path, query, header, formData, body)
  let scheme = call_589138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589138.url(scheme.get, call_589138.host, call_589138.base,
                         call_589138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589138, url, valid)

proc call*(call_589139: Call_GamesConfigurationImageConfigurationsUpload_589126;
          resourceId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          imageType: string = "ACHIEVEMENT_ICON"; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## gamesConfigurationImageConfigurationsUpload
  ## Uploads an image for a resource with the given ID and image type.
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
  ##   imageType: string (required)
  ##            : Selects which image in a resource for this method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resourceId: string (required)
  ##             : The ID of the resource used by this method.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589140 = newJObject()
  var query_589141 = newJObject()
  add(query_589141, "fields", newJString(fields))
  add(query_589141, "quotaUser", newJString(quotaUser))
  add(query_589141, "alt", newJString(alt))
  add(query_589141, "oauth_token", newJString(oauthToken))
  add(query_589141, "userIp", newJString(userIp))
  add(path_589140, "imageType", newJString(imageType))
  add(query_589141, "key", newJString(key))
  add(path_589140, "resourceId", newJString(resourceId))
  add(query_589141, "prettyPrint", newJBool(prettyPrint))
  result = call_589139.call(path_589140, query_589141, nil, nil, nil)

var gamesConfigurationImageConfigurationsUpload* = Call_GamesConfigurationImageConfigurationsUpload_589126(
    name: "gamesConfigurationImageConfigurationsUpload",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/images/{resourceId}/imageType/{imageType}",
    validator: validate_GamesConfigurationImageConfigurationsUpload_589127,
    base: "/games/v1configuration",
    url: url_GamesConfigurationImageConfigurationsUpload_589128,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsUpdate_589157 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationLeaderboardConfigurationsUpdate_589159(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_GamesConfigurationLeaderboardConfigurationsUpdate_589158(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update the metadata of the leaderboard configuration with the given ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `leaderboardId` field"
  var valid_589160 = path.getOrDefault("leaderboardId")
  valid_589160 = validateParameter(valid_589160, JString, required = true,
                                 default = nil)
  if valid_589160 != nil:
    section.add "leaderboardId", valid_589160
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
  var valid_589161 = query.getOrDefault("fields")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "fields", valid_589161
  var valid_589162 = query.getOrDefault("quotaUser")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "quotaUser", valid_589162
  var valid_589163 = query.getOrDefault("alt")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = newJString("json"))
  if valid_589163 != nil:
    section.add "alt", valid_589163
  var valid_589164 = query.getOrDefault("oauth_token")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "oauth_token", valid_589164
  var valid_589165 = query.getOrDefault("userIp")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "userIp", valid_589165
  var valid_589166 = query.getOrDefault("key")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "key", valid_589166
  var valid_589167 = query.getOrDefault("prettyPrint")
  valid_589167 = validateParameter(valid_589167, JBool, required = false,
                                 default = newJBool(true))
  if valid_589167 != nil:
    section.add "prettyPrint", valid_589167
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

proc call*(call_589169: Call_GamesConfigurationLeaderboardConfigurationsUpdate_589157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the metadata of the leaderboard configuration with the given ID.
  ## 
  let valid = call_589169.validator(path, query, header, formData, body)
  let scheme = call_589169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589169.url(scheme.get, call_589169.host, call_589169.base,
                         call_589169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589169, url, valid)

proc call*(call_589170: Call_GamesConfigurationLeaderboardConfigurationsUpdate_589157;
          leaderboardId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsUpdate
  ## Update the metadata of the leaderboard configuration with the given ID.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589171 = newJObject()
  var query_589172 = newJObject()
  var body_589173 = newJObject()
  add(query_589172, "fields", newJString(fields))
  add(query_589172, "quotaUser", newJString(quotaUser))
  add(query_589172, "alt", newJString(alt))
  add(path_589171, "leaderboardId", newJString(leaderboardId))
  add(query_589172, "oauth_token", newJString(oauthToken))
  add(query_589172, "userIp", newJString(userIp))
  add(query_589172, "key", newJString(key))
  if body != nil:
    body_589173 = body
  add(query_589172, "prettyPrint", newJBool(prettyPrint))
  result = call_589170.call(path_589171, query_589172, nil, nil, body_589173)

var gamesConfigurationLeaderboardConfigurationsUpdate* = Call_GamesConfigurationLeaderboardConfigurationsUpdate_589157(
    name: "gamesConfigurationLeaderboardConfigurationsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesConfigurationLeaderboardConfigurationsUpdate_589158,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsUpdate_589159,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsGet_589142 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationLeaderboardConfigurationsGet_589144(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_GamesConfigurationLeaderboardConfigurationsGet_589143(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the metadata of the leaderboard configuration with the given ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `leaderboardId` field"
  var valid_589145 = path.getOrDefault("leaderboardId")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "leaderboardId", valid_589145
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
  var valid_589146 = query.getOrDefault("fields")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "fields", valid_589146
  var valid_589147 = query.getOrDefault("quotaUser")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "quotaUser", valid_589147
  var valid_589148 = query.getOrDefault("alt")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = newJString("json"))
  if valid_589148 != nil:
    section.add "alt", valid_589148
  var valid_589149 = query.getOrDefault("oauth_token")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "oauth_token", valid_589149
  var valid_589150 = query.getOrDefault("userIp")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "userIp", valid_589150
  var valid_589151 = query.getOrDefault("key")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "key", valid_589151
  var valid_589152 = query.getOrDefault("prettyPrint")
  valid_589152 = validateParameter(valid_589152, JBool, required = false,
                                 default = newJBool(true))
  if valid_589152 != nil:
    section.add "prettyPrint", valid_589152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589153: Call_GamesConfigurationLeaderboardConfigurationsGet_589142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metadata of the leaderboard configuration with the given ID.
  ## 
  let valid = call_589153.validator(path, query, header, formData, body)
  let scheme = call_589153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589153.url(scheme.get, call_589153.host, call_589153.base,
                         call_589153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589153, url, valid)

proc call*(call_589154: Call_GamesConfigurationLeaderboardConfigurationsGet_589142;
          leaderboardId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsGet
  ## Retrieves the metadata of the leaderboard configuration with the given ID.
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
  var path_589155 = newJObject()
  var query_589156 = newJObject()
  add(query_589156, "fields", newJString(fields))
  add(query_589156, "quotaUser", newJString(quotaUser))
  add(query_589156, "alt", newJString(alt))
  add(path_589155, "leaderboardId", newJString(leaderboardId))
  add(query_589156, "oauth_token", newJString(oauthToken))
  add(query_589156, "userIp", newJString(userIp))
  add(query_589156, "key", newJString(key))
  add(query_589156, "prettyPrint", newJBool(prettyPrint))
  result = call_589154.call(path_589155, query_589156, nil, nil, nil)

var gamesConfigurationLeaderboardConfigurationsGet* = Call_GamesConfigurationLeaderboardConfigurationsGet_589142(
    name: "gamesConfigurationLeaderboardConfigurationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesConfigurationLeaderboardConfigurationsGet_589143,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsGet_589144,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsPatch_589189 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationLeaderboardConfigurationsPatch_589191(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_GamesConfigurationLeaderboardConfigurationsPatch_589190(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update the metadata of the leaderboard configuration with the given ID. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `leaderboardId` field"
  var valid_589192 = path.getOrDefault("leaderboardId")
  valid_589192 = validateParameter(valid_589192, JString, required = true,
                                 default = nil)
  if valid_589192 != nil:
    section.add "leaderboardId", valid_589192
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
  var valid_589193 = query.getOrDefault("fields")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "fields", valid_589193
  var valid_589194 = query.getOrDefault("quotaUser")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "quotaUser", valid_589194
  var valid_589195 = query.getOrDefault("alt")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = newJString("json"))
  if valid_589195 != nil:
    section.add "alt", valid_589195
  var valid_589196 = query.getOrDefault("oauth_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "oauth_token", valid_589196
  var valid_589197 = query.getOrDefault("userIp")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "userIp", valid_589197
  var valid_589198 = query.getOrDefault("key")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "key", valid_589198
  var valid_589199 = query.getOrDefault("prettyPrint")
  valid_589199 = validateParameter(valid_589199, JBool, required = false,
                                 default = newJBool(true))
  if valid_589199 != nil:
    section.add "prettyPrint", valid_589199
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

proc call*(call_589201: Call_GamesConfigurationLeaderboardConfigurationsPatch_589189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the metadata of the leaderboard configuration with the given ID. This method supports patch semantics.
  ## 
  let valid = call_589201.validator(path, query, header, formData, body)
  let scheme = call_589201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589201.url(scheme.get, call_589201.host, call_589201.base,
                         call_589201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589201, url, valid)

proc call*(call_589202: Call_GamesConfigurationLeaderboardConfigurationsPatch_589189;
          leaderboardId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsPatch
  ## Update the metadata of the leaderboard configuration with the given ID. This method supports patch semantics.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589203 = newJObject()
  var query_589204 = newJObject()
  var body_589205 = newJObject()
  add(query_589204, "fields", newJString(fields))
  add(query_589204, "quotaUser", newJString(quotaUser))
  add(query_589204, "alt", newJString(alt))
  add(path_589203, "leaderboardId", newJString(leaderboardId))
  add(query_589204, "oauth_token", newJString(oauthToken))
  add(query_589204, "userIp", newJString(userIp))
  add(query_589204, "key", newJString(key))
  if body != nil:
    body_589205 = body
  add(query_589204, "prettyPrint", newJBool(prettyPrint))
  result = call_589202.call(path_589203, query_589204, nil, nil, body_589205)

var gamesConfigurationLeaderboardConfigurationsPatch* = Call_GamesConfigurationLeaderboardConfigurationsPatch_589189(
    name: "gamesConfigurationLeaderboardConfigurationsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesConfigurationLeaderboardConfigurationsPatch_589190,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsPatch_589191,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsDelete_589174 = ref object of OpenApiRestCall_588457
proc url_GamesConfigurationLeaderboardConfigurationsDelete_589176(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_GamesConfigurationLeaderboardConfigurationsDelete_589175(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete the leaderboard configuration with the given ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   leaderboardId: JString (required)
  ##                : The ID of the leaderboard.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `leaderboardId` field"
  var valid_589177 = path.getOrDefault("leaderboardId")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = nil)
  if valid_589177 != nil:
    section.add "leaderboardId", valid_589177
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
  var valid_589178 = query.getOrDefault("fields")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "fields", valid_589178
  var valid_589179 = query.getOrDefault("quotaUser")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "quotaUser", valid_589179
  var valid_589180 = query.getOrDefault("alt")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = newJString("json"))
  if valid_589180 != nil:
    section.add "alt", valid_589180
  var valid_589181 = query.getOrDefault("oauth_token")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "oauth_token", valid_589181
  var valid_589182 = query.getOrDefault("userIp")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "userIp", valid_589182
  var valid_589183 = query.getOrDefault("key")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "key", valid_589183
  var valid_589184 = query.getOrDefault("prettyPrint")
  valid_589184 = validateParameter(valid_589184, JBool, required = false,
                                 default = newJBool(true))
  if valid_589184 != nil:
    section.add "prettyPrint", valid_589184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589185: Call_GamesConfigurationLeaderboardConfigurationsDelete_589174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the leaderboard configuration with the given ID.
  ## 
  let valid = call_589185.validator(path, query, header, formData, body)
  let scheme = call_589185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589185.url(scheme.get, call_589185.host, call_589185.base,
                         call_589185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589185, url, valid)

proc call*(call_589186: Call_GamesConfigurationLeaderboardConfigurationsDelete_589174;
          leaderboardId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsDelete
  ## Delete the leaderboard configuration with the given ID.
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
  var path_589187 = newJObject()
  var query_589188 = newJObject()
  add(query_589188, "fields", newJString(fields))
  add(query_589188, "quotaUser", newJString(quotaUser))
  add(query_589188, "alt", newJString(alt))
  add(path_589187, "leaderboardId", newJString(leaderboardId))
  add(query_589188, "oauth_token", newJString(oauthToken))
  add(query_589188, "userIp", newJString(userIp))
  add(query_589188, "key", newJString(key))
  add(query_589188, "prettyPrint", newJBool(prettyPrint))
  result = call_589186.call(path_589187, query_589188, nil, nil, nil)

var gamesConfigurationLeaderboardConfigurationsDelete* = Call_GamesConfigurationLeaderboardConfigurationsDelete_589174(
    name: "gamesConfigurationLeaderboardConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesConfigurationLeaderboardConfigurationsDelete_589175,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsDelete_589176,
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
