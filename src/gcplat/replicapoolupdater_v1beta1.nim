
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
  gcpServiceName = "replicapoolupdater"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReplicapoolupdaterZoneOperationsList_579692 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolupdaterZoneOperationsList_579694(protocol: Scheme;
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

proc validate_ReplicapoolupdaterZoneOperationsList_579693(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of Operation resources contained within the specified zone.
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

proc call*(call_579868: Call_ReplicapoolupdaterZoneOperationsList_579692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of Operation resources contained within the specified zone.
  ## 
  let valid = call_579868.validator(path, query, header, formData, body)
  let scheme = call_579868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579868.url(scheme.get, call_579868.host, call_579868.base,
                         call_579868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579868, url, valid)

proc call*(call_579939: Call_ReplicapoolupdaterZoneOperationsList_579692;
          zone: string; project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## replicapoolupdaterZoneOperationsList
  ## Retrieves the list of Operation resources contained within the specified zone.
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

var replicapoolupdaterZoneOperationsList* = Call_ReplicapoolupdaterZoneOperationsList_579692(
    name: "replicapoolupdaterZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/operations",
    validator: validate_ReplicapoolupdaterZoneOperationsList_579693,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterZoneOperationsList_579694, schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterZoneOperationsGet_579981 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolupdaterZoneOperationsGet_579983(protocol: Scheme; host: string;
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

proc validate_ReplicapoolupdaterZoneOperationsGet_579982(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579984 = path.getOrDefault("zone")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "zone", valid_579984
  var valid_579985 = path.getOrDefault("operation")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "operation", valid_579985
  var valid_579986 = path.getOrDefault("project")
  valid_579986 = validateParameter(valid_579986, JString, required = true,
                                 default = nil)
  if valid_579986 != nil:
    section.add "project", valid_579986
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
  var valid_579987 = query.getOrDefault("fields")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "fields", valid_579987
  var valid_579988 = query.getOrDefault("quotaUser")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "quotaUser", valid_579988
  var valid_579989 = query.getOrDefault("alt")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = newJString("json"))
  if valid_579989 != nil:
    section.add "alt", valid_579989
  var valid_579990 = query.getOrDefault("oauth_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "oauth_token", valid_579990
  var valid_579991 = query.getOrDefault("userIp")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "userIp", valid_579991
  var valid_579992 = query.getOrDefault("key")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "key", valid_579992
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
  if body != nil:
    result.add "body", body

proc call*(call_579994: Call_ReplicapoolupdaterZoneOperationsGet_579981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  let valid = call_579994.validator(path, query, header, formData, body)
  let scheme = call_579994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579994.url(scheme.get, call_579994.host, call_579994.base,
                         call_579994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579994, url, valid)

proc call*(call_579995: Call_ReplicapoolupdaterZoneOperationsGet_579981;
          zone: string; operation: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolupdaterZoneOperationsGet
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
  var path_579996 = newJObject()
  var query_579997 = newJObject()
  add(path_579996, "zone", newJString(zone))
  add(query_579997, "fields", newJString(fields))
  add(query_579997, "quotaUser", newJString(quotaUser))
  add(query_579997, "alt", newJString(alt))
  add(path_579996, "operation", newJString(operation))
  add(query_579997, "oauth_token", newJString(oauthToken))
  add(query_579997, "userIp", newJString(userIp))
  add(query_579997, "key", newJString(key))
  add(path_579996, "project", newJString(project))
  add(query_579997, "prettyPrint", newJBool(prettyPrint))
  result = call_579995.call(path_579996, query_579997, nil, nil, nil)

var replicapoolupdaterZoneOperationsGet* = Call_ReplicapoolupdaterZoneOperationsGet_579981(
    name: "replicapoolupdaterZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/operations/{operation}",
    validator: validate_ReplicapoolupdaterZoneOperationsGet_579982,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterZoneOperationsGet_579983, schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesInsert_580017 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolupdaterRollingUpdatesInsert_580019(protocol: Scheme;
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

proc validate_ReplicapoolupdaterRollingUpdatesInsert_580018(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts and starts a new update.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580020 = path.getOrDefault("zone")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "zone", valid_580020
  var valid_580021 = path.getOrDefault("project")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "project", valid_580021
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
  var valid_580022 = query.getOrDefault("fields")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "fields", valid_580022
  var valid_580023 = query.getOrDefault("quotaUser")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "quotaUser", valid_580023
  var valid_580024 = query.getOrDefault("alt")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("json"))
  if valid_580024 != nil:
    section.add "alt", valid_580024
  var valid_580025 = query.getOrDefault("oauth_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "oauth_token", valid_580025
  var valid_580026 = query.getOrDefault("userIp")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "userIp", valid_580026
  var valid_580027 = query.getOrDefault("key")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "key", valid_580027
  var valid_580028 = query.getOrDefault("prettyPrint")
  valid_580028 = validateParameter(valid_580028, JBool, required = false,
                                 default = newJBool(true))
  if valid_580028 != nil:
    section.add "prettyPrint", valid_580028
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

proc call*(call_580030: Call_ReplicapoolupdaterRollingUpdatesInsert_580017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts and starts a new update.
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_ReplicapoolupdaterRollingUpdatesInsert_580017;
          zone: string; project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolupdaterRollingUpdatesInsert
  ## Inserts and starts a new update.
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
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
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580032 = newJObject()
  var query_580033 = newJObject()
  var body_580034 = newJObject()
  add(path_580032, "zone", newJString(zone))
  add(query_580033, "fields", newJString(fields))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "userIp", newJString(userIp))
  add(query_580033, "key", newJString(key))
  add(path_580032, "project", newJString(project))
  if body != nil:
    body_580034 = body
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  result = call_580031.call(path_580032, query_580033, nil, nil, body_580034)

var replicapoolupdaterRollingUpdatesInsert* = Call_ReplicapoolupdaterRollingUpdatesInsert_580017(
    name: "replicapoolupdaterRollingUpdatesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/rollingUpdates",
    validator: validate_ReplicapoolupdaterRollingUpdatesInsert_580018,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesInsert_580019,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesList_579998 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolupdaterRollingUpdatesList_580000(protocol: Scheme;
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

proc validate_ReplicapoolupdaterRollingUpdatesList_579999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists recent updates for a given managed instance group, in reverse chronological order and paginated format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580001 = path.getOrDefault("zone")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "zone", valid_580001
  var valid_580002 = path.getOrDefault("project")
  valid_580002 = validateParameter(valid_580002, JString, required = true,
                                 default = nil)
  if valid_580002 != nil:
    section.add "project", valid_580002
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
  var valid_580003 = query.getOrDefault("fields")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "fields", valid_580003
  var valid_580004 = query.getOrDefault("pageToken")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "pageToken", valid_580004
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
  var valid_580009 = query.getOrDefault("maxResults")
  valid_580009 = validateParameter(valid_580009, JInt, required = false,
                                 default = newJInt(500))
  if valid_580009 != nil:
    section.add "maxResults", valid_580009
  var valid_580010 = query.getOrDefault("key")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "key", valid_580010
  var valid_580011 = query.getOrDefault("prettyPrint")
  valid_580011 = validateParameter(valid_580011, JBool, required = false,
                                 default = newJBool(true))
  if valid_580011 != nil:
    section.add "prettyPrint", valid_580011
  var valid_580012 = query.getOrDefault("filter")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "filter", valid_580012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580013: Call_ReplicapoolupdaterRollingUpdatesList_579998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists recent updates for a given managed instance group, in reverse chronological order and paginated format.
  ## 
  let valid = call_580013.validator(path, query, header, formData, body)
  let scheme = call_580013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580013.url(scheme.get, call_580013.host, call_580013.base,
                         call_580013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580013, url, valid)

proc call*(call_580014: Call_ReplicapoolupdaterRollingUpdatesList_579998;
          zone: string; project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## replicapoolupdaterRollingUpdatesList
  ## Lists recent updates for a given managed instance group, in reverse chronological order and paginated format.
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
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
  var path_580015 = newJObject()
  var query_580016 = newJObject()
  add(path_580015, "zone", newJString(zone))
  add(query_580016, "fields", newJString(fields))
  add(query_580016, "pageToken", newJString(pageToken))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(query_580016, "userIp", newJString(userIp))
  add(query_580016, "maxResults", newJInt(maxResults))
  add(query_580016, "key", newJString(key))
  add(path_580015, "project", newJString(project))
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  add(query_580016, "filter", newJString(filter))
  result = call_580014.call(path_580015, query_580016, nil, nil, nil)

var replicapoolupdaterRollingUpdatesList* = Call_ReplicapoolupdaterRollingUpdatesList_579998(
    name: "replicapoolupdaterRollingUpdatesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/rollingUpdates",
    validator: validate_ReplicapoolupdaterRollingUpdatesList_579999,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesList_580000, schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesGet_580035 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolupdaterRollingUpdatesGet_580037(protocol: Scheme; host: string;
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

proc validate_ReplicapoolupdaterRollingUpdatesGet_580036(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about an update.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580038 = path.getOrDefault("zone")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "zone", valid_580038
  var valid_580039 = path.getOrDefault("rollingUpdate")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "rollingUpdate", valid_580039
  var valid_580040 = path.getOrDefault("project")
  valid_580040 = validateParameter(valid_580040, JString, required = true,
                                 default = nil)
  if valid_580040 != nil:
    section.add "project", valid_580040
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
  var valid_580041 = query.getOrDefault("fields")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "fields", valid_580041
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
  var valid_580046 = query.getOrDefault("key")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "key", valid_580046
  var valid_580047 = query.getOrDefault("prettyPrint")
  valid_580047 = validateParameter(valid_580047, JBool, required = false,
                                 default = newJBool(true))
  if valid_580047 != nil:
    section.add "prettyPrint", valid_580047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580048: Call_ReplicapoolupdaterRollingUpdatesGet_580035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about an update.
  ## 
  let valid = call_580048.validator(path, query, header, formData, body)
  let scheme = call_580048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580048.url(scheme.get, call_580048.host, call_580048.base,
                         call_580048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580048, url, valid)

proc call*(call_580049: Call_ReplicapoolupdaterRollingUpdatesGet_580035;
          zone: string; rollingUpdate: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolupdaterRollingUpdatesGet
  ## Returns information about an update.
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
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
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580050 = newJObject()
  var query_580051 = newJObject()
  add(path_580050, "zone", newJString(zone))
  add(query_580051, "fields", newJString(fields))
  add(query_580051, "quotaUser", newJString(quotaUser))
  add(query_580051, "alt", newJString(alt))
  add(query_580051, "oauth_token", newJString(oauthToken))
  add(query_580051, "userIp", newJString(userIp))
  add(path_580050, "rollingUpdate", newJString(rollingUpdate))
  add(query_580051, "key", newJString(key))
  add(path_580050, "project", newJString(project))
  add(query_580051, "prettyPrint", newJBool(prettyPrint))
  result = call_580049.call(path_580050, query_580051, nil, nil, nil)

var replicapoolupdaterRollingUpdatesGet* = Call_ReplicapoolupdaterRollingUpdatesGet_580035(
    name: "replicapoolupdaterRollingUpdatesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}",
    validator: validate_ReplicapoolupdaterRollingUpdatesGet_580036,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesGet_580037, schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesCancel_580052 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolupdaterRollingUpdatesCancel_580054(protocol: Scheme;
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

proc validate_ReplicapoolupdaterRollingUpdatesCancel_580053(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels an update. The update must be PAUSED before it can be cancelled. This has no effect if the update is already CANCELLED.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580055 = path.getOrDefault("zone")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "zone", valid_580055
  var valid_580056 = path.getOrDefault("rollingUpdate")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "rollingUpdate", valid_580056
  var valid_580057 = path.getOrDefault("project")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "project", valid_580057
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
  var valid_580058 = query.getOrDefault("fields")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "fields", valid_580058
  var valid_580059 = query.getOrDefault("quotaUser")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "quotaUser", valid_580059
  var valid_580060 = query.getOrDefault("alt")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("json"))
  if valid_580060 != nil:
    section.add "alt", valid_580060
  var valid_580061 = query.getOrDefault("oauth_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "oauth_token", valid_580061
  var valid_580062 = query.getOrDefault("userIp")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "userIp", valid_580062
  var valid_580063 = query.getOrDefault("key")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "key", valid_580063
  var valid_580064 = query.getOrDefault("prettyPrint")
  valid_580064 = validateParameter(valid_580064, JBool, required = false,
                                 default = newJBool(true))
  if valid_580064 != nil:
    section.add "prettyPrint", valid_580064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580065: Call_ReplicapoolupdaterRollingUpdatesCancel_580052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels an update. The update must be PAUSED before it can be cancelled. This has no effect if the update is already CANCELLED.
  ## 
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_ReplicapoolupdaterRollingUpdatesCancel_580052;
          zone: string; rollingUpdate: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolupdaterRollingUpdatesCancel
  ## Cancels an update. The update must be PAUSED before it can be cancelled. This has no effect if the update is already CANCELLED.
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
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
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  add(path_580067, "zone", newJString(zone))
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "userIp", newJString(userIp))
  add(path_580067, "rollingUpdate", newJString(rollingUpdate))
  add(query_580068, "key", newJString(key))
  add(path_580067, "project", newJString(project))
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  result = call_580066.call(path_580067, query_580068, nil, nil, nil)

var replicapoolupdaterRollingUpdatesCancel* = Call_ReplicapoolupdaterRollingUpdatesCancel_580052(
    name: "replicapoolupdaterRollingUpdatesCancel", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}/cancel",
    validator: validate_ReplicapoolupdaterRollingUpdatesCancel_580053,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesCancel_580054,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_580069 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_580071(
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

proc validate_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_580070(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the current status for each instance within a given update.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580072 = path.getOrDefault("zone")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "zone", valid_580072
  var valid_580073 = path.getOrDefault("rollingUpdate")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "rollingUpdate", valid_580073
  var valid_580074 = path.getOrDefault("project")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "project", valid_580074
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
  var valid_580075 = query.getOrDefault("fields")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "fields", valid_580075
  var valid_580076 = query.getOrDefault("pageToken")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "pageToken", valid_580076
  var valid_580077 = query.getOrDefault("quotaUser")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "quotaUser", valid_580077
  var valid_580078 = query.getOrDefault("alt")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("json"))
  if valid_580078 != nil:
    section.add "alt", valid_580078
  var valid_580079 = query.getOrDefault("oauth_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "oauth_token", valid_580079
  var valid_580080 = query.getOrDefault("userIp")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "userIp", valid_580080
  var valid_580081 = query.getOrDefault("maxResults")
  valid_580081 = validateParameter(valid_580081, JInt, required = false,
                                 default = newJInt(500))
  if valid_580081 != nil:
    section.add "maxResults", valid_580081
  var valid_580082 = query.getOrDefault("key")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "key", valid_580082
  var valid_580083 = query.getOrDefault("prettyPrint")
  valid_580083 = validateParameter(valid_580083, JBool, required = false,
                                 default = newJBool(true))
  if valid_580083 != nil:
    section.add "prettyPrint", valid_580083
  var valid_580084 = query.getOrDefault("filter")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "filter", valid_580084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580085: Call_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_580069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the current status for each instance within a given update.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_580069;
          zone: string; rollingUpdate: string; project: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 500;
          key: string = ""; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## replicapoolupdaterRollingUpdatesListInstanceUpdates
  ## Lists the current status for each instance within a given update.
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
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
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Filter expression for filtering listed resources.
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  add(path_580087, "zone", newJString(zone))
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "pageToken", newJString(pageToken))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(query_580088, "userIp", newJString(userIp))
  add(query_580088, "maxResults", newJInt(maxResults))
  add(path_580087, "rollingUpdate", newJString(rollingUpdate))
  add(query_580088, "key", newJString(key))
  add(path_580087, "project", newJString(project))
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  add(query_580088, "filter", newJString(filter))
  result = call_580086.call(path_580087, query_580088, nil, nil, nil)

var replicapoolupdaterRollingUpdatesListInstanceUpdates* = Call_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_580069(
    name: "replicapoolupdaterRollingUpdatesListInstanceUpdates",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}/instanceUpdates",
    validator: validate_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_580070,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesListInstanceUpdates_580071,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesPause_580089 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolupdaterRollingUpdatesPause_580091(protocol: Scheme;
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

proc validate_ReplicapoolupdaterRollingUpdatesPause_580090(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pauses the update in state from ROLLING_FORWARD or ROLLING_BACK. Has no effect if invoked when the state of the update is PAUSED.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580092 = path.getOrDefault("zone")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "zone", valid_580092
  var valid_580093 = path.getOrDefault("rollingUpdate")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "rollingUpdate", valid_580093
  var valid_580094 = path.getOrDefault("project")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "project", valid_580094
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
  var valid_580095 = query.getOrDefault("fields")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "fields", valid_580095
  var valid_580096 = query.getOrDefault("quotaUser")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "quotaUser", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("oauth_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "oauth_token", valid_580098
  var valid_580099 = query.getOrDefault("userIp")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "userIp", valid_580099
  var valid_580100 = query.getOrDefault("key")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "key", valid_580100
  var valid_580101 = query.getOrDefault("prettyPrint")
  valid_580101 = validateParameter(valid_580101, JBool, required = false,
                                 default = newJBool(true))
  if valid_580101 != nil:
    section.add "prettyPrint", valid_580101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580102: Call_ReplicapoolupdaterRollingUpdatesPause_580089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pauses the update in state from ROLLING_FORWARD or ROLLING_BACK. Has no effect if invoked when the state of the update is PAUSED.
  ## 
  let valid = call_580102.validator(path, query, header, formData, body)
  let scheme = call_580102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580102.url(scheme.get, call_580102.host, call_580102.base,
                         call_580102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580102, url, valid)

proc call*(call_580103: Call_ReplicapoolupdaterRollingUpdatesPause_580089;
          zone: string; rollingUpdate: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolupdaterRollingUpdatesPause
  ## Pauses the update in state from ROLLING_FORWARD or ROLLING_BACK. Has no effect if invoked when the state of the update is PAUSED.
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
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
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580104 = newJObject()
  var query_580105 = newJObject()
  add(path_580104, "zone", newJString(zone))
  add(query_580105, "fields", newJString(fields))
  add(query_580105, "quotaUser", newJString(quotaUser))
  add(query_580105, "alt", newJString(alt))
  add(query_580105, "oauth_token", newJString(oauthToken))
  add(query_580105, "userIp", newJString(userIp))
  add(path_580104, "rollingUpdate", newJString(rollingUpdate))
  add(query_580105, "key", newJString(key))
  add(path_580104, "project", newJString(project))
  add(query_580105, "prettyPrint", newJBool(prettyPrint))
  result = call_580103.call(path_580104, query_580105, nil, nil, nil)

var replicapoolupdaterRollingUpdatesPause* = Call_ReplicapoolupdaterRollingUpdatesPause_580089(
    name: "replicapoolupdaterRollingUpdatesPause", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}/pause",
    validator: validate_ReplicapoolupdaterRollingUpdatesPause_580090,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesPause_580091, schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesResume_580106 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolupdaterRollingUpdatesResume_580108(protocol: Scheme;
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

proc validate_ReplicapoolupdaterRollingUpdatesResume_580107(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Continues an update in PAUSED state. Has no effect if invoked when the state of the update is ROLLED_OUT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580109 = path.getOrDefault("zone")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "zone", valid_580109
  var valid_580110 = path.getOrDefault("rollingUpdate")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "rollingUpdate", valid_580110
  var valid_580111 = path.getOrDefault("project")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "project", valid_580111
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
  var valid_580112 = query.getOrDefault("fields")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "fields", valid_580112
  var valid_580113 = query.getOrDefault("quotaUser")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "quotaUser", valid_580113
  var valid_580114 = query.getOrDefault("alt")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("json"))
  if valid_580114 != nil:
    section.add "alt", valid_580114
  var valid_580115 = query.getOrDefault("oauth_token")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "oauth_token", valid_580115
  var valid_580116 = query.getOrDefault("userIp")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "userIp", valid_580116
  var valid_580117 = query.getOrDefault("key")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "key", valid_580117
  var valid_580118 = query.getOrDefault("prettyPrint")
  valid_580118 = validateParameter(valid_580118, JBool, required = false,
                                 default = newJBool(true))
  if valid_580118 != nil:
    section.add "prettyPrint", valid_580118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580119: Call_ReplicapoolupdaterRollingUpdatesResume_580106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Continues an update in PAUSED state. Has no effect if invoked when the state of the update is ROLLED_OUT.
  ## 
  let valid = call_580119.validator(path, query, header, formData, body)
  let scheme = call_580119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580119.url(scheme.get, call_580119.host, call_580119.base,
                         call_580119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580119, url, valid)

proc call*(call_580120: Call_ReplicapoolupdaterRollingUpdatesResume_580106;
          zone: string; rollingUpdate: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolupdaterRollingUpdatesResume
  ## Continues an update in PAUSED state. Has no effect if invoked when the state of the update is ROLLED_OUT.
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
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
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580121 = newJObject()
  var query_580122 = newJObject()
  add(path_580121, "zone", newJString(zone))
  add(query_580122, "fields", newJString(fields))
  add(query_580122, "quotaUser", newJString(quotaUser))
  add(query_580122, "alt", newJString(alt))
  add(query_580122, "oauth_token", newJString(oauthToken))
  add(query_580122, "userIp", newJString(userIp))
  add(path_580121, "rollingUpdate", newJString(rollingUpdate))
  add(query_580122, "key", newJString(key))
  add(path_580121, "project", newJString(project))
  add(query_580122, "prettyPrint", newJBool(prettyPrint))
  result = call_580120.call(path_580121, query_580122, nil, nil, nil)

var replicapoolupdaterRollingUpdatesResume* = Call_ReplicapoolupdaterRollingUpdatesResume_580106(
    name: "replicapoolupdaterRollingUpdatesResume", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}/resume",
    validator: validate_ReplicapoolupdaterRollingUpdatesResume_580107,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesResume_580108,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolupdaterRollingUpdatesRollback_580123 = ref object of OpenApiRestCall_579424
proc url_ReplicapoolupdaterRollingUpdatesRollback_580125(protocol: Scheme;
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

proc validate_ReplicapoolupdaterRollingUpdatesRollback_580124(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rolls back the update in state from ROLLING_FORWARD or PAUSED. Has no effect if invoked when the state of the update is ROLLED_BACK.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the update's target resides.
  ##   rollingUpdate: JString (required)
  ##                : The name of the update.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580126 = path.getOrDefault("zone")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "zone", valid_580126
  var valid_580127 = path.getOrDefault("rollingUpdate")
  valid_580127 = validateParameter(valid_580127, JString, required = true,
                                 default = nil)
  if valid_580127 != nil:
    section.add "rollingUpdate", valid_580127
  var valid_580128 = path.getOrDefault("project")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "project", valid_580128
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
  var valid_580129 = query.getOrDefault("fields")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "fields", valid_580129
  var valid_580130 = query.getOrDefault("quotaUser")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "quotaUser", valid_580130
  var valid_580131 = query.getOrDefault("alt")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = newJString("json"))
  if valid_580131 != nil:
    section.add "alt", valid_580131
  var valid_580132 = query.getOrDefault("oauth_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "oauth_token", valid_580132
  var valid_580133 = query.getOrDefault("userIp")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "userIp", valid_580133
  var valid_580134 = query.getOrDefault("key")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "key", valid_580134
  var valid_580135 = query.getOrDefault("prettyPrint")
  valid_580135 = validateParameter(valid_580135, JBool, required = false,
                                 default = newJBool(true))
  if valid_580135 != nil:
    section.add "prettyPrint", valid_580135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580136: Call_ReplicapoolupdaterRollingUpdatesRollback_580123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back the update in state from ROLLING_FORWARD or PAUSED. Has no effect if invoked when the state of the update is ROLLED_BACK.
  ## 
  let valid = call_580136.validator(path, query, header, formData, body)
  let scheme = call_580136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580136.url(scheme.get, call_580136.host, call_580136.base,
                         call_580136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580136, url, valid)

proc call*(call_580137: Call_ReplicapoolupdaterRollingUpdatesRollback_580123;
          zone: string; rollingUpdate: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolupdaterRollingUpdatesRollback
  ## Rolls back the update in state from ROLLING_FORWARD or PAUSED. Has no effect if invoked when the state of the update is ROLLED_BACK.
  ##   zone: string (required)
  ##       : The name of the zone in which the update's target resides.
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
  ##   rollingUpdate: string (required)
  ##                : The name of the update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580138 = newJObject()
  var query_580139 = newJObject()
  add(path_580138, "zone", newJString(zone))
  add(query_580139, "fields", newJString(fields))
  add(query_580139, "quotaUser", newJString(quotaUser))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(query_580139, "userIp", newJString(userIp))
  add(path_580138, "rollingUpdate", newJString(rollingUpdate))
  add(query_580139, "key", newJString(key))
  add(path_580138, "project", newJString(project))
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  result = call_580137.call(path_580138, query_580139, nil, nil, nil)

var replicapoolupdaterRollingUpdatesRollback* = Call_ReplicapoolupdaterRollingUpdatesRollback_580123(
    name: "replicapoolupdaterRollingUpdatesRollback", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/rollingUpdates/{rollingUpdate}/rollback",
    validator: validate_ReplicapoolupdaterRollingUpdatesRollback_580124,
    base: "/replicapoolupdater/v1beta1/projects",
    url: url_ReplicapoolupdaterRollingUpdatesRollback_580125,
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
