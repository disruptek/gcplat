
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google App State
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Google App State API.
## 
## https://developers.google.com/games/services/web/api/states
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
  gcpServiceName = "appstate"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppstateStatesList_579692 = ref object of OpenApiRestCall_579424
proc url_AppstateStatesList_579694(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AppstateStatesList_579693(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all the states keys, and optionally the state data.
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
  ##   includeData: JBool
  ##              : Whether to include the full data in addition to the version number
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
  var valid_579826 = query.getOrDefault("includeData")
  valid_579826 = validateParameter(valid_579826, JBool, required = false,
                                 default = newJBool(false))
  if valid_579826 != nil:
    section.add "includeData", valid_579826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579849: Call_AppstateStatesList_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the states keys, and optionally the state data.
  ## 
  let valid = call_579849.validator(path, query, header, formData, body)
  let scheme = call_579849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579849.url(scheme.get, call_579849.host, call_579849.base,
                         call_579849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579849, url, valid)

proc call*(call_579920: Call_AppstateStatesList_579692; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          includeData: bool = false): Recallable =
  ## appstateStatesList
  ## Lists all the states keys, and optionally the state data.
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
  ##   includeData: bool
  ##              : Whether to include the full data in addition to the version number
  var query_579921 = newJObject()
  add(query_579921, "fields", newJString(fields))
  add(query_579921, "quotaUser", newJString(quotaUser))
  add(query_579921, "alt", newJString(alt))
  add(query_579921, "oauth_token", newJString(oauthToken))
  add(query_579921, "userIp", newJString(userIp))
  add(query_579921, "key", newJString(key))
  add(query_579921, "prettyPrint", newJBool(prettyPrint))
  add(query_579921, "includeData", newJBool(includeData))
  result = call_579920.call(nil, query_579921, nil, nil, nil)

var appstateStatesList* = Call_AppstateStatesList_579692(
    name: "appstateStatesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/states",
    validator: validate_AppstateStatesList_579693, base: "/appstate/v1",
    url: url_AppstateStatesList_579694, schemes: {Scheme.Https})
type
  Call_AppstateStatesUpdate_579990 = ref object of OpenApiRestCall_579424
proc url_AppstateStatesUpdate_579992(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "stateKey" in path, "`stateKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/states/"),
               (kind: VariableSegment, value: "stateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppstateStatesUpdate_579991(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the data associated with the input key if and only if the passed version matches the currently stored version. This method is safe in the face of concurrent writes. Maximum per-key size is 128KB.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stateKey: JInt (required)
  ##           : The key for the data to be retrieved.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stateKey` field"
  var valid_579993 = path.getOrDefault("stateKey")
  valid_579993 = validateParameter(valid_579993, JInt, required = true, default = nil)
  if valid_579993 != nil:
    section.add "stateKey", valid_579993
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
  ##   currentStateVersion: JString
  ##                      : The version of the app state your application is attempting to update. If this does not match the current version, this method will return a conflict error. If there is no data stored on the server for this key, the update will succeed irrespective of the value of this parameter.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
  var valid_579995 = query.getOrDefault("quotaUser")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "quotaUser", valid_579995
  var valid_579996 = query.getOrDefault("alt")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("json"))
  if valid_579996 != nil:
    section.add "alt", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("userIp")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "userIp", valid_579998
  var valid_579999 = query.getOrDefault("currentStateVersion")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "currentStateVersion", valid_579999
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("prettyPrint")
  valid_580001 = validateParameter(valid_580001, JBool, required = false,
                                 default = newJBool(true))
  if valid_580001 != nil:
    section.add "prettyPrint", valid_580001
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

proc call*(call_580003: Call_AppstateStatesUpdate_579990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the data associated with the input key if and only if the passed version matches the currently stored version. This method is safe in the face of concurrent writes. Maximum per-key size is 128KB.
  ## 
  let valid = call_580003.validator(path, query, header, formData, body)
  let scheme = call_580003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580003.url(scheme.get, call_580003.host, call_580003.base,
                         call_580003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580003, url, valid)

proc call*(call_580004: Call_AppstateStatesUpdate_579990; stateKey: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = "";
          currentStateVersion: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## appstateStatesUpdate
  ## Update the data associated with the input key if and only if the passed version matches the currently stored version. This method is safe in the face of concurrent writes. Maximum per-key size is 128KB.
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
  ##   currentStateVersion: string
  ##                      : The version of the app state your application is attempting to update. If this does not match the current version, this method will return a conflict error. If there is no data stored on the server for this key, the update will succeed irrespective of the value of this parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   stateKey: int (required)
  ##           : The key for the data to be retrieved.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580005 = newJObject()
  var query_580006 = newJObject()
  var body_580007 = newJObject()
  add(query_580006, "fields", newJString(fields))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(query_580006, "alt", newJString(alt))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "userIp", newJString(userIp))
  add(query_580006, "currentStateVersion", newJString(currentStateVersion))
  add(query_580006, "key", newJString(key))
  add(path_580005, "stateKey", newJInt(stateKey))
  if body != nil:
    body_580007 = body
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  result = call_580004.call(path_580005, query_580006, nil, nil, body_580007)

var appstateStatesUpdate* = Call_AppstateStatesUpdate_579990(
    name: "appstateStatesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/states/{stateKey}",
    validator: validate_AppstateStatesUpdate_579991, base: "/appstate/v1",
    url: url_AppstateStatesUpdate_579992, schemes: {Scheme.Https})
type
  Call_AppstateStatesGet_579961 = ref object of OpenApiRestCall_579424
proc url_AppstateStatesGet_579963(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "stateKey" in path, "`stateKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/states/"),
               (kind: VariableSegment, value: "stateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppstateStatesGet_579962(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves the data corresponding to the passed key. If the key does not exist on the server, an HTTP 404 will be returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stateKey: JInt (required)
  ##           : The key for the data to be retrieved.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stateKey` field"
  var valid_579978 = path.getOrDefault("stateKey")
  valid_579978 = validateParameter(valid_579978, JInt, required = true, default = nil)
  if valid_579978 != nil:
    section.add "stateKey", valid_579978
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
  var valid_579982 = query.getOrDefault("oauth_token")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "oauth_token", valid_579982
  var valid_579983 = query.getOrDefault("userIp")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "userIp", valid_579983
  var valid_579984 = query.getOrDefault("key")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "key", valid_579984
  var valid_579985 = query.getOrDefault("prettyPrint")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "prettyPrint", valid_579985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579986: Call_AppstateStatesGet_579961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the data corresponding to the passed key. If the key does not exist on the server, an HTTP 404 will be returned.
  ## 
  let valid = call_579986.validator(path, query, header, formData, body)
  let scheme = call_579986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579986.url(scheme.get, call_579986.host, call_579986.base,
                         call_579986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579986, url, valid)

proc call*(call_579987: Call_AppstateStatesGet_579961; stateKey: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## appstateStatesGet
  ## Retrieves the data corresponding to the passed key. If the key does not exist on the server, an HTTP 404 will be returned.
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
  ##   stateKey: int (required)
  ##           : The key for the data to be retrieved.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579988 = newJObject()
  var query_579989 = newJObject()
  add(query_579989, "fields", newJString(fields))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(query_579989, "userIp", newJString(userIp))
  add(query_579989, "key", newJString(key))
  add(path_579988, "stateKey", newJInt(stateKey))
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  result = call_579987.call(path_579988, query_579989, nil, nil, nil)

var appstateStatesGet* = Call_AppstateStatesGet_579961(name: "appstateStatesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/states/{stateKey}", validator: validate_AppstateStatesGet_579962,
    base: "/appstate/v1", url: url_AppstateStatesGet_579963, schemes: {Scheme.Https})
type
  Call_AppstateStatesDelete_580008 = ref object of OpenApiRestCall_579424
proc url_AppstateStatesDelete_580010(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "stateKey" in path, "`stateKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/states/"),
               (kind: VariableSegment, value: "stateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppstateStatesDelete_580009(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a key and the data associated with it. The key is removed and no longer counts against the key quota. Note that since this method is not safe in the face of concurrent modifications, it should only be used for development and testing purposes. Invoking this method in shipping code can result in data loss and data corruption.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stateKey: JInt (required)
  ##           : The key for the data to be retrieved.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stateKey` field"
  var valid_580011 = path.getOrDefault("stateKey")
  valid_580011 = validateParameter(valid_580011, JInt, required = true, default = nil)
  if valid_580011 != nil:
    section.add "stateKey", valid_580011
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
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("userIp")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userIp", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
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

proc call*(call_580019: Call_AppstateStatesDelete_580008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a key and the data associated with it. The key is removed and no longer counts against the key quota. Note that since this method is not safe in the face of concurrent modifications, it should only be used for development and testing purposes. Invoking this method in shipping code can result in data loss and data corruption.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_AppstateStatesDelete_580008; stateKey: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## appstateStatesDelete
  ## Deletes a key and the data associated with it. The key is removed and no longer counts against the key quota. Note that since this method is not safe in the face of concurrent modifications, it should only be used for development and testing purposes. Invoking this method in shipping code can result in data loss and data corruption.
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
  ##   stateKey: int (required)
  ##           : The key for the data to be retrieved.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "userIp", newJString(userIp))
  add(query_580022, "key", newJString(key))
  add(path_580021, "stateKey", newJInt(stateKey))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var appstateStatesDelete* = Call_AppstateStatesDelete_580008(
    name: "appstateStatesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/states/{stateKey}",
    validator: validate_AppstateStatesDelete_580009, base: "/appstate/v1",
    url: url_AppstateStatesDelete_580010, schemes: {Scheme.Https})
type
  Call_AppstateStatesClear_580023 = ref object of OpenApiRestCall_579424
proc url_AppstateStatesClear_580025(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "stateKey" in path, "`stateKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/states/"),
               (kind: VariableSegment, value: "stateKey"),
               (kind: ConstantSegment, value: "/clear")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppstateStatesClear_580024(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Clears (sets to empty) the data for the passed key if and only if the passed version matches the currently stored version. This method results in a conflict error on version mismatch.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   stateKey: JInt (required)
  ##           : The key for the data to be retrieved.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `stateKey` field"
  var valid_580026 = path.getOrDefault("stateKey")
  valid_580026 = validateParameter(valid_580026, JInt, required = true, default = nil)
  if valid_580026 != nil:
    section.add "stateKey", valid_580026
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   currentDataVersion: JString
  ##                     : The version of the data to be cleared. Version strings are returned by the server.
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
  var valid_580028 = query.getOrDefault("currentDataVersion")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "currentDataVersion", valid_580028
  var valid_580029 = query.getOrDefault("quotaUser")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "quotaUser", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("oauth_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "oauth_token", valid_580031
  var valid_580032 = query.getOrDefault("userIp")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "userIp", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580035: Call_AppstateStatesClear_580023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears (sets to empty) the data for the passed key if and only if the passed version matches the currently stored version. This method results in a conflict error on version mismatch.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_AppstateStatesClear_580023; stateKey: int;
          fields: string = ""; currentDataVersion: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## appstateStatesClear
  ## Clears (sets to empty) the data for the passed key if and only if the passed version matches the currently stored version. This method results in a conflict error on version mismatch.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   currentDataVersion: string
  ##                     : The version of the data to be cleared. Version strings are returned by the server.
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
  ##   stateKey: int (required)
  ##           : The key for the data to be retrieved.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  add(query_580038, "fields", newJString(fields))
  add(query_580038, "currentDataVersion", newJString(currentDataVersion))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "alt", newJString(alt))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "userIp", newJString(userIp))
  add(query_580038, "key", newJString(key))
  add(path_580037, "stateKey", newJInt(stateKey))
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  result = call_580036.call(path_580037, query_580038, nil, nil, nil)

var appstateStatesClear* = Call_AppstateStatesClear_580023(
    name: "appstateStatesClear", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/states/{stateKey}/clear",
    validator: validate_AppstateStatesClear_580024, base: "/appstate/v1",
    url: url_AppstateStatesClear_580025, schemes: {Scheme.Https})
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
