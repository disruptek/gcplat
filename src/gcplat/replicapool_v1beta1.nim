
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Replica Pool
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Replica Pool API allows users to declaratively provision and manage groups of Google Compute Engine instances based on a common template.
## 
## https://developers.google.com/compute/docs/replica-pool/
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

  OpenApiRestCall_579380 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579380](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579380): Option[Scheme] {.used.} =
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
  gcpServiceName = "replicapool"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReplicapoolPoolsInsert_579938 = ref object of OpenApiRestCall_579380
proc url_ReplicapoolPoolsInsert_579940(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/pools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReplicapoolPoolsInsert_579939(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new replica pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone for this replica pool.
  ##   projectName: JString (required)
  ##              : The project ID for this replica pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_579941 = path.getOrDefault("zone")
  valid_579941 = validateParameter(valid_579941, JString, required = true,
                                 default = nil)
  if valid_579941 != nil:
    section.add "zone", valid_579941
  var valid_579942 = path.getOrDefault("projectName")
  valid_579942 = validateParameter(valid_579942, JString, required = true,
                                 default = nil)
  if valid_579942 != nil:
    section.add "projectName", valid_579942
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
  var valid_579943 = query.getOrDefault("key")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "key", valid_579943
  var valid_579944 = query.getOrDefault("prettyPrint")
  valid_579944 = validateParameter(valid_579944, JBool, required = false,
                                 default = newJBool(true))
  if valid_579944 != nil:
    section.add "prettyPrint", valid_579944
  var valid_579945 = query.getOrDefault("oauth_token")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "oauth_token", valid_579945
  var valid_579946 = query.getOrDefault("alt")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = newJString("json"))
  if valid_579946 != nil:
    section.add "alt", valid_579946
  var valid_579947 = query.getOrDefault("userIp")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "userIp", valid_579947
  var valid_579948 = query.getOrDefault("quotaUser")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "quotaUser", valid_579948
  var valid_579949 = query.getOrDefault("fields")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "fields", valid_579949
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

proc call*(call_579951: Call_ReplicapoolPoolsInsert_579938; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a new replica pool.
  ## 
  let valid = call_579951.validator(path, query, header, formData, body)
  let scheme = call_579951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579951.url(scheme.get, call_579951.host, call_579951.base,
                         call_579951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579951, url, valid)

proc call*(call_579952: Call_ReplicapoolPoolsInsert_579938; zone: string;
          projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## replicapoolPoolsInsert
  ## Inserts a new replica pool.
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
  ##   zone: string (required)
  ##       : The zone for this replica pool.
  ##   body: JObject
  ##   projectName: string (required)
  ##              : The project ID for this replica pool.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579953 = newJObject()
  var query_579954 = newJObject()
  var body_579955 = newJObject()
  add(query_579954, "key", newJString(key))
  add(query_579954, "prettyPrint", newJBool(prettyPrint))
  add(query_579954, "oauth_token", newJString(oauthToken))
  add(query_579954, "alt", newJString(alt))
  add(query_579954, "userIp", newJString(userIp))
  add(query_579954, "quotaUser", newJString(quotaUser))
  add(path_579953, "zone", newJString(zone))
  if body != nil:
    body_579955 = body
  add(path_579953, "projectName", newJString(projectName))
  add(query_579954, "fields", newJString(fields))
  result = call_579952.call(path_579953, query_579954, nil, nil, body_579955)

var replicapoolPoolsInsert* = Call_ReplicapoolPoolsInsert_579938(
    name: "replicapoolPoolsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools",
    validator: validate_ReplicapoolPoolsInsert_579939,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsInsert_579940,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsList_579650 = ref object of OpenApiRestCall_579380
proc url_ReplicapoolPoolsList_579652(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/pools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReplicapoolPoolsList_579651(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all replica pools.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone for this replica pool.
  ##   projectName: JString (required)
  ##              : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_579778 = path.getOrDefault("zone")
  valid_579778 = validateParameter(valid_579778, JString, required = true,
                                 default = nil)
  if valid_579778 != nil:
    section.add "zone", valid_579778
  var valid_579779 = path.getOrDefault("projectName")
  valid_579779 = validateParameter(valid_579779, JString, required = true,
                                 default = nil)
  if valid_579779 != nil:
    section.add "projectName", valid_579779
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
  ##            : Set this to the nextPageToken value returned by a previous list request to obtain the next page of results from the previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 100, inclusive. (Default: 50)
  section = newJObject()
  var valid_579780 = query.getOrDefault("key")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "key", valid_579780
  var valid_579794 = query.getOrDefault("prettyPrint")
  valid_579794 = validateParameter(valid_579794, JBool, required = false,
                                 default = newJBool(true))
  if valid_579794 != nil:
    section.add "prettyPrint", valid_579794
  var valid_579795 = query.getOrDefault("oauth_token")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "oauth_token", valid_579795
  var valid_579796 = query.getOrDefault("alt")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = newJString("json"))
  if valid_579796 != nil:
    section.add "alt", valid_579796
  var valid_579797 = query.getOrDefault("userIp")
  valid_579797 = validateParameter(valid_579797, JString, required = false,
                                 default = nil)
  if valid_579797 != nil:
    section.add "userIp", valid_579797
  var valid_579798 = query.getOrDefault("quotaUser")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "quotaUser", valid_579798
  var valid_579799 = query.getOrDefault("pageToken")
  valid_579799 = validateParameter(valid_579799, JString, required = false,
                                 default = nil)
  if valid_579799 != nil:
    section.add "pageToken", valid_579799
  var valid_579800 = query.getOrDefault("fields")
  valid_579800 = validateParameter(valid_579800, JString, required = false,
                                 default = nil)
  if valid_579800 != nil:
    section.add "fields", valid_579800
  var valid_579802 = query.getOrDefault("maxResults")
  valid_579802 = validateParameter(valid_579802, JInt, required = false,
                                 default = newJInt(500))
  if valid_579802 != nil:
    section.add "maxResults", valid_579802
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579825: Call_ReplicapoolPoolsList_579650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all replica pools.
  ## 
  let valid = call_579825.validator(path, query, header, formData, body)
  let scheme = call_579825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579825.url(scheme.get, call_579825.host, call_579825.base,
                         call_579825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579825, url, valid)

proc call*(call_579896: Call_ReplicapoolPoolsList_579650; zone: string;
          projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 500): Recallable =
  ## replicapoolPoolsList
  ## List all replica pools.
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
  ##            : Set this to the nextPageToken value returned by a previous list request to obtain the next page of results from the previous list request.
  ##   zone: string (required)
  ##       : The zone for this replica pool.
  ##   projectName: string (required)
  ##              : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 100, inclusive. (Default: 50)
  var path_579897 = newJObject()
  var query_579899 = newJObject()
  add(query_579899, "key", newJString(key))
  add(query_579899, "prettyPrint", newJBool(prettyPrint))
  add(query_579899, "oauth_token", newJString(oauthToken))
  add(query_579899, "alt", newJString(alt))
  add(query_579899, "userIp", newJString(userIp))
  add(query_579899, "quotaUser", newJString(quotaUser))
  add(query_579899, "pageToken", newJString(pageToken))
  add(path_579897, "zone", newJString(zone))
  add(path_579897, "projectName", newJString(projectName))
  add(query_579899, "fields", newJString(fields))
  add(query_579899, "maxResults", newJInt(maxResults))
  result = call_579896.call(path_579897, query_579899, nil, nil, nil)

var replicapoolPoolsList* = Call_ReplicapoolPoolsList_579650(
    name: "replicapoolPoolsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools",
    validator: validate_ReplicapoolPoolsList_579651,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsList_579652,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsDelete_579973 = ref object of OpenApiRestCall_579380
proc url_ReplicapoolPoolsDelete_579975(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReplicapoolPoolsDelete_579974(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a replica pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the replica pool for this request.
  ##   zone: JString (required)
  ##       : The zone for this replica pool.
  ##   projectName: JString (required)
  ##              : The project ID for this replica pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_579976 = path.getOrDefault("poolName")
  valid_579976 = validateParameter(valid_579976, JString, required = true,
                                 default = nil)
  if valid_579976 != nil:
    section.add "poolName", valid_579976
  var valid_579977 = path.getOrDefault("zone")
  valid_579977 = validateParameter(valid_579977, JString, required = true,
                                 default = nil)
  if valid_579977 != nil:
    section.add "zone", valid_579977
  var valid_579978 = path.getOrDefault("projectName")
  valid_579978 = validateParameter(valid_579978, JString, required = true,
                                 default = nil)
  if valid_579978 != nil:
    section.add "projectName", valid_579978
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
  var valid_579979 = query.getOrDefault("key")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "key", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
  var valid_579981 = query.getOrDefault("oauth_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "oauth_token", valid_579981
  var valid_579982 = query.getOrDefault("alt")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("json"))
  if valid_579982 != nil:
    section.add "alt", valid_579982
  var valid_579983 = query.getOrDefault("userIp")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "userIp", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
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

proc call*(call_579987: Call_ReplicapoolPoolsDelete_579973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a replica pool.
  ## 
  let valid = call_579987.validator(path, query, header, formData, body)
  let scheme = call_579987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579987.url(scheme.get, call_579987.host, call_579987.base,
                         call_579987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579987, url, valid)

proc call*(call_579988: Call_ReplicapoolPoolsDelete_579973; poolName: string;
          zone: string; projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## replicapoolPoolsDelete
  ## Deletes a replica pool.
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
  ##   poolName: string (required)
  ##           : The name of the replica pool for this request.
  ##   zone: string (required)
  ##       : The zone for this replica pool.
  ##   body: JObject
  ##   projectName: string (required)
  ##              : The project ID for this replica pool.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579989 = newJObject()
  var query_579990 = newJObject()
  var body_579991 = newJObject()
  add(query_579990, "key", newJString(key))
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(query_579990, "alt", newJString(alt))
  add(query_579990, "userIp", newJString(userIp))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(path_579989, "poolName", newJString(poolName))
  add(path_579989, "zone", newJString(zone))
  if body != nil:
    body_579991 = body
  add(path_579989, "projectName", newJString(projectName))
  add(query_579990, "fields", newJString(fields))
  result = call_579988.call(path_579989, query_579990, nil, nil, body_579991)

var replicapoolPoolsDelete* = Call_ReplicapoolPoolsDelete_579973(
    name: "replicapoolPoolsDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}",
    validator: validate_ReplicapoolPoolsDelete_579974,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsDelete_579975,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsGet_579956 = ref object of OpenApiRestCall_579380
proc url_ReplicapoolPoolsGet_579958(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReplicapoolPoolsGet_579957(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets information about a single replica pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the replica pool for this request.
  ##   zone: JString (required)
  ##       : The zone for this replica pool.
  ##   projectName: JString (required)
  ##              : The project ID for this replica pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_579959 = path.getOrDefault("poolName")
  valid_579959 = validateParameter(valid_579959, JString, required = true,
                                 default = nil)
  if valid_579959 != nil:
    section.add "poolName", valid_579959
  var valid_579960 = path.getOrDefault("zone")
  valid_579960 = validateParameter(valid_579960, JString, required = true,
                                 default = nil)
  if valid_579960 != nil:
    section.add "zone", valid_579960
  var valid_579961 = path.getOrDefault("projectName")
  valid_579961 = validateParameter(valid_579961, JString, required = true,
                                 default = nil)
  if valid_579961 != nil:
    section.add "projectName", valid_579961
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
  var valid_579962 = query.getOrDefault("key")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "key", valid_579962
  var valid_579963 = query.getOrDefault("prettyPrint")
  valid_579963 = validateParameter(valid_579963, JBool, required = false,
                                 default = newJBool(true))
  if valid_579963 != nil:
    section.add "prettyPrint", valid_579963
  var valid_579964 = query.getOrDefault("oauth_token")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "oauth_token", valid_579964
  var valid_579965 = query.getOrDefault("alt")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = newJString("json"))
  if valid_579965 != nil:
    section.add "alt", valid_579965
  var valid_579966 = query.getOrDefault("userIp")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "userIp", valid_579966
  var valid_579967 = query.getOrDefault("quotaUser")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "quotaUser", valid_579967
  var valid_579968 = query.getOrDefault("fields")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "fields", valid_579968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579969: Call_ReplicapoolPoolsGet_579956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a single replica pool.
  ## 
  let valid = call_579969.validator(path, query, header, formData, body)
  let scheme = call_579969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579969.url(scheme.get, call_579969.host, call_579969.base,
                         call_579969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579969, url, valid)

proc call*(call_579970: Call_ReplicapoolPoolsGet_579956; poolName: string;
          zone: string; projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## replicapoolPoolsGet
  ## Gets information about a single replica pool.
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
  ##   poolName: string (required)
  ##           : The name of the replica pool for this request.
  ##   zone: string (required)
  ##       : The zone for this replica pool.
  ##   projectName: string (required)
  ##              : The project ID for this replica pool.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579971 = newJObject()
  var query_579972 = newJObject()
  add(query_579972, "key", newJString(key))
  add(query_579972, "prettyPrint", newJBool(prettyPrint))
  add(query_579972, "oauth_token", newJString(oauthToken))
  add(query_579972, "alt", newJString(alt))
  add(query_579972, "userIp", newJString(userIp))
  add(query_579972, "quotaUser", newJString(quotaUser))
  add(path_579971, "poolName", newJString(poolName))
  add(path_579971, "zone", newJString(zone))
  add(path_579971, "projectName", newJString(projectName))
  add(query_579972, "fields", newJString(fields))
  result = call_579970.call(path_579971, query_579972, nil, nil, nil)

var replicapoolPoolsGet* = Call_ReplicapoolPoolsGet_579956(
    name: "replicapoolPoolsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}",
    validator: validate_ReplicapoolPoolsGet_579957,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsGet_579958,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasList_579992 = ref object of OpenApiRestCall_579380
proc url_ReplicapoolReplicasList_579994(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/replicas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReplicapoolReplicasList_579993(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all replicas in a pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The replica pool name for this request.
  ##   zone: JString (required)
  ##       : The zone where the replica pool lives.
  ##   projectName: JString (required)
  ##              : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_579995 = path.getOrDefault("poolName")
  valid_579995 = validateParameter(valid_579995, JString, required = true,
                                 default = nil)
  if valid_579995 != nil:
    section.add "poolName", valid_579995
  var valid_579996 = path.getOrDefault("zone")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "zone", valid_579996
  var valid_579997 = path.getOrDefault("projectName")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "projectName", valid_579997
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
  ##            : Set this to the nextPageToken value returned by a previous list request to obtain the next page of results from the previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 100, inclusive. (Default: 50)
  section = newJObject()
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("prettyPrint")
  valid_579999 = validateParameter(valid_579999, JBool, required = false,
                                 default = newJBool(true))
  if valid_579999 != nil:
    section.add "prettyPrint", valid_579999
  var valid_580000 = query.getOrDefault("oauth_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "oauth_token", valid_580000
  var valid_580001 = query.getOrDefault("alt")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("json"))
  if valid_580001 != nil:
    section.add "alt", valid_580001
  var valid_580002 = query.getOrDefault("userIp")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "userIp", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("pageToken")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "pageToken", valid_580004
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
  var valid_580006 = query.getOrDefault("maxResults")
  valid_580006 = validateParameter(valid_580006, JInt, required = false,
                                 default = newJInt(500))
  if valid_580006 != nil:
    section.add "maxResults", valid_580006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580007: Call_ReplicapoolReplicasList_579992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all replicas in a pool.
  ## 
  let valid = call_580007.validator(path, query, header, formData, body)
  let scheme = call_580007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580007.url(scheme.get, call_580007.host, call_580007.base,
                         call_580007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580007, url, valid)

proc call*(call_580008: Call_ReplicapoolReplicasList_579992; poolName: string;
          zone: string; projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 500): Recallable =
  ## replicapoolReplicasList
  ## Lists all replicas in a pool.
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
  ##            : Set this to the nextPageToken value returned by a previous list request to obtain the next page of results from the previous list request.
  ##   poolName: string (required)
  ##           : The replica pool name for this request.
  ##   zone: string (required)
  ##       : The zone where the replica pool lives.
  ##   projectName: string (required)
  ##              : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 100, inclusive. (Default: 50)
  var path_580009 = newJObject()
  var query_580010 = newJObject()
  add(query_580010, "key", newJString(key))
  add(query_580010, "prettyPrint", newJBool(prettyPrint))
  add(query_580010, "oauth_token", newJString(oauthToken))
  add(query_580010, "alt", newJString(alt))
  add(query_580010, "userIp", newJString(userIp))
  add(query_580010, "quotaUser", newJString(quotaUser))
  add(query_580010, "pageToken", newJString(pageToken))
  add(path_580009, "poolName", newJString(poolName))
  add(path_580009, "zone", newJString(zone))
  add(path_580009, "projectName", newJString(projectName))
  add(query_580010, "fields", newJString(fields))
  add(query_580010, "maxResults", newJInt(maxResults))
  result = call_580008.call(path_580009, query_580010, nil, nil, nil)

var replicapoolReplicasList* = Call_ReplicapoolReplicasList_579992(
    name: "replicapoolReplicasList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas",
    validator: validate_ReplicapoolReplicasList_579993,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasList_579994,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasDelete_580029 = ref object of OpenApiRestCall_579380
proc url_ReplicapoolReplicasDelete_580031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "replicaName" in path, "`replicaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/replicas/"),
               (kind: VariableSegment, value: "replicaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReplicapoolReplicasDelete_580030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a replica from the pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The replica pool name for this request.
  ##   zone: JString (required)
  ##       : The zone where the replica lives.
  ##   projectName: JString (required)
  ##              : The project ID for this request.
  ##   replicaName: JString (required)
  ##              : The name of the replica for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_580032 = path.getOrDefault("poolName")
  valid_580032 = validateParameter(valid_580032, JString, required = true,
                                 default = nil)
  if valid_580032 != nil:
    section.add "poolName", valid_580032
  var valid_580033 = path.getOrDefault("zone")
  valid_580033 = validateParameter(valid_580033, JString, required = true,
                                 default = nil)
  if valid_580033 != nil:
    section.add "zone", valid_580033
  var valid_580034 = path.getOrDefault("projectName")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "projectName", valid_580034
  var valid_580035 = path.getOrDefault("replicaName")
  valid_580035 = validateParameter(valid_580035, JString, required = true,
                                 default = nil)
  if valid_580035 != nil:
    section.add "replicaName", valid_580035
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
  var valid_580036 = query.getOrDefault("key")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "key", valid_580036
  var valid_580037 = query.getOrDefault("prettyPrint")
  valid_580037 = validateParameter(valid_580037, JBool, required = false,
                                 default = newJBool(true))
  if valid_580037 != nil:
    section.add "prettyPrint", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("alt")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("json"))
  if valid_580039 != nil:
    section.add "alt", valid_580039
  var valid_580040 = query.getOrDefault("userIp")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "userIp", valid_580040
  var valid_580041 = query.getOrDefault("quotaUser")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "quotaUser", valid_580041
  var valid_580042 = query.getOrDefault("fields")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "fields", valid_580042
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

proc call*(call_580044: Call_ReplicapoolReplicasDelete_580029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a replica from the pool.
  ## 
  let valid = call_580044.validator(path, query, header, formData, body)
  let scheme = call_580044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580044.url(scheme.get, call_580044.host, call_580044.base,
                         call_580044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580044, url, valid)

proc call*(call_580045: Call_ReplicapoolReplicasDelete_580029; poolName: string;
          zone: string; projectName: string; replicaName: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## replicapoolReplicasDelete
  ## Deletes a replica from the pool.
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
  ##   poolName: string (required)
  ##           : The replica pool name for this request.
  ##   zone: string (required)
  ##       : The zone where the replica lives.
  ##   body: JObject
  ##   projectName: string (required)
  ##              : The project ID for this request.
  ##   replicaName: string (required)
  ##              : The name of the replica for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580046 = newJObject()
  var query_580047 = newJObject()
  var body_580048 = newJObject()
  add(query_580047, "key", newJString(key))
  add(query_580047, "prettyPrint", newJBool(prettyPrint))
  add(query_580047, "oauth_token", newJString(oauthToken))
  add(query_580047, "alt", newJString(alt))
  add(query_580047, "userIp", newJString(userIp))
  add(query_580047, "quotaUser", newJString(quotaUser))
  add(path_580046, "poolName", newJString(poolName))
  add(path_580046, "zone", newJString(zone))
  if body != nil:
    body_580048 = body
  add(path_580046, "projectName", newJString(projectName))
  add(path_580046, "replicaName", newJString(replicaName))
  add(query_580047, "fields", newJString(fields))
  result = call_580045.call(path_580046, query_580047, nil, nil, body_580048)

var replicapoolReplicasDelete* = Call_ReplicapoolReplicasDelete_580029(
    name: "replicapoolReplicasDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}",
    validator: validate_ReplicapoolReplicasDelete_580030,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasDelete_580031,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasGet_580011 = ref object of OpenApiRestCall_579380
proc url_ReplicapoolReplicasGet_580013(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "replicaName" in path, "`replicaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/replicas/"),
               (kind: VariableSegment, value: "replicaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReplicapoolReplicasGet_580012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific replica.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The replica pool name for this request.
  ##   zone: JString (required)
  ##       : The zone where the replica lives.
  ##   projectName: JString (required)
  ##              : The project ID for this request.
  ##   replicaName: JString (required)
  ##              : The name of the replica for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_580014 = path.getOrDefault("poolName")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "poolName", valid_580014
  var valid_580015 = path.getOrDefault("zone")
  valid_580015 = validateParameter(valid_580015, JString, required = true,
                                 default = nil)
  if valid_580015 != nil:
    section.add "zone", valid_580015
  var valid_580016 = path.getOrDefault("projectName")
  valid_580016 = validateParameter(valid_580016, JString, required = true,
                                 default = nil)
  if valid_580016 != nil:
    section.add "projectName", valid_580016
  var valid_580017 = path.getOrDefault("replicaName")
  valid_580017 = validateParameter(valid_580017, JString, required = true,
                                 default = nil)
  if valid_580017 != nil:
    section.add "replicaName", valid_580017
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
  var valid_580018 = query.getOrDefault("key")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "key", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
  var valid_580020 = query.getOrDefault("oauth_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "oauth_token", valid_580020
  var valid_580021 = query.getOrDefault("alt")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("json"))
  if valid_580021 != nil:
    section.add "alt", valid_580021
  var valid_580022 = query.getOrDefault("userIp")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "userIp", valid_580022
  var valid_580023 = query.getOrDefault("quotaUser")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "quotaUser", valid_580023
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580025: Call_ReplicapoolReplicasGet_580011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific replica.
  ## 
  let valid = call_580025.validator(path, query, header, formData, body)
  let scheme = call_580025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580025.url(scheme.get, call_580025.host, call_580025.base,
                         call_580025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580025, url, valid)

proc call*(call_580026: Call_ReplicapoolReplicasGet_580011; poolName: string;
          zone: string; projectName: string; replicaName: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## replicapoolReplicasGet
  ## Gets information about a specific replica.
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
  ##   poolName: string (required)
  ##           : The replica pool name for this request.
  ##   zone: string (required)
  ##       : The zone where the replica lives.
  ##   projectName: string (required)
  ##              : The project ID for this request.
  ##   replicaName: string (required)
  ##              : The name of the replica for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580027 = newJObject()
  var query_580028 = newJObject()
  add(query_580028, "key", newJString(key))
  add(query_580028, "prettyPrint", newJBool(prettyPrint))
  add(query_580028, "oauth_token", newJString(oauthToken))
  add(query_580028, "alt", newJString(alt))
  add(query_580028, "userIp", newJString(userIp))
  add(query_580028, "quotaUser", newJString(quotaUser))
  add(path_580027, "poolName", newJString(poolName))
  add(path_580027, "zone", newJString(zone))
  add(path_580027, "projectName", newJString(projectName))
  add(path_580027, "replicaName", newJString(replicaName))
  add(query_580028, "fields", newJString(fields))
  result = call_580026.call(path_580027, query_580028, nil, nil, nil)

var replicapoolReplicasGet* = Call_ReplicapoolReplicasGet_580011(
    name: "replicapoolReplicasGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}",
    validator: validate_ReplicapoolReplicasGet_580012,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasGet_580013,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasRestart_580049 = ref object of OpenApiRestCall_579380
proc url_ReplicapoolReplicasRestart_580051(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  assert "replicaName" in path, "`replicaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/replicas/"),
               (kind: VariableSegment, value: "replicaName"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReplicapoolReplicasRestart_580050(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restarts a replica in a pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The replica pool name for this request.
  ##   zone: JString (required)
  ##       : The zone where the replica lives.
  ##   projectName: JString (required)
  ##              : The project ID for this request.
  ##   replicaName: JString (required)
  ##              : The name of the replica for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_580052 = path.getOrDefault("poolName")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "poolName", valid_580052
  var valid_580053 = path.getOrDefault("zone")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "zone", valid_580053
  var valid_580054 = path.getOrDefault("projectName")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "projectName", valid_580054
  var valid_580055 = path.getOrDefault("replicaName")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "replicaName", valid_580055
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
  var valid_580056 = query.getOrDefault("key")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "key", valid_580056
  var valid_580057 = query.getOrDefault("prettyPrint")
  valid_580057 = validateParameter(valid_580057, JBool, required = false,
                                 default = newJBool(true))
  if valid_580057 != nil:
    section.add "prettyPrint", valid_580057
  var valid_580058 = query.getOrDefault("oauth_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "oauth_token", valid_580058
  var valid_580059 = query.getOrDefault("alt")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("json"))
  if valid_580059 != nil:
    section.add "alt", valid_580059
  var valid_580060 = query.getOrDefault("userIp")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "userIp", valid_580060
  var valid_580061 = query.getOrDefault("quotaUser")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "quotaUser", valid_580061
  var valid_580062 = query.getOrDefault("fields")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "fields", valid_580062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580063: Call_ReplicapoolReplicasRestart_580049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a replica in a pool.
  ## 
  let valid = call_580063.validator(path, query, header, formData, body)
  let scheme = call_580063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580063.url(scheme.get, call_580063.host, call_580063.base,
                         call_580063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580063, url, valid)

proc call*(call_580064: Call_ReplicapoolReplicasRestart_580049; poolName: string;
          zone: string; projectName: string; replicaName: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## replicapoolReplicasRestart
  ## Restarts a replica in a pool.
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
  ##   poolName: string (required)
  ##           : The replica pool name for this request.
  ##   zone: string (required)
  ##       : The zone where the replica lives.
  ##   projectName: string (required)
  ##              : The project ID for this request.
  ##   replicaName: string (required)
  ##              : The name of the replica for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580065 = newJObject()
  var query_580066 = newJObject()
  add(query_580066, "key", newJString(key))
  add(query_580066, "prettyPrint", newJBool(prettyPrint))
  add(query_580066, "oauth_token", newJString(oauthToken))
  add(query_580066, "alt", newJString(alt))
  add(query_580066, "userIp", newJString(userIp))
  add(query_580066, "quotaUser", newJString(quotaUser))
  add(path_580065, "poolName", newJString(poolName))
  add(path_580065, "zone", newJString(zone))
  add(path_580065, "projectName", newJString(projectName))
  add(path_580065, "replicaName", newJString(replicaName))
  add(query_580066, "fields", newJString(fields))
  result = call_580064.call(path_580065, query_580066, nil, nil, nil)

var replicapoolReplicasRestart* = Call_ReplicapoolReplicasRestart_580049(
    name: "replicapoolReplicasRestart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}/restart",
    validator: validate_ReplicapoolReplicasRestart_580050,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasRestart_580051,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsResize_580067 = ref object of OpenApiRestCall_579380
proc url_ReplicapoolPoolsResize_580069(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/resize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReplicapoolPoolsResize_580068(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resize a pool. This is an asynchronous operation, and multiple overlapping resize requests can be made. Replica Pools will use the information from the last resize request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the replica pool for this request.
  ##   zone: JString (required)
  ##       : The zone for this replica pool.
  ##   projectName: JString (required)
  ##              : The project ID for this replica pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_580070 = path.getOrDefault("poolName")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "poolName", valid_580070
  var valid_580071 = path.getOrDefault("zone")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "zone", valid_580071
  var valid_580072 = path.getOrDefault("projectName")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "projectName", valid_580072
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
  ##   numReplicas: JInt
  ##              : The desired number of replicas to resize to. If this number is larger than the existing number of replicas, new replicas will be added. If the number is smaller, then existing replicas will be deleted.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580073 = query.getOrDefault("key")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "key", valid_580073
  var valid_580074 = query.getOrDefault("prettyPrint")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(true))
  if valid_580074 != nil:
    section.add "prettyPrint", valid_580074
  var valid_580075 = query.getOrDefault("oauth_token")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "oauth_token", valid_580075
  var valid_580076 = query.getOrDefault("alt")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("json"))
  if valid_580076 != nil:
    section.add "alt", valid_580076
  var valid_580077 = query.getOrDefault("userIp")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "userIp", valid_580077
  var valid_580078 = query.getOrDefault("quotaUser")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "quotaUser", valid_580078
  var valid_580079 = query.getOrDefault("numReplicas")
  valid_580079 = validateParameter(valid_580079, JInt, required = false, default = nil)
  if valid_580079 != nil:
    section.add "numReplicas", valid_580079
  var valid_580080 = query.getOrDefault("fields")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "fields", valid_580080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580081: Call_ReplicapoolPoolsResize_580067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resize a pool. This is an asynchronous operation, and multiple overlapping resize requests can be made. Replica Pools will use the information from the last resize request.
  ## 
  let valid = call_580081.validator(path, query, header, formData, body)
  let scheme = call_580081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580081.url(scheme.get, call_580081.host, call_580081.base,
                         call_580081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580081, url, valid)

proc call*(call_580082: Call_ReplicapoolPoolsResize_580067; poolName: string;
          zone: string; projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; numReplicas: int = 0; fields: string = ""): Recallable =
  ## replicapoolPoolsResize
  ## Resize a pool. This is an asynchronous operation, and multiple overlapping resize requests can be made. Replica Pools will use the information from the last resize request.
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
  ##   poolName: string (required)
  ##           : The name of the replica pool for this request.
  ##   numReplicas: int
  ##              : The desired number of replicas to resize to. If this number is larger than the existing number of replicas, new replicas will be added. If the number is smaller, then existing replicas will be deleted.
  ##   zone: string (required)
  ##       : The zone for this replica pool.
  ##   projectName: string (required)
  ##              : The project ID for this replica pool.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580083 = newJObject()
  var query_580084 = newJObject()
  add(query_580084, "key", newJString(key))
  add(query_580084, "prettyPrint", newJBool(prettyPrint))
  add(query_580084, "oauth_token", newJString(oauthToken))
  add(query_580084, "alt", newJString(alt))
  add(query_580084, "userIp", newJString(userIp))
  add(query_580084, "quotaUser", newJString(quotaUser))
  add(path_580083, "poolName", newJString(poolName))
  add(query_580084, "numReplicas", newJInt(numReplicas))
  add(path_580083, "zone", newJString(zone))
  add(path_580083, "projectName", newJString(projectName))
  add(query_580084, "fields", newJString(fields))
  result = call_580082.call(path_580083, query_580084, nil, nil, nil)

var replicapoolPoolsResize* = Call_ReplicapoolPoolsResize_580067(
    name: "replicapoolPoolsResize", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/resize",
    validator: validate_ReplicapoolPoolsResize_580068,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsResize_580069,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsUpdatetemplate_580085 = ref object of OpenApiRestCall_579380
proc url_ReplicapoolPoolsUpdatetemplate_580087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "poolName" in path, "`poolName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/pools/"),
               (kind: VariableSegment, value: "poolName"),
               (kind: ConstantSegment, value: "/updateTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ReplicapoolPoolsUpdatetemplate_580086(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the template used by the pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   poolName: JString (required)
  ##           : The name of the replica pool for this request.
  ##   zone: JString (required)
  ##       : The zone for this replica pool.
  ##   projectName: JString (required)
  ##              : The project ID for this replica pool.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `poolName` field"
  var valid_580088 = path.getOrDefault("poolName")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "poolName", valid_580088
  var valid_580089 = path.getOrDefault("zone")
  valid_580089 = validateParameter(valid_580089, JString, required = true,
                                 default = nil)
  if valid_580089 != nil:
    section.add "zone", valid_580089
  var valid_580090 = path.getOrDefault("projectName")
  valid_580090 = validateParameter(valid_580090, JString, required = true,
                                 default = nil)
  if valid_580090 != nil:
    section.add "projectName", valid_580090
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
  var valid_580091 = query.getOrDefault("key")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "key", valid_580091
  var valid_580092 = query.getOrDefault("prettyPrint")
  valid_580092 = validateParameter(valid_580092, JBool, required = false,
                                 default = newJBool(true))
  if valid_580092 != nil:
    section.add "prettyPrint", valid_580092
  var valid_580093 = query.getOrDefault("oauth_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "oauth_token", valid_580093
  var valid_580094 = query.getOrDefault("alt")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("json"))
  if valid_580094 != nil:
    section.add "alt", valid_580094
  var valid_580095 = query.getOrDefault("userIp")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "userIp", valid_580095
  var valid_580096 = query.getOrDefault("quotaUser")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "quotaUser", valid_580096
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
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

proc call*(call_580099: Call_ReplicapoolPoolsUpdatetemplate_580085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the template used by the pool.
  ## 
  let valid = call_580099.validator(path, query, header, formData, body)
  let scheme = call_580099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580099.url(scheme.get, call_580099.host, call_580099.base,
                         call_580099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580099, url, valid)

proc call*(call_580100: Call_ReplicapoolPoolsUpdatetemplate_580085;
          poolName: string; zone: string; projectName: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## replicapoolPoolsUpdatetemplate
  ## Update the template used by the pool.
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
  ##   poolName: string (required)
  ##           : The name of the replica pool for this request.
  ##   zone: string (required)
  ##       : The zone for this replica pool.
  ##   body: JObject
  ##   projectName: string (required)
  ##              : The project ID for this replica pool.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580101 = newJObject()
  var query_580102 = newJObject()
  var body_580103 = newJObject()
  add(query_580102, "key", newJString(key))
  add(query_580102, "prettyPrint", newJBool(prettyPrint))
  add(query_580102, "oauth_token", newJString(oauthToken))
  add(query_580102, "alt", newJString(alt))
  add(query_580102, "userIp", newJString(userIp))
  add(query_580102, "quotaUser", newJString(quotaUser))
  add(path_580101, "poolName", newJString(poolName))
  add(path_580101, "zone", newJString(zone))
  if body != nil:
    body_580103 = body
  add(path_580101, "projectName", newJString(projectName))
  add(query_580102, "fields", newJString(fields))
  result = call_580100.call(path_580101, query_580102, nil, nil, body_580103)

var replicapoolPoolsUpdatetemplate* = Call_ReplicapoolPoolsUpdatetemplate_580085(
    name: "replicapoolPoolsUpdatetemplate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/updateTemplate",
    validator: validate_ReplicapoolPoolsUpdatetemplate_580086,
    base: "/replicapool/v1beta1/projects",
    url: url_ReplicapoolPoolsUpdatetemplate_580087, schemes: {Scheme.Https})
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
