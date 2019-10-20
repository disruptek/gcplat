
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Compute Engine Instance Group Updater
## version: v1beta1
## termsOfService: (not provided)
## license: (not provided)
## 
## [Deprecated. Please use compute.instanceGroupManagers.update method. replicapoolupdater API will be disabled after December 30th, 2016] Updates groups of Compute Engine instances.
## 
## https://cloud.google.com/compute/docs/instance-groups/manager/#applying_rolling_updates_using_the_updater_service
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
  gcpServiceName = "replicapoolupdater"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReplicapoolupdaterZoneOperationsList_578625 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolupdaterZoneOperationsList_578627(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolupdaterZoneOperationsList_578626(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of Operation resources contained within the specified zone.
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

proc call*(call_578801: Call_ReplicapoolupdaterZoneOperationsList_578625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of Operation resources contained within the specified zone.
  ## 
  let valid = call_578801.validator(path, query, header, formData, body)
  let scheme = call_578801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578801.url(scheme.get, call_578801.host, call_578801.base,
                         call_578801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578801, url, valid)

proc call*(call_578872: Call_ReplicapoolupdaterZoneOperationsList_578625;
          project: string; zone: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 500): Recallable =
  ## replicapoolupdaterZoneOperationsList
  ## Retrieves the list of Operation resources contained within the specified zone.
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

var replicapoolupdaterZoneOperationsList* = Call_ReplicapoolupdaterZoneOperationsList_578625(
    name: "replicapoolupdaterZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/operations",
    validator: validate_ReplicapoolupdaterZoneOperationsList_578626,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterZoneOperationsList_578627, schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterZoneOperationsGet_578914 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolupdaterZoneOperationsGet_578916(protocol: Scheme; host: string;
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

proc validate_ReplicapoolupdaterZoneOperationsGet_578915(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_578917 = path.getOrDefault("operation")
  valid_578917 = validateParameter(valid_578917, JString, required = true,
                                 default = nil)
  if valid_578917 != nil:
    section.add "operation", valid_578917
  var valid_578918 = path.getOrDefault("project")
  valid_578918 = validateParameter(valid_578918, JString, required = true,
                                 default = nil)
  if valid_578918 != nil:
    section.add "project", valid_578918
  var valid_578919 = path.getOrDefault("zone")
  valid_578919 = validateParameter(valid_578919, JString, required = true,
                                 default = nil)
  if valid_578919 != nil:
    section.add "zone", valid_578919
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
  var valid_578920 = query.getOrDefault("key")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "key", valid_578920
  var valid_578921 = query.getOrDefault("prettyPrint")
  valid_578921 = validateParameter(valid_578921, JBool, required = false,
                                 default = newJBool(true))
  if valid_578921 != nil:
    section.add "prettyPrint", valid_578921
  var valid_578922 = query.getOrDefault("oauth_token")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "oauth_token", valid_578922
  var valid_578923 = query.getOrDefault("alt")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = newJString("json"))
  if valid_578923 != nil:
    section.add "alt", valid_578923
  var valid_578924 = query.getOrDefault("userIp")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "userIp", valid_578924
  var valid_578925 = query.getOrDefault("quotaUser")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "quotaUser", valid_578925
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
  if body != nil:
    result.add "body", body

proc call*(call_578927: Call_ReplicapoolupdaterZoneOperationsGet_578914;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  let valid = call_578927.validator(path, query, header, formData, body)
  let scheme = call_578927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578927.url(scheme.get, call_578927.host, call_578927.base,
                         call_578927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578927, url, valid)

proc call*(call_578928: Call_ReplicapoolupdaterZoneOperationsGet_578914;
          operation: string; project: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## replicapoolupdaterZoneOperationsGet
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
  var path_578929 = newJObject()
  var query_578930 = newJObject()
  add(query_578930, "key", newJString(key))
  add(query_578930, "prettyPrint", newJBool(prettyPrint))
  add(query_578930, "oauth_token", newJString(oauthToken))
  add(path_578929, "operation", newJString(operation))
  add(query_578930, "alt", newJString(alt))
  add(query_578930, "userIp", newJString(userIp))
  add(query_578930, "quotaUser", newJString(quotaUser))
  add(path_578929, "project", newJString(project))
  add(path_578929, "zone", newJString(zone))
  add(query_578930, "fields", newJString(fields))
  result = call_578928.call(path_578929, query_578930, nil, nil, nil)

var replicapoolupdaterZoneOperationsGet* = Call_ReplicapoolupdaterZoneOperationsGet_578914(
    name: "replicapoolupdaterZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/operations/{operation}",
    validator: validate_ReplicapoolupdaterZoneOperationsGet_578915,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterZoneOperationsGet_578916, schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesInsert_578950 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolupdaterRollingUpdatesInsert_578952(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/rollingUpdates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolupdaterRollingUpdatesInsert_578951(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts and starts a new update.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578953 = path.getOrDefault("project")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "project", valid_578953
  var valid_578954 = path.getOrDefault("zone")
  valid_578954 = validateParameter(valid_578954, JString, required = true,
                                 default = nil)
  if valid_578954 != nil:
    section.add "zone", valid_578954
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
  var valid_578955 = query.getOrDefault("key")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "key", valid_578955
  var valid_578956 = query.getOrDefault("prettyPrint")
  valid_578956 = validateParameter(valid_578956, JBool, required = false,
                                 default = newJBool(true))
  if valid_578956 != nil:
    section.add "prettyPrint", valid_578956
  var valid_578957 = query.getOrDefault("oauth_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "oauth_token", valid_578957
  var valid_578958 = query.getOrDefault("alt")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("json"))
  if valid_578958 != nil:
    section.add "alt", valid_578958
  var valid_578959 = query.getOrDefault("userIp")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "userIp", valid_578959
  var valid_578960 = query.getOrDefault("quotaUser")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "quotaUser", valid_578960
  var valid_578961 = query.getOrDefault("fields")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "fields", valid_578961
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

proc call*(call_578963: Call_ReplicapoolupdaterRollingUpdatesInsert_578950;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts and starts a new update.
  ## 
  let valid = call_578963.validator(path, query, header, formData, body)
  let scheme = call_578963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578963.url(scheme.get, call_578963.host, call_578963.base,
                         call_578963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578963, url, valid)

proc call*(call_578964: Call_ReplicapoolupdaterRollingUpdatesInsert_578950;
          project: string; zone: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## replicapoolupdaterRollingUpdatesInsert
  ## Inserts and starts a new update.
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
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578965 = newJObject()
  var query_578966 = newJObject()
  var body_578967 = newJObject()
  add(query_578966, "key", newJString(key))
  add(query_578966, "prettyPrint", newJBool(prettyPrint))
  add(query_578966, "oauth_token", newJString(oauthToken))
  add(query_578966, "alt", newJString(alt))
  add(query_578966, "userIp", newJString(userIp))
  add(query_578966, "quotaUser", newJString(quotaUser))
  add(path_578965, "project", newJString(project))
  add(path_578965, "zone", newJString(zone))
  if body != nil:
    body_578967 = body
  add(query_578966, "fields", newJString(fields))
  result = call_578964.call(path_578965, query_578966, nil, nil, body_578967)

var replicapoolupdaterRollingUpdatesInsert* = Call_ReplicapoolupdaterRollingUpdatesInsert_578950(
    name: "replicapoolupdaterRollingUpdatesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/rollingUpdates",
    validator: validate_ReplicapoolupdaterRollingUpdatesInsert_578951,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesInsert_578952,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesList_578931 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolupdaterRollingUpdatesList_578933(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/rollingUpdates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolupdaterRollingUpdatesList_578932(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists recent updates for a given managed instance group, in reverse chronological order and paginated format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578934 = path.getOrDefault("project")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "project", valid_578934
  var valid_578935 = path.getOrDefault("zone")
  valid_578935 = validateParameter(valid_578935, JString, required = true,
                                 default = nil)
  if valid_578935 != nil:
    section.add "zone", valid_578935
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
  var valid_578936 = query.getOrDefault("key")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "key", valid_578936
  var valid_578937 = query.getOrDefault("prettyPrint")
  valid_578937 = validateParameter(valid_578937, JBool, required = false,
                                 default = newJBool(true))
  if valid_578937 != nil:
    section.add "prettyPrint", valid_578937
  var valid_578938 = query.getOrDefault("oauth_token")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "oauth_token", valid_578938
  var valid_578939 = query.getOrDefault("alt")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = newJString("json"))
  if valid_578939 != nil:
    section.add "alt", valid_578939
  var valid_578940 = query.getOrDefault("userIp")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "userIp", valid_578940
  var valid_578941 = query.getOrDefault("quotaUser")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "quotaUser", valid_578941
  var valid_578942 = query.getOrDefault("filter")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "filter", valid_578942
  var valid_578943 = query.getOrDefault("pageToken")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "pageToken", valid_578943
  var valid_578944 = query.getOrDefault("fields")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "fields", valid_578944
  var valid_578945 = query.getOrDefault("maxResults")
  valid_578945 = validateParameter(valid_578945, JInt, required = false,
                                 default = newJInt(500))
  if valid_578945 != nil:
    section.add "maxResults", valid_578945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578946: Call_ReplicapoolupdaterRollingUpdatesList_578931;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists recent updates for a given managed instance group, in reverse chronological order and paginated format.
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_ReplicapoolupdaterRollingUpdatesList_578931;
          project: string; zone: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 500): Recallable =
  ## replicapoolupdaterRollingUpdatesList
  ## Lists recent updates for a given managed instance group, in reverse chronological order and paginated format.
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
  ##       : The name of the zone in which the update's target resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  var path_578948 = newJObject()
  var query_578949 = newJObject()
  add(query_578949, "key", newJString(key))
  add(query_578949, "prettyPrint", newJBool(prettyPrint))
  add(query_578949, "oauth_token", newJString(oauthToken))
  add(query_578949, "alt", newJString(alt))
  add(query_578949, "userIp", newJString(userIp))
  add(query_578949, "quotaUser", newJString(quotaUser))
  add(query_578949, "filter", newJString(filter))
  add(query_578949, "pageToken", newJString(pageToken))
  add(path_578948, "project", newJString(project))
  add(path_578948, "zone", newJString(zone))
  add(query_578949, "fields", newJString(fields))
  add(query_578949, "maxResults", newJInt(maxResults))
  result = call_578947.call(path_578948, query_578949, nil, nil, nil)

var replicapoolupdaterRollingUpdatesList* = Call_ReplicapoolupdaterRollingUpdatesList_578931(
    name: "replicapoolupdaterRollingUpdatesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/rollingUpdates",
    validator: validate_ReplicapoolupdaterRollingUpdatesList_578932,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesList_578933, schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesGet_578968 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolupdaterRollingUpdatesGet_578970(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "rollingUpdate" in path, "`rollingUpdate` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/rollingUpdates/"),
               (kind: VariableSegment, value: "rollingUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolupdaterRollingUpdatesGet_578969(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about an update.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rollingUpdate` field"
  var valid_578971 = path.getOrDefault("rollingUpdate")
  valid_578971 = validateParameter(valid_578971, JString, required = true,
                                 default = nil)
  if valid_578971 != nil:
    section.add "rollingUpdate", valid_578971
  var valid_578972 = path.getOrDefault("project")
  valid_578972 = validateParameter(valid_578972, JString, required = true,
                                 default = nil)
  if valid_578972 != nil:
    section.add "project", valid_578972
  var valid_578973 = path.getOrDefault("zone")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "zone", valid_578973
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
  var valid_578974 = query.getOrDefault("key")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "key", valid_578974
  var valid_578975 = query.getOrDefault("prettyPrint")
  valid_578975 = validateParameter(valid_578975, JBool, required = false,
                                 default = newJBool(true))
  if valid_578975 != nil:
    section.add "prettyPrint", valid_578975
  var valid_578976 = query.getOrDefault("oauth_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "oauth_token", valid_578976
  var valid_578977 = query.getOrDefault("alt")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("json"))
  if valid_578977 != nil:
    section.add "alt", valid_578977
  var valid_578978 = query.getOrDefault("userIp")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "userIp", valid_578978
  var valid_578979 = query.getOrDefault("quotaUser")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "quotaUser", valid_578979
  var valid_578980 = query.getOrDefault("fields")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "fields", valid_578980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578981: Call_ReplicapoolupdaterRollingUpdatesGet_578968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about an update.
  ## 
  let valid = call_578981.validator(path, query, header, formData, body)
  let scheme = call_578981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578981.url(scheme.get, call_578981.host, call_578981.base,
                         call_578981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578981, url, valid)

proc call*(call_578982: Call_ReplicapoolupdaterRollingUpdatesGet_578968;
          rollingUpdate: string; project: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## replicapoolupdaterRollingUpdatesGet
  ## Returns information about an update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
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
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578983 = newJObject()
  var query_578984 = newJObject()
  add(query_578984, "key", newJString(key))
  add(path_578983, "rollingUpdate", newJString(rollingUpdate))
  add(query_578984, "prettyPrint", newJBool(prettyPrint))
  add(query_578984, "oauth_token", newJString(oauthToken))
  add(query_578984, "alt", newJString(alt))
  add(query_578984, "userIp", newJString(userIp))
  add(query_578984, "quotaUser", newJString(quotaUser))
  add(path_578983, "project", newJString(project))
  add(path_578983, "zone", newJString(zone))
  add(query_578984, "fields", newJString(fields))
  result = call_578982.call(path_578983, query_578984, nil, nil, nil)

var replicapoolupdaterRollingUpdatesGet* = Call_ReplicapoolupdaterRollingUpdatesGet_578968(
    name: "replicapoolupdaterRollingUpdatesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}",
    validator: validate_ReplicapoolupdaterRollingUpdatesGet_578969,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesGet_578970, schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesCancel_578985 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolupdaterRollingUpdatesCancel_578987(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "rollingUpdate" in path, "`rollingUpdate` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/rollingUpdates/"),
               (kind: VariableSegment, value: "rollingUpdate"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolupdaterRollingUpdatesCancel_578986(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels an update. The update must be PAUSED before it can be cancelled. This has no effect if the update is already CANCELLED.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rollingUpdate` field"
  var valid_578988 = path.getOrDefault("rollingUpdate")
  valid_578988 = validateParameter(valid_578988, JString, required = true,
                                 default = nil)
  if valid_578988 != nil:
    section.add "rollingUpdate", valid_578988
  var valid_578989 = path.getOrDefault("project")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "project", valid_578989
  var valid_578990 = path.getOrDefault("zone")
  valid_578990 = validateParameter(valid_578990, JString, required = true,
                                 default = nil)
  if valid_578990 != nil:
    section.add "zone", valid_578990
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
  var valid_578991 = query.getOrDefault("key")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "key", valid_578991
  var valid_578992 = query.getOrDefault("prettyPrint")
  valid_578992 = validateParameter(valid_578992, JBool, required = false,
                                 default = newJBool(true))
  if valid_578992 != nil:
    section.add "prettyPrint", valid_578992
  var valid_578993 = query.getOrDefault("oauth_token")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "oauth_token", valid_578993
  var valid_578994 = query.getOrDefault("alt")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = newJString("json"))
  if valid_578994 != nil:
    section.add "alt", valid_578994
  var valid_578995 = query.getOrDefault("userIp")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "userIp", valid_578995
  var valid_578996 = query.getOrDefault("quotaUser")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "quotaUser", valid_578996
  var valid_578997 = query.getOrDefault("fields")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "fields", valid_578997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578998: Call_ReplicapoolupdaterRollingUpdatesCancel_578985;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels an update. The update must be PAUSED before it can be cancelled. This has no effect if the update is already CANCELLED.
  ## 
  let valid = call_578998.validator(path, query, header, formData, body)
  let scheme = call_578998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578998.url(scheme.get, call_578998.host, call_578998.base,
                         call_578998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578998, url, valid)

proc call*(call_578999: Call_ReplicapoolupdaterRollingUpdatesCancel_578985;
          rollingUpdate: string; project: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## replicapoolupdaterRollingUpdatesCancel
  ## Cancels an update. The update must be PAUSED before it can be cancelled. This has no effect if the update is already CANCELLED.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
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
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579000 = newJObject()
  var query_579001 = newJObject()
  add(query_579001, "key", newJString(key))
  add(path_579000, "rollingUpdate", newJString(rollingUpdate))
  add(query_579001, "prettyPrint", newJBool(prettyPrint))
  add(query_579001, "oauth_token", newJString(oauthToken))
  add(query_579001, "alt", newJString(alt))
  add(query_579001, "userIp", newJString(userIp))
  add(query_579001, "quotaUser", newJString(quotaUser))
  add(path_579000, "project", newJString(project))
  add(path_579000, "zone", newJString(zone))
  add(query_579001, "fields", newJString(fields))
  result = call_578999.call(path_579000, query_579001, nil, nil, nil)

var replicapoolupdaterRollingUpdatesCancel* = Call_ReplicapoolupdaterRollingUpdatesCancel_578985(
    name: "replicapoolupdaterRollingUpdatesCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}/cancel",
    validator: validate_ReplicapoolupdaterRollingUpdatesCancel_578986,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesCancel_578987,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_579002 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_579004(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "rollingUpdate" in path, "`rollingUpdate` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/rollingUpdates/"),
               (kind: VariableSegment, value: "rollingUpdate"),
               (kind: ConstantSegment, value: "/instanceUpdates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_579003(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the current status for each instance within a given update.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rollingUpdate` field"
  var valid_579005 = path.getOrDefault("rollingUpdate")
  valid_579005 = validateParameter(valid_579005, JString, required = true,
                                 default = nil)
  if valid_579005 != nil:
    section.add "rollingUpdate", valid_579005
  var valid_579006 = path.getOrDefault("project")
  valid_579006 = validateParameter(valid_579006, JString, required = true,
                                 default = nil)
  if valid_579006 != nil:
    section.add "project", valid_579006
  var valid_579007 = path.getOrDefault("zone")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "zone", valid_579007
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
  var valid_579008 = query.getOrDefault("key")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "key", valid_579008
  var valid_579009 = query.getOrDefault("prettyPrint")
  valid_579009 = validateParameter(valid_579009, JBool, required = false,
                                 default = newJBool(true))
  if valid_579009 != nil:
    section.add "prettyPrint", valid_579009
  var valid_579010 = query.getOrDefault("oauth_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "oauth_token", valid_579010
  var valid_579011 = query.getOrDefault("alt")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("json"))
  if valid_579011 != nil:
    section.add "alt", valid_579011
  var valid_579012 = query.getOrDefault("userIp")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "userIp", valid_579012
  var valid_579013 = query.getOrDefault("quotaUser")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "quotaUser", valid_579013
  var valid_579014 = query.getOrDefault("filter")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "filter", valid_579014
  var valid_579015 = query.getOrDefault("pageToken")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "pageToken", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
  var valid_579017 = query.getOrDefault("maxResults")
  valid_579017 = validateParameter(valid_579017, JInt, required = false,
                                 default = newJInt(500))
  if valid_579017 != nil:
    section.add "maxResults", valid_579017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579018: Call_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_579002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the current status for each instance within a given update.
  ## 
  let valid = call_579018.validator(path, query, header, formData, body)
  let scheme = call_579018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579018.url(scheme.get, call_579018.host, call_579018.base,
                         call_579018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579018, url, valid)

proc call*(call_579019: Call_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_579002;
          rollingUpdate: string; project: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 500): Recallable =
  ## replicapoolupdaterRollingUpdatesListInstanceUpdates
  ## Lists the current status for each instance within a given update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
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
  ##       : The name of the zone in which the update's target resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  var path_579020 = newJObject()
  var query_579021 = newJObject()
  add(query_579021, "key", newJString(key))
  add(path_579020, "rollingUpdate", newJString(rollingUpdate))
  add(query_579021, "prettyPrint", newJBool(prettyPrint))
  add(query_579021, "oauth_token", newJString(oauthToken))
  add(query_579021, "alt", newJString(alt))
  add(query_579021, "userIp", newJString(userIp))
  add(query_579021, "quotaUser", newJString(quotaUser))
  add(query_579021, "filter", newJString(filter))
  add(query_579021, "pageToken", newJString(pageToken))
  add(path_579020, "project", newJString(project))
  add(path_579020, "zone", newJString(zone))
  add(query_579021, "fields", newJString(fields))
  add(query_579021, "maxResults", newJInt(maxResults))
  result = call_579019.call(path_579020, query_579021, nil, nil, nil)

var replicapoolupdaterRollingUpdatesListInstanceUpdates* = Call_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_579002(
    name: "replicapoolupdaterRollingUpdatesListInstanceUpdates",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}/instanceUpdates",
    validator: validate_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_579003,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_579004,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesPause_579022 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolupdaterRollingUpdatesPause_579024(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "rollingUpdate" in path, "`rollingUpdate` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/rollingUpdates/"),
               (kind: VariableSegment, value: "rollingUpdate"),
               (kind: ConstantSegment, value: "/pause")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolupdaterRollingUpdatesPause_579023(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pauses the update in state from ROLLING_FORWARD or ROLLING_BACK. Has no effect if invoked when the state of the update is PAUSED.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rollingUpdate` field"
  var valid_579025 = path.getOrDefault("rollingUpdate")
  valid_579025 = validateParameter(valid_579025, JString, required = true,
                                 default = nil)
  if valid_579025 != nil:
    section.add "rollingUpdate", valid_579025
  var valid_579026 = path.getOrDefault("project")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "project", valid_579026
  var valid_579027 = path.getOrDefault("zone")
  valid_579027 = validateParameter(valid_579027, JString, required = true,
                                 default = nil)
  if valid_579027 != nil:
    section.add "zone", valid_579027
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
  var valid_579028 = query.getOrDefault("key")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "key", valid_579028
  var valid_579029 = query.getOrDefault("prettyPrint")
  valid_579029 = validateParameter(valid_579029, JBool, required = false,
                                 default = newJBool(true))
  if valid_579029 != nil:
    section.add "prettyPrint", valid_579029
  var valid_579030 = query.getOrDefault("oauth_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "oauth_token", valid_579030
  var valid_579031 = query.getOrDefault("alt")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("json"))
  if valid_579031 != nil:
    section.add "alt", valid_579031
  var valid_579032 = query.getOrDefault("userIp")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "userIp", valid_579032
  var valid_579033 = query.getOrDefault("quotaUser")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "quotaUser", valid_579033
  var valid_579034 = query.getOrDefault("fields")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "fields", valid_579034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579035: Call_ReplicapoolupdaterRollingUpdatesPause_579022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pauses the update in state from ROLLING_FORWARD or ROLLING_BACK. Has no effect if invoked when the state of the update is PAUSED.
  ## 
  let valid = call_579035.validator(path, query, header, formData, body)
  let scheme = call_579035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579035.url(scheme.get, call_579035.host, call_579035.base,
                         call_579035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579035, url, valid)

proc call*(call_579036: Call_ReplicapoolupdaterRollingUpdatesPause_579022;
          rollingUpdate: string; project: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## replicapoolupdaterRollingUpdatesPause
  ## Pauses the update in state from ROLLING_FORWARD or ROLLING_BACK. Has no effect if invoked when the state of the update is PAUSED.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
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
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579037 = newJObject()
  var query_579038 = newJObject()
  add(query_579038, "key", newJString(key))
  add(path_579037, "rollingUpdate", newJString(rollingUpdate))
  add(query_579038, "prettyPrint", newJBool(prettyPrint))
  add(query_579038, "oauth_token", newJString(oauthToken))
  add(query_579038, "alt", newJString(alt))
  add(query_579038, "userIp", newJString(userIp))
  add(query_579038, "quotaUser", newJString(quotaUser))
  add(path_579037, "project", newJString(project))
  add(path_579037, "zone", newJString(zone))
  add(query_579038, "fields", newJString(fields))
  result = call_579036.call(path_579037, query_579038, nil, nil, nil)

var replicapoolupdaterRollingUpdatesPause* = Call_ReplicapoolupdaterRollingUpdatesPause_579022(
    name: "replicapoolupdaterRollingUpdatesPause", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}/pause",
    validator: validate_ReplicapoolupdaterRollingUpdatesPause_579023,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesPause_579024, schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesResume_579039 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolupdaterRollingUpdatesResume_579041(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "rollingUpdate" in path, "`rollingUpdate` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/rollingUpdates/"),
               (kind: VariableSegment, value: "rollingUpdate"),
               (kind: ConstantSegment, value: "/resume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolupdaterRollingUpdatesResume_579040(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Continues an update in PAUSED state. Has no effect if invoked when the state of the update is ROLLED_OUT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rollingUpdate` field"
  var valid_579042 = path.getOrDefault("rollingUpdate")
  valid_579042 = validateParameter(valid_579042, JString, required = true,
                                 default = nil)
  if valid_579042 != nil:
    section.add "rollingUpdate", valid_579042
  var valid_579043 = path.getOrDefault("project")
  valid_579043 = validateParameter(valid_579043, JString, required = true,
                                 default = nil)
  if valid_579043 != nil:
    section.add "project", valid_579043
  var valid_579044 = path.getOrDefault("zone")
  valid_579044 = validateParameter(valid_579044, JString, required = true,
                                 default = nil)
  if valid_579044 != nil:
    section.add "zone", valid_579044
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
  var valid_579045 = query.getOrDefault("key")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "key", valid_579045
  var valid_579046 = query.getOrDefault("prettyPrint")
  valid_579046 = validateParameter(valid_579046, JBool, required = false,
                                 default = newJBool(true))
  if valid_579046 != nil:
    section.add "prettyPrint", valid_579046
  var valid_579047 = query.getOrDefault("oauth_token")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "oauth_token", valid_579047
  var valid_579048 = query.getOrDefault("alt")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = newJString("json"))
  if valid_579048 != nil:
    section.add "alt", valid_579048
  var valid_579049 = query.getOrDefault("userIp")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "userIp", valid_579049
  var valid_579050 = query.getOrDefault("quotaUser")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "quotaUser", valid_579050
  var valid_579051 = query.getOrDefault("fields")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "fields", valid_579051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579052: Call_ReplicapoolupdaterRollingUpdatesResume_579039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Continues an update in PAUSED state. Has no effect if invoked when the state of the update is ROLLED_OUT.
  ## 
  let valid = call_579052.validator(path, query, header, formData, body)
  let scheme = call_579052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579052.url(scheme.get, call_579052.host, call_579052.base,
                         call_579052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579052, url, valid)

proc call*(call_579053: Call_ReplicapoolupdaterRollingUpdatesResume_579039;
          rollingUpdate: string; project: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## replicapoolupdaterRollingUpdatesResume
  ## Continues an update in PAUSED state. Has no effect if invoked when the state of the update is ROLLED_OUT.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
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
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579054 = newJObject()
  var query_579055 = newJObject()
  add(query_579055, "key", newJString(key))
  add(path_579054, "rollingUpdate", newJString(rollingUpdate))
  add(query_579055, "prettyPrint", newJBool(prettyPrint))
  add(query_579055, "oauth_token", newJString(oauthToken))
  add(query_579055, "alt", newJString(alt))
  add(query_579055, "userIp", newJString(userIp))
  add(query_579055, "quotaUser", newJString(quotaUser))
  add(path_579054, "project", newJString(project))
  add(path_579054, "zone", newJString(zone))
  add(query_579055, "fields", newJString(fields))
  result = call_579053.call(path_579054, query_579055, nil, nil, nil)

var replicapoolupdaterRollingUpdatesResume* = Call_ReplicapoolupdaterRollingUpdatesResume_579039(
    name: "replicapoolupdaterRollingUpdatesResume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}/resume",
    validator: validate_ReplicapoolupdaterRollingUpdatesResume_579040,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesResume_579041,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesRollback_579056 = ref object of OpenApiRestCall_578355
proc url_ReplicapoolupdaterRollingUpdatesRollback_579058(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "rollingUpdate" in path, "`rollingUpdate` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/rollingUpdates/"),
               (kind: VariableSegment, value: "rollingUpdate"),
               (kind: ConstantSegment, value: "/rollback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolupdaterRollingUpdatesRollback_579057(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rolls back the update in state from ROLLING_FORWARD or PAUSED. Has no effect if invoked when the state of the update is ROLLED_BACK.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `rollingUpdate` field"
  var valid_579059 = path.getOrDefault("rollingUpdate")
  valid_579059 = validateParameter(valid_579059, JString, required = true,
                                 default = nil)
  if valid_579059 != nil:
    section.add "rollingUpdate", valid_579059
  var valid_579060 = path.getOrDefault("project")
  valid_579060 = validateParameter(valid_579060, JString, required = true,
                                 default = nil)
  if valid_579060 != nil:
    section.add "project", valid_579060
  var valid_579061 = path.getOrDefault("zone")
  valid_579061 = validateParameter(valid_579061, JString, required = true,
                                 default = nil)
  if valid_579061 != nil:
    section.add "zone", valid_579061
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
  var valid_579062 = query.getOrDefault("key")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "key", valid_579062
  var valid_579063 = query.getOrDefault("prettyPrint")
  valid_579063 = validateParameter(valid_579063, JBool, required = false,
                                 default = newJBool(true))
  if valid_579063 != nil:
    section.add "prettyPrint", valid_579063
  var valid_579064 = query.getOrDefault("oauth_token")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "oauth_token", valid_579064
  var valid_579065 = query.getOrDefault("alt")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = newJString("json"))
  if valid_579065 != nil:
    section.add "alt", valid_579065
  var valid_579066 = query.getOrDefault("userIp")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "userIp", valid_579066
  var valid_579067 = query.getOrDefault("quotaUser")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "quotaUser", valid_579067
  var valid_579068 = query.getOrDefault("fields")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "fields", valid_579068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579069: Call_ReplicapoolupdaterRollingUpdatesRollback_579056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back the update in state from ROLLING_FORWARD or PAUSED. Has no effect if invoked when the state of the update is ROLLED_BACK.
  ## 
  let valid = call_579069.validator(path, query, header, formData, body)
  let scheme = call_579069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579069.url(scheme.get, call_579069.host, call_579069.base,
                         call_579069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579069, url, valid)

proc call*(call_579070: Call_ReplicapoolupdaterRollingUpdatesRollback_579056;
          rollingUpdate: string; project: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## replicapoolupdaterRollingUpdatesRollback
  ## Rolls back the update in state from ROLLING_FORWARD or PAUSED. Has no effect if invoked when the state of the update is ROLLED_BACK.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
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
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579071 = newJObject()
  var query_579072 = newJObject()
  add(query_579072, "key", newJString(key))
  add(path_579071, "rollingUpdate", newJString(rollingUpdate))
  add(query_579072, "prettyPrint", newJBool(prettyPrint))
  add(query_579072, "oauth_token", newJString(oauthToken))
  add(query_579072, "alt", newJString(alt))
  add(query_579072, "userIp", newJString(userIp))
  add(query_579072, "quotaUser", newJString(quotaUser))
  add(path_579071, "project", newJString(project))
  add(path_579071, "zone", newJString(zone))
  add(query_579072, "fields", newJString(fields))
  result = call_579070.call(path_579071, query_579072, nil, nil, nil)

var replicapoolupdaterRollingUpdatesRollback* = Call_ReplicapoolupdaterRollingUpdatesRollback_579056(
    name: "replicapoolupdaterRollingUpdatesRollback", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}/rollback",
    validator: validate_ReplicapoolupdaterRollingUpdatesRollback_579057,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesRollback_579058,
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
