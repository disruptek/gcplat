
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppstateStatesList_597692 = ref object of OpenApiRestCall_597424
proc url_AppstateStatesList_597694(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AppstateStatesList_597693(path: JsonNode; query: JsonNode;
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
  var valid_597806 = query.getOrDefault("fields")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "fields", valid_597806
  var valid_597807 = query.getOrDefault("quotaUser")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "quotaUser", valid_597807
  var valid_597821 = query.getOrDefault("alt")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = newJString("json"))
  if valid_597821 != nil:
    section.add "alt", valid_597821
  var valid_597822 = query.getOrDefault("oauth_token")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = nil)
  if valid_597822 != nil:
    section.add "oauth_token", valid_597822
  var valid_597823 = query.getOrDefault("userIp")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "userIp", valid_597823
  var valid_597824 = query.getOrDefault("key")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "key", valid_597824
  var valid_597825 = query.getOrDefault("prettyPrint")
  valid_597825 = validateParameter(valid_597825, JBool, required = false,
                                 default = newJBool(true))
  if valid_597825 != nil:
    section.add "prettyPrint", valid_597825
  var valid_597826 = query.getOrDefault("includeData")
  valid_597826 = validateParameter(valid_597826, JBool, required = false,
                                 default = newJBool(false))
  if valid_597826 != nil:
    section.add "includeData", valid_597826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597849: Call_AppstateStatesList_597692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the states keys, and optionally the state data.
  ## 
  let valid = call_597849.validator(path, query, header, formData, body)
  let scheme = call_597849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597849.url(scheme.get, call_597849.host, call_597849.base,
                         call_597849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597849, url, valid)

