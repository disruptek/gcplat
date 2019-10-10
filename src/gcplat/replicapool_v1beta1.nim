
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "replicapool"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReplicapoolPoolsInsert_589013 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolPoolsInsert_589015(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_ReplicapoolPoolsInsert_589014(path: JsonNode; query: JsonNode;
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
  var valid_589016 = path.getOrDefault("zone")
  valid_589016 = validateParameter(valid_589016, JString, required = true,
                                 default = nil)
  if valid_589016 != nil:
    section.add "zone", valid_589016
  var valid_589017 = path.getOrDefault("projectName")
  valid_589017 = validateParameter(valid_589017, JString, required = true,
                                 default = nil)
  if valid_589017 != nil:
    section.add "projectName", valid_589017
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
  var valid_589018 = query.getOrDefault("fields")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "fields", valid_589018
  var valid_589019 = query.getOrDefault("quotaUser")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "quotaUser", valid_589019
  var valid_589020 = query.getOrDefault("alt")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("json"))
  if valid_589020 != nil:
    section.add "alt", valid_589020
  var valid_589021 = query.getOrDefault("oauth_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "oauth_token", valid_589021
  var valid_589022 = query.getOrDefault("userIp")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "userIp", valid_589022
  var valid_589023 = query.getOrDefault("key")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "key", valid_589023
  var valid_589024 = query.getOrDefault("prettyPrint")
  valid_589024 = validateParameter(valid_589024, JBool, required = false,
                                 default = newJBool(true))
  if valid_589024 != nil:
    section.add "prettyPrint", valid_589024
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

proc call*(call_589026: Call_ReplicapoolPoolsInsert_589013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a new replica pool.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_ReplicapoolPoolsInsert_589013; zone: string;
          projectName: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolPoolsInsert
  ## Inserts a new replica pool.
  ##   zone: string (required)
  ##       : The zone for this replica pool.
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
  ##   projectName: string (required)
  ##              : The project ID for this replica pool.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589028 = newJObject()
  var query_589029 = newJObject()
  var body_589030 = newJObject()
  add(path_589028, "zone", newJString(zone))
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "userIp", newJString(userIp))
  add(query_589029, "key", newJString(key))
  add(path_589028, "projectName", newJString(projectName))
  if body != nil:
    body_589030 = body
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  result = call_589027.call(path_589028, query_589029, nil, nil, body_589030)

var replicapoolPoolsInsert* = Call_ReplicapoolPoolsInsert_589013(
    name: "replicapoolPoolsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools",
    validator: validate_ReplicapoolPoolsInsert_589014,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsInsert_589015,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsList_588725 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolPoolsList_588727(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_ReplicapoolPoolsList_588726(path: JsonNode; query: JsonNode;
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
  var valid_588853 = path.getOrDefault("zone")
  valid_588853 = validateParameter(valid_588853, JString, required = true,
                                 default = nil)
  if valid_588853 != nil:
    section.add "zone", valid_588853
  var valid_588854 = path.getOrDefault("projectName")
  valid_588854 = validateParameter(valid_588854, JString, required = true,
                                 default = nil)
  if valid_588854 != nil:
    section.add "projectName", valid_588854
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Set this to the nextPageToken value returned by a previous list request to obtain the next page of results from the previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 100, inclusive. (Default: 50)
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588855 = query.getOrDefault("fields")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "fields", valid_588855
  var valid_588856 = query.getOrDefault("pageToken")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "pageToken", valid_588856
  var valid_588857 = query.getOrDefault("quotaUser")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "quotaUser", valid_588857
  var valid_588871 = query.getOrDefault("alt")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = newJString("json"))
  if valid_588871 != nil:
    section.add "alt", valid_588871
  var valid_588872 = query.getOrDefault("oauth_token")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "oauth_token", valid_588872
  var valid_588873 = query.getOrDefault("userIp")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = nil)
  if valid_588873 != nil:
    section.add "userIp", valid_588873
  var valid_588875 = query.getOrDefault("maxResults")
  valid_588875 = validateParameter(valid_588875, JInt, required = false,
                                 default = newJInt(500))
  if valid_588875 != nil:
    section.add "maxResults", valid_588875
  var valid_588876 = query.getOrDefault("key")
  valid_588876 = validateParameter(valid_588876, JString, required = false,
                                 default = nil)
  if valid_588876 != nil:
    section.add "key", valid_588876
  var valid_588877 = query.getOrDefault("prettyPrint")
  valid_588877 = validateParameter(valid_588877, JBool, required = false,
                                 default = newJBool(true))
  if valid_588877 != nil:
    section.add "prettyPrint", valid_588877
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588900: Call_ReplicapoolPoolsList_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all replica pools.
  ## 
  let valid = call_588900.validator(path, query, header, formData, body)
  let scheme = call_588900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588900.url(scheme.get, call_588900.host, call_588900.base,
                         call_588900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588900, url, valid)

proc call*(call_588971: Call_ReplicapoolPoolsList_588725; zone: string;
          projectName: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## replicapoolPoolsList
  ## List all replica pools.
  ##   zone: string (required)
  ##       : The zone for this replica pool.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Set this to the nextPageToken value returned by a previous list request to obtain the next page of results from the previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 100, inclusive. (Default: 50)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588972 = newJObject()
  var query_588974 = newJObject()
  add(path_588972, "zone", newJString(zone))
  add(query_588974, "fields", newJString(fields))
  add(query_588974, "pageToken", newJString(pageToken))
  add(query_588974, "quotaUser", newJString(quotaUser))
  add(query_588974, "alt", newJString(alt))
  add(query_588974, "oauth_token", newJString(oauthToken))
  add(query_588974, "userIp", newJString(userIp))
  add(query_588974, "maxResults", newJInt(maxResults))
  add(query_588974, "key", newJString(key))
  add(path_588972, "projectName", newJString(projectName))
  add(query_588974, "prettyPrint", newJBool(prettyPrint))
  result = call_588971.call(path_588972, query_588974, nil, nil, nil)

var replicapoolPoolsList* = Call_ReplicapoolPoolsList_588725(
    name: "replicapoolPoolsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools",
    validator: validate_ReplicapoolPoolsList_588726,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsList_588727,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsDelete_589048 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolPoolsDelete_589050(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_ReplicapoolPoolsDelete_589049(path: JsonNode; query: JsonNode;
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
  var valid_589051 = path.getOrDefault("poolName")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "poolName", valid_589051
  var valid_589052 = path.getOrDefault("zone")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = nil)
  if valid_589052 != nil:
    section.add "zone", valid_589052
  var valid_589053 = path.getOrDefault("projectName")
  valid_589053 = validateParameter(valid_589053, JString, required = true,
                                 default = nil)
  if valid_589053 != nil:
    section.add "projectName", valid_589053
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589062: Call_ReplicapoolPoolsDelete_589048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a replica pool.
  ## 
  let valid = call_589062.validator(path, query, header, formData, body)
  let scheme = call_589062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589062.url(scheme.get, call_589062.host, call_589062.base,
                         call_589062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589062, url, valid)

proc call*(call_589063: Call_ReplicapoolPoolsDelete_589048; poolName: string;
          zone: string; projectName: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## replicapoolPoolsDelete
  ## Deletes a replica pool.
  ##   poolName: string (required)
  ##           : The name of the replica pool for this request.
  ##   zone: string (required)
  ##       : The zone for this replica pool.
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
  ##   projectName: string (required)
  ##              : The project ID for this replica pool.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589064 = newJObject()
  var query_589065 = newJObject()
  var body_589066 = newJObject()
  add(path_589064, "poolName", newJString(poolName))
  add(path_589064, "zone", newJString(zone))
  add(query_589065, "fields", newJString(fields))
  add(query_589065, "quotaUser", newJString(quotaUser))
  add(query_589065, "alt", newJString(alt))
  add(query_589065, "oauth_token", newJString(oauthToken))
  add(query_589065, "userIp", newJString(userIp))
  add(query_589065, "key", newJString(key))
  add(path_589064, "projectName", newJString(projectName))
  if body != nil:
    body_589066 = body
  add(query_589065, "prettyPrint", newJBool(prettyPrint))
  result = call_589063.call(path_589064, query_589065, nil, nil, body_589066)

var replicapoolPoolsDelete* = Call_ReplicapoolPoolsDelete_589048(
    name: "replicapoolPoolsDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}",
    validator: validate_ReplicapoolPoolsDelete_589049,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsDelete_589050,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsGet_589031 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolPoolsGet_589033(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_ReplicapoolPoolsGet_589032(path: JsonNode; query: JsonNode;
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
  var valid_589034 = path.getOrDefault("poolName")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "poolName", valid_589034
  var valid_589035 = path.getOrDefault("zone")
  valid_589035 = validateParameter(valid_589035, JString, required = true,
                                 default = nil)
  if valid_589035 != nil:
    section.add "zone", valid_589035
  var valid_589036 = path.getOrDefault("projectName")
  valid_589036 = validateParameter(valid_589036, JString, required = true,
                                 default = nil)
  if valid_589036 != nil:
    section.add "projectName", valid_589036
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
  var valid_589037 = query.getOrDefault("fields")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "fields", valid_589037
  var valid_589038 = query.getOrDefault("quotaUser")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "quotaUser", valid_589038
  var valid_589039 = query.getOrDefault("alt")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("json"))
  if valid_589039 != nil:
    section.add "alt", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("userIp")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "userIp", valid_589041
  var valid_589042 = query.getOrDefault("key")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "key", valid_589042
  var valid_589043 = query.getOrDefault("prettyPrint")
  valid_589043 = validateParameter(valid_589043, JBool, required = false,
                                 default = newJBool(true))
  if valid_589043 != nil:
    section.add "prettyPrint", valid_589043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589044: Call_ReplicapoolPoolsGet_589031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a single replica pool.
  ## 
  let valid = call_589044.validator(path, query, header, formData, body)
  let scheme = call_589044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589044.url(scheme.get, call_589044.host, call_589044.base,
                         call_589044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589044, url, valid)

proc call*(call_589045: Call_ReplicapoolPoolsGet_589031; poolName: string;
          zone: string; projectName: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolPoolsGet
  ## Gets information about a single replica pool.
  ##   poolName: string (required)
  ##           : The name of the replica pool for this request.
  ##   zone: string (required)
  ##       : The zone for this replica pool.
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
  ##   projectName: string (required)
  ##              : The project ID for this replica pool.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589046 = newJObject()
  var query_589047 = newJObject()
  add(path_589046, "poolName", newJString(poolName))
  add(path_589046, "zone", newJString(zone))
  add(query_589047, "fields", newJString(fields))
  add(query_589047, "quotaUser", newJString(quotaUser))
  add(query_589047, "alt", newJString(alt))
  add(query_589047, "oauth_token", newJString(oauthToken))
  add(query_589047, "userIp", newJString(userIp))
  add(query_589047, "key", newJString(key))
  add(path_589046, "projectName", newJString(projectName))
  add(query_589047, "prettyPrint", newJBool(prettyPrint))
  result = call_589045.call(path_589046, query_589047, nil, nil, nil)

var replicapoolPoolsGet* = Call_ReplicapoolPoolsGet_589031(
    name: "replicapoolPoolsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}",
    validator: validate_ReplicapoolPoolsGet_589032,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsGet_589033,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasList_589067 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolReplicasList_589069(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_ReplicapoolReplicasList_589068(path: JsonNode; query: JsonNode;
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
  var valid_589070 = path.getOrDefault("poolName")
  valid_589070 = validateParameter(valid_589070, JString, required = true,
                                 default = nil)
  if valid_589070 != nil:
    section.add "poolName", valid_589070
  var valid_589071 = path.getOrDefault("zone")
  valid_589071 = validateParameter(valid_589071, JString, required = true,
                                 default = nil)
  if valid_589071 != nil:
    section.add "zone", valid_589071
  var valid_589072 = path.getOrDefault("projectName")
  valid_589072 = validateParameter(valid_589072, JString, required = true,
                                 default = nil)
  if valid_589072 != nil:
    section.add "projectName", valid_589072
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Set this to the nextPageToken value returned by a previous list request to obtain the next page of results from the previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 100, inclusive. (Default: 50)
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589073 = query.getOrDefault("fields")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "fields", valid_589073
  var valid_589074 = query.getOrDefault("pageToken")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "pageToken", valid_589074
  var valid_589075 = query.getOrDefault("quotaUser")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "quotaUser", valid_589075
  var valid_589076 = query.getOrDefault("alt")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("json"))
  if valid_589076 != nil:
    section.add "alt", valid_589076
  var valid_589077 = query.getOrDefault("oauth_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "oauth_token", valid_589077
  var valid_589078 = query.getOrDefault("userIp")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "userIp", valid_589078
  var valid_589079 = query.getOrDefault("maxResults")
  valid_589079 = validateParameter(valid_589079, JInt, required = false,
                                 default = newJInt(500))
  if valid_589079 != nil:
    section.add "maxResults", valid_589079
  var valid_589080 = query.getOrDefault("key")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "key", valid_589080
  var valid_589081 = query.getOrDefault("prettyPrint")
  valid_589081 = validateParameter(valid_589081, JBool, required = false,
                                 default = newJBool(true))
  if valid_589081 != nil:
    section.add "prettyPrint", valid_589081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589082: Call_ReplicapoolReplicasList_589067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all replicas in a pool.
  ## 
  let valid = call_589082.validator(path, query, header, formData, body)
  let scheme = call_589082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589082.url(scheme.get, call_589082.host, call_589082.base,
                         call_589082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589082, url, valid)

proc call*(call_589083: Call_ReplicapoolReplicasList_589067; poolName: string;
          zone: string; projectName: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 500;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolReplicasList
  ## Lists all replicas in a pool.
  ##   poolName: string (required)
  ##           : The replica pool name for this request.
  ##   zone: string (required)
  ##       : The zone where the replica pool lives.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Set this to the nextPageToken value returned by a previous list request to obtain the next page of results from the previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 100, inclusive. (Default: 50)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589084 = newJObject()
  var query_589085 = newJObject()
  add(path_589084, "poolName", newJString(poolName))
  add(path_589084, "zone", newJString(zone))
  add(query_589085, "fields", newJString(fields))
  add(query_589085, "pageToken", newJString(pageToken))
  add(query_589085, "quotaUser", newJString(quotaUser))
  add(query_589085, "alt", newJString(alt))
  add(query_589085, "oauth_token", newJString(oauthToken))
  add(query_589085, "userIp", newJString(userIp))
  add(query_589085, "maxResults", newJInt(maxResults))
  add(query_589085, "key", newJString(key))
  add(path_589084, "projectName", newJString(projectName))
  add(query_589085, "prettyPrint", newJBool(prettyPrint))
  result = call_589083.call(path_589084, query_589085, nil, nil, nil)

var replicapoolReplicasList* = Call_ReplicapoolReplicasList_589067(
    name: "replicapoolReplicasList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas",
    validator: validate_ReplicapoolReplicasList_589068,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasList_589069,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasDelete_589104 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolReplicasDelete_589106(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_ReplicapoolReplicasDelete_589105(path: JsonNode; query: JsonNode;
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
  var valid_589107 = path.getOrDefault("poolName")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "poolName", valid_589107
  var valid_589108 = path.getOrDefault("zone")
  valid_589108 = validateParameter(valid_589108, JString, required = true,
                                 default = nil)
  if valid_589108 != nil:
    section.add "zone", valid_589108
  var valid_589109 = path.getOrDefault("projectName")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = nil)
  if valid_589109 != nil:
    section.add "projectName", valid_589109
  var valid_589110 = path.getOrDefault("replicaName")
  valid_589110 = validateParameter(valid_589110, JString, required = true,
                                 default = nil)
  if valid_589110 != nil:
    section.add "replicaName", valid_589110
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
  var valid_589111 = query.getOrDefault("fields")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "fields", valid_589111
  var valid_589112 = query.getOrDefault("quotaUser")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "quotaUser", valid_589112
  var valid_589113 = query.getOrDefault("alt")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("json"))
  if valid_589113 != nil:
    section.add "alt", valid_589113
  var valid_589114 = query.getOrDefault("oauth_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "oauth_token", valid_589114
  var valid_589115 = query.getOrDefault("userIp")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "userIp", valid_589115
  var valid_589116 = query.getOrDefault("key")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "key", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
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

proc call*(call_589119: Call_ReplicapoolReplicasDelete_589104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a replica from the pool.
  ## 
  let valid = call_589119.validator(path, query, header, formData, body)
  let scheme = call_589119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589119.url(scheme.get, call_589119.host, call_589119.base,
                         call_589119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589119, url, valid)

proc call*(call_589120: Call_ReplicapoolReplicasDelete_589104; poolName: string;
          zone: string; projectName: string; replicaName: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## replicapoolReplicasDelete
  ## Deletes a replica from the pool.
  ##   poolName: string (required)
  ##           : The replica pool name for this request.
  ##   zone: string (required)
  ##       : The zone where the replica lives.
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
  ##   projectName: string (required)
  ##              : The project ID for this request.
  ##   replicaName: string (required)
  ##              : The name of the replica for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589121 = newJObject()
  var query_589122 = newJObject()
  var body_589123 = newJObject()
  add(path_589121, "poolName", newJString(poolName))
  add(path_589121, "zone", newJString(zone))
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(query_589122, "alt", newJString(alt))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(query_589122, "userIp", newJString(userIp))
  add(query_589122, "key", newJString(key))
  add(path_589121, "projectName", newJString(projectName))
  add(path_589121, "replicaName", newJString(replicaName))
  if body != nil:
    body_589123 = body
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  result = call_589120.call(path_589121, query_589122, nil, nil, body_589123)

var replicapoolReplicasDelete* = Call_ReplicapoolReplicasDelete_589104(
    name: "replicapoolReplicasDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}",
    validator: validate_ReplicapoolReplicasDelete_589105,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasDelete_589106,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasGet_589086 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolReplicasGet_589088(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_ReplicapoolReplicasGet_589087(path: JsonNode; query: JsonNode;
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
  var valid_589089 = path.getOrDefault("poolName")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "poolName", valid_589089
  var valid_589090 = path.getOrDefault("zone")
  valid_589090 = validateParameter(valid_589090, JString, required = true,
                                 default = nil)
  if valid_589090 != nil:
    section.add "zone", valid_589090
  var valid_589091 = path.getOrDefault("projectName")
  valid_589091 = validateParameter(valid_589091, JString, required = true,
                                 default = nil)
  if valid_589091 != nil:
    section.add "projectName", valid_589091
  var valid_589092 = path.getOrDefault("replicaName")
  valid_589092 = validateParameter(valid_589092, JString, required = true,
                                 default = nil)
  if valid_589092 != nil:
    section.add "replicaName", valid_589092
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
  var valid_589093 = query.getOrDefault("fields")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "fields", valid_589093
  var valid_589094 = query.getOrDefault("quotaUser")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "quotaUser", valid_589094
  var valid_589095 = query.getOrDefault("alt")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("json"))
  if valid_589095 != nil:
    section.add "alt", valid_589095
  var valid_589096 = query.getOrDefault("oauth_token")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "oauth_token", valid_589096
  var valid_589097 = query.getOrDefault("userIp")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "userIp", valid_589097
  var valid_589098 = query.getOrDefault("key")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "key", valid_589098
  var valid_589099 = query.getOrDefault("prettyPrint")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "prettyPrint", valid_589099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589100: Call_ReplicapoolReplicasGet_589086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific replica.
  ## 
  let valid = call_589100.validator(path, query, header, formData, body)
  let scheme = call_589100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589100.url(scheme.get, call_589100.host, call_589100.base,
                         call_589100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589100, url, valid)

proc call*(call_589101: Call_ReplicapoolReplicasGet_589086; poolName: string;
          zone: string; projectName: string; replicaName: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolReplicasGet
  ## Gets information about a specific replica.
  ##   poolName: string (required)
  ##           : The replica pool name for this request.
  ##   zone: string (required)
  ##       : The zone where the replica lives.
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
  ##   projectName: string (required)
  ##              : The project ID for this request.
  ##   replicaName: string (required)
  ##              : The name of the replica for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589102 = newJObject()
  var query_589103 = newJObject()
  add(path_589102, "poolName", newJString(poolName))
  add(path_589102, "zone", newJString(zone))
  add(query_589103, "fields", newJString(fields))
  add(query_589103, "quotaUser", newJString(quotaUser))
  add(query_589103, "alt", newJString(alt))
  add(query_589103, "oauth_token", newJString(oauthToken))
  add(query_589103, "userIp", newJString(userIp))
  add(query_589103, "key", newJString(key))
  add(path_589102, "projectName", newJString(projectName))
  add(path_589102, "replicaName", newJString(replicaName))
  add(query_589103, "prettyPrint", newJBool(prettyPrint))
  result = call_589101.call(path_589102, query_589103, nil, nil, nil)

var replicapoolReplicasGet* = Call_ReplicapoolReplicasGet_589086(
    name: "replicapoolReplicasGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}",
    validator: validate_ReplicapoolReplicasGet_589087,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasGet_589088,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasRestart_589124 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolReplicasRestart_589126(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_ReplicapoolReplicasRestart_589125(path: JsonNode; query: JsonNode;
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
  var valid_589127 = path.getOrDefault("poolName")
  valid_589127 = validateParameter(valid_589127, JString, required = true,
                                 default = nil)
  if valid_589127 != nil:
    section.add "poolName", valid_589127
  var valid_589128 = path.getOrDefault("zone")
  valid_589128 = validateParameter(valid_589128, JString, required = true,
                                 default = nil)
  if valid_589128 != nil:
    section.add "zone", valid_589128
  var valid_589129 = path.getOrDefault("projectName")
  valid_589129 = validateParameter(valid_589129, JString, required = true,
                                 default = nil)
  if valid_589129 != nil:
    section.add "projectName", valid_589129
  var valid_589130 = path.getOrDefault("replicaName")
  valid_589130 = validateParameter(valid_589130, JString, required = true,
                                 default = nil)
  if valid_589130 != nil:
    section.add "replicaName", valid_589130
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

proc call*(call_589138: Call_ReplicapoolReplicasRestart_589124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a replica in a pool.
  ## 
  let valid = call_589138.validator(path, query, header, formData, body)
  let scheme = call_589138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589138.url(scheme.get, call_589138.host, call_589138.base,
                         call_589138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589138, url, valid)

proc call*(call_589139: Call_ReplicapoolReplicasRestart_589124; poolName: string;
          zone: string; projectName: string; replicaName: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolReplicasRestart
  ## Restarts a replica in a pool.
  ##   poolName: string (required)
  ##           : The replica pool name for this request.
  ##   zone: string (required)
  ##       : The zone where the replica lives.
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
  ##   projectName: string (required)
  ##              : The project ID for this request.
  ##   replicaName: string (required)
  ##              : The name of the replica for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589140 = newJObject()
  var query_589141 = newJObject()
  add(path_589140, "poolName", newJString(poolName))
  add(path_589140, "zone", newJString(zone))
  add(query_589141, "fields", newJString(fields))
  add(query_589141, "quotaUser", newJString(quotaUser))
  add(query_589141, "alt", newJString(alt))
  add(query_589141, "oauth_token", newJString(oauthToken))
  add(query_589141, "userIp", newJString(userIp))
  add(query_589141, "key", newJString(key))
  add(path_589140, "projectName", newJString(projectName))
  add(path_589140, "replicaName", newJString(replicaName))
  add(query_589141, "prettyPrint", newJBool(prettyPrint))
  result = call_589139.call(path_589140, query_589141, nil, nil, nil)

var replicapoolReplicasRestart* = Call_ReplicapoolReplicasRestart_589124(
    name: "replicapoolReplicasRestart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}/restart",
    validator: validate_ReplicapoolReplicasRestart_589125,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasRestart_589126,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsResize_589142 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolPoolsResize_589144(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_ReplicapoolPoolsResize_589143(path: JsonNode; query: JsonNode;
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
  var valid_589145 = path.getOrDefault("poolName")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "poolName", valid_589145
  var valid_589146 = path.getOrDefault("zone")
  valid_589146 = validateParameter(valid_589146, JString, required = true,
                                 default = nil)
  if valid_589146 != nil:
    section.add "zone", valid_589146
  var valid_589147 = path.getOrDefault("projectName")
  valid_589147 = validateParameter(valid_589147, JString, required = true,
                                 default = nil)
  if valid_589147 != nil:
    section.add "projectName", valid_589147
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   numReplicas: JInt
  ##              : The desired number of replicas to resize to. If this number is larger than the existing number of replicas, new replicas will be added. If the number is smaller, then existing replicas will be deleted.
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
  var valid_589148 = query.getOrDefault("fields")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "fields", valid_589148
  var valid_589149 = query.getOrDefault("numReplicas")
  valid_589149 = validateParameter(valid_589149, JInt, required = false, default = nil)
  if valid_589149 != nil:
    section.add "numReplicas", valid_589149
  var valid_589150 = query.getOrDefault("quotaUser")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "quotaUser", valid_589150
  var valid_589151 = query.getOrDefault("alt")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = newJString("json"))
  if valid_589151 != nil:
    section.add "alt", valid_589151
  var valid_589152 = query.getOrDefault("oauth_token")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "oauth_token", valid_589152
  var valid_589153 = query.getOrDefault("userIp")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "userIp", valid_589153
  var valid_589154 = query.getOrDefault("key")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "key", valid_589154
  var valid_589155 = query.getOrDefault("prettyPrint")
  valid_589155 = validateParameter(valid_589155, JBool, required = false,
                                 default = newJBool(true))
  if valid_589155 != nil:
    section.add "prettyPrint", valid_589155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589156: Call_ReplicapoolPoolsResize_589142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resize a pool. This is an asynchronous operation, and multiple overlapping resize requests can be made. Replica Pools will use the information from the last resize request.
  ## 
  let valid = call_589156.validator(path, query, header, formData, body)
  let scheme = call_589156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589156.url(scheme.get, call_589156.host, call_589156.base,
                         call_589156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589156, url, valid)

proc call*(call_589157: Call_ReplicapoolPoolsResize_589142; poolName: string;
          zone: string; projectName: string; fields: string = ""; numReplicas: int = 0;
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolPoolsResize
  ## Resize a pool. This is an asynchronous operation, and multiple overlapping resize requests can be made. Replica Pools will use the information from the last resize request.
  ##   poolName: string (required)
  ##           : The name of the replica pool for this request.
  ##   zone: string (required)
  ##       : The zone for this replica pool.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   numReplicas: int
  ##              : The desired number of replicas to resize to. If this number is larger than the existing number of replicas, new replicas will be added. If the number is smaller, then existing replicas will be deleted.
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
  ##   projectName: string (required)
  ##              : The project ID for this replica pool.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589158 = newJObject()
  var query_589159 = newJObject()
  add(path_589158, "poolName", newJString(poolName))
  add(path_589158, "zone", newJString(zone))
  add(query_589159, "fields", newJString(fields))
  add(query_589159, "numReplicas", newJInt(numReplicas))
  add(query_589159, "quotaUser", newJString(quotaUser))
  add(query_589159, "alt", newJString(alt))
  add(query_589159, "oauth_token", newJString(oauthToken))
  add(query_589159, "userIp", newJString(userIp))
  add(query_589159, "key", newJString(key))
  add(path_589158, "projectName", newJString(projectName))
  add(query_589159, "prettyPrint", newJBool(prettyPrint))
  result = call_589157.call(path_589158, query_589159, nil, nil, nil)

var replicapoolPoolsResize* = Call_ReplicapoolPoolsResize_589142(
    name: "replicapoolPoolsResize", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/resize",
    validator: validate_ReplicapoolPoolsResize_589143,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsResize_589144,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsUpdatetemplate_589160 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolPoolsUpdatetemplate_589162(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_ReplicapoolPoolsUpdatetemplate_589161(path: JsonNode;
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
  var valid_589163 = path.getOrDefault("poolName")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "poolName", valid_589163
  var valid_589164 = path.getOrDefault("zone")
  valid_589164 = validateParameter(valid_589164, JString, required = true,
                                 default = nil)
  if valid_589164 != nil:
    section.add "zone", valid_589164
  var valid_589165 = path.getOrDefault("projectName")
  valid_589165 = validateParameter(valid_589165, JString, required = true,
                                 default = nil)
  if valid_589165 != nil:
    section.add "projectName", valid_589165
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
  var valid_589166 = query.getOrDefault("fields")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "fields", valid_589166
  var valid_589167 = query.getOrDefault("quotaUser")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "quotaUser", valid_589167
  var valid_589168 = query.getOrDefault("alt")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = newJString("json"))
  if valid_589168 != nil:
    section.add "alt", valid_589168
  var valid_589169 = query.getOrDefault("oauth_token")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "oauth_token", valid_589169
  var valid_589170 = query.getOrDefault("userIp")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "userIp", valid_589170
  var valid_589171 = query.getOrDefault("key")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "key", valid_589171
  var valid_589172 = query.getOrDefault("prettyPrint")
  valid_589172 = validateParameter(valid_589172, JBool, required = false,
                                 default = newJBool(true))
  if valid_589172 != nil:
    section.add "prettyPrint", valid_589172
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

proc call*(call_589174: Call_ReplicapoolPoolsUpdatetemplate_589160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the template used by the pool.
  ## 
  let valid = call_589174.validator(path, query, header, formData, body)
  let scheme = call_589174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589174.url(scheme.get, call_589174.host, call_589174.base,
                         call_589174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589174, url, valid)

proc call*(call_589175: Call_ReplicapoolPoolsUpdatetemplate_589160;
          poolName: string; zone: string; projectName: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## replicapoolPoolsUpdatetemplate
  ## Update the template used by the pool.
  ##   poolName: string (required)
  ##           : The name of the replica pool for this request.
  ##   zone: string (required)
  ##       : The zone for this replica pool.
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
  ##   projectName: string (required)
  ##              : The project ID for this replica pool.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589176 = newJObject()
  var query_589177 = newJObject()
  var body_589178 = newJObject()
  add(path_589176, "poolName", newJString(poolName))
  add(path_589176, "zone", newJString(zone))
  add(query_589177, "fields", newJString(fields))
  add(query_589177, "quotaUser", newJString(quotaUser))
  add(query_589177, "alt", newJString(alt))
  add(query_589177, "oauth_token", newJString(oauthToken))
  add(query_589177, "userIp", newJString(userIp))
  add(query_589177, "key", newJString(key))
  add(path_589176, "projectName", newJString(projectName))
  if body != nil:
    body_589178 = body
  add(query_589177, "prettyPrint", newJBool(prettyPrint))
  result = call_589175.call(path_589176, query_589177, nil, nil, body_589178)

var replicapoolPoolsUpdatetemplate* = Call_ReplicapoolPoolsUpdatetemplate_589160(
    name: "replicapoolPoolsUpdatetemplate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/updateTemplate",
    validator: validate_ReplicapoolPoolsUpdatetemplate_589161,
    base: "/replicapool/v1beta1/projects",
    url: url_ReplicapoolPoolsUpdatetemplate_589162, schemes: {Scheme.Https})
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
