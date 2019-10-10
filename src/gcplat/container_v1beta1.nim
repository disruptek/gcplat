
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Container Engine
## version: v1beta1
## termsOfService: (not provided)
## license: (not provided)
## 
## The Google Container Engine API is used for building and managing container based applications, powered by the open source Kubernetes technology.
## 
## https://cloud.google.com/container-engine/
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "container"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContainerProjectsZonesClustersCreate_589011 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersCreate_589013(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersCreate_589012(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589014 = path.getOrDefault("zone")
  valid_589014 = validateParameter(valid_589014, JString, required = true,
                                 default = nil)
  if valid_589014 != nil:
    section.add "zone", valid_589014
  var valid_589015 = path.getOrDefault("projectId")
  valid_589015 = validateParameter(valid_589015, JString, required = true,
                                 default = nil)
  if valid_589015 != nil:
    section.add "projectId", valid_589015
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589016 = query.getOrDefault("upload_protocol")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "upload_protocol", valid_589016
  var valid_589017 = query.getOrDefault("fields")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "fields", valid_589017
  var valid_589018 = query.getOrDefault("quotaUser")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "quotaUser", valid_589018
  var valid_589019 = query.getOrDefault("alt")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = newJString("json"))
  if valid_589019 != nil:
    section.add "alt", valid_589019
  var valid_589020 = query.getOrDefault("pp")
  valid_589020 = validateParameter(valid_589020, JBool, required = false,
                                 default = newJBool(true))
  if valid_589020 != nil:
    section.add "pp", valid_589020
  var valid_589021 = query.getOrDefault("oauth_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "oauth_token", valid_589021
  var valid_589022 = query.getOrDefault("callback")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "callback", valid_589022
  var valid_589023 = query.getOrDefault("access_token")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "access_token", valid_589023
  var valid_589024 = query.getOrDefault("uploadType")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "uploadType", valid_589024
  var valid_589025 = query.getOrDefault("key")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "key", valid_589025
  var valid_589026 = query.getOrDefault("$.xgafv")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = newJString("1"))
  if valid_589026 != nil:
    section.add "$.xgafv", valid_589026
  var valid_589027 = query.getOrDefault("prettyPrint")
  valid_589027 = validateParameter(valid_589027, JBool, required = false,
                                 default = newJBool(true))
  if valid_589027 != nil:
    section.add "prettyPrint", valid_589027
  var valid_589028 = query.getOrDefault("bearer_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "bearer_token", valid_589028
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

proc call*(call_589030: Call_ContainerProjectsZonesClustersCreate_589011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ## 
  let valid = call_589030.validator(path, query, header, formData, body)
  let scheme = call_589030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589030.url(scheme.get, call_589030.host, call_589030.base,
                         call_589030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589030, url, valid)

proc call*(call_589031: Call_ContainerProjectsZonesClustersCreate_589011;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersCreate
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589032 = newJObject()
  var query_589033 = newJObject()
  var body_589034 = newJObject()
  add(query_589033, "upload_protocol", newJString(uploadProtocol))
  add(path_589032, "zone", newJString(zone))
  add(query_589033, "fields", newJString(fields))
  add(query_589033, "quotaUser", newJString(quotaUser))
  add(query_589033, "alt", newJString(alt))
  add(query_589033, "pp", newJBool(pp))
  add(query_589033, "oauth_token", newJString(oauthToken))
  add(query_589033, "callback", newJString(callback))
  add(query_589033, "access_token", newJString(accessToken))
  add(query_589033, "uploadType", newJString(uploadType))
  add(query_589033, "key", newJString(key))
  add(path_589032, "projectId", newJString(projectId))
  add(query_589033, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589034 = body
  add(query_589033, "prettyPrint", newJBool(prettyPrint))
  add(query_589033, "bearer_token", newJString(bearerToken))
  result = call_589031.call(path_589032, query_589033, nil, nil, body_589034)

var containerProjectsZonesClustersCreate* = Call_ContainerProjectsZonesClustersCreate_589011(
    name: "containerProjectsZonesClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersCreate_589012, base: "/",
    url: url_ContainerProjectsZonesClustersCreate_589013, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersList_588719 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersList_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersList_588720(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_588847 = path.getOrDefault("zone")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "zone", valid_588847
  var valid_588848 = path.getOrDefault("projectId")
  valid_588848 = validateParameter(valid_588848, JString, required = true,
                                 default = nil)
  if valid_588848 != nil:
    section.add "projectId", valid_588848
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project and location) where the clusters will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_588849 = query.getOrDefault("upload_protocol")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "upload_protocol", valid_588849
  var valid_588850 = query.getOrDefault("fields")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "fields", valid_588850
  var valid_588851 = query.getOrDefault("quotaUser")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "quotaUser", valid_588851
  var valid_588865 = query.getOrDefault("alt")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = newJString("json"))
  if valid_588865 != nil:
    section.add "alt", valid_588865
  var valid_588866 = query.getOrDefault("pp")
  valid_588866 = validateParameter(valid_588866, JBool, required = false,
                                 default = newJBool(true))
  if valid_588866 != nil:
    section.add "pp", valid_588866
  var valid_588867 = query.getOrDefault("oauth_token")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "oauth_token", valid_588867
  var valid_588868 = query.getOrDefault("callback")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "callback", valid_588868
  var valid_588869 = query.getOrDefault("access_token")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "access_token", valid_588869
  var valid_588870 = query.getOrDefault("uploadType")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = nil)
  if valid_588870 != nil:
    section.add "uploadType", valid_588870
  var valid_588871 = query.getOrDefault("parent")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "parent", valid_588871
  var valid_588872 = query.getOrDefault("key")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "key", valid_588872
  var valid_588873 = query.getOrDefault("$.xgafv")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = newJString("1"))
  if valid_588873 != nil:
    section.add "$.xgafv", valid_588873
  var valid_588874 = query.getOrDefault("prettyPrint")
  valid_588874 = validateParameter(valid_588874, JBool, required = false,
                                 default = newJBool(true))
  if valid_588874 != nil:
    section.add "prettyPrint", valid_588874
  var valid_588875 = query.getOrDefault("bearer_token")
  valid_588875 = validateParameter(valid_588875, JString, required = false,
                                 default = nil)
  if valid_588875 != nil:
    section.add "bearer_token", valid_588875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588898: Call_ContainerProjectsZonesClustersList_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_588898.validator(path, query, header, formData, body)
  let scheme = call_588898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588898.url(scheme.get, call_588898.host, call_588898.base,
                         call_588898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588898, url, valid)

proc call*(call_588969: Call_ContainerProjectsZonesClustersList_588719;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; parent: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersList
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project and location) where the clusters will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_588970 = newJObject()
  var query_588972 = newJObject()
  add(query_588972, "upload_protocol", newJString(uploadProtocol))
  add(path_588970, "zone", newJString(zone))
  add(query_588972, "fields", newJString(fields))
  add(query_588972, "quotaUser", newJString(quotaUser))
  add(query_588972, "alt", newJString(alt))
  add(query_588972, "pp", newJBool(pp))
  add(query_588972, "oauth_token", newJString(oauthToken))
  add(query_588972, "callback", newJString(callback))
  add(query_588972, "access_token", newJString(accessToken))
  add(query_588972, "uploadType", newJString(uploadType))
  add(query_588972, "parent", newJString(parent))
  add(query_588972, "key", newJString(key))
  add(path_588970, "projectId", newJString(projectId))
  add(query_588972, "$.xgafv", newJString(Xgafv))
  add(query_588972, "prettyPrint", newJBool(prettyPrint))
  add(query_588972, "bearer_token", newJString(bearerToken))
  result = call_588969.call(path_588970, query_588972, nil, nil, nil)

var containerProjectsZonesClustersList* = Call_ContainerProjectsZonesClustersList_588719(
    name: "containerProjectsZonesClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersList_588720, base: "/",
    url: url_ContainerProjectsZonesClustersList_588721, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersUpdate_589059 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersUpdate_589061(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersUpdate_589060(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the settings of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589062 = path.getOrDefault("zone")
  valid_589062 = validateParameter(valid_589062, JString, required = true,
                                 default = nil)
  if valid_589062 != nil:
    section.add "zone", valid_589062
  var valid_589063 = path.getOrDefault("projectId")
  valid_589063 = validateParameter(valid_589063, JString, required = true,
                                 default = nil)
  if valid_589063 != nil:
    section.add "projectId", valid_589063
  var valid_589064 = path.getOrDefault("clusterId")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "clusterId", valid_589064
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589065 = query.getOrDefault("upload_protocol")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "upload_protocol", valid_589065
  var valid_589066 = query.getOrDefault("fields")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "fields", valid_589066
  var valid_589067 = query.getOrDefault("quotaUser")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "quotaUser", valid_589067
  var valid_589068 = query.getOrDefault("alt")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("json"))
  if valid_589068 != nil:
    section.add "alt", valid_589068
  var valid_589069 = query.getOrDefault("pp")
  valid_589069 = validateParameter(valid_589069, JBool, required = false,
                                 default = newJBool(true))
  if valid_589069 != nil:
    section.add "pp", valid_589069
  var valid_589070 = query.getOrDefault("oauth_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "oauth_token", valid_589070
  var valid_589071 = query.getOrDefault("callback")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "callback", valid_589071
  var valid_589072 = query.getOrDefault("access_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "access_token", valid_589072
  var valid_589073 = query.getOrDefault("uploadType")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "uploadType", valid_589073
  var valid_589074 = query.getOrDefault("key")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "key", valid_589074
  var valid_589075 = query.getOrDefault("$.xgafv")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("1"))
  if valid_589075 != nil:
    section.add "$.xgafv", valid_589075
  var valid_589076 = query.getOrDefault("prettyPrint")
  valid_589076 = validateParameter(valid_589076, JBool, required = false,
                                 default = newJBool(true))
  if valid_589076 != nil:
    section.add "prettyPrint", valid_589076
  var valid_589077 = query.getOrDefault("bearer_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "bearer_token", valid_589077
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

proc call*(call_589079: Call_ContainerProjectsZonesClustersUpdate_589059;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the settings of a specific cluster.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_ContainerProjectsZonesClustersUpdate_589059;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersUpdate
  ## Updates the settings of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  var body_589083 = newJObject()
  add(query_589082, "upload_protocol", newJString(uploadProtocol))
  add(path_589081, "zone", newJString(zone))
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "pp", newJBool(pp))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "callback", newJString(callback))
  add(query_589082, "access_token", newJString(accessToken))
  add(query_589082, "uploadType", newJString(uploadType))
  add(query_589082, "key", newJString(key))
  add(path_589081, "projectId", newJString(projectId))
  add(query_589082, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589083 = body
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  add(path_589081, "clusterId", newJString(clusterId))
  add(query_589082, "bearer_token", newJString(bearerToken))
  result = call_589080.call(path_589081, query_589082, nil, nil, body_589083)

var containerProjectsZonesClustersUpdate* = Call_ContainerProjectsZonesClustersUpdate_589059(
    name: "containerProjectsZonesClustersUpdate", meth: HttpMethod.HttpPut,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersUpdate_589060, base: "/",
    url: url_ContainerProjectsZonesClustersUpdate_589061, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersGet_589035 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersGet_589037(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersGet_589036(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to retrieve.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589038 = path.getOrDefault("zone")
  valid_589038 = validateParameter(valid_589038, JString, required = true,
                                 default = nil)
  if valid_589038 != nil:
    section.add "zone", valid_589038
  var valid_589039 = path.getOrDefault("projectId")
  valid_589039 = validateParameter(valid_589039, JString, required = true,
                                 default = nil)
  if valid_589039 != nil:
    section.add "projectId", valid_589039
  var valid_589040 = path.getOrDefault("clusterId")
  valid_589040 = validateParameter(valid_589040, JString, required = true,
                                 default = nil)
  if valid_589040 != nil:
    section.add "clusterId", valid_589040
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project, location, cluster) of the cluster to retrieve.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589041 = query.getOrDefault("upload_protocol")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "upload_protocol", valid_589041
  var valid_589042 = query.getOrDefault("fields")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "fields", valid_589042
  var valid_589043 = query.getOrDefault("quotaUser")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "quotaUser", valid_589043
  var valid_589044 = query.getOrDefault("alt")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = newJString("json"))
  if valid_589044 != nil:
    section.add "alt", valid_589044
  var valid_589045 = query.getOrDefault("pp")
  valid_589045 = validateParameter(valid_589045, JBool, required = false,
                                 default = newJBool(true))
  if valid_589045 != nil:
    section.add "pp", valid_589045
  var valid_589046 = query.getOrDefault("oauth_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "oauth_token", valid_589046
  var valid_589047 = query.getOrDefault("callback")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "callback", valid_589047
  var valid_589048 = query.getOrDefault("access_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "access_token", valid_589048
  var valid_589049 = query.getOrDefault("uploadType")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "uploadType", valid_589049
  var valid_589050 = query.getOrDefault("key")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "key", valid_589050
  var valid_589051 = query.getOrDefault("name")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "name", valid_589051
  var valid_589052 = query.getOrDefault("$.xgafv")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = newJString("1"))
  if valid_589052 != nil:
    section.add "$.xgafv", valid_589052
  var valid_589053 = query.getOrDefault("prettyPrint")
  valid_589053 = validateParameter(valid_589053, JBool, required = false,
                                 default = newJBool(true))
  if valid_589053 != nil:
    section.add "prettyPrint", valid_589053
  var valid_589054 = query.getOrDefault("bearer_token")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "bearer_token", valid_589054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589055: Call_ContainerProjectsZonesClustersGet_589035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific cluster.
  ## 
  let valid = call_589055.validator(path, query, header, formData, body)
  let scheme = call_589055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589055.url(scheme.get, call_589055.host, call_589055.base,
                         call_589055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589055, url, valid)

proc call*(call_589056: Call_ContainerProjectsZonesClustersGet_589035;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersGet
  ## Gets the details of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster) of the cluster to retrieve.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to retrieve.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589057 = newJObject()
  var query_589058 = newJObject()
  add(query_589058, "upload_protocol", newJString(uploadProtocol))
  add(path_589057, "zone", newJString(zone))
  add(query_589058, "fields", newJString(fields))
  add(query_589058, "quotaUser", newJString(quotaUser))
  add(query_589058, "alt", newJString(alt))
  add(query_589058, "pp", newJBool(pp))
  add(query_589058, "oauth_token", newJString(oauthToken))
  add(query_589058, "callback", newJString(callback))
  add(query_589058, "access_token", newJString(accessToken))
  add(query_589058, "uploadType", newJString(uploadType))
  add(query_589058, "key", newJString(key))
  add(query_589058, "name", newJString(name))
  add(path_589057, "projectId", newJString(projectId))
  add(query_589058, "$.xgafv", newJString(Xgafv))
  add(query_589058, "prettyPrint", newJBool(prettyPrint))
  add(path_589057, "clusterId", newJString(clusterId))
  add(query_589058, "bearer_token", newJString(bearerToken))
  result = call_589056.call(path_589057, query_589058, nil, nil, nil)

var containerProjectsZonesClustersGet* = Call_ContainerProjectsZonesClustersGet_589035(
    name: "containerProjectsZonesClustersGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersGet_589036, base: "/",
    url: url_ContainerProjectsZonesClustersGet_589037, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersDelete_589084 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersDelete_589086(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersDelete_589085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster
  ## (e.g. load balancer resources) will not be deleted if they weren't present
  ## at the initial create time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to delete.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589087 = path.getOrDefault("zone")
  valid_589087 = validateParameter(valid_589087, JString, required = true,
                                 default = nil)
  if valid_589087 != nil:
    section.add "zone", valid_589087
  var valid_589088 = path.getOrDefault("projectId")
  valid_589088 = validateParameter(valid_589088, JString, required = true,
                                 default = nil)
  if valid_589088 != nil:
    section.add "projectId", valid_589088
  var valid_589089 = path.getOrDefault("clusterId")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "clusterId", valid_589089
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project, location, cluster) of the cluster to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589090 = query.getOrDefault("upload_protocol")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "upload_protocol", valid_589090
  var valid_589091 = query.getOrDefault("fields")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "fields", valid_589091
  var valid_589092 = query.getOrDefault("quotaUser")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "quotaUser", valid_589092
  var valid_589093 = query.getOrDefault("alt")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = newJString("json"))
  if valid_589093 != nil:
    section.add "alt", valid_589093
  var valid_589094 = query.getOrDefault("pp")
  valid_589094 = validateParameter(valid_589094, JBool, required = false,
                                 default = newJBool(true))
  if valid_589094 != nil:
    section.add "pp", valid_589094
  var valid_589095 = query.getOrDefault("oauth_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "oauth_token", valid_589095
  var valid_589096 = query.getOrDefault("callback")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "callback", valid_589096
  var valid_589097 = query.getOrDefault("access_token")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "access_token", valid_589097
  var valid_589098 = query.getOrDefault("uploadType")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "uploadType", valid_589098
  var valid_589099 = query.getOrDefault("key")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "key", valid_589099
  var valid_589100 = query.getOrDefault("name")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "name", valid_589100
  var valid_589101 = query.getOrDefault("$.xgafv")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("1"))
  if valid_589101 != nil:
    section.add "$.xgafv", valid_589101
  var valid_589102 = query.getOrDefault("prettyPrint")
  valid_589102 = validateParameter(valid_589102, JBool, required = false,
                                 default = newJBool(true))
  if valid_589102 != nil:
    section.add "prettyPrint", valid_589102
  var valid_589103 = query.getOrDefault("bearer_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "bearer_token", valid_589103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589104: Call_ContainerProjectsZonesClustersDelete_589084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster
  ## (e.g. load balancer resources) will not be deleted if they weren't present
  ## at the initial create time.
  ## 
  let valid = call_589104.validator(path, query, header, formData, body)
  let scheme = call_589104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589104.url(scheme.get, call_589104.host, call_589104.base,
                         call_589104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589104, url, valid)

proc call*(call_589105: Call_ContainerProjectsZonesClustersDelete_589084;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersDelete
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster
  ## (e.g. load balancer resources) will not be deleted if they weren't present
  ## at the initial create time.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster) of the cluster to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to delete.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589106 = newJObject()
  var query_589107 = newJObject()
  add(query_589107, "upload_protocol", newJString(uploadProtocol))
  add(path_589106, "zone", newJString(zone))
  add(query_589107, "fields", newJString(fields))
  add(query_589107, "quotaUser", newJString(quotaUser))
  add(query_589107, "alt", newJString(alt))
  add(query_589107, "pp", newJBool(pp))
  add(query_589107, "oauth_token", newJString(oauthToken))
  add(query_589107, "callback", newJString(callback))
  add(query_589107, "access_token", newJString(accessToken))
  add(query_589107, "uploadType", newJString(uploadType))
  add(query_589107, "key", newJString(key))
  add(query_589107, "name", newJString(name))
  add(path_589106, "projectId", newJString(projectId))
  add(query_589107, "$.xgafv", newJString(Xgafv))
  add(query_589107, "prettyPrint", newJBool(prettyPrint))
  add(path_589106, "clusterId", newJString(clusterId))
  add(query_589107, "bearer_token", newJString(bearerToken))
  result = call_589105.call(path_589106, query_589107, nil, nil, nil)

var containerProjectsZonesClustersDelete* = Call_ContainerProjectsZonesClustersDelete_589084(
    name: "containerProjectsZonesClustersDelete", meth: HttpMethod.HttpDelete,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersDelete_589085, base: "/",
    url: url_ContainerProjectsZonesClustersDelete_589086, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersAddons_589108 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersAddons_589110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/addons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersAddons_589109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the addons of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589111 = path.getOrDefault("zone")
  valid_589111 = validateParameter(valid_589111, JString, required = true,
                                 default = nil)
  if valid_589111 != nil:
    section.add "zone", valid_589111
  var valid_589112 = path.getOrDefault("projectId")
  valid_589112 = validateParameter(valid_589112, JString, required = true,
                                 default = nil)
  if valid_589112 != nil:
    section.add "projectId", valid_589112
  var valid_589113 = path.getOrDefault("clusterId")
  valid_589113 = validateParameter(valid_589113, JString, required = true,
                                 default = nil)
  if valid_589113 != nil:
    section.add "clusterId", valid_589113
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589114 = query.getOrDefault("upload_protocol")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "upload_protocol", valid_589114
  var valid_589115 = query.getOrDefault("fields")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "fields", valid_589115
  var valid_589116 = query.getOrDefault("quotaUser")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "quotaUser", valid_589116
  var valid_589117 = query.getOrDefault("alt")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = newJString("json"))
  if valid_589117 != nil:
    section.add "alt", valid_589117
  var valid_589118 = query.getOrDefault("pp")
  valid_589118 = validateParameter(valid_589118, JBool, required = false,
                                 default = newJBool(true))
  if valid_589118 != nil:
    section.add "pp", valid_589118
  var valid_589119 = query.getOrDefault("oauth_token")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "oauth_token", valid_589119
  var valid_589120 = query.getOrDefault("callback")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "callback", valid_589120
  var valid_589121 = query.getOrDefault("access_token")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "access_token", valid_589121
  var valid_589122 = query.getOrDefault("uploadType")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "uploadType", valid_589122
  var valid_589123 = query.getOrDefault("key")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "key", valid_589123
  var valid_589124 = query.getOrDefault("$.xgafv")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = newJString("1"))
  if valid_589124 != nil:
    section.add "$.xgafv", valid_589124
  var valid_589125 = query.getOrDefault("prettyPrint")
  valid_589125 = validateParameter(valid_589125, JBool, required = false,
                                 default = newJBool(true))
  if valid_589125 != nil:
    section.add "prettyPrint", valid_589125
  var valid_589126 = query.getOrDefault("bearer_token")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "bearer_token", valid_589126
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

proc call*(call_589128: Call_ContainerProjectsZonesClustersAddons_589108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons of a specific cluster.
  ## 
  let valid = call_589128.validator(path, query, header, formData, body)
  let scheme = call_589128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589128.url(scheme.get, call_589128.host, call_589128.base,
                         call_589128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589128, url, valid)

proc call*(call_589129: Call_ContainerProjectsZonesClustersAddons_589108;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersAddons
  ## Sets the addons of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589130 = newJObject()
  var query_589131 = newJObject()
  var body_589132 = newJObject()
  add(query_589131, "upload_protocol", newJString(uploadProtocol))
  add(path_589130, "zone", newJString(zone))
  add(query_589131, "fields", newJString(fields))
  add(query_589131, "quotaUser", newJString(quotaUser))
  add(query_589131, "alt", newJString(alt))
  add(query_589131, "pp", newJBool(pp))
  add(query_589131, "oauth_token", newJString(oauthToken))
  add(query_589131, "callback", newJString(callback))
  add(query_589131, "access_token", newJString(accessToken))
  add(query_589131, "uploadType", newJString(uploadType))
  add(query_589131, "key", newJString(key))
  add(path_589130, "projectId", newJString(projectId))
  add(query_589131, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589132 = body
  add(query_589131, "prettyPrint", newJBool(prettyPrint))
  add(path_589130, "clusterId", newJString(clusterId))
  add(query_589131, "bearer_token", newJString(bearerToken))
  result = call_589129.call(path_589130, query_589131, nil, nil, body_589132)

var containerProjectsZonesClustersAddons* = Call_ContainerProjectsZonesClustersAddons_589108(
    name: "containerProjectsZonesClustersAddons", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/addons",
    validator: validate_ContainerProjectsZonesClustersAddons_589109, base: "/",
    url: url_ContainerProjectsZonesClustersAddons_589110, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLegacyAbac_589133 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersLegacyAbac_589135(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/legacyAbac")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersLegacyAbac_589134(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589136 = path.getOrDefault("zone")
  valid_589136 = validateParameter(valid_589136, JString, required = true,
                                 default = nil)
  if valid_589136 != nil:
    section.add "zone", valid_589136
  var valid_589137 = path.getOrDefault("projectId")
  valid_589137 = validateParameter(valid_589137, JString, required = true,
                                 default = nil)
  if valid_589137 != nil:
    section.add "projectId", valid_589137
  var valid_589138 = path.getOrDefault("clusterId")
  valid_589138 = validateParameter(valid_589138, JString, required = true,
                                 default = nil)
  if valid_589138 != nil:
    section.add "clusterId", valid_589138
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589139 = query.getOrDefault("upload_protocol")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "upload_protocol", valid_589139
  var valid_589140 = query.getOrDefault("fields")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "fields", valid_589140
  var valid_589141 = query.getOrDefault("quotaUser")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "quotaUser", valid_589141
  var valid_589142 = query.getOrDefault("alt")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = newJString("json"))
  if valid_589142 != nil:
    section.add "alt", valid_589142
  var valid_589143 = query.getOrDefault("pp")
  valid_589143 = validateParameter(valid_589143, JBool, required = false,
                                 default = newJBool(true))
  if valid_589143 != nil:
    section.add "pp", valid_589143
  var valid_589144 = query.getOrDefault("oauth_token")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "oauth_token", valid_589144
  var valid_589145 = query.getOrDefault("callback")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "callback", valid_589145
  var valid_589146 = query.getOrDefault("access_token")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "access_token", valid_589146
  var valid_589147 = query.getOrDefault("uploadType")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "uploadType", valid_589147
  var valid_589148 = query.getOrDefault("key")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "key", valid_589148
  var valid_589149 = query.getOrDefault("$.xgafv")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("1"))
  if valid_589149 != nil:
    section.add "$.xgafv", valid_589149
  var valid_589150 = query.getOrDefault("prettyPrint")
  valid_589150 = validateParameter(valid_589150, JBool, required = false,
                                 default = newJBool(true))
  if valid_589150 != nil:
    section.add "prettyPrint", valid_589150
  var valid_589151 = query.getOrDefault("bearer_token")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "bearer_token", valid_589151
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

proc call*(call_589153: Call_ContainerProjectsZonesClustersLegacyAbac_589133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_589153.validator(path, query, header, formData, body)
  let scheme = call_589153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589153.url(scheme.get, call_589153.host, call_589153.base,
                         call_589153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589153, url, valid)

proc call*(call_589154: Call_ContainerProjectsZonesClustersLegacyAbac_589133;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersLegacyAbac
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589155 = newJObject()
  var query_589156 = newJObject()
  var body_589157 = newJObject()
  add(query_589156, "upload_protocol", newJString(uploadProtocol))
  add(path_589155, "zone", newJString(zone))
  add(query_589156, "fields", newJString(fields))
  add(query_589156, "quotaUser", newJString(quotaUser))
  add(query_589156, "alt", newJString(alt))
  add(query_589156, "pp", newJBool(pp))
  add(query_589156, "oauth_token", newJString(oauthToken))
  add(query_589156, "callback", newJString(callback))
  add(query_589156, "access_token", newJString(accessToken))
  add(query_589156, "uploadType", newJString(uploadType))
  add(query_589156, "key", newJString(key))
  add(path_589155, "projectId", newJString(projectId))
  add(query_589156, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589157 = body
  add(query_589156, "prettyPrint", newJBool(prettyPrint))
  add(path_589155, "clusterId", newJString(clusterId))
  add(query_589156, "bearer_token", newJString(bearerToken))
  result = call_589154.call(path_589155, query_589156, nil, nil, body_589157)

var containerProjectsZonesClustersLegacyAbac* = Call_ContainerProjectsZonesClustersLegacyAbac_589133(
    name: "containerProjectsZonesClustersLegacyAbac", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/legacyAbac",
    validator: validate_ContainerProjectsZonesClustersLegacyAbac_589134,
    base: "/", url: url_ContainerProjectsZonesClustersLegacyAbac_589135,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLocations_589158 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersLocations_589160(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersLocations_589159(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the locations of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589161 = path.getOrDefault("zone")
  valid_589161 = validateParameter(valid_589161, JString, required = true,
                                 default = nil)
  if valid_589161 != nil:
    section.add "zone", valid_589161
  var valid_589162 = path.getOrDefault("projectId")
  valid_589162 = validateParameter(valid_589162, JString, required = true,
                                 default = nil)
  if valid_589162 != nil:
    section.add "projectId", valid_589162
  var valid_589163 = path.getOrDefault("clusterId")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "clusterId", valid_589163
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589164 = query.getOrDefault("upload_protocol")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "upload_protocol", valid_589164
  var valid_589165 = query.getOrDefault("fields")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "fields", valid_589165
  var valid_589166 = query.getOrDefault("quotaUser")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "quotaUser", valid_589166
  var valid_589167 = query.getOrDefault("alt")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = newJString("json"))
  if valid_589167 != nil:
    section.add "alt", valid_589167
  var valid_589168 = query.getOrDefault("pp")
  valid_589168 = validateParameter(valid_589168, JBool, required = false,
                                 default = newJBool(true))
  if valid_589168 != nil:
    section.add "pp", valid_589168
  var valid_589169 = query.getOrDefault("oauth_token")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "oauth_token", valid_589169
  var valid_589170 = query.getOrDefault("callback")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "callback", valid_589170
  var valid_589171 = query.getOrDefault("access_token")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "access_token", valid_589171
  var valid_589172 = query.getOrDefault("uploadType")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "uploadType", valid_589172
  var valid_589173 = query.getOrDefault("key")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "key", valid_589173
  var valid_589174 = query.getOrDefault("$.xgafv")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = newJString("1"))
  if valid_589174 != nil:
    section.add "$.xgafv", valid_589174
  var valid_589175 = query.getOrDefault("prettyPrint")
  valid_589175 = validateParameter(valid_589175, JBool, required = false,
                                 default = newJBool(true))
  if valid_589175 != nil:
    section.add "prettyPrint", valid_589175
  var valid_589176 = query.getOrDefault("bearer_token")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "bearer_token", valid_589176
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

proc call*(call_589178: Call_ContainerProjectsZonesClustersLocations_589158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations of a specific cluster.
  ## 
  let valid = call_589178.validator(path, query, header, formData, body)
  let scheme = call_589178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589178.url(scheme.get, call_589178.host, call_589178.base,
                         call_589178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589178, url, valid)

proc call*(call_589179: Call_ContainerProjectsZonesClustersLocations_589158;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersLocations
  ## Sets the locations of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589180 = newJObject()
  var query_589181 = newJObject()
  var body_589182 = newJObject()
  add(query_589181, "upload_protocol", newJString(uploadProtocol))
  add(path_589180, "zone", newJString(zone))
  add(query_589181, "fields", newJString(fields))
  add(query_589181, "quotaUser", newJString(quotaUser))
  add(query_589181, "alt", newJString(alt))
  add(query_589181, "pp", newJBool(pp))
  add(query_589181, "oauth_token", newJString(oauthToken))
  add(query_589181, "callback", newJString(callback))
  add(query_589181, "access_token", newJString(accessToken))
  add(query_589181, "uploadType", newJString(uploadType))
  add(query_589181, "key", newJString(key))
  add(path_589180, "projectId", newJString(projectId))
  add(query_589181, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589182 = body
  add(query_589181, "prettyPrint", newJBool(prettyPrint))
  add(path_589180, "clusterId", newJString(clusterId))
  add(query_589181, "bearer_token", newJString(bearerToken))
  result = call_589179.call(path_589180, query_589181, nil, nil, body_589182)

var containerProjectsZonesClustersLocations* = Call_ContainerProjectsZonesClustersLocations_589158(
    name: "containerProjectsZonesClustersLocations", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/locations",
    validator: validate_ContainerProjectsZonesClustersLocations_589159, base: "/",
    url: url_ContainerProjectsZonesClustersLocations_589160,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLogging_589183 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersLogging_589185(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/logging")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersLogging_589184(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the logging service of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589186 = path.getOrDefault("zone")
  valid_589186 = validateParameter(valid_589186, JString, required = true,
                                 default = nil)
  if valid_589186 != nil:
    section.add "zone", valid_589186
  var valid_589187 = path.getOrDefault("projectId")
  valid_589187 = validateParameter(valid_589187, JString, required = true,
                                 default = nil)
  if valid_589187 != nil:
    section.add "projectId", valid_589187
  var valid_589188 = path.getOrDefault("clusterId")
  valid_589188 = validateParameter(valid_589188, JString, required = true,
                                 default = nil)
  if valid_589188 != nil:
    section.add "clusterId", valid_589188
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589189 = query.getOrDefault("upload_protocol")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "upload_protocol", valid_589189
  var valid_589190 = query.getOrDefault("fields")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "fields", valid_589190
  var valid_589191 = query.getOrDefault("quotaUser")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "quotaUser", valid_589191
  var valid_589192 = query.getOrDefault("alt")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = newJString("json"))
  if valid_589192 != nil:
    section.add "alt", valid_589192
  var valid_589193 = query.getOrDefault("pp")
  valid_589193 = validateParameter(valid_589193, JBool, required = false,
                                 default = newJBool(true))
  if valid_589193 != nil:
    section.add "pp", valid_589193
  var valid_589194 = query.getOrDefault("oauth_token")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "oauth_token", valid_589194
  var valid_589195 = query.getOrDefault("callback")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "callback", valid_589195
  var valid_589196 = query.getOrDefault("access_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "access_token", valid_589196
  var valid_589197 = query.getOrDefault("uploadType")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "uploadType", valid_589197
  var valid_589198 = query.getOrDefault("key")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "key", valid_589198
  var valid_589199 = query.getOrDefault("$.xgafv")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = newJString("1"))
  if valid_589199 != nil:
    section.add "$.xgafv", valid_589199
  var valid_589200 = query.getOrDefault("prettyPrint")
  valid_589200 = validateParameter(valid_589200, JBool, required = false,
                                 default = newJBool(true))
  if valid_589200 != nil:
    section.add "prettyPrint", valid_589200
  var valid_589201 = query.getOrDefault("bearer_token")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "bearer_token", valid_589201
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

proc call*(call_589203: Call_ContainerProjectsZonesClustersLogging_589183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service of a specific cluster.
  ## 
  let valid = call_589203.validator(path, query, header, formData, body)
  let scheme = call_589203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589203.url(scheme.get, call_589203.host, call_589203.base,
                         call_589203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589203, url, valid)

proc call*(call_589204: Call_ContainerProjectsZonesClustersLogging_589183;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersLogging
  ## Sets the logging service of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589205 = newJObject()
  var query_589206 = newJObject()
  var body_589207 = newJObject()
  add(query_589206, "upload_protocol", newJString(uploadProtocol))
  add(path_589205, "zone", newJString(zone))
  add(query_589206, "fields", newJString(fields))
  add(query_589206, "quotaUser", newJString(quotaUser))
  add(query_589206, "alt", newJString(alt))
  add(query_589206, "pp", newJBool(pp))
  add(query_589206, "oauth_token", newJString(oauthToken))
  add(query_589206, "callback", newJString(callback))
  add(query_589206, "access_token", newJString(accessToken))
  add(query_589206, "uploadType", newJString(uploadType))
  add(query_589206, "key", newJString(key))
  add(path_589205, "projectId", newJString(projectId))
  add(query_589206, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589207 = body
  add(query_589206, "prettyPrint", newJBool(prettyPrint))
  add(path_589205, "clusterId", newJString(clusterId))
  add(query_589206, "bearer_token", newJString(bearerToken))
  result = call_589204.call(path_589205, query_589206, nil, nil, body_589207)

var containerProjectsZonesClustersLogging* = Call_ContainerProjectsZonesClustersLogging_589183(
    name: "containerProjectsZonesClustersLogging", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/logging",
    validator: validate_ContainerProjectsZonesClustersLogging_589184, base: "/",
    url: url_ContainerProjectsZonesClustersLogging_589185, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMaster_589208 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersMaster_589210(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/master")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersMaster_589209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the master of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589211 = path.getOrDefault("zone")
  valid_589211 = validateParameter(valid_589211, JString, required = true,
                                 default = nil)
  if valid_589211 != nil:
    section.add "zone", valid_589211
  var valid_589212 = path.getOrDefault("projectId")
  valid_589212 = validateParameter(valid_589212, JString, required = true,
                                 default = nil)
  if valid_589212 != nil:
    section.add "projectId", valid_589212
  var valid_589213 = path.getOrDefault("clusterId")
  valid_589213 = validateParameter(valid_589213, JString, required = true,
                                 default = nil)
  if valid_589213 != nil:
    section.add "clusterId", valid_589213
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589214 = query.getOrDefault("upload_protocol")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "upload_protocol", valid_589214
  var valid_589215 = query.getOrDefault("fields")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "fields", valid_589215
  var valid_589216 = query.getOrDefault("quotaUser")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "quotaUser", valid_589216
  var valid_589217 = query.getOrDefault("alt")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = newJString("json"))
  if valid_589217 != nil:
    section.add "alt", valid_589217
  var valid_589218 = query.getOrDefault("pp")
  valid_589218 = validateParameter(valid_589218, JBool, required = false,
                                 default = newJBool(true))
  if valid_589218 != nil:
    section.add "pp", valid_589218
  var valid_589219 = query.getOrDefault("oauth_token")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "oauth_token", valid_589219
  var valid_589220 = query.getOrDefault("callback")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "callback", valid_589220
  var valid_589221 = query.getOrDefault("access_token")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "access_token", valid_589221
  var valid_589222 = query.getOrDefault("uploadType")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "uploadType", valid_589222
  var valid_589223 = query.getOrDefault("key")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "key", valid_589223
  var valid_589224 = query.getOrDefault("$.xgafv")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = newJString("1"))
  if valid_589224 != nil:
    section.add "$.xgafv", valid_589224
  var valid_589225 = query.getOrDefault("prettyPrint")
  valid_589225 = validateParameter(valid_589225, JBool, required = false,
                                 default = newJBool(true))
  if valid_589225 != nil:
    section.add "prettyPrint", valid_589225
  var valid_589226 = query.getOrDefault("bearer_token")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "bearer_token", valid_589226
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

proc call*(call_589228: Call_ContainerProjectsZonesClustersMaster_589208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master of a specific cluster.
  ## 
  let valid = call_589228.validator(path, query, header, formData, body)
  let scheme = call_589228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589228.url(scheme.get, call_589228.host, call_589228.base,
                         call_589228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589228, url, valid)

proc call*(call_589229: Call_ContainerProjectsZonesClustersMaster_589208;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersMaster
  ## Updates the master of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589230 = newJObject()
  var query_589231 = newJObject()
  var body_589232 = newJObject()
  add(query_589231, "upload_protocol", newJString(uploadProtocol))
  add(path_589230, "zone", newJString(zone))
  add(query_589231, "fields", newJString(fields))
  add(query_589231, "quotaUser", newJString(quotaUser))
  add(query_589231, "alt", newJString(alt))
  add(query_589231, "pp", newJBool(pp))
  add(query_589231, "oauth_token", newJString(oauthToken))
  add(query_589231, "callback", newJString(callback))
  add(query_589231, "access_token", newJString(accessToken))
  add(query_589231, "uploadType", newJString(uploadType))
  add(query_589231, "key", newJString(key))
  add(path_589230, "projectId", newJString(projectId))
  add(query_589231, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589232 = body
  add(query_589231, "prettyPrint", newJBool(prettyPrint))
  add(path_589230, "clusterId", newJString(clusterId))
  add(query_589231, "bearer_token", newJString(bearerToken))
  result = call_589229.call(path_589230, query_589231, nil, nil, body_589232)

var containerProjectsZonesClustersMaster* = Call_ContainerProjectsZonesClustersMaster_589208(
    name: "containerProjectsZonesClustersMaster", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/master",
    validator: validate_ContainerProjectsZonesClustersMaster_589209, base: "/",
    url: url_ContainerProjectsZonesClustersMaster_589210, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMonitoring_589233 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersMonitoring_589235(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/monitoring")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersMonitoring_589234(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the monitoring service of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589236 = path.getOrDefault("zone")
  valid_589236 = validateParameter(valid_589236, JString, required = true,
                                 default = nil)
  if valid_589236 != nil:
    section.add "zone", valid_589236
  var valid_589237 = path.getOrDefault("projectId")
  valid_589237 = validateParameter(valid_589237, JString, required = true,
                                 default = nil)
  if valid_589237 != nil:
    section.add "projectId", valid_589237
  var valid_589238 = path.getOrDefault("clusterId")
  valid_589238 = validateParameter(valid_589238, JString, required = true,
                                 default = nil)
  if valid_589238 != nil:
    section.add "clusterId", valid_589238
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589239 = query.getOrDefault("upload_protocol")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "upload_protocol", valid_589239
  var valid_589240 = query.getOrDefault("fields")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "fields", valid_589240
  var valid_589241 = query.getOrDefault("quotaUser")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "quotaUser", valid_589241
  var valid_589242 = query.getOrDefault("alt")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = newJString("json"))
  if valid_589242 != nil:
    section.add "alt", valid_589242
  var valid_589243 = query.getOrDefault("pp")
  valid_589243 = validateParameter(valid_589243, JBool, required = false,
                                 default = newJBool(true))
  if valid_589243 != nil:
    section.add "pp", valid_589243
  var valid_589244 = query.getOrDefault("oauth_token")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "oauth_token", valid_589244
  var valid_589245 = query.getOrDefault("callback")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "callback", valid_589245
  var valid_589246 = query.getOrDefault("access_token")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "access_token", valid_589246
  var valid_589247 = query.getOrDefault("uploadType")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "uploadType", valid_589247
  var valid_589248 = query.getOrDefault("key")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "key", valid_589248
  var valid_589249 = query.getOrDefault("$.xgafv")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = newJString("1"))
  if valid_589249 != nil:
    section.add "$.xgafv", valid_589249
  var valid_589250 = query.getOrDefault("prettyPrint")
  valid_589250 = validateParameter(valid_589250, JBool, required = false,
                                 default = newJBool(true))
  if valid_589250 != nil:
    section.add "prettyPrint", valid_589250
  var valid_589251 = query.getOrDefault("bearer_token")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "bearer_token", valid_589251
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

proc call*(call_589253: Call_ContainerProjectsZonesClustersMonitoring_589233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service of a specific cluster.
  ## 
  let valid = call_589253.validator(path, query, header, formData, body)
  let scheme = call_589253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589253.url(scheme.get, call_589253.host, call_589253.base,
                         call_589253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589253, url, valid)

proc call*(call_589254: Call_ContainerProjectsZonesClustersMonitoring_589233;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersMonitoring
  ## Sets the monitoring service of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589255 = newJObject()
  var query_589256 = newJObject()
  var body_589257 = newJObject()
  add(query_589256, "upload_protocol", newJString(uploadProtocol))
  add(path_589255, "zone", newJString(zone))
  add(query_589256, "fields", newJString(fields))
  add(query_589256, "quotaUser", newJString(quotaUser))
  add(query_589256, "alt", newJString(alt))
  add(query_589256, "pp", newJBool(pp))
  add(query_589256, "oauth_token", newJString(oauthToken))
  add(query_589256, "callback", newJString(callback))
  add(query_589256, "access_token", newJString(accessToken))
  add(query_589256, "uploadType", newJString(uploadType))
  add(query_589256, "key", newJString(key))
  add(path_589255, "projectId", newJString(projectId))
  add(query_589256, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589257 = body
  add(query_589256, "prettyPrint", newJBool(prettyPrint))
  add(path_589255, "clusterId", newJString(clusterId))
  add(query_589256, "bearer_token", newJString(bearerToken))
  result = call_589254.call(path_589255, query_589256, nil, nil, body_589257)

var containerProjectsZonesClustersMonitoring* = Call_ContainerProjectsZonesClustersMonitoring_589233(
    name: "containerProjectsZonesClustersMonitoring", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/monitoring",
    validator: validate_ContainerProjectsZonesClustersMonitoring_589234,
    base: "/", url: url_ContainerProjectsZonesClustersMonitoring_589235,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsCreate_589282 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsCreate_589284(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsCreate_589283(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a node pool for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589285 = path.getOrDefault("zone")
  valid_589285 = validateParameter(valid_589285, JString, required = true,
                                 default = nil)
  if valid_589285 != nil:
    section.add "zone", valid_589285
  var valid_589286 = path.getOrDefault("projectId")
  valid_589286 = validateParameter(valid_589286, JString, required = true,
                                 default = nil)
  if valid_589286 != nil:
    section.add "projectId", valid_589286
  var valid_589287 = path.getOrDefault("clusterId")
  valid_589287 = validateParameter(valid_589287, JString, required = true,
                                 default = nil)
  if valid_589287 != nil:
    section.add "clusterId", valid_589287
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589288 = query.getOrDefault("upload_protocol")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "upload_protocol", valid_589288
  var valid_589289 = query.getOrDefault("fields")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "fields", valid_589289
  var valid_589290 = query.getOrDefault("quotaUser")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "quotaUser", valid_589290
  var valid_589291 = query.getOrDefault("alt")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = newJString("json"))
  if valid_589291 != nil:
    section.add "alt", valid_589291
  var valid_589292 = query.getOrDefault("pp")
  valid_589292 = validateParameter(valid_589292, JBool, required = false,
                                 default = newJBool(true))
  if valid_589292 != nil:
    section.add "pp", valid_589292
  var valid_589293 = query.getOrDefault("oauth_token")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "oauth_token", valid_589293
  var valid_589294 = query.getOrDefault("callback")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "callback", valid_589294
  var valid_589295 = query.getOrDefault("access_token")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "access_token", valid_589295
  var valid_589296 = query.getOrDefault("uploadType")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "uploadType", valid_589296
  var valid_589297 = query.getOrDefault("key")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "key", valid_589297
  var valid_589298 = query.getOrDefault("$.xgafv")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = newJString("1"))
  if valid_589298 != nil:
    section.add "$.xgafv", valid_589298
  var valid_589299 = query.getOrDefault("prettyPrint")
  valid_589299 = validateParameter(valid_589299, JBool, required = false,
                                 default = newJBool(true))
  if valid_589299 != nil:
    section.add "prettyPrint", valid_589299
  var valid_589300 = query.getOrDefault("bearer_token")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "bearer_token", valid_589300
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

proc call*(call_589302: Call_ContainerProjectsZonesClustersNodePoolsCreate_589282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_589302.validator(path, query, header, formData, body)
  let scheme = call_589302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589302.url(scheme.get, call_589302.host, call_589302.base,
                         call_589302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589302, url, valid)

proc call*(call_589303: Call_ContainerProjectsZonesClustersNodePoolsCreate_589282;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsCreate
  ## Creates a node pool for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589304 = newJObject()
  var query_589305 = newJObject()
  var body_589306 = newJObject()
  add(query_589305, "upload_protocol", newJString(uploadProtocol))
  add(path_589304, "zone", newJString(zone))
  add(query_589305, "fields", newJString(fields))
  add(query_589305, "quotaUser", newJString(quotaUser))
  add(query_589305, "alt", newJString(alt))
  add(query_589305, "pp", newJBool(pp))
  add(query_589305, "oauth_token", newJString(oauthToken))
  add(query_589305, "callback", newJString(callback))
  add(query_589305, "access_token", newJString(accessToken))
  add(query_589305, "uploadType", newJString(uploadType))
  add(query_589305, "key", newJString(key))
  add(path_589304, "projectId", newJString(projectId))
  add(query_589305, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589306 = body
  add(query_589305, "prettyPrint", newJBool(prettyPrint))
  add(path_589304, "clusterId", newJString(clusterId))
  add(query_589305, "bearer_token", newJString(bearerToken))
  result = call_589303.call(path_589304, query_589305, nil, nil, body_589306)

var containerProjectsZonesClustersNodePoolsCreate* = Call_ContainerProjectsZonesClustersNodePoolsCreate_589282(
    name: "containerProjectsZonesClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsCreate_589283,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsCreate_589284,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsList_589258 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsList_589260(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsList_589259(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the node pools for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589261 = path.getOrDefault("zone")
  valid_589261 = validateParameter(valid_589261, JString, required = true,
                                 default = nil)
  if valid_589261 != nil:
    section.add "zone", valid_589261
  var valid_589262 = path.getOrDefault("projectId")
  valid_589262 = validateParameter(valid_589262, JString, required = true,
                                 default = nil)
  if valid_589262 != nil:
    section.add "projectId", valid_589262
  var valid_589263 = path.getOrDefault("clusterId")
  valid_589263 = validateParameter(valid_589263, JString, required = true,
                                 default = nil)
  if valid_589263 != nil:
    section.add "clusterId", valid_589263
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project, location, cluster id) where the node pools will be listed.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589264 = query.getOrDefault("upload_protocol")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "upload_protocol", valid_589264
  var valid_589265 = query.getOrDefault("fields")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "fields", valid_589265
  var valid_589266 = query.getOrDefault("quotaUser")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "quotaUser", valid_589266
  var valid_589267 = query.getOrDefault("alt")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = newJString("json"))
  if valid_589267 != nil:
    section.add "alt", valid_589267
  var valid_589268 = query.getOrDefault("pp")
  valid_589268 = validateParameter(valid_589268, JBool, required = false,
                                 default = newJBool(true))
  if valid_589268 != nil:
    section.add "pp", valid_589268
  var valid_589269 = query.getOrDefault("oauth_token")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "oauth_token", valid_589269
  var valid_589270 = query.getOrDefault("callback")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "callback", valid_589270
  var valid_589271 = query.getOrDefault("access_token")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "access_token", valid_589271
  var valid_589272 = query.getOrDefault("uploadType")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "uploadType", valid_589272
  var valid_589273 = query.getOrDefault("parent")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "parent", valid_589273
  var valid_589274 = query.getOrDefault("key")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "key", valid_589274
  var valid_589275 = query.getOrDefault("$.xgafv")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = newJString("1"))
  if valid_589275 != nil:
    section.add "$.xgafv", valid_589275
  var valid_589276 = query.getOrDefault("prettyPrint")
  valid_589276 = validateParameter(valid_589276, JBool, required = false,
                                 default = newJBool(true))
  if valid_589276 != nil:
    section.add "prettyPrint", valid_589276
  var valid_589277 = query.getOrDefault("bearer_token")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "bearer_token", valid_589277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589278: Call_ContainerProjectsZonesClustersNodePoolsList_589258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_589278.validator(path, query, header, formData, body)
  let scheme = call_589278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589278.url(scheme.get, call_589278.host, call_589278.base,
                         call_589278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589278, url, valid)

proc call*(call_589279: Call_ContainerProjectsZonesClustersNodePoolsList_589258;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          parent: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsList
  ## Lists the node pools for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project, location, cluster id) where the node pools will be listed.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589280 = newJObject()
  var query_589281 = newJObject()
  add(query_589281, "upload_protocol", newJString(uploadProtocol))
  add(path_589280, "zone", newJString(zone))
  add(query_589281, "fields", newJString(fields))
  add(query_589281, "quotaUser", newJString(quotaUser))
  add(query_589281, "alt", newJString(alt))
  add(query_589281, "pp", newJBool(pp))
  add(query_589281, "oauth_token", newJString(oauthToken))
  add(query_589281, "callback", newJString(callback))
  add(query_589281, "access_token", newJString(accessToken))
  add(query_589281, "uploadType", newJString(uploadType))
  add(query_589281, "parent", newJString(parent))
  add(query_589281, "key", newJString(key))
  add(path_589280, "projectId", newJString(projectId))
  add(query_589281, "$.xgafv", newJString(Xgafv))
  add(query_589281, "prettyPrint", newJBool(prettyPrint))
  add(path_589280, "clusterId", newJString(clusterId))
  add(query_589281, "bearer_token", newJString(bearerToken))
  result = call_589279.call(path_589280, query_589281, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsList* = Call_ContainerProjectsZonesClustersNodePoolsList_589258(
    name: "containerProjectsZonesClustersNodePoolsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsList_589259,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsList_589260,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsGet_589307 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsGet_589309(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsGet_589308(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the node pool requested.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589310 = path.getOrDefault("zone")
  valid_589310 = validateParameter(valid_589310, JString, required = true,
                                 default = nil)
  if valid_589310 != nil:
    section.add "zone", valid_589310
  var valid_589311 = path.getOrDefault("nodePoolId")
  valid_589311 = validateParameter(valid_589311, JString, required = true,
                                 default = nil)
  if valid_589311 != nil:
    section.add "nodePoolId", valid_589311
  var valid_589312 = path.getOrDefault("projectId")
  valid_589312 = validateParameter(valid_589312, JString, required = true,
                                 default = nil)
  if valid_589312 != nil:
    section.add "projectId", valid_589312
  var valid_589313 = path.getOrDefault("clusterId")
  valid_589313 = validateParameter(valid_589313, JString, required = true,
                                 default = nil)
  if valid_589313 != nil:
    section.add "clusterId", valid_589313
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project, location, cluster, node pool id) of the node pool to get.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589314 = query.getOrDefault("upload_protocol")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "upload_protocol", valid_589314
  var valid_589315 = query.getOrDefault("fields")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "fields", valid_589315
  var valid_589316 = query.getOrDefault("quotaUser")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "quotaUser", valid_589316
  var valid_589317 = query.getOrDefault("alt")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = newJString("json"))
  if valid_589317 != nil:
    section.add "alt", valid_589317
  var valid_589318 = query.getOrDefault("pp")
  valid_589318 = validateParameter(valid_589318, JBool, required = false,
                                 default = newJBool(true))
  if valid_589318 != nil:
    section.add "pp", valid_589318
  var valid_589319 = query.getOrDefault("oauth_token")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "oauth_token", valid_589319
  var valid_589320 = query.getOrDefault("callback")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "callback", valid_589320
  var valid_589321 = query.getOrDefault("access_token")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "access_token", valid_589321
  var valid_589322 = query.getOrDefault("uploadType")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "uploadType", valid_589322
  var valid_589323 = query.getOrDefault("key")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "key", valid_589323
  var valid_589324 = query.getOrDefault("name")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "name", valid_589324
  var valid_589325 = query.getOrDefault("$.xgafv")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = newJString("1"))
  if valid_589325 != nil:
    section.add "$.xgafv", valid_589325
  var valid_589326 = query.getOrDefault("prettyPrint")
  valid_589326 = validateParameter(valid_589326, JBool, required = false,
                                 default = newJBool(true))
  if valid_589326 != nil:
    section.add "prettyPrint", valid_589326
  var valid_589327 = query.getOrDefault("bearer_token")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "bearer_token", valid_589327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589328: Call_ContainerProjectsZonesClustersNodePoolsGet_589307;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the node pool requested.
  ## 
  let valid = call_589328.validator(path, query, header, formData, body)
  let scheme = call_589328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589328.url(scheme.get, call_589328.host, call_589328.base,
                         call_589328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589328, url, valid)

proc call*(call_589329: Call_ContainerProjectsZonesClustersNodePoolsGet_589307;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsGet
  ## Retrieves the node pool requested.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster, node pool id) of the node pool to get.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589330 = newJObject()
  var query_589331 = newJObject()
  add(query_589331, "upload_protocol", newJString(uploadProtocol))
  add(path_589330, "zone", newJString(zone))
  add(query_589331, "fields", newJString(fields))
  add(query_589331, "quotaUser", newJString(quotaUser))
  add(query_589331, "alt", newJString(alt))
  add(query_589331, "pp", newJBool(pp))
  add(query_589331, "oauth_token", newJString(oauthToken))
  add(query_589331, "callback", newJString(callback))
  add(query_589331, "access_token", newJString(accessToken))
  add(query_589331, "uploadType", newJString(uploadType))
  add(path_589330, "nodePoolId", newJString(nodePoolId))
  add(query_589331, "key", newJString(key))
  add(query_589331, "name", newJString(name))
  add(path_589330, "projectId", newJString(projectId))
  add(query_589331, "$.xgafv", newJString(Xgafv))
  add(query_589331, "prettyPrint", newJBool(prettyPrint))
  add(path_589330, "clusterId", newJString(clusterId))
  add(query_589331, "bearer_token", newJString(bearerToken))
  result = call_589329.call(path_589330, query_589331, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsGet* = Call_ContainerProjectsZonesClustersNodePoolsGet_589307(
    name: "containerProjectsZonesClustersNodePoolsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsGet_589308,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsGet_589309,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsDelete_589332 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsDelete_589334(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsDelete_589333(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a node pool from a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589335 = path.getOrDefault("zone")
  valid_589335 = validateParameter(valid_589335, JString, required = true,
                                 default = nil)
  if valid_589335 != nil:
    section.add "zone", valid_589335
  var valid_589336 = path.getOrDefault("nodePoolId")
  valid_589336 = validateParameter(valid_589336, JString, required = true,
                                 default = nil)
  if valid_589336 != nil:
    section.add "nodePoolId", valid_589336
  var valid_589337 = path.getOrDefault("projectId")
  valid_589337 = validateParameter(valid_589337, JString, required = true,
                                 default = nil)
  if valid_589337 != nil:
    section.add "projectId", valid_589337
  var valid_589338 = path.getOrDefault("clusterId")
  valid_589338 = validateParameter(valid_589338, JString, required = true,
                                 default = nil)
  if valid_589338 != nil:
    section.add "clusterId", valid_589338
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project, location, cluster, node pool id) of the node pool to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589339 = query.getOrDefault("upload_protocol")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "upload_protocol", valid_589339
  var valid_589340 = query.getOrDefault("fields")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "fields", valid_589340
  var valid_589341 = query.getOrDefault("quotaUser")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "quotaUser", valid_589341
  var valid_589342 = query.getOrDefault("alt")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = newJString("json"))
  if valid_589342 != nil:
    section.add "alt", valid_589342
  var valid_589343 = query.getOrDefault("pp")
  valid_589343 = validateParameter(valid_589343, JBool, required = false,
                                 default = newJBool(true))
  if valid_589343 != nil:
    section.add "pp", valid_589343
  var valid_589344 = query.getOrDefault("oauth_token")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "oauth_token", valid_589344
  var valid_589345 = query.getOrDefault("callback")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "callback", valid_589345
  var valid_589346 = query.getOrDefault("access_token")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "access_token", valid_589346
  var valid_589347 = query.getOrDefault("uploadType")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "uploadType", valid_589347
  var valid_589348 = query.getOrDefault("key")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "key", valid_589348
  var valid_589349 = query.getOrDefault("name")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "name", valid_589349
  var valid_589350 = query.getOrDefault("$.xgafv")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = newJString("1"))
  if valid_589350 != nil:
    section.add "$.xgafv", valid_589350
  var valid_589351 = query.getOrDefault("prettyPrint")
  valid_589351 = validateParameter(valid_589351, JBool, required = false,
                                 default = newJBool(true))
  if valid_589351 != nil:
    section.add "prettyPrint", valid_589351
  var valid_589352 = query.getOrDefault("bearer_token")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "bearer_token", valid_589352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589353: Call_ContainerProjectsZonesClustersNodePoolsDelete_589332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_589353.validator(path, query, header, formData, body)
  let scheme = call_589353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589353.url(scheme.get, call_589353.host, call_589353.base,
                         call_589353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589353, url, valid)

proc call*(call_589354: Call_ContainerProjectsZonesClustersNodePoolsDelete_589332;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster, node pool id) of the node pool to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589355 = newJObject()
  var query_589356 = newJObject()
  add(query_589356, "upload_protocol", newJString(uploadProtocol))
  add(path_589355, "zone", newJString(zone))
  add(query_589356, "fields", newJString(fields))
  add(query_589356, "quotaUser", newJString(quotaUser))
  add(query_589356, "alt", newJString(alt))
  add(query_589356, "pp", newJBool(pp))
  add(query_589356, "oauth_token", newJString(oauthToken))
  add(query_589356, "callback", newJString(callback))
  add(query_589356, "access_token", newJString(accessToken))
  add(query_589356, "uploadType", newJString(uploadType))
  add(path_589355, "nodePoolId", newJString(nodePoolId))
  add(query_589356, "key", newJString(key))
  add(query_589356, "name", newJString(name))
  add(path_589355, "projectId", newJString(projectId))
  add(query_589356, "$.xgafv", newJString(Xgafv))
  add(query_589356, "prettyPrint", newJBool(prettyPrint))
  add(path_589355, "clusterId", newJString(clusterId))
  add(query_589356, "bearer_token", newJString(bearerToken))
  result = call_589354.call(path_589355, query_589356, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsDelete* = Call_ContainerProjectsZonesClustersNodePoolsDelete_589332(
    name: "containerProjectsZonesClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsDelete_589333,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsDelete_589334,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_589357 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsAutoscaling_589359(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId"),
               (kind: ConstantSegment, value: "/autoscaling")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_589358(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589360 = path.getOrDefault("zone")
  valid_589360 = validateParameter(valid_589360, JString, required = true,
                                 default = nil)
  if valid_589360 != nil:
    section.add "zone", valid_589360
  var valid_589361 = path.getOrDefault("nodePoolId")
  valid_589361 = validateParameter(valid_589361, JString, required = true,
                                 default = nil)
  if valid_589361 != nil:
    section.add "nodePoolId", valid_589361
  var valid_589362 = path.getOrDefault("projectId")
  valid_589362 = validateParameter(valid_589362, JString, required = true,
                                 default = nil)
  if valid_589362 != nil:
    section.add "projectId", valid_589362
  var valid_589363 = path.getOrDefault("clusterId")
  valid_589363 = validateParameter(valid_589363, JString, required = true,
                                 default = nil)
  if valid_589363 != nil:
    section.add "clusterId", valid_589363
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589364 = query.getOrDefault("upload_protocol")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "upload_protocol", valid_589364
  var valid_589365 = query.getOrDefault("fields")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "fields", valid_589365
  var valid_589366 = query.getOrDefault("quotaUser")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "quotaUser", valid_589366
  var valid_589367 = query.getOrDefault("alt")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = newJString("json"))
  if valid_589367 != nil:
    section.add "alt", valid_589367
  var valid_589368 = query.getOrDefault("pp")
  valid_589368 = validateParameter(valid_589368, JBool, required = false,
                                 default = newJBool(true))
  if valid_589368 != nil:
    section.add "pp", valid_589368
  var valid_589369 = query.getOrDefault("oauth_token")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "oauth_token", valid_589369
  var valid_589370 = query.getOrDefault("callback")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "callback", valid_589370
  var valid_589371 = query.getOrDefault("access_token")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "access_token", valid_589371
  var valid_589372 = query.getOrDefault("uploadType")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "uploadType", valid_589372
  var valid_589373 = query.getOrDefault("key")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "key", valid_589373
  var valid_589374 = query.getOrDefault("$.xgafv")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = newJString("1"))
  if valid_589374 != nil:
    section.add "$.xgafv", valid_589374
  var valid_589375 = query.getOrDefault("prettyPrint")
  valid_589375 = validateParameter(valid_589375, JBool, required = false,
                                 default = newJBool(true))
  if valid_589375 != nil:
    section.add "prettyPrint", valid_589375
  var valid_589376 = query.getOrDefault("bearer_token")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "bearer_token", valid_589376
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

proc call*(call_589378: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_589357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  let valid = call_589378.validator(path, query, header, formData, body)
  let scheme = call_589378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589378.url(scheme.get, call_589378.host, call_589378.base,
                         call_589378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589378, url, valid)

proc call*(call_589379: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_589357;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsAutoscaling
  ## Sets the autoscaling settings of a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589380 = newJObject()
  var query_589381 = newJObject()
  var body_589382 = newJObject()
  add(query_589381, "upload_protocol", newJString(uploadProtocol))
  add(path_589380, "zone", newJString(zone))
  add(query_589381, "fields", newJString(fields))
  add(query_589381, "quotaUser", newJString(quotaUser))
  add(query_589381, "alt", newJString(alt))
  add(query_589381, "pp", newJBool(pp))
  add(query_589381, "oauth_token", newJString(oauthToken))
  add(query_589381, "callback", newJString(callback))
  add(query_589381, "access_token", newJString(accessToken))
  add(query_589381, "uploadType", newJString(uploadType))
  add(path_589380, "nodePoolId", newJString(nodePoolId))
  add(query_589381, "key", newJString(key))
  add(path_589380, "projectId", newJString(projectId))
  add(query_589381, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589382 = body
  add(query_589381, "prettyPrint", newJBool(prettyPrint))
  add(path_589380, "clusterId", newJString(clusterId))
  add(query_589381, "bearer_token", newJString(bearerToken))
  result = call_589379.call(path_589380, query_589381, nil, nil, body_589382)

var containerProjectsZonesClustersNodePoolsAutoscaling* = Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_589357(
    name: "containerProjectsZonesClustersNodePoolsAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/autoscaling",
    validator: validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_589358,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsAutoscaling_589359,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetManagement_589383 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsSetManagement_589385(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId"),
               (kind: ConstantSegment, value: "/setManagement")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsSetManagement_589384(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the NodeManagement options for a node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to update.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589386 = path.getOrDefault("zone")
  valid_589386 = validateParameter(valid_589386, JString, required = true,
                                 default = nil)
  if valid_589386 != nil:
    section.add "zone", valid_589386
  var valid_589387 = path.getOrDefault("nodePoolId")
  valid_589387 = validateParameter(valid_589387, JString, required = true,
                                 default = nil)
  if valid_589387 != nil:
    section.add "nodePoolId", valid_589387
  var valid_589388 = path.getOrDefault("projectId")
  valid_589388 = validateParameter(valid_589388, JString, required = true,
                                 default = nil)
  if valid_589388 != nil:
    section.add "projectId", valid_589388
  var valid_589389 = path.getOrDefault("clusterId")
  valid_589389 = validateParameter(valid_589389, JString, required = true,
                                 default = nil)
  if valid_589389 != nil:
    section.add "clusterId", valid_589389
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589390 = query.getOrDefault("upload_protocol")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "upload_protocol", valid_589390
  var valid_589391 = query.getOrDefault("fields")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "fields", valid_589391
  var valid_589392 = query.getOrDefault("quotaUser")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "quotaUser", valid_589392
  var valid_589393 = query.getOrDefault("alt")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = newJString("json"))
  if valid_589393 != nil:
    section.add "alt", valid_589393
  var valid_589394 = query.getOrDefault("pp")
  valid_589394 = validateParameter(valid_589394, JBool, required = false,
                                 default = newJBool(true))
  if valid_589394 != nil:
    section.add "pp", valid_589394
  var valid_589395 = query.getOrDefault("oauth_token")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "oauth_token", valid_589395
  var valid_589396 = query.getOrDefault("callback")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "callback", valid_589396
  var valid_589397 = query.getOrDefault("access_token")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "access_token", valid_589397
  var valid_589398 = query.getOrDefault("uploadType")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "uploadType", valid_589398
  var valid_589399 = query.getOrDefault("key")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "key", valid_589399
  var valid_589400 = query.getOrDefault("$.xgafv")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = newJString("1"))
  if valid_589400 != nil:
    section.add "$.xgafv", valid_589400
  var valid_589401 = query.getOrDefault("prettyPrint")
  valid_589401 = validateParameter(valid_589401, JBool, required = false,
                                 default = newJBool(true))
  if valid_589401 != nil:
    section.add "prettyPrint", valid_589401
  var valid_589402 = query.getOrDefault("bearer_token")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "bearer_token", valid_589402
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

proc call*(call_589404: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_589383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_589404.validator(path, query, header, formData, body)
  let scheme = call_589404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589404.url(scheme.get, call_589404.host, call_589404.base,
                         call_589404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589404, url, valid)

proc call*(call_589405: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_589383;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsSetManagement
  ## Sets the NodeManagement options for a node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to update.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589406 = newJObject()
  var query_589407 = newJObject()
  var body_589408 = newJObject()
  add(query_589407, "upload_protocol", newJString(uploadProtocol))
  add(path_589406, "zone", newJString(zone))
  add(query_589407, "fields", newJString(fields))
  add(query_589407, "quotaUser", newJString(quotaUser))
  add(query_589407, "alt", newJString(alt))
  add(query_589407, "pp", newJBool(pp))
  add(query_589407, "oauth_token", newJString(oauthToken))
  add(query_589407, "callback", newJString(callback))
  add(query_589407, "access_token", newJString(accessToken))
  add(query_589407, "uploadType", newJString(uploadType))
  add(path_589406, "nodePoolId", newJString(nodePoolId))
  add(query_589407, "key", newJString(key))
  add(path_589406, "projectId", newJString(projectId))
  add(query_589407, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589408 = body
  add(query_589407, "prettyPrint", newJBool(prettyPrint))
  add(path_589406, "clusterId", newJString(clusterId))
  add(query_589407, "bearer_token", newJString(bearerToken))
  result = call_589405.call(path_589406, query_589407, nil, nil, body_589408)

var containerProjectsZonesClustersNodePoolsSetManagement* = Call_ContainerProjectsZonesClustersNodePoolsSetManagement_589383(
    name: "containerProjectsZonesClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setManagement",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetManagement_589384,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetManagement_589385,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsUpdate_589409 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsUpdate_589411(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId"),
               (kind: ConstantSegment, value: "/update")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsUpdate_589410(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589412 = path.getOrDefault("zone")
  valid_589412 = validateParameter(valid_589412, JString, required = true,
                                 default = nil)
  if valid_589412 != nil:
    section.add "zone", valid_589412
  var valid_589413 = path.getOrDefault("nodePoolId")
  valid_589413 = validateParameter(valid_589413, JString, required = true,
                                 default = nil)
  if valid_589413 != nil:
    section.add "nodePoolId", valid_589413
  var valid_589414 = path.getOrDefault("projectId")
  valid_589414 = validateParameter(valid_589414, JString, required = true,
                                 default = nil)
  if valid_589414 != nil:
    section.add "projectId", valid_589414
  var valid_589415 = path.getOrDefault("clusterId")
  valid_589415 = validateParameter(valid_589415, JString, required = true,
                                 default = nil)
  if valid_589415 != nil:
    section.add "clusterId", valid_589415
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589416 = query.getOrDefault("upload_protocol")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "upload_protocol", valid_589416
  var valid_589417 = query.getOrDefault("fields")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "fields", valid_589417
  var valid_589418 = query.getOrDefault("quotaUser")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "quotaUser", valid_589418
  var valid_589419 = query.getOrDefault("alt")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = newJString("json"))
  if valid_589419 != nil:
    section.add "alt", valid_589419
  var valid_589420 = query.getOrDefault("pp")
  valid_589420 = validateParameter(valid_589420, JBool, required = false,
                                 default = newJBool(true))
  if valid_589420 != nil:
    section.add "pp", valid_589420
  var valid_589421 = query.getOrDefault("oauth_token")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "oauth_token", valid_589421
  var valid_589422 = query.getOrDefault("callback")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "callback", valid_589422
  var valid_589423 = query.getOrDefault("access_token")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "access_token", valid_589423
  var valid_589424 = query.getOrDefault("uploadType")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "uploadType", valid_589424
  var valid_589425 = query.getOrDefault("key")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "key", valid_589425
  var valid_589426 = query.getOrDefault("$.xgafv")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = newJString("1"))
  if valid_589426 != nil:
    section.add "$.xgafv", valid_589426
  var valid_589427 = query.getOrDefault("prettyPrint")
  valid_589427 = validateParameter(valid_589427, JBool, required = false,
                                 default = newJBool(true))
  if valid_589427 != nil:
    section.add "prettyPrint", valid_589427
  var valid_589428 = query.getOrDefault("bearer_token")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = nil)
  if valid_589428 != nil:
    section.add "bearer_token", valid_589428
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

proc call*(call_589430: Call_ContainerProjectsZonesClustersNodePoolsUpdate_589409;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  let valid = call_589430.validator(path, query, header, formData, body)
  let scheme = call_589430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589430.url(scheme.get, call_589430.host, call_589430.base,
                         call_589430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589430, url, valid)

proc call*(call_589431: Call_ContainerProjectsZonesClustersNodePoolsUpdate_589409;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsUpdate
  ## Updates the version and/or iamge type of a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589432 = newJObject()
  var query_589433 = newJObject()
  var body_589434 = newJObject()
  add(query_589433, "upload_protocol", newJString(uploadProtocol))
  add(path_589432, "zone", newJString(zone))
  add(query_589433, "fields", newJString(fields))
  add(query_589433, "quotaUser", newJString(quotaUser))
  add(query_589433, "alt", newJString(alt))
  add(query_589433, "pp", newJBool(pp))
  add(query_589433, "oauth_token", newJString(oauthToken))
  add(query_589433, "callback", newJString(callback))
  add(query_589433, "access_token", newJString(accessToken))
  add(query_589433, "uploadType", newJString(uploadType))
  add(path_589432, "nodePoolId", newJString(nodePoolId))
  add(query_589433, "key", newJString(key))
  add(path_589432, "projectId", newJString(projectId))
  add(query_589433, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589434 = body
  add(query_589433, "prettyPrint", newJBool(prettyPrint))
  add(path_589432, "clusterId", newJString(clusterId))
  add(query_589433, "bearer_token", newJString(bearerToken))
  result = call_589431.call(path_589432, query_589433, nil, nil, body_589434)

var containerProjectsZonesClustersNodePoolsUpdate* = Call_ContainerProjectsZonesClustersNodePoolsUpdate_589409(
    name: "containerProjectsZonesClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/update",
    validator: validate_ContainerProjectsZonesClustersNodePoolsUpdate_589410,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsUpdate_589411,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsRollback_589435 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsRollback_589437(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId"),
               (kind: ConstantSegment, value: ":rollback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsRollback_589436(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to rollback.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to rollback.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589438 = path.getOrDefault("zone")
  valid_589438 = validateParameter(valid_589438, JString, required = true,
                                 default = nil)
  if valid_589438 != nil:
    section.add "zone", valid_589438
  var valid_589439 = path.getOrDefault("nodePoolId")
  valid_589439 = validateParameter(valid_589439, JString, required = true,
                                 default = nil)
  if valid_589439 != nil:
    section.add "nodePoolId", valid_589439
  var valid_589440 = path.getOrDefault("projectId")
  valid_589440 = validateParameter(valid_589440, JString, required = true,
                                 default = nil)
  if valid_589440 != nil:
    section.add "projectId", valid_589440
  var valid_589441 = path.getOrDefault("clusterId")
  valid_589441 = validateParameter(valid_589441, JString, required = true,
                                 default = nil)
  if valid_589441 != nil:
    section.add "clusterId", valid_589441
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589442 = query.getOrDefault("upload_protocol")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "upload_protocol", valid_589442
  var valid_589443 = query.getOrDefault("fields")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "fields", valid_589443
  var valid_589444 = query.getOrDefault("quotaUser")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "quotaUser", valid_589444
  var valid_589445 = query.getOrDefault("alt")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = newJString("json"))
  if valid_589445 != nil:
    section.add "alt", valid_589445
  var valid_589446 = query.getOrDefault("pp")
  valid_589446 = validateParameter(valid_589446, JBool, required = false,
                                 default = newJBool(true))
  if valid_589446 != nil:
    section.add "pp", valid_589446
  var valid_589447 = query.getOrDefault("oauth_token")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = nil)
  if valid_589447 != nil:
    section.add "oauth_token", valid_589447
  var valid_589448 = query.getOrDefault("callback")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = nil)
  if valid_589448 != nil:
    section.add "callback", valid_589448
  var valid_589449 = query.getOrDefault("access_token")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "access_token", valid_589449
  var valid_589450 = query.getOrDefault("uploadType")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "uploadType", valid_589450
  var valid_589451 = query.getOrDefault("key")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "key", valid_589451
  var valid_589452 = query.getOrDefault("$.xgafv")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = newJString("1"))
  if valid_589452 != nil:
    section.add "$.xgafv", valid_589452
  var valid_589453 = query.getOrDefault("prettyPrint")
  valid_589453 = validateParameter(valid_589453, JBool, required = false,
                                 default = newJBool(true))
  if valid_589453 != nil:
    section.add "prettyPrint", valid_589453
  var valid_589454 = query.getOrDefault("bearer_token")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "bearer_token", valid_589454
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

proc call*(call_589456: Call_ContainerProjectsZonesClustersNodePoolsRollback_589435;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  let valid = call_589456.validator(path, query, header, formData, body)
  let scheme = call_589456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589456.url(scheme.get, call_589456.host, call_589456.base,
                         call_589456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589456, url, valid)

proc call*(call_589457: Call_ContainerProjectsZonesClustersNodePoolsRollback_589435;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsRollback
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to rollback.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to rollback.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589458 = newJObject()
  var query_589459 = newJObject()
  var body_589460 = newJObject()
  add(query_589459, "upload_protocol", newJString(uploadProtocol))
  add(path_589458, "zone", newJString(zone))
  add(query_589459, "fields", newJString(fields))
  add(query_589459, "quotaUser", newJString(quotaUser))
  add(query_589459, "alt", newJString(alt))
  add(query_589459, "pp", newJBool(pp))
  add(query_589459, "oauth_token", newJString(oauthToken))
  add(query_589459, "callback", newJString(callback))
  add(query_589459, "access_token", newJString(accessToken))
  add(query_589459, "uploadType", newJString(uploadType))
  add(path_589458, "nodePoolId", newJString(nodePoolId))
  add(query_589459, "key", newJString(key))
  add(path_589458, "projectId", newJString(projectId))
  add(query_589459, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589460 = body
  add(query_589459, "prettyPrint", newJBool(prettyPrint))
  add(path_589458, "clusterId", newJString(clusterId))
  add(query_589459, "bearer_token", newJString(bearerToken))
  result = call_589457.call(path_589458, query_589459, nil, nil, body_589460)

var containerProjectsZonesClustersNodePoolsRollback* = Call_ContainerProjectsZonesClustersNodePoolsRollback_589435(
    name: "containerProjectsZonesClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}:rollback",
    validator: validate_ContainerProjectsZonesClustersNodePoolsRollback_589436,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsRollback_589437,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersResourceLabels_589461 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersResourceLabels_589463(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/resourceLabels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersResourceLabels_589462(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets labels on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589464 = path.getOrDefault("zone")
  valid_589464 = validateParameter(valid_589464, JString, required = true,
                                 default = nil)
  if valid_589464 != nil:
    section.add "zone", valid_589464
  var valid_589465 = path.getOrDefault("projectId")
  valid_589465 = validateParameter(valid_589465, JString, required = true,
                                 default = nil)
  if valid_589465 != nil:
    section.add "projectId", valid_589465
  var valid_589466 = path.getOrDefault("clusterId")
  valid_589466 = validateParameter(valid_589466, JString, required = true,
                                 default = nil)
  if valid_589466 != nil:
    section.add "clusterId", valid_589466
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589467 = query.getOrDefault("upload_protocol")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = nil)
  if valid_589467 != nil:
    section.add "upload_protocol", valid_589467
  var valid_589468 = query.getOrDefault("fields")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "fields", valid_589468
  var valid_589469 = query.getOrDefault("quotaUser")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "quotaUser", valid_589469
  var valid_589470 = query.getOrDefault("alt")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = newJString("json"))
  if valid_589470 != nil:
    section.add "alt", valid_589470
  var valid_589471 = query.getOrDefault("pp")
  valid_589471 = validateParameter(valid_589471, JBool, required = false,
                                 default = newJBool(true))
  if valid_589471 != nil:
    section.add "pp", valid_589471
  var valid_589472 = query.getOrDefault("oauth_token")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "oauth_token", valid_589472
  var valid_589473 = query.getOrDefault("callback")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "callback", valid_589473
  var valid_589474 = query.getOrDefault("access_token")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "access_token", valid_589474
  var valid_589475 = query.getOrDefault("uploadType")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "uploadType", valid_589475
  var valid_589476 = query.getOrDefault("key")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "key", valid_589476
  var valid_589477 = query.getOrDefault("$.xgafv")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = newJString("1"))
  if valid_589477 != nil:
    section.add "$.xgafv", valid_589477
  var valid_589478 = query.getOrDefault("prettyPrint")
  valid_589478 = validateParameter(valid_589478, JBool, required = false,
                                 default = newJBool(true))
  if valid_589478 != nil:
    section.add "prettyPrint", valid_589478
  var valid_589479 = query.getOrDefault("bearer_token")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "bearer_token", valid_589479
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

proc call*(call_589481: Call_ContainerProjectsZonesClustersResourceLabels_589461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_589481.validator(path, query, header, formData, body)
  let scheme = call_589481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589481.url(scheme.get, call_589481.host, call_589481.base,
                         call_589481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589481, url, valid)

proc call*(call_589482: Call_ContainerProjectsZonesClustersResourceLabels_589461;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersResourceLabels
  ## Sets labels on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589483 = newJObject()
  var query_589484 = newJObject()
  var body_589485 = newJObject()
  add(query_589484, "upload_protocol", newJString(uploadProtocol))
  add(path_589483, "zone", newJString(zone))
  add(query_589484, "fields", newJString(fields))
  add(query_589484, "quotaUser", newJString(quotaUser))
  add(query_589484, "alt", newJString(alt))
  add(query_589484, "pp", newJBool(pp))
  add(query_589484, "oauth_token", newJString(oauthToken))
  add(query_589484, "callback", newJString(callback))
  add(query_589484, "access_token", newJString(accessToken))
  add(query_589484, "uploadType", newJString(uploadType))
  add(query_589484, "key", newJString(key))
  add(path_589483, "projectId", newJString(projectId))
  add(query_589484, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589485 = body
  add(query_589484, "prettyPrint", newJBool(prettyPrint))
  add(path_589483, "clusterId", newJString(clusterId))
  add(query_589484, "bearer_token", newJString(bearerToken))
  result = call_589482.call(path_589483, query_589484, nil, nil, body_589485)

var containerProjectsZonesClustersResourceLabels* = Call_ContainerProjectsZonesClustersResourceLabels_589461(
    name: "containerProjectsZonesClustersResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/resourceLabels",
    validator: validate_ContainerProjectsZonesClustersResourceLabels_589462,
    base: "/", url: url_ContainerProjectsZonesClustersResourceLabels_589463,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersCompleteIpRotation_589486 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersCompleteIpRotation_589488(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: ":completeIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersCompleteIpRotation_589487(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Completes master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589489 = path.getOrDefault("zone")
  valid_589489 = validateParameter(valid_589489, JString, required = true,
                                 default = nil)
  if valid_589489 != nil:
    section.add "zone", valid_589489
  var valid_589490 = path.getOrDefault("projectId")
  valid_589490 = validateParameter(valid_589490, JString, required = true,
                                 default = nil)
  if valid_589490 != nil:
    section.add "projectId", valid_589490
  var valid_589491 = path.getOrDefault("clusterId")
  valid_589491 = validateParameter(valid_589491, JString, required = true,
                                 default = nil)
  if valid_589491 != nil:
    section.add "clusterId", valid_589491
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589492 = query.getOrDefault("upload_protocol")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = nil)
  if valid_589492 != nil:
    section.add "upload_protocol", valid_589492
  var valid_589493 = query.getOrDefault("fields")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "fields", valid_589493
  var valid_589494 = query.getOrDefault("quotaUser")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "quotaUser", valid_589494
  var valid_589495 = query.getOrDefault("alt")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = newJString("json"))
  if valid_589495 != nil:
    section.add "alt", valid_589495
  var valid_589496 = query.getOrDefault("pp")
  valid_589496 = validateParameter(valid_589496, JBool, required = false,
                                 default = newJBool(true))
  if valid_589496 != nil:
    section.add "pp", valid_589496
  var valid_589497 = query.getOrDefault("oauth_token")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "oauth_token", valid_589497
  var valid_589498 = query.getOrDefault("callback")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "callback", valid_589498
  var valid_589499 = query.getOrDefault("access_token")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "access_token", valid_589499
  var valid_589500 = query.getOrDefault("uploadType")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "uploadType", valid_589500
  var valid_589501 = query.getOrDefault("key")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "key", valid_589501
  var valid_589502 = query.getOrDefault("$.xgafv")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = newJString("1"))
  if valid_589502 != nil:
    section.add "$.xgafv", valid_589502
  var valid_589503 = query.getOrDefault("prettyPrint")
  valid_589503 = validateParameter(valid_589503, JBool, required = false,
                                 default = newJBool(true))
  if valid_589503 != nil:
    section.add "prettyPrint", valid_589503
  var valid_589504 = query.getOrDefault("bearer_token")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "bearer_token", valid_589504
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

proc call*(call_589506: Call_ContainerProjectsZonesClustersCompleteIpRotation_589486;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_589506.validator(path, query, header, formData, body)
  let scheme = call_589506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589506.url(scheme.get, call_589506.host, call_589506.base,
                         call_589506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589506, url, valid)

proc call*(call_589507: Call_ContainerProjectsZonesClustersCompleteIpRotation_589486;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589508 = newJObject()
  var query_589509 = newJObject()
  var body_589510 = newJObject()
  add(query_589509, "upload_protocol", newJString(uploadProtocol))
  add(path_589508, "zone", newJString(zone))
  add(query_589509, "fields", newJString(fields))
  add(query_589509, "quotaUser", newJString(quotaUser))
  add(query_589509, "alt", newJString(alt))
  add(query_589509, "pp", newJBool(pp))
  add(query_589509, "oauth_token", newJString(oauthToken))
  add(query_589509, "callback", newJString(callback))
  add(query_589509, "access_token", newJString(accessToken))
  add(query_589509, "uploadType", newJString(uploadType))
  add(query_589509, "key", newJString(key))
  add(path_589508, "projectId", newJString(projectId))
  add(query_589509, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589510 = body
  add(query_589509, "prettyPrint", newJBool(prettyPrint))
  add(path_589508, "clusterId", newJString(clusterId))
  add(query_589509, "bearer_token", newJString(bearerToken))
  result = call_589507.call(path_589508, query_589509, nil, nil, body_589510)

var containerProjectsZonesClustersCompleteIpRotation* = Call_ContainerProjectsZonesClustersCompleteIpRotation_589486(
    name: "containerProjectsZonesClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:completeIpRotation",
    validator: validate_ContainerProjectsZonesClustersCompleteIpRotation_589487,
    base: "/", url: url_ContainerProjectsZonesClustersCompleteIpRotation_589488,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMaintenancePolicy_589511 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersSetMaintenancePolicy_589513(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: ":setMaintenancePolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersSetMaintenancePolicy_589512(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the maintenance policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   clusterId: JString (required)
  ##            : The name of the cluster to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589514 = path.getOrDefault("zone")
  valid_589514 = validateParameter(valid_589514, JString, required = true,
                                 default = nil)
  if valid_589514 != nil:
    section.add "zone", valid_589514
  var valid_589515 = path.getOrDefault("projectId")
  valid_589515 = validateParameter(valid_589515, JString, required = true,
                                 default = nil)
  if valid_589515 != nil:
    section.add "projectId", valid_589515
  var valid_589516 = path.getOrDefault("clusterId")
  valid_589516 = validateParameter(valid_589516, JString, required = true,
                                 default = nil)
  if valid_589516 != nil:
    section.add "clusterId", valid_589516
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589517 = query.getOrDefault("upload_protocol")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "upload_protocol", valid_589517
  var valid_589518 = query.getOrDefault("fields")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "fields", valid_589518
  var valid_589519 = query.getOrDefault("quotaUser")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "quotaUser", valid_589519
  var valid_589520 = query.getOrDefault("alt")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = newJString("json"))
  if valid_589520 != nil:
    section.add "alt", valid_589520
  var valid_589521 = query.getOrDefault("pp")
  valid_589521 = validateParameter(valid_589521, JBool, required = false,
                                 default = newJBool(true))
  if valid_589521 != nil:
    section.add "pp", valid_589521
  var valid_589522 = query.getOrDefault("oauth_token")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "oauth_token", valid_589522
  var valid_589523 = query.getOrDefault("callback")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "callback", valid_589523
  var valid_589524 = query.getOrDefault("access_token")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "access_token", valid_589524
  var valid_589525 = query.getOrDefault("uploadType")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "uploadType", valid_589525
  var valid_589526 = query.getOrDefault("key")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "key", valid_589526
  var valid_589527 = query.getOrDefault("$.xgafv")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = newJString("1"))
  if valid_589527 != nil:
    section.add "$.xgafv", valid_589527
  var valid_589528 = query.getOrDefault("prettyPrint")
  valid_589528 = validateParameter(valid_589528, JBool, required = false,
                                 default = newJBool(true))
  if valid_589528 != nil:
    section.add "prettyPrint", valid_589528
  var valid_589529 = query.getOrDefault("bearer_token")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = nil)
  if valid_589529 != nil:
    section.add "bearer_token", valid_589529
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

proc call*(call_589531: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_589511;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_589531.validator(path, query, header, formData, body)
  let scheme = call_589531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589531.url(scheme.get, call_589531.host, call_589531.base,
                         call_589531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589531, url, valid)

proc call*(call_589532: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_589511;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersSetMaintenancePolicy
  ## Sets the maintenance policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to update.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589533 = newJObject()
  var query_589534 = newJObject()
  var body_589535 = newJObject()
  add(query_589534, "upload_protocol", newJString(uploadProtocol))
  add(path_589533, "zone", newJString(zone))
  add(query_589534, "fields", newJString(fields))
  add(query_589534, "quotaUser", newJString(quotaUser))
  add(query_589534, "alt", newJString(alt))
  add(query_589534, "pp", newJBool(pp))
  add(query_589534, "oauth_token", newJString(oauthToken))
  add(query_589534, "callback", newJString(callback))
  add(query_589534, "access_token", newJString(accessToken))
  add(query_589534, "uploadType", newJString(uploadType))
  add(query_589534, "key", newJString(key))
  add(path_589533, "projectId", newJString(projectId))
  add(query_589534, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589535 = body
  add(query_589534, "prettyPrint", newJBool(prettyPrint))
  add(path_589533, "clusterId", newJString(clusterId))
  add(query_589534, "bearer_token", newJString(bearerToken))
  result = call_589532.call(path_589533, query_589534, nil, nil, body_589535)

var containerProjectsZonesClustersSetMaintenancePolicy* = Call_ContainerProjectsZonesClustersSetMaintenancePolicy_589511(
    name: "containerProjectsZonesClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMaintenancePolicy",
    validator: validate_ContainerProjectsZonesClustersSetMaintenancePolicy_589512,
    base: "/", url: url_ContainerProjectsZonesClustersSetMaintenancePolicy_589513,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMasterAuth_589536 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersSetMasterAuth_589538(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: ":setMasterAuth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersSetMasterAuth_589537(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589539 = path.getOrDefault("zone")
  valid_589539 = validateParameter(valid_589539, JString, required = true,
                                 default = nil)
  if valid_589539 != nil:
    section.add "zone", valid_589539
  var valid_589540 = path.getOrDefault("projectId")
  valid_589540 = validateParameter(valid_589540, JString, required = true,
                                 default = nil)
  if valid_589540 != nil:
    section.add "projectId", valid_589540
  var valid_589541 = path.getOrDefault("clusterId")
  valid_589541 = validateParameter(valid_589541, JString, required = true,
                                 default = nil)
  if valid_589541 != nil:
    section.add "clusterId", valid_589541
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589542 = query.getOrDefault("upload_protocol")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "upload_protocol", valid_589542
  var valid_589543 = query.getOrDefault("fields")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "fields", valid_589543
  var valid_589544 = query.getOrDefault("quotaUser")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "quotaUser", valid_589544
  var valid_589545 = query.getOrDefault("alt")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = newJString("json"))
  if valid_589545 != nil:
    section.add "alt", valid_589545
  var valid_589546 = query.getOrDefault("pp")
  valid_589546 = validateParameter(valid_589546, JBool, required = false,
                                 default = newJBool(true))
  if valid_589546 != nil:
    section.add "pp", valid_589546
  var valid_589547 = query.getOrDefault("oauth_token")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "oauth_token", valid_589547
  var valid_589548 = query.getOrDefault("callback")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = nil)
  if valid_589548 != nil:
    section.add "callback", valid_589548
  var valid_589549 = query.getOrDefault("access_token")
  valid_589549 = validateParameter(valid_589549, JString, required = false,
                                 default = nil)
  if valid_589549 != nil:
    section.add "access_token", valid_589549
  var valid_589550 = query.getOrDefault("uploadType")
  valid_589550 = validateParameter(valid_589550, JString, required = false,
                                 default = nil)
  if valid_589550 != nil:
    section.add "uploadType", valid_589550
  var valid_589551 = query.getOrDefault("key")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = nil)
  if valid_589551 != nil:
    section.add "key", valid_589551
  var valid_589552 = query.getOrDefault("$.xgafv")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = newJString("1"))
  if valid_589552 != nil:
    section.add "$.xgafv", valid_589552
  var valid_589553 = query.getOrDefault("prettyPrint")
  valid_589553 = validateParameter(valid_589553, JBool, required = false,
                                 default = newJBool(true))
  if valid_589553 != nil:
    section.add "prettyPrint", valid_589553
  var valid_589554 = query.getOrDefault("bearer_token")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = nil)
  if valid_589554 != nil:
    section.add "bearer_token", valid_589554
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

proc call*(call_589556: Call_ContainerProjectsZonesClustersSetMasterAuth_589536;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  let valid = call_589556.validator(path, query, header, formData, body)
  let scheme = call_589556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589556.url(scheme.get, call_589556.host, call_589556.base,
                         call_589556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589556, url, valid)

proc call*(call_589557: Call_ContainerProjectsZonesClustersSetMasterAuth_589536;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersSetMasterAuth
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589558 = newJObject()
  var query_589559 = newJObject()
  var body_589560 = newJObject()
  add(query_589559, "upload_protocol", newJString(uploadProtocol))
  add(path_589558, "zone", newJString(zone))
  add(query_589559, "fields", newJString(fields))
  add(query_589559, "quotaUser", newJString(quotaUser))
  add(query_589559, "alt", newJString(alt))
  add(query_589559, "pp", newJBool(pp))
  add(query_589559, "oauth_token", newJString(oauthToken))
  add(query_589559, "callback", newJString(callback))
  add(query_589559, "access_token", newJString(accessToken))
  add(query_589559, "uploadType", newJString(uploadType))
  add(query_589559, "key", newJString(key))
  add(path_589558, "projectId", newJString(projectId))
  add(query_589559, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589560 = body
  add(query_589559, "prettyPrint", newJBool(prettyPrint))
  add(path_589558, "clusterId", newJString(clusterId))
  add(query_589559, "bearer_token", newJString(bearerToken))
  result = call_589557.call(path_589558, query_589559, nil, nil, body_589560)

var containerProjectsZonesClustersSetMasterAuth* = Call_ContainerProjectsZonesClustersSetMasterAuth_589536(
    name: "containerProjectsZonesClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMasterAuth",
    validator: validate_ContainerProjectsZonesClustersSetMasterAuth_589537,
    base: "/", url: url_ContainerProjectsZonesClustersSetMasterAuth_589538,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetNetworkPolicy_589561 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersSetNetworkPolicy_589563(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: ":setNetworkPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersSetNetworkPolicy_589562(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589564 = path.getOrDefault("zone")
  valid_589564 = validateParameter(valid_589564, JString, required = true,
                                 default = nil)
  if valid_589564 != nil:
    section.add "zone", valid_589564
  var valid_589565 = path.getOrDefault("projectId")
  valid_589565 = validateParameter(valid_589565, JString, required = true,
                                 default = nil)
  if valid_589565 != nil:
    section.add "projectId", valid_589565
  var valid_589566 = path.getOrDefault("clusterId")
  valid_589566 = validateParameter(valid_589566, JString, required = true,
                                 default = nil)
  if valid_589566 != nil:
    section.add "clusterId", valid_589566
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589567 = query.getOrDefault("upload_protocol")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = nil)
  if valid_589567 != nil:
    section.add "upload_protocol", valid_589567
  var valid_589568 = query.getOrDefault("fields")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = nil)
  if valid_589568 != nil:
    section.add "fields", valid_589568
  var valid_589569 = query.getOrDefault("quotaUser")
  valid_589569 = validateParameter(valid_589569, JString, required = false,
                                 default = nil)
  if valid_589569 != nil:
    section.add "quotaUser", valid_589569
  var valid_589570 = query.getOrDefault("alt")
  valid_589570 = validateParameter(valid_589570, JString, required = false,
                                 default = newJString("json"))
  if valid_589570 != nil:
    section.add "alt", valid_589570
  var valid_589571 = query.getOrDefault("pp")
  valid_589571 = validateParameter(valid_589571, JBool, required = false,
                                 default = newJBool(true))
  if valid_589571 != nil:
    section.add "pp", valid_589571
  var valid_589572 = query.getOrDefault("oauth_token")
  valid_589572 = validateParameter(valid_589572, JString, required = false,
                                 default = nil)
  if valid_589572 != nil:
    section.add "oauth_token", valid_589572
  var valid_589573 = query.getOrDefault("callback")
  valid_589573 = validateParameter(valid_589573, JString, required = false,
                                 default = nil)
  if valid_589573 != nil:
    section.add "callback", valid_589573
  var valid_589574 = query.getOrDefault("access_token")
  valid_589574 = validateParameter(valid_589574, JString, required = false,
                                 default = nil)
  if valid_589574 != nil:
    section.add "access_token", valid_589574
  var valid_589575 = query.getOrDefault("uploadType")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = nil)
  if valid_589575 != nil:
    section.add "uploadType", valid_589575
  var valid_589576 = query.getOrDefault("key")
  valid_589576 = validateParameter(valid_589576, JString, required = false,
                                 default = nil)
  if valid_589576 != nil:
    section.add "key", valid_589576
  var valid_589577 = query.getOrDefault("$.xgafv")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = newJString("1"))
  if valid_589577 != nil:
    section.add "$.xgafv", valid_589577
  var valid_589578 = query.getOrDefault("prettyPrint")
  valid_589578 = validateParameter(valid_589578, JBool, required = false,
                                 default = newJBool(true))
  if valid_589578 != nil:
    section.add "prettyPrint", valid_589578
  var valid_589579 = query.getOrDefault("bearer_token")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "bearer_token", valid_589579
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

proc call*(call_589581: Call_ContainerProjectsZonesClustersSetNetworkPolicy_589561;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  let valid = call_589581.validator(path, query, header, formData, body)
  let scheme = call_589581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589581.url(scheme.get, call_589581.host, call_589581.base,
                         call_589581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589581, url, valid)

proc call*(call_589582: Call_ContainerProjectsZonesClustersSetNetworkPolicy_589561;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersSetNetworkPolicy
  ## Enables/Disables Network Policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589583 = newJObject()
  var query_589584 = newJObject()
  var body_589585 = newJObject()
  add(query_589584, "upload_protocol", newJString(uploadProtocol))
  add(path_589583, "zone", newJString(zone))
  add(query_589584, "fields", newJString(fields))
  add(query_589584, "quotaUser", newJString(quotaUser))
  add(query_589584, "alt", newJString(alt))
  add(query_589584, "pp", newJBool(pp))
  add(query_589584, "oauth_token", newJString(oauthToken))
  add(query_589584, "callback", newJString(callback))
  add(query_589584, "access_token", newJString(accessToken))
  add(query_589584, "uploadType", newJString(uploadType))
  add(query_589584, "key", newJString(key))
  add(path_589583, "projectId", newJString(projectId))
  add(query_589584, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589585 = body
  add(query_589584, "prettyPrint", newJBool(prettyPrint))
  add(path_589583, "clusterId", newJString(clusterId))
  add(query_589584, "bearer_token", newJString(bearerToken))
  result = call_589582.call(path_589583, query_589584, nil, nil, body_589585)

var containerProjectsZonesClustersSetNetworkPolicy* = Call_ContainerProjectsZonesClustersSetNetworkPolicy_589561(
    name: "containerProjectsZonesClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setNetworkPolicy",
    validator: validate_ContainerProjectsZonesClustersSetNetworkPolicy_589562,
    base: "/", url: url_ContainerProjectsZonesClustersSetNetworkPolicy_589563,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersStartIpRotation_589586 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersStartIpRotation_589588(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: ":startIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersStartIpRotation_589587(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Start master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589589 = path.getOrDefault("zone")
  valid_589589 = validateParameter(valid_589589, JString, required = true,
                                 default = nil)
  if valid_589589 != nil:
    section.add "zone", valid_589589
  var valid_589590 = path.getOrDefault("projectId")
  valid_589590 = validateParameter(valid_589590, JString, required = true,
                                 default = nil)
  if valid_589590 != nil:
    section.add "projectId", valid_589590
  var valid_589591 = path.getOrDefault("clusterId")
  valid_589591 = validateParameter(valid_589591, JString, required = true,
                                 default = nil)
  if valid_589591 != nil:
    section.add "clusterId", valid_589591
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589592 = query.getOrDefault("upload_protocol")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = nil)
  if valid_589592 != nil:
    section.add "upload_protocol", valid_589592
  var valid_589593 = query.getOrDefault("fields")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = nil)
  if valid_589593 != nil:
    section.add "fields", valid_589593
  var valid_589594 = query.getOrDefault("quotaUser")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = nil)
  if valid_589594 != nil:
    section.add "quotaUser", valid_589594
  var valid_589595 = query.getOrDefault("alt")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = newJString("json"))
  if valid_589595 != nil:
    section.add "alt", valid_589595
  var valid_589596 = query.getOrDefault("pp")
  valid_589596 = validateParameter(valid_589596, JBool, required = false,
                                 default = newJBool(true))
  if valid_589596 != nil:
    section.add "pp", valid_589596
  var valid_589597 = query.getOrDefault("oauth_token")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "oauth_token", valid_589597
  var valid_589598 = query.getOrDefault("callback")
  valid_589598 = validateParameter(valid_589598, JString, required = false,
                                 default = nil)
  if valid_589598 != nil:
    section.add "callback", valid_589598
  var valid_589599 = query.getOrDefault("access_token")
  valid_589599 = validateParameter(valid_589599, JString, required = false,
                                 default = nil)
  if valid_589599 != nil:
    section.add "access_token", valid_589599
  var valid_589600 = query.getOrDefault("uploadType")
  valid_589600 = validateParameter(valid_589600, JString, required = false,
                                 default = nil)
  if valid_589600 != nil:
    section.add "uploadType", valid_589600
  var valid_589601 = query.getOrDefault("key")
  valid_589601 = validateParameter(valid_589601, JString, required = false,
                                 default = nil)
  if valid_589601 != nil:
    section.add "key", valid_589601
  var valid_589602 = query.getOrDefault("$.xgafv")
  valid_589602 = validateParameter(valid_589602, JString, required = false,
                                 default = newJString("1"))
  if valid_589602 != nil:
    section.add "$.xgafv", valid_589602
  var valid_589603 = query.getOrDefault("prettyPrint")
  valid_589603 = validateParameter(valid_589603, JBool, required = false,
                                 default = newJBool(true))
  if valid_589603 != nil:
    section.add "prettyPrint", valid_589603
  var valid_589604 = query.getOrDefault("bearer_token")
  valid_589604 = validateParameter(valid_589604, JString, required = false,
                                 default = nil)
  if valid_589604 != nil:
    section.add "bearer_token", valid_589604
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

proc call*(call_589606: Call_ContainerProjectsZonesClustersStartIpRotation_589586;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start master IP rotation.
  ## 
  let valid = call_589606.validator(path, query, header, formData, body)
  let scheme = call_589606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589606.url(scheme.get, call_589606.host, call_589606.base,
                         call_589606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589606, url, valid)

proc call*(call_589607: Call_ContainerProjectsZonesClustersStartIpRotation_589586;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersStartIpRotation
  ## Start master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589608 = newJObject()
  var query_589609 = newJObject()
  var body_589610 = newJObject()
  add(query_589609, "upload_protocol", newJString(uploadProtocol))
  add(path_589608, "zone", newJString(zone))
  add(query_589609, "fields", newJString(fields))
  add(query_589609, "quotaUser", newJString(quotaUser))
  add(query_589609, "alt", newJString(alt))
  add(query_589609, "pp", newJBool(pp))
  add(query_589609, "oauth_token", newJString(oauthToken))
  add(query_589609, "callback", newJString(callback))
  add(query_589609, "access_token", newJString(accessToken))
  add(query_589609, "uploadType", newJString(uploadType))
  add(query_589609, "key", newJString(key))
  add(path_589608, "projectId", newJString(projectId))
  add(query_589609, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589610 = body
  add(query_589609, "prettyPrint", newJBool(prettyPrint))
  add(path_589608, "clusterId", newJString(clusterId))
  add(query_589609, "bearer_token", newJString(bearerToken))
  result = call_589607.call(path_589608, query_589609, nil, nil, body_589610)

var containerProjectsZonesClustersStartIpRotation* = Call_ContainerProjectsZonesClustersStartIpRotation_589586(
    name: "containerProjectsZonesClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:startIpRotation",
    validator: validate_ContainerProjectsZonesClustersStartIpRotation_589587,
    base: "/", url: url_ContainerProjectsZonesClustersStartIpRotation_589588,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsList_589611 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesOperationsList_589613(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsList_589612(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589614 = path.getOrDefault("zone")
  valid_589614 = validateParameter(valid_589614, JString, required = true,
                                 default = nil)
  if valid_589614 != nil:
    section.add "zone", valid_589614
  var valid_589615 = path.getOrDefault("projectId")
  valid_589615 = validateParameter(valid_589615, JString, required = true,
                                 default = nil)
  if valid_589615 != nil:
    section.add "projectId", valid_589615
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project and location) where the operations will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589616 = query.getOrDefault("upload_protocol")
  valid_589616 = validateParameter(valid_589616, JString, required = false,
                                 default = nil)
  if valid_589616 != nil:
    section.add "upload_protocol", valid_589616
  var valid_589617 = query.getOrDefault("fields")
  valid_589617 = validateParameter(valid_589617, JString, required = false,
                                 default = nil)
  if valid_589617 != nil:
    section.add "fields", valid_589617
  var valid_589618 = query.getOrDefault("quotaUser")
  valid_589618 = validateParameter(valid_589618, JString, required = false,
                                 default = nil)
  if valid_589618 != nil:
    section.add "quotaUser", valid_589618
  var valid_589619 = query.getOrDefault("alt")
  valid_589619 = validateParameter(valid_589619, JString, required = false,
                                 default = newJString("json"))
  if valid_589619 != nil:
    section.add "alt", valid_589619
  var valid_589620 = query.getOrDefault("pp")
  valid_589620 = validateParameter(valid_589620, JBool, required = false,
                                 default = newJBool(true))
  if valid_589620 != nil:
    section.add "pp", valid_589620
  var valid_589621 = query.getOrDefault("oauth_token")
  valid_589621 = validateParameter(valid_589621, JString, required = false,
                                 default = nil)
  if valid_589621 != nil:
    section.add "oauth_token", valid_589621
  var valid_589622 = query.getOrDefault("callback")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = nil)
  if valid_589622 != nil:
    section.add "callback", valid_589622
  var valid_589623 = query.getOrDefault("access_token")
  valid_589623 = validateParameter(valid_589623, JString, required = false,
                                 default = nil)
  if valid_589623 != nil:
    section.add "access_token", valid_589623
  var valid_589624 = query.getOrDefault("uploadType")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = nil)
  if valid_589624 != nil:
    section.add "uploadType", valid_589624
  var valid_589625 = query.getOrDefault("parent")
  valid_589625 = validateParameter(valid_589625, JString, required = false,
                                 default = nil)
  if valid_589625 != nil:
    section.add "parent", valid_589625
  var valid_589626 = query.getOrDefault("key")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "key", valid_589626
  var valid_589627 = query.getOrDefault("$.xgafv")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = newJString("1"))
  if valid_589627 != nil:
    section.add "$.xgafv", valid_589627
  var valid_589628 = query.getOrDefault("prettyPrint")
  valid_589628 = validateParameter(valid_589628, JBool, required = false,
                                 default = newJBool(true))
  if valid_589628 != nil:
    section.add "prettyPrint", valid_589628
  var valid_589629 = query.getOrDefault("bearer_token")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "bearer_token", valid_589629
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589630: Call_ContainerProjectsZonesOperationsList_589611;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_589630.validator(path, query, header, formData, body)
  let scheme = call_589630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589630.url(scheme.get, call_589630.host, call_589630.base,
                         call_589630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589630, url, valid)

proc call*(call_589631: Call_ContainerProjectsZonesOperationsList_589611;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; parent: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## containerProjectsZonesOperationsList
  ## Lists all operations in a project in a specific zone or all zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project and location) where the operations will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589632 = newJObject()
  var query_589633 = newJObject()
  add(query_589633, "upload_protocol", newJString(uploadProtocol))
  add(path_589632, "zone", newJString(zone))
  add(query_589633, "fields", newJString(fields))
  add(query_589633, "quotaUser", newJString(quotaUser))
  add(query_589633, "alt", newJString(alt))
  add(query_589633, "pp", newJBool(pp))
  add(query_589633, "oauth_token", newJString(oauthToken))
  add(query_589633, "callback", newJString(callback))
  add(query_589633, "access_token", newJString(accessToken))
  add(query_589633, "uploadType", newJString(uploadType))
  add(query_589633, "parent", newJString(parent))
  add(query_589633, "key", newJString(key))
  add(path_589632, "projectId", newJString(projectId))
  add(query_589633, "$.xgafv", newJString(Xgafv))
  add(query_589633, "prettyPrint", newJBool(prettyPrint))
  add(query_589633, "bearer_token", newJString(bearerToken))
  result = call_589631.call(path_589632, query_589633, nil, nil, nil)

var containerProjectsZonesOperationsList* = Call_ContainerProjectsZonesOperationsList_589611(
    name: "containerProjectsZonesOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/operations",
    validator: validate_ContainerProjectsZonesOperationsList_589612, base: "/",
    url: url_ContainerProjectsZonesOperationsList_589613, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsGet_589634 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesOperationsGet_589636(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsGet_589635(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   operationId: JString (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589637 = path.getOrDefault("zone")
  valid_589637 = validateParameter(valid_589637, JString, required = true,
                                 default = nil)
  if valid_589637 != nil:
    section.add "zone", valid_589637
  var valid_589638 = path.getOrDefault("projectId")
  valid_589638 = validateParameter(valid_589638, JString, required = true,
                                 default = nil)
  if valid_589638 != nil:
    section.add "projectId", valid_589638
  var valid_589639 = path.getOrDefault("operationId")
  valid_589639 = validateParameter(valid_589639, JString, required = true,
                                 default = nil)
  if valid_589639 != nil:
    section.add "operationId", valid_589639
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project, location, operation id) of the operation to get.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589640 = query.getOrDefault("upload_protocol")
  valid_589640 = validateParameter(valid_589640, JString, required = false,
                                 default = nil)
  if valid_589640 != nil:
    section.add "upload_protocol", valid_589640
  var valid_589641 = query.getOrDefault("fields")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = nil)
  if valid_589641 != nil:
    section.add "fields", valid_589641
  var valid_589642 = query.getOrDefault("quotaUser")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = nil)
  if valid_589642 != nil:
    section.add "quotaUser", valid_589642
  var valid_589643 = query.getOrDefault("alt")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = newJString("json"))
  if valid_589643 != nil:
    section.add "alt", valid_589643
  var valid_589644 = query.getOrDefault("pp")
  valid_589644 = validateParameter(valid_589644, JBool, required = false,
                                 default = newJBool(true))
  if valid_589644 != nil:
    section.add "pp", valid_589644
  var valid_589645 = query.getOrDefault("oauth_token")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = nil)
  if valid_589645 != nil:
    section.add "oauth_token", valid_589645
  var valid_589646 = query.getOrDefault("callback")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "callback", valid_589646
  var valid_589647 = query.getOrDefault("access_token")
  valid_589647 = validateParameter(valid_589647, JString, required = false,
                                 default = nil)
  if valid_589647 != nil:
    section.add "access_token", valid_589647
  var valid_589648 = query.getOrDefault("uploadType")
  valid_589648 = validateParameter(valid_589648, JString, required = false,
                                 default = nil)
  if valid_589648 != nil:
    section.add "uploadType", valid_589648
  var valid_589649 = query.getOrDefault("key")
  valid_589649 = validateParameter(valid_589649, JString, required = false,
                                 default = nil)
  if valid_589649 != nil:
    section.add "key", valid_589649
  var valid_589650 = query.getOrDefault("name")
  valid_589650 = validateParameter(valid_589650, JString, required = false,
                                 default = nil)
  if valid_589650 != nil:
    section.add "name", valid_589650
  var valid_589651 = query.getOrDefault("$.xgafv")
  valid_589651 = validateParameter(valid_589651, JString, required = false,
                                 default = newJString("1"))
  if valid_589651 != nil:
    section.add "$.xgafv", valid_589651
  var valid_589652 = query.getOrDefault("prettyPrint")
  valid_589652 = validateParameter(valid_589652, JBool, required = false,
                                 default = newJBool(true))
  if valid_589652 != nil:
    section.add "prettyPrint", valid_589652
  var valid_589653 = query.getOrDefault("bearer_token")
  valid_589653 = validateParameter(valid_589653, JString, required = false,
                                 default = nil)
  if valid_589653 != nil:
    section.add "bearer_token", valid_589653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589654: Call_ContainerProjectsZonesOperationsGet_589634;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified operation.
  ## 
  let valid = call_589654.validator(path, query, header, formData, body)
  let scheme = call_589654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589654.url(scheme.get, call_589654.host, call_589654.base,
                         call_589654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589654, url, valid)

proc call*(call_589655: Call_ContainerProjectsZonesOperationsGet_589634;
          zone: string; projectId: string; operationId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesOperationsGet
  ## Gets the specified operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, operation id) of the operation to get.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   operationId: string (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589656 = newJObject()
  var query_589657 = newJObject()
  add(query_589657, "upload_protocol", newJString(uploadProtocol))
  add(path_589656, "zone", newJString(zone))
  add(query_589657, "fields", newJString(fields))
  add(query_589657, "quotaUser", newJString(quotaUser))
  add(query_589657, "alt", newJString(alt))
  add(query_589657, "pp", newJBool(pp))
  add(query_589657, "oauth_token", newJString(oauthToken))
  add(query_589657, "callback", newJString(callback))
  add(query_589657, "access_token", newJString(accessToken))
  add(query_589657, "uploadType", newJString(uploadType))
  add(query_589657, "key", newJString(key))
  add(query_589657, "name", newJString(name))
  add(path_589656, "projectId", newJString(projectId))
  add(query_589657, "$.xgafv", newJString(Xgafv))
  add(query_589657, "prettyPrint", newJBool(prettyPrint))
  add(path_589656, "operationId", newJString(operationId))
  add(query_589657, "bearer_token", newJString(bearerToken))
  result = call_589655.call(path_589656, query_589657, nil, nil, nil)

var containerProjectsZonesOperationsGet* = Call_ContainerProjectsZonesOperationsGet_589634(
    name: "containerProjectsZonesOperationsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/operations/{operationId}",
    validator: validate_ContainerProjectsZonesOperationsGet_589635, base: "/",
    url: url_ContainerProjectsZonesOperationsGet_589636, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsCancel_589658 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesOperationsCancel_589660(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsCancel_589659(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   operationId: JString (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589661 = path.getOrDefault("zone")
  valid_589661 = validateParameter(valid_589661, JString, required = true,
                                 default = nil)
  if valid_589661 != nil:
    section.add "zone", valid_589661
  var valid_589662 = path.getOrDefault("projectId")
  valid_589662 = validateParameter(valid_589662, JString, required = true,
                                 default = nil)
  if valid_589662 != nil:
    section.add "projectId", valid_589662
  var valid_589663 = path.getOrDefault("operationId")
  valid_589663 = validateParameter(valid_589663, JString, required = true,
                                 default = nil)
  if valid_589663 != nil:
    section.add "operationId", valid_589663
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589664 = query.getOrDefault("upload_protocol")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "upload_protocol", valid_589664
  var valid_589665 = query.getOrDefault("fields")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = nil)
  if valid_589665 != nil:
    section.add "fields", valid_589665
  var valid_589666 = query.getOrDefault("quotaUser")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "quotaUser", valid_589666
  var valid_589667 = query.getOrDefault("alt")
  valid_589667 = validateParameter(valid_589667, JString, required = false,
                                 default = newJString("json"))
  if valid_589667 != nil:
    section.add "alt", valid_589667
  var valid_589668 = query.getOrDefault("pp")
  valid_589668 = validateParameter(valid_589668, JBool, required = false,
                                 default = newJBool(true))
  if valid_589668 != nil:
    section.add "pp", valid_589668
  var valid_589669 = query.getOrDefault("oauth_token")
  valid_589669 = validateParameter(valid_589669, JString, required = false,
                                 default = nil)
  if valid_589669 != nil:
    section.add "oauth_token", valid_589669
  var valid_589670 = query.getOrDefault("callback")
  valid_589670 = validateParameter(valid_589670, JString, required = false,
                                 default = nil)
  if valid_589670 != nil:
    section.add "callback", valid_589670
  var valid_589671 = query.getOrDefault("access_token")
  valid_589671 = validateParameter(valid_589671, JString, required = false,
                                 default = nil)
  if valid_589671 != nil:
    section.add "access_token", valid_589671
  var valid_589672 = query.getOrDefault("uploadType")
  valid_589672 = validateParameter(valid_589672, JString, required = false,
                                 default = nil)
  if valid_589672 != nil:
    section.add "uploadType", valid_589672
  var valid_589673 = query.getOrDefault("key")
  valid_589673 = validateParameter(valid_589673, JString, required = false,
                                 default = nil)
  if valid_589673 != nil:
    section.add "key", valid_589673
  var valid_589674 = query.getOrDefault("$.xgafv")
  valid_589674 = validateParameter(valid_589674, JString, required = false,
                                 default = newJString("1"))
  if valid_589674 != nil:
    section.add "$.xgafv", valid_589674
  var valid_589675 = query.getOrDefault("prettyPrint")
  valid_589675 = validateParameter(valid_589675, JBool, required = false,
                                 default = newJBool(true))
  if valid_589675 != nil:
    section.add "prettyPrint", valid_589675
  var valid_589676 = query.getOrDefault("bearer_token")
  valid_589676 = validateParameter(valid_589676, JString, required = false,
                                 default = nil)
  if valid_589676 != nil:
    section.add "bearer_token", valid_589676
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

proc call*(call_589678: Call_ContainerProjectsZonesOperationsCancel_589658;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_589678.validator(path, query, header, formData, body)
  let scheme = call_589678.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589678.url(scheme.get, call_589678.host, call_589678.base,
                         call_589678.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589678, url, valid)

proc call*(call_589679: Call_ContainerProjectsZonesOperationsCancel_589658;
          zone: string; projectId: string; operationId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesOperationsCancel
  ## Cancels the specified operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   operationId: string (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589680 = newJObject()
  var query_589681 = newJObject()
  var body_589682 = newJObject()
  add(query_589681, "upload_protocol", newJString(uploadProtocol))
  add(path_589680, "zone", newJString(zone))
  add(query_589681, "fields", newJString(fields))
  add(query_589681, "quotaUser", newJString(quotaUser))
  add(query_589681, "alt", newJString(alt))
  add(query_589681, "pp", newJBool(pp))
  add(query_589681, "oauth_token", newJString(oauthToken))
  add(query_589681, "callback", newJString(callback))
  add(query_589681, "access_token", newJString(accessToken))
  add(query_589681, "uploadType", newJString(uploadType))
  add(query_589681, "key", newJString(key))
  add(path_589680, "projectId", newJString(projectId))
  add(query_589681, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589682 = body
  add(query_589681, "prettyPrint", newJBool(prettyPrint))
  add(path_589680, "operationId", newJString(operationId))
  add(query_589681, "bearer_token", newJString(bearerToken))
  result = call_589679.call(path_589680, query_589681, nil, nil, body_589682)

var containerProjectsZonesOperationsCancel* = Call_ContainerProjectsZonesOperationsCancel_589658(
    name: "containerProjectsZonesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/operations/{operationId}:cancel",
    validator: validate_ContainerProjectsZonesOperationsCancel_589659, base: "/",
    url: url_ContainerProjectsZonesOperationsCancel_589660,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesGetServerconfig_589683 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesGetServerconfig_589685(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/serverconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesGetServerconfig_589684(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns configuration info about the Container Engine service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589686 = path.getOrDefault("zone")
  valid_589686 = validateParameter(valid_589686, JString, required = true,
                                 default = nil)
  if valid_589686 != nil:
    section.add "zone", valid_589686
  var valid_589687 = path.getOrDefault("projectId")
  valid_589687 = validateParameter(valid_589687, JString, required = true,
                                 default = nil)
  if valid_589687 != nil:
    section.add "projectId", valid_589687
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project and location) of the server config to get
  ## Specified in the format 'projects/*/locations/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589688 = query.getOrDefault("upload_protocol")
  valid_589688 = validateParameter(valid_589688, JString, required = false,
                                 default = nil)
  if valid_589688 != nil:
    section.add "upload_protocol", valid_589688
  var valid_589689 = query.getOrDefault("fields")
  valid_589689 = validateParameter(valid_589689, JString, required = false,
                                 default = nil)
  if valid_589689 != nil:
    section.add "fields", valid_589689
  var valid_589690 = query.getOrDefault("quotaUser")
  valid_589690 = validateParameter(valid_589690, JString, required = false,
                                 default = nil)
  if valid_589690 != nil:
    section.add "quotaUser", valid_589690
  var valid_589691 = query.getOrDefault("alt")
  valid_589691 = validateParameter(valid_589691, JString, required = false,
                                 default = newJString("json"))
  if valid_589691 != nil:
    section.add "alt", valid_589691
  var valid_589692 = query.getOrDefault("pp")
  valid_589692 = validateParameter(valid_589692, JBool, required = false,
                                 default = newJBool(true))
  if valid_589692 != nil:
    section.add "pp", valid_589692
  var valid_589693 = query.getOrDefault("oauth_token")
  valid_589693 = validateParameter(valid_589693, JString, required = false,
                                 default = nil)
  if valid_589693 != nil:
    section.add "oauth_token", valid_589693
  var valid_589694 = query.getOrDefault("callback")
  valid_589694 = validateParameter(valid_589694, JString, required = false,
                                 default = nil)
  if valid_589694 != nil:
    section.add "callback", valid_589694
  var valid_589695 = query.getOrDefault("access_token")
  valid_589695 = validateParameter(valid_589695, JString, required = false,
                                 default = nil)
  if valid_589695 != nil:
    section.add "access_token", valid_589695
  var valid_589696 = query.getOrDefault("uploadType")
  valid_589696 = validateParameter(valid_589696, JString, required = false,
                                 default = nil)
  if valid_589696 != nil:
    section.add "uploadType", valid_589696
  var valid_589697 = query.getOrDefault("key")
  valid_589697 = validateParameter(valid_589697, JString, required = false,
                                 default = nil)
  if valid_589697 != nil:
    section.add "key", valid_589697
  var valid_589698 = query.getOrDefault("name")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = nil)
  if valid_589698 != nil:
    section.add "name", valid_589698
  var valid_589699 = query.getOrDefault("$.xgafv")
  valid_589699 = validateParameter(valid_589699, JString, required = false,
                                 default = newJString("1"))
  if valid_589699 != nil:
    section.add "$.xgafv", valid_589699
  var valid_589700 = query.getOrDefault("prettyPrint")
  valid_589700 = validateParameter(valid_589700, JBool, required = false,
                                 default = newJBool(true))
  if valid_589700 != nil:
    section.add "prettyPrint", valid_589700
  var valid_589701 = query.getOrDefault("bearer_token")
  valid_589701 = validateParameter(valid_589701, JString, required = false,
                                 default = nil)
  if valid_589701 != nil:
    section.add "bearer_token", valid_589701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589702: Call_ContainerProjectsZonesGetServerconfig_589683;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Container Engine service.
  ## 
  let valid = call_589702.validator(path, query, header, formData, body)
  let scheme = call_589702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589702.url(scheme.get, call_589702.host, call_589702.base,
                         call_589702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589702, url, valid)

proc call*(call_589703: Call_ContainerProjectsZonesGetServerconfig_589683;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## containerProjectsZonesGetServerconfig
  ## Returns configuration info about the Container Engine service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project and location) of the server config to get
  ## Specified in the format 'projects/*/locations/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589704 = newJObject()
  var query_589705 = newJObject()
  add(query_589705, "upload_protocol", newJString(uploadProtocol))
  add(path_589704, "zone", newJString(zone))
  add(query_589705, "fields", newJString(fields))
  add(query_589705, "quotaUser", newJString(quotaUser))
  add(query_589705, "alt", newJString(alt))
  add(query_589705, "pp", newJBool(pp))
  add(query_589705, "oauth_token", newJString(oauthToken))
  add(query_589705, "callback", newJString(callback))
  add(query_589705, "access_token", newJString(accessToken))
  add(query_589705, "uploadType", newJString(uploadType))
  add(query_589705, "key", newJString(key))
  add(query_589705, "name", newJString(name))
  add(path_589704, "projectId", newJString(projectId))
  add(query_589705, "$.xgafv", newJString(Xgafv))
  add(query_589705, "prettyPrint", newJBool(prettyPrint))
  add(query_589705, "bearer_token", newJString(bearerToken))
  result = call_589703.call(path_589704, query_589705, nil, nil, nil)

var containerProjectsZonesGetServerconfig* = Call_ContainerProjectsZonesGetServerconfig_589683(
    name: "containerProjectsZonesGetServerconfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/serverconfig",
    validator: validate_ContainerProjectsZonesGetServerconfig_589684, base: "/",
    url: url_ContainerProjectsZonesGetServerconfig_589685, schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsUpdate_589731 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsUpdate_589733(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsUpdate_589732(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to update.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589734 = path.getOrDefault("name")
  valid_589734 = validateParameter(valid_589734, JString, required = true,
                                 default = nil)
  if valid_589734 != nil:
    section.add "name", valid_589734
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589735 = query.getOrDefault("upload_protocol")
  valid_589735 = validateParameter(valid_589735, JString, required = false,
                                 default = nil)
  if valid_589735 != nil:
    section.add "upload_protocol", valid_589735
  var valid_589736 = query.getOrDefault("fields")
  valid_589736 = validateParameter(valid_589736, JString, required = false,
                                 default = nil)
  if valid_589736 != nil:
    section.add "fields", valid_589736
  var valid_589737 = query.getOrDefault("quotaUser")
  valid_589737 = validateParameter(valid_589737, JString, required = false,
                                 default = nil)
  if valid_589737 != nil:
    section.add "quotaUser", valid_589737
  var valid_589738 = query.getOrDefault("alt")
  valid_589738 = validateParameter(valid_589738, JString, required = false,
                                 default = newJString("json"))
  if valid_589738 != nil:
    section.add "alt", valid_589738
  var valid_589739 = query.getOrDefault("pp")
  valid_589739 = validateParameter(valid_589739, JBool, required = false,
                                 default = newJBool(true))
  if valid_589739 != nil:
    section.add "pp", valid_589739
  var valid_589740 = query.getOrDefault("oauth_token")
  valid_589740 = validateParameter(valid_589740, JString, required = false,
                                 default = nil)
  if valid_589740 != nil:
    section.add "oauth_token", valid_589740
  var valid_589741 = query.getOrDefault("callback")
  valid_589741 = validateParameter(valid_589741, JString, required = false,
                                 default = nil)
  if valid_589741 != nil:
    section.add "callback", valid_589741
  var valid_589742 = query.getOrDefault("access_token")
  valid_589742 = validateParameter(valid_589742, JString, required = false,
                                 default = nil)
  if valid_589742 != nil:
    section.add "access_token", valid_589742
  var valid_589743 = query.getOrDefault("uploadType")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = nil)
  if valid_589743 != nil:
    section.add "uploadType", valid_589743
  var valid_589744 = query.getOrDefault("key")
  valid_589744 = validateParameter(valid_589744, JString, required = false,
                                 default = nil)
  if valid_589744 != nil:
    section.add "key", valid_589744
  var valid_589745 = query.getOrDefault("$.xgafv")
  valid_589745 = validateParameter(valid_589745, JString, required = false,
                                 default = newJString("1"))
  if valid_589745 != nil:
    section.add "$.xgafv", valid_589745
  var valid_589746 = query.getOrDefault("prettyPrint")
  valid_589746 = validateParameter(valid_589746, JBool, required = false,
                                 default = newJBool(true))
  if valid_589746 != nil:
    section.add "prettyPrint", valid_589746
  var valid_589747 = query.getOrDefault("bearer_token")
  valid_589747 = validateParameter(valid_589747, JString, required = false,
                                 default = nil)
  if valid_589747 != nil:
    section.add "bearer_token", valid_589747
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

proc call*(call_589749: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_589731;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  let valid = call_589749.validator(path, query, header, formData, body)
  let scheme = call_589749.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589749.url(scheme.get, call_589749.host, call_589749.base,
                         call_589749.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589749, url, valid)

proc call*(call_589750: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_589731;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsUpdate
  ## Updates the version and/or iamge type of a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to update.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589751 = newJObject()
  var query_589752 = newJObject()
  var body_589753 = newJObject()
  add(query_589752, "upload_protocol", newJString(uploadProtocol))
  add(query_589752, "fields", newJString(fields))
  add(query_589752, "quotaUser", newJString(quotaUser))
  add(path_589751, "name", newJString(name))
  add(query_589752, "alt", newJString(alt))
  add(query_589752, "pp", newJBool(pp))
  add(query_589752, "oauth_token", newJString(oauthToken))
  add(query_589752, "callback", newJString(callback))
  add(query_589752, "access_token", newJString(accessToken))
  add(query_589752, "uploadType", newJString(uploadType))
  add(query_589752, "key", newJString(key))
  add(query_589752, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589753 = body
  add(query_589752, "prettyPrint", newJBool(prettyPrint))
  add(query_589752, "bearer_token", newJString(bearerToken))
  result = call_589750.call(path_589751, query_589752, nil, nil, body_589753)

var containerProjectsLocationsClustersNodePoolsUpdate* = Call_ContainerProjectsLocationsClustersNodePoolsUpdate_589731(
    name: "containerProjectsLocationsClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPut, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsUpdate_589732,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsUpdate_589733,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsGet_589706 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsGet_589708(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsGet_589707(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the node pool requested.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to get.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589709 = path.getOrDefault("name")
  valid_589709 = validateParameter(valid_589709, JString, required = true,
                                 default = nil)
  if valid_589709 != nil:
    section.add "name", valid_589709
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: JString
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589710 = query.getOrDefault("upload_protocol")
  valid_589710 = validateParameter(valid_589710, JString, required = false,
                                 default = nil)
  if valid_589710 != nil:
    section.add "upload_protocol", valid_589710
  var valid_589711 = query.getOrDefault("fields")
  valid_589711 = validateParameter(valid_589711, JString, required = false,
                                 default = nil)
  if valid_589711 != nil:
    section.add "fields", valid_589711
  var valid_589712 = query.getOrDefault("quotaUser")
  valid_589712 = validateParameter(valid_589712, JString, required = false,
                                 default = nil)
  if valid_589712 != nil:
    section.add "quotaUser", valid_589712
  var valid_589713 = query.getOrDefault("alt")
  valid_589713 = validateParameter(valid_589713, JString, required = false,
                                 default = newJString("json"))
  if valid_589713 != nil:
    section.add "alt", valid_589713
  var valid_589714 = query.getOrDefault("pp")
  valid_589714 = validateParameter(valid_589714, JBool, required = false,
                                 default = newJBool(true))
  if valid_589714 != nil:
    section.add "pp", valid_589714
  var valid_589715 = query.getOrDefault("oauth_token")
  valid_589715 = validateParameter(valid_589715, JString, required = false,
                                 default = nil)
  if valid_589715 != nil:
    section.add "oauth_token", valid_589715
  var valid_589716 = query.getOrDefault("callback")
  valid_589716 = validateParameter(valid_589716, JString, required = false,
                                 default = nil)
  if valid_589716 != nil:
    section.add "callback", valid_589716
  var valid_589717 = query.getOrDefault("access_token")
  valid_589717 = validateParameter(valid_589717, JString, required = false,
                                 default = nil)
  if valid_589717 != nil:
    section.add "access_token", valid_589717
  var valid_589718 = query.getOrDefault("uploadType")
  valid_589718 = validateParameter(valid_589718, JString, required = false,
                                 default = nil)
  if valid_589718 != nil:
    section.add "uploadType", valid_589718
  var valid_589719 = query.getOrDefault("nodePoolId")
  valid_589719 = validateParameter(valid_589719, JString, required = false,
                                 default = nil)
  if valid_589719 != nil:
    section.add "nodePoolId", valid_589719
  var valid_589720 = query.getOrDefault("zone")
  valid_589720 = validateParameter(valid_589720, JString, required = false,
                                 default = nil)
  if valid_589720 != nil:
    section.add "zone", valid_589720
  var valid_589721 = query.getOrDefault("key")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = nil)
  if valid_589721 != nil:
    section.add "key", valid_589721
  var valid_589722 = query.getOrDefault("$.xgafv")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = newJString("1"))
  if valid_589722 != nil:
    section.add "$.xgafv", valid_589722
  var valid_589723 = query.getOrDefault("projectId")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = nil)
  if valid_589723 != nil:
    section.add "projectId", valid_589723
  var valid_589724 = query.getOrDefault("prettyPrint")
  valid_589724 = validateParameter(valid_589724, JBool, required = false,
                                 default = newJBool(true))
  if valid_589724 != nil:
    section.add "prettyPrint", valid_589724
  var valid_589725 = query.getOrDefault("clusterId")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "clusterId", valid_589725
  var valid_589726 = query.getOrDefault("bearer_token")
  valid_589726 = validateParameter(valid_589726, JString, required = false,
                                 default = nil)
  if valid_589726 != nil:
    section.add "bearer_token", valid_589726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589727: Call_ContainerProjectsLocationsClustersNodePoolsGet_589706;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the node pool requested.
  ## 
  let valid = call_589727.validator(path, query, header, formData, body)
  let scheme = call_589727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589727.url(scheme.get, call_589727.host, call_589727.base,
                         call_589727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589727, url, valid)

proc call*(call_589728: Call_ContainerProjectsLocationsClustersNodePoolsGet_589706;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; nodePoolId: string = ""; zone: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true; clusterId: string = ""; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsGet
  ## Retrieves the node pool requested.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to get.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589729 = newJObject()
  var query_589730 = newJObject()
  add(query_589730, "upload_protocol", newJString(uploadProtocol))
  add(query_589730, "fields", newJString(fields))
  add(query_589730, "quotaUser", newJString(quotaUser))
  add(path_589729, "name", newJString(name))
  add(query_589730, "alt", newJString(alt))
  add(query_589730, "pp", newJBool(pp))
  add(query_589730, "oauth_token", newJString(oauthToken))
  add(query_589730, "callback", newJString(callback))
  add(query_589730, "access_token", newJString(accessToken))
  add(query_589730, "uploadType", newJString(uploadType))
  add(query_589730, "nodePoolId", newJString(nodePoolId))
  add(query_589730, "zone", newJString(zone))
  add(query_589730, "key", newJString(key))
  add(query_589730, "$.xgafv", newJString(Xgafv))
  add(query_589730, "projectId", newJString(projectId))
  add(query_589730, "prettyPrint", newJBool(prettyPrint))
  add(query_589730, "clusterId", newJString(clusterId))
  add(query_589730, "bearer_token", newJString(bearerToken))
  result = call_589728.call(path_589729, query_589730, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsGet* = Call_ContainerProjectsLocationsClustersNodePoolsGet_589706(
    name: "containerProjectsLocationsClustersNodePoolsGet",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsGet_589707,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsGet_589708,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsDelete_589754 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsDelete_589756(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsDelete_589755(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a node pool from a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589757 = path.getOrDefault("name")
  valid_589757 = validateParameter(valid_589757, JString, required = true,
                                 default = nil)
  if valid_589757 != nil:
    section.add "name", valid_589757
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: JString
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589758 = query.getOrDefault("upload_protocol")
  valid_589758 = validateParameter(valid_589758, JString, required = false,
                                 default = nil)
  if valid_589758 != nil:
    section.add "upload_protocol", valid_589758
  var valid_589759 = query.getOrDefault("fields")
  valid_589759 = validateParameter(valid_589759, JString, required = false,
                                 default = nil)
  if valid_589759 != nil:
    section.add "fields", valid_589759
  var valid_589760 = query.getOrDefault("quotaUser")
  valid_589760 = validateParameter(valid_589760, JString, required = false,
                                 default = nil)
  if valid_589760 != nil:
    section.add "quotaUser", valid_589760
  var valid_589761 = query.getOrDefault("alt")
  valid_589761 = validateParameter(valid_589761, JString, required = false,
                                 default = newJString("json"))
  if valid_589761 != nil:
    section.add "alt", valid_589761
  var valid_589762 = query.getOrDefault("pp")
  valid_589762 = validateParameter(valid_589762, JBool, required = false,
                                 default = newJBool(true))
  if valid_589762 != nil:
    section.add "pp", valid_589762
  var valid_589763 = query.getOrDefault("oauth_token")
  valid_589763 = validateParameter(valid_589763, JString, required = false,
                                 default = nil)
  if valid_589763 != nil:
    section.add "oauth_token", valid_589763
  var valid_589764 = query.getOrDefault("callback")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = nil)
  if valid_589764 != nil:
    section.add "callback", valid_589764
  var valid_589765 = query.getOrDefault("access_token")
  valid_589765 = validateParameter(valid_589765, JString, required = false,
                                 default = nil)
  if valid_589765 != nil:
    section.add "access_token", valid_589765
  var valid_589766 = query.getOrDefault("uploadType")
  valid_589766 = validateParameter(valid_589766, JString, required = false,
                                 default = nil)
  if valid_589766 != nil:
    section.add "uploadType", valid_589766
  var valid_589767 = query.getOrDefault("nodePoolId")
  valid_589767 = validateParameter(valid_589767, JString, required = false,
                                 default = nil)
  if valid_589767 != nil:
    section.add "nodePoolId", valid_589767
  var valid_589768 = query.getOrDefault("zone")
  valid_589768 = validateParameter(valid_589768, JString, required = false,
                                 default = nil)
  if valid_589768 != nil:
    section.add "zone", valid_589768
  var valid_589769 = query.getOrDefault("key")
  valid_589769 = validateParameter(valid_589769, JString, required = false,
                                 default = nil)
  if valid_589769 != nil:
    section.add "key", valid_589769
  var valid_589770 = query.getOrDefault("$.xgafv")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = newJString("1"))
  if valid_589770 != nil:
    section.add "$.xgafv", valid_589770
  var valid_589771 = query.getOrDefault("projectId")
  valid_589771 = validateParameter(valid_589771, JString, required = false,
                                 default = nil)
  if valid_589771 != nil:
    section.add "projectId", valid_589771
  var valid_589772 = query.getOrDefault("prettyPrint")
  valid_589772 = validateParameter(valid_589772, JBool, required = false,
                                 default = newJBool(true))
  if valid_589772 != nil:
    section.add "prettyPrint", valid_589772
  var valid_589773 = query.getOrDefault("clusterId")
  valid_589773 = validateParameter(valid_589773, JString, required = false,
                                 default = nil)
  if valid_589773 != nil:
    section.add "clusterId", valid_589773
  var valid_589774 = query.getOrDefault("bearer_token")
  valid_589774 = validateParameter(valid_589774, JString, required = false,
                                 default = nil)
  if valid_589774 != nil:
    section.add "bearer_token", valid_589774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589775: Call_ContainerProjectsLocationsClustersNodePoolsDelete_589754;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_589775.validator(path, query, header, formData, body)
  let scheme = call_589775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589775.url(scheme.get, call_589775.host, call_589775.base,
                         call_589775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589775, url, valid)

proc call*(call_589776: Call_ContainerProjectsLocationsClustersNodePoolsDelete_589754;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; nodePoolId: string = ""; zone: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true; clusterId: string = ""; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589777 = newJObject()
  var query_589778 = newJObject()
  add(query_589778, "upload_protocol", newJString(uploadProtocol))
  add(query_589778, "fields", newJString(fields))
  add(query_589778, "quotaUser", newJString(quotaUser))
  add(path_589777, "name", newJString(name))
  add(query_589778, "alt", newJString(alt))
  add(query_589778, "pp", newJBool(pp))
  add(query_589778, "oauth_token", newJString(oauthToken))
  add(query_589778, "callback", newJString(callback))
  add(query_589778, "access_token", newJString(accessToken))
  add(query_589778, "uploadType", newJString(uploadType))
  add(query_589778, "nodePoolId", newJString(nodePoolId))
  add(query_589778, "zone", newJString(zone))
  add(query_589778, "key", newJString(key))
  add(query_589778, "$.xgafv", newJString(Xgafv))
  add(query_589778, "projectId", newJString(projectId))
  add(query_589778, "prettyPrint", newJBool(prettyPrint))
  add(query_589778, "clusterId", newJString(clusterId))
  add(query_589778, "bearer_token", newJString(bearerToken))
  result = call_589776.call(path_589777, query_589778, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsDelete* = Call_ContainerProjectsLocationsClustersNodePoolsDelete_589754(
    name: "containerProjectsLocationsClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsDelete_589755,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsDelete_589756,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsGetServerConfig_589779 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsGetServerConfig_589781(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/serverConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsGetServerConfig_589780(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns configuration info about the Container Engine service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project and location) of the server config to get
  ## Specified in the format 'projects/*/locations/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589782 = path.getOrDefault("name")
  valid_589782 = validateParameter(valid_589782, JString, required = true,
                                 default = nil)
  if valid_589782 != nil:
    section.add "name", valid_589782
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589783 = query.getOrDefault("upload_protocol")
  valid_589783 = validateParameter(valid_589783, JString, required = false,
                                 default = nil)
  if valid_589783 != nil:
    section.add "upload_protocol", valid_589783
  var valid_589784 = query.getOrDefault("fields")
  valid_589784 = validateParameter(valid_589784, JString, required = false,
                                 default = nil)
  if valid_589784 != nil:
    section.add "fields", valid_589784
  var valid_589785 = query.getOrDefault("quotaUser")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = nil)
  if valid_589785 != nil:
    section.add "quotaUser", valid_589785
  var valid_589786 = query.getOrDefault("alt")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = newJString("json"))
  if valid_589786 != nil:
    section.add "alt", valid_589786
  var valid_589787 = query.getOrDefault("pp")
  valid_589787 = validateParameter(valid_589787, JBool, required = false,
                                 default = newJBool(true))
  if valid_589787 != nil:
    section.add "pp", valid_589787
  var valid_589788 = query.getOrDefault("oauth_token")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = nil)
  if valid_589788 != nil:
    section.add "oauth_token", valid_589788
  var valid_589789 = query.getOrDefault("callback")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "callback", valid_589789
  var valid_589790 = query.getOrDefault("access_token")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = nil)
  if valid_589790 != nil:
    section.add "access_token", valid_589790
  var valid_589791 = query.getOrDefault("uploadType")
  valid_589791 = validateParameter(valid_589791, JString, required = false,
                                 default = nil)
  if valid_589791 != nil:
    section.add "uploadType", valid_589791
  var valid_589792 = query.getOrDefault("zone")
  valid_589792 = validateParameter(valid_589792, JString, required = false,
                                 default = nil)
  if valid_589792 != nil:
    section.add "zone", valid_589792
  var valid_589793 = query.getOrDefault("key")
  valid_589793 = validateParameter(valid_589793, JString, required = false,
                                 default = nil)
  if valid_589793 != nil:
    section.add "key", valid_589793
  var valid_589794 = query.getOrDefault("$.xgafv")
  valid_589794 = validateParameter(valid_589794, JString, required = false,
                                 default = newJString("1"))
  if valid_589794 != nil:
    section.add "$.xgafv", valid_589794
  var valid_589795 = query.getOrDefault("projectId")
  valid_589795 = validateParameter(valid_589795, JString, required = false,
                                 default = nil)
  if valid_589795 != nil:
    section.add "projectId", valid_589795
  var valid_589796 = query.getOrDefault("prettyPrint")
  valid_589796 = validateParameter(valid_589796, JBool, required = false,
                                 default = newJBool(true))
  if valid_589796 != nil:
    section.add "prettyPrint", valid_589796
  var valid_589797 = query.getOrDefault("bearer_token")
  valid_589797 = validateParameter(valid_589797, JString, required = false,
                                 default = nil)
  if valid_589797 != nil:
    section.add "bearer_token", valid_589797
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589798: Call_ContainerProjectsLocationsGetServerConfig_589779;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Container Engine service.
  ## 
  let valid = call_589798.validator(path, query, header, formData, body)
  let scheme = call_589798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589798.url(scheme.get, call_589798.host, call_589798.base,
                         call_589798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589798, url, valid)

proc call*(call_589799: Call_ContainerProjectsLocationsGetServerConfig_589779;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsGetServerConfig
  ## Returns configuration info about the Container Engine service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project and location) of the server config to get
  ## Specified in the format 'projects/*/locations/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: string
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589800 = newJObject()
  var query_589801 = newJObject()
  add(query_589801, "upload_protocol", newJString(uploadProtocol))
  add(query_589801, "fields", newJString(fields))
  add(query_589801, "quotaUser", newJString(quotaUser))
  add(path_589800, "name", newJString(name))
  add(query_589801, "alt", newJString(alt))
  add(query_589801, "pp", newJBool(pp))
  add(query_589801, "oauth_token", newJString(oauthToken))
  add(query_589801, "callback", newJString(callback))
  add(query_589801, "access_token", newJString(accessToken))
  add(query_589801, "uploadType", newJString(uploadType))
  add(query_589801, "zone", newJString(zone))
  add(query_589801, "key", newJString(key))
  add(query_589801, "$.xgafv", newJString(Xgafv))
  add(query_589801, "projectId", newJString(projectId))
  add(query_589801, "prettyPrint", newJBool(prettyPrint))
  add(query_589801, "bearer_token", newJString(bearerToken))
  result = call_589799.call(path_589800, query_589801, nil, nil, nil)

var containerProjectsLocationsGetServerConfig* = Call_ContainerProjectsLocationsGetServerConfig_589779(
    name: "containerProjectsLocationsGetServerConfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{name}/serverConfig",
    validator: validate_ContainerProjectsLocationsGetServerConfig_589780,
    base: "/", url: url_ContainerProjectsLocationsGetServerConfig_589781,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsCancel_589802 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsOperationsCancel_589804(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsOperationsCancel_589803(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, operation id) of the operation to cancel.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589805 = path.getOrDefault("name")
  valid_589805 = validateParameter(valid_589805, JString, required = true,
                                 default = nil)
  if valid_589805 != nil:
    section.add "name", valid_589805
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589806 = query.getOrDefault("upload_protocol")
  valid_589806 = validateParameter(valid_589806, JString, required = false,
                                 default = nil)
  if valid_589806 != nil:
    section.add "upload_protocol", valid_589806
  var valid_589807 = query.getOrDefault("fields")
  valid_589807 = validateParameter(valid_589807, JString, required = false,
                                 default = nil)
  if valid_589807 != nil:
    section.add "fields", valid_589807
  var valid_589808 = query.getOrDefault("quotaUser")
  valid_589808 = validateParameter(valid_589808, JString, required = false,
                                 default = nil)
  if valid_589808 != nil:
    section.add "quotaUser", valid_589808
  var valid_589809 = query.getOrDefault("alt")
  valid_589809 = validateParameter(valid_589809, JString, required = false,
                                 default = newJString("json"))
  if valid_589809 != nil:
    section.add "alt", valid_589809
  var valid_589810 = query.getOrDefault("pp")
  valid_589810 = validateParameter(valid_589810, JBool, required = false,
                                 default = newJBool(true))
  if valid_589810 != nil:
    section.add "pp", valid_589810
  var valid_589811 = query.getOrDefault("oauth_token")
  valid_589811 = validateParameter(valid_589811, JString, required = false,
                                 default = nil)
  if valid_589811 != nil:
    section.add "oauth_token", valid_589811
  var valid_589812 = query.getOrDefault("callback")
  valid_589812 = validateParameter(valid_589812, JString, required = false,
                                 default = nil)
  if valid_589812 != nil:
    section.add "callback", valid_589812
  var valid_589813 = query.getOrDefault("access_token")
  valid_589813 = validateParameter(valid_589813, JString, required = false,
                                 default = nil)
  if valid_589813 != nil:
    section.add "access_token", valid_589813
  var valid_589814 = query.getOrDefault("uploadType")
  valid_589814 = validateParameter(valid_589814, JString, required = false,
                                 default = nil)
  if valid_589814 != nil:
    section.add "uploadType", valid_589814
  var valid_589815 = query.getOrDefault("key")
  valid_589815 = validateParameter(valid_589815, JString, required = false,
                                 default = nil)
  if valid_589815 != nil:
    section.add "key", valid_589815
  var valid_589816 = query.getOrDefault("$.xgafv")
  valid_589816 = validateParameter(valid_589816, JString, required = false,
                                 default = newJString("1"))
  if valid_589816 != nil:
    section.add "$.xgafv", valid_589816
  var valid_589817 = query.getOrDefault("prettyPrint")
  valid_589817 = validateParameter(valid_589817, JBool, required = false,
                                 default = newJBool(true))
  if valid_589817 != nil:
    section.add "prettyPrint", valid_589817
  var valid_589818 = query.getOrDefault("bearer_token")
  valid_589818 = validateParameter(valid_589818, JString, required = false,
                                 default = nil)
  if valid_589818 != nil:
    section.add "bearer_token", valid_589818
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

proc call*(call_589820: Call_ContainerProjectsLocationsOperationsCancel_589802;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_589820.validator(path, query, header, formData, body)
  let scheme = call_589820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589820.url(scheme.get, call_589820.host, call_589820.base,
                         call_589820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589820, url, valid)

proc call*(call_589821: Call_ContainerProjectsLocationsOperationsCancel_589802;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsOperationsCancel
  ## Cancels the specified operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, operation id) of the operation to cancel.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589822 = newJObject()
  var query_589823 = newJObject()
  var body_589824 = newJObject()
  add(query_589823, "upload_protocol", newJString(uploadProtocol))
  add(query_589823, "fields", newJString(fields))
  add(query_589823, "quotaUser", newJString(quotaUser))
  add(path_589822, "name", newJString(name))
  add(query_589823, "alt", newJString(alt))
  add(query_589823, "pp", newJBool(pp))
  add(query_589823, "oauth_token", newJString(oauthToken))
  add(query_589823, "callback", newJString(callback))
  add(query_589823, "access_token", newJString(accessToken))
  add(query_589823, "uploadType", newJString(uploadType))
  add(query_589823, "key", newJString(key))
  add(query_589823, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589824 = body
  add(query_589823, "prettyPrint", newJBool(prettyPrint))
  add(query_589823, "bearer_token", newJString(bearerToken))
  result = call_589821.call(path_589822, query_589823, nil, nil, body_589824)

var containerProjectsLocationsOperationsCancel* = Call_ContainerProjectsLocationsOperationsCancel_589802(
    name: "containerProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_ContainerProjectsLocationsOperationsCancel_589803,
    base: "/", url: url_ContainerProjectsLocationsOperationsCancel_589804,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCompleteIpRotation_589825 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersCompleteIpRotation_589827(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":completeIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersCompleteIpRotation_589826(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Completes master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to complete IP rotation.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589828 = path.getOrDefault("name")
  valid_589828 = validateParameter(valid_589828, JString, required = true,
                                 default = nil)
  if valid_589828 != nil:
    section.add "name", valid_589828
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589829 = query.getOrDefault("upload_protocol")
  valid_589829 = validateParameter(valid_589829, JString, required = false,
                                 default = nil)
  if valid_589829 != nil:
    section.add "upload_protocol", valid_589829
  var valid_589830 = query.getOrDefault("fields")
  valid_589830 = validateParameter(valid_589830, JString, required = false,
                                 default = nil)
  if valid_589830 != nil:
    section.add "fields", valid_589830
  var valid_589831 = query.getOrDefault("quotaUser")
  valid_589831 = validateParameter(valid_589831, JString, required = false,
                                 default = nil)
  if valid_589831 != nil:
    section.add "quotaUser", valid_589831
  var valid_589832 = query.getOrDefault("alt")
  valid_589832 = validateParameter(valid_589832, JString, required = false,
                                 default = newJString("json"))
  if valid_589832 != nil:
    section.add "alt", valid_589832
  var valid_589833 = query.getOrDefault("pp")
  valid_589833 = validateParameter(valid_589833, JBool, required = false,
                                 default = newJBool(true))
  if valid_589833 != nil:
    section.add "pp", valid_589833
  var valid_589834 = query.getOrDefault("oauth_token")
  valid_589834 = validateParameter(valid_589834, JString, required = false,
                                 default = nil)
  if valid_589834 != nil:
    section.add "oauth_token", valid_589834
  var valid_589835 = query.getOrDefault("callback")
  valid_589835 = validateParameter(valid_589835, JString, required = false,
                                 default = nil)
  if valid_589835 != nil:
    section.add "callback", valid_589835
  var valid_589836 = query.getOrDefault("access_token")
  valid_589836 = validateParameter(valid_589836, JString, required = false,
                                 default = nil)
  if valid_589836 != nil:
    section.add "access_token", valid_589836
  var valid_589837 = query.getOrDefault("uploadType")
  valid_589837 = validateParameter(valid_589837, JString, required = false,
                                 default = nil)
  if valid_589837 != nil:
    section.add "uploadType", valid_589837
  var valid_589838 = query.getOrDefault("key")
  valid_589838 = validateParameter(valid_589838, JString, required = false,
                                 default = nil)
  if valid_589838 != nil:
    section.add "key", valid_589838
  var valid_589839 = query.getOrDefault("$.xgafv")
  valid_589839 = validateParameter(valid_589839, JString, required = false,
                                 default = newJString("1"))
  if valid_589839 != nil:
    section.add "$.xgafv", valid_589839
  var valid_589840 = query.getOrDefault("prettyPrint")
  valid_589840 = validateParameter(valid_589840, JBool, required = false,
                                 default = newJBool(true))
  if valid_589840 != nil:
    section.add "prettyPrint", valid_589840
  var valid_589841 = query.getOrDefault("bearer_token")
  valid_589841 = validateParameter(valid_589841, JString, required = false,
                                 default = nil)
  if valid_589841 != nil:
    section.add "bearer_token", valid_589841
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

proc call*(call_589843: Call_ContainerProjectsLocationsClustersCompleteIpRotation_589825;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_589843.validator(path, query, header, formData, body)
  let scheme = call_589843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589843.url(scheme.get, call_589843.host, call_589843.base,
                         call_589843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589843, url, valid)

proc call*(call_589844: Call_ContainerProjectsLocationsClustersCompleteIpRotation_589825;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to complete IP rotation.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589845 = newJObject()
  var query_589846 = newJObject()
  var body_589847 = newJObject()
  add(query_589846, "upload_protocol", newJString(uploadProtocol))
  add(query_589846, "fields", newJString(fields))
  add(query_589846, "quotaUser", newJString(quotaUser))
  add(path_589845, "name", newJString(name))
  add(query_589846, "alt", newJString(alt))
  add(query_589846, "pp", newJBool(pp))
  add(query_589846, "oauth_token", newJString(oauthToken))
  add(query_589846, "callback", newJString(callback))
  add(query_589846, "access_token", newJString(accessToken))
  add(query_589846, "uploadType", newJString(uploadType))
  add(query_589846, "key", newJString(key))
  add(query_589846, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589847 = body
  add(query_589846, "prettyPrint", newJBool(prettyPrint))
  add(query_589846, "bearer_token", newJString(bearerToken))
  result = call_589844.call(path_589845, query_589846, nil, nil, body_589847)

var containerProjectsLocationsClustersCompleteIpRotation* = Call_ContainerProjectsLocationsClustersCompleteIpRotation_589825(
    name: "containerProjectsLocationsClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:completeIpRotation",
    validator: validate_ContainerProjectsLocationsClustersCompleteIpRotation_589826,
    base: "/", url: url_ContainerProjectsLocationsClustersCompleteIpRotation_589827,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsRollback_589848 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsRollback_589850(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":rollback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsRollback_589849(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node poll to
  ## rollback upgrade.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589851 = path.getOrDefault("name")
  valid_589851 = validateParameter(valid_589851, JString, required = true,
                                 default = nil)
  if valid_589851 != nil:
    section.add "name", valid_589851
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589852 = query.getOrDefault("upload_protocol")
  valid_589852 = validateParameter(valid_589852, JString, required = false,
                                 default = nil)
  if valid_589852 != nil:
    section.add "upload_protocol", valid_589852
  var valid_589853 = query.getOrDefault("fields")
  valid_589853 = validateParameter(valid_589853, JString, required = false,
                                 default = nil)
  if valid_589853 != nil:
    section.add "fields", valid_589853
  var valid_589854 = query.getOrDefault("quotaUser")
  valid_589854 = validateParameter(valid_589854, JString, required = false,
                                 default = nil)
  if valid_589854 != nil:
    section.add "quotaUser", valid_589854
  var valid_589855 = query.getOrDefault("alt")
  valid_589855 = validateParameter(valid_589855, JString, required = false,
                                 default = newJString("json"))
  if valid_589855 != nil:
    section.add "alt", valid_589855
  var valid_589856 = query.getOrDefault("pp")
  valid_589856 = validateParameter(valid_589856, JBool, required = false,
                                 default = newJBool(true))
  if valid_589856 != nil:
    section.add "pp", valid_589856
  var valid_589857 = query.getOrDefault("oauth_token")
  valid_589857 = validateParameter(valid_589857, JString, required = false,
                                 default = nil)
  if valid_589857 != nil:
    section.add "oauth_token", valid_589857
  var valid_589858 = query.getOrDefault("callback")
  valid_589858 = validateParameter(valid_589858, JString, required = false,
                                 default = nil)
  if valid_589858 != nil:
    section.add "callback", valid_589858
  var valid_589859 = query.getOrDefault("access_token")
  valid_589859 = validateParameter(valid_589859, JString, required = false,
                                 default = nil)
  if valid_589859 != nil:
    section.add "access_token", valid_589859
  var valid_589860 = query.getOrDefault("uploadType")
  valid_589860 = validateParameter(valid_589860, JString, required = false,
                                 default = nil)
  if valid_589860 != nil:
    section.add "uploadType", valid_589860
  var valid_589861 = query.getOrDefault("key")
  valid_589861 = validateParameter(valid_589861, JString, required = false,
                                 default = nil)
  if valid_589861 != nil:
    section.add "key", valid_589861
  var valid_589862 = query.getOrDefault("$.xgafv")
  valid_589862 = validateParameter(valid_589862, JString, required = false,
                                 default = newJString("1"))
  if valid_589862 != nil:
    section.add "$.xgafv", valid_589862
  var valid_589863 = query.getOrDefault("prettyPrint")
  valid_589863 = validateParameter(valid_589863, JBool, required = false,
                                 default = newJBool(true))
  if valid_589863 != nil:
    section.add "prettyPrint", valid_589863
  var valid_589864 = query.getOrDefault("bearer_token")
  valid_589864 = validateParameter(valid_589864, JString, required = false,
                                 default = nil)
  if valid_589864 != nil:
    section.add "bearer_token", valid_589864
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

proc call*(call_589866: Call_ContainerProjectsLocationsClustersNodePoolsRollback_589848;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  let valid = call_589866.validator(path, query, header, formData, body)
  let scheme = call_589866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589866.url(scheme.get, call_589866.host, call_589866.base,
                         call_589866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589866, url, valid)

proc call*(call_589867: Call_ContainerProjectsLocationsClustersNodePoolsRollback_589848;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsRollback
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node poll to
  ## rollback upgrade.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589868 = newJObject()
  var query_589869 = newJObject()
  var body_589870 = newJObject()
  add(query_589869, "upload_protocol", newJString(uploadProtocol))
  add(query_589869, "fields", newJString(fields))
  add(query_589869, "quotaUser", newJString(quotaUser))
  add(path_589868, "name", newJString(name))
  add(query_589869, "alt", newJString(alt))
  add(query_589869, "pp", newJBool(pp))
  add(query_589869, "oauth_token", newJString(oauthToken))
  add(query_589869, "callback", newJString(callback))
  add(query_589869, "access_token", newJString(accessToken))
  add(query_589869, "uploadType", newJString(uploadType))
  add(query_589869, "key", newJString(key))
  add(query_589869, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589870 = body
  add(query_589869, "prettyPrint", newJBool(prettyPrint))
  add(query_589869, "bearer_token", newJString(bearerToken))
  result = call_589867.call(path_589868, query_589869, nil, nil, body_589870)

var containerProjectsLocationsClustersNodePoolsRollback* = Call_ContainerProjectsLocationsClustersNodePoolsRollback_589848(
    name: "containerProjectsLocationsClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:rollback",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsRollback_589849,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsRollback_589850,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetAddons_589871 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetAddons_589873(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setAddons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetAddons_589872(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the addons of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set addons.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589874 = path.getOrDefault("name")
  valid_589874 = validateParameter(valid_589874, JString, required = true,
                                 default = nil)
  if valid_589874 != nil:
    section.add "name", valid_589874
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589875 = query.getOrDefault("upload_protocol")
  valid_589875 = validateParameter(valid_589875, JString, required = false,
                                 default = nil)
  if valid_589875 != nil:
    section.add "upload_protocol", valid_589875
  var valid_589876 = query.getOrDefault("fields")
  valid_589876 = validateParameter(valid_589876, JString, required = false,
                                 default = nil)
  if valid_589876 != nil:
    section.add "fields", valid_589876
  var valid_589877 = query.getOrDefault("quotaUser")
  valid_589877 = validateParameter(valid_589877, JString, required = false,
                                 default = nil)
  if valid_589877 != nil:
    section.add "quotaUser", valid_589877
  var valid_589878 = query.getOrDefault("alt")
  valid_589878 = validateParameter(valid_589878, JString, required = false,
                                 default = newJString("json"))
  if valid_589878 != nil:
    section.add "alt", valid_589878
  var valid_589879 = query.getOrDefault("pp")
  valid_589879 = validateParameter(valid_589879, JBool, required = false,
                                 default = newJBool(true))
  if valid_589879 != nil:
    section.add "pp", valid_589879
  var valid_589880 = query.getOrDefault("oauth_token")
  valid_589880 = validateParameter(valid_589880, JString, required = false,
                                 default = nil)
  if valid_589880 != nil:
    section.add "oauth_token", valid_589880
  var valid_589881 = query.getOrDefault("callback")
  valid_589881 = validateParameter(valid_589881, JString, required = false,
                                 default = nil)
  if valid_589881 != nil:
    section.add "callback", valid_589881
  var valid_589882 = query.getOrDefault("access_token")
  valid_589882 = validateParameter(valid_589882, JString, required = false,
                                 default = nil)
  if valid_589882 != nil:
    section.add "access_token", valid_589882
  var valid_589883 = query.getOrDefault("uploadType")
  valid_589883 = validateParameter(valid_589883, JString, required = false,
                                 default = nil)
  if valid_589883 != nil:
    section.add "uploadType", valid_589883
  var valid_589884 = query.getOrDefault("key")
  valid_589884 = validateParameter(valid_589884, JString, required = false,
                                 default = nil)
  if valid_589884 != nil:
    section.add "key", valid_589884
  var valid_589885 = query.getOrDefault("$.xgafv")
  valid_589885 = validateParameter(valid_589885, JString, required = false,
                                 default = newJString("1"))
  if valid_589885 != nil:
    section.add "$.xgafv", valid_589885
  var valid_589886 = query.getOrDefault("prettyPrint")
  valid_589886 = validateParameter(valid_589886, JBool, required = false,
                                 default = newJBool(true))
  if valid_589886 != nil:
    section.add "prettyPrint", valid_589886
  var valid_589887 = query.getOrDefault("bearer_token")
  valid_589887 = validateParameter(valid_589887, JString, required = false,
                                 default = nil)
  if valid_589887 != nil:
    section.add "bearer_token", valid_589887
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

proc call*(call_589889: Call_ContainerProjectsLocationsClustersSetAddons_589871;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons of a specific cluster.
  ## 
  let valid = call_589889.validator(path, query, header, formData, body)
  let scheme = call_589889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589889.url(scheme.get, call_589889.host, call_589889.base,
                         call_589889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589889, url, valid)

proc call*(call_589890: Call_ContainerProjectsLocationsClustersSetAddons_589871;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetAddons
  ## Sets the addons of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set addons.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589891 = newJObject()
  var query_589892 = newJObject()
  var body_589893 = newJObject()
  add(query_589892, "upload_protocol", newJString(uploadProtocol))
  add(query_589892, "fields", newJString(fields))
  add(query_589892, "quotaUser", newJString(quotaUser))
  add(path_589891, "name", newJString(name))
  add(query_589892, "alt", newJString(alt))
  add(query_589892, "pp", newJBool(pp))
  add(query_589892, "oauth_token", newJString(oauthToken))
  add(query_589892, "callback", newJString(callback))
  add(query_589892, "access_token", newJString(accessToken))
  add(query_589892, "uploadType", newJString(uploadType))
  add(query_589892, "key", newJString(key))
  add(query_589892, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589893 = body
  add(query_589892, "prettyPrint", newJBool(prettyPrint))
  add(query_589892, "bearer_token", newJString(bearerToken))
  result = call_589890.call(path_589891, query_589892, nil, nil, body_589893)

var containerProjectsLocationsClustersSetAddons* = Call_ContainerProjectsLocationsClustersSetAddons_589871(
    name: "containerProjectsLocationsClustersSetAddons",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setAddons",
    validator: validate_ContainerProjectsLocationsClustersSetAddons_589872,
    base: "/", url: url_ContainerProjectsLocationsClustersSetAddons_589873,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589894 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589896(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setAutoscaling")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589895(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to set
  ## autoscaler settings. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589897 = path.getOrDefault("name")
  valid_589897 = validateParameter(valid_589897, JString, required = true,
                                 default = nil)
  if valid_589897 != nil:
    section.add "name", valid_589897
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589898 = query.getOrDefault("upload_protocol")
  valid_589898 = validateParameter(valid_589898, JString, required = false,
                                 default = nil)
  if valid_589898 != nil:
    section.add "upload_protocol", valid_589898
  var valid_589899 = query.getOrDefault("fields")
  valid_589899 = validateParameter(valid_589899, JString, required = false,
                                 default = nil)
  if valid_589899 != nil:
    section.add "fields", valid_589899
  var valid_589900 = query.getOrDefault("quotaUser")
  valid_589900 = validateParameter(valid_589900, JString, required = false,
                                 default = nil)
  if valid_589900 != nil:
    section.add "quotaUser", valid_589900
  var valid_589901 = query.getOrDefault("alt")
  valid_589901 = validateParameter(valid_589901, JString, required = false,
                                 default = newJString("json"))
  if valid_589901 != nil:
    section.add "alt", valid_589901
  var valid_589902 = query.getOrDefault("pp")
  valid_589902 = validateParameter(valid_589902, JBool, required = false,
                                 default = newJBool(true))
  if valid_589902 != nil:
    section.add "pp", valid_589902
  var valid_589903 = query.getOrDefault("oauth_token")
  valid_589903 = validateParameter(valid_589903, JString, required = false,
                                 default = nil)
  if valid_589903 != nil:
    section.add "oauth_token", valid_589903
  var valid_589904 = query.getOrDefault("callback")
  valid_589904 = validateParameter(valid_589904, JString, required = false,
                                 default = nil)
  if valid_589904 != nil:
    section.add "callback", valid_589904
  var valid_589905 = query.getOrDefault("access_token")
  valid_589905 = validateParameter(valid_589905, JString, required = false,
                                 default = nil)
  if valid_589905 != nil:
    section.add "access_token", valid_589905
  var valid_589906 = query.getOrDefault("uploadType")
  valid_589906 = validateParameter(valid_589906, JString, required = false,
                                 default = nil)
  if valid_589906 != nil:
    section.add "uploadType", valid_589906
  var valid_589907 = query.getOrDefault("key")
  valid_589907 = validateParameter(valid_589907, JString, required = false,
                                 default = nil)
  if valid_589907 != nil:
    section.add "key", valid_589907
  var valid_589908 = query.getOrDefault("$.xgafv")
  valid_589908 = validateParameter(valid_589908, JString, required = false,
                                 default = newJString("1"))
  if valid_589908 != nil:
    section.add "$.xgafv", valid_589908
  var valid_589909 = query.getOrDefault("prettyPrint")
  valid_589909 = validateParameter(valid_589909, JBool, required = false,
                                 default = newJBool(true))
  if valid_589909 != nil:
    section.add "prettyPrint", valid_589909
  var valid_589910 = query.getOrDefault("bearer_token")
  valid_589910 = validateParameter(valid_589910, JString, required = false,
                                 default = nil)
  if valid_589910 != nil:
    section.add "bearer_token", valid_589910
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

proc call*(call_589912: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589894;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  let valid = call_589912.validator(path, query, header, formData, body)
  let scheme = call_589912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589912.url(scheme.get, call_589912.host, call_589912.base,
                         call_589912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589912, url, valid)

proc call*(call_589913: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589894;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetAutoscaling
  ## Sets the autoscaling settings of a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to set
  ## autoscaler settings. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589914 = newJObject()
  var query_589915 = newJObject()
  var body_589916 = newJObject()
  add(query_589915, "upload_protocol", newJString(uploadProtocol))
  add(query_589915, "fields", newJString(fields))
  add(query_589915, "quotaUser", newJString(quotaUser))
  add(path_589914, "name", newJString(name))
  add(query_589915, "alt", newJString(alt))
  add(query_589915, "pp", newJBool(pp))
  add(query_589915, "oauth_token", newJString(oauthToken))
  add(query_589915, "callback", newJString(callback))
  add(query_589915, "access_token", newJString(accessToken))
  add(query_589915, "uploadType", newJString(uploadType))
  add(query_589915, "key", newJString(key))
  add(query_589915, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589916 = body
  add(query_589915, "prettyPrint", newJBool(prettyPrint))
  add(query_589915, "bearer_token", newJString(bearerToken))
  result = call_589913.call(path_589914, query_589915, nil, nil, body_589916)

var containerProjectsLocationsClustersNodePoolsSetAutoscaling* = Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589894(
    name: "containerProjectsLocationsClustersNodePoolsSetAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setAutoscaling", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589895,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589896,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLegacyAbac_589917 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetLegacyAbac_589919(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLegacyAbac")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLegacyAbac_589918(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to set legacy abac.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589920 = path.getOrDefault("name")
  valid_589920 = validateParameter(valid_589920, JString, required = true,
                                 default = nil)
  if valid_589920 != nil:
    section.add "name", valid_589920
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589921 = query.getOrDefault("upload_protocol")
  valid_589921 = validateParameter(valid_589921, JString, required = false,
                                 default = nil)
  if valid_589921 != nil:
    section.add "upload_protocol", valid_589921
  var valid_589922 = query.getOrDefault("fields")
  valid_589922 = validateParameter(valid_589922, JString, required = false,
                                 default = nil)
  if valid_589922 != nil:
    section.add "fields", valid_589922
  var valid_589923 = query.getOrDefault("quotaUser")
  valid_589923 = validateParameter(valid_589923, JString, required = false,
                                 default = nil)
  if valid_589923 != nil:
    section.add "quotaUser", valid_589923
  var valid_589924 = query.getOrDefault("alt")
  valid_589924 = validateParameter(valid_589924, JString, required = false,
                                 default = newJString("json"))
  if valid_589924 != nil:
    section.add "alt", valid_589924
  var valid_589925 = query.getOrDefault("pp")
  valid_589925 = validateParameter(valid_589925, JBool, required = false,
                                 default = newJBool(true))
  if valid_589925 != nil:
    section.add "pp", valid_589925
  var valid_589926 = query.getOrDefault("oauth_token")
  valid_589926 = validateParameter(valid_589926, JString, required = false,
                                 default = nil)
  if valid_589926 != nil:
    section.add "oauth_token", valid_589926
  var valid_589927 = query.getOrDefault("callback")
  valid_589927 = validateParameter(valid_589927, JString, required = false,
                                 default = nil)
  if valid_589927 != nil:
    section.add "callback", valid_589927
  var valid_589928 = query.getOrDefault("access_token")
  valid_589928 = validateParameter(valid_589928, JString, required = false,
                                 default = nil)
  if valid_589928 != nil:
    section.add "access_token", valid_589928
  var valid_589929 = query.getOrDefault("uploadType")
  valid_589929 = validateParameter(valid_589929, JString, required = false,
                                 default = nil)
  if valid_589929 != nil:
    section.add "uploadType", valid_589929
  var valid_589930 = query.getOrDefault("key")
  valid_589930 = validateParameter(valid_589930, JString, required = false,
                                 default = nil)
  if valid_589930 != nil:
    section.add "key", valid_589930
  var valid_589931 = query.getOrDefault("$.xgafv")
  valid_589931 = validateParameter(valid_589931, JString, required = false,
                                 default = newJString("1"))
  if valid_589931 != nil:
    section.add "$.xgafv", valid_589931
  var valid_589932 = query.getOrDefault("prettyPrint")
  valid_589932 = validateParameter(valid_589932, JBool, required = false,
                                 default = newJBool(true))
  if valid_589932 != nil:
    section.add "prettyPrint", valid_589932
  var valid_589933 = query.getOrDefault("bearer_token")
  valid_589933 = validateParameter(valid_589933, JString, required = false,
                                 default = nil)
  if valid_589933 != nil:
    section.add "bearer_token", valid_589933
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

proc call*(call_589935: Call_ContainerProjectsLocationsClustersSetLegacyAbac_589917;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_589935.validator(path, query, header, formData, body)
  let scheme = call_589935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589935.url(scheme.get, call_589935.host, call_589935.base,
                         call_589935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589935, url, valid)

proc call*(call_589936: Call_ContainerProjectsLocationsClustersSetLegacyAbac_589917;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLegacyAbac
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set legacy abac.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589937 = newJObject()
  var query_589938 = newJObject()
  var body_589939 = newJObject()
  add(query_589938, "upload_protocol", newJString(uploadProtocol))
  add(query_589938, "fields", newJString(fields))
  add(query_589938, "quotaUser", newJString(quotaUser))
  add(path_589937, "name", newJString(name))
  add(query_589938, "alt", newJString(alt))
  add(query_589938, "pp", newJBool(pp))
  add(query_589938, "oauth_token", newJString(oauthToken))
  add(query_589938, "callback", newJString(callback))
  add(query_589938, "access_token", newJString(accessToken))
  add(query_589938, "uploadType", newJString(uploadType))
  add(query_589938, "key", newJString(key))
  add(query_589938, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589939 = body
  add(query_589938, "prettyPrint", newJBool(prettyPrint))
  add(query_589938, "bearer_token", newJString(bearerToken))
  result = call_589936.call(path_589937, query_589938, nil, nil, body_589939)

var containerProjectsLocationsClustersSetLegacyAbac* = Call_ContainerProjectsLocationsClustersSetLegacyAbac_589917(
    name: "containerProjectsLocationsClustersSetLegacyAbac",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLegacyAbac",
    validator: validate_ContainerProjectsLocationsClustersSetLegacyAbac_589918,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLegacyAbac_589919,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLocations_589940 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetLocations_589942(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLocations_589941(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the locations of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set locations.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589943 = path.getOrDefault("name")
  valid_589943 = validateParameter(valid_589943, JString, required = true,
                                 default = nil)
  if valid_589943 != nil:
    section.add "name", valid_589943
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589944 = query.getOrDefault("upload_protocol")
  valid_589944 = validateParameter(valid_589944, JString, required = false,
                                 default = nil)
  if valid_589944 != nil:
    section.add "upload_protocol", valid_589944
  var valid_589945 = query.getOrDefault("fields")
  valid_589945 = validateParameter(valid_589945, JString, required = false,
                                 default = nil)
  if valid_589945 != nil:
    section.add "fields", valid_589945
  var valid_589946 = query.getOrDefault("quotaUser")
  valid_589946 = validateParameter(valid_589946, JString, required = false,
                                 default = nil)
  if valid_589946 != nil:
    section.add "quotaUser", valid_589946
  var valid_589947 = query.getOrDefault("alt")
  valid_589947 = validateParameter(valid_589947, JString, required = false,
                                 default = newJString("json"))
  if valid_589947 != nil:
    section.add "alt", valid_589947
  var valid_589948 = query.getOrDefault("pp")
  valid_589948 = validateParameter(valid_589948, JBool, required = false,
                                 default = newJBool(true))
  if valid_589948 != nil:
    section.add "pp", valid_589948
  var valid_589949 = query.getOrDefault("oauth_token")
  valid_589949 = validateParameter(valid_589949, JString, required = false,
                                 default = nil)
  if valid_589949 != nil:
    section.add "oauth_token", valid_589949
  var valid_589950 = query.getOrDefault("callback")
  valid_589950 = validateParameter(valid_589950, JString, required = false,
                                 default = nil)
  if valid_589950 != nil:
    section.add "callback", valid_589950
  var valid_589951 = query.getOrDefault("access_token")
  valid_589951 = validateParameter(valid_589951, JString, required = false,
                                 default = nil)
  if valid_589951 != nil:
    section.add "access_token", valid_589951
  var valid_589952 = query.getOrDefault("uploadType")
  valid_589952 = validateParameter(valid_589952, JString, required = false,
                                 default = nil)
  if valid_589952 != nil:
    section.add "uploadType", valid_589952
  var valid_589953 = query.getOrDefault("key")
  valid_589953 = validateParameter(valid_589953, JString, required = false,
                                 default = nil)
  if valid_589953 != nil:
    section.add "key", valid_589953
  var valid_589954 = query.getOrDefault("$.xgafv")
  valid_589954 = validateParameter(valid_589954, JString, required = false,
                                 default = newJString("1"))
  if valid_589954 != nil:
    section.add "$.xgafv", valid_589954
  var valid_589955 = query.getOrDefault("prettyPrint")
  valid_589955 = validateParameter(valid_589955, JBool, required = false,
                                 default = newJBool(true))
  if valid_589955 != nil:
    section.add "prettyPrint", valid_589955
  var valid_589956 = query.getOrDefault("bearer_token")
  valid_589956 = validateParameter(valid_589956, JString, required = false,
                                 default = nil)
  if valid_589956 != nil:
    section.add "bearer_token", valid_589956
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

proc call*(call_589958: Call_ContainerProjectsLocationsClustersSetLocations_589940;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations of a specific cluster.
  ## 
  let valid = call_589958.validator(path, query, header, formData, body)
  let scheme = call_589958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589958.url(scheme.get, call_589958.host, call_589958.base,
                         call_589958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589958, url, valid)

proc call*(call_589959: Call_ContainerProjectsLocationsClustersSetLocations_589940;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLocations
  ## Sets the locations of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set locations.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589960 = newJObject()
  var query_589961 = newJObject()
  var body_589962 = newJObject()
  add(query_589961, "upload_protocol", newJString(uploadProtocol))
  add(query_589961, "fields", newJString(fields))
  add(query_589961, "quotaUser", newJString(quotaUser))
  add(path_589960, "name", newJString(name))
  add(query_589961, "alt", newJString(alt))
  add(query_589961, "pp", newJBool(pp))
  add(query_589961, "oauth_token", newJString(oauthToken))
  add(query_589961, "callback", newJString(callback))
  add(query_589961, "access_token", newJString(accessToken))
  add(query_589961, "uploadType", newJString(uploadType))
  add(query_589961, "key", newJString(key))
  add(query_589961, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589962 = body
  add(query_589961, "prettyPrint", newJBool(prettyPrint))
  add(query_589961, "bearer_token", newJString(bearerToken))
  result = call_589959.call(path_589960, query_589961, nil, nil, body_589962)

var containerProjectsLocationsClustersSetLocations* = Call_ContainerProjectsLocationsClustersSetLocations_589940(
    name: "containerProjectsLocationsClustersSetLocations",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLocations",
    validator: validate_ContainerProjectsLocationsClustersSetLocations_589941,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLocations_589942,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLogging_589963 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetLogging_589965(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLogging")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLogging_589964(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the logging service of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set logging.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589966 = path.getOrDefault("name")
  valid_589966 = validateParameter(valid_589966, JString, required = true,
                                 default = nil)
  if valid_589966 != nil:
    section.add "name", valid_589966
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589967 = query.getOrDefault("upload_protocol")
  valid_589967 = validateParameter(valid_589967, JString, required = false,
                                 default = nil)
  if valid_589967 != nil:
    section.add "upload_protocol", valid_589967
  var valid_589968 = query.getOrDefault("fields")
  valid_589968 = validateParameter(valid_589968, JString, required = false,
                                 default = nil)
  if valid_589968 != nil:
    section.add "fields", valid_589968
  var valid_589969 = query.getOrDefault("quotaUser")
  valid_589969 = validateParameter(valid_589969, JString, required = false,
                                 default = nil)
  if valid_589969 != nil:
    section.add "quotaUser", valid_589969
  var valid_589970 = query.getOrDefault("alt")
  valid_589970 = validateParameter(valid_589970, JString, required = false,
                                 default = newJString("json"))
  if valid_589970 != nil:
    section.add "alt", valid_589970
  var valid_589971 = query.getOrDefault("pp")
  valid_589971 = validateParameter(valid_589971, JBool, required = false,
                                 default = newJBool(true))
  if valid_589971 != nil:
    section.add "pp", valid_589971
  var valid_589972 = query.getOrDefault("oauth_token")
  valid_589972 = validateParameter(valid_589972, JString, required = false,
                                 default = nil)
  if valid_589972 != nil:
    section.add "oauth_token", valid_589972
  var valid_589973 = query.getOrDefault("callback")
  valid_589973 = validateParameter(valid_589973, JString, required = false,
                                 default = nil)
  if valid_589973 != nil:
    section.add "callback", valid_589973
  var valid_589974 = query.getOrDefault("access_token")
  valid_589974 = validateParameter(valid_589974, JString, required = false,
                                 default = nil)
  if valid_589974 != nil:
    section.add "access_token", valid_589974
  var valid_589975 = query.getOrDefault("uploadType")
  valid_589975 = validateParameter(valid_589975, JString, required = false,
                                 default = nil)
  if valid_589975 != nil:
    section.add "uploadType", valid_589975
  var valid_589976 = query.getOrDefault("key")
  valid_589976 = validateParameter(valid_589976, JString, required = false,
                                 default = nil)
  if valid_589976 != nil:
    section.add "key", valid_589976
  var valid_589977 = query.getOrDefault("$.xgafv")
  valid_589977 = validateParameter(valid_589977, JString, required = false,
                                 default = newJString("1"))
  if valid_589977 != nil:
    section.add "$.xgafv", valid_589977
  var valid_589978 = query.getOrDefault("prettyPrint")
  valid_589978 = validateParameter(valid_589978, JBool, required = false,
                                 default = newJBool(true))
  if valid_589978 != nil:
    section.add "prettyPrint", valid_589978
  var valid_589979 = query.getOrDefault("bearer_token")
  valid_589979 = validateParameter(valid_589979, JString, required = false,
                                 default = nil)
  if valid_589979 != nil:
    section.add "bearer_token", valid_589979
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

proc call*(call_589981: Call_ContainerProjectsLocationsClustersSetLogging_589963;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service of a specific cluster.
  ## 
  let valid = call_589981.validator(path, query, header, formData, body)
  let scheme = call_589981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589981.url(scheme.get, call_589981.host, call_589981.base,
                         call_589981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589981, url, valid)

proc call*(call_589982: Call_ContainerProjectsLocationsClustersSetLogging_589963;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLogging
  ## Sets the logging service of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set logging.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589983 = newJObject()
  var query_589984 = newJObject()
  var body_589985 = newJObject()
  add(query_589984, "upload_protocol", newJString(uploadProtocol))
  add(query_589984, "fields", newJString(fields))
  add(query_589984, "quotaUser", newJString(quotaUser))
  add(path_589983, "name", newJString(name))
  add(query_589984, "alt", newJString(alt))
  add(query_589984, "pp", newJBool(pp))
  add(query_589984, "oauth_token", newJString(oauthToken))
  add(query_589984, "callback", newJString(callback))
  add(query_589984, "access_token", newJString(accessToken))
  add(query_589984, "uploadType", newJString(uploadType))
  add(query_589984, "key", newJString(key))
  add(query_589984, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589985 = body
  add(query_589984, "prettyPrint", newJBool(prettyPrint))
  add(query_589984, "bearer_token", newJString(bearerToken))
  result = call_589982.call(path_589983, query_589984, nil, nil, body_589985)

var containerProjectsLocationsClustersSetLogging* = Call_ContainerProjectsLocationsClustersSetLogging_589963(
    name: "containerProjectsLocationsClustersSetLogging",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLogging",
    validator: validate_ContainerProjectsLocationsClustersSetLogging_589964,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLogging_589965,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_589986 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetMaintenancePolicy_589988(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMaintenancePolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_589987(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the maintenance policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to set maintenance
  ## policy.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589989 = path.getOrDefault("name")
  valid_589989 = validateParameter(valid_589989, JString, required = true,
                                 default = nil)
  if valid_589989 != nil:
    section.add "name", valid_589989
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589990 = query.getOrDefault("upload_protocol")
  valid_589990 = validateParameter(valid_589990, JString, required = false,
                                 default = nil)
  if valid_589990 != nil:
    section.add "upload_protocol", valid_589990
  var valid_589991 = query.getOrDefault("fields")
  valid_589991 = validateParameter(valid_589991, JString, required = false,
                                 default = nil)
  if valid_589991 != nil:
    section.add "fields", valid_589991
  var valid_589992 = query.getOrDefault("quotaUser")
  valid_589992 = validateParameter(valid_589992, JString, required = false,
                                 default = nil)
  if valid_589992 != nil:
    section.add "quotaUser", valid_589992
  var valid_589993 = query.getOrDefault("alt")
  valid_589993 = validateParameter(valid_589993, JString, required = false,
                                 default = newJString("json"))
  if valid_589993 != nil:
    section.add "alt", valid_589993
  var valid_589994 = query.getOrDefault("pp")
  valid_589994 = validateParameter(valid_589994, JBool, required = false,
                                 default = newJBool(true))
  if valid_589994 != nil:
    section.add "pp", valid_589994
  var valid_589995 = query.getOrDefault("oauth_token")
  valid_589995 = validateParameter(valid_589995, JString, required = false,
                                 default = nil)
  if valid_589995 != nil:
    section.add "oauth_token", valid_589995
  var valid_589996 = query.getOrDefault("callback")
  valid_589996 = validateParameter(valid_589996, JString, required = false,
                                 default = nil)
  if valid_589996 != nil:
    section.add "callback", valid_589996
  var valid_589997 = query.getOrDefault("access_token")
  valid_589997 = validateParameter(valid_589997, JString, required = false,
                                 default = nil)
  if valid_589997 != nil:
    section.add "access_token", valid_589997
  var valid_589998 = query.getOrDefault("uploadType")
  valid_589998 = validateParameter(valid_589998, JString, required = false,
                                 default = nil)
  if valid_589998 != nil:
    section.add "uploadType", valid_589998
  var valid_589999 = query.getOrDefault("key")
  valid_589999 = validateParameter(valid_589999, JString, required = false,
                                 default = nil)
  if valid_589999 != nil:
    section.add "key", valid_589999
  var valid_590000 = query.getOrDefault("$.xgafv")
  valid_590000 = validateParameter(valid_590000, JString, required = false,
                                 default = newJString("1"))
  if valid_590000 != nil:
    section.add "$.xgafv", valid_590000
  var valid_590001 = query.getOrDefault("prettyPrint")
  valid_590001 = validateParameter(valid_590001, JBool, required = false,
                                 default = newJBool(true))
  if valid_590001 != nil:
    section.add "prettyPrint", valid_590001
  var valid_590002 = query.getOrDefault("bearer_token")
  valid_590002 = validateParameter(valid_590002, JString, required = false,
                                 default = nil)
  if valid_590002 != nil:
    section.add "bearer_token", valid_590002
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

proc call*(call_590004: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_589986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_590004.validator(path, query, header, formData, body)
  let scheme = call_590004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590004.url(scheme.get, call_590004.host, call_590004.base,
                         call_590004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590004, url, valid)

proc call*(call_590005: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_589986;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMaintenancePolicy
  ## Sets the maintenance policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set maintenance
  ## policy.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590006 = newJObject()
  var query_590007 = newJObject()
  var body_590008 = newJObject()
  add(query_590007, "upload_protocol", newJString(uploadProtocol))
  add(query_590007, "fields", newJString(fields))
  add(query_590007, "quotaUser", newJString(quotaUser))
  add(path_590006, "name", newJString(name))
  add(query_590007, "alt", newJString(alt))
  add(query_590007, "pp", newJBool(pp))
  add(query_590007, "oauth_token", newJString(oauthToken))
  add(query_590007, "callback", newJString(callback))
  add(query_590007, "access_token", newJString(accessToken))
  add(query_590007, "uploadType", newJString(uploadType))
  add(query_590007, "key", newJString(key))
  add(query_590007, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590008 = body
  add(query_590007, "prettyPrint", newJBool(prettyPrint))
  add(query_590007, "bearer_token", newJString(bearerToken))
  result = call_590005.call(path_590006, query_590007, nil, nil, body_590008)

var containerProjectsLocationsClustersSetMaintenancePolicy* = Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_589986(
    name: "containerProjectsLocationsClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMaintenancePolicy",
    validator: validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_589987,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMaintenancePolicy_589988,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_590009 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsSetManagement_590011(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setManagement")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_590010(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the NodeManagement options for a node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to set
  ## management properties. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_590012 = path.getOrDefault("name")
  valid_590012 = validateParameter(valid_590012, JString, required = true,
                                 default = nil)
  if valid_590012 != nil:
    section.add "name", valid_590012
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590013 = query.getOrDefault("upload_protocol")
  valid_590013 = validateParameter(valid_590013, JString, required = false,
                                 default = nil)
  if valid_590013 != nil:
    section.add "upload_protocol", valid_590013
  var valid_590014 = query.getOrDefault("fields")
  valid_590014 = validateParameter(valid_590014, JString, required = false,
                                 default = nil)
  if valid_590014 != nil:
    section.add "fields", valid_590014
  var valid_590015 = query.getOrDefault("quotaUser")
  valid_590015 = validateParameter(valid_590015, JString, required = false,
                                 default = nil)
  if valid_590015 != nil:
    section.add "quotaUser", valid_590015
  var valid_590016 = query.getOrDefault("alt")
  valid_590016 = validateParameter(valid_590016, JString, required = false,
                                 default = newJString("json"))
  if valid_590016 != nil:
    section.add "alt", valid_590016
  var valid_590017 = query.getOrDefault("pp")
  valid_590017 = validateParameter(valid_590017, JBool, required = false,
                                 default = newJBool(true))
  if valid_590017 != nil:
    section.add "pp", valid_590017
  var valid_590018 = query.getOrDefault("oauth_token")
  valid_590018 = validateParameter(valid_590018, JString, required = false,
                                 default = nil)
  if valid_590018 != nil:
    section.add "oauth_token", valid_590018
  var valid_590019 = query.getOrDefault("callback")
  valid_590019 = validateParameter(valid_590019, JString, required = false,
                                 default = nil)
  if valid_590019 != nil:
    section.add "callback", valid_590019
  var valid_590020 = query.getOrDefault("access_token")
  valid_590020 = validateParameter(valid_590020, JString, required = false,
                                 default = nil)
  if valid_590020 != nil:
    section.add "access_token", valid_590020
  var valid_590021 = query.getOrDefault("uploadType")
  valid_590021 = validateParameter(valid_590021, JString, required = false,
                                 default = nil)
  if valid_590021 != nil:
    section.add "uploadType", valid_590021
  var valid_590022 = query.getOrDefault("key")
  valid_590022 = validateParameter(valid_590022, JString, required = false,
                                 default = nil)
  if valid_590022 != nil:
    section.add "key", valid_590022
  var valid_590023 = query.getOrDefault("$.xgafv")
  valid_590023 = validateParameter(valid_590023, JString, required = false,
                                 default = newJString("1"))
  if valid_590023 != nil:
    section.add "$.xgafv", valid_590023
  var valid_590024 = query.getOrDefault("prettyPrint")
  valid_590024 = validateParameter(valid_590024, JBool, required = false,
                                 default = newJBool(true))
  if valid_590024 != nil:
    section.add "prettyPrint", valid_590024
  var valid_590025 = query.getOrDefault("bearer_token")
  valid_590025 = validateParameter(valid_590025, JString, required = false,
                                 default = nil)
  if valid_590025 != nil:
    section.add "bearer_token", valid_590025
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

proc call*(call_590027: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_590009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_590027.validator(path, query, header, formData, body)
  let scheme = call_590027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590027.url(scheme.get, call_590027.host, call_590027.base,
                         call_590027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590027, url, valid)

proc call*(call_590028: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_590009;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetManagement
  ## Sets the NodeManagement options for a node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to set
  ## management properties. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590029 = newJObject()
  var query_590030 = newJObject()
  var body_590031 = newJObject()
  add(query_590030, "upload_protocol", newJString(uploadProtocol))
  add(query_590030, "fields", newJString(fields))
  add(query_590030, "quotaUser", newJString(quotaUser))
  add(path_590029, "name", newJString(name))
  add(query_590030, "alt", newJString(alt))
  add(query_590030, "pp", newJBool(pp))
  add(query_590030, "oauth_token", newJString(oauthToken))
  add(query_590030, "callback", newJString(callback))
  add(query_590030, "access_token", newJString(accessToken))
  add(query_590030, "uploadType", newJString(uploadType))
  add(query_590030, "key", newJString(key))
  add(query_590030, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590031 = body
  add(query_590030, "prettyPrint", newJBool(prettyPrint))
  add(query_590030, "bearer_token", newJString(bearerToken))
  result = call_590028.call(path_590029, query_590030, nil, nil, body_590031)

var containerProjectsLocationsClustersNodePoolsSetManagement* = Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_590009(
    name: "containerProjectsLocationsClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setManagement", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_590010,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetManagement_590011,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMasterAuth_590032 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetMasterAuth_590034(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMasterAuth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMasterAuth_590033(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set auth.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_590035 = path.getOrDefault("name")
  valid_590035 = validateParameter(valid_590035, JString, required = true,
                                 default = nil)
  if valid_590035 != nil:
    section.add "name", valid_590035
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590036 = query.getOrDefault("upload_protocol")
  valid_590036 = validateParameter(valid_590036, JString, required = false,
                                 default = nil)
  if valid_590036 != nil:
    section.add "upload_protocol", valid_590036
  var valid_590037 = query.getOrDefault("fields")
  valid_590037 = validateParameter(valid_590037, JString, required = false,
                                 default = nil)
  if valid_590037 != nil:
    section.add "fields", valid_590037
  var valid_590038 = query.getOrDefault("quotaUser")
  valid_590038 = validateParameter(valid_590038, JString, required = false,
                                 default = nil)
  if valid_590038 != nil:
    section.add "quotaUser", valid_590038
  var valid_590039 = query.getOrDefault("alt")
  valid_590039 = validateParameter(valid_590039, JString, required = false,
                                 default = newJString("json"))
  if valid_590039 != nil:
    section.add "alt", valid_590039
  var valid_590040 = query.getOrDefault("pp")
  valid_590040 = validateParameter(valid_590040, JBool, required = false,
                                 default = newJBool(true))
  if valid_590040 != nil:
    section.add "pp", valid_590040
  var valid_590041 = query.getOrDefault("oauth_token")
  valid_590041 = validateParameter(valid_590041, JString, required = false,
                                 default = nil)
  if valid_590041 != nil:
    section.add "oauth_token", valid_590041
  var valid_590042 = query.getOrDefault("callback")
  valid_590042 = validateParameter(valid_590042, JString, required = false,
                                 default = nil)
  if valid_590042 != nil:
    section.add "callback", valid_590042
  var valid_590043 = query.getOrDefault("access_token")
  valid_590043 = validateParameter(valid_590043, JString, required = false,
                                 default = nil)
  if valid_590043 != nil:
    section.add "access_token", valid_590043
  var valid_590044 = query.getOrDefault("uploadType")
  valid_590044 = validateParameter(valid_590044, JString, required = false,
                                 default = nil)
  if valid_590044 != nil:
    section.add "uploadType", valid_590044
  var valid_590045 = query.getOrDefault("key")
  valid_590045 = validateParameter(valid_590045, JString, required = false,
                                 default = nil)
  if valid_590045 != nil:
    section.add "key", valid_590045
  var valid_590046 = query.getOrDefault("$.xgafv")
  valid_590046 = validateParameter(valid_590046, JString, required = false,
                                 default = newJString("1"))
  if valid_590046 != nil:
    section.add "$.xgafv", valid_590046
  var valid_590047 = query.getOrDefault("prettyPrint")
  valid_590047 = validateParameter(valid_590047, JBool, required = false,
                                 default = newJBool(true))
  if valid_590047 != nil:
    section.add "prettyPrint", valid_590047
  var valid_590048 = query.getOrDefault("bearer_token")
  valid_590048 = validateParameter(valid_590048, JString, required = false,
                                 default = nil)
  if valid_590048 != nil:
    section.add "bearer_token", valid_590048
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

proc call*(call_590050: Call_ContainerProjectsLocationsClustersSetMasterAuth_590032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  let valid = call_590050.validator(path, query, header, formData, body)
  let scheme = call_590050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590050.url(scheme.get, call_590050.host, call_590050.base,
                         call_590050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590050, url, valid)

proc call*(call_590051: Call_ContainerProjectsLocationsClustersSetMasterAuth_590032;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMasterAuth
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set auth.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590052 = newJObject()
  var query_590053 = newJObject()
  var body_590054 = newJObject()
  add(query_590053, "upload_protocol", newJString(uploadProtocol))
  add(query_590053, "fields", newJString(fields))
  add(query_590053, "quotaUser", newJString(quotaUser))
  add(path_590052, "name", newJString(name))
  add(query_590053, "alt", newJString(alt))
  add(query_590053, "pp", newJBool(pp))
  add(query_590053, "oauth_token", newJString(oauthToken))
  add(query_590053, "callback", newJString(callback))
  add(query_590053, "access_token", newJString(accessToken))
  add(query_590053, "uploadType", newJString(uploadType))
  add(query_590053, "key", newJString(key))
  add(query_590053, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590054 = body
  add(query_590053, "prettyPrint", newJBool(prettyPrint))
  add(query_590053, "bearer_token", newJString(bearerToken))
  result = call_590051.call(path_590052, query_590053, nil, nil, body_590054)

var containerProjectsLocationsClustersSetMasterAuth* = Call_ContainerProjectsLocationsClustersSetMasterAuth_590032(
    name: "containerProjectsLocationsClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMasterAuth",
    validator: validate_ContainerProjectsLocationsClustersSetMasterAuth_590033,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMasterAuth_590034,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMonitoring_590055 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetMonitoring_590057(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMonitoring")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMonitoring_590056(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the monitoring service of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set monitoring.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_590058 = path.getOrDefault("name")
  valid_590058 = validateParameter(valid_590058, JString, required = true,
                                 default = nil)
  if valid_590058 != nil:
    section.add "name", valid_590058
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590059 = query.getOrDefault("upload_protocol")
  valid_590059 = validateParameter(valid_590059, JString, required = false,
                                 default = nil)
  if valid_590059 != nil:
    section.add "upload_protocol", valid_590059
  var valid_590060 = query.getOrDefault("fields")
  valid_590060 = validateParameter(valid_590060, JString, required = false,
                                 default = nil)
  if valid_590060 != nil:
    section.add "fields", valid_590060
  var valid_590061 = query.getOrDefault("quotaUser")
  valid_590061 = validateParameter(valid_590061, JString, required = false,
                                 default = nil)
  if valid_590061 != nil:
    section.add "quotaUser", valid_590061
  var valid_590062 = query.getOrDefault("alt")
  valid_590062 = validateParameter(valid_590062, JString, required = false,
                                 default = newJString("json"))
  if valid_590062 != nil:
    section.add "alt", valid_590062
  var valid_590063 = query.getOrDefault("pp")
  valid_590063 = validateParameter(valid_590063, JBool, required = false,
                                 default = newJBool(true))
  if valid_590063 != nil:
    section.add "pp", valid_590063
  var valid_590064 = query.getOrDefault("oauth_token")
  valid_590064 = validateParameter(valid_590064, JString, required = false,
                                 default = nil)
  if valid_590064 != nil:
    section.add "oauth_token", valid_590064
  var valid_590065 = query.getOrDefault("callback")
  valid_590065 = validateParameter(valid_590065, JString, required = false,
                                 default = nil)
  if valid_590065 != nil:
    section.add "callback", valid_590065
  var valid_590066 = query.getOrDefault("access_token")
  valid_590066 = validateParameter(valid_590066, JString, required = false,
                                 default = nil)
  if valid_590066 != nil:
    section.add "access_token", valid_590066
  var valid_590067 = query.getOrDefault("uploadType")
  valid_590067 = validateParameter(valid_590067, JString, required = false,
                                 default = nil)
  if valid_590067 != nil:
    section.add "uploadType", valid_590067
  var valid_590068 = query.getOrDefault("key")
  valid_590068 = validateParameter(valid_590068, JString, required = false,
                                 default = nil)
  if valid_590068 != nil:
    section.add "key", valid_590068
  var valid_590069 = query.getOrDefault("$.xgafv")
  valid_590069 = validateParameter(valid_590069, JString, required = false,
                                 default = newJString("1"))
  if valid_590069 != nil:
    section.add "$.xgafv", valid_590069
  var valid_590070 = query.getOrDefault("prettyPrint")
  valid_590070 = validateParameter(valid_590070, JBool, required = false,
                                 default = newJBool(true))
  if valid_590070 != nil:
    section.add "prettyPrint", valid_590070
  var valid_590071 = query.getOrDefault("bearer_token")
  valid_590071 = validateParameter(valid_590071, JString, required = false,
                                 default = nil)
  if valid_590071 != nil:
    section.add "bearer_token", valid_590071
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

proc call*(call_590073: Call_ContainerProjectsLocationsClustersSetMonitoring_590055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service of a specific cluster.
  ## 
  let valid = call_590073.validator(path, query, header, formData, body)
  let scheme = call_590073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590073.url(scheme.get, call_590073.host, call_590073.base,
                         call_590073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590073, url, valid)

proc call*(call_590074: Call_ContainerProjectsLocationsClustersSetMonitoring_590055;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMonitoring
  ## Sets the monitoring service of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set monitoring.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590075 = newJObject()
  var query_590076 = newJObject()
  var body_590077 = newJObject()
  add(query_590076, "upload_protocol", newJString(uploadProtocol))
  add(query_590076, "fields", newJString(fields))
  add(query_590076, "quotaUser", newJString(quotaUser))
  add(path_590075, "name", newJString(name))
  add(query_590076, "alt", newJString(alt))
  add(query_590076, "pp", newJBool(pp))
  add(query_590076, "oauth_token", newJString(oauthToken))
  add(query_590076, "callback", newJString(callback))
  add(query_590076, "access_token", newJString(accessToken))
  add(query_590076, "uploadType", newJString(uploadType))
  add(query_590076, "key", newJString(key))
  add(query_590076, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590077 = body
  add(query_590076, "prettyPrint", newJBool(prettyPrint))
  add(query_590076, "bearer_token", newJString(bearerToken))
  result = call_590074.call(path_590075, query_590076, nil, nil, body_590077)

var containerProjectsLocationsClustersSetMonitoring* = Call_ContainerProjectsLocationsClustersSetMonitoring_590055(
    name: "containerProjectsLocationsClustersSetMonitoring",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMonitoring",
    validator: validate_ContainerProjectsLocationsClustersSetMonitoring_590056,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMonitoring_590057,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetNetworkPolicy_590078 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetNetworkPolicy_590080(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setNetworkPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetNetworkPolicy_590079(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to set networking policy.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_590081 = path.getOrDefault("name")
  valid_590081 = validateParameter(valid_590081, JString, required = true,
                                 default = nil)
  if valid_590081 != nil:
    section.add "name", valid_590081
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590082 = query.getOrDefault("upload_protocol")
  valid_590082 = validateParameter(valid_590082, JString, required = false,
                                 default = nil)
  if valid_590082 != nil:
    section.add "upload_protocol", valid_590082
  var valid_590083 = query.getOrDefault("fields")
  valid_590083 = validateParameter(valid_590083, JString, required = false,
                                 default = nil)
  if valid_590083 != nil:
    section.add "fields", valid_590083
  var valid_590084 = query.getOrDefault("quotaUser")
  valid_590084 = validateParameter(valid_590084, JString, required = false,
                                 default = nil)
  if valid_590084 != nil:
    section.add "quotaUser", valid_590084
  var valid_590085 = query.getOrDefault("alt")
  valid_590085 = validateParameter(valid_590085, JString, required = false,
                                 default = newJString("json"))
  if valid_590085 != nil:
    section.add "alt", valid_590085
  var valid_590086 = query.getOrDefault("pp")
  valid_590086 = validateParameter(valid_590086, JBool, required = false,
                                 default = newJBool(true))
  if valid_590086 != nil:
    section.add "pp", valid_590086
  var valid_590087 = query.getOrDefault("oauth_token")
  valid_590087 = validateParameter(valid_590087, JString, required = false,
                                 default = nil)
  if valid_590087 != nil:
    section.add "oauth_token", valid_590087
  var valid_590088 = query.getOrDefault("callback")
  valid_590088 = validateParameter(valid_590088, JString, required = false,
                                 default = nil)
  if valid_590088 != nil:
    section.add "callback", valid_590088
  var valid_590089 = query.getOrDefault("access_token")
  valid_590089 = validateParameter(valid_590089, JString, required = false,
                                 default = nil)
  if valid_590089 != nil:
    section.add "access_token", valid_590089
  var valid_590090 = query.getOrDefault("uploadType")
  valid_590090 = validateParameter(valid_590090, JString, required = false,
                                 default = nil)
  if valid_590090 != nil:
    section.add "uploadType", valid_590090
  var valid_590091 = query.getOrDefault("key")
  valid_590091 = validateParameter(valid_590091, JString, required = false,
                                 default = nil)
  if valid_590091 != nil:
    section.add "key", valid_590091
  var valid_590092 = query.getOrDefault("$.xgafv")
  valid_590092 = validateParameter(valid_590092, JString, required = false,
                                 default = newJString("1"))
  if valid_590092 != nil:
    section.add "$.xgafv", valid_590092
  var valid_590093 = query.getOrDefault("prettyPrint")
  valid_590093 = validateParameter(valid_590093, JBool, required = false,
                                 default = newJBool(true))
  if valid_590093 != nil:
    section.add "prettyPrint", valid_590093
  var valid_590094 = query.getOrDefault("bearer_token")
  valid_590094 = validateParameter(valid_590094, JString, required = false,
                                 default = nil)
  if valid_590094 != nil:
    section.add "bearer_token", valid_590094
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

proc call*(call_590096: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_590078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  let valid = call_590096.validator(path, query, header, formData, body)
  let scheme = call_590096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590096.url(scheme.get, call_590096.host, call_590096.base,
                         call_590096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590096, url, valid)

proc call*(call_590097: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_590078;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetNetworkPolicy
  ## Enables/Disables Network Policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set networking policy.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590098 = newJObject()
  var query_590099 = newJObject()
  var body_590100 = newJObject()
  add(query_590099, "upload_protocol", newJString(uploadProtocol))
  add(query_590099, "fields", newJString(fields))
  add(query_590099, "quotaUser", newJString(quotaUser))
  add(path_590098, "name", newJString(name))
  add(query_590099, "alt", newJString(alt))
  add(query_590099, "pp", newJBool(pp))
  add(query_590099, "oauth_token", newJString(oauthToken))
  add(query_590099, "callback", newJString(callback))
  add(query_590099, "access_token", newJString(accessToken))
  add(query_590099, "uploadType", newJString(uploadType))
  add(query_590099, "key", newJString(key))
  add(query_590099, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590100 = body
  add(query_590099, "prettyPrint", newJBool(prettyPrint))
  add(query_590099, "bearer_token", newJString(bearerToken))
  result = call_590097.call(path_590098, query_590099, nil, nil, body_590100)

var containerProjectsLocationsClustersSetNetworkPolicy* = Call_ContainerProjectsLocationsClustersSetNetworkPolicy_590078(
    name: "containerProjectsLocationsClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setNetworkPolicy",
    validator: validate_ContainerProjectsLocationsClustersSetNetworkPolicy_590079,
    base: "/", url: url_ContainerProjectsLocationsClustersSetNetworkPolicy_590080,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetResourceLabels_590101 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetResourceLabels_590103(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setResourceLabels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetResourceLabels_590102(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets labels on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to set labels.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_590104 = path.getOrDefault("name")
  valid_590104 = validateParameter(valid_590104, JString, required = true,
                                 default = nil)
  if valid_590104 != nil:
    section.add "name", valid_590104
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590105 = query.getOrDefault("upload_protocol")
  valid_590105 = validateParameter(valid_590105, JString, required = false,
                                 default = nil)
  if valid_590105 != nil:
    section.add "upload_protocol", valid_590105
  var valid_590106 = query.getOrDefault("fields")
  valid_590106 = validateParameter(valid_590106, JString, required = false,
                                 default = nil)
  if valid_590106 != nil:
    section.add "fields", valid_590106
  var valid_590107 = query.getOrDefault("quotaUser")
  valid_590107 = validateParameter(valid_590107, JString, required = false,
                                 default = nil)
  if valid_590107 != nil:
    section.add "quotaUser", valid_590107
  var valid_590108 = query.getOrDefault("alt")
  valid_590108 = validateParameter(valid_590108, JString, required = false,
                                 default = newJString("json"))
  if valid_590108 != nil:
    section.add "alt", valid_590108
  var valid_590109 = query.getOrDefault("pp")
  valid_590109 = validateParameter(valid_590109, JBool, required = false,
                                 default = newJBool(true))
  if valid_590109 != nil:
    section.add "pp", valid_590109
  var valid_590110 = query.getOrDefault("oauth_token")
  valid_590110 = validateParameter(valid_590110, JString, required = false,
                                 default = nil)
  if valid_590110 != nil:
    section.add "oauth_token", valid_590110
  var valid_590111 = query.getOrDefault("callback")
  valid_590111 = validateParameter(valid_590111, JString, required = false,
                                 default = nil)
  if valid_590111 != nil:
    section.add "callback", valid_590111
  var valid_590112 = query.getOrDefault("access_token")
  valid_590112 = validateParameter(valid_590112, JString, required = false,
                                 default = nil)
  if valid_590112 != nil:
    section.add "access_token", valid_590112
  var valid_590113 = query.getOrDefault("uploadType")
  valid_590113 = validateParameter(valid_590113, JString, required = false,
                                 default = nil)
  if valid_590113 != nil:
    section.add "uploadType", valid_590113
  var valid_590114 = query.getOrDefault("key")
  valid_590114 = validateParameter(valid_590114, JString, required = false,
                                 default = nil)
  if valid_590114 != nil:
    section.add "key", valid_590114
  var valid_590115 = query.getOrDefault("$.xgafv")
  valid_590115 = validateParameter(valid_590115, JString, required = false,
                                 default = newJString("1"))
  if valid_590115 != nil:
    section.add "$.xgafv", valid_590115
  var valid_590116 = query.getOrDefault("prettyPrint")
  valid_590116 = validateParameter(valid_590116, JBool, required = false,
                                 default = newJBool(true))
  if valid_590116 != nil:
    section.add "prettyPrint", valid_590116
  var valid_590117 = query.getOrDefault("bearer_token")
  valid_590117 = validateParameter(valid_590117, JString, required = false,
                                 default = nil)
  if valid_590117 != nil:
    section.add "bearer_token", valid_590117
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

proc call*(call_590119: Call_ContainerProjectsLocationsClustersSetResourceLabels_590101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_590119.validator(path, query, header, formData, body)
  let scheme = call_590119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590119.url(scheme.get, call_590119.host, call_590119.base,
                         call_590119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590119, url, valid)

proc call*(call_590120: Call_ContainerProjectsLocationsClustersSetResourceLabels_590101;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetResourceLabels
  ## Sets labels on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set labels.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590121 = newJObject()
  var query_590122 = newJObject()
  var body_590123 = newJObject()
  add(query_590122, "upload_protocol", newJString(uploadProtocol))
  add(query_590122, "fields", newJString(fields))
  add(query_590122, "quotaUser", newJString(quotaUser))
  add(path_590121, "name", newJString(name))
  add(query_590122, "alt", newJString(alt))
  add(query_590122, "pp", newJBool(pp))
  add(query_590122, "oauth_token", newJString(oauthToken))
  add(query_590122, "callback", newJString(callback))
  add(query_590122, "access_token", newJString(accessToken))
  add(query_590122, "uploadType", newJString(uploadType))
  add(query_590122, "key", newJString(key))
  add(query_590122, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590123 = body
  add(query_590122, "prettyPrint", newJBool(prettyPrint))
  add(query_590122, "bearer_token", newJString(bearerToken))
  result = call_590120.call(path_590121, query_590122, nil, nil, body_590123)

var containerProjectsLocationsClustersSetResourceLabels* = Call_ContainerProjectsLocationsClustersSetResourceLabels_590101(
    name: "containerProjectsLocationsClustersSetResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setResourceLabels",
    validator: validate_ContainerProjectsLocationsClustersSetResourceLabels_590102,
    base: "/", url: url_ContainerProjectsLocationsClustersSetResourceLabels_590103,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersStartIpRotation_590124 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersStartIpRotation_590126(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":startIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersStartIpRotation_590125(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Start master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to start IP rotation.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_590127 = path.getOrDefault("name")
  valid_590127 = validateParameter(valid_590127, JString, required = true,
                                 default = nil)
  if valid_590127 != nil:
    section.add "name", valid_590127
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590128 = query.getOrDefault("upload_protocol")
  valid_590128 = validateParameter(valid_590128, JString, required = false,
                                 default = nil)
  if valid_590128 != nil:
    section.add "upload_protocol", valid_590128
  var valid_590129 = query.getOrDefault("fields")
  valid_590129 = validateParameter(valid_590129, JString, required = false,
                                 default = nil)
  if valid_590129 != nil:
    section.add "fields", valid_590129
  var valid_590130 = query.getOrDefault("quotaUser")
  valid_590130 = validateParameter(valid_590130, JString, required = false,
                                 default = nil)
  if valid_590130 != nil:
    section.add "quotaUser", valid_590130
  var valid_590131 = query.getOrDefault("alt")
  valid_590131 = validateParameter(valid_590131, JString, required = false,
                                 default = newJString("json"))
  if valid_590131 != nil:
    section.add "alt", valid_590131
  var valid_590132 = query.getOrDefault("pp")
  valid_590132 = validateParameter(valid_590132, JBool, required = false,
                                 default = newJBool(true))
  if valid_590132 != nil:
    section.add "pp", valid_590132
  var valid_590133 = query.getOrDefault("oauth_token")
  valid_590133 = validateParameter(valid_590133, JString, required = false,
                                 default = nil)
  if valid_590133 != nil:
    section.add "oauth_token", valid_590133
  var valid_590134 = query.getOrDefault("callback")
  valid_590134 = validateParameter(valid_590134, JString, required = false,
                                 default = nil)
  if valid_590134 != nil:
    section.add "callback", valid_590134
  var valid_590135 = query.getOrDefault("access_token")
  valid_590135 = validateParameter(valid_590135, JString, required = false,
                                 default = nil)
  if valid_590135 != nil:
    section.add "access_token", valid_590135
  var valid_590136 = query.getOrDefault("uploadType")
  valid_590136 = validateParameter(valid_590136, JString, required = false,
                                 default = nil)
  if valid_590136 != nil:
    section.add "uploadType", valid_590136
  var valid_590137 = query.getOrDefault("key")
  valid_590137 = validateParameter(valid_590137, JString, required = false,
                                 default = nil)
  if valid_590137 != nil:
    section.add "key", valid_590137
  var valid_590138 = query.getOrDefault("$.xgafv")
  valid_590138 = validateParameter(valid_590138, JString, required = false,
                                 default = newJString("1"))
  if valid_590138 != nil:
    section.add "$.xgafv", valid_590138
  var valid_590139 = query.getOrDefault("prettyPrint")
  valid_590139 = validateParameter(valid_590139, JBool, required = false,
                                 default = newJBool(true))
  if valid_590139 != nil:
    section.add "prettyPrint", valid_590139
  var valid_590140 = query.getOrDefault("bearer_token")
  valid_590140 = validateParameter(valid_590140, JString, required = false,
                                 default = nil)
  if valid_590140 != nil:
    section.add "bearer_token", valid_590140
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

proc call*(call_590142: Call_ContainerProjectsLocationsClustersStartIpRotation_590124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start master IP rotation.
  ## 
  let valid = call_590142.validator(path, query, header, formData, body)
  let scheme = call_590142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590142.url(scheme.get, call_590142.host, call_590142.base,
                         call_590142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590142, url, valid)

proc call*(call_590143: Call_ContainerProjectsLocationsClustersStartIpRotation_590124;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersStartIpRotation
  ## Start master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to start IP rotation.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590144 = newJObject()
  var query_590145 = newJObject()
  var body_590146 = newJObject()
  add(query_590145, "upload_protocol", newJString(uploadProtocol))
  add(query_590145, "fields", newJString(fields))
  add(query_590145, "quotaUser", newJString(quotaUser))
  add(path_590144, "name", newJString(name))
  add(query_590145, "alt", newJString(alt))
  add(query_590145, "pp", newJBool(pp))
  add(query_590145, "oauth_token", newJString(oauthToken))
  add(query_590145, "callback", newJString(callback))
  add(query_590145, "access_token", newJString(accessToken))
  add(query_590145, "uploadType", newJString(uploadType))
  add(query_590145, "key", newJString(key))
  add(query_590145, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590146 = body
  add(query_590145, "prettyPrint", newJBool(prettyPrint))
  add(query_590145, "bearer_token", newJString(bearerToken))
  result = call_590143.call(path_590144, query_590145, nil, nil, body_590146)

var containerProjectsLocationsClustersStartIpRotation* = Call_ContainerProjectsLocationsClustersStartIpRotation_590124(
    name: "containerProjectsLocationsClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:startIpRotation",
    validator: validate_ContainerProjectsLocationsClustersStartIpRotation_590125,
    base: "/", url: url_ContainerProjectsLocationsClustersStartIpRotation_590126,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersUpdateMaster_590147 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersUpdateMaster_590149(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":updateMaster")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersUpdateMaster_590148(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the master of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to update.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_590150 = path.getOrDefault("name")
  valid_590150 = validateParameter(valid_590150, JString, required = true,
                                 default = nil)
  if valid_590150 != nil:
    section.add "name", valid_590150
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590151 = query.getOrDefault("upload_protocol")
  valid_590151 = validateParameter(valid_590151, JString, required = false,
                                 default = nil)
  if valid_590151 != nil:
    section.add "upload_protocol", valid_590151
  var valid_590152 = query.getOrDefault("fields")
  valid_590152 = validateParameter(valid_590152, JString, required = false,
                                 default = nil)
  if valid_590152 != nil:
    section.add "fields", valid_590152
  var valid_590153 = query.getOrDefault("quotaUser")
  valid_590153 = validateParameter(valid_590153, JString, required = false,
                                 default = nil)
  if valid_590153 != nil:
    section.add "quotaUser", valid_590153
  var valid_590154 = query.getOrDefault("alt")
  valid_590154 = validateParameter(valid_590154, JString, required = false,
                                 default = newJString("json"))
  if valid_590154 != nil:
    section.add "alt", valid_590154
  var valid_590155 = query.getOrDefault("pp")
  valid_590155 = validateParameter(valid_590155, JBool, required = false,
                                 default = newJBool(true))
  if valid_590155 != nil:
    section.add "pp", valid_590155
  var valid_590156 = query.getOrDefault("oauth_token")
  valid_590156 = validateParameter(valid_590156, JString, required = false,
                                 default = nil)
  if valid_590156 != nil:
    section.add "oauth_token", valid_590156
  var valid_590157 = query.getOrDefault("callback")
  valid_590157 = validateParameter(valid_590157, JString, required = false,
                                 default = nil)
  if valid_590157 != nil:
    section.add "callback", valid_590157
  var valid_590158 = query.getOrDefault("access_token")
  valid_590158 = validateParameter(valid_590158, JString, required = false,
                                 default = nil)
  if valid_590158 != nil:
    section.add "access_token", valid_590158
  var valid_590159 = query.getOrDefault("uploadType")
  valid_590159 = validateParameter(valid_590159, JString, required = false,
                                 default = nil)
  if valid_590159 != nil:
    section.add "uploadType", valid_590159
  var valid_590160 = query.getOrDefault("key")
  valid_590160 = validateParameter(valid_590160, JString, required = false,
                                 default = nil)
  if valid_590160 != nil:
    section.add "key", valid_590160
  var valid_590161 = query.getOrDefault("$.xgafv")
  valid_590161 = validateParameter(valid_590161, JString, required = false,
                                 default = newJString("1"))
  if valid_590161 != nil:
    section.add "$.xgafv", valid_590161
  var valid_590162 = query.getOrDefault("prettyPrint")
  valid_590162 = validateParameter(valid_590162, JBool, required = false,
                                 default = newJBool(true))
  if valid_590162 != nil:
    section.add "prettyPrint", valid_590162
  var valid_590163 = query.getOrDefault("bearer_token")
  valid_590163 = validateParameter(valid_590163, JString, required = false,
                                 default = nil)
  if valid_590163 != nil:
    section.add "bearer_token", valid_590163
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

proc call*(call_590165: Call_ContainerProjectsLocationsClustersUpdateMaster_590147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master of a specific cluster.
  ## 
  let valid = call_590165.validator(path, query, header, formData, body)
  let scheme = call_590165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590165.url(scheme.get, call_590165.host, call_590165.base,
                         call_590165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590165, url, valid)

proc call*(call_590166: Call_ContainerProjectsLocationsClustersUpdateMaster_590147;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersUpdateMaster
  ## Updates the master of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to update.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590167 = newJObject()
  var query_590168 = newJObject()
  var body_590169 = newJObject()
  add(query_590168, "upload_protocol", newJString(uploadProtocol))
  add(query_590168, "fields", newJString(fields))
  add(query_590168, "quotaUser", newJString(quotaUser))
  add(path_590167, "name", newJString(name))
  add(query_590168, "alt", newJString(alt))
  add(query_590168, "pp", newJBool(pp))
  add(query_590168, "oauth_token", newJString(oauthToken))
  add(query_590168, "callback", newJString(callback))
  add(query_590168, "access_token", newJString(accessToken))
  add(query_590168, "uploadType", newJString(uploadType))
  add(query_590168, "key", newJString(key))
  add(query_590168, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590169 = body
  add(query_590168, "prettyPrint", newJBool(prettyPrint))
  add(query_590168, "bearer_token", newJString(bearerToken))
  result = call_590166.call(path_590167, query_590168, nil, nil, body_590169)

var containerProjectsLocationsClustersUpdateMaster* = Call_ContainerProjectsLocationsClustersUpdateMaster_590147(
    name: "containerProjectsLocationsClustersUpdateMaster",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:updateMaster",
    validator: validate_ContainerProjectsLocationsClustersUpdateMaster_590148,
    base: "/", url: url_ContainerProjectsLocationsClustersUpdateMaster_590149,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCreate_590193 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersCreate_590195(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersCreate_590194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project and location) where the cluster will be created.
  ## Specified in the format 'projects/*/locations/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_590196 = path.getOrDefault("parent")
  valid_590196 = validateParameter(valid_590196, JString, required = true,
                                 default = nil)
  if valid_590196 != nil:
    section.add "parent", valid_590196
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590197 = query.getOrDefault("upload_protocol")
  valid_590197 = validateParameter(valid_590197, JString, required = false,
                                 default = nil)
  if valid_590197 != nil:
    section.add "upload_protocol", valid_590197
  var valid_590198 = query.getOrDefault("fields")
  valid_590198 = validateParameter(valid_590198, JString, required = false,
                                 default = nil)
  if valid_590198 != nil:
    section.add "fields", valid_590198
  var valid_590199 = query.getOrDefault("quotaUser")
  valid_590199 = validateParameter(valid_590199, JString, required = false,
                                 default = nil)
  if valid_590199 != nil:
    section.add "quotaUser", valid_590199
  var valid_590200 = query.getOrDefault("alt")
  valid_590200 = validateParameter(valid_590200, JString, required = false,
                                 default = newJString("json"))
  if valid_590200 != nil:
    section.add "alt", valid_590200
  var valid_590201 = query.getOrDefault("pp")
  valid_590201 = validateParameter(valid_590201, JBool, required = false,
                                 default = newJBool(true))
  if valid_590201 != nil:
    section.add "pp", valid_590201
  var valid_590202 = query.getOrDefault("oauth_token")
  valid_590202 = validateParameter(valid_590202, JString, required = false,
                                 default = nil)
  if valid_590202 != nil:
    section.add "oauth_token", valid_590202
  var valid_590203 = query.getOrDefault("callback")
  valid_590203 = validateParameter(valid_590203, JString, required = false,
                                 default = nil)
  if valid_590203 != nil:
    section.add "callback", valid_590203
  var valid_590204 = query.getOrDefault("access_token")
  valid_590204 = validateParameter(valid_590204, JString, required = false,
                                 default = nil)
  if valid_590204 != nil:
    section.add "access_token", valid_590204
  var valid_590205 = query.getOrDefault("uploadType")
  valid_590205 = validateParameter(valid_590205, JString, required = false,
                                 default = nil)
  if valid_590205 != nil:
    section.add "uploadType", valid_590205
  var valid_590206 = query.getOrDefault("key")
  valid_590206 = validateParameter(valid_590206, JString, required = false,
                                 default = nil)
  if valid_590206 != nil:
    section.add "key", valid_590206
  var valid_590207 = query.getOrDefault("$.xgafv")
  valid_590207 = validateParameter(valid_590207, JString, required = false,
                                 default = newJString("1"))
  if valid_590207 != nil:
    section.add "$.xgafv", valid_590207
  var valid_590208 = query.getOrDefault("prettyPrint")
  valid_590208 = validateParameter(valid_590208, JBool, required = false,
                                 default = newJBool(true))
  if valid_590208 != nil:
    section.add "prettyPrint", valid_590208
  var valid_590209 = query.getOrDefault("bearer_token")
  valid_590209 = validateParameter(valid_590209, JString, required = false,
                                 default = nil)
  if valid_590209 != nil:
    section.add "bearer_token", valid_590209
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

proc call*(call_590211: Call_ContainerProjectsLocationsClustersCreate_590193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ## 
  let valid = call_590211.validator(path, query, header, formData, body)
  let scheme = call_590211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590211.url(scheme.get, call_590211.host, call_590211.base,
                         call_590211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590211, url, valid)

proc call*(call_590212: Call_ContainerProjectsLocationsClustersCreate_590193;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersCreate
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project and location) where the cluster will be created.
  ## Specified in the format 'projects/*/locations/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590213 = newJObject()
  var query_590214 = newJObject()
  var body_590215 = newJObject()
  add(query_590214, "upload_protocol", newJString(uploadProtocol))
  add(query_590214, "fields", newJString(fields))
  add(query_590214, "quotaUser", newJString(quotaUser))
  add(query_590214, "alt", newJString(alt))
  add(query_590214, "pp", newJBool(pp))
  add(query_590214, "oauth_token", newJString(oauthToken))
  add(query_590214, "callback", newJString(callback))
  add(query_590214, "access_token", newJString(accessToken))
  add(query_590214, "uploadType", newJString(uploadType))
  add(path_590213, "parent", newJString(parent))
  add(query_590214, "key", newJString(key))
  add(query_590214, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590215 = body
  add(query_590214, "prettyPrint", newJBool(prettyPrint))
  add(query_590214, "bearer_token", newJString(bearerToken))
  result = call_590212.call(path_590213, query_590214, nil, nil, body_590215)

var containerProjectsLocationsClustersCreate* = Call_ContainerProjectsLocationsClustersCreate_590193(
    name: "containerProjectsLocationsClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersCreate_590194,
    base: "/", url: url_ContainerProjectsLocationsClustersCreate_590195,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersList_590170 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersList_590172(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersList_590171(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project and location) where the clusters will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_590173 = path.getOrDefault("parent")
  valid_590173 = validateParameter(valid_590173, JString, required = true,
                                 default = nil)
  if valid_590173 != nil:
    section.add "parent", valid_590173
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590174 = query.getOrDefault("upload_protocol")
  valid_590174 = validateParameter(valid_590174, JString, required = false,
                                 default = nil)
  if valid_590174 != nil:
    section.add "upload_protocol", valid_590174
  var valid_590175 = query.getOrDefault("fields")
  valid_590175 = validateParameter(valid_590175, JString, required = false,
                                 default = nil)
  if valid_590175 != nil:
    section.add "fields", valid_590175
  var valid_590176 = query.getOrDefault("quotaUser")
  valid_590176 = validateParameter(valid_590176, JString, required = false,
                                 default = nil)
  if valid_590176 != nil:
    section.add "quotaUser", valid_590176
  var valid_590177 = query.getOrDefault("alt")
  valid_590177 = validateParameter(valid_590177, JString, required = false,
                                 default = newJString("json"))
  if valid_590177 != nil:
    section.add "alt", valid_590177
  var valid_590178 = query.getOrDefault("pp")
  valid_590178 = validateParameter(valid_590178, JBool, required = false,
                                 default = newJBool(true))
  if valid_590178 != nil:
    section.add "pp", valid_590178
  var valid_590179 = query.getOrDefault("oauth_token")
  valid_590179 = validateParameter(valid_590179, JString, required = false,
                                 default = nil)
  if valid_590179 != nil:
    section.add "oauth_token", valid_590179
  var valid_590180 = query.getOrDefault("callback")
  valid_590180 = validateParameter(valid_590180, JString, required = false,
                                 default = nil)
  if valid_590180 != nil:
    section.add "callback", valid_590180
  var valid_590181 = query.getOrDefault("access_token")
  valid_590181 = validateParameter(valid_590181, JString, required = false,
                                 default = nil)
  if valid_590181 != nil:
    section.add "access_token", valid_590181
  var valid_590182 = query.getOrDefault("uploadType")
  valid_590182 = validateParameter(valid_590182, JString, required = false,
                                 default = nil)
  if valid_590182 != nil:
    section.add "uploadType", valid_590182
  var valid_590183 = query.getOrDefault("zone")
  valid_590183 = validateParameter(valid_590183, JString, required = false,
                                 default = nil)
  if valid_590183 != nil:
    section.add "zone", valid_590183
  var valid_590184 = query.getOrDefault("key")
  valid_590184 = validateParameter(valid_590184, JString, required = false,
                                 default = nil)
  if valid_590184 != nil:
    section.add "key", valid_590184
  var valid_590185 = query.getOrDefault("$.xgafv")
  valid_590185 = validateParameter(valid_590185, JString, required = false,
                                 default = newJString("1"))
  if valid_590185 != nil:
    section.add "$.xgafv", valid_590185
  var valid_590186 = query.getOrDefault("projectId")
  valid_590186 = validateParameter(valid_590186, JString, required = false,
                                 default = nil)
  if valid_590186 != nil:
    section.add "projectId", valid_590186
  var valid_590187 = query.getOrDefault("prettyPrint")
  valid_590187 = validateParameter(valid_590187, JBool, required = false,
                                 default = newJBool(true))
  if valid_590187 != nil:
    section.add "prettyPrint", valid_590187
  var valid_590188 = query.getOrDefault("bearer_token")
  valid_590188 = validateParameter(valid_590188, JString, required = false,
                                 default = nil)
  if valid_590188 != nil:
    section.add "bearer_token", valid_590188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590189: Call_ContainerProjectsLocationsClustersList_590170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_590189.validator(path, query, header, formData, body)
  let scheme = call_590189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590189.url(scheme.get, call_590189.host, call_590189.base,
                         call_590189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590189, url, valid)

proc call*(call_590190: Call_ContainerProjectsLocationsClustersList_590170;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersList
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project and location) where the clusters will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590191 = newJObject()
  var query_590192 = newJObject()
  add(query_590192, "upload_protocol", newJString(uploadProtocol))
  add(query_590192, "fields", newJString(fields))
  add(query_590192, "quotaUser", newJString(quotaUser))
  add(query_590192, "alt", newJString(alt))
  add(query_590192, "pp", newJBool(pp))
  add(query_590192, "oauth_token", newJString(oauthToken))
  add(query_590192, "callback", newJString(callback))
  add(query_590192, "access_token", newJString(accessToken))
  add(query_590192, "uploadType", newJString(uploadType))
  add(path_590191, "parent", newJString(parent))
  add(query_590192, "zone", newJString(zone))
  add(query_590192, "key", newJString(key))
  add(query_590192, "$.xgafv", newJString(Xgafv))
  add(query_590192, "projectId", newJString(projectId))
  add(query_590192, "prettyPrint", newJBool(prettyPrint))
  add(query_590192, "bearer_token", newJString(bearerToken))
  result = call_590190.call(path_590191, query_590192, nil, nil, nil)

var containerProjectsLocationsClustersList* = Call_ContainerProjectsLocationsClustersList_590170(
    name: "containerProjectsLocationsClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersList_590171, base: "/",
    url: url_ContainerProjectsLocationsClustersList_590172,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsCreate_590240 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsCreate_590242(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsCreate_590241(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a node pool for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project, location, cluster id) where the node pool will be created.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_590243 = path.getOrDefault("parent")
  valid_590243 = validateParameter(valid_590243, JString, required = true,
                                 default = nil)
  if valid_590243 != nil:
    section.add "parent", valid_590243
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590244 = query.getOrDefault("upload_protocol")
  valid_590244 = validateParameter(valid_590244, JString, required = false,
                                 default = nil)
  if valid_590244 != nil:
    section.add "upload_protocol", valid_590244
  var valid_590245 = query.getOrDefault("fields")
  valid_590245 = validateParameter(valid_590245, JString, required = false,
                                 default = nil)
  if valid_590245 != nil:
    section.add "fields", valid_590245
  var valid_590246 = query.getOrDefault("quotaUser")
  valid_590246 = validateParameter(valid_590246, JString, required = false,
                                 default = nil)
  if valid_590246 != nil:
    section.add "quotaUser", valid_590246
  var valid_590247 = query.getOrDefault("alt")
  valid_590247 = validateParameter(valid_590247, JString, required = false,
                                 default = newJString("json"))
  if valid_590247 != nil:
    section.add "alt", valid_590247
  var valid_590248 = query.getOrDefault("pp")
  valid_590248 = validateParameter(valid_590248, JBool, required = false,
                                 default = newJBool(true))
  if valid_590248 != nil:
    section.add "pp", valid_590248
  var valid_590249 = query.getOrDefault("oauth_token")
  valid_590249 = validateParameter(valid_590249, JString, required = false,
                                 default = nil)
  if valid_590249 != nil:
    section.add "oauth_token", valid_590249
  var valid_590250 = query.getOrDefault("callback")
  valid_590250 = validateParameter(valid_590250, JString, required = false,
                                 default = nil)
  if valid_590250 != nil:
    section.add "callback", valid_590250
  var valid_590251 = query.getOrDefault("access_token")
  valid_590251 = validateParameter(valid_590251, JString, required = false,
                                 default = nil)
  if valid_590251 != nil:
    section.add "access_token", valid_590251
  var valid_590252 = query.getOrDefault("uploadType")
  valid_590252 = validateParameter(valid_590252, JString, required = false,
                                 default = nil)
  if valid_590252 != nil:
    section.add "uploadType", valid_590252
  var valid_590253 = query.getOrDefault("key")
  valid_590253 = validateParameter(valid_590253, JString, required = false,
                                 default = nil)
  if valid_590253 != nil:
    section.add "key", valid_590253
  var valid_590254 = query.getOrDefault("$.xgafv")
  valid_590254 = validateParameter(valid_590254, JString, required = false,
                                 default = newJString("1"))
  if valid_590254 != nil:
    section.add "$.xgafv", valid_590254
  var valid_590255 = query.getOrDefault("prettyPrint")
  valid_590255 = validateParameter(valid_590255, JBool, required = false,
                                 default = newJBool(true))
  if valid_590255 != nil:
    section.add "prettyPrint", valid_590255
  var valid_590256 = query.getOrDefault("bearer_token")
  valid_590256 = validateParameter(valid_590256, JString, required = false,
                                 default = nil)
  if valid_590256 != nil:
    section.add "bearer_token", valid_590256
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

proc call*(call_590258: Call_ContainerProjectsLocationsClustersNodePoolsCreate_590240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_590258.validator(path, query, header, formData, body)
  let scheme = call_590258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590258.url(scheme.get, call_590258.host, call_590258.base,
                         call_590258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590258, url, valid)

proc call*(call_590259: Call_ContainerProjectsLocationsClustersNodePoolsCreate_590240;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsCreate
  ## Creates a node pool for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project, location, cluster id) where the node pool will be created.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590260 = newJObject()
  var query_590261 = newJObject()
  var body_590262 = newJObject()
  add(query_590261, "upload_protocol", newJString(uploadProtocol))
  add(query_590261, "fields", newJString(fields))
  add(query_590261, "quotaUser", newJString(quotaUser))
  add(query_590261, "alt", newJString(alt))
  add(query_590261, "pp", newJBool(pp))
  add(query_590261, "oauth_token", newJString(oauthToken))
  add(query_590261, "callback", newJString(callback))
  add(query_590261, "access_token", newJString(accessToken))
  add(query_590261, "uploadType", newJString(uploadType))
  add(path_590260, "parent", newJString(parent))
  add(query_590261, "key", newJString(key))
  add(query_590261, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590262 = body
  add(query_590261, "prettyPrint", newJBool(prettyPrint))
  add(query_590261, "bearer_token", newJString(bearerToken))
  result = call_590259.call(path_590260, query_590261, nil, nil, body_590262)

var containerProjectsLocationsClustersNodePoolsCreate* = Call_ContainerProjectsLocationsClustersNodePoolsCreate_590240(
    name: "containerProjectsLocationsClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsCreate_590241,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsCreate_590242,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsList_590216 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsList_590218(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsList_590217(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the node pools for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project, location, cluster id) where the node pools will be listed.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_590219 = path.getOrDefault("parent")
  valid_590219 = validateParameter(valid_590219, JString, required = true,
                                 default = nil)
  if valid_590219 != nil:
    section.add "parent", valid_590219
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590220 = query.getOrDefault("upload_protocol")
  valid_590220 = validateParameter(valid_590220, JString, required = false,
                                 default = nil)
  if valid_590220 != nil:
    section.add "upload_protocol", valid_590220
  var valid_590221 = query.getOrDefault("fields")
  valid_590221 = validateParameter(valid_590221, JString, required = false,
                                 default = nil)
  if valid_590221 != nil:
    section.add "fields", valid_590221
  var valid_590222 = query.getOrDefault("quotaUser")
  valid_590222 = validateParameter(valid_590222, JString, required = false,
                                 default = nil)
  if valid_590222 != nil:
    section.add "quotaUser", valid_590222
  var valid_590223 = query.getOrDefault("alt")
  valid_590223 = validateParameter(valid_590223, JString, required = false,
                                 default = newJString("json"))
  if valid_590223 != nil:
    section.add "alt", valid_590223
  var valid_590224 = query.getOrDefault("pp")
  valid_590224 = validateParameter(valid_590224, JBool, required = false,
                                 default = newJBool(true))
  if valid_590224 != nil:
    section.add "pp", valid_590224
  var valid_590225 = query.getOrDefault("oauth_token")
  valid_590225 = validateParameter(valid_590225, JString, required = false,
                                 default = nil)
  if valid_590225 != nil:
    section.add "oauth_token", valid_590225
  var valid_590226 = query.getOrDefault("callback")
  valid_590226 = validateParameter(valid_590226, JString, required = false,
                                 default = nil)
  if valid_590226 != nil:
    section.add "callback", valid_590226
  var valid_590227 = query.getOrDefault("access_token")
  valid_590227 = validateParameter(valid_590227, JString, required = false,
                                 default = nil)
  if valid_590227 != nil:
    section.add "access_token", valid_590227
  var valid_590228 = query.getOrDefault("uploadType")
  valid_590228 = validateParameter(valid_590228, JString, required = false,
                                 default = nil)
  if valid_590228 != nil:
    section.add "uploadType", valid_590228
  var valid_590229 = query.getOrDefault("zone")
  valid_590229 = validateParameter(valid_590229, JString, required = false,
                                 default = nil)
  if valid_590229 != nil:
    section.add "zone", valid_590229
  var valid_590230 = query.getOrDefault("key")
  valid_590230 = validateParameter(valid_590230, JString, required = false,
                                 default = nil)
  if valid_590230 != nil:
    section.add "key", valid_590230
  var valid_590231 = query.getOrDefault("$.xgafv")
  valid_590231 = validateParameter(valid_590231, JString, required = false,
                                 default = newJString("1"))
  if valid_590231 != nil:
    section.add "$.xgafv", valid_590231
  var valid_590232 = query.getOrDefault("projectId")
  valid_590232 = validateParameter(valid_590232, JString, required = false,
                                 default = nil)
  if valid_590232 != nil:
    section.add "projectId", valid_590232
  var valid_590233 = query.getOrDefault("prettyPrint")
  valid_590233 = validateParameter(valid_590233, JBool, required = false,
                                 default = newJBool(true))
  if valid_590233 != nil:
    section.add "prettyPrint", valid_590233
  var valid_590234 = query.getOrDefault("clusterId")
  valid_590234 = validateParameter(valid_590234, JString, required = false,
                                 default = nil)
  if valid_590234 != nil:
    section.add "clusterId", valid_590234
  var valid_590235 = query.getOrDefault("bearer_token")
  valid_590235 = validateParameter(valid_590235, JString, required = false,
                                 default = nil)
  if valid_590235 != nil:
    section.add "bearer_token", valid_590235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590236: Call_ContainerProjectsLocationsClustersNodePoolsList_590216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_590236.validator(path, query, header, formData, body)
  let scheme = call_590236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590236.url(scheme.get, call_590236.host, call_590236.base,
                         call_590236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590236, url, valid)

proc call*(call_590237: Call_ContainerProjectsLocationsClustersNodePoolsList_590216;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; clusterId: string = "";
          bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsList
  ## Lists the node pools for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project, location, cluster id) where the node pools will be listed.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590238 = newJObject()
  var query_590239 = newJObject()
  add(query_590239, "upload_protocol", newJString(uploadProtocol))
  add(query_590239, "fields", newJString(fields))
  add(query_590239, "quotaUser", newJString(quotaUser))
  add(query_590239, "alt", newJString(alt))
  add(query_590239, "pp", newJBool(pp))
  add(query_590239, "oauth_token", newJString(oauthToken))
  add(query_590239, "callback", newJString(callback))
  add(query_590239, "access_token", newJString(accessToken))
  add(query_590239, "uploadType", newJString(uploadType))
  add(path_590238, "parent", newJString(parent))
  add(query_590239, "zone", newJString(zone))
  add(query_590239, "key", newJString(key))
  add(query_590239, "$.xgafv", newJString(Xgafv))
  add(query_590239, "projectId", newJString(projectId))
  add(query_590239, "prettyPrint", newJBool(prettyPrint))
  add(query_590239, "clusterId", newJString(clusterId))
  add(query_590239, "bearer_token", newJString(bearerToken))
  result = call_590237.call(path_590238, query_590239, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsList* = Call_ContainerProjectsLocationsClustersNodePoolsList_590216(
    name: "containerProjectsLocationsClustersNodePoolsList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1beta1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsList_590217,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsList_590218,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsList_590263 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsOperationsList_590265(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsOperationsList_590264(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project and location) where the operations will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_590266 = path.getOrDefault("parent")
  valid_590266 = validateParameter(valid_590266, JString, required = true,
                                 default = nil)
  if valid_590266 != nil:
    section.add "parent", valid_590266
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_590267 = query.getOrDefault("upload_protocol")
  valid_590267 = validateParameter(valid_590267, JString, required = false,
                                 default = nil)
  if valid_590267 != nil:
    section.add "upload_protocol", valid_590267
  var valid_590268 = query.getOrDefault("fields")
  valid_590268 = validateParameter(valid_590268, JString, required = false,
                                 default = nil)
  if valid_590268 != nil:
    section.add "fields", valid_590268
  var valid_590269 = query.getOrDefault("quotaUser")
  valid_590269 = validateParameter(valid_590269, JString, required = false,
                                 default = nil)
  if valid_590269 != nil:
    section.add "quotaUser", valid_590269
  var valid_590270 = query.getOrDefault("alt")
  valid_590270 = validateParameter(valid_590270, JString, required = false,
                                 default = newJString("json"))
  if valid_590270 != nil:
    section.add "alt", valid_590270
  var valid_590271 = query.getOrDefault("pp")
  valid_590271 = validateParameter(valid_590271, JBool, required = false,
                                 default = newJBool(true))
  if valid_590271 != nil:
    section.add "pp", valid_590271
  var valid_590272 = query.getOrDefault("oauth_token")
  valid_590272 = validateParameter(valid_590272, JString, required = false,
                                 default = nil)
  if valid_590272 != nil:
    section.add "oauth_token", valid_590272
  var valid_590273 = query.getOrDefault("callback")
  valid_590273 = validateParameter(valid_590273, JString, required = false,
                                 default = nil)
  if valid_590273 != nil:
    section.add "callback", valid_590273
  var valid_590274 = query.getOrDefault("access_token")
  valid_590274 = validateParameter(valid_590274, JString, required = false,
                                 default = nil)
  if valid_590274 != nil:
    section.add "access_token", valid_590274
  var valid_590275 = query.getOrDefault("uploadType")
  valid_590275 = validateParameter(valid_590275, JString, required = false,
                                 default = nil)
  if valid_590275 != nil:
    section.add "uploadType", valid_590275
  var valid_590276 = query.getOrDefault("zone")
  valid_590276 = validateParameter(valid_590276, JString, required = false,
                                 default = nil)
  if valid_590276 != nil:
    section.add "zone", valid_590276
  var valid_590277 = query.getOrDefault("key")
  valid_590277 = validateParameter(valid_590277, JString, required = false,
                                 default = nil)
  if valid_590277 != nil:
    section.add "key", valid_590277
  var valid_590278 = query.getOrDefault("$.xgafv")
  valid_590278 = validateParameter(valid_590278, JString, required = false,
                                 default = newJString("1"))
  if valid_590278 != nil:
    section.add "$.xgafv", valid_590278
  var valid_590279 = query.getOrDefault("projectId")
  valid_590279 = validateParameter(valid_590279, JString, required = false,
                                 default = nil)
  if valid_590279 != nil:
    section.add "projectId", valid_590279
  var valid_590280 = query.getOrDefault("prettyPrint")
  valid_590280 = validateParameter(valid_590280, JBool, required = false,
                                 default = newJBool(true))
  if valid_590280 != nil:
    section.add "prettyPrint", valid_590280
  var valid_590281 = query.getOrDefault("bearer_token")
  valid_590281 = validateParameter(valid_590281, JString, required = false,
                                 default = nil)
  if valid_590281 != nil:
    section.add "bearer_token", valid_590281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590282: Call_ContainerProjectsLocationsOperationsList_590263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_590282.validator(path, query, header, formData, body)
  let scheme = call_590282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590282.url(scheme.get, call_590282.host, call_590282.base,
                         call_590282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590282, url, valid)

proc call*(call_590283: Call_ContainerProjectsLocationsOperationsList_590263;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsOperationsList
  ## Lists all operations in a project in a specific zone or all zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project and location) where the operations will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   zone: string
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_590284 = newJObject()
  var query_590285 = newJObject()
  add(query_590285, "upload_protocol", newJString(uploadProtocol))
  add(query_590285, "fields", newJString(fields))
  add(query_590285, "quotaUser", newJString(quotaUser))
  add(query_590285, "alt", newJString(alt))
  add(query_590285, "pp", newJBool(pp))
  add(query_590285, "oauth_token", newJString(oauthToken))
  add(query_590285, "callback", newJString(callback))
  add(query_590285, "access_token", newJString(accessToken))
  add(query_590285, "uploadType", newJString(uploadType))
  add(path_590284, "parent", newJString(parent))
  add(query_590285, "zone", newJString(zone))
  add(query_590285, "key", newJString(key))
  add(query_590285, "$.xgafv", newJString(Xgafv))
  add(query_590285, "projectId", newJString(projectId))
  add(query_590285, "prettyPrint", newJBool(prettyPrint))
  add(query_590285, "bearer_token", newJString(bearerToken))
  result = call_590283.call(path_590284, query_590285, nil, nil, nil)

var containerProjectsLocationsOperationsList* = Call_ContainerProjectsLocationsOperationsList_590263(
    name: "containerProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/operations",
    validator: validate_ContainerProjectsLocationsOperationsList_590264,
    base: "/", url: url_ContainerProjectsLocationsOperationsList_590265,
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
