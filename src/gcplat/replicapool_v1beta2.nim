
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
  Call_ReplicapoolInstanceGroupManagersInsert_579981 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolInstanceGroupManagersInsert_579983(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersInsert_579982(path: JsonNode;
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
  var valid_579984 = path.getOrDefault("zone")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "zone", valid_579984
  var valid_579985 = path.getOrDefault("project")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "project", valid_579985
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
  var valid_579986 = query.getOrDefault("fields")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "fields", valid_579986
  var valid_579987 = query.getOrDefault("quotaUser")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "quotaUser", valid_579987
  var valid_579988 = query.getOrDefault("alt")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("json"))
  if valid_579988 != nil:
    section.add "alt", valid_579988
  var valid_579989 = query.getOrDefault("oauth_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "oauth_token", valid_579989
  var valid_579990 = query.getOrDefault("userIp")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "userIp", valid_579990
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  assert query != nil, "query argument is necessary due to required `size` field"
  var valid_579992 = query.getOrDefault("size")
  valid_579992 = validateParameter(valid_579992, JInt, required = true, default = nil)
  if valid_579992 != nil:
    section.add "size", valid_579992
  var valid_579993 = query.getOrDefault("prettyPrint")
  valid_579993 = validateParameter(valid_579993, JBool, required = false,
                                 default = newJBool(true))
  if valid_579993 != nil:
    section.add "prettyPrint", valid_579993
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

proc call*(call_579995: Call_ReplicapoolInstanceGroupManagersInsert_579981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an instance group manager, as well as the instance group and the specified number of instances.
  ## 
  let valid = call_579995.validator(path, query, header, formData, body)
  let scheme = call_579995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579995.url(scheme.get, call_579995.host, call_579995.base,
                         call_579995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579995, url, valid)

proc call*(call_579996: Call_ReplicapoolInstanceGroupManagersInsert_579981;
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
  var path_579997 = newJObject()
  var query_579998 = newJObject()
  var body_579999 = newJObject()
  add(path_579997, "zone", newJString(zone))
  add(query_579998, "fields", newJString(fields))
  add(query_579998, "quotaUser", newJString(quotaUser))
  add(query_579998, "alt", newJString(alt))
  add(query_579998, "oauth_token", newJString(oauthToken))
  add(query_579998, "userIp", newJString(userIp))
  add(query_579998, "key", newJString(key))
  add(query_579998, "size", newJInt(size))
  add(path_579997, "project", newJString(project))
  if body != nil:
    body_579999 = body
  add(query_579998, "prettyPrint", newJBool(prettyPrint))
  result = call_579996.call(path_579997, query_579998, nil, nil, body_579999)

var replicapoolInstanceGroupManagersInsert* = Call_ReplicapoolInstanceGroupManagersInsert_579981(
    name: "replicapoolInstanceGroupManagersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/instanceGroupManagers",
    validator: validate_ReplicapoolInstanceGroupManagersInsert_579982,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersInsert_579983,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersList_579692 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolInstanceGroupManagersList_579694(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersList_579693(path: JsonNode;
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
  var valid_579820 = path.getOrDefault("zone")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "zone", valid_579820
  var valid_579821 = path.getOrDefault("project")
  valid_579821 = validateParameter(valid_579821, JString, required = true,
                                 default = nil)
  if valid_579821 != nil:
    section.add "project", valid_579821
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
  var valid_579845 = query.getOrDefault("filter")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = nil)
  if valid_579845 != nil:
    section.add "filter", valid_579845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579868: Call_ReplicapoolInstanceGroupManagersList_579692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of Instance Group Manager resources contained within the specified zone.
  ## 
  let valid = call_579868.validator(path, query, header, formData, body)
  let scheme = call_579868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579868.url(scheme.get, call_579868.host, call_579868.base,
                         call_579868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579868, url, valid)

proc call*(call_579939: Call_ReplicapoolInstanceGroupManagersList_579692;
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
  var path_579940 = newJObject()
  var query_579942 = newJObject()
  add(path_579940, "zone", newJString(zone))
  add(query_579942, "fields", newJString(fields))
  add(query_579942, "pageToken", newJString(pageToken))
  add(query_579942, "quotaUser", newJString(quotaUser))
  add(query_579942, "alt", newJString(alt))
  add(query_579942, "oauth_token", newJString(oauthToken))
  add(query_579942, "userIp", newJString(userIp))
  add(query_579942, "maxResults", newJInt(maxResults))
  add(query_579942, "key", newJString(key))
  add(path_579940, "project", newJString(project))
  add(query_579942, "prettyPrint", newJBool(prettyPrint))
  add(query_579942, "filter", newJString(filter))
  result = call_579939.call(path_579940, query_579942, nil, nil, nil)

var replicapoolInstanceGroupManagersList* = Call_ReplicapoolInstanceGroupManagersList_579692(
    name: "replicapoolInstanceGroupManagersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/instanceGroupManagers",
    validator: validate_ReplicapoolInstanceGroupManagersList_579693,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersList_579694, schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersGet_580000 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolInstanceGroupManagersGet_580002(protocol: Scheme; host: string;
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

proc validate_ReplicapoolInstanceGroupManagersGet_580001(path: JsonNode;
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
  var valid_580003 = path.getOrDefault("zone")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "zone", valid_580003
  var valid_580004 = path.getOrDefault("instanceGroupManager")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "instanceGroupManager", valid_580004
  var valid_580005 = path.getOrDefault("project")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "project", valid_580005
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
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("quotaUser")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "quotaUser", valid_580007
  var valid_580008 = query.getOrDefault("alt")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("json"))
  if valid_580008 != nil:
    section.add "alt", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("userIp")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "userIp", valid_580010
  var valid_580011 = query.getOrDefault("key")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "key", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580013: Call_ReplicapoolInstanceGroupManagersGet_580000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the specified Instance Group Manager resource.
  ## 
  let valid = call_580013.validator(path, query, header, formData, body)
  let scheme = call_580013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580013.url(scheme.get, call_580013.host, call_580013.base,
                         call_580013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580013, url, valid)

proc call*(call_580014: Call_ReplicapoolInstanceGroupManagersGet_580000;
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
  var path_580015 = newJObject()
  var query_580016 = newJObject()
  add(path_580015, "zone", newJString(zone))
  add(query_580016, "fields", newJString(fields))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(path_580015, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(query_580016, "userIp", newJString(userIp))
  add(query_580016, "key", newJString(key))
  add(path_580015, "project", newJString(project))
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  result = call_580014.call(path_580015, query_580016, nil, nil, nil)

var replicapoolInstanceGroupManagersGet* = Call_ReplicapoolInstanceGroupManagersGet_580000(
    name: "replicapoolInstanceGroupManagersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}",
    validator: validate_ReplicapoolInstanceGroupManagersGet_580001,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersGet_580002, schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersDelete_580017 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolInstanceGroupManagersDelete_580019(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersDelete_580018(path: JsonNode;
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
  var valid_580020 = path.getOrDefault("zone")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "zone", valid_580020
  var valid_580021 = path.getOrDefault("instanceGroupManager")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "instanceGroupManager", valid_580021
  var valid_580022 = path.getOrDefault("project")
  valid_580022 = validateParameter(valid_580022, JString, required = true,
                                 default = nil)
  if valid_580022 != nil:
    section.add "project", valid_580022
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
  var valid_580023 = query.getOrDefault("fields")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "fields", valid_580023
  var valid_580024 = query.getOrDefault("quotaUser")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "quotaUser", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("oauth_token")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "oauth_token", valid_580026
  var valid_580027 = query.getOrDefault("userIp")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "userIp", valid_580027
  var valid_580028 = query.getOrDefault("key")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "key", valid_580028
  var valid_580029 = query.getOrDefault("prettyPrint")
  valid_580029 = validateParameter(valid_580029, JBool, required = false,
                                 default = newJBool(true))
  if valid_580029 != nil:
    section.add "prettyPrint", valid_580029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580030: Call_ReplicapoolInstanceGroupManagersDelete_580017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the instance group manager and all instances contained within. If you'd like to delete the manager without deleting the instances, you must first abandon the instances to remove them from the group.
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_ReplicapoolInstanceGroupManagersDelete_580017;
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
  var path_580032 = newJObject()
  var query_580033 = newJObject()
  add(path_580032, "zone", newJString(zone))
  add(query_580033, "fields", newJString(fields))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(path_580032, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "userIp", newJString(userIp))
  add(query_580033, "key", newJString(key))
  add(path_580032, "project", newJString(project))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  result = call_580031.call(path_580032, query_580033, nil, nil, nil)

var replicapoolInstanceGroupManagersDelete* = Call_ReplicapoolInstanceGroupManagersDelete_580017(
    name: "replicapoolInstanceGroupManagersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}",
    validator: validate_ReplicapoolInstanceGroupManagersDelete_580018,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersDelete_580019,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersAbandonInstances_580034 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolInstanceGroupManagersAbandonInstances_580036(
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

proc validate_ReplicapoolInstanceGroupManagersAbandonInstances_580035(
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
  var valid_580037 = path.getOrDefault("zone")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "zone", valid_580037
  var valid_580038 = path.getOrDefault("instanceGroupManager")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "instanceGroupManager", valid_580038
  var valid_580039 = path.getOrDefault("project")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "project", valid_580039
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
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("quotaUser")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "quotaUser", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("oauth_token")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "oauth_token", valid_580043
  var valid_580044 = query.getOrDefault("userIp")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "userIp", valid_580044
  var valid_580045 = query.getOrDefault("key")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "key", valid_580045
  var valid_580046 = query.getOrDefault("prettyPrint")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(true))
  if valid_580046 != nil:
    section.add "prettyPrint", valid_580046
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

proc call*(call_580048: Call_ReplicapoolInstanceGroupManagersAbandonInstances_580034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified instances from the managed instance group, and from any target pools of which they were members, without deleting the instances.
  ## 
  let valid = call_580048.validator(path, query, header, formData, body)
  let scheme = call_580048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580048.url(scheme.get, call_580048.host, call_580048.base,
                         call_580048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580048, url, valid)

proc call*(call_580049: Call_ReplicapoolInstanceGroupManagersAbandonInstances_580034;
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
  var path_580050 = newJObject()
  var query_580051 = newJObject()
  var body_580052 = newJObject()
  add(path_580050, "zone", newJString(zone))
  add(query_580051, "fields", newJString(fields))
  add(query_580051, "quotaUser", newJString(quotaUser))
  add(path_580050, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_580051, "alt", newJString(alt))
  add(query_580051, "oauth_token", newJString(oauthToken))
  add(query_580051, "userIp", newJString(userIp))
  add(query_580051, "key", newJString(key))
  add(path_580050, "project", newJString(project))
  if body != nil:
    body_580052 = body
  add(query_580051, "prettyPrint", newJBool(prettyPrint))
  result = call_580049.call(path_580050, query_580051, nil, nil, body_580052)

var replicapoolInstanceGroupManagersAbandonInstances* = Call_ReplicapoolInstanceGroupManagersAbandonInstances_580034(
    name: "replicapoolInstanceGroupManagersAbandonInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/abandonInstances",
    validator: validate_ReplicapoolInstanceGroupManagersAbandonInstances_580035,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersAbandonInstances_580036,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersDeleteInstances_580053 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolInstanceGroupManagersDeleteInstances_580055(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersDeleteInstances_580054(
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
  var valid_580056 = path.getOrDefault("zone")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "zone", valid_580056
  var valid_580057 = path.getOrDefault("instanceGroupManager")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "instanceGroupManager", valid_580057
  var valid_580058 = path.getOrDefault("project")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "project", valid_580058
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
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("userIp")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "userIp", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("prettyPrint")
  valid_580065 = validateParameter(valid_580065, JBool, required = false,
                                 default = newJBool(true))
  if valid_580065 != nil:
    section.add "prettyPrint", valid_580065
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

proc call*(call_580067: Call_ReplicapoolInstanceGroupManagersDeleteInstances_580053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified instances. The instances are deleted, then removed from the instance group and any target pools of which they were a member. The targetSize of the instance group manager is reduced by the number of instances deleted.
  ## 
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_ReplicapoolInstanceGroupManagersDeleteInstances_580053;
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
  var path_580069 = newJObject()
  var query_580070 = newJObject()
  var body_580071 = newJObject()
  add(path_580069, "zone", newJString(zone))
  add(query_580070, "fields", newJString(fields))
  add(query_580070, "quotaUser", newJString(quotaUser))
  add(path_580069, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_580070, "alt", newJString(alt))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "userIp", newJString(userIp))
  add(query_580070, "key", newJString(key))
  add(path_580069, "project", newJString(project))
  if body != nil:
    body_580071 = body
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  result = call_580068.call(path_580069, query_580070, nil, nil, body_580071)

var replicapoolInstanceGroupManagersDeleteInstances* = Call_ReplicapoolInstanceGroupManagersDeleteInstances_580053(
    name: "replicapoolInstanceGroupManagersDeleteInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/deleteInstances",
    validator: validate_ReplicapoolInstanceGroupManagersDeleteInstances_580054,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersDeleteInstances_580055,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersRecreateInstances_580072 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolInstanceGroupManagersRecreateInstances_580074(
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

proc validate_ReplicapoolInstanceGroupManagersRecreateInstances_580073(
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
  var valid_580075 = path.getOrDefault("zone")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "zone", valid_580075
  var valid_580076 = path.getOrDefault("instanceGroupManager")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "instanceGroupManager", valid_580076
  var valid_580077 = path.getOrDefault("project")
  valid_580077 = validateParameter(valid_580077, JString, required = true,
                                 default = nil)
  if valid_580077 != nil:
    section.add "project", valid_580077
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

proc call*(call_580086: Call_ReplicapoolInstanceGroupManagersRecreateInstances_580072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recreates the specified instances. The instances are deleted, then recreated using the instance group manager's current instance template.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_ReplicapoolInstanceGroupManagersRecreateInstances_580072;
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
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  var body_580090 = newJObject()
  add(path_580088, "zone", newJString(zone))
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(path_580088, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "userIp", newJString(userIp))
  add(query_580089, "key", newJString(key))
  add(path_580088, "project", newJString(project))
  if body != nil:
    body_580090 = body
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  result = call_580087.call(path_580088, query_580089, nil, nil, body_580090)

var replicapoolInstanceGroupManagersRecreateInstances* = Call_ReplicapoolInstanceGroupManagersRecreateInstances_580072(
    name: "replicapoolInstanceGroupManagersRecreateInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/recreateInstances",
    validator: validate_ReplicapoolInstanceGroupManagersRecreateInstances_580073,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersRecreateInstances_580074,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersResize_580091 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolInstanceGroupManagersResize_580093(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersResize_580092(path: JsonNode;
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
  var valid_580094 = path.getOrDefault("zone")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "zone", valid_580094
  var valid_580095 = path.getOrDefault("instanceGroupManager")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "instanceGroupManager", valid_580095
  var valid_580096 = path.getOrDefault("project")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "project", valid_580096
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
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
  var valid_580098 = query.getOrDefault("quotaUser")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "quotaUser", valid_580098
  var valid_580099 = query.getOrDefault("alt")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("json"))
  if valid_580099 != nil:
    section.add "alt", valid_580099
  var valid_580100 = query.getOrDefault("oauth_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "oauth_token", valid_580100
  var valid_580101 = query.getOrDefault("userIp")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "userIp", valid_580101
  var valid_580102 = query.getOrDefault("key")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "key", valid_580102
  assert query != nil, "query argument is necessary due to required `size` field"
  var valid_580103 = query.getOrDefault("size")
  valid_580103 = validateParameter(valid_580103, JInt, required = true, default = nil)
  if valid_580103 != nil:
    section.add "size", valid_580103
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

proc call*(call_580105: Call_ReplicapoolInstanceGroupManagersResize_580091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resizes the managed instance group up or down. If resized up, new instances are created using the current instance template. If resized down, instances are removed in the order outlined in Resizing a managed instance group.
  ## 
  let valid = call_580105.validator(path, query, header, formData, body)
  let scheme = call_580105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580105.url(scheme.get, call_580105.host, call_580105.base,
                         call_580105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580105, url, valid)

proc call*(call_580106: Call_ReplicapoolInstanceGroupManagersResize_580091;
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
  var path_580107 = newJObject()
  var query_580108 = newJObject()
  add(path_580107, "zone", newJString(zone))
  add(query_580108, "fields", newJString(fields))
  add(query_580108, "quotaUser", newJString(quotaUser))
  add(path_580107, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_580108, "alt", newJString(alt))
  add(query_580108, "oauth_token", newJString(oauthToken))
  add(query_580108, "userIp", newJString(userIp))
  add(query_580108, "key", newJString(key))
  add(query_580108, "size", newJInt(size))
  add(path_580107, "project", newJString(project))
  add(query_580108, "prettyPrint", newJBool(prettyPrint))
  result = call_580106.call(path_580107, query_580108, nil, nil, nil)

var replicapoolInstanceGroupManagersResize* = Call_ReplicapoolInstanceGroupManagersResize_580091(
    name: "replicapoolInstanceGroupManagersResize", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/resize",
    validator: validate_ReplicapoolInstanceGroupManagersResize_580092,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersResize_580093,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_580109 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolInstanceGroupManagersSetInstanceTemplate_580111(
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

proc validate_ReplicapoolInstanceGroupManagersSetInstanceTemplate_580110(
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
  var valid_580112 = path.getOrDefault("zone")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "zone", valid_580112
  var valid_580113 = path.getOrDefault("instanceGroupManager")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "instanceGroupManager", valid_580113
  var valid_580114 = path.getOrDefault("project")
  valid_580114 = validateParameter(valid_580114, JString, required = true,
                                 default = nil)
  if valid_580114 != nil:
    section.add "project", valid_580114
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
  var valid_580115 = query.getOrDefault("fields")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "fields", valid_580115
  var valid_580116 = query.getOrDefault("quotaUser")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "quotaUser", valid_580116
  var valid_580117 = query.getOrDefault("alt")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = newJString("json"))
  if valid_580117 != nil:
    section.add "alt", valid_580117
  var valid_580118 = query.getOrDefault("oauth_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "oauth_token", valid_580118
  var valid_580119 = query.getOrDefault("userIp")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "userIp", valid_580119
  var valid_580120 = query.getOrDefault("key")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "key", valid_580120
  var valid_580121 = query.getOrDefault("prettyPrint")
  valid_580121 = validateParameter(valid_580121, JBool, required = false,
                                 default = newJBool(true))
  if valid_580121 != nil:
    section.add "prettyPrint", valid_580121
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

proc call*(call_580123: Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_580109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the instance template to use when creating new instances in this group. Existing instances are not affected.
  ## 
  let valid = call_580123.validator(path, query, header, formData, body)
  let scheme = call_580123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580123.url(scheme.get, call_580123.host, call_580123.base,
                         call_580123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580123, url, valid)

proc call*(call_580124: Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_580109;
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
  var path_580125 = newJObject()
  var query_580126 = newJObject()
  var body_580127 = newJObject()
  add(path_580125, "zone", newJString(zone))
  add(query_580126, "fields", newJString(fields))
  add(query_580126, "quotaUser", newJString(quotaUser))
  add(path_580125, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_580126, "alt", newJString(alt))
  add(query_580126, "oauth_token", newJString(oauthToken))
  add(query_580126, "userIp", newJString(userIp))
  add(query_580126, "key", newJString(key))
  add(path_580125, "project", newJString(project))
  if body != nil:
    body_580127 = body
  add(query_580126, "prettyPrint", newJBool(prettyPrint))
  result = call_580124.call(path_580125, query_580126, nil, nil, body_580127)

var replicapoolInstanceGroupManagersSetInstanceTemplate* = Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_580109(
    name: "replicapoolInstanceGroupManagersSetInstanceTemplate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/setInstanceTemplate",
    validator: validate_ReplicapoolInstanceGroupManagersSetInstanceTemplate_580110,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersSetInstanceTemplate_580111,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersSetTargetPools_580128 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolInstanceGroupManagersSetTargetPools_580130(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersSetTargetPools_580129(
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
  var valid_580131 = path.getOrDefault("zone")
  valid_580131 = validateParameter(valid_580131, JString, required = true,
                                 default = nil)
  if valid_580131 != nil:
    section.add "zone", valid_580131
  var valid_580132 = path.getOrDefault("instanceGroupManager")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "instanceGroupManager", valid_580132
  var valid_580133 = path.getOrDefault("project")
  valid_580133 = validateParameter(valid_580133, JString, required = true,
                                 default = nil)
  if valid_580133 != nil:
    section.add "project", valid_580133
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
  var valid_580134 = query.getOrDefault("fields")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "fields", valid_580134
  var valid_580135 = query.getOrDefault("quotaUser")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "quotaUser", valid_580135
  var valid_580136 = query.getOrDefault("alt")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("json"))
  if valid_580136 != nil:
    section.add "alt", valid_580136
  var valid_580137 = query.getOrDefault("oauth_token")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "oauth_token", valid_580137
  var valid_580138 = query.getOrDefault("userIp")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "userIp", valid_580138
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("prettyPrint")
  valid_580140 = validateParameter(valid_580140, JBool, required = false,
                                 default = newJBool(true))
  if valid_580140 != nil:
    section.add "prettyPrint", valid_580140
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

proc call*(call_580142: Call_ReplicapoolInstanceGroupManagersSetTargetPools_580128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the target pools to which all new instances in this group are assigned. Existing instances in the group are not affected.
  ## 
  let valid = call_580142.validator(path, query, header, formData, body)
  let scheme = call_580142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580142.url(scheme.get, call_580142.host, call_580142.base,
                         call_580142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580142, url, valid)

proc call*(call_580143: Call_ReplicapoolInstanceGroupManagersSetTargetPools_580128;
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
  var path_580144 = newJObject()
  var query_580145 = newJObject()
  var body_580146 = newJObject()
  add(path_580144, "zone", newJString(zone))
  add(query_580145, "fields", newJString(fields))
  add(query_580145, "quotaUser", newJString(quotaUser))
  add(path_580144, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_580145, "alt", newJString(alt))
  add(query_580145, "oauth_token", newJString(oauthToken))
  add(query_580145, "userIp", newJString(userIp))
  add(query_580145, "key", newJString(key))
  add(path_580144, "project", newJString(project))
  if body != nil:
    body_580146 = body
  add(query_580145, "prettyPrint", newJBool(prettyPrint))
  result = call_580143.call(path_580144, query_580145, nil, nil, body_580146)

var replicapoolInstanceGroupManagersSetTargetPools* = Call_ReplicapoolInstanceGroupManagersSetTargetPools_580128(
    name: "replicapoolInstanceGroupManagersSetTargetPools",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/setTargetPools",
    validator: validate_ReplicapoolInstanceGroupManagersSetTargetPools_580129,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersSetTargetPools_580130,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolZoneOperationsList_580147 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolZoneOperationsList_580149(protocol: Scheme; host: string;
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

proc validate_ReplicapoolZoneOperationsList_580148(path: JsonNode; query: JsonNode;
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
  var valid_580150 = path.getOrDefault("zone")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "zone", valid_580150
  var valid_580151 = path.getOrDefault("project")
  valid_580151 = validateParameter(valid_580151, JString, required = true,
                                 default = nil)
  if valid_580151 != nil:
    section.add "project", valid_580151
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
  var valid_580152 = query.getOrDefault("fields")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "fields", valid_580152
  var valid_580153 = query.getOrDefault("pageToken")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "pageToken", valid_580153
  var valid_580154 = query.getOrDefault("quotaUser")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "quotaUser", valid_580154
  var valid_580155 = query.getOrDefault("alt")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("json"))
  if valid_580155 != nil:
    section.add "alt", valid_580155
  var valid_580156 = query.getOrDefault("oauth_token")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "oauth_token", valid_580156
  var valid_580157 = query.getOrDefault("userIp")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "userIp", valid_580157
  var valid_580158 = query.getOrDefault("maxResults")
  valid_580158 = validateParameter(valid_580158, JInt, required = false,
                                 default = newJInt(500))
  if valid_580158 != nil:
    section.add "maxResults", valid_580158
  var valid_580159 = query.getOrDefault("key")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "key", valid_580159
  var valid_580160 = query.getOrDefault("prettyPrint")
  valid_580160 = validateParameter(valid_580160, JBool, required = false,
                                 default = newJBool(true))
  if valid_580160 != nil:
    section.add "prettyPrint", valid_580160
  var valid_580161 = query.getOrDefault("filter")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "filter", valid_580161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580162: Call_ReplicapoolZoneOperationsList_580147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of operation resources contained within the specified zone.
  ## 
  let valid = call_580162.validator(path, query, header, formData, body)
  let scheme = call_580162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580162.url(scheme.get, call_580162.host, call_580162.base,
                         call_580162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580162, url, valid)

proc call*(call_580163: Call_ReplicapoolZoneOperationsList_580147; zone: string;
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
  var path_580164 = newJObject()
  var query_580165 = newJObject()
  add(path_580164, "zone", newJString(zone))
  add(query_580165, "fields", newJString(fields))
  add(query_580165, "pageToken", newJString(pageToken))
  add(query_580165, "quotaUser", newJString(quotaUser))
  add(query_580165, "alt", newJString(alt))
  add(query_580165, "oauth_token", newJString(oauthToken))
  add(query_580165, "userIp", newJString(userIp))
  add(query_580165, "maxResults", newJInt(maxResults))
  add(query_580165, "key", newJString(key))
  add(path_580164, "project", newJString(project))
  add(query_580165, "prettyPrint", newJBool(prettyPrint))
  add(query_580165, "filter", newJString(filter))
  result = call_580163.call(path_580164, query_580165, nil, nil, nil)

var replicapoolZoneOperationsList* = Call_ReplicapoolZoneOperationsList_580147(
    name: "replicapoolZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/operations",
    validator: validate_ReplicapoolZoneOperationsList_580148,
    base: "/replicapool/v1beta2/projects", url: url_ReplicapoolZoneOperationsList_580149,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolZoneOperationsGet_580166 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolZoneOperationsGet_580168(protocol: Scheme; host: string;
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

proc validate_ReplicapoolZoneOperationsGet_580167(path: JsonNode; query: JsonNode;
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
  var valid_580169 = path.getOrDefault("zone")
  valid_580169 = validateParameter(valid_580169, JString, required = true,
                                 default = nil)
  if valid_580169 != nil:
    section.add "zone", valid_580169
  var valid_580170 = path.getOrDefault("operation")
  valid_580170 = validateParameter(valid_580170, JString, required = true,
                                 default = nil)
  if valid_580170 != nil:
    section.add "operation", valid_580170
  var valid_580171 = path.getOrDefault("project")
  valid_580171 = validateParameter(valid_580171, JString, required = true,
                                 default = nil)
  if valid_580171 != nil:
    section.add "project", valid_580171
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
  var valid_580172 = query.getOrDefault("fields")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "fields", valid_580172
  var valid_580173 = query.getOrDefault("quotaUser")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "quotaUser", valid_580173
  var valid_580174 = query.getOrDefault("alt")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = newJString("json"))
  if valid_580174 != nil:
    section.add "alt", valid_580174
  var valid_580175 = query.getOrDefault("oauth_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "oauth_token", valid_580175
  var valid_580176 = query.getOrDefault("userIp")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "userIp", valid_580176
  var valid_580177 = query.getOrDefault("key")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "key", valid_580177
  var valid_580178 = query.getOrDefault("prettyPrint")
  valid_580178 = validateParameter(valid_580178, JBool, required = false,
                                 default = newJBool(true))
  if valid_580178 != nil:
    section.add "prettyPrint", valid_580178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580179: Call_ReplicapoolZoneOperationsGet_580166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_ReplicapoolZoneOperationsGet_580166; zone: string;
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
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  add(path_580181, "zone", newJString(zone))
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(query_580182, "alt", newJString(alt))
  add(path_580181, "operation", newJString(operation))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(query_580182, "userIp", newJString(userIp))
  add(query_580182, "key", newJString(key))
  add(path_580181, "project", newJString(project))
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  result = call_580180.call(path_580181, query_580182, nil, nil, nil)

var replicapoolZoneOperationsGet* = Call_ReplicapoolZoneOperationsGet_580166(
    name: "replicapoolZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/operations/{operation}",
    validator: validate_ReplicapoolZoneOperationsGet_580167,
    base: "/replicapool/v1beta2/projects", url: url_ReplicapoolZoneOperationsGet_580168,
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
