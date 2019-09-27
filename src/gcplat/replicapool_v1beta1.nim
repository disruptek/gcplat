
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReplicapoolPoolsInsert_593980 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolPoolsInsert_593982(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ReplicapoolPoolsInsert_593981(path: JsonNode; query: JsonNode;
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
  var valid_593983 = path.getOrDefault("zone")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "zone", valid_593983
  var valid_593984 = path.getOrDefault("projectName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "projectName", valid_593984
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
  var valid_593985 = query.getOrDefault("fields")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "fields", valid_593985
  var valid_593986 = query.getOrDefault("quotaUser")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "quotaUser", valid_593986
  var valid_593987 = query.getOrDefault("alt")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = newJString("json"))
  if valid_593987 != nil:
    section.add "alt", valid_593987
  var valid_593988 = query.getOrDefault("oauth_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "oauth_token", valid_593988
  var valid_593989 = query.getOrDefault("userIp")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "userIp", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("prettyPrint")
  valid_593991 = validateParameter(valid_593991, JBool, required = false,
                                 default = newJBool(true))
  if valid_593991 != nil:
    section.add "prettyPrint", valid_593991
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

proc call*(call_593993: Call_ReplicapoolPoolsInsert_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a new replica pool.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_ReplicapoolPoolsInsert_593980; zone: string;
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  var body_593997 = newJObject()
  add(path_593995, "zone", newJString(zone))
  add(query_593996, "fields", newJString(fields))
  add(query_593996, "quotaUser", newJString(quotaUser))
  add(query_593996, "alt", newJString(alt))
  add(query_593996, "oauth_token", newJString(oauthToken))
  add(query_593996, "userIp", newJString(userIp))
  add(query_593996, "key", newJString(key))
  add(path_593995, "projectName", newJString(projectName))
  if body != nil:
    body_593997 = body
  add(query_593996, "prettyPrint", newJBool(prettyPrint))
  result = call_593994.call(path_593995, query_593996, nil, nil, body_593997)

var replicapoolPoolsInsert* = Call_ReplicapoolPoolsInsert_593980(
    name: "replicapoolPoolsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools",
    validator: validate_ReplicapoolPoolsInsert_593981,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsInsert_593982,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsList_593692 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolPoolsList_593694(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ReplicapoolPoolsList_593693(path: JsonNode; query: JsonNode;
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
  var valid_593820 = path.getOrDefault("zone")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "zone", valid_593820
  var valid_593821 = path.getOrDefault("projectName")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "projectName", valid_593821
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
  var valid_593822 = query.getOrDefault("fields")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "fields", valid_593822
  var valid_593823 = query.getOrDefault("pageToken")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "pageToken", valid_593823
  var valid_593824 = query.getOrDefault("quotaUser")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "quotaUser", valid_593824
  var valid_593838 = query.getOrDefault("alt")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = newJString("json"))
  if valid_593838 != nil:
    section.add "alt", valid_593838
  var valid_593839 = query.getOrDefault("oauth_token")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "oauth_token", valid_593839
  var valid_593840 = query.getOrDefault("userIp")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "userIp", valid_593840
  var valid_593842 = query.getOrDefault("maxResults")
  valid_593842 = validateParameter(valid_593842, JInt, required = false,
                                 default = newJInt(500))
  if valid_593842 != nil:
    section.add "maxResults", valid_593842
  var valid_593843 = query.getOrDefault("key")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "key", valid_593843
  var valid_593844 = query.getOrDefault("prettyPrint")
  valid_593844 = validateParameter(valid_593844, JBool, required = false,
                                 default = newJBool(true))
  if valid_593844 != nil:
    section.add "prettyPrint", valid_593844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593867: Call_ReplicapoolPoolsList_593692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all replica pools.
  ## 
  let valid = call_593867.validator(path, query, header, formData, body)
  let scheme = call_593867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593867.url(scheme.get, call_593867.host, call_593867.base,
                         call_593867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593867, url, valid)

proc call*(call_593938: Call_ReplicapoolPoolsList_593692; zone: string;
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
  var path_593939 = newJObject()
  var query_593941 = newJObject()
  add(path_593939, "zone", newJString(zone))
  add(query_593941, "fields", newJString(fields))
  add(query_593941, "pageToken", newJString(pageToken))
  add(query_593941, "quotaUser", newJString(quotaUser))
  add(query_593941, "alt", newJString(alt))
  add(query_593941, "oauth_token", newJString(oauthToken))
  add(query_593941, "userIp", newJString(userIp))
  add(query_593941, "maxResults", newJInt(maxResults))
  add(query_593941, "key", newJString(key))
  add(path_593939, "projectName", newJString(projectName))
  add(query_593941, "prettyPrint", newJBool(prettyPrint))
  result = call_593938.call(path_593939, query_593941, nil, nil, nil)

var replicapoolPoolsList* = Call_ReplicapoolPoolsList_593692(
    name: "replicapoolPoolsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools",
    validator: validate_ReplicapoolPoolsList_593693,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsList_593694,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsDelete_594015 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolPoolsDelete_594017(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ReplicapoolPoolsDelete_594016(path: JsonNode; query: JsonNode;
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
  var valid_594018 = path.getOrDefault("poolName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "poolName", valid_594018
  var valid_594019 = path.getOrDefault("zone")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "zone", valid_594019
  var valid_594020 = path.getOrDefault("projectName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "projectName", valid_594020
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
  var valid_594021 = query.getOrDefault("fields")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "fields", valid_594021
  var valid_594022 = query.getOrDefault("quotaUser")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "quotaUser", valid_594022
  var valid_594023 = query.getOrDefault("alt")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = newJString("json"))
  if valid_594023 != nil:
    section.add "alt", valid_594023
  var valid_594024 = query.getOrDefault("oauth_token")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "oauth_token", valid_594024
  var valid_594025 = query.getOrDefault("userIp")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "userIp", valid_594025
  var valid_594026 = query.getOrDefault("key")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "key", valid_594026
  var valid_594027 = query.getOrDefault("prettyPrint")
  valid_594027 = validateParameter(valid_594027, JBool, required = false,
                                 default = newJBool(true))
  if valid_594027 != nil:
    section.add "prettyPrint", valid_594027
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

proc call*(call_594029: Call_ReplicapoolPoolsDelete_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a replica pool.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_ReplicapoolPoolsDelete_594015; poolName: string;
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
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  var body_594033 = newJObject()
  add(path_594031, "poolName", newJString(poolName))
  add(path_594031, "zone", newJString(zone))
  add(query_594032, "fields", newJString(fields))
  add(query_594032, "quotaUser", newJString(quotaUser))
  add(query_594032, "alt", newJString(alt))
  add(query_594032, "oauth_token", newJString(oauthToken))
  add(query_594032, "userIp", newJString(userIp))
  add(query_594032, "key", newJString(key))
  add(path_594031, "projectName", newJString(projectName))
  if body != nil:
    body_594033 = body
  add(query_594032, "prettyPrint", newJBool(prettyPrint))
  result = call_594030.call(path_594031, query_594032, nil, nil, body_594033)

var replicapoolPoolsDelete* = Call_ReplicapoolPoolsDelete_594015(
    name: "replicapoolPoolsDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}",
    validator: validate_ReplicapoolPoolsDelete_594016,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsDelete_594017,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsGet_593998 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolPoolsGet_594000(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ReplicapoolPoolsGet_593999(path: JsonNode; query: JsonNode;
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
  var valid_594001 = path.getOrDefault("poolName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "poolName", valid_594001
  var valid_594002 = path.getOrDefault("zone")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "zone", valid_594002
  var valid_594003 = path.getOrDefault("projectName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "projectName", valid_594003
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
  var valid_594004 = query.getOrDefault("fields")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "fields", valid_594004
  var valid_594005 = query.getOrDefault("quotaUser")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "quotaUser", valid_594005
  var valid_594006 = query.getOrDefault("alt")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = newJString("json"))
  if valid_594006 != nil:
    section.add "alt", valid_594006
  var valid_594007 = query.getOrDefault("oauth_token")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "oauth_token", valid_594007
  var valid_594008 = query.getOrDefault("userIp")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "userIp", valid_594008
  var valid_594009 = query.getOrDefault("key")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "key", valid_594009
  var valid_594010 = query.getOrDefault("prettyPrint")
  valid_594010 = validateParameter(valid_594010, JBool, required = false,
                                 default = newJBool(true))
  if valid_594010 != nil:
    section.add "prettyPrint", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_ReplicapoolPoolsGet_593998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a single replica pool.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_ReplicapoolPoolsGet_593998; poolName: string;
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
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(path_594013, "poolName", newJString(poolName))
  add(path_594013, "zone", newJString(zone))
  add(query_594014, "fields", newJString(fields))
  add(query_594014, "quotaUser", newJString(quotaUser))
  add(query_594014, "alt", newJString(alt))
  add(query_594014, "oauth_token", newJString(oauthToken))
  add(query_594014, "userIp", newJString(userIp))
  add(query_594014, "key", newJString(key))
  add(path_594013, "projectName", newJString(projectName))
  add(query_594014, "prettyPrint", newJBool(prettyPrint))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var replicapoolPoolsGet* = Call_ReplicapoolPoolsGet_593998(
    name: "replicapoolPoolsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}",
    validator: validate_ReplicapoolPoolsGet_593999,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsGet_594000,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasList_594034 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolReplicasList_594036(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ReplicapoolReplicasList_594035(path: JsonNode; query: JsonNode;
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
  var valid_594037 = path.getOrDefault("poolName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "poolName", valid_594037
  var valid_594038 = path.getOrDefault("zone")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "zone", valid_594038
  var valid_594039 = path.getOrDefault("projectName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "projectName", valid_594039
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
  var valid_594040 = query.getOrDefault("fields")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "fields", valid_594040
  var valid_594041 = query.getOrDefault("pageToken")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "pageToken", valid_594041
  var valid_594042 = query.getOrDefault("quotaUser")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "quotaUser", valid_594042
  var valid_594043 = query.getOrDefault("alt")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = newJString("json"))
  if valid_594043 != nil:
    section.add "alt", valid_594043
  var valid_594044 = query.getOrDefault("oauth_token")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "oauth_token", valid_594044
  var valid_594045 = query.getOrDefault("userIp")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "userIp", valid_594045
  var valid_594046 = query.getOrDefault("maxResults")
  valid_594046 = validateParameter(valid_594046, JInt, required = false,
                                 default = newJInt(500))
  if valid_594046 != nil:
    section.add "maxResults", valid_594046
  var valid_594047 = query.getOrDefault("key")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "key", valid_594047
  var valid_594048 = query.getOrDefault("prettyPrint")
  valid_594048 = validateParameter(valid_594048, JBool, required = false,
                                 default = newJBool(true))
  if valid_594048 != nil:
    section.add "prettyPrint", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_ReplicapoolReplicasList_594034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all replicas in a pool.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_ReplicapoolReplicasList_594034; poolName: string;
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
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  add(path_594051, "poolName", newJString(poolName))
  add(path_594051, "zone", newJString(zone))
  add(query_594052, "fields", newJString(fields))
  add(query_594052, "pageToken", newJString(pageToken))
  add(query_594052, "quotaUser", newJString(quotaUser))
  add(query_594052, "alt", newJString(alt))
  add(query_594052, "oauth_token", newJString(oauthToken))
  add(query_594052, "userIp", newJString(userIp))
  add(query_594052, "maxResults", newJInt(maxResults))
  add(query_594052, "key", newJString(key))
  add(path_594051, "projectName", newJString(projectName))
  add(query_594052, "prettyPrint", newJBool(prettyPrint))
  result = call_594050.call(path_594051, query_594052, nil, nil, nil)

var replicapoolReplicasList* = Call_ReplicapoolReplicasList_594034(
    name: "replicapoolReplicasList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas",
    validator: validate_ReplicapoolReplicasList_594035,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasList_594036,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasDelete_594071 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolReplicasDelete_594073(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ReplicapoolReplicasDelete_594072(path: JsonNode; query: JsonNode;
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
  var valid_594074 = path.getOrDefault("poolName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "poolName", valid_594074
  var valid_594075 = path.getOrDefault("zone")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "zone", valid_594075
  var valid_594076 = path.getOrDefault("projectName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "projectName", valid_594076
  var valid_594077 = path.getOrDefault("replicaName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "replicaName", valid_594077
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
  var valid_594078 = query.getOrDefault("fields")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "fields", valid_594078
  var valid_594079 = query.getOrDefault("quotaUser")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "quotaUser", valid_594079
  var valid_594080 = query.getOrDefault("alt")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = newJString("json"))
  if valid_594080 != nil:
    section.add "alt", valid_594080
  var valid_594081 = query.getOrDefault("oauth_token")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "oauth_token", valid_594081
  var valid_594082 = query.getOrDefault("userIp")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "userIp", valid_594082
  var valid_594083 = query.getOrDefault("key")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "key", valid_594083
  var valid_594084 = query.getOrDefault("prettyPrint")
  valid_594084 = validateParameter(valid_594084, JBool, required = false,
                                 default = newJBool(true))
  if valid_594084 != nil:
    section.add "prettyPrint", valid_594084
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

proc call*(call_594086: Call_ReplicapoolReplicasDelete_594071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a replica from the pool.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_ReplicapoolReplicasDelete_594071; poolName: string;
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
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  var body_594090 = newJObject()
  add(path_594088, "poolName", newJString(poolName))
  add(path_594088, "zone", newJString(zone))
  add(query_594089, "fields", newJString(fields))
  add(query_594089, "quotaUser", newJString(quotaUser))
  add(query_594089, "alt", newJString(alt))
  add(query_594089, "oauth_token", newJString(oauthToken))
  add(query_594089, "userIp", newJString(userIp))
  add(query_594089, "key", newJString(key))
  add(path_594088, "projectName", newJString(projectName))
  add(path_594088, "replicaName", newJString(replicaName))
  if body != nil:
    body_594090 = body
  add(query_594089, "prettyPrint", newJBool(prettyPrint))
  result = call_594087.call(path_594088, query_594089, nil, nil, body_594090)

var replicapoolReplicasDelete* = Call_ReplicapoolReplicasDelete_594071(
    name: "replicapoolReplicasDelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}",
    validator: validate_ReplicapoolReplicasDelete_594072,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasDelete_594073,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasGet_594053 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolReplicasGet_594055(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ReplicapoolReplicasGet_594054(path: JsonNode; query: JsonNode;
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
  var valid_594056 = path.getOrDefault("poolName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "poolName", valid_594056
  var valid_594057 = path.getOrDefault("zone")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "zone", valid_594057
  var valid_594058 = path.getOrDefault("projectName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "projectName", valid_594058
  var valid_594059 = path.getOrDefault("replicaName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "replicaName", valid_594059
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
  var valid_594060 = query.getOrDefault("fields")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "fields", valid_594060
  var valid_594061 = query.getOrDefault("quotaUser")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "quotaUser", valid_594061
  var valid_594062 = query.getOrDefault("alt")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = newJString("json"))
  if valid_594062 != nil:
    section.add "alt", valid_594062
  var valid_594063 = query.getOrDefault("oauth_token")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "oauth_token", valid_594063
  var valid_594064 = query.getOrDefault("userIp")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "userIp", valid_594064
  var valid_594065 = query.getOrDefault("key")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "key", valid_594065
  var valid_594066 = query.getOrDefault("prettyPrint")
  valid_594066 = validateParameter(valid_594066, JBool, required = false,
                                 default = newJBool(true))
  if valid_594066 != nil:
    section.add "prettyPrint", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_ReplicapoolReplicasGet_594053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific replica.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_ReplicapoolReplicasGet_594053; poolName: string;
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
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(path_594069, "poolName", newJString(poolName))
  add(path_594069, "zone", newJString(zone))
  add(query_594070, "fields", newJString(fields))
  add(query_594070, "quotaUser", newJString(quotaUser))
  add(query_594070, "alt", newJString(alt))
  add(query_594070, "oauth_token", newJString(oauthToken))
  add(query_594070, "userIp", newJString(userIp))
  add(query_594070, "key", newJString(key))
  add(path_594069, "projectName", newJString(projectName))
  add(path_594069, "replicaName", newJString(replicaName))
  add(query_594070, "prettyPrint", newJBool(prettyPrint))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var replicapoolReplicasGet* = Call_ReplicapoolReplicasGet_594053(
    name: "replicapoolReplicasGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}",
    validator: validate_ReplicapoolReplicasGet_594054,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasGet_594055,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolReplicasRestart_594091 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolReplicasRestart_594093(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ReplicapoolReplicasRestart_594092(path: JsonNode; query: JsonNode;
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
  var valid_594094 = path.getOrDefault("poolName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "poolName", valid_594094
  var valid_594095 = path.getOrDefault("zone")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "zone", valid_594095
  var valid_594096 = path.getOrDefault("projectName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "projectName", valid_594096
  var valid_594097 = path.getOrDefault("replicaName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "replicaName", valid_594097
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
  var valid_594098 = query.getOrDefault("fields")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "fields", valid_594098
  var valid_594099 = query.getOrDefault("quotaUser")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "quotaUser", valid_594099
  var valid_594100 = query.getOrDefault("alt")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = newJString("json"))
  if valid_594100 != nil:
    section.add "alt", valid_594100
  var valid_594101 = query.getOrDefault("oauth_token")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "oauth_token", valid_594101
  var valid_594102 = query.getOrDefault("userIp")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "userIp", valid_594102
  var valid_594103 = query.getOrDefault("key")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "key", valid_594103
  var valid_594104 = query.getOrDefault("prettyPrint")
  valid_594104 = validateParameter(valid_594104, JBool, required = false,
                                 default = newJBool(true))
  if valid_594104 != nil:
    section.add "prettyPrint", valid_594104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594105: Call_ReplicapoolReplicasRestart_594091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a replica in a pool.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_ReplicapoolReplicasRestart_594091; poolName: string;
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
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  add(path_594107, "poolName", newJString(poolName))
  add(path_594107, "zone", newJString(zone))
  add(query_594108, "fields", newJString(fields))
  add(query_594108, "quotaUser", newJString(quotaUser))
  add(query_594108, "alt", newJString(alt))
  add(query_594108, "oauth_token", newJString(oauthToken))
  add(query_594108, "userIp", newJString(userIp))
  add(query_594108, "key", newJString(key))
  add(path_594107, "projectName", newJString(projectName))
  add(path_594107, "replicaName", newJString(replicaName))
  add(query_594108, "prettyPrint", newJBool(prettyPrint))
  result = call_594106.call(path_594107, query_594108, nil, nil, nil)

var replicapoolReplicasRestart* = Call_ReplicapoolReplicasRestart_594091(
    name: "replicapoolReplicasRestart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/pools/{poolName}/replicas/{replicaName}/restart",
    validator: validate_ReplicapoolReplicasRestart_594092,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolReplicasRestart_594093,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsResize_594109 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolPoolsResize_594111(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ReplicapoolPoolsResize_594110(path: JsonNode; query: JsonNode;
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
  var valid_594112 = path.getOrDefault("poolName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "poolName", valid_594112
  var valid_594113 = path.getOrDefault("zone")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "zone", valid_594113
  var valid_594114 = path.getOrDefault("projectName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "projectName", valid_594114
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
  var valid_594115 = query.getOrDefault("fields")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "fields", valid_594115
  var valid_594116 = query.getOrDefault("numReplicas")
  valid_594116 = validateParameter(valid_594116, JInt, required = false, default = nil)
  if valid_594116 != nil:
    section.add "numReplicas", valid_594116
  var valid_594117 = query.getOrDefault("quotaUser")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "quotaUser", valid_594117
  var valid_594118 = query.getOrDefault("alt")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = newJString("json"))
  if valid_594118 != nil:
    section.add "alt", valid_594118
  var valid_594119 = query.getOrDefault("oauth_token")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "oauth_token", valid_594119
  var valid_594120 = query.getOrDefault("userIp")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "userIp", valid_594120
  var valid_594121 = query.getOrDefault("key")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "key", valid_594121
  var valid_594122 = query.getOrDefault("prettyPrint")
  valid_594122 = validateParameter(valid_594122, JBool, required = false,
                                 default = newJBool(true))
  if valid_594122 != nil:
    section.add "prettyPrint", valid_594122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594123: Call_ReplicapoolPoolsResize_594109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resize a pool. This is an asynchronous operation, and multiple overlapping resize requests can be made. Replica Pools will use the information from the last resize request.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_ReplicapoolPoolsResize_594109; poolName: string;
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
  var path_594125 = newJObject()
  var query_594126 = newJObject()
  add(path_594125, "poolName", newJString(poolName))
  add(path_594125, "zone", newJString(zone))
  add(query_594126, "fields", newJString(fields))
  add(query_594126, "numReplicas", newJInt(numReplicas))
  add(query_594126, "quotaUser", newJString(quotaUser))
  add(query_594126, "alt", newJString(alt))
  add(query_594126, "oauth_token", newJString(oauthToken))
  add(query_594126, "userIp", newJString(userIp))
  add(query_594126, "key", newJString(key))
  add(path_594125, "projectName", newJString(projectName))
  add(query_594126, "prettyPrint", newJBool(prettyPrint))
  result = call_594124.call(path_594125, query_594126, nil, nil, nil)

var replicapoolPoolsResize* = Call_ReplicapoolPoolsResize_594109(
    name: "replicapoolPoolsResize", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/resize",
    validator: validate_ReplicapoolPoolsResize_594110,
    base: "/replicapool/v1beta1/projects", url: url_ReplicapoolPoolsResize_594111,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolPoolsUpdatetemplate_594127 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolPoolsUpdatetemplate_594129(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ReplicapoolPoolsUpdatetemplate_594128(path: JsonNode;
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
  var valid_594130 = path.getOrDefault("poolName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "poolName", valid_594130
  var valid_594131 = path.getOrDefault("zone")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "zone", valid_594131
  var valid_594132 = path.getOrDefault("projectName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "projectName", valid_594132
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
  var valid_594133 = query.getOrDefault("fields")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "fields", valid_594133
  var valid_594134 = query.getOrDefault("quotaUser")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "quotaUser", valid_594134
  var valid_594135 = query.getOrDefault("alt")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = newJString("json"))
  if valid_594135 != nil:
    section.add "alt", valid_594135
  var valid_594136 = query.getOrDefault("oauth_token")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "oauth_token", valid_594136
  var valid_594137 = query.getOrDefault("userIp")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "userIp", valid_594137
  var valid_594138 = query.getOrDefault("key")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "key", valid_594138
  var valid_594139 = query.getOrDefault("prettyPrint")
  valid_594139 = validateParameter(valid_594139, JBool, required = false,
                                 default = newJBool(true))
  if valid_594139 != nil:
    section.add "prettyPrint", valid_594139
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

proc call*(call_594141: Call_ReplicapoolPoolsUpdatetemplate_594127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the template used by the pool.
  ## 
  let valid = call_594141.validator(path, query, header, formData, body)
  let scheme = call_594141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594141.url(scheme.get, call_594141.host, call_594141.base,
                         call_594141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594141, url, valid)

proc call*(call_594142: Call_ReplicapoolPoolsUpdatetemplate_594127;
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
  var path_594143 = newJObject()
  var query_594144 = newJObject()
  var body_594145 = newJObject()
  add(path_594143, "poolName", newJString(poolName))
  add(path_594143, "zone", newJString(zone))
  add(query_594144, "fields", newJString(fields))
  add(query_594144, "quotaUser", newJString(quotaUser))
  add(query_594144, "alt", newJString(alt))
  add(query_594144, "oauth_token", newJString(oauthToken))
  add(query_594144, "userIp", newJString(userIp))
  add(query_594144, "key", newJString(key))
  add(path_594143, "projectName", newJString(projectName))
  if body != nil:
    body_594145 = body
  add(query_594144, "prettyPrint", newJBool(prettyPrint))
  result = call_594142.call(path_594143, query_594144, nil, nil, body_594145)

var replicapoolPoolsUpdatetemplate* = Call_ReplicapoolPoolsUpdatetemplate_594127(
    name: "replicapoolPoolsUpdatetemplate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/pools/{poolName}/updateTemplate",
    validator: validate_ReplicapoolPoolsUpdatetemplate_594128,
    base: "/replicapool/v1beta1/projects",
    url: url_ReplicapoolPoolsUpdatetemplate_594129, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
