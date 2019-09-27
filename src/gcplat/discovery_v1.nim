
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: API Discovery Service
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides information about other Google APIs, such as what APIs are available, the resource, and method details for each API.
## 
## https://developers.google.com/discovery/
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  gcpServiceName = "discovery"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DiscoveryApisList_593676 = ref object of OpenApiRestCall_593408
proc url_DiscoveryApisList_593678(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DiscoveryApisList_593677(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieve the list of APIs supported at this endpoint.
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
  ##   preferred: JBool
  ##            : Return only the preferred version of an API.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : Only include APIs with the given name.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593790 = query.getOrDefault("fields")
  valid_593790 = validateParameter(valid_593790, JString, required = false,
                                 default = nil)
  if valid_593790 != nil:
    section.add "fields", valid_593790
  var valid_593791 = query.getOrDefault("quotaUser")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "quotaUser", valid_593791
  var valid_593805 = query.getOrDefault("alt")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = newJString("json"))
  if valid_593805 != nil:
    section.add "alt", valid_593805
  var valid_593806 = query.getOrDefault("preferred")
  valid_593806 = validateParameter(valid_593806, JBool, required = false,
                                 default = newJBool(false))
  if valid_593806 != nil:
    section.add "preferred", valid_593806
  var valid_593807 = query.getOrDefault("oauth_token")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "oauth_token", valid_593807
  var valid_593808 = query.getOrDefault("userIp")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "userIp", valid_593808
  var valid_593809 = query.getOrDefault("key")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "key", valid_593809
  var valid_593810 = query.getOrDefault("name")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "name", valid_593810
  var valid_593811 = query.getOrDefault("prettyPrint")
  valid_593811 = validateParameter(valid_593811, JBool, required = false,
                                 default = newJBool(true))
  if valid_593811 != nil:
    section.add "prettyPrint", valid_593811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593834: Call_DiscoveryApisList_593676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the list of APIs supported at this endpoint.
  ## 
  let valid = call_593834.validator(path, query, header, formData, body)
  let scheme = call_593834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593834.url(scheme.get, call_593834.host, call_593834.base,
                         call_593834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593834, url, valid)

proc call*(call_593905: Call_DiscoveryApisList_593676; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; preferred: bool = false;
          oauthToken: string = ""; userIp: string = ""; key: string = ""; name: string = "";
          prettyPrint: bool = true): Recallable =
  ## discoveryApisList
  ## Retrieve the list of APIs supported at this endpoint.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   preferred: bool
  ##            : Return only the preferred version of an API.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : Only include APIs with the given name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593906 = newJObject()
  add(query_593906, "fields", newJString(fields))
  add(query_593906, "quotaUser", newJString(quotaUser))
  add(query_593906, "alt", newJString(alt))
  add(query_593906, "preferred", newJBool(preferred))
  add(query_593906, "oauth_token", newJString(oauthToken))
  add(query_593906, "userIp", newJString(userIp))
  add(query_593906, "key", newJString(key))
  add(query_593906, "name", newJString(name))
  add(query_593906, "prettyPrint", newJBool(prettyPrint))
  result = call_593905.call(nil, query_593906, nil, nil, nil)

var discoveryApisList* = Call_DiscoveryApisList_593676(name: "discoveryApisList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/apis",
    validator: validate_DiscoveryApisList_593677, base: "/discovery/v1",
    url: url_DiscoveryApisList_593678, schemes: {Scheme.Https})
type
  Call_DiscoveryApisGetRest_593946 = ref object of OpenApiRestCall_593408
proc url_DiscoveryApisGetRest_593948(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "api" in path, "`api` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "api"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "version"),
               (kind: ConstantSegment, value: "/rest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiscoveryApisGetRest_593947(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the description of a particular version of an api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   version: JString (required)
  ##          : The version of the API.
  ##   api: JString (required)
  ##      : The name of the API.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `version` field"
  var valid_593963 = path.getOrDefault("version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "version", valid_593963
  var valid_593964 = path.getOrDefault("api")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "api", valid_593964
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
  var valid_593965 = query.getOrDefault("fields")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "fields", valid_593965
  var valid_593966 = query.getOrDefault("quotaUser")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "quotaUser", valid_593966
  var valid_593967 = query.getOrDefault("alt")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = newJString("json"))
  if valid_593967 != nil:
    section.add "alt", valid_593967
  var valid_593968 = query.getOrDefault("oauth_token")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "oauth_token", valid_593968
  var valid_593969 = query.getOrDefault("userIp")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "userIp", valid_593969
  var valid_593970 = query.getOrDefault("key")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "key", valid_593970
  var valid_593971 = query.getOrDefault("prettyPrint")
  valid_593971 = validateParameter(valid_593971, JBool, required = false,
                                 default = newJBool(true))
  if valid_593971 != nil:
    section.add "prettyPrint", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_DiscoveryApisGetRest_593946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the description of a particular version of an api.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_DiscoveryApisGetRest_593946; version: string;
          api: string; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## discoveryApisGetRest
  ## Retrieve the description of a particular version of an api.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   version: string (required)
  ##          : The version of the API.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   api: string (required)
  ##      : The name of the API.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(query_593975, "fields", newJString(fields))
  add(query_593975, "quotaUser", newJString(quotaUser))
  add(query_593975, "alt", newJString(alt))
  add(path_593974, "version", newJString(version))
  add(query_593975, "oauth_token", newJString(oauthToken))
  add(query_593975, "userIp", newJString(userIp))
  add(query_593975, "key", newJString(key))
  add(query_593975, "prettyPrint", newJBool(prettyPrint))
  add(path_593974, "api", newJString(api))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var discoveryApisGetRest* = Call_DiscoveryApisGetRest_593946(
    name: "discoveryApisGetRest", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/apis/{api}/{version}/rest",
    validator: validate_DiscoveryApisGetRest_593947, base: "/discovery/v1",
    url: url_DiscoveryApisGetRest_593948, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