proc call*(call_597920: Call_AppstateStatesList_597692; fields: string = "";
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
  var query_597921 = newJObject()
  add(query_597921, "fields", newJString(fields))
  add(query_597921, "quotaUser", newJString(quotaUser))
  add(query_597921, "alt", newJString(alt))
  add(query_597921, "oauth_token", newJString(oauthToken))
  add(query_597921, "userIp", newJString(userIp))
  add(query_597921, "key", newJString(key))
  add(query_597921, "prettyPrint", newJBool(prettyPrint))
  add(query_597921, "includeData", newJBool(includeData))
  result = call_597920.call(nil, query_597921, nil, nil, nil)

var appstateStatesList* = Call_AppstateStatesList_597692(
    name: "appstateStatesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/states",
    validator: validate_AppstateStatesList_597693, base: "/appstate/v1",
    url: url_AppstateStatesList_597694, schemes: {Scheme.Https})
type
  Call_AppstateStatesUpdate_597990 = ref object of OpenApiRestCall_597424
proc url_AppstateStatesUpdate_597992(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "stateKey" in path, "`stateKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/states/"),
               (kind: VariableSegment, value: "stateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppstateStatesUpdate_597991(path: JsonNode; query: JsonNode;
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
  var valid_597993 = path.getOrDefault("stateKey")
  valid_597993 = validateParameter(valid_597993, JInt, required = true, default = nil)
  if valid_597993 != nil:
    section.add "stateKey", valid_597993
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
  var valid_597994 = query.getOrDefault("fields")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "fields", valid_597994
  var valid_597995 = query.getOrDefault("quotaUser")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "quotaUser", valid_597995
  var valid_597996 = query.getOrDefault("alt")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = newJString("json"))
  if valid_597996 != nil:
    section.add "alt", valid_597996
  var valid_597997 = query.getOrDefault("oauth_token")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "oauth_token", valid_597997
  var valid_597998 = query.getOrDefault("userIp")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "userIp", valid_597998
  var valid_597999 = query.getOrDefault("currentStateVersion")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "currentStateVersion", valid_597999
  var valid_598000 = query.getOrDefault("key")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "key", valid_598000
  var valid_598001 = query.getOrDefault("prettyPrint")
  valid_598001 = validateParameter(valid_598001, JBool, required = false,
                                 default = newJBool(true))
  if valid_598001 != nil:
    section.add "prettyPrint", valid_598001
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

proc call*(call_598003: Call_AppstateStatesUpdate_597990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the data associated with the input key if and only if the passed version matches the currently stored version. This method is safe in the face of concurrent writes. Maximum per-key size is 128KB.
  ## 
  let valid = call_598003.validator(path, query, header, formData, body)
  let scheme = call_598003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598003.url(scheme.get, call_598003.host, call_598003.base,
                         call_598003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598003, url, valid)

proc call*(call_598004: Call_AppstateStatesUpdate_597990; stateKey: int;
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
  var path_598005 = newJObject()
  var query_598006 = newJObject()
  var body_598007 = newJObject()
  add(query_598006, "fields", newJString(fields))
  add(query_598006, "quotaUser", newJString(quotaUser))
  add(query_598006, "alt", newJString(alt))
  add(query_598006, "oauth_token", newJString(oauthToken))
  add(query_598006, "userIp", newJString(userIp))
  add(query_598006, "currentStateVersion", newJString(currentStateVersion))
  add(query_598006, "key", newJString(key))
  add(path_598005, "stateKey", newJInt(stateKey))
  if body != nil:
    body_598007 = body
  add(query_598006, "prettyPrint", newJBool(prettyPrint))
  result = call_598004.call(path_598005, query_598006, nil, nil, body_598007)

var appstateStatesUpdate* = Call_AppstateStatesUpdate_597990(
    name: "appstateStatesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/states/{stateKey}",
    validator: validate_AppstateStatesUpdate_597991, base: "/appstate/v1",
    url: url_AppstateStatesUpdate_597992, schemes: {Scheme.Https})
type
  Call_AppstateStatesGet_597961 = ref object of OpenApiRestCall_597424
proc url_AppstateStatesGet_597963(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "stateKey" in path, "`stateKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/states/"),
               (kind: VariableSegment, value: "stateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppstateStatesGet_597962(path: JsonNode; query: JsonNode;
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
  var valid_597978 = path.getOrDefault("stateKey")
  valid_597978 = validateParameter(valid_597978, JInt, required = true, default = nil)
  if valid_597978 != nil:
    section.add "stateKey", valid_597978
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
  var valid_597979 = query.getOrDefault("fields")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "fields", valid_597979
  var valid_597980 = query.getOrDefault("quotaUser")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "quotaUser", valid_597980
  var valid_597981 = query.getOrDefault("alt")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = newJString("json"))
  if valid_597981 != nil:
    section.add "alt", valid_597981
  var valid_597982 = query.getOrDefault("oauth_token")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "oauth_token", valid_597982
  var valid_597983 = query.getOrDefault("userIp")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "userIp", valid_597983
  var valid_597984 = query.getOrDefault("key")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "key", valid_597984
  var valid_597985 = query.getOrDefault("prettyPrint")
  valid_597985 = validateParameter(valid_597985, JBool, required = false,
                                 default = newJBool(true))
  if valid_597985 != nil:
    section.add "prettyPrint", valid_597985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597986: Call_AppstateStatesGet_597961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the data corresponding to the passed key. If the key does not exist on the server, an HTTP 404 will be returned.
  ## 
  let valid = call_597986.validator(path, query, header, formData, body)
  let scheme = call_597986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597986.url(scheme.get, call_597986.host, call_597986.base,
                         call_597986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597986, url, valid)

proc call*(call_597987: Call_AppstateStatesGet_597961; stateKey: int;
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
  var path_597988 = newJObject()
  var query_597989 = newJObject()
  add(query_597989, "fields", newJString(fields))
  add(query_597989, "quotaUser", newJString(quotaUser))
  add(query_597989, "alt", newJString(alt))
  add(query_597989, "oauth_token", newJString(oauthToken))
  add(query_597989, "userIp", newJString(userIp))
  add(query_597989, "key", newJString(key))
  add(path_597988, "stateKey", newJInt(stateKey))
  add(query_597989, "prettyPrint", newJBool(prettyPrint))
  result = call_597987.call(path_597988, query_597989, nil, nil, nil)

var appstateStatesGet* = Call_AppstateStatesGet_597961(name: "appstateStatesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/states/{stateKey}", validator: validate_AppstateStatesGet_597962,
    base: "/appstate/v1", url: url_AppstateStatesGet_597963, schemes: {Scheme.Https})
type
  Call_AppstateStatesDelete_598008 = ref object of OpenApiRestCall_597424
proc url_AppstateStatesDelete_598010(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "stateKey" in path, "`stateKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/states/"),
               (kind: VariableSegment, value: "stateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppstateStatesDelete_598009(path: JsonNode; query: JsonNode;
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
  var valid_598011 = path.getOrDefault("stateKey")
  valid_598011 = validateParameter(valid_598011, JInt, required = true, default = nil)
  if valid_598011 != nil:
    section.add "stateKey", valid_598011
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
  var valid_598012 = query.getOrDefault("fields")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "fields", valid_598012
  var valid_598013 = query.getOrDefault("quotaUser")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "quotaUser", valid_598013
  var valid_598014 = query.getOrDefault("alt")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("json"))
  if valid_598014 != nil:
    section.add "alt", valid_598014
  var valid_598015 = query.getOrDefault("oauth_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "oauth_token", valid_598015
  var valid_598016 = query.getOrDefault("userIp")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "userIp", valid_598016
  var valid_598017 = query.getOrDefault("key")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "key", valid_598017
  var valid_598018 = query.getOrDefault("prettyPrint")
  valid_598018 = validateParameter(valid_598018, JBool, required = false,
                                 default = newJBool(true))
  if valid_598018 != nil:
    section.add "prettyPrint", valid_598018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598019: Call_AppstateStatesDelete_598008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a key and the data associated with it. The key is removed and no longer counts against the key quota. Note that since this method is not safe in the face of concurrent modifications, it should only be used for development and testing purposes. Invoking this method in shipping code can result in data loss and data corruption.
  ## 
  let valid = call_598019.validator(path, query, header, formData, body)
  let scheme = call_598019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598019.url(scheme.get, call_598019.host, call_598019.base,
                         call_598019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598019, url, valid)

proc call*(call_598020: Call_AppstateStatesDelete_598008; stateKey: int;
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
  var path_598021 = newJObject()
  var query_598022 = newJObject()
  add(query_598022, "fields", newJString(fields))
  add(query_598022, "quotaUser", newJString(quotaUser))
  add(query_598022, "alt", newJString(alt))
  add(query_598022, "oauth_token", newJString(oauthToken))
  add(query_598022, "userIp", newJString(userIp))
  add(query_598022, "key", newJString(key))
  add(path_598021, "stateKey", newJInt(stateKey))
  add(query_598022, "prettyPrint", newJBool(prettyPrint))
  result = call_598020.call(path_598021, query_598022, nil, nil, nil)

var appstateStatesDelete* = Call_AppstateStatesDelete_598008(
    name: "appstateStatesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/states/{stateKey}",
    validator: validate_AppstateStatesDelete_598009, base: "/appstate/v1",
    url: url_AppstateStatesDelete_598010, schemes: {Scheme.Https})
type
  Call_AppstateStatesClear_598023 = ref object of OpenApiRestCall_597424
proc url_AppstateStatesClear_598025(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AppstateStatesClear_598024(path: JsonNode; query: JsonNode;
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
  var valid_598026 = path.getOrDefault("stateKey")
  valid_598026 = validateParameter(valid_598026, JInt, required = true, default = nil)
  if valid_598026 != nil:
    section.add "stateKey", valid_598026
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
  var valid_598027 = query.getOrDefault("fields")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "fields", valid_598027
  var valid_598028 = query.getOrDefault("currentDataVersion")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "currentDataVersion", valid_598028
  var valid_598029 = query.getOrDefault("quotaUser")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "quotaUser", valid_598029
  var valid_598030 = query.getOrDefault("alt")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = newJString("json"))
  if valid_598030 != nil:
    section.add "alt", valid_598030
  var valid_598031 = query.getOrDefault("oauth_token")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "oauth_token", valid_598031
  var valid_598032 = query.getOrDefault("userIp")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "userIp", valid_598032
  var valid_598033 = query.getOrDefault("key")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "key", valid_598033
  var valid_598034 = query.getOrDefault("prettyPrint")
  valid_598034 = validateParameter(valid_598034, JBool, required = false,
                                 default = newJBool(true))
  if valid_598034 != nil:
    section.add "prettyPrint", valid_598034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598035: Call_AppstateStatesClear_598023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears (sets to empty) the data for the passed key if and only if the passed version matches the currently stored version. This method results in a conflict error on version mismatch.
  ## 
  let valid = call_598035.validator(path, query, header, formData, body)
  let scheme = call_598035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598035.url(scheme.get, call_598035.host, call_598035.base,
                         call_598035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598035, url, valid)

proc call*(call_598036: Call_AppstateStatesClear_598023; stateKey: int;
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
  var path_598037 = newJObject()
  var query_598038 = newJObject()
  add(query_598038, "fields", newJString(fields))
  add(query_598038, "currentDataVersion", newJString(currentDataVersion))
  add(query_598038, "quotaUser", newJString(quotaUser))
  add(query_598038, "alt", newJString(alt))
  add(query_598038, "oauth_token", newJString(oauthToken))
  add(query_598038, "userIp", newJString(userIp))
  add(query_598038, "key", newJString(key))
  add(path_598037, "stateKey", newJInt(stateKey))
  add(query_598038, "prettyPrint", newJBool(prettyPrint))
  result = call_598036.call(path_598037, query_598038, nil, nil, nil)

var appstateStatesClear* = Call_AppstateStatesClear_598023(
    name: "appstateStatesClear", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/states/{stateKey}/clear",
    validator: validate_AppstateStatesClear_598024, base: "/appstate/v1",
    url: url_AppstateStatesClear_598025, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
