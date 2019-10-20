
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
  gcpServiceName = "gamesConfiguration"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GamesConfigurationAchievementConfigurationsUpdate_578909 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationAchievementConfigurationsUpdate_578911(
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

proc validate_GamesConfigurationAchievementConfigurationsUpdate_578910(
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
  var valid_578912 = path.getOrDefault("achievementId")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "achievementId", valid_578912
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
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("prettyPrint")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "prettyPrint", valid_578914
  var valid_578915 = query.getOrDefault("oauth_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "oauth_token", valid_578915
  var valid_578916 = query.getOrDefault("alt")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("json"))
  if valid_578916 != nil:
    section.add "alt", valid_578916
  var valid_578917 = query.getOrDefault("userIp")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "userIp", valid_578917
  var valid_578918 = query.getOrDefault("quotaUser")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "quotaUser", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
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

proc call*(call_578921: Call_GamesConfigurationAchievementConfigurationsUpdate_578909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the metadata of the achievement configuration with the given ID.
  ## 
  let valid = call_578921.validator(path, query, header, formData, body)
  let scheme = call_578921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578921.url(scheme.get, call_578921.host, call_578921.base,
                         call_578921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578921, url, valid)

proc call*(call_578922: Call_GamesConfigurationAchievementConfigurationsUpdate_578909;
          achievementId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gamesConfigurationAchievementConfigurationsUpdate
  ## Update the metadata of the achievement configuration with the given ID.
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
  ##   achievementId: string (required)
  ##                : The ID of the achievement used by this method.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578923 = newJObject()
  var query_578924 = newJObject()
  var body_578925 = newJObject()
  add(query_578924, "key", newJString(key))
  add(query_578924, "prettyPrint", newJBool(prettyPrint))
  add(query_578924, "oauth_token", newJString(oauthToken))
  add(query_578924, "alt", newJString(alt))
  add(query_578924, "userIp", newJString(userIp))
  add(query_578924, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578925 = body
  add(path_578923, "achievementId", newJString(achievementId))
  add(query_578924, "fields", newJString(fields))
  result = call_578922.call(path_578923, query_578924, nil, nil, body_578925)

var gamesConfigurationAchievementConfigurationsUpdate* = Call_GamesConfigurationAchievementConfigurationsUpdate_578909(
    name: "gamesConfigurationAchievementConfigurationsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/achievements/{achievementId}",
    validator: validate_GamesConfigurationAchievementConfigurationsUpdate_578910,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsUpdate_578911,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationAchievementConfigurationsGet_578625 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationAchievementConfigurationsGet_578627(protocol: Scheme;
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

proc validate_GamesConfigurationAchievementConfigurationsGet_578626(
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
  var valid_578753 = path.getOrDefault("achievementId")
  valid_578753 = validateParameter(valid_578753, JString, required = true,
                                 default = nil)
  if valid_578753 != nil:
    section.add "achievementId", valid_578753
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
  var valid_578754 = query.getOrDefault("key")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "key", valid_578754
  var valid_578768 = query.getOrDefault("prettyPrint")
  valid_578768 = validateParameter(valid_578768, JBool, required = false,
                                 default = newJBool(true))
  if valid_578768 != nil:
    section.add "prettyPrint", valid_578768
  var valid_578769 = query.getOrDefault("oauth_token")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "oauth_token", valid_578769
  var valid_578770 = query.getOrDefault("alt")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = newJString("json"))
  if valid_578770 != nil:
    section.add "alt", valid_578770
  var valid_578771 = query.getOrDefault("userIp")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "userIp", valid_578771
  var valid_578772 = query.getOrDefault("quotaUser")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "quotaUser", valid_578772
  var valid_578773 = query.getOrDefault("fields")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "fields", valid_578773
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578796: Call_GamesConfigurationAchievementConfigurationsGet_578625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metadata of the achievement configuration with the given ID.
  ## 
  let valid = call_578796.validator(path, query, header, formData, body)
  let scheme = call_578796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578796.url(scheme.get, call_578796.host, call_578796.base,
                         call_578796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578796, url, valid)

proc call*(call_578867: Call_GamesConfigurationAchievementConfigurationsGet_578625;
          achievementId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesConfigurationAchievementConfigurationsGet
  ## Retrieves the metadata of the achievement configuration with the given ID.
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
  var path_578868 = newJObject()
  var query_578870 = newJObject()
  add(query_578870, "key", newJString(key))
  add(query_578870, "prettyPrint", newJBool(prettyPrint))
  add(query_578870, "oauth_token", newJString(oauthToken))
  add(query_578870, "alt", newJString(alt))
  add(query_578870, "userIp", newJString(userIp))
  add(query_578870, "quotaUser", newJString(quotaUser))
  add(path_578868, "achievementId", newJString(achievementId))
  add(query_578870, "fields", newJString(fields))
  result = call_578867.call(path_578868, query_578870, nil, nil, nil)

var gamesConfigurationAchievementConfigurationsGet* = Call_GamesConfigurationAchievementConfigurationsGet_578625(
    name: "gamesConfigurationAchievementConfigurationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/achievements/{achievementId}",
    validator: validate_GamesConfigurationAchievementConfigurationsGet_578626,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsGet_578627,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationAchievementConfigurationsPatch_578941 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationAchievementConfigurationsPatch_578943(
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

proc validate_GamesConfigurationAchievementConfigurationsPatch_578942(
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
  var valid_578944 = path.getOrDefault("achievementId")
  valid_578944 = validateParameter(valid_578944, JString, required = true,
                                 default = nil)
  if valid_578944 != nil:
    section.add "achievementId", valid_578944
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
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  var valid_578946 = query.getOrDefault("prettyPrint")
  valid_578946 = validateParameter(valid_578946, JBool, required = false,
                                 default = newJBool(true))
  if valid_578946 != nil:
    section.add "prettyPrint", valid_578946
  var valid_578947 = query.getOrDefault("oauth_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "oauth_token", valid_578947
  var valid_578948 = query.getOrDefault("alt")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("json"))
  if valid_578948 != nil:
    section.add "alt", valid_578948
  var valid_578949 = query.getOrDefault("userIp")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "userIp", valid_578949
  var valid_578950 = query.getOrDefault("quotaUser")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "quotaUser", valid_578950
  var valid_578951 = query.getOrDefault("fields")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "fields", valid_578951
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

proc call*(call_578953: Call_GamesConfigurationAchievementConfigurationsPatch_578941;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the metadata of the achievement configuration with the given ID. This method supports patch semantics.
  ## 
  let valid = call_578953.validator(path, query, header, formData, body)
  let scheme = call_578953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578953.url(scheme.get, call_578953.host, call_578953.base,
                         call_578953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578953, url, valid)

proc call*(call_578954: Call_GamesConfigurationAchievementConfigurationsPatch_578941;
          achievementId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gamesConfigurationAchievementConfigurationsPatch
  ## Update the metadata of the achievement configuration with the given ID. This method supports patch semantics.
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
  ##   achievementId: string (required)
  ##                : The ID of the achievement used by this method.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578955 = newJObject()
  var query_578956 = newJObject()
  var body_578957 = newJObject()
  add(query_578956, "key", newJString(key))
  add(query_578956, "prettyPrint", newJBool(prettyPrint))
  add(query_578956, "oauth_token", newJString(oauthToken))
  add(query_578956, "alt", newJString(alt))
  add(query_578956, "userIp", newJString(userIp))
  add(query_578956, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578957 = body
  add(path_578955, "achievementId", newJString(achievementId))
  add(query_578956, "fields", newJString(fields))
  result = call_578954.call(path_578955, query_578956, nil, nil, body_578957)

var gamesConfigurationAchievementConfigurationsPatch* = Call_GamesConfigurationAchievementConfigurationsPatch_578941(
    name: "gamesConfigurationAchievementConfigurationsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/achievements/{achievementId}",
    validator: validate_GamesConfigurationAchievementConfigurationsPatch_578942,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsPatch_578943,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationAchievementConfigurationsDelete_578926 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationAchievementConfigurationsDelete_578928(
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

proc validate_GamesConfigurationAchievementConfigurationsDelete_578927(
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
  var valid_578929 = path.getOrDefault("achievementId")
  valid_578929 = validateParameter(valid_578929, JString, required = true,
                                 default = nil)
  if valid_578929 != nil:
    section.add "achievementId", valid_578929
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
  var valid_578930 = query.getOrDefault("key")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "key", valid_578930
  var valid_578931 = query.getOrDefault("prettyPrint")
  valid_578931 = validateParameter(valid_578931, JBool, required = false,
                                 default = newJBool(true))
  if valid_578931 != nil:
    section.add "prettyPrint", valid_578931
  var valid_578932 = query.getOrDefault("oauth_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "oauth_token", valid_578932
  var valid_578933 = query.getOrDefault("alt")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("json"))
  if valid_578933 != nil:
    section.add "alt", valid_578933
  var valid_578934 = query.getOrDefault("userIp")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "userIp", valid_578934
  var valid_578935 = query.getOrDefault("quotaUser")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "quotaUser", valid_578935
  var valid_578936 = query.getOrDefault("fields")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "fields", valid_578936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578937: Call_GamesConfigurationAchievementConfigurationsDelete_578926;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the achievement configuration with the given ID.
  ## 
  let valid = call_578937.validator(path, query, header, formData, body)
  let scheme = call_578937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578937.url(scheme.get, call_578937.host, call_578937.base,
                         call_578937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578937, url, valid)

proc call*(call_578938: Call_GamesConfigurationAchievementConfigurationsDelete_578926;
          achievementId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesConfigurationAchievementConfigurationsDelete
  ## Delete the achievement configuration with the given ID.
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
  var path_578939 = newJObject()
  var query_578940 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "userIp", newJString(userIp))
  add(query_578940, "quotaUser", newJString(quotaUser))
  add(path_578939, "achievementId", newJString(achievementId))
  add(query_578940, "fields", newJString(fields))
  result = call_578938.call(path_578939, query_578940, nil, nil, nil)

var gamesConfigurationAchievementConfigurationsDelete* = Call_GamesConfigurationAchievementConfigurationsDelete_578926(
    name: "gamesConfigurationAchievementConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/achievements/{achievementId}",
    validator: validate_GamesConfigurationAchievementConfigurationsDelete_578927,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsDelete_578928,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationAchievementConfigurationsInsert_578975 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationAchievementConfigurationsInsert_578977(
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

proc validate_GamesConfigurationAchievementConfigurationsInsert_578976(
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
  var valid_578978 = path.getOrDefault("applicationId")
  valid_578978 = validateParameter(valid_578978, JString, required = true,
                                 default = nil)
  if valid_578978 != nil:
    section.add "applicationId", valid_578978
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
  var valid_578979 = query.getOrDefault("key")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "key", valid_578979
  var valid_578980 = query.getOrDefault("prettyPrint")
  valid_578980 = validateParameter(valid_578980, JBool, required = false,
                                 default = newJBool(true))
  if valid_578980 != nil:
    section.add "prettyPrint", valid_578980
  var valid_578981 = query.getOrDefault("oauth_token")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "oauth_token", valid_578981
  var valid_578982 = query.getOrDefault("alt")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = newJString("json"))
  if valid_578982 != nil:
    section.add "alt", valid_578982
  var valid_578983 = query.getOrDefault("userIp")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "userIp", valid_578983
  var valid_578984 = query.getOrDefault("quotaUser")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "quotaUser", valid_578984
  var valid_578985 = query.getOrDefault("fields")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "fields", valid_578985
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

proc call*(call_578987: Call_GamesConfigurationAchievementConfigurationsInsert_578975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert a new achievement configuration in this application.
  ## 
  let valid = call_578987.validator(path, query, header, formData, body)
  let scheme = call_578987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578987.url(scheme.get, call_578987.host, call_578987.base,
                         call_578987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578987, url, valid)

proc call*(call_578988: Call_GamesConfigurationAchievementConfigurationsInsert_578975;
          applicationId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gamesConfigurationAchievementConfigurationsInsert
  ## Insert a new achievement configuration in this application.
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
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  var path_578989 = newJObject()
  var query_578990 = newJObject()
  var body_578991 = newJObject()
  add(query_578990, "key", newJString(key))
  add(query_578990, "prettyPrint", newJBool(prettyPrint))
  add(query_578990, "oauth_token", newJString(oauthToken))
  add(query_578990, "alt", newJString(alt))
  add(query_578990, "userIp", newJString(userIp))
  add(query_578990, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578991 = body
  add(query_578990, "fields", newJString(fields))
  add(path_578989, "applicationId", newJString(applicationId))
  result = call_578988.call(path_578989, query_578990, nil, nil, body_578991)

var gamesConfigurationAchievementConfigurationsInsert* = Call_GamesConfigurationAchievementConfigurationsInsert_578975(
    name: "gamesConfigurationAchievementConfigurationsInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/applications/{applicationId}/achievements",
    validator: validate_GamesConfigurationAchievementConfigurationsInsert_578976,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsInsert_578977,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationAchievementConfigurationsList_578958 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationAchievementConfigurationsList_578960(protocol: Scheme;
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

proc validate_GamesConfigurationAchievementConfigurationsList_578959(
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
  var valid_578961 = path.getOrDefault("applicationId")
  valid_578961 = validateParameter(valid_578961, JString, required = true,
                                 default = nil)
  if valid_578961 != nil:
    section.add "applicationId", valid_578961
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
  ##             : The maximum number of resource configurations to return in the response, used for paging. For any response, the actual number of resources returned may be less than the specified maxResults.
  section = newJObject()
  var valid_578962 = query.getOrDefault("key")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "key", valid_578962
  var valid_578963 = query.getOrDefault("prettyPrint")
  valid_578963 = validateParameter(valid_578963, JBool, required = false,
                                 default = newJBool(true))
  if valid_578963 != nil:
    section.add "prettyPrint", valid_578963
  var valid_578964 = query.getOrDefault("oauth_token")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "oauth_token", valid_578964
  var valid_578965 = query.getOrDefault("alt")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("json"))
  if valid_578965 != nil:
    section.add "alt", valid_578965
  var valid_578966 = query.getOrDefault("userIp")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "userIp", valid_578966
  var valid_578967 = query.getOrDefault("quotaUser")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "quotaUser", valid_578967
  var valid_578968 = query.getOrDefault("pageToken")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "pageToken", valid_578968
  var valid_578969 = query.getOrDefault("fields")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "fields", valid_578969
  var valid_578970 = query.getOrDefault("maxResults")
  valid_578970 = validateParameter(valid_578970, JInt, required = false, default = nil)
  if valid_578970 != nil:
    section.add "maxResults", valid_578970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578971: Call_GamesConfigurationAchievementConfigurationsList_578958;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of the achievement configurations in this application.
  ## 
  let valid = call_578971.validator(path, query, header, formData, body)
  let scheme = call_578971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578971.url(scheme.get, call_578971.host, call_578971.base,
                         call_578971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578971, url, valid)

proc call*(call_578972: Call_GamesConfigurationAchievementConfigurationsList_578958;
          applicationId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## gamesConfigurationAchievementConfigurationsList
  ## Returns a list of the achievement configurations in this application.
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
  ##             : The maximum number of resource configurations to return in the response, used for paging. For any response, the actual number of resources returned may be less than the specified maxResults.
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  var path_578973 = newJObject()
  var query_578974 = newJObject()
  add(query_578974, "key", newJString(key))
  add(query_578974, "prettyPrint", newJBool(prettyPrint))
  add(query_578974, "oauth_token", newJString(oauthToken))
  add(query_578974, "alt", newJString(alt))
  add(query_578974, "userIp", newJString(userIp))
  add(query_578974, "quotaUser", newJString(quotaUser))
  add(query_578974, "pageToken", newJString(pageToken))
  add(query_578974, "fields", newJString(fields))
  add(query_578974, "maxResults", newJInt(maxResults))
  add(path_578973, "applicationId", newJString(applicationId))
  result = call_578972.call(path_578973, query_578974, nil, nil, nil)

var gamesConfigurationAchievementConfigurationsList* = Call_GamesConfigurationAchievementConfigurationsList_578958(
    name: "gamesConfigurationAchievementConfigurationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/applications/{applicationId}/achievements",
    validator: validate_GamesConfigurationAchievementConfigurationsList_578959,
    base: "/games/v1configuration",
    url: url_GamesConfigurationAchievementConfigurationsList_578960,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsInsert_579009 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationLeaderboardConfigurationsInsert_579011(
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

proc validate_GamesConfigurationLeaderboardConfigurationsInsert_579010(
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
  var valid_579012 = path.getOrDefault("applicationId")
  valid_579012 = validateParameter(valid_579012, JString, required = true,
                                 default = nil)
  if valid_579012 != nil:
    section.add "applicationId", valid_579012
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
  var valid_579013 = query.getOrDefault("key")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "key", valid_579013
  var valid_579014 = query.getOrDefault("prettyPrint")
  valid_579014 = validateParameter(valid_579014, JBool, required = false,
                                 default = newJBool(true))
  if valid_579014 != nil:
    section.add "prettyPrint", valid_579014
  var valid_579015 = query.getOrDefault("oauth_token")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "oauth_token", valid_579015
  var valid_579016 = query.getOrDefault("alt")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = newJString("json"))
  if valid_579016 != nil:
    section.add "alt", valid_579016
  var valid_579017 = query.getOrDefault("userIp")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "userIp", valid_579017
  var valid_579018 = query.getOrDefault("quotaUser")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "quotaUser", valid_579018
  var valid_579019 = query.getOrDefault("fields")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "fields", valid_579019
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

proc call*(call_579021: Call_GamesConfigurationLeaderboardConfigurationsInsert_579009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert a new leaderboard configuration in this application.
  ## 
  let valid = call_579021.validator(path, query, header, formData, body)
  let scheme = call_579021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579021.url(scheme.get, call_579021.host, call_579021.base,
                         call_579021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579021, url, valid)

proc call*(call_579022: Call_GamesConfigurationLeaderboardConfigurationsInsert_579009;
          applicationId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsInsert
  ## Insert a new leaderboard configuration in this application.
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
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  var path_579023 = newJObject()
  var query_579024 = newJObject()
  var body_579025 = newJObject()
  add(query_579024, "key", newJString(key))
  add(query_579024, "prettyPrint", newJBool(prettyPrint))
  add(query_579024, "oauth_token", newJString(oauthToken))
  add(query_579024, "alt", newJString(alt))
  add(query_579024, "userIp", newJString(userIp))
  add(query_579024, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579025 = body
  add(query_579024, "fields", newJString(fields))
  add(path_579023, "applicationId", newJString(applicationId))
  result = call_579022.call(path_579023, query_579024, nil, nil, body_579025)

var gamesConfigurationLeaderboardConfigurationsInsert* = Call_GamesConfigurationLeaderboardConfigurationsInsert_579009(
    name: "gamesConfigurationLeaderboardConfigurationsInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/applications/{applicationId}/leaderboards",
    validator: validate_GamesConfigurationLeaderboardConfigurationsInsert_579010,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsInsert_579011,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsList_578992 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationLeaderboardConfigurationsList_578994(protocol: Scheme;
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

proc validate_GamesConfigurationLeaderboardConfigurationsList_578993(
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
  var valid_578995 = path.getOrDefault("applicationId")
  valid_578995 = validateParameter(valid_578995, JString, required = true,
                                 default = nil)
  if valid_578995 != nil:
    section.add "applicationId", valid_578995
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
  ##             : The maximum number of resource configurations to return in the response, used for paging. For any response, the actual number of resources returned may be less than the specified maxResults.
  section = newJObject()
  var valid_578996 = query.getOrDefault("key")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "key", valid_578996
  var valid_578997 = query.getOrDefault("prettyPrint")
  valid_578997 = validateParameter(valid_578997, JBool, required = false,
                                 default = newJBool(true))
  if valid_578997 != nil:
    section.add "prettyPrint", valid_578997
  var valid_578998 = query.getOrDefault("oauth_token")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "oauth_token", valid_578998
  var valid_578999 = query.getOrDefault("alt")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = newJString("json"))
  if valid_578999 != nil:
    section.add "alt", valid_578999
  var valid_579000 = query.getOrDefault("userIp")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "userIp", valid_579000
  var valid_579001 = query.getOrDefault("quotaUser")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "quotaUser", valid_579001
  var valid_579002 = query.getOrDefault("pageToken")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "pageToken", valid_579002
  var valid_579003 = query.getOrDefault("fields")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "fields", valid_579003
  var valid_579004 = query.getOrDefault("maxResults")
  valid_579004 = validateParameter(valid_579004, JInt, required = false, default = nil)
  if valid_579004 != nil:
    section.add "maxResults", valid_579004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579005: Call_GamesConfigurationLeaderboardConfigurationsList_578992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of the leaderboard configurations in this application.
  ## 
  let valid = call_579005.validator(path, query, header, formData, body)
  let scheme = call_579005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579005.url(scheme.get, call_579005.host, call_579005.base,
                         call_579005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579005, url, valid)

proc call*(call_579006: Call_GamesConfigurationLeaderboardConfigurationsList_578992;
          applicationId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsList
  ## Returns a list of the leaderboard configurations in this application.
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
  ##             : The maximum number of resource configurations to return in the response, used for paging. For any response, the actual number of resources returned may be less than the specified maxResults.
  ##   applicationId: string (required)
  ##                : The application ID from the Google Play developer console.
  var path_579007 = newJObject()
  var query_579008 = newJObject()
  add(query_579008, "key", newJString(key))
  add(query_579008, "prettyPrint", newJBool(prettyPrint))
  add(query_579008, "oauth_token", newJString(oauthToken))
  add(query_579008, "alt", newJString(alt))
  add(query_579008, "userIp", newJString(userIp))
  add(query_579008, "quotaUser", newJString(quotaUser))
  add(query_579008, "pageToken", newJString(pageToken))
  add(query_579008, "fields", newJString(fields))
  add(query_579008, "maxResults", newJInt(maxResults))
  add(path_579007, "applicationId", newJString(applicationId))
  result = call_579006.call(path_579007, query_579008, nil, nil, nil)

var gamesConfigurationLeaderboardConfigurationsList* = Call_GamesConfigurationLeaderboardConfigurationsList_578992(
    name: "gamesConfigurationLeaderboardConfigurationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/applications/{applicationId}/leaderboards",
    validator: validate_GamesConfigurationLeaderboardConfigurationsList_578993,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsList_578994,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationImageConfigurationsUpload_579026 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationImageConfigurationsUpload_579028(protocol: Scheme;
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

proc validate_GamesConfigurationImageConfigurationsUpload_579027(path: JsonNode;
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
  var valid_579029 = path.getOrDefault("imageType")
  valid_579029 = validateParameter(valid_579029, JString, required = true,
                                 default = newJString("ACHIEVEMENT_ICON"))
  if valid_579029 != nil:
    section.add "imageType", valid_579029
  var valid_579030 = path.getOrDefault("resourceId")
  valid_579030 = validateParameter(valid_579030, JString, required = true,
                                 default = nil)
  if valid_579030 != nil:
    section.add "resourceId", valid_579030
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
  var valid_579031 = query.getOrDefault("key")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "key", valid_579031
  var valid_579032 = query.getOrDefault("prettyPrint")
  valid_579032 = validateParameter(valid_579032, JBool, required = false,
                                 default = newJBool(true))
  if valid_579032 != nil:
    section.add "prettyPrint", valid_579032
  var valid_579033 = query.getOrDefault("oauth_token")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "oauth_token", valid_579033
  var valid_579034 = query.getOrDefault("alt")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = newJString("json"))
  if valid_579034 != nil:
    section.add "alt", valid_579034
  var valid_579035 = query.getOrDefault("userIp")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "userIp", valid_579035
  var valid_579036 = query.getOrDefault("quotaUser")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "quotaUser", valid_579036
  var valid_579037 = query.getOrDefault("fields")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "fields", valid_579037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579038: Call_GamesConfigurationImageConfigurationsUpload_579026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads an image for a resource with the given ID and image type.
  ## 
  let valid = call_579038.validator(path, query, header, formData, body)
  let scheme = call_579038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579038.url(scheme.get, call_579038.host, call_579038.base,
                         call_579038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579038, url, valid)

proc call*(call_579039: Call_GamesConfigurationImageConfigurationsUpload_579026;
          resourceId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; imageType: string = "ACHIEVEMENT_ICON";
          fields: string = ""): Recallable =
  ## gamesConfigurationImageConfigurationsUpload
  ## Uploads an image for a resource with the given ID and image type.
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
  ##   imageType: string (required)
  ##            : Selects which image in a resource for this method.
  ##   resourceId: string (required)
  ##             : The ID of the resource used by this method.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579040 = newJObject()
  var query_579041 = newJObject()
  add(query_579041, "key", newJString(key))
  add(query_579041, "prettyPrint", newJBool(prettyPrint))
  add(query_579041, "oauth_token", newJString(oauthToken))
  add(query_579041, "alt", newJString(alt))
  add(query_579041, "userIp", newJString(userIp))
  add(query_579041, "quotaUser", newJString(quotaUser))
  add(path_579040, "imageType", newJString(imageType))
  add(path_579040, "resourceId", newJString(resourceId))
  add(query_579041, "fields", newJString(fields))
  result = call_579039.call(path_579040, query_579041, nil, nil, nil)

var gamesConfigurationImageConfigurationsUpload* = Call_GamesConfigurationImageConfigurationsUpload_579026(
    name: "gamesConfigurationImageConfigurationsUpload",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/images/{resourceId}/imageType/{imageType}",
    validator: validate_GamesConfigurationImageConfigurationsUpload_579027,
    base: "/games/v1configuration",
    url: url_GamesConfigurationImageConfigurationsUpload_579028,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsUpdate_579057 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationLeaderboardConfigurationsUpdate_579059(
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

proc validate_GamesConfigurationLeaderboardConfigurationsUpdate_579058(
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
  var valid_579060 = path.getOrDefault("leaderboardId")
  valid_579060 = validateParameter(valid_579060, JString, required = true,
                                 default = nil)
  if valid_579060 != nil:
    section.add "leaderboardId", valid_579060
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
  var valid_579061 = query.getOrDefault("key")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "key", valid_579061
  var valid_579062 = query.getOrDefault("prettyPrint")
  valid_579062 = validateParameter(valid_579062, JBool, required = false,
                                 default = newJBool(true))
  if valid_579062 != nil:
    section.add "prettyPrint", valid_579062
  var valid_579063 = query.getOrDefault("oauth_token")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "oauth_token", valid_579063
  var valid_579064 = query.getOrDefault("alt")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("json"))
  if valid_579064 != nil:
    section.add "alt", valid_579064
  var valid_579065 = query.getOrDefault("userIp")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "userIp", valid_579065
  var valid_579066 = query.getOrDefault("quotaUser")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "quotaUser", valid_579066
  var valid_579067 = query.getOrDefault("fields")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "fields", valid_579067
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

proc call*(call_579069: Call_GamesConfigurationLeaderboardConfigurationsUpdate_579057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the metadata of the leaderboard configuration with the given ID.
  ## 
  let valid = call_579069.validator(path, query, header, formData, body)
  let scheme = call_579069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579069.url(scheme.get, call_579069.host, call_579069.base,
                         call_579069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579069, url, valid)

proc call*(call_579070: Call_GamesConfigurationLeaderboardConfigurationsUpdate_579057;
          leaderboardId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsUpdate
  ## Update the metadata of the leaderboard configuration with the given ID.
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
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard.
  var path_579071 = newJObject()
  var query_579072 = newJObject()
  var body_579073 = newJObject()
  add(query_579072, "key", newJString(key))
  add(query_579072, "prettyPrint", newJBool(prettyPrint))
  add(query_579072, "oauth_token", newJString(oauthToken))
  add(query_579072, "alt", newJString(alt))
  add(query_579072, "userIp", newJString(userIp))
  add(query_579072, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579073 = body
  add(query_579072, "fields", newJString(fields))
  add(path_579071, "leaderboardId", newJString(leaderboardId))
  result = call_579070.call(path_579071, query_579072, nil, nil, body_579073)

var gamesConfigurationLeaderboardConfigurationsUpdate* = Call_GamesConfigurationLeaderboardConfigurationsUpdate_579057(
    name: "gamesConfigurationLeaderboardConfigurationsUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesConfigurationLeaderboardConfigurationsUpdate_579058,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsUpdate_579059,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsGet_579042 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationLeaderboardConfigurationsGet_579044(protocol: Scheme;
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

proc validate_GamesConfigurationLeaderboardConfigurationsGet_579043(
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
  var valid_579045 = path.getOrDefault("leaderboardId")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "leaderboardId", valid_579045
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
  var valid_579046 = query.getOrDefault("key")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "key", valid_579046
  var valid_579047 = query.getOrDefault("prettyPrint")
  valid_579047 = validateParameter(valid_579047, JBool, required = false,
                                 default = newJBool(true))
  if valid_579047 != nil:
    section.add "prettyPrint", valid_579047
  var valid_579048 = query.getOrDefault("oauth_token")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "oauth_token", valid_579048
  var valid_579049 = query.getOrDefault("alt")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = newJString("json"))
  if valid_579049 != nil:
    section.add "alt", valid_579049
  var valid_579050 = query.getOrDefault("userIp")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "userIp", valid_579050
  var valid_579051 = query.getOrDefault("quotaUser")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "quotaUser", valid_579051
  var valid_579052 = query.getOrDefault("fields")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "fields", valid_579052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579053: Call_GamesConfigurationLeaderboardConfigurationsGet_579042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the metadata of the leaderboard configuration with the given ID.
  ## 
  let valid = call_579053.validator(path, query, header, formData, body)
  let scheme = call_579053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579053.url(scheme.get, call_579053.host, call_579053.base,
                         call_579053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579053, url, valid)

proc call*(call_579054: Call_GamesConfigurationLeaderboardConfigurationsGet_579042;
          leaderboardId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsGet
  ## Retrieves the metadata of the leaderboard configuration with the given ID.
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
  var path_579055 = newJObject()
  var query_579056 = newJObject()
  add(query_579056, "key", newJString(key))
  add(query_579056, "prettyPrint", newJBool(prettyPrint))
  add(query_579056, "oauth_token", newJString(oauthToken))
  add(query_579056, "alt", newJString(alt))
  add(query_579056, "userIp", newJString(userIp))
  add(query_579056, "quotaUser", newJString(quotaUser))
  add(query_579056, "fields", newJString(fields))
  add(path_579055, "leaderboardId", newJString(leaderboardId))
  result = call_579054.call(path_579055, query_579056, nil, nil, nil)

var gamesConfigurationLeaderboardConfigurationsGet* = Call_GamesConfigurationLeaderboardConfigurationsGet_579042(
    name: "gamesConfigurationLeaderboardConfigurationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesConfigurationLeaderboardConfigurationsGet_579043,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsGet_579044,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsPatch_579089 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationLeaderboardConfigurationsPatch_579091(
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

proc validate_GamesConfigurationLeaderboardConfigurationsPatch_579090(
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
  var valid_579092 = path.getOrDefault("leaderboardId")
  valid_579092 = validateParameter(valid_579092, JString, required = true,
                                 default = nil)
  if valid_579092 != nil:
    section.add "leaderboardId", valid_579092
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
  var valid_579093 = query.getOrDefault("key")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "key", valid_579093
  var valid_579094 = query.getOrDefault("prettyPrint")
  valid_579094 = validateParameter(valid_579094, JBool, required = false,
                                 default = newJBool(true))
  if valid_579094 != nil:
    section.add "prettyPrint", valid_579094
  var valid_579095 = query.getOrDefault("oauth_token")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "oauth_token", valid_579095
  var valid_579096 = query.getOrDefault("alt")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("json"))
  if valid_579096 != nil:
    section.add "alt", valid_579096
  var valid_579097 = query.getOrDefault("userIp")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "userIp", valid_579097
  var valid_579098 = query.getOrDefault("quotaUser")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "quotaUser", valid_579098
  var valid_579099 = query.getOrDefault("fields")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "fields", valid_579099
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

proc call*(call_579101: Call_GamesConfigurationLeaderboardConfigurationsPatch_579089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the metadata of the leaderboard configuration with the given ID. This method supports patch semantics.
  ## 
  let valid = call_579101.validator(path, query, header, formData, body)
  let scheme = call_579101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579101.url(scheme.get, call_579101.host, call_579101.base,
                         call_579101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579101, url, valid)

proc call*(call_579102: Call_GamesConfigurationLeaderboardConfigurationsPatch_579089;
          leaderboardId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsPatch
  ## Update the metadata of the leaderboard configuration with the given ID. This method supports patch semantics.
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
  ##   leaderboardId: string (required)
  ##                : The ID of the leaderboard.
  var path_579103 = newJObject()
  var query_579104 = newJObject()
  var body_579105 = newJObject()
  add(query_579104, "key", newJString(key))
  add(query_579104, "prettyPrint", newJBool(prettyPrint))
  add(query_579104, "oauth_token", newJString(oauthToken))
  add(query_579104, "alt", newJString(alt))
  add(query_579104, "userIp", newJString(userIp))
  add(query_579104, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579105 = body
  add(query_579104, "fields", newJString(fields))
  add(path_579103, "leaderboardId", newJString(leaderboardId))
  result = call_579102.call(path_579103, query_579104, nil, nil, body_579105)

var gamesConfigurationLeaderboardConfigurationsPatch* = Call_GamesConfigurationLeaderboardConfigurationsPatch_579089(
    name: "gamesConfigurationLeaderboardConfigurationsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesConfigurationLeaderboardConfigurationsPatch_579090,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsPatch_579091,
    schemes: {Scheme.Https})
type
  Call_GamesConfigurationLeaderboardConfigurationsDelete_579074 = ref object of OpenApiRestCall_578355
proc url_GamesConfigurationLeaderboardConfigurationsDelete_579076(
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

proc validate_GamesConfigurationLeaderboardConfigurationsDelete_579075(
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
  var valid_579077 = path.getOrDefault("leaderboardId")
  valid_579077 = validateParameter(valid_579077, JString, required = true,
                                 default = nil)
  if valid_579077 != nil:
    section.add "leaderboardId", valid_579077
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
  var valid_579078 = query.getOrDefault("key")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "key", valid_579078
  var valid_579079 = query.getOrDefault("prettyPrint")
  valid_579079 = validateParameter(valid_579079, JBool, required = false,
                                 default = newJBool(true))
  if valid_579079 != nil:
    section.add "prettyPrint", valid_579079
  var valid_579080 = query.getOrDefault("oauth_token")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "oauth_token", valid_579080
  var valid_579081 = query.getOrDefault("alt")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = newJString("json"))
  if valid_579081 != nil:
    section.add "alt", valid_579081
  var valid_579082 = query.getOrDefault("userIp")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "userIp", valid_579082
  var valid_579083 = query.getOrDefault("quotaUser")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "quotaUser", valid_579083
  var valid_579084 = query.getOrDefault("fields")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "fields", valid_579084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579085: Call_GamesConfigurationLeaderboardConfigurationsDelete_579074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the leaderboard configuration with the given ID.
  ## 
  let valid = call_579085.validator(path, query, header, formData, body)
  let scheme = call_579085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579085.url(scheme.get, call_579085.host, call_579085.base,
                         call_579085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579085, url, valid)

proc call*(call_579086: Call_GamesConfigurationLeaderboardConfigurationsDelete_579074;
          leaderboardId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## gamesConfigurationLeaderboardConfigurationsDelete
  ## Delete the leaderboard configuration with the given ID.
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
  var path_579087 = newJObject()
  var query_579088 = newJObject()
  add(query_579088, "key", newJString(key))
  add(query_579088, "prettyPrint", newJBool(prettyPrint))
  add(query_579088, "oauth_token", newJString(oauthToken))
  add(query_579088, "alt", newJString(alt))
  add(query_579088, "userIp", newJString(userIp))
  add(query_579088, "quotaUser", newJString(quotaUser))
  add(query_579088, "fields", newJString(fields))
  add(path_579087, "leaderboardId", newJString(leaderboardId))
  result = call_579086.call(path_579087, query_579088, nil, nil, nil)

var gamesConfigurationLeaderboardConfigurationsDelete* = Call_GamesConfigurationLeaderboardConfigurationsDelete_579074(
    name: "gamesConfigurationLeaderboardConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/leaderboards/{leaderboardId}",
    validator: validate_GamesConfigurationLeaderboardConfigurationsDelete_579075,
    base: "/games/v1configuration",
    url: url_GamesConfigurationLeaderboardConfigurationsDelete_579076,
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
