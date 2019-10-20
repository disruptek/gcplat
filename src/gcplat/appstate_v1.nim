
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
  gcpServiceName = "appstate"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppstateStatesList_578625 = ref object of OpenApiRestCall_578355
proc url_AppstateStatesList_578627(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AppstateStatesList_578626(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all the states keys, and optionally the state data.
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
  ##   includeData: JBool
  ##              : Whether to include the full data in addition to the version number
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
  var valid_578758 = query.getOrDefault("includeData")
  valid_578758 = validateParameter(valid_578758, JBool, required = false,
                                 default = newJBool(false))
  if valid_578758 != nil:
    section.add "includeData", valid_578758
  var valid_578759 = query.getOrDefault("fields")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "fields", valid_578759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578782: Call_AppstateStatesList_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the states keys, and optionally the state data.
  ## 
  let valid = call_578782.validator(path, query, header, formData, body)
  let scheme = call_578782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578782.url(scheme.get, call_578782.host, call_578782.base,
                         call_578782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578782, url, valid)

proc call*(call_578853: Call_AppstateStatesList_578625; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; includeData: bool = false;
          fields: string = ""): Recallable =
  ## appstateStatesList
  ## Lists all the states keys, and optionally the state data.
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
  ##   includeData: bool
  ##              : Whether to include the full data in addition to the version number
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578854 = newJObject()
  add(query_578854, "key", newJString(key))
  add(query_578854, "prettyPrint", newJBool(prettyPrint))
  add(query_578854, "oauth_token", newJString(oauthToken))
  add(query_578854, "alt", newJString(alt))
  add(query_578854, "userIp", newJString(userIp))
  add(query_578854, "quotaUser", newJString(quotaUser))
  add(query_578854, "includeData", newJBool(includeData))
  add(query_578854, "fields", newJString(fields))
  result = call_578853.call(nil, query_578854, nil, nil, nil)

var appstateStatesList* = Call_AppstateStatesList_578625(
    name: "appstateStatesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/states",
    validator: validate_AppstateStatesList_578626, base: "/appstate/v1",
    url: url_AppstateStatesList_578627, schemes: {Scheme.Https})
type
  Call_AppstateStatesUpdate_578923 = ref object of OpenApiRestCall_578355
proc url_AppstateStatesUpdate_578925(protocol: Scheme; host: string; base: string;
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

proc validate_AppstateStatesUpdate_578924(path: JsonNode; query: JsonNode;
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
  var valid_578926 = path.getOrDefault("stateKey")
  valid_578926 = validateParameter(valid_578926, JInt, required = true, default = nil)
  if valid_578926 != nil:
    section.add "stateKey", valid_578926
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
  ##   currentStateVersion: JString
  ##                      : The version of the app state your application is attempting to update. If this does not match the current version, this method will return a conflict error. If there is no data stored on the server for this key, the update will succeed irrespective of the value of this parameter.
  section = newJObject()
  var valid_578927 = query.getOrDefault("key")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "key", valid_578927
  var valid_578928 = query.getOrDefault("prettyPrint")
  valid_578928 = validateParameter(valid_578928, JBool, required = false,
                                 default = newJBool(true))
  if valid_578928 != nil:
    section.add "prettyPrint", valid_578928
  var valid_578929 = query.getOrDefault("oauth_token")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "oauth_token", valid_578929
  var valid_578930 = query.getOrDefault("alt")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("json"))
  if valid_578930 != nil:
    section.add "alt", valid_578930
  var valid_578931 = query.getOrDefault("userIp")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "userIp", valid_578931
  var valid_578932 = query.getOrDefault("quotaUser")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "quotaUser", valid_578932
  var valid_578933 = query.getOrDefault("fields")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "fields", valid_578933
  var valid_578934 = query.getOrDefault("currentStateVersion")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "currentStateVersion", valid_578934
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

proc call*(call_578936: Call_AppstateStatesUpdate_578923; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the data associated with the input key if and only if the passed version matches the currently stored version. This method is safe in the face of concurrent writes. Maximum per-key size is 128KB.
  ## 
  let valid = call_578936.validator(path, query, header, formData, body)
  let scheme = call_578936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578936.url(scheme.get, call_578936.host, call_578936.base,
                         call_578936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578936, url, valid)

proc call*(call_578937: Call_AppstateStatesUpdate_578923; stateKey: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""; currentStateVersion: string = ""): Recallable =
  ## appstateStatesUpdate
  ## Update the data associated with the input key if and only if the passed version matches the currently stored version. This method is safe in the face of concurrent writes. Maximum per-key size is 128KB.
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
  ##   stateKey: int (required)
  ##           : The key for the data to be retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   currentStateVersion: string
  ##                      : The version of the app state your application is attempting to update. If this does not match the current version, this method will return a conflict error. If there is no data stored on the server for this key, the update will succeed irrespective of the value of this parameter.
  var path_578938 = newJObject()
  var query_578939 = newJObject()
  var body_578940 = newJObject()
  add(query_578939, "key", newJString(key))
  add(query_578939, "prettyPrint", newJBool(prettyPrint))
  add(query_578939, "oauth_token", newJString(oauthToken))
  add(query_578939, "alt", newJString(alt))
  add(query_578939, "userIp", newJString(userIp))
  add(query_578939, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578940 = body
  add(path_578938, "stateKey", newJInt(stateKey))
  add(query_578939, "fields", newJString(fields))
  add(query_578939, "currentStateVersion", newJString(currentStateVersion))
  result = call_578937.call(path_578938, query_578939, nil, nil, body_578940)

var appstateStatesUpdate* = Call_AppstateStatesUpdate_578923(
    name: "appstateStatesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/states/{stateKey}",
    validator: validate_AppstateStatesUpdate_578924, base: "/appstate/v1",
    url: url_AppstateStatesUpdate_578925, schemes: {Scheme.Https})
type
  Call_AppstateStatesGet_578894 = ref object of OpenApiRestCall_578355
proc url_AppstateStatesGet_578896(protocol: Scheme; host: string; base: string;
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

proc validate_AppstateStatesGet_578895(path: JsonNode; query: JsonNode;
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
  var valid_578911 = path.getOrDefault("stateKey")
  valid_578911 = validateParameter(valid_578911, JInt, required = true, default = nil)
  if valid_578911 != nil:
    section.add "stateKey", valid_578911
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
  var valid_578912 = query.getOrDefault("key")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "key", valid_578912
  var valid_578913 = query.getOrDefault("prettyPrint")
  valid_578913 = validateParameter(valid_578913, JBool, required = false,
                                 default = newJBool(true))
  if valid_578913 != nil:
    section.add "prettyPrint", valid_578913
  var valid_578914 = query.getOrDefault("oauth_token")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "oauth_token", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("userIp")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "userIp", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("fields")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "fields", valid_578918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578919: Call_AppstateStatesGet_578894; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the data corresponding to the passed key. If the key does not exist on the server, an HTTP 404 will be returned.
  ## 
  let valid = call_578919.validator(path, query, header, formData, body)
  let scheme = call_578919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578919.url(scheme.get, call_578919.host, call_578919.base,
                         call_578919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578919, url, valid)

proc call*(call_578920: Call_AppstateStatesGet_578894; stateKey: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## appstateStatesGet
  ## Retrieves the data corresponding to the passed key. If the key does not exist on the server, an HTTP 404 will be returned.
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
  ##   stateKey: int (required)
  ##           : The key for the data to be retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578921 = newJObject()
  var query_578922 = newJObject()
  add(query_578922, "key", newJString(key))
  add(query_578922, "prettyPrint", newJBool(prettyPrint))
  add(query_578922, "oauth_token", newJString(oauthToken))
  add(query_578922, "alt", newJString(alt))
  add(query_578922, "userIp", newJString(userIp))
  add(query_578922, "quotaUser", newJString(quotaUser))
  add(path_578921, "stateKey", newJInt(stateKey))
  add(query_578922, "fields", newJString(fields))
  result = call_578920.call(path_578921, query_578922, nil, nil, nil)

var appstateStatesGet* = Call_AppstateStatesGet_578894(name: "appstateStatesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/states/{stateKey}", validator: validate_AppstateStatesGet_578895,
    base: "/appstate/v1", url: url_AppstateStatesGet_578896, schemes: {Scheme.Https})
type
  Call_AppstateStatesDelete_578941 = ref object of OpenApiRestCall_578355
proc url_AppstateStatesDelete_578943(protocol: Scheme; host: string; base: string;
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

proc validate_AppstateStatesDelete_578942(path: JsonNode; query: JsonNode;
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
  var valid_578944 = path.getOrDefault("stateKey")
  valid_578944 = validateParameter(valid_578944, JInt, required = true, default = nil)
  if valid_578944 != nil:
    section.add "stateKey", valid_578944
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
  if body != nil:
    result.add "body", body

proc call*(call_578952: Call_AppstateStatesDelete_578941; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a key and the data associated with it. The key is removed and no longer counts against the key quota. Note that since this method is not safe in the face of concurrent modifications, it should only be used for development and testing purposes. Invoking this method in shipping code can result in data loss and data corruption.
  ## 
  let valid = call_578952.validator(path, query, header, formData, body)
  let scheme = call_578952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578952.url(scheme.get, call_578952.host, call_578952.base,
                         call_578952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578952, url, valid)

proc call*(call_578953: Call_AppstateStatesDelete_578941; stateKey: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## appstateStatesDelete
  ## Deletes a key and the data associated with it. The key is removed and no longer counts against the key quota. Note that since this method is not safe in the face of concurrent modifications, it should only be used for development and testing purposes. Invoking this method in shipping code can result in data loss and data corruption.
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
  ##   stateKey: int (required)
  ##           : The key for the data to be retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578954 = newJObject()
  var query_578955 = newJObject()
  add(query_578955, "key", newJString(key))
  add(query_578955, "prettyPrint", newJBool(prettyPrint))
  add(query_578955, "oauth_token", newJString(oauthToken))
  add(query_578955, "alt", newJString(alt))
  add(query_578955, "userIp", newJString(userIp))
  add(query_578955, "quotaUser", newJString(quotaUser))
  add(path_578954, "stateKey", newJInt(stateKey))
  add(query_578955, "fields", newJString(fields))
  result = call_578953.call(path_578954, query_578955, nil, nil, nil)

var appstateStatesDelete* = Call_AppstateStatesDelete_578941(
    name: "appstateStatesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/states/{stateKey}",
    validator: validate_AppstateStatesDelete_578942, base: "/appstate/v1",
    url: url_AppstateStatesDelete_578943, schemes: {Scheme.Https})
type
  Call_AppstateStatesClear_578956 = ref object of OpenApiRestCall_578355
proc url_AppstateStatesClear_578958(protocol: Scheme; host: string; base: string;
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

proc validate_AppstateStatesClear_578957(path: JsonNode; query: JsonNode;
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
  var valid_578959 = path.getOrDefault("stateKey")
  valid_578959 = validateParameter(valid_578959, JInt, required = true, default = nil)
  if valid_578959 != nil:
    section.add "stateKey", valid_578959
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   currentDataVersion: JString
  ##                     : The version of the data to be cleared. Version strings are returned by the server.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578960 = query.getOrDefault("key")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "key", valid_578960
  var valid_578961 = query.getOrDefault("prettyPrint")
  valid_578961 = validateParameter(valid_578961, JBool, required = false,
                                 default = newJBool(true))
  if valid_578961 != nil:
    section.add "prettyPrint", valid_578961
  var valid_578962 = query.getOrDefault("oauth_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "oauth_token", valid_578962
  var valid_578963 = query.getOrDefault("currentDataVersion")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "currentDataVersion", valid_578963
  var valid_578964 = query.getOrDefault("alt")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("json"))
  if valid_578964 != nil:
    section.add "alt", valid_578964
  var valid_578965 = query.getOrDefault("userIp")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "userIp", valid_578965
  var valid_578966 = query.getOrDefault("quotaUser")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "quotaUser", valid_578966
  var valid_578967 = query.getOrDefault("fields")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "fields", valid_578967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578968: Call_AppstateStatesClear_578956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears (sets to empty) the data for the passed key if and only if the passed version matches the currently stored version. This method results in a conflict error on version mismatch.
  ## 
  let valid = call_578968.validator(path, query, header, formData, body)
  let scheme = call_578968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578968.url(scheme.get, call_578968.host, call_578968.base,
                         call_578968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578968, url, valid)

proc call*(call_578969: Call_AppstateStatesClear_578956; stateKey: int;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          currentDataVersion: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## appstateStatesClear
  ## Clears (sets to empty) the data for the passed key if and only if the passed version matches the currently stored version. This method results in a conflict error on version mismatch.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   currentDataVersion: string
  ##                     : The version of the data to be cleared. Version strings are returned by the server.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   stateKey: int (required)
  ##           : The key for the data to be retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578970 = newJObject()
  var query_578971 = newJObject()
  add(query_578971, "key", newJString(key))
  add(query_578971, "prettyPrint", newJBool(prettyPrint))
  add(query_578971, "oauth_token", newJString(oauthToken))
  add(query_578971, "currentDataVersion", newJString(currentDataVersion))
  add(query_578971, "alt", newJString(alt))
  add(query_578971, "userIp", newJString(userIp))
  add(query_578971, "quotaUser", newJString(quotaUser))
  add(path_578970, "stateKey", newJInt(stateKey))
  add(query_578971, "fields", newJString(fields))
  result = call_578969.call(path_578970, query_578971, nil, nil, nil)

var appstateStatesClear* = Call_AppstateStatesClear_578956(
    name: "appstateStatesClear", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/states/{stateKey}/clear",
    validator: validate_AppstateStatesClear_578957, base: "/appstate/v1",
    url: url_AppstateStatesClear_578958, schemes: {Scheme.Https})
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
