
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
  gcpServiceName = "replicapool"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReplicapoolPoolsInsert_579980 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolPoolsInsert_579982(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicapoolPoolsInsert_579981(path: JsonNode; query: JsonNode;
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
  var valid_579983 = path.getOrDefault("zone")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "zone", valid_579983
  var valid_579984 = path.getOrDefault("projectName")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "projectName", valid_579984
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
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("alt")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("json"))
  if valid_579987 != nil:
    section.add "alt", valid_579987
  var valid_579988 = query.getOrDefault("oauth_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "oauth_token", valid_579988
  var valid_579989 = query.getOrDefault("userIp")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "userIp", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("prettyPrint")
  valid_579991 = validateParameter(valid_579991, JBool, required = false,
                                 default = newJBool(true))
  if valid_579991 != nil:
    section.add "prettyPrint", valid_579991
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

proc call*(call_579993: Call_ReplicapoolPoolsInsert_579980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a new replica pool.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_ReplicapoolPoolsInsert_579980; zone: string;
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
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  var body_579997 = newJObject()
  add(path_579995, "zone", newJString(zone))
  add(query_579996, "fields", newJString(fields))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(query_579996, "alt", newJString(alt))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "userIp", newJString(userIp))
  add(query_579996, "key", newJString(key))
  add(path_579995, "projectName", newJString(projectName))
  if body != nil:
    body_579997 = body
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(path_579995, query_579996, nil, nil, body_579997)

var replicapoolPoolsInsert* = Call_ReplicapoolPoolsInsert_579980(
    name: "replicapoolPoolsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools",
    validator: validate_ReplicapoolPoolsInsert_579981,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsInsert_579982,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsList_579692 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolPoolsList_579694(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicapoolPoolsList_579693(path: JsonNode; query: JsonNode;
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
  var valid_579820 = path.getOrDefault("zone")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "zone", valid_579820
  var valid_579821 = path.getOrDefault("projectName")
  valid_579821 = validateParameter(valid_579821, JString, required = true,
                                 default = nil)
  if valid_579821 != nil:
    section.add "projectName", valid_579821
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
  var valid_579822 = query.getOrDefault("fields")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "fields", valid_579822
  var valid_579823 = query.getOrDefault("pageToken")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "pageToken", valid_579823
  var valid_579824 = query.getOrDefault("quotaUser")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "quotaUser", valid_579824
  var valid_579838 = query.getOrDefault("alt")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = newJString("json"))
  if valid_579838 != nil:
    section.add "alt", valid_579838
  var valid_579839 = query.getOrDefault("oauth_token")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "oauth_token", valid_579839
  var valid_579840 = query.getOrDefault("userIp")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "userIp", valid_579840
  var valid_579842 = query.getOrDefault("maxResults")
  valid_579842 = validateParameter(valid_579842, JInt, required = false,
                                 default = newJInt(500))
  if valid_579842 != nil:
    section.add "maxResults", valid_579842
  var valid_579843 = query.getOrDefault("key")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "key", valid_579843
  var valid_579844 = query.getOrDefault("prettyPrint")
  valid_579844 = validateParameter(valid_579844, JBool, required = false,
                                 default = newJBool(true))
  if valid_579844 != nil:
    section.add "prettyPrint", valid_579844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579867: Call_ReplicapoolPoolsList_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all replica pools.
  ## 
  let valid = call_579867.validator(path, query, header, formData, body)
  let scheme = call_579867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579867.url(scheme.get, call_579867.host, call_579867.base,
                         call_579867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579867, url, valid)

proc call*(call_579938: Call_ReplicapoolPoolsList_579692; zone: string;
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
  var path_579939 = newJObject()
  var query_579941 = newJObject()
  add(path_579939, "zone", newJString(zone))
  add(query_579941, "fields", newJString(fields))
  add(query_579941, "pageToken", newJString(pageToken))
  add(query_579941, "quotaUser", newJString(quotaUser))
  add(query_579941, "alt", newJString(alt))
  add(query_579941, "oauth_token", newJString(oauthToken))
  add(query_579941, "userIp", newJString(userIp))
  add(query_579941, "maxResults", newJInt(maxResults))
  add(query_579941, "key", newJString(key))
  add(path_579939, "projectName", newJString(projectName))
  add(query_579941, "prettyPrint", newJBool(prettyPrint))
  result = call_579938.call(path_579939, query_579941, nil, nil, nil)

var replicapoolPoolsList* = Call_ReplicapoolPoolsList_579692(
    name: "replicapoolPoolsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools",
    validator: validate_ReplicapoolPoolsList_579693,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsList_579694,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsDelete_580015 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolPoolsDelete_580017(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicapoolPoolsDelete_580016(path: JsonNode; query: JsonNode;
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
  var valid_580018 = path.getOrDefault("poolName")
  valid_580018 = validateParameter(valid_580018, JString, required = true,
                                 default = nil)
  if valid_580018 != nil:
    section.add "poolName", valid_580018
  var valid_580019 = path.getOrDefault("zone")
  valid_580019 = validateParameter(valid_580019, JString, required = true,
                                 default = nil)
  if valid_580019 != nil:
    section.add "zone", valid_580019
  var valid_580020 = path.getOrDefault("projectName")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "projectName", valid_580020
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
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
  var valid_580022 = query.getOrDefault("quotaUser")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "quotaUser", valid_580022
  var valid_580023 = query.getOrDefault("alt")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("json"))
  if valid_580023 != nil:
    section.add "alt", valid_580023
  var valid_580024 = query.getOrDefault("oauth_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "oauth_token", valid_580024
  var valid_580025 = query.getOrDefault("userIp")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "userIp", valid_580025
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  var valid_580027 = query.getOrDefault("prettyPrint")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "prettyPrint", valid_580027
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

proc call*(call_580029: Call_ReplicapoolPoolsDelete_580015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a replica pool.
  ## 
  let valid = call_580029.validator(path, query, header, formData, body)
  let scheme = call_580029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580029.url(scheme.get, call_580029.host, call_580029.base,
                         call_580029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580029, url, valid)

proc call*(call_580030: Call_ReplicapoolPoolsDelete_580015; poolName: string;
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
  var path_580031 = newJObject()
  var query_580032 = newJObject()
  var body_580033 = newJObject()
  add(path_580031, "poolName", newJString(poolName))
  add(path_580031, "zone", newJString(zone))
  add(query_580032, "fields", newJString(fields))
  add(query_580032, "quotaUser", newJString(quotaUser))
  add(query_580032, "alt", newJString(alt))
  add(query_580032, "oauth_token", newJString(oauthToken))
  add(query_580032, "userIp", newJString(userIp))
  add(query_580032, "key", newJString(key))
  add(path_580031, "projectName", newJString(projectName))
  if body != nil:
    body_580033 = body
  add(query_580032, "prettyPrint", newJBool(prettyPrint))
  result = call_580030.call(path_580031, query_580032, nil, nil, body_580033)

var replicapoolPoolsDelete* = Call_ReplicapoolPoolsDelete_580015(
    name: "replicapoolPoolsDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}",
    validator: validate_ReplicapoolPoolsDelete_580016,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsDelete_580017,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsGet_579998 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolPoolsGet_580000(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicapoolPoolsGet_579999(path: JsonNode; query: JsonNode;
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
  var valid_580001 = path.getOrDefault("poolName")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "poolName", valid_580001
  var valid_580002 = path.getOrDefault("zone")
  valid_580002 = validateParameter(valid_580002, JString, required = true,
                                 default = nil)
  if valid_580002 != nil:
    section.add "zone", valid_580002
  var valid_580003 = path.getOrDefault("projectName")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "projectName", valid_580003
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
  var valid_580004 = query.getOrDefault("fields")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "fields", valid_580004
  var valid_580005 = query.getOrDefault("quotaUser")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "quotaUser", valid_580005
  var valid_580006 = query.getOrDefault("alt")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = newJString("json"))
  if valid_580006 != nil:
    section.add "alt", valid_580006
  var valid_580007 = query.getOrDefault("oauth_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "oauth_token", valid_580007
  var valid_580008 = query.getOrDefault("userIp")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "userIp", valid_580008
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("prettyPrint")
  valid_580010 = validateParameter(valid_580010, JBool, required = false,
                                 default = newJBool(true))
  if valid_580010 != nil:
    section.add "prettyPrint", valid_580010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580011: Call_ReplicapoolPoolsGet_579998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a single replica pool.
  ## 
  let valid = call_580011.validator(path, query, header, formData, body)
  let scheme = call_580011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580011.url(scheme.get, call_580011.host, call_580011.base,
                         call_580011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580011, url, valid)

proc call*(call_580012: Call_ReplicapoolPoolsGet_579998; poolName: string;
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
  var path_580013 = newJObject()
  var query_580014 = newJObject()
  add(path_580013, "poolName", newJString(poolName))
  add(path_580013, "zone", newJString(zone))
  add(query_580014, "fields", newJString(fields))
  add(query_580014, "quotaUser", newJString(quotaUser))
  add(query_580014, "alt", newJString(alt))
  add(query_580014, "oauth_token", newJString(oauthToken))
  add(query_580014, "userIp", newJString(userIp))
  add(query_580014, "key", newJString(key))
  add(path_580013, "projectName", newJString(projectName))
  add(query_580014, "prettyPrint", newJBool(prettyPrint))
  result = call_580012.call(path_580013, query_580014, nil, nil, nil)

var replicapoolPoolsGet* = Call_ReplicapoolPoolsGet_579998(
    name: "replicapoolPoolsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}",
    validator: validate_ReplicapoolPoolsGet_579999,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsGet_580000,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasList_580034 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolReplicasList_580036(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicapoolReplicasList_580035(path: JsonNode; query: JsonNode;
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
  var valid_580037 = path.getOrDefault("poolName")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "poolName", valid_580037
  var valid_580038 = path.getOrDefault("zone")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "zone", valid_580038
  var valid_580039 = path.getOrDefault("projectName")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "projectName", valid_580039
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
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("pageToken")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "pageToken", valid_580041
  var valid_580042 = query.getOrDefault("quotaUser")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "quotaUser", valid_580042
  var valid_580043 = query.getOrDefault("alt")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("json"))
  if valid_580043 != nil:
    section.add "alt", valid_580043
  var valid_580044 = query.getOrDefault("oauth_token")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "oauth_token", valid_580044
  var valid_580045 = query.getOrDefault("userIp")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "userIp", valid_580045
  var valid_580046 = query.getOrDefault("maxResults")
  valid_580046 = validateParameter(valid_580046, JInt, required = false,
                                 default = newJInt(500))
  if valid_580046 != nil:
    section.add "maxResults", valid_580046
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("prettyPrint")
  valid_580048 = validateParameter(valid_580048, JBool, required = false,
                                 default = newJBool(true))
  if valid_580048 != nil:
    section.add "prettyPrint", valid_580048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580049: Call_ReplicapoolReplicasList_580034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all replicas in a pool.
  ## 
  let valid = call_580049.validator(path, query, header, formData, body)
  let scheme = call_580049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580049.url(scheme.get, call_580049.host, call_580049.base,
                         call_580049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580049, url, valid)

proc call*(call_580050: Call_ReplicapoolReplicasList_580034; poolName: string;
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
  var path_580051 = newJObject()
  var query_580052 = newJObject()
  add(path_580051, "poolName", newJString(poolName))
  add(path_580051, "zone", newJString(zone))
  add(query_580052, "fields", newJString(fields))
  add(query_580052, "pageToken", newJString(pageToken))
  add(query_580052, "quotaUser", newJString(quotaUser))
  add(query_580052, "alt", newJString(alt))
  add(query_580052, "oauth_token", newJString(oauthToken))
  add(query_580052, "userIp", newJString(userIp))
  add(query_580052, "maxResults", newJInt(maxResults))
  add(query_580052, "key", newJString(key))
  add(path_580051, "projectName", newJString(projectName))
  add(query_580052, "prettyPrint", newJBool(prettyPrint))
  result = call_580050.call(path_580051, query_580052, nil, nil, nil)

var replicapoolReplicasList* = Call_ReplicapoolReplicasList_580034(
    name: "replicapoolReplicasList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas",
    validator: validate_ReplicapoolReplicasList_580035,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasList_580036,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasDelete_580071 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolReplicasDelete_580073(protocol: Scheme; host: string;
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

proc validate_ReplicapoolReplicasDelete_580072(path: JsonNode; query: JsonNode;
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
  var valid_580074 = path.getOrDefault("poolName")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "poolName", valid_580074
  var valid_580075 = path.getOrDefault("zone")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "zone", valid_580075
  var valid_580076 = path.getOrDefault("projectName")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "projectName", valid_580076
  var valid_580077 = path.getOrDefault("replicaName")
  valid_580077 = validateParameter(valid_580077, JString, required = true,
                                 default = nil)
  if valid_580077 != nil:
    section.add "replicaName", valid_580077
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
  var valid_580078 = query.getOrDefault("fields")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "fields", valid_580078
  var valid_580079 = query.getOrDefault("quotaUser")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "quotaUser", valid_580079
  var valid_580080 = query.getOrDefault("alt")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("json"))
  if valid_580080 != nil:
    section.add "alt", valid_580080
  var valid_580081 = query.getOrDefault("oauth_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "oauth_token", valid_580081
  var valid_580082 = query.getOrDefault("userIp")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "userIp", valid_580082
  var valid_580083 = query.getOrDefault("key")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "key", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
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

proc call*(call_580086: Call_ReplicapoolReplicasDelete_580071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a replica from the pool.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_ReplicapoolReplicasDelete_580071; poolName: string;
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
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  var body_580090 = newJObject()
  add(path_580088, "poolName", newJString(poolName))
  add(path_580088, "zone", newJString(zone))
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "userIp", newJString(userIp))
  add(query_580089, "key", newJString(key))
  add(path_580088, "projectName", newJString(projectName))
  add(path_580088, "replicaName", newJString(replicaName))
  if body != nil:
    body_580090 = body
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  result = call_580087.call(path_580088, query_580089, nil, nil, body_580090)

var replicapoolReplicasDelete* = Call_ReplicapoolReplicasDelete_580071(
    name: "replicapoolReplicasDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}",
    validator: validate_ReplicapoolReplicasDelete_580072,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasDelete_580073,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasGet_580053 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolReplicasGet_580055(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicapoolReplicasGet_580054(path: JsonNode; query: JsonNode;
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
  var valid_580056 = path.getOrDefault("poolName")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "poolName", valid_580056
  var valid_580057 = path.getOrDefault("zone")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "zone", valid_580057
  var valid_580058 = path.getOrDefault("projectName")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "projectName", valid_580058
  var valid_580059 = path.getOrDefault("replicaName")
  valid_580059 = validateParameter(valid_580059, JString, required = true,
                                 default = nil)
  if valid_580059 != nil:
    section.add "replicaName", valid_580059
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
  var valid_580060 = query.getOrDefault("fields")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "fields", valid_580060
  var valid_580061 = query.getOrDefault("quotaUser")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "quotaUser", valid_580061
  var valid_580062 = query.getOrDefault("alt")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("json"))
  if valid_580062 != nil:
    section.add "alt", valid_580062
  var valid_580063 = query.getOrDefault("oauth_token")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "oauth_token", valid_580063
  var valid_580064 = query.getOrDefault("userIp")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "userIp", valid_580064
  var valid_580065 = query.getOrDefault("key")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "key", valid_580065
  var valid_580066 = query.getOrDefault("prettyPrint")
  valid_580066 = validateParameter(valid_580066, JBool, required = false,
                                 default = newJBool(true))
  if valid_580066 != nil:
    section.add "prettyPrint", valid_580066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580067: Call_ReplicapoolReplicasGet_580053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific replica.
  ## 
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_ReplicapoolReplicasGet_580053; poolName: string;
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
  var path_580069 = newJObject()
  var query_580070 = newJObject()
  add(path_580069, "poolName", newJString(poolName))
  add(path_580069, "zone", newJString(zone))
  add(query_580070, "fields", newJString(fields))
  add(query_580070, "quotaUser", newJString(quotaUser))
  add(query_580070, "alt", newJString(alt))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "userIp", newJString(userIp))
  add(query_580070, "key", newJString(key))
  add(path_580069, "projectName", newJString(projectName))
  add(path_580069, "replicaName", newJString(replicaName))
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  result = call_580068.call(path_580069, query_580070, nil, nil, nil)

var replicapoolReplicasGet* = Call_ReplicapoolReplicasGet_580053(
    name: "replicapoolReplicasGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}",
    validator: validate_ReplicapoolReplicasGet_580054,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasGet_580055,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasRestart_580091 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolReplicasRestart_580093(protocol: Scheme; host: string;
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

proc validate_ReplicapoolReplicasRestart_580092(path: JsonNode; query: JsonNode;
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
  var valid_580094 = path.getOrDefault("poolName")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "poolName", valid_580094
  var valid_580095 = path.getOrDefault("zone")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "zone", valid_580095
  var valid_580096 = path.getOrDefault("projectName")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "projectName", valid_580096
  var valid_580097 = path.getOrDefault("replicaName")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "replicaName", valid_580097
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
  var valid_580098 = query.getOrDefault("fields")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "fields", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("alt")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("json"))
  if valid_580100 != nil:
    section.add "alt", valid_580100
  var valid_580101 = query.getOrDefault("oauth_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "oauth_token", valid_580101
  var valid_580102 = query.getOrDefault("userIp")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "userIp", valid_580102
  var valid_580103 = query.getOrDefault("key")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "key", valid_580103
  var valid_580104 = query.getOrDefault("prettyPrint")
  valid_580104 = validateParameter(valid_580104, JBool, required = false,
                                 default = newJBool(true))
  if valid_580104 != nil:
    section.add "prettyPrint", valid_580104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580105: Call_ReplicapoolReplicasRestart_580091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a replica in a pool.
  ## 
  let valid = call_580105.validator(path, query, header, formData, body)
  let scheme = call_580105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580105.url(scheme.get, call_580105.host, call_580105.base,
                         call_580105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580105, url, valid)

proc call*(call_580106: Call_ReplicapoolReplicasRestart_580091; poolName: string;
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
  var path_580107 = newJObject()
  var query_580108 = newJObject()
  add(path_580107, "poolName", newJString(poolName))
  add(path_580107, "zone", newJString(zone))
  add(query_580108, "fields", newJString(fields))
  add(query_580108, "quotaUser", newJString(quotaUser))
  add(query_580108, "alt", newJString(alt))
  add(query_580108, "oauth_token", newJString(oauthToken))
  add(query_580108, "userIp", newJString(userIp))
  add(query_580108, "key", newJString(key))
  add(path_580107, "projectName", newJString(projectName))
  add(path_580107, "replicaName", newJString(replicaName))
  add(query_580108, "prettyPrint", newJBool(prettyPrint))
  result = call_580106.call(path_580107, query_580108, nil, nil, nil)

var replicapoolReplicasRestart* = Call_ReplicapoolReplicasRestart_580091(
    name: "replicapoolReplicasRestart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}/restart",
    validator: validate_ReplicapoolReplicasRestart_580092,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasRestart_580093,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsResize_580109 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolPoolsResize_580111(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicapoolPoolsResize_580110(path: JsonNode; query: JsonNode;
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
  var valid_580112 = path.getOrDefault("poolName")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "poolName", valid_580112
  var valid_580113 = path.getOrDefault("zone")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "zone", valid_580113
  var valid_580114 = path.getOrDefault("projectName")
  valid_580114 = validateParameter(valid_580114, JString, required = true,
                                 default = nil)
  if valid_580114 != nil:
    section.add "projectName", valid_580114
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
  var valid_580115 = query.getOrDefault("fields")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "fields", valid_580115
  var valid_580116 = query.getOrDefault("numReplicas")
  valid_580116 = validateParameter(valid_580116, JInt, required = false, default = nil)
  if valid_580116 != nil:
    section.add "numReplicas", valid_580116
  var valid_580117 = query.getOrDefault("quotaUser")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "quotaUser", valid_580117
  var valid_580118 = query.getOrDefault("alt")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = newJString("json"))
  if valid_580118 != nil:
    section.add "alt", valid_580118
  var valid_580119 = query.getOrDefault("oauth_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "oauth_token", valid_580119
  var valid_580120 = query.getOrDefault("userIp")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "userIp", valid_580120
  var valid_580121 = query.getOrDefault("key")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "key", valid_580121
  var valid_580122 = query.getOrDefault("prettyPrint")
  valid_580122 = validateParameter(valid_580122, JBool, required = false,
                                 default = newJBool(true))
  if valid_580122 != nil:
    section.add "prettyPrint", valid_580122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580123: Call_ReplicapoolPoolsResize_580109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resize a pool. This is an asynchronous operation, and multiple overlapping resize requests can be made. Replica Pools will use the information from the last resize request.
  ## 
  let valid = call_580123.validator(path, query, header, formData, body)
  let scheme = call_580123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580123.url(scheme.get, call_580123.host, call_580123.base,
                         call_580123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580123, url, valid)

proc call*(call_580124: Call_ReplicapoolPoolsResize_580109; poolName: string;
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
  var path_580125 = newJObject()
  var query_580126 = newJObject()
  add(path_580125, "poolName", newJString(poolName))
  add(path_580125, "zone", newJString(zone))
  add(query_580126, "fields", newJString(fields))
  add(query_580126, "numReplicas", newJInt(numReplicas))
  add(query_580126, "quotaUser", newJString(quotaUser))
  add(query_580126, "alt", newJString(alt))
  add(query_580126, "oauth_token", newJString(oauthToken))
  add(query_580126, "userIp", newJString(userIp))
  add(query_580126, "key", newJString(key))
  add(path_580125, "projectName", newJString(projectName))
  add(query_580126, "prettyPrint", newJBool(prettyPrint))
  result = call_580124.call(path_580125, query_580126, nil, nil, nil)

var replicapoolPoolsResize* = Call_ReplicapoolPoolsResize_580109(
    name: "replicapoolPoolsResize", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/resize",
    validator: validate_ReplicapoolPoolsResize_580110,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsResize_580111,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsUpdatetemplate_580127 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolPoolsUpdatetemplate_580129(protocol: Scheme; host: string;
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

proc validate_ReplicapoolPoolsUpdatetemplate_580128(path: JsonNode;
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
  var valid_580130 = path.getOrDefault("poolName")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "poolName", valid_580130
  var valid_580131 = path.getOrDefault("zone")
  valid_580131 = validateParameter(valid_580131, JString, required = true,
                                 default = nil)
  if valid_580131 != nil:
    section.add "zone", valid_580131
  var valid_580132 = path.getOrDefault("projectName")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "projectName", valid_580132
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
  var valid_580133 = query.getOrDefault("fields")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "fields", valid_580133
  var valid_580134 = query.getOrDefault("quotaUser")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "quotaUser", valid_580134
  var valid_580135 = query.getOrDefault("alt")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = newJString("json"))
  if valid_580135 != nil:
    section.add "alt", valid_580135
  var valid_580136 = query.getOrDefault("oauth_token")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "oauth_token", valid_580136
  var valid_580137 = query.getOrDefault("userIp")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "userIp", valid_580137
  var valid_580138 = query.getOrDefault("key")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "key", valid_580138
  var valid_580139 = query.getOrDefault("prettyPrint")
  valid_580139 = validateParameter(valid_580139, JBool, required = false,
                                 default = newJBool(true))
  if valid_580139 != nil:
    section.add "prettyPrint", valid_580139
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

proc call*(call_580141: Call_ReplicapoolPoolsUpdatetemplate_580127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the template used by the pool.
  ## 
  let valid = call_580141.validator(path, query, header, formData, body)
  let scheme = call_580141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580141.url(scheme.get, call_580141.host, call_580141.base,
                         call_580141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580141, url, valid)

proc call*(call_580142: Call_ReplicapoolPoolsUpdatetemplate_580127;
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
  var path_580143 = newJObject()
  var query_580144 = newJObject()
  var body_580145 = newJObject()
  add(path_580143, "poolName", newJString(poolName))
  add(path_580143, "zone", newJString(zone))
  add(query_580144, "fields", newJString(fields))
  add(query_580144, "quotaUser", newJString(quotaUser))
  add(query_580144, "alt", newJString(alt))
  add(query_580144, "oauth_token", newJString(oauthToken))
  add(query_580144, "userIp", newJString(userIp))
  add(query_580144, "key", newJString(key))
  add(path_580143, "projectName", newJString(projectName))
  if body != nil:
    body_580145 = body
  add(query_580144, "prettyPrint", newJBool(prettyPrint))
  result = call_580142.call(path_580143, query_580144, nil, nil, body_580145)

var replicapoolPoolsUpdatetemplate* = Call_ReplicapoolPoolsUpdatetemplate_580127(
    name: "replicapoolPoolsUpdatetemplate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/updateTemplate",
    validator: validate_ReplicapoolPoolsUpdatetemplate_580128,
    base: "/replicapool/v1beta1/projects",
    url: url_ReplicapoolPoolsUpdatetemplate_580129, schemes: {Scheme.Https})
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
