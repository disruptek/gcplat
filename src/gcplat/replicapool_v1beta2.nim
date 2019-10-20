
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
  gcpServiceName = "replicapool"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReplicapoolInstanceGroupManagersInsert_578914 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolInstanceGroupManagersInsert_578916(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersInsert_578915(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an instance group manager, as well as the instance group and the specified number of instances.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578917 = path.getOrDefault("project")
  valid_578917 = validateParameter(valid_578917, JString, required = true,
                                 default = nil)
  if valid_578917 != nil:
    section.add "project", valid_578917
  var valid_578918 = path.getOrDefault("zone")
  valid_578918 = validateParameter(valid_578918, JString, required = true,
                                 default = nil)
  if valid_578918 != nil:
    section.add "zone", valid_578918
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
  ##   size: JInt (required)
  ##       : Number of instances that should exist.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578919 = query.getOrDefault("key")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "key", valid_578919
  var valid_578920 = query.getOrDefault("prettyPrint")
  valid_578920 = validateParameter(valid_578920, JBool, required = false,
                                 default = newJBool(true))
  if valid_578920 != nil:
    section.add "prettyPrint", valid_578920
  var valid_578921 = query.getOrDefault("oauth_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "oauth_token", valid_578921
  var valid_578922 = query.getOrDefault("alt")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = newJString("json"))
  if valid_578922 != nil:
    section.add "alt", valid_578922
  var valid_578923 = query.getOrDefault("userIp")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "userIp", valid_578923
  var valid_578924 = query.getOrDefault("quotaUser")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "quotaUser", valid_578924
  assert query != nil, "query argument is necessary due to required `size` field"
  var valid_578925 = query.getOrDefault("size")
  valid_578925 = validateParameter(valid_578925, JInt, required = true, default = nil)
  if valid_578925 != nil:
    section.add "size", valid_578925
  var valid_578926 = query.getOrDefault("fields")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "fields", valid_578926
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

proc call*(call_578928: Call_ReplicapoolInstanceGroupManagersInsert_578914;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an instance group manager, as well as the instance group and the specified number of instances.
  ## 
  let valid = call_578928.validator(path, query, header, formData, body)
  let scheme = call_578928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578928.url(scheme.get, call_578928.host, call_578928.base,
                         call_578928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578928, url, valid)

proc call*(call_578929: Call_ReplicapoolInstanceGroupManagersInsert_578914;
          project: string; size: int; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## replicapoolInstanceGroupManagersInsert
  ## Creates an instance group manager, as well as the instance group and the specified number of instances.
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
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   size: int (required)
  ##       : Number of instances that should exist.
  ##   body: JObject
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578930 = newJObject()
  var query_578931 = newJObject()
  var body_578932 = newJObject()
  add(query_578931, "key", newJString(key))
  add(query_578931, "prettyPrint", newJBool(prettyPrint))
  add(query_578931, "oauth_token", newJString(oauthToken))
  add(query_578931, "alt", newJString(alt))
  add(query_578931, "userIp", newJString(userIp))
  add(query_578931, "quotaUser", newJString(quotaUser))
  add(path_578930, "project", newJString(project))
  add(query_578931, "size", newJInt(size))
  if body != nil:
    body_578932 = body
  add(path_578930, "zone", newJString(zone))
  add(query_578931, "fields", newJString(fields))
  result = call_578929.call(path_578930, query_578931, nil, nil, body_578932)

var replicapoolInstanceGroupManagersInsert* = Call_ReplicapoolInstanceGroupManagersInsert_578914(
    name: "replicapoolInstanceGroupManagersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/instanceGroupManagers",
    validator: validate_ReplicapoolInstanceGroupManagersInsert_578915,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersInsert_578916,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersList_578625 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolInstanceGroupManagersList_578627(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersList_578626(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of Instance Group Manager resources contained within the specified zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578753 = path.getOrDefault("project")
  valid_578753 = validateParameter(valid_578753, JString, required = true,
                                 default = nil)
  if valid_578753 != nil:
    section.add "project", valid_578753
  var valid_578754 = path.getOrDefault("zone")
  valid_578754 = validateParameter(valid_578754, JString, required = true,
                                 default = nil)
  if valid_578754 != nil:
    section.add "zone", valid_578754
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
  ##   filter: JString
  ##         : Optional. Filter expression for filtering listed resources.
  ##   pageToken: JString
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  section = newJObject()
  var valid_578755 = query.getOrDefault("key")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "key", valid_578755
  var valid_578769 = query.getOrDefault("prettyPrint")
  valid_578769 = validateParameter(valid_578769, JBool, required = false,
                                 default = newJBool(true))
  if valid_578769 != nil:
    section.add "prettyPrint", valid_578769
  var valid_578770 = query.getOrDefault("oauth_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "oauth_token", valid_578770
  var valid_578771 = query.getOrDefault("alt")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = newJString("json"))
  if valid_578771 != nil:
    section.add "alt", valid_578771
  var valid_578772 = query.getOrDefault("userIp")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "userIp", valid_578772
  var valid_578773 = query.getOrDefault("quotaUser")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "quotaUser", valid_578773
  var valid_578774 = query.getOrDefault("filter")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "filter", valid_578774
  var valid_578775 = query.getOrDefault("pageToken")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = nil)
  if valid_578775 != nil:
    section.add "pageToken", valid_578775
  var valid_578776 = query.getOrDefault("fields")
  valid_578776 = validateParameter(valid_578776, JString, required = false,
                                 default = nil)
  if valid_578776 != nil:
    section.add "fields", valid_578776
  var valid_578778 = query.getOrDefault("maxResults")
  valid_578778 = validateParameter(valid_578778, JInt, required = false,
                                 default = newJInt(500))
  if valid_578778 != nil:
    section.add "maxResults", valid_578778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578801: Call_ReplicapoolInstanceGroupManagersList_578625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of Instance Group Manager resources contained within the specified zone.
  ## 
  let valid = call_578801.validator(path, query, header, formData, body)
  let scheme = call_578801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578801.url(scheme.get, call_578801.host, call_578801.base,
                         call_578801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578801, url, valid)

proc call*(call_578872: Call_ReplicapoolInstanceGroupManagersList_578625;
          project: string; zone: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 500): Recallable =
  ## replicapoolInstanceGroupManagersList
  ## Retrieves the list of Instance Group Manager resources contained within the specified zone.
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
  ##   filter: string
  ##         : Optional. Filter expression for filtering listed resources.
  ##   pageToken: string
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  var path_578873 = newJObject()
  var query_578875 = newJObject()
  add(query_578875, "key", newJString(key))
  add(query_578875, "prettyPrint", newJBool(prettyPrint))
  add(query_578875, "oauth_token", newJString(oauthToken))
  add(query_578875, "alt", newJString(alt))
  add(query_578875, "userIp", newJString(userIp))
  add(query_578875, "quotaUser", newJString(quotaUser))
  add(query_578875, "filter", newJString(filter))
  add(query_578875, "pageToken", newJString(pageToken))
  add(path_578873, "project", newJString(project))
  add(path_578873, "zone", newJString(zone))
  add(query_578875, "fields", newJString(fields))
  add(query_578875, "maxResults", newJInt(maxResults))
  result = call_578872.call(path_578873, query_578875, nil, nil, nil)

var replicapoolInstanceGroupManagersList* = Call_ReplicapoolInstanceGroupManagersList_578625(
    name: "replicapoolInstanceGroupManagersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/instanceGroupManagers",
    validator: validate_ReplicapoolInstanceGroupManagersList_578626,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersList_578627, schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersGet_578933 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolInstanceGroupManagersGet_578935(protocol: Scheme; host: string;
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

proc validate_ReplicapoolInstanceGroupManagersGet_578934(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified Instance Group Manager resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceGroupManager: JString (required)
  ##                       : Name of the instance resource to return.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instanceGroupManager` field"
  var valid_578936 = path.getOrDefault("instanceGroupManager")
  valid_578936 = validateParameter(valid_578936, JString, required = true,
                                 default = nil)
  if valid_578936 != nil:
    section.add "instanceGroupManager", valid_578936
  var valid_578937 = path.getOrDefault("project")
  valid_578937 = validateParameter(valid_578937, JString, required = true,
                                 default = nil)
  if valid_578937 != nil:
    section.add "project", valid_578937
  var valid_578938 = path.getOrDefault("zone")
  valid_578938 = validateParameter(valid_578938, JString, required = true,
                                 default = nil)
  if valid_578938 != nil:
    section.add "zone", valid_578938
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
  var valid_578939 = query.getOrDefault("key")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "key", valid_578939
  var valid_578940 = query.getOrDefault("prettyPrint")
  valid_578940 = validateParameter(valid_578940, JBool, required = false,
                                 default = newJBool(true))
  if valid_578940 != nil:
    section.add "prettyPrint", valid_578940
  var valid_578941 = query.getOrDefault("oauth_token")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "oauth_token", valid_578941
  var valid_578942 = query.getOrDefault("alt")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = newJString("json"))
  if valid_578942 != nil:
    section.add "alt", valid_578942
  var valid_578943 = query.getOrDefault("userIp")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "userIp", valid_578943
  var valid_578944 = query.getOrDefault("quotaUser")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "quotaUser", valid_578944
  var valid_578945 = query.getOrDefault("fields")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "fields", valid_578945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578946: Call_ReplicapoolInstanceGroupManagersGet_578933;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the specified Instance Group Manager resource.
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_ReplicapoolInstanceGroupManagersGet_578933;
          instanceGroupManager: string; project: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## replicapoolInstanceGroupManagersGet
  ## Returns the specified Instance Group Manager resource.
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
  ##   instanceGroupManager: string (required)
  ##                       : Name of the instance resource to return.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578948 = newJObject()
  var query_578949 = newJObject()
  add(query_578949, "key", newJString(key))
  add(query_578949, "prettyPrint", newJBool(prettyPrint))
  add(query_578949, "oauth_token", newJString(oauthToken))
  add(query_578949, "alt", newJString(alt))
  add(query_578949, "userIp", newJString(userIp))
  add(query_578949, "quotaUser", newJString(quotaUser))
  add(path_578948, "instanceGroupManager", newJString(instanceGroupManager))
  add(path_578948, "project", newJString(project))
  add(path_578948, "zone", newJString(zone))
  add(query_578949, "fields", newJString(fields))
  result = call_578947.call(path_578948, query_578949, nil, nil, nil)

var replicapoolInstanceGroupManagersGet* = Call_ReplicapoolInstanceGroupManagersGet_578933(
    name: "replicapoolInstanceGroupManagersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}",
    validator: validate_ReplicapoolInstanceGroupManagersGet_578934,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersGet_578935, schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersDelete_578950 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolInstanceGroupManagersDelete_578952(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersDelete_578951(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the instance group manager and all instances contained within. If you'd like to delete the manager without deleting the instances, you must first abandon the instances to remove them from the group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceGroupManager: JString (required)
  ##                       : Name of the Instance Group Manager resource to delete.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instanceGroupManager` field"
  var valid_578953 = path.getOrDefault("instanceGroupManager")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "instanceGroupManager", valid_578953
  var valid_578954 = path.getOrDefault("project")
  valid_578954 = validateParameter(valid_578954, JString, required = true,
                                 default = nil)
  if valid_578954 != nil:
    section.add "project", valid_578954
  var valid_578955 = path.getOrDefault("zone")
  valid_578955 = validateParameter(valid_578955, JString, required = true,
                                 default = nil)
  if valid_578955 != nil:
    section.add "zone", valid_578955
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
  var valid_578956 = query.getOrDefault("key")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "key", valid_578956
  var valid_578957 = query.getOrDefault("prettyPrint")
  valid_578957 = validateParameter(valid_578957, JBool, required = false,
                                 default = newJBool(true))
  if valid_578957 != nil:
    section.add "prettyPrint", valid_578957
  var valid_578958 = query.getOrDefault("oauth_token")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "oauth_token", valid_578958
  var valid_578959 = query.getOrDefault("alt")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = newJString("json"))
  if valid_578959 != nil:
    section.add "alt", valid_578959
  var valid_578960 = query.getOrDefault("userIp")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "userIp", valid_578960
  var valid_578961 = query.getOrDefault("quotaUser")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "quotaUser", valid_578961
  var valid_578962 = query.getOrDefault("fields")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "fields", valid_578962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578963: Call_ReplicapoolInstanceGroupManagersDelete_578950;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the instance group manager and all instances contained within. If you'd like to delete the manager without deleting the instances, you must first abandon the instances to remove them from the group.
  ## 
  let valid = call_578963.validator(path, query, header, formData, body)
  let scheme = call_578963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578963.url(scheme.get, call_578963.host, call_578963.base,
                         call_578963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578963, url, valid)

proc call*(call_578964: Call_ReplicapoolInstanceGroupManagersDelete_578950;
          instanceGroupManager: string; project: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## replicapoolInstanceGroupManagersDelete
  ## Deletes the instance group manager and all instances contained within. If you'd like to delete the manager without deleting the instances, you must first abandon the instances to remove them from the group.
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
  ##   instanceGroupManager: string (required)
  ##                       : Name of the Instance Group Manager resource to delete.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578965 = newJObject()
  var query_578966 = newJObject()
  add(query_578966, "key", newJString(key))
  add(query_578966, "prettyPrint", newJBool(prettyPrint))
  add(query_578966, "oauth_token", newJString(oauthToken))
  add(query_578966, "alt", newJString(alt))
  add(query_578966, "userIp", newJString(userIp))
  add(query_578966, "quotaUser", newJString(quotaUser))
  add(path_578965, "instanceGroupManager", newJString(instanceGroupManager))
  add(path_578965, "project", newJString(project))
  add(path_578965, "zone", newJString(zone))
  add(query_578966, "fields", newJString(fields))
  result = call_578964.call(path_578965, query_578966, nil, nil, nil)

var replicapoolInstanceGroupManagersDelete* = Call_ReplicapoolInstanceGroupManagersDelete_578950(
    name: "replicapoolInstanceGroupManagersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}",
    validator: validate_ReplicapoolInstanceGroupManagersDelete_578951,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersDelete_578952,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersAbandonInstances_578967 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolInstanceGroupManagersAbandonInstances_578969(
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

proc validate_ReplicapoolInstanceGroupManagersAbandonInstances_578968(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes the specified instances from the managed instance group, and from any target pools of which they were members, without deleting the instances.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instanceGroupManager` field"
  var valid_578970 = path.getOrDefault("instanceGroupManager")
  valid_578970 = validateParameter(valid_578970, JString, required = true,
                                 default = nil)
  if valid_578970 != nil:
    section.add "instanceGroupManager", valid_578970
  var valid_578971 = path.getOrDefault("project")
  valid_578971 = validateParameter(valid_578971, JString, required = true,
                                 default = nil)
  if valid_578971 != nil:
    section.add "project", valid_578971
  var valid_578972 = path.getOrDefault("zone")
  valid_578972 = validateParameter(valid_578972, JString, required = true,
                                 default = nil)
  if valid_578972 != nil:
    section.add "zone", valid_578972
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
  var valid_578973 = query.getOrDefault("key")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "key", valid_578973
  var valid_578974 = query.getOrDefault("prettyPrint")
  valid_578974 = validateParameter(valid_578974, JBool, required = false,
                                 default = newJBool(true))
  if valid_578974 != nil:
    section.add "prettyPrint", valid_578974
  var valid_578975 = query.getOrDefault("oauth_token")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "oauth_token", valid_578975
  var valid_578976 = query.getOrDefault("alt")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = newJString("json"))
  if valid_578976 != nil:
    section.add "alt", valid_578976
  var valid_578977 = query.getOrDefault("userIp")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "userIp", valid_578977
  var valid_578978 = query.getOrDefault("quotaUser")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "quotaUser", valid_578978
  var valid_578979 = query.getOrDefault("fields")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "fields", valid_578979
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

proc call*(call_578981: Call_ReplicapoolInstanceGroupManagersAbandonInstances_578967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified instances from the managed instance group, and from any target pools of which they were members, without deleting the instances.
  ## 
  let valid = call_578981.validator(path, query, header, formData, body)
  let scheme = call_578981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578981.url(scheme.get, call_578981.host, call_578981.base,
                         call_578981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578981, url, valid)

proc call*(call_578982: Call_ReplicapoolInstanceGroupManagersAbandonInstances_578967;
          instanceGroupManager: string; project: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## replicapoolInstanceGroupManagersAbandonInstances
  ## Removes the specified instances from the managed instance group, and from any target pools of which they were members, without deleting the instances.
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
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578983 = newJObject()
  var query_578984 = newJObject()
  var body_578985 = newJObject()
  add(query_578984, "key", newJString(key))
  add(query_578984, "prettyPrint", newJBool(prettyPrint))
  add(query_578984, "oauth_token", newJString(oauthToken))
  add(query_578984, "alt", newJString(alt))
  add(query_578984, "userIp", newJString(userIp))
  add(query_578984, "quotaUser", newJString(quotaUser))
  add(path_578983, "instanceGroupManager", newJString(instanceGroupManager))
  add(path_578983, "project", newJString(project))
  add(path_578983, "zone", newJString(zone))
  if body != nil:
    body_578985 = body
  add(query_578984, "fields", newJString(fields))
  result = call_578982.call(path_578983, query_578984, nil, nil, body_578985)

var replicapoolInstanceGroupManagersAbandonInstances* = Call_ReplicapoolInstanceGroupManagersAbandonInstances_578967(
    name: "replicapoolInstanceGroupManagersAbandonInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/abandonInstances",
    validator: validate_ReplicapoolInstanceGroupManagersAbandonInstances_578968,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersAbandonInstances_578969,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersDeleteInstances_578986 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolInstanceGroupManagersDeleteInstances_578988(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersDeleteInstances_578987(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the specified instances. The instances are deleted, then removed from the instance group and any target pools of which they were a member. The targetSize of the instance group manager is reduced by the number of instances deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instanceGroupManager` field"
  var valid_578989 = path.getOrDefault("instanceGroupManager")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "instanceGroupManager", valid_578989
  var valid_578990 = path.getOrDefault("project")
  valid_578990 = validateParameter(valid_578990, JString, required = true,
                                 default = nil)
  if valid_578990 != nil:
    section.add "project", valid_578990
  var valid_578991 = path.getOrDefault("zone")
  valid_578991 = validateParameter(valid_578991, JString, required = true,
                                 default = nil)
  if valid_578991 != nil:
    section.add "zone", valid_578991
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
  var valid_578992 = query.getOrDefault("key")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "key", valid_578992
  var valid_578993 = query.getOrDefault("prettyPrint")
  valid_578993 = validateParameter(valid_578993, JBool, required = false,
                                 default = newJBool(true))
  if valid_578993 != nil:
    section.add "prettyPrint", valid_578993
  var valid_578994 = query.getOrDefault("oauth_token")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "oauth_token", valid_578994
  var valid_578995 = query.getOrDefault("alt")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("json"))
  if valid_578995 != nil:
    section.add "alt", valid_578995
  var valid_578996 = query.getOrDefault("userIp")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "userIp", valid_578996
  var valid_578997 = query.getOrDefault("quotaUser")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "quotaUser", valid_578997
  var valid_578998 = query.getOrDefault("fields")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "fields", valid_578998
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

proc call*(call_579000: Call_ReplicapoolInstanceGroupManagersDeleteInstances_578986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified instances. The instances are deleted, then removed from the instance group and any target pools of which they were a member. The targetSize of the instance group manager is reduced by the number of instances deleted.
  ## 
  let valid = call_579000.validator(path, query, header, formData, body)
  let scheme = call_579000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579000.url(scheme.get, call_579000.host, call_579000.base,
                         call_579000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579000, url, valid)

proc call*(call_579001: Call_ReplicapoolInstanceGroupManagersDeleteInstances_578986;
          instanceGroupManager: string; project: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## replicapoolInstanceGroupManagersDeleteInstances
  ## Deletes the specified instances. The instances are deleted, then removed from the instance group and any target pools of which they were a member. The targetSize of the instance group manager is reduced by the number of instances deleted.
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
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579002 = newJObject()
  var query_579003 = newJObject()
  var body_579004 = newJObject()
  add(query_579003, "key", newJString(key))
  add(query_579003, "prettyPrint", newJBool(prettyPrint))
  add(query_579003, "oauth_token", newJString(oauthToken))
  add(query_579003, "alt", newJString(alt))
  add(query_579003, "userIp", newJString(userIp))
  add(query_579003, "quotaUser", newJString(quotaUser))
  add(path_579002, "instanceGroupManager", newJString(instanceGroupManager))
  add(path_579002, "project", newJString(project))
  add(path_579002, "zone", newJString(zone))
  if body != nil:
    body_579004 = body
  add(query_579003, "fields", newJString(fields))
  result = call_579001.call(path_579002, query_579003, nil, nil, body_579004)

var replicapoolInstanceGroupManagersDeleteInstances* = Call_ReplicapoolInstanceGroupManagersDeleteInstances_578986(
    name: "replicapoolInstanceGroupManagersDeleteInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/deleteInstances",
    validator: validate_ReplicapoolInstanceGroupManagersDeleteInstances_578987,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersDeleteInstances_578988,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersRecreateInstances_579005 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolInstanceGroupManagersRecreateInstances_579007(
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

proc validate_ReplicapoolInstanceGroupManagersRecreateInstances_579006(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Recreates the specified instances. The instances are deleted, then recreated using the instance group manager's current instance template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instanceGroupManager` field"
  var valid_579008 = path.getOrDefault("instanceGroupManager")
  valid_579008 = validateParameter(valid_579008, JString, required = true,
                                 default = nil)
  if valid_579008 != nil:
    section.add "instanceGroupManager", valid_579008
  var valid_579009 = path.getOrDefault("project")
  valid_579009 = validateParameter(valid_579009, JString, required = true,
                                 default = nil)
  if valid_579009 != nil:
    section.add "project", valid_579009
  var valid_579010 = path.getOrDefault("zone")
  valid_579010 = validateParameter(valid_579010, JString, required = true,
                                 default = nil)
  if valid_579010 != nil:
    section.add "zone", valid_579010
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
  var valid_579011 = query.getOrDefault("key")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "key", valid_579011
  var valid_579012 = query.getOrDefault("prettyPrint")
  valid_579012 = validateParameter(valid_579012, JBool, required = false,
                                 default = newJBool(true))
  if valid_579012 != nil:
    section.add "prettyPrint", valid_579012
  var valid_579013 = query.getOrDefault("oauth_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "oauth_token", valid_579013
  var valid_579014 = query.getOrDefault("alt")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = newJString("json"))
  if valid_579014 != nil:
    section.add "alt", valid_579014
  var valid_579015 = query.getOrDefault("userIp")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "userIp", valid_579015
  var valid_579016 = query.getOrDefault("quotaUser")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "quotaUser", valid_579016
  var valid_579017 = query.getOrDefault("fields")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "fields", valid_579017
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

proc call*(call_579019: Call_ReplicapoolInstanceGroupManagersRecreateInstances_579005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recreates the specified instances. The instances are deleted, then recreated using the instance group manager's current instance template.
  ## 
  let valid = call_579019.validator(path, query, header, formData, body)
  let scheme = call_579019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579019.url(scheme.get, call_579019.host, call_579019.base,
                         call_579019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579019, url, valid)

proc call*(call_579020: Call_ReplicapoolInstanceGroupManagersRecreateInstances_579005;
          instanceGroupManager: string; project: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## replicapoolInstanceGroupManagersRecreateInstances
  ## Recreates the specified instances. The instances are deleted, then recreated using the instance group manager's current instance template.
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
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579021 = newJObject()
  var query_579022 = newJObject()
  var body_579023 = newJObject()
  add(query_579022, "key", newJString(key))
  add(query_579022, "prettyPrint", newJBool(prettyPrint))
  add(query_579022, "oauth_token", newJString(oauthToken))
  add(query_579022, "alt", newJString(alt))
  add(query_579022, "userIp", newJString(userIp))
  add(query_579022, "quotaUser", newJString(quotaUser))
  add(path_579021, "instanceGroupManager", newJString(instanceGroupManager))
  add(path_579021, "project", newJString(project))
  add(path_579021, "zone", newJString(zone))
  if body != nil:
    body_579023 = body
  add(query_579022, "fields", newJString(fields))
  result = call_579020.call(path_579021, query_579022, nil, nil, body_579023)

var replicapoolInstanceGroupManagersRecreateInstances* = Call_ReplicapoolInstanceGroupManagersRecreateInstances_579005(
    name: "replicapoolInstanceGroupManagersRecreateInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/recreateInstances",
    validator: validate_ReplicapoolInstanceGroupManagersRecreateInstances_579006,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersRecreateInstances_579007,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersResize_579024 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolInstanceGroupManagersResize_579026(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersResize_579025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resizes the managed instance group up or down. If resized up, new instances are created using the current instance template. If resized down, instances are removed in the order outlined in Resizing a managed instance group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instanceGroupManager` field"
  var valid_579027 = path.getOrDefault("instanceGroupManager")
  valid_579027 = validateParameter(valid_579027, JString, required = true,
                                 default = nil)
  if valid_579027 != nil:
    section.add "instanceGroupManager", valid_579027
  var valid_579028 = path.getOrDefault("project")
  valid_579028 = validateParameter(valid_579028, JString, required = true,
                                 default = nil)
  if valid_579028 != nil:
    section.add "project", valid_579028
  var valid_579029 = path.getOrDefault("zone")
  valid_579029 = validateParameter(valid_579029, JString, required = true,
                                 default = nil)
  if valid_579029 != nil:
    section.add "zone", valid_579029
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
  ##   size: JInt (required)
  ##       : Number of instances that should exist in this Instance Group Manager.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579030 = query.getOrDefault("key")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "key", valid_579030
  var valid_579031 = query.getOrDefault("prettyPrint")
  valid_579031 = validateParameter(valid_579031, JBool, required = false,
                                 default = newJBool(true))
  if valid_579031 != nil:
    section.add "prettyPrint", valid_579031
  var valid_579032 = query.getOrDefault("oauth_token")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "oauth_token", valid_579032
  var valid_579033 = query.getOrDefault("alt")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("json"))
  if valid_579033 != nil:
    section.add "alt", valid_579033
  var valid_579034 = query.getOrDefault("userIp")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "userIp", valid_579034
  var valid_579035 = query.getOrDefault("quotaUser")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "quotaUser", valid_579035
  assert query != nil, "query argument is necessary due to required `size` field"
  var valid_579036 = query.getOrDefault("size")
  valid_579036 = validateParameter(valid_579036, JInt, required = true, default = nil)
  if valid_579036 != nil:
    section.add "size", valid_579036
  var valid_579037 = query.getOrDefault("fields")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "fields", valid_579037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579038: Call_ReplicapoolInstanceGroupManagersResize_579024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resizes the managed instance group up or down. If resized up, new instances are created using the current instance template. If resized down, instances are removed in the order outlined in Resizing a managed instance group.
  ## 
  let valid = call_579038.validator(path, query, header, formData, body)
  let scheme = call_579038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579038.url(scheme.get, call_579038.host, call_579038.base,
                         call_579038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579038, url, valid)

proc call*(call_579039: Call_ReplicapoolInstanceGroupManagersResize_579024;
          instanceGroupManager: string; project: string; size: int; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## replicapoolInstanceGroupManagersResize
  ## Resizes the managed instance group up or down. If resized up, new instances are created using the current instance template. If resized down, instances are removed in the order outlined in Resizing a managed instance group.
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
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   size: int (required)
  ##       : Number of instances that should exist in this Instance Group Manager.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579040 = newJObject()
  var query_579041 = newJObject()
  add(query_579041, "key", newJString(key))
  add(query_579041, "prettyPrint", newJBool(prettyPrint))
  add(query_579041, "oauth_token", newJString(oauthToken))
  add(query_579041, "alt", newJString(alt))
  add(query_579041, "userIp", newJString(userIp))
  add(query_579041, "quotaUser", newJString(quotaUser))
  add(path_579040, "instanceGroupManager", newJString(instanceGroupManager))
  add(path_579040, "project", newJString(project))
  add(query_579041, "size", newJInt(size))
  add(path_579040, "zone", newJString(zone))
  add(query_579041, "fields", newJString(fields))
  result = call_579039.call(path_579040, query_579041, nil, nil, nil)

var replicapoolInstanceGroupManagersResize* = Call_ReplicapoolInstanceGroupManagersResize_579024(
    name: "replicapoolInstanceGroupManagersResize", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/resize",
    validator: validate_ReplicapoolInstanceGroupManagersResize_579025,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersResize_579026,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_579042 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolInstanceGroupManagersSetInstanceTemplate_579044(
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

proc validate_ReplicapoolInstanceGroupManagersSetInstanceTemplate_579043(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the instance template to use when creating new instances in this group. Existing instances are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instanceGroupManager` field"
  var valid_579045 = path.getOrDefault("instanceGroupManager")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "instanceGroupManager", valid_579045
  var valid_579046 = path.getOrDefault("project")
  valid_579046 = validateParameter(valid_579046, JString, required = true,
                                 default = nil)
  if valid_579046 != nil:
    section.add "project", valid_579046
  var valid_579047 = path.getOrDefault("zone")
  valid_579047 = validateParameter(valid_579047, JString, required = true,
                                 default = nil)
  if valid_579047 != nil:
    section.add "zone", valid_579047
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
  var valid_579048 = query.getOrDefault("key")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "key", valid_579048
  var valid_579049 = query.getOrDefault("prettyPrint")
  valid_579049 = validateParameter(valid_579049, JBool, required = false,
                                 default = newJBool(true))
  if valid_579049 != nil:
    section.add "prettyPrint", valid_579049
  var valid_579050 = query.getOrDefault("oauth_token")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "oauth_token", valid_579050
  var valid_579051 = query.getOrDefault("alt")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = newJString("json"))
  if valid_579051 != nil:
    section.add "alt", valid_579051
  var valid_579052 = query.getOrDefault("userIp")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "userIp", valid_579052
  var valid_579053 = query.getOrDefault("quotaUser")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "quotaUser", valid_579053
  var valid_579054 = query.getOrDefault("fields")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "fields", valid_579054
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

proc call*(call_579056: Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_579042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the instance template to use when creating new instances in this group. Existing instances are not affected.
  ## 
  let valid = call_579056.validator(path, query, header, formData, body)
  let scheme = call_579056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579056.url(scheme.get, call_579056.host, call_579056.base,
                         call_579056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579056, url, valid)

proc call*(call_579057: Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_579042;
          instanceGroupManager: string; project: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## replicapoolInstanceGroupManagersSetInstanceTemplate
  ## Sets the instance template to use when creating new instances in this group. Existing instances are not affected.
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
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579058 = newJObject()
  var query_579059 = newJObject()
  var body_579060 = newJObject()
  add(query_579059, "key", newJString(key))
  add(query_579059, "prettyPrint", newJBool(prettyPrint))
  add(query_579059, "oauth_token", newJString(oauthToken))
  add(query_579059, "alt", newJString(alt))
  add(query_579059, "userIp", newJString(userIp))
  add(query_579059, "quotaUser", newJString(quotaUser))
  add(path_579058, "instanceGroupManager", newJString(instanceGroupManager))
  add(path_579058, "project", newJString(project))
  add(path_579058, "zone", newJString(zone))
  if body != nil:
    body_579060 = body
  add(query_579059, "fields", newJString(fields))
  result = call_579057.call(path_579058, query_579059, nil, nil, body_579060)

var replicapoolInstanceGroupManagersSetInstanceTemplate* = Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_579042(
    name: "replicapoolInstanceGroupManagersSetInstanceTemplate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/setInstanceTemplate",
    validator: validate_ReplicapoolInstanceGroupManagersSetInstanceTemplate_579043,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersSetInstanceTemplate_579044,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersSetTargetPools_579061 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolInstanceGroupManagersSetTargetPools_579063(protocol: Scheme;
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

proc validate_ReplicapoolInstanceGroupManagersSetTargetPools_579062(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Modifies the target pools to which all new instances in this group are assigned. Existing instances in the group are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instanceGroupManager` field"
  var valid_579064 = path.getOrDefault("instanceGroupManager")
  valid_579064 = validateParameter(valid_579064, JString, required = true,
                                 default = nil)
  if valid_579064 != nil:
    section.add "instanceGroupManager", valid_579064
  var valid_579065 = path.getOrDefault("project")
  valid_579065 = validateParameter(valid_579065, JString, required = true,
                                 default = nil)
  if valid_579065 != nil:
    section.add "project", valid_579065
  var valid_579066 = path.getOrDefault("zone")
  valid_579066 = validateParameter(valid_579066, JString, required = true,
                                 default = nil)
  if valid_579066 != nil:
    section.add "zone", valid_579066
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
  var valid_579067 = query.getOrDefault("key")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "key", valid_579067
  var valid_579068 = query.getOrDefault("prettyPrint")
  valid_579068 = validateParameter(valid_579068, JBool, required = false,
                                 default = newJBool(true))
  if valid_579068 != nil:
    section.add "prettyPrint", valid_579068
  var valid_579069 = query.getOrDefault("oauth_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "oauth_token", valid_579069
  var valid_579070 = query.getOrDefault("alt")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("json"))
  if valid_579070 != nil:
    section.add "alt", valid_579070
  var valid_579071 = query.getOrDefault("userIp")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "userIp", valid_579071
  var valid_579072 = query.getOrDefault("quotaUser")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "quotaUser", valid_579072
  var valid_579073 = query.getOrDefault("fields")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "fields", valid_579073
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

proc call*(call_579075: Call_ReplicapoolInstanceGroupManagersSetTargetPools_579061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the target pools to which all new instances in this group are assigned. Existing instances in the group are not affected.
  ## 
  let valid = call_579075.validator(path, query, header, formData, body)
  let scheme = call_579075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579075.url(scheme.get, call_579075.host, call_579075.base,
                         call_579075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579075, url, valid)

proc call*(call_579076: Call_ReplicapoolInstanceGroupManagersSetTargetPools_579061;
          instanceGroupManager: string; project: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## replicapoolInstanceGroupManagersSetTargetPools
  ## Modifies the target pools to which all new instances in this group are assigned. Existing instances in the group are not affected.
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
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579077 = newJObject()
  var query_579078 = newJObject()
  var body_579079 = newJObject()
  add(query_579078, "key", newJString(key))
  add(query_579078, "prettyPrint", newJBool(prettyPrint))
  add(query_579078, "oauth_token", newJString(oauthToken))
  add(query_579078, "alt", newJString(alt))
  add(query_579078, "userIp", newJString(userIp))
  add(query_579078, "quotaUser", newJString(quotaUser))
  add(path_579077, "instanceGroupManager", newJString(instanceGroupManager))
  add(path_579077, "project", newJString(project))
  add(path_579077, "zone", newJString(zone))
  if body != nil:
    body_579079 = body
  add(query_579078, "fields", newJString(fields))
  result = call_579076.call(path_579077, query_579078, nil, nil, body_579079)

var replicapoolInstanceGroupManagersSetTargetPools* = Call_ReplicapoolInstanceGroupManagersSetTargetPools_579061(
    name: "replicapoolInstanceGroupManagersSetTargetPools",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/setTargetPools",
    validator: validate_ReplicapoolInstanceGroupManagersSetTargetPools_579062,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersSetTargetPools_579063,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolZoneOperationsList_579080 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolZoneOperationsList_579082(protocol: Scheme; host: string;
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

proc validate_ReplicapoolZoneOperationsList_579081(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of operation resources contained within the specified zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Name of the project scoping this request.
  ##   zone: JString (required)
  ##       : Name of the zone scoping this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579083 = path.getOrDefault("project")
  valid_579083 = validateParameter(valid_579083, JString, required = true,
                                 default = nil)
  if valid_579083 != nil:
    section.add "project", valid_579083
  var valid_579084 = path.getOrDefault("zone")
  valid_579084 = validateParameter(valid_579084, JString, required = true,
                                 default = nil)
  if valid_579084 != nil:
    section.add "zone", valid_579084
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
  ##   filter: JString
  ##         : Optional. Filter expression for filtering listed resources.
  ##   pageToken: JString
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  section = newJObject()
  var valid_579085 = query.getOrDefault("key")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "key", valid_579085
  var valid_579086 = query.getOrDefault("prettyPrint")
  valid_579086 = validateParameter(valid_579086, JBool, required = false,
                                 default = newJBool(true))
  if valid_579086 != nil:
    section.add "prettyPrint", valid_579086
  var valid_579087 = query.getOrDefault("oauth_token")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "oauth_token", valid_579087
  var valid_579088 = query.getOrDefault("alt")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = newJString("json"))
  if valid_579088 != nil:
    section.add "alt", valid_579088
  var valid_579089 = query.getOrDefault("userIp")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "userIp", valid_579089
  var valid_579090 = query.getOrDefault("quotaUser")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "quotaUser", valid_579090
  var valid_579091 = query.getOrDefault("filter")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "filter", valid_579091
  var valid_579092 = query.getOrDefault("pageToken")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "pageToken", valid_579092
  var valid_579093 = query.getOrDefault("fields")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "fields", valid_579093
  var valid_579094 = query.getOrDefault("maxResults")
  valid_579094 = validateParameter(valid_579094, JInt, required = false,
                                 default = newJInt(500))
  if valid_579094 != nil:
    section.add "maxResults", valid_579094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579095: Call_ReplicapoolZoneOperationsList_579080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of operation resources contained within the specified zone.
  ## 
  let valid = call_579095.validator(path, query, header, formData, body)
  let scheme = call_579095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579095.url(scheme.get, call_579095.host, call_579095.base,
                         call_579095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579095, url, valid)

proc call*(call_579096: Call_ReplicapoolZoneOperationsList_579080; project: string;
          zone: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 500): Recallable =
  ## replicapoolZoneOperationsList
  ## Retrieves the list of operation resources contained within the specified zone.
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
  ##   filter: string
  ##         : Optional. Filter expression for filtering listed resources.
  ##   pageToken: string
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   project: string (required)
  ##          : Name of the project scoping this request.
  ##   zone: string (required)
  ##       : Name of the zone scoping this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  var path_579097 = newJObject()
  var query_579098 = newJObject()
  add(query_579098, "key", newJString(key))
  add(query_579098, "prettyPrint", newJBool(prettyPrint))
  add(query_579098, "oauth_token", newJString(oauthToken))
  add(query_579098, "alt", newJString(alt))
  add(query_579098, "userIp", newJString(userIp))
  add(query_579098, "quotaUser", newJString(quotaUser))
  add(query_579098, "filter", newJString(filter))
  add(query_579098, "pageToken", newJString(pageToken))
  add(path_579097, "project", newJString(project))
  add(path_579097, "zone", newJString(zone))
  add(query_579098, "fields", newJString(fields))
  add(query_579098, "maxResults", newJInt(maxResults))
  result = call_579096.call(path_579097, query_579098, nil, nil, nil)

var replicapoolZoneOperationsList* = Call_ReplicapoolZoneOperationsList_579080(
    name: "replicapoolZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/operations",
    validator: validate_ReplicapoolZoneOperationsList_579081,
    base: "/replicapool/v1beta2/projects", url: url_ReplicapoolZoneOperationsList_579082,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolZoneOperationsGet_579099 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolZoneOperationsGet_579101(protocol: Scheme; host: string;
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

proc validate_ReplicapoolZoneOperationsGet_579100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operation: JString (required)
  ##            : Name of the operation resource to return.
  ##   project: JString (required)
  ##          : Name of the project scoping this request.
  ##   zone: JString (required)
  ##       : Name of the zone scoping this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `operation` field"
  var valid_579102 = path.getOrDefault("operation")
  valid_579102 = validateParameter(valid_579102, JString, required = true,
                                 default = nil)
  if valid_579102 != nil:
    section.add "operation", valid_579102
  var valid_579103 = path.getOrDefault("project")
  valid_579103 = validateParameter(valid_579103, JString, required = true,
                                 default = nil)
  if valid_579103 != nil:
    section.add "project", valid_579103
  var valid_579104 = path.getOrDefault("zone")
  valid_579104 = validateParameter(valid_579104, JString, required = true,
                                 default = nil)
  if valid_579104 != nil:
    section.add "zone", valid_579104
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
  var valid_579105 = query.getOrDefault("key")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "key", valid_579105
  var valid_579106 = query.getOrDefault("prettyPrint")
  valid_579106 = validateParameter(valid_579106, JBool, required = false,
                                 default = newJBool(true))
  if valid_579106 != nil:
    section.add "prettyPrint", valid_579106
  var valid_579107 = query.getOrDefault("oauth_token")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "oauth_token", valid_579107
  var valid_579108 = query.getOrDefault("alt")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = newJString("json"))
  if valid_579108 != nil:
    section.add "alt", valid_579108
  var valid_579109 = query.getOrDefault("userIp")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "userIp", valid_579109
  var valid_579110 = query.getOrDefault("quotaUser")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "quotaUser", valid_579110
  var valid_579111 = query.getOrDefault("fields")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "fields", valid_579111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579112: Call_ReplicapoolZoneOperationsGet_579099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  let valid = call_579112.validator(path, query, header, formData, body)
  let scheme = call_579112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579112.url(scheme.get, call_579112.host, call_579112.base,
                         call_579112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579112, url, valid)

proc call*(call_579113: Call_ReplicapoolZoneOperationsGet_579099;
          operation: string; project: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## replicapoolZoneOperationsGet
  ## Retrieves the specified zone-specific operation resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   operation: string (required)
  ##            : Name of the operation resource to return.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Name of the project scoping this request.
  ##   zone: string (required)
  ##       : Name of the zone scoping this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579114 = newJObject()
  var query_579115 = newJObject()
  add(query_579115, "key", newJString(key))
  add(query_579115, "prettyPrint", newJBool(prettyPrint))
  add(query_579115, "oauth_token", newJString(oauthToken))
  add(path_579114, "operation", newJString(operation))
  add(query_579115, "alt", newJString(alt))
  add(query_579115, "userIp", newJString(userIp))
  add(query_579115, "quotaUser", newJString(quotaUser))
  add(path_579114, "project", newJString(project))
  add(path_579114, "zone", newJString(zone))
  add(query_579115, "fields", newJString(fields))
  result = call_579113.call(path_579114, query_579115, nil, nil, nil)

var replicapoolZoneOperationsGet* = Call_ReplicapoolZoneOperationsGet_579099(
    name: "replicapoolZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/operations/{operation}",
    validator: validate_ReplicapoolZoneOperationsGet_579100,
    base: "/replicapool/v1beta2/projects", url: url_ReplicapoolZoneOperationsGet_579101,
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
