
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Compute Engine Instance Group Manager
## version: v1beta2
## termsOfService: (not provided)
## license: (not provided)
## 
## [Deprecated. Please use Instance Group Manager in Compute API] Provides groups of homogenous Compute Engine instances.
## 
## https://developers.google.com/compute/docs/instance-groups/manager/v1beta2
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
  Call_ReplicapoolInstanceGroupManagersInsert_589014 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolInstanceGroupManagersInsert_589016(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersInsert_589015(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an instance group manager, as well as the instance group and the specified number of instances.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589017 = path.getOrDefault("zone")
  valid_589017 = validateParameter(valid_589017, JString, required = true,
                                 default = nil)
  if valid_589017 != nil:
    section.add "zone", valid_589017
  var valid_589018 = path.getOrDefault("project")
  valid_589018 = validateParameter(valid_589018, JString, required = true,
                                 default = nil)
  if valid_589018 != nil:
    section.add "project", valid_589018
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
  ##   size: JInt (required)
  ##       : Number of instances that should exist.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589019 = query.getOrDefault("fields")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "fields", valid_589019
  var valid_589020 = query.getOrDefault("quotaUser")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "quotaUser", valid_589020
  var valid_589021 = query.getOrDefault("alt")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = newJString("json"))
  if valid_589021 != nil:
    section.add "alt", valid_589021
  var valid_589022 = query.getOrDefault("oauth_token")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "oauth_token", valid_589022
  var valid_589023 = query.getOrDefault("userIp")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "userIp", valid_589023
  var valid_589024 = query.getOrDefault("key")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "key", valid_589024
  assert query != nil, "query argument is necessary due to required `size` field"
  var valid_589025 = query.getOrDefault("size")
  valid_589025 = validateParameter(valid_589025, JInt, required = true, default = nil)
  if valid_589025 != nil:
    section.add "size", valid_589025
  var valid_589026 = query.getOrDefault("prettyPrint")
  valid_589026 = validateParameter(valid_589026, JBool, required = false,
                                 default = newJBool(true))
  if valid_589026 != nil:
    section.add "prettyPrint", valid_589026
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

proc call*(call_589028: Call_ReplicapoolInstanceGroupManagersInsert_589014;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an instance group manager, as well as the instance group and the specified number of instances.
  ## 
  let valid = call_589028.validator(path, query, header, formData, body)
  let scheme = call_589028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589028.url(scheme.get, call_589028.host, call_589028.base,
                         call_589028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589028, url, valid)

proc call*(call_589029: Call_ReplicapoolInstanceGroupManagersInsert_589014;
          zone: string; size: int; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersInsert
  ## Creates an instance group manager, as well as the instance group and the specified number of instances.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
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
  ##   size: int (required)
  ##       : Number of instances that should exist.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589030 = newJObject()
  var query_589031 = newJObject()
  var body_589032 = newJObject()
  add(path_589030, "zone", newJString(zone))
  add(query_589031, "fields", newJString(fields))
  add(query_589031, "quotaUser", newJString(quotaUser))
  add(query_589031, "alt", newJString(alt))
  add(query_589031, "oauth_token", newJString(oauthToken))
  add(query_589031, "userIp", newJString(userIp))
  add(query_589031, "key", newJString(key))
  add(query_589031, "size", newJInt(size))
  add(path_589030, "project", newJString(project))
  if body != nil:
    body_589032 = body
  add(query_589031, "prettyPrint", newJBool(prettyPrint))
  result = call_589029.call(path_589030, query_589031, nil, nil, body_589032)

var replicapoolInstanceGroupManagersInsert* = Call_ReplicapoolInstanceGroupManagersInsert_589014(
    name: "replicapoolInstanceGroupManagersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/instanceGroupManagers",
    validator: validate_ReplicapoolInstanceGroupManagersInsert_589015,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersInsert_589016,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersList_588725 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolInstanceGroupManagersList_588727(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersList_588726(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of Instance Group Manager resources contained within the specified zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_588853 = path.getOrDefault("zone")
  valid_588853 = validateParameter(valid_588853, JString, required = true,
                                 default = nil)
  if valid_588853 != nil:
    section.add "zone", valid_588853
  var valid_588854 = path.getOrDefault("project")
  valid_588854 = validateParameter(valid_588854, JString, required = true,
                                 default = nil)
  if valid_588854 != nil:
    section.add "project", valid_588854
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Filter expression for filtering listed resources.
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
  var valid_588878 = query.getOrDefault("filter")
  valid_588878 = validateParameter(valid_588878, JString, required = false,
                                 default = nil)
  if valid_588878 != nil:
    section.add "filter", valid_588878
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588901: Call_ReplicapoolInstanceGroupManagersList_588725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of Instance Group Manager resources contained within the specified zone.
  ## 
  let valid = call_588901.validator(path, query, header, formData, body)
  let scheme = call_588901.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588901.url(scheme.get, call_588901.host, call_588901.base,
                         call_588901.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588901, url, valid)

proc call*(call_588972: Call_ReplicapoolInstanceGroupManagersList_588725;
          zone: string; project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## replicapoolInstanceGroupManagersList
  ## Retrieves the list of Instance Group Manager resources contained within the specified zone.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Filter expression for filtering listed resources.
  var path_588973 = newJObject()
  var query_588975 = newJObject()
  add(path_588973, "zone", newJString(zone))
  add(query_588975, "fields", newJString(fields))
  add(query_588975, "pageToken", newJString(pageToken))
  add(query_588975, "quotaUser", newJString(quotaUser))
  add(query_588975, "alt", newJString(alt))
  add(query_588975, "oauth_token", newJString(oauthToken))
  add(query_588975, "userIp", newJString(userIp))
  add(query_588975, "maxResults", newJInt(maxResults))
  add(query_588975, "key", newJString(key))
  add(path_588973, "project", newJString(project))
  add(query_588975, "prettyPrint", newJBool(prettyPrint))
  add(query_588975, "filter", newJString(filter))
  result = call_588972.call(path_588973, query_588975, nil, nil, nil)

var replicapoolInstanceGroupManagersList* = Call_ReplicapoolInstanceGroupManagersList_588725(
    name: "replicapoolInstanceGroupManagersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/instanceGroupManagers",
    validator: validate_ReplicapoolInstanceGroupManagersList_588726,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersList_588727, schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersGet_589033 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolInstanceGroupManagersGet_589035(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersGet_589034(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified Instance Group Manager resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : Name of the instance resource to return.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589036 = path.getOrDefault("zone")
  valid_589036 = validateParameter(valid_589036, JString, required = true,
                                 default = nil)
  if valid_589036 != nil:
    section.add "zone", valid_589036
  var valid_589037 = path.getOrDefault("instanceGroupManager")
  valid_589037 = validateParameter(valid_589037, JString, required = true,
                                 default = nil)
  if valid_589037 != nil:
    section.add "instanceGroupManager", valid_589037
  var valid_589038 = path.getOrDefault("project")
  valid_589038 = validateParameter(valid_589038, JString, required = true,
                                 default = nil)
  if valid_589038 != nil:
    section.add "project", valid_589038
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
  var valid_589039 = query.getOrDefault("fields")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "fields", valid_589039
  var valid_589040 = query.getOrDefault("quotaUser")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "quotaUser", valid_589040
  var valid_589041 = query.getOrDefault("alt")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = newJString("json"))
  if valid_589041 != nil:
    section.add "alt", valid_589041
  var valid_589042 = query.getOrDefault("oauth_token")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "oauth_token", valid_589042
  var valid_589043 = query.getOrDefault("userIp")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "userIp", valid_589043
  var valid_589044 = query.getOrDefault("key")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "key", valid_589044
  var valid_589045 = query.getOrDefault("prettyPrint")
  valid_589045 = validateParameter(valid_589045, JBool, required = false,
                                 default = newJBool(true))
  if valid_589045 != nil:
    section.add "prettyPrint", valid_589045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589046: Call_ReplicapoolInstanceGroupManagersGet_589033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the specified Instance Group Manager resource.
  ## 
  let valid = call_589046.validator(path, query, header, formData, body)
  let scheme = call_589046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589046.url(scheme.get, call_589046.host, call_589046.base,
                         call_589046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589046, url, valid)

proc call*(call_589047: Call_ReplicapoolInstanceGroupManagersGet_589033;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersGet
  ## Returns the specified Instance Group Manager resource.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : Name of the instance resource to return.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589048 = newJObject()
  var query_589049 = newJObject()
  add(path_589048, "zone", newJString(zone))
  add(query_589049, "fields", newJString(fields))
  add(query_589049, "quotaUser", newJString(quotaUser))
  add(path_589048, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_589049, "alt", newJString(alt))
  add(query_589049, "oauth_token", newJString(oauthToken))
  add(query_589049, "userIp", newJString(userIp))
  add(query_589049, "key", newJString(key))
  add(path_589048, "project", newJString(project))
  add(query_589049, "prettyPrint", newJBool(prettyPrint))
  result = call_589047.call(path_589048, query_589049, nil, nil, nil)

var replicapoolInstanceGroupManagersGet* = Call_ReplicapoolInstanceGroupManagersGet_589033(
    name: "replicapoolInstanceGroupManagersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}",
    validator: validate_ReplicapoolInstanceGroupManagersGet_589034,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersGet_589035, schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersDelete_589050 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolInstanceGroupManagersDelete_589052(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersDelete_589051(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the instance group manager and all instances contained within. If you'd like to delete the manager without deleting the instances, you must first abandon the instances to remove them from the group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : Name of the Instance Group Manager resource to delete.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589053 = path.getOrDefault("zone")
  valid_589053 = validateParameter(valid_589053, JString, required = true,
                                 default = nil)
  if valid_589053 != nil:
    section.add "zone", valid_589053
  var valid_589054 = path.getOrDefault("instanceGroupManager")
  valid_589054 = validateParameter(valid_589054, JString, required = true,
                                 default = nil)
  if valid_589054 != nil:
    section.add "instanceGroupManager", valid_589054
  var valid_589055 = path.getOrDefault("project")
  valid_589055 = validateParameter(valid_589055, JString, required = true,
                                 default = nil)
  if valid_589055 != nil:
    section.add "project", valid_589055
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
  var valid_589056 = query.getOrDefault("fields")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "fields", valid_589056
  var valid_589057 = query.getOrDefault("quotaUser")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "quotaUser", valid_589057
  var valid_589058 = query.getOrDefault("alt")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = newJString("json"))
  if valid_589058 != nil:
    section.add "alt", valid_589058
  var valid_589059 = query.getOrDefault("oauth_token")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "oauth_token", valid_589059
  var valid_589060 = query.getOrDefault("userIp")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "userIp", valid_589060
  var valid_589061 = query.getOrDefault("key")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "key", valid_589061
  var valid_589062 = query.getOrDefault("prettyPrint")
  valid_589062 = validateParameter(valid_589062, JBool, required = false,
                                 default = newJBool(true))
  if valid_589062 != nil:
    section.add "prettyPrint", valid_589062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589063: Call_ReplicapoolInstanceGroupManagersDelete_589050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the instance group manager and all instances contained within. If you'd like to delete the manager without deleting the instances, you must first abandon the instances to remove them from the group.
  ## 
  let valid = call_589063.validator(path, query, header, formData, body)
  let scheme = call_589063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589063.url(scheme.get, call_589063.host, call_589063.base,
                         call_589063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589063, url, valid)

proc call*(call_589064: Call_ReplicapoolInstanceGroupManagersDelete_589050;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersDelete
  ## Deletes the instance group manager and all instances contained within. If you'd like to delete the manager without deleting the instances, you must first abandon the instances to remove them from the group.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : Name of the Instance Group Manager resource to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589065 = newJObject()
  var query_589066 = newJObject()
  add(path_589065, "zone", newJString(zone))
  add(query_589066, "fields", newJString(fields))
  add(query_589066, "quotaUser", newJString(quotaUser))
  add(path_589065, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_589066, "alt", newJString(alt))
  add(query_589066, "oauth_token", newJString(oauthToken))
  add(query_589066, "userIp", newJString(userIp))
  add(query_589066, "key", newJString(key))
  add(path_589065, "project", newJString(project))
  add(query_589066, "prettyPrint", newJBool(prettyPrint))
  result = call_589064.call(path_589065, query_589066, nil, nil, nil)

var replicapoolInstanceGroupManagersDelete* = Call_ReplicapoolInstanceGroupManagersDelete_589050(
    name: "replicapoolInstanceGroupManagersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}",
    validator: validate_ReplicapoolInstanceGroupManagersDelete_589051,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersDelete_589052,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersAbandonInstances_589067 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolInstanceGroupManagersAbandonInstances_589069(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/abandonInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersAbandonInstances_589068(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes the specified instances from the managed instance group, and from any target pools of which they were members, without deleting the instances.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589070 = path.getOrDefault("zone")
  valid_589070 = validateParameter(valid_589070, JString, required = true,
                                 default = nil)
  if valid_589070 != nil:
    section.add "zone", valid_589070
  var valid_589071 = path.getOrDefault("instanceGroupManager")
  valid_589071 = validateParameter(valid_589071, JString, required = true,
                                 default = nil)
  if valid_589071 != nil:
    section.add "instanceGroupManager", valid_589071
  var valid_589072 = path.getOrDefault("project")
  valid_589072 = validateParameter(valid_589072, JString, required = true,
                                 default = nil)
  if valid_589072 != nil:
    section.add "project", valid_589072
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
  var valid_589073 = query.getOrDefault("fields")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "fields", valid_589073
  var valid_589074 = query.getOrDefault("quotaUser")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "quotaUser", valid_589074
  var valid_589075 = query.getOrDefault("alt")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("json"))
  if valid_589075 != nil:
    section.add "alt", valid_589075
  var valid_589076 = query.getOrDefault("oauth_token")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "oauth_token", valid_589076
  var valid_589077 = query.getOrDefault("userIp")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "userIp", valid_589077
  var valid_589078 = query.getOrDefault("key")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "key", valid_589078
  var valid_589079 = query.getOrDefault("prettyPrint")
  valid_589079 = validateParameter(valid_589079, JBool, required = false,
                                 default = newJBool(true))
  if valid_589079 != nil:
    section.add "prettyPrint", valid_589079
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

proc call*(call_589081: Call_ReplicapoolInstanceGroupManagersAbandonInstances_589067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified instances from the managed instance group, and from any target pools of which they were members, without deleting the instances.
  ## 
  let valid = call_589081.validator(path, query, header, formData, body)
  let scheme = call_589081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589081.url(scheme.get, call_589081.host, call_589081.base,
                         call_589081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589081, url, valid)

proc call*(call_589082: Call_ReplicapoolInstanceGroupManagersAbandonInstances_589067;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersAbandonInstances
  ## Removes the specified instances from the managed instance group, and from any target pools of which they were members, without deleting the instances.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589083 = newJObject()
  var query_589084 = newJObject()
  var body_589085 = newJObject()
  add(path_589083, "zone", newJString(zone))
  add(query_589084, "fields", newJString(fields))
  add(query_589084, "quotaUser", newJString(quotaUser))
  add(path_589083, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_589084, "alt", newJString(alt))
  add(query_589084, "oauth_token", newJString(oauthToken))
  add(query_589084, "userIp", newJString(userIp))
  add(query_589084, "key", newJString(key))
  add(path_589083, "project", newJString(project))
  if body != nil:
    body_589085 = body
  add(query_589084, "prettyPrint", newJBool(prettyPrint))
  result = call_589082.call(path_589083, query_589084, nil, nil, body_589085)

var replicapoolInstanceGroupManagersAbandonInstances* = Call_ReplicapoolInstanceGroupManagersAbandonInstances_589067(
    name: "replicapoolInstanceGroupManagersAbandonInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/abandonInstances",
    validator: validate_ReplicapoolInstanceGroupManagersAbandonInstances_589068,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersAbandonInstances_589069,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersDeleteInstances_589086 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolInstanceGroupManagersDeleteInstances_589088(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/deleteInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersDeleteInstances_589087(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the specified instances. The instances are deleted, then removed from the instance group and any target pools of which they were a member. The targetSize of the instance group manager is reduced by the number of instances deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589089 = path.getOrDefault("zone")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "zone", valid_589089
  var valid_589090 = path.getOrDefault("instanceGroupManager")
  valid_589090 = validateParameter(valid_589090, JString, required = true,
                                 default = nil)
  if valid_589090 != nil:
    section.add "instanceGroupManager", valid_589090
  var valid_589091 = path.getOrDefault("project")
  valid_589091 = validateParameter(valid_589091, JString, required = true,
                                 default = nil)
  if valid_589091 != nil:
    section.add "project", valid_589091
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
  var valid_589092 = query.getOrDefault("fields")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "fields", valid_589092
  var valid_589093 = query.getOrDefault("quotaUser")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "quotaUser", valid_589093
  var valid_589094 = query.getOrDefault("alt")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = newJString("json"))
  if valid_589094 != nil:
    section.add "alt", valid_589094
  var valid_589095 = query.getOrDefault("oauth_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "oauth_token", valid_589095
  var valid_589096 = query.getOrDefault("userIp")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "userIp", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("prettyPrint")
  valid_589098 = validateParameter(valid_589098, JBool, required = false,
                                 default = newJBool(true))
  if valid_589098 != nil:
    section.add "prettyPrint", valid_589098
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

proc call*(call_589100: Call_ReplicapoolInstanceGroupManagersDeleteInstances_589086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified instances. The instances are deleted, then removed from the instance group and any target pools of which they were a member. The targetSize of the instance group manager is reduced by the number of instances deleted.
  ## 
  let valid = call_589100.validator(path, query, header, formData, body)
  let scheme = call_589100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589100.url(scheme.get, call_589100.host, call_589100.base,
                         call_589100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589100, url, valid)

proc call*(call_589101: Call_ReplicapoolInstanceGroupManagersDeleteInstances_589086;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersDeleteInstances
  ## Deletes the specified instances. The instances are deleted, then removed from the instance group and any target pools of which they were a member. The targetSize of the instance group manager is reduced by the number of instances deleted.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589102 = newJObject()
  var query_589103 = newJObject()
  var body_589104 = newJObject()
  add(path_589102, "zone", newJString(zone))
  add(query_589103, "fields", newJString(fields))
  add(query_589103, "quotaUser", newJString(quotaUser))
  add(path_589102, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_589103, "alt", newJString(alt))
  add(query_589103, "oauth_token", newJString(oauthToken))
  add(query_589103, "userIp", newJString(userIp))
  add(query_589103, "key", newJString(key))
  add(path_589102, "project", newJString(project))
  if body != nil:
    body_589104 = body
  add(query_589103, "prettyPrint", newJBool(prettyPrint))
  result = call_589101.call(path_589102, query_589103, nil, nil, body_589104)

var replicapoolInstanceGroupManagersDeleteInstances* = Call_ReplicapoolInstanceGroupManagersDeleteInstances_589086(
    name: "replicapoolInstanceGroupManagersDeleteInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/deleteInstances",
    validator: validate_ReplicapoolInstanceGroupManagersDeleteInstances_589087,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersDeleteInstances_589088,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersRecreateInstances_589105 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolInstanceGroupManagersRecreateInstances_589107(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/recreateInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersRecreateInstances_589106(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Recreates the specified instances. The instances are deleted, then recreated using the instance group manager's current instance template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589108 = path.getOrDefault("zone")
  valid_589108 = validateParameter(valid_589108, JString, required = true,
                                 default = nil)
  if valid_589108 != nil:
    section.add "zone", valid_589108
  var valid_589109 = path.getOrDefault("instanceGroupManager")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = nil)
  if valid_589109 != nil:
    section.add "instanceGroupManager", valid_589109
  var valid_589110 = path.getOrDefault("project")
  valid_589110 = validateParameter(valid_589110, JString, required = true,
                                 default = nil)
  if valid_589110 != nil:
    section.add "project", valid_589110
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

proc call*(call_589119: Call_ReplicapoolInstanceGroupManagersRecreateInstances_589105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recreates the specified instances. The instances are deleted, then recreated using the instance group manager's current instance template.
  ## 
  let valid = call_589119.validator(path, query, header, formData, body)
  let scheme = call_589119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589119.url(scheme.get, call_589119.host, call_589119.base,
                         call_589119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589119, url, valid)

proc call*(call_589120: Call_ReplicapoolInstanceGroupManagersRecreateInstances_589105;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersRecreateInstances
  ## Recreates the specified instances. The instances are deleted, then recreated using the instance group manager's current instance template.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589121 = newJObject()
  var query_589122 = newJObject()
  var body_589123 = newJObject()
  add(path_589121, "zone", newJString(zone))
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(path_589121, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_589122, "alt", newJString(alt))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(query_589122, "userIp", newJString(userIp))
  add(query_589122, "key", newJString(key))
  add(path_589121, "project", newJString(project))
  if body != nil:
    body_589123 = body
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  result = call_589120.call(path_589121, query_589122, nil, nil, body_589123)

var replicapoolInstanceGroupManagersRecreateInstances* = Call_ReplicapoolInstanceGroupManagersRecreateInstances_589105(
    name: "replicapoolInstanceGroupManagersRecreateInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/recreateInstances",
    validator: validate_ReplicapoolInstanceGroupManagersRecreateInstances_589106,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersRecreateInstances_589107,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersResize_589124 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolInstanceGroupManagersResize_589126(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/resize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersResize_589125(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resizes the managed instance group up or down. If resized up, new instances are created using the current instance template. If resized down, instances are removed in the order outlined in Resizing a managed instance group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589127 = path.getOrDefault("zone")
  valid_589127 = validateParameter(valid_589127, JString, required = true,
                                 default = nil)
  if valid_589127 != nil:
    section.add "zone", valid_589127
  var valid_589128 = path.getOrDefault("instanceGroupManager")
  valid_589128 = validateParameter(valid_589128, JString, required = true,
                                 default = nil)
  if valid_589128 != nil:
    section.add "instanceGroupManager", valid_589128
  var valid_589129 = path.getOrDefault("project")
  valid_589129 = validateParameter(valid_589129, JString, required = true,
                                 default = nil)
  if valid_589129 != nil:
    section.add "project", valid_589129
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
  ##   size: JInt (required)
  ##       : Number of instances that should exist in this Instance Group Manager.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589130 = query.getOrDefault("fields")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "fields", valid_589130
  var valid_589131 = query.getOrDefault("quotaUser")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "quotaUser", valid_589131
  var valid_589132 = query.getOrDefault("alt")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("json"))
  if valid_589132 != nil:
    section.add "alt", valid_589132
  var valid_589133 = query.getOrDefault("oauth_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "oauth_token", valid_589133
  var valid_589134 = query.getOrDefault("userIp")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "userIp", valid_589134
  var valid_589135 = query.getOrDefault("key")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "key", valid_589135
  assert query != nil, "query argument is necessary due to required `size` field"
  var valid_589136 = query.getOrDefault("size")
  valid_589136 = validateParameter(valid_589136, JInt, required = true, default = nil)
  if valid_589136 != nil:
    section.add "size", valid_589136
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

proc call*(call_589138: Call_ReplicapoolInstanceGroupManagersResize_589124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resizes the managed instance group up or down. If resized up, new instances are created using the current instance template. If resized down, instances are removed in the order outlined in Resizing a managed instance group.
  ## 
  let valid = call_589138.validator(path, query, header, formData, body)
  let scheme = call_589138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589138.url(scheme.get, call_589138.host, call_589138.base,
                         call_589138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589138, url, valid)

proc call*(call_589139: Call_ReplicapoolInstanceGroupManagersResize_589124;
          zone: string; instanceGroupManager: string; size: int; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersResize
  ## Resizes the managed instance group up or down. If resized up, new instances are created using the current instance template. If resized down, instances are removed in the order outlined in Resizing a managed instance group.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   size: int (required)
  ##       : Number of instances that should exist in this Instance Group Manager.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589140 = newJObject()
  var query_589141 = newJObject()
  add(path_589140, "zone", newJString(zone))
  add(query_589141, "fields", newJString(fields))
  add(query_589141, "quotaUser", newJString(quotaUser))
  add(path_589140, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_589141, "alt", newJString(alt))
  add(query_589141, "oauth_token", newJString(oauthToken))
  add(query_589141, "userIp", newJString(userIp))
  add(query_589141, "key", newJString(key))
  add(query_589141, "size", newJInt(size))
  add(path_589140, "project", newJString(project))
  add(query_589141, "prettyPrint", newJBool(prettyPrint))
  result = call_589139.call(path_589140, query_589141, nil, nil, nil)

var replicapoolInstanceGroupManagersResize* = Call_ReplicapoolInstanceGroupManagersResize_589124(
    name: "replicapoolInstanceGroupManagersResize", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/resize",
    validator: validate_ReplicapoolInstanceGroupManagersResize_589125,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersResize_589126,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_589142 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolInstanceGroupManagersSetInstanceTemplate_589144(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/setInstanceTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersSetInstanceTemplate_589143(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the instance template to use when creating new instances in this group. Existing instances are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589145 = path.getOrDefault("zone")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "zone", valid_589145
  var valid_589146 = path.getOrDefault("instanceGroupManager")
  valid_589146 = validateParameter(valid_589146, JString, required = true,
                                 default = nil)
  if valid_589146 != nil:
    section.add "instanceGroupManager", valid_589146
  var valid_589147 = path.getOrDefault("project")
  valid_589147 = validateParameter(valid_589147, JString, required = true,
                                 default = nil)
  if valid_589147 != nil:
    section.add "project", valid_589147
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
  var valid_589148 = query.getOrDefault("fields")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "fields", valid_589148
  var valid_589149 = query.getOrDefault("quotaUser")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "quotaUser", valid_589149
  var valid_589150 = query.getOrDefault("alt")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = newJString("json"))
  if valid_589150 != nil:
    section.add "alt", valid_589150
  var valid_589151 = query.getOrDefault("oauth_token")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "oauth_token", valid_589151
  var valid_589152 = query.getOrDefault("userIp")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "userIp", valid_589152
  var valid_589153 = query.getOrDefault("key")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "key", valid_589153
  var valid_589154 = query.getOrDefault("prettyPrint")
  valid_589154 = validateParameter(valid_589154, JBool, required = false,
                                 default = newJBool(true))
  if valid_589154 != nil:
    section.add "prettyPrint", valid_589154
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

proc call*(call_589156: Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_589142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the instance template to use when creating new instances in this group. Existing instances are not affected.
  ## 
  let valid = call_589156.validator(path, query, header, formData, body)
  let scheme = call_589156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589156.url(scheme.get, call_589156.host, call_589156.base,
                         call_589156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589156, url, valid)

proc call*(call_589157: Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_589142;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersSetInstanceTemplate
  ## Sets the instance template to use when creating new instances in this group. Existing instances are not affected.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589158 = newJObject()
  var query_589159 = newJObject()
  var body_589160 = newJObject()
  add(path_589158, "zone", newJString(zone))
  add(query_589159, "fields", newJString(fields))
  add(query_589159, "quotaUser", newJString(quotaUser))
  add(path_589158, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_589159, "alt", newJString(alt))
  add(query_589159, "oauth_token", newJString(oauthToken))
  add(query_589159, "userIp", newJString(userIp))
  add(query_589159, "key", newJString(key))
  add(path_589158, "project", newJString(project))
  if body != nil:
    body_589160 = body
  add(query_589159, "prettyPrint", newJBool(prettyPrint))
  result = call_589157.call(path_589158, query_589159, nil, nil, body_589160)

var replicapoolInstanceGroupManagersSetInstanceTemplate* = Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_589142(
    name: "replicapoolInstanceGroupManagersSetInstanceTemplate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/setInstanceTemplate",
    validator: validate_ReplicapoolInstanceGroupManagersSetInstanceTemplate_589143,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersSetInstanceTemplate_589144,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersSetTargetPools_589161 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolInstanceGroupManagersSetTargetPools_589163(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/setTargetPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersSetTargetPools_589162(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Modifies the target pools to which all new instances in this group are assigned. Existing instances in the group are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589164 = path.getOrDefault("zone")
  valid_589164 = validateParameter(valid_589164, JString, required = true,
                                 default = nil)
  if valid_589164 != nil:
    section.add "zone", valid_589164
  var valid_589165 = path.getOrDefault("instanceGroupManager")
  valid_589165 = validateParameter(valid_589165, JString, required = true,
                                 default = nil)
  if valid_589165 != nil:
    section.add "instanceGroupManager", valid_589165
  var valid_589166 = path.getOrDefault("project")
  valid_589166 = validateParameter(valid_589166, JString, required = true,
                                 default = nil)
  if valid_589166 != nil:
    section.add "project", valid_589166
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
  var valid_589167 = query.getOrDefault("fields")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "fields", valid_589167
  var valid_589168 = query.getOrDefault("quotaUser")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "quotaUser", valid_589168
  var valid_589169 = query.getOrDefault("alt")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = newJString("json"))
  if valid_589169 != nil:
    section.add "alt", valid_589169
  var valid_589170 = query.getOrDefault("oauth_token")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "oauth_token", valid_589170
  var valid_589171 = query.getOrDefault("userIp")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "userIp", valid_589171
  var valid_589172 = query.getOrDefault("key")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "key", valid_589172
  var valid_589173 = query.getOrDefault("prettyPrint")
  valid_589173 = validateParameter(valid_589173, JBool, required = false,
                                 default = newJBool(true))
  if valid_589173 != nil:
    section.add "prettyPrint", valid_589173
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

proc call*(call_589175: Call_ReplicapoolInstanceGroupManagersSetTargetPools_589161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the target pools to which all new instances in this group are assigned. Existing instances in the group are not affected.
  ## 
  let valid = call_589175.validator(path, query, header, formData, body)
  let scheme = call_589175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589175.url(scheme.get, call_589175.host, call_589175.base,
                         call_589175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589175, url, valid)

proc call*(call_589176: Call_ReplicapoolInstanceGroupManagersSetTargetPools_589161;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersSetTargetPools
  ## Modifies the target pools to which all new instances in this group are assigned. Existing instances in the group are not affected.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589177 = newJObject()
  var query_589178 = newJObject()
  var body_589179 = newJObject()
  add(path_589177, "zone", newJString(zone))
  add(query_589178, "fields", newJString(fields))
  add(query_589178, "quotaUser", newJString(quotaUser))
  add(path_589177, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_589178, "alt", newJString(alt))
  add(query_589178, "oauth_token", newJString(oauthToken))
  add(query_589178, "userIp", newJString(userIp))
  add(query_589178, "key", newJString(key))
  add(path_589177, "project", newJString(project))
  if body != nil:
    body_589179 = body
  add(query_589178, "prettyPrint", newJBool(prettyPrint))
  result = call_589176.call(path_589177, query_589178, nil, nil, body_589179)

var replicapoolInstanceGroupManagersSetTargetPools* = Call_ReplicapoolInstanceGroupManagersSetTargetPools_589161(
    name: "replicapoolInstanceGroupManagersSetTargetPools",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/setTargetPools",
    validator: validate_ReplicapoolInstanceGroupManagersSetTargetPools_589162,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersSetTargetPools_589163,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolZoneOperationsList_589180 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolZoneOperationsList_589182(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolZoneOperationsList_589181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of operation resources contained within the specified zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Name of the zone scoping this request.
  ##   project: JString (required)
  ##          : Name of the project scoping this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589183 = path.getOrDefault("zone")
  valid_589183 = validateParameter(valid_589183, JString, required = true,
                                 default = nil)
  if valid_589183 != nil:
    section.add "zone", valid_589183
  var valid_589184 = path.getOrDefault("project")
  valid_589184 = validateParameter(valid_589184, JString, required = true,
                                 default = nil)
  if valid_589184 != nil:
    section.add "project", valid_589184
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Filter expression for filtering listed resources.
  section = newJObject()
  var valid_589185 = query.getOrDefault("fields")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "fields", valid_589185
  var valid_589186 = query.getOrDefault("pageToken")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "pageToken", valid_589186
  var valid_589187 = query.getOrDefault("quotaUser")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "quotaUser", valid_589187
  var valid_589188 = query.getOrDefault("alt")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = newJString("json"))
  if valid_589188 != nil:
    section.add "alt", valid_589188
  var valid_589189 = query.getOrDefault("oauth_token")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "oauth_token", valid_589189
  var valid_589190 = query.getOrDefault("userIp")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "userIp", valid_589190
  var valid_589191 = query.getOrDefault("maxResults")
  valid_589191 = validateParameter(valid_589191, JInt, required = false,
                                 default = newJInt(500))
  if valid_589191 != nil:
    section.add "maxResults", valid_589191
  var valid_589192 = query.getOrDefault("key")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "key", valid_589192
  var valid_589193 = query.getOrDefault("prettyPrint")
  valid_589193 = validateParameter(valid_589193, JBool, required = false,
                                 default = newJBool(true))
  if valid_589193 != nil:
    section.add "prettyPrint", valid_589193
  var valid_589194 = query.getOrDefault("filter")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "filter", valid_589194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589195: Call_ReplicapoolZoneOperationsList_589180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of operation resources contained within the specified zone.
  ## 
  let valid = call_589195.validator(path, query, header, formData, body)
  let scheme = call_589195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589195.url(scheme.get, call_589195.host, call_589195.base,
                         call_589195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589195, url, valid)

proc call*(call_589196: Call_ReplicapoolZoneOperationsList_589180; zone: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## replicapoolZoneOperationsList
  ## Retrieves the list of operation resources contained within the specified zone.
  ##   zone: string (required)
  ##       : Name of the zone scoping this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Name of the project scoping this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Filter expression for filtering listed resources.
  var path_589197 = newJObject()
  var query_589198 = newJObject()
  add(path_589197, "zone", newJString(zone))
  add(query_589198, "fields", newJString(fields))
  add(query_589198, "pageToken", newJString(pageToken))
  add(query_589198, "quotaUser", newJString(quotaUser))
  add(query_589198, "alt", newJString(alt))
  add(query_589198, "oauth_token", newJString(oauthToken))
  add(query_589198, "userIp", newJString(userIp))
  add(query_589198, "maxResults", newJInt(maxResults))
  add(query_589198, "key", newJString(key))
  add(path_589197, "project", newJString(project))
  add(query_589198, "prettyPrint", newJBool(prettyPrint))
  add(query_589198, "filter", newJString(filter))
  result = call_589196.call(path_589197, query_589198, nil, nil, nil)

var replicapoolZoneOperationsList* = Call_ReplicapoolZoneOperationsList_589180(
    name: "replicapoolZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/operations",
    validator: validate_ReplicapoolZoneOperationsList_589181,
    base: "/replicapool/v1beta2/projects", url: url_ReplicapoolZoneOperationsList_589182,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolZoneOperationsGet_589199 = ref object of OpenApiRestCall_588457
proc url_ReplicapoolZoneOperationsGet_589201(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolZoneOperationsGet_589200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Name of the zone scoping this request.
  ##   operation: JString (required)
  ##            : Name of the operation resource to return.
  ##   project: JString (required)
  ##          : Name of the project scoping this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589202 = path.getOrDefault("zone")
  valid_589202 = validateParameter(valid_589202, JString, required = true,
                                 default = nil)
  if valid_589202 != nil:
    section.add "zone", valid_589202
  var valid_589203 = path.getOrDefault("operation")
  valid_589203 = validateParameter(valid_589203, JString, required = true,
                                 default = nil)
  if valid_589203 != nil:
    section.add "operation", valid_589203
  var valid_589204 = path.getOrDefault("project")
  valid_589204 = validateParameter(valid_589204, JString, required = true,
                                 default = nil)
  if valid_589204 != nil:
    section.add "project", valid_589204
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
  var valid_589205 = query.getOrDefault("fields")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "fields", valid_589205
  var valid_589206 = query.getOrDefault("quotaUser")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "quotaUser", valid_589206
  var valid_589207 = query.getOrDefault("alt")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = newJString("json"))
  if valid_589207 != nil:
    section.add "alt", valid_589207
  var valid_589208 = query.getOrDefault("oauth_token")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "oauth_token", valid_589208
  var valid_589209 = query.getOrDefault("userIp")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "userIp", valid_589209
  var valid_589210 = query.getOrDefault("key")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "key", valid_589210
  var valid_589211 = query.getOrDefault("prettyPrint")
  valid_589211 = validateParameter(valid_589211, JBool, required = false,
                                 default = newJBool(true))
  if valid_589211 != nil:
    section.add "prettyPrint", valid_589211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589212: Call_ReplicapoolZoneOperationsGet_589199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  let valid = call_589212.validator(path, query, header, formData, body)
  let scheme = call_589212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589212.url(scheme.get, call_589212.host, call_589212.base,
                         call_589212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589212, url, valid)

proc call*(call_589213: Call_ReplicapoolZoneOperationsGet_589199; zone: string;
          operation: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolZoneOperationsGet
  ## Retrieves the specified zone-specific operation resource.
  ##   zone: string (required)
  ##       : Name of the zone scoping this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   operation: string (required)
  ##            : Name of the operation resource to return.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Name of the project scoping this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589214 = newJObject()
  var query_589215 = newJObject()
  add(path_589214, "zone", newJString(zone))
  add(query_589215, "fields", newJString(fields))
  add(query_589215, "quotaUser", newJString(quotaUser))
  add(query_589215, "alt", newJString(alt))
  add(path_589214, "operation", newJString(operation))
  add(query_589215, "oauth_token", newJString(oauthToken))
  add(query_589215, "userIp", newJString(userIp))
  add(query_589215, "key", newJString(key))
  add(path_589214, "project", newJString(project))
  add(query_589215, "prettyPrint", newJBool(prettyPrint))
  result = call_589213.call(path_589214, query_589215, nil, nil, nil)

var replicapoolZoneOperationsGet* = Call_ReplicapoolZoneOperationsGet_589199(
    name: "replicapoolZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/operations/{operation}",
    validator: validate_ReplicapoolZoneOperationsGet_589200,
    base: "/replicapool/v1beta2/projects", url: url_ReplicapoolZoneOperationsGet_589201,
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
